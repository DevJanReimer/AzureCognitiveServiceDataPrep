# Pfad zur CSV-Datei
$csvPath = 'PATHToBeSet'

# Pfad zum Ausgabeordner für Textdateien
$textFilesOutputPath = 'PATHToBeSet'

# Pfad zur JSON-Ausgabedatei
$jsonOutputPath = 'PATHToBeSet'
# CSV-Daten laden
$csvData = Import-Csv -Path $csvPath -Delimiter ";" -Encoding UTF8

# Eindeutige Keywords auslesen und anpassen
$uniqueKeywords = $csvData | Select-Object -ExpandProperty keyword -Unique | ForEach-Object { $_ -replace '[-~"#%&*:+<>()?/\{}|–…]', '' }

# Alle Keywords im CSV-Datensatz anpassen
$csvData = $csvData | ForEach-Object { $_.keyword = $_.keyword -replace '[-~"#%&*:+<>()?/\{}|–…]', ''; $_ }

# Klassenarray vorbereiten
$classesArray = @()
$documentsArray = @()

# Kleinste Anzahl an Datensätzen für ein bestimmtes Keyword festlegen und erhöhen
$minCount = $csvData | Group-Object -Property keyword | Sort-Object -Property Count | Select-Object -First 1 -ExpandProperty Count
$maxCount = [math]::Ceiling($minCount * 300.0)

# Zähler für die aktuelle Zeilennummer
$lineNumber = 0

foreach ($keyword in $uniqueKeywords) {
    $classesArray += @{
        'category' = $keyword
    }
    
    # Anzahl der Einträge für dieses Keyword
    $keywordCount = ($csvData | Where-Object { $_.keyword -eq $keyword }).Count
    
    if ($keywordCount -gt 0) {
        # Zufällige Auswahl von Einträgen für dieses Keyword
        $count = [math]::Min($keywordCount, $maxCount)
        $keywordData = $csvData | Where-Object { $_.keyword -eq $keyword } | Get-Random -Count $count

        # Jede Zeile der ausgewählten CSV-Daten für dieses Keyword durchgehen
        foreach ($row in $keywordData) {
            # Zähler erhöhen
            $lineNumber++
            
            # Textdatei erstellen
            $textFileName = $lineNumber.ToString() + '.txt'
            $textFilePath = Join-Path -Path $textFilesOutputPath -ChildPath $textFileName

            # Subject und Requesttext in die Textdatei schreiben
            $content = $row.subject + "`r`n" + $row.requesttext
            Set-Content -Path $textFilePath -Value $content -Encoding UTF8

            # Dokument zum JSON hinzufügen
            $documentsArray += [PSCustomObject]@{
                'location' = $textFileName
                'language' = 'de' # Ersetzen durch den tatsächlichen Sprachcode
                                    # Ersetzen durch den tatsächlichen Datensatz (Train/Test)
                'class' =  @{ 'category' = $keyword }
            }
        }
    }
}

# Basisinformationen für das JSON-Objekt
$jsonBase = @{
    'projectFileVersion' = '2022-10-01-preview'
    'stringIndexType' = 'Utf16CodeUnit'
    'metadata' = @{
        'projectKind' = 'CustomSingleLabelClassification'
        'storageInputContainerName' = 'ticket-classification-keyword-gaussian'
        'projectName' = 'ticket-classification-keyword-gaussian'
        'multilingual' = $false
        'description' = 'ticket-classification-keyword-gaussian'
        'language' = 'de'
    }
    'assets' = @{
        'projectKind' = 'CustomSingleLabelClassification'
        'classes' = $classesArray
        'documents' = $documentsArray
    }
}

# JSON-Datei erstellen
$json = ConvertTo-Json -InputObject $jsonBase -Depth 100
Set-Content -Path $jsonOutputPath -Value $json -Encoding UTF8
