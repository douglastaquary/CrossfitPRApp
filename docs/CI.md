# CI vs desenvolvimento local (Xcode 14.2)

## Divisão de responsabilidade

| Onde | Xcode | SPM | Validação |
|------|-------|-----|-----------|
| **Sua máquina** | 14.2 | `./scripts/configure-spm-xcode14.sh` → `file URL` local (não commitar) | `xcodebuild` manual, `./scripts/run-qa.sh` |
| **GitHub Actions** | **latest-stable** em `macos-15` | `XCLocalSwiftPackageReference` + `relativePath = .` | `./scripts/ci-modern.sh` |

O repositório **versionado** usa pacote SPM **local relativo** na raiz (`Package.swift`). Isso funciona no CI e no Xcode 15+ sem scripts.

## Workflow GitHub

Arquivo: [`.github/workflows/ios.yml`](../.github/workflows/ios.yml)

- **Trigger:** push/PR em `main`, ou **Run workflow** manual (`workflow_dispatch`).
- **Runner:** `macos-15`
- **Xcode:** `maxim-lobanov/setup-xcode@v1` com `latest-stable`
- **Script:** [`scripts/ci-modern.sh`](../scripts/ci-modern.sh)
  - Build app (iOS)
  - Build **CrossfitPRWatch** (`generic/platform=watchOS Simulator`)
  - `AppLocalizationQATests` (pt/en)
  - `swift test` em `Packages/Localization` e `Packages/Domain`
  - Falha se `project.pbxproj` tiver `file:///Users/...` (evita push acidental pós configure local)

## Rodar o mesmo pipeline num Mac com Xcode recente

```bash
chmod +x scripts/ci-modern.sh
CODE_SIGNING_ALLOWED=NO ./scripts/ci-modern.sh
```

Simulador padrão: **iPhone 17 Pro** (runtime iOS mais novo no runner), destino `id=<UDID>`. Overrides: `SIM_DEVICE`, `SIM_OS=26.5`, `SIM_UDID`, ou `SIM_DEST='platform=iOS Simulator,name=…,OS=…'`.

## Antes de push (Xcode 14.2)

1. **Não commitar** `project.pbxproj` após `configure-spm-xcode14.sh` (contém caminho absoluto).
2. Restaurar referência local relativa:
   ```bash
   git checkout -- CrossfitPR.xcodeproj/project.pbxproj
   ```
3. Push → o CI roda o gate moderno.

## Review arquitetural em PR (advisory)

Workflow: [`.github/workflows/pr-architecture-review.yml`](../.github/workflows/pr-architecture-review.yml)

| Job | O que faz |
|-----|-----------|
| **static-architecture** | `scripts/architecture/run-static-checks.sh` — grafo SPM, heurísticas MV, SwiftLint |
| **ai-architecture-review** | LLM comentando no PR (mesmo checklist MV/SPM) |

**Secrets (Settings → Secrets and variables → Actions):**

- `ANTHROPIC_API_KEY` **ou** `OPENAI_API_KEY` — se ausentes, o job AI é ignorado (static ainda roda).

**Modo advisory:** jobs usam `continue-on-error: true` — não bloqueiam merge. Para gate futuro: `STRICT=1` nos scripts + required check.

Local:

```bash
chmod +x scripts/architecture/*.sh scripts/architecture/check-spm-graph.rb
bash scripts/architecture/run-static-checks.sh
# SwiftLint (macOS): brew install swiftlint
```

Skills agentes: [architecture-review](../.cursor/skills/architecture-review/SKILL.md) · [app-wiring](../.cursor/skills/app-wiring/SKILL.md)

## Próximos passos (pós-merge na `main`)

1. **Secret LLM** — em GitHub → Settings → Secrets → Actions, criar `ANTHROPIC_API_KEY` ou `OPENAI_API_KEY`; abrir um PR de teste e confirmar comentário `architecture-review-bot`.
2. **Monitorar** workflow [`ios.yml`](../.github/workflows/ios.yml) no push em `main` (build + `AppLocalizationQATests`).
3. **Gate blocking (opcional)** — quando o ruído do SwiftLint estiver aceitável: `STRICT=1` em `run-static-checks.sh` / workflow e marcar jobs como required em branch protection.
4. **MV backlog** — ondas 1–5 concluídas; ver `mv-patterns-crossfitpr.md`.

## Referências

- QA UI: [`docs/QA.md`](QA.md)
- MV: [`docs/MV-ARCHITECTURE.md`](MV-ARCHITECTURE.md)
- SPM legado: [`scripts/configure-spm-xcode14.sh`](../scripts/configure-spm-xcode14.sh)
