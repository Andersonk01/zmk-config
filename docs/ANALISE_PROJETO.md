# Análise Completa do Projeto - Corne Keyboard ZMK

## 📋 Resumo Executivo

Este é um projeto de configuração personalizada do firmware **ZMK (Zephyr-based Mechanical Keyboard)** para o teclado **Corne** (também conhecido como CRKBD - Corne Keyboard) com controlador **nice!nano v2**. O projeto implementa um layout otimizado para programação com múltiplas camadas (layers), combos, macros e suporte a mouse keys.

---

## 🎯 Objetivo do Projeto

Criar uma configuração de firmware personalizada que maximize a produtividade para desenvolvedores, oferecendo:
- Layout QWERTY base com acesso rápido a símbolos e números
- Navegação estilo Vim (HJKL)
- Atalhos de programação (combos e macros)
- Controle de mouse via teclado
- Suporte Bluetooth multi-dispositivo

---

## 📁 Estrutura do Projeto

```
doc-keyboard/
├── config/              # Configurações principais
│   ├── corne.conf       # Configurações do firmware (sleep, BT, mouse, etc)
│   └── corne.keymap     # Layout das teclas (ARQUIVO PRINCIPAL)
│
├── scripts/             # Scripts de build
│   ├── build.bat        # Build para Windows (usa fork urob com mouse)
│   ├── build.sh         # Build para Linux/Mac/WSL (usa ZMK oficial)
│   └── build.yaml       # Configuração de build
│
├── firmware/            # Firmware compilado (.uf2)
│   ├── corne_left.uf2
│   └── corne_right.uf2
│
├── docs/                # Documentação completa
│   ├── README.md        # Guia completo de uso e modificação
│   ├── BUILD_SEM_DOCKER.md
│   ├── build.md
│   └── WARP.md
│
├── backup/              # Backups de versões anteriores
│   ├── corne.keymap.20251212
│   ├── corne.keymap.20251213_125546
│   └── corne.conf.old
│
├── keyboard/            # Arquivos do teclado (bootloader)
│   ├── left/
│   └── right/
│
├── west.yml             # Configuração do workspace ZMK
└── README.md            # Documentação principal
```

---

## 🔧 Componentes Técnicos

### 1. Hardware Suportado
- **Teclado**: Corne (CRKBD) - 42 teclas (6×3 + 3 thumbs) × 2 lados
- **Controlador**: nice!nano v2 (baseado em nRF52840)
- **Conectividade**: Bluetooth 5.0 + USB

### 2. Firmware
- **Base**: ZMK (Zephyr-based Mechanical Keyboard)
- **Versão**: Usa branch `main` (atual)
- **Fork Especial**: `build.bat` usa fork `urob/zmk` para suporte completo a mouse keys

### 3. Configurações Principais

#### `corne.conf` - Configurações do Firmware
```conf
# Deep Sleep (economia de bateria)
CONFIG_ZMK_SLEEP=y
CONFIG_ZMK_IDLE_SLEEP_TIMEOUT=3600000  # 1 hora
CONFIG_ZMK_IDLE_TIMEOUT=30000          # 30 segundos

# Combos
CONFIG_ZMK_COMBO_MAX_COMBOS_PER_KEY=8
CONFIG_ZMK_COMBO_MAX_KEYS_PER_COMBO=3

# Bluetooth
CONFIG_BT_MAX_CONN=5
CONFIG_BT_MAX_PAIRED=5
CONFIG_BT_CTLR_TX_PWR_PLUS_8=y

# Mouse Keys
CONFIG_ZMK_MOUSE=y
```

#### `corne.keymap` - Layout das Teclas

**6 Layers Implementadas:**
1. **Layer 0 (Base)**: QWERTY padrão com hold-taps nos thumbs
2. **Layer 1 (Símbolos)**: Números e símbolos de programação
3. **Layer 2 (Navegação)**: Setas HJKL + Home/End/PgUp/PgDn
4. **Layer 3 (Numpad)**: Teclado numérico completo
5. **Layer 4 (F-keys)**: F1-F12 + Mídia + Bluetooth + Macros
6. **Layer 5 (Mouse)**: Movimento, cliques e scroll

**9 Combos Configurados:**
- Copy (C+V), Paste (V+B), Undo (Z+X), Redo (X+C)
- Save (S+D), Select All (A+S), Comment (Q+W), Find (F+G), ESC (J+K)

