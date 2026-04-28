const fs = require('fs');
const path = require('path');

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';
const files = fs.readdirSync(templatesDir);

const refinedLogic = `                        const mainVariantId = "{{ product.variants.first.id }}";
                        const mainPrice = {{ product.price | divided_by: 100 | default: 0 }};
                        const selectedGift = document.querySelector('input[name="free_gift"]:checked');
                        
                        let items = [];
                        
                        if (selectedGift && selectedGift.getAttribute('data-variant-id')) {
                            const giftVariantId = selectedGift.getAttribute('data-variant-id');
                            const giftPrice = parseInt(selectedGift.getAttribute('data-price') || 0);
                            
                            if (giftPrice > mainPrice) {
                                items.push({ 
                                    id: mainVariantId, 
                                    quantity: 1, 
                                    properties: { '_free_gift': 'true', '_bogo': 'true' } 
                                });
                                items.push({ 
                                    id: giftVariantId, 
                                    quantity: 1, 
                                    properties: { '_bogo': 'true' } 
                                });
                            } else {
                                items.push({ 
                                    id: mainVariantId, 
                                    quantity: 1, 
                                    properties: { '_bogo': 'true' } 
                                });
                                items.push({ 
                                    id: giftVariantId, 
                                    quantity: 1, 
                                    properties: { '_free_gift': 'true', '_bogo': 'true' } 
                                });
                            }
                        } else {
                            items.push({ id: mainVariantId, quantity: 1 });
                        }

                        console.log('Adding items to cart:', items);

                        fetch('/cart/add.js', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ items: items })
                        })
                        .then(response => {
                            if (!response.ok) return response.json().then(err => { throw err; });
                            return response.json();
                        })
                        .then(data => {
                            console.log('Success:', data);
                            window.location.reload();
                        })
                        .catch(error => {
                            console.error('Cart Error:', error);
                            alert('Bag Error: ' + (error.description || error.message || 'Could not add to bag'));
                            b.innerHTML = originalText;
                            b.disabled = false;
                        });`;

files.forEach(file => {
    if (file.endsWith('.liquid')) {
        const filePath = path.join(templatesDir, file);
        let content = fs.readFileSync(filePath, 'utf8');
        
        // Find the start of the logic
        const startMarker = 'const mainVariantId = "{{ product.variants.first.id }}";';
        const startIndex = content.indexOf(startMarker);
        
        if (startIndex !== -1) {
            console.log(`Updating ${file}...`);
            // Find the catch block or the end of the fetch
            // Since we know the previous versions used either "window.location.href" or "window.location.reload()"
            let endIndex = -1;
            const markers = ["window.location.href = '/cart';", "window.location.reload();"];
            for (const m of markers) {
                const idx = content.indexOf(m, startIndex);
                if (idx !== -1) {
                    // Find the end of the catch block after this
                    const catchIdx = content.indexOf('}', idx + m.length);
                    const finalIdx = content.indexOf('}', catchIdx + 1);
                    endIndex = finalIdx + 1;
                    break;
                }
            }
            
            if (endIndex !== -1) {
                const before = content.substring(0, startIndex);
                const after = content.substring(endIndex);
                content = before + refinedLogic + '\n' + after;
                fs.writeFileSync(filePath, content);
            } else {
                 // Fallback: search for the next closing brace after mainVariantId
                 console.log(`Falling back for ${file}`);
                 const nextBrace = content.indexOf('});', startIndex);
                 if (nextBrace !== -1) {
                     const before = content.substring(0, startIndex);
                     const after = content.substring(nextBrace);
                     content = before + refinedLogic + '\n                        ' + after;
                     fs.writeFileSync(filePath, content);
                 }
            }
        }
    }
});
