{$MODE TP}
(* {$M 65520,0,655200} *)
Unit CTLM_me;
Interface
type
  VarRec = Record
             FieldName: String [16];
             FieldValue: String [82];
           End;
  CtlArrayType = Array [1..600] of VarRec;
  CtlArrayTypePtr = ^CtlArrayType;
Var
  ReplaceMode: Boolean;
  CtlFile: Text;
  StackPointer: Word;
  CurrentCtlValue: String;
  MoreParameters: Boolean;
  Index: Word;
  CopyRight: String;
  CtlArray: CtlArrayTypePtr;
Procedure ReadCtlFile (CtlFileName: String);
{Пpочесть CTL-файл в память. Инициализиpовать пеpеменные.}
Function GetCtlValue (Variable: String): String;
{Полyчить значение пеpеменной из CTL-файла в виде String}
Procedure SplitString (Str: String; Var ParmName, ParmValue: String);
{Разpезать стpочкy "ParamName ParmValue" на два составных паpаметpа}
Procedure FindFirstParameter (WildCard: String);
{Поиск по шаблонy}
Procedure FindNextParameter;
Procedure DoneCtlManager;
{пеpед выходом}
Implementation
{Uses DOS;}
Var
  PW: String;
Procedure RemoveSpaces (Var S: String);
Begin
  While (S [1] = ' ') and (Length (S) > 0) do Delete (S, 1, 1);
  While (S [Length (S) ] = ' ') and (Length (S) > 0) do S [0] := Chr (Ord (S [0] ) - 1);
End;
Procedure SplitString;
Begin
  If Pos ('=', Str) > 0 Then
    Delete (Str, Pos ('=', Str), 1);
  ParmName := Copy (Str, 1, Pos (' ', Str) );
  RemoveSpaces (ParmName);
  Delete (Str, 1, Pos (' ', Str) );
  RemoveSpaces (Str);
  ParmValue := Str;
End;
Function ParmNumber (Parm: String; Number: Byte): String;
Var
  I, B: Byte;
  SS, Param: String;
Begin
  Param := Parm;
  While Length (Param) > 16 do Param [0] := Chr (Ord (Param [0] ) - 1);
  While Length (Param) < 16 do Param := Param + ' ';
  For I := 1 to 16 do
  Begin
    Param [I] := UpCase (Param [I] );
    If Param [I] = ' ' Then
      Param [I] := '_';
  End;
  Str (Number, SS);
  If Length (SS) = 1 Then SS := '00' + SS;
  If Length (SS) = 2 Then SS := '0' + SS;
  Param [14] := SS [1];
  Param [15] := SS [2];
  Param [16] := SS [3];
  ParmNumber := Param;
End;
Function GetCtlValue(Variable: String):String;
Var
  Param: String;
  I, J: Word;
Begin
  Param := Variable;
  While Length (Param) > 16 do Param [0] := Chr (Ord (Param [0] ) - 1);
  While Length (Param) < 16 do Param := Param + ' ';
  For I := 1 to 16 do
  Begin
    Param [I] := UpCase (Param [I] );
    If Param [I] = ' ' Then
      Param [I] := '_';
  End;
  GetCtlValue := '';
  For J := 1 to StackPointer-1 do
  Begin
    If (CtlArray^ [J].FieldName = Param)  {or (CtlArray^[J].FieldName=ParmNumber(Param,0))} Then
      GetCtlValue := CtlArray^ [J].FieldValue;
  End;
End;
Procedure ReadCtlFile;
Var
  Line, Param: String;
  I, J: Word;
