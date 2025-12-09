#!/bin/bash
# Script para build local do firmware ZMK usando Docker
# Usa o fork do urob com suporte a mouse keys
# Funciona no Git Bash, WSL, Linux e Mac

echo "========================================"
echo "  Build ZMK - Corne Keyboard"
echo "  (usando fork urob com mouse support)"
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

# Obter o diretório atual
CURRENT_DIR=$(pwd)

# Usar diretório fixo para cache (evita reclonar sempre)
ZMK_CACHE="$HOME/.zmk-cache"
mkdir -p "$ZMK_CACHE"

echo "[INFO] Usando cache ZMK: $ZMK_CACHE"
echo ""

# Verificar se o repositório já existe, se não, clonar
if [ ! -d "$ZMK_CACHE/zmk/.git" ]; then
    echo "[INFO] Clonando fork do urob (main branch com mouse support)..."
    echo "[INFO] Isso pode levar alguns minutos (primeira vez)..."
    docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace \
      zmkfirmware/zmk-build-arm:stable sh -c "git clone --branch main https://github.com/urob/zmk.git zmk"
    
    if [ $? -ne 0 ]; then
        echo "[ERRO] Falha ao clonar o fork do urob!"
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
fi

echo "[OK] Repositório ZMK pronto"
echo ""

# Copiar arquivos de configuração
echo "[INFO] Copiando arquivos de configuração..."
mkdir -p "$ZMK_CACHE/zmk/app/config"
cp -r "$CURRENT_DIR/config"/* "$ZMK_CACHE/zmk/app/config/" 2>/dev/null || \
cp "$CURRENT_DIR/config/corne.conf" "$ZMK_CACHE/zmk/app/config/" && \
cp "$CURRENT_DIR/config/corne.keymap" "$ZMK_CACHE/zmk/app/config/"

echo "[OK] Arquivos de configuração copiados"
echo ""

echo "Compilando firmware para Corne..."
echo ""

# Build do lado esquerdo
echo "[1/2] Compilando lado ESQUERDO..."
docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk/app \
  zmkfirmware/zmk-build-arm:stable \
  sh -c "source ../modules/zephyr/zephyr-env.sh && west build -p -b nice_nano_v2 -- -DSHIELD=corne_left"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado esquerdo!"
    exit 1
fi

# Copiar e renomear o arquivo esquerdo
if [ -f "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_left.uf2"
    echo "[OK] corne_left.uf2 criado"
elif [ -f "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_left.uf2"
    echo "[OK] corne_left.uf2 criado (caminho alternativo)"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

echo ""

# Build do lado direito
echo "[2/2] Compilando lado DIREITO..."
docker run --rm -v "$ZMK_CACHE:/workspace" -w /workspace/zmk/app \
  zmkfirmware/zmk-build-arm:stable \
  sh -c "source ../modules/zephyr/zephyr-env.sh && west build -p -b nice_nano_v2 -- -DSHIELD=corne_right"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado direito!"
    exit 1
fi

# Copiar e renomear o arquivo direito
if [ -f "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/app/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_right.uf2"
    echo "[OK] corne_right.uf2 criado"
elif [ -f "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" ]; then
    cp "$ZMK_CACHE/zmk/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_right.uf2"
    echo "[OK] corne_right.uf2 criado (caminho alternativo)"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

echo ""
echo "========================================"
echo "  Build concluído!"
echo "========================================"
echo ""
echo "Arquivos criados:"
[ -f "$CURRENT_DIR/corne_left.uf2" ] && echo "  - corne_left.uf2"
[ -f "$CURRENT_DIR/corne_right.uf2" ] && echo "  - corne_right.uf2"
echo ""
echo "Pronto para flashear no nice!nano!"
echo ""
echo "[INFO] Este firmware foi compilado com o fork do urob"
echo "       e inclui suporte completo a mouse keys (&mmv, &mkp, &msc)"
echo ""

