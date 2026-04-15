
$files = @(
    "templates/product.tranexamic-serum-v2.liquid",
    "templates/product.keratin-serum-v2.liquid",
    "templates/product.glow-serum.liquid",
    "templates/product.glutathione-cream.liquid",
    "templates/product.hair-mist.liquid",
    "templates/product.face-wash.liquid",
    "templates/product.anti-acne.liquid",
    "templates/product.sunscreen-v2.liquid",
    "templates/product.renewal-cleanser.liquid",
    "templates/product.centella-moisturizer.liquid",
    "templates/product.renewal-toner.liquid",
    "templates/product.oil-to-foam-cleanser.liquid",
    "templates/product.skin-refining-toner.liquid",
    "templates/product.hair-regrow-spray.liquid",
    "templates/product.aha-exfoliant.liquid",
    "templates/product.anti-acne-serum-v2.liquid",
    "templates/product.centella-moisturiser.liquid",
    "templates/product.centella-skin-toner.liquid",
    "templates/product.centella-skin-toner-copy.liquid",
    "templates/product.e7-korean-glass-skin-centella-face-wash-copy.liquid",
    "templates/product.e7-korean-glass-skin-moisturizer.liquid",
    "templates/product.glutathione-cream-v2.liquid",
    "templates/product.renewal-cleanser-v2.liquid",
    "templates/product.renewal-toner-v2.liquid",
    "templates/product.moisturizer.liquid"
)

$UI_REGEX = '(?s)<div class="bogo-inline-section">.*?</div>'
$UI_REPLACEMENT = @"
<div class="bogo-inline-section">
                               {% render 'bogo-selection' %}
          </div>
"@

$SCRIPT_REGEX = '(?s)document\.querySelectorAll\(''.add-to-cart-btn''\)\.forEach\(btn => \{.*?\}\);'

$GOLDEN_SCRIPT = @"
            // Main Add to Cart Logic
            document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
                btn.addEventListener('click', async function(e) {
                    e.preventDefault();
                    const b = this;
                    const originalText = b.innerHTML;
                    
                    if (b.disabled) return;
                    
                    b.innerHTML = 'ADDING TO BAG...';
                    b.disabled = true;

                    try {
                        const mainVariantId = "{{ product.variants.first.id }}";
                        const selectedGift = document.querySelector('input[name="free_gift"]:checked');
                        
                        let items = [{ 
                            id: mainVariantId, 
                            quantity: 1, 
                            properties: { '_bogo': 'true' } 
                        }];

                        if (selectedGift) {
                            const giftVariantId = selectedGift.getAttribute('data-variant-id');
                            if (giftVariantId && giftVariantId.trim() !== '' && giftVariantId !== '0') {
                                items.push({ 
                                    id: giftVariantId, 
                                    quantity: 1, 
                                    properties: { '_free_gift': 'true', '_bogo': 'true' } 
                                });
                            }
                        }

                        const response = await fetch('/cart/add.js', {
                            method: 'POST',
                            headers: { 
                                'Content-Type': 'application/json',
                                'X-Requested-With': 'XMLHttpRequest'
                            },
                            body: JSON.stringify({ items: items })
                        });

                        const data = await response.json();
                        if (!response.ok) throw new Error(data.description || data.message || 'Could not add to bag');

                        window.location.href = '/cart';
                        
                    } catch (error) {
                        console.error('Cart Addition Error:', error);
                        alert('Bag Error: ' + error.message);
                        b.innerHTML = originalText;
                        b.disabled = false;
                    }
                });
            });
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Replace UI
        if ($content -match $UI_REGEX) {
            Write-Host "Updating UI in $file"
            $content = $content -replace $UI_REGEX, $UI_REPLACEMENT
        } else {
            Write-Host "UI block already updated or not found in $file"
        }
        
        # Replace Script
        if ($content -match $SCRIPT_REGEX) {
            Write-Host "Updating Script in $file"
            $content = $content -replace $SCRIPT_REGEX, $GOLDEN_SCRIPT
        } else {
            Write-Host "Script block already updated or not found in $file"
        }
        
        Set-Content $file $content
    } else {
        Write-Host "File $file not found."
    }
}
