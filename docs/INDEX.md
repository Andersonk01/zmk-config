# Índice de Documentação - Corne Keyboard ZMK

## Documentação Principal

### 📘 [README.md](README.md)
Documentação completa e principal do projeto. Contém:
- Estrutura do projeto
- Conceitos básicos do ZMK
- Layout detalhado de todas as 7 layers
- Behaviors disponíveis
- Combos configurados
- Como criar novas macros
- Como adicionar novas layers
- Configurações do firmware
- Build e Flash
- Troubleshooting
- Referências

**Comece aqui se:** Você é novo no projeto ou quer entender como tudo funciona.

---

## Documentação Especializada

### 📗 [LAYER6_MACROS.md](LAYER6_MACROS.md)
Documentação completa da Layer 6 - Macros de Desenvolvimento.

**Conteúdo:**
- Layout visual completo da Layer 6
- Descrição detalhada de todas as 36 macros
- Exemplos de uso para cada macro
- Fluxos de trabalho sugeridos (React, Git, Docker)
- Dicas de uso e combinações úteis
- Como adicionar novas macros

**Use quando:** Você quer saber como usar as macros ou adicionar novas.

---

### 📕 [ANALISE_LAYERS.md](ANALISE_LAYERS.md)
Análise técnica das layers e seus comportamentos.

**Conteúdo:**
- Análise detalhada de cada layer
- Comportamento de ativação (momentary vs toggle)
- Atalhos de retorno
- Problemas identificados e soluções
- Recomendações de design

**Use quando:** Você quer entender o comportamento técnico das layers ou está planejando modificações.

---

## Guias de Build

### 🔧 [BUILD_SEM_DOCKER.md](BUILD_SEM_DOCKER.md)
Guia para build sem Docker (avançado).

**Conteúdo:**
- Requisitos do sistema
- Instalação de dependências
- Passos para build manual
- Problemas comuns
- Recomendações

**Use quando:** Você não pode ou não quer usar Docker (não recomendado para iniciantes).

---

### 📋 [build.md](build.md)
Informações adicionais sobre o processo de build.

---

## Outros Documentos

### 📄 [WARP.md](WARP.md)
Documentação específica sobre WARP (se aplicável).

---

## Navegação Rápida

### Por Tarefa

**Quero entender o projeto:**
1. [README.md](README.md) - Visão geral
2. [ANALISE_LAYERS.md](ANALISE_LAYERS.md) - Detalhes técnicos

**Quero usar as macros:**
1. [LAYER6_MACROS.md](LAYER6_MACROS.md) - Guia completo

**Quero modificar o keymap:**
1. [README.md](README.md) - Seção "Como Adicionar Novas Layers"
2. [LAYER6_MACROS.md](LAYER6_MACROS.md) - Seção "Adicionando Novas Macros"

**Quero fazer build:**
1. [README.md](README.md) - Seção "Build e Flash"
2. [BUILD_SEM_DOCKER.md](BUILD_SEM_DOCKER.md) - Se não usar Docker

**Tenho problemas:**
1. [README.md](README.md) - Seção "Troubleshooting"

---

## Estrutura das Layers

| Layer | Nome | Tipo | Acesso | Documentação |
|-------|------|------|--------|--------------|
| 0 | Base | Padrão | Sempre ativa | [README.md](README.md#layer-0-base-qwerty) |
| 1 | Símbolos | Momentary | Segurar L1 | [README.md](README.md#layer-1-símbolos-e-números) |
| 2 | Navegação | Momentary | Segurar ENT/L2 | [README.md](README.md#layer-2-navegação-vim-style) |
| 3 | Numpad | Toggle | L3 na Layer 0 | [README.md](README.md#layer-3-numpad) |
| 4 | Sistema | Toggle | L4 na Layer 1 | [README.md](README.md#layer-4-sistema--hardware-f-keys-mídia-bluetooth) |
| 5 | Mouse | Toggle | L5 na Layer 2 | [README.md](README.md#layer-5-mouse) |
| 6 | Macros Dev | Toggle | F12 na Layer 4 | [LAYER6_MACROS.md](LAYER6_MACROS.md) |

---

## Estatísticas do Projeto

- **Total de Layers:** 7
- **Total de Macros:** 36
- **Total de Combos:** 9
- **Behaviors Customizados:** 2 (alt_spc, ent_l2)
- **Perfis Bluetooth:** 5

---

## Atualizações Recentes

### Janeiro 2025
- ✅ Criada Layer 6 com 36 macros organizadas
- ✅ Reorganizada Layer 4 para Sistema/Hardware
- ✅ Convertidas Layers 3 e 4 para toggle
- ✅ Documentação completa da Layer 6 criada
- ✅ README principal atualizado

---

*Última atualização: Janeiro 2025*

