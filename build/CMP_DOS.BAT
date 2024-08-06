cd ..\src
fpc -o..\bin\dos32\pntchkp.exe -B pntchk.pas
fpc -o..\bin\dos32\execbad.exe -B execbad.pas
fpc -o..\bin\dos32\execgood.exe -B execgood.pas
del /y ..\bin\dos32\*.o
del /y ..\bin\dos32\*.ppu


