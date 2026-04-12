
$files = Get-ChildItem "templates/product.*.liquid"

$cleanScript = @"
          <script>
            // BOGO Selection Logic
            function selectBogo(card) {
                document.querySelectorAll('.bogo-inline-card').forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
                const input = card.querySelector('input[type="radio"]');
                if(input) {
                    input.checked = true;
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

foreach ($file in $files) {
    Write-Host "Aggressive script cleaning in $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # Remove ANY existing script blocks that contain selectBogo or add-to-cart-btn
    $content = $content -replace '(?s)<script>\s*function selectBogo.*?</script>', ''
    $content = $content -replace '(?s)<script>\s*const handleToIdMap.*?</script>', ''
    $content = $content -replace '(?s)<script>\s*document\.querySelector\(''\.add-to-cart-btn''.*?</script>', ''
    # Some might be merged already
    $content = $content -replace '(?s)<script>\s*// BOGO Selection Logic.*?</script>', ''
    
    # Inject the clean script right before </body> or at the very end
    if ($content -match '</body>') {
        $content = $content -replace '</body>', "$cleanScript`n</body>"
    } else {
        $content = $content + "`n" + $cleanScript
    }

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "All product pages are now Functional!"
