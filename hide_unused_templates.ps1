$templatesDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"
$backupDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates_backup"

if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# The files we strictly want to KEEP in the templates directory to appear in the dropdown
$keepProducts = @(
    "product.tranexamic-serum-v2.liquid",
    "product.anti-acne.liquid",
    "product.anti-acne-serum-v2.liquid",
    "product.hair-mist-v2.liquid",
    "product.keratin-serum-v2.liquid",
    "product.glow-serum.liquid",
    "product.sunscreen-v2.liquid",
    "product.face-wash.liquid",
    "product.night-cream.liquid",
    "product.json" # Default product fallback
)

# Get all product.* files in templates
$productFiles = Get-ChildItem -Path "$templatesDir\product.*"

foreach ($file in $productFiles) {
    if ($keepProducts -notcontains $file.Name) {
        # This product file is NOT in the active UI list. Move it to backup using git.
        $target = "$backupDir\$($file.Name)"
        git mv $file.FullName $target
        Write-Host "Hidden: $($file.Name)"
    }
}
Write-Host "Cleanup complete."
