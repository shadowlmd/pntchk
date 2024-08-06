cd ../src
fpc -Px86_64 -o../bin/linux64/pntchk_c.lnx -B pntchk.pas
fpc -Px86_64 -o../bin/linux64/pntchk_b.lnx -dBW -B pntchk.pas
fpc -Px86_64 -o../bin/linux64/execbad -B execbad.pas
fpc -Px86_64 -o../bin/linux64/execgood -B execgood.pas
fpc -Pi386 -o../bin/linux32/pntchk_c.lnx -B pntchk.pas
fpc -Pi386 -o../bin/linux32/pntchk_b.lnx -dBW -B pntchk.pas
fpc -Pi386 -o../bin/linux32/execbad -B execbad.pas
fpc -Pi386 -o../bin/linux32/execgood -B execgood.pas
rm -f ../bin/linux32/*.o
rm -f ../bin/linux32/*.ppu
rm -f ../bin/linux64/*.o
rm -f ../bin/linux64/*.ppu
