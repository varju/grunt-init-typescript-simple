@echo on
tsc --module amd --target ES3 %1
if %ERRORLEVEL% == 0 grunt post-tscompile
grunt clean:tsjs
