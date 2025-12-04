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

# Criar diretório temporário para o workspace ZMK
TEMP_WORKSPACE=$(mktemp -d)
echo "[INFO] Workspace temporário: $TEMP_WORKSPACE"
echo ""

# Clonar o fork do urob com mouse support
echo "[INFO] Clonando fork do urob (main branch com mouse support)..."
echo "[INFO] Isso pode levar alguns minutos (primeira vez)..."
docker run --rm -v "$TEMP_WORKSPACE:/workspace" -w /workspace \
  zmkfirmware/zmk-build-arm:stable sh -c "
    git clone --branch main https://github.com/urob/zmk.git zmk
    cd zmk
    west init -l app
    west update
  "

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao clonar o fork do urob!"
    rm -rf "$TEMP_WORKSPACE"
    exit 1
fi

# Exportar Zephyr
echo "[INFO] Exportando Zephyr..."
docker run --rm -v "$TEMP_WORKSPACE:/workspace" -w /workspace/zmk \
  zmkfirmware/zmk-build-arm:stable sh -c "west zephyr-export" || echo "[AVISO] Falha ao exportar Zephyr, continuando mesmo assim..."

echo "[OK] Fork do urob clonado"
echo ""

# Copiar arquivos de configuração
echo "[INFO] Copiando arquivos de configuração..."
mkdir -p "$TEMP_WORKSPACE/zmk/app/config"
cp -r "$CURRENT_DIR/config"/* "$TEMP_WORKSPACE/zmk/app/config/" 2>/dev/null || \
cp "$CURRENT_DIR/config/corne.conf" "$TEMP_WORKSPACE/zmk/app/config/" && \
cp "$CURRENT_DIR/config/corne.keymap" "$TEMP_WORKSPACE/zmk/app/config/"

echo "[OK] Arquivos de configuração copiados"
echo ""

echo "Compilando firmware para Corne..."
echo ""

# Build do lado esquerdo
echo "[1/2] Compilando lado ESQUERDO..."
docker run --rm -v "$TEMP_WORKSPACE:/workspace" -w /workspace/zmk/app \
  zmkfirmware/zmk-build-arm:stable \
  sh -c "source ../modules/zephyr/zephyr-env.sh && west build -p -b nice_nano_v2 -- -DSHIELD=corne_left"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado esquerdo!"
    rm -rf "$TEMP_WORKSPACE"
    exit 1
fi

# Copiar e renomear o arquivo esquerdo
if [ -f "$TEMP_WORKSPACE/zmk/app/build/zephyr/zmk.uf2" ]; then
    cp "$TEMP_WORKSPACE/zmk/app/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_left.uf2"
    echo "[OK] corne_left.uf2 criado"
elif [ -f "$TEMP_WORKSPACE/zmk/build/zephyr/zmk.uf2" ]; then
    cp "$TEMP_WORKSPACE/zmk/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_left.uf2"
    echo "[OK] corne_left.uf2 criado (caminho alternativo)"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

echo ""

# Build do lado direito
echo "[2/2] Compilando lado DIREITO..."
docker run --rm -v "$TEMP_WORKSPACE:/workspace" -w /workspace/zmk/app \
  zmkfirmware/zmk-build-arm:stable \
  sh -c "source ../modules/zephyr/zephyr-env.sh && west build -p -b nice_nano_v2 -- -DSHIELD=corne_right"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado direito!"
    rm -rf "$TEMP_WORKSPACE"
    exit 1
fi

# Copiar e renomear o arquivo direito
if [ -f "$TEMP_WORKSPACE/zmk/app/build/zephyr/zmk.uf2" ]; then
    cp "$TEMP_WORKSPACE/zmk/app/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_right.uf2"
    echo "[OK] corne_right.uf2 criado"
elif [ -f "$TEMP_WORKSPACE/zmk/build/zephyr/zmk.uf2" ]; then
    cp "$TEMP_WORKSPACE/zmk/build/zephyr/zmk.uf2" "$CURRENT_DIR/corne_right.uf2"
    echo "[OK] corne_right.uf2 criado (caminho alternativo)"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

# Limpar workspace temporário
echo ""
echo "[INFO] Limpando arquivos temporários..."
rm -rf "$TEMP_WORKSPACE"

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

