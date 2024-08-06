{ ----- fixed -------- unable to open in R/W}
{ ----- fixed -------- @seglines=0 when MEDIUM }
{ ----- fixed -------- run-error 218 in freeBSD }
{ ----- fixed -------- writeln 0d/0a in UNIX }
{ ----- fixed -------- crtfake }
{ ----- fixed -------- clrscr }
{ ----- fixed -------- �᫨ �� ����� SEGMENTFORMAT }
{ ----- fixed -------- 0A/0D}
{ ----- fixed -------- �� lite-���ᨨ ���� ������� pntchk.exe }
{ ----- fixed -------- msg>32000 }

{ StrUpCase -> UpCase }
{ �஢�ઠ �� ᮮ⢥��⢨� ����� ᥣ���� ����� ����� }
{ use fillchar!!! move }
{ rename -> ioresult<>0 -> copy/del }
{ ����� ���४⭠� ࠡ�� � inadmis chars (㤠���� �ࠧ� ��᪮�쪮) }
{ ��⠢�� " ... " � ���䨣-��ப�� }
{ HUBPOINTS -> includesegments }
{ ����� 䫠�� �� ����� 32 ᨬ����� }
{ bug: invalid segment name }
{ no points }
{Year 2000 check}
{����������� ���뫪�� ���쬠 �모���� ᥣ����}
{ndlname must not be equal with indexname}
{p���� �p���� ����⫨��}
{comma deleted}
{�� ���뫠�� ���� ���p�����p�, �᫨ COODRD=FROM}
{*.pkt, squish}
{check pointlist}

(*{$M 65520,0,200000}*)
{$IFDEF VIRTUALPASCAL }
{$M 32767,0,200000 }
{$ELSE}
{$M 65520,0,200000 }
{$ENDIF}
{$I-,V-,S+,F+,D-,L-,R-,X+}
(* {$S+} *)
Program PNTCHK;
Uses {$IFDEF LINUX} {$IFDEF BSD} linux, {$ELSE} unix, {$ENDIF} {$ENDIF} dos, {$IFDEF BW} CrtFake, {$ELSE} Crt, {$ENDIF}
     ctlm_me, LOGMan_m, BVTools, Netma_me, tpstring,
     crcunit, regexp  {$IFDEF VIRTUALPASCAL} {$ELSE} , swapunit {$ENDIF};

Const
  NameProg = {$IFDEF VIRTUALPASCAL } {$IFDEF WIN32} 'PNTCHK/W32' {$ELSE} {$IFDEF DOS32} 'PNTCHK/32' {$ELSE}
             {$IFDEF LINUX} {$IFDEF FREEBSD} 'PNTCHK/BSD' {$ELSE} 'PNTCHK/LNX' {$ENDIF} {$ELSE} {$IFDEF EMX} 'PNTCHK/EMX'
             {$ELSE} 'PNTCHK/2' {$ENDIF} {$ENDIF} {$ENDIF}
             {$ENDIF}
             {$ELSE} 'PNTCHK' {$ENDIF};
{$IFDEF WIN32}  namefprog = 'W'; {$ENDIF}
{$IFDEF EMX}    namefprog = 'E'; {$ENDIF}
{$IFDEF DOS32}  namefprog = 'P'; {$ENDIF}
{$IFDEF LINUX}  namefprog = {$IFDEF FREEBSD} '.BSD' {$ELSE} '.LNX' {$ENDIF}; {$ENDIF}
{  Version = '1.00+ (final)';}
  Version = '1.00.rc6';
  DefCommentCount = 5;
{errorlevels}
{  GoodSegment = 1;}
{  BadSegment = 2;}

  Segnotopen = 201;
  Unabletocreatelogfile = 202;
  Ctlnotopen = 203;
  NetMailNotFound = 204;
  MasterNotFound = 205;
  BadfilesNotFound = 206;
  Cannotcreatetempfile = 207;
  cantmove = 208;
  backupNotFound = 209;
  tempdirNotFound = 210;
  templateNotFound = 211;
  unabletocreatepointlist = 212;
  notcompatiblewithlitemode = 213;
  tplcount = 65;

  lite: boolean = false;

  TplConst2 : array [1..tplcount-10] of string[16] = ('@NDLNAME', {1}
    '@ERRORNUMBER',    {2}
    '@WARNINGNUMBER',  {3}
    '@NAMEPROG',       {4}
    '@SERIAL',         {5}
    '@OWNER',          {6}
    '@VERSION',        {7}
    '@SEGNAME',        {8}
    '@SEGLENGTH',      {9}
    '@SEGDATE',        {10}
    '@RESULT',         {11}
    '@COMMENTCOUNT',   {12}
    '@REASON',         {13}
    '@SEGLINES',       {14}
    '@CURRENTSTRING',  {15}
    '@SEGFORMAT',      {16}
    '@IDEALSTRING',    {17}
    '@ADDRESS',        {18}
    '@SENDER',         {19}
{-------- splitstring --------}
    '@POINT',          {20}
    '@SYSTEM',         {21}
    '@SYSOP',          {22}
    '@LOCATION',       {23}
    '@PHONE',          {24}
    '@PREFIX',         {25}
    '@BAUD',           {26}
    '@FLAGS',          {27}
{-------- splitstring --------}
    '@NEWSEGNAME',     {28}
    '@CURRENTFLAG',    {29}
    '@IMPLTOFLAG',     {30}
    '@INADMCHAR',      {31}
    '@LINENUMBER',     {32}
    '@SEGFULLNAME',    {33}
    '@NEWPHONE',       {34}
    '@NEWLOCATION',    {35}
    '@OLDFLAGS',       {36}
    '@SPEED',          {37}
    '@NEWBAUD',        {38}
    '@ADDEDFLAG',      {39}
    '@FIRSTSYSOPNAME', {40}
    '@LASTSYSOPNAME',  {41}
    '@NDLFULLNAME',    {42}
    '@SEGWRNAGE',      {43}
    '@SEGERRAGE',      {44}
    '@DAYSTOEXPIRE',   {45}
    '@NEWSYSTEM',      {46}
    '@NEWSYSOP',       {47}
    '@DATE',           {48}
    '@MONTH',          {49}
    '@YEAR',           {50}
    '@WEEKDAY',        {51}
    '@DAYNUMBER',      {52}
    '@PNTLCRC',        {53}
    '@PNTLNAME',       {54}
    '@NEWSEGDATE');    {55}

Var Ctlfl: string[80];
   TplConst : array [1..tplcount] of string[16];
   a4,a2,a3,str1,str4,postr,str2,str3,owner,serial: string;
   i: {$IFDEF VIRTUALPASCAL} LongInt {$ELSE} integer {$ENDIF};
   j,lk: integer;
   ertpl,segfl,templfl,tempfl2: text;
   tmpfile: file of byte;
   numb: longint;
   Net: TNetmail;
   addr,addr2: taddrtype;
{   a1, a2, a3, a4: word;}
   ch1: char;
   Tplar : array [1..tplcount] of string;

   ftime : Longint; { For Get/SetFTime}
   dt : DateTime; { For Pack/UnpackTime}

   unixlines,wasattr,endflag,eoff: boolean;
{   namefprog: string;}

  DirInfo,DirInfo2: SearchRec;
 SEGMENTFORMAT: array[1..20] of string;
 formcount: byte;
 result: byte;

 infile2: file of byte;
 IndexFile: file of longint;
 indexfile2: file of byte;

{$IFDEF LINUX}
{$IFNDEF BSD}

Function Utime(var f;utim:utimebuf):boolean;
var
  sr : Syscallregs;
begin
  sr.reg2:=longint(@(filerec(f).name[0]));
  sr.reg3:=longint(@utim);
  Utime:=SysCall(Syscall_nr_utime,sr)=0;
  linuxerror:=errno;
end;

{$ELSE}

Function Utime(var f;utim:utimebuf):boolean;
begin
  Utime:=do_syscall(syscall_nr_utimes,longint(@filerec(f).name[0]),longint(@utim))=0;
  linuxerror:=errno;
end;

{$ENDIF}

Procedure setftime(var f; time : longint);
Var
  utim: utimbuf;
  DT: DateTime;

Begin

  doserror:=0;
 
  with utim do begin
    actime:=gettimeofday;
    UnPackTime(Time,DT);
    modtime:=DTToUnixDate(DT);
  end;

  if not utime(f,utim) then
   begin
     Time:=0;
     doserror:=3;
     exit
   end;
  
end;

{$ENDIF}

Procedure runerror(module: string;numbar: byte);
begin
 if ioresult<>0 then writeln('Run-time error $0000:000',xstr(numbar),' in module: ',module,'! Please contact the author!')
end;

Function GetCtlValueLite(Param: String):String;
Begin
  If lite then GetCtlValueLite:='' else GetCtlValueLite:=GetCtlValue(Param);
End;

{
     ASSIGN         

                    
                
     BAUDERRTPL     IMPLERRTPL                 SYSOPERRTPL
     CMNTERRTPL     INADMCHARERRTPL  PHONEERRTPL     SYSTEMERRTPL
                           
		     LOCATERRTPL      PNTLSTERRTPL    
     DUPFLGERRTPL                  
     EMPTYLINETPL               

     EQNUMERRTPL    NDLERRTPL            

  NDLINDEX             
}


Function test(ada: integer; strseg: string): string;

var pora3,pora4: string;
  regar: array [1..11] of byte;
  ter: integer;
  feda: byte;

begin


    for j:=1 to 11 do regar[j]:=0;
    for j:=length(xstr(ada)) downto 1 do
        regar[11-length(xstr(ada))+j]:=xval(copy(xstr(ada),j,1));

{   if plokho then plokho:=false;}

     pora3:=strupcase(strseg);
     pora4:=pora3;

     ter:=11;

     for j:=length(pora3) downto 1 do
      begin

       if (pora3[j]='D') then
         if pora3[j-1]='~' then
           begin
             pora4[j]:=chr(regar[ter]+48);
             dec(ter);
             dec(j);
           end;

       if (pora3[j]='H') then
         if pora3[j-1]='~' then
           begin
             feda:=ter;
             repeat
               dec(feda);
             until (regar[feda]<>0) or (feda=1);
             if (regar[feda]<>0) and (regar[ter] in [0..5]) then
                begin
                  dec(regar[feda]);
                  for feda:=feda+1 to ter-1 do regar[feda]:=9;
                  case regar[ter] of
                   0: pora4[j]:='A';
                   1: pora4[j]:='B';
                   2: pora4[j]:='C';
                   3: pora4[j]:='D';
                   4: pora4[j]:='E';
                   5: pora4[j]:='F';
                  end; {case}
                end
              else pora4[j]:=chr(regar[ter]+48);
             dec(ter);
             dec(j);
           end;

     end;

    while pos('~',pora4)<>0 do delete(pora4,pos('~',pora4),1);
    for j:=ter downto 1 do if regar[j]<>0 then pora4:='';
    test:=pora4;

end;

Function TestName(stpath: string): string;
var per,ter: integer;
    perdat: longint;
    stri1,stri2,stri3: string;
    rc: integer;
begin

   per:=0;
   perdat:=0;
   stri1:='';

   repeat
     inc(per);

    stri2:=segmentformat[per];

    for ter:=length(stri2) downto 1 do if (stri2[ter-1]<>'~') and (stri2[ter]<>'~') and (stri2[ter]<>'.') then stri2[ter]:='?';

    stri3:=test(lk,stri2);

if stri3<>'' then begin

    findfirst(stpath+stri3,$3F,dirinfo);
    rc:=doserror;
      while rc=0 do
        begin
          if perdat<dirinfo.time then
             begin
               perdat:=dirinfo.time;
               stri1:=stpath+dirinfo.name
             end;
          findnext(dirinfo);
          rc:=doserror
        end;

     {$IFDEF VIRTUALPASCAL} findclose(dirinfo); {$ENDIF}


end;

   until per=formcount;


   testname:=stri1

end;

Procedure changetime;
var tfile: file;
begin

 assign(tfile,tplar[33]);
 reset(tfile);
 setftime(tfile,ftime);
 close(tfile)

end;

function paramo(para: string{; number: byte}): string;
var a1: byte;
    st1,st2: string;
begin

  a1:= pos('%O',strupcase(para));
  if (a1<>0)
    then if para[a1-1]='%' then delete(para,a1-1,1)
                           else

   begin
      st1:= GetCTLValueLite ('MASTER');
      if st1='' then getdir(0,st1);
      if st1[length(st1)]<> {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} then st1:=st1+ {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} ;

      st2:= testname(st1);
      if st2<>'' then
         begin

           delete(para,a1,2);
           insert(st2,para,a1)

         end
   end;

  a1:= pos('%S',strupcase(para));
  if (a1<>0)
    then if para[a1-1]='%' then delete(para,a1-1,1)
                           else
begin
  delete(para,a1,2);
  insert(tplar[33],para,a1)

end;

  a1:= pos('%P',strupcase(para));
  if (a1<>0)
    then if para[a1-1]='%' then delete(para,a1-1,1)
                           else
begin
  delete(para,a1,2);
  insert(tplar[54],para,a1)

end;

  a1:= pos('%D',strupcase(para));
  if (a1<>0)
    then if para[a1-1]='%' then delete(para,a1-1,1)
                           else
begin
  delete(para,a1,2);
  insert(tplar[52],para,a1)

end;

paramo:=para

end;

Procedure execpr(paramst:string);
var rc: integer;
  {$IFDEF LINUX }
    progr,param:string;
  {$ENDIF}

begin

logmsg('%','Executing : '+paramst);

  {$IFDEF VIRTUALPASCAL }

  {$IFDEF LINUX }

  splitstring(paramst,progr,param);
  if progr='' then begin progr:=param; param:='' end;

  Exec( progr, param );

  {$ELSE}

Exec( getenv ( 'COMSPEC' ), '/C'+paramst );

  {$ENDIF}

  {$ELSE}

    if prepareswap ( ptr ( seg ( freelist ^ ) + $1000, 0 ), 'pntchk.$$$' ) then
    begin
        swap ( getenv ( 'COMSPEC' ), '/C'+paramst);
        removeswap
    end;
    gotoxy(1,wherey-1);

 {$ENDIF}

rc:= doserror;
if rc=0 then
    rc:= dosexitcode;
logmsg('%','SWAP RESULT: '+ xstr(rc));
end;

Procedure execonce;

var st1: string;

Procedure touch(flagname: string);
var
aaa:file;
io:word;
begin
   assign(aaa,flagname);
   rewrite(aaa);
   io:=ioresult;
   if io=0 then begin
       close(aaa);
       io:=ioresult
     end;
    if io<>0 then logmsg('!','An error occured creating the flagfile : '+strupcase(flagname))
      else logmsg('%','Creating the flagfile : '+strupcase(flagname))
end;

begin

 changetime;


 if tplar[11] {@result} = 'ok' then
   begin
     st1:= getctlvaluelite('EXECGOOD');
     if st1 <> '' then execpr(paramo(st1));
     st1:= getctlvaluelite('TOUCHGOOD');
     if st1 <> '' then touch(st1);
     if (result-2 <> 1) or (result<>1) then result:=result+1;
   end;

 if tplar[11] {@result} = 'bad' then
   begin
     st1:= getctlvaluelite('EXECBAD');
     if st1 <> '' then execpr(paramo(st1));
     st1:= getctlvaluelite('TOUCHBAD');
     if st1 <> '' then touch(st1);
     if result<2 then result:=result+2;
   end
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

Function retfname(p:pathstr;put:boolean):string;
var
  D: DirStr;
  N: NameStr;
  E: ExtStr;
begin
  FSplit(P, D, N, E);
  if put then retfname:=D else retfname:=N+E
end;

Procedure haltonerror(logmessage: string; errorcode: word);
begin
{   colormsg (lightred, screenmsg);}
   logmsg('!',logmessage);
   closelogfile ('Program halted ('+xstr(errorcode)+')');
 
   str1:= getctlvalue('TEMPDIR');

   DoneCTLManager;
{   textcolor(7); write(' ');}

  if str1<>'' then if str1[length(str1)]<> {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} then str1:=str1+ {$IFDEF LINUX} '/'
                                        {$ELSE} '\' {$ENDIF} ;
  str2:='MSG_TMP.FFF';

  if exist(str1+str2) then begin
    assign(templfl, str1+str2);
    erase(templfl)
  end;

   halt(errorcode)
end;

Function createtpl(tplnm: string): string;
type tpltype = array[1..20] of string;
     tplfiletype = array[1..20] of text;
var tplara: ^tpltype;
    tpfl: ^tplfiletype;
    tmpfl: text;
    str8,str7: string;
    k,m: integer;
    b1,b2: byte;
    endstring: boolean;

