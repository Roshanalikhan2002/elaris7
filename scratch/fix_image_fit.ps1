
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    $content = Get-Content -Path $file -Raw
    
    # Force the image to completely fill the gallery viewport, fixing the white space issue.
    # Update gallery-slide img from max-width/max-height contain to width/height cover
    $patternImg = '(?s)(\.gallery-slide img\s*\{.*?)(?:max-width:\s*100%;\s*max-height:\s*100%;\s*object-fit:\s*contain;)(.*?\})'
    $replacementImg = '$1width: 100%;`n        height: 100%;`n        object-fit: cover;$2'
    
    if ($content -match $patternImg) {
        $content = [regex]::Replace($content, $patternImg, $replacementImg)
    } else {
        # Fallback if it was partially modified
        $patternImgFallback = '(?s)(\.gallery-slide img\s*\{[^\}]*?\})'
        # We can just surgical replace inside the matched block
        $content = [regex]::Replace($content, 'max-width:\s*100%;', 'width: 100%;')
        $content = [regex]::Replace($content, 'max-height:\s*100%;', 'height: 100%;')
        $content = [regex]::Replace($content, 'object-fit:\s*contain;', 'object-fit: cover;')
    }

    Set-Content -Path $file -Value $content
}
Write-Host "Updated image fitting across all templates."
