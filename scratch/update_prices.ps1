
$prices = @{
    "night-cream" = "2,675";
    "tranexamic-serum" = "2,740";
    "anti-frizz-keratin-serum" = "2,680";
    "glow-serum" = "2,645";
    "glutathione-cream" = "2,640";
    "floral-blossom-hair-mist" = "2,960";
    "face-wash" = "2,620";
    "anti-acne" = "2,755";
    "sunscreen" = "2,735";
    "renewal-cleanser" = "2,820";
    "moisturizer" = "2,680";
    "renewal-toner" = "2,780";
}

$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Processing $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # 1. Update the MAIN price (e.g., ADD TO CART - Rs. XXXX)
    # We find the file base name to know which price to use
    $baseName = $file.BaseName.Replace("product.", "").Replace("-v2", "")
    if ($prices.ContainsKey($baseName)) {
        $newPrice = $prices[$baseName]
        Write-Host "  Updating main price for $baseName to $newPrice"
        
        # Replace Rs. or RS. followed by 4 digits (with comma usually)
        # Using a regex that finds the price inside the add-to-cart area
        $content = $content -replace "(ADD TO CART - <span>)(Rs\.|RS\.)\s*[0-9,]+(</span>)", "`$1Rs. $newPrice`$3"
        $content = $content -replace "(ADD TO BAG - )(Rs\.|RS\.)\s*[0-9,]+", "`$1RS. $newPrice"
    }

    # 2. Update the "Cards" price at the bottom (Static cards)
    # This is trickier because the cards have different handles
    foreach ($h in $prices.Keys) {
        $targetPrice = $prices[$h]
        # Match BUY - RS. 1,500 for that specific handle
        # We look for the handle link then the buy-pill
        $content = $content -replace "(href=""/products/$h"".*?BUY - )(Rs\.|RS\.)\s*[0-9,]+", "`$1RS. $targetPrice"
        # Also match the hover cta text
        $content = $content -replace "(BUY " + $h.ToUpper().Split("-")[0] + ".*? - )(Rs\.|RS\.)\s*[0-9,]+", "`$1RS. $targetPrice"
    }

    # Final common polish: replace any remaining RS. 1,500 with something sensible? 
    # No, let's keep it specific.

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Update complete!"
