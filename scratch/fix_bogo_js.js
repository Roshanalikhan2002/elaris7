const fs = require('fs');
const path = require('path');

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';
const files = fs.readdirSync(templatesDir);

const newCode = `            function selectBogo(card) {
                document.querySelectorAll('.bogo-inline-card').forEach(c => {
                    c.classList.remove('selected');
                    const input = c.querySelector('input[type="checkbox"]');
                    if(input) input.checked = false;
                });
                card.classList.add('selected');
                const input = card.querySelector('input[type="checkbox"]');
                if(input) {
                    input.checked = true;
                }
            }`;

files.forEach(file => {
    if (file.endsWith('.liquid')) {
        const filePath = path.join(templatesDir, file);
        let content = fs.readFileSync(filePath, 'utf8');
        if (content.includes('function selectBogo(card)')) {
            console.log(`Updating ${file}...`);
            
            const startTag = 'function selectBogo(card) {';
            const endMarker = '// Main Add to Cart Logic';
            
            const startIndex = content.indexOf(startTag);
            const endIndex = content.indexOf(endMarker);
            
            if (startIndex !== -1 && endIndex !== -1 && startIndex < endIndex) {
                const before = content.substring(0, startIndex);
                const after = content.substring(endIndex);
                content = before + newCode + '\n\n            ' + after;
                fs.writeFileSync(filePath, content);
            } else {
                console.log(`Could not find markers in ${file}`);
            }
        }
    }
});
