$sourceFile = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\night-cream.html"
$templatesDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"

$sourceContent = Get-Content -Path $sourceFile -Raw

# 1. Extract Master Template Sections from Night Cream
$styleMatches = [regex]::Matches($sourceContent, '<style>.*?</style>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$masterStyles = ""
foreach ($match in $styleMatches) { $masterStyles += $match.Value + "`n" }

$headerMatch = [regex]::Match($sourceContent, '<header class="site-header">.*?</header>', [System.Text.RegularExpressions.RegexOptions]::Singleline).Value
$footerMatch = [regex]::Match($sourceContent, '<footer class="footer-block">.*?</footer>', [System.Text.RegularExpressions.RegexOptions]::Singleline).Value
$drawerMatch = [regex]::Match($sourceContent, '<div class="mobile-menu-drawer">.*?</div>', [System.Text.RegularExpressions.RegexOptions]::Singleline).Value

# Extract the Skeleton (The part between <header> and <footer>)
$mainStartIdx = $sourceContent.IndexOf('<main class="product-page">')
$mainEndIdx = $sourceContent.IndexOf('</main>') + 7
$masterMain = $sourceContent.Substring($mainStartIdx, $mainEndIdx - $mainStartIdx)

function Smart-Overhaul($filePath) {
    $content = Get-Content -Path $filePath -Raw
    $fileName = Split-Path $filePath -Leaf

    Write-Host "Processing: $fileName"

    # A. Extract unique data from current file
    $title = [regex]::Match($content, '<h1 class="product-title">(.*?)</h1>', [System.Text.RegularExpressions.RegexOptions]::Singleline).Groups[1].Value.Trim()
    if (-not $title) { $title = [regex]::Match($content, '<title>(.*?)\|', [System.Text.RegularExpressions.RegexOptions]::Singleline).Groups[1].Value.Trim() }
    
    $price = [regex]::Match($content, '(?:Rs\.|RS\.)\s*([\d,]+)', [System.Text.RegularExpressions.RegexOptions]::Singleline).Groups[1].Value.Trim()
    if (-not $price) { $price = "1,500" }

    $mainImg = [regex]::Match($content, '<img src="([^"]+)" alt="Main View 1"', [System.Text.RegularExpressions.RegexOptions]::Singleline).Groups[1].Value
    if (-not $mainImg) { $mainImg = [regex]::Match($content, '<img src="([^"]+)" alt="Thumb 1"', [System.Text.RegularExpressions.RegexOptions]::Singleline).Groups[1].Value }
    if (-not $mainImg) { $mainImg = [regex]::Match($content, '<img src="([^"]+)" class="main-product-img"', [System.Text.RegularExpressions.RegexOptions]::Singleline).Groups[1].Value }

    # B. Clone the Skeleton
    $newMain = $masterMain
    
    # C. Inject extracted data into cloned Skeleton
    # Night Cream specific strings to replace
    $newMain = $newMain -replace 'Centella Night Cream', $title
    $newMain = $newMain -replace 'night cream', $title
    $newMain = $newMain -replace 'RS\. 2,660', "RS. $price"
    $newMain = $newMain -replace '\$36\.00', "RS. $price"
    $newMain = $newMain -replace 'ADD TO BAG - \$36\.00', "ADD TO BAG - RS. $price"
    $newMain = $newMain -replace 'ADD TO BAG - RS\. 2,660', "ADD TO BAG - RS. $price"
    
    if ($mainImg) {
        # Inject main image into gallery and thumbnails
        # We'll just replace the first few images in the skeleton with the detected main image
        $newMain = [regex]::Replace($newMain, '<div class="gallery-slide"><img src="[^"]+"', "<div class=\"gallery-slide\"><img src=\"$mainImg\"", [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $newMain = [regex]::Replace($newMain, '<div class="thumb-item[^>]*><img src="[^"]+"', "<div class=\"thumb-item active\"><img src=\"$mainImg\"", [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $newMain = [regex]::Replace($newMain, '<div class="breakdown-image">.*?<img src="[^"]+"', "<div class=\"breakdown-image\">`n        <img src=\"$mainImg\"", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    }

    # D. Reconstruct the Full HTML
    $isLiquid = $filePath.EndsWith(".liquid")
    $newContent = ""
    if ($isLiquid) {
        $newContent += "{% layout none %}`n"
    }
    $newContent += "<!DOCTYPE html>`n<html lang=`"en`">`n<head>`n  <meta charset=`"UTF-8`">`n  <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">`n  <title>$title | elaris7</title>`n"
    $newContent += "$masterStyles`n</head>`n<body>`n"
    $newContent += "$headerMatch`n"
    $newContent += "$newMain`n"
    $newContent += "$drawerMatch`n"
    $newContent += "$footerMatch`n"
    
    # Final cleanup of scripts
    $newContent += "<script src=`"{{ 'script.js' | asset_url }}`" defer></script>`n"
    $newContent += "</body>`n</html>"

    # E. Save
    Set-Content -Path $filePath -Value $newContent -Encoding UTF8
    Write-Host "Successfully overalled: $fileName"
}

# The files the user wants specifically
$targets = @(
    "product.anti-acne.liquid",
    "product.hair-mist-v2.liquid",
    "product.keratin-serum-v2.liquid",
    "product.glow-serum.liquid",
    "product.sunscreen-v2.liquid",
    "product.moisturizer.liquid",
    "product.aha-exfoliant.liquid",
    "product.barrier-cream.liquid",
    "product.ceramide-moisturiser.liquid",
    "product.glutathione-cream-v2.liquid",
    "product.retinol-night-cream.liquid",
    "product.skin-refining-toner.liquid"
)

foreach ($t in $targets) {
    $fpath = "$templatesDir\$t"
    if (Test-Path $fpath) {
        Smart-Overhaul $fpath
    } else {
        # Check in backup if missing
        $backPath = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates_backup\$t"
        if (Test-Path $backPath) {
             Smart-Overhaul $backPath
             # Move back to active templates
             git mv $backPath $fpath
        }
    }
}

Write-Host "Full Body Structural Sync Complete!"