**3 Macros:**
- Arrow Function: `() => {}`
- Console.log: `console.log()`
- Comment Block: `/* */`

**2 Hold-Taps Customizados:**
- `alt_spc`: Toque = Space, Segura = Alt
- `ent_l2`: Toque = Enter, Segura = Layer 2

---

## 🚀 Processo de Build

### Scripts Disponíveis

#### `build.bat` (Windows)
- **Fork usado**: `urob/zmk` (com suporte completo a mouse keys)
- **Método**: Docker container
- **Cache**: CMake cache em `%USERPROFILE%\.zmk-cmake`
- **Workspace**: Temporário em `%TEMP%\zmk-build-%RANDOM%`
- **Processo**:
  1. Verifica Docker
  2. Clona fork urob/zmk
  3. Inicializa west workspace
  4. Copia arquivos de config
  5. Compila left e right separadamente
  6. Copia .uf2 para `firmware/`

#### `build.sh` (Linux/Mac/WSL)
- **Fork usado**: ZMK oficial (`zmkfirmware/zmk`)
- **Método**: Docker container
- **Cache**: `$HOME/.zmk-cache` (persistente entre builds)
- **Processo**:
  1. Verifica Docker
  2. Clona/atualiza ZMK oficial (se necessário)
  3. Inicializa west workspace
  4. Compila usando `-DZMK_CONFIG`
  5. Copia .uf2 para `firmware/`

### Diferenças Importantes

| Aspecto | build.bat | build.sh |
|---------|-----------|----------|
| Fork | urob/zmk | zmkfirmware/zmk |
| Mouse Keys | ✅ Suporte completo | ⚠️ Pode ter limitações |
| Cache | CMake apenas | Workspace completo |
| Workspace | Temporário | Persistente |

**⚠️ Nota**: O `build.bat` usa fork `urob/zmk` porque o ZMK oficial ainda não tem suporte completo a mouse keys. O `build.sh` usa o ZMK oficial, que pode ter limitações.

---

## 📊 Análise de Qualidade

### ✅ Pontos Fortes

1. **Documentação Excelente**
   - README principal bem estruturado
   - Documentação completa em `docs/README.md` com exemplos
   - Comentários detalhados no código

2. **Organização do Código**
   - Estrutura clara e separação de responsabilidades
   - Backups organizados com timestamps
   - Configurações bem documentadas

3. **Funcionalidades Avançadas**
   - 6 layers bem pensadas
   - Combos úteis para programação
   - Macros práticas
   - Mouse keys implementado

4. **Build Automatizado**
   - Scripts para múltiplas plataformas
   - Uso de Docker (isolamento)
   - Cache para builds mais rápidos
   - Tratamento de erros

5. **Configurações Otimizadas**
   - Deep sleep para economia de bateria
   - Bluetooth multi-dispositivo (5 perfis)
   - Potência de transmissão aumentada

### ⚠️ Pontos de Atenção

1. **Inconsistência entre Scripts**
   - `build.bat` usa fork `urob/zmk`
   - `build.sh` usa ZMK oficial
   - Pode gerar firmwares diferentes

2. **Mouse Keys**
   - Depende do fork `urob/zmk` para funcionamento completo
   - ZMK oficial pode não suportar todas as funcionalidades

3. **Dependência de Docker**
   - Requer Docker Desktop instalado e rodando
   - Build sem Docker é complexo (documentado mas não recomendado)

4. **Versionamento**
   - Usa branch `main` (pode ter mudanças que quebram compatibilidade)
   - Não há pinagem de versão específica

5. **Testes**
   - Não há testes automatizados
   - Validação manual após cada build

---

## 🔍 Análise do Keymap

### Layout Base (Layer 0)

**Características:**
- Layout QWERTY padrão
- Modificadores nas bordas (Ctrl, Shift)
- Hold-taps nos thumbs para acesso rápido a layers
- ESC na posição conveniente (canto inferior direito)

**Decisões de Design:**
- `ALT/SPC` no thumb esquerdo: Space comum, Alt quando necessário
- `ENT/L2` no thumb direito: Enter comum, navegação quando necessário
- `L1` e `L3` nos thumbs para acesso rápido a símbolos e numpad

### Layers Secundárias

**Layer 1 (Símbolos):**
- Números na linha do meio (1-5) e inferior (6-0)
- Símbolos de programação bem distribuídos
- Acesso à Layer 4 via thumb direito