begin
 runerror('createtpl',1);
 b1:=0; b2:=0;
 endstring:=false;
 new(tpfl);
 assign(tpfl^ [1],tplnm);
 reset(tpfl^ [1]);
 if ioresult<>0 then
   begin
     str8:=getctlvaluelite('TEMPLATEPATH');
     if str8[length(str8)]<> {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then str8:=str8+ {$IFDEF LINUX} 
'/' {$ELSE}  
'\'{$ENDIF} ;
     str8:=str8+tplnm;
     assign(tpfl^ [1],str8);
     reset(tpfl^ [1]);
     if ioresult<>0 then
       begin
         haltonerror('Error opening template file : '+tplnm,templateNotFound);
     end; end;

 str8:=getctlvalue('TEMPDIR');
 if str8[length(str8)]<> {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then str8:=str8+ {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} 
;
 k:=length(tplnm);
 repeat
   dec(k);
 until (tplnm[k]= {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ) or (k=0);
 str8:=str8+copy(tplnm,k+1,length(tplnm)-k);
 assign(tmpfl,str8);
 rewrite(tmpfl);
 if ioresult<>0 then begin
   haltonerror('Error creating temporary file : '+str8,207);
{   createtpl:='';
   exit}
 end;

 createtpl:=str8;

 new(tplara);

 m:=1;

 repeat
   readln(tpfl^ [m],str8);


   b1:= pos(';',str8);
   if b1<>0 then
begin
 if str8[b1-1]<>'\'
                  then
                    delete(str8,b1,length(str8)-b1+1)
                  else
                    delete(str8,b1-1,1);
end;
   if b1=1 then b2:=1;
   b1:= pos('@END',strupcase(str8));
   if (b1=1) and (m>1) then b2:=1;
   if (b1<>0) and (m>1) then begin delete(str8,b1,length(str8)-b1+1); if m>1 then close(tpfl^ [m]); endstring:=true;
       if m>1 then dec(m) end
     else if eof(tpfl^ [m]) then begin if m>1 then close(tpfl^ [m]); endstring:=true; if m>1 then dec(m) end;

 for k:=tplcount-9 to tplcount do
 if tplar[k,1]='@' then
  begin
   b1:= pos(strupcase(tplconst[k]),strupcase(str8));
   if b1<>0 then
    begin
     tplara^ [m]:=copy(str8,b1+length(tplconst[k]),length(str8)-b1-length(tplconst[k]));
     str8:=copy(str8,1,b1-1);
     inc(m);
     assign(tpfl^ [m],copy(tplar[k],2,length(tplar[k])-1));
     reset(tpfl^ [m]);
     if ioresult<>0 then begin
      str7:=getctlvaluelite('TEMPLATEPATH');
      if str7[length(str7)]<> {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then str7:=str7+ {$IFDEF LINUX} 
'/' {$ELSE} '\' {$ENDIF};
      str7:=str7+copy(tplar[k],2,length(tplar[k])-1);
      assign(tpfl^ [m],str7);
      reset(tpfl^ [m]);
      if ioresult<>0 then
        begin
          logmsg('!','Error opening template file : '+copy(tplar[k],2,length(tplar[k])-1));
          dec(m)
        end;
      k:=tplcount
    end;
    end;
  end;

  if (b1<>1) and (b2<>1) then writeln(tmpfl,str8);
   b1:=0; b2:=0;
  if endstring then begin
    if tplara^ [m]<>'' then begin writeln(tmpfl,tplara^ [m]); tplara^ [m]:='' end;
    endstring:= false
   end;
 until eof(tpfl^ [1]) or (m=0);

 dispose(tplara);
 close(tmpfl);
 close(tpfl^ [1]);
 dispose(tpfl);
end;

Procedure incerror(err: boolean);
var  wore: integer;
 numg: byte;
begin
 if err then numg:=2 else numg:=3;
 wore:= xval(tplar[numg]); {@errornumber or @warningnumber}
 if wore=-1 then inc(wore);
 inc(wore);
 tplar[numg]:= xstr(wore);
 if err then tplar[11]:='bad';
end;

Procedure decerror(err: boolean);
var  wore: integer;
 numg: byte;
begin
 if err then numg:=2 else numg:=3;
 wore:= xval(tplar[numg]); {@errornumber or @warningnumber}
 if wore<>-1 then dec(wore);
 if wore=0 then tplar[numg]:= '0 (none)' else tplar[numg]:= xstr(wore);
 if tplar[2]='0 (none)' then tplar[11]:='ok'
end;

Procedure registration;
var
 k,ch2,ch4,ch6: byte;
 hex1,hex2,hex3: string;
 regname,regstring: string;
 aaa: longint;

BEGIN
 regname:=getctlvalue('REGISTERNAME');
 regstring:=getctlvalue('REGISTERKEY');
 hex2:=regname;
 regname:=regname+regstring;
 aaa:=342453534;
 for i:=1 to length(regname)-8 do
  begin
  if i=length(regname)-8 then if (aaa=-12953656) or (aaa=812315) then exit;
  if i mod 2 = 0 then aaa:=aaa*ord(regname[i]) else aaa:=aaa div ord(regname[i]);
 end;
 hex1:=hexl(aaa);
 if hex1<>copy(regname,length(regname)-7,8) then exit;

 hex3:='Q#';

 for k:=1 to 18 do
begin

 ch1:=regstring[k];
 case ch1 of
   'A': i:=10;
   'B': i:=11;
   'C': i:=12;
   'D': i:=13;
   'E': i:=14;
   'F': i:=15;
  else i:= xval(ch1);
 end; {case}

 inc(k);

 ch1:=regstring[k];
 case ch1 of
   'A': j:=10;
   'B': j:=11;
   'C': j:=12;
   'D': j:=13;
   'E': j:=14;
   'F': j:=15;
  else j:= xval(ch1);
 end; {case}

 case k of
   2,8,14: ch2:=i*16+j;
   4,10,16: ch4:=i*16+j-ch2;
   6,12,18: begin ch6:=i*16+j-ch2;
           hex3:=hex3+chr(ch2+ch4+ch6)
           end;
 end; {case}

end;

 ch1:= regstring[19];
 case ch1 of
   '1': hex3:=hex3+'A';
   '2': hex3:=hex3+'B';
   '3': hex3:=hex3+'C'
  end; {case}

 serial:=hex3;
 owner:=hex2;
end;

function readunixln(var f: file; var buffer: string): boolean;
var
    pos: longint;
    actualread: {$IFDEF VIRTUALPASCAL} longint {$ELSE} word {$ENDIF};
    len: byte;
begin
    pos:=filepos(f);
    buffer[0]:=chr(0);
    blockread(f,buffer[1],255,actualread);
    for len:=1 to actualread do
      if buffer[len]=chr($0A) then
          break;
    if (len=actualread) and (buffer[len]<>chr($0A))
      then buffer[0]:=chr(len)
    else
      buffer[0]:=chr(len-1);
    if buffer[ord(buffer[0])]=chr($0D) then
      begin
        buffer[0]:=chr(ord(buffer[0])-1);
        readunixln:=false
      end
        else readunixln:=true;
    if (actualread=0) or ((actualread<255) and (len>=actualread))
      then
        seek(f,0)
      else
        seek(f,pos+len);
end;

Procedure splitaddress(addrstr: string; var z, n, f, p: word);
 var ch1: char;
begin
 i:=0;
 repeat
  inc(i);
  ch1:= addrstr[i];
 until ch1=':';
 z:= xval(copy(addrstr,1,i-1));
 j:=i;
 repeat
  inc(i);
  ch1:= addrstr[i];
 until ch1='/';
 n:= xval(copy(addrstr,j+1,(i-1)-(j+1)+1));
 j:=i;
 repeat
  inc(i);
  ch1:= addrstr[i];
 until (ch1='.') or (i=length(addrstr));
 if ch1='.' then
 begin
  f:= xval(copy(addrstr,j+1,(i-1)-(j+1)+1));
  p:= xval(copy(addrstr,i+1,length(addrstr)-(i+1)+1))
 end
 else begin
   f:= xval(copy(addrstr,j+1,(i-1)-(j+1)+2));
   p:=0
 end
end;

Function tplstring(stro: string): string;
var h: integer;
    b1: byte;
    stri,stra: string;
begin
 stri:=stro;
{ b1:= pos(';',stri);
 if b1<>0 then
begin
 if stri[b1-1]<>'\'
                  then
                    delete(stri,b1,length(stri)-b1+1)
                  else
                    delete(stri,b1-1,1);
end;}
 b1:= pos('@END',strupcase(stri));
 if b1<>0 then begin delete(stri,b1,length(stri)-b1+1); endflag:=true end;
{ writeln(strupcase(stra));}

 stra:=stri;

 for h:=1 to tplcount do
  begin
   b1:= pos(tplconst[h],strupcase(stra));
   if b1<>0 then
    begin
{  writeln(tplconst[h]);}
     stri:='';
     stri:=copy(stra,1,b1-1);
     stri:=stri+tplar[h];
     stri:=stri+copy(stra,b1+length(tplconst[h]),length(stra)-b1-length(tplconst[h])+1);
     stra:=stri;
    end
  end;
 for h:=1 to length(stri) do
     if ord(stri[h])<33 then stri[h]:=#32;
 tplstring:=stri;
end;

Procedure setmsgflags;
var flagstr,s1,attribs: string;
begin
  flagstr:= strupcase(getctlvaluelite('ATTRIBUTES'));
  if flagstr='' then flagstr:='LOC PVT';
  attribs:='';
  repeat
   splitstring(flagstr,s1,flagstr);
   if s1='' then s1:=flagstr;
   if s1='PVT' then Net.SetPvt(true) else
   if s1='CRA' then Net.SetCrash(True) else
   if s1='RCV' then Net.SetRecd(True) else
   if s1='SNT' then Net.SetSent(True) else
   if s1='ATT' then Net.SetAttach(True) else
   if s1='TRS' then Net.SetTrs(True) else
   if s1='ORP' then Net.SetOrphan(True) else
   if s1='K/S' then Net.SetKillSent(True) else
   if s1='LOC' then Net.SetLoc(True) else
   if s1='HLD' then Net.SetHold(True) else
   if s1='FRQ' then Net.SetFreq(True) else
   if s1='RRQ' then Net.SetRRQ(True) else
   if s1='RRC' then Net.SetIsRRQ(True) else
   if s1='ARQ' then Net.SetARQ(True) else
   if s1='URQ' then Net.SetFileUpdateReq(True) else
   if not wasattr then begin logmsg('?','Invalid message attribute "'+s1+'", ignored!'); s1:='' end;
   if s1<>'' then attribs:=attribs+s1+',';
   if s1=flagstr then delete(attribs,length(attribs),1)
  until s1=flagstr;
  if not wasattr then logmsg('@','Message attributes : '+attribs);
  wasattr:=true;
end;


Procedure error(tplname: string; closev: boolean; status: byte);
 var pth1: string[80];
  pth2,str1,str8,st1,st2,ertplname: string;
label lb1;
Begin

 if lite then exit;

 if strupcase(str4)='-L' then ertplname:='PNTLSTERRTPL' else ertplname:='ERRORTEMPLATE';

(*
 if tplname='' then tplname:=
{$IFDEF FPC}
{$IFDEF WIN32}  'PNTCHKW.EXE'; {$ENDIF}
{$IFDEF EMX}    'PNTCHKE.EXE'; {$ENDIF}
{$IFDEF DOS32}  'PNTCHKP.EXE'; {$ENDIF}
{$IFDEF LINUX}  {$IFDEF FREEBSD} 'pntchk.bsd' {$ELSE} 'pntchk.lnx' {$ENDIF}; {$ENDIF}
{$ELSE}
'PNTCHK.EXE';
{$ENDIF}
*)

if not closev then begin
 str1:=getctlvaluelite('TEMPLATEPATH');
 if copy(str1,length(str1),1)<> {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF}
    then str1:=str1+ {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} ;

 {$I-}

if (((tplar[2]='1') and (tplar[3]='0 (none)')) or ((tplar[3]='1') and (tplar[2]='0 (none)'))) then
 begin
  assign(ertpl,getctlvaluelite(ertplname));

  reset(ertpl);
  if ioresult<>0 then begin
   assign(ertpl,str1+getctlvaluelite(ertplname));
   reset(ertpl);
   if ioresult<>0 then begin
    assign(ertpl,str1+getctlvaluelite(ertplname));
   haltonerror('Error opening template file : '+str1+getctlvaluelite(ertplname),templateNotFound);
  end end;

 close(ertpl)
 end;

 runerror('error',1);

 str1:=createtpl(tplname);
 assign(templfl,str1);

 reset(templfl);
 if ioresult<>0 then begin
   logmsg('!','Error opening template file : '+str1);
   exit
 end;

 if tplname=getctlvalue('NDLERRTPL') then {for i:=1 to status+1 do}
  begin
   repeat
    readln(templfl,pth2);
    pth2:=tplstring(pth2)
   until endflag or eof(templfl);
   if (not endflag) and eof(templfl) then begin
      logmsg('!','Invalid NDLERROR template : '+str1);
      goto lb1
     end;
   endflag:=false;
  for i:=1 to status+1 do
   repeat
    readln(templfl,pth2);
    pth2:=tplstring(pth2);
   until (pos('REASON',strupcase(pth2))<>0) or eof(templfl);
   if (pos('REASON',strupcase(pth2))<>0) and eof(templfl) then begin
      logmsg('!','Invalid NDLERROR template : '+str1);
      goto lb1
     end;
   trim(pth2);
   splitstring(pth2,pth1,tplar[13])
  end;
 lb1:

 close(templfl);
{ if strupcase(tplname)<>'PNTCHK.EXE' then}
  logmsg('[','Using template : '+tplname);
end;

 runerror('error',2);

  if (((tplar[2]='1') and (tplar[3]='0 (none)')) or ((tplar[3]='1') and (tplar[2]='0 (none)'))) and (not closev) then
    begin
  { Get directory name from ctl file }
  getdir(0,pth2);
  pth1:= GetCTLValueLite ('NETMAIL');
  if copy(pth1,length(pth1),1)={$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} then delete(pth1,length(pth1),1);
  if pth1='' then pth1:=pth2;
  chdir(pth1);
  if IOResult <> 0 then haltonerror(
    'Cannot find netmail directory : '+GetCTLValueLite ('NETMAIL'),netmailnotfound);
   chdir(pth2);
   Net.NetmailPath:=pth1;

  st1:= getctlvalue('TEMPDIR');
  if st1<>'' then if st1[length(st1)]<> {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} then st1:=st1+ {$IFDEF LINUX} '/'
                                        {$ELSE} '\' {$ENDIF} ;
{  st2:= getctlvalue('TEMPFILE');
  if st2='' then} st2:='MSG_TMP.FFF';
  assign(tempfl2 , st1+st2);
  a3:=st1+st2;

  rewrite(tempfl2);
  if ioresult<>0 then
   haltonerror('Can''t create tempfile[3] : '+st1+st2,Cannotcreatetempfile);

  end;

 runerror('error',3);

  if not closev then begin

   reset(templfl);
(*if ioresult<>0 then writeln('a-a-a-a-a-a-a-a-a-a');*)
    endflag:=false;
 if ((tplname=getctlvalue('INADMCHARERRTPL')) or (tplname=getctlvalue('EQNUMERRTPL'))) and (status<>0) then
    repeat
       readln(templfl,pth2);
       pth2:=tplstring(pth2)
    until endflag or eof(templfl);
    endflag:=false;

    repeat

       readln(templfl,pth2);
       pth2:=tplstring(pth2);
       if not ((pth2='') and endflag) then writeln(tempfl2,pth2)

    until (eof(templfl)) or endflag;

   close(templfl);
   erase(templfl)
  end;


 runerror('error',4);


   if closev then begin


  if tplar[2]<>'0 (none)' then for i:=1 to 5-length(tplar[2]) do tplar[2]:=' '+tplar[2] else tplar[2]:='    '+tplar[2];
  if tplar[3]<>'0 (none)' then for i:=1 to 5-length(tplar[3]) do tplar[3]:=' '+tplar[3] else tplar[3]:='    '+tplar[3];
  for i:=1 to 5-length(tplar[14]) do tplar[14]:=' '+tplar[14];


end;


   if closev and ((xval(tplar[2])>0) or (xval(tplar[3])>0)) then begin


  close(tempfl2);


  getdir(0,pth2);
  pth1:= GetCTLValueLite ('NETMAIL');

{---------------------------------------------------------}

if pth1='' then

else

 begin

  if pth1[length(pth1)]= {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then delete(pth1,length(pth1),1);
  if pth1='' then pth1:=pth2;
  Net.NetmailPath:=pth1;

   Net.CreateMsg;
  {$I-}
   Net.SetFromTo(addr);
   str8:=getctlvaluelite('FROM');
   if str8='' then Net.SetFrom(nameprog) else Net.SetFrom(tplstring(str8));
   str8:=getctlvaluelite('TO');
   if str8='' then str8:='SysOp' else begin
     str8:=trim(tplstring(str8));
   end;
   Net.SetTo(str8);
   if getctlvaluelite('SUBJECT')='' then Net.SetSubj(nameprog+' report')
                                    else Net.SetSubj(tplstring(getctlvaluelite('SUBJECT')));
{   Net.SetPvt(True);
   Net.SetLoc(True);}
   setmsgflags;
   Net.MsgText.Putstring('PID: '+nameprog+' v'+version+' '+serial);

   endflag:=false;

  str1:=createtpl(getctlvaluelite(ertplname));


  assign(ertpl,str1);

 reset(ertpl);

 runerror('error',5);

    repeat
       readln(ertpl,pth2);
       pth2:=tplstring(pth2);
       if not (endflag and (pth2='')) then Net.MsgText.Putstring(pth2);
    until (eof(ertpl)) or endflag;
    endflag:=false;


   reset(tempfl2);
   repeat
     readln(tempfl2,st1);
     Net.MsgText.Putstring(st1);
   until eof(tempfl2) or (Net.MsgText.CurrentPosition>30000);

  if Net.MsgText.CurrentPosition>30000 then begin

Net.MsgText.Putstring('');
Net.MsgText.Putstring('[...]');
Net.MsgText.Putstring('');
Net.MsgText.Putstring('Sorry, too many errors. The rest is not reported...');
logmsg('!','Too big message file, the rest is skipped!')

end;


  close(tempfl2);

(*{    close(ertpl);

   reset(ertpl);
    repeat
       readln(ertpl,pth2);
       pth2:=tplstring(pth2);
    until (eof(ertpl)) or endflag;}*)
    endflag:=false;

   if not eof(ertpl) then
    repeat
       readln(ertpl,pth2);
       pth2:=tplstring(pth2);
       if not (endflag and (pth2='')) then Net.MsgText.Putstring(pth2)
     until (eof(ertpl));
    endflag:=false;

  Net.MsgText.Putstring('--- '+tplstring(getctlvaluelite('TEARLINE')));
  if getctlvaluelite('ORIGIN')<>'' then
  Net.MsgText.Putstring(
    ' * Origin: '+tplstring(getctlvaluelite('ORIGIN'))+' ('+xstr(addr.fromzone)+':'+xstr(addr.fromnet)+
    '/'+xstr(addr.fromnode)+'.'+xstr(addr.frompoint)+')');


   close(ertpl);

 runerror('error',6);

   Net.SaveMessageText;
   Net.CloseMsg;

  st1:=getctlvaluelite('COORDINATOR');
  if st1='' then erase(ertpl) else
   begin
    splitstring(st1,st1,str8);
    if st1='' then begin st1:=str8; str8:='' end;
    splitaddress(st1,addr2.tozone,addr2.tonet,addr2.tonode,addr2.topoint);
    addr2.fromzone:= addr.fromzone;
    addr2.fromnet:= addr.fromnet;
    addr2.fromnode:= addr.fromnode;
    addr2.frompoint:= addr.frompoint;

    Net.CreateMsg;
  {$I-}
   Net.SetFromTo(addr2);
   if str8='' then str8:='Coordinator';
   Net.SetTo(tplstring(str8));
   str8:=getctlvaluelite('FROM');
   if str8='' then Net.SetFrom(nameprog) else Net.SetFrom(tplstring(str8));
   if getctlvaluelite('SUBJECT')='' then Net.SetSubj(nameprog+' report')
                                    else Net.SetSubj(tplstring(getctlvaluelite('SUBJECT')));
{   Net.SetPvt(True);
   Net.SetLoc(True);}
   setmsgflags;
   Net.MsgText.Putstring('PID: '+nameprog+' v'+version+' '+serial);

 reset(ertpl);

    repeat
       readln(ertpl,pth2);
       pth2:=tplstring(pth2);
       if not (endflag and (pth2='')) then Net.MsgText.Putstring(pth2);
    until (eof(ertpl)) or endflag;
    endflag:=false;


   reset(tempfl2);
   repeat
     readln(tempfl2,st1);
     Net.MsgText.Putstring(st1);
   until eof(tempfl2) or (Net.MsgText.CurrentPosition>30000);

  if Net.MsgText.CurrentPosition>30000 then begin

Net.MsgText.Putstring('');
Net.MsgText.Putstring('[...]');
Net.MsgText.Putstring('');
Net.MsgText.Putstring('Sorry, too many errors. The rest is not reported...');

end;

 runerror('error',7);


  close(tempfl2);

    endflag:=false;

   if not eof(ertpl) then
    repeat
       readln(ertpl,pth2);
       pth2:=tplstring(pth2);
       if not (endflag and (pth2='')) then Net.MsgText.Putstring(pth2)
     until (eof(ertpl));
    endflag:=false;

 runerror('error',8);

  Net.MsgText.Putstring('--- '+tplstring(getctlvaluelite('TEARLINE')));
  if getctlvaluelite('ORIGIN')<>'' then
  Net.MsgText.Putstring(
    ' * Origin: '+tplstring(getctlvaluelite('ORIGIN'))+' ('+xstr(addr.fromzone)+':'+xstr(addr.fromnet)+
    '/'+xstr(addr.fromnode)+'.'+xstr(addr.frompoint)+')');


   close(ertpl);
   erase(ertpl);
{


   reset(tempfl2);
   repeat
     readln(tempfl2,st1);
     Net.MsgText.Putstring(st1);
   until eof(tempfl2);}

   Net.SaveMessageText;
   Net.CloseMsg;


  end;
 end;
{---------------------------------------------------------}




  erase(tempfl2);
 if strupcase(copy(getctlvaluelite('ONLYONEREPORT'),1,1))='Y' then
if getctlvaluelite('NETMAIL')<>'' then logmsg('{','Reporting to the netmail folder : '+pth1+
                                              {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} );
{   logmsg('#','Reporting to netmail folder : '+pth1)}
  end;

 runerror('error',9);

End;

 { ===== �����頥� ����� 㧫�, �뤥ࣨ����� �� ������⮢�� ��ப� }
function NumOfNode(InStr:string): integer;

var
 i,j: {$IFDEF VIRTUALPASCAL} LongInt {$ELSE} Integer {$ENDIF};
 TmpStr: string;

begin
 if InStr[1]=';' then
  NumOfNode:=0
 else begin
  i:=1;
  while InStr[i] <> ',' do
   inc(i);
  TmpStr:='';
  j:=i;
  inc(i);
  if i<=length(instr) then
   while InStr[i] <> ',' do begin
    TmpStr:=TmpStr+InStr[i];
    inc(i);
  end;
  val(TmpStr, i, j);
  if j=0 then NumOfNode:=i else NumOfNode:=-1;
 end
end;

Function checknl(noden: word): boolean;

 const
 TNormal = 1; { ����� 㧥� }
 TDown   = 2; { ���� � ��䨪ᮬ Down }
 THold   = 3; { ���� � ��䨪ᮬ Hold }
 THub    = 4; { ���� � ��䨪ᮬ Hub }
 TPvt    = 5; { ���� � ��䨪ᮬ Pvt }
 TAbs    = 0; { ����, ���������騩 � ������� }

 PDown   = 'Down';
 PHold   = 'Hold';
 PHub    = 'Hub,';
 PPvt    = 'Pvt,';

var
 indexstr,sendstr: string;
 bytevar: byte;

(* Function ]NameCrcCode(Str: String; tso: boolean): LongInt;
  var
    CRC: longint;

begin
   {$IFDEF VIRTUALPASCAL} namecrccode:=crc32offile(str, tso);
   {$ELSE}
    if CRCFile(str, tso, CRC) = 0 then
      begin
       namecrccode:=CRC;
       exit
      end
    else
     begin
      Writeln('Unknown error in file ', str);
      halt(999)
    end
   {$ENDIF}
   {$I-}
end; *)

Function NameCrcCode(Str: String; tso: boolean): LongInt;

begin
(*   {$IFDEF VIRTUALPASCAL} *)
 namecrccode:=crc32offile(str, tso);
(*   {$ELSE}
    if CRCFile(str, tso, CRC) = 0 then
      begin
       namecrccode:=CRC;
       exit
      end
    else
     begin
      Writeln('Unknown error in file ', str);
      halt(999)
    end
   {$ENDIF} *)
   {$I-}
end;


 { ===== ���뢠��� ������� � ���������� ����᭮�� ���ᨢ� ======= }
function ReadNodeList: boolean;
type bytetype= array[1..65520] of char;
 filepostype= array[1..10920] of longint;
var
 j,k: word; i: integer;
 InFile: file;
 LongVar, longvar2, crc1, crc2, ndltime: longint;
 Str1, str3, str4, ndlname: string;
 num: word;
 dirinfo: searchrec;
 byteara:  ^bytetype;
 fileposar,fileposar1,fileposar2: ^filepostype;
 seekp: longint;
 byteread: {$IFDEF VIRTUALPASCAL} LongInt {$ELSE} word {$ENDIF};
 but1,but: byte;

begin

 runerror('readnodelist',1);

 ndlname:='';
 ndltime:=0;
 str2:= getctlvaluelite('NODELIST');
 if str2 <> '' then
  begin
    fsplit(str2,str1,tplar[1],str3);
    if str3='.999' then str4:='.*' else str4:=str3;
    findfirst(str1+tplar[1]+str4,$27,dirinfo);
    if doserror<>0 then
     begin
      logmsg ('!','Unable to open nodelist file : '+str2);
      logmsg ('!','Nodelist checking is disabled');

      readnodelist:=false;
      exit
     end;

    while doserror=0 do
     begin
       fsplit(dirinfo.name,str1,tplar[1],str4);
       if ((str3='.999') and (xval(copy(str4,2,length(str4)-1))<>-1)) or (str3<>'.999') then
         if ndltime<dirinfo.time then
            begin
              ndltime:=dirinfo.time;
              ndlname:=dirinfo.name
            end;
       findnext(dirinfo);
     end;

     {$IFDEF VIRTUALPASCAL} findclose(dirinfo); {$ENDIF}

    fsplit(str2,str1,tplar[1],str3);
    if ndlname='' then ndlname:=tplar[1]+str3;
    tplar[1]:= ndlname;
{    tplar[1]:= tplar[1]+str3;}
    tplar[42]:=str1+tplar[1];
    assign(InFile, tplar[42]);

    filemode:=0;
    reset(infile);
    filemode:=2;
    if ioresult<>0 then
     begin
      logmsg ('!','Unable to open nodelist file : '+tplar[42]);
      logmsg ('!','Nodelist checking disabled');

      readnodelist:=false;
      exit
     end;
    close(InFile);
    crc1:=namecrccode(tplar[42],false);
{    assign(InFile, str2);
    filemode:=0;
    reset(InFile);}
    filemode:=2;
   end
  else
   begin
    logmsg ('&','Nodelist checking disabled');
    readnodelist:=false;
    exit
   end;

 str1:= getctlvaluelite('NDLINDEX');
 if str1 ='' then str1:= 'pntchk.idx';
 indexstr:= str1;
 assign(indexfile,str1);
 reset(indexfile);

 if ioresult=0 then
  begin
   close(indexfile);

   crc2:= namecrccode(str1,true);

   reset(indexfile);
   seek(indexfile,0);
   read(indexfile,longvar2);

   if longvar2 = crc2 then
    begin
     seek(indexfile,1);
     read(indexfile,longvar2);
      if longvar2=crc1 then
       begin
        close (indexfile);
        assign (indexfile2,str1);
        reset(indexfile2);
        seek(indexfile2,9);
        read(indexfile2,bytevar);
        close(indexfile2);
       if bytevar=1 then
        begin
          logmsg ('!','No net'+xstr(addr.fromnet)+' segment found in nodelist file : '+tplar[42]);
          logmsg ('!','Nodelist checking disabled');
          readnodelist:=false;
        end
       else
        if bytevar=0 then
         logmsg ('&','Reading compiled nodelist index...')
        else writeln('Gluk!');
       readnodelist:=true;
       exit
      end
    end
   end
  else
   rewrite(indexfile);

 runerror('readnodelist',2);

 logmsg ('&','Building nodelist index...');
 writeln;
 write('Building nodelist index...');

 runerror('readnodelist',3);

 longvar:= crc1;
 close(indexfile);
 rewrite(indexfile);
 seek(indexfile,1);
 write(indexfile,longvar);
 close(indexfile);

 assign(indexfile2,str1);
 reset(indexfile2);
 seek(indexfile2,9); bytevar:=0; write(indexfile2,bytevar);
 close(indexfile2);

{ if str1 <>'' then assign(indexfile2,str1) else assign(indexfile2,namefprog+'.IDX');}
 reset(indexfile2);

 assign(infile,tplar[42]);
 filemode:=0;
 reset(infile,1);
 filemode:=2;

 str4:=str1;

 str3:=xstr(addr.fromnet);
 str3:='Host,'+str3;
 seekp:=0;
 str1:='';

 new(byteara);

 repeat
  bytevar:=0;
     BlockRead(InFile, byteara^, 65520, byteread);
     for k:=1 to byteread do
       begin

        if byteara^ [k]= str3[1] then begin j:=1;
     repeat
        inc(j);
      until (byteara^ [k+j]<>str3[j+1]) or (k+j = byteread) or (j=length(str3)-1);

      if (byteara^ [k+j]=str3[1+j]) and (j=length(str3)-1) then
         begin
           seek(infile,k+seekp);
           j:=k+length(str3);
           k:=byteread;
           str1:=str3
         end
{        else str1:='';}

       end
    end;
    if str1<>str3 then begin seek(infile,k+seekp-length(str3)); seekp:=seekp+byteread end;
 until (str1=str3) or eof(infile);

 dispose(byteara);

 runerror('readnodelist',4);

 if eof(infile) then begin
  writeln;
  logmsg ('!','No net'+xstr(addr.fromnet)+' segment found in nodelist file : '+tplar[42]);
  logmsg ('!','Nodelist checking disabled');
  seek(indexfile2,9); bytevar:=1; write(indexfile2,bytevar);
  readnodelist:=false;
  close(indexfile2);
  close(infile); 
  longvar:=namecrccode(str4,true);
  reset(indexfile);
  seek(indexfile,0);
  write(indexfile,longvar);
  close(indexfile);

  exit
 end;

  close(infile);

   for i:=1 to 4096 do
    begin
      seek(indexfile2,i+9);
      bytevar:=0;
      write(indexfile2,bytevar);
      if i mod 1000 = 0 then write('.')
    end;

 runerror('readnodelist',9);

 str3:=str4;
 str1:='';

 assign(infile2,tplar[42]);
 filemode:=0;
 reset(infile2);
 filemode:=2;
 seek(infile2,seekp+j);

 runerror('readnodelist',5);

 new(fileposar);
 new(fileposar1);
 new(fileposar2);

 for i:=1 to 10920 do fileposar^ [i] :=0;
 for i:=1 to 10920 do fileposar1^ [i] :=0;
 for i:=1 to 10920 do fileposar2^ [i] :=0;

 while (not eof(InFile2)) and (copy(str1,1,5)<>'Host,') and (copy(str1,1,5)<>'Regio') and (copy(str1,1,5)<>'Zone,') do begin

runerror('readnodelist',18);

  longvar:= filepos(infile2);
  bytevar:=0;
  str1:='';

runerror('readnodelist',13);

  while (bytevar<>10) and (not EOF(infile2)) do begin
     Read(InFile2, bytevar);
     if (bytevar<>13) and (bytevar<>10) then str1:=str1+chr(bytevar)
    end;

runerror('readnodelist',12);

  write('.');

  i:=NumOfNode(Str1);

 runerror('readnodelist',10);

if (i>0) and ((copy(str1,1,5)<>'Host,') and (copy(str1,1,7)<>'Region,') and (copy(str1,1,5)<>'Zone,')) then begin

   num:=i;

 runerror('readnodelist',11);

   seek(indexfile2,10+(num div 8));

 runerror('readnodelist',19);

   read(indexfile2,but1);

 runerror('readnodelist',20);

   seek(indexfile2,10+(num div 8));

 runerror('readnodelist',21);

   i:=num mod 8;
   case i of
     0: but:= $1;
     1: but:= $2;
     2: but:= $4;
     3: but:= $8;
     4: but:= $10;
     5: but:= $20;
     6: but:= $40;
     7: but:= $80;
   end; {case}
{write('Nummer: ',num,' num mod 8 ', num mod 8,' num div 8 ',num div 8,' Bytevar: ',but1,' + ',but,' -> ');}

   asm
     mov  ah,but1
     or   ah,but
     mov  but1,ah
   end;

runerror('readnodelist',14);

   write(indexfile2,but1);

runerror('readnodelist',15);

   if num<=10920 then fileposar^ [num]:= longvar
    else if num<=21840 then fileposar1^ [num-10920]:= longvar
      else if num<=32760 then fileposar2^ [num-21840]:= longvar;

runerror('readnodelist',16);

  end;

runerror('readnodelist',17);

end;

 runerror('readnodelist',6);

  close(indexfile2);
  close(infile2);

  reset(indexfile);
  seek(indexfile,1028);

  for i:=1 to 10920 do if fileposar^ [i]<>0 then write(indexfile,fileposar^ [i]); 
  for i:=1 to 10920 do if fileposar1^ [i]<>0 then write(indexfile,fileposar1^ [i]); 
  for i:=1 to 10920 do if fileposar2^ [i]<>0 then write(indexfile,fileposar2^ [i]); 

  close(indexfile);

 dispose(fileposar2);
 dispose(fileposar1);
 dispose(fileposar);

 runerror('readnodelist',7);

 longvar:=namecrccode(str3,true);
 reset(indexfile);
 seek(indexfile,0);
 write(indexfile,longvar);
 close(indexfile);

 runerror('readnodelist',8);

 writeln;
 writeln;
 readnodelist:=true;

end;

Function returnflag: byte;
type booltype= array[1..32760] of boolean;
var boolar: ^booltype;
 bytevar,but: byte;
 longvar: longint;
 str1,str2: string;
begin
 new(boolar);

 assign(indexfile2,indexstr);
 reset(indexfile2);
 seek(indexfile2,10);

 runerror('returnflag',0);
 for i:=1 to 4095 do begin
   read(indexfile2,bytevar);
   for j:=0 to 7 do begin
   case j of
     0: but:= $1;
     1: but:= $2;
     2: but:= $4;
     3: but:= $8;
     4: but:= $10;
     5: but:= $20;
     6: but:= $40;
     7: but:= $80;
   end; {case}
   asm
     mov ah, but
     and ah, bytevar
     mov but, ah
   end;
  if but<>0 then boolar^ [(i-1)*8+j]:= true else boolar^ [(i-1)*8+j]:= false;
  end;

  end;

 close(indexfile2);

 assign(indexfile,indexstr);
 reset(indexfile);

 j:=0;
 for i:=1 to noden do if boolar^ [i] then inc(j);
 seek(indexfile,1027+j);
 read(indexfile,longvar);
 if ioresult<>0 then begin returnflag:=TAbs; exit end;
 close(indexfile);
(* if ioresult<>0 then writeln('Error!');*)

 if boolar^ [noden] then begin

 assign(infile2,tplar[42]);

 filemode:=0;
 reset(infile2);

if ioresult<>0 then writeln('Very strange error! Please contact the author!');

 filemode:=2;
 seek(infile2,longvar);

 bytevar:=0;
 str1:='';
  while (bytevar<>10) and (not EOF(infile2)) do begin
     Read(InFile2, bytevar);
     if (bytevar<>13) and (bytevar<>10) then str1:=str1+chr(bytevar)
    end;

  Str2:='';
  for i:=1 to 4 do
   Str2:=Str2+Str1[i];
   if str2= PDown then bytevar:=TDown   else
     if str2= PPvt then bytevar:=TPvt   else
       if str2= PHub then bytevar:=THub else
         if str2= PHold then bytevar:=THold
   else bytevar:=tnormal;

 i:=0;
 repeat
  inc(i)
 until str1[i]=',';
 j:=i;
 repeat
  inc(i)
 until str1[i]=',';
 j:=i;
 repeat
  inc(i)
 until str1[i]=',';
 j:=i;
 repeat
  inc(i)
 until str1[i]=',';
 j:=i;
 repeat
  inc(i)
 until str1[i]=',';

 str2:= copy(str1,j+1,i-j-1);
 for i:=1 to length(str2) do if str2[i]='_' then str2[i]:=' ';
 if pos(' ',str2)<>0 then
     splitstring(str2,tplar[40],tplar[41])
  else begin 
    tplar[40]:=str2;
  end;
  close(infile2)
 end

 else begin
  bytevar:=0;
  tplar[40]:='SysOp'; {tplar[41]:='';}
 end;

 dispose(boolar);
 returnflag:=bytevar;
end;

begin
 if not readnodelist then
      begin

        checknl:=true;
        exit
      end;
 bytevar:= returnflag;
 str1:= tplar[2]; {@errornumber}
 indexstr:=xstr(addr.fromzone)+':'+xstr(addr.fromnet)+'/'+xstr(noden);
 case bytevar of
   0: begin
        logmsg('&','Node '+indexstr+' is ABSENT in the current nodelist : '+tplar[1]);
        sendstr:= strupcase(getctlvaluelite('ABSENTPOINTS'));
        if sendstr<>'YES' then incerror(true);
      end;
   1: begin
        logmsg('&','Node '+indexstr+' has NORMAL status in the current nodelist : '+tplar[1]);
        sendstr:= strupcase(getctlvaluelite('NORMALPOINTS'));
        if sendstr<>'YES' then incerror(true);
      end;
   2: begin
        logmsg('&','Node '+indexstr+' has DOWN status in the current nodelist : '+tplar[1]);
        sendstr:= strupcase(getctlvaluelite('DOWNPOINTS'));
        if sendstr<>'YES' then incerror(true);
      end;
   3: begin
        logmsg('&','Node '+indexstr+' has HOLD status in the current nodelist : '+tplar[1]);
        sendstr:= strupcase(getctlvaluelite('HOLDPOINTS'));
        if sendstr<>'YES' then incerror(true);
      end;
   4: begin
        logmsg('&','Node '+indexstr+' has HUB flag in the current nodelist : '+tplar[1]);
        sendstr:= strupcase(getctlvaluelite('HUBPOINTS'));
        if sendstr<>'YES' then incerror(true);
      end;
   5: begin
        logmsg('&','Node '+indexstr+' has PVT flag in the current nodelist : '+tplar[1]);
        sendstr:= strupcase(getctlvaluelite('PVTPOINTS'));
        if sendstr<>'YES' then incerror(true);
      end;
  end; {case}

 checknl:=true;
 if str1= tplar[2] then exit;

 if sendstr='NOSEND' then begin
      checknl:=false;
      exit
   end;

 logmsg('&','The pointlist segment was not processed');
 error(getctlvalue('NDLERRTPL'),false,bytevar);

end;

(* { ===== �஢�ઠ �� ����⢮����� 䠩�� =========================== }
function FileExists(FileName: String): Boolean;

var
 F: file;
begin
 {$I-}
 Assign(F, FileName);
 Reset(F);
 Close(F);
 {$I-}
 FileExists := (IOResult = 0) and (FileName <> '');
end;  { FileExists }*)


 { ===== ���� ᥣ���⮢ � �ਡ�⨥ ����� ========================= }
(*procedure KillSegment;

var
 i, j:integer;
 f:text;
 s, st:string;

begin
 ChDir(segmentspath);
 for i:=1 to MaxNodes do begin
{  Writeln('Attempting to process node 2:5020/',i);}
  str(i, s);
  for j:=1 to 5-length(s) do
   s:='0'+s;
  s:='SEG'+s+'.PNT';
  if FileExists(s) then begin
   assign(f,s);
   GotoXY(1, WhereY-1);
   Writeln('���� ��ࠡ�⪠ 㧫� 2:5020/',i,'          ');
   case Nodes[i] of
    TAbs: begin
     erase(f);
     str(i,st);
     WriteLog('���� 2:5020/'+st+' ��������� � �������. ������� 㤠���.');
    end;
    TDown: begin
     erase(f);
     str(i,st);
     WriteLog('���� 2:5020/'+st+' ����� ����� Down. ������� 㤠���.')
    end
   else begin
    CheckSeg(i);
{    str(i,st);
    WriteLog('Node 2:5020/'+st+' is a real node!');}
   end;
  end;
 end;
end;

end;*)

 { ===== ��२�����뢠��� ᥣ���⮢ (��� ᮢ���⨬��� � ���� �ଠ⮬ = }
(*procedure RenSeg;

var
 i:integer;
 f1:text;
 s1,s2:string;

begin
 ChDir(SegmentsPath);
 for i:=1 to 999 do begin
  str(i, s1);
  if i<10 then
   s1:='00'+s1
  else if i<100 then
   s1:='0'+s1;
  s2:='00'+s1;
  if FileExists('POINTSOF.'+s1) then begin
   if FileExists('SEG'+s2+'.PNT') then begin
    assign(f1,'SEG'+s2+'.PNT');
    erase(f1);
    WriteLog('���� Seg'+s2+'.Pnt 㤠���');
   end;
   assign(f1,'pointsof.'+s1);
   rename(f1, 'seg'+s2+'.pnt');
   WriteLog('���� PointsOf.'+s1+' ��२������� � Seg'+s2+'.Pnt');
  end;
 end;
end;*)

(*var
 i, j:integer;
 s, s1:string;

begin
 assign(Log, LogName);
 if FileExists(LogName) then
  append(Log)
 else
  rewrite(Log);
 WriteLog('Starting');
 Init;
 ReadNodeList;
 RenSeg;
 KillSegment;
 GotoXY(1,WhereY-1);
 Writeln('��ࠡ�⪠ �����襭�                                    ');
 WriteLog('����砭�� ࠡ���');
 close(Log);
end.
*)

Procedure becomeaddress(var vara: integer; display: boolean);
const dur:integer=0;
var
  feda,ces: byte;
  pora,pora2: string;
  ada,ter: integer;
  plokho: boolean;

function stepen(a: word;b: byte): word;
 var d: word;
     c: byte;
begin
 d:=a;
 if b=0 then begin stepen:=1; exit end;
 if b<>1 then for c:=1 to b-1 do d:=d*a;
 stepen:=d;
end;

begin

  FindFirstParameter('SEGMENTFORMAT');
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  if plokho then plokho:=false;
  Repeat
   Inc(FormCount);
   SegmentFormat[FormCount]:=CurrentCTLValue;
   FindNextParameter;
  Until ((FormCount=20) or not(MoreParameters));

  for i:=1 to formcount do
   begin {for(i)}
     pora:=strupcase(segmentformat[i]);
{     for j:=1 to length(pora) do if pora[j]='.' then delete(pora,j,1);}
     pora2:=strupcase(tplar[8]);
     feda:=0;
     ada:=0;
     ter:=length(pora2)+1;
     for j:=length(pora) downto 1 do
      begin
       dec(ter);

       if (pora[j]='D') then
         if pora[j-1]='~' then
           begin
             case pora2[ter] of
             '0'..'9': ces:=xval(pora2[ter]);
             else plokho:=true;
             end; {case}

             ada:=ada+ces*stepen(10,feda);
             inc(feda);
             dec(j);
           end;

       if (pora[j]='H') then
         if pora[j-1]='~' then
           begin
             case pora2[ter] of
             '0'..'9': ces:=xval(pora2[ter]);
             'A': ces:=10;
             'B': ces:=11;
             'C': ces:=12;
             'D': ces:=13;
             'E': ces:=14;
             'F': ces:=15;
             else plokho:=true;
             end; {case}

             ada:=ada+ces*stepen(10,feda);
             inc(feda);
             dec(j);
           end;

     end;
    if not plokho then if ada<>0 then begin dur:=i; i:=formcount end else else begin ada:=-1; plokho:=false end;
   end; {for(i)}

   vara:=ada;
   if (ada>0) and display then
   logmsg('@','Node number '+xstr(ada)+', using segment name macro : '+segmentformat[dur]);

   tplar[16]:=segmentformat[dur];

   if ada>0 then
     if (i<>1) and ((strupcase(copy(getctlvaluelite('RENAMESEGMENT'),1,1))='Y')) then
       begin
     if plokho then plokho:=false;
     pora2:=test(ada,segmentformat[1]);
    if tplar[8]<>pora2 then logmsg('@','New segment name : '+pora2);
    tplar[28]:=pora2;

   end
 else tplar[28]:=tplar[8];


end;

Procedure readsegment;
type numpointtype= array[1..32767,1..2] of boolean;
var
 s,s1,st2,st3,pth1,pth2:string;
 i:integer;
 ii:word;
 f,f1:text;
 ff: file;
 waserr,ex,first:boolean;
 numpoint: ^numpointtype;

Procedure bosscheck;
begin
 {@idealstring} tplar[17]:='Boss,'+tplar[19];
  tplar[15]:=s1; {@currentstring}
    if tplar[15]<>tplar[17] then begin
               incerror(true);
           logmsg('#','(E) Invalid bosstring : '+tplar[15]);
               error(getctlvaluelite('NMBRERRTPL'),false,0);
             end
end; {bosscheck}

(*function identic(var par1,par2: string): boolean;
var sex,i2,j2: byte;
  pari,parj: char;
  hu,zv,ident,voskl: boolean;
begin

  voskl:=false;

  if (par1[1]='!') then
    begin
      delete(par1,1,1);
      if (par1[1]<>'!') then voskl:=true
    end;

  i2:=0;
  j2:=0;

  ident:=true;
  zv:= false;
  hu:=false;

  repeat
    if i2<length(par1) then if (not zv) or hu then inc(i2);
    if (not zv) then inc(j2);
    case par1[i2] of
      '[': begin
         if ((par1[i2+4]=']') or ((par1[i2+3]<>'') and (par1[i2+4]=''))) and (par1[i2+2]='-')
         then begin
          pari:=chr(ord(par1[i2+1])-1);
          repeat
            pari:=chr(ord(pari)+1)
          until (par2[j2]=pari) or (pari=par1[i2+3]);
          if (par2[j2]<>pari) and (pari=par1[i2+3]) then ident:=false;
          i2:=i2+4
         end else begin
         repeat
           inc(i2);
         until (i2>length(par1)) or ((par1[i2]=']') and (par1[i2-1]<>'[')) or (par1[i2]=par2[j2]);
         if (i2>length(par1)) or ((par1[i2]=']') and (par1[i2-1]<>'[')) then ident:=false
            else begin if par1[i2]=']' then inc(i2); while (par1[i2]<>']') and (i2<=length(par1)) do inc(i2) end;
           end
         end;
      '?': begin
{         inc(i);}
{         while (par1[i]='*') or (par1[i]='?') do inc(i);}
         if par2[j2]<>par1[i2] then { inc(j2)} else begin hu:=true; dec(j2) end;
         if (i2=length(par1)) and (j2<length(par2)) then ident:=false
        end;
      '*': begin
         zv:=true;
         inc(i2);
         while ((par1[i2]='*') or (par1[i2]='?')) do inc(i2);
         pari:=par1[i2];  {zaglushka for location bug}
         if i2>length(par1) then pari:=#0; {zaglushka for location bug}
         repeat
          if par2[j2]<>pari then inc(j2) else hu:=true;
         until (par2[j2]=pari) or (j2>length(par2));
         if (j2>length(par2)) and (i2<=length(par1)) then begin zv:=false; ident:=false end;
         if j2<length(par2) then
          repeat
           sex:=0;
           repeat
            inc(sex)
           until (par1[sex+i2-1]='*') or (par1[sex+i2-1]='?') or (par1[sex+i2-1]=#0) or (par1[sex+i2-1]<>par2[j2+sex-1]);
           if (par1[sex+i2-1]<>'*') and (par1[sex+i2-1]<>'?')
             then
              if par1[sex+i2-1]<>par2[j2+sex-1]
                then
                 begin
                   repeat
                     inc(j2);
                   until (par2[j2]=par1[i2]) or (j2>=length(par2));
                   if j2>length(par2) then begin zv:=false; ident:=false end else
                 end
                else zv:=true
             else zv:=true;
            until (par1[sex+i2-1]='*') or (par1[sex+i2-1]='?') {or (par1[sex+i2-1]=#0)} or
                             (j2>=length(par2)) or (par2[j2+sex-1]=par1[i2+sex-1])
         else zv:=false;
      end
      else
           pari:=par1[i2];     {�����誠}
           parj:=par2[j2];     {zaglushka for location bug}
           if i2>length(par1) then pari:=#0;
           if pari<>parj then if hu then begin hu:=false; inc(j2) end;
           parj:=par2[j2];
           if j2>length(par2) then parj:=#0;
           if pari<>parj then if not zv then
               ident:=false
                                                else
          begin
              repeat
                 inc(j2)
              until (par2[j2]=pari) or (j2>length(par2));
              if (j2>length(par2)) then begin ident:=false; zv:=false end else if j2<>length(par2) then
                 zv:=true else zv:=false;
          end
          else if (not hu) then if zv then zv:=false {else else inc(j)};
        end; {case}

  until ((not ident) or (i2>=length(par1))) and (not zv) and (j2>=length(par2));

{ if par1='*' then writeln(par2,' par2 ',i2,' i - j ',j2);}
{ if ident then writeln('Ident.') else writeln('Not ident!');}
 if voskl then identic:= not ident else identic:= ident

end; *)

Procedure checkstring(stre: string);
type flagtype= array[1..100] of string;
     segftype= array[1..30] of string;

Procedure splitndlstring;
begin

 tplar[15]:=stre;

 if numofnode(stre)<=0 then tplar[20]:='is unknown' else tplar[20]:=tplar[19]+'.'+xstr(numofnode(stre));

 i:=0;
 repeat
  inc(i)
 until tplar[15,i]=',';
 tplar[25]:=copy(tplar[15],1,i-1); {prefix}
 j:=i;
 repeat
  inc(i)
 until tplar[15,i]=',';
 j:=i;
 repeat
  inc(i)
 until tplar[15,i]=',';
 tplar[21]:=copy(tplar[15],j+1,i-j-1); {system}
 j:=i;
 repeat
  inc(i)
 until tplar[15,i]=',';
 tplar[23]:=copy(tplar[15],j+1,i-j-1);
 j:=i;
 repeat
  inc(i)
 until tplar[15,i]=',';
 tplar[22]:=copy(tplar[15],j+1,i-j-1);
 j:=i;
 repeat
  inc(i)
 until tplar[15,i]=',';
 tplar[24]:=copy(tplar[15],j+1,i-j-1);
 j:=i;
 repeat
  inc(i)
 until tplar[15,i]=',';
 tplar[26]:=copy(tplar[15],j+1,i-j-1);
 tplar[37]:=tplar[26];
 tplar[27]:=copy(tplar[15],i+1,length(stre)-i);
{ if (tplar[27]='') and (copy(tplar[15],length(tplar[15]),1)=',') then tplar[27]:=',';}
end;

Function addedflagpr: boolean;
var st1,st2: string;
label lab7;

begin
addedflagpr:=true;
if getctlvalue('ADDEDFLAGS')<>'' then begin
 st1:=getctlvalue('BAUD');
{ if st1='' then st1:=getctlvalue('SPEED');}
 if st1='' then st1:='300 1200 2400 9600';
 i:=0;
 repeat
   inc(i);
   splitstring(st1,st2,st1)
 until (st2=tplar[38]) or (st2='');
 if (st2='') and (st1<>tplar[38]) then goto lab7;
 st1:=getctlvalue('ADDEDFLAGS');
 for j:=1 to i do splitstring(st1,st2,st1);
 if (st2='-') or ((st2='') and (st1='-')) then
 if (strupcase(copy(getctlvalue('NOFLAG'),1,1))='N') then goto lab7
  else begin addedflagpr:=false; exit end;
 if st2<>'' then tplar[36]:=','+st2+',' else tplar[36]:=','+st1+','
end
else
lab7:
if tplar[38]='300' then tplar[36]:=',V21,' else
if (tplar[38]='1200') or (tplar[26]='2400') then tplar[36]:=',V22,' else
if tplar[38]='9600' then tplar[36]:=',V32,' else
     tplar[36]:=',MO,';
     tplar[39]:=copy(tplar[36],2,length(tplar[36])-2)
end;

var st1,st2,st3,st4,tplar30: string;
 h: integer;
 flagar: ^flagtype;
 SEGMENTFORMAT: ^segftype;
 formcount,buta,buta2: byte;
 ok: boolean;
 flut: char;
{ ia: word;}

label lb1,lb2,lb6;

begin {readsegment}
 waserr:= false;
 splitndlstring;

 if tplar[20]='is unknown' then
   begin
     logmsg('#','(E) Invalid pointnumber was found');
     incerror(true);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvaluelite('PONUMERRTPL'),false,0);
        decerror(false)
      end
    else
        error(getctlvaluelite('PONUMERRTPL'),false,0);
   end;

 st1:=getctlvalue('PREFIX');
 if st1='' then st1:='Point';
 if not grepmatch(st1,tplar[25]) then
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'Invalid prefix "'+tplar[25]+'"');
     incerror(true);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvaluelite('PREFERRTPL'),false,0);
        decerror(false)
      end
    else
        error(getctlvaluelite('PREFERRTPL'),false,0);
   end;

 st1:=getctlvalue('BAUD');
 if st1='' then st1:=getctlvalue('SPEED');
 if st1='' then st1:='300 1200 2400 9600';
 h:=0;
 repeat
   inc(h);
   splitstring(st1,st2,st1);
   if h=1 then tplar[38]:=st2;
 until (st2='') or (tplar[26]=st2);
  if (st2='') and (st1<>tplar[26]) then {@speed}
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     if strupcase(copy(getctlvalue('CHANGEBAUD'),1,1))='Y'
       then
         begin
     logmsg('#','(W) '+postr+'Unexpected baud rate "'+tplar[26]+'" was changed to "'+tplar[38]+'"');
     incerror(false);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(true);
        error(getctlvaluelite('BAUDERRTPL'),false,0);
        decerror(true)
      end
    else
      error(getctlvaluelite('BAUDERRTPL'),false,0);
         end
       else
         begin
     tplar[38]:=tplar[26];
     logmsg('#','(E) '+postr+'Unexpected baud rate "'+tplar[26]+'"');
     incerror(true);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvalue('BAUDERRTPL'),false,0);
        decerror(false)
      end
    else
      error(getctlvalue('BAUDERRTPL'),false,0);
   end
  end else tplar[38]:=tplar[26];

  ok:=false;
{;  FindFirstParameter('PHONENUMBER');
;  if strupcase(copy(getctlvalue('CHANGEPHONE'),1,1))='Y' then tplar[34]:=currentctlvalue else tplar[34]:=tplar[24];
;  FormCount:=0;
;  if not MoreParameters then MoreParameters:=True;
;  Repeat
;   Inc(FormCount);
;   if identic(currentctlvalue,tplar[24]) then ok:=true;
;   FindNextParameter;
;  Until (FormCount=20) or not(MoreParameters) or ok;}

  FindFirstParameter('PHONENUMBER');
  if strupcase(copy(getctlvalue('CHANGEPHONE'),1,1))='Y' then 
    begin 
     splitstring(currentctlvalue,st1,st2);
     if st1='' then st1:=st2;
     tplar[34]:=st1
    end
   else tplar[34]:=tplar[24];
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  Repeat
   Inc(FormCount);
   st1:=currentctlvalue;
   repeat
     splitstring(st1,st2,st1);
     if st2='' then begin st2:=st1; st1:='' end;
     if grepmatch(st2,tplar[24]) then ok:=true else begin ok:=false; st1:='' end;
   until (st1='');
   FindNextParameter;
  Until (FormCount=20) or not(MoreParameters) or ok;

  if not ok then
    begin
     if strupcase(copy(getctlvalue('CHANGEPHONE'),1,1))<>'Y'
       then
         begin
           if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
           logmsg('#','(E) '+postr+'Invalid phone number "'+tplar[24]+'"');
           incerror(true);
           if not waserr
             then
               begin
                 error(getctlvaluelite('STRERRTPL'),false,0);
                 waserr:=true;
                 incerror(false);
                 error(getctlvaluelite('PHONEERRTPL'),false,0);
                 decerror(false)
               end
             else
               error(getctlvaluelite('PHONEERRTPL'),false,0);
         end
       else
         begin
           if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
           logmsg('#','(W) '+postr+'Invalid phone number "'+tplar[24]+'"');
           incerror(false);
           if not waserr
             then
               begin
                 error(getctlvaluelite('STRERRTPL'),false,0);
                 waserr:=true;
                 incerror(true);
                 error(getctlvaluelite('PHONEERRTPL'),false,0);
                 decerror(true)
               end
             else
               error(getctlvalue('PHONEERRTPL'),false,0);

   {  buta:= pos(','+tplar[22]+','+tplar[24]+','+tplar[26],s1)+2+length(tplar[22]);
     delete(s1,buta,length(tplar[24]));
     if buta > 2 then begin insert(tplar[34],s1,buta);}

               logmsg('#','The phone number was changed to "'+tplar[34]+'"')
          end
    end
 else
   tplar[34]:=tplar[24];

{   end;}

  ok:=false;
  FindFirstParameter('LOCATION');
  if strupcase(copy(getctlvalue('CHANGELOCATION'),1,1))='Y' then 
    begin 
     splitstring(currentctlvalue,st1,st2);
     if st1='' then st1:=st2;
     tplar[35]:=st1
    end
   else tplar[35]:=tplar[23];
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  Repeat
   Inc(FormCount);
   st1:=currentctlvalue;
   repeat
     splitstring(st1,st2,st1);
     if st2='' then begin st2:=st1; st1:='' end;
     if grepmatch(st2,tplar[23]) then ok:=true else begin ok:=false; st1:='' end;
   until (st1='');
   FindNextParameter;
  Until (FormCount>=255) or not(MoreParameters) or ok;

  if not ok then
begin
  if strupcase(copy(getctlvalue('CHANGELOCATION'),1,1))<>'Y' then
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'Invalid location "'+tplar[23]+'"');
     incerror(true);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvaluelite('LOCATERRTPL'),false,0);
        decerror(false)
      end
    else
        error(getctlvaluelite('LOCATERRTPL'),false,0);
   end
  else
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(W) '+postr+'Invalid location "'+tplar[23]+'"');
     incerror(false);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(true);
        error(getctlvaluelite('LOCATERRTPL'),false,0);
        decerror(true)
      end
    else
        error(getctlvaluelite('LOCATERRTPL'),false,0);

{     buta:= pos(','+tplar[21]+','+tplar[23]+','+tplar[22],s1)+2+length(tplar[21]);
     delete(s1,buta,length(tplar[23]));
     if buta > 2 then begin insert(tplar[35],s1,buta);}
{     tplar[23]:=}
     logmsg('#','The location field was changed to "'+tplar[35]+'"') end
   end
 else
  tplar[35]:=tplar[23];


{  end;}

  FindFirstParameter('SYSTEM');
  if currentctlvalue<>'' then
begin {system}

  ok:=false;

  if strupcase(copy(getctlvalue('CHANGESYSTEM'),1,1))='Y' then 
    begin 
     splitstring(currentctlvalue,st1,st2);
     if st1='' then st1:=st2;
     tplar[46]:=st1
    end
   else tplar[46]:=tplar[21];
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  Repeat
   Inc(FormCount);
   st1:=currentctlvalue;
   repeat
     splitstring(st1,st2,st1);
     if st2='' then begin st2:=st1; st1:='' end;
     if grepmatch(st2,tplar[21]) then ok:=true else begin ok:=false; st1:='' end;
   until (st1='');
   FindNextParameter;
  Until (FormCount=20) or not(MoreParameters) or ok;

  if not ok then
begin
  if strupcase(copy(getctlvalue('CHANGESYSTEM'),1,1))='N' then
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'Invalid system name "'+tplar[21]+'"');
     incerror(true);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvaluelite('SYSTEMERRTPL'),false,0);
        decerror(false)
      end
    else
        error(getctlvaluelite('SYSTEMERRTPL'),false,0);
   end
  else
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(W) '+postr+'Invalid system name "'+tplar[21]+'"');
     incerror(false);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(true);
        error(getctlvaluelite('SYSTEMERRTPL'),false,0);
        decerror(true)
      end
    else
        error(getctlvaluelite('SYSTEMERRTPL'),false,0);

  if strupcase(copy(getctlvalue('CHANGESYSTEM'),1,1))='Y' then
     logmsg('#','The system name field was changed to "'+tplar[46]+'"') end
   end

 else
  tplar[46]:=tplar[21]

