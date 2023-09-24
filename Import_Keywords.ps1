# Pfad zur CSV-Datei
$csvPath = 'PATHToBeSet'

# Pfad zum Ausgabeordner für Textdateien
$textFilesOutputPath = 'PATHToBeSet'

# Pfad zur JSON-Ausgabedatei
$jsonOutputPath = 'PATHToBeSet'


# CSV-Daten laden
$csvData = Import-Csv -Path $csvPath -Delimiter ";" -Encoding UTF8

# Eindeutige Keywords auslesen
$uniqueKeywords = $csvData | Select-Object -ExpandProperty keyword -Unique | ForEach-Object { $_ -replace '[-~"#%&*:+<>()?/\{}|–…]', '' }

# Klassenarray vorbereiten
$classesArray = @()

foreach ($keyword in $uniqueKeywords) {
    $classesArray += @{
        'category' = $keyword
    }
}

# Basisinformationen für das JSON-Objekt
$jsonBase = @{
    'projectFileVersion' = '2022-10-01-preview'
    'stringIndexType' = 'Utf16CodeUnit'
    'metadata' = @{
        'projectKind' = 'CustomSingleLabelClassification'
        'storageInputContainerName' = 'ticket-classification-keyword'
        'projectName' = 'ticket-classification-keyword'
        'multilingual' = $false
        'description' = 'ticket-classification-keyword'
        'language' = 'de'
    }
    'assets' = @{
        'projectKind' = 'CustomSingleLabelClassification'
        'classes' = $classesArray
        'documents' = @()
    }
}

# Zähler für die aktuelle Zeilennummer
$lineNumber = 0

# Jede Zeile der CSV-Datei durchgehen
foreach ($row in $csvData) {
    # Zähler erhöhen und Fortschritt anzeigen
    $lineNumber++
    Write-Host "Verarbeite Zeile $lineNumber..."

    # Textdatei erstellen, jetzt mit der laufenden Nummer
    $textFileName = $lineNumber.ToString() + '.txt'
    $textFilePath = Join-Path -Path $textFilesOutputPath -ChildPath $textFileName

    # Subject und Requesttext in die Textdatei schreiben
    $content = $row.subject + "`r`n" + $row.requesttext
    Set-Content -Path $textFilePath -Value $content -Encoding UTF8

    # Dokument zum JSON hinzufügen
    $jsonBase.assets.documents += [PSCustomObject]@{
        'location' = $textFileName
        'language' = 'de' # Ersetzen durch den tatsächlichen Sprachcode
                            # Ersetzen durch den tatsächlichen Datensatz (Train/Test)
        'class' =  @{ 'category' = $row.keyword -replace '[-~"#%&*:+<>()?/\{}|–…]', '' }
    }
}

# JSON-Datei erstellen
$json = ConvertTo-Json -InputObject $jsonBase -Depth 100
Set-Content -Path $jsonOutputPath -Value $json -Encoding UTF8
