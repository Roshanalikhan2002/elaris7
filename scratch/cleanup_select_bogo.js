const fs = require('fs');
const path = require('path');

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';
const files = fs.readdirSync(templatesDir);

files.forEach(file => {
    if (file.endsWith('.liquid')) {
        const filePath = path.join(templatesDir, file);
        let content = fs.readFileSync(filePath, 'utf8');
        
        if (content.includes('function selectBogo(card)')) {
            console.log(`Removing local selectBogo from ${file}...`);
            
            // Remove the whole function definition
            const startStr = 'function selectBogo(card) {';
            const endStr = '            }'; // Assuming it's followed by this
            
            const startIdx = content.indexOf(startStr);
            if (startIdx !== -1) {
                const endIdx = content.indexOf(endStr, startIdx);
                if (endIdx !== -1) {
                    const before = content.substring(0, startIdx);
                    const after = content.substring(endIdx + endStr.length);
                    content = before + after;
                    fs.writeFileSync(filePath, content);
                }
            }
        }
    }
});
