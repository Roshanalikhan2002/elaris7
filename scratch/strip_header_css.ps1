# Surgically remove header CSS from bundle/luxury templates to prevent theme header corruption

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
    
    # Remove CSS blocks related to header/nav
    # We look for common patterns like .site-header, .announcement-bar, etc.
    # Note: Regex needs to be broad enough to catch the whole block but specific enough to not kill main content.
    
    # Pattern 1: /* 1. Header & Navigation ... */ (found in bright/hair/individual)
    $c = [regex]::Replace($c, '(?s)/\* 1\. Header & Navigation[\s\S]*?(?=\/\*|\.pdp-wrapper|\.pdp-main-box|\.gallery-wrap|\.details-panel|<\/style>)', '')
    
    # Pattern 2: Explicit classes
    $classesToRemove = @(
        '\.site-header', '\.announcement-bar', '\.header-main', '\.header-nav', '\.header-logo', 
        '\.logo-text', '\.desktop-only', '\.mobile-only', '\.site-nav', '\.cart-count', 
        '\.menu-trigger', '\.hamburger-box', '\.mobile-header-icons', '\.cart-icon-wrapper'
    )
    
    foreach ($cls in $classesToRemove) {
        $c = [regex]::Replace($c, '(?s)' + $cls + '[\s\S]*?\{[\s\S]*?\}', '')
    }

    # Ensure padding-top is consistent (140px) for the fixed header
    if ($c -match '\.pdp-wrapper') {
        $c = [regex]::Replace($c, '((\.pdp-wrapper|\.pdp-wrapper-glass|\.pdp-acne-container)[\s\S]*?padding-top:\s*)(\d+px)', '${1}140px')
    }

    [System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
    Write-Host "Cleaned header CSS from $relPath" -ForegroundColor Green
}

Write-Host "Done." -ForegroundColor Cyan
