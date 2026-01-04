# Corne Keyboard - ZMK Firmware

Configuração ZMK personalizada para teclado Corne com nice!nano v2.

## Funcionalidades

- **7 Layers**: Base, Símbolos, Navegação, Numpad, Sistema/Hardware, Mouse, Macros Dev
- **9 Combos**: Copy, Paste, Undo, Redo, Save, Select All, Comment, Find, ESC
- **36 Macros**: React, JS/TS, Git, Docker, Terminal, Utilidades (ver [docs/LAYER6_MACROS.md](docs/LAYER6_MACROS.md))
- **Mouse Keys**: Movimento, cliques e scroll via teclado
- **Bluetooth**: 5 perfis de conexão

## Estrutura

```
config/         → Arquivos de configuração (keymap, conf)
scripts/        → Scripts de build (build.sh, build.bat)
firmware/       → Firmware compilado (.uf2)
docs/           → Documentação completa
```

## Build Rápido

**Requisitos:** Docker Desktop instalado e rodando.

```bash
# Linux/Mac/WSL
./scripts/build.sh

# Windows
scripts\build.bat
```

Os arquivos `.uf2` serão gerados em `firmware/`.

## Flash

1. Conecte o nice!nano via USB
2. Entre no bootloader (double-tap no reset)
3. Copie o `.uf2` para a unidade que aparecer
4. Repita para o outro lado

## Documentação

📖 **[Documentação Completa](docs/README.md)** - Guia detalhado com:
- Layout de todas as layers
- Como adicionar novas layers
- Sintaxe de behaviors, combos e macros
- Configurações do firmware
- Troubleshooting

📖 **[Layer 6 - Macros](docs/LAYER6_MACROS.md)** - Documentação completa das 36 macros:
- React (useState, useEffect, export, etc.)
- JavaScript/TypeScript (async, try/catch, arrow functions, etc.)
- Git (status, commit, push, pull, etc.)
- Docker (compose up/down, logs, ps, exec)
- Terminal (pnpm, npm, clear)
- Utilidades (console.log, TODO, comentários)

## Layout Resumido

```
Layer 0 (Base):        QWERTY padrão + hold-taps nos thumbs
Layer 1 (Símbolos):    Números (1-0) e símbolos de programação
Layer 2 (Nav):         Setas HJKL + Home/End/PgUp/PgDn
Layer 3 (Numpad):      Teclado numérico no lado direito (toggle)
Layer 4 (Sistema):     F1-F12 + Mídia + Bluetooth (toggle)
Layer 5 (Mouse):       Movimento + Cliques + Scroll (toggle)
Layer 6 (Macros Dev):  36 macros organizadas: React, JS/TS, Git, Docker, Terminal
```

**Acesso às Layers:**
- Layer 1: Momentary (segurar L1)
- Layer 2: Momentary (segurar ENT/L2)
- Layer 3: Toggle (L3 na Layer 0)
- Layer 4: Toggle (L4 na Layer 1)
- Layer 5: Toggle (L5 na Layer 2)
- Layer 6: Toggle (F12 na Layer 4)

## Teclas Especiais

| Tecla | Toque | Segurar |
|-------|-------|---------|
| ALT/SPC | Space | Alt |
| ENT/L2 | Enter | Layer 2 |

## Links Úteis

- [Documentação ZMK](https://zmk.dev/docs)
- [Keymap Editor Visual](https://nickcoutsos.github.io/keymap-editor/)
