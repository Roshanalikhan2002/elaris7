const fs = require('fs');
const path = require('path');

const templatesToUpdate = [
  'product.hair-regrow-spray.liquid',
  'product.hair-mist.liquid',
  'product.anti-frizz-keratin-serum.liquid'
];

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';

templatesToUpdate.forEach(fileName => {
  const filePath = path.join(templatesDir, fileName);
  if (fs.existsSync(filePath)) {
    let content = fs.readFileSync(filePath, 'utf8');
    // It might be using 'bogo-selection' or others
    const regex = /\{% render 'bogo-selection(-limited|-brightening)?' %\}/g;
    if (regex.test(content)) {
      console.log(`Updating BOGO snippet in ${fileName}...`);
      content = content.replace(regex, "{% render 'bogo-selection-hair' %}");
      fs.writeFileSync(filePath, content);
    } else {
        console.log(`Snippet NOT found in ${fileName}`);
    }
  } else {
    console.log(`File NOT found: ${fileName}`);
  }
});
