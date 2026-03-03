@echo off
REM ============================================================
REM  Generación masiva de anuarios: desde 2000 hasta el último
REM  año cerrado (año actual - 1).
REM  Ejecutar desde la carpeta fichas\
REM ============================================================

setlocal enabledelayedexpansion

REM Año actual
for /f "tokens=1 delims=/" %%a in ('wmic os get localdatetime /value ^| find "="') do (
    set dt=%%a
)
set CURRENT_YEAR=%date:~6,4%
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value ^| findstr LocalDateTime') do set dt=%%a
set CURRENT_YEAR=%dt:~0,4%
set /a LAST_YEAR=%CURRENT_YEAR% - 1

set START_YEAR=2000

echo ============================================================
echo   GENERACION MASIVA DE ANUARIOS
echo   Rango: %START_YEAR% - %LAST_YEAR%
echo   Ano actual: %CURRENT_YEAR% (excluido, no cerrado)
echo ============================================================
echo.

for /l %%Y in (%START_YEAR%, 1, %LAST_YEAR%) do (
    echo.
    echo ************************************************************
    echo   Procesando ano %%Y
    echo ************************************************************
    python generate.py %%Y
    if errorlevel 1 (
        echo   [ERROR] Fallo ao xerar anuario %%Y
    ) else (
        echo   [OK] Anuario %%Y completado
    )
)

echo.
echo ============================================================
echo   PROCESO FINALIZADO
echo   Anuarios xerados en: output\
echo ============================================================
pause
