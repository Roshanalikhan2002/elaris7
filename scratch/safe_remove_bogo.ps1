
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Removing BOGO from $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # Remove the BOGO button inside the actions grid
    # We match the specific button class and text
    $content = $content -replace '<button class="buy-button bogo-btn".*?>BUY 1 GET 1 FREE</button>', ""
    
    # Change the grid from 2 columns to 1 column
    $content = $content -replace 'grid-template-columns: 1fr 1fr;', 'grid-template-columns: 1fr;'
    
    # Expand the Add to Cart button to 100% width
    $content = $content -replace '(<button class="buy-button add-to-cart-btn" style="white-space: nowrap;)', '$1 width: 100%;'

    # Hide the BOGO selection area using CSS override (Safest way to deal with varying HTML)
    # We append a small style tag before the product grid
    if ($content -like "*product-actions-grid*") {
        $hideStyle = "`n<style>.bogo-inline-section, .bogo-btn, #bogoDrawer, #bogoOverlay { display: none !important; }</style>`n"
        $content = $content -replace '<div class="product-actions-grid">', ($hideStyle + '<div class="product-actions-grid">')
    }

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "BOGO removal complete!"
