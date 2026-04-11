const fs = require('fs');

const indexHtml = fs.readFileSync('index.html', 'utf8');

// The slider starts at <div class="product-collection" id="product-slider">
const startMarker = '<div class="product-collection" id="product-slider">';
const startIndex = indexHtml.indexOf(startMarker);

// Find the end of it... It should end before the next section
const endMarker = '    </section>';
const endIndex = indexHtml.indexOf(endMarker, startIndex);

let sliderHtml = indexHtml.substring(startIndex + startMarker.length, endIndex).trim();
// Extract only the cards, disregard the closing </div> of product-slider.
// Actually sliderHtml ends with </div>
sliderHtml = sliderHtml.substring(0, sliderHtml.lastIndexOf('</div>')).trim();

// Now update product_migration_system.js to use this exact HTML
// We will replace the current 'const featuredHtml = products.map(...' logic with our static HTML!
let migrationScript = fs.readFileSync('product_migration_system.js', 'utf8');

const targetStart = 'const featuredHtml = products.map(prod => {';
const targetEnd = 'c = c.replace(\'<!-- FEATURED_CARDS_PLACEHOLDER -->\', featuredHtml);';

const targetStartIndex = migrationScript.indexOf(targetStart);
const targetEndIndex = migrationScript.indexOf(targetEnd) + targetEnd.length;

if (targetStartIndex !== -1 && targetEndIndex !== -1) {
    let exactStaticHtml = 'const featuredHtml = `' + sliderHtml + '`;\n        c = c.replace(\'<!-- FEATURED_CARDS_PLACEHOLDER -->\', featuredHtml);';
    
    // We already have Asset URL Conversion happening AFTER this step in the script, so we don't need to do any manual {{ asset_url }} conversions here if they are relative paths like ./assets/*.jpg
    
    // Wait, the Asset URL conversion in product_migration_system.js says:
    // $c = [regex]::Replace($c, 'src="\./assets/([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"', 'src="{{ \'\'$1\'\' | asset_url }}"')
    // Wait, no! The script uses standard JS `replaceAll('...', ...)` for asset mapping!
    // Wait, let's see how product_migration_system.js handles general assets.
    // DOES it handle general assets?
    
    let replacement = `const featuredHtml = \`${sliderHtml}\`.replace(/src="\\.\\/assets\\/([\\w\\.-]+\\.(?:jpg|png|jpeg|webp|gif|svg|webp))"/g, 'src="{{ \\'$1\\' | asset_url }}"');\n        c = c.replace('<!-- FEATURED_CARDS_PLACEHOLDER -->', featuredHtml);`;

    let newScript = migrationScript.substring(0, targetStartIndex) + replacement + migrationScript.substring(targetEndIndex);
    fs.writeFileSync('product_migration_system.js', newScript);
    console.log("Migration script updated successfully!");
} else {
    console.log("Could not find target block in migration script.");
}
