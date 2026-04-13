
$items = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $items) {
    Write-Host "Forcing cleanser image in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    $workingImage = '<div class="bogo-img-box"><img src="{{ ''rc-gal-1.jpg'' | asset_url }}" alt="Renewal Cleanser"></div>'

    # Patterns to match
    $p1 = [regex]::Escape('<div class="bogo-img-box"><img src="{{ all_products[''renewal-cleanser''].featured_image | img_url: ''400x400'' }}" alt="Renewal Cleanser"></div>')
    $p2 = [regex]::Escape('<div class="bogo-img-box"><img src="{{ all_products[''renewal-cleanser-v2''].featured_image | img_url: ''400x400'' }}" alt="Renewal Cleanser"></div>')

    $content = $content -replace $p1, $workingImage
    $content = $content -replace $p2, $workingImage
    
    Set-Content $file.FullName $content
}

Write-Host "Renewal Cleanser image forced successfully with escaped regex!"
