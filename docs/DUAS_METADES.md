# Duas metades independentes

## Nomes Bluetooth

Definidos em `corne_left.conf` e `corne_right.conf` (`CONFIG_ZMK_KEYBOARD_NAME`). Aparecem no Windows como **Corne L** e **Corne R** (até 16 caracteres).

Para mudar, edite esses arquivos e rode o build de novo.

## Mapeamento (correção de matrix transform)

Cada metade opera como teclado standalone (`CONFIG_ZMK_SPLIT=n`). O shield Corne original define um `default_transform` com 12 colunas (split). Os overlays (`corne_left.overlay` e `corne_right.overlay`) **redefinem** o transform para **6 colunas × 4 rows**, compatível com o uso independente.

O PCB clone usa a **mesma ordem de pinos** que a esquerda. As letras ficam nas **colunas 0–5** do keymap. O overlay usa `col-offset = 0`.

## Layers por metade

Cada `*.keymap` tem 3 layers só para aquela metade:

1. **Base** — QWERTY do lado  
2. **Bluetooth** — `BT_CLR`, `BT1`…`BT5`, números, setas (direita)  
3. **Símbolos** — `!@#` etc.

Não há comunicação entre metades.

## Bluetooth independente

Cada lado tem seu próprio `BT_CLR` e `BT_SEL 0-4` na layer Bluetooth (layer 1).
Para acessar: segure o thumb interno (`LWR` / `mo 1`).

- `BT_CLR` limpa **apenas** o pareamento do lado em que foi pressionado
- `BT_SEL` seleciona perfil Bluetooth **daquele lado** independentemente

## Uso

- Só esquerda: emparelhe **Corne L**  
- Só direita: emparelhe **Corne R**  
- As duas: dois dispositivos no PC  

Cada metade: segure polegar inferior interno (**LWR** / layer 1) para Bluetooth.
