# PNTCHK, v1.00+ (release)
## Professional pointsegment checker
Copyright (c) 1997,2004 Pavel I.Osipov (2:5020/770@fidonet)<br>Manual translation (c) 2002-2004 Pavel I.Osipov, Sergey Tsvetkov, Slava Belkov, Alexei Klimenko, Katerina Znamenskaya<br>All rights reserved

The process of work of network pointlist coordinators (pointlist keepers) constantly requires performing of validity check on incoming pointlist segments. Unfortunately, to err is humanum, so the segments often contain errors, not corresponding the requirements of the technical standards. The amount of coordinator's work is rather big, so it wouldn't be bad to automatize the processing of pointlist segments.
PNTCHK was designed to help pointlist coordinators in their work.
"PNTCHK" is an abbreviation of Professional pointsegment checker. Why professional? Because it can perform many tasks, surpassing analogous software.

Moreover, the program can be used not only to check the incoming segments, but also for compilation of the whole pointlist. The advantage of combination of such two tasks in one program is in the fact, that the segments can be checked not only at the moment of their arrival, but also when they are included into the pointlist, even if the requirements have been changed since the segment came.

This are the main features of the software:

PNTCHK ...
* does all the checks performed by ordinary checkers: baud rate, phone number, flags;
* has nodelist processing routine: checks for presence of the bossnode and its status in the nodelist; this feature is very flexible: for every possible nodelist status of bossnodes (hub, normal, pvt, hold, down) you can define, whether to process their segments  or not;
* checks for inadmissible characters present in the pointsegment lines (the range of admissible chars can be defined in the config file; by default as inadmissible are treated the chars with ASCII-codes less than #33 and greather than #127);
* checks for segment lines having equal point number;
* finds strings without any flag, having no comma at the end;
* checks correspondence of the name of the segment with the "Boss,\*"-string, and also the correctness of the "Boss,\*"-string itself;
* checks for presence of CR/LF chars at the end of each segment string;
* subject to adjustments removes superfluous comment lines from the segment (superfluous comments from the header and, if you want, from the body of the segment);
* subject to adjustments can not only check the segments, but also correct them, automaticaly correcting (deleting) invalid flags, baud rate, phone number fields etc;
* creates message reports in \*.MSG-format and addresses them to the sender of the segment and (possibly) to the pointlist coordinator;
* performs many other tasks.

PNTCHK can easily be installed on you system. Versions of PNTCHK for different OS (PNTCHK v.1.00+ is available for DOS16, DOS32, OS/2, WIN32, Linux and FreeBSD) are completely identical in their call and output, use the same format of the nodelist index, logfile, so they can be used at the same time.
