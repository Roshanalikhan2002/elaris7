const fs = require('fs');
const path = require('path');

const templatesDir = path.join(__dirname, 'templates');
const rootDir = __dirname;
const assetsPrefix = './assets/';

// Map of template filename pattern to target html filename
// We extract the handle from 'product.[handle].liquid'
const files = fs.readdirSync(templatesDir).filter(f => f.startsWith('product.') && f.endsWith('.liquid'));

files.forEach(file => {
    let content = fs.readFileSync(path.join(templatesDir, file), 'utf8');
    
    // 1. Remove Liquid Layout tags
    content = content.replace(/\{% layout none %\}/g, '');
    
    // 2. Replace asset_url tags with local paths
    // Pattern: {{ "filename.jpg" | asset_url }} -> ./assets/filename.jpg
    content = content.replace(/\{\{\s*"([^"]+)"\s*\|\s*asset_url\s*\}\}/g, (match, filename) => {
        return assetsPrefix + filename;
    });

    // 3. Extract handle for the output file
    // product.face-wash.liquid -> face-wash.html
    let handle = file.replace('product.', '').replace('.liquid', '');
    
    // Remove -v2 suffix for cleaner links
    handle = handle.replace('-v2', '');
    
    let targetFileName = handle + '.html';
    
    // special cases if any
    if (handle === 'glow-serum') targetFileName = 'glow-serum.html';

    const targetPath = path.join(rootDir, targetFileName);
    fs.writeFileSync(targetPath, content, 'utf8');
    console.log(`Generated static page: ${targetFileName}`);
});
