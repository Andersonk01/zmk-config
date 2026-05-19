@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM Script para build local do firmware ZMK usando Docker
REM Usa o ZMK oficial e reaproveita um cache local
REM Requer Docker Desktop instalado e rodando

echo ========================================
echo   Build ZMK - Corne Keyboard
echo   (usando ZMK oficial)
echo ========================================
echo.

set "IMAGE=zmkfirmware/zmk-build-arm:stable"

REM Verificar se Docker está rodando
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Docker nao esta rodando ou nao esta instalado^!
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
    call :clone_official_zmk
    if errorlevel 1 goto :fail
    call :init_west_workspace
    if errorlevel 1 goto :fail
    call :export_zephyr_ignore_failure
) else (
    call :get_cache_remote
    if /I not "!CURRENT_REMOTE!"=="https://github.com/zmkfirmware/zmk.git" (
        echo [AVISO] O cache local aponta para outro fork.
        if defined CURRENT_REMOTE echo [AVISO] Remote atual: !CURRENT_REMOTE!
        echo [INFO] Recriando cache com o ZMK oficial...
        rmdir /s /q "%ZMK_CACHE%\zmk" >nul 2>&1
        call :clone_official_zmk
        if errorlevel 1 goto :fail
        call :init_west_workspace
        if errorlevel 1 goto :fail
    ) else (
        echo [INFO] Cache encontrado^! Atualizando repositorio...
        call :cleanup_stale_locks
        docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk %IMAGE% sh -c "git pull && west update"
        if errorlevel 1 (
            echo [AVISO] Falha ao atualizar na primeira tentativa, limpando locks e tentando novamente...
            call :cleanup_stale_locks
            docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk %IMAGE% sh -c "git pull && west update"
            if errorlevel 1 echo [AVISO] Falha ao atualizar, usando versao em cache...
        )
    )
    
    call :export_zephyr_strict
    if errorlevel 1 (
        echo [ERRO] Falha ao exportar Zephyr!
        goto :fail
    )
)

echo [OK] Repositorio ZMK pronto
echo.

REM Preparar arquivos de configuração
echo [INFO] Preparando arquivos de configuracao...
set CONFIG_DIR=%CURRENT_DIR%\config

REM Verificar se os arquivos existem
if not exist "%CONFIG_DIR%\corne_left.keymap" (
    echo [ERRO] Arquivo corne_left.keymap nao encontrado em %CONFIG_DIR%
    pause
    exit /b 1
)

echo [OK] Arquivos de configuracao encontrados
echo   - %CONFIG_DIR%\corne_left.keymap
echo   - %CONFIG_DIR%\corne_right.keymap
echo   - %CONFIG_DIR%\corne.conf
echo.

echo Compilando firmware para Corne...
echo.

call :cleanup_stale_build_dir

REM Build do lado esquerdo
REM -DZMK_CONFIG aponta para o diretório com os arquivos customizados
echo [1/3] Compilando lado ESQUERDO...
docker run --rm ^
  -v "%ZMK_CACHE%:/workspace" ^
  -v "%CONFIG_DIR%:/zmk-config" ^
  -w /workspace/zmk/app ^
  %IMAGE% ^
  bash -c "west build -p -b nice_nano/nrf52840/zmk -- -DSHIELD=corne_left -DZMK_CONFIG=/zmk-config"

if errorlevel 1 (
    echo [ERRO] Falha ao compilar lado esquerdo!
    goto :fail
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
        echo [OK] firmware\corne_left.uf2 criado ^(caminho alternativo^)
    )
)

echo.

REM Build do lado direito (teclado independente Corne R)
echo [2/3] Compilando lado DIREITO...
docker run --rm ^
  -v "%ZMK_CACHE%:/workspace" ^
  -v "%CONFIG_DIR%:/zmk-config" ^
  -w /workspace/zmk/app ^
  %IMAGE% ^
  bash -c "west build -p -b nice_nano/nrf52840/zmk -- -DSHIELD=corne_right -DZMK_CONFIG=/zmk-config"

if errorlevel 1 (
    echo [ERRO] Falha ao compilar lado direito!
    goto :fail
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
        echo [OK] firmware\corne_right.uf2 criado ^(caminho alternativo^)
    )
)

echo.