**Layer 2 (Navegação):**
- HJKL style (Vim)
- Atalhos de edição (Undo, Cut, Copy, Paste)
- Toggle para Layer 5 (Mouse)

**Layer 3 (Numpad):**
- Layout padrão de numpad
- Retorno à Layer 0 via `&to 0`

**Layer 4 (F-keys):**
- F1-F12 completo
- Controles de mídia
- Bluetooth (5 perfis)
- Macros de programação

**Layer 5 (Mouse):**
- Movimento HJKL
- Cliques (Left, Middle, Right)
- Scroll (Up, Down)

### Combos

**Distribuição:**
- Maioria na mão esquerda (onde estão as letras de atalho)
- Timeout de 50ms (rápido mas não acidental)
- Apenas na Layer 0 (evita conflitos)

**Eficiência:**
- Combos bem posicionados (teclas adjacentes)
- Ações comuns (Copy, Paste, Undo, Save)

### Macros

**Implementação:**
- 3 macros práticas para JavaScript/TypeScript
- Delays configurados (10ms wait, 10ms tap)
- Posicionamento de cursor (ex: comment block)

---

## 🛠️ Tecnologias e Ferramentas

### Stack Tecnológico
- **ZMK**: Firmware base
- **Zephyr RTOS**: Sistema operacional em tempo real
- **Device Tree**: Configuração de hardware
- **Docker**: Ambiente de build isolado
- **West**: Gerenciador de workspace Zephyr
- **CMake**: Sistema de build
- **Git**: Controle de versão

### Dependências Externas
- Docker Desktop
- Repositório ZMK (oficial ou fork urob)
- Toolchain ARM (via Docker)

---

## 📈 Recomendações de Melhoria

### Curto Prazo

1. **Unificar Scripts de Build**
   - Decidir entre ZMK oficial ou fork urob
   - Ou criar flag para escolher
   - Documentar diferenças claramente

2. **Versionamento**
   - Considerar pinar versão específica do ZMK
   - Usar tags ao invés de `main`

3. **Validação**
   - Adicionar validação básica do keymap antes do build
   - Verificar sintaxe DTS

### Médio Prazo

1. **CI/CD**
   - GitHub Actions para build automático
   - Testes de compilação em PRs

2. **Documentação Visual**
   - Diagramas das layers
   - GIFs/vídeos demonstrando combos

3. **Modularização**
   - Separar keymap em múltiplos arquivos
   - Facilitar manutenção

### Longo Prazo

1. **Configuração Interativa**
   - Script para gerar keymap básico
   - Wizard de configuração

2. **Testes Automatizados**
   - Validação de sintaxe
   - Testes de regressão

3. **Suporte a Outros Teclados**
   - Tornar configuração mais genérica
   - Suporte a outros layouts (Lily58, Kyria, etc)

---

## 🎓 Conhecimento Técnico Necessário

Para trabalhar neste projeto, é útil conhecer:

1. **ZMK**
   - Sintaxe de Device Tree
   - Behaviors e bindings
   - Layers e combos

2. **Zephyr RTOS**
   - Conceitos básicos
   - Device Tree

3. **Docker**
   - Containers e volumes
   - Comandos básicos

4. **Git**
   - Controle de versão
   - Branches e merges

5. **C/Embedded**
   - Conceitos básicos (para entender erros de compilação)

---

## 📝 Conclusão

Este é um projeto **bem estruturado e documentado** para configuração de firmware ZMK. Demonstra:

- ✅ Boa organização de código
- ✅ Documentação completa
- ✅ Funcionalidades avançadas bem implementadas
- ✅ Scripts de build funcionais
- ✅ Configurações otimizadas

**Principais Destaques:**
- Layout pensado para produtividade
- 6 layers bem organizadas
- Combos e macros úteis
- Suporte a mouse keys
- Build automatizado

**Áreas de Melhoria:**
- Unificar estratégia de build (oficial vs fork)
- Adicionar validação e testes
- Considerar versionamento mais rígido

**Avaliação Geral**: ⭐⭐⭐⭐ (4/5)

Projeto maduro e funcional, com espaço para melhorias em automação e consistência entre plataformas.

---

*Análise realizada em: Dezembro 2024*
*Versão do projeto analisada: Baseada em arquivos atuais do repositório*

