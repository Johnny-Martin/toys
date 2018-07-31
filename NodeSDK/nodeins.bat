[@echo](/user/echo) off
if "%1"=="" goto help
mkdir "%1"
mkdir "%1"\include

copy /y src\node.h "%1"\include
copy /y src\node_object_wrap.h "%1"\include
copy /y src\node_buffer.h "%1"\include
copy /y src\node_version.h "%1"\include

copy /y deps\v8\include\*.h "%1"\include\

copy /y deps\uv\include\*.h "%1"\include\

mkdir "%1"\include\uv-private
copy /y deps\uv\include\uv-private\*.h "%1"\include\uv-private

mkdir "%1"\include\ev
copy /y deps\uv\src\ev\*.h "%1"\include\ev

mkdir "%1"\include\c-ares
copy /y deps\uv\include\ares.h "%1"\include\c-ares
copy /y deps\uv\include\ares_version.h "%1"\include\c-ares

mkdir "%1"\lib
copy /y Release\node.lib "%1"\lib

copy /y Release\node.exe "%1"

echo =================================
echo Install succeefully!
goto exit

if not errorlevel 0 echo Error "install-path" & goto exit

:help
echo nodins.bat install-path

:exit