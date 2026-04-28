const fs = require('fs');
const path = require('path');

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';
const files = fs.readdirSync(templatesDir);

files.forEach(file => {
    if (file.endsWith('.liquid')) {
        const filePath = path.join(templatesDir, file);
        let content = fs.readFileSync(filePath, 'utf8');
        if (content.includes("window.location.href = '/cart';")) {
            console.log(`Updating redirect to reload in ${file}...`);
            content = content.replace("window.location.href = '/cart';", "window.location.reload();");
            fs.writeFileSync(filePath, content);
        }
    }
});
