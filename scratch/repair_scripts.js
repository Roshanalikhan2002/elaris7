const fs = require('fs');
const path = require('path');

const templatesDir = 'c:\\Users\\ASUS\\Desktop\\Elaris7\\templates';
const files = fs.readdirSync(templatesDir);

const standardizedScript = `  <script>
    // Main Add to Cart Logic
    document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
      btn.addEventListener('click', function(e) {
        e.preventDefault();
        const b = this;
        const originalText = b.innerHTML;
        
        if (b.disabled) return;
        
        b.innerHTML = 'ADDING TO BAG...';
        b.disabled = true;

        const mainVariantId = "{{ product.variants.first.id }}";
        const mainPrice = {{ product.price | divided_by: 100 | default: 0 }};
        const selectedGift = document.querySelector('input[name="free_gift"]:checked');
        
        let items = [];
        
        if (selectedGift && selectedGift.getAttribute('data-variant-id')) {
          const giftVariantId = selectedGift.getAttribute('data-variant-id');
          const giftPrice = parseInt(selectedGift.getAttribute('data-price') || 0);
          
          if (giftPrice > mainPrice) {
            items.push({ 
              id: mainVariantId, 
              quantity: 1, 
              properties: { '_free_gift': 'true', '_bogo': 'true' } 
            });
            items.push({ 
              id: giftVariantId, 
              quantity: 1, 
              properties: { '_bogo': 'true' } 
            });
          } else {
            items.push({ 
              id: mainVariantId, 
              quantity: 1, 
              properties: { '_bogo': 'true' } 
            });
            items.push({ 
              id: giftVariantId, 
              quantity: 1, 
              properties: { '_free_gift': 'true', '_bogo': 'true' } 
            });
          }
        } else {
          items.push({ id: mainVariantId, quantity: 1 });
        }

        fetch('/cart/add.js', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ items: items })
        })
        .then(response => {
          if (!response.ok) return response.json().then(err => { throw err; });
          return response.json();
        })
        .then(data => {
          window.location.reload();
        })
        .catch(error => {
          console.error('Cart Error:', error);
          alert('Bag Error: ' + (error.description || error.message || 'Could not add to bag'));
          b.innerHTML = originalText;
          b.disabled = false;
        });
      });
    });
  </script>
`;

files.forEach(file => {
  if (file.endsWith('.liquid')) {
    const filePath = path.join(templatesDir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Find the script block that contains BOGO logic
    const searchStr = 'const mainVariantId = "{{ product.variants.first.id }}";';
    if (content.includes(searchStr)) {
      console.log(`Fixing script in ${file}...`);
      
      // Find the <script> before and </script> after
      const scriptStartIdx = content.lastIndexOf('<script>', content.indexOf(searchStr));
      const scriptEndIdx = content.indexOf('</script>', content.indexOf(searchStr)) + 9;
      
      if (scriptStartIdx !== -1 && scriptEndIdx !== -1) {
        const before = content.substring(0, scriptStartIdx);
        const after = content.substring(scriptEndIdx);
        content = before + standardizedScript + after;
        fs.writeFileSync(filePath, content);
      }
    }
  }
});
