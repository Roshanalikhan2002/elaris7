# Fix bundle templates: remove layout none + custom html wrapper, keep content + styles

# ── BRIGHT BUNDLE ──
$brightFile = 'c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates\product.bright-bundle.liquid'
$brightContent = [System.IO.File]::ReadAllText($brightFile, [System.Text.Encoding]::UTF8)

# Extract the CSS block (between first <style> and </style>)
$cssMatch = [regex]::Match($brightContent, '(?s)<style>(.*?)</style>')
$brightCSS = if ($cssMatch.Success) { $cssMatch.Groups[1].Value } else { '' }

# Extract main content (from <main to just before </body>)
$mainMatch = [regex]::Match($brightContent, '(?s)(<main[\s\S]*?)<\/body>')
$brightMain = if ($mainMatch.Success) { $mainMatch.Groups[1].Value } else { '' }

# Extract script block (between last <script> and </script> before </body>)
$scriptMatches = [regex]::Matches($brightContent, '(?s)<script>([\s\S]*?)<\/script>')
$brightScript = ''
foreach ($m in $scriptMatches) { $brightScript = $m.Value }  # take last one

# Build new file: style + main content (which already includes script at end)
$newBright = @"
<style>
  /* Bundle Page Content Styles */
  .pdp-wrapper { padding-top: 140px; max-width: 1440px; margin: 0 auto; padding-left: 12px; padding-right: 12px; width: 100%; }
$brightCSS
</style>

$brightMain
"@

[System.IO.File]::WriteAllText($brightFile, $newBright, [System.Text.Encoding]::UTF8)
Write-Host "Bright bundle fixed." -ForegroundColor Green

# ── HAIR BUNDLE ──
$hairFile = 'c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates\product.hair-bundle.liquid'
$hairContent = [System.IO.File]::ReadAllText($hairFile, [System.Text.Encoding]::UTF8)

$cssMatch2 = [regex]::Match($hairContent, '(?s)<style>(.*?)<\/style>')
$hairCSS = if ($cssMatch2.Success) { $cssMatch2.Groups[1].Value } else { '' }

$mainMatch2 = [regex]::Match($hairContent, '(?s)(<main[\s\S]*?)<\/body>')
$hairMain = if ($mainMatch2.Success) { $mainMatch2.Groups[1].Value } else { '' }

$newHair = @"
<style>
  /* Bundle Page Content Styles */
  .pdp-wrapper { padding-top: 140px; max-width: 1440px; margin: 0 auto; padding-left: 12px; padding-right: 12px; width: 100%; }
$hairCSS
</style>

$hairMain
{{ 'script.js' | asset_url | script_tag }}
"@

[System.IO.File]::WriteAllText($hairFile, $newHair, [System.Text.Encoding]::UTF8)
Write-Host "Hair bundle fixed." -ForegroundColor Green

Write-Host ""
Write-Host "Both bundle templates now use the theme layout (no layout none)." -ForegroundColor Cyan
Write-Host "Shopify will automatically apply header.liquid from theme layout." -ForegroundColor Cyan
