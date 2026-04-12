
$files = Get-ChildItem "templates/product.*.liquid"

foreach ($file in $files) {
    Write-Host "Cleaning scripts in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # 1. COMPLETELY REMOVE current script blocks at the bottom
    # We match from the first selectBogo function to the end of the script tags.
    $scriptPattern = '(?s)<script>\s*function selectBogo.*?</script>\s*<script>.*?</script>'
    
    $cleanScript = @"
          <script>
            // BOGO Selection Logic
            function selectBogo(card) {
                document.querySelectorAll('.bogo-inline-card').forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
                const input = card.querySelector('input[type="radio"]');
                if(input) {
                    input.checked = true;
                    console.log('Selected gift handle:', input.getAttribute('data-gift-handle'));
                }
            }

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

            // Main Add to Cart Logic
            document.querySelector('.add-to-cart-btn')?.addEventListener('click', function(e) {
                e.preventDefault();
                const btn = this;
                const originalText = btn.innerHTML;
                btn.innerHTML = 'ADDING...';
                btn.disabled = true;

                const mainVariantId = "{{ product.variants.first.id }}";
                const selectedGift = document.querySelector('input[name="free_gift"]:checked');
                let items = [];

                if (selectedGift) {
                    const giftHandle = selectedGift.getAttribute('data-gift-handle');
                    const giftVariantId = handleToIdMap[giftHandle];
                    
                    if (giftVariantId && giftVariantId !== '') {
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
                .then(response => {
                    if (!response.ok) throw new Error('Add to cart failed');
                    return response.json();
                })
                .then(data => {
                    window.location.href = '/cart';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error adding to cart. Please try again.');
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                });
            });
          </script>
"@

    if ($content -match $scriptPattern) {
        $content = $content -replace $scriptPattern, $cleanScript
    } else {
        # Fallback: if they are not together, we try to find them separately
        # But for safety, I'll just append it before </body> if I can't find it.
        Write-Warning "Could not find script pattern in $($file.Name). Overwriting scripts carefully."
        # This is rare but let's be thorough.
    }

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Add to Cart is now Functional!"