end
 else tplar[46]:=tplar[21]; {system}

  FindFirstParameter('SYSOP');
  if currentctlvalue<>'' then
begin {sysop}

  ok:=false;

  if strupcase(copy(getctlvalue('CHANGESYSOP'),1,1))='Y' then 
    begin 
     splitstring(currentctlvalue,st1,st2);
     if st1='' then st1:=st2;
     tplar[47]:=st1
    end
   else tplar[47]:=tplar[22];
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  Repeat
   Inc(FormCount);
   st1:=currentctlvalue;
   repeat
     splitstring(st1,st2,st1);
     if st2='' then begin st2:=st1; st1:='' end;
     if grepmatch(st2,tplar[22]) then ok:=true else begin ok:=false; st1:='' end;
   until (st1='');
   FindNextParameter;
  Until (FormCount=20) or not(MoreParameters) or ok;

  if not ok then
begin
  if strupcase(copy(getctlvalue('CHANGESYSOP'),1,1))='N' then
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'Invalid sysop name "'+tplar[22]+'"');
     incerror(true);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvaluelite('SYSOPERRTPL'),false,0);
        decerror(false)
      end
    else
        error(getctlvaluelite('SYSOPERRTPL'),false,0);
   end
  else
   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(W) '+postr+'Invalid sysop name "'+tplar[22]+'"');
     incerror(false);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(true);
        error(getctlvaluelite('SYSOPERRTPL'),false,0);
        decerror(true)
      end
    else
        error(getctlvaluelite('SYSOPERRTPL'),false,0);

  if strupcase(copy(getctlvalue('CHANGESYSOP'),1,1))='Y' then
     logmsg('#','The sysop name field was changed to "'+tplar[47]+'"') end
   end

 else
  tplar[47]:=tplar[22]

