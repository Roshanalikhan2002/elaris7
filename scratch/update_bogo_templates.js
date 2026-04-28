const fs = require('fs');
const path = require('path');

const templatesToUpdate = [
  'product.night-cream.liquid',
  'product.e7-korean-glass-skin-centella-sunscreen-spf50-copy.liquid',
  'product.e7-korean-glass-skin-centella-face-wash-copy.liquid',
  'product.oil-to-foam-cleanser.liquid',
  'product.skin-refining-toner.liquid',
  'product.e7-korean-glass-skin-centella-night-cream-copy.liquid',
  'product.centella-moisturizer.liquid'
];

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';

templatesToUpdate.forEach(fileName => {
  const filePath = path.join(templatesDir, fileName);
  if (fs.existsSync(filePath)) {
    let content = fs.readFileSync(filePath, 'utf8');
    if (content.includes("{% render 'bogo-selection' %}")) {
      console.log(`Updating BOGO snippet in ${fileName}...`);
      content = content.replace("{% render 'bogo-selection' %}", "{% render 'bogo-selection-limited' %}");
      fs.writeFileSync(filePath, content);
    } else {
        console.log(`Snippet NOT found in ${fileName}`);
    }
  } else {
    console.log(`File NOT found: ${fileName}`);
  }
});
