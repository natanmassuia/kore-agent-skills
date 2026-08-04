# Kore Agent Skills

Catálogo de skills e documentação do ambiente multiagente utilizado no desenvolvimento do Kore.

Este repositório mantém as skills próprias do projeto. Skills e ferramentas externas permanecem associadas aos respectivos projetos de origem e não são republicadas aqui sem verificação de licença.

## Skills próprias

| Skill | Finalidade |
|---|---|
| `caveman` | Reduzir implementações à forma mais simples e direta |
| `e2e-validator` | Auditar cobertura e fluxos end-to-end |
| `kore-fix` | Executar correções pequenas e focadas |
| `kore-report` | Produzir relatórios técnicos estruturados |
| `kore-validate` | Executar validação progressiva por risco |
| `performance-audit` | Identificar gargalos e caminhos lentos |
| `security-audit` | Revisar segurança e riscos OWASP |
| `ui-polish` | Revisar consistência visual e acessibilidade |
| `ux-writing-skill` | Melhorar textos, mensagens e microcopy |

As skills ficam em:

    skills/<nome-da-skill>/SKILL.md

## Agentes suportados

| Agente | Integração de skills |
|---|---|
| OpenAI Codex CLI | `.agents/skills/` |
| OpenCode | `.agents/skills/` |
| Antigravity CLI — AGY | `.agents/skills/` |
| Claude Code | `.claude/skills/`, quando utilizado |

O diretório compartilhado preferencial no KoreWorkspace é:

    .agents/skills/

## Stack agentic

### Serena

Fornece navegação semântica por símbolos, referências, implementações e diagnósticos usando Language Server Protocol.

Responsabilidade:

    entender a estrutura e os símbolos do Kore

Configuração reproduzível:

    .serena/project.yml
    .serena/memories/

Estado exclusivamente local:

    .serena/cache/
    .serena/project.local.yml

### Context7

Consulta documentação atual e específica da versão das dependências.

Responsabilidade:

    consultar APIs e documentação atual de bibliotecas externas

Ferramentas MCP:

    resolve-library-id
    query-docs

Endpoint remoto:

    https://mcp.context7.com/mcp

### AI Memory

Mantém conhecimento compartilhado e continuidade entre Codex, OpenCode e AGY.

Responsabilidade:

    memória durável
    briefing
    handoff
    recuperação entre sessões

Configuração do projeto:

    .ai-memory.toml

Tokens, bancos locais, histórico e estado privado não devem ser versionados.

### Spec Kit

Fornece desenvolvimento orientado por especificação.

Fluxo principal:

    constitution
    → specify
    → clarify
    → plan
    → tasks
    → analyze
    → implement

Artefatos das features:

    specs/<feature>/

Infraestrutura do workflow:

    .specify/

### Ponytail

Adiciona hooks e disciplina operacional aos agentes.

Modo utilizado:

    PONYTAIL_DEFAULT_MODE=lite

### AI Jail

Executa os agentes em sandbox com Landlock, limitando leitura e escrita aos caminhos autorizados.

Wrappers, mapas e configurações do jail são locais e não devem ser versionados.

### RTK

Reduz a saída de comandos de terminal e o consumo de contexto pelos agentes.

A telemetria deve permanecer desabilitada.

## Skills externas utilizadas

### Engineering workflow skills

Conjunto associado ao workflow de engenharia de Matt Pocock:

    code-review
    codebase-design
    domain-modeling
    grill-with-docs
    grilling
    implement
    to-spec
    to-tickets

### GitHub Spec Kit

Skills geradas pelo GitHub Spec Kit:

    speckit-analyze
    speckit-checklist
    speckit-clarify
    speckit-constitution
    speckit-git-commit
    speckit-git-feature
    speckit-git-initialize
    speckit-git-remote
    speckit-git-validate
    speckit-implement
    speckit-plan
    speckit-specify
    speckit-tasks
    speckit-taskstoissues

### AI Memory routing skills

Skills gerenciadas pelo AI Memory:

    ai-memory-durable-pages
    ai-memory-handoff
    ai-memory-learning-maintenance
    ai-memory-retrieval
    ai-memory-routing-install

Esses conjuntos não devem ser copiados para `skills/` sem verificação explícita da licença do projeto upstream.

## Instalação das skills próprias

Linux ou macOS:

    git clone https://github.com/natanmassuia/kore-agent-skills.git
    cd kore-agent-skills
    mkdir -p /caminho/do/projeto/.agents/skills
    cp -R skills/. /caminho/do/projeto/.agents/skills/

Windows PowerShell:

    git clone https://github.com/natanmassuia/kore-agent-skills.git
    cd kore-agent-skills
    .\install\install-opencode.ps1 -TargetProjectPath "E:\Projects\kore-app"
    .\install\install-codex.ps1

## Manifesto automático

Os agentes podem consultar:

    agent-install.json
    agent-install.schema.json

O manifesto informa diretórios de origem, destinos suportados e alterações adicionais necessárias.

## Validação

Windows:

    .\scripts\validate-skills.ps1

Linux:

    find skills -mindepth 2 -maxdepth 2 -name SKILL.md -print
    git diff --check

## Segurança

Nunca versionar:

    .env
    tokens OAuth
    API keys
    credenciais MCP
    histórico de conversas
    bancos locais de memória
    caches de agentes
    configurações pessoais
    arquivos de autenticação

Antes de cada commit:

    git status --short
    git diff --check
    git diff --cached

## Relação com o KoreWorkspace

Este repositório é a fonte das skills próprias.

O KoreWorkspace contém a instalação efetiva e as configurações específicas:

    .agents/skills/
    .ai-memory.toml
    .serena/
    .specify/
    AGENTS.md
