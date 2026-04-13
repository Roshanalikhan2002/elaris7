
$files = Get-ChildItem -Path "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates" -Filter "product.*.liquid" | Select-String -Pattern "bogo-inline-section" | Select-Object -ExpandProperty Path -Unique

$bogoHtml = @"
          <div class="bogo-inline-section">
            <div class="bogo-header">
               <svg class="bogo-gift-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 12v10H4V12M2 7h20v5H2zM12 22V7M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7zM12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"/></svg>
               <p class="bogo-inline-title">Choose your item</p>
            </div>
            <div class="bogo-vertical-scroll">
              <div class="bogo-inline-card selected" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="oil-to-foam-cleanser" style="display:none;" checked>
                <div class="bogo-img-box"><img src="{{ 'oil-to-foam-main.jpg' | asset_url }}" alt="Oil to Foam Cleanser"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Oil to Foam Cleanser</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,820</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="gel-cleanser" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'gel cleanser-100.jpg' | asset_url }}" alt="Gel Cleanser"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Gel Cleanser</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,620</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="hair-regrow-spray" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'hair-regrow-main.jpeg' | asset_url }}" alt="Hair Regrow Spray"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Hair Regrow Spray</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,790</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="e7-korean-glass-skin-centella-night-cream-copy" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'night-cream.jpg' | asset_url }}" alt="Night Cream"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Night Cream</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,675</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="tranexamic-serum-v2" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'tranexamic-serum.jpg' | asset_url }}" alt="Tranexamic Serum"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Tranexamic Serum</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,740</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="keratin-serum-v2" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'keratin-serum.jpg' | asset_url }}" alt="Anti Frizz Keratin Serum"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Anti Frizz Keratin Serum</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,680</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="centella-serum" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'glow-serum-100.jpg' | asset_url }}" alt="Glow Serum"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Glow Serum</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,645</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="glutathione-cream-v2" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'glutathione-cream-100.jpg' | asset_url }}" alt="Glutathione Cream"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Glutathione Cream</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,640</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="hair-mist-v2" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'hair-mist.jpg' | asset_url }}" alt="Floral Blossom Hair Mist"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Floral Blossom Hair Mist</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,960</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="e7-korean-glass-skin-centella-face-wash-copy" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'facewash-100.jpg' | asset_url }}" alt="Face Wash"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Face Wash</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,620</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="anti-acne-serum-v2" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'anti-acne-100.jpg' | asset_url }}" alt="Anti Acne"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Anti Acne</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,755</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="e7-korean-glass-skin-centella-sunscreen-spf50-copy" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'sunscreen-100.jpg' | asset_url }}" alt="Sunscreen SPF60+"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Sunscreen SPF60+</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,735</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="renewal-cleanser-v2" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'renewal-cleanser-1.jpg' | asset_url }}" alt="Renewal Cleanser"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Renewal Cleanser</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,820</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="e7-korean-glass-skin-moisturizer" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'moisturizer-100.jpg' | asset_url }}" alt="Hydra Burst Moisturizer"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Hydra Burst Moisturizer</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,680</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <div class="bogo-radio"></div>
                <input type="radio" name="free_gift" data-gift-handle="centella-skin-toner-copy" style="display:none;">
                <div class="bogo-img-box"><img src="{{ 'toner1.jpeg' | asset_url }}" alt="Renewal Toner"></div>
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">Renewal Toner</span>
                  <div class="bogo-price-line"><span class="bogo-old-price">Rs. 2,780</span><span class="bogo-free-tag">FREE</span></div>
                </div>
              </div>
            </div>
          </div>

          <div class="product-actions-grid">
            <button class="buy-button add-to-cart-btn" style="white-space: nowrap; width: 100%;">ADD TO CART - <span>{{ product.price | money_without_trailing_zeros }}</span></button>
          </div>

          <style>
            .product-actions-grid { display: grid; grid-template-columns: 1fr; gap: 12px; margin-bottom: 30px; }
            .add-to-cart-btn { background-color: #002d5f !important; color: #fff !important; padding: 15px !important; border-radius: 50px !important; border: none; font-weight: 800; cursor: pointer; }
            .accordion-item { border-top: 1px solid rgba(0,0,0,0.05); border-bottom: 1px solid rgba(0,0,0,0.1); padding: 5px 0; margin-bottom: 5px; }
            .accordion-item summary { padding: 20px 0; display: flex; justify-content: space-between; cursor: pointer; font-weight: 700; font-size: 0.85rem; color: #5b5a53; list-style: none; }
            .accordion-item summary::-webkit-details-marker { display: none; }
            .accordion-item[open] summary span:last-child { transform: rotate(45deg); display: inline-block; }
            .accordion-content { padding-top: 15px; font-size: 0.85rem; color: #5b5a53; line-height: 1.5; font-weight: 400; }
            
            .bogo-header { display: flex; align-items: center; gap: 8px; margin-bottom: 15px; padding: 0 5px; }
            .bogo-gift-icon { width: 18px; height: 18px; color: #333; }
            .bogo-inline-title { margin: 0; font-size: 0.85rem; font-weight: 800; color: #333; text-transform: none; }
            
            .bogo-vertical-scroll { display: flex; flex-direction: column; gap: 8px; max-height: 380px; overflow-y: auto; padding-right: 10px; }
            .bogo-vertical-scroll::-webkit-scrollbar { width: 4px; }
            .bogo-vertical-scroll::-webkit-scrollbar-track { background: #f1f1f1; }
            .bogo-vertical-scroll::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }

            .bogo-inline-card { display: flex; align-items: center; gap: 12px; background: #fff; border: 1px solid #e8e8e6; border-radius: 12px; padding: 12px; cursor: pointer; transition: all 0.2s ease; margin-bottom: 2px; }
            .bogo-inline-card.selected { border-color: #5b5a53; background: #fdfdfb; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
            
            .bogo-radio { 
              width: 18px; height: 18px; border: 2px solid #ccc; border-radius: 50%; position: relative; flex-shrink: 0; 
              transition: border-color 0.2s ease;
            }
            .bogo-inline-card.selected .bogo-radio { border-color: #007aff; }
            .bogo-inline-card.selected .bogo-radio::after {
              content: ''; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
              width: 10px; height: 10px; background: #007aff; border-radius: 50%;
            }

            .bogo-img-box { 
              width: 50px; height: 50px; background: #fff; border-radius: 8px; display: flex; 
              align-items: center; justify-content: center; overflow: hidden; border: 1px solid #f0f0f0;
            }
            .bogo-img-box img { width: 100%; height: 100%; object-fit: contain; }

            .bogo-inline-info { flex: 1; display: flex; flex-direction: column; gap: 2px; }
            .bogo-inline-name { font-size: 0.85rem; font-weight: 800; color: #333; line-height: 1.2; }
            
            .bogo-price-line { display: flex; align-items: center; gap: 6px; }
            .bogo-old-price { text-decoration: line-through; color: #999; font-size: 0.75rem; }
            .bogo-free-tag { color: #333; font-weight: 800; font-size: 0.75rem; color: #000; }
          </style>

          <div class="product-accordions accordions">
"@

foreach ($file in $files) {
    $content = Get-Content -Path $file -Raw
    
    # Surgical Replace: Match from the START of bogo-inline-section 
    # to the START of product-accordions accordions
    # This will catch both the new code and any duplicated old code in between.
    $patternClean = '(?s)<div class="bogo-inline-section">.*?<div class="product-accordions accordions">'
    
    if ($content -match $patternClean) {
        $content = [regex]::Replace($content, $patternClean, $bogoHtml)
        Set-Content -Path $file -Value $content
        Write-Host "Fixed: $($file)"
    } else {
        Write-Host "Skip (No match): $($file)"
    }
}
