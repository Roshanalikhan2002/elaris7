
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

$priceMap = @{
    "night-cream" = "2,675"
    "tranexamic-serum-v2" = "2,740"
    "keratin-serum-v2" = "2,680"
    "glow-serum" = "2,645"
    "glutathione-cream-v2" = "2,640"
    "hair-mist-v2" = "2,960"
    "face-wash" = "2,620"
    "anti-acne-serum-v2" = "2,755"
    "sunscreen-v2" = "2,735"
    "renewal-cleanser-v2" = "2,820"
    "moisturizer" = "2,680"
    "renewal-toner-v2" = "2,780"
}

$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Re-aligning $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # 1. Update Price in Add to Cart button
    $handle = $file.Name -replace "product\.", "" -replace "\.liquid", ""
    if ($priceMap.ContainsKey($handle)) {
        $price = $priceMap[$handle]
        $content = $content -replace '(ADD TO CART - <span>Rs\.\s*)([\d,]+)(</span>)', "`${1}${price}`$3"
    }

    # 2. Update BOGO selection list
    if ($content -match '(?s)<div class="bogo-inline-section">.*?</div>\s*</div>') {
        $content = $content -replace '(?s)<div class="bogo-inline-section">.*?</div>\s*</div>', $all12BogoHtml
    }

    # 3. Fix Product Actions Grid (Remove BOGO button, set 1 column)
    $content = $content -replace '<button class="buy-button bogo-btn" id="bogoAddToCart">BUY 1 GET 1 FREE</button>', ""
    $content = $content -replace 'grid-template-columns: 1fr 1fr;', 'grid-template-columns: 1fr;'
    
    # 4. Accordion Spacing & Styling (Clean approach)
    $content = $content.Replace('.accordion-item {', ".accordion-item { border-top: 1px solid rgba(0,0,0,0.05);")
    $content = $content.Replace('padding: 18px 0;', 'padding: 8px 0;') # Reduction of outer padding
    if ($content -match '(\.accordion-item summary\s*\{)') {
        if (-not $content.Contains('padding: 24px 0;')) {
             $content = $content -replace '(\.accordion-item summary\s*\{)', "`$1`n              padding: 24px 0;"
        }
    }

    # 5. Fix Javascript for Add to Cart Button (Merge BOGO logic)
    # Restore the handle mapping block
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
    if ($content -match '(?s)const handleToIdMap = \{.*?\};') {
        $content = $content -replace '(?s)const handleToIdMap = \{.*?\};', $newHandleToIdMap
    }

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
    # Replace the existing add-to-cart-btn event listener
    $content = $content -replace '(?s)document\.querySelector\(''\.add-to-cart-btn''\)\?\.addEventListener\(''click''.*?\}\);', $newAddToCartScript

    # 6. Ensure everything is inside product-details
    # Clean up any broken divs from previous turns
    # If there are consecutive </div></div></div>, this is a sign of breakage
    $content = $content.Replace("</div>`n          </div>`n        </div>", "</div>") # This is a risky cleanup but might be necessary

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Cleanup and Realignment complete!"