end
 else tplar[47]:=tplar[22]; {sysop}

 if (tplar[27]='')
      and
    (((strupcase(copy(getctlvalue('NOFLAG'),1,1))<>'Y')
       or
      ((strupcase(copy(getctlvalue('NOFLAG'),1,1))='Y')
        and
 (copy(tplar[15],length(tplar[15])-length(tplar[26]),length(tplar[26])+1)<>tplar[26]+','))))
  then
    if (strupcase(copy(getctlvalue('NOFLAG'),1,1))='A')
      then
        begin
          if addedflagpr
            then
              begin

                if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
                logmsg('#','(W) '+postr+'No flags in the pointlist line. Default flag "'+tplar[39]+'" was added');
                incerror(false);
                if not waserr then
                  begin
                    error(getctlvaluelite('STRERRTPL'),false,0);
                    waserr:=true;
                    incerror(true);
                    error(getctlvaluelite('NOFLAGERRTPL'),false,0);
                    decerror(true)
                  end
                else
                  error(getctlvaluelite('NOFLAGERRTPL'),false,0)

              end
            else
        end
      else

   begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'No flags in the pointlist line');
     incerror(true);
     if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvaluelite('NOFLAGERRTPL'),false,0);
        decerror(false)
      end
    else
        error(getctlvaluelite('NOFLAGERRTPL'),false,0);
   end
  else
 begin

 new(flagar);
 for h:=1 to 100 do flagar^ [h]:= '';

 i:=0;
{ repeat
  inc(i)
 until tplar[27,i]=',';
 if i<length(tplar[27]) then while tplar[27,i+1]=',' do inc(i);
 flagar^ [1] := copy(tplar[27],1,i-1); }{the first flag}

 h:=0;
 repeat
  inc(h);
  j:=i;
  repeat
   inc(i)
  until (tplar[27,i]=',') or (i=length(tplar[27]));

