#!/bin/bash -e


green="`tput setaf 2`"
red="`tput setaf 1`"
sgr0="`tput sgr0`"
cyan="`tput setaf 6`"

# Git-Synchronisation (https://github.com/musikforschung)
REPOS=(
"$HOME/rilm/marc2bibtex/"
"$HOME/lib/Catmandu/Exporter/"
)

echo "Prüfe auf Aktualisierungen..."

for repo_path in "${REPOS[@]}"; do
   if [ ! -d "$repo_path" ]; then
      echo "Fehler: Verzeichnis nicht gefunden: $repo_path!"
	     continue
   fi

   cd "$repo_path" || { echo  "Fehler: Konnte nicht in $repo_path wechseln!"; continue; }
   git fetch &> /dev/null
   if [ $? -ne 0 ]; then
      echo "Fehler beim Abrufen der Remote_Daten."
      continue
   fi
   STATUS=$(git status)
   if [[ $STATUS =~ "Ihr Branch ist auf demselben Stand wie" ]]; then
      echo "$repo_path ist aktuell"
   elif [[ $STATUS =~ "git pull" ]]; then
      echo "Aktualisierungen für $repo_path gefunden"
      git config pull.rebase false && git pull &> /dev/null
      echo "$repo_path wurde aktualisiert"
   else
      echo "Bitte Aktualisierungen prüfen."
      echo "$STATUS"
   fi
done
echo "------------------------------------------------------"
echo "Synchronisierung abgeschlossen.
"

##Abruf und Transformation der OENB-Daten
## Abfrage des aktuellen Quartalsstempels "JJJJQQ"
read -p "${cyan}			Bitte den aktuellen Quartalsstempel in der Form JJJJQQ eingeben: ${sgr0}" DateOENB
while [[ ! "$DateOENB" =~ ^20[23][0-9]0[1234]$ ]] ; do
  echo "${red}Ungültige Eingabe. Der Stempel besteht aus einer Jahres- und Quartalsangabe in der Form JJJJQQ. Erlaubte Werte für QQ = 01, 02, 03, 04.${sgr0}"
  read -p "${cyan}			Bitte den aktuellen Quartalsstempel eingeben: ${sgr0}" DateOENB
done
echo "
Transformation der ÖNB-Daten nach BibTeX gestartet."

cd $HOME/rilm/marc2bibtex/

# Weitergabe des aktuellen Stempels in die entsprechenden Fixes per $Date
sed -i "s/alma.local_field_980=RILMJJJJQQ/alma.local_field_980=RILM\l$DateOENB/g" $HOME/rilm/marc2bibtex/fix/sru_sort_request.fix &&

#Abrufen der Identifier der Hauptaufnahmen aller mit dem RILM-Stempel gekennzeichneten Datensätze
catmandu convert SRU --base https://obv-at-oenb.alma.exlibrisgroup.com/view/sru/43ACC_ONB --recordSchema marcxml --parser marcxml --query alma.local_field_980=RILM${DateOENB} to CSV --fix $HOME/rilm/marc2bibtex/fix/sru_request.fix --fields ac_number > $HOME/rilm/marc2bibtex/data/oenb.csv &&

# sortiert die Einträge und entfernt Dubletten
grep -P '\d{5,}' $HOME/rilm/marc2bibtex/data/oenb.csv | sort | uniq > $HOME/rilm/marc2bibtex/data/oenb_sort.csv &&
#fügt den Spaltennamen "ac_number" ein
sed -i '1s/^/ac_number\n/' $HOME/rilm/marc2bibtex/data/oenb_sort.csv &&

# Abruf der vollständigen Aufsätze und ihrer Hauptaufnahmen
catmandu convert CSV to Null --fix $HOME/rilm/marc2bibtex/fix/sru_sort_request.fix < $HOME/rilm/marc2bibtex/data/oenb_sort.csv &&
# Zusammenführung der Daten
cat $HOME/rilm/marc2bibtex/data/oenb_coll.mrk $HOME/rilm/marc2bibtex/data/oenb_ha.mrk > $HOME/rilm/marc2bibtex/oenb_${DateOENB}.mrk &&

# BibTeX-Datei auf eventuell fehlende Formschlagwörter (Festschrift/Konferenzschrift) prüfen
catmandu convert MARC --type MARCMaker to CSV --fields Konferenzschrift,Festschrift,Dissertation,Titelzusatz,ID --fix $HOME/rilm/marc2bibtex/fix/formschlagwort_oenb.fix < $HOME/rilm/marc2bibtex/oenb_${DateOENB}.mrk > $HOME/rilm/marc2bibtex/formschlagwort_oenb.csv &&

if [ -f $HOME/rilm/marc2bibtex/formschlagwort_oenb.csv ]; then
   echo "
			${cyan}Bitte die Datei ${green}formschlagwort_oenb.csv${cyan} prüfen und in der Datei ${green}oenb_${DateOENB}.mrk${cyan} bei Bedarf Formschlagwörter in den Hauptaufnahmen ergänzen.
			Gegebenenfalls vor den Titelzusätzen in Feld 245 \"\$b\" einfügen.
			Danach Datei speichern und schließen.${sgr0}"
fi

read -p "${cyan}			Mit \"${green}y${cyan}\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: ${sgr0}" Bestaetigung
while [[ ! "$Bestaetigung" == y ]]; do
  echo "${red}Warte auf Bestätigung${sgr0}"
  read -p "${cyan}			Bitte mit \"${green}y${cyan}\" bestätigen, wenn die Datei oenb_${DateOENB}.mrk geschlossen ist und die Transformation fortgeführt werden kann: ${sgr0}" Bestaetigung
