$sourceFile = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\night-cream.html"
$templatesDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"

$masterHtml = Get-Content -Path $sourceFile -Raw

$products = @{
    "product.night-cream.liquid" = @{ "title" = "Centella Night Cream"; "price" = "2,660"; "img" = "night-cream-suite.jpeg"; "gallery" = @("nightcream1.jpeg", "nightcream2.jpeg", "nightcream3.jpeg", "nightcream4.jpeg") }
    "product.face-wash.liquid" = @{ "title" = "Centella Face Wash"; "price" = "1,800"; "img" = "face-wash.png"; "gallery" = @("facewash-gallery-1.jpg", "facewash-gallery-2.jpg", "facewash-gallery-3.jpg", "facewash-gallery-4.jpg") }
    "product.aha-exfoliant.liquid" = @{ "title" = "AHA BHA Exfoliant"; "price" = "2,200"; "img" = "aha-exfoliant.jpg"; "gallery" = @("aha-exfoliant.jpg", "aha-exfoliant.jpg", "aha-exfoliant.jpg", "aha-exfoliant.jpg") }
    "product.anti-acne.liquid" = @{ "title" = "Anti Acne Kit"; "price" = "3,500"; "img" = "anti-acne-kit.png"; "gallery" = @("anti-acne-kit.png", "anti-acne-kit.png", "anti-acne-kit.png", "anti-acne-kit.png") }
    "product.barrier-cream.liquid" = @{ "title" = "Barrier Repair Cream"; "price" = "1,800"; "img" = "barrier-cream.jpg"; "gallery" = @("barrier-cream.jpg", "barrier-cream.jpg", "barrier-cream.jpg", "barrier-cream.jpg") }
    "product.ceramide-moisturiser.liquid" = @{ "title" = "Ceramide Moisturizer"; "price" = "1,500"; "img" = "ceramide-1.png"; "gallery" = @("ceramide-1.png", "ceramide-1.png", "ceramide-1.png", "ceramide-1.png") }
    "product.glow-serum.liquid" = @{ "title" = "Centella Serum"; "price" = "2,200"; "img" = "centella-serum.png"; "gallery" = @("centella-serum-1.jpg", "centella-serum-2.jpg", "centella-serum-3.jpg", "centella-serum-main.png") }
    "product.hair-mist-v2.liquid" = @{ "title" = "Floral Blossom Hair Mist"; "price" = "1,200"; "img" = "hair-mist.png"; "gallery" = @("hair-mist.png", "hair-mist.png", "hair-mist.png", "hair-mist.png") }
    "product.keratin-serum-v2.liquid" = @{ "title" = "Anti Frizz Keratin Serum"; "price" = "1,800"; "img" = "keratin-serum.png"; "gallery" = @("keratin-serum.png", "keratin-serum.png", "keratin-serum.png", "keratin-serum.png") }
    "product.moisturizer.liquid" = @{ "title" = "Hydra Burst Moisturizer"; "price" = "1,500"; "img" = "moisturizer-1.png"; "gallery" = @("moisturizer-gallery-1.jpg", "moisturizer-gallery-2.jpg", "moisturizer-gallery-3.jpg", "moisturizer-gallery-4.jpg") }
    "product.retinol-night-cream.liquid" = @{ "title" = "Retinol Night Cream"; "price" = "2,800"; "img" = "retinol-1.png"; "gallery" = @("retinol-1.png", "retinol-1.png", "retinol-1.png", "retinol-1.png") }
    "product.sunscreen-v2.liquid" = @{ "title" = "Sunscreen SPF60+"; "price" = "2,500"; "img" = "sunscreen-100.jpg"; "gallery" = @("sunscreen-lifestyle-1.jpg", "sunscreen-lifestyle-2.jpg", "sunscreen-lifestyle-3.jpg", "sunscreen-lifestyle-4.jpg") }
    "product.skin-refining-toner.liquid" = @{ "title" = "Skin Refining Toner"; "price" = "1,800"; "img" = "toner-1.png"; "gallery" = @("toner-meet-1.jpg", "toner-meet-2.jpg", "toner-meet-3.jpg", "toner-meet-4.jpg") }
    "product.tranexamic-serum-v2.liquid" = @{ "title" = "Tranexamic Brightening Serum"; "price" = "2,200"; "img" = "brightening-serum.png"; "gallery" = @("tranexamic-meet-1.jpg", "tranexamic-meet-2.jpg", "tranexamic-meet-3.jpg", "tranexamic-meet-4.jpg") }
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
    
    # Replace Gallery Images (nightcream1 to 4)
    if ($config.gallery) {
        $newContent = $newContent -replace 'nightcream1.jpeg', $config.gallery[0]
        $newContent = $newContent -replace 'nightcream2.jpeg', $config.gallery[1]
        $newContent = $newContent -replace 'nightcream3.jpeg', $config.gallery[2]
        $newContent = $newContent -replace 'nightcream4.jpeg', $config.gallery[3]
    }
    
    # Replace Main Image if needed (though it's usually part of the gallery now)
    $newContent = $newContent -replace 'night-cream-suite.jpeg', $config.img

    # Ensure all assets use liquid tags
    $newContent = [regex]::Replace($newContent, 'src="\./assets/([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"', 'src="{{ ''$1'' | asset_url }}"')
    $newContent = [regex]::Replace($newContent, 'src="([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"', 'src="{{ ''$1'' | asset_url }}"')

    $targetPath = "$templatesDir\$filename"
    Set-Content -Path $targetPath -Value $newContent -Encoding UTF8
}

Write-Host "Gold Standard Deployment Complete with Gallery Support."
