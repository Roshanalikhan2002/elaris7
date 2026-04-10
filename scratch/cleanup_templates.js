const fs = require('fs');
const path = require('path');

const templatesDir = path.join(__dirname, '..', 'templates');
const wrongFiles = [
    'product.moisturizer.liquid',
    'product.face-wash.liquid',
    'product.glow-serum.liquid',
    'product.sunscreen-v2.liquid',
    'product.skin-refining-toner.liquid'
];

wrongFiles.forEach(file => {
    const filePath = path.join(templatesDir, file);
    if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        console.log(`Deleted: ${file}`);
    }
});
