;== PNTCHK 1.00.rc6 ======== PNTCHK's main control file ===================
;
;   PNTCHK version 1.00.rc6 (release candidate #6) configuration file
;
;   Translation (c) 2000-2004 by Pavel I.Osipov. Send any corrections/com-
;   ments to forsite@f770.n5020.z2.fidonet.org or forsite@spamtest.ru please
;
;   Restrictions: 16 characters per each variable and 80 characters
;                 per its value
;
;============================= System section =============================
;
;       In this section the main parameters of your system are defined
;
;--------------------------------------------------------------------------
;
;   The address of your system. Used as FromAddress in the report messages.
;   Host-part of this address is also used in the working with nodelists
;
ADDRESS 2:5020/770.1
;
;   Path to the netmail area, current directory as default
;
NETMAIL C:\MAIL\NETMAIL\
;
;   Path where correct segments will be placed
;
MASTER C:\PNTLIST\GOOD\
;
;   Path where incorrect segments will be placed (see KILLBAD variable)
;
BADFILES C:\PNTLIST\BAD\
;
;   If BACKUPDIR is defined, the segment before being processed, will be
;   copied to this directory (for reasons of emergency); if commented out,
;   no copies will be made
;
BACKUPDIR C:\PNTLIST\BACKUP\
;
;   Directory for temporary files, current as default
;
TEMPDIR C:\TEMP\
;
;   Path to the template files
;
TEMPLATEPATH .\TEMPLATE
;
;   Logfile name
;
LOGFILE pntchk.log
;
;   Logmessage tags not to put into logfile
;
LOGLEVEL .
;
;   If 'YES' then the logfile will be closed after every writing (just the
;   same like it is done in T-Mail when LogBuffer=0). Is useful in unstable
;   functioning of the system in order to prevent loosing log information.
;   Disadvantage of enabling this function is in a little bit slower work
;   with the logfile and bigger number of hard-disk operations.
;
SHARINGMODE NO
;
;   Variable switches on so called lite-mode of PNTCHK, which serves
;   the local check of the pointlist segment before sending it to the
;   coordinator.
;
; LITE YES
;
;============================= Message settings ===========================
;
;       Here parameters of the report messages of PNTCHK are defined
;
;--------------------------------------------------------------------------
;
;   FromName in the report messages. Default value is program name.
;   All macros are supported (see bellow)
;
; FROM Pavel I.Osipov
; FROM @owner
FROM @nameprog v@version
;
;   To: field of the report messages. Default value is 'SysOp'
;
TO @FirstSysOpName @LastSysOpName
;
;   Subject: field of the report messages. Default value is equal to
;   nameprog+' report'.
;   Macros are supported
;
SUBJECT segment: @segname, @seglength bytes, dated @segdate
; SUBJECT It's a respond from the pointsegment checker
;
;   Tearline of the report messages, empty as default
;
TEARLINE
; TEARLINE @newyear
; TEARLINE @nameprog, R: @owner (@serial)
;
;   The origin of the report messages. If commented out, no origin will
;   be added
;
; ORIGIN The best checker was here!
;
;   Attributes of the report messages:
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
;   As default PVT LOC
;
ATTRIBUTES PVT LOC
;
;   In any case send only one report: using NORMALTEMPLATE if the segment
;   is correct and using ERRORTEMPLATE in contrary case.
;   If NO, PNTCHK will work similar to MakeNL.
;
ONLYONEREPORT YES
;
;   The address and the name (default 'Coordinator) of coordinator. All the
;   error reports will be copied to this address.
;   If commented, no error report copy will be sent
;
; COORDINATOR 2:5020/770 Pavel I.Osipov
;
;============================ Nodelist section ============================
;
;              Definitions of the nodelist processing routine
;
;--------------------------------------------------------------------------
;
;   Nodelist file to be scanned
;
;   Wildcard in the extension: * - any extension
;                              999 - only number digits
;
;   When more than one nodelist meets wildcard requirements, nodelist
;   with the last date of creation will be taken
;
;   ! Take care of not placing a compressed nodelist file (eg. nodelist.zip)
;   into the NODELIST directory, if you are using .* wildcard.
;
; NODELIST c:\mail\brake\nodelist\nodelist.999
; NODELIST z2-list.192
; NODELIST net5020.*
NODELIST net5020.ndl
;
;   Index file of the nodelist, <Nameprog>.IDX as default
;
;   Warning! The name of the index MUSTN'T be the same to nodelist name.
;
; NDLINDEX PNTCHECK.NDL
;
;   Segments of nodes having which status will be included in the pointlist
;
;      YES    - include segments into pointlist
;      NO     - reject the segment, send error report
;      NOSEND - silently reject the segment, send no report
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
;           General definitions of the segments processing routine
;
;--------------------------------------------------------------------------
;
;   Mask of the name of the segment to be processed by the program (up to 10)
;
;   <any char> - the same as '?' in DOS-wildcard, i.e. any char
;                (PNTCHK doesn't analyze unimportant symbols; instead of
;                <any char> you can put for instance 'A' or '@', as well as
;                '%' - result will be the same.
;                You need to take care only in case of RENAMESEGMENT=YES:
;                the name of the first SEGMENTFORMAT variable mustn't
;                contain inadmissible chars, otherwise OS will fall when
;                renaming the segment)
;
;   The node number will be got from combination of digits:
;    ~D - a decimal digit (0..9)
;    ~H - a hex digit (0..F)
;
;   Calculate the number:
;
;    1 1
;    1 0 9 8 7 6 5 4 3 2 1
;    X X X X X X X X X X X
;
;    X1 + 10*X2 + 100*X3 + 1000*X4 + ... + 10000000*X8
;
;    Example. The segment name PAV33A78.TXT under the SEGMENTFORMAT
;    +++~H~H~H~H~H.+++ will be calculated as 8*1 + 7*10 + 10*100 + 3*1000 +
;    + 3*10000 = 34078, under SEGMENTFORMAT +++~D~D~D~D~D.+++ you will get
;    an error.
;
;    Warning! The length of the segment name and the length of SEGMENTFORMAT
;    must be equal (combinations such as '~D' and '~H' are deemed as one
;    char), otherwise you will get an unpredictable result
;
SEGMENTFORMAT SEG~D~D~D~D~D.PNT
SEGMENTFORMAT MOPOINTS.~H~D~D ; ABSOLUTELY the same as ????????.~H~D~D
; SEGMENTFORMAT ~D~D~D~D~DPNT.TXT
;
;   Should PNTCHK rename the segment (if YES, rename to the first
;   SEGMENTFORMAT)
;
RENAMESEGMENT NO
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This variable defines wheter incorrect segments will be killed or not
;
;   Available values:
;
;   ALWAYS (YES) - kill incorrect segments after receiveing of them,
;      after receiveing of a correct segment delete old incorrect segments
;      from this node in BADFILES
;   IFGOOD - after receiveing of a correct segment delete old incorrect
;      segments from this node in BADFILES
;   NEVER (NO) - move incorrect segments into BADFILES, never delete them
;
KILLBAD IFGOOD
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Admissible age of the segment (in days), excess of which causes sending
;   of warnings by PNTCHK (text is read from the file defined by AGEWRNTPL);
;   as default no check is being made
;
SEGWRNAGE 365
;
;   The same as SEGWRNAGE, but the segment will be deemed bad and
;   not processed
;
; SEGERRAGE 730
;
;   Variable determines, whether to change the date of incomming
;   segments to the current on receiving of them.
;   This variable influences to the process of the check for valid age
;   of the segments (variables SEGWRNAGE и SEGERRAGE), setting the moment
;   since which the age of the segments should be calculated.
;
; TOUCHSEGMENTS YES
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Maximum number of comment lines in the segment (5 as default)
;
COMMENTCOUNT 5
;
;   This variable determines whether the comment lines are admitable
;   between ordinary point segment strings or not
;   (if YES, edit CMNTERRTPL accordingly)
;
BETWEENCOMMENTS NO
;
;============= String-by-string segment processing section ================
;
;             Settings when processing pointsegment strings
;
;--------------------------------------------------------------------------
;
;   Chars admissible in point strings ([!-] as default)
;
; ADMISSIBLECHARS [!-] [А-п] р с [туфхцч] [ш-я]
;
;   This variable switches on the check on the comment lines for
;   inadmissible characters (as inadmissible in the comment lines are
;   treated so called "control characters" - the chars with the codes
;   below #32).
;
CHECKCOMMENTS YES
;
;   The variable switches on the compatibility mode with the popular
;   diff-processor Nodelife, prohibiting comment lines, containing
;   the character string ";`", which is inproperly processed by this
;   diff-processor.
;
NODELIFECOMPAT YES
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Addmissible value of the "prefix" field ("Point" default)
;
; PREFIX Point
; PREFIX @ ; empty prefix
;
;   Admissible values of the "modem baud" field (300, 1200, 2400, 9600 as
;   default)
;
BAUD 300 1200 2400 9600
;
;   PNTCHK can also check the content of "Location" field.
;   Up to 255 variables
;
LOCATION * !@
; LOCATION Moscow
;
;   Admissible values (up to 20) of "Phone number" field of a pointsegment
;   string. "-Unpublished-" is default value.
;
PHONENUMBER -Unpublished-
PHONENUMBER 7-095-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]
;
;   Up to 20 variables, defining values of <SysOp_name> field
;
SYSOP * !@
; SYSOP * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;   Up to 20 variables, defining the value of "system_name" field.
;
SYSTEM * !@
; SYSTEM * ![Nn][Oo]_[Nn][Aa][Mm][Ee] !*[Ff][Uu][Cc][Kk]* !*FUCK*
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Admissible flags (up to 30 variables)
;
;   Special operating condition
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
;   Implies for flags (up to 30 strings)
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
;   Avoiding of time flags duplication
;
implies UT[A-X][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[A-X][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][A-X]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
implies UT[a-x][a-x]   = UT[A-X][A-X] UT[A-X][a-x] UT[a-x][A-X] UT[a-x][a-x]
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Should the flags be uppercased before being processed
;
UPPERCASEFLAGS NO
;
;==================== Errors autocorrection section =======================
;
;       The settings of this sections let PNTCHK not only check the
;       segments but also automaticaly correct them
;
;--------------------------------------------------------------------------
;
;   This variable determines wheter PNTCHK should remove empty lines from
;   the segment or not. In case of YES, an empty line will be removed, the
;   sender will be warned, but the segment will be processed.
;   In case of NO, this situation will be considered as an error and
;   the segment will not be processed.
;
;   ! Если REMOVEEMPTYLINES=NO, edit EMPTYLINETPL accordingly
;
REMOVEEMPTYLINES YES
;
;   Variable READUNIXLINES defines the reaction of PNTCHK to the strings
;   of unix-style (not ended by cr/lf):
;   NO - as in the past, the standart ReadLn of Pascal language (in the
;        DOS/OS2-versions the strings ended by lf won't be recognised,
;        FPC-versions recognise this kind of strings automaticaly)
;   SILENT - silently process this kind of strings, as they truely were ended
;        by cr/lf (in the FPC-versions this is identical to READUNIXLINES=NO)
;   WARNING - process this kind of strings, but report a warning (the
;        file template UNIXLINETPL)
;   ERROR - report an error (the file template UNIXLINETPL), reject the
;        segment
;
READUNIXLINES WARNING
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This variable determines the reaction of the PNTCHK to incorrect
;   values in the "Baud rate" field. If CHANGEBAUD is set to YES, incorrect
;   value will be replaced by the first value of the BAUD variable.
;   That case will not be deemed as an error, so only a warning will be sent
;   to SysOp (do not forget to change the value of the BAUDEERRORTPL
;   variable to "baudwrn.tpl" or anything else where the content of the
;   further warning message is stored);
;   if CHANGEBAUD is set to NO, an error will be sent to SysOp and the
;   segment will not be processed (BAUDEERRORTPL needs to be changed
;   to "baudeerr.tpl")
;
CHANGEBAUD NO
;
;   See description of CHANGEBAUD
;
CHANGELOCATION NO
;
;   CHANGESYSOP determines the reaction of PNTCHK to incorrect value
;   of SYSOP field. Mechanism is similar to CHANGESYSTEM
;
;   ! Do not forget to change SYSOPERRTPL accordingly
;
CHANGESYSOP NO
; CHANGESYSOP WARN
; CHANGESYSOP YES
;
;   CHANGESYSTEM determines the behavior of PNTCHK when it finds
;   incorrect content of SYSTEM field. Three possible values:
;     NO   - treat the situation as an error and < забpаковывать сегмент >;
;     WARN - send a warning but process the segment  (default behavior);
;     YES  - replace incorrect content of SYSTEM field by the value of
;            the first SYSTEM variable in pntchk.ctl, process the segment
;            sending a warning
;
;   ! Do not forget to change SYSTEMERRTPL accordingly
;
CHANGESYSTEM NO
; CHANGESYSTEM WARN
; CHANGESYSTEM YES
;
;   This variable determines the reaction of the PNTCHK to incorrect
;   values in "Phone number" field. If CHANGEPHONE is set to YES, incorrect
;   value will be replaced by the value of the first of the PHONENUMBER
;   variables.
;   That case will not be seemed as an error, so only a warning will be sent
;   to SysOp (do not forget to change the value of the PHONEERRORTPL
;   variable to "phonewrn.tpl" or anything else where the content of the
;   further warning message is stored);
;   if CHANGEPHONE is set to NO, an error will be sent to SysOp and the
;   segment will not be processed (PHONEERRORTPL needs to be changed
;   to "phoneerr.tpl")
;
CHANGEPHONE NO
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Should incorrect flags be deleted (value YES) instead of sending an
;   error report (value NO) when finding them.
;   As incorrect a flag will be treated in the following cases:
;       а) the flag is unknown (not defined by FLAGS variables in cfg);
;       б) the flag is present more than once in a string;
;       в) the flag is implied by one of the others flags in the string (cfg
;   variables IMPLIES)
;
;   Warning! If you define YES, do not forget to change FLAGERRTPL,
;   IMPLERRTPL and DUPFLGERRTPL to flagwrn.tpl, implwrn.tpl and dupflwrn.tpl
;   accordingly
;
REMOVEBADFLAGS NO
;
;   The variable determines wheter point strings without any flags are
;   treated as correct or not (if YES, the string must be ended with
;   "<baud_rate>,"); if ADD, one flag will be automaticaly added according
;   to default settings or value of ADDEDFLAGS
;
;   ! If NOFLAG=NO/ADD, change NOFLAGERRTPL accordingly
;
NOFLAG YES
; NOFLAG ADD
; NOFLAG NO
;
;   Flags that will be added (1) when NOFLAG=ADD or (2) when all flags in
;   the point string are incorrect and REMOVEBADFLAGS=YES
;
ADDEDFLAGS MO V22 V22 V32
;
;===================== External processors section ========================
;
;                    Settings for external utilities
;
;--------------------------------------------------------------------------
;
;   External program executed before processing of the segment.
;   The syntax: EXECBEFORE <string of parameters sent to command processor>
;   Among the parameters of the external utility you can place:
;   %S - the name of the segment being processed (with path included).
;   To sent the combination "%S" itself, put extra "%" character before
;   it (%%S).
;
; EXECBEFORE exec.bat %s Hey mister DJ!
;
;   External program that will be executed after processing of segment, but
;   before sending a report and moving the segment to the MASTER directory.
;   The syntax: EXECGOOD <string of parameters sent to command processor>
;   Among the parameters of the external utility you can place:
;   %S - the name of the segment being processed (path is included),
;   %O - the name of the old segment in base (a search will be made in the
;   MASTER directory and the name of first segment that will meet the
;   definitions of of SEGMENTFORMAT will be sent to the external utility;
;   if no segment is found, the word "%O" itself will be sent).
;   To sent the combinations "%S" and "%O" themself, you should put extra
;   "%" character before them (%%S or %%O)
;
; EXECGOOD utility\execgood.exe %s %o report.txt ; for DOS and OS/2
; EXECGOOD pntdiff.cmd %s %o report.txt          ; OS/2 only
;
;   The same, but for an incorrect segment
;
; EXECBAD utility\execbad.exe %s %o report.txt   ; for DOS and OS/2
;
;   The path and the name of the flag that will be created after receiving
;   and processing of a correct segment. The flag is created just after
;   executing of the instruction EXECGOOD
;
; TOUCHGOOD C:\MAIL\FLAGS\goodseg.flg
;
;   The same, but for an incorrect segment
;
; TOUCHBAD C:\MAIL\FLAGS\badseg.flg
;
;===================== Pointlist creation section =========================
;
;          The settings for the pointlist compilation routine
;          (the "-L" switch of command line)
;
;--------------------------------------------------------------------------
;
;   The name of pointlist to be created. If extension is omitted, the
;   day-of-year of publication date will be automatically added as
;   the extension
;
POINTLIST pnt5020
; POINTLIST pnt5020.ndl
;
;   Date of publication. Affects macros @date, @month, @year, @weekday,
;   as well as @daynumber.
;   Possible values:
;       TODAY - date of creation
;       FRIDAY - Friday publication date
;
PNTLDATE FRIDAY
; PNTLDATE TODAY
;
;   The original value of macro @pntlcrc that will be replaced by the real
;   CRC of pointlist after its calculation. Default value - 00000
;
; FAKECRCSTR 00000
;
;   Maximum node number in the network (set for increasing the speed
;   of search of segments and pointlist compilation), 32767 as default
;
; MAXNUMBER 1000
;
;   How to check the segments during the creation of the pointlist.
;
;       FULL   - full check (as in previous versions),
;       MEDIUM - check of being present in the nodelist and of the age of
                 the segment
