cd ..\src
fpc -Pi386 -dWIN32 -opntchk_w32_c.exe -B pntchk.pas
fpc -Pi386 -dWIN32 -opntchk_w32_b.exe -dBW -B pntchk.pas
fpc -Pi386 -dWIN32 -oexecbad_w32.exe -B execbad.pas
fpc -Pi386 -dWIN32 -oexecgood_w32.exe -B execgood.pas