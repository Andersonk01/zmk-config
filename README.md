# Corne Keyboard - ZMK Firmware (Configuração Padrão)

Configuração ZMK básica para teclado Corne com **nice!nano v2**.

Este projeto está com o **layout padrão oficial do ZMK**, sem macros, combos ou behaviors customizados. Pronto para você começar do zero e adicionar suas próprias customizações.

## Estrutura

```
.github/workflows/    → Workflow do GitHub Actions (build automático)
config/               → Arquivos de configuração
  ├── corne.keymap   → Layout das layers (3 layers padrão)
  └── corne.conf     → Configurações do firmware (Kconfig)
build.yaml            → Define quais shields serão compilados
west.yml              → Manifest do west (gerencia repositório ZMK)
```

## Layout Padrão (3 Layers)

### Layer 0 — Default (Base QWERTY)
```
| TAB  |  Q  |  W  |  E  |  R  |  T  |     |  Y  |  U  |  I  |  O  |  P  | BSPC |
| CTRL |  A  |  S  |  D  |  F  |  G  |     |  H  |  J  |  K  |  L  |  ;  |  '   |
| SHFT |  Z  |  X  |  C  |  V  |  B  |     |  N  |  M  |  ,  |  .  |  /  | ESC  |
                | GUI | LWR | SPC |       | ENT | RSE | ALT |
```

### Layer 1 — Lower (Números + Bluetooth + Setas)
```
| TAB   |  1  |  2  |  3  |  4  |  5  |     |  6  |  7  |  8  |  9  |  0  | BSPC |
| BTCLR | BT1 | BT2 | BT3 | BT4 | BT5 |     | LFT | DWN |  UP | RGT |     |      |
| SHFT  |     |     |     |     |     |     |     |     |     |     |     |      |
                | GUI |     | SPC |       | ENT |     | ALT |
```

### Layer 2 — Raise (Símbolos)
```
| TAB  |  !  |  @  |  #  |  $  |  %  |     |  ^  |  &  |  *  |  (  |  )  | BSPC |
| CTRL |     |     |     |     |     |     |  -  |  =  |  [  |  ]  |  \  |  `   |
| SHFT |     |     |     |     |     |     |  _  |  +  |  {  |  }  | "|" |  ~   |
                | GUI |     | SPC |       | ENT |     | ALT |
```

**Acesso às Layers:** segure `LWR` (polegar esquerdo) para Layer 1 ou `RSE` (polegar direito) para Layer 2.

## Build pelo GitHub Actions (Recomendado)

1. Faça **fork** ou **push** deste repositório para o GitHub.
2. O workflow em `.github/workflows/build.yml` compila automaticamente a cada push.
3. Acesse a aba **Actions** do repositório e baixe o artefato `firmware.zip`.
4. Dentro dele você encontra `corne_left-nice_nano_v2-zmk.uf2` e `corne_right-nice_nano_v2-zmk.uf2`.

## Build local com Docker

Se quiser compilar direto na sua máquina, os scripts em `scripts/` usam o container oficial `zmkfirmware/zmk-build-arm:stable` e salvam os artefatos em `firmware/`.

No Windows:

```bat
scripts\build.bat
```

No Git Bash, WSL, Linux ou macOS:

```bash
./scripts/build.sh
```

Os scripts usam cache em `~/.zmk-cache` para evitar baixar o ZMK toda vez. Se o cache local estiver apontando para um fork antigo, ele é recriado automaticamente com o repositório oficial.

## Flash do Firmware

1. Conecte o nice!nano via USB.
2. Entre no bootloader: **dois cliques rápidos no botão de reset** (em menos de 1 segundo).
3. Uma unidade chamada `NICENANO` aparecerá no sistema.
4. Copie o arquivo `.uf2` correspondente para a unidade:
   - `corne_left-...uf2` → metade esquerda
   - `corne_right-...uf2` → metade direita
5. Após copiar, o teclado reinicia automaticamente.

## Customização

Edite o arquivo [`config/corne.keymap`](config/corne.keymap) para adicionar suas próprias keys, layers, combos ou macros. Consulte:

- [Documentação ZMK — Keymaps](https://zmk.dev/docs/keymaps)
- [Lista de behaviors](https://zmk.dev/docs/keymaps/behaviors)
- [Editor visual KeymapEditor](https://nickcoutsos.github.io/keymap-editor/)
