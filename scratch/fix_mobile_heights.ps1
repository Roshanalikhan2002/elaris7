
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw
        
        # Breakdown Section
        $patternBD = '(?s)(@media \(max-width: 900px\)\s*\{\s*\.breakdown-section\s*\{[^\}]*\})'
        if ($content -match $patternBD) {
            $content = [regex]::Replace($content, '(@media \(max-width: 900px\)\s*\{\s*\.breakdown-section\s*\{)', "`$1`n        height: auto;")
        }

        # What's Inside Section
        $patternWI = '(?s)(@media \(max-width: 900px\)\s*\{\s*\.whats-inside-section\s*\{[^\}]*\})'
        if ($content -match $patternWI) {
            $content = [regex]::Replace($content, '(@media \(max-width: 900px\)\s*\{\s*\.whats-inside-section\s*\{)', "`$1`n        height: auto;")
        }

        # Spread It On For Section
        $patternSP = '(?s)(@media \(max-width: 900px\)\s*\{\s*\.spread-section\s*\{[^\}]*\})'
        if ($content -match $patternSP) {
            $content = [regex]::Replace($content, '(@media \(max-width: 900px\)\s*\{\s*\.spread-section\s*\{)', "`$1`n        height: auto;")
        }

        # Statistics Section
        $patternST = '(?s)(@media \(max-width: 900px\)\s*\{\s*\.stats-section\s*\{[^\}]*\})'
        if ($content -match $patternST) {
            $content = [regex]::Replace($content, '(@media \(max-width: 900px\)\s*\{\s*\.stats-section\s*\{)', "`$1`n        height: auto;")
        }
        
        # Just in case, clean up any multiple 'height: auto;' if script ran more than once
        $content = [regex]::Replace($content, '(height:\s*auto;\s*){2,}', "height: auto;`n        ")

        Set-Content -Path $file -Value $content
    }
}
Write-Host "Fixed mobile editorial section heights across all templates."
