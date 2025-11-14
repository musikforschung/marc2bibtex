#!/bin/bash -e
#Shell-Skript für die Transformation von MARC-Daten der ÖNB nach PICA zur Einspielung in die BMS
#$ bash marc2pica.sh


# 1. übergeordnete Ad-Aufnahmen
# übergeordnete Ad-Aufnahmen ermitteln und MARC-Daten abholen
catmandu convert -v MARC --type MARCMaker to MARC --type MARCMaker --fix ./fix/sru_ad_request.fix < ./data/oenb.mrk
# übergeordnete Ad-Aufnahmen transformieren
catmandu convert -v MARC --type MARCMaker to PICA --type plain --fix ./fix/marc2pica_oenb.fix < ./data/oenb_ad.mrk > ./data/oenb_ad.pp
# Aufsätze und Hauptaufnahmen transformieren
catmandu convert -v MARC --type MARCMaker to PICA --type plain --fix ./fix/marc2pica_oenb.fix < ./data/oenb.mrk > ./data/oenb.pp && echo

"MARC-Daten erfolgreich nach PICA transformiert.
Die Daten befinden sich in der Datei ./data/\"oenb.pp\".
Dublettenscheck für Ads wird durchgeführt."
catmandu convert PICA --type plain to YAML --fix ./fix/ha_sru_check.fix < ./data/oenb.pp > ./data/ad_abstract_check.yml && echo 
"Dublettencheck der Hauptaufmahmen wird durchgeführt."

catmandu convert PICA --type plain to YAML --fix ./fix/ha_sru_check.fix < ./data/oenb.pp > ./data/ha_abstract_check.yml && echo "Datei ./data/ha_check.yml öffnen und die nicht benötigten abstracts der ÖNB löschen. Datei speichern und schließen."

read -p "Bitte mit \"y\" bestätigen, wenn Datei ./data/ha_check.yml geschlossen ist. Danach werden die neuen abstracts für die Einspielung in die BMS aufbereitet" Bestaetigung

if [ $Bestaetigung=y ]; 
   then bash ./bms_sru.sh
fi   
