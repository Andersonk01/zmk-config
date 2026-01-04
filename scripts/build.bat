@echo off
REM Script para build local do firmware ZMK usando Docker
REM Usa o fork do urob com suporte a mouse keys
REM Requer Docker Desktop instalado e rodando

echo ========================================
echo   Build ZMK - Corne Keyboard
echo   (usando fork urob com mouse support)
echo ========================================
echo.

REM Verificar se Docker está rodando
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Docker nao esta rodando ou nao esta instalado!
    echo.
    echo Por favor:
    echo 1. Instale Docker Desktop: https://www.docker.com/products/docker-desktop
    echo 2. Certifique-se de que o Docker esta rodando
    echo.
    pause
    exit /b 1
)

echo [OK] Docker detectado
echo.

REM Obter o diretório do projeto (pasta pai do scripts/)
set SCRIPT_DIR=%~dp0
set PROJECT_DIR=%SCRIPT_DIR%..
cd /d "%PROJECT_DIR%"
set CURRENT_DIR=%cd%

REM Criar diretório firmware se não existir
if not exist "%CURRENT_DIR%\firmware" mkdir "%CURRENT_DIR%\firmware" >nul 2>&1

REM Usar diretório fixo para cache (evita reclonar sempre)
set ZMK_CACHE=%USERPROFILE%\.zmk-cache
if not exist "%ZMK_CACHE%" mkdir "%ZMK_CACHE%" >nul 2>&1

echo [INFO] Usando cache ZMK: %ZMK_CACHE%
echo.

REM Verificar se o repositório já existe, se não, clonar
if not exist "%ZMK_CACHE%\zmk\.git" (
    echo [INFO] Clonando fork do urob (main branch com mouse support)...
    echo [INFO] Isso pode levar alguns minutos (primeira vez)...
    docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace zmkfirmware/zmk-build-arm:stable sh -c "git clone --branch main https://github.com/urob/zmk.git zmk"
    
    if %ERRORLEVEL% NEQ 0 (
        echo [ERRO] Falha ao clonar o fork do urob!
        pause
        exit /b 1
    )
    
    echo [INFO] Inicializando west workspace...
    docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk zmkfirmware/zmk-build-arm:stable sh -c "west init -l app && west update"
    
    if %ERRORLEVEL% NEQ 0 (
        echo [ERRO] Falha ao inicializar west!
        pause
        exit /b 1
    )
    
    echo [INFO] Exportando Zephyr...
    docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk zmkfirmware/zmk-build-arm:stable sh -c "west zephyr-export" || echo [AVISO] Falha ao exportar Zephyr, continuando mesmo assim...
) else (
    echo [INFO] Cache encontrado! Atualizando repositorio...
    docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk zmkfirmware/zmk-build-arm:stable sh -c "git pull && west update" || echo [AVISO] Falha ao atualizar, usando versao em cache...
    
    echo [INFO] Exportando Zephyr...
    docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk zmkfirmware/zmk-build-arm:stable sh -c "west zephyr-export"
    
    if %ERRORLEVEL% NEQ 0 (
        echo [ERRO] Falha ao exportar Zephyr!
        pause
        exit /b 1
    )
)

echo [OK] Repositorio ZMK pronto
echo.

REM Preparar arquivos de configuração
echo [INFO] Preparando arquivos de configuracao...
set CONFIG_DIR=%CURRENT_DIR%\config

REM Verificar se os arquivos existem
if not exist "%CONFIG_DIR%\corne.keymap" (
    echo [ERRO] Arquivo corne.keymap nao encontrado em %CONFIG_DIR%
    pause
    exit /b 1
)

echo [OK] Arquivos de configuracao encontrados
echo   - %CONFIG_DIR%\corne.keymap
echo   - %CONFIG_DIR%\corne.conf
echo.

echo Compilando firmware para Corne...
echo.

