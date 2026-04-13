$files = @('templates\product.bright-bundle.liquid', 'templates\product.hair-bundle.liquid')
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText("c:\Users\MY PC\OneDrive\Desktop\Elaris7\$f", [System.Text.Encoding]::UTF8)
    $name = Split-Path $f -Leaf
    Write-Host "=== $name ===" -ForegroundColor Cyan
    if ($c -match 'layout none')     { Write-Host '[FAIL] layout none still present' -ForegroundColor Red } else { Write-Host '[OK] layout none removed' -ForegroundColor Green }
    if ($c -match '<!DOCTYPE')       { Write-Host '[FAIL] DOCTYPE still present' -ForegroundColor Red }    else { Write-Host '[OK] DOCTYPE removed' -ForegroundColor Green }
    if ($c -match '<body')           { Write-Host '[FAIL] body tag still present' -ForegroundColor Red }   else { Write-Host '[OK] body tag removed' -ForegroundColor Green }
    if ($c -match "section 'header'") { Write-Host '[FAIL] manual section header present' -ForegroundColor Red } else { Write-Host '[OK] manual section header gone' -ForegroundColor Green }
    if ($c -match 'pdp-wrapper')     { Write-Host '[OK] pdp-wrapper content present' -ForegroundColor Green } else { Write-Host '[FAIL] pdp-wrapper missing' -ForegroundColor Red }
    if ($c -match '<style>')         { Write-Host '[OK] styles present' -ForegroundColor Green }           else { Write-Host '[WARN] no styles' -ForegroundColor Yellow }
    Write-Host ''
}
