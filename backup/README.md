# Backup das Configurações Antigas

Esta pasta contém as versões antigas dos arquivos de configuração antes das alterações para suporte a mouse keys.

## Arquivos salvos:

- **corne.keymap.old**: Versão antiga do keymap (usava `#include <dt-bindings/zmk/mouse.h>` e sintaxe `&kp MS_U`, `&kp MB_L`, etc.)
- **corne.conf.old**: Versão antiga do arquivo de configuração (usava `CONFIG_ZMK_MOUSE=y`)

## Como restaurar:

Se precisar voltar às configurações antigas, você pode:

1. **Copiar os arquivos de volta:**
   ```bash
   copy backup\corne.keymap.old config\corne.keymap
   copy backup\corne.conf.old config\corne.conf
   ```

2. **Ou usar git para restaurar:**
   ```bash
   git checkout HEAD -- config/corne.keymap config/corne.conf
   ```

## Data do backup:
Criado antes da compilação com as novas configurações de mouse keys (pointing).

## Mudanças realizadas:

### corne.keymap:
- Header alterado de `mouse.h` para `pointing.h`
- Sintaxe das mouse keys atualizada:
  - `&kp MS_U/MS_L/MS_D/MS_R` → `&mmv MOVE_UP/MOVE_LEFT/MOVE_DOWN/MOVE_RIGHT`
  - `&kp MB_L/MB_M/MB_R` → `&mkp LCLK/MCLK/RCLK`
  - `&kp WH_U/WH_D` → `&mwh WH_UP/WH_DN`

### corne.conf:
- Configuração alterada de `CONFIG_ZMK_MOUSE=y` para `CONFIG_ZMK_POINTING=y`

