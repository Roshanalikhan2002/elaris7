
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw
        
        # Reduce the top margin of the product page wrapper on mobile to close the gap beneath the header
        $content = $content -replace 'margin:\s*100px 0 0;', 'margin: 65px 0 0;'
        
        # In case some variations exist like margin-top: 100px;
        $content = $content -replace 'margin-top:\s*100px;', 'margin-top: 65px;'

        Set-Content -Path $file -Value $content
    }
}
Write-Host "Reduced mobile top margin across all templates."
