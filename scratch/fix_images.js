const fs = require('fs');
let content = fs.readFileSync('templates/product.renewal-cleanser.liquid', 'utf16le');
const mapping = {
  'renewal-cleanser-1.jpg': 'rc-gal-1.jpg',
  'renewal-cleanser-2.jpg': 'rc-gal-2.jpg',
  'renewal-cleanser-3.jpg': 'rc-gal-3.jpg',
  'renewal-cleanser-4.jpg': 'rc-gal-4.jpg',
  'renewal-cleanser-plate.jpg': 'rc-plate.jpg',
  'renewal-cleanser-spoon.jpg': 'rc-spoon.jpg',
  'renewal-cleanser-spread.jpg': 'rc-spread.jpg',
  'renewal-cleanser-percent.jpg': 'rc-percent.jpg',
  'renewal-cleanser-faq.jpg': 'rc-faq.jpg'
};
for(const [old, newName] of Object.entries(mapping)) {
  content = content.split('"' + old + '"').join("'" + newName + "'");
}
fs.writeFileSync('templates/product.renewal-cleanser.liquid', content, 'utf16le');
