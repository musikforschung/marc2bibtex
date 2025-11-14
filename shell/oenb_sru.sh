#!/bin/bash -e
#Shell-Skript für die Transformation von MARC-Daten der ÖNB nach BibTeX für RILM
# bash ./shell/oenb_sru.sh
Date=${DateOENB}
echo ${Date}

# Abfrage des aktuellen RILM-Stempels "JJJJQQ"
read -p "Bitte den aktuellen Stempel der abzuholenden ÖNB-Daten in der Form 'JJJJQQ' eingeben: " Date
while [[ ! "$Date" =~ ^202[4-9]0[1-4]$ ]] ; do
    echo "Ungültige Eingabe. Der Stempel besteht aus der Jahres- und der Quartalsangabe in der Form JJJJQQ."
    read -p "Bitte den aktuellen Stempel der abzuholenden ÖNB-Daten eingeben: " Date
done && echo "Stempel erfolgreich eingegeben
Transformation gestartet."

# Weitergabe des aktuellen Stempels in die entsprechenden Fixes per $Date
sed -i "s/alma.local_field_980=RILM[0-9]\+/alma.local_field_980=RILM\l$Date/g" ./fix/sru_sort_request.fix
#sed -i "s/IMOENB\: [0-9]\+/IMOENB\:\l $Date/g" ./fix/marc2pica_oenb.fix &&
## $Date auch noch in den Fix zur SRU-Abfrage der PPNs der bereits vorhandenen HAs übergeben

#Abrufen der Identifier der Hauptaufnahmen aller mit dem RILM-Stempel gekennzeichneten Datensätze
catmandu convert SRU --base https://obv-at-oenb.alma.exlibrisgroup.com/view/sru/43ACC_ONB --recordSchema marcxml --parser marcxml --query alma.local_field_980=RILM$Date to CSV --fix ./fix/sru_request.fix --fields ac_number > ./dictionary/oenb.csv

# sortiert die Einträge und entfernt Dubletten
grep -P '\d{5,}' ./dictionary/oenb.csv | sort | uniq > ./dictionary/oenb_sort.csv
#fügt den Spaltennamen "ac_number" ein
sed -i '1s/^/ac_number\n/' ./dictionary/oenb_sort.csv

# Abruf der vollständigen Aufsätze und ihrer Hauptaufnahmen
catmandu convert -v CSV to Null --fix ./fix/sru_sort_request.fix < ./dictionary/oenb_sort.csv
# Zusammenführung der Daten
cat ./data/oenb_coll.mrk ./data/oenb_ha.mrk > ./data/oenb.mrk
 
echo "MARC-Daten wurden erfolgreich abgeholt und sortiert.
Datei ./data/oenb.mrk öffnen und prüfen.
Gegebenenfalls fehlende Formschlagwörter in den Hauptaufnahmen vergeben:
Konferenzschrift: \"=655  \$0(DE-588)1071861417\"
Festschrift: \"=655  \$0(DE-588)4016928-5\"
Aufsatzsammlung: \"=655  \$0(DE-588)4143413-4\"
Hochschulschrift: \"=655  \$0(DE-588)4113937-9\"
Gegebenenfalls vor den Titelzusätzen in Feld 245 \"\$b\" einfügen.
Danach Datei speichern und schließen"

read -p "Bitte mit \"y\" bestätigen, wenn die Datei ./data/oenb.mrk geschlossen ist und die Transformation fortgeführt werden kann. " Bestaetigung
while [[ ! "$Bestaetigung" == y ]]; do
  echo "Warte auf Bestätigung"
  read -p "Bitte mit \"y\" bestätigen, wenn die Datei ./data/oenb.mrk geschlossen ist und die Transformation fortgeführt werden kann. " Bestaetigung
done && echo "Transformation der Daten nach BibTeX wird ausgeführt."

# Entfernen alter Fehlermeldungen
if [ -f fehlermeldung.csv ]; then
   rm fehlermeldung.csv
fi

# Liste von ACNummer und type der Hauptaufnahme erstellen
catmandu convert MARC --type MARCMaker to CSV --fix ./fix/type.fix --fields ACNumber,type < ./data/oenb.mrk > ./dictionary/type.csv
# Liste von ACNummer und Ländercode der Hauptaufnahmen erstellen
catmandu convert MARC --type MARCMaker to CSV --fix ./fix/countrycode.fix < ./data/oenb.mrk > ./dictionary/countrycodelist.csv
# Liste von ACNummer und Volume der Hauptaufnahmen erstellen
catmandu convert MARC --type MARCMaker to CSV --fix ./fix/volume.fix --fields ACNumber,volume < ./data/oenb.mrk > ./dictionary/volume.csv

# Transformation der OENB-Daten von MARC nach BibTeX
catmandu -I /home_ext/PK/siwallor/lib convert -v MARC --type MARCMaker to BibTeX --fix ./fix/marc2bibtex.fix --fix ./fix/replace.fix < ./data/oenb.mrk >> ../bms/dmpbms_2025-09-01.btx

# Prüfung der BibTeX-Daten und Ausgabe einer Fehlerdatei
catmandu convert BibTeX to CSV --fields Type,Country,Note,Pages,Number,Volume,Year,Abstract,Abstractor,Series,Crossref,Ausschluss,PPN --fix ./fix/fehlermeldung.fix < oenb_rilm.btx > fehlermeldung.csv

if [ -f fehlermeldung.csv ]; then
   echo "Bitte die Datei fehlermeldung.csv prüfen!!!"
else
   echo "Transformation abgeschlossen.
Die ÖNB-Daten im Format Bibtex für RILM befinden sich in der Datei \"oenb_rilm.btx\"." 
fi

# Export-Statistik für OENB-BibTeX-Daten 
echo "Statistik der transformierten Daten:"
catmandu convert BibTeX to Stat --fix ./fix/stat.fix --fields Aufsätze_Monografien,Rezensionen,Abstracts < oenb_rilm.btx 2>/dev/null | tee ./statistics/rilm_export_statistik_${Date}.csv 

