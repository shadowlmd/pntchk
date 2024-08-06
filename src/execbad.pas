Program execbad;
Uses Crt,SysUtils;
var segfl: text;
    endstr,endstr2: string;
const
  NameProg = 'EXECBAD'
        {$IFDEF WIN32} +'/W32' {$ENDIF}
        {$IFDEF WIN64} +'/W64' {$ENDIF}
        {$IFDEF DPMI} +'/32' {$ENDIF}
        {$IFDEF LINUX} +'/LNX' {$ENDIF}
        {$IFDEF BSD} +'/BSD' {$ENDIF}
        {$IFDEF OS2}{$IFDEF EMX} +'/EMX' {$ELSE} +'/2' {$ENDIF}
        {$ENDIF}
        ;
  {$IFDEF WINDOWS}  namefprog = 'W'; {$ENDIF}
  {$IFDEF EMX}    namefprog = 'E'; {$ENDIF}
  {$IFDEF DPMI}  namefprog = 'P'; {$ENDIF}
  {$IFDEF LINUX}  namefprog = '.LNX'; {$ENDIF}
  {$IFDEF BSD} namefprog = '.BSD'; {$ENDIF}
  Version = '0.12.beta';

begin
  TextColor (White);
  Write (nameprog);
  TextColor(LightCyan);
  Writeln ('    An example utility for PNTCHK v'+version);
  TextColor(Yellow);
  Writeln ('Copyright (c) 1997 Pavel I.Osipov (2:5020/770.0@fidonet)');
  WriteLn;
  if (paramcount<3) then
    begin
      textcolor(7);
      writeln('A small example utility of EXECBAD procedure for');
      writeln('Professional pointsegment checker, v'+version+' and later');
      writeln;
      textcolor(15);
      write('Usage: EXECBAD'+namefprog+{$IFNDEF UNIX}'.EXE'+
                      {$ENDIF}' <new_segment_file> <old_segment_file> <outfile>');
      textcolor(7); writeln;
      halt
    end;

 endstr:='';

 assign(segfl,paramstr(1));
 reset(segfl);
 if ioresult<>0 then
  begin
    writeln('Error opening segment file : ',paramstr(1));
    halt
  end;
 endstr:=endstr+FormatDateTime('DD-MM-YYYY HH:MM',FileDateToDateTime(FileAge(paramstr(1))));
 close(segfl);

if (paramstr(2)<>'%o') and (paramstr(2)<>'%O') then

 begin

 assign(segfl,paramstr(2));
 reset(segfl);
 if ioresult<>0 then
  begin
    writeln('Error opening old segment file : ',paramstr(2));
    halt
  end;
 endstr2:=FormatDateTime('DD-MM-YYYY HH:MM',FileDateToDateTime(FileAge(paramstr(2))));
 close(segfl)

 end;

 assign(segfl,paramstr(3));
 rewrite(segfl);
 if ioresult<>0 then
  begin
    writeln('Error creating outfile : ',paramstr(3));
    halt
  end;

    write(segfl,'Bad segment file "'+ExtractFileName(paramstr(1))+'" dated '+endstr+' wasn''t accepted');
if (paramstr(2)<>'%o') and (paramstr(2)<>'%O') then writeln(segfl,',') else writeln(segfl);
if (paramstr(2)<>'%o') and (paramstr(2)<>'%O') then writeln(segfl,'old segment file "'+ExtractFileName(paramstr(2))+'" dated '+
    endstr2+' was accepted');

 close(segfl);

 textcolor(white);

    write('Bad segment file "'+ExtractFileName(paramstr(1))+'" dated '+endstr+' wasn''t accepted');
if (paramstr(2)<>'%o') and (paramstr(2)<>'%O') then writeln(',') else writeln;
if (paramstr(2)<>'%o') and (paramstr(2)<>'%O') then writeln('old segment file "'+ExtractFileName(paramstr(2))+'" dated '+
    endstr2+' was accepted');

end.
