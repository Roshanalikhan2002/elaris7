
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Cleaning BOGO from $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # 1. Remove BOGO Styles
    # Pattern: <style> with .bogo-inline-section
    $content = $content -replace "(?s)<style>.*?\.bogo-inline-section.*?</style>", ""
    
    # 2. Remove BOGO Styles for buttons
    # Pattern: .bogo-btn
    $content = $content -replace "(?s)<style>.*?\.bogo-btn.*?</style>", ""

    # 3. Remove BOGO Selection Area and Scripts
    # We remove everything between the bogo style and the action grid if possible, or just the blocks
    $content = $content -replace "(?s)<script>.*?function selectBogo.*?</script>", ""
    $content = $content -replace "(?s)<div class=""bogo-inline-section"">.*?</div>", "" # If it exists as a div
    
    # 4. Filter the Action Grid to remove BOGO Button
    # Removing the BOGO button and changing grid to 1 column
    $content = $content -replace "<button class=""buy-button bogo-btn"".*?</button>", ""
    $content = $content -replace "grid-template-columns: 1fr 1fr;", "grid-template-columns: 1fr;"
    
    # 5. Remove BOGO Drawer and Overlay if present
    # Pattern: id="bogoDrawer"
    $content = $content -replace "(?s)<div id=""bogoDrawer"".*?</div>\s*</div>", "" # This might be fragile
    $content = $content -replace "<div id=""bogoOverlay"".*?</div>", ""
    $content = $content -replace "(?s)<script>.*?const openBogo = document.getElementById\('openBogo'\).*?</script>", ""
    
    # Remove any stray "Select" cards
    $content = $content -replace "(?s)<div class=""bogo-inline-card"".*?</div>", ""

    # Cleanup any empty style tags or extra whitespace
    $content = $content -replace "<style>\s*</style>", ""

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "BOGO removal complete!"
