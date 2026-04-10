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

# Extract the Skeleton
$mainStartIdx = $sourceContent.IndexOf('<main class="product-page">')
$mainEndIdx = $sourceContent.IndexOf('</main>') + 7
$masterMain = $sourceContent.Substring($mainStartIdx, $mainEndIdx - $mainStartIdx)

function Smart-Overhaul($filePath) {
    if (-not (Test-Path $filePath)) { return }
    $content = Get-Content -Path $filePath -Raw
    $fileName = Split-Path $filePath -Leaf

    Write-Host "Processing: $fileName"

    $titleMatch = [regex]::Match($content, '<h1 class="product-title">(.*?)</h1>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $title = if ($titleMatch.Success) { $titleMatch.Groups[1].Value.Trim() } else { "Product" }
    
    $priceMatch = [regex]::Match($content, '(?:Rs\.|RS\.)\s*([\d,]+)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $price = if ($priceMatch.Success) { $priceMatch.Groups[1].Value.Trim() } else { "1,500" }

    $imgMatch = [regex]::Match($content, '<img src="([^"]+)"', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $mainImg = if ($imgMatch.Success) { $imgMatch.Groups[1].Value } else { "" }

    $newMain = $masterMain
    $newMain = $newMain -replace 'Centella Night Cream', $title
    $newMain = $newMain -replace 'night cream', $title
    $newMain = $newMain -replace 'RS\. 2,660', "RS. $price"
    $newMain = $newMain -replace '2,660', $price
    
    if ($mainImg) {
        $newMain = [regex]::Replace($newMain, '<div class="gallery-slide"><img src="[^"]+"', "<div class=`"gallery-slide`"><img src=`"$mainImg`"", [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $newMain = [regex]::Replace($newMain, '<div class="thumb-item[^>]*><img src="[^"]+"', "<div class=`"thumb-item active`"><img src=`"$mainImg`"", [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $newMain = [regex]::Replace($newMain, '<div class="breakdown-image">.*?<img src="[^"]+"', "<div class=`"breakdown-image`">`n        <img src=`"$mainImg`"", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    }

    $isLiquid = $filePath.EndsWith(".liquid")
    $newContent = if ($isLiquid) { "{% layout none %}`n" } else { "" }
    $newContent += "<!DOCTYPE html>`n<html lang=`"en`">`n<head>`n  <meta charset=`"UTF-8`">`n  <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">`n  <title>$title | elaris7</title>`n"
    $newContent += "$masterStyles`n</head>`n<body>`n"
    $newContent += "$headerMatch`n"
    $newContent += "$newMain`n"
    $newContent += "$drawerMatch`n"
    $newContent += "$footerMatch`n"
    $newContent += "<script src=`"{{ 'script.js' | asset_url }}`" defer></script>`n</body>`n</html>"

    Set-Content -Path $filePath -Value $newContent -Encoding UTF8
}

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
        $backPath = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates_backup\$t"
        if (Test-Path $backPath) {
             Smart-Overhaul $backPath
             git mv $backPath $fpath
        }
    }
}
Write-Host "Structural Overhaul Done."
