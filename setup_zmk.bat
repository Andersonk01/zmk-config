@echo off
REM Script auxiliar para executar o setup do ZMK no Windows
REM Execute este arquivo ou use Git Bash diretamente

echo ========================================
echo   Setup ZMK para nice!nano
echo ========================================
echo.
echo Este script precisa ser executado no Git Bash.
echo.
echo Por favor, abra o Git Bash e execute:
echo.
echo   bash -c "$(curl -fsSL https://zmk.dev/setup.sh)"
echo.
echo Ou navegue ate este diretorio e execute:
echo   bash setup_zmk.sh
echo.
echo.
echo Pressione qualquer tecla para abrir o Git Bash...
pause >nul

REM Tentar abrir Git Bash se disponivel
where bash >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Abrindo Git Bash...
    bash
) else (
    echo Git Bash nao encontrado no PATH.
    echo Por favor, abra o Git Bash manualmente.
    pause
)

