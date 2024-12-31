@echo off
setlocal enabledelayedexpansion

:: Inicio del script
:inicio
cls
echo ================================================
echo Descargador de canciones de YouTube
echo ================================================
echo.
echo Opciones de formato disponibles:
echo 1. MP3 (audio)
echo 2. M4A (audio)
echo 3. MP4 (video)
echo.
set /p formato="Elige el formato de salida (1=MP3, 2=M4A, 3=MP4, salir para terminar): "

:: Verificar si el usuario quiere salir
if /i "%formato%"=="salir" goto fin

:: Asignar el formato y la extensión de acuerdo con la opción seleccionada
if "%formato%"=="1" set "audio_format=mp3" & set "extension=mp3"
if "%formato%"=="2" set "audio_format=m4a" & set "extension=m4a"
if "%formato%"=="3" set "audio_format=mp4" & set "extension=mp4"

:: Validar opción seleccionada
if not defined audio_format (
    echo Opcion invalida. Intenta nuevamente.
    timeout /t 2 >nul
    goto inicio
)

:: Solicitar la URL del video
set /p videoURL="Ingresa la URL del video (o escribe 'salir' para terminar): "
if /i "%videoURL%"=="salir" goto fin

:: Paso 1: Descargar el video en el formato seleccionado
cls
echo ================================================
echo Descargando y convirtiendo el video...
echo ================================================
yt-dlp -o "C:\Users\josep\Music\%%(title)s.%%(ext)s" ^
       "%videoURL%" ^
       -x --audio-format %audio_format% ^
       --ffmpeg-location "C:\ffmpeg\bin" ^
       --restrict-filenames

:: Obtener el nombre del archivo descargado
for /f "delims=" %%A in ('yt-dlp --get-filename -o "C:\Users\josep\Music\%%(title)s.%extension%" "%videoURL%" --restrict-filenames') do set "downloadedFile=%%A"

:: Extraer solo el nombre del archivo sin la ruta
for %%F in ("%downloadedFile%") do set "fileName=%%~nF"

:: Paso 2: Renombrar el archivo si el usuario lo desea
call :renombrar_archivo "%fileName%" "%extension%"

:: Paso 3: Confirmar descarga exitosa
cls
echo ================================================
echo Descarga completada con exito.
echo Archivo: "%nuevoTituloFinal%.%extension%"
echo ================================================

:: Preguntar si abrir el archivo descargado o continuar
set /p opcion="¿Quieres abrir el archivo descargado? (s/n): "
if /i "%opcion%"=="s" (
    start "" "C:\Users\josep\Music\%nuevoTituloFinal%.%extension%"
)

echo.
echo Volviendo al inicio...
timeout /t 2 >nul
goto inicio

:: Función para renombrar archivo
:renombrar_archivo
set "originalTitulo=%~1"
set "extension=%~2"

cls
echo ================================================
echo Paso 2: Renombrar archivo
echo ================================================
echo Nombre actual: "%originalTitulo%.%extension%"
echo.
set /p opcion="Elige una opcion (m=mantener / c=cambiar): "
if /i "%opcion%"=="m" (
    set "nuevoTitulo=%originalTitulo%"
) else (
    set /p nuevoTitulo="Ingresa el nuevo titulo (sin extension): "
)

:: Renombrar el archivo
ren "C:\Users\josep\Music\%originalTitulo%.%extension%" "%nuevoTitulo%.%extension%"
set "nuevoTituloFinal=%nuevoTitulo%"
goto :eof

:: Fin del script
:fin
cls
echo Gracias por usar el descargador. ¡Hasta luego!
timeout /t 2 >nul
endlocal
exit /b
