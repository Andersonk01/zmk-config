# Duas metades independentes

## Nomes Bluetooth

Definidos em `corne_left.conf` e `corne_right.conf` (`CONFIG_ZMK_KEYBOARD_NAME`). Aparecem no Windows como **Corne Esquerda** e **Corne Direita** (até 16 caracteres).

Para mudar, edite esses arquivos e rode o build de novo.

## Mapeamento da direita (correção)

O PCB clone usa a **mesma ordem de pinos** que a esquerda. As letras ficam nas **colunas 0–5** do keymap (não 6–11 como no split). O overlay usa `col-offset = 0`.

## Layers por metade

Cada `*.keymap` tem 3 layers só para aquela metade:

1. **Base** — QWERTY do lado  
2. **Bluetooth** — `BT_CLR`, `BT1`…`BT5`, números, setas (direita)  
3. **Símbolos** — `!@#` etc.

Não há comunicação entre metades.

## Uso

- Só esquerda: emparelhe **Corne Esquerda**  
- Só direita: emparelhe **Corne Direita**  
- As duas: dois dispositivos no PC  

Cada metade: segure polegar inferior interno (**LWR** / layer 1) para Bluetooth.
