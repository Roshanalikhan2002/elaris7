const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, '..', 'night-cream.html');
let content = fs.readFileSync(filePath, 'utf8');

// Use regex to find the product-collection div and replace its inner content
const regex = /(<div class="product-collection" id="product-slider">)[\s\S]*?(<\/div>\s*<\/section>)/;
const placeholder = '\n        <!-- FEATURED_CARDS_PLACEHOLDER -->\n      ';

content = content.replace(regex, `$1${placeholder}$2`);

fs.writeFileSync(filePath, content, 'utf8');
console.log('night-cream.html cleaned successfully.');
