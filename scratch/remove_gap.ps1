$files = @(
    "templates/product.night-cream.liquid",
    "templates/product.tranexamic-serum.liquid",
    "templates/product.anti-frizz-keratin-serum.liquid",
    "templates/product.e7-korean-glass-skin-centella-sunscreen-spf50-copy.liquid",
    "templates/product.glutathione-cream.liquid",
    "templates/product.floral-blossom-hair-mist.liquid",
    "templates/product.e7-korean-glass-skin-centella-night-cream-copy.liquid",
    "templates/product.anti-acne.liquid",
    "templates/product.e7-korean-glass-skin-centella-face-wash-copy.liquid",
    "templates/product.renewal-cleanser.liquid",
    "templates/product.centella-moisturizer.liquid",
    "templates/product.renewal-toner.liquid",
    "templates/product.oil-to-foam-cleanser.liquid",
    "templates/product.skin-refining-toner.liquid",
    "templates/product.hair-regrow-spray.liquid",
    "templates/product.anti-acne-serum-v2.liquid",
    "templates/product.renewal-toner-v2.liquid",
    "templates/product.tranexamic-serum-v2.liquid"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Replace padding-top: 115px or similar with 0
        $content = $content -replace 'padding-top: 115px;', 'padding-top: 0;'
        $content = $content -replace 'padding: 100px 16px 16px;', 'padding: 0;'
        
        # Replace margin: 20px ... or margin: 115px ... with 0
        $content = $content -replace 'margin: 20px 12px 12px;', 'margin: 0 12px 12px;'
        $content = $content -replace 'margin: 20px 0 0;', 'margin: 0;'
        $content = $content -replace 'margin: 65px 0 0;', 'margin: 0;'
        $content = $content -replace 'margin: 115px 12px 12px;', 'margin: 0 12px 12px;'
        
        Set-Content $file $content
        Write-Host "Updated $file"
    }
}
