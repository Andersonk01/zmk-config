#!/bin/bash
# Script para build local do firmware ZMK usando Docker
# Funciona no Git Bash, WSL, Linux e Mac

echo "========================================"
echo "  Build ZMK - Corne Keyboard"
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

echo "Compilando firmware para Corne..."
echo ""

# Build do lado esquerdo
echo "[1/2] Compilando lado ESQUERDO..."
docker run --rm -v "$CURRENT_DIR:/zmk-config" -w /zmk-config \
  zmkfirmware/zmk-build-arm:2.5 \
  west build -p -b nice_nano_v2 -- -DSHIELD=corne_left

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado esquerdo!"
    exit 1
fi

# Copiar e renomear o arquivo esquerdo
if [ -f "build/zephyr/zmk.uf2" ]; then
    cp "build/zephyr/zmk.uf2" "corne_left.uf2"
    echo "[OK] corne_left.uf2 criado"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

echo ""

# Build do lado direito
echo "[2/2] Compilando lado DIREITO..."
docker run --rm -v "$CURRENT_DIR:/zmk-config" -w /zmk-config \
  zmkfirmware/zmk-build-arm:2.5 \
  west build -p -b nice_nano_v2 -- -DSHIELD=corne_right

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao compilar lado direito!"
    exit 1
fi

# Copiar e renomear o arquivo direito
if [ -f "build/zephyr/zmk.uf2" ]; then
    cp "build/zephyr/zmk.uf2" "corne_right.uf2"
    echo "[OK] corne_right.uf2 criado"
else
    echo "[AVISO] Arquivo build/zephyr/zmk.uf2 não encontrado"
fi

echo ""
echo "========================================"
echo "  Build concluído!"
echo "========================================"
echo ""
echo "Arquivos criados:"
[ -f "corne_left.uf2" ] && echo "  - corne_left.uf2"
[ -f "corne_right.uf2" ] && echo "  - corne_right.uf2"
echo ""
echo "Pronto para flashear no nice!nano!"
echo ""

