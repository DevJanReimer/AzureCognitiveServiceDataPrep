**Beschreibung:**

**CSV-Datenkonverter für die Azure Cognitive Services**

Diese Sammlung von PowerShell-Skripten wurde entwickelt, um Daten aus CSV-Dateien in ein spezifisches Format zu überführen, welches von den Azure Cognitive Services vorausgesetzt wird. 

**Import_Keywords.ps1:**

- **Grundlegende Datenverarbeitung**: Dieses Skript fokussiert sich auf den direkten Import von CSV-Daten und deren Transformation in Textdateien und JSON-Format ohne zusätzliche Normalisierung oder Datenbalancierung.
- **Keyword-Bereinigung**: Das Skript entfernt bestimmte Sonderzeichen aus den Keywords, um eine höhere Datenkonsistenz zu gewährleisten.
- **Textdatei- und JSON-Erstellung**: Für jeden CSV-Eintrag wird eine separate Textdatei generiert. Parallel dazu wird eine JSON-Datei erstellt, die den Azure Cognitive Services-Anforderungen entspricht und Metadaten sowie Informationen über jede Textdatei enthält.

**Import_Keywords_Normalization.ps1 (Erweiterte Version):**

- **Erweiterte Datenverarbeitung**: Zusätzlich zur Basisfunktionalität des ersten Skripts bietet dieses Skript eine Datenbalancierung durch Berücksichtigung einer maximalen Anzahl von Einträgen pro Keyword.
- **Keyword-Bereinigung**: Wie im ersten Skript werden die Keywords bereinigt, um Sonderzeichen zu entfernen.
- **Textdatei- und JSON-Erstellung**: Das Skript transformiert jeden CSV-Eintrag in eine separate Textdatei und erstellt zusätzlich eine angepasste JSON-Datei, die für Azure Cognitive Services geeignet ist.

**Zweck und Verwendung:**

Der primäre Zweck dieser Skripte besteht darin, Daten aus einer CSV-Datei so zu formatieren, dass diese in den Azure Cognitive Services verwendet werden können. Ein häufiges Problem beim maschinellen Lernen besteht darin, dass durch ungleich verteilte Daten Verzerrungen (Biases) in den resultierenden Algorithmen entstehen. Die erweiterte Version des Skripts versucht, diese Problematik mit einfachen Mitteln zu mitigieren.  Vor der Ausführung der Skripte sollten die Pfade (`$csvPath`, `$textFilesOutputPath`, `$jsonOutputPath`) entsprechend gesetzt werden. Nach Abschluss des Prozesses können die generierten Textdateien und die JSON-Datei direkt in Azure Blob Storage hochgeladen und dann von Azure Cognitive Services verwendet werden.
