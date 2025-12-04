# **Documentação Completa dos Layouts - Corne Keyboard**

Este documento descreve todos os layers (camadas) do teclado Corne configurado com ZMK.

## **⚠️ IMPORTANTE: Suporte a Mouse Keys**

Este teclado inclui suporte a mouse keys (controle de mouse) no **Layer 3**. Para que isso funcione, você precisa compilar o firmware usando o **fork do urob** do ZMK, que inclui suporte a mouse keys.

### **Como Compilar com Suporte a Mouse:**

1. **Windows:** Execute `build.bat`
2. **Linux/Mac/WSL/Git Bash:** Execute `./build.sh`

Os scripts foram configurados para usar automaticamente o fork do urob com suporte a mouse keys. Eles irão:
- Clonar o fork do urob (https://github.com/urob/zmk)
- Compilar o firmware com suporte a `&mmv`, `&mkp` e `&msc`
- Gerar os arquivos `corne_left.uf2` e `corne_right.uf2`

**Requisitos:**
- Docker Desktop instalado e rodando
- Conexão com internet (para clonar o repositório)

**Nota:** O ZMK oficial ainda não inclui suporte a mouse keys. Os scripts de build foram configurados para usar o fork do urob que inclui esse suporte.

---

## **Layer 0: Default Layer (Layout Base)**

Este é o layout padrão do teclado, ativo quando nenhum modificador está pressionado.

### **Como ativar:**
- Sempre ativo por padrão
- Retorna automaticamente quando soltar os modificadores de layer

### **Layout:**

#### **Linha superior (esquerda → direita):**
- **TAB** | **Q** | **W** | **E** | **R** | **T** | **Y** | **U** | **I** | **O** | **P** | **ESC**

#### **Linha do meio (esquerda → direita):**
- **CTRL** | **A** | **S** | **D** | **F** | **G** | **H** | **J** | **K** | **L** | **;** | **LWR/'** (Layer 1 ou aspas simples)

#### **Linha inferior (esquerda → direita):**
- **SHIFT** | **Z** | **X** | **C** | **V** | **B** | **N** | **M** | **,** | **.** | **/** | **SHIFT**

#### **Thumbs (linha inferior):**
- **Esquerda:** **GUI** (Windows/Command) | **LWR** (Layer 1 - Lower) | **ALT/ENTER** (Tap: ALT, Hold: ENTER)
- **Direita:** **HYPER/SPACE** (Tap: HYPER, Hold: SPACE) | **BACKSPACE** | **RSE** (Layer 2 - Raise)

### **Comportamentos especiais:**
- **LWR/'** (última tecla da linha do meio, direita): Tap = aspas simples (`'`), Hold = ativa Layer 1
- **ALT/ENTER** (terceira tecla do thumb esquerdo): Tap = ALT, Hold = ENTER (comportamento tap-preferred)
- **HYPER/SPACE** (primeira tecla do thumb direito): Tap = HYPER (Ctrl+Shift+Alt+GUI), Hold = SPACE (comportamento tap-preferred)

---

## **Layer 1: Layer Below (Números e Símbolos)**

Layer para números, símbolos e caracteres especiais.

### **Como ativar:**
- Segurar a tecla **LWR** (segunda tecla do thumb esquerdo)
- Ou segurar a tecla **LWR/'** (última tecla da linha do meio, direita)

### **Layout:**

#### **Linha superior (esquerda → direita):**
- **Transparente** | **!** | **@** | **#** | **$** | **%** | **^** | **&** | ***** | **(** | **)** | **\\**

#### **Linha do meio (esquerda → direita):**
- **Transparente** | **1** | **2** | **3** | **4** | **5** | **-** | **=** | **`** | **[** | **]** | **|**

#### **Linha inferior (esquerda → direita):**
- **SHIFT** | **6** | **7** | **8** | **9** | **0** | **_** | **+** | **~** | **{** | **}** | **SHIFT**

#### **Thumbs (linha inferior):**
- **Esquerda:** **GUI** | **Transparente** | **ALT/ENTER** (Tap: ALT, Hold: ENTER)
- **Direita:** **HYPER/SPACE** (Tap: HYPER, Hold: SPACE) | **BACKSPACE** | **Transparente**

### **Observações:**
- As teclas transparentes mantêm a função do Layer 0
- SHIFT na linha inferior permite acessar símbolos alternativos (ex: SHIFT+1 = !)

---

## **Layer 2: Layer Above (Funções, Mídia e Bluetooth)**

Layer para teclas de função (F1-F12), controles de mídia, setas direcionais e gerenciamento Bluetooth.

### **Como ativar:**
- Segurar a tecla **RSE** (última tecla do thumb direito)

### **Layout:**

#### **Linha superior (esquerda → direita):**
- **F1** | **F2** | **F3** | **F4** | **F5** | **F6** | **F7** | **F8** | **F9** | **F10** | **F11** | **F12**

#### **Linha do meio (esquerda → direita):**
- **Transparente** | **Previous** (música anterior) | **Next** (próxima música) | **Volume -** | **Volume +** | **Play/Pause** | **←** | **↓** | **↑** | **→** | **Transparente** | **Transparente**

#### **Linha inferior (esquerda → direita):**
- **BT_CLR** (limpa perfil Bluetooth atual) | **BT1** (perfil 0) | **BT2** (perfil 1) | **BT3** (perfil 2) | **BT4** (perfil 3) | **BT5** (perfil 4) | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente**

#### **Thumbs (linha inferior):**
- **Esquerda:** **Transparente** | **Transparente** | **Transparente**
- **Direita:** **Transparente** | **Transparente** | **Transparente**

### **Funções detalhadas:**
- **F1-F12:** Teclas de função padrão (F1 começa na primeira tecla superior esquerda)
- **Previous/Next:** Controles de mídia (música anterior/próxima)
- **Volume -/Volume +:** Controles de volume do sistema
- **Play/Pause:** Reproduzir/pausar mídia
- **Setas (← ↓ ↑ →):** Navegação direcional
- **BT_CLR:** Limpa o perfil Bluetooth atual (útil para resolver problemas de conexão)
- **BT1-BT5:** Seleciona perfis Bluetooth 0, 1, 2, 3 e 4 respectivamente

### **Observações:**
- Todas as teclas de thumb são transparentes neste layer
- As teclas transparentes mantêm a função do Layer 0

---

## **Layer 3: Mouse Control (Controle de Mouse)**

Layer para controle de mouse usando o teclado. Requer firmware compilado com o fork do urob (suporte a mouse keys).

### **Como ativar:**
- Ativar com `&tog 3` (toggle layer 3) - configurado na última tecla do thumb direito no Layer 0

### **Layout:**

#### **Linha superior (esquerda → direita):**
- **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente**

#### **Linha do meio (esquerda → direita):**
- **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **↑** (Mouse Move Up) | **←** (Mouse Move Left) | **↓** (Mouse Move Down) | **→** (Mouse Move Right) | **Transparente** | **Transparente**

#### **Linha inferior (esquerda → direita):**
- **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **Transparente** | **LCLK** (Left Click) | **MCLK** (Middle Click) | **RCLK** (Right Click) | **WH_U** (Scroll Up) | **WH_D** (Scroll Down) | **Transparente**

### **Funções detalhadas:**
- **Mouse Move (↑ ← ↓ →):** Move o cursor do mouse nas direções indicadas
- **LCLK:** Clique esquerdo do mouse
- **MCLK:** Clique do botão do meio (scroll wheel click)
- **RCLK:** Clique direito do mouse
- **WH_U/WH_D:** Scroll para cima/baixo

### **Observações:**
- Este layer requer o fork do urob do ZMK com suporte a mouse keys
- Os comportamentos `&mmv`, `&mkp` e `&msc` não estão disponíveis no ZMK oficial
- Veja a seção "Como Compilar" abaixo para instruções

---

## **Resumo dos Modificadores de Layer:**

- **LWR** (Lower): Ativa Layer 1 - Números e Símbolos
- **RSE** (Raise): Ativa Layer 2 - Funções, Mídia e Bluetooth
- **LWR/'**: Tap = aspas simples, Hold = Layer 1
- **Layer 3**: Toggle layer para controle de mouse (ativado com `&tog 3`)

---

## **Comportamentos Especiais:**

### **Tap-Preferred (`tp`):**
- **ALT/ENTER:** Tap = ALT, Hold = ENTER (150ms de tapping term)
- **HYPER/SPACE:** Tap = HYPER (Ctrl+Shift+Alt+GUI), Hold = SPACE (150ms de tapping term)

### **Layer-Tap (`lt`):**
- **LWR/'**: Tap = aspas simples (`'`), Hold = Layer 1

---

## **Layout Visual Rápido:**

```
Layer 0 (Default):
┌─────┬─────┬─────┬─────┬─────┬─────┐     ┌─────┬─────┬─────┬─────┬─────┬─────┐
│ TAB │  Q  │  W  │  E  │  R  │  T  │     │  Y  │  U  │  I  │  O  │  P  │ ESC │
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│CTRL │  A  │  S  │  D  │  F  │  G  │     │  H  │  J  │  K  │  L  │  ;  │LWR/'│
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│SHIFT│  Z  │  X  │  C  │  V  │  B  │     │  N  │  M  │  ,  │  .  │  /  │SHIFT│
└─────┴─────┴─────┴─────┴─────┴─────┘     └─────┴─────┴─────┴─────┴─────┴─────┘
        ┌─────┬─────┬─────┐                       ┌─────┬─────┬─────┐
        │ GUI │ LWR │ALT/ │                       │HYPER│ BKSP│ RSE │
        │     │     │ENTER│                       │/SPC │     │     │
        └─────┴─────┴─────┘                       └─────┴─────┴─────┘

Layer 1 (Lower - Números e Símbolos):
┌─────┬─────┬─────┬─────┬─────┬─────┐     ┌─────┬─────┬─────┬─────┬─────┬─────┐
│     │  !  │  @  │  #  │  $  │  %  │     │  ^  │  &  │  *  │  (  │  )  │  \  │
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │  1  │  2  │  3  │  4  │  5  │     │  -  │  =  │  `  │  [  │  ]  │  |  │
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│SHIFT│  6  │  7  │  8  │  9  │  0  │     │  _  │  +  │  ~  │  {  │  }  │SHIFT│
└─────┴─────┴─────┴─────┴─────┴─────┘     └─────┴─────┴─────┴─────┴─────┴─────┘

Layer 2 (Raise - Funções, Mídia e Bluetooth):
┌─────┬─────┬─────┬─────┬─────┬─────┐     ┌─────┬─────┬─────┬─────┬─────┬─────┐
│ F1  │ F2  │ F3  │ F4  │ F5  │ F6  │     │ F7  │ F8  │ F9  │ F10 │ F11 │ F12 │
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │PREV │NEXT │VOL- │VOL+ │PLAY │     │  ←  │  ↓  │  ↑  │  →  │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│BTCLR│ BT1 │ BT2 │ BT3 │ BT4 │ BT5 │     │     │     │     │     │     │     │
└─────┴─────┴─────┴─────┴─────┴─────┘     └─────┴─────┴─────┴─────┴─────┴─────┘

Layer 3 (Mouse Control):
┌─────┬─────┬─────┬─────┬─────┬─────┐     ┌─────┬─────┬─────┬─────┬─────┬─────┐
│     │     │     │     │     │     │     │     │     │     │     │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │     │     │     │  ↑  │  ←  │  ↓  │  →  │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┤     ├─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │     │     │     │LCLK │MCLK │RCLK │WH_U │WH_D │     │
└─────┴─────┴─────┴─────┴─────┴─────┘     └─────┴─────┴─────┴─────┴─────┴─────┘
```
