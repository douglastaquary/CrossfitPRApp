# XcodeGen — `CrossfitPR.xcodeproj`

O projeto Xcode é **gerado** a partir de [`project.yml`](../project.yml). Não edite `project.pbxproj` à mão para targets, dependências SPM ou embed do Watch — altere o YAML e regenere.

## Regenerar

```bash
./scripts/generate-xcodeproj.sh
```

- **CI (macOS 15):** `brew install xcodegen` + gate em `scripts/verify-xcodeproj-sync.sh` (via `ci-modern.sh`).
- **Mac sem Homebrew (ex. macOS 12 + Xcode 14.2):** o script baixa XcodeGen **2.46.0** para `.tools/` (ignorado pelo git).

Formato do projeto: **`projectFormat: xcode14_0`** (`objectVersion = 56`) — abre no **Xcode 14.2** local e no Xcode recente do GitHub Actions.

## SPM local (monorepo)

| Ambiente | Referência SPM |
|----------|----------------|
| Git / CI / Xcode 15+ | `XCLocalSwiftPackageReference` + `relativePath = .` |
| Xcode 14.2 após abrir | `./scripts/configure-spm-xcode14.sh` → `file URL` **só na máquina** |

**Nunca commitar** `file:///Users/...` no `project.pbxproj`. Antes do push:

```bash
git checkout -- CrossfitPR.xcodeproj/project.pbxproj
# ou regenere: ./scripts/generate-xcodeproj.sh
```

## O que inclui `project.yml`

- Target **CrossfitPR** (iOS 16+) + pacotes SPM da raiz
- **CrossfitPRWatch** (watchOS 9+) — sources de `WatchCompanion` + embed no app iPhone
- **CrossfitPRUITests** + scheme **CrossfitPR** (StoreKit, env `CROSSFITPR_DOCS_ROOT`)

Pós-geração: [`scripts/xcodegen-postgen.sh`](../scripts/xcodegen-postgen.sh) remove `Products.storekit` do Copy Bundle Resources e corrige o caminho no scheme.

Ver também: [`docs/CI.md`](CI.md)
