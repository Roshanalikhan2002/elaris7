
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw
        
        # Inject aspect-ratio into the mobile declarations
        $content = [regex]::Replace($content, '(\.breakdown-image\s*\{[^}]*?order:\s*1;\s*)', "`$1`n        aspect-ratio: 1 / 1.1;")
        $content = [regex]::Replace($content, '(\.wi-image-col\s*\{[^}]*?order:\s*1;\s*)', "`$1`n        aspect-ratio: 1 / 1.1;")
        $content = [regex]::Replace($content, '(\.spread-image-col\s*\{[^}]*?border-radius:\s*0;\s*)', "`$1`n        aspect-ratio: 1 / 1.1;")
        $content = [regex]::Replace($content, '(\.stats-image\s*\{[^}]*?order:\s*1;\s*)', "`$1`n        aspect-ratio: 1 / 1.1;")

        # Cleanup duplicate aspect-ratio if it ran multiple times
        $content = [regex]::Replace($content, '(aspect-ratio:\s*1\s*/\s*1\.1;\s*){2,}', "aspect-ratio: 1 / 1.1;`n        ")

        Set-Content -Path $file -Value $content
    }
}
Write-Host "Forced aspect ratio using refined targeting."
