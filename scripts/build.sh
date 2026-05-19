#!/bin/bash
# Script para build local do firmware ZMK usando Docker
# Usa o ZMK oficial e reaproveita um cache local
# Funciona no Git Bash, WSL, Linux e Mac

echo "========================================"
echo "  Build ZMK - Corne Keyboard"
echo "  (usando ZMK oficial)"
echo "========================================"
echo ""

# Evita conversão automática de paths do Git Bash ao chamar Docker no Windows.
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL="*"

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "[ERRO] Docker não está rodando ou não está instalado!"
    echo ""
    echo "Por favor:"
    echo "1. Instale Docker Desktop: https://www.docker.com/products/docker-desktop"
    echo "2. Certifique-se de que o Docker está rodando"
    echo ""
    exit 1
fi

echo "[OK] Docker detectado"
echo ""

# Obter o diretório do projeto (pasta pai do scripts/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"
CURRENT_DIR="$PROJECT_DIR"

# Criar diretório firmware se não existir
mkdir -p "$CURRENT_DIR/firmware"

# Usar diretório fixo para cache (evita reclonar sempre)
ZMK_CACHE="$HOME/.zmk-cache"
mkdir -p "$ZMK_CACHE"

echo "[INFO] Usando cache ZMK: $ZMK_CACHE"
echo ""

# Verificar se o repositório já existe, se não, clonar
if [ -d "$ZMK_CACHE/zmk/.git" ]; then
    CURRENT_REMOTE=$(docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
      zmkfirmware/zmk-build-arm:stable sh -c "git remote get-url origin" 2>/dev/null || true)

    if [ "$CURRENT_REMOTE" != "https://github.com/zmkfirmware/zmk.git" ]; then
        echo "[AVISO] Cache local aponta para outro fork:"
        echo "        $CURRENT_REMOTE"
        echo "[INFO] Recriando cache com o ZMK oficial..."
        rm -rf "$ZMK_CACHE/zmk"
    fi
fi

if [ ! -d "$ZMK_CACHE/zmk/.git" ]; then
    echo "[INFO] Clonando ZMK oficial (main branch)..."
    echo "[INFO] Isso pode levar alguns minutos (primeira vez)..."
    docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace \
      zmkfirmware/zmk-build-arm:stable sh -c "git clone --branch main https://github.com/zmkfirmware/zmk.git zmk"
    
    if [ $? -ne 0 ]; then
        echo "[ERRO] Falha ao clonar o ZMK!"
        exit 1
    fi
    
    echo "[INFO] Inicializando west workspace..."
    docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
      zmkfirmware/zmk-build-arm:stable sh -c "west init -l app && west update"
    
    if [ $? -ne 0 ]; then
        echo "[ERRO] Falha ao inicializar west!"
        exit 1
    fi
    
    echo "[INFO] Exportando Zephyr..."
    docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
      zmkfirmware/zmk-build-arm:stable sh -c "west zephyr-export" || echo "[AVISO] Falha ao exportar Zephyr, continuando mesmo assim..."
else
    echo "[INFO] Cache encontrado! Atualizando repositório..."
    docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
      zmkfirmware/zmk-build-arm:stable python3 -c "from pathlib import Path; [p.unlink() for p in Path('/workspace/zmk').rglob('index.lock') if p.is_file()]"
    docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
      zmkfirmware/zmk-build-arm:stable sh -c "git pull && west update" || {
        echo "[AVISO] Falha ao atualizar na primeira tentativa, limpando locks e tentando novamente..."
        docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
          zmkfirmware/zmk-build-arm:stable python3 -c "from pathlib import Path; [p.unlink() for p in Path('/workspace/zmk').rglob('index.lock') if p.is_file()]"
        docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
          zmkfirmware/zmk-build-arm:stable sh -c "git pull && west update" || echo "[AVISO] Falha ao atualizar, usando versão em cache..."
      }
    
    echo "[INFO] Exportando Zephyr..."
    docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk \
      zmkfirmware/zmk-build-arm:stable sh -c "west zephyr-export"
    
    if [ $? -ne 0 ]; then
        echo "[ERRO] Falha ao exportar Zephyr!"
        exit 1
    fi
fi

echo "[OK] Repositório ZMK pronto"
echo ""

# Copiar arquivos de configuração para diretório que será montado
echo "[INFO] Preparando arquivos de configuração..."
CONFIG_DIR="$CURRENT_DIR/config"

