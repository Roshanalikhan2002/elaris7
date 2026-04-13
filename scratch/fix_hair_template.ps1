# PowerShell script to surgically update the Hair Regrow Spray template
$f = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates\product.hair-regrow-spray.liquid"
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Restore from a clean copy of hair-mist-v2 first
$base = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates\product.hair-mist-v2.liquid"
$c = [System.IO.File]::ReadAllText($base, [System.Text.Encoding]::UTF8)

# 1. Update Title
$c = $c.Replace("<title>Hair Mist | elaris7</title>", "<title>Hair Regrow Spray | elaris7</title>")

# 2. Update Product Name and Subtitle
$oldHeader = @"
          <div class="product-header">
            <h1 class="product-title">Hair Mist</h1>
          </div>

          <div class="product-meta">
            <span class="product-subtitle">Fresh Floral Touch</span>
            <p class="disclaimer">*with continued daily use</p>
          </div>
"@

$newHeader = @"
          <div class="product-header">
            <h1 class="product-title">Hair Regrow Spray</h1>
          </div>

          <div class="product-meta">
            <span class="product-subtitle">Follicle Revive</span>
            <div class="product-description" style="margin-top: 20px; font-size: 0.95rem; color: #5b5a53; line-height: 1.6;">
              <p>A potent, targeted scalp treatment designed to stimulate follicles, promote thicker-looking hair, and support a healthy scalp environment for visible regrowth and vitality.</p>
            </div>
            <p class="disclaimer">*with continued daily use</p>
          </div>
"@

# Note: Using .Replace() for literal match
$c = $c.Replace($oldHeader, $newHeader)

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "Manually restored and updated Hair Regrow Spray"