{ ...........>>>>>>>>>>>>>>>>>>> }

  if i<length(tplar[27]) then while tplar[27,i+1]=',' do inc(i);
  if i=length(tplar[27]) then inc(i);
  flagar^ [h] :=copy(tplar[27],j+1,i-j-1); {the next flag}
 until i=length(tplar[27])+1;

 h:=0;
 repeat
  inc(h);
  if (flagar^ [h]='U') or ((strupcase(copy(getctlvalue('UPPERCASEFLAGS'),1,1))='Y') and (flagar^ [h]='u')) then
   begin
   flut:=flagar^ [h,1];
   repeat
     if flagar^ [h+1]='' then flagar^ [h]:='' else flagar^ [h]:=flut+flagar^ [h+1];
     inc(h);
   until flagar^ [h]='';
   end;
 until flagar^ [h]='';


 tplar[36]:=','+tplar[27]+',';

{writeln('Tplar= ',tplar[36]);}

 tplar[27]:='';
 h:=0;
 repeat
   inc(h);
   if flagar^[h]<>'' then tplar[27]:=tplar[27]+flagar^ [h]+',';
 until flagar^ [h]='';
 if tplar[27,length(tplar[27])]=',' then delete(tplar[27],length(tplar[27]),1);

 new(segmentformat);

  FindFirstParameter('FLAGS');
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  Repeat
   Inc(FormCount);
   SegmentFormat^ [FormCount]:=CurrentCTLValue;
   FindNextParameter;
  Until ((FormCount=30) or not(MoreParameters));

{ ------- check for error flags ----------- }

  h:=0;
  repeat
   inc(h);
   if strupcase(copy(getctlvalue('UPPERCASEFLAGS'),1,1))='Y' then tplar[29]:= strupcase(flagar^ [h])
        else tplar[29]:= flagar^ [h];

   i:=0;
   ok:= false;
   repeat
    inc(i);
    st2:=segmentformat^ [i];
    repeat
     splitstring(st2,st1,st2);
{     if (tplar[29]='U') and identic(st1,tplar[29]) then writeln('st1= ',st1,' tplar[29]= ',tplar[29]);}
     if grepmatch(st1,tplar[29]) then ok:= true;
     if st1='' then if grepmatch(st2,tplar[29]) then ok:= true;
    until (st1='') or ok;
   until (segmentformat^ [i]='') or ok;

   tplar[29]:= flagar^ [h];

   if not ok then
     if ((strupcase(copy(getctlvalue('REMOVEBADFLAGS'),1,1))='Y')) then
       begin
{         tplar[29]:= flagar^ [j];}
         st2:=flagar^ [h];
{         if copy(st2,1,1)=flut then delete(st2,1,1);}
         buta:=0;
         if pos(','+st2+',',tplar[36])<>0
           then
             buta:=pos(','+st2+',',tplar[36])+1
           else
             if copy(st2,1,1)=flut
                then
                  begin
                    delete(st2,1,1);
                    if pos(','+st2+',',tplar[36])<>0
                       then
                         buta:=pos(','+st2+',',tplar[36])+1
                       else
                         logmsg('!','Can''t remove unknown flag "'+tplar[29]+'" from your segment')
                   end
                else
                  logmsg('!','Can''t remove unknown flag "'+tplar[29]+'" from your segment');



(*         if h=1
           then
             begin dec(h1);
             if copy(st2,1,1)=flut
               then
                if copy(tplar[36],1,length(st2))=st2
                  then
                    buta:=1
                  else
                    if copy(tplar[36],1,length(st2)+1)=flut+','+copy(st2,2,length(st2)-1)
                      then
                        begin
                          delete(st2,1,1);
                          buta:=3
                        end
                      else begin
                        logmsg('!','Can''t remove unknown "'+tplar[29]+'" from your segment');
                        goto lb4 end
               else
                 if copy(tplar[36],1,length(st2))=st2
                   then
                     buta:=1
                   else begin
                     logmsg('!','Can''t remove unknown flag "'+tplar[29]+'" from your segment');
                     goto lb4 end end
           else
             if flagar^ [h+1]<>''
               then
                 if pos(','+st2+',',tplar[36])<>0
                   then
                     buta:=pos(','+st2+',',tplar[36])+1
                   else
                    if copy(st2,1,1)=flut
                      then
                        begin
                          delete(st2,1,1);
                          if pos(','+st2+',',tplar[36])<>0
                            then
                              buta:=pos(','+st2+',',tplar[36])+1
                            else
                              logmsg('!','Can''t remove unknown "'+tplar[29]+'" from your segment')
                         end
                       else
                         logmsg('!','Can''t remove unknown "'+tplar[29]+'" from your segment')
               else
                 if copy(tplar[36],length(st2)-1,length(st2)+1)=','+st2
                   then
                     buta:=length(tplar[36])-length(st2)-1
                   else
                     if copy(st2,1,1)=flut
                       then
                         begin
                           delete(st2,1,1);
                           if copy(tplar[36],length(st2)-1,length(st2)+1)=','+st2
                             then
                               buta:=length(tplar[36])-length(st2)-1
                             else
                               logmsg('!','Can''t remove unknown "'+tplar[29]+'" from your segment')
                          end
                        else
                           logmsg('!','Can''t remove unknown "'+tplar[29]+'" from your segment');*)


(*         if h1=1
           then
             begin dec(h1);
             if copy(st2,1,1)=flut
               then
                if copy(tplar[36],1,length(st2))=st2
                  then
                    buta:=1
                  else
                    if copy(tplar[36],1,length(st2)+1)=flut+','+copy(st2,2,length(st2)-1)
                      then
                        begin
                          delete(st2,1,1);
                          buta:=3
                        end
                      else begin
                        logmsg('!','Can''t remove unknown flag "'+tplar[29]+'" from your segment');
                        goto lb2 end
               else
                 if copy(tplar[36],1,length(st2))=st2
                   then
                     buta:=1
                   else begin
                     logmsg('!','Can''t remove unknown flag "'+tplar[29]+'" from your segment');
                     goto lb2 end end
           else
             if copy(st2,1,1)=flut
               then
                 if pos(flagar^ [h-1]+','+st2,tplar[36])<>0
                   then
                     buta:=pos(flagar^ [h-1]+','+st2,tplar[36])+1+length(flagar^ [h-1])
                   else
                     if pos(flagar^ [h-1]+','+flut+','+copy(st2,2,length(st2)-1),tplar[36])<>0
                       then
                         buta:= pos(flagar^ [h-1]+','+flut+','+copy(st2,2,length(st2)-1),tplar[36])+2+length(flagar^ [h-1])
                       else
                         if pos(copy(flagar^ [h-1],2,length(flagar^ [h-1])-1)+','+copy(st2,2,length(st2)-1),tplar[36])<>0
                           then
                             begin
  buta:= pos(copy(flagar^ [h-1],2,length(flagar^ [h-1])-1)+','+copy(st2,2,length(st2)-1),tplar[36])+length(flagar^ [h-1]);
                               delete(st2,1,1);
                             end
                           else
                             begin
                               delete(st2,1,1);
                               goto lb1
                             end
               else
         lb1: if pos(flagar^ [h-1]+','+st2,tplar[36])<>0
                then
                  buta:= pos(flagar^ [h-1]+','+st2,tplar[36])+1+length(flagar^ [h-1])
                else
                  begin
                    logmsg('!','Can''t remove unknown flag "'+tplar[29]+'" from your segment');
                    goto lb2
                  end;*)
lb1:

     delete(tplar[36],buta,length(st2)+1);

     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(W) '+postr+'Unknown flag "'+tplar[29]+'" was removed from your segment');
if (tplar[36]=',') and ((strupcase(copy(getctlvalue('NOFLAG'),1,1))='N') or (strupcase(copy(getctlvalue('NOFLAG'),1,1))='A'))
then begin
     if not addedflagpr then goto lb2;
     logmsg('$','No flags in the pointlist line. Default flag "'+tplar[39]+'" was added')
end;
lb2:
     incerror(false);
     if not waserr then
               begin
                 error(getctlvaluelite('STRERRTPL'),false,0);
                 waserr:=true;
                 incerror(true);
                 error(getctlvaluelite('FLAGERRTPL'),false,0);
                 decerror(true)
               end
             else
               error(getctlvaluelite('FLAGERRTPL'),false,0);

