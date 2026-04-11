const fs = require('fs');
let data = JSON.parse(fs.readFileSync('product_data.json', 'utf8'));

// Find "Elaris7 Glycolic Renewal Toner" which was erroneously placed in product.aha-exfoliant.liquid
let ahaExfoliantIndex = data.findIndex(p => p.File === 'product.aha-exfoliant.liquid');

// Find "Skin Refining Toner" which is currently in product.renewal-toner.liquid
let renewalTonerIndex = data.findIndex(p => p.File === 'product.renewal-toner.liquid');

if (ahaExfoliantIndex !== -1 && renewalTonerIndex !== -1) {
    // Copy the entire object from aha-exfoliant and just set the file to product.renewal-toner.liquid
    let correctRenewalToner = JSON.parse(JSON.stringify(data[ahaExfoliantIndex]));
    correctRenewalToner.File = 'product.renewal-toner.liquid';
    
    // Replace the incorrect product.renewal-toner.liquid entry with the correct data
    data[renewalTonerIndex] = correctRenewalToner;
}

// For Anti-Acne, the user might be using product.anti-acne-serum-v2.liquid or another template in Shopify.
// Let's duplicate the product.anti-acne.liquid entry for product.anti-acne-serum-v2.liquid just to be safe.
let antiAcneIndex = data.findIndex(p => p.File === 'product.anti-acne.liquid');
if (antiAcneIndex !== -1) {
    let antiAcneV2 = JSON.parse(JSON.stringify(data[antiAcneIndex]));
    antiAcneV2.File = 'product.anti-acne-serum-v2.liquid';
    // Append it
    data.push(antiAcneV2);
}

// And what about centella face wash? Some templates might also be missing.
fs.writeFileSync('product_data.json', JSON.stringify(data, null, 2));
console.log("Updated product_data.json.");
