$f1 = 'c:\Users\MY PC\OneDrive\Desktop\Elaris7\sections\product-luxury-detail.liquid'
$f2 = 'c:\Users\MY PC\OneDrive\Desktop\Elaris7\sections\cart-luxury.liquid'

Write-Host '=== product-luxury-detail.liquid ===' -ForegroundColor Cyan
$c1 = [System.IO.File]::ReadAllText($f1, [System.Text.Encoding]::UTF8)

if ($c1 -match 'first_available_variant') { Write-Host '[OK] Gift radio uses variant ID' -ForegroundColor Green } else { Write-Host '[FAIL] Gift radio variant ID missing' -ForegroundColor Red }
if ($c1 -match 'bogoAddToCart')           { Write-Host '[OK] bogoAddToCart function present' -ForegroundColor Green } else { Write-Host '[FAIL] bogoAddToCart missing' -ForegroundColor Red }
if ($c1 -match 'cart/add\.js')            { Write-Host '[OK] Cart API call present' -ForegroundColor Green } else { Write-Host '[FAIL] Cart API missing' -ForegroundColor Red }
if ($c1 -match '_free_gift')              { Write-Host '[OK] Free gift property set' -ForegroundColor Green } else { Write-Host '[FAIL] Free gift property missing' -ForegroundColor Red }

Write-Host ''
Write-Host '=== cart-luxury.liquid ===' -ForegroundColor Cyan
$c2 = [System.IO.File]::ReadAllText($f2, [System.Text.Encoding]::UTF8)

if ($c2 -match 'is_free_gift')    { Write-Host '[OK] Free gift detection in cart' -ForegroundColor Green } else { Write-Host '[FAIL] Free gift detection missing' -ForegroundColor Red }
if ($c2 -match 'lux-free-badge')  { Write-Host '[OK] FREE badge CSS class' -ForegroundColor Green } else { Write-Host '[FAIL] Badge CSS missing' -ForegroundColor Red }
if ($c2 -match 'paid_total')      { Write-Host '[OK] paid_total used for price calc' -ForegroundColor Green } else { Write-Host '[FAIL] paid_total missing' -ForegroundColor Red }
if ($c2 -match 'lux-gift-item')   { Write-Host '[OK] Gift item row style' -ForegroundColor Green } else { Write-Host '[FAIL] Gift item style missing' -ForegroundColor Red }
if ($c2 -match 'Included')        { Write-Host '[OK] Free Gift row in summary' -ForegroundColor Green } else { Write-Host '[FAIL] Free Gift summary row missing' -ForegroundColor Red }

Write-Host ''
Write-Host 'All checks complete.' -ForegroundColor Cyan