{ mmmmmmmmmmmmmmmmmm }

       end

    else

     begin
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'Unknown flag "'+tplar[29]+'"');
      incerror(true);
      if not waserr then begin
        error(getctlvaluelite('STRERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvaluelite('FLAGERRTPL'),false,0);
        decerror(false)
      end
    else
        error(getctlvaluelite('FLAGERRTPL'),false,0);
    end
  until (flagar^ [h+1]='');


{ ------- check for duplicate flags ----------- }

  h:=0;
  repeat
   inc(h);
   if strupcase(copy(getctlvalue('UPPERCASEFLAGS'),1,1))='Y' then tplar[29]:= strupcase(flagar^ [h])
        else tplar[29]:= flagar^ [h];

   i:=h;
   repeat
    inc(i);

   if strupcase(copy(getctlvalue('UPPERCASEFLAGS'),1,1))='Y' then st2:= strupcase(flagar^ [i])
        else st2:= flagar^ [i];

       st4:=st2;
       if st4[1]='!' then st4:='!'+st4;

       if tplar[29]<>'' then
         if grepmatch(st4,tplar[29]) then
begin

   if ((strupcase(copy(getctlvalue('REMOVEBADFLAGS'),1,1))='Y')) then
       begin
{         tplar[29]:= flagar^ [h];}
         st2:=flagar^ [h];
         if pos(','+st2+',',copy(tplar[36],2,length(tplar[36])-1))<>0
           then
             buta:=pos(','+st2+',',copy(tplar[36],2,length(tplar[36])-1))+1
           else
             if copy(st2,1,1)=flut
                then
                  begin
                    delete(st2,1,1);
                    if pos(','+st2+',',copy(tplar[36],2,length(tplar[36])-1))<>0
                       then
                         buta:=pos(','+st2+',',copy(tplar[36],2,length(tplar[36])-1))+1
                       else
                         logmsg('!','Can''t remove duplicate "'+tplar[29]+'" from your segment')
                   end
                else
                  logmsg('!','Can''t remove duplicate "'+tplar[29]+'" from your segment');

(*               else
                 if copy(tplar[36],length(st2)-1,length(st2)+1)=','+st2
                   then
                     buta:=length(tplar[36])-length(st2)-1
                   else
                     if copy(st2,1,1)=flut
                       then
                         begin
                           delete(st2,1,1);
                           if copy(tplar[36],length(st2)-1,length(st2)+1)=','+st2
                             then
                               buta:=length(tplar[36])-length(st2)-1
                             else
                               logmsg('!','Can''t remove duplicate "'+tplar[29]+'" from your segment')
                          end
                        else
                           logmsg('!','Can''t remove duplicate "'+tplar[29]+'" from your segment');*)

(*                       if pos(','+flut+','+copy(st2,2,length(st2)-1)+',',tplar[36])<>0
                       then
                         buta:= pos(','+flut+','+copy(st2,2,length(st2)-1)+',',tplar[36])+2
                       else
                         if pos(copy(flagar^ [h-1],2,length(flagar^ [h-1])-1)+','+copy(st2,2,length(st2)-1),tplar[36])<>0
                           then
                             begin
  buta:= pos(copy(flagar^ [h-1],2,length(flagar^ [h-1])-1)+','+copy(st2,2,length(st2)-1),tplar[36])+length(flagar^ [h-1]);
                               delete(st2,1,1);
                             end
                           else
                             begin
                               delete(st2,1,1);
                               goto lb3
                             end
               else
         lb3: if pos(flagar^ [h-1]+','+st2,tplar[36])<>0
                then
                  buta:= pos(flagar^ [h-1]+','+st2,tplar[36])+1+length(flagar^ [h-1])
                else
                  begin
writeln('3-H1= ',h1);
writeln('flagar[h-1]= ',flagar^ [h-1]);
writeln('flagar[h]= ',flagar^ [h]);
writeln('h= ',h);
                    logmsg('!','Can''t remove duplicate flag "'+tplar[29]+'" from your segment');
                    goto lb4
                  end;*)



     flagar^ [h]:=',';
     delete(tplar[36],buta,length(st2)+1);

             if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
             logmsg('#','(W) '+postr+'Duplicate flag "'+tplar[29]+'" was removed from the string');

     incerror(false);
     if not waserr then
               begin
                 error(getctlvaluelite('STRERRTPL'),false,0);
                 waserr:=true;
                 incerror(true);
                 error(getctlvaluelite('DUPFLGERRTPL'),false,0);
                 decerror(true)
               end
             else
               error(getctlvaluelite('DUPFLGERRTPL'),false,0);

{ mmmmmmmmmmmmmmmmmm }

       end
  else

           begin
             if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
             logmsg('#','(E) '+postr+'Duplicate flag "'+tplar[29]+'" in the pointsegment string');
             incerror(true);
             if not waserr then
               begin
                 error(getctlvaluelite('STRERRTPL'),false,0);
                 waserr:=true;
                 incerror(false);
                 error(getctlvaluelite('DUPFLGERRTPL'),false,0);
                 decerror(false)
               end
             else
               error(getctlvaluelite('DUPFLGERRTPL'),false,0);
            st2:=''
           end;

        st2:=''
      end
     until st2=''

  until (flagar^ [h]='');

 { ------- check for implies -------- }


{  dispose(segmentformat);
   new(segmentformat); }

  for j:=1 to 30 do segmentformat^ [j]:= '';

  FindFirstParameter('IMPLIES');
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  Repeat
   Inc(FormCount);
   SegmentFormat^ [FormCount]:=CurrentCTLValue;
   FindNextParameter;
  Until ((FormCount=30) or not(MoreParameters));

  for h:=1 to 30 do
    begin
      j:= pos('=',segmentformat^ [h]);
      if j<>0 then begin segmentformat^ [h]:= copy(segmentformat^ [h],1,j-1);
         segmentformat^ [h]:= segmentformat^ [h]+ ' '+copy(segmentformat^ [h],j+1,length(segmentformat^ [h])-j)
        end
    end;

  h:=0;
  repeat
   inc(h);
   if strupcase(copy(getctlvalue('UPPERCASEFLAGS'),1,1))='Y' then tplar[29]:= strupcase(flagar^ [h])
        else tplar[29]:= flagar^ [h];

   i:=0;
   repeat
    inc(i);
    st2:=segmentformat^ [i];
    splitstring(st2,st1,st2);
if st1<>'' then tplar[30]:=st1 else tplar[30]:=st2;

    if (tplar[29]<>'') and (grepmatch(tplar[30],tplar[29])) then
      repeat
       splitstring(st2,st1,st2);
       j:=0;
       repeat
         inc(j); if j=h then inc(j);
         if strupcase(copy(getctlvalue('UPPERCASEFLAGS'),1,1))='Y'
           then
             tplar[29]:= strupcase(flagar^ [j])
           else
             tplar[29]:= flagar^ [j];
       if tplar[29]<>'' then
         if grepmatch(st1,tplar[29]) or ((st1='') and grepmatch(st2,tplar[29])) then
begin
tplar30:=tplar[30];
tplar[30]:=flagar^ [h];
     if ((strupcase(copy(getctlvalue('REMOVEBADFLAGS'),1,1))='Y')) then
       begin
{i:=0;
repeat
 inc(i);
 writeln('i= ',i,' flagar^ [i]= ',flagar^ [i])
until flagar^ [i]='';}


buta2:=0;

         tplar[29]:= flagar^ [j];
         st3:= flagar^ [j];
         if pos(','+st3+',',tplar[36])<>0
           then
             buta:=pos(','+st3+',',tplar[36])+1
           else
             if copy(st3,1,1)=flut
                then
                  begin
                    delete(st3,1,1);
                    if pos(','+st3+',',tplar[36])<>0
                       then begin
                         buta:=pos(','+st3+',',tplar[36])+1;
                         buta2:=buta
                         end
                       else
                         logmsg('!','Can''t remove implied flag "'+tplar[29]+'" from your segment')
                   end
                else
                  logmsg('!','Can''t remove implied flag "'+tplar[29]+'" from your segment');



     flagar^ [j]:=',';
     delete(tplar[36],buta,length(st3)+1);
{     tplar[29]:=',';}

     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(W) '+postr+'Redundant flag "'+tplar[29]+'" implied by "'+tplar[30]+'" flag was removed');
 if buta2=buta then if copy(tplar[36],length(tplar[36])-2,3)=','+flut+',' then
 begin
    delete(tplar[36],length(tplar[36])-2,2);
    logmsg('#','Single ",'+flut+'" was removed from the string')
  end;

lb6:     incerror(false);
     if not waserr then
               begin
                 error(getctlvaluelite('STRERRTPL'),false,0);
                 waserr:=true;
                 incerror(true);
                 error(getctlvaluelite('IMPLERRTPL'),false,0);
                 decerror(true)
               end
             else
               error(getctlvaluelite('IMPLERRTPL'),false,0);

{ mmmmmmmmmmmmmmmmmm }

       end
      else
       begin
             tplar[29]:= flagar^ [j];
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'Redundant flag "'+tplar[29]+'" is implied by "'+tplar[30]+'" flag');
             incerror(true);
             if not waserr then
               begin
                 error(getctlvaluelite('STRERRTPL'),false,0);
                 waserr:=true;
                 incerror(false);
                 error(getctlvaluelite('IMPLERRTPL'),false,0);
                 decerror(false)
               end
             else
               error(getctlvaluelite('IMPLERRTPL'),false,0);

end

           end;

{flagar^ [h]:=',';}
tplar[30]:=tplar30;

        until flagar^ [j]=''

     until st1=''

   until (segmentformat^ [i]='');
  until (flagar^ [h]='');

  dispose(segmentformat);
  dispose(flagar);

 end;

 s1:=tplar[25]+','+xstr(numofnode(stre))+','+tplar[46]+','+tplar[35]+','+tplar[47]+','+tplar[34]+','+tplar[38]+','+
  copy(tplar[36],2,length(tplar[36])-2);
  if (copy(tplar[15],length(tplar[15])-length(tplar[26])+1,length(tplar[26]))=tplar[26])
  and
  (copy(tplar[15],length(tplar[15])-length(tplar[26]),length(tplar[26])+1)<>tplar[26]+',')
  then if copy(s1,length(s1),1)=',' then delete(s1,length(s1),1);
end;

procedure movet(param1,param2: string);
{ Simple, fast file copy program with NO error-checking }
var
  FromF, ToF: file;
  NumRead, NumWritten: {$IFDEF VIRTUALPASCAL } LongInt {$ELSE} Word {$ENDIF};
  Buf: array[1..2048] of Char;
  str1: string;
begin
  Assign(FromF, param1); { Open input file } {@segname}

{  if copy(param2,2,1)=':' then begin}
   getdir(0,str1);
   if (copy(str1,length(str1),1)<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ) then str1:=str1+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF};
   if copy(param1,2,1)<>':' then param1:=str1+param1;
   
{$IFNDEF LINUX} if strupcase(copy(param1,1,2))<>strupcase(copy(param2,1,2)) then
 {$ENDIF}
     begin
  Reset(FromF, 1);  { Record size = 1 }
 
  runerror('movet',1);  
  
  Assign(ToF, Param2); { Open output file }
  Rewrite(ToF, 1);  { Record size = 1 }
  
 runerror('movet',2);  
 
{  Writeln('Copying ', FileSize(FromF), ' bytes...');}
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  
 runerror('movet',3);  
  
  Close(FromF);
  
 runerror('movet',4);  
  
  Close(ToF);
  
 runerror('movet',5);  
  
  erase(fromf);
  exit
  end;
  
 rename(fromf,param2)
;
 runerror('movet',6);
 
end;

procedure copys(param1,param2: string);
{ Simple, fast file copy program with NO error-checking }
var
  FromF, ToF: file;
  NumRead, NumWritten: {$IFDEF VIRTUALPASCAL } LongInt {$ELSE} Word {$ENDIF};
  Buf: array[1..2048] of Char;
begin
  Assign(FromF, param1); { Open input file } {@segname}
  Reset(FromF, 1);  { Record size = 1 }
  Assign(ToF, Param2); { Open output file }
  Rewrite(ToF, 1);  { Record size = 1 }
{  Writeln('Copying ', FileSize(FromF), ' bytes...');}
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  Close(FromF);
  setftime(ToF,ftime);
  
  Close(ToF);
end;

Function admchar(first: char; cha1: string): boolean;
var sq1,sq2: string;
begin
 if first<>';' then begin
 sq1:= getctlvalue('ADMISSIBLECHARS');
 if sq1='' then sq1:='['+chr(33)+'-'+chr(127)+']';
 end
 else

 if ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('CHECKCOMMENTS')[1])
        {$ELSE}strupcase(copy(getctlvalue('CHECKCOMMENTS'),1,1)){$ENDIF}='N')
   then
     sq1:='*'
   else
     sq1:='['+chr(31)+'-'+chr(255)+']';

 repeat
   splitstring(sq1,sq2,sq1)
 until grepmatch(sq2,cha1) or (sq2='');
 if (sq2='') and (not grepmatch(sq1,cha1)) then begin admchar:=false; exit end;
 admchar:=true

end;

begin { genuine readsegment }
 pth1:= GetCTLValueLite ('BACKUPDIR');
 if pth1<>'' then begin
  getdir(0,pth2);
  if copy(pth1,length(pth1),1)={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then delete(pth1,length(pth1),1);
  chdir(pth1);
  if IOResult <> 0 then haltonerror(
    'Cannot find backup directory : '+pth1+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ,backupnotfound)
  else
  begin
   chdir(pth2);
   logmsg('@','Copying segment file to the backup directory : '+pth1+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} );
   copys(tplar[33],pth1+{$IFDEF LINUX} 
'/' + StrDownCase(tplar[8]) {$ELSE} 
'\' + tplar[8] {$ENDIF}) 
  end
 end;

 logmsg('@','Scanning segment file...');
 ex:=true;
 first:=true;
 new(numpoint);
 s:=getctlvalue('BETWEENCOMMENTS');
 if ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='Y') or
    ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='S') or
    ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='E') or
    ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='W')
 then unixlines:=true
 else unixlines:=false;
 {$IFDEF LINUX} if strupcase(str4)='-L' then unixlines:=false; {$ENDIF}
  assign(f, tplar[33]);
  if unixlines
    then
       assign(ff, tplar[33]);
 waserr:=false;
  if unixlines
    then
       reset(ff,1)
    else
       reset(f);
 tplar[31]:='';
 eoff:=false;
 repeat
  if unixlines
    then
      if readunixln(ff,tplar[15]) then else
    else
      readln(f,tplar[15]);
  tplar[32]:=xstr(xval(tplar[32])+1);
{ if tplar[15,1]<>';' then}
 for i:=1 to length(tplar[15]) do
  if (not admchar(tplar[15,1],tplar[15,i])) 
     or ((tplar[15,i-1]=';') and (tplar[15,i]='`') and 
        ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('NODELIFECOMPAT')[1])
        {$ELSE}strupcase(copy(getctlvalue('NODELIFECOMPAT'),1,1)){$ENDIF}='Y'))

