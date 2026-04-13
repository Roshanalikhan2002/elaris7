
$items = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $items) {
    Write-Host "Checking handle mismatch in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # If renewal-cleanser didn't show image, it's likely renewal-cleanser-v2
    # We will try both or just switch to v2 if that's what's in the store.
    
    $content = $content -replace "all_products\['renewal-cleanser'\]", "all_products['renewal-cleanser-v2']"
    $content = $content -replace "data-gift-handle=`"renewal-cleanser`"", "data-gift-handle=`"renewal-cleanser-v2`""
    
    Set-Content $file.FullName $content
}

Write-Host "Updated Renewal Cleanser handle to v2!"
