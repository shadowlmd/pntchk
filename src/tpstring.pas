unit TPString;
  {-Basic string manipulation routines}

interface

(*type
  CharSet = set of Char;
  CompareType = (Less, Equal, Greater);
  BTable = array[0..255] of Byte; {For Boyer-Moore searching}
  {$IFOPT N+}
   Float = Extended;
  {$ELSE}
   Float = Real;
  {$ENDIF}*)
(*const
  {used by CompareLetterSets for estimating word similarity}
  LetterValues : array['A'..'Z'] of Byte = (
    3 {A} , 6 {B} , 5 {C} , 4 {D} , 3 {E} , 5 {F} , 5 {G} , 4 {H} , 3 {I} ,
    8 {J} , 7 {K} , 4 {L} , 5 {M} , 3 {N} , 3 {O} , 5 {P} , 7 {Q} , 4 {R} ,
    3 {S} , 3 {T} , 4 {U} , 6 {V} , 5 {W} , 8 {X} , 8 {Y} , 9 {Z} );
const
  MoneySign : Char = '$';    {Used by Form for floating dollar sign}
  CommaForPeriod : Boolean = False; {replace '.' with ',' in Form masks}*)

  {-------- Numeric conversion -----------}

function HexB(B : Byte) : string;
  {-Return hex string for byte}

function HexW(W : Word) : string;
  {-Return hex string for word}

function HexL(L : LongInt) : string;
  {-Return hex string for longint}

implementation

type
  Long =
    record
      LowWord, HighWord : Word;
    end;
const
  Digits : array[0..$F] of Char = '0123456789ABCDEF';
(*const
  DosDelimSet : set of Char = ['\', ':', #0];*)

(*  {$L TPCASE.OBJ}
  {$L TPCOMP.OBJ}
  {$L TPSEARCH.OBJ}
  {$L TPTAB.OBJ}
  {$L TPBM.OBJ}*)

  function HexB(B : Byte) : string;
    {-Return hex string for byte}
  begin
    HexB[0] := #2;
    HexB[1] := Digits[B shr 4];
    HexB[2] := Digits[B and $F];
  end;

  function HexW(W : Word) : string;
    {-Return hex string for word}
  begin
    HexW[0] := #4;
    HexW[1] := Digits[hi(W) shr 4];
    HexW[2] := Digits[hi(W) and $F];
    HexW[3] := Digits[lo(W) shr 4];
    HexW[4] := Digits[lo(W) and $F];
  end;

  function HexL(L : LongInt) : string;
    {-Return hex string for LongInt}
  begin
    with Long(L) do
      HexL := HexW(HighWord)+HexW(LowWord);
  end;

end.
