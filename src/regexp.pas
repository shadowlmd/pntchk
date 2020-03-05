unit regexp;
interface

Function GrepMatch(wildcard,arg:string):boolean;

implementation
const
  MaxState = 255;
  AllChars : set of Char=[#1..#255];
  EmptySet : set of Char  = [];
  Mrange = '-';  {indicates range in set, ie. [a-z]}
  Mliteral = '\';  {indicates literal follows, ie. \?}
  MnotSet = '^';  {indicates every thing but, ie. [^a-z]}

type
  Str12  = string[MaxState];
  CharSet= set of CHAR;
  states = 0..MaxState-1;
  metaCharType= (null,tClosure,tCCl,tLitChar);
  metaCharRec = record
    _set   : CharSet;
    _next  : States;
    _type  : MetaCharType;
  end;
  AMetaCharRec=array [0..MaxState-1] of MetaCharRec;

var
  arcs  : ^AMetaCharRec;
  lastState : states;
  voskl, result : boolean;


procedure MakeAutomaton(metaCharExpr:string);
var i : word;
    L : byte absolute metaCharExpr;
    procedure GetNextMetaChar(var m:MetaCharType; var ms:CharSet);
    var
      c : CHAR;
      IsIn : boolean;
            procedure Include(c:CHAR);
            begin
               if IsIn then System.Include(ms,c) else System.Exclude(ms,c);
            end;
            procedure GetChar(var c:CHAR);
            begin
               if i<=L then begin c:={UpCase(}metaCharExpr[i]{)};Inc(i) end else
c:=#0;
            end {GetChar};
            procedure DoRange;
            var
                c1,c2 : CHAR;
            begin
               m:=tCCl;c1:=#0;GetChar(c);
               if c=MnotSet then begin
                  GetChar(c);IsIn:=false;ms:=AllChars;
               end else IsIn := true;
               repeat
                  case c of
                     Mrange:if c1<>#0 then begin
                               if metaCharExpr[Pred(Pred(i))]<metaCharExpr[i]
then begin
                                  for c2:=Succ(c1) to {UpCase(}metaCharExpr[i]{)}
do Include(c2);
                                  GetChar(c);
                              end else begin GetChar(c);Include(c) end;
                         end else Include(c);
                     Mliteral:begin GetChar(c);Include(c);c:=' ' end;
                     ']':;
                     else begin Include(c);c1 := c end;
                  end {case};
                  GetChar(c);
               until (c=']') or (i>L);
            end {DoRange};
    begin {-- GetNextMetaChar --}
      ms:=EmptySet;m:=Null;GetChar(c);
      case c of
        '*':begin m:=tClosure;ms:=AllChars end;
        '[':DoRange;
        '.':begin m:=tLitChar;ms:=[c] end;
        else if c='?' then begin m:=tLitChar;ms:=AllChars end else
             if c in AllChars then begin m:=tLitChar;ms:=[c] end else
             Exit;
      end {case};
    end {GetNextMetaChar};
var
   n : word;
   m : MetaCharType;
   mset : CharSet;
begin
   FillChar(arcs^,SizeOf(arcs^),0);n:=0;i:=1;m:=tLitChar;
   while (i <= L) and (m<>Null) do begin
      GetNextMetaChar(m,mset);
      case m of
        tClosure:begin
           with arcs^[n] do begin _set:=AllChars;Inc(n);_next:=n;_type:=m end;
          GetNextMetaChar(m,mset);
          if (m<>Null)
           then with arcs^[n] do begin _set:=mset;_next:=Succ(n);_type:=m end;
        end;
        Null:;
        else with arcs^[n] do begin _set:=mset;_next:=Succ(n);_type:=m end;
      end {case};
      Inc(n);
   end {while};
   if m=Null then Dec(n);
   lastState:=n;
end {MakeAutomaton};

function  IsAcceptable(s:Str12):boolean;
var L:byte absolute s;
    function Amatch(offset:integer; patNdx:word):integer;
             function Omatch(var i:integer; patNdx:word):boolean;
             var
              advance : integer;
                ttok : MetaCharType;
                c : CHAR;
             begin
              advance:=-1;ttok:=arcs^[patNdx]._type;
                if i<=L then begin
                   c:={UpCase(}s[i]{)};
                   case ttok of
                     tLitChar:if c in arcs^[patNdx]._set then advance:=1;
                     tCCL:if c in arcs^[patNdx]._set then advance:=1;
                     tClosure:if c in arcs^[patNdx]._set then advance:=1;
                   end;
                end {if};
                if advance>=0 then begin Omatch:=true;i:=i+advance end
     else Omatch := false;
             end {Omatch};
    var
 done : boolean;
 j,k : word;
 i : integer;
 ttok : MetaCharType;
    begin
     done:=false;j:=patNdx;
        while not(done) and (j<=lastState) do begin
       ttok:=arcs^[j]._type;
              if (ttok=Null) and (offset>L) then done:=true else
              if ttok=tClosure then begin
                 i:=offset;
                 while not(done) and (i<=L) do if not(Omatch(i,j))
    then done:=true;
                done:=false;
                while not(done) and (i>=offset) do begin
                  k:=Amatch(i,Succ(j));
                 if k>0 then done:=true else Dec(i);
   end {while};
                offset:=k;done:=true;
              end else if not (Omatch(offset,j)) then begin
                offset:=0;done:=true;
              end else Inc(j);
        end {while};
        Amatch := offset;
    end {Amatch};
begin
  result:=(Amatch(1,0)>0);
  if voskl then IsAcceptable:=not result else isacceptable:= result
end;

Function Osipov(var wildcard: string) : boolean;
begin
  osipov:= false;
  voskl:= false;
  if (wildcard[1]='!') then
    begin
      delete(wildcard,1,1);
      if (wildcard[1]<>'!') then voskl:=true
    end;
  if (wildcard='@') then begin osipov:=true; exit end else
      if (wildcard[1]='@') then delete(wildcard,1,1);
end;

Function GrepMatch(wildcard,arg:string):boolean;
begin
    if osipov(wildcard)
      then
        begin
          if arg<>'' then voskl:=not voskl;
          if voskl
             then grepmatch:=false
             else grepmatch:=true;
          exit
      end;
    New(arcs);
    MakeAutomaton(wildcard);
    GrepMatch:=IsAcceptable(arg);
    Dispose(arcs);
end;

end.
