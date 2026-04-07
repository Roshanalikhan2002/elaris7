$source = "templates/product.luxury.json"
$handles = @(
  'keratin-serum',
  'glow-serum',
  'glutathione-cream',
  'hair-mist',
  'face-wash',
  'anti-acne-serum',
  'sunscreen',
  'renewal-cleanser',
  'hydra-burst-moisturizer',
  'renewal-toner',
  'anti-frizz-serum',
  'hair-regrowth-spray'
)

$content = Get-Content $source -Raw
foreach ($handle in $handles) {
  $target = "templates/product.$handle.json"
  $content | Out-File -FilePath $target -Encoding utf8
  Write-Host "Created $target"
}
