# PowerShell script to fix the missing container tag and mojibake stars
$f = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\sections\featured-products.liquid"
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# 1. Restore the missing container tag
# Look for the empty line (line 12-ish) and the comment
$c = $c -replace '(?s)</div>\s*\n\s*\n\s*<!-- NEW PRODUCTS', '</div><div class="product-collection" id="product-collection-scroll"><!-- NEW PRODUCTS'

# 2. Fix the stars (mojibake)
$c = $c.Replace('â˜…â˜…â˜…â˜…â˜…', '★★★★★')

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "Restored container tag and fixed stars."