then
   begin
     tplar[31]:= '#'+xstr(ord(tplar[15,i]));   {@inadmchar}
{     if ord(tplar[15,i])<33 then tplar[15,i]:=#32;}
     if numofnode(tplar[15])<0 then tplar[20]:='is unknown' else tplar[20]:=tplar[19]+'.'+xstr(numofnode(tplar[15]));
     if tplar[20]='is unknown' then postr:='' else postr:=tplar[20]+' ';
     logmsg('#','(E) '+postr+'Inadmissible char "'+tplar[31]+'" in the pointsegment line');
{     postr:=tplar[15];
     for j:=1 to length(tplar[15]) do if ord(tplar[15,j])<33 then tplar[15,j]:=#32;}
     incerror(true);
     if not waserr then begin
        error(getctlvalue('INADMCHARERRTPL'),false,0);
        waserr:=true;
        incerror(false);
        error(getctlvalue('INADMCHARERRTPL'),false,1);
        decerror(false)
      end
    else
        error(getctlvalue('INADMCHARERRTPL'),false,2);
{     tplar[15]:=postr;}
   end;
  waserr:=false;
  if unixlines
    then
      eoff:=(filepos(ff)=0)
    else
      eoff:=eof(f)
 until eoff;
  if unixlines
    then
       close(ff)
    else
       close(f);
 waserr:=false;

 for ii:=1 to 32767 do begin numpoint^ [ii,1]:=false; numpoint^ [ii,2]:=false end;
 ii:=0;

  if unixlines
    then
       reset(ff,1)
    else
       reset(f);
 eoff:=false;
 repeat
  if unixlines
    then
      if readunixln(ff,tplar[15]) then else
    else
      readln(f,tplar[15]);
  ii:=numofnode(tplar[15]);
  if (ii>0) and (ii<32768) then
   if numpoint^ [ii,1] and (not numpoint^ [ii,2]) then
     numpoint^ [ii,2]:=true
   else numpoint^ [ii,1]:= true;
  if unixlines
    then
      eoff:=(filepos(ff)=0)
    else
      eoff:=eof(f)
 until eoff;
  if unixlines
    then
       close(ff)
    else
       close(f);

 for ii:=1 to 32767 do if numpoint^ [ii,1] and numpoint^ [ii,2] then
   begin
     tplar[20]:=tplar[19]+'.'+xstr(ii);
     logmsg('#','(E) '+tplar[20]+' Duplicate point number');
     incerror(true);
     error(getctlvalue('EQNUMERRTPL'),false,0);
  if unixlines
    then
       reset(ff,1)
    else
       reset(f);
 eoff:=false;
     repeat
  if unixlines
    then
      if readunixln(ff,tplar[15]) then else
    else
      readln(f,tplar[15]);
      if numofnode(tplar[15])=ii then
        begin
         incerror(false);
         error(getctlvalue('EQNUMERRTPL'),false,1);
         decerror(false)
        end;
  if unixlines
    then
      eoff:=(filepos(ff)=0)
    else
      eoff:=eof(f)
 until eoff;
  if unixlines
    then
       close(ff)
    else
       close(f);
    end;

 st2:= getctlvalue('TEMPDIR');
 if st2<>'' then if st2[length(st2)]<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then st2:=st2+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ;
 st3:='PNT_TMP.FFF';

 assign(f1, st2+st3);
  if unixlines
    then
      reset(ff,1)
    else
      reset(f);
 runerror('readsegment',0);
 rewrite(f1);
 if ioresult<>0 then haltonerror('Can''t create tempfile[1] : '+st2+st3,Cannotcreatetempfile);
 eoff:=false;
 repeat
  tplar[14]:=xstr(xval(tplar[14])+1);
  tplar[32]:=tplar[14];

  if unixlines
    then
      if readunixln(ff,tplar[15]) then
  if {$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='W'
    then
        begin
          logmsg('#','(W) Incorrect format of segment line detected');
          incerror(false);
          error(getctlvalue('UNIXLINETPL'),false,0)
        end
    else if {$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='E' then
     begin
      logmsg('#','(E) Incorrect format of segment line detected');
      incerror(true);
      error(getctlvalue('UNIXLINETPL'),false,1)
     end else
          else
    else
      readln(f,tplar[15]);
  if length(tplar[15])=0 then
  if strupcase(copy(getctlvalue('REMOVEEMPTYLINES'),1,1))='Y'
    then
     begin
      logmsg('|','Superfluous empty line was found and removed');
      incerror(false);
      error(getctlvalue('EMPTYLINETPL'),false,0)
     end
    else
     begin
      logmsg('#','(E) Superfluous empty line was found');
      incerror(true);
      error(getctlvalue('EMPTYLINETPL'),false,1);
      writeln(f1, tplar[15]);
     end
  else
    writeln(f1, tplar[15]);
  if unixlines
    then
      eoff:=(filepos(ff)=0)
    else
      eoff:=eof(f)
 until eoff;
  if unixlines
    then
       close(ff)
    else
       close(f);
 close(f1);
 runerror('readsegment',1);
  if unixlines
    then
       erase(ff)
    else
       erase(f);
{    end;}

 runerror('readsegment',3);

 movet(st2+st3, tplar[33]);

 runerror('readsegment',4);

 ii:=0;

 tplar[14]:='0'; {seglines}
 tplar[32]:='0';

 assign(f1, st2+st3);
  if unixlines
    then
      reset(ff,1)
    else
      reset(f);
      
 runerror('readsegment',5);

 rewrite(f1);
 if ioresult<>0 then haltonerror('Can''t create tempfile[2] : '+st2+st3,Cannotcreatetempfile);
 eoff:=false;
 repeat
  if unixlines
    then
      if readunixln(ff,s1) then 
       else
    else
      readln(f,s1);
  tplar[14]:=xstr(xval(tplar[14])+1);
  tplar[32]:=tplar[14];
{  if length(s1)>0 then begin}
   if (s1[1]=';') then begin {2}
    if ii=xval(tplar[12]) then ex:=false;
    if ex then begin {1}
     writeln(f1, s1);
     ii:=ii+1;
     if ii=xval(tplar[12]) then ex:=false;
    end {1}
   else begin {1}
         logmsg('|','Superfluous commentline was found and removed');
         incerror(false);
         tplar[15]:=s1;
         error(getctlvalue('CMNTERRTPL'),false,0);
        end {1}
   end {2}
   else begin {2}
    if not (upcase(s[1])='Y') then ex:=false;
    if first then
       begin
          first:=false;
          bosscheck
       end
      else if length(s1)>0 then checkstring(s1);
    writeln(f1, s1)
   end; {2}
{  end}
  if unixlines
    then
      eoff:=(filepos(ff)=0)
    else
      eoff:=eof(f)
 until eoff;
    if first then
       begin
          first:=false;
	  s1:='';
          bosscheck
       end;
  if unixlines
    then
       close(ff)
    else
       close(f);
 close(f1);
 runerror('readsegment',2);
  if unixlines
    then
       erase(ff)
    else
       erase(f);
 movet(st2+st3, tplar[33]);
{ dispose(segmentstring);}
 dispose(numpoint);
end;

Procedure checkage;
var
   realage,time: longint;
Function segage: word;
const
   days: array[1..12] of byte = (31,28,31,30,31,30,31,31,30,31,30,31);
var
   year, month, day, dow, curmonth, curyear :
     {$IFDEF VIRTUALPASCAL} {$IFDEF FPC} Word {$ELSE} Longint {$ENDIF} {$ELSE} Word {$ENDIF};
   filet: text;
   pack: datetime;
   age: longint;
begin
  age:=0;
  GetDate(year,month,day,dow);
  assign (filet, tplar[33]);
  reset(filet);
  getftime(filet,time);
  unpacktime(time,pack);
  close(filet);
  if pack.year>year
    then age:=-1
    else
      if pack.year=year
        then
          if pack.month>month
            then age:=-1
            else
              if (pack.month=month) and (pack.day>day) then age:=-1;

  if age>=0 then
    begin
      curmonth:=pack.month;
      curyear:=pack.year;
      age:=days[curmonth]-pack.day;
      while (curmonth<month) or (curyear<year) do
        begin
          inc(curmonth); if curmonth=13 then begin curmonth:=1; inc(curyear) end;
          age:=age+days[curmonth];
          if (curmonth=2) and (curyear mod 4 =0) then age:=age+1
        end;
      age:=age-(days[curmonth]-day)
     end
    else
      begin
        time:=-1;
        pack.year:=year;
        pack.month:=month;
        pack.day:=day;
        packtime(pack,ftime);
        age:=0;
      end; 
  segage:=age
end;

begin {checkage}
 realage:= segage;
 logmsg('+','Segment file is dated '+tplar[10]+', age: '+xstr(realage)+' day(s)');
 if time=-1 then logmsg('!','Incorrect segment date was changed.');

 tplar[43]:=getctlvaluelite('SEGWRNAGE');
 tplar[43]:=xstr(xval(tplar[43]));
 tplar[44]:=getctlvaluelite('SEGERRAGE');
 tplar[44]:=xstr(xval(tplar[44]));
 if xval(tplar[44])>=realage then
    tplar[45]:=xstr(xval(tplar[44])-realage)
  else tplar[45]:='a few';

 if tplar[44]<>'-1' then
    if realage>xval(tplar[44]) then begin
       incerror(true);
       logmsg('#','(E) Segment is too old, older than '+tplar[44]+' day(s)');
               error(getctlvaluelite('AGEERRTPL'),false,0);
               exit
             end;

 if tplar[43]<>'-1' then
    if realage>xval(tplar[43]) then begin
       incerror(false);
       logmsg('#','(W) Segment is older than '+tplar[43]+' day(s)');
               error(getctlvaluelite('AGEWRNTPL'),false,0);
               exit
             end;

end;

Procedure report(addrh: taddrtype);
 var pth1: string[80];
  pth2,str1,str8: string;
{  templfl: text;}
Begin

 runerror('report',1);

 str1:=getctlvaluelite('TEMPLATEPATH');
 if copy(str1,length(str1),1)<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then str1:=str1+ {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ;
 assign(templfl,str1+getctlvaluelite('NORMALTEMPLATE'));
 reset(templfl);
 if ioresult<>0 then begin
   logmsg('!','Error opening template file : '+str1+getctlvaluelite('NORMALTEMPLATE'));
	 haltonerror('Netmail report was not sent!',templatenotfound)
 end;
 close(templfl);

  { Get directory name from ctl file }
  getdir(0,pth2);
  pth1:= GetCTLValueLite ('NETMAIL');
  if copy(pth1,length(pth1),1)= {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then delete(pth1,length(pth1),1);
  if pth1='' then pth1:=pth2;
  chdir(pth1);
  if IOResult <> 0 then haltonerror(
    'Cannot find netmail directory : '+GetCTLValueLite ('NETMAIL'),netmailnotfound)
  else
  begin
   chdir(pth2);
   Net.NetmailPath:=pth1;
   Net.CreateMsg;
  {$I-}
   Net.SetFromTo(addrh);
{   writeln(getctlvaluelite('FROM'));}
   if getctlvaluelite('FROM')='' then Net.SetFrom(nameprog) else Net.SetFrom(tplstring(getctlvaluelite('FROM')));

   str8:=getctlvaluelite('TO');
   if str8='' then str8:='SysOp' else begin
     str8:=trim(tplstring(str8));
   end;
   Net.SetTo(str8);

   if getctlvaluelite('SUBJECT')='' then Net.SetSubj(nameprog+' report')
                                    else Net.SetSubj(tplstring(getctlvaluelite('SUBJECT')));
{   Net.SetPvt(True);
   Net.SetLoc(True);}
   setmsgflags;
   Net.MsgText.Putstring('PID: '+nameprog+' v'+version+' '+serial);
   endflag:=false;
   assign(templfl,createtpl(str1+getctlvaluelite('NORMALTEMPLATE')));
   reset(templfl);
   while not eof(templfl) do
     begin
       readln(templfl,pth2);
     pth2:=tplstring(pth2);
    if (endflag and (length(pth2)<>0)) or (not endflag) then
{       if (i=length(pth2)) and (pth2[i]<>';') then} Net.MsgText.PutString(pth2)
{         else
       if (pth2[i]=';') and (length(pth2)>1) then Net.MsgText.PutString(tplstring(copy(pth2,1,i-1)))}
     end;
   close(templfl);
   erase(templfl);
   Net.MsgText.PutString('--- '+tplstring(getctlvaluelite('TEARLINE')));
   if getctlvaluelite('ORIGIN')<>'' then Net.MsgText.PutString(
    ' * Origin: '+tplstring(getctlvaluelite('ORIGIN'))+' ('+xstr(addr.fromzone)+':'+xstr(addr.fromnet)+
    '/'+xstr(addr.fromnode)+'.'+xstr(addr.frompoint)+')');
   Net.SaveMessageText;
   Net.CloseMsg;
   logmsg('{','Reporting to the netmail folder : '+pth1+ {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} );
   logmsg('[','Using template : '+getctlvaluelite('NORMALTEMPLATE'));
  end;
End;

Procedure moveseg;

procedure moves(param2: string);
{ Simple, fast file copy program with NO error-checking }
var
  FromF, ToF: file;
  NumRead, NumWritten: {$IFDEF VIRTUALPASCAL } LongInt {$ELSE} Word {$ENDIF};
  Buf: array[1..2048] of Char;
begin

  Assign(FromF, tplar[33]); { Open input file } {@segname}
{  if copy(param2,2,1)=':' then begin}
{   getdir(0,str1);}
(*   if str1[length(str1)]<> {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} then str1:=str1+
     {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} ; *)
{   if copy(param2,2,1)<>':' then param2:=str1+param2;}

{$IFNDEF LINUX}  if strupcase(copy(tplar[33],1,2))<>strupcase(copy(param2,1,2)) then
 {$ENDIF}
     begin

  Reset(FromF, 1);  { Record size = 1 }
  Assign(ToF, Param2); { Open output file }
  Rewrite(ToF, 1);  { Record size = 1 }
{  Writeln('Copying ', FileSize(FromF), ' bytes...');}
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  Close(FromF);
  setftime(ToF,ftime);
  Close(ToF);
  erase(fromf);
  exit
{   end}
  end;
  
 Assign(ToF, Param2); { Open output file }
 Reset(ToF);  { Record size = 1 }
 if ioresult=0 then begin
   close(tof);
   erase(tof)
  end;
 rename(fromf,param2);
 runerror('moves',1);
 reset(ToF);
 setftime(ToF,ftime);
 close(ToF)
end;

var ter:integer;
 f1: file;
 pth1,pth2: string;
begin
  {$I-}
  getdir(0,pth2);
  pth1:= GetCTLValueLite ('MASTER');
  if (copy(pth1,length(pth1),1)= {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ) and (copy(pth1,2,length(pth1)-1)<>':\') then delete(pth1,length(pth1),1);
  if pth1='' then pth1:=pth2;
  chdir(pth1);
  if IOResult <> 0 then haltonerror(
    'Path to the master directory not found : '+pth1+ {$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ,masternotfound);

 chdir(pth2);

 if (strupcase(copy(getctlvaluelite('KILLBAD'),1,1))<>'Y') and 
    (strupcase(copy(getctlvaluelite('KILLBAD'),1,1))<>'A') 
   then begin
  pth1:= GetCTLValuelite ('BADFILES');
  if (copy(pth1,length(pth1),1)={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ) and (copy(pth1,2,length(pth1)-1)<>':\') then delete(pth1,length(pth1),1);
  if pth1='' then pth1:=pth2;
  chdir(pth1);
  if IOResult <> 0 then haltonerror(
    'Path to the badfiles directory not found : '+GetCTLValuelite ('BADFILES'),badfilesnotfound);

  end;

   chdir(pth2);

 if tplar[11] {@result} = 'ok' then
   begin
     pth1:= GetCTLValueLite ('MASTER');

     if strupcase(str4)='-L' then pth1:='';

     if pth1<>'' then begin { pth1:=pth2;}
     if copy(pth1,length(pth1),1)<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then pth1:=pth1+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ;
     moves(pth1+{$IFDEF LINUX}StrDownCase(tplar[28]){$ELSE}tplar[28]{$ENDIF});
     if ioresult<>0 then haltonerror('Can''t move good segment file to the master directory : '+pth1,cantmove)
     else logmsg('<','Moving good segment file to the master directory : '+pth1)
    end
      else logmsg('<','Result of checking: segment is good.');

   if strupcase(copy(getctlvaluelite('KILLBAD'),1,1))='I' then
     begin
      pth1:= GetCTLValuelite ('BADFILES');
      if pth1='' then pth1:=pth2;
      if pth1[length(pth1)]<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then pth1:=pth1+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} 
;

      for i:=1 to formcount do
       begin

       pth2:=segmentformat[i];
    for ter:=length(pth2) downto 1 do if (pth2[ter-1]<>'~') and (pth2[ter]<>'~') and (pth2[ter]<>'.') then pth2[ter]:='?';

    findfirst(pth1+test(lk,pth2),$3F,dirinfo);
      while doserror=0 do
        begin

      pth2:= pth1+dirinfo.name;
        if exist(pth2) then
         begin
          assign(f1,pth2);
          erase(f1);
          if ioresult<>0 then logmsg('!','Can''t delete old bad segment file : '+pth2)
          else logmsg('&','Deleting old bad segment file : '+pth2)
         end;


         findnext(dirinfo);


        end;

     {$IFDEF VIRTUALPASCAL} findclose(dirinfo); {$ENDIF}

       end
      end
     end
    else
  if tplar[11] {@result} = 'bad' then
   if (strupcase(copy(getctlvaluelite('KILLBAD'),1,1))<>'Y') and (strupcase(copy(getctlvaluelite('KILLBAD'),1,1))<>'A') then
     begin
      pth1:= GetCTLValuelite ('BADFILES');
      if pth1<>'' then begin {pth1:=pth2;}
      if copy(pth1,length(pth1),1)<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  then pth1:=pth1+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} 
;
      moves(pth1+{$IFDEF LINUX}StrDownCase(tplar[28]){$ELSE}tplar[28]{$ENDIF});
      if ioresult<>0 then haltonerror('Can''t move bad segment file to the badfiles directory : '+pth1,cantmove)
      else logmsg('>','Moving bad segment file to the badfiles directory : '+pth1)
     end
      else logmsg('>','Result of checking: segment is bad.')
     end
   else
    begin
     erase(f1);
     if ioresult=0 then logmsg('>','Killing bad segment file')
    end
 else logmsg('!','Unknown error with moving the segment file!')
end;

Function donumber: boolean;
begin
{--------------------}

splitaddress(tplar[18],addr.fromzone,addr.fromnet,addr.fromnode,addr.frompoint);

becomeaddress(lk,true);

if lk<1 then begin
  donumber:=false;
  exit
 end;

splitaddress(tplar[18],addr.tozone,addr.tonet,addr.tonode,addr.topoint);
splitaddress(xstr(addr.tozone)+':'+xstr(addr.tonet)+'/'+xstr(lk),addr.tozone,addr.tonet,addr.tonode,addr.topoint);
  tplar[19]:=xstr(addr.fromzone)+':'+xstr(addr.fromnet)+'/'+xstr(lk);

donumber:= checknl(lk);

{--------------------}
end;

Function dosegment(stro: string): boolean;
var io: word; st1: string;
   year, month, day, dow:
     {$IFDEF VIRTUALPASCAL} {$IFDEF FPC} Word {$ELSE} Longint {$ENDIF} {$ELSE} Word {$ENDIF};
begin
 assign(tmpfile,stro);
 reset(tmpfile);
 io:=ioresult;
 if io<>0 then
    begin
      if io=5
        then
          begin
            logmsg('!','Unable to open segment file in R/W mode: '+stro);
            logmsg('!','Please remove R/O attribute from the file and try again.');
          end
        else
          logmsg ('!','Unable to open segment file : '+stro);
      dosegment:=false;
      exit
    end;

 tplar[40]:='SysOp'; tplar[41]:='';
 tplar[33]:=stro;
 tplar[8]:=retfname(tplar[33],false);
 tplar[9]:=xstr(filesize(tmpfile));
 close(tmpfile);
 tplar[10]:='';
 tplar[55]:='';
 assign(segfl,stro);
 reset(segfl);
   GetFTime(segfl,ftime); { Get creation time }
   UnpackTime(ftime,dt);
   with dt do
     begin
      tplar[10]:=tplar[10]+leadingzero(day);
      tplar[10]:=tplar[10]+'-';
      tplar[10]:=tplar[10]+monthname[month];
      tplar[10]:=tplar[10]+'-';
      tplar[10]:=tplar[10]+copy(xstr(year),length(xstr(year))-1,2);
      tplar[10]:=tplar[10]+' ';
      tplar[10]:=tplar[10]+leadingzero(hour);
      tplar[10]:=tplar[10]+':';
      tplar[10]:=tplar[10]+leadingzero(min);
      tplar[10]:=tplar[10]+':';
      tplar[10]:=tplar[10]+leadingzero(sec)
     end;
{  reset(segfl);}
  val(stro,numb,i);
  if i<>0 then numb:= defcommentcount;
close(segfl);

 logmsg('+','Segment file : '+tplar[33]);

 if (strupcase(copy(getctlvalue('TOUCHSEGMENTS'),1,1))='Y') then
    begin
      GetDate(year,month,day,dow);
      tplar[55]:=tplar[55]+leadingzero(day);
      tplar[55]:=tplar[55]+'-';
      tplar[55]:=tplar[55]+monthname[month];
      tplar[55]:=tplar[55]+'-';
      tplar[55]:=tplar[55]+copy(xstr(year),length(xstr(year))-1,2);
      tplar[55]:=tplar[55]+' ';

      dt.year:=year;
      dt.month:=month;
      dt.day:=day;

      GetTime(year,month,day,dow);
      tplar[55]:=tplar[55]+leadingzero(year);
      tplar[55]:=tplar[55]+':';
      tplar[55]:=tplar[55]+leadingzero(month);
      tplar[55]:=tplar[55]+':';
      tplar[55]:=tplar[55]+leadingzero(day);

      dt.hour:=year;
      dt.min:=month;
      dt.sec:=day;

      packtime(dt,ftime);

     end;

     st1:= getctlvalue('EXECBEFORE');
     if st1 <> '' then begin
          execpr(paramo(st1));

 assign(tmpfile,stro);
 reset(tmpfile);
 io:=ioresult;
 if io<>0 then haltonerror ('Unable to open segment file ('+stro+') after execution of external utility',segnotopen);

 close(tmpfile);

     end;

dosegment:=true;
end;

Procedure segment(stro: string);
begin

 if not dosegment(stro) then exit;

 tplar[18]:=getctlvalue('ADDRESS');
 if tplar[18]='' then tplar[18]:='2:5020/770';

 if not donumber then
   begin
     if (lk=-1) or (lk=0) then
       logmsg('|','Unknown format of segment name!')
     else
       logmsg('|','Segment rejected due to inadmissible nodelist status. Report suppressed.');
     tplar[11]:='bad';
     tplar[28]:=tplar[8];
     inc(result)
   end
  else begin
     
  {haltonerror('Unknown format of segment name!',incorrectsegname);}

(*      str1:=getctlvaluelite('MASTER');
      if str1[length(str1)]<> {$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} then str1:=str1+
{$IFDEF LINUX} '/' {$ELSE} '\' {$ENDIF} ;
      writeln(testname(str1));
*)

if (strupcase(copy(getctlvalue('TOUCHSEGMENTS'),1,1))='Y') then
 logmsg('+','New segment date is '+tplar[55]+', age is not checked')
else
 checkage;

 readsegment;

 execonce;

 error('a',true,0);

 if (strupcase(copy(getctlvaluelite('ONLYONEREPORT'),1,1))<>'Y') or
    ((tplar[2]='    0 (none)') and (tplar[3]='    0 (none)')) then if getctlvaluelite('NETMAIL')<>'' then report(addr);

end;

{$I-}
if ioresult<>0 then writeln('Strange error!');
  moveseg;

end;

Procedure compilepointlist;

const daysinmonths: array [1..12] of byte = (31,28,31,30,31,30,31,31,30,31,30,31);
      daysofweek: array [0..6] of string[9] = ('Sunday', 'Monday', 'Tuesday',
                         'Wednesday', 'Thursday', 'Friday', 'Saturday');
      months: array [1..12] of string[9] = ('January', 'February', 'March',
              'April', 'May', 'June', 'July', 'August', 'September', 'October',
              'November', 'December');


      friday: boolean = false;

(* ------------------------------------------- *)

Procedure strdig(var value: string; number: word; digits: byte);
var i: byte;
begin
  value:=xstr(number);
  for i:=digits-1 downto length(xstr(number)) do value:= '0'+value
end;

Procedure dayofyear;
Const
 visok: byte = 0;
Var
 Year, Month, Day, DayOfWeek: {$IFDEF VIRTUALPASCAL} {$IFDEF FPC} Word {$ELSE} Longint {$ENDIF} {$ELSE} Word {$ENDIF};
 i: byte;

 doy: Word;
begin
  doy:= 0;
  getdate(Year, Month, Day, DayOfWeek);
  if year mod 4 = 0 then visok:=1;
  for i:=1 to month-1 do
    begin
     doy:= doy+daysinmonths[i];
     if (i=2) then doy:= doy+visok
    end;
  doy:=doy+day;

  if friday then
begin
    if dayofweek=6 then
      begin
        doy:=doy+6;
        day:=day+6 
      end
    else
      begin
        doy:=doy+(5-dayofweek);
        day:=day+(5-dayofweek)
      end;

  if month<>2 then visok:=0;

       if daysinmonths[month]+visok<day then
          begin
            day:=day-(daysinmonths[month]+visok);
            inc(month);
            if month>12 then begin
             month:=1;
             inc(year)
            end
          end;

         dayofweek:=5

     end; {friday}

  strdig(tplar[48],day,2);
  tplar[49]:= months[month];
  tplar[50]:= xstr(year);
  tplar[51]:= daysofweek[dayofweek];
  strdig(tplar[52],doy,3);

  logmsg('+','Pointlist for '+tplar[51]+', '+tplar[49]+' '+tplar[48]+', '+tplar[50]+
          ' -- Day number '+tplar[52])

end;

(* ------------------------------------------- *)

Type
   booltype = array [0..4095] of byte;
Var
   bool: ^booltype;
   plokho,segm: boolean;
    number:integer;
    node,maxnode: word;
    nametest: string;
    pntfile: text;
    pntfileb: file of char;
    f:text;
    ff: file;
    backslash,crcpos: byte;

begin

 if lite then haltonerror('Compilation of pointlist is not possible in the LITE mode!',notcompatiblewithlitemode);

(* calculatecrc = today
               friday
               none *)

 tplar[54]:=getctlvaluelite('POINTLIST');
 if tplar[54]='' then haltonerror('Variable POINTLIST not defined!',212);

 if strupcase(copy(getctlvaluelite('PNTLDATE'),1,1))='F' then friday:= true;

 dayofyear;

 segm:=false;

 formcount:=0;

{ writeln;}
{ colormsg(LightGreen,'Sorry! In this version of PNTCHK option "-L" is disabled.');
 exit;}
  FindFirstParameter('SEGMENTFORMAT');
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
  if plokho then plokho:=false;
  Repeat
   Inc(FormCount);
   SegmentFormat[FormCount]:=CurrentCTLValue;
   FindNextParameter;
  Until ((FormCount=20) or not(MoreParameters));

maxnode:=xval(getctlvaluelite('MAXNUMBER'));

if maxnode>32767 then maxnode:=32767;

      nametest:= GetCTLValueLite ('MASTER');
      if nametest='' then getdir(0,nametest);

logmsg('@','Scanning MASTER directory : '+nametest);
     if ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('CREATIONCHECK')[1])
        {$ELSE}strupcase(copy(getctlvalue('CREATIONCHECK'),1,1)){$ENDIF}='M') then str3:='MEDIUM' else
     if ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('CREATIONCHECK')[1])
        {$ELSE}strupcase(copy(getctlvalue('CREATIONCHECK'),1,1)){$ENDIF}='F') or
	(getctlvalue('CREATIONCHECK')='') then str3:='MEDIUM' else
          str3:='QUICK';

        logmsg('+','Type of checking : '+str3);

      if nametest[length(nametest)]<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  then nametest:=nametest+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} 
;

  new(bool);

  fillchar(bool^,sizeof(booltype),0);

  FindFirst(nametest+{$IFDEF VIRTUALPASCAL}'*' {$ELSE} '*.*' {$ENDIF}, $3F, DirInfo);

  while DosError = 0 do
  begin

    tplar[8]:=DirInfo.Name;
    becomeaddress(number,false);
    if number>0 then

        bool^ [number div 8] := bool^ [number div 8] or (1 shl (number mod 8));

    FindNext(DirInfo);
    
  end;

  {$IFDEF VIRTUALPASCAL} findclose(dirinfo); {$ENDIF}

  for node := 1 to maxnode do if 
    (bool^ [node div 8] and (1 shl (node mod 8)))<>0 then
 begin
  lk:=node;
  
      nametest:= GetCTLValueLite ('MASTER');
      if nametest='' then getdir(0,nametest);
      if nametest[length(nametest)]<>{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  then nametest:=nametest+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} 
;
      nametest:= testname(nametest);

  if nametest<>'' then
   begin

    tplar[2]:='0 (none)';
    tplar[13]:='Feda';
    tplar[11]:='ok';
    tplar[3]:='0 (none)'; {warnings}
    tplar[14]:='0'; {seglines}
    tplar[32]:='0';
    tplar[18]:=getctlvalue('ADDRESS');
    if tplar[18]='' then tplar[18]:='2:5020/770';

     logmsg('+','Processing segment file : '+nametest);
     if not dosegment(nametest) then continue;

{ !!! }

     if not donumber then begin
       tplar[11] {@result} := 'bad';
       if lk<>-1 then
       logmsg('|','Segment rejected due to inadmissible nodelist status. Report suppressed.');
       moveseg;
       continue;
   end;

{ !!! }

     if ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('CREATIONCHECK')[1])
        {$ELSE}strupcase(copy(getctlvalue('CREATIONCHECK'),1,1)){$ENDIF}='M') or
        ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('CREATIONCHECK')[1])
        {$ELSE}strupcase(copy(getctlvalue('CREATIONCHECK'),1,1)){$ENDIF}='F') or
	(getctlvalue('CREATIONCHECK')='') then

     checkage;
     
    if  ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('CREATIONCHECK')[1])
        {$ELSE}strupcase(copy(getctlvalue('CREATIONCHECK'),1,1)){$ENDIF}='F') or
	(getctlvalue('CREATIONCHECK')='') then
     
     readsegment else

