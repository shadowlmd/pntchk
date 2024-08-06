;== PNTCHK 1.00.rc6 ======== PNTCHK's main control file ===================
;
;    ���䨣�p�樮��� 䠩� PNTCHK ��pᨨ 1.00.rc6 (release candidate #6)
;    ��࠭�祭��: 16 ᨬ����� ���祢�� ᫮�� � 80 ᨬ����� ��� ���祭��
;
;============================= System section =============================
;
;       � �⮩ ᥪ樨 �������� �᭮��� ��ࠬ���� ��襩 ��⥬�
;
;--------------------------------------------------------------------------
;
;   ���� ��襩 ��⥬�. �ᯮ������ ��� FromAddress � ���쬠�-९����;
;   �ᯮ������ ⠪�� ����� ��� � ࠡ�� � ������⠬�
;
ADDRESS 2:5020/770.1
;
;   ���� � ��⬥��� (��� ९��⮢). �᫨ �� �����, � ⥪��� ��४���.
;
NETMAIL C:\MAIL\NETMAIL\
;
;   ���� ��� �p��� ᥣ���⮢
;
MASTER C:\PNTLIST\GOOD\
;
;   ���� ��� ���ﭭ�� ᥣ���⮢ (�. ��६����� KILLBAD)
;
BADFILES C:\PNTLIST\BAD\
;
;   �᫨ ������ BACKUPDIR, � ᥣ���� ��। ��� ��ࠡ�⪮� �㤥� ᪮��஢��
;   � ���; �᫨ ���������஢���, � ⠪�� ����஢���� �� �ந��������
;
BACKUPDIR C:\PNTLIST\BACKUP\
;
;   ��४��� �६����� 䠩���. �� 㬮�砭�� - ⥪���
;
TEMPDIR C:\TEMP\
;
;   ���� � ⥬����⠬
;
TEMPLATEPATH .\TEMPLATE
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
; LITE YES
;
;============================= Message settings ===========================
;
;        ����� �������� ��p����p� ���뫠���� 祪�p�� ��ᥬ-���⮢
;
;--------------------------------------------------------------------------
;
;   ��� �ணࠬ��, ����⠢�塞�� � ���� From: � ���쬠�-९����. �� 㬮�-
;   砭�� ࠢ�� ����� �ணࠬ��.
;   ���p��� �����ন������
;
; FROM Pavel I.Osipov
; FROM @owner
FROM @nameprog v@version
;
;   ���� To: ��ᥬ-p���p⮢. �� 㬮�砭�� 'SysOp'.
;
TO @FirstSysOpName @LastSysOpName
;
;   Subject ��ᥬ-९��⮢. �� 㬮�砭�� nameprog+' report'.
;   ���p��� �����ন������.
;
SUBJECT segment: @segname, @seglength bytes, dated @segdate
; SUBJECT �� ��뢠�� ����⫨��? ��।���-��।���-��।���...
;
;   "����� ��१�" ��ᥬ ९��⮢. �� 㬮�砭�� �����.
;
TEARLINE
; TEARLINE @newyear
; TEARLINE @nameprog, R: @owner (@serial)
;
;   �ਤ��� ��ᥬ-९��⮢. �᫨ ���������஢���, �� �⠢����.
;
; ORIGIN The best checker was here!
;
;   ��p����� ��ᥬ-p���p⮢:
;
;    PVT - privat
;    CRA - crash
;    RCV - received
;    SNT - sent
;    ATT - attach
;    TRS - transit
;    ORP - orphan
;    K/S - kill/sent
;    LOC - local
;    HLD - hold
;    FRQ - freq
;    RRQ - return receipt request
;    RRC - return receipt
;    ARQ - audit request
;    URQ - file update request
;
;   �� 㬮�砭�� PVT LOC
;
ATTRIBUTES PVT LOC
;
;   ���뫠�� �� � �� ��砥 ⮫쪮 ���� ���쬮-९���: � ��砥 ����祭��
;   ��襣� ᥣ���� - ���쬮 � ᮤ�ন�� �� NORMALTEMPLATE, � ��⨢���
;   ��砥 - ERRORTEMPLATE.
;   �᫨ NO, p���⠥� �������筮 MakeNL.
;
ONLYONEREPORT YES
;
;   ��⥢�� ����, �� ����� �㡫������� ᮮ�饭�� �� �訡���, � ⠪��
;   ��� �ᮯ� �⮣� 㧫� (�� 㬮�砭�� 'Coordinator').
;   �᫨ ���������஢���, � ⠪�� ᮮ�饭�� �� ���뫠����
;
; COORDINATOR 2:5020/770 Pavel I.Osipov
;
;============================ Nodelist section ============================
;
;            ����� ��p�������� ����p��� �� p���� � ������⮬
;
;--------------------------------------------------------------------------
;
;   ������㥬� �������
;
;   ��᪠ � ���७��: * - ��
;                       999 - ⮫쪮 ��ન ;)
;
;   H������ ������ � ����� ������� ��⮩ ᮧ�����
;
;   ! ������, �⮡� �p� ������� ������� � p���p����� .* � ��p���p��
;   ������⮢ �� ��室����� ���p娢�p�������� ������� � ⠪�� �� ������
;   � ����� ������� ��⮩ ᮧ�����
;
; NODELIST c:\mail\brake\nodelist\nodelist.999
; NODELIST z2-list.192
; NODELIST net5020.*
NODELIST net5020.ndl
;
;   ������� 䠩� �������, �� 㬮�砭�� <Nameprog>.IDX
;
;   Warning! ������, �⮡� ��� ������ �� ᮢ������ � ������ �������.
;
; NDLINDEX PNTCHECK.NDL
;
;   �������� 㧫�� � ����� ����ᮬ ���� ����祭� � ����⫨��
;
;      YES    - ������� ᥣ����� � ����⫨��
;      NO     - �� ������� ᥣ����� � ����⫨��, �뤠���� �訡��
;      NOSEND - ���砫��� ����뢠�� ᥣ����, ���� �� ���뫠��
;
ABSENTPOINTS NOSEND
NORMALPOINTS YES
DOWNPOINTS NOSEND
HOLDPOINTS NO
HUBPOINTS YES
PVTPOINTS YES
;
;================== General segment processing section ====================
;
;            ��騥 ����p����, �����騥 �p���� ��p���⪨ ᥣ���⮢
;
;--------------------------------------------------------------------------
;
;   ��᪠ ����� ��।�������� �ணࠬ�� ᥣ���� (10, �㬠�, �����筮
;   �� ����� ;).
;
;   <�� ᨬ���> - � ��, �� '?' � ���筮� ��᪥, �.�. �� ᨬ���
;                   (�p��p���� ������騥 ᨬ���� �� �������p��, �����
;                   <�� ᨬ���> ����� � �p��� ���⠢��� ��� 'A' ���
;                   '@', ��� '%', �� �㦭� ���� �����⥫�� � ��砥
;                   RENAMESEGMENT=YES: ��� ��p���� SEGMENTFORMAT �� ������
;                   ᮤ�p���� �������⨬�� ᨬ�����, ���� OS �뤠��
;                   �訡�� �p� ����⪥ ��p����������� ᥣ����)
;
;   ����� 㧫� ������ �� �������樨 ���:
;    ~D - �����筠� ��� (0..9)
;    ~H - ��⭠����筠� ��� (0..F)
;
;   �ਢ���� � "��ଠ�쭮��" ���� ᫥���騬 ��ࠧ��:
;
;    1 1
;    1 0 9 8 7 6 5 4 3 2 1
;    X X X X X X X X X X X
;
;    X1 + 10*X2 + 100*X3 + 1000*X4 + ... + 10000000*X8
;
;    ���⢥��⢥���, ��� ᥣ����, ���ਬ��, PAV33A78.TXT �� �����
;    ???~H~H~H~H~H.??? �㤥� ���ਭ�� ���  8*1 + 7*10 + 10*100 + 3*1000 +
;    + 3*10000 = 34078, �� ����� ???~D~D~D~D~D.??? �㤥� ����祭�
;    ᮮ�饭�� �� �訡��.
;
;    Warning! ����� ����� ᥣ���� ������ ᮮ⢥��⢮���� ����� �����.
;    ���� ���� ��.
;
SEGMENTFORMAT SEG~D~D~D~D~D.PNT
SEGMENTFORMAT MOPOINTS.~H~D~D ; �������H� � �� ᠬ��, �� ????????.~H~D~D
; SEGMENTFORMAT ~D~D~D~D~DPNT.TXT
;
;   ��२�����뢠�� �� ᥣ���� (�᫨ YES, ��२���㥬 � ���� �ଠ�)
;
RENAMESEGMENT NO
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ������� �� ���p������ ᥣ�����
;
;   �����⨬� ���祭��:
;
;   ALWAYS (YES) - 㡨���� ���娥 ᥣ����� �� ����祭�� � �� �㢨�� ��
;      � BADFILES, �� ����祭�� ��襣� ᥣ���� ����� BADFILES
;   IFGOOD - �� ����祭�� ��襣� ᥣ���� ����� BADFILES
;   NEVER (NO) - �㢨�� ���娥 ᥣ����� � BADFILES � �� ������ ��
;
KILLBAD IFGOOD
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   �����⨬� ���p��� ᥣ���� (� ����), �p� �p���襭�� ���p���
;   �㤥� �뤠������ �p���p������� �� AGEWRNTPL;
;   �� 㬮�砭�� �p���p�� �� ��������
;
SEGWRNAGE 365
;
;   �� ��, �� SEGWRNAGE, ⮫쪮 �뤠���� �訡�� � ᥣ���� �� ��p����뢠����
;
; SEGERRAGE 730
;
;   ��६����� ��।����, �������� �� ���� ��室��� ᥣ���⮢ ��
;   ⥪���� �� �� ����祭��.
;   ������ ��६����� ����� �� ����� �஢�ન ������ ᥣ���⮢
;   (��६���� SEGWRNAGE � SEGERRAGE), �������� ��।�����, �� ������
;   ������ �����뢠�� ������ ᥣ����.
;
; TOUCHSEGMENTS YES
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
;============= String-by-string segment processing section ================
;
;            H���p���� �p� ����p������ ��p���⪥ ᥣ���⮢
;
;--------------------------------------------------------------------------
;
;   �������, �����⨬� � ����⫨�⮢�� ��p���� (�� 㬮�砭�� [!-])
;
; ADMISSIBLECHARS [!-] [�-�] � � [������] [�-�]
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
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   �����⨬�� ���祭�� ���� "prefix" (�� 㬮�砭�� "Point")
;
; PREFIX Point
; PREFIX @ ; ����� ��ப�
;
;   �����⨬� ���祭�� ���� "᪮���� ������" (�� 㬮�砭�� 300, 1200, 2400,
;   9600)
;
BAUD 300 1200 2400 9600
;
;   �᫨ �� ����-����� �㦭�, � ����� � �஢���� ���� "Location"
;   �� 255 ���祭��.
;
LOCATION * !@
; LOCATION Moscow
;
;   �����⨬� ���祭�� ���� "Phone" (�� 20). �� 㬮�砭�� "-Unpublished-".
;
PHONENUMBER -Unpublished-
PHONENUMBER 7-095-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]
;
;   �� 20 ��p�������, ��p�������� ���祭�� ���� <SysOp_name>.
;
SYSOP * !@
; SYSOP * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;   �� 20 ��p�������, ��p�������� ���祭�� ���� <system_name>.
;
SYSTEM * !@
; SYSTEM * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   �����⨬� 䫠�� (���ᨬ� 30 ��ப)
;
;   Special operating conditions
;
flags		CM MO LO
;
;   Modem capabilities supported
;
flags           V22 V29 V32 V32B V34 V42 V42B MNP H96 HST H14 H16
flags           MAX PEP CSP V32T VFC ZYX V90C V90S X2C X2S Z19
;
;   Type(s) of compression of mail packets supported
;
flags           MN
;
;   Types of file/update requests supported
;
flags		XA XB XC XP XR XW XX
;
;   Gateways to other domains (mail networks)
;
flags		GUUCP
;
;   Dedicated mail periods supported
;
flags		#01 #02 #08 #09 #18 #20
flags		!!01 !!02 !!08 !!09 !!18 !!20
;
;   IP Flags
;
flags		IBN IBN:[0-9] IBN:[1-9][0-9] IBN:[1-9][0-9][0-9]
flags		IBN:[1-9][0-9][0-9][0-9] IBN:[1-9][0-9][0-9][0-9][0-9]
flags		IFC IFC:[0-9] IFC:[1-9][0-9] IFC:[1-9][0-9][0-9]
flags		IFC:[1-9][0-9][0-9][0-9] IFC:[1-9][0-9][0-9][0-9][0-9]
flags		IFT IFT:[0-9] IFT:[1-9][0-9] IFT:[1-9][0-9][0-9]
flags		IFT:[1-9][0-9][0-9][0-9] IFT:[1-9][0-9][0-9][0-9][0-9][0-9]
flags		ITN ITN:[0-9] ITN:[1-9][0-9] ITN:[1-9][0-9][0-9]
flags		ITN:[1-9][0-9][0-9][0-9] ITN:[1-9][0-9][0-9][0-9][0-9]
flags		IVM IVM:[0-9] IVM:[1-9][0-9] IVM:[1-9][0-9][0-9]
flags		IVM:[1-9][0-9][0-9][0-9] IVM:[1-9][0-9][0-9][0-9][0-9]
flags		IP
;
;   SMTP-based transport media
;
flags		IMI ISE ITX IUC IEM IMI:* ISE:* ITX:* IUC:* IEM:*
;
;   E-mail-based transport media (rev. 26/6/1999)
;
flags		EVY EMA EVY:* EMA:*
;
;   ISDN nodelist flags as per FTS-5001
;
flags		V110L V110H V120L V120H X75 ISDN
;
;   Zone 2 authorised 'user' flags:
;
;    NetMail Coordination
;
flags		UNC
;
;    EchoMail Coordination
;
flags		UREC UNEC
;
;    Pointlists
;
flags		URPK UNPK
;
;    Special flags
;
flags		UK12 UENC UCDP USDS USMH
;
;    System open hours
;
flags		UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   �宦����� 䫠��� (30 ��ப ���ᨬ�)
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
implies V90S           = V34
implies X2C            = V34
implies X2S            = V34
implies CM             = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies ISDN           = V110L V110H V120L V120H X75
;
;   ���⨬�� �� ����p������ 䫠��� �p�����
;
implies UT[A-X][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[A-X][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ��ॢ����� �� 䫠�� � ���孨� ॣ���� ��। �� ��ࠡ�⪮�
;
UPPERCASEFLAGS NO
;
;==================== Errors autocorrection section =======================
;
;    H���p���� �⮩ ᥪ樨 ����� ���⠢��� (let) PNTCHK �� ⮫쪮 �p���p���
;    ᥣ����� �� ����稥 �訡��, �� � ᠬ����⥫쭮 ��p������ ��
;
;--------------------------------------------------------------------------
;
;   ������� �� ����� ��p��� �� ᥣ����, ��p����뢠� ��� �p� �⮬
;   �᫨ YES, � ����� ��p��� �㤥� 㤠����, �㤥� �뤠�� �p���p�������, ��
;   ᥣ���� �㤥� ��p���⠭ ��p���쭮;
;   �᫨ NO, � �㤥� �뤠�� ᮮ�饭�� �� �訡�� � ᥣ���� ��p���⠭ �� �㤥�
;
;   ! �᫨ REMOVEEMPTYLINES=NO, ��ࠢ�� ᮮ⢥�����騬 ��ࠧ�� EMPTYLINETPL
;
REMOVEEMPTYLINES YES
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
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   �������� ��p�p����� p����� 祪�p� � ��砥 ����p㦥��� �訡�� � ����
;   "Baud_rate". �᫨ CHANGEBAUD=YES, � �訡�筮� ���祭�� ���� "Baud_rate"
;   �㤥� �������� �� ��p��� ���祭�� ��p������� BAUD, �㤥� �뤠�� ����
;   �p���p�������, �訡�� �� �㤥� (BAUDERRORTPL ������ ᮮ⢥��⢮����
;   ⥬����� baudwrn.tpl);
;   �p� CHANGEBAUD=NO �뤠���� �訡�� � ᥣ���� ���p����뢠����
;   (BAUDERRORTPL=bauderr.tpl)
;
CHANGEBAUD NO
;
;   �������筮 CHANGEBAUD
;
CHANGELOCATION NO
;
;   CHANGESYSOP �������� ��p�p����� p����� 祪�p� �p�
;   ����p㦥��� ����pp��⭮�� ���祭�� ���� SYSOP. �����
;   �������筠 CHANGESYSTEM
;
;   ! ��ࠢ�� ᮮ⢥�����騬 ��ࠧ�� SYSOPERRTPL
;
CHANGESYSOP NO
; CHANGESYSOP WARN
; CHANGESYSOP YES
;
;   CHANGESYSTEM �������� ��p�p����� p����� 祪�p� �p� ����p㦥-
;   ��� ����pp��⭮�� ���祭�� ���� SYSTEM. �p� ��������� ���祭��:
;     NO -   �뤠���� �訡�� � ���p����뢠�� ᥣ����;
;     WARN - �뤠���� �p���p�������, �� ᥣ���� ��p����뢠�� (�� 㬮�砭��);
;     YES -  �������� ����pp��⭮� ���祭�� �� ��p��� ���祭�� ��p�������
;            SYSTEM, ��p����뢠�� ᥣ����, �뤠��� �p���p�������.
;
;   ! ��ࠢ�� ᮮ⢥�����騬 ��ࠧ�� SYSTEMERRTPL
;
CHANGESYSTEM NO
; CHANGESYSTEM WARN
; CHANGESYSTEM YES
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
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ������� �� �����४�� 䫠�� (���祭�� YES) ����� �뤠� ᮮ�饭�� ��
;   �訡�� (���祭�� NO) � ��砥 �� ����p㦥���.
;   �����४�� 䫠� ��⠥��� � ��砥:
;       �) 䫠� �������⥭ (�� ��।���� ��६���묨 FLAGS � ���䨣�);
;       �) 䫠� ����砥��� ����� ������ ࠧ� � ��ப�;
;       �) 䫠� ���� �室�騬 � ���� �� ��㣨� 䫠��� � ��ப� (��६����
;   IMPLIES)
;
;   Warning! �᫨ �⠢�� ���祭�� YES, �� ������ �������� FLAGERRTPL,
;   IMPLERRTPL � DUPFLGERRTPL �� flagwrn.tpl, implwrn.tpl � dupflwrn.tpl
;   ᮮ⢥��⢥���
;
REMOVEBADFLAGS NO
;
;   �����⨬� �� ��p��� ��� ������� 䫠�� (�᫨ YES, � ��ப� ������
;   �����稢����� "<baud_rate>,"); �᫨ ADD, 䫠� �㤥� �������� �
;   ᮮ⢥��⢨� � ��⠭������ �� 㬮�砭�� � �� ADDEDFLAGS
;
;   ! �᫨ NOFLAG=NO/ADD, ��ࠢ�� ᮮ⢥�����騬 ��ࠧ�� NOFLAGERRTPL
;
NOFLAG YES
; NOFLAG ADD
; NOFLAG NO
;
;   �����, ������塞� �p� NOFLAG=ADD ��� �p� �모�뢠��� ��� 䫠���,
;   ����� REMOVEBADFLAGS=YES
;
ADDEDFLAGS MO V22 V22 V32
;
;===================== External processors section ========================
;
;            ����� ��p��������� ����p���� ���譨� ��p����稪��
;
;--------------------------------------------------------------------------
;
;   ������ �p��p����, ���p�� ���� ��뢠���� ��। ��p���⪮� ᥣ����.
;   ���⠪�� �p���: EXECBEFORE <��p��������� ���������� �p����p� ��p���>
;   �p��� ��p����p�� ���譥� �⨫��� ����� ������:
;   %S - ��� ��p����뢠����� ᥣ���� (� ��⥬).
;   �⮡� ��p����� ᠬ� ᫮�� "%S", �㦭� ���⠢��� ��p�� ���� �� ����
;   ᨬ��� "%" (%%S)
;
; EXECBEFORE exec.bat %s Hey mister DJ!
;
;   ������ �p��p����, ���p�� ���� ��뢠���� ��᫥ ��p���⪨ ᥣ����, ��
;   �� ���뫪� ���� � ��p���ᥭ�� ᥣ���� � ��p���p�� MASTER.
;   ���⠪��: EXECGOOD <��p��������� ���������� �p����p� ��p���>
;   �p��� ��p����p�� ���譥� �⨫��� ����� ������:
;   %S - ��� ��p����뢠����� ᥣ���� (� ��⥬),
;   %O - ��� ��p��� ᥣ���� (�㤥� �p�������� ���� � MASTER � ��p��
;   ᥣ����, 㤮���⢮p��騩 ���ᠭ�� SEGMENTFORMAT �㤥� ��p���� ���譥�
;   �p��p����; �᫨ �� ������ ᥣ���� �� �㤥� �������, �p��� �㤥�
;   ��p����� ᠬ� ᫮�� "%O").
;   �⮡� ��p����� ᠬ� ᫮�� "%S" � "%O", �㦭� ���⠢��� ��p�� ���� ��
;   ���� ᨬ��� "%" (%%S ��� %%O)
;
; EXECGOOD utility\execgood.exe %s %o report.txt ; for DOS and OS/2
; EXECGOOD pntdiff.cmd %s %o report.txt          ; OS/2 only
;
;   �� �� ᠬ��, ⮫쪮 ��� ���宣� ᥣ����
;
; EXECBAD utility\execbad.exe %s %o report.txt   ; for DOS and OS/2
;
;   ���� � ��� 䫠��, ���p� �㤥� ᮧ�������� � ��砥 ����祭�� � ��p���⪨
;   ��pp��⭮�� ᥣ����. ���� ᮧ������ �p��� ��᫥ �믮������ ����p�樨
;   EXECGOOD
;
; TOUCHGOOD C:\MAIL\FLAGS\goodseg.flg
;
;   �������筮 ��� ����pp��⭮�� ᥣ����
;
; TOUCHBAD C:\MAIL\FLAGS\badseg.flg
;
;===================== Pointlist creation section =========================
;
;         H���p���� ᮡ�p���� ����⫨�� (���� "-L" ��������� ��p���)
;
;--------------------------------------------------------------------------
;
;   ��� ����⫨��. �᫨ ��� ������ ��� p���p����, � ����⢥ ��᫥�����
;   �㤥� ��⮬���᪨ �������� ����p ��� � ���� ᡮp�� ����⫨��
;
POINTLIST pnt5020
; POINTLIST pnt5020.ndl
;
;   ��⠢�塞�� � ����⫨�� ��� ��� ��室�. ����� �� ���p��� @date, @month,
;   @year, @weekday, � ⠪�� @daynumber.
;   �������� ���祭��:
;       TODAY - ��� ᡮp��
;       FRIDAY - ��� ������襩 ��⭨��
;
PNTLDATE FRIDAY
; PNTLDATE TODAY
;
;   ���祭�� ��� ���p�� @pntlcrc, ���p�� ���᫥��⢨� �㤥� ��������
;   p���쭮� CRC ����⫨��, �� 㬮�砭�� - 00000
;
; FAKECRCSTR 00000
;
;   ���ᨬ���� ����p 㧫� � �� (��⠭���������� ��� �᪮p����
;   ���᪠ ᥣ���⮢ � ᡮp�� ����⫨��), �� 㬮�砭�� 32767
;
; MAXNUMBER 1000
;
;   �⥯��� ���஡���� �஢�ન ᥣ���⮢ �� ᮧ����� ����⫨��.
;
;       FULL   - ������ �஢�ઠ (��� ࠭��),
;       MEDIUM - �஢�ઠ ⮫쪮 �� ������⢨� � ������� � �� ������
;                ᥣ����
;       QUICK  - �஢�ઠ ⮫쪮 �� ������⢨� � ������� 㧫�
;
CREATIONCHECK MEDIUM
; CREATIONCHECK QUICK
; CREATIONCHECK FULL
;
;   ������ �p��p����, ��뢠���� ��᫥ ᡮન ����⫨��.
;   ���⠪��: EXECPNTLST <��p��������� ���������� �p����p� ��p���>
;   ���⠪�� �������祭 EXECGOOD/EXECBAD, �������� ��ࠬ���� -
;   %P - ��� ᮡ࠭���� ����⫨��
;   %D - day-of-year ᮡ࠭���� ����⫨��
;
; EXECPNTLST exec.bat %p %d
;
;======================= Main templates section ===========================
;
;                 �᭮��� 蠡���� ��� ��ᥬ-���⮢
;
;--------------------------------------------------------------------------
;
;   �������� ��ᥬ-९��⮢
;
NORMALTEMPLATE normal.tpl
;
;   ��������-蠯�� ��ᥬ-p���p⮢ �� �訡���
;
ERRORTEMPLATE error.tpl
;
;   �������� �訡�� � ��p����
;
STRERRTPL strerror.tpl
;
;    �᭮���� ⥬����� ��� ��ᥬ �� ����p㦥��� �訡�� � ᥣ�����
;    �p� ᡮp�� ����⫨�� (������ ERRORTEMPLATE)
;
PNTLSTERRTPL Pntlst.Tpl
;
;======================= Error templates section ==========================
;
;                  ������� ��� ��ᥬ-���⮢ �� �訡���
;
;--------------------------------------------------------------------------
;
;   �������� �訡�� � ������⮬
;
NDLERRTPL ndlerror.tpl
;
;   �������� �訡�� � ��p��� 'Boss,*'
;
NMBRERRTPL nmbrerr.tpl
;
;   �᫨ ��� ��� ����� ����⮢ ����� ��������� ��p��
;
EQNUMERRTPL equalnum.tpl
;
;   ��������� �訡�� � �।�०����� � �ॢ�襭�� �����⨬��� ������
;   ᥣ����
;
AGEERRTPL Ageerr.tpl
AGEWRNTPL Agewrn.tpl
;
;   �������� �।�०����� �� �����㦥��� ���⮩ ��ப� � ᥣ����
;
EMPTYLINETPL emplnwrn.tpl
; EMPTYLINETPL emplnerr.tpl
;
;   �������� ᮮ�饭�� �� �����㦥��� unix-style ��ப� ᥣ����
;
UNIXLINETPL unixlnwn.tpl
; UNIXLINETPL unixlner.tpl
;
;   �������� �訡�� � �������p���
;
CMNTERRTPL cmntwrn.tpl
; CMNTERRTPL cmntwrn2.tpl
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   �������� �訡�� �� �����㦥��� �������⨬��� ᨬ����
;
INADMCHARERRTPL inacherr.tpl
;
;   �訡�� � ��䨪� (�����ন������ ⮫쪮 ��䨪� "Point", ��
;   ��⠫쭮� - �訡��)
;
PREFERRTPL preferr.tpl
;
;   �訡�� � ����p� ����� ( <>[1..32767] )
;
PONUMERRTPL numpoerr.tpl
;
;   �������� �訡�� � ᪮��� ������
;
BAUDERRTPL bauderr.tpl
; BAUDERRTPL baudwrn.tpl
;
;   �訡�� � ���� 'Phone'
;
PHONEERRTPL phoneerr.tpl
; PHONEERRTPL phonewrn.tpl
;
; ��������
;
LOCATERRTPL locaterr.tpl
; LOCATERRTPL locatwrn.tpl
;
;   �������� �訡�� � ���� <system_name>
;
SYSTEMERRTPL systerr.tpl
; SYSTEMERRTPL systwrn.tpl
; SYSTEMERRTPL systwrn2.tpl
;
;   �������� �訡�� � ���� <SysOp_name>
;
SYSOPERRTPL sysoperr.tpl
; SYSOPERRTPL sysopwrn.tpl
; SYSOPERRTPL sysopwr2.tpl
;
;   �������� �訡��, �᫨ ��� �� ������ 䫠�� ("9600 ��� ��䨣�")
;
NOFLAGERRTPL noflgerr.tpl
; NOFLAGERRTPL noflger2.tpl ; ��� NOFLAG=NO
; NOFLAGERRTPL noflgwrn.tpl ; ��� NOFLAG=ADD
;
;   H�������� 䫠�
;
FLAGERRTPL flagerr.tpl
; FLAGERRTPL flagwrn.tpl ; ��� REMOVEBADFLAGS=YES
;
;   �宦����� 䫠���
;
IMPLERRTPL implerr.tpl
; IMPLERRTPL implwrn.tpl ; ��� REMOVEBADFLAGS=YES
;
;   �㡫�p��騥�� 䫠��
;
DUPFLGERRTPL dupflerr.tpl
; DUPFLGERRTPL dupflwrn.tpl ; ��� REMOVEBADFLAGS=YES
;
;================ Pointlist creation templates section ====================
;
;       ������� ��� ��ᥬ-���⮢, �ᯮ��㥬� �p� ᮧ����� ����⫨��
;
;--------------------------------------------------------------------------
;
;   ��������, ���p� �㤥� ��⠢������ ��p�� �ᥬ ���⮬
;
PNTLSTHEADER Lsthead.Tpl
;
;   ��������, ���p� �㤥� ��⠢������ ��᫥ ����
;
PNTLSTFOOTER Lstfoot.Tpl
;
;    ��������, ��⠢�塞� ��p�� ����� ᥣ���⮬
;
PNTSEGHEADER Seghead.Tpl
;
;    ��������, ��⠢�塞� ��᫥ ������� ᥣ����
;
PNTSEGFOOTER Segfoot.Tpl
;
;================= Definitions of user macros in templates ================
;
;       ����� ����p��� ���������� � ��p������ � 䠩���-⥬������
;
;--------------------------------------------------------------------------
;
;   ��p�������� p�� ���祢� ᫮��-��६���� (�� 10-�), �ᯮ��㥬�
;   � 䠩���-⥬������.
;   ���⠪��:  ASSIGN @<name> [@]<value>
;   ���祭�� (value) ����� ������ �� ��᪮�쪨� ᫮�.
;   �᫥ <value> ��稭����� � ᨬ���� '@', � ��� ������ ��� 䠩��,
;   ᮤ�ন��� ���ண� �㤥� ��⠢���� ����� <name>.
;
; ASSIGN @HELLO Hello everybody!
; ASSIGN @NEWYEAR Happy new year! ; :-)
ASSIGN @NOTE @NOTE.TPL
ASSIGN @FOOTER @FOOTER.TPL
; ASSIGN @REPORT @report.txt ; ��� EXEC*
;
;============================ End of pntchk.ctl ===========================