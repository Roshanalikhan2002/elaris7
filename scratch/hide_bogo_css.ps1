
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Hiding BOGO components in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    $hideCSS = ".bogo-inline-section, .bogo-btn, #bogoDrawer, #bogoOverlay { display: none !important; }`n"
    
    # Prepend to the first </style> tag
    if ($content -like "*</style>*" -and -not $content.Contains('.bogo-inline-section { display: none !important; }')) {
        $content = $content -replace "</style>", ($hideCSS + "</style>")
    }

    Set-Content -Path $file.FullName -Value $content
}