done 

echo "Transformation der ÖNB-Daten nach BibTeX wird fortgesetzt." 

# Lösche formschlagwort_oenb.csv
if [ -f $HOME/rilm/marc2bibtex/formschlagwort_oenb.csv ]; then
   rm $HOME/rilm/marc2bibtex/formschlagwort_oenb.csv
fi &&

# Liste von ACNummer und type der Hauptaufnahme erstellen
catmandu convert MARC --type MARCMaker to CSV --fix $HOME/rilm/marc2bibtex/fix/type.fix --fields ACNumber,type < $HOME/rilm/marc2bibtex/oenb_${DateOENB}.mrk > $HOME/rilm/marc2bibtex/data/type.csv &&
# Liste von ACNummer und Ländercode der Hauptaufnahmen erstellen
catmandu convert MARC --type MARCMaker to CSV --fix $HOME/rilm/marc2bibtex/fix/countrycode.fix < $HOME/rilm/marc2bibtex/oenb_${DateOENB}.mrk > $HOME/rilm/marc2bibtex/data/countrycodelist.csv &&
# Liste von ACNummer und Volume der Hauptaufnahmen erstellen
catmandu convert MARC --type MARCMaker to CSV --fix $HOME/rilm/marc2bibtex/fix/volume.fix --fields ACNumber,volume < $HOME/rilm/marc2bibtex/oenb_${DateOENB}.mrk > $HOME/rilm/marc2bibtex/data/volume.csv &&

# Transformation der OENB-Daten von MARC nach BibTeX
catmandu -I $HOME/lib convert MARC --type MARCMaker to BibTeX --fix $HOME/rilm/marc2bibtex/fix/marc2bibtex.fix --fix $HOME/rilm/marc2bibtex/fix/replace.fix < $HOME/rilm/marc2bibtex/oenb_${DateOENB}.mrk > $HOME/rilm/marc2bibtex/dmpbms_${DateOENB}.btx &&

# entry types in RILM tags ändern
TARGET_FILE="$HOME/rilm/marc2bibtex/dmpbms_${DateOENB}.btx"

sed -i -e "
    s/^@b[cegs]{/@collection{/;
    s/^@bf{/@book{/;
    s/^@bm{/@book{/;
    s/^@bp{/@periodical{/;
    s/^@bt{/@book{/;
    s/^@dd{/@dissertation{/;
    s/^@dm{/@thesis{/;
    s/^@er{/@electronicres{/;
    s/^@mp{/@film{/;
    s/^@mr{/@audio{/;
    s/^@r[abcdefprstvx]{/@review{/;
	s/^@a[bcdegs]{/@incollection{/;
	s/^@ap{/@article{/
" "$TARGET_FILE"

# Prüfung der BibTeX-Daten und Ausgabe einer Fehlerdatei
catmandu convert BibTeX to CSV --fields Type,Country,Note,Pages,Number,Volume,Year,Abstract,Abstractor,Series,Crossref,Ausschluss,PPN --fix $HOME/rilm/marc2bibtex/fix/fehlermeldung_oenb.fix < $HOME/rilm/marc2bibtex/dmpbms_${DateOENB}.btx > $HOME/rilm/marc2bibtex/fehlermeldung_oenb_${DateOENB}.csv &&

if [ -f $HOME/rilm/marc2bibtex/fehlermeldung_oenb_${DateOENB}.csv ]; then
   echo "${cyan}			Bitte die Datei ${green}fehlermeldung_oenb_${DateOENB}.csv${cyan} prüfen und bei Bedarf die Daten in dmpbms_${Date}.btx anpassen!!!${sgr0}"
   read -p "${cyan}			Mit \"${green}y${cyan}\" bestätigen, wenn die Prüfung beendet und alle Änderungen abgespeichert sind: ${sgr0}" Bestaetigung
   while [[ ! "$Bestaetigung" == y ]]; do
     echo "${red}Warte auf Bestätigung${sgr0}"
     read -p "${cyan}			Bitte mit \"${green}y${cyan}\" bestätigen, wenn die Datei oenb_${DateOENB}.mrk geschlossen ist und die Transformation fortgeführt werden kann: ${sgr0}" Bestaetigung
   done 
   echo "
   ------------------------------------------------------"
   echo "Transformation abgeschlossen."
   mv $HOME/rilm/marc2bibtex/fehlermeldung_oenb_${DateOENB}.csv $HOME/rilm/marc2bibtex/fehlermeldungen/
   mv $HOME/rilm/marc2bibtex/oenb_${DateOENB}.mrk $HOME/rilm/marc2bibtex/ablage/
else
   echo "
   ------------------------------------------------------"
   echo "Transformation abgeschlossen."
fi
echo "
Die ÖNB-Daten im Format Bibtex für RILM befinden sich in der Datei ${green}dmpbms_${DateOENB}.btx${sgr0}." 

# Erstelle Export-Statistik
echo "
Statistik der transformierten MARC-Daten:
"

catmandu convert BibTeX to Stat --fix $HOME/rilm/marc2bibtex/fix/stat.fix --fields Aufsätze_Monografien,Rezensionen,Abstracts < $HOME/rilm/marc2bibtex/dmpbms_${DateOENB}.btx 2>/dev/null | tee $HOME/rilm/marc2bibtex/statistics/rilm_export_statistik_${DateOENB}.csv &&

sed -i "s/alma.local_field_980=RILM${DateOENB}/alma.local_field_980=RILMJJJJQQ/g" $HOME/rilm/marc2bibtex/fix/sru_sort_request.fix &&

echo "
------------------------------------------------------"
echo "Ende."

