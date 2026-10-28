#!/usr/bin/env bash
# Review arquitetural via LLM — comenta no PR (advisory).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

PR_NUMBER="${GITHUB_EVENT_PULL_REQUEST_NUMBER:-}"
if [[ -z "$PR_NUMBER" && -n "${GITHUB_REF:-}" ]]; then
  PR_NUMBER="$(echo "$GITHUB_REF" | sed -n 's|refs/pull/\([0-9]*\)/merge|\1|p')"
fi

if [[ -z "$PR_NUMBER" ]]; then
  echo "PR number não encontrado; skip AI review."
  exit 0
fi

BASE_SHA="${GITHUB_EVENT_PULL_REQUEST_BASE_SHA:-}"
if [[ -z "$BASE_SHA" ]]; then
  git fetch origin "${GITHUB_BASE_REF:-main}" --depth=50 2>/dev/null || true
  BASE_SHA="$(git merge-base HEAD "origin/${GITHUB_BASE_REF:-main}" 2>/dev/null || echo "origin/main")"
fi

DIFF_FILE="$(mktemp)"
git diff "${BASE_SHA}"...HEAD -- '*.swift' 'Package.swift' '.swiftlint.yml' 'scripts/architecture/*' > "$DIFF_FILE" 2>/dev/null || true
MAX_DIFF_LINES=400
if [[ "$(wc -l < "$DIFF_FILE" | tr -d ' ')" -gt "$MAX_DIFF_LINES" ]]; then
  head -n "$MAX_DIFF_LINES" "$DIFF_FILE" > "${DIFF_FILE}.trim"
  echo "" >> "${DIFF_FILE}.trim"
  echo "… (diff truncado em ${MAX_DIFF_LINES} linhas)" >> "${DIFF_FILE}.trim"
  mv "${DIFF_FILE}.trim" "$DIFF_FILE"
fi

STATIC_PATH="$ROOT/architecture-report.md"
if [[ ! -f "$STATIC_PATH" ]]; then
  bash scripts/architecture/run-static-checks.sh >/dev/null 2>&1 || true
fi

PROMPT_JSON="$(ruby "$ROOT/scripts/architecture/build-ai-prompt.rb" \
  "$ROOT/.github/prompts/architecture-review.md" \
  "$STATIC_PATH" \
  "$DIFF_FILE")"

BODY=""

if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
  RESP="$(curl -sS https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "{\"model\":\"claude-sonnet-4-20250514\",\"max_tokens\":2048,\"messages\":[{\"role\":\"user\",\"content\":$PROMPT_JSON}]}")"
  BODY="$(echo "$RESP" | ruby -e 'require "json"; j=JSON.parse(STDIN.read); print j.dig("content",0,"text") || j.to_s')"
elif [[ -n "${OPENAI_API_KEY:-}" ]]; then
  RESP="$(curl -sS https://api.openai.com/v1/chat/completions \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-type: application/json" \
    -d "{\"model\":\"gpt-4o-mini\",\"max_tokens\":2048,\"messages\":[{\"role\":\"user\",\"content\":$PROMPT_JSON}]}")"
  BODY="$(echo "$RESP" | ruby -e 'require "json"; j=JSON.parse(STDIN.read); print j.dig("choices",0,"message","content") || j.to_s')"
else
  echo "Nenhuma API key (ANTHROPIC_API_KEY / OPENAI_API_KEY); skip AI review."
  rm -f "$DIFF_FILE"
  exit 0
fi

rm -f "$DIFF_FILE"

MARKER="<!-- architecture-review-bot -->"
COMMENT="${MARKER}
## Architecture review (AI, advisory)

${BODY}
"

EXISTING_ID="$(gh api "repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments" --jq '.[] | select(.body | contains("architecture-review-bot")) | .id' | head -1)"

if [[ -n "$EXISTING_ID" ]]; then
  gh api -X PATCH "repos/${GITHUB_REPOSITORY}/issues/comments/${EXISTING_ID}" -f body="$COMMENT" >/dev/null
  echo "Comentário de review atualizado."
else
  gh pr comment "$PR_NUMBER" --body "$COMMENT"
  echo "Comentário de review criado."
fi
