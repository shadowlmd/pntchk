;
;   Professional pointsegment checker v1.00.rc6 (lite) configuration file
;
;-----------------------------------------------------------------------------
;   ������ ����������� ����p��� ����p�
;-----------------------------------------------------------------------------
;
;   ��p�� ����� �������. ���p�����, ���� ����p ������ ����� ����������
;   �� 2:5020/ (�� ���������)
;
; ADDRESS 2:5020/770
;
;   ��� ��������
;
LOGFILE pntchk.log
;
;   ���� ���������, ������� �� ����� ���������� � ���
;
LOGLEVEL .
;
;   ���� 'YES', �� ��� ����� ����������� ����� ������ ����������� �������, ���
;   ��� ������� � T-Mail ��� LogBuffer=0. ������� ��� ��� ����, ����� �� ������
;   ��������� ����������� ���� � ������ ����. ������ ��� ��������� ���������
;   ������ ��������� � ����� ������� ���� ����-����. ;)
;
SHARINGMODE NO
;
;   ���������� �������� �.�. "�����������" (LITE) ����� ������ ������,
;   ������� ������ ��� ��������� �������� ������������� ����� ���
;   �������� ������������.
;
LITE YES
;
;-----------------------------------------------------------------------------
;   ������ ����p���, ����������� ����p� �������������� ���p������ ���� ������
;-----------------------------------------------------------------------------
;
;   ������� �� ������ ��p��� �� ��������, ��p�������� ��� �p� ����
;   ���� YES, �� ������ ��p��� ����� �������, ����� ������ �p����p�������, ��
;   ������� ����� ��p������ ��p������;
;   ���� NO, �� ����� ������ ��������� �� ������
;
REMOVEEMPTYLINES NO
; REMOVEEMPTYLINES YES
;
;   ���������� READUNIXLINES ���������� ��������� ������ ��� �����������
;   unix-style ����� (�� �������������� �� cr/lf):
;   NO - ��� ��� ������, �������� ����������� ������������ readln (�
;        DOS/OS2-������ ������ �� lf ������������� �� �����, FPC-������
;        ��� ������ ����� ������������ �������������)
;   SILENT - ����� ������������ ������, ��� ����� ��� ������������� �� CR/LF
;        (� FPC-������� ���������� READUNIXLINES=NO)
;   WARNING - ������������ ������, �� �������� warning (�������� UNIXLINETPL)
;   ERROR - �������� ������ (�������� UNIXLINETPL), ������������� �������
;
READUNIXLINES WARNING
;
;   ��������� ��p��p����� p����� ����p� � ������ ����p������ ������ � ����
;   "Phone". ���� CHANGEPHONE=YES, �� ��������� �������� ���� "Phone" �����
;   �������� �� ��p��� �������� ��p������� PHONENUMBER, ����� ������ ����
;   �p����p�������, ������ �� ����� (PHONEERRORTPL ������ ���������������
;   �������� phonewrn.tpl);
;   �p� CHANGEPHONE=NO �������� ������ � ������� ���p�����������
;   (PHONEERRORTPL=phoneerr.tpl)
;
CHANGEPHONE NO
; CHANGEPHONE YES
;
;   ���������� CHANGEPHONE
;
CHANGELOCATION NO
; CHANGELOCATION YES
;
;   ������ �������� � CHANGEPHONE
;
CHANGEBAUD NO
; CHANGEBAUD YES
;
;   �� �� �����
;
CHANGESYSTEM NO
; CHANGESYSTEM YES
;
;   ����������
;
CHANGESYSOP NO
; CHANGESYSOP YES
;
;   ��������� �� ��p��� ��� ������� ����� (���� YES, �� ������ ������
;   ������������� "<baud_rate>,"); ���� ADD, ���� ����� �������� �
;   ������������ � ����������� �� ��������� � �� ADDEDFLAGS
;
NOFLAG YES
; NOFLAG ADD
; NOFLAG NO
;
;   ������� �� ������������ ����� (�������� YES) ������ ������ ��������� ��
;   ������ (�������� NO) � ������ �� ����p������.
;   ������������ ���� ��������� � ������:
;       �) ���� ���������� (�� ��������� ����������� FLAGS � �������);
;       �) ���� ����������� ����� ������ ���� � ������;
;       �) ���� �������� �������� � ���� �� ������ ������ � ������ (����������
;   IMPLIES)
;
REMOVEBADFLAGS NO
; REMOVEBADFLAGS YES
;
;   �����, ����������� �p� NOFLAG=ADD ��� �p� ����������� ���� ������,
;   ����� REMOVEBADFLAGS=YES
;
; ADDEDFLAGS V21 V22 V22B V32
;
;-----------------------------------------------------------------------------
;   ��� ��p����p� ������ ���������� ���p������p��.
;-----------------------------------------------------------------------------
;
;   �������, ���������� � ������������� ��p���� (�� ��������� [!-])
;
; ADMISSIBLECHARS [!-] [�-�] � � [������] [�-�]
;
;   ����� ����� � ������������� � �������� (�� ��������� 5)
;
COMMENTCOUNT 5
;
;   ��������� �� ��������p�� ����� ��p�������� �������������� ��p�����
;   (���� YES, ���p����� CMNTERRTPL ��������������� ��p����)
;
BETWEENCOMMENTS NO
;
;   ���������� ��������� �������� ����� �������� ������������ ��
;   ���������� ������� (������������� � ������������ ��������� �.�.
;   "����������� �������" - ������� � ������ ������ 32).
;
CHECKCOMMENTS YES
;
;   ���������� �������� ����� ������������� � ����������
;   ����-����������� Nodelife, �������� ������ ������������ �������������,
;   ���������� ������������������ �������� ";`", ������� �����������
;   ������ ����-����������� ��������������.
;
NODELIFECOMPAT YES
;
;   ���������� �������� ���� "prefix" (�� ��������� "Point")
;
; PREFIX Point
; PREFIX @ ; ������ ������
;
;   ���������� �������� ���� "�������� ������" (�� ��������� 300, 1200, 2400,
;   9600)
;
; BAUD 300 1200 2400 9600 14400
;
;   ���������� �������� ���� "Phone" (�� 20). �� ��������� "-Unpublished-".
;
PHONENUMBER -Unpublished-
PHONENUMBER 7-095-???-????
; PHONENUMBER *
;
;   �������� ���� "Location" (�� 255 ��������).
;
LOCATION * !@
; LOCATION Moscow
;
;   �� 20 ��p�������, ��p��������� �������� ���� <system_name>.
;
SYSTEM * !@
; SYSTEM None
; SYSTEM * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;   �� 20 ��p�������, ��p��������� �������� ���� <SysOp_name>.
;
SYSOP * !@
; SYSOP * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;   ���������� �� ����� � ������� ������� ����� �� ����������
;
UPPERCASEFLAGS NO
;
;  ��p��� ����� ��������, ��������������� ���p������p��.
;
SEGMENTFORMAT SEG~D~D~D~D~D.PNT
;
;-----------------------------------------------------------------------------
;  ����� ���� ����p����, � ����p�� ��� ������������� ������� �� �������.
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
;   ��������� �� �����p������� ������ �p�����
implies UT[A-X][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[A-X][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
;
;-----------------------------------------------------------------------------
;
; End of file.
;