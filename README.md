<details>

<summary>us English version (click here)</summary>

# marc2bibtex

Transformation of bibliographic data from MARC MARCMaker to BibTeX for RILM

The German editorial office of the Répertoire International de Littérature Musiicale (RILM) is located at the Staatliches Institut für Musikforschung (SIM). As such, the SIM transmits all entries of the [Bibliographie des Musikschrifttums](https://www.musikbibliographie.de/) (BMS online) published in Germany to the central editorial office of [RILM Abstracts of Music Literature](https://www.rilm.org/abstracts/) on a quarterly basis. In addition, the entries reported by the editorial team at the Austrian National Library are transferred and delivered to RILM. The bibliographic data of the Austrian RILM editorial team is retrieved via the SRU interface in MARC format and must be transformed into BibTeX format for further processing at the RILM central editorial office. SIM uses the command-line tool Catmandu for this purpose. Further information about Catmandu is available here https://librecat.org/Catmandu. 

# Files description

[dictionary] (https://github.com/musikforschung/marc2bibtex/blob/main/dictionary)

* [countrycode.csv](https://github.com/musikforschung/marc2bibtex/blob/main/dictionary/countrycode.csv) contains a list of ISO country codes and the corresponding RILM tag.
* [language.csv] (https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/dictionary/language.csv) contains a list of ISO language codes and the corresponding RILM tag.
* [note.csv](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/dictionary/note.csv) contains the illustration details of the MARC field 044 and the corresponding RILM tag.

[fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix)

* [countrycode.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/countrycode.fix) selects the country codes and IDs of all journals and collections.
* [fehlermeldung_oenb.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/fehlermeldung_oenb.fix) validates the transformed BibTeX data.
* [formschlagwort_oenb.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/formschlagwort_oenb.fix) checks MARC field 655 for missing information.
* [marc2bibtex.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/marc2bibtex.fix) contains fixes to transform the necessary MARC data into the BibTeX format.
* [mat_coll.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/mat_coll.fix) adds missing format keywords to essay collections.
* [mat_ha.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/mat_ha.fix) adds missing format keywords to journals, theses, proceedings, festschrifts ... . 
* [replace.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/replace.fix) is needed for cleaning up the transformed data.
* [sru_request.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/sru_request.fix) SRU query of the monographs and main entries of the Austrian National Library using a timestamp.
* [sru_sort_request.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/sru_sort_request.fix) SRU query of the complete data of the Austrian National Library using identifier and timestamp.
* [stat.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/stat.fix) creates statistics of the transformed data.
* [type.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/type.fix) creates a list of identifiers and their associated document types.
* [volume.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/volume.fix) creates a list of monograph identifiers and their associated volume numbers.

[shell] (https://github.com/musikforschung/marc2bibtex/tree/main/shell)

* [marc2pica.sh] (https://github.com/musikforschung/marc2bibtex/blob/main/shell/marc2pica.sh) Bash script to execute all steps of the transformation from MARC to BibTex for RILM.

# Required Catmandu modules

* [Catmandu::MARC](https://metacpan.org/pod/Catmandu::MARC)
* [Catmandu::BibTeX](https://metacpan.org/pod/Catmandu::BibTeX)
* [BibTeX.pm] (https://github.com/musikforschung/Exporter/blob/main/BibTeX.pm)

# Authors

René Wallor, wallor at sim.spk-berlin.de

# Contributors

* [marc2bibtex.fix](https://github.com/musikforschung/marc2bibtex/blob/main/marc2bibtex.fix):
Johann Rolschewski, jorol at cpan.org

# License an copyright

Copyright (c) 2022 Stiftung Preußischer Kulturbesitz - Staatliches Institut für Musikforschung

This program is free software; you can redistribute it and/or modify it under the terms of either: the GNU General Public License as published by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information. 


</details>

---

<details open>

<summary>DE Deutsche Version</summary>


# marc2bibtex

Transformation bibliographischer Daten aus dem Format PICA Plain in das Format BibTeX für RILM

Am Staatlichen Institut für Musikforschung (SIM) befindet sich die deutsche Redaktion des Répertoire International de Littérature Musiicale (RILM). Als diese übermittelt das SIM vierteljährlich alle in Deutschland erscheinenden Einträge der [Bibliographie des Musikschrifttums](https://www.musikbibliographie.de/) (BMS online) an die Zentralredaktion von [RILM Abstracts of Music Literature](https://www.rilm.org/abstracts/). Zusätzlich werden die gemeldeten Einträge der Redaktion an der Österreichischen Nationalbibliothek übernommen und an RILM geliefert. Die bibliographischen Daten der österreichischen RILM-Redaktion werden per SRU-Schnittstelle im MARC-Format abgerufen und müssen für die Weiterverarbeitung in der RILM-Zentralredaktion in das Format BibTeX transformiert werden. Dafür nutzt das SIM das Kommandozeilentool Catmandu. Weitere Informationen zu Catmandu gibt hier https://librecat.org/Catmandu. 

# Beschreibung der Dateien

[dictionary] (https://github.com/musikforschung/marc2bibtex/tree/main/dictionary)

* [countrycode.csv] (https://github.com/musikforschung/marc2bibtex/blob/main/dictionary/countrycode.csv) enthält eine Liste der ISO-Ländercodes und des entsprechenden RILM-tags.
* [language.csv] (https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/dictionary/language.csv) enthält eine Liste der ISO-Sprachencodes und des entsprechenden RILM-tags.
* [note.csv](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/dictionary/note.csv) enthält Illustrationsangaben aus dem MARC-Feld 044 und des entsprechenden RILM-tags.

[fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix)

* [countrycode.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/countrycode.fix) selektiert die Identifikatoren und die zugehörigen Ländercodes aus den Hauptaufnahmen.
* [fehlermeldung_oenb.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/fehlermeldung_oenb.fix) validiert die transformierten BibTeX-Daten.
* [formschlagwort_oenb.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/formschlagwort_oenb.fix) prüft fehlende Formschlagwörter im  MARC-Feld 655.
* [marc2bibtex.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/marc2bibtex.fix) enthält fixes für die Transformation der Daten von MARC nach BibTeX.
* [mat_coll.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/mat_coll.fix) fügt fehlende Formschlagwörter den Sammelbänden hinzu.
* [mat_ha.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/mat_ha.fix) fügt fehlende Formschlagwörter den Zeitschriften, Hochschulschriften, Kongreßschriften, Festschriften usw. hinzu. 
* [replace.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/replace.fix) bereinigt die transformierten BibTeX-Daten.
* [sru_request.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/sru_request.fix) SRU-Abfrage der Monografien und der Hauptaufnahmen mittels Zeitstempel bei der Österreichischen Nationalbibliothek.
* [sru_sort_request.fix] (https://github.com/musikforschung/marc2bibtex/blob/main/fix/sru_sort_request.fix) SRU-Abfrage aller Daten mittels Identifikator und Zeitstempel bei der Österreichischen Nationalbibliothek.
* [stat.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/stat.fix) erstellt Statistiken der transformierten Daten.
* [type.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/type.fix) erstellt eine Liste von Identifikatoren und den zugehörigen Dokumententypen.
* [volume.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/volume.fix) erstellt eine Liste von Identifikatoren der Monografien und den zugehörigen Bandnummern.

[shell] (https://github.com/musikforschung/marc2bibtex/tree/main/shell)

* [marc2pica.sh] (https://github.com/musikforschung/marc2bibtex/blob/main/shell/marc2pica.sh) Bash-Skript zur Ausführung aller Schritte der Transformation von MARC nach BibTex für RILM.

#  benötigte Catmandu-Module

* [Catmandu::MARC] (https://metacpan.org/pod/Catmandu::MARC)
* [Catmandu::BibTeX] (https://metacpan.org/pod/Catmandu::BibTeX)
* [BibTeX.pm] (https://github.com/musikforschung/Exporter/blob/main/BibTeX.pm)

# Autoren

René Wallor, wallor at sim.spk-berlin.de

# Mitwirkende

* [marc2bibtex.fix](https://github.com/musikforschung/marc2bibtex/blob/main/fix/marc2bibtex.fix):
Johann Rolschewski, jorol at cpan.org

# Lizenz und Copyright

Copyright (c) 2022 Stiftung Preußischer Kulturbesitz - Staatliches Institut für Musikforschung

This program is free software; you can redistribute it and/or modify it under the terms of either: the GNU General Public License as published by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

</details>

---
