{
    This file is devoid of functionality version of CRT unit
    that is part of the Free Pascal run time library.

 **********************************************************************}
unit crtfake;

interface
Const
{ CRT modes }
  BW40          = 0;            { 40x25 B/W on Color Adapter }
  CO40          = 1;            { 40x25 Color on Color Adapter }
  BW80          = 2;            { 80x25 B/W on Color Adapter }
  CO80          = 3;            { 80x25 Color on Color Adapter }
  Mono          = 7;            { 80x25 on Monochrome Adapter }
  Font8x8       = 256;          { Add-in for ROM font }

{ Mode constants for 3.0 compatibility }
  C40           = CO40;
  C80           = CO80;

{ Foreground and background color constants }
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

{ Foreground color constants }
  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

{ Add-in for blinking }
  Blink         = 128;

var

{ Interface variables }
  CheckBreak: Boolean;    { Enable Ctrl-Break }
  CheckEOF: Boolean;      { Enable Ctrl-Z }
  DirectVideo: Boolean;   { Enable direct video addressing }
  CheckSnow: Boolean;     { Enable snow filtering }
  LastMode: Word = 3;         { Current text mode }
  TextAttr: Byte = $07;         { Current text attribute }
  WindMin: Word  = $0;          { Window upper left coordinates }
  WindMax: Word  = $184f;          { Window lower right coordinates }
  { FPC Specific for large screen support }
  WindMinX : DWord;
  WindMaxX : DWord;
  WindMinY : DWord;
  WindMaxY : DWord      ;

type
  { all crt unit coordinates are 1-based }
  tcrtcoord = 1..255;

{ Interface procedures }
procedure AssignCrt(var F: Text);
function KeyPressed: Boolean;
function ReadKey: Char;
procedure TextMode (Mode: word);
procedure Window(X1,Y1,X2,Y2: Byte);
procedure GotoXY(X,Y: tcrtcoord);
function WhereX: tcrtcoord;
function WhereY: tcrtcoord;
procedure ClrScr;
procedure ClrEol;
procedure InsLine;
procedure DelLine;
procedure TextColor(Color: Byte);
procedure TextBackground(Color: Byte);
procedure LowVideo;
procedure HighVideo;
procedure NormVideo;
procedure Delay(MS: Word);
procedure Sound(Hz: Word);
procedure NoSound;

{Extra Functions}
procedure cursoron;
procedure cursoroff;
procedure cursorbig;


implementation


{****************************************************************************
                             Public Crt Functions
****************************************************************************}

procedure TextMode (Mode: word);
begin
end;

Procedure TextColor(Color: Byte);
Begin
End;

Procedure TextBackground(Color: Byte);
Begin
End;

Procedure HighVideo;
Begin
End;

Procedure LowVideo;
Begin
End;

Procedure NormVideo;
Begin
End;

Procedure GotoXY(X: tcrtcoord; Y: tcrtcoord);
begin
end;

Procedure Window(X1, Y1, X2, Y2: Byte);
begin
end;

procedure ClrScr;
begin
end;

procedure ClrEol;
begin
end;

Function WhereX: tcrtcoord;
begin
WhereX:=1;
end;

Function WhereY: tcrtcoord;
begin
WhereY:=1;
end;

{*************************************************************************
                            KeyBoard
*************************************************************************}

function KeyPressed : boolean;
begin
KeyPressed := false;
end;


function ReadKey: char;
begin
ReadKey := #00;
end;

procedure Delay(MS: Word);
begin
end;

procedure sound(hz : word);
begin
end;

procedure nosound;
begin
end;

procedure delline;
begin
end;

procedure insline;
begin
end;

{****************************************************************************
                             Extra Crt Functions
****************************************************************************}

procedure cursoron;
begin
end;


procedure cursoroff;
begin
end;


procedure cursorbig;
begin
end;


{*****************************************************************************
                          Read and Write routines
*****************************************************************************}

procedure AssignCrt(var F: Text);
begin
end;

end.