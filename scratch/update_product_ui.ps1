
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    $content = Get-Content -Path $file -Raw
    
    $content = $content -replace 'line-height:\s*1\.05;\s*', ''
    $patternTitle = '(?s)(\.product-title\s*\{)'
    $content = [regex]::Replace($content, $patternTitle, "`$1`n      line-height: 1.05;")

    $content = $content -replace 'border:\s*1px solid rgba\(0,0,0,0\.08\);\s*', ''
    $content = $content -replace 'background-color:\s*#fff;\s*', ''
    
    $patternViewport = '(?s)(\.gallery-main-viewport\s*\{)'
    $replacementViewport = "`$1`n      border: 1px solid rgba(0,0,0,0.08);`n      background-color: #fff;`n      overflow: hidden;"
    $content = [regex]::Replace($content, $patternViewport, $replacementViewport)
    
    $patternMobileRadius = '(\.gallery-main-viewport\s*\{.*?border-radius:\s*)0(;| !important;)'
    $content = [regex]::Replace($content, $patternMobileRadius, '`$112px`$2')

    Set-Content -Path $file -Value $content
}
Write-Host "Updated UI."
