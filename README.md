# Corne Keyboard - ZMK Firmware

Configuração ZMK personalizada para teclado Corne com nice!nano v2.

## Funcionalidades

- **6 Layers**: Base, Símbolos, Navegação, Numpad, F-keys/Mídia, Mouse
- **9 Combos**: Copy, Paste, Undo, Redo, Save, Select All, Comment, Find, ESC
- **3 Macros**: Arrow Function, Console.log, Comment Block
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

## Layout Resumido

```
Layer 0 (Base):     QWERTY padrão + hold-taps nos thumbs
Layer 1 (Símbolos): Números (1-0) e símbolos de programação
Layer 2 (Nav):      Setas HJKL + Home/End/PgUp/PgDn
Layer 3 (Numpad):   Teclado numérico no lado direito
Layer 4 (F-keys):   F1-F12 + Mídia + Bluetooth
Layer 5 (Mouse):    Movimento + Cliques + Scroll
```

## Teclas Especiais

| Tecla | Toque | Segurar |
|-------|-------|---------|
| ALT/SPC | Space | Alt |
| ENT/L2 | Enter | Layer 2 |

## Links Úteis

- [Documentação ZMK](https://zmk.dev/docs)
- [Keymap Editor Visual](https://nickcoutsos.github.io/keymap-editor/)
