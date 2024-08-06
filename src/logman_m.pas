{$O+}
Unit LogMan_m;
Interface
Const dayof: array[1..7] of string[3] = ('Mon','Tue','Wed','Thu','Fri','Sat','Sun');
     monthname: array[1..12] of string[3] = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
Var
 LogFile:Text;  {⥪�⮢�� ��p�������, �易���� � 䠩��� ���� (��� ����y��
                 � ��� �� ���짮��⥫�᪨� �p��p��� - undocumented mode ;)}
 SharingMode:Boolean; {�᫨ TRUE, � ��� �y��� ���p뢠���� ��᫥ ������� ᮮ�-
                       饭��, ��� �� ᤥ���� � t-mail'�. ������� �� ���
                       ⮣�, �⮡� �� �p��� ᮮ�饭�� �����p�⮣� ����.
                       �H���H��! ���祭�� ��p������� ����� ������ ��᫥
                       ��p��� ����!}
 CopyRight: String;
Procedure OpenLogFile(LogFileName,Filter,Message:String);
{��p뢠�� log-䠩�. LogFileName - ��� ����, filter - ᯨ᮪ ⠣��, ���p�
 �� �y�y� ����祭� � ���. H��p���p: �᫨ filter = '@=X', � �� �맮�� �p��-
 �yp� LogMsg � ⠣��� @, = � X ᮮ⢥��⢥���, �y�y� �p�����p�p�����. Title -
 ⥪��, ����騩�� � ������ ��p���. � BinkleyTerm, ���p���p, �� ��p���
 'BINK'. Message - �p�����⢥���� ᮮ�饭��, ������塞�� � ��� �p� ��� ��p�-
 ⨨.}
Procedure LogMsg(Tag:Char;Message:String);
{�������� ᮮ�饭�� � ���. Tag - �� ᮡ�⢥��� ⠣ ᮮ�饭��, ��� ��⥣�p��.
 ���筮: '!' - �⠫�� �訡��, '?' - ���⠫�� �訡�� ��� �p��� ������
 ��y�樨, '.' - �p��� ���p����. ��� ��p���, ������塞�� � ���:
 X YY/ZZ AA:BB:CC:DD EEEEEE <⥪��>, ���:
 X - ⠣,
 YY/ZZ - ���
 AA:BB:CC:DD - �p���
 EEEEEE - ���祭�� ��p������� Title, ���p�� y������ � �p�楤yp� OpenLogFile}
Procedure CloseLogFile(Message:String);
{���p뢠�� ���-䠩�. �� ;)}
Implementation
Uses Dos, {$IFDEF BW } CrtFake; {$ELSE} crt; {$ENDIF}
Var
 TagFilter:String;
{ LogTitle:String;}
 a1,a2,a3,a4:  {$IFDEF VIRTUALPASCAL } {$IFDEF FPC} Word {$ELSE} LongInt {$ENDIF} {$ELSE} Word {$ENDIF};
 strad: string[4];
Procedure OpenLogFile;
Begin
 Assign(LogFile,LogFileName);
 {$I-}
 Append(LogFile);
 {$I+}
 If IOResult<>0 Then
{  Begin
   Close(LogFile);
   Append(LogFile);
  End
 Else} {$I-}
  ReWrite(LogFile);
 If IOResult<>0 then
   begin
     textcolor(LightRed);
     write('Unable to open/create logfile: '+LogFileName);
     textcolor(7);
     writeln;
     halt(202)
   end;
 {$I+}
 WriteLn(LogFile);
 getdate(a1,a2,a3,a4);
 if a4=0 then a4:=7;
 str(a1,strad);
 strad:=copy(strad,length(strad)-1,2);
 if a3 in [0..9] then
  WriteLn(LogFile,'----------  ',dayof[a4],' 0',a3,' ',monthname[a2],' ',strad,', ',Message)
 else
  WriteLn(LogFile,'----------  ',dayof[a4],' ',a3,' ',monthname[a2],' ',strad,', ',Message);
 TagFilter:=Filter;
{ LogTitle:=Title;}
 If SharingMode Then
  Close(LogFile);
End;
Procedure CloseLogFile;
Begin
 If SharingMode Then
   Append(LogFile);
 WriteLn(LogFile,'----------  ' + Message);
 Close(LogFile);
End;
Procedure LogMsg;
Var
 H,M,S,S100:{$IFDEF VIRTUALPASCAL} {$IFDEF FPC} Word {$ELSE} LongInt {$ENDIF} {$ELSE} Word {$ENDIF};
Begin
 If SharingMode Then
  Append(LogFile);
 If Pos(Tag,TagFilter)=0 Then
   Begin
    if tag='!' then textcolor(12);
    Write(LogFile,Tag+' ');
    Write(Tag+' ');
{    GetDate(Y,M,D,DoW);
    If D in [0..9] Then
      Write(LogFile,'0',D,'/');
      Write('0',D,'/')
    Else
      Write(LogFile,D,'/');
      Write(D,'/');
    If M in [0..9] Then
      Write(LogFile,'0',M,' ');
      Write('0',M,' ')
    Else
      Write(LogFile,M,' ');
      Write(M,' ');}

    GetTime(H,M,S,S100);
    If H in [0..9] Then begin
      Write(LogFile,'0',H,':');
      Write('0',H,':') end
    Else begin
      Write(LogFile,H,':');
      Write(H,':') end;
    If M in [0..9] Then begin
      Write(LogFile,'0',M,':');
      Write('0',M,':') end
    Else begin
      Write(LogFile,M,':');
      Write(M,':') end;
{    If S in [0..9] Then
      Writeln(LogFile,'0',S)
    Else
      Writeln(LogFile,S);}
    If S in [0..9] Then begin
      WriteLn(LogFile,'0',S,'  ',Message);
      Write('0',S,'  ',Message) end
    Else begin
      WriteLn(LogFile,S,'  ',Message);
      Write(S,'  ',Message) end;
    textcolor(7);
    writeln
   End;
 If SharingMode Then
  Close(LogFile);
(*  CopyRight := '.LOG files support library coded by basil v. vorontsov, (C)1995; updated (c) 1997 by Pavel I.Osipov';*)
End;
Begin
 SharingMode:=False;
End.
