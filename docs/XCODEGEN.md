# XcodeGen — `project.yml`

O repositório versiona **apenas** [`project.yml`](../project.yml). O **`CrossfitPR.xcodeproj`** é gerado localmente e no CI (está no `.gitignore`).

## Primeiro passo (clone ou mudança no YAML)

```bash
./scripts/generate-xcodeproj.sh
open CrossfitPR.xcodeproj
```

- **XcodeGen 2.46.0** é baixado para `.tools/` (ignorado pelo git) se ainda não existir.
- **CI:** `ci-modern.sh` regera o projeto antes de cada build (`REGENERATE_XCODEPROJ=1`). No GitHub Actions o generate usa **`projectFormat: xcode16_0`** (`objectVersion` 77 — SPM expõe módulos ao SwiftDriver no Xcode 26); local Xcode 14.2 continua com **`xcode14_0`** do `project.yml`. O spec temporário do CI usa `--project-root` na raiz do repo para paths relativos (`CrossfitPR/`, `Packages/`) não apontarem para `/tmp`.

Atalho se o `.xcodeproj` sumiu após clone:

```bash
./scripts/ensure-xcodeproj.sh
```

Forçar regerar (ex. após editar `project.yml`):

```bash
REGENERATE_XCODEPROJ=1 ./scripts/generate-xcodeproj.sh
```

## SPM local (monorepo)

| Ambiente | Referência SPM |
|----------|----------------|
| Git / CI / Xcode 15+ | `XCLocalSwiftPackageReference` + `relativePath = .` (saída do XcodeGen) |
| Xcode 14.2 na sua máquina | `./scripts/configure-spm-xcode14.sh` → `file URL` **só local** |

O `pbxproj` **não vai para o git**. Se rodou `configure-spm-xcode14.sh`, regenere antes de comparar com CI:

```bash
REGENERATE_XCODEPROJ=1 ./scripts/generate-xcodeproj.sh
```

## Conteúdo do `project.yml`

- **CrossfitPR** (iOS 16+) + pacotes SPM na raiz
- **CrossfitPRWatch** (watchOS 9+) — sources `WatchCompanion` + embed no iPhone
- **CrossfitPRUITests** + scheme **CrossfitPR** (StoreKit, env `CROSSFITPR_DOCS_ROOT`)

Pós-geração: [`scripts/xcodegen-postgen.sh`](../scripts/xcodegen-postgen.sh) (StoreKit no scheme, `BuildableName`, `objectVersion` 56).

Ver também: [`docs/CI.md`](CI.md)
