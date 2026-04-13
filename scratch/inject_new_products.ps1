# PowerShell script to inject the 3 new products permanently into the product scroll
$f = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\sections\featured-products.liquid"
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Define the HTML for the 3 new cards
$newCardsHtml = @"
    <!-- NEW PRODUCTS (Hardcoded to ensure they show up even with blocks) -->
    <!-- Oil to Foam Cleanser -->
    <div class="card card-rhode" data-category="korean-glass-skin">
      <a href="/products/oil-to-foam-cleanser" class="card-link-wrapper">
        <img src="{{ 'facewash2.jpg' | asset_url }}" class="card-hover-bg" alt="Oil to Foam Cleanser Hover">
        <div class="card-rhode-top">
          <span class="card-brand-label">korean-glass-skin</span>
          <span class="card-badge">NEW</span>
        </div>
        <div class="card-rhode-image">
          <img src="{{ 'facewash1.jpeg' | asset_url }}" alt="Oil to Foam Cleanser" class="product-main-img">
        </div>
        <div class="card-rhode-footer">
          <div class="card-meta">
            <div class="card-stars">★★★★★ <span class="review-count">(12k)</span></div>
            <h3 class="card-name">OIL TO FOAM CLEANSER</h3>
          </div>
          <span class="btn-rhode-buy-pill">BUY - RS. 2,620</span>
        </div>
        <div class="buy-button-hover" data-handle="oil-to-foam-cleanser" onclick="window.location.href='/products/oil-to-foam-cleanser'">
          BUY OIL TO FOAM CLEANSER - RS. 2,620
        </div>
      </a>
    </div>

    <!-- Gel Cleanser -->
    <div class="card card-rhode" data-category="korean-brightening">
      <a href="/products/gel-cleanser" class="card-link-wrapper">
        <img src="{{ 'deep-hydration-facewash.jpg' | asset_url }}" class="card-hover-bg" alt="Gel Cleanser Hover">
        <div class="card-rhode-top">
          <span class="card-brand-label">korean-brightening</span>
          <span class="card-badge">NEW</span>
        </div>
        <div class="card-rhode-image">
          <img src="{{ 'gel cleanser-100.jpg' | asset_url }}" alt="Gel Cleanser" class="product-main-img">
        </div>
        <div class="card-rhode-footer">
          <div class="card-meta">
            <div class="card-stars">★★★★★ <span class="review-count">(8k)</span></div>
            <h3 class="card-name">GEL CLEANSER</h3>
          </div>
          <span class="btn-rhode-buy-pill">BUY - RS. 2,620</span>
        </div>
        <div class="buy-button-hover" data-handle="gel-cleanser" onclick="window.location.href='/products/gel-cleanser'">
          BUY GEL CLEANSER - RS. 2,620
        </div>
      </a>
    </div>

    <!-- Hair Regrow Spray -->
    <div class="card card-rhode" data-category="hair-care">
      <a href="/products/hair-regrow-spray" class="card-link-wrapper">
        <img src="{{ 'hair-mist-hover.jpg' | asset_url }}" class="card-hover-bg" alt="Hair Regrow Spray Hover">
        <div class="card-rhode-top">
          <span class="card-brand-label">hair-care</span>
          <span class="card-badge">NEW</span>
        </div>
        <div class="card-rhode-image">
          <img src="{{ 'hair-mist.jpg' | asset_url }}" alt="Hair Regrow Spray" class="product-main-img">
        </div>
        <div class="card-rhode-footer">
          <div class="card-meta">
            <div class="card-stars">★★★★★ <span class="review-count">(10k)</span></div>
            <h3 class="card-name">HAIR REGROW SPRAY</h3>
          </div>
          <span class="btn-rhode-buy-pill">BUY - RS. 2,960</span>
        </div>
        <div class="buy-button-hover" data-handle="hair-regrow-spray" onclick="window.location.href='/products/hair-regrow-spray'">
          BUY HAIR REGROW SPRAY - RS. 2,960
        </div>
      </a>
    </div>
"@

# Inject after <div class="product-collection" id="product-collection-scroll">
$c = $c -replace '(<div class="product-collection" id="product-collection-scroll">)', "$1`n$newCardsHtml"

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "Permanently injected 3 new products into featured-products.liquid"
