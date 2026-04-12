
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Unwrapping name in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # regex to find the product title block and remove <br> tags inside it
    if ($content -match '(<h1 class="product-title">)(.*?)(</h1>)') {
        $titleBlock = $matches[0]
        $cleanTitle = $titleBlock -replace '<br\s*/?>', ' '
        # Remove extra spaces if any
        $cleanTitle = $cleanTitle -replace '\s+', ' '
        
        # Replace the original block with the cleaned one
        $content = $content.Replace($titleBlock, $cleanTitle)
        
        Write-Host "  Success: Cleaned title."
    } else {
        Write-Host "  Warning: Title tag not found."
    }

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Title unwrapping complete!"
