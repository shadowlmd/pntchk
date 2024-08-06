{$MODE TP}
{$O+}
Unit LogMan_m;
Interface
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
Uses Sysutils, {$IFDEF BW } CrtFake; {$ELSE} crt; {$ENDIF}
Var
 TagFilter:String;
{ LogTitle:String;}
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
 WriteLn(LogFile,'----------  ',FormatDateTime('ddd dd-mmm-yy',Now),', ',Message);
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
Begin
 If SharingMode Then
  Append(LogFile);
 If Pos(Tag,TagFilter)=0 Then
   Begin
    if tag='!' then textcolor(12);
    WriteLn(LogFile,Tag,' ',FormatDateTime('HH:MM:SS',Now),'  ',Message);
    WriteLn(Tag,' ',FormatDateTime('HH:MM:SS',Now),'  ',Message);
    textcolor(7);
   End;
 If SharingMode Then
  Close(LogFile);
(*  CopyRight := '.LOG files support library coded by basil v. vorontsov, (C)1995; updated (c) 1997 by Pavel I.Osipov';*)
End;
Begin
 SharingMode:=False;
End.
