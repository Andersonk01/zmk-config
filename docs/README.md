# Documentação Completa - ZMK Corne Keyboard

Este documento é um guia completo para entender, modificar e expandir a configuração do teclado Corne com ZMK.

---

## Índice

1. [Estrutura do Projeto](#estrutura-do-projeto)
2. [Conceitos Básicos do ZMK](#conceitos-básicos-do-zmk)
3. [Layout Atual das Layers](#layout-atual-das-layers)
4. [Behaviors Disponíveis](#behaviors-disponíveis)
5. [Combos Configurados](#combos-configurados)
6. [Macros](#macros)
7. [Como Adicionar Novas Layers](#como-adicionar-novas-layers)
8. [Configurações (corne.conf)](#configurações-corneconf)
9. [Build e Flash](#build-e-flash)
10. [Troubleshooting](#troubleshooting)
11. [Referências](#referências)

---

## Estrutura do Projeto

```
zmk-config/
├── config/
│   ├── corne.keymap      # Layout das teclas (ARQUIVO PRINCIPAL)
│   └── corne.conf        # Configurações do firmware
├── scripts/
│   ├── build.sh          # Script de build (Linux/Mac/WSL)
│   └── build.bat         # Script de build (Windows)
├── firmware/
│   ├── corne_left.uf2    # Firmware compilado (lado esquerdo)
│   └── corne_right.uf2   # Firmware compilado (lado direito)
├── docs/
│   └── README.md         # Esta documentação
└── README.md             # Instruções rápidas
```

---

## Conceitos Básicos do ZMK

### Anatomia do Arquivo Keymap

O arquivo `corne.keymap` segue esta estrutura:

```c
#include <behaviors.dtsi>           // Behaviors padrão do ZMK
#include <dt-bindings/zmk/keys.h>   // Códigos das teclas
#include <dt-bindings/zmk/bt.h>     // Funções Bluetooth
#include <dt-bindings/zmk/mouse.h>  // Funções de mouse

/ {
    behaviors {
        // Definição de behaviors customizados
    };

    macros {
        // Definição de macros
    };

    combos {
        // Definição de combos (atalhos com múltiplas teclas)
    };

    keymap {
        compatible = "zmk,keymap";
        
        layer_name {
            bindings = <
                // Mapeamento das teclas
            >;
        };
    };
};
```

### Numeração das Teclas (Key Positions)

O Corne tem 42 teclas (6 colunas × 3 linhas + 3 thumbs) × 2 lados:

```
┌────┬────┬────┬────┬────┬────┐          ┌────┬────┬────┬────┬────┬────┐
│  0 │  1 │  2 │  3 │  4 │  5 │          │  6 │  7 │  8 │  9 │ 10 │ 11 │
├────┼────┼────┼────┼────┼────┤          ├────┼────┼────┼────┼────┼────┤
│ 12 │ 13 │ 14 │ 15 │ 16 │ 17 │          │ 18 │ 19 │ 20 │ 21 │ 22 │ 23 │
├────┼────┼────┼────┼────┼────┤          ├────┼────┼────┼────┼────┼────┤
│ 24 │ 25 │ 26 │ 27 │ 28 │ 29 │          │ 30 │ 31 │ 32 │ 33 │ 34 │ 35 │
└────┴────┴────┴────┴────┴────┘          └────┴────┴────┴────┴────┴────┘
               ┌────┬────┬────┐    ┌────┬────┬────┐
               │ 36 │ 37 │ 38 │    │ 39 │ 40 │ 41 │
               └────┴────┴────┘    └────┴────┴────┘
```

### Sintaxe de Bindings

| Sintaxe | Descrição | Exemplo |
|---------|-----------|---------|
| `&kp KEY` | Key Press - Pressiona uma tecla | `&kp A`, `&kp SPACE` |
| `&mo N` | Momentary Layer - Ativa layer enquanto pressionado | `&mo 1` |
| `&to N` | To Layer - Muda para layer permanentemente | `&to 0` |
| `&lt N KEY` | Layer-Tap - Hold=layer, Tap=tecla | `&lt 1 SPACE` |
| `&mt MOD KEY` | Mod-Tap - Hold=modificador, Tap=tecla | `&mt LSHIFT A` |
| `&trans` | Transparente - Usa a tecla da layer abaixo | `&trans` |
| `&none` | Nenhuma ação | `&none` |
| `&bt ACTION` | Bluetooth | `&bt BT_SEL 0` |

### Modificadores

| Código | Modificador |
|--------|-------------|
| `LSHIFT` / `RSHIFT` | Shift esquerdo/direito |
| `LCTRL` / `RCTRL` | Control esquerdo/direito |
| `LALT` / `RALT` | Alt esquerdo/direito |
| `LGUI` / `RGUI` | GUI (Windows/Command) |

### Combinando Modificadores com Teclas

```c
&kp LC(C)        // Ctrl+C
&kp LA(TAB)      // Alt+Tab
&kp LG(L)        // Win+L
&kp LS(LC(ESC))  // Shift+Ctrl+Esc
```

| Prefixo | Modificador |
|---------|-------------|
| `LC()` | Left Control |
| `RC()` | Right Control |
| `LS()` | Left Shift |
| `RS()` | Right Shift |
| `LA()` | Left Alt |
| `RA()` | Right Alt |
| `LG()` | Left GUI |
| `RG()` | Right GUI |

---

## Layout Atual das Layers

### Layer 0: Base QWERTY

```
┌──────┬─────┬─────┬─────┬─────┬─────┐      ┌─────┬─────┬─────┬─────┬─────┬──────┐
│ TAB  │  Q  │  W  │  E  │  R  │  T  │      │  Y  │  U  │  I  │  O  │  P  │ BSPC │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│ CTRL │  A  │  S  │  D  │  F  │  G  │      │  H  │  J  │  K  │  L  │  ;  │  '   │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│SHIFT │  Z  │  X  │  C  │  V  │  B  │      │  N  │  M  │  ,  │  .  │  /  │ ESC  │
└──────┴─────┴─────┴─────┴─────┴─────┘      └─────┴─────┴─────┴─────┴─────┴──────┘
                   ┌─────┬─────┬───────┐  ┌───────┬─────┬─────┐
                   │ GUI │ L1  │ALT/SPC│  │ENT/L2 │BSPC │ L3  │
                   └─────┴─────┴───────┘  └───────┴─────┴─────┘

Teclas especiais dos thumbs:
- ALT/SPC: Toque = Space, Segura = Alt
- ENT/L2:  Toque = Enter, Segura = Layer 2 (Navegação)
```

### Layer 1: Símbolos e Números

Ativado segurando a tecla L1 (thumb esquerdo).

```
┌──────┬─────┬─────┬─────┬─────┬─────┐      ┌─────┬─────┬─────┬─────┬─────┬──────┐
│  `   │  !  │  @  │  #  │  $  │  %  │      │  ^  │  &  │  *  │  (  │  )  │ DEL  │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │  1  │  2  │  3  │  4  │  5  │      │  -  │  =  │  [  │  ]  │  \  │  `   │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │  6  │  7  │  8  │  9  │  0  │      │  _  │  +  │  {  │  }  │  |  │  ~   │
└──────┴─────┴─────┴─────┴─────┴─────┘      └─────┴─────┴─────┴─────┴─────┴──────┘
                   ┌─────┬─────┬─────┐      ┌─────┬─────┬─────┐
                   │     │     │     │      │     │     │ L4  │
                   └─────┴─────┴─────┘      └─────┴─────┴─────┘

- Linha do meio: Números 1-5 (esquerda) e símbolos de programação (direita)
- Linha inferior: Números 6-0 (esquerda) e mais símbolos (direita)
- Thumb direito L4: Acessa Layer 4 (F-keys)
```

### Layer 2: Navegação (Vim-style)

Ativado segurando ENT/L2 (thumb direito).

```
┌──────┬─────┬─────┬─────┬─────┬─────┐      ┌─────┬─────┬─────┬─────┬─────┬──────┐
│ ESC  │     │     │     │     │     │      │     │HOME │PGDN │PGUP │ END │      │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │      │  ←  │  ↓  │  ↑  │  →  │     │      │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │UNDO │ CUT │COPY │PASTE│     │      │     │     │     │     │     │      │
└──────┴─────┴─────┴─────┴─────┴─────┘      └─────┴─────┴─────┴─────┴─────┴──────┘
                   ┌─────┬─────┬─────┐      ┌─────┬─────┬─────┐
                   │     │     │     │      │     │     │ L5  │
                   └─────┴─────┴─────┘      └─────┴─────┴─────┘

- HJKL style: Setas direcionais na posição do Vim
- Atalhos de edição: Undo, Cut, Copy, Paste
- Thumb direito L5: Acessa Layer 5 (Mouse)
```

### Layer 3: Numpad

Ativado com L3 (thumb direito na Layer 0).

```
┌──────┬─────┬─────┬─────┬─────┬─────┐      ┌─────┬─────┬─────┬─────┬─────┬──────┐
│      │     │     │     │     │     │      │  /  │  7  │  8  │  9  │  -  │      │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │      │  *  │  4  │  5  │  6  │  +  │      │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │      │  0  │  1  │  2  │  3  │  .  │ENTER │
└──────┴─────┴─────┴─────┴─────┴─────┘      └─────┴─────┴─────┴─────┴─────┴──────┘
                   ┌─────┬─────┬─────┐      ┌─────┬─────┬─────┐
                   │     │TO 0 │     │      │     │     │     │
                   └─────┴─────┴─────┘      └─────┴─────┴─────┘

- Numpad completo no lado direito
- TO 0: Volta para Layer 0 (base)
```

### Layer 4: F-keys + Mídia + Bluetooth

Acessado via L1 + L4 (segurar L1, depois L4).

```
┌──────┬─────┬─────┬─────┬─────┬─────┐      ┌─────┬─────┬─────┬─────┬─────┬──────┐
│  F1  │ F2  │ F3  │ F4  │ F5  │ F6  │      │ F7  │ F8  │ F9  │ F10 │ F11 │ F12  │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │PREV │NEXT │VOL- │VOL+ │PLAY │      │     │     │     │     │     │      │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│BTCLR │BT 0 │BT 1 │BT 2 │BT 3 │BT 4 │      │ARRFN│CLOG │CMBLK│     │     │ TO 0 │
└──────┴─────┴─────┴─────┴─────┴─────┘      └─────┴─────┴─────┴─────┴─────┴──────┘

- F1-F12: Teclas de função
- Controles de mídia: Previous, Next, Volume, Play/Pause
- Bluetooth: Clear, Select 0-4
- Macros: Arrow Function, Console.log, Comment Block
```

### Layer 5: Mouse

Acessado via L2 + L5 (segurar ENT/L2, depois L5).

```
┌──────┬─────┬─────┬─────┬─────┬─────┐      ┌─────┬─────┬─────┬─────┬─────┬──────┐
│      │     │     │     │     │     │      │     │     │     │     │     │      │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │      │  ←  │  ↓  │  ↑  │  →  │     │      │
├──────┼─────┼─────┼─────┼─────┼─────┤      ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │      │LCLK │MCLK │RCLK │SC↑  │SC↓  │ TO 0 │
└──────┴─────┴─────┴─────┴─────┴─────┘      └─────┴─────┴─────┴─────┴─────┴──────┘

- Movimento do mouse: HJKL style (MOVE_LEFT, DOWN, UP, RIGHT)
- Cliques: Left, Middle, Right
- Scroll: Up, Down
```

---

## Behaviors Disponíveis

### Hold-Tap Customizados

Definidos na seção `behaviors` do keymap:

```c
// Toque = tecla, Segurar = modificador/layer
alt_spc: alt_space {
    compatible = "zmk,behavior-hold-tap";
    #binding-cells = <2>;
    tapping-term-ms = <200>;    // Tempo para distinguir tap de hold
    quick-tap-ms = <150>;       // Janela para double-tap
    flavor = "balanced";        // balanced, tap-preferred, hold-preferred
    bindings = <&kp>, <&kp>;    // <hold>, <tap>
};

// Uso: &alt_spc LALT SPACE
// Resultado: Toque = Space, Segurar = Alt
```

**Flavors disponíveis:**
- `balanced`: Decide baseado em se outra tecla foi pressionada
- `tap-preferred`: Favorece tap, hold precisa de mais tempo
- `hold-preferred`: Favorece hold

### Behaviors Padrão do ZMK

| Behavior | Descrição | Exemplo |
|----------|-----------|---------|
| `&kp` | Key Press | `&kp A` |
| `&mo` | Momentary Layer | `&mo 1` |
| `&to` | To Layer (permanente) | `&to 0` |
| `&tog` | Toggle Layer | `&tog 3` |
| `&lt` | Layer-Tap | `&lt 1 SPACE` |
| `&mt` | Mod-Tap | `&mt LSHIFT A` |
| `&sk` | Sticky Key | `&sk LSHIFT` |
| `&sl` | Sticky Layer | `&sl 1` |
| `&caps_word` | Caps Word | `&caps_word` |
| `&key_repeat` | Repete última tecla | `&key_repeat` |

### Mouse Behaviors

Requer `CONFIG_ZMK_MOUSE=y` no `corne.conf`:

```c
#include <dt-bindings/zmk/mouse.h>

// Movimento do mouse
&mmv MOVE_LEFT
&mmv MOVE_RIGHT
&mmv MOVE_UP
&mmv MOVE_DOWN

// Cliques
&mkp LCLK    // Left Click
&mkp MCLK    // Middle Click
&mkp RCLK    // Right Click

// Scroll
&msc SCRL_UP
&msc SCRL_DOWN
&msc SCRL_LEFT
&msc SCRL_RIGHT
```

---

## Combos Configurados

Combos são atalhos ativados pressionando múltiplas teclas simultaneamente.

### Combos Atuais

| Combo | Teclas | Ação | Layer |
|-------|--------|------|-------|
| Copy | C + V (27 + 28) | Ctrl+C | 0 |
| Paste | V + B (28 + 29) | Ctrl+V | 0 |
| Undo | Z + X (25 + 26) | Ctrl+Z | 0 |
| Redo | X + C (26 + 27) | Ctrl+Y | 0 |
| Save | S + D (14 + 15) | Ctrl+S | 0 |
| Select All | A + S (13 + 14) | Ctrl+A | 0 |
| Comment | Q + W (1 + 2) | Ctrl+/ | 0 |
| Find | F + G (16 + 17) | Ctrl+F | 0 |
| ESC | J + K (19 + 20) | ESC | 0 |

### Como Adicionar Novos Combos

```c
combos {
    compatible = "zmk,combos";

    combo_nome {
        bindings = <&kp LC(X)>;     // Ação (Ctrl+X neste exemplo)
        key-positions = <26 27>;     // Posições das teclas (veja mapa acima)
        timeout-ms = <50>;           // Janela de tempo (ms)
        layers = <0>;                // Layers onde funciona (0 = base)
    };
};
```

**Dicas:**
- `timeout-ms`: Tempo máximo entre os pressionamentos (50ms é bom)
- `layers`: Pode ser `<0 1>` para funcionar em múltiplas layers

---

## Macros

Macros enviam sequências de teclas com um único pressionamento.

### Macros Atuais

| Macro | Nome | Resultado |
|-------|------|-----------|
| `&arrow_fn` | Arrow Function | `() => {}` |
| `&cons_log` | Console Log | `console.log()` |
| `&comment_blk` | Comment Block | `/* */` (cursor no meio) |

### Como Criar Novas Macros

```c
macros {
    // Exemplo: Macro para "function() {}"
    func_macro: function_macro {
        compatible = "zmk,behavior-macro";
        label = "FUNCTION_MACRO";
        #binding-cells = <0>;
        wait-ms = <10>;              // Delay entre teclas
        tap-ms = <10>;               // Duração do pressionamento
        bindings = <
            &kp F &kp U &kp N &kp C &kp T &kp I &kp O &kp N
            &kp LPAR &kp RPAR &kp SPACE &kp LBRC &kp RBRC
        >;
    };
};

// Uso no keymap: &func_macro
```

**Teclas especiais em macros:**
- `&kp SPACE` - Espaço
- `&kp LPAR` / `&kp RPAR` - Parênteses
- `&kp LBRC` / `&kp RBRC` - Chaves
- `&kp LBKT` / `&kp RBKT` - Colchetes
- `&kp LEFT` / `&kp RIGHT` - Setas (útil para posicionar cursor)

---

## Como Adicionar Novas Layers

### Passo 1: Definir a Layer no Keymap

Adicione após a última layer existente:

```c
keymap {
    compatible = "zmk,keymap";

    // ... layers existentes ...

    // Nova Layer 6: Gaming
    gaming_layer {
        display-name = "Gaming";
        bindings = <
   &kp ESC   &kp Q &kp W &kp E &kp R &kp T   &kp Y &kp U &kp I     &kp O   &kp P    &kp BSPC
   &kp TAB   &kp A &kp S &kp D &kp F &kp G   &kp H &kp J &kp K     &kp L   &kp SEMI &kp SQT
   &kp LSHFT &kp Z &kp X &kp C &kp V &kp B   &kp N &kp M &kp COMMA &kp DOT &kp FSLH &to 0
                    &kp LCTRL &kp SPACE &kp LALT   &kp RET &kp BSPC &trans
        >;
    };
};
```

### Passo 2: Adicionar Acesso à Nova Layer

Escolha uma das opções:

```c
// Opção 1: Momentary (ativa enquanto segura)
&mo 6

// Opção 2: Toggle (liga/desliga)
&tog 6

// Opção 3: To (muda permanentemente)
&to 6

// Opção 4: Layer-Tap (tap = tecla, hold = layer)
&lt 6 SPACE
```

### Passo 3: Adicionar Forma de Voltar

Na nova layer, adicione uma forma de voltar:

```c
&to 0    // Volta para layer 0
// ou
&trans   // Se estiver usando &mo, basta soltar a tecla
```

### Exemplo Completo: Layer de Gaming

```c
// No keymap, após a layer 5:
gaming_layer {
    display-name = "Gaming";
// Layout otimizado para jogos - WASD centralizado
    bindings = <
   &kp ESC   &kp N1 &kp N2 &kp N3 &kp N4 &kp N5   &kp Y &kp U &kp I &kp O &kp P &kp BSPC
   &kp TAB   &kp Q  &kp W  &kp E  &kp R  &kp T    &kp H &kp J &kp K &kp L &kp SEMI &kp SQT
   &kp LSHFT &kp A  &kp S  &kp D  &kp F  &kp G    &kp N &kp M &kp COMMA &kp DOT &kp FSLH &to 0
                       &kp LCTRL &kp SPACE &kp LALT   &kp RET &kp BSPC &trans
    >;
};
```

Para ativar, adicione em alguma layer:
```c
&tog 6   // Toggle gaming mode
```

---

## Configurações (corne.conf)

O arquivo `corne.conf` controla funcionalidades do firmware:

```conf
# ==========================================
# Deep Sleep (economia de bateria)
# ==========================================
CONFIG_ZMK_SLEEP=y
CONFIG_ZMK_IDLE_SLEEP_TIMEOUT=3600000   # 1 hora em ms
CONFIG_ZMK_IDLE_TIMEOUT=30000           # 30 segundos

# ==========================================
# Combos
# ==========================================
CONFIG_ZMK_COMBO_MAX_COMBOS_PER_KEY=8   # Máx combos por tecla
CONFIG_ZMK_COMBO_MAX_KEYS_PER_COMBO=3   # Máx teclas por combo

# ==========================================
# Bluetooth
# ==========================================
CONFIG_BT_MAX_CONN=5                    # Máx conexões simultâneas
CONFIG_BT_MAX_PAIRED=5                  # Máx dispositivos pareados
CONFIG_BT_CTLR_TX_PWR_PLUS_8=y         # Potência de transmissão

# ==========================================
# Mouse Keys
# ==========================================
CONFIG_ZMK_MOUSE=y                      # Habilita suporte a mouse
```

### Configurações Opcionais Úteis

```conf
# Debounce (anti-bounce das teclas)
CONFIG_ZMK_KSCAN_DEBOUNCE_PRESS_MS=5
CONFIG_ZMK_KSCAN_DEBOUNCE_RELEASE_MS=5

# USB
CONFIG_ZMK_USB=y

# Nome do dispositivo Bluetooth
CONFIG_ZMK_KEYBOARD_NAME="Corne"

# Bateria
CONFIG_ZMK_BATTERY_REPORTING=y
```

---

## Build e Flash

### Requisitos

- Docker Desktop instalado e rodando
- Conexão com internet (primeira vez)

### Comandos

**Linux/Mac/WSL:**
```bash
cd zmk-config
./scripts/build.sh
```

**Windows:**
```cmd
cd zmk-config
scripts\build.bat
```

### Arquivos Gerados

```
firmware/
├── corne_left.uf2    # Flash no lado esquerdo
└── corne_right.uf2   # Flash no lado direito
```

### Como Flashear

1. Conecte o nice!nano via USB
2. Entre no bootloader (double-tap no reset ou segure reset ao conectar)
3. Uma unidade USB aparecerá (NICENANO)
4. Copie o arquivo `.uf2` correspondente para a unidade
5. O teclado reiniciará automaticamente
6. Repita para o outro lado

---

## Troubleshooting

### Keymap não funciona após flash

**Problema:** O build não está usando seu keymap customizado.

**Solução:** Verifique se o output do build mostra:
```
-- Using keymap file: /zmk-config/corne.keymap
```

Se mostrar outro caminho, o script de build não está passando `-DZMK_CONFIG` corretamente.

### Erro: "pointing.h not found"

**Problema:** Include incorreto para mouse keys.

**Solução:** Use:
```c
#include <dt-bindings/zmk/mouse.h>   // ✓ Correto
// NÃO use: #include <dt-bindings/zmk/pointing.h>
```

### Mouse keys não funcionam

**Problema:** Funcionalidade de mouse não habilitada.

**Solução:** Em `corne.conf`:
```conf
CONFIG_ZMK_MOUSE=y   # ✓ Correto
# NÃO use: CONFIG_ZMK_POINTING=y
```

### Bluetooth não conecta

**Soluções:**
1. Limpe o perfil: Use `&bt BT_CLR` na Layer 4
2. Selecione um perfil diferente: `&bt BT_SEL 0` até `&bt BT_SEL 4`
3. Refaça o pareamento no dispositivo

### Combos não funcionam

**Verificações:**
1. Verifique as posições das teclas (use o mapa de posições)
2. Aumente o `timeout-ms` se necessário
3. Confirme que a layer está correta

---

## Referências

### Documentação Oficial
- [ZMK Documentation](https://zmk.dev/docs)
- [Keycodes Reference](https://zmk.dev/docs/codes)
- [Behaviors](https://zmk.dev/docs/behaviors)
- [Combos](https://zmk.dev/docs/features/combos)
- [Macros](https://zmk.dev/docs/behaviors/macros)

### Repositórios
- [ZMK Firmware (oficial)](https://github.com/zmkfirmware/zmk)
- [urob/zmk (fork com mouse)](https://github.com/urob/zmk)

### Ferramentas
- [Keymap Editor Visual](https://nickcoutsos.github.io/keymap-editor/)
- [ZMK Config Generator](https://zmk.dev/docs/user-setup)

---

*Última atualização: Dezembro 2024*
