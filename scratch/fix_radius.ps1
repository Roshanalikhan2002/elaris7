
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    $content = Get-Content -Path $file -Raw
    
    # Fix the border-radius issue for mobile
    $patternMobileRadius = '(?s)(\.gallery-main-viewport\s*\{[^\}]*?border-radius:\s*)0(;| !important;)'
    $content = [regex]::Replace($content, $patternMobileRadius, '${1}12px$2')

    Set-Content -Path $file -Value $content
}
Write-Host "Fixed mobile border radius."
