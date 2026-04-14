
# Script to remove mobile-sticky-cart from all product liquid templates
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Processing $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # Remove HTML block (using regex to handle varying prices and spacing)
    $patternHtml = "(?s)\s*<!-- Mobile Sticky Cart -->\s*<div class=`"mobile-sticky-cart`".*?</div>"
    $newContent = $content -replace $patternHtml, ""
    
    # Remove padding-bottom: 90px; from .product-page in CSS
    $patternCss = "(?s)(\.product-page\s*\{\s*padding:\s*0;)\s*padding-bottom:\s*90px;(\s*\})"
    $newContent = $newContent -replace $patternCss, '$1$2'
    
    Set-Content $file.FullName $newContent
}
