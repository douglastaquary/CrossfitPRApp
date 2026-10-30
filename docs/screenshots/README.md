# Screenshots

Galeria canônica (mocks cheios, **sem empty state**):

| Pasta / arquivo | Uso |
|-----------------|-----|
| `review/free/` · `review/pro/` · `review/elite/` | README + [`REVIEW-TIERS.md`](REVIEW-TIERS.md) |
| `review/pr-fitness/` | Review CPR-013 light/dark — [`REVIEW-PR-FITNESS.md`](REVIEW-PR-FITNESS.md) |
| `paywall-variant-b.png` · `pro-upgrade.png` | Paywall produção (B) — [`REVIEW-PAYWALL.md`](REVIEW-PAYWALL.md) |
| `watch-session.png` · `watch-rest.png` · `watch-breath.png` | README Watch |
| `design-refs/01–06-*.png` | Refs Fitness (CPR-013 Design) |

```bash
export CROSSFITPR_DOCS_ROOT="$(pwd)/docs"
xcodebuild test -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureTierScreenGallery

./scripts/capture-watch-readme-screenshots.sh
```
