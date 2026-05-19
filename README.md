# Corne — duas metades independentes

Cada metade é um teclado **separado** (sem split): Bluetooth, layers e `BT_CLR` / `BT1`–`BT5` **próprios**.

| Metade | Nome no Bluetooth |
|--------|-------------------|
| Esquerda | **Corne Esquerda** |
| Direita | **Corne Direita** |

## Layers (cada metade)

| Polegar | Layer |
|---------|--------|
| Segurar polegar interno (**LWR** / **RSE**) | **Bluetooth** — `BT_CLR`, `BT1`–`BT5` |
| Na layer BT, segure o polegar do meio | **Símbolos** |

## Build e flash

```bat
scripts\build.bat
```

1. `settings_reset.uf2` → esquerda e direita  
2. `corne_left.uf2` → esquerda  
3. `corne_right.uf2` → direita  

No Windows: remova Corne antigos → emparelhe **Corne Esquerda** e **Corne Direita** separadamente.

## Se a direita ainda estiver trocada

Avise qual tecla física manda qual letra (ex.: canto superior direito = ?). Ajustamos ordem das colunas no `corne_right.overlay`.

Mais detalhes: [docs/DUAS_METADES.md](docs/DUAS_METADES.md)