REM Build do lado esquerdo
REM -DZMK_CONFIG aponta para o diretório com os arquivos customizados
echo [1/2] Compilando lado ESQUERDO...
docker run --rm ^
  -v "%ZMK_CACHE%:/workspace" ^
  -v "%CONFIG_DIR%:/zmk-config" ^
  -w /workspace/zmk/app ^
  -e ZEPHYR_BASE=/workspace/zmk/modules/zephyr/zephyr ^
  zmkfirmware/zmk-build-arm:stable ^
  bash -c "west build -p -b nice_nano_v2 -- -DSHIELD=corne_left -DZMK_CONFIG=/zmk-config -DCMAKE_PREFIX_PATH=/workspace/zmk/modules/zephyr/zephyr/share/zephyr-package/cmake"

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao compilar lado esquerdo!
    pause
    exit /b 1
)

REM Copiar e renomear o arquivo esquerdo
if exist "%ZMK_CACHE%\zmk\app\build\zephyr\zmk.uf2" (
    copy /Y "%ZMK_CACHE%\zmk\app\build\zephyr\zmk.uf2" "%CURRENT_DIR%\firmware\corne_left.uf2" >nul
    echo [OK] firmware\corne_left.uf2 criado
) else (
    echo [AVISO] Arquivo build\zephyr\zmk.uf2 nao encontrado
    echo [INFO] Verificando caminho alternativo...
    if exist "%ZMK_CACHE%\zmk\build\zephyr\zmk.uf2" (
        copy /Y "%ZMK_CACHE%\zmk\build\zephyr\zmk.uf2" "%CURRENT_DIR%\firmware\corne_left.uf2" >nul
        echo [OK] firmware\corne_left.uf2 criado (caminho alternativo)
    )
)

echo.

REM Build do lado direito
echo [2/2] Compilando lado DIREITO...
docker run --rm ^
  -v "%ZMK_CACHE%:/workspace" ^
  -v "%CONFIG_DIR%:/zmk-config" ^
  -w /workspace/zmk/app ^
  -e ZEPHYR_BASE=/workspace/zmk/modules/zephyr/zephyr ^
  zmkfirmware/zmk-build-arm:stable ^
  bash -c "west build -p -b nice_nano_v2 -- -DSHIELD=corne_right -DZMK_CONFIG=/zmk-config -DCMAKE_PREFIX_PATH=/workspace/zmk/modules/zephyr/zephyr/share/zephyr-package/cmake"

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao compilar lado direito!
    pause
    exit /b 1
)

REM Copiar e renomear o arquivo direito
if exist "%ZMK_CACHE%\zmk\app\build\zephyr\zmk.uf2" (
    copy /Y "%ZMK_CACHE%\zmk\app\build\zephyr\zmk.uf2" "%CURRENT_DIR%\firmware\corne_right.uf2" >nul
    echo [OK] firmware\corne_right.uf2 criado
) else (
    echo [AVISO] Arquivo build\zephyr\zmk.uf2 nao encontrado
    echo [INFO] Verificando caminho alternativo...
    if exist "%ZMK_CACHE%\zmk\build\zephyr\zmk.uf2" (
        copy /Y "%ZMK_CACHE%\zmk\build\zephyr\zmk.uf2" "%CURRENT_DIR%\firmware\corne_right.uf2" >nul
        echo [OK] firmware\corne_right.uf2 criado (caminho alternativo)
    )
)

echo.
echo ========================================
echo   Build concluido!
echo ========================================
echo.
echo Arquivos criados:
if exist "%CURRENT_DIR%\firmware\corne_left.uf2" echo   - firmware\corne_left.uf2
if exist "%CURRENT_DIR%\firmware\corne_right.uf2" echo   - firmware\corne_right.uf2
echo.
echo Pronto para flashear no nice!nano!
echo.
echo [INFO] Este firmware foi compilado com o fork do urob
echo        e inclui suporte completo a mouse keys (^&mmv, ^&mkp, ^&msc)
echo.
pause
