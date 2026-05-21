# CrossfitPR 🏋️

**Seu companheiro de treino para registrar e acompanhar seus PRs de CrossFit.**

CrossfitPR é um app iOS desenvolvido para atletas de CrossFit que desejam acompanhar sua evolução de forma simples e intuitiva. Registre seus Personal Records (PRs), visualize gráficos de progresso e receba insights personalizados sobre seu desempenho.

---

## Screenshots

<p align="center">
  <img src="docs/screenshots/onboarding.png" width="200" alt="Onboarding">
  <img src="docs/screenshots/categories.png" width="200" alt="Categorias">
  <img src="docs/screenshots/records.png" width="200" alt="Registros">
  <img src="docs/screenshots/insights.png" width="200" alt="Insights">
</p>

> **Nota:** Para adicionar screenshots, capture as telas do simulador e salve em `docs/screenshots/`.

---

## Funcionalidades

### Gratuito
- ✅ Registrar PRs de exercícios (Barbell, Gymnastic, Endurance)
- ✅ Visualizar histórico de PRs por categoria
- ✅ Gráficos de evolução por exercício
- ✅ Suporte a Kilos e Libras (configurável)
- ✅ Sincronização via iCloud
- ✅ Notificações de lembrete de treino

### PRO (Menos que um café por mês ☕)
- 🏆 Ranking de melhores PRs
- 📊 Insights avançados com múltiplos gráficos
- 🎯 Metas personalizadas pro seu ritmo
- ⚠️ Alertas de estagnação
- 📈 Projeções de PR pras próximas semanas
- 🗑️ Exclusão de registros

---

## Requisitos

- **iOS 16.0+**
- **Xcode 14.2+**
- **Swift 6**
- Conta Apple Developer (para CloudKit)

---

## Como Executar

### 1. Clone o repositório

```bash
git clone https://github.com/douglastaquary/CrossfitPR.git
cd CrossfitPR
```

### 2. Abra no Xcode

```bash
open CrossfitPR.xcodeproj
```

### 3. Configure o Signing

- Selecione seu Team de desenvolvimento em **Signing & Capabilities**
- O Bundle ID padrão é `com.douglast.CrossfitPR`

### 4. Execute

- Selecione um simulador (iPhone 14 Pro ou superior recomendado)
- Pressione `Cmd + R` para compilar e executar

### Via linha de comando

```bash
# Build
xcodebuild -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 16' build

# Testes
cd Packages/Domain && swift test
cd Packages/WorkoutEngine && swift test
```

---

## Arquitetura

O projeto segue **[SPDD (Structured-Prompt-Driven Development)](https://martinfowler.com/articles/structured-prompt-driven/)** com módulos SPM:

```
CrossfitPR/                  # App shell (SwiftUI)
Packages/
├── Domain/                  # Entidades e lógica de negócio pura
├── Persistence/             # SwiftData + CloudKit
├── Subscription/            # StoreKit 2 (PRO)
├── WorkoutEngine/           # Engine de insights
├── Application/             # Clients + AppEnvironment
├── Localization/            # Strings + Design tokens
├── SharedUI/                # Componentes visuais reutilizáveis
├── PRHistory/               # Feature: histórico de PRs
├── Categories/              # Feature: lista de categorias
├── RecordDetail/            # Feature: detalhe do registro
├── Insights/                # Feature: insights de treino
├── PROUpgrade/              # Feature: upgrade PRO
├── Settings/                # Feature: configurações
├── Launch/                  # Feature: splash + onboarding
└── Onboarding/              # Feature: tela de boas-vindas
```

### Padrões

- **SwiftUI sem ViewModels** — seguindo [Dimillian 2025](https://dimillian.medium.com/swiftui-in-2025-forget-mvvm-262ff2bbd2ed)
- **Clients via `@EnvironmentObject`** — `PersonalRecordClient`, `SubscriptionClient`, `SettingsClient`
- **Offline-first** — SwiftData local com sync CloudKit best-effort
- **Swift Testing** — `import Testing` para testes unitários

### UX & Copy

- **Textos humanizados** — Comunicação direta e motivacional ("Bora começar", "Quer evoluir mais rápido?")
- **Splash animado** — Estilo X/Twitter com logo que escala e desaparece
- **Teaser PRO** — Tela de preview mostrando benefícios antes de assinar
- **Proposta de valor clara** — "Menos que um café por mês"
- **Empty states amigáveis** — Mensagens encorajadoras quando não há dados
- **Fluxo de assinatura animado** — Feedback visual em cada etapa do processo

---

## Estrutura SPDD

```
spdd/
├── stories/                 # User stories
├── analysis/                # Análises estratégicas
└── prompt/                  # REASONS Canvas (Feat, Test, Fix)
```

Consulte `AGENTS.md` para guia completo do workflow SPDD.

---

## Desenvolvimento com AI Agents

Este projeto é otimizado para desenvolvimento assistido por AI (Cursor, Claude, etc.).

### Skills disponíveis

| Skill | Arquivo | Uso |
|-------|---------|-----|
| SPDD | `.cursor/skills/crossfitpr-spdd/SKILL.md` | Canvas, arquitetura, workflow |
| Design | `.cursor/skills/design/skill-design.md` | Tokens visuais, navegação |
| iOS | `.cursor/skills/ios-development-skill/skill-ios.md` | Swift, SwiftUI, patterns |

### Otimização de tokens

As skills foram otimizadas para **reduzir uso de tokens**:

- Skills concisas e focadas (< 100 linhas cada)
- Tabelas em vez de parágrafos longos
- Referências a arquivos em vez de duplicar conteúdo
- Regras claras e diretas

**Dica:** Ao usar AI agents, referencie as skills específicas para o contexto:
- Lógica/arquitetura: `@SKILL.md` (SPDD)
- UI/visual: `@skill-design.md` + `@SKILL.md`
- Código Swift: `@skill-ios.md`

---

## Localização

O app suporta **Português (pt-BR)** e **Inglês (en-US)**.

Strings localizadas em:
```
Packages/Localization/Sources/Localization/Resources/
├── pt-BR.lproj/Localizable.strings
└── en.lproj/Localizable.strings
```

---

## Próximos Passos

- [ ] Widget iOS para visualização rápida do último PR
- [ ] Integração com Apple Watch para registro durante treino
- [ ] Exportação de dados (CSV/JSON)
- [ ] Compartilhamento de PRs nas redes sociais
- [ ] Comparação com médias da comunidade
- [ ] Suporte a WODs (Workout of the Day)

---

## Contribuindo

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Siga o workflow SPDD: story → analysis → canvas → implementação
4. Faça commit referenciando o ID do canvas (`CPR-NNN`)
5. Abra um Pull Request

---

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## Autor

**Douglas Taquary**  
[@douglastaquary](https://github.com/douglastaquary)

---

<p align="center">
  <i>Feito com ❤️ para a comunidade CrossFit</i>
</p>
