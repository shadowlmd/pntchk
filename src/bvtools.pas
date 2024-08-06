Unit BVTools;{FOR OS/2}
Interface
Uses {$IFDEF BW} CrtFake, {$ELSE} Crt, {$ENDIF} Dos;

Var
  CopyRight: String[80];

Function UniqueID: String;
Function Trim(S:String):String;
(*Function SetString(S:String;Lnn:Byte):String;
Function CenterStr(Lnn:Byte;S:String):String;
*)
Function XStr(L:LongInt):String;
Function XVal(S:String):Integer;
Function Exist(FN:String):Boolean;
Function StrUpCase(S:String):String;
Function StrDownCase(S:String):String;
(*Function GetWordStr(S:String;K:Integer):String;*)
Function ReadString:String;
Function ReadPassword:String;
Function ArrToString(Var Arr):String;
Procedure Abort(Message:String);
Procedure ColorMsg(Color:Byte;Message:String);

Implementation

Function Trim;
Var
 SS:String;
Begin
 SS:=S;
 While SS[1]=' ' do
  Delete(SS,1,1);
 While SS[Length(SS)]=' ' do
  SS[0]:=Chr(Ord(SS[0])-1);
 Trim:=SS;
End;

(*Function SetString;
Var
 SS:String;
Begin
 SS:=S;
 Repeat
  If Length(SS)<Lnn Then
    SS:=SS+' ';
  If Length(SS)>Lnn Then
    SS[0]:=Chr(Ord(SS[0])-1);
 Until Length(SS)=Lnn;
 SetString:=SS;
End;

Function CenterStr;
Var
 SS:String;
Begin
 SS:=S;
 While Length(SS)<Lnn do
  SS:=' '+SS+' ';
 SS[0]:=Chr(Lnn);
 CenterStr:=SS;
End;
*)
Function XStr;
Var
 SS:String;
Begin
 Str(L,SS);
 XStr:=SS;
End;

Function XVal;
Var
 I:LongInt;
 Zed: {$IFDEF VIRTUALPASCAL } LongInt {$ELSE} Integer {$ENDIF};
Begin
 Val(S,I,Zed);
 If Zed>0 Then
  I:=-1;
 XVal:=I;
End;


Function Exist;
Var
 F:File;
Begin
 Assign(F,FN);
 filemode:=0;
 {$I-}
 Reset(F,1);
 {$I+}
 If IOResult=0 Then
  Begin
    Close(F);
    Exist:=True;
  End
 Else
  Exist:=False;
 filemode:=2;
End;

Function StrUpCase;
Var
 J:Byte;
 St:String;
Begin
 St[0]:=S[0];
 For J:=1 to Length(S) do St[J]:=UpCase(S[J]);
 StrUpCase:=St;
End;

Function StrDownCase;
Var
 J:Byte;
 St:String;
Begin
 St[0]:=S[0];
 For J:=1 to Length(S) do
   begin
     if ( ord(S[J]) >= $41 ) and ( ord(S[J]) <= $5A )
       then
         St[J]:=chr(ord(S[J])+$20)
       else
         St[J]:=S[J]
   end;
 StrDownCase:=St;
End;

(*Function GetWordStr(S:String;K:Integer):String;
Var
 I:Integer;
 V,R:String;
Begin
 R:='';
 V:=S;
 For I:=1 to K do
  Begin
   While ((Length(V)>0) and (V[1]=' ')) do Delete(V,1,1);
   If I<>K Then
    While ((Length(V)>0) and (V[1]<>' ')) do Delete(V,1,1);
  End;
 I:=1;
 While ((I<=Length(V)) and (V[I]<>' ')) do
  Begin
   R:=R+V[I];
   Inc(I);
  End;
 GetWordStr:=R;
End;
*)
Function ReadPassword;
Var
 St:String;
 Ch:Char;
 J:Byte;
Begin
 St:='';
 Repeat
  Ch:=ReadKey;
  If Ch=#8 Then
   If Length(St)>0 Then St[0]:=Chr(Ord(St[0])-1) Else Write(#7)
  Else
   St:=St+Ch;
 Until Ch=#13;
 St[0]:=Chr(Ord(St[0])-1);
 ReadPassword:=St;
 WriteLn;
End;

Function ReadString;
Var
 I:Byte;
 Quit:Boolean;
 S:String;
 Ch:Char;
Begin
 S:='';
 Quit:=False;
 Repeat
  Ch:=ReadKey;
  If Ch=#8 Then
   Begin
    If Length(S)>0 Then
     Begin
      S[0]:=Chr(Length(S)-1);
      GotoXY(WhereX-1,WhereY);
      Write(' ');
      GotoXY(WhereX-1,WhereY);
     End
    Else Write(#7);
   End
  Else
  If Ch=#13 Then
   Quit:=True
  Else
  Begin
   S:=S+Ch;
   Write(Ch);
  End;
 Until Quit;
 ReadString:=S;
 WriteLn;
End;

Procedure Abort;
Begin
 WriteLn(Message);
 Halt(27);
End;

Procedure ColorMsg;
Begin
 TextColor(Color);
 Write(Message);
 TextColor(7);
 Writeln;
End;

Function ArrToString;
Type
 ArrType=Array[1..255] of Byte;
Var
 Ar:ArrType;
 St:String;
 J:Word;
Begin
 Ar:=ArrType(Arr);
 St:='';
 For J:=1 to 255 do
  Begin
   If Ar[J]=0 Then
    Break;
   St:=St+Chr(Ar[J]);
  End;
 ArrToString:=St;
End;

Function UniqueID;
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

Begin
  Randomize;
(*  CopyRight:='BVTools supplementary library coded by basil v. vorontsov (C)1995';*)
End.