Begin
  StackPointer := 1;
  New (CtlArray);
  Assign (CtlFile, CtlFileName);
  {$I-}
  Reset (CtlFile);
  {$I+}
  If IOResult <> 0 Then
    Halt (27);
  While not EoF (CtlFile) do
  Begin
    ReadLn (CtlFile, Line);
    RemoveSpaces (Line);
    For I := 1 to Length (Line) do
      If Line [I] = #9 Then
        Line [I] := ' ';
    If Pos (';', Line) > 0 Then
      Delete (Line, Pos (';', Line), Length (Line) - Pos (';', Line) + 1);
    If (Line <> '') and (Line [1] <> '%') and (Pos (' ', Line) > 0) Then
    Begin
      If Pos ('=', Line) > 0 Then
        Delete (Line, Pos ('=', Line), 1);
      Param := Copy (Line, 1, Pos (' ', Line) );
      RemoveSpaces (Param);
      Delete (Line, 1, Pos (' ', Line) );
      RemoveSpaces (Line);
      While Length (Line) > 82 do Line [0] := Chr (Ord (Line [0] ) - 1);
      While Length (Param) > 16 do Param [0] := Chr (Ord (Param [0] ) - 1);
      While Length (Param) < 16 do Param := Param + ' ';
      For I := 1 to 16 do
      Begin
        Param [I] := UpCase (Param [I] );
        If Param [I] = ' ' Then
          Param [I] := '_';
      End;
      If GetCtlValue (Param) <> '' Then
      Begin
        For J := 1 to StackPointer - 1 do
        Begin
          If CtlArray^ [J].FieldName = Param Then
          Begin
            CtlArray^ [J].FieldName := ParmNumber (CtlArray^ [J].FieldName, 0);
            CtlArray^ [StackPointer].FieldName := ParmNumber (Param, 1);
            CtlArray^ [StackPointer].FieldValue := Line;
            Inc (StackPointer);
          End;
        End;
      End
      Else
        If GetCtlValue (ParmNumber (Param, 0) ) <> '' Then
        Begin
          J := 0;
          Repeat
            Inc (J);
          Until GetCtlValue (ParmNumber (Param, J) ) = '';
          CtlArray^ [StackPointer].FieldName := ParmNumber (Param, J);
          CtlArray^ [StackPointer].FieldValue := Line;
          Inc (StackPointer);
        End
        Else
        Begin
          CtlArray^ [StackPointer].FieldName := Param;
          CtlArray^ [StackPointer].FieldValue := Line;
          Inc (StackPointer);
        End;
    End;
  End;
  Close (CtlFile);
  For J := 1 to StackPointer do
  Begin
    While Length (CtlArray^ [J].FieldName) < 16 do CtlArray^ [J].FieldName := CtlArray^ [J].FieldName + ' ';
    For I := 1 to 16 do
    Begin
      CtlArray^ [J].FieldName [I] := UpCase (CtlArray^ [J].FieldName [I] );
      If (CtlArray^ [J].FieldName [I] ) = ' ' Then
        CtlArray^ [J].FieldName [I] := '_';
    End;
  End;
End;
Procedure FindFirstParameter;
Begin
  Index := 1;
  PW := WildCard;
  MoreParameters := True;
  If (Index = 1) and (GetCtlValue (PW) = '') and (GetCtlValue (ParmNumber (PW, 0) ) = '') Then
  Begin
    MoreParameters := False;
    Exit;
  End;
  If GetCtlValue (PW) <> '' Then
   CurrentCtlValue := GetCtlValue (PW)
  Else
   CurrentCtlValue := GetCtlValue (ParmNumber (PW, Index - 1) );
  Inc (Index);
End;
Procedure FindNextParameter;
Begin
  MoreParameters := True;
  If GetCtlValue (ParmNumber (PW, Index - 1) ) = '' Then
  Begin
    MoreParameters := False;
    Exit;
  End;
  CurrentCtlValue := GetCtlValue (ParmNumber (PW, Index - 1) );
  Inc (Index);
End;
Procedure DoneCtlManager;
Begin
(*  CopyRight := '.CTL support library v 1.2 coded by basil v. vorontsov (C)1995';*)
  Dispose (CtlArray);
End;
Begin
  ReplaceMode := True;
End.
