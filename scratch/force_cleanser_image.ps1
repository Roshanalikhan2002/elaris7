
$items = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $items) {
    Write-Host "Forcing cleanser image in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # Replace the dynamic Shopify image logic with the working hardcoded asset for this specific product
    $search = '<div class="bogo-img-box"><img src="{{ all_products[''renewal-cleanser-v2''].featured_image | img_url: ''400x400'' }}" alt="Renewal Cleanser"></div>'
    $replace = '<div class="bogo-img-box"><img src="{{ ''rc-gal-1.jpg'' | asset_url }}" alt="Renewal Cleanser"></div>'
    
    # Also handle the v1 version just in case
    $content = $content -replace '<div class="bogo-img-box"><img src="{{ all_products[''renewal-cleanser''].featured_image | img_url: ''400x400'' }}" alt="Renewal Cleanser"></div>', $replace
    $content = $content -replace $search, $replace
    
    Set-Content $file.FullName $content
}

Write-Host "Renewal Cleanser image forced successfully!"
