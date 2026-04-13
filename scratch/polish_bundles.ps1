# Final cleanup for bundle templates: fix HTML tags and padding

$files = @(
    'templates\product.bright-bundle.liquid',
    'templates\product.hair-bundle.liquid',
    'templates\product.glass-bundle.liquid',
    'templates\product.anti-acne.liquid'
)

foreach ($relPath in $files) {
    $f = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\$relPath"
    if (-Not (Test-Path $f)) { continue }
    
    $c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
    
    # 1. Replace <main> with <div> because theme.liquid already has <main>
    $c = $c -replace '<main', '<div'
    $c = $c -replace '</main>', '</div>'
    
    # 2. Fix footer: templates shouldn't have their own <footer> if theme has one
    # Note: theme.liquid line 45 has {% section 'footer' %}
    $c = [regex]::Replace($c, '(?s)<footer[\s\S]*?</footer>', '')
    
    # 3. Set padding-top to 20px (since theme main already provides 115px)
    if ($c -match 'padding-top:\s*\d+px') {
        $c = [regex]::Replace($c, 'padding-top:\s*\d+px', 'padding-top: 20px')
    }

    # 4. Remove any last traces of header/logo CSS overrides
    $classesToRemove = @('\.site-header', '\.announcement-bar', '\.header-main', '\.header-logo', '\.logo-text')
    foreach ($cls in $classesToRemove) {
        $c = [regex]::Replace($c, '(?s)' + $cls + '[\s\S]*?\{[\s\S]*?\}', '')
    }

    [System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
    Write-Host "Polished $relPath" -ForegroundColor Green
}

Write-Host "Bundle templates are now optimized for theme layout." -ForegroundColor Cyan
