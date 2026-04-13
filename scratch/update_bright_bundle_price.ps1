
$filePath = "templates/product.bright-bundle.liquid"
$content = [IO.File]::ReadAllText($filePath)

$content = $content.Replace("BUY THE KIT - RS. 4,500", "BUY THE KIT - RS. 5,392")
$content = $content.Replace("or 4 payments of RS. 1,125", "or 4 payments of RS. 1,348")

[IO.File]::WriteAllText($filePath, $content)
Write-Host "Replaced prices in Bright Bundle template successfully."
