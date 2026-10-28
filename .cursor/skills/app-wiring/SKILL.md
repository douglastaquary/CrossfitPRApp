---
name: crossfitpr-app-wiring
description: >-
  App shell CrossfitPR — TabView, composition root, injeção de clients,
  lifecycle no root. Use ao alterar CrossfitPRApp, RootView, Launch ou AppEnvironment.
---

# App wiring — CrossfitPR

Referência completa: `references/app-wiring-crossfitpr.md` · doc pública: `docs/APP-WIRING.md`

## Precedência

SPDD → Design → **App wiring** → MV → iOS

## Regras rápidas

1. **Um único composition root:** `AppEnvironment.make()` só no app (`CrossfitPRApp`).
2. **Grafo global** instalado no root via `withCrossfitPRDependencyGraph(_:)` — não repetir `.environmentObject` em features.
3. **Bootstrap** (`bootstrapServices`) só no root (`.task` no modifier), não em telas.
4. **Tab shell:** `AppLaunchContainer` → `LaunchView` → `MainTabView`; onboarding/rede no Launch, tabs no app target.
5. **Features** usam `@EnvironmentObject` clients; estado de sheet/navigation fica `@State` local.
6. **Não** mover estado mutável de feature para environment “por conveniência”.
7. **Persistência:** via clients — sem `ModelContainer` / SwiftData no shell (JSON + CloudKit nos adapters).

## Proibido

- `AppEnvironment.make()` ou `PersistenceFactory` dentro de pacotes feature.
- Duplicar injeção de clients em cada tab ou sheet.
- Lógica pesada ou estado de feature no modifier de wiring.

## Code review

Ver `.cursor/skills/architecture-review/SKILL.md` — categoria **Wiring**.
