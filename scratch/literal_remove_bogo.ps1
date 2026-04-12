
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Updating $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # EXACT strings to remove/replace
    $bogoButton = '<button class="buy-button bogo-btn" id="bogoAddToCart">BUY 1 GET 1 FREE</button>'
    $bogoButton2 = '<button class="buy-button bogo-btn" id="openBogo">BUY 1 GET 1 FREE</button>'
    
    $content = $content.Replace($bogoButton, "")
    $content = $content.Replace($bogoButton2, "")
    
    # Fix the grid
    $content = $content.Replace('grid-template-columns: 1fr 1fr;', 'grid-template-columns: 1fr;')
    
    # Expand Add to Cart button
    $content = $content.Replace('<button class="buy-button add-to-cart-btn" style="white-space: nowrap;">', '<button class="buy-button add-to-cart-btn" style="white-space: nowrap; width: 100%;">')

    # Add a style to hide the bogo section (safest)
    if ($content.Contains('product-actions-grid') -and -not $content.Contains('display: none !important;')) {
        $hideStyle = "`n<style>.bogo-inline-section { display: none !important; }</style>`n"
        $content = $content.Replace('<div class="product-actions-grid">', $hideStyle + '<div class="product-actions-grid">')
    }

    Set-Content -Path $file.FullName -Value $content
}