REM Build settings_reset (limpa pareamento split e perfis BT)
echo [3/3] Compilando SETTINGS RESET...
docker run --rm ^
  -v "%ZMK_CACHE%:/workspace" ^
  -w /workspace/zmk/app ^
  %IMAGE% ^
  bash -c "west build -p -b nice_nano/nrf52840/zmk -- -DSHIELD=settings_reset"

if errorlevel 1 (
    echo [ERRO] Falha ao compilar settings_reset!
    goto :fail
)

if exist "%ZMK_CACHE%\zmk\app\build\zephyr\zmk.uf2" (
    copy /Y "%ZMK_CACHE%\zmk\app\build\zephyr\zmk.uf2" "%CURRENT_DIR%\firmware\settings_reset.uf2" >nul
    echo [OK] firmware\settings_reset.uf2 criado
) else if exist "%ZMK_CACHE%\zmk\build\zephyr\zmk.uf2" (
    copy /Y "%ZMK_CACHE%\zmk\build\zephyr\zmk.uf2" "%CURRENT_DIR%\firmware\settings_reset.uf2" >nul
    echo [OK] firmware\settings_reset.uf2 criado ^(caminho alternativo^)
) else (
    echo [AVISO] Arquivo settings_reset nao encontrado apos build
)

echo.
echo ========================================
echo   Build concluido!
echo ========================================
echo.
echo Arquivos criados:
if exist "%CURRENT_DIR%\firmware\settings_reset.uf2" echo   - firmware\settings_reset.uf2  ^(flash nas DUAS metades primeiro^)
if exist "%CURRENT_DIR%\firmware\corne_left.uf2" echo   - firmware\corne_left.uf2
if exist "%CURRENT_DIR%\firmware\corne_right.uf2" echo   - firmware\corne_right.uf2
echo.
echo Ordem de flash (dois teclados independentes):
echo   1. settings_reset.uf2 em esquerda e direita
echo   2. corne_left.uf2 na esquerda, corne_right.uf2 na direita
echo   3. Emparelhe "Corne L" e "Corne R" separados no Bluetooth do PC
echo.
echo Pronto para flashear no nice!nano!
echo.
echo [INFO] Este firmware foi compilado com o ZMK oficial
echo.
pause
exit /b 0

:clone_official_zmk
echo [INFO] Clonando ZMK oficial ^(main branch^)...
echo [INFO] Isso pode levar alguns minutos ^(primeira vez^)...
docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace %IMAGE% sh -c "git clone --branch main https://github.com/zmkfirmware/zmk.git zmk"
if errorlevel 1 (
    echo [ERRO] Falha ao clonar o ZMK oficial^!
    exit /b 1
)
exit /b 0

:init_west_workspace
echo [INFO] Inicializando west workspace...
docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk %IMAGE% sh -c "west init -l app && west update"
if errorlevel 1 (
    echo [ERRO] Falha ao inicializar west^!
    exit /b 1
)
exit /b 0

:export_zephyr_ignore_failure
echo [INFO] Exportando Zephyr...
docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk %IMAGE% sh -c "west zephyr-export"
if errorlevel 1 echo [AVISO] Falha ao exportar Zephyr, continuando mesmo assim...
exit /b 0

:export_zephyr_strict
echo [INFO] Exportando Zephyr...
docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk %IMAGE% sh -c "west zephyr-export"
exit /b %ERRORLEVEL%

:get_cache_remote
set "CURRENT_REMOTE="
echo [INFO] Verificando origem do cache...
for /f "usebackq delims=" %%I in (`docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk %IMAGE% sh -c "git remote get-url origin 2>/dev/null"`) do (
    set "CURRENT_REMOTE=%%I"
)
exit /b 0

:cleanup_stale_locks
docker run --rm -v "%ZMK_CACHE%:/workspace" -w /workspace/zmk %IMAGE% python3 -c "from pathlib import Path; [p.unlink() for p in Path('/workspace/zmk').rglob('index.lock') if p.is_file()]"
exit /b 0

:cleanup_stale_build_dir
if exist "%ZMK_CACHE%\zmk\app\build" (
    echo [INFO] Limpando cache de build antigo...
    rmdir /s /q "%ZMK_CACHE%\zmk\app\build" >nul 2>&1
)
exit /b 0

:fail
pause
exit /b 1
