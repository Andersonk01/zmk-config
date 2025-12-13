# Build ZMK sem Docker (Windows)

## ⚠️ Aviso
Build sem Docker é **muito mais complexo** e requer instalação manual de muitas dependências. O Docker é **altamente recomendado**.

## Requisitos

1. **ARM GNU Toolchain**
   - Download: https://developer.arm.com/downloads/-/gnu-rm
   - Adicionar ao PATH: `C:\Program Files (x86)\GNU Arm Embedded Toolchain\10 2021.10\bin`

2. **Python 3.8+**
   - Download: https://www.python.org/downloads/
   - Instalar com "Add Python to PATH"

3. **West**
   ```bash
   pip install west
   ```

4. **CMake 3.20+**
   - Download: https://cmake.org/download/
   - Adicionar ao PATH

5. **Ninja**
   - Download: https://github.com/ninja-build/ninja/releases
   - Adicionar ao PATH

6. **Git**
   - Download: https://git-scm.com/download/win

## Passos para Build

1. **Clone o ZMK:**
   ```bash
   git clone https://github.com/zmkfirmware/zmk.git
   cd zmk
   ```

2. **Inicialize o workspace:**
   ```bash
   west init -l app/
   west update
   ```

3. **Exporte o Zephyr:**
   ```bash
   west zephyr-export
   ```

4. **Configure o ambiente:**
   ```bash
   cd app
   source ../modules/zephyr/zephyr-env.sh
   ```

5. **Copie seus arquivos de config:**
   ```bash
   cp -r /caminho/para/seu/config/* config/
   ```

6. **Build:**
   ```bash
   west build -p -b nice_nano_v2 -- -DSHIELD=corne_left -DZMK_CONFIG=config
   west build -p -b nice_nano_v2 -- -DSHIELD=corne_right -DZMK_CONFIG=config
   ```

7. **Encontre os arquivos .uf2:**
   ```
   app/build/zephyr/zmk.uf2
   ```

## Problemas Comuns

- **Erro "Zephyr not found"**: Execute `west zephyr-export`
- **Erro "ARM toolchain not found"**: Verifique o PATH
- **Erro "CMake not found"**: Instale CMake e adicione ao PATH

## Recomendação

**Use Docker!** É muito mais simples e confiável. O `build.bat` fornecido usa Docker e funciona imediatamente.

