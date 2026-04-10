$sourceFile = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\night-cream.html"
$templatesDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"

$masterHtml = Get-Content -Path $sourceFile -Raw

$products = @{
    "product.night-cream.liquid" = @{ "title" = "Centella Night Cream"; "price" = "2,660"; "img" = "night-cream-suite.jpeg" }
    "product.face-wash.liquid" = @{ "title" = "Centella Face Wash"; "price" = "1,800"; "img" = "face-wash.png" }
    "product.aha-exfoliant.liquid" = @{ "title" = "AHA BHA Exfoliant"; "price" = "2,200"; "img" = "aha-exfoliant.jpg" }
    "product.anti-acne.liquid" = @{ "title" = "Anti Acne Kit"; "price" = "3,500"; "img" = "anti-acne-kit.png" }
    "product.barrier-cream.liquid" = @{ "title" = "Barrier Repair Cream"; "price" = "1,800"; "img" = "barrier-cream.jpg" }
    "product.ceramide-moisturiser.liquid" = @{ "title" = "Ceramide Moisturizer"; "price" = "1,500"; "img" = "ceramide-1.png" }
    "product.glow-serum.liquid" = @{ "title" = "Centella Serum"; "price" = "2,200"; "img" = "centella-serum.png" }
    "product.hair-mist-v2.liquid" = @{ "title" = "Floral Blossom Hair Mist"; "price" = "1,200"; "img" = "hair-mist.png" }
    "product.keratin-serum-v2.liquid" = @{ "title" = "Anti Frizz Keratin Serum"; "price" = "1,800"; "img" = "keratin-serum.png" }
    "product.moisturizer.liquid" = @{ "title" = "Hydra Burst Moisturizer"; "price" = "1,500"; "img" = "moisturizer-1.png" }
    "product.retinol-night-cream.liquid" = @{ "title" = "Retinol Night Cream"; "price" = "2,800"; "img" = "retinol-1.png" }
    "product.sunscreen-v2.liquid" = @{ "title" = "Sunscreen SPF60+"; "price" = "2,500"; "img" = "sunscreen-100.jpg" }
    "product.skin-refining-toner.liquid" = @{ "title" = "Skin Refining Toner"; "price" = "1,800"; "img" = "toner-1.png" }
}

foreach ($filename in $products.Keys) {
    $config = $products[$filename]
    Write-Host "Applying Gold Standard Overhaul to: $filename"
    
    $newContent = "{% layout none %}`n" + $masterHtml
    
    # Replace Titles
    $newContent = $newContent -replace "<title>night cream", "<title>$($config.title)"
    $newContent = $newContent -replace 'class="product-title">Centella<br>Night Cream', "class=`"product-title`">$($config.title)"
    $newContent = $newContent -replace 'Centella Night Cream', $config.title
    
    # Replace Prices
    $newContent = $newContent -replace '2,660', $config.price
    $newContent = $newContent -replace '\$36\.00', "RS. $($config.price)"
    
    # Replace Images
    $newContent = [regex]::Replace($newContent, 'src="[^"]*night-cream[^"]*"', "src=`"{{ '$($config.img)' | asset_url }}|`"", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $newContent = $newContent -replace '\|"', '"'
    $newContent = $newContent -replace 'night-cream-suite.jpeg', $config.img
    
    # Ensure all assets use liquid tags
    $newContent = [regex]::Replace($newContent, 'src="([\w-]+\.(?:jpg|png|jpeg|webp|gif|svg))"', 'src="{{ ''$1'' | asset_url }}"')

    $targetPath = "$templatesDir\$filename"
    Set-Content -Path $targetPath -Value $newContent -Encoding UTF8
}

Write-Host "Gold Standard Deployment Complete."
