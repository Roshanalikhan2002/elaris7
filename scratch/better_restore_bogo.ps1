
$all12BogoHtml = @"
          <div class="bogo-inline-section">
            <p class="bogo-inline-title">SELECT YOUR FREE GIFT (BUY 1 GET 1)</p>
            <div class="bogo-vertical-scroll">
              
              <div class="bogo-inline-card selected" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="night-cream" style="display:none;" checked>
                <img src="{{ 'night-cream-suite.jpeg' | asset_url }}" alt="Centella Night Cream">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Centella Night Cream</span>
                  <span class="bogo-inline-tag">Night Renewal</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="face-wash" style="display:none;">
                <img src="{{ 'facewash1.jpeg' | asset_url }}" alt="Centella Face Wash">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Centella Face Wash</span>
                  <span class="bogo-inline-tag">Pure Start</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="glow-serum" style="display:none;">
                <img src="{{ 'glowserum-1.png' | asset_url }}" alt="Centella Serum">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Centella Serum</span>
                  <span class="bogo-inline-tag">Radiance Reset</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="sunscreen-v2" style="display:none;">
                <img src="{{ 'v2-sunscreen-1.jpeg' | asset_url }}" alt="Centella Sunscreen SPF60+">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Centella Sunscreen SPF60+</span>
                  <span class="bogo-inline-tag">Daily Shield</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="tranexamic-serum-v2" style="display:none;">
                <img src="{{ 'TranexamicSerum1.jpg' | asset_url }}" alt="Tranexamic Brightening Serum">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Tranexamic Brightening Serum</span>
                  <span class="bogo-inline-tag">Even & Illuminate</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="anti-acne-serum-v2" style="display:none;">
                <img src="{{ 'v2-antiacne-1.jpeg' | asset_url }}" alt="Anti-Acne Clarifying Serum">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Anti-Acne Clarifying Serum</span>
                  <span class="bogo-inline-tag">Clear & Control</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="glutathione-cream-v2" style="display:none;">
                <img src="{{ 'v2-glutathione-1.jpeg' | asset_url }}" alt="Glutathione Brightening Cream">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Glutathione Brightening Cream</span>
                  <span class="bogo-inline-tag">Radiance Reset</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="renewal-toner-v2" style="display:none;">
                <img src="{{ 'toner1.jpeg' | asset_url }}" alt="Renewal Toner">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Renewal Toner</span>
                  <span class="bogo-inline-tag">Hydration Lock</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="renewal-cleanser-v2" style="display:none;">
                <img src="{{ 'gel cleanser-100.jpg' | asset_url }}" alt="Renewal Cleanser">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Renewal Cleanser</span>
                  <span class="bogo-inline-tag">Gentle Purify</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="keratin-serum-v2" style="display:none;">
                <img src="{{ 'keratin-serum.jpg' | asset_url }}" alt="Anti-Frizz Keratin Serum">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Anti-Frizz Keratin Serum</span>
                  <span class="bogo-inline-tag">Smooth & Shine</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="hair-mist-v2" style="display:none;">
                <img src="{{ 'hair-mist.jpg' | asset_url }}" alt="Floral Blossom Hair Mist">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Floral Blossom Hair Mist</span>
                  <span class="bogo-inline-tag">Fresh Scent</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>

              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="moisturizer" style="display:none;">
                <img src="{{ 'moisturizer-100.jpg' | asset_url }}" alt="Hydra Burst Moisturizer">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Hydra Burst Moisturizer</span>
                  <span class="bogo-inline-tag">Deep Moisture</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>
            </div>
          </div>
"@

$newHandleToIdMap = @"
            const handleToIdMap = {
                'glow-serum': '{{ all_products["glow-serum"].variants.first.id }}',
                'sunscreen-v2': '{{ all_products["sunscreen-v2"].variants.first.id }}',
                'face-wash': '{{ all_products["face-wash"].variants.first.id }}',
                'tranexamic-serum-v2': '{{ all_products["tranexamic-serum-v2"].variants.first.id }}',
                'anti-acne-serum-v2': '{{ all_products["anti-acne-serum-v2"].variants.first.id }}',
                'night-cream': '{{ all_products["night-cream"].variants.first.id }}',
                'glutathione-cream-v2': '{{ all_products["glutathione-cream-v2"].variants.first.id }}',
                'renewal-toner-v2': '{{ all_products["renewal-toner-v2"].variants.first.id }}',
                'renewal-cleanser-v2': '{{ all_products["renewal-cleanser-v2"].variants.first.id }}',
                'keratin-serum-v2': '{{ all_products["keratin-serum-v2"].variants.first.id }}',
                'hair-mist-v2': '{{ all_products["hair-mist-v2"].variants.first.id }}',
                'moisturizer': '{{ all_products["moisturizer"].variants.first.id }}'
            };
"@

$newAddToCartScript = @"
            document.querySelector('.add-to-cart-btn')?.addEventListener('click', function(e) {
                e.preventDefault();
                const mainVariantId = "{{ product.variants.first.id }}";
                const selectedGift = document.querySelector('input[name="free_gift"]:checked');
                let items = [];

                if (selectedGift) {
                    const giftHandle = selectedGift.getAttribute('data-gift-handle');
                    const giftVariantId = handleToIdMap[giftHandle];
                    
                    if (giftVariantId) {
                        items = [
                            { id: mainVariantId, quantity: 1, properties: { '_bogo': 'true' } },
                            { id: giftVariantId, quantity: 1, properties: { '_bogo': 'true' } }
                        ];
                    } else {
                        items = [{ id: mainVariantId, quantity: 1 }];
                    }
                } else {
                    items = [{ id: mainVariantId, quantity: 1 }];
                }
                
                fetch('/cart/add.js', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ items: items })
                })
                .then(response => response.json())
                .then(data => { window.location.href = '/cart'; })
                .catch(error => { alert('Error adding to cart.'); });
            });
"@

$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Updating $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # 1. CLEANUP BOGO Section
    # Find the whole section from <div class="bogo-inline-section"> to the next </div>\s*</div>
    if ($content -match '(?s)<div class="bogo-inline-section">.*?</div>\s*</div>') {
        $content = $content -replace '(?s)<div class="bogo-inline-section">.*?</div>\s*</div>', $all12BogoHtml
    }

    # 2. Add To Cart Script replacement
    # Match from document.querySelector('.add-to-cart-btn') to });
    if ($content -match '(?s)document\.querySelector\(''\.add-to-cart-btn''\)\?\.addEventListener\(''click''.*?\}\);') {
        $content = $content -replace '(?s)document\.querySelector\(''\.add-to-cart-btn''\)\?\.addEventListener\(''click''.*?\}\);', $newAddToCartScript
    }

    # 3. HandleToIdMap replacement
    if ($content -match '(?s)const handleToIdMap = \{.*?\};') {
        $content = $content -replace '(?s)const handleToIdMap = \{.*?\};', $newHandleToIdMap
    }

    # 4. CSS Fixes (Accordions)
    # Target spacing properly
    $content = $content.Replace('.accordion-item {', ".accordion-item {`n              margin-bottom: 8px; border-top: 1px solid rgba(0,0,0,0.05);")
    $content = $content.Replace('.accordion-item summary {', ".accordion-item summary {`n              padding: 22px 0;")
    
    # 5. Remove the global hide style
    $content = $content.Replace('.bogo-inline-section, .bogo-btn, #bogoDrawer, #bogoOverlay { display: none !important; }', '.bogo-btn, #bogoDrawer, #bogoOverlay { display: none !important; }')

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Restoration complete!"
