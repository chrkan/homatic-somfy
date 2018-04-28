# homatic-somfy
Somfy Rollos mit Homematic steuern

Vorweg: 
Ich beschreibe hier die Einzelnen wenigen Schritte eins zu eins, trotzdem kaue ich hier nicht alles vor. Grundlagen und selber Einlesen in die Thematik ist das A und O :roll: 

Vorbereitung:
Für die Steuerung der Rollos ohne einen Aktor wird neben CUXD ab der Version Version 0.68 ein culfw ab der Firmware 1.61 benötigt. Wie das Upadate durchgeführt wird steht im CUXD Handbuch im Kapitel 9 DFU Firmwareupdate über den CUx-Daemon
Bitte auch beachten das ich von dem original Busware ausgehe und nicht von günstigeren nachbauten!
Des Weiteren brauchen wir einen FTP Zugang zur CCU und SSH zugriff.

Inbetriebnahme:
1. Im CUXD legen wir das Gerät 40 -> Control: Jalousie an, welches nach dem Anlegen im CCU Posteingang zu finden ist und nach euren Wünschen angepasst werden muss.
CUXD40.png




2. Jetzt brauchen wir für jeden Rollo den wir steuern wollen eine Systemvariable des Types Zahl, dieser Name muss einmalig im System sein! Weder ein Gerät noch ein Kanal darf diesen Namen schon haben! 
Minimalwert: 0
Maximalwert: 9999999999

In meinem Fall nenne ich die Variable Somfy (Info ich wollte meinen Variable wie folgt nennen WohnGrFSomfy dies mochte das Tool nicht, WohnGrF geht.

3. wir legen nun das Script von rodi22 auf die CCU per FTP in das Verzeichnis eurer Wahl.
In der Anleitung gehe ich von dem Ort: /usr/local/addons/rollo/somfy.tcl aus

Das Script ist gegenüber dem Original von mir auf die neuen Gegebenheiten angepasst.
Als FTP Client nehme ich FileZilla welcher auch das für die CCU2 benötigte SFTP Protokoll unterstützt.






4. Nach dem Upload gebe ich dem File noch die vollen Rechte 777.

5. In den Geräteeinstellungen des CUXD Aktor Jalousie müssen nun die Steuerbefehle für das Script eingetragen werden.
BLIND|CMD_EXEC Harken setzen.

BLIND|CMD_SHORT + BLIND|CMD_LONG: tclsh /usr/local/addons/rollo/somfy.tcl $CHANNEL$ Somfy $VALUE$ A0 A00000
BLIND|CMD_STOP: tclsh /usr/local/addons/rollo/somfy.tcl $CHANNEL$ Somfy STOP A0 A00000

Pfad zum Script sowie Script Name 
Hier muss die Seriennummer des CUXD Jalousie Aktor eingetragen werden, mit der Variable $CHANNEL$ beschied dies Automatisch. Zum Anlernen bitte amber den Geräte Namen aufschreiben 
Die Systemvariable aus dem Schritt 2. 
Eine hochzählende HEX Zahl, Erster Rollo A00000, zweiter A00001 usw. Diese dürft Ihr vorher noch NIE beim Rumspielen genutzt haben!!!

Alles andere bleibt so wie es ist.

Anlernen des Aktors am ROLLO, dafür müsst Ihr euren Rollo in den Anlernmodus versetzen, dies ist je nach Rollo ein wenig unterschiedlich (Handbuch nutzen)
Zusätzlich müssen wir jetzt per Telnet (CCU1) oder Ssh (CCU2) auf die CCU dafür unter Windows putty nehmen am MAC reicht das Terminal bestens aus. Es ist hiermit nicht das CUXD Terminal gemeint!!

Als Befehl geben wir nach dem der Rollo Meldet er ist im Anlernmodus folgendes in die Konsole:

tclsh /usr/local/addons/rollo/somfy.tcl CUX4000001:1 Somfy PROG A0 A00000 

Edit: 12.06.2016 Es ist umbedingt wichtig einen bestehenden Kanal in unserem fall z.b. den CUX4000001:1 mit anzugeben sonst geht das anlernen nich!!!
Edit 11.12.2017 In der Konsole sollte jetzt folgendes zurück gemeldet werden:
CODE: ALLES AUSWÄHLEN
"YsA0802DB2AA0000"
dom.GetObject("CUxD.CUX4000001:1.SEND_CMD").State("YsA0802DB2AA0000");
1

Die Letzte zahl ist der in der Systemvariable gleich

Nun sollte der Rollo eine Rückmeldung der erfolgreichen Anlernen des CULF melden.

Fertig
Über unseren CUXD Jalousien Aktor ist der Rollo nun steuerbar, leider zur Zeit nur Offen, 50% oder MY Position sowie Geschlossen.
Persönlich brauche ich nicht mehr, wenn einer eine Lösung für genaue Einteilung der Schritte hat her damit!

DANKE an Uwe für die Änderung am 40 und rodi22 für die Script Idee.

Bitte keine PN zu diesem Thema, Fragen bitte in diesem Thread!!

Edit 11.05.2017
=========================== Fehler Meldungen ===========================
Edit 18.04.2018:
Bei einem Fehler bitte genau beschreiben was passiert!
Welcher Motor?
Welche CUX Version? Welche Version auf dem CUL ? Cuxd Status Monitor {CUX} CUL868 [COMM] - /dev/ttyACM1 {:1617s} - V 1.61 CUL868 (CUL_V3)
Was passiert mit der Systemvariable, zählt diese hoch?
Was spukt das script aus wenn wenn es per Konsole aufgerufen wird? Wie sieht der Aufruf aus?


CODE: ALLES AUSWÄHLEN
syntax error in expression "int(null)"
    while executing
"expr int($remote_counter)"
    invoked from within
"set remote_counter [ expr int($remote_counter)]"
    (file "/usr/local/addons/rollo/somfy.tcl" line 21)


Systemvariable Existiert nicht oder ist falsch
Edit 31.12.2017 oder es ist bereit ein Gerät mit dem gleichen Namen der Systemvariable angelegt!



Edit 30.12.2017: Anlernen, Verweis das nicht das CUXD Terminal genutzt werden soll!


=========================== Getestete Motoren ===========================
Edit 14.12.2014: Zur Zeit steuere ich damit 3x Sonesse 30 RTS und 1x Altus 40
