$templatesDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"
$files = Get-ChildItem -Path $templatesDir -Filter "*.liquid"
foreach ($file in $files) {
    # Read first 3000 chars to cover the title area
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    $title = "Unknown"
    if ($content -match 'class="product-title">(.*?)</h1>') {
        $title = $matches[1] -replace '<br>', ' '
    } elseif ($content -match '<title>(.*?)</title>') {
        $title = $matches[1] -replace ' \| elaris7', ''
    }
    
    $subtitle = ""
    if ($content -match 'class="product-subtitle">(.*?)</span>') {
        $subtitle = $matches[1]
    }
    
    Write-Host "$($file.Name) | $title | $subtitle"
}
