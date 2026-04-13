$file = 'c:\Users\MY PC\OneDrive\Desktop\Elaris7\sections\product-luxury-detail.liquid'
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# Fix 1: gift radio value — product ID → first_available_variant ID
$old1 = 'value="{{ gift_prod.id }}"'
$new1 = 'value="{{ gift_prod.first_available_variant.id }}"'
if ($content.Contains($old1)) {
    $content = $content.Replace($old1, $new1)
    Write-Host "Fixed: gift radio now uses first_available_variant.id"
} else {
    Write-Host "WARN: Could not find gift_prod.id pattern - checking file..."
    $lines = $content -split "`n"
    $found = $lines | Where-Object { $_ -match 'free_gift|gift_prod' }
    $found | ForEach-Object { Write-Host "  >>> $_" }
}

[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
Write-Host "Done. File saved."
