const fs = require('fs');
const path = require('path');

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';
const files = fs.readdirSync(templatesDir);

const newLogic = `                        const mainVariantId = "{{ product.variants.first.id }}";
                        const mainPrice = {{ product.price | divided_by: 100 | default: 0 }};
                        const selectedGift = document.querySelector('input[name="free_gift"]:checked');
                        
                        let items = [];
                        
                        if (selectedGift) {
                            const giftVariantId = selectedGift.getAttribute('data-variant-id');
                            const giftPrice = parseInt(selectedGift.getAttribute('data-price') || 0);
                            
                            if (giftPrice > mainPrice) {
                                // Gift is more expensive -> Main is FREE, Gift is PAID
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
                                // Main is more expensive or equal -> Gift is FREE, Main is PAID
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
`;

files.forEach(file => {
    if (file.endsWith('.liquid')) {
        const filePath = path.join(templatesDir, file);
        let content = fs.readFileSync(filePath, 'utf8');
        if (content.includes('const mainVariantId = "{{ product.variants.first.id }}";')) {
            console.log(`Updating Add to Cart logic in ${file}...`);
            
            const startMarker = 'const mainVariantId = "{{ product.variants.first.id }}";';
            const endMarker = 'const response = await fetch(\'/cart/add.js\', {';
            
            const startIndex = content.indexOf(startMarker);
            const endIndex = content.indexOf(endMarker);
            
            if (startIndex !== -1 && endIndex !== -1 && startIndex < endIndex) {
                const before = content.substring(0, startIndex);
                const after = content.substring(endIndex);
                content = before + newLogic + '\n                        ' + after;
                fs.writeFileSync(filePath, content);
            }
        }
    }
});
