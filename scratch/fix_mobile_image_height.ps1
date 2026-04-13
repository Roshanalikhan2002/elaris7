
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw
        
        # Breakdown image
        $patternBDMobileImg = '(@media \(max-width: 900px\)\s*\{\s*\.breakdown-section.*?\.breakdown-image\s*\{)'
        if ($content -match $patternBDMobileImg) {
            $content = [regex]::Replace($content, $patternBDMobileImg, "`$1`n        aspect-ratio: 1 / 1.1;")
        }

        # What's Inside image
        $patternWIMobileImg = '(@media \(max-width: 900px\)\s*\{\s*\.whats-inside-section.*?\.wi-image-col\s*\{)'
        if ($content -match $patternWIMobileImg) {
            $content = [regex]::Replace($content, $patternWIMobileImg, "`$1`n        aspect-ratio: 1 / 1.1;")
        }

        # Spread It On For image
        $patternSPMobileImg = '(@media \(max-width: 900px\)\s*\{\s*\.spread-section.*?\.spread-image-col\s*\{)'
        if ($content -match $patternSPMobileImg) {
            $content = [regex]::Replace($content, $patternSPMobileImg, "`$1`n        aspect-ratio: 1 / 1.1;")
        }

        # Statistics image
        $patternSTMobileImg = '(@media \(max-width: 900px\)\s*\{\s*\.stats-section.*?\.stats-image\s*\{)'
        if ($content -match $patternSTMobileImg) {
            $content = [regex]::Replace($content, $patternSTMobileImg, "`$1`n        aspect-ratio: 1 / 1.1;")
        }

        Set-Content -Path $file -Value $content
    }
}
Write-Host "Set aspect ratios for mobile images."
