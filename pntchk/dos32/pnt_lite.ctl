;
;   Professional pointsegment checker v1.00.rc6 (lite) configuration file
;
;-----------------------------------------------------------------------------
;   ����� �孨�᪨� ����p��� 祪�p�
;-----------------------------------------------------------------------------
;
;   ��p�� ��襩 ��⥬�. ��p����, �᫨ ����p ��襣� ��� �⫨砥���
;   �� 2:5020/ (�� 㬮�砭��)
;
; ADDRESS 2:5020/770
;
;   ��� ���䠩��
;
LOGFILE pntchk.log
;
;   ���� ᮮ�饭��, ����� �� ���� �뢮������ � ���
;
LOGLEVEL .
;
;   �᫨ 'YES', � ��� �㤥� ����뢠���� ��᫥ ������ ������塞�� ���窨, ���
;   �� ᤥ���� � T-Mail �� LogBuffer=0. ������� �� ��� ⮣�, �⮡� �� �����
;   ᮮ�饭�� �������⮣� ���� � ��砥 ᡮ�. ������ �� ��᪮�쪮 ��������
;   ࠡ��� �ணࠬ�� � ����� �ॡ�� ���� �㤠-�. ;)
;
SHARINGMODE NO
;
;   ��६����� ����砥� �.�. "�����祭��" (LITE) ०�� ࠡ��� 祪��,
;   ����� �㦨� ��� �����쭮� �஢�ન �����ᥣ���� ��। ���
;   ���뫪�� ���न�����.
;
LITE YES
;
;-----------------------------------------------------------------------------
;   ����� ����p���, ���������� 祪�p� ᠬ����⥫쭮 ��p������ ��� �訡��
;-----------------------------------------------------------------------------
;
;   ������� �� ����� ��p��� �� ᥣ����, ��p����뢠� ��� �p� �⮬
;   �᫨ YES, � ����� ��p��� �㤥� 㤠����, �㤥� �뤠�� �p���p�������, ��
;   ᥣ���� �㤥� ��p���⠭ ��p���쭮;
;   �᫨ NO, � �㤥� �뤠�� ᮮ�饭�� �� �訡��
;
REMOVEEMPTYLINES NO
; REMOVEEMPTYLINES YES
;
;   ��६����� READUNIXLINES ��।���� ��������� 祪�� �� �����㦥���
;   unix-style ��ப (�� ����稢������ �� cr/lf):
;   NO - �� ��� ࠭��, ࠡ�⠥� �⠭����� ��᪠���᪨� readln (�
;        DOS/OS2-���ᨨ ��ப� �� lf �ᯮ�������� �� ����, FPC-���ᨨ
;        �� ��ப� 㬥�� �ᯮ������� ��⮬���᪨)
;   SILENT - ���� ��ࠡ��뢠�� ��ப�, ��� ��� ��� �����稢����� �� CR/LF
;        (� FPC-������ �������筮 READUNIXLINES=NO)
;   WARNING - ��ࠡ��뢠�� ��ப�, �� �뤠���� warning (⥬����� UNIXLINETPL)
;   ERROR - �뤠���� �訡�� (⥬����� UNIXLINETPL), ���ࠪ��뢠�� ᥣ����
;
READUNIXLINES WARNING
;
;   �������� ��p�p����� p����� 祪�p� � ��砥 ����p㦥��� �訡�� � ����
;   "Phone". �᫨ CHANGEPHONE=YES, � �訡�筮� ���祭�� ���� "Phone" �㤥�
;   �������� �� ��p��� ���祭�� ��p������� PHONENUMBER, �㤥� �뤠�� ����
;   �p���p�������, �訡�� �� �㤥� (PHONEERRORTPL ������ ᮮ⢥��⢮����
;   ⥬����� phonewrn.tpl);
;   �p� CHANGEPHONE=NO �뤠���� �訡�� � ᥣ���� ���p����뢠����
;   (PHONEERRORTPL=phoneerr.tpl)
;
CHANGEPHONE NO
; CHANGEPHONE YES
;
;   �������筮 CHANGEPHONE
;
CHANGELOCATION NO
; CHANGELOCATION YES
;
;   ����� ���ᠭ�� � CHANGEPHONE
;
CHANGEBAUD NO
; CHANGEBAUD YES
;
;   �� �� ᠬ��
;
CHANGESYSTEM NO
; CHANGESYSTEM YES
;
;   �������筮
;
CHANGESYSOP NO
; CHANGESYSOP YES
;
;   �����⨬� �� ��p��� ��� ������� 䫠�� (�᫨ YES, � ��ப� ������
;   �����稢����� "<baud_rate>,"); �᫨ ADD, 䫠� �㤥� �������� �
;   ᮮ⢥��⢨� � ��⠭������ �� 㬮�砭�� � �� ADDEDFLAGS
;
NOFLAG YES
; NOFLAG ADD
; NOFLAG NO
;
;   ������� �� �����४�� 䫠�� (���祭�� YES) ����� �뤠� ᮮ�饭�� ��
;   �訡�� (���祭�� NO) � ��砥 �� ����p㦥���.
;   �����४�� 䫠� ��⠥��� � ��砥:
;       �) 䫠� �������⥭ (�� ��।���� ��६���묨 FLAGS � ���䨣�);
;       �) 䫠� ����砥��� ����� ������ ࠧ� � ��ப�;
;       �) 䫠� ���� �室�騬 � ���� �� ��㣨� 䫠��� � ��ப� (��६����
;   IMPLIES)
;
REMOVEBADFLAGS NO
; REMOVEBADFLAGS YES
;
;   �����, ������塞� �p� NOFLAG=ADD ��� �p� �모�뢠��� ��� 䫠���,
;   ����� REMOVEBADFLAGS=YES
;
; ADDEDFLAGS V21 V22 V22B V32
;
;-----------------------------------------------------------------------------
;   �� ��p����p� ������ ���������� ���p�����p��.
;-----------------------------------------------------------------------------
;
;   �������, �����⨬� � ����⫨�⮢�� ��p���� (�� 㬮�砭�� [!-])
;
; ADMISSIBLECHARS [!-] [�-�] � � [������] [�-�]
;
;   ��᫮ ��ப � ��������ﬨ � ᥣ���� (�� 㬮�砭�� 5)
;
COMMENTCOUNT 5
;
;   �����⨬� �� �������p�� ����� ��p����묨 ����⫨�⮢묨 ��p�����
;   (�᫨ YES, ��p���� CMNTERRTPL ᮮ⢥�����騬 ��p����)
;
BETWEENCOMMENTS NO
;
;   ��६����� �������� ������� ०�� �஢�ન �������ਥ� ��
;   �����⨬� ᨬ���� (�������⨬묨 � ���������� ������� �.�.
;   "�ࠢ���騥 ᨬ����" - ᨬ���� � ������ ����� 32).
;
CHECKCOMMENTS YES
;
;   ��६����� ����砥� ०�� ᮢ���⨬��� � �������
;   ����-�����஬ Nodelife, ������ ��ப� �������ਥ� �����ᥣ����,
;   ᮤ�ঠ騥 ��᫥����⥫쭮��� ᨬ����� ";`", ����� �����४⭮
;   ����� ����-�����஬ ��ࠡ��뢠����.
;
NODELIFECOMPAT YES
;
;   �����⨬�� ���祭�� ���� "prefix" (�� 㬮�砭�� "Point")
;
; PREFIX Point
; PREFIX @ ; ����� ��ப�
;
;   �����⨬� ���祭�� ���� "᪮���� ������" (�� 㬮�砭�� 300, 1200, 2400,
;   9600)
;
; BAUD 300 1200 2400 9600 14400
;
;   �����⨬� ���祭�� ���� "Phone" (�� 20). �� 㬮�砭�� "-Unpublished-".
;
PHONENUMBER -Unpublished-
PHONENUMBER 7-095-???-????
; PHONENUMBER *
;
;   �஢�ઠ ���� "Location" (�� 255 ���祭��).
;
LOCATION * !@
; LOCATION Moscow
;
;   �� 20 ��p�������, ��p�������� ���祭�� ���� <system_name>.
;
SYSTEM * !@
; SYSTEM None
; SYSTEM * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;   �� 20 ��p�������, ��p�������� ���祭�� ���� <SysOp_name>.
;
SYSOP * !@
; SYSOP * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;   ��ॢ����� �� 䫠�� � ���孨� ॣ���� ��। �� ��ࠡ�⪮�
;
UPPERCASEFLAGS NO
;
;  ��p��� ����� ᥣ����, ��⠭��������� ���p�����p��.
;
SEGMENTFORMAT SEG~D~D~D~D~D.PNT
;
;-----------------------------------------------------------------------------
;  ����� ���� ����p����, � ���p� ��� ����室����� ������� �� ᫥���.
;-----------------------------------------------------------------------------
;
;   flag descriptions (30 strings as maximum)
;
;   special operating condition
;
flags   CM MO LO
;
;   modem capabilities supported
;
flags   V21 V22 V29 V32 V32B V34 V32T VFC V42 V42B MNP
flags   H96 HST H14 H16 MAX PEP CSP ZYX
flags   Z19 X2C X2S V90C V90S
;
;   type of compression mail
;
flags   MN
;
;   types of requests supported
;
flags   XA XB XC XP XR XW XX
;
;   gateways to other domains
;
flags   GUUCP
;
;   mail periods
;
flags   #01 #02 #08 #09 #18 #20
flags   !!01 !!02 !!08 !!09 !!18 !!20
;
;   FTS-5001 user flags
;
flags   UNC UZEC UREC UNEC USDS USMH
flags   UISDN UV110L UV110H UV120L UV120H UX75
;
;   user flags, authorized for Z2
;
flags   URPK UNPK
flags   UK12 UENC UCDP
;
;   IP flags
;
flags   IBN IBN:[0-9] IBN:[1-9][0-9] IBN:[1-9][0-9][0-9]
flags   IBN:[1-9][0-9][0-9][0-9] IBN:[1-9][0-9][0-9][0-9][0-9]
flags   IFC IFC:[0-9] IFC:[1-9][0-9] IFC:[1-9][0-9][0-9]
flags   IFC:[1-9][0-9][0-9][0-9] IFC:[1-9][0-9][0-9][0-9][0-9]
flags   IFT IFT:[0-9] IFT:[1-9][0-9] IFT:[1-9][0-9][0-9]
flags   IFT:[1-9][0-9][0-9][0-9] IFT:[1-9][0-9][0-9][0-9][0-9][0-9]
flags   ITN ITN:[0-9] ITN:[1-9][0-9] ITN:[1-9][0-9][0-9]
flags   ITN:[1-9][0-9][0-9][0-9] ITN:[1-9][0-9][0-9][0-9][0-9]
flags   IVM IVM:[0-9] IVM:[1-9][0-9] IVM:[1-9][0-9][0-9]
flags   IVM:[1-9][0-9][0-9][0-9] IVM:[1-9][0-9][0-9][0-9][0-9]
flags   IP
;
;       SMTP-based transport media: these flags describe additional
;   capabilities and are preliminary approved for Zone 2, but may still
;         be updated following ongoing discussions: (Apr.15, 1999)
;
flags   IMI ISE ITX IUC IEM IMI:* ISE:* ITX:* IUC:* IEM:* EVY:* EMA:*
;
;   working time
;
flags   UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
;
; ---------------------------------------------------------------------
;
;   implies for flags (30 strings as maximum)
;
implies V42B           = V42 MNP
implies V42            = MNP
implies V32T           = V32B V32
implies V32B           = V32
implies HST            = MNP
implies H14            = HST MNP
implies H16            = H14 HST MNP V42 V42B
implies ZYX            = V32B V32 V42B V42 MNP
implies Z19            = ZYX V32B V32 V42B V42 MNP
implies V90C           = V34
implies X2C            = V34
implies CM             = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
;   ���⨬�� �� ����p������ 䫠��� �p�����
implies UT[A-X][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[A-X][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
;
;-----------------------------------------------------------------------------
;
; End of file.
;