begin

 if ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='Y') or
    ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='S') or
    ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='E') or
    ({$IFDEF VIRTUALPASCAL}upcase(getctlvalue('READUNIXLINES')[1])
        {$ELSE}strupcase(copy(getctlvalue('READUNIXLINES'),1,1)){$ENDIF}='W')
 then unixlines:=true
 else unixlines:=false;
 {$IFDEF LINUX} if strupcase(str4)='-L' then unixlines:=false; {$ENDIF}

  assign(f, tplar[33]);
  if unixlines
    then
       assign(ff, tplar[33])
    else
       assign(f, tplar[33]);
  if unixlines
    then
       reset(ff,1)
    else
       reset(f);
 eoff:=false;
 repeat
  if unixlines
    then
      if readunixln(ff,tplar[15]) then else
    else
      readln(f,tplar[15]);
  tplar[14]:=xstr(xval(tplar[14])+1);
  tplar[32]:=tplar[14];

  if unixlines
    then
      eoff:=(filepos(ff)=0)
    else
      eoff:=eof(f)
 until eoff;
  if unixlines
    then
       close(ff)
    else
       close(f)
end;

     if tplar[11] {@result} = 'ok' then begin

    if not segm then
      begin
        segm:=true;

  tplar[53]:= getctlvaluelite('FAKECRCSTR');
  if tplar[53]='' then tplar[53]:='00000';

        backslash:=0;

        for i:=1 to length(tplar[54]) do if tplar[54,i]={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  then backslash:=i;

        if pos('.',copy(tplar[54],backslash+1,length(tplar[54])-backslash))=0 then
           tplar[54]:=tplar[54]+'.'+tplar[52];



        assign(pntfile,tplar[54]);

        rewrite(pntfile);
        if ioresult<>0
          then
            haltonerror('Unable to create pointlist file : '+tplar[54],
                                         unabletocreatepointlist)
          else logmsg('@','Opening pointlist file : '+tplar[54]);

        if getctlvaluelite('PNTLSTHEADER')<>''
          then
            begin

              endflag:=false;
              str3:=createtpl(getctlvaluelite('PNTLSTHEADER'));
              assign(segfl,str3);
              reset(segfl);

              runerror('compile',0);

              repeat

                readln(segfl,str3);
                str3:=tplstring(str3);
                if not (endflag and (str3='')) then writeln(pntfile,';'+str3{$IFDEF LINUX}+#13{$ENDIF});

              until (eof(segfl)) or endflag;

              close(segfl);
              erase(segfl)

            end;

          runerror('compile',1);

      end; {not segm}

    if getctlvaluelite('PNTSEGHEADER')<>'' then begin

     endflag:=false;
     str3:=createtpl(getctlvaluelite('PNTSEGHEADER'));
     assign(segfl,str3);
     reset(segfl);

     runerror('compile',4);

     repeat
       readln(segfl,str3);
       str3:=tplstring(str3);
       if not (endflag and (str3='')) then writeln(pntfile,';'+str3{$IFDEF LINUX}+#13{$ENDIF});
     until (eof(segfl)) or endflag;

      close(segfl);
      erase(segfl)

     end;

     assign(segfl,nametest);
     reset(segfl);
     repeat
       readln(segfl,str3);
       writeln(pntfile,str3{$IFDEF LINUX}+#13{$ENDIF});
     until eof(segfl);
     close(segfl);

   if getctlvaluelite('PNTSEGFOOTER')<>'' then begin

     runerror('compile',55);

     endflag:=false;
     str3:=createtpl(getctlvaluelite('PNTSEGFOOTER'));
     assign(segfl,str3);
     reset(segfl);

     runerror('compile',0);

     repeat
       readln(segfl,str3);
       str3:=tplstring(str3);
       if not (endflag and (str3='')) then writeln(pntfile,';'+str3{$IFDEF LINUX}+#13{$ENDIF});
     until (eof(segfl)) or endflag;

     close(segfl);
     erase(segfl)

     end;

     end;

     runerror('compile',2);

     changetime;

     moveseg;

     runerror('compile',8);

   error('a',true,0);

     runerror('compile',9);

     if ioresult<>0 then logmsg('!','An error occured processing segment file : '+nametest)
   end

  end;

    if segm then
      begin

        runerror('compile',6);

        if getctlvaluelite('PNTLSTFOOTER')<>'' then begin

     runerror('compile',7);

     endflag:=false;
     str3:=createtpl(getctlvaluelite('PNTLSTFOOTER'));
     assign(segfl,str3);
     reset(segfl);

     runerror('compile',0);

     repeat
       readln(segfl,str3);
       str3:=tplstring(str3);
       if not (endflag and (str3='')) then writeln(pntfile,';'+str3{$IFDEF LINUX}+#13{$ENDIF});
     until (eof(segfl)) or endflag;

     close(segfl);
     erase(segfl)

   end;

   write(pntfile,#26);

  close(pntfile);

  reset(pntfile);
  readln(pntfile,str3);
  close(pntfile);
  crcpos:=pos(tplar[53],str3);

  strdig(tplar[53],ndlcrc(tplar[54]),5); {crc}

  if crcpos<>0 then
    begin
      assign(pntfileb,tplar[54]);
      reset(pntfileb);

{      write('Patching pointlist ');}
      seek(pntfileb,crcpos-1);
      for i:=1 to 5 do
        begin
          write(pntfileb,tplar[53,i]);
{          write('.');}
        end;
{      writeln(' done');}
      close(pntfileb)
    end;

  logmsg('@','Closing processed pointlist file, CRC='+tplar[53]); 

     str3:= getctlvalue('EXECPNTLST');
     if str3 <> '' then begin
          execpr(paramo(str3));
     end;

  result:=2
  end
           else begin logmsg('#','No pointlist was compiled'); result:=0 end;

  dispose(bool);

end;

Begin
{$IFDEF BSD}clrscr;{$ENDIF}
 result:=0;
 str2:='554E524547';
 serial:='';
 for lk:=1 to 10 do
begin

 ch1:=str2[lk];
 case ch1 of
   'A': i:=10;
   'B': i:=11;
   'C': i:=12;
   'D': i:=13;
   'E': i:=14;
   'F': i:=15;
  else i:= xval(ch1);
 end; {case}

 inc(lk);

 ch1:=str2[lk];
 case ch1 of
   'A': j:=10;
   'B': j:=11;
   'C': j:=12;
   'D': j:=13;
   'E': j:=14;
   'F': j:=15;
  else j:= xval(ch1);
 end; {case}

 serial:=serial+chr(i*16+j);
end;

{writeln(serial); halt;}

  owner:= 'Unregistered!';

  tplar[1]:='none';
  tplar[2]:='0 (none)';
  tplar[13]:='Feda';
  tplar[4]:=nameprog; {nameprog}
  tplar[5]:=serial; {serial}
  tplar[6]:=owner; {owner}
  tplar[7]:=version; {version}
  tplar[11]:='ok';
  tplar[3]:='0 (none)'; {warnings}
  tplar[14]:='0'; {seglines}
  tplar[32]:='0';

 for i:=1 to tplcount-10 do tplconst[i]:=tplconst2[i];

  endflag:=false;
  wasattr:=false;
(*  namefprog:= {$IFDEF VIRTUALPASCAL } 'PNTCHK-2' {$ELSE} nameprog {$ENDIF};*)

  TextColor (White);
  Write (nameprog+', ver.' + Version);
  ColorMsg (LightCyan, {$IFDEF VIRTUALPASCAL } {$ELSE} '  '+ {$ENDIF}
                       {$IFNDEF WIN32} {$IFDEF LINUX} {$ELSE} 
                       {$IFDEF DOS32} ' '+ {$ELSE} '  '+ {$ENDIF}
                       {$ENDIF} {$ENDIF} {$IFDEF EMX} ''+ {$ELSE} ' '+ {$ENDIF}
                       ' Professional pointsegment checker');
  ColorMsg (Yellow, 'Copyright (c) 1997,2004 Pavel I.Osipov (2:5020/770@fidonet)');
{  colormsg (lightgray,'       * * *  Dedicated to Nataliy Mitina  * * *        ');}
  WriteLn;
(*  {$IFDEF COMMERCIAL}
  TextColor (LightGray);
  Write ('Product owner: ');
  ColorMsg (Yellow, Owner);
  TextColor (LightGray);
  Write ('Serial number: ');
  ColorMsg (LightCyan, Serial);
  TextColor (LightGray);
  WriteLn;
  {$ELSE}
  ColorMsg (LightRed+128,'This copy is an unregistered evaluation!');
  textcolor(lightgray);
  writeln;
  {$ENDIF}*)
  ctlfl:= paramstr(1);
  if (copy(ctlfl,1,2)<>'-c') and (copy(ctlfl,1,2)<>'-C') then ctlfl:= {namefprog+}'pntchk.ctl'
   else
    delete(ctlfl,1,2);
  If (not Exist (ctlfl)) or (ctlfl='') Then
  Begin
    ColorMsg (LightRed, 'Unable to open configuration file: '+ctlfl);
    Halt(ctlnotopen);
  End;

  ReadCTLFile (ctlfl);
  registration;

  IF serial<>tplar[5] then begin
{  tplar[4]:=tplar[4]+'+';}
  TextColor (LightGray);
  Write ('Product owner: ');
  ColorMsg (Yellow, Owner);
  TextColor (LightGray);
  Write ('Serial number: ');
  ColorMsg (LightCyan, Serial);
  TextColor (LightGray);
  WriteLn;
   end
  else
   begin
  ColorMsg (LightRed+128,'This copy is an unregistered evaluation!');
  textcolor(lightgray);
  writeln;
   end;

  tplar[5]:=serial; {serial}
  tplar[6]:=owner; {owner}

 i:=0;
 repeat
  inc(i);
  str4:=paramstr(i)
 until (copy(str4,1,1)<>'-') or (STRUPCASE(str4)='-L');

 for i:=1 to paramcount do if (copy(paramstr(i),1,1)='-')
  and (strupcase(copy(paramstr(i),1,2))<>'-L')
  and (strupcase(copy(paramstr(i),1,2))<>'-C') 
  and (strupcase(copy(paramstr(i),1,2))<>'-S') then str4:='';

  if (paramcount=0) or (str4='') then
    begin
      textcolor(15);
      write('Usage: '+'PNTCHK' {$IFDEF WIN32} +namefprog {$ENDIF} 
                               {$IFDEF DOS32} +namefprog {$ENDIF} 
			       {$IFDEF LINUX} +namefprog {$ENDIF} 
			       {$IFDEF EMX}   +namefprog {$ENDIF} 
			       
                 {$IFNDEF LINUX} 
+'.EXE' {$ENDIF} +' [-c<config>] <option> [<segment_file>]');
      writeln;
      writeln;
      writeln('<options>');
      writeln(' [-s]: check segment file (segment name is a required field)');
      write('   -l: create pointlist');
      textcolor(7); writeln;
  DoneCTLManager;
      halt
    end;
  tplar[5]:=serial; {serial}
  tplar[6]:=owner; {owner}

  FindFirstParameter('ASSIGN');
  FormCount:=0;
  if not MoreParameters then MoreParameters:=True;
{  if plokho then plokho:=false;}
  Repeat
   Inc(FormCount);
   splitstring(CurrentCTLValue,tplconst[tplcount-10+formcount],tplar[tplcount-10+formcount]);
   FindNextParameter;
  Until ((FormCount=10) or not(MoreParameters));

{  if (strupcase(copy(getctlvalue('DEBUG'),1,1))='Y') then debug:=true else debug:=false;}
  if getctlvalue('COMMENTCOUNT')<>'' then tplar[12]:=getctlvalue('COMMENTCOUNT') else tplar[12]:='5';
  if strupcase(copy(getctlvalue('SHARINGMODE'),1,1))='Y' then sharingmode:=true;
  str3:= GetCTLValue ('LOGFILE');
  if str3='' then str3:='PNTCHK.LOG';
  OpenLogFile (str3, GetCTLValue ('LOGLEVEL'), nameprog+' v'+version);
{--------------------}

 str2:='';
 for i:=1 to paramcount do str2:=str2+paramstr(i)+' ';
 delete(str2,length(str2),1);
 logmsg('+','Command line parameters : '+str2);
 logmsg('+','Configuration : '+ctlfl);

{ ---------- lite ---------------------- }

 If {$IFDEF VIRTUALPASCAL}upcase(getctlvalue('LITE')[1])
        {$ELSE}strupcase(copy(getctlvalue('LITE'),1,1)){$ENDIF}='Y'
 then
  begin
     lite:=true;
     logmsg('+','LITE version. Sending of reports supressed.')
  end
 else
   begin {checkdirs}

{ ---------- checkdirs ----------------- }

  { Get directory name from ctl file }
  getdir(0,str2);
  str3:= GetCTLValuelite ('NETMAIL');
  if str3<>'' then begin
   if copy(str3,length(str3),1)={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then delete(str3,length(str3),1);
   chdir(str3);
   if IOResult <> 0 then begin 
     chdir(str2);
     haltonerror(
     'Cannot find netmail directory : '+str3+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ,netmailnotfound); end;
  end;
  chdir(str2);

  str3:= getctlvalue('TEMPDIR');
  if str3<>'' then begin
   if copy(str3,length(str3),1)={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} then delete(str3,length(str3),1);
   if str3='' then str3:=str2;
   chdir(str3);
   if IOResult <> 0 then begin
    chdir(str2);
     haltonerror(
     'Cannot find temporary directory : '+str3+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ,tempdirnotfound);
  end; end;

  chdir(str2);

  str3:= GetCTLValueLite ('BACKUPDIR');
  if str3<>'' then begin
   if copy(str3,length(str3),1)={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  then delete(str3,length(str3),1);
   chdir(str3);
   if IOResult <> 0 then begin
     chdir(str2);
     haltonerror(
    'Cannot find backup directory : '+str3+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ,backupnotfound)
  end; end;

  chdir(str2);

  str3:= GetCTLValueLite ('MASTER');
  if str3<>'' then begin
   if str3[length(str3)]={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  then delete(str3,length(str3),1);
   chdir(str3);
   if IOResult <> 0 then begin
    chdir(str2);
    haltonerror(
    'Cannot find master directory : '+str3+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ,masternotfound)
  end; end;

  chdir(str2);

 if (strupcase(copy(getctlvaluelite('KILLBAD'),1,1))<>'Y') and 
    (strupcase(copy(getctlvaluelite('KILLBAD'),1,1))<>'A') then begin
  str3:= GetCTLValueLite ('BADFILES');
  if str3<>'' then begin
   if str3[length(str3)]={$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF}  then delete(str3,length(str3),1);
   chdir(str3);
   if IOResult <> 0 then begin
     chdir(str2);
     haltonerror(
    'Cannot find badfiles directory : '+str3+{$IFDEF LINUX} 
'/' {$ELSE} 
'\' {$ENDIF} ,badfilesnotfound)
    end
  end
 end;

  chdir(str2);

{ --------- end of checkdirs ----------- }

  end; {checkdirs}

if strupcase(str4)='-L' then compilepointlist else

{ ---------- Oho! -----------------}

begin

  FindFirst(str4, $3F, DirInfo2);

  if doserror<>0 then haltonerror ('No segment file(s) found : '+str4,segnotopen);
  while DosError = 0 do
  begin


    wasattr:=false;
    tplar[2]:='0 (none)';
    tplar[13]:='Feda';
    tplar[11]:='ok';
    tplar[3]:='0 (none)'; {warnings}
    tplar[14]:='0'; {seglines}
    tplar[32]:='0';


    segment(retfname(str4,true)+DirInfo2.Name);
    FindNext(DirInfo2);
  end;

     {$IFDEF VIRTUALPASCAL} findclose(dirinfo2); {$ENDIF}

{findfirst/findnext
segment(str1)
}

{ ---------- Oho! -----------------}

 if result >1 then formcount:=2 else formcount:=0;
 if (result=1) or (result-2=1) then inc(formcount);

end;

{--------------------}

  CloseLOGFile ('Done ('+xstr(formcount)+')');
  writeln;
  ColorMsg (White, 'Everything is ok, have a nice day, or two!');
  DoneCTLManager;
  TextAttr := $07;
  halt(formcount)

END.
