const fs = require('fs');
const path = require('path');

const templatesToUpdate = [
  'product.glutathione-cream.liquid',
  'product.tranexamic-serum.liquid',
  'product.renewal-cleanser.liquid',
  'product.renewal-toner.liquid'
];

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';

templatesToUpdate.forEach(fileName => {
  const filePath = path.join(templatesDir, fileName);
  if (fs.existsSync(filePath)) {
    let content = fs.readFileSync(filePath, 'utf8');
    // It might be using 'bogo-selection' or 'bogo-selection-limited' depending on previous runs
    const regex = /\{% render 'bogo-selection(-limited)?' %\}/g;
    if (regex.test(content)) {
      console.log(`Updating BOGO snippet in ${fileName}...`);
      content = content.replace(regex, "{% render 'bogo-selection-brightening' %}");
      fs.writeFileSync(filePath, content);
    } else {
        console.log(`Snippet NOT found in ${fileName}`);
    }
  } else {
    console.log(`File NOT found: ${fileName}`);
  }
});
