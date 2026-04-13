
$items = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $items) {
    Write-Host "Fixing imagery in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # regex to find the gift items in the loop
    # We want to replace the hardcoded asset_url with the dynamic product image
    # Note: We already updated the handles in the previous turn
    
    # We will look for the pattern: <div class="bogo-img-box"><img src="{{ '.*' | asset_url }}" alt=".*"></div>
    # And replace it with a more dynamic version that uses the variant ID's parent product image if possible, 
    # but the simplest way is to use the data-gift-handle we already have.
    
    # However, since the handle is in a different line (data-gift-handle), 
    # the easiest way is to look for the specific block and replace it with the correct Shopify image logic.

    # 1. Renewal Cleanser fix (specific request)
    $content = $content -replace '<div class="bogo-img-box"><img src="{{ ''renewal-cleanser-1.jpg'' \| asset_url }}" alt="Renewal Cleanser"></div>', '<div class="bogo-img-box"><img src="{{ all_products[''renewal-cleanser''].featured_image | img_url: ''400x400'' }}" alt="Renewal Cleanser"></div>'
    
    # 2. General logic: Let's just fix the Cleanser one first as requested to be safe.
    # If the user wants all fixed, we can do more.
    
    Set-Content $file.FullName $content
}

Write-Host "Renewal Cleanser imagery fixed globally!"
