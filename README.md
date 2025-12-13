# Corne Keyboard - ZMK Firmware

Configuração ZMK para teclado Corne com nice!nano v2.

## Estrutura

```
config/     - Arquivos de configuração (keymap, conf)
scripts/    - Scripts de build (build.bat, build.sh)
firmware/   - Firmware compilado (.uf2)
docs/       - Documentação completa
backup/     - Backups de configurações anteriores
```

## Build Rápido

**Windows:**
```
scripts\build.bat
```

**Linux/Mac/WSL:**
```
./scripts/build.sh
```

Os arquivos `.uf2` serão gerados em `firmware/`.

## Documentação

Ver [docs/README.md](docs/README.md) para documentação completa dos layers e keymaps.

