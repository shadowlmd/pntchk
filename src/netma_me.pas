{$MODE TP}
{$O+}
Unit NetMa_me;
Interface
Uses sysutils, DOS;
Const
  {errors}
  bvMessageNotFound = 1;
  bvNoMoreMessages = 18;
  bvMessageNotOpen = 9;
  {flags}
  flPvt = 1;
  flCrash = 2;
  flRecd = 4;
  flSent = 8;
  flAttach = 16;
  flTrs = 32;
  flOrphan = 64;
  flKillSent = 128;
  flLoc = 256;
  flHold = 512;
  flFreq = 2048;
  flRRQ = 4096;
  flIsRRQ = 8192;
  flARQ = 16384;
  flFileUpdateReq = 32768;

  MonthNames:Array[1..12] of String[3]= ('Jan','Feb','Mar','Apr','May','Jun',
  'Jul','Aug','Sep','Oct','Nov','Dec');
Type
  TAddrType = Record
    FromZone, FromNet, FromNode, FromPoint, ToZone, ToNet, ToNode, ToPoint: Word;
  End;
  TMsgText = Object
    MessageText: Array [1..32000] of Char;
    CurrentPosition: Word;
    MsgEOF: Boolean;
    Procedure ReRead;
    Procedure Clear;
    Function GetChar: Char;
    Function GetString: String;
    Procedure Seek (Position: Word);
    Procedure PutChar (CH: Char);
    Procedure PutString (St: String);
    Constructor Init;
  End;
  TMsgHdr = Record
    From, TTo           : Array [1..36] of Char;
    Subj                : Array [1..72] of Char;
    Date, Time          : Array [1..10] of Char;
    Read, ToNode        : Word;
    FromNode, Cost      : Word;
    FromNet, ToNet      : Word;
    Other               : Array [1..8] of Char;
    Reply, Flags, Next  : Word;
  End;
  TNetMail = Object
    Header: TMsgHdr;
    DirInfo: SearchRec;
    MFile: File;
    NetMailPath: String [80];
    CurrentMsg: String [12];
    MsgText: TMsgText;
    MessageOpen: Boolean;
    Procedure ReScan;
    Procedure OpenMsg;
    Procedure CreateMsg;
    Procedure NextMsg;
    Function GetFrom: String;
    Function GetTo: String;
    Function GetSubj: String;
    Function GetFlags: Word;
    Function IsPvt: Boolean;
    Function IsCrash: Boolean;
    Function IsRecd: Boolean;
    Function IsSent: Boolean;
    Function IsAttach: Boolean;
    Function IsTrs: Boolean;
    Function IsLoc: Boolean;
    Function IsHold: Boolean;
    Function IsFreq: Boolean;
    Procedure SetPvt (YesNo: Boolean);
    Procedure SetCrash (YesNo: Boolean);
    Procedure SetRecd (YesNo: Boolean);
    Procedure SetSent (YesNo: Boolean);
    Procedure SetAttach (YesNo: Boolean);
    Procedure SetTrs (YesNo: Boolean);
    Procedure SetOrphan (YesNo: Boolean);
    Procedure SetKillSent (YesNo: Boolean);
    Procedure SetLoc (YesNo: Boolean);
    Procedure SetHold (YesNo: Boolean);
    Procedure SetFreq (YesNo: Boolean);
    Procedure SetRRQ (YesNo: Boolean);
    Procedure SetIsRRQ (YesNo: Boolean);
    Procedure SetARQ (YesNo: Boolean);
    Procedure SetFileUpdateReq (YesNo: Boolean);
    Procedure SetFrom (St: String);
    Procedure SetTo (St: String);
    Procedure SetSubj (St: String);
    Procedure SetFlags (Flags: Word);
    Procedure SetFromTo (Var Addr: TAddrType);
    Procedure GetFromTo (Var Addr: TAddrType);
    Procedure SetCurrentTime;
    Procedure GetMsgTime (Var Date,Month,Year,Hour,Min,Sec:Word);
    Procedure SetMsgTime (Date,Month,Year,Hour,Min,Sec:Word);
    Procedure LoadMessageText;
    Procedure SaveMessageText;
    Procedure CloseMsg;
    Procedure KillMsg;
    Procedure ParseAddress (FromAddr, ToAddr: String; Var Addr: TAddrType);
    Procedure DisParseAddress (Addr: TAddrType; Var FromAddr, ToAddr:String);
  End;
