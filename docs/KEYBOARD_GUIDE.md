# 🎹 Corne Keyboard — Documentação Completa

> **Hardware:** 2x Tenstar Robot nRF52840 (clone nice!nano V2) — Placa vermelha  
> **Firmware:** ZMK Firmware (branch `feature/split-keymap-refactor`)  
> **Modo:** Split Real — Esquerdo (Central BLE) + Direito (Periférico BLE)

---

## 📑 Índice

1. [Arquitetura Split](#-arquitetura-split)
2. [LEDs — Indicadores de Status](#-leds--indicadores-de-status)
3. [Bateria — Carga e Monitoramento](#-bateria--carga-e-monitoramento)
4. [Layers — Mapa Completo de Teclas](#-layers--mapa-completo-de-teclas)
5. [Combos — Atalhos de Duas Teclas](#-combos--atalhos-de-duas-teclas)
6. [Behaviors — Hold-Tap Customizados](#-behaviors--hold-tap-customizados)
7. [Macros — Todas as Macros de Desenvolvimento](#-macros--todas-as-macros-de-desenvolvimento)
8. [Bluetooth — Perfis e Gerenciamento](#-bluetooth--perfis-e-gerenciamento)
9. [Flashing — Como Gravar o Firmware](#-flashing--como-gravar-o-firmware)
10. [Troubleshooting — Resolução de Problemas](#-troubleshooting--resolução-de-problemas)

---

## 🔗 Arquitetura Split

```
┌─────────────────┐         BLE          ┌─────────────────┐
│   LADO ESQUERDO │ ◄══════════════════► │   LADO DIREITO  │
│    (Central)    │    Comunicação sem    │  (Periférico)   │
│                 │        fio           │                 │
│  ► Conecta ao   │                      │  ► Só fala com  │
│    computador   │                      │    o esquerdo   │
│  ► USB = dados  │                      │  ► USB = apenas │
│    + carga      │                      │    carga        │
│  ► BLE = dados  │                      │  ► Precisa de   │
│    sem fio      │                      │    bateria      │
└─────────────────┘                      └─────────────────┘
        │
        │  USB-C ou BLE
        ▼
   ┌──────────┐
   │ Notebook │
   └──────────┘
```

| Característica | Lado Esquerdo | Lado Direito |
|:---|:---|:---|
| Função | Central (master) | Periférico (slave) |
| Conexão ao PC | ✅ USB-C ou Bluetooth | ❌ Impossível |
| USB-C serve para | Dados + Carga | Apenas carga |
| Precisa de bateria | Recomendado | **Obrigatório** (sem fio) |
| Keymap definido | Sim (42 teclas completas) | Sim (recebe do central) |

---

## 💡 LEDs — Indicadores de Status

### Mapeamento de LEDs (Placa Tenstar Robot Vermelha)

> ⚠️ Nas placas clone Tenstar, os LEDs são **invertidos** em relação ao nice!nano original.

| LED Físico | Pino | Função na Tenstar | Função no nice!nano original |
|:---|:---|:---|:---|
| 🔵 **Azul** | Circuito de carga | **Carregamento** de bateria | Status/Programável |
| 🔴 **Vermelho** | `P0.15` (GPIO) | **Status BLE + Bateria** (programável) | Carregamento |

---

### LED Azul (Carregamento)

| Estado | Significado |
|:---|:---|
| 🔵 Aceso contínuo | Bateria **carregando** via USB |
| 🔵 Apagado | Bateria **carregada** ou USB desconectado |
| 🔵 Piscando lento | Modo **bootloader** (aguardando firmware .uf2) |

---

### LED Vermelho (Status — zmk-poor-mans-led-indicator)

#### No Boot (ao ligar/resetar)

| Piscadas | Velocidade | Significado |
|:---|:---|:---|
| 2x | 🐢 Devagar | 🟢 Bateria **boa** (acima do threshold alto) |
| 4x | 🚶 Médio | 🟡 Bateria **baixa** (abaixo do threshold baixo) |
| 6x | 🏃 Rápido | 🔴 Bateria **crítica** (precisa carregar AGORA) |

#### Status BLE (a cada mudança de conexão)

| Comportamento | Significado |
|:---|:---|
| Pisca **N vezes devagar** e para | ✅ **Conectado** ao perfil BT nº N |
| Pisca **rápido sem parar** | ❌ **Desconectado** / procurando pareamento |
| Pisca **lento contínuo** | 🔍 **Procurando** dispositivo para parear |

---

## 🔋 Bateria — Carga e Monitoramento

### Como Verificar o Nível de Bateria

| Método | Onde | Como |
|:---|:---|:---|
| LED no boot | No teclado | Observe as piscadas ao ligar (tabela acima) |
| Windows | Configurações → Bluetooth | Mostra % ao lado de "Corne KB" |
| Sinais de descarga | Uso | Teclas do lado direito param de funcionar |

### Como Carregar

1. Conecte um cabo **USB-C** no lado que precisa carregar
2. O **LED azul** acende enquanto carrega
3. O **LED azul** apaga quando a carga está completa
4. O teclado **continua funcionando** enquanto carrega
5. Taxa de carga padrão: **100mA** (baterias de 110-300mAh levam 1-3h)

### Configurações Ativas de Bateria (corne.conf)

```
CONFIG_ZMK_SPLIT_BLE_CENTRAL_BATTERY_LEVEL_FETCHING=y  ← Busca bateria do direito
CONFIG_ZMK_SPLIT_BLE_CENTRAL_BATTERY_LEVEL_PROXY=y     ← Mostra no Windows
```

---

## 🎹 Layers — Mapa Completo de Teclas

### Navegação entre Layers

```
Layer 0 (Base) ──► Segura L1 thumb esq ──► Layer 1 (Símbolos)
     │                                          │
     ├──► Segura ENT thumb dir ──► Layer 2 (Nav) │
     │                                │         │
     ├──► Toggle L3 thumb dir ──► Layer 3 (Numpad)
     │                                          │
     │              Layer 1 + Toggle L4 ──► Layer 4 (Sistema)
     │                                          │
     │              Layer 2 + Toggle L5 ──► Layer 5 (Mouse)
     │                                          │
     │              Layer 4 + Toggle L6 ──► Layer 6 (Macros)
     │                                          │
     └──────────── "to 0" em cada layer ◄───────┘
```

---

### Layer 0: Base QWERTY

```
┌──────┬─────┬─────┬─────┬─────┬─────┐   ┌─────┬─────┬─────┬─────┬─────┬──────┐
│ TAB  │  Q  │  W  │  E  │  R  │  T  │   │  Y  │  U  │  I  │  O  │  P  │ BSPC │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│ CTRL │  A  │  S  │  D  │  F  │  G  │   │  H  │  J  │  K  │  L  │  ;  │  '   │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│ SHFT │  Z  │  X  │  C  │  V  │  B  │   │  N  │  M  │  ,  │  .  │  /  │ ESC  │
└──────┴─────┴─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┴─────┴──────┘
                   │ GUI │ L1  │ALT/ │   │ENT/ │BSPC │ L3  │
                   │     │(mo) │ SPC │   │ L2  │     │(tog)│
                   └─────┴─────┴─────┘   └─────┴─────┴─────┘
```

**Teclas especiais dos thumbs:**
- `GUI` = Tecla Windows
- `L1 (mo)` = Segura para ativar Layer 1 (solta = volta)
- `ALT/SPC` = Toque = Espaço, Segura = Alt (hold-tap)
- `ENT/L2` = Toque = Enter, Segura = Layer 2 (hold-tap)
- `BSPC` = Backspace
- `L3 (tog)` = Toggle Layer 3 (clica = ativa, clica de novo = desativa)

---

### Layer 1: Símbolos e Números

**Acesso:** Segurar L1 no thumb esquerdo

```
┌──────┬─────┬─────┬─────┬─────┬─────┐   ┌─────┬─────┬─────┬─────┬─────┬──────┐
│  `   │  !  │  @  │  #  │  $  │  %  │   │  ^  │  &  │  *  │  (  │  )  │ DEL  │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │  1  │  2  │  3  │  4  │  5  │   │  -  │  =  │  [  │  ]  │  \  │  `   │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │  6  │  7  │  8  │  9  │  0  │   │  _  │  +  │  {  │  }  │  |  │  ~   │
└──────┴─────┴─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┴─────┴──────┘
                   │     │ ▓▓▓ │     │   │     │     │ L4  │
                   │     │(L1) │     │   │     │     │(tog)│
                   └─────┴─────┴─────┘   └─────┴─────┴─────┘
```

**Linha superior:** Símbolos especiais (`!@#$%^&*()`)  
**Linha do meio:** Números 1-5 + operadores (`-=[]\`)  
**Linha inferior:** Números 6-0 + operadores (`_+{}|~`)  
**Thumb direito:** Toggle para Layer 4 (Sistema)

---

### Layer 2: Navegação (Vim-style)

**Acesso:** Segurar ENT/L2 no thumb direito

```
┌──────┬─────┬─────┬─────┬─────┬─────┐   ┌─────┬─────┬─────┬─────┬─────┬──────┐
│ ESC  │     │     │     │     │     │   │     │HOME │PgDn │PgUp │ END │      │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │   │  ←  │  ↓  │  ↑  │  →  │     │      │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │UNDO │CUT  │COPY │PASTE│     │   │     │     │     │     │     │      │
└──────┴─────┴─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┴─────┴──────┘
                   │     │     │     │   │ ▓▓▓ │     │ L5  │
                   │     │     │     │   │(L2) │     │(tog)│
                   └─────┴─────┴─────┘   └─────┴─────┴─────┘
```

**Lado direito:** Navegação HJKL (estilo Vim: ← ↓ ↑ →)  
**Lado esquerdo:** Atalhos de edição (Ctrl+Z, Ctrl+X, Ctrl+C, Ctrl+V)  
**Thumb direito:** Toggle para Layer 5 (Mouse)

---

### Layer 3: Numpad

**Acesso:** Toggle L3 no thumb direito

```
┌──────┬─────┬─────┬─────┬─────┬─────┐   ┌─────┬─────┬─────┬─────┬─────┬──────┐
│      │     │     │     │     │     │   │  /  │  7  │  8  │  9  │  -  │      │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │   │  *  │  4  │  5  │  6  │  +  │      │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │   │  0  │  1  │  2  │  3  │  .  │ ENT  │
└──────┴─────┴─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┴─────┴──────┘
                   │     │ L0  │     │   │     │     │     │
                   │     │(to) │     │   │     │     │     │
                   └─────┴─────┴─────┘   └─────┴─────┴─────┘
```

**Lado direito:** Teclado numérico completo (como num pad tradicional)  
**Thumb esquerdo:** Volta para Layer 0

---

### Layer 4: Sistema / Hardware

**Acesso:** Toggle L4 a partir da Layer 1

```
┌──────┬─────┬─────┬─────┬─────┬─────┐   ┌─────┬─────┬─────┬─────┬─────┬──────┐
│  F1  │ F2  │ F3  │ F4  │ F5  │ F6  │   │ F7  │ F8  │ F9  │ F10 │ F11 │ F12  │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │PREV │NEXT │VOL- │VOL+ │PLAY │   │     │     │     │     │     │  L6  │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│BTCLR │ BT1 │ BT2 │ BT3 │ BT4 │ BT5 │   │     │     │     │     │     │  L0  │
└──────┴─────┴─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┴─────┴──────┘
                   │     │     │     │   │     │     │     │
                   └─────┴─────┴─────┘   └─────┴─────┴─────┘
```

**Linha superior:** F1 a F12  
**Linha do meio:** Controles de mídia (Prev, Next, Vol-, Vol+, Play/Pause)  
**Linha inferior:** Bluetooth (Limpar, Perfil 1-5)  
**Canto direito:** Toggle Layer 6 (Macros) e volta ao Layer 0

---

### Layer 5: Mouse

**Acesso:** Toggle L5 a partir da Layer 2

```
┌──────┬─────┬─────┬─────┬─────┬─────┐   ┌─────┬─────┬─────┬─────┬─────┬──────┐
│      │     │     │     │     │     │   │     │     │     │     │     │      │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │   │  ←  │  ↓  │  ↑  │  →  │     │      │
├──────┼─────┼─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┼─────┼──────┤
│      │     │     │     │     │     │   │LCLK │MCLK │RCLK │SC↑  │SC↓  │  L0  │
└──────┴─────┴─────┼─────┼─────┼─────┤   ├─────┼─────┼─────┼─────┴─────┴──────┘
                   │     │     │     │   │     │     │     │
                   └─────┴─────┴─────┘   └─────┴─────┴─────┘
```

**Linha do meio (direita):** Movimento do cursor (HJKL → ← ↓ ↑ →)  
**Linha inferior (direita):** Cliques (Esquerdo, Meio, Direito) + Scroll (↑ ↓)

---

### Layer 6: Macros de Desenvolvimento

**Acesso:** Toggle L6 a partir da Layer 4

```
┌────────┬────────┬────────┬────────┬────────┬────────┐ ┌────────┬────────┬────────┬────────┬────────┬────────┐
│useState│useEffct│expConst│expFn   │useMemo │useCallb│ │async() │tryCatch│arrow() │return  │if(){}  │ternary │
├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
│git st  │git cm  │git add │git push│git pull│git co-b│ │dc up   │dc down │dc build│dc logs │dock ps │dock ex │
├────────┼────────┼────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┼────────┼────────┤
│pnpm dev│pnpm bld│pnpm tst│npm dev │npm bld │clear   │ │console │TODO    │/**/    │FIXME   │con.err │throw   │
└────────┴────────┴────────┼────────┼────────┼────────┤ ├────────┼────────┼────────┼────────┴────────┴────────┘
                           │        │        │        │ │        │        │  L0    │
                           └────────┴────────┴────────┘ └────────┴────────┴────────┘
```

---

## ⌨️ Combos — Atalhos de Duas Teclas

Combos funcionam **apenas na Layer 0** (Base). Pressione as duas teclas simultaneamente (dentro de 50ms):

| Teclas Simultâneas | Ação | Equivalente |
|:---|:---|:---|
| `Z` + `X` | Desfazer | `Ctrl+Z` |
| `X` + `C` | Refazer | `Ctrl+Y` |
| `C` + `V` | Copiar | `Ctrl+C` |
| `V` + `B` | Colar | `Ctrl+V` |
| `A` + `S` | Selecionar Tudo | `Ctrl+A` |
| `S` + `D` | Salvar | `Ctrl+S` |
| `F` + `G` | Buscar | `Ctrl+F` |
| `Q` + `W` | Comentar Linha | `Ctrl+/` (VS Code) |
| `J` + `K` | ESC rápido | `Escape` |

---

## 🔀 Behaviors — Hold-Tap Customizados

| Nome | Toque Rápido | Segurar (200ms+) | Onde |
|:---|:---|:---|:---|
| `alt_spc` | `Espaço` | `Alt` | Thumb esquerdo (3º) |
| `ent_l2` | `Enter` | Ativa Layer 2 | Thumb direito (1º) |

**Configuração:**
- `tapping-term-ms = 200` → tempo mínimo para registrar como "segurar"
- `quick-tap-ms = 150` → toque duplo rápido sempre registra como toque
- `flavor = balanced` → decisão balanceada entre toque e segurar

---

## 🤖 Macros — Todas as Macros de Desenvolvimento

### React (Layer 6 — Linha Superior Esquerda)

| Posição | Tecla | Saída |
|:---|:---|:---|
| 1 | useState | `const [state, setState] = useState();` |
| 2 | useEffect | `useEffect(() => {}, []);` |
| 3 | export_const | `export const Component = () => {}` |
| 4 | export_fn | `export default function Component() {}` |
| 5 | useMemo | `useMemo(() => {}, []);` |
| 6 | useCallback | `useCallback(() => {}, []);` |

### JavaScript/TypeScript (Layer 6 — Linha Superior Direita)

| Posição | Tecla | Saída |
|:---|:---|:---|
| 7 | async_fn | `async () => {}` |
| 8 | try_catch | `try {} catch (e) {}` |
| 9 | arrow_fn | `() => {}` |
| 10 | return | `return` |
| 11 | ifBlock | `if () {}` |
| 12 | ternary | ` ? true : false` |

### Git (Layer 6 — Linha do Meio Esquerda)

| Posição | Tecla | Saída | Executa? |
|:---|:---|:---|:---|
| 1 | git_status | `git status` | ✅ Enter |
| 2 | git_commit | `git commit -m ''` | ❌ Cursor entre aspas |
| 3 | git_add_all | `git add .` | ✅ Enter |
| 4 | git_push | `git push` | ✅ Enter |
| 5 | git_pull | `git pull` | ✅ Enter |
| 6 | git_checkout_b | `git checkout -b ` | ❌ Aguarda nome |

### Docker (Layer 6 — Linha do Meio Direita)

| Posição | Tecla | Saída | Executa? |
|:---|:---|:---|:---|
| 7 | dc_up | `docker compose up -d` | ✅ Enter |
| 8 | dc_down | `docker compose down` | ✅ Enter |
| 9 | dc_build | `docker compose build` | ✅ Enter |
| 10 | dc_logs | `docker compose logs -f` | ✅ Enter |
| 11 | docker_ps | `docker ps` | ✅ Enter |
| 12 | docker_exec | `docker exec -it ` | ❌ Aguarda container |

### Terminal / Package Managers (Layer 6 — Linha Inferior Esquerda)

| Posição | Tecla | Saída | Executa? |
|:---|:---|:---|:---|
| 1 | pnpm_dev | `pnpm dev` | ✅ Enter |
| 2 | pnpm_build | `pnpm build` | ✅ Enter |
| 3 | pnpm_test | `pnpm test` | ✅ Enter |
| 4 | npm_dev | `npm run dev` | ✅ Enter |
| 5 | npm_build | `npm run build` | ✅ Enter |
| 6 | clear_term | `clear` | ✅ Enter |

### Utilitários de Código (Layer 6 — Linha Inferior Direita)

| Posição | Tecla | Saída |
|:---|:---|:---|
| 7 | cons_log | `console.log()` |
| 8 | todo_macro | `// TODO: ` |
| 9 | comment_blk | `/*  */` (cursor no meio) |
| 10 | fixme_macro | `// FIXME: ` |
| 11 | console_err | `console.error()` |
| 12 | throw_err | `throw new Error();` |

---

## 📡 Bluetooth — Perfis e Gerenciamento

### 5 Perfis Bluetooth Disponíveis

O teclado suporta até **5 dispositivos** pareados simultaneamente. Troque entre eles na **Layer 4** (Sistema):

| Tecla (Layer 4) | Ação | Uso |
|:---|:---|:---|
| `BT1` | Seleciona perfil 1 | Ex: Notebook pessoal |
| `BT2` | Seleciona perfil 2 | Ex: PC do trabalho |
| `BT3` | Seleciona perfil 3 | Ex: Tablet |
| `BT4` | Seleciona perfil 4 | Ex: Celular |
| `BT5` | Seleciona perfil 5 | Ex: Reserva |
| `BTCLR` | Limpa o perfil ativo | Remove pareamento atual |

### Como Parear com um Novo Dispositivo

1. Ative a **Layer 4** (segure L1 → pressione Toggle L4)
2. Selecione um perfil vazio (ex: `BT2`)
3. No dispositivo, procure por **"Corne KB"** no Bluetooth
4. Pareie — pronto!

### Configurações BLE Ativas

```
CONFIG_BT_CTLR_TX_PWR_PLUS_8=y   ← Potência máxima de sinal
CONFIG_BT_MAX_CONN=5              ← Até 5 conexões simultâneas
CONFIG_BT_MAX_PAIRED=5            ← Até 5 dispositivos pareados
```

---

## 💾 Flashing — Como Gravar o Firmware

### Passo a Passo Completo

#### 1. Compilar o Firmware
- Faça push das mudanças para o GitHub
- O GitHub Actions compila automaticamente
- Baixe os artifacts na aba Actions → Summary → Artifacts

#### 2. Arquivos do Artifact

| Arquivo | Destino | Tamanho aprox. |
|:---|:---|:---|
| `settings_reset-nice_nano__zmk-zmk.uf2` | Ambos os lados (limpa memória) | ~30 KB |
| `corne_left-nice_nano__zmk-zmk.uf2` | Lado **esquerdo** apenas | ~500 KB |
| `corne_right-nice_nano__zmk-zmk.uf2` | Lado **direito** apenas | ~375 KB |

#### 3. Sequência de Gravação

```
1. ESQUERDO: Duplo clique reset → Arrastar settings_reset.uf2
2. DIREITO:  Duplo clique reset → Arrastar settings_reset.uf2
3. ESQUERDO: Duplo clique reset → Arrastar corne_left.uf2
4. DIREITO:  Duplo clique reset → Arrastar corne_right.uf2
5. Ligar ambos ao mesmo tempo (bateria ou USB)
6. Aguardar 15 segundos para pareamento automático
7. Conectar ao computador via Bluetooth → "Corne KB"
```

#### 4. Entrar no Modo Bootloader

- **Botão de reset:** Pressione 2x rapidamente (< 0.5s)
- **Sem botão:** Curto-circuito rápido entre pinos `RST` e `GND` (2x)
- **Sucesso:** Drive `NICENANO` aparece no computador + LED azul pisca

---

## 🛠️ Troubleshooting — Resolução de Problemas

### Os dois lados não se comunicam

1. Flash `settings_reset` em **ambos** os lados
2. Flash os firmwares corretos (left no esquerdo, right no direito)
3. Ligue ambos **ao mesmo tempo**
4. Remova "Corne KB" do Bluetooth do PC e pareie novamente

### Teclas do lado direito não funcionam

- Verifique se a bateria do direito tem carga
- Verifique se o LED vermelho pisca no boot (firmware ativo)
- Verifique se o firmware correto foi flasheado (`corne_right`, NÃO `corne_left`)

### O drive NICENANO não aparece

- Tente outro cabo USB-C (muitos são apenas de carga)
- Use a porta USB traseira do computador
- Tente o duplo clique no reset mais rápido ou mais devagar

### Teclado desconecta do Bluetooth

- Verifique bateria (carregue via USB-C)
- Verifique distância e obstruções metálicas
- `TX_PWR_PLUS_8` já está no máximo — o problema é geralmente bateria fraca

### LED vermelho pisca rápido sem parar (lado direito)

- O periférico está **procurando** o central
- Certifique-se de que o lado esquerdo está **ligado**
- Se persistir, faça settings_reset em ambos

---

## 📁 Arquivos do Projeto

| Arquivo | Função |
|:---|:---|
| `config/corne.keymap` | Mapa de teclas (7 layers + combos + macros) |
| `config/corne.conf` | Configuração do firmware (split, BLE, mouse, LED) |
| `config/corne.overlay` | Definição do LED hardware (P0.15) |
| `config/west.yml` | Dependências (ZMK + módulo LED indicator) |
| `build.yaml` | Targets de compilação (left, right, settings_reset) |

---

> 📝 **Última atualização:** Maio 2026  
> 🔗 **Repositório:** [Andersonk01/zmk-config](https://github.com/Andersonk01/zmk-config)  
> 🌿 **Branch:** `feature/split-keymap-refactor`
