#!/bin/bash
# Script para build local do firmware ZMK usando Docker
# Usa o ZMK OFICIAL
# Funciona no Git Bash, WSL, Linux e Mac

echo "========================================"
echo "  Build ZMK - Corne Keyboard"
echo "  (usando ZMK oficial)"
echo "========================================"
echo ""

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
      zmkfirmware/zmk-build-arm:stable sh -c "git pull && west update" || echo "[AVISO] Falha ao atualizar, usando versão em cache..."
    
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

# Copiar arquivos de configuração
echo "[INFO] Copiando arquivos de configuração..."
docker run --rm -v "$ZMK_CACHE:/workspace" -v "$CURRENT_DIR/config:/config" \
  zmkfirmware/zmk-build-arm:stable sh -c "rm -rf /workspace/zmk/app/config && mkdir -p /workspace/zmk/app/config && cp /config/corne.conf /config/corne.keymap /workspace/zmk/app/config/"

echo "[OK] Arquivos de configuração copiados"
echo ""

echo "Compilando firmware para Corne..."
echo ""

# Build do lado esquerdo
echo "[1/2] Compilando lado ESQUERDO..."
docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk/app \
  -e ZEPHYR_BASE=/workspace/zmk/modules/zephyr/zephyr \
  zmkfirmware/zmk-build-arm:stable \
  bash -c "west build -p -b nice_nano_v2 -- -DSHIELD=corne_left -DCMAKE_PREFIX_PATH=/workspace/zmk/modules/zephyr/zephyr/share/zephyr-package/cmake"

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

# Build do lado direito
echo "[2/2] Compilando lado DIREITO..."
docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk/app \
  -e ZEPHYR_BASE=/workspace/zmk/modules/zephyr/zephyr \
  zmkfirmware/zmk-build-arm:stable \
  bash -c "west build -p -b nice_nano_v2 -- -DSHIELD=corne_right -DCMAKE_PREFIX_PATH=/workspace/zmk/modules/zephyr/zephyr/share/zephyr-package/cmake"

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
echo "========================================"
echo "  Build concluído!"
echo "========================================"
echo ""
echo "Arquivos criados:"
[ -f "$CURRENT_DIR/firmware/corne_left.uf2" ] && echo "  - firmware/corne_left.uf2"
[ -f "$CURRENT_DIR/firmware/corne_right.uf2" ] && echo "  - firmware/corne_right.uf2"
echo ""
echo "Pronto para flashear no nice!nano!"
echo ""
echo "[INFO] Este firmware foi compilado com o ZMK oficial"
echo ""