Var
  NetmailError: Integer;
  Copyright:String;
  MaximumMsgs: Word;
  MessageChanged: Boolean;
  
  
Implementation

Function UniqueID: String;
Var
 S: String;
 J, B: Byte;
 C: Char;
Begin
 S:='';
 For J:=1 to 8 do
  Begin
   B:=Random(16);
   If B in [0..9] Then
     S:=S+Chr(Ord('0')+B)
   Else
     S:=S+Chr(Ord('a')+(B-10));
  End;
 UniqueID:=S;
End;

Function XStr(L:LongInt):String;
Var
  SS:String;
Begin
  Str(L,SS);
  XStr:=SS;
End;

Function XVal(S:String):Integer;
Var
  I:Integer;
  Zed: {$IFDEF VIRTUALPASCAL } LongInt {$ELSE} Integer {$ENDIF};
Begin
  Val(S,I,Zed);
  If Zed>0 Then
    I:=-1;
  XVal:=I;
End;

Procedure TMsgText. ReRead;
Begin
  Self. CurrentPosition := 1;
  MsgEOF := False;
End;

Procedure TMsgText. Clear;
Begin
  FillChar (Self. MessageText, 32000, #0);
  Self. ReRead;
End;

Procedure TMsgText. Seek;
Begin
  Self. CurrentPosition := Position + 1;
  MsgEOF := False;
End;

Function TMsgText. GetChar;
Begin
  GetChar := Self. MessageText [CurrentPosition];
  Inc (CurrentPosition);
  If (Self. MessageText [CurrentPosition] = #0) and (Self. MessageText [CurrentPosition + 1] = #0) Then
    MsgEOF := True;
End;

Function TMsgText. GetString;
Var
  S: String;
  CH: Char;
Begin
  S := '';
  Repeat
    CH := Self. GetChar;
    If (CH <> #0) and (CH <> #13) Then
      S := S + CH;
  Until (CH = #0) or (CH = #13);
  GetString := S;
End;

Procedure TMsgText. PutChar;
Begin
  if CurrentPosition<31998 then begin
  If Self. MessageText [CurrentPosition] = #0 Then
   Begin
    Self. MessageText [CurrentPosition + 1] := #0;
    Self. MessageText [CurrentPosition + 2] := #0;
   End;
  Self. MessageText [CurrentPosition] := CH;
  Inc (CurrentPosition);
  MessageChanged:=True;
  end;
End;

Procedure TMsgText. PutString;
Var
  J: Word;
Begin
  For J := 1 to Length (St) do
    Self. PutChar (St [J] );
  Self. PutChar (#13);
End;

Constructor TMsgText. Init;
Begin
  Self. CurrentPosition := 1;
  MsgEOF := False;
  MessageChanged:=False;
End;

Procedure TNetMail. Rescan;
Begin
  NetMailPath:=ExtractFilePath(IncludeTrailingPathDelimiter(NetMailPath));
(*  If NetMailPath[Length(NetMailPath)]<>{$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} 
         Then
    NetMailPath:=NetMailPath+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ; *)
  FindFirst(NetMailPath+'*.msg', AnyFile-Directory, DirInfo);
  If DosError=0 then CurrentMsg := DirInfo.Name
                else NetmailError := DosError;
End;

Procedure TNetMail.OpenMsg;
Begin
  NetMailPath:=ExtractFilePath(IncludeTrailingPathDelimiter(NetMailPath));
(*  If NetMailPath[Length(NetMailPath)]<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  Then
    NetMailPath:=NetMailPath+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} 
; *)
  Assign (MFile, NetMailPath + CurrentMsg);
  FileMode := 2;
  {$I-}
  Reset (MFile, 1);
  {$I+}
  If IOResult <> 0 Then
  Begin
    NetMailError := bvMessageNotFound;
    MessageOpen := False;
    Exit;
  End
  Else Begin
    MessageOpen := True;
  End { else };
  BlockRead (MFile, Header, SizeOf (Header) );
  MessageChanged:=False;
End;

Procedure TNetMail. LoadMessageText;
Var
  Really:  LongInt;
Begin
  If not MessageOpen Then
  Begin
    NetmailError := bvMessageNotOpen;
    Exit;
  End;
  Seek (MFile, 190);
  FillChar (MsgText.MessageText, 32000, #0);
  If not EOF(MFile) Then
    BlockRead (MFile, MsgText.MessageText [1], 32000, Really);
End;

Procedure TNetMail. SaveMessageText;
Var
  Size: Word;
Begin
  If not MessageOpen Then
  Begin
    NetmailError := bvMessageNotOpen;
    Exit;
  End;
  Seek (MFile, 190);
  Truncate (MFile);
  Size := 0;
  Repeat
    Inc (Size);
  Until (MsgText. MessageText [Size] = #0) and (MsgText. MessageText [Size+1] = #0);
  BlockWrite (MFile, MsgText. MessageText [1], Size);
End;

Procedure TNetMail. CloseMsg;
Begin
  If MessageOpen Then
   Begin
    If MessageChanged Then
    Begin
      Seek (MFile, 0);
      BlockWrite (MFile, Header, SizeOf (Header) );
    End;
    Close (MFile);
   End;
  MessageOpen := False;
  MessageChanged := False;
End;

Procedure TNetMail. NextMsg;
Begin
  If MessageOpen Then
    CloseMsg;
  NetMailPath:=ExtractFilePath(IncludeTrailingPathDelimiter(NetMailPath));

(*  If NetMailPath[Length(NetMailPath)]<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  Then
    NetMailPath:=NetMailPath+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} 
; *)
  MessageOpen := False;
  FindNext(DirInfo);
  If DosError<>0 Then NetMailError:=DosError;
  CurrentMsg:=DirInfo.Name;
End;

Procedure TNetMail.SetCurrentTime;
Var
  Hour, Min, Sec, Sec100, Year, Month, Date, DoW: Word;
Begin
  GetTime(Hour, Min, Sec, Sec100);
  GetDate(Year, Month, Date, DoW);
{  If Year>1900 Then
    Year:=Year-1900;}
  SetMsgTime(Date, Month, Year, Hour, Min, Sec);
End;


Procedure TNetMail. CreateMsg;
Var
  MaxMsg, MsgNo, ZZ: LongInt;
  P:DirStr;
  N:Namestr;
  E:ExtStr;
Begin
  If MessageOpen Then
    CloseMsg;
  FillChar(Header,190,0);
  FindFirst (ExtractFilePath(IncludeTrailingPathDelimiter(NetMailPath)) +'*.msg', AnyFile, DirInfo);

(*  FindFirst (NetMailPath +{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} +'*.msg', AnyFile, DirInfo); *)
  MaxMsg := 0;
  While DosError = 0 do
  Begin
    FSplit (DirInfo.Name, P, N, E);
    Val (N, MsgNo, ZZ);
    If MsgNo > MaxMsg Then
      MaxMsg := MsgNo;
    FindNext (DirInfo);
  End;
  Inc (MaxMsg);
  NetMailPath:=ExtractFilePath(IncludeTrailingPathDelimiter(NetMailPath));

(*  If NetMailPath[Length(NetMailPath)]<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  Then
    NetMailPath:=NetMailPath+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ; *)
  Assign (MFile, NetMailPath + XStr (MaxMsg) + '.msg');
  FileMode := 2;
  {$I-}
  Rewrite (MFile, 1);
  {$I+}
  Header.Flags:= Header.Flags or flLoc;
  SetCurrentTime;
  BlockWrite (MFile, Header, SizeOf (Header) );
  MsgText. Clear;
  MessageOpen:=True;
  MessageChanged:=True;
End;

Procedure TNetMail.KillMsg;
Begin
  If MessageOpen Then
   Begin
    Close(MFile);
    MessageOpen:=False;
   End;
  NetMailPath:=ExtractFilePath(IncludeTrailingPathDelimiter(NetMailPath));
(*  If NetMailPath[Length(NetMailPath)]<>{$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF}
         Then NetMailPath:=NetMailPath+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ; *)
  Assign (MFile, NetMailPath + CurrentMsg);
  Erase(MFile);
End;

Procedure TNetMail.SetFrom;
Var
  J:Byte;
Begin
  For J:=1 to 36 do
    Header.From[J]:=#0;
  For J:=1 to Length(St) do
    Header.From[J]:=St[J];
  MessageChanged := True;
End;

Procedure TNetMail.SetTo;
Var
  J:Byte;
Begin
  For J:=1 to 36 do
    Header.TTo[J]:=#0;
  For J:=1 to Length(St) do
    Header.TTo[J]:=St[J];
  MessageChanged := True;
End;

Procedure TNetMail.SetSubj;
Var
  J:Byte;
Begin
  For J:=1 to 36 do
    Header.Subj[J]:=#0;
  For J:=1 to Length(St) do
    Header.Subj[J]:=St[J];
  MessageChanged := True;
End;

Procedure TNetMail.SetFlags;
Begin
  If MessageOpen then Begin Close(MFile); MessageOpen:=False; End { if };
  OpenMsg;
  Header.Flags:=Flags;
  MessageChanged := True;
End;

Procedure TNetMail.SetFromTo;
Var
  Intl, MsgId: String[80];
  I: Byte;
Begin
  Header.FromNode:=Addr.FromNode;
  Header.ToNode:=Addr.ToNode;
  Header.FromNet:=Addr.FromNet;
  Header.ToNet:=Addr.ToNet;
  MsgText.ReRead;
  Intl:=#1+'INTL '+XStr(Addr.ToZone)+':'+XStr(Addr.ToNet)+'/'+XStr(Addr.ToNode)+' '+
  XStr(Addr.FromZone)+':'+XStr(Addr.FromNet)+'/'+XStr(Addr.FromNode);
  MsgText.PutString(Intl);
  If Addr.FromPoint<>0 Then
    MsgText.PutString(#1+'FMPT '+XStr(Addr.FromPoint));
  If Addr.ToPoint<>0 Then
    MsgText.PutString(#1+'TOPT '+XStr(Addr.ToPoint));
  If Addr.FromPoint<>0 Then
    MsgId:=#1+'MSGID: '+XStr(Addr.FromZone)+':'+XStr(Addr.FromNet)+'/'+XStr(Addr.FromNode)+'.'+XStr(Addr.FromPoint)+' '
  Else
    MsgId:=#1+'MSGID: '+XStr(Addr.FromZone)+':'+XStr(Addr.FromNet)+'/'+XStr(Addr.FromNode)+' ';
  MsgId:=MsgId+UniqueID;
  MsgText.PutString(MsgId);
  SaveMessageText;
  MessageChanged := True;
End;

Procedure TNetMail.GetFromTo;
Var
  Cnt:Byte;
  St:String;
Begin
  Cnt:=0;
  LoadMessageText;
  Addr.FromNet:=Header.FromNet;
  Addr.FromNode:=Header.FromNode;
  Addr.ToNet:=Header.ToNet;
  Addr.ToNode:=Header.ToNode;
  Addr.FromZone:=0;
  Addr.ToZone:=0;
  Addr.FromPoint:=0;
  Addr.ToPoint:=0;
  MsgText.ReRead;
  Repeat
    St:=MsgText.GetString;
    If Pos(#1+'FMPT ',St)>0 Then
    Begin
      Delete(St,1,6);
      Addr.FromPoint:=XVal(St);
    End;
    If Pos(#1+'TOPT ',St)>0 Then
    Begin
      Delete(St,1,6);
      Addr.ToPoint:=XVal(St);
    End;
    If Pos(#1+'INTL ',St)>0 Then
    Begin
      Delete(St,1,6);
      Addr.ToZone:=XVal(Copy(St,1,Pos(':',St)-1));
      While (St[1]<>' ') and (Length(St)>0) do
        Delete(St,1,1);
      Delete(St,1,1);
      Addr.FromZone:=XVal(Copy(St,1,Pos(':',St)-1));
    End;
    If Pos(#1+'MSGID: ',St)>0 Then
    Begin
      Delete(St,1,8);
      Addr.FromZone:=XVal(Copy(St,1,Pos(':',St)-1));
    End;
  Until MsgText.MsgEOF;
End;

Procedure TNetMail.DisParseAddress;
Begin
  If Addr.FromPoint<>0 Then
    FromAddr:=XStr(Addr.FromZone)+':'+XStr(Addr.FromNet)+'/'+XStr(Addr.FromNode)+'.'+XStr(Addr.FromPoint)
  Else
    FromAddr:=XStr(Addr.FromZone)+':'+XStr(Addr.FromNet)+'/'+XStr(Addr.FromNode);
  If Addr.ToPoint<>0 Then
    ToAddr:=XStr(Addr.ToZone)+':'+XStr(Addr.ToNet)+'/'+XStr(Addr.ToNode)+'.'+XStr(Addr.ToPoint)
  Else
    ToAddr:=XStr(Addr.ToZone)+':'+XStr(Addr.ToNet)+'/'+XStr(Addr.ToNode);
End;

Procedure TNetMail.ParseAddress;
Begin
  If Copy(FromAddr,1,Pos(':',FromAddr)-1)='*'
   then Addr.FromZone:=65535
   else Addr.FromZone:=XVal(Copy(FromAddr,1,Pos(':',FromAddr)-1));
  If Copy(FromAddr,Pos(':',FromAddr)+1,Pos('/',FromAddr)-Pos(':',FromAddr)-1)='*'
   then Addr.FromNet:=65535
   else Addr.FromNet:=XVal(Copy(FromAddr,Pos(':',FromAddr)+1,Pos('/',FromAddr)-Pos(':',FromAddr)-1));
  If Pos('.',FromAddr)>0 Then
  Begin
   If Copy(FromAddr,Pos('/',FromAddr)+1,Pos('.',FromAddr)-Pos('/',FromAddr)-1)='*'
    then Addr.FromNode:=65535
    else Addr.FromNode:=XVal(Copy(FromAddr,Pos('/',FromAddr)+1,Pos('.',FromAddr)-Pos('/',FromAddr)-1));
   If Copy(FromAddr,Pos('.',FromAddr)+1,Length(FromAddr)-Pos('.',FromAddr))='*'
    then Addr.FromPoint:=65535
    else Addr.FromPoint:=XVal(Copy(FromAddr,Pos('.',FromAddr)+1,Length(FromAddr)-Pos('.',FromAddr)))
  End
  Else
  Begin
   If Copy(FromAddr,Pos('/',FromAddr)+1,Length(FromAddr)-Pos('/',FromAddr))='*'
    then Begin
     Addr.FromNode:=65535;
     Addr.FromPoint:=65535
    end
    else Begin
     Addr.FromNode:=XVal(Copy(FromAddr,Pos('/',FromAddr)+1,Length(FromAddr)-Pos('/',FromAddr)));
     Addr.FromPoint:=0;
    end;
  End;
  If (Copy(ToAddr,1,Pos(':',ToAddr)-1))='*'
   then Addr.ToZone:=65535
   else Addr.ToZone:=XVal(Copy(ToAddr,1,Pos(':',ToAddr)-1));
  If Copy(ToAddr,Pos(':',ToAddr)+1,Pos('/',ToAddr)-Pos(':',ToAddr)-1)='*'
   then Addr.ToNet:=65535
   else Addr.ToNet:=XVal(Copy(ToAddr,Pos(':',ToAddr)+1,Pos('/',ToAddr)-Pos(':',ToAddr)-1));
  If Pos('.',ToAddr)>0 Then
  Begin
   If Copy(ToAddr,Pos('/',ToAddr)+1,Pos('.',ToAddr)-Pos('/',ToAddr)-1)='*'
    then Addr.ToNode:=65535
    else Addr.ToNode:=XVal(Copy(ToAddr,Pos('/',ToAddr)+1,Pos('.',ToAddr)-Pos('/',ToAddr)-1));
   If Copy(ToAddr,Pos('.',ToAddr)+1,Length(ToAddr)-Pos('.',ToAddr))='*'
    then Addr.ToPoint:=65535
    else Addr.ToPoint:=XVal(Copy(ToAddr,Pos('.',ToAddr)+1,Length(ToAddr)-Pos('.',ToAddr)))
  End
  Else
  Begin
   If Copy(ToAddr,Pos('/',ToAddr)+1,Length(ToAddr)-Pos('/',ToAddr))='*'
    then Begin
     Addr.ToNode:=65535;
     Addr.ToPoint:=65535
    end
    else Begin
     Addr.ToNode:=XVal(Copy(ToAddr,Pos('/',ToAddr)+1,Length(ToAddr)-Pos('/',ToAddr)));
     Addr.ToPoint:=0;
    end;

  End;
End;

Procedure TNetMail.GetMsgTime;
Var
  S:String;
  J:Byte;
Begin
  S:=Header.Date[1]+Header.Date[2];
  Date:=XVal(S);
  S:=Header.Date[4]+Header.Date[5]+Header.Date[6];
  For J:=1 to 12 do
  Begin
    If S=MonthNames[J] Then
      Month:=J;
  End;
  S:=Header.Date[8]+Header.Date[9];
  Year:=1900+XVal(S);
  S:=Header.Time[2]+Header.Time[3];
  Hour:=XVal(S);
  S:=Header.Time[5]+Header.Time[6];
  Min:=XVal(S);
  S:=Header.Time[8]+Header.Time[9];
  Sec:=XVal(S);
End;

Procedure TNetMail.SetMsgTime;
Var
  S:String;
  YR:Word;
Begin
  S:=XStr(Date);
  If Length(S)=1 Then
    S:='0'+S;
  Header.Date[1]:=S[1];
  Header.Date[2]:=S[2];
  Header.Date[3]:=' ';
  S:=MonthNames[Month];
  Header.Date[4]:=S[1];
  Header.Date[5]:=S[2];
  Header.Date[6]:=S[3];
{  If Year>1900 Then
    YR:=Year-1900
  Else}
    YR:=Year;
  S:=XStr(YR);
  If Length(S)=1 Then
    S:='0'+S;
  Header.Date[7]:=' ';
  Header.Date[8]:=S[length(S)-1];
  Header.Date[9]:=S[length(S)];
  Header.Date[10]:=' ';
  S:=XStr(Hour);
  If Length(S)=1 Then
    S:='0'+S;
  Header.Time[1]:=' ';
  Header.Time[2]:=S[1];
  Header.Time[3]:=S[2];
  S:=XStr(Min);
  If Length(S)=1 Then
    S:='0'+S;
  Header.Time[4]:=':';
  Header.Time[5]:=S[1];
  Header.Time[6]:=S[2];
  S:=XStr(Sec);
  If Length(S)=1 Then
    S:='0'+S;
  Header.Time[7]:=':';
  Header.Time[8]:=S[1];
  Header.Time[9]:=S[2];
  MessageChanged := True;
End;

Function TNetMail.GetFrom;
Var
  S:String;
  J:Byte;
Begin
  S:='';
  J:=0;
  Repeat
    Inc(J);
    If Header.From[J]<>#0 Then
      S:=S+Header.From[J];
  Until (Header.From[J]=#0) or (J>=36);
  GetFrom:=S;
End;

Function TNetMail.GetTo;
Var
  S:String;
  J:Byte;
Begin
  S:='';
  J:=0;
  Repeat
    Inc(J);
    If Header.TTo[J]<>#0 Then
      S:=S+Header.TTo[J];
  Until (Header.TTo[J]=#0) or (J>=36);
  GetTo:=S;
End;

Function TNetMail.GetSubj;
Var
  S:String;
  J:Byte;
Begin
  S:='';
  J:=0;
  Repeat
    Inc(J);
    If Header.Subj[J]<>#0 Then
      S:=S+Header.Subj[J];
  Until (Header.Subj[J]=#0) or (J>=72);
  GetSubj:=S;
End;

Function TNetMail.GetFlags;
Begin
  GetFlags:=Header.Flags;
End;

Function TNetMail.IsCrash;
Begin
  IsCrash:=((Header.Flags and 2) = 2);
End;

Function TNetMail.IsPvt;
Begin
  IsPvt:=((Header.Flags and 1) = 1);
End;

Function TNetMail.IsRecd;
Begin
  IsRecd:=((Header.Flags and 4) = 4);
End;

Function TNetMail.IsSent;
Begin
  IsSent:=((Header.Flags and 8) = 8);
End;

Function TNetMail.IsAttach;
Begin
  IsAttach:=((Header.Flags and 16) = 16);
End;

Function TNetMail.IsTrs;
Begin
  IsTrs:=((Header.Flags and 32) = 32);
End;

Function TNetMail.IsLoc;
Begin
  IsLoc:=((Header.Flags and 256) = 256);
End;

Function TNetMail.IsHold;
Begin
  IsHold:=((Header.Flags and 512) = 512);
End;

Function TNetMail.IsFreq;
Begin
  IsFreq:=((Header.Flags and 2048) = 2048);
End;

Procedure TNetMail.SetPvt;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 1
  Else
    Header.Flags:=(Header.Flags and (not (Word (1))));
End;

Procedure TNetMail.SetCrash;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 2
  Else
    Header.Flags:=(Header.Flags and (not (Word (2))));
  MessageChanged := True;
End;

Procedure TNetMail.SetRecd;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 4
  Else
    Header.Flags:=(Header.Flags and (not (Word (4))));
  MessageChanged := True;
End;

Procedure TNetMail.SetSent;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 8
  Else
    Header.Flags:=(Header.Flags and (not (Word (8))));
  MessageChanged := True;
End;

Procedure TNetMail.SetAttach;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 16
  Else
    Header.Flags:=(Header.Flags and (not (Word (16))));
  MessageChanged := True;
End;

Procedure TNetMail.SetTrs;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 32
  Else
    Header.Flags:=(Header.Flags and (not (Word (32))));
  MessageChanged := True;
End;

Procedure TNetMail.SetOrphan;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 64
  Else
    Header.Flags:=(Header.Flags and (not (Word (64))));
  MessageChanged := True;
End;

Procedure TNetMail.SetKillSent;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 128
  Else
    Header.Flags:=(Header.Flags and (not (Word (128))));
  MessageChanged := True;
End;

Procedure TNetMail.SetLoc;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 256
  Else
    Header.Flags:=(Header.Flags and (not (Word (256))));
  MessageChanged := True;
End;

Procedure TNetMail.SetHold;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 512
  Else
    Header.Flags:=(Header.Flags and (not (Word (512))));
  MessageChanged := True;
End;

Procedure TNetMail.SetFreq;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 2048
  Else
    Header.Flags:=(Header.Flags and (not (Word (2048))));
  MessageChanged := True;
End;

Procedure TNetMail.SetRRQ;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 4096
  Else
    Header.Flags:=(Header.Flags and (not (Word (4096))));
  MessageChanged := True;
End;

Procedure TNetMail.SetIsRRQ;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 8192
  Else
    Header.Flags:=(Header.Flags and (not (Word (8192))));
  MessageChanged := True;
End;

Procedure TNetMail.SetARQ;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 16384
  Else
    Header.Flags:=(Header.Flags and (not (Word (16384))));
  MessageChanged := True;
End;

Procedure TNetMail.SetFileUpdateReq;
Begin
  If YesNo Then
    Header.Flags:=Header.Flags or 32768
  Else
    Header.Flags:=(Header.Flags and (not (Word (32768))));
  MessageChanged := True;
End;

{Function TNetMail.;
Begin
End;}

Begin
  MaximumMsgs:=1000;
  MessageChanged:=False;
  Randomize;
  Copyright:='NETMAIL support library coded by basil v. vorontsov (C)1995; updated (c) 1997 by Pavel I.Osipov';
End.
