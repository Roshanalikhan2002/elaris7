
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Aggressively removing BOGO from $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # 1. Remove the BOGO Selection Section (Radio cards etc)
    # Match the div with bogo-inline-section
    $content = $content -replace "(?s)<div class=""bogo-inline-section"">.*?</div>\s*</div>", ""
    
    # 2. Remove the BOGO Button inside the actions grid
    $content = $content -replace '<button class="buy-button bogo-btn".*?>BUY 1 GET 1 FREE</button>', ""
    
    # 3. Fix the actions grid structure
    # Change grid to 1 column
    $content = $content -replace 'grid-template-columns: 1fr 1fr;', 'grid-template-columns: 1fr;'
    # Force Add to Cart to 100% width and remove any floating styles
    $content = $content -replace '(<button class="buy-button add-to-cart-btn" style="white-space: nowrap;)', '$1 width: 100%;'

    # 4. Remove BOGO Styles and Scripts
    $content = $content -replace "(?s)<style>.*?\.bogo-inline-section.*?</style>", ""
    $content = $content -replace "(?s)<script>.*?function selectBogo.*?</script>", ""
    $content = $content -replace "(?s)<script>.*?const openBogo = document.getElementById\('openBogo'\).*?</script>", ""

    # 5. Remove BOGO Drawer and Overlay
    $content = $content -replace "(?s)<div id=""bogoDrawer"".*?</div>\s*</div>", ""
    $content = $content -replace '<div id="bogoOverlay".*?></div>', ""

    # Final polish: make sure the Add to Cart button looks good alone
    $content = $content -replace 'width: 100%; width: 100%;', 'width: 100%;'

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "BOGO removal complete!"
