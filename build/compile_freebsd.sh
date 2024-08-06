cd ../src
fpc -Px86_64 -o../bin/freebsd64/pntchk_c.bsd -B pntchk.pas 
fpc -Px86_64 -o../bin/freebsd64/pntchk_b.bsd -dBW -B pntchk.pas 
fpc -Px86_64 -o../bin/freebsd64/execbad -B execbad.pas 
fpc -Px86_64 -o../bin/freebsd64/execgood -B execgood.pas 
fpc -Pi386 -o../bin/freebsd32/pntchk_c.bsd -B pntchk.pas 
fpc -Pi386 -o../bin/freebsd32/pntchk_b.bsd -dBW -B pntchk.pas 
fpc -Pi386 -o../bin/freebsd32/execbad -B execbad.pas 
fpc -Pi386 -o../bin/freebsd32/execgood -B execgood.pas 
rm -f ../bin/freebsd32/*.o
rm -f ../bin/freebsd32/*.ppu
rm -f ../bin/freebsd64/*.o
rm -f ../bin/freebsd64/*.ppu