;       QUICK  - check of the presence in the nodelist
;
CREATIONCHECK MEDIUM
; CREATIONCHECK QUICK
; CREATIONCHECK FULL
;
;   External program executed after creation of the pointlist.
;   The syntax: EXECPNTLST <string of parameters sent to command processor>
;   Among the parameters of the external utility you can place:
;   %P - the name of the pointlist created
;   %D - day-of-year of the pointlist created
;   To sent the combinations "%P" and "%D" themself, put extra "%" character
;   before them (%%P or %%D)
;
; EXECPNTLST exec.bat %p %d
;
;======================= Main templates section ===========================
;
;                 General templates for report messages
;
;--------------------------------------------------------------------------
;
;   File template for reports
;
NORMALTEMPLATE normal.tpl
;
;   Template header for error reports
;
ERRORTEMPLATE error.tpl
;
;   General file template for errors in point segment strings
;
STRERRTPL strerror.tpl
;
;    The main template for errors during the pointlist compilation
;    (analog of ERRORTEMPLATE)
;
PNTLSTERRTPL Pntlst.Tpl
;
;======================= Error templates section ==========================
;
;                  Templates for error report messages
;
;--------------------------------------------------------------------------
;
;   File template for errors ragarding to the nodelist.
;
NDLERRTPL ndlerror.tpl
;
;   File template for errors in the point string 'Boss,*'
;
NMBRERRTPL nmbrerr.tpl
;
;   File template for error in case two points have an equal address
;
EQNUMERRTPL equalnum.tpl
;
;   The templates for the error and the warning about the exceeding
;   of maximum admissible age of the segment (for SEGWRNAGE and SEGERRAGE)
;
AGEERRTPL Ageerr.tpl
AGEWRNTPL Agewrn.tpl
;
;   The template for the error when an empty line is found in the segment
;   (for REMOVEEMPTYLINES)
;
EMPTYLINETPL emplnwrn.tpl
; EMPTYLINETPL emplnerr.tpl
;
;   File template when an unix-style string is found
;
UNIXLINETPL unixlnwn.tpl
; UNIXLINETPL unixlner.tpl
;
;   File template for errors in comment lines
;
CMNTERRTPL cmntwrn.tpl
; CMNTERRTPL cmntwrn2.tpl
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Template when an inadmissible char was found in the pointsegment string
;
INADMCHARERRTPL inacherr.tpl
;
;   File template for errors in point line prefix (by now only prefix "Point"
;   is supported, anything else is considered as an error)
;
PREFERRTPL preferr.tpl
;
;   File template for incorrect point numbers ( <>[1..32767] )
;
PONUMERRTPL numpoerr.tpl
;
;   File template for errors in "Baud rate" field
;
BAUDERRTPL bauderr.tpl
; BAUDERRTPL baudwrn.tpl
;
;   File template for errors in "Phone number" field
;
PHONEERRTPL phoneerr.tpl
; PHONEERRTPL phonewrn.tpl
;
;   File template for errors in "Location" field
;
LOCATERRTPL locaterr.tpl
; LOCATERRTPL locatwrn.tpl
;
;   File template for errors in the "System name" field
;
SYSTEMERRTPL systerr.tpl
; SYSTEMERRTPL systwrn.tpl
; SYSTEMERRTPL systwrn2.tpl
;
;   File template for errors in the "SysOp name" field
;
SYSOPERRTPL sysoperr.tpl
; SYSOPERRTPL sysopwrn.tpl
; SYSOPERRTPL sysopwr2.tpl
;
;   File template for the error when no flag is present in pointsegment line
;
NOFLAGERRTPL noflgerr.tpl
; NOFLAGERRTPL noflger2.tpl ; for NOFLAG=NO
; NOFLAGERRTPL noflgwrn.tpl ; for NOFLAG=ADD
;
;   Unknown flag found
;
FLAGERRTPL flagerr.tpl
; FLAGERRTPL flagwrn.tpl ; for REMOVEBADFLAGS=YES
;
;   Implied flag found
;
IMPLERRTPL implerr.tpl
; IMPLERRTPL implwrn.tpl ; for REMOVEBADFLAGS=YES
;
;   Duplicated flag found
;
DUPFLGERRTPL dupflerr.tpl
; DUPFLGERRTPL dupflwrn.tpl ; for REMOVEBADFLAGS=YES
;
;================ Pointlist creation templates section ====================
;
;        The file templates used by pointlist compilation routine
;
;--------------------------------------------------------------------------
;
;   File template inserted before the whole pointlist
;
PNTLSTHEADER Lsthead.Tpl
;
;   File template inserted after the whole pointlist
;
PNTLSTFOOTER Lstfoot.Tpl
;
;   File template inserted before each segment
;
PNTSEGHEADER Seghead.Tpl
;
;   File template inserted after each segment
;
PNTSEGFOOTER Segfoot.Tpl
;
;================= Definitions of user macros in templates ================
;
;            User defined additions to macros in file templates
;
;--------------------------------------------------------------------------
;
;   User definable macros (up to 10) used in templates.
;   Synopsys: ASSIGN @<name> [@]<value>
;   "Value" may consist of several words.
;   Beginning with char '@' value defines the filename, the content of
;   which will be inserted into the report instead of <name>.
;
; ASSIGN @HELLO Hello everybody!
; ASSIGN @NEWYEAR Happy new year! ; :-)
ASSIGN @NOTE @NOTE.TPL
ASSIGN @FOOTER @FOOTER.TPL
; ASSIGN @REPORT @report.txt ; for EXEC*
;
;=========================== End of pntchk-e.ctl ==========================