
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Updating accordion spacing in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # Increase padding for accordion items
    $content = $content.Replace('padding: 18px 0;', 'padding: 24px 0;')
    
    # Optional polish for summary text
    if ($content -match '(\.accordion-item summary\s*\{)') {
        # Check if letter-spacing is already there
        if (-not $content.Contains('letter-spacing: 0.05em;')) {
            $content = $content -replace '(\.accordion-item summary\s*\{)', '$1' + "`n              letter-spacing: 0.05em;"
        }
    }

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Accordion spacing update complete!"