# Verificar se os arquivos existem
if [ ! -f "$CONFIG_DIR/corne_left.keymap" ]; then
    echo "[ERRO] Arquivo corne_left.keymap não encontrado em $CONFIG_DIR"
    exit 1
fi

echo "[OK] Arquivos de configuração encontrados"
echo "  - $CONFIG_DIR/corne_left.keymap"
echo "  - $CONFIG_DIR/corne_right.keymap"
echo "  - $CONFIG_DIR/corne.conf"
echo ""

echo "Compilando firmware para Corne..."
echo ""

# Remove cache de build antigo para evitar paths obsoletos do Zephyr.
rm -rf "$ZMK_CACHE/zmk/app/build"

# Build do lado esquerdo
# -DZMK_CONFIG aponta para o diretório com os arquivos customizados
echo "[1/3] Compilando lado ESQUERDO..."
docker run --rm \
  -v "$ZMK_CACHE:/workspace" \
  -v "$CONFIG_DIR:/zmk-config" \
  -w /workspace/zmk/app \
  zmkfirmware/zmk-build-arm:stable \
  bash -c "west build -p -b nice_nano/nrf52840/zmk -- -DSHIELD=corne_left -DZMK_CONFIG=/zmk-config"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado esquerdo!"
    exit 1
fi

# Copiar e renomear o arquivo esquerdo
if [ -f "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" "$CURRENT_DIR/firmware/corne_left.uf2"
    echo "[OK] firmware/corne_left.uf2 criado"
elif [ -f "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" "$CURRENT_DIR/firmware/corne_left.uf2"
    echo "[OK] firmware/corne_left.uf2 criado (caminho alternativo)"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

echo ""

echo "[2/3] Compilando lado DIREITO..."
docker run --rm \
  -v "$ZMK_CACHE:/workspace" \
  -v "$CONFIG_DIR:/zmk-config" \
  -w /workspace/zmk/app \
  zmkfirmware/zmk-build-arm:stable \
  bash -c "west build -p -b nice_nano/nrf52840/zmk -- -DSHIELD=corne_right -DZMK_CONFIG=/zmk-config"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado direito!"
    exit 1
fi

# Copiar e renomear o arquivo direito
if [ -f "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" "$CURRENT_DIR/firmware/corne_right.uf2"
    echo "[OK] firmware/corne_right.uf2 criado"
elif [ -f "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" "$CURRENT_DIR/firmware/corne_right.uf2"
    echo "[OK] firmware/corne_right.uf2 criado (caminho alternativo)"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

echo ""

# settings_reset não usa keymap; só apaga NVS (pareamento split + BT)
echo "[3/3] Compilando SETTINGS RESET..."
docker run --rm \
  -v "$ZMK_CACHE:/workspace" \
  -w /workspace/zmk/app \
  zmkfirmware/zmk-build-arm:stable \
  bash -c "west build -p -b nice_nano/nrf52840/zmk -- -DSHIELD=settings_reset"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar settings_reset!"
    exit 1
fi

if [ -f "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" "$CURRENT_DIR/firmware/settings_reset.uf2"
    echo "[OK] firmware/settings_reset.uf2 criado"
elif [ -f "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" "$CURRENT_DIR/firmware/settings_reset.uf2"
    echo "[OK] firmware/settings_reset.uf2 criado (caminho alternativo)"
else
    echo "[AVISO] Arquivo settings_reset não encontrado após build"
fi

echo ""
echo "========================================"
echo "  Build concluído!"
echo "========================================"
echo ""
echo "Arquivos criados:"
[ -f "$CURRENT_DIR/firmware/settings_reset.uf2" ] && echo "  - firmware/settings_reset.uf2  (flash nas DUAS metades primeiro)"
[ -f "$CURRENT_DIR/firmware/corne_left.uf2" ] && echo "  - firmware/corne_left.uf2"
[ -f "$CURRENT_DIR/firmware/corne_right.uf2" ] && echo "  - firmware/corne_right.uf2"
echo ""
echo "Ordem de flash (dois teclados independentes):"
echo "  1. settings_reset.uf2 em esquerda e direita"
echo "  2. corne_left.uf2 na esquerda, corne_right.uf2 na direita"
echo "  3. Emparelhe Corne L e Corne R separados no Bluetooth do PC"
echo ""
echo "Pronto para flashear no nice!nano!"
echo ""
echo "[INFO] Este firmware foi compilado com o ZMK oficial"
echo ""

