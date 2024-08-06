cd ..\src
fpc -Px86_64 -dWIN64 -opntchk_w64_c.exe -B pntchk.pas 
fpc -Px86_64 -dWIN64 -opntchk_w64_b.exe -B -dBW pntchk.pas
fpc -Px86_64 -dWIN64 -oexecbad_w64.exe -B execbad.pas 
fpc -Px86_64 -dWIN64 -oexecgood_w64.exe -B execgood.pas 