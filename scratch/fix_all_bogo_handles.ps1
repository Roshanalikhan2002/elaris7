
$items = Get-ChildItem "templates/product.*.liquid"

$replacements = @{
    'tranexamic-serum-v2' = 'tranexamic-serum'
    'centella-serum' = 'glow-serum'
    'renewal-cleanser-v2' = 'renewal-cleanser'
    'keratin-serum-v2' = 'anti-frizz-keratin-serum'
    'anti-acne-serum-v2' = 'anti-acne'
    'glutathione-cream-v2' = 'glutathione-cream'
    'hair-mist-v2' = 'floral-blossom-hair-mist'
    'e7-korean-glass-skin-moisturizer' = 'centella-moisturizer'
    'centella-skin-toner-copy' = 'renewal-toner'
    'e7-korean-glass-skin-centella-night-cream-copy' = 'night-cream'
}

foreach ($file in $items) {
    Write-Host "Processing $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # Update handles in all_products references
    foreach ($old in $replacements.Keys) {
        $new = $replacements[$old]
        $content = $content.Replace("all_products['$old']", "all_products['$new']")
        $content = $content.Replace("data-gift-handle=`"$old`"", "data-gift-handle=`"$new`"")
    }
    
    # Fix Night Cream price in UI too if needed
    $content = $content.Replace("Old Price: Rs. 2,660", "Rs. 2,660")
    
    Set-Content $file.FullName $content
}

Write-Host "All product handles updated!"
