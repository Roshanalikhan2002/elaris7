
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw
        
        # Determine if the content is broken with literal `n
        if ($content -match "``n") {
            $content = $content -replace "``n", "`n"
        }

        Set-Content -Path $file -Value $content
    }
}
Write-Host "Fixed literal newline characters in CSS across all templates."
