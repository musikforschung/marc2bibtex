<details>

<summary>us English version (click here)</summary>

# marc2bibtex

Transformation of bibliographic data from MARC MARCMaker format to BibTeX format for RILM

The German editorial office of the Répertoire International de Littérature Musiicale (RILM) is located at the Staatliches Institut für Musikforschung (SIM). As such, the SIM transmits all entries of the [Bibliographie des Musikschrifttums](https://www.musikbibliographie.de/) (BMS online) published in Germany to the central editorial office of [RILM Abstracts of Music Literature](https://www.rilm.org/abstracts/) on a quarterly basis. In addition, the entries reported by the editorial team at the Austrian National Library are transferred and delivered to RILM. The bibliographic data of the Austrian RILM editorial team is retrieved via the SRU interface in MARC format and must be transformed into BibTeX format for further processing at the RILM central editorial office. SIM uses the command-line tool Catmandu for this purpose. Further information about Catmandu is available here https://librecat.org/Catmandu. 

# Files description

* [BibTeX_bms.pm](https://github.com/musikforschung/marc2bibtex/blob/main/BibTeX_bms.pm) contains some RILM-specific tags that are not supported in the original Catmandu [BibTeX module](https://github.com/LibreCat/Catmandu-BibTeX/tree/main/lib/Catmandu/Exporter): abstractor, author_afterword, author_collaborator, author_commentator, author_compiled, author_foreword, author_illustrator, author_introduction, author_supervisor, author_translator, country, crossref, eventdate, eventtitle, honoured, language_original, reviewed-item.
* [countrycode.fix](https://github.com/musikforschung/marc2bibtex/blob/main/countrycode.fix) selects the country codes and IDs of all journals and collections. The loader codes are written to a csv file and transferred to the essays contained in the journals or collections in a later step.
* [festschrift_proceeding.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/festschrift_proceeding.fix) selects the IDs of all conference and festschriften and assigns the RILM-tag to them. The selected RILM-tags and IDs are written to a csv file and in a later step transferred to the articles contained in the conference and festschrift proceedings.
* [note.csv](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/note.csv) contains the illustration details of the PICA field 034M and the corresponding RILM tag.
* [picafix.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/picafix.fix) contains the script for transforming the necessary PICA+ data into the BibTeX format.
* [replace.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/replace.fix) is needed for cleaning up the transformed data.

# Required Catmandu modules

* [Catmandu::MARC](https://metacpan.org/pod/Catmandu::MARC)
* [Catmandu::BibTeX](https://metacpan.org/pod/Catmandu::BibTeX)

# Authors

* [BibTeX_bms.pm](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/BibTeX_bms.pm):
Nicolas Steenlant, nicolas.steenlant at ugent.be; edited by René Wallor

* files included in [Fix_bms](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/Fix_bms):
René Wallor, wallor at sim.spk-berlin.de

# Contributors

* [picafix.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/picafix.fix):
Johann Rolschewski, jorol at cpan.org

# License an copyright

* [BibTeX_bms.pm](https://github.com/musikforschung/marc2bibtex/exporter_bibtex/blob/main/BibTeX_bms.pm):
Copyright (c) 2021 by Nicolas Steenlant

* files in [Fix_bms](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/Fix_bms):
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

* [BibTeX_bms.pm](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/BibTeX_bms.pm) enthält einige RILM-spezifische tags, die im ursprünglichen Catmandu [BibTeX Modul](https://github.com/LibreCat/Catmandu-BibTeX/tree/main/lib/Catmandu/Exporter) nicht unterstützt werden: abstractor, author_afterword, author_collaborator, author_commentator, author_compiled, author_foreword, author_illustrator, author_introduction, author_supervisor, author_translator, country, crossref, eventdate, eventtitle, honoured, language_original, reviewed-item.
* [countrycode.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/countrycode.fix) selektiert die Ländercodes und IDs aller Zeitschriften und Sammelbände. Die Ländercodes werden in eine csv-Datei geschrieben und in einem späteren Schritt auf die in den Zeitschriften und Sammelbänden enthaltenen Aufsätze übertragen.
* [festschrift_proceeding.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/festschrift_proceeding.fix) selektiert die IDs aller Konferenz- und Festschriften und ordnet ihnen den entsprechenden RILM-tag zu. Die selektierten RILM-tags und IDs werden in eine csv-Datei geschrieben und in einem späteren Schritt auf die in den Konferenz- und Festschriften enthaltenen Aufsätzen übertragen.
* [note.csv](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/note.csv) enthält die Illustrationsangaben des PICA-Feldes 034M und den entsprechenden RILM-tag.
* [picafix.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/picafix.fix) enthält das Script für die Transformation der notwendigen PICA+ Daten in das Format BibTeX.
* [replace.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/replace.fix) wird für die Bereinigung der transformierten Daten benötigt.

#  benötigte Catmandu-Module

* [Catmandu::MARC](https://metacpan.org/pod/Catmandu::MARC)
* [Catmandu::BibTeX](https://metacpan.org/pod/Catmandu::BibTeX)

# Autoren

* [BibTeX_bms.pm](https://github.com/musikforschung/marc2bibtex/exporter_bibtex/blob/main/BibTeX_bms.pm):
Nicolas Steenlant, nicolas.steenlant at ugent.be; bearbeitet von René Wallor

* Skripte in [fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/Fix_bms):
René Wallor, wallor at sim.spk-berlin.de

# Mitwirkende

* [marc2bibtex.fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/picafix.fix):
Johann Rolschewski, jorol at cpan.org

# Lizenz und Copyright

* [BibTeX_bms.pm](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/BibTeX_bms.pm):
Copyright (c) 2021 by Nicolas Steenlant

* Skripte in [fix](https://github.com/musikforschung/Catmandu_PICAtoBibTeX/blob/main/Fix_bms):
Copyright (c) 2022 Stiftung Preußischer Kulturbesitz - Staatliches Institut für Musikforschung

This program is free software; you can redistribute it and/or modify it under the terms of either: the GNU General Public License as published by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

</details>

---
