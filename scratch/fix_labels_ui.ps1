# PowerShell script to fix brand labels in featured-products.liquid
$f = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\sections\featured-products.liquid"
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Replace 'korean-glass-skin' with 'oil-to-foam' in the label SPAN (specifically for the new card)
$c = $c -replace '<span class="card-brand-label">korean-glass-skin</span>', '<span class="card-brand-label">oil-to-foam</span>'

# Replace 'korean-brightening' with 'gel-cleanser' in the label SPAN
$c = $c -replace '<span class="card-brand-label">korean-brightening</span>', '<span class="card-brand-label">gel-cleanser</span>'

# Replace 'hair-care' with 'regrow-spray' in the label SPAN
$c = $c -replace '<span class="card-brand-label">hair-care</span>', '<span class="card-brand-label">regrow-spray</span>'

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "Updated brand labels for better UI."
