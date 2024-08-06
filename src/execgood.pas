Program execgood;
Uses Dos,Crt;
var segfl: text;
    endstr,endstr2: string;
const
(*  NameProg = {$IFDEF VIRTUALPASCAL } {$IFDEF EMX} 'EXECGOOD/EMX' {$ELSE} 'EXECGOOD/2' {$ENDIF} {$ELSE} 'EXECGOOD' {$ENDIF};
  NameFProg = {$IFDEF VIRTUALPASCAL } 'EXEGOOD' {$ELSE} nameprog {$ENDIF};*)
  NameProg = {$IFDEF VIRTUALPASCAL } {$IFDEF WIN32} 'EXECGOOD/W32' {$ELSE} {$IFDEF DOS32} 'EXECGOOD/32' {$ELSE}
             {$IFDEF LINUX} {$IFDEF FREEBSD} 'EXECGOOD/BSD' {$ELSE} 'EXECGOOD/LNX' {$ENDIF} {$ELSE} {$IFDEF EMX} 'PNTCHK/EMX'
             {$ELSE} 'EXECGOOD/2' {$ENDIF} {$ENDIF} {$ENDIF}
             {$ENDIF}
             {$ELSE} 'EXECGOOD' {$ENDIF};
{$IFDEF FPC}
{$IFDEF WIN32}  namefprog = 'W'; {$ENDIF}
{$IFDEF EMX}    namefprog = 'E'; {$ENDIF}
{$IFDEF DOS32}  namefprog = 'P'; {$ENDIF}
{$IFDEF LINUX}  namefprog = {$IFDEF FREEBSD} 'D.BSD' {$ELSE} 'D.LNX' {$ENDIF}; {$ENDIF}
{$ELSE}
namefprog = 'D';
{$ENDIF}
  Version = '0.11.beta';
  {dayof: array[1..7] of string[3] = ('Mon','Tue','Wed','Thu','Fri','Sat','Sun');}
  monthname: array[1..12] of string[3] = ('Jan','Fer','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

Function XStr(L:LongInt):String;
Var
 SS:String;
Begin
 Str(L,SS);
 XStr:=SS;
End;

Function shortname(fullname: string): string;
var i:integer;
begin
    i:=length(fullname)+1;
    repeat
      dec(i)
    until (fullname[i]='\') or (i=0);
    if i>0 then delete(fullname,1,i);
    shortname:=fullname
end;

function LeadingZero(w : Word) : String;
 var
   s : String;
 begin
   Str(w:0,s);
   if Length(s) = 1 then
     s := '0' + s;
   LeadingZero := s;
 end;

Function returndatetime: string;
var tplstr: string;
    ftime : Longint; { For Get/SetFTime}
    dt : DateTime; { For Pack/UnpackTime}
begin
   tplstr:='';
   GetFTime(segfl,ftime); { Get creation time }
   UnpackTime(ftime,dt);
   with dt do
     begin
      tplstr:=tplstr+leadingzero(day);
      tplstr:=tplstr+'-';
      tplstr:=tplstr+monthname[month];
      tplstr:=tplstr+'-';
      tplstr:=tplstr+copy(xstr(year),length(xstr(year))-1,2);
      tplstr:=tplstr+' ';
      tplstr:=tplstr+leadingzero(hour);
      tplstr:=tplstr+':';
      tplstr:=tplstr+leadingzero(min);
      tplstr:=tplstr+':';
      tplstr:=tplstr+leadingzero(sec)
     end;
  returndatetime:=tplstr
end;

begin
  TextColor (White);
  Write (nameprog);
  TextColor(LightCyan);
  Writeln ({$IFDEF VIRTUALPASCAL} {$IFDEF EMX} ''+ {$ELSE} ''+ {$ENDIF} {$ELSE} '    '+
           {$ENDIF}'    An example utility for PNTCHK v'+version);
  TextColor(Yellow);
  Writeln ('Copyright (c) 1997 Pavel I.Osipov (2:5020/770.0@fidonet)');
  WriteLn;
  if (paramcount<3) then
    begin
      textcolor(7);
      writeln('A small example utility of EXECGOOD procedure for');
      writeln('Professional pointsegment checker, v'+version+' and later');
      writeln;
      textcolor(15);
      write('Usage: EXECGOO'+namefprog+{$IFNDEF LINUX}'.EXE'+
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
 endstr:=endstr+returndatetime;
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
 endstr2:=returndatetime;
 close(segfl)

 end;

 assign(segfl,paramstr(3));
 rewrite(segfl);
 if ioresult<>0 then
  begin
    writeln('Error creating outfile : ',paramstr(3));
    halt
  end;

 writeln(segfl,'New segment file "'+shortname(paramstr(1))+'" dated '+endstr+' was accepted');
if (paramstr(2)<>'%o') and (paramstr(2)<>'%O') then writeln(segfl,'instead of old segment file "'+
    shortname(paramstr(2))+'" dated '+endstr2);

 close(segfl);

 textcolor(white);

 writeln('New segment file "'+shortname(paramstr(1))+'" dated '+endstr+' was accepted');
if (paramstr(2)<>'%o') and (paramstr(2)<>'%O') then writeln('instead of old segment file "'+
    shortname(paramstr(2))+'" dated '+endstr2)

end.
