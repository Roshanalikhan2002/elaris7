
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Fixing double closure in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # Remove doubled closure
    $content = $content.Replace("            });`n            });", "            });")
    $content = $content.Replace("            });`r`n            });", "            });")

    Set-Content -Path $file.FullName -Value $content
}
