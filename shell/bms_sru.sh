#!/bin/bash -e
#Shell-Skript zur Einspielung der ÖNB-Daten in die BMS
#$ bash bms_sru.sh

# Ads
# ggf. abstracts der Ads für upload aufbereiten
catmandu convert YAML to TSV --fix ./fix/abstract_upload.fix --fields upload < ./data/ad_check.yml > ad_abstract_upload.tsv

# HAs
# abstracts der HAs für upload aufbereiten
catmandu convert YAML to TSV --fix ./fix/abstract_upload.fix --fields upload < ./data/ha_check.yml > ha_abstract_upload.tsv && echo "Die Datei mit den zu ergänzenden abstracts in die BMS ist bereit. Daten kopieren, in \"sim_batchUpload\" einfügen und in die WinIBW einspielen"

# PICA-Daten der Ads für upload aufbereiten
 sed -e ':a;N;$!ba;s/\n/\\n/g' -e 's/IMOENB: \1 $Date\$x99/IMOENB: \1 $Date\$x99\"\)/g' -e 's/002@/\napplication.activeWindow.command\(\"e\", false\);\napplication.activeWindow.title.insertText\(\"\\n002@/g' -e 's/\\n\\n//g' < ./data/ad_check.pp > ad_upload.pp

# PICA-Daten der HAs für upload aufbereiten
 sed -e ':a;N;$!ba;s/\n/\\n/g' -e 's/IMOENB: \1 $Date\$x99/IMOENB: \1 $Date\$x99\"\)/g' -e 's/002@/\napplication.activeWindow.command\(\"e\", false\);\napplication.activeWindow.title.insertText\(\"\\n002@/g' -e 's/\\n\\n//g' < ./data/ha_check.pp > ha_upload.pp && echo "Die Datei mit den einzuspielenden Hauptaufnahmen liegt bereit: './data/ha_check.pp'. Daten kopieren, in \"sim_batchUpload\" einfügen und in die WinIBW einspielen"

#dictionary AC-PPN der bereits vorhandenen HAs erstellen
catmandu convert YAML to CSV --fix ./fix/ha_ppn.fix --fields ACNummer,PPN < ./data/ha_abstract_check.yml > ./dictionary/ha_ppn.csv

# Nach dem Einspielen der HAs, die PPNs per sru abfragen und der Datei ha_ppn.csv hinzufügen
catmandu convert SRU --base http://sru.k10plus.de/bmsonline --recordSchema picaxml --parser picaxml --query pica.exk="IMOENB: \l $Date" to CSV --fix ./fix/ha_ppn_sru.fix --fields ACNummer,PPN --header 1 >> ./dictionary/ha_ppn.csv 

# Asus
# Dublettencheck
catmandu convert PICA --type plain to YAML --fix ./fix/as_sru_check.fix < ./data/oenb.pp > ./data/as_check.yml && echo "Bitte Daten prüfen. ./data/as_check.yml enthält Dubletten, bei denen die abstracts überprüft werden müssen. Die Datei ./data/as_check_ppn.pp handelt es sich ggf. um eine Dublette, bei der die PPN der Hauptaufnahme geprüft werden muss. Die Daten in ./data/sru_check.pp müssen auf Dubletten in der BMS geprüft werden. Dubletten in den Dateien löschen."

# YAML-Datei für den Import der abstracts aufbereiten 
catmandu convert YAML to TSV --fix ./fix/abstract_upload.fix --fields upload < ./data/as_check.yml > as_abstract_upload.tsv && echo "Die Datei mit den zu ergänzenden abstracts in die BMS ist bereit. Daten kopieren, in \"sim_batchUpload\" einfügen und in die WinIBW einspielen"
# !!! eventuell zusammen mit den ha-abstracts verarbeiten - dann weiter mit der aufarbeitung der pp_Dateien für den Import

# PICA-Daten der HAs für upload aufbereiten
# sed -e ':a;N;$!ba;s/\n/\\n/g' -e 's/IMOENB: 202501ƒx99/IMOENB: 202501ƒx99\"\);\napplication.activeWindow.pressButton\(\"Enter\"\);/g' -e 's/002@/\napplication.activeWindow.command\(\"e\", false\);\napplication.activeWindow.title.insertText\(\"\\n002@/g' -e 's/\\n\\n//g' < ./data/as_check.pp > as_upload.pp && echo "Die Datei mit den einzuspielenden Hauptaufnahmen liegt bereit: './data/ha_check.pp'. Daten kopieren, in \"sim_batchUpload\" einfügen und in die WinIBW einspielen"
