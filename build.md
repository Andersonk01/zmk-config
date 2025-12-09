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

REM Obter o diretório atual
set CURRENT_DIR=%cd%

REM Criar diretório temporário para o workspace ZMK
set TEMP_WORKSPACE=%TEMP%\zmk-build-%RANDOM%
mkdir "%TEMP_WORKSPACE%" >nul 2>&1

echo [INFO] Workspace temporario: %TEMP_WORKSPACE%
echo.

REM Clonar o fork do urob com mouse support
echo [INFO] Clonando fork do urob (main branch com mouse support)...
echo [INFO] Isso pode levar alguns minutos (primeira vez)...
docker run --rm -v "%TEMP_WORKSPACE%:/workspace" -w /workspace zmkfirmware/zmk-build-arm:stable sh -c "git clone --branch main https://github.com/urob/zmk.git zmk && cd zmk && west init -l app && west update"

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao clonar o fork do urob!
    rmdir /s /q "%TEMP_WORKSPACE%" >nul 2>&1
    pause
    exit /b 1
)

REM Exportar Zephyr
echo [INFO] Exportando Zephyr...
docker run --rm -v "%TEMP_WORKSPACE%:/workspace" -w /workspace/zmk zmkfirmware/zmk-build-arm:stable sh -c "west zephyr-export"

if %ERRORLEVEL% NEQ 0 (
    echo [AVISO] Falha ao exportar Zephyr, continuando mesmo assim...
)

echo [OK] Fork do urob clonado
echo.

REM Copiar arquivos de config
echo [INFO] Copiando arquivos de configuracao...
if not exist "%TEMP_WORKSPACE%\zmk\app\config" mkdir "%TEMP_WORKSPACE%\zmk\app\config" >nul 2>&1
xcopy /Y "%CURRENT_DIR%\config\*.conf" "%TEMP_WORKSPACE%\zmk\app\config\" >nul 2>&1
xcopy /Y "%CURRENT_DIR%\config\*.keymap" "%TEMP_WORKSPACE%\zmk\app\config\" >nul 2>&1

echo [OK] Arquivos de configuracao copiados
echo.

echo Compilando firmware para Corne...
echo.

REM Build do lado esquerdo
echo [1/2] Compilando lado ESQUERDO...
docker run --rm -v "%TEMP_WORKSPACE%:/workspace" -w /workspace/zmk/app zmkfirmware/zmk-build-arm:stable sh -c "source ../modules/zephyr/zephyr-env.sh && west build -p -b nice_nano_v2 -- -DSHIELD=corne_left"

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao compilar lado esquerdo!
    rmdir /s /q "%TEMP_WORKSPACE%" >nul 2>&1
    pause
    exit /b 1
)

REM Copiar e renomear o arquivo esquerdo
if exist "%TEMP_WORKSPACE%\zmk\app\build\zephyr\zmk.uf2" (
    copy /Y "%TEMP_WORKSPACE%\zmk\app\build\zephyr\zmk.uf2" "%CURRENT_DIR%\corne_left.uf2" >nul
    echo [OK] corne_left.uf2 criado
) else (
    echo [AVISO] Arquivo build\zephyr\zmk.uf2 nao encontrado
    echo [INFO] Verificando caminho alternativo...
    if exist "%TEMP_WORKSPACE%\zmk\build\zephyr\zmk.uf2" (
        copy /Y "%TEMP_WORKSPACE%\zmk\build\zephyr\zmk.uf2" "%CURRENT_DIR%\corne_left.uf2" >nul
        echo [OK] corne_left.uf2 criado (caminho alternativo)
    )
)

echo.

REM Build do lado direito
echo [2/2] Compilando lado DIREITO...
docker run --rm -v "%TEMP_WORKSPACE%:/workspace" -w /workspace/zmk/app zmkfirmware/zmk-build-arm:stable sh -c "source ../modules/zephyr/zephyr-env.sh && west build -p -b nice_nano_v2 -- -DSHIELD=corne_right"

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao compilar lado direito!
    rmdir /s /q "%TEMP_WORKSPACE%" >nul 2>&1
    pause
    exit /b 1
)

REM Copiar e renomear o arquivo direito
if exist "%TEMP_WORKSPACE%\zmk\app\build\zephyr\zmk.uf2" (
    copy /Y "%TEMP_WORKSPACE%\zmk\app\build\zephyr\zmk.uf2" "%CURRENT_DIR%\corne_right.uf2" >nul
    echo [OK] corne_right.uf2 criado
) else (
    echo [AVISO] Arquivo build\zephyr\zmk.uf2 nao encontrado
    echo [INFO] Verificando caminho alternativo...
    if exist "%TEMP_WORKSPACE%\zmk\build\zephyr\zmk.uf2" (
        copy /Y "%TEMP_WORKSPACE%\zmk\build\zephyr\zmk.uf2" "%CURRENT_DIR%\corne_right.uf2" >nul
        echo [OK] corne_right.uf2 criado (caminho alternativo)
    )
)

REM Limpar workspace temporário
echo.
echo [INFO] Limpando arquivos temporarios...
rmdir /s /q "%TEMP_WORKSPACE%" >nul 2>&1

echo.
echo ========================================
echo   Build concluido!
echo ========================================
echo.
echo Arquivos criados:
if exist "%CURRENT_DIR%\corne_left.uf2" echo   - corne_left.uf2
if exist "%CURRENT_DIR%\corne_right.uf2" echo   - corne_right.uf2
echo.
echo Pronto para flashear no nice!nano!
echo.
echo [INFO] Este firmware foi compilado com o fork do urob
echo        e inclui suporte completo a mouse keys (^&mmv, ^&mkp, ^&msc)
echo.
pause
