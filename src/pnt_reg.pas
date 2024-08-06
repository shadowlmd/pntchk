uses bvtools,tpstring;
var 
 f1: text;
 ch1,ch3,ch5: char;
 i,j,k,ch2,ch4,ch6: byte;
 hex1,hex2,hex3: string;
 regname,regname2,regstring,regstring2: string;
 aaa: longint;
label lb1,lb2,lb3;

BEGIN
 randomize;
 write('Registration or checking? ');
 readln(ch1);
 write('Please enter the registername: ');
 readln(regname2);
 regname:=regname2;
 if ch1='c' then goto lb2;
 lb3:
 regstring:='';
 write('Please enter the registernumber: ');
 readln(regstring2);
 for i:=1 to 3 do
begin
 LB1:
 ch1:=regstring2[i];
 ch2:=random(ord(ch1));
 ch4:=random(ord(ch1)-ch2);
 ch6:=ord(ch1)-ch2-ch4;

{ writeln('The code is: ',ch2+ch4+ch6,' (',chr(ord(ch2+ch4+ch6)),')');}

 ch4:=ch4+ch2;
 ch6:=ch6+ch2;

 hex1:=hexb(ch2);
 hex2:=hexb(ch4);
 hex3:=hexb(ch6);

{ ch2:=ch2-xval(ch1);}
{  ch2:=ch2+xval(ch1);}
 regstring:=regstring+hex1+hex2+hex3
end;
ch1:=regstring2[4];
 case ch1 of
   'A': ch1:='1';
   'B': ch1:='2';
   'C': ch1:='3';
  else begin writeln('Invalid code!'); halt end;
  end; {case}

{write('Please type the kind of registration: A - 1, B - 2, C - 3 etc ');}
{readln(ch1);}
 regname:=regname+regstring+ch1;
 aaa:=342453534;
 for i:=1 to length(regname) do
  begin
{    ch1:=}
{  writeln(ord(regname[i]));}
  if i mod 2 = 0 then aaa:=aaa*ord(regname[i]) else aaa:=aaa div ord(regname[i]);

{  writeln('AAA: ',aaa);}
 end;
 regstring:=regstring+ch1+hexl(aaa);
 writeln('The registration code is: ',regstring);
{ writeln('The register code is: ',hex1,hex2,hex3);}
 write('Is that OK? ');
 readln(ch5);
 if (ch5='n') or (ch5='N') then begin i:=1; regstring:=''; regname:=regname2; goto lb1 end;

 assign(f1,'PNTCHK.KEY');
 rewrite(f1);
 writeln(f1,'REGISTERNAME '+regname2);
 writeln(f1,'REGISTERKEY '+regstring);
 close(f1);

 halt;

{-----------------------------}

 lb2:
 write('Please enter the register key: ');
 readln(regstring);
 hex2:=regname;
 regname:=regname+regstring;
 aaa:=342453534;
 for i:=1 to length(regname)-8 do
  begin
  if i mod 2 = 0 then aaa:=aaa*ord(regname[i]) else aaa:=aaa div ord(regname[i]);
 end;
 hex1:=hexl(aaa);
 writeln;
 if hex1=copy(regname,length(regname)-7,8) then writeln('Valid key!')
 else begin writeln('Invalid key!'); halt end;
 writeln;

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

 writeln('Prodect owner: ',hex2);
 writeln('Registration number: ',hex3);

end.