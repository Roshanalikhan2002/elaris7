const fs = require('fs');
const path = require('path');

const sourceFile = 'c:\\Users\\MY PC\\OneDrive\\Desktop\\Elaris7\\night-cream.html';
const templatesDir = 'c:\\Users\\MY PC\\OneDrive\\Desktop\\Elaris7\\templates';
const jsonDataPath = 'c:\\Users\\MY PC\\OneDrive\\Desktop\\Elaris7\\product_data.json';

if (!fs.existsSync(templatesDir)) {
    fs.mkdirSync(templatesDir, { recursive: true });
}

const masterHtml = fs.readFileSync(sourceFile, 'utf8');
const products = JSON.parse(fs.readFileSync(jsonDataPath, 'utf8'));

// First, clean up the master template for the new layout
let masterCleaned = masterHtml;

// 1. Remove the original size selector block and prepare BOGO Placeholder
const sizeSelectorPattern = /<div class="product-options">[\s\S]*?<\/div>\s*<\/div>/;
const bogoReplacement = `<div class="bogo-inline-section">
            <p class="bogo-inline-title">SELECT YOUR FREE PRODUCT</p>
            <div class="bogo-vertical-scroll">
              <!-- BOGO_CARDS_PLACEHOLDER -->
            </div>
          </div>
          
          <style>
            .bogo-inline-section {
              margin-top: 20px;
              margin-bottom: 20px;
            }
            .bogo-inline-title {
              font-size: 0.75rem;
              font-weight: 800;
              color: #5b5a53;
              letter-spacing: 0.08em;
              margin-bottom: 12px;
              text-transform: uppercase;
            }
            .bogo-vertical-scroll {
              display: flex;
              flex-direction: column;
              gap: 10px;
              max-height: 400px;
              overflow-y: auto;
              padding-right: 10px;
              scrollbar-width: thin;
              scrollbar-color: #5b5a53 #f1efea;
            }
            .bogo-inline-card {
              display: flex;
              align-items: center;
              gap: 15px;
              background: #fff;
              border: 1px solid #d1d1cf;
              border-radius: 12px;
              padding: 10px;
              cursor: pointer;
              transition: all 0.2s ease;
            }
            .bogo-inline-card:hover, .bogo-inline-card.selected {
              border-color: #5b5a53;
              background: #fdfdfb;
            }
            .bogo-inline-card img {
              width: 50px;
              height: 50px;
              object-fit: contain;
              border-radius: 6px;
              background: #f9f9f9;
            }
            .bogo-inline-info {
              flex: 1;
              display: flex;
              flex-direction: column;
            }
            .bogo-inline-name {
              font-size: 0.85rem;
              font-weight: 700;
              color: #333;
            }
            .bogo-inline-tag {
              font-size: 0.65rem;
              color: #777;
              text-transform: uppercase;
            }
            .bogo-select-indicator {
              width: 18px;
              height: 18px;
              border: 2px solid #d1d1cf;
              border-radius: 50%;
              position: relative;
            }
            .bogo-inline-card.selected .bogo-select-indicator {
              border-color: #5b5a53;
              background: #5b5a53;
            }
            .bogo-inline-card.selected .bogo-select-indicator::after {
              content: '';
              position: absolute;
              top: 3px;
              left: 3px;
              width: 8px;
              height: 8px;
              background: #fff;
              border-radius: 50%;
            }
          </style>
          
          <script>
            function selectBogo(card) {
              document.querySelectorAll('.bogo-inline-card').forEach(c => c.classList.remove('selected'));
              card.classList.add('selected');
              const input = card.querySelector('input[type="radio"]');
              if(input) input.checked = true;
            }
          </script>
          </div>`;

const hasBogo = masterCleaned.match(sizeSelectorPattern);
if (hasBogo) {
    masterCleaned = masterCleaned.replace(sizeSelectorPattern, bogoReplacement);
}

// 2. Prepare Featured Collection Placeholder
// We match the container and all its internal cards until the closing section tag.
const featuredSliderPattern = /<div class="product-collection" id="product-slider">[\s\S]*?<\/div>\s*<\/section>/;
masterCleaned = masterCleaned.replace(featuredSliderPattern, `<div class="product-collection" id="product-slider"><!-- FEATURED_CARDS_PLACEHOLDER --></div>\n    </section>`);

// Helper to generate handles
function getHandle(fileName) {
    return fileName.replace('product.', '').replace('.liquid', '');
}

function updateTemplate(p) {
    console.log(`Syncing ${p.File}...`);
    let c = '{% layout none %}\n' + masterCleaned;

    // 1. Generate BOGO Cards (Horizontal/Vertical variant for Selection)
    const bogoCardsHtml = products.map(prod => {
        const handle = getHandle(prod.File);
        return `
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="${handle}" style="display:none;">
                <img src="{{ "${prod.Images.Hero}" | asset_url }}" alt="${prod.Title}">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">${prod.Title}</span>
                  <span class="bogo-inline-tag">${prod.Subtitle || 'Elaris Essential'}</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>`;
    }).join('\n');

    c = c.replace('<!-- BOGO_CARDS_PLACEHOLDER -->', bogoCardsHtml);

    // 2. Generate Featured Collection Cards (Horizontal Slider)
    const featuredCardsHtml = products.map(prod => {
        const handle = getHandle(prod.File);
        const category = prod.Category || (prod.Title.toLowerCase().includes('serum') ? 'serum' : 'skincare');
        // Use Carousel[1] as hover image if it exists, fallback to Hero
        const hoverImg = (prod.Images.Carousel && prod.Images.Carousel[1]) ? prod.Images.Carousel[1] : prod.Images.Hero;

        return `
        <div class="card card-rhode" data-category="${category}">
          <a href="/products/${handle}" class="card-link-wrapper">
            <img src="{{ "${hoverImg}" | asset_url }}" class="card-hover-bg" alt="${prod.Title} Hover">
            <div class="card-rhode-top">
              <span class="card-brand-label">${prod.Subtitle || 'SKINCARE'}</span>
            </div>
            <div class="card-rhode-image">
              <img src="{{ "${prod.Images.Hero}" | asset_url }}" alt="${prod.Title}" class="product-main-img">
            </div>
            <div class="card-rhode-footer">
              <div class="card-meta">
                <div class="card-stars">★★★★★ <span class="review-count">(10k+)</span></div>
                <h3 class="card-name">${prod.Title}</h3>
              </div>
              <span class="btn-rhode-buy-pill">BUY - RS. ${prod.Price}</span>
            </div>
            <div class="buy-button-hover">
                BUY ${prod.Title} - RS. ${prod.Price}
            </div>
          </a>
        </div>`;
    }).join('\n');

    c = c.replace('<!-- FEATURED_CARDS_PLACEHOLDER -->', featuredCardsHtml);

    // 3. Product Metadata
    const titleBr = p.Title.replace(/ /g, '<br>');
    c = c.replace(/class="product-title">[\s\S]*?<\/h1>/, `class="product-title">${titleBr}</h1>`);
    c = c.replace(/<title>[\s\S]*?<\/title>/, `<title>${p.Title} | elaris7</title>`);
    c = c.replace(/class="product-subtitle">[\s\S]*?<\/p>/, `class="product-subtitle">${p.Subtitle}</p>`);
    
    // Global Price Replacement (Careful not to overwrite BOGO prices if they are dynamic)
    // We'll target the main price display
    c = c.replace(/<p class="product-price">[\s\S]*?<\/p>/, `<p class="product-price">RS. ${p.Price}</p>`);
    c = c.replace(/ADD TO BAG - [\s\S]*?<\/button>/, `ADD TO BAG - RS. ${p.Price}</button>`);
    c = c.replace(/data-variant-id="[\s\S]*?"/, `data-variant-id="{{ product.variants.first.id }}"`); // Placeholder for Liquid

    // 4. Description
    const newDesc = `<div class="product-description">
            <p>${p.Description}</p>
            <p class="disclaimer">*with continued daily use</p>
          </div>`;
    c = c.replace(/<div class="product-description">[\s\S]*?<\/div>/, newDesc);

    // 5. Accordions
    const benefitItems = p.Benefits.map(item => `                  <li>${item}</li>`).join('\n');
    c = c.replace(/<summary><span>BENEFITS<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, `<summary><span>BENEFITS</span><span>+</span></summary><div class="accordion-content"><ul>${benefitItems}</ul></div>`);

    const appItems = `<summary><span>APPLICATION</span><span>+</span></summary><div class="accordion-content"><p style="margin:0;">${p.Application}</p></div>`;
    c = c.replace(/<summary><span>APPLICATION<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, appItems);

    const trickItems = p.Tricks.map(item => `                  <li>${item}</li>`).join('\n');
    c = c.replace(/<summary><span>TRICK<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, `<summary><span>TRICK</span><span>+</span></summary><div class="accordion-content"><ul>${trickItems}</ul></div>`);

    const ingItems = p.Ingredients.map(item => `                  <li>${item}</li>`).join('\n');
    c = c.replace(/<summary><span>KEY INGREDIENTS<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, `<summary><span>KEY INGREDIENTS</span><span>+</span></summary><div class="accordion-content"><ul>${ingItems}</ul></div>`);

    // 6. Catchy Line
    c = c.replace(/<h2 class="meet-title">[\s\S]*?<\/h2>/, `<h2 class="meet-title">${p.CatchyLine}</h2>`);

    // 7. Important Info
    const info = p.ImportantInfo;
    c = c.replace(/<h2 class="bd-title">[\s\S]*?<\/h2>/, `<h2 class="bd-title">${info.Headline}</h2>`);
    // Note: These replacements rely on exact strings in master. Since we just updated master, it should work.
    
    // 8. What's Inside
    const wi = p.WhatsInside;
    c = c.replace(/Our formula is powered by advanced repair and brightening actives[\s\S]*?renewal\./, wi.Intro);
    c = c.replace(/<h3 class="wi-ingred-title">[\s\S]*?<\/h3>([\s\S]*?)<p class="wi-ingred-desc">[\s\S]*?<\/p>/, `<h3 class="wi-ingred-title">${wi.I1Title}</h3>$1<p class="wi-ingred-desc">${wi.I1Desc}</p>`);
    // Re-doing I2 replacement more carefully
    const wiParts = c.split('<div class="wi-ingred-item">');
    if (wiParts.length > 2) {
        wiParts[2] = wiParts[2].replace(/<h3 class="wi-ingred-title">[\s\S]*?<\/h3>/, `<h3 class="wi-ingred-title">${wi.I2Title}</h3>`);
        wiParts[2] = wiParts[2].replace(/<p class="wi-ingred-desc">[\s\S]*?<\/p>/, `<p class="wi-ingred-desc">${wi.I2Desc}</p>`);
        c = wiParts.join('<div class="wi-ingred-item">');
    }
    c = c.replace(/also made with <strong>[\s\S]*?<\/strong>/, `also made with <strong>${wi.Also}</strong>`);

    // 9. Spread It On For
    if(p.SpreadItOn) {
        c = c.replace(/<h2 class="spread-heading">[\s\S]*?<\/h2>/, `<h2 class="spread-heading">${p.SpreadItOn[0]}</h2>`);
        // Replace second heading
        let spreadParts = c.split('<div class="spread-text">');
        if(spreadParts.length > 2) {
            spreadParts[2] = spreadParts[2].replace(/<h2 class="spread-heading">[\s\S]*?<\/h2>/, `<h2 class="spread-heading">${p.SpreadItOn[1]}</h2>`);
            c = spreadParts.join('<div class="spread-text">');
        }
        c = c.replace(/<h2 class="spread-heading spread-green">[\s\S]*?<\/h2>/, `<h2 class="spread-heading spread-green">${p.SpreadItOn[2]}</h2>`);
    }

    // 10. Stats
    if(p.Stats && p.Stats.length > 0) {
        c = c.replace(/\d+%/, p.Stats[0].Pct);
        c = c.replace(/SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED/, p.Stats[0].Desc);
        if (p.Stats.length > 1) {
            c = c.replace(/\d+%/, p.Stats[1].Pct);
            // Replace matching desc
        }
    }

    // 11. FAQs
    const faqHtml = p.FAQs.map(f => `<details class="faq-item">
          <summary><span>${f.Q}</span><span>+</span></summary>
          <div class="faq-answer">${f.A}</div>
        </details>`).join('\n');
    c = c.replace(/<div class="faq-list">[\s\S]*?<\/div>/, `<div class="faq-list">\n        ${faqHtml}\n      </div>`);

    // 12. Reviews
    const reviewHtml = p.Reviews.map(r => `<div class="customer-review-card">
          <div class="review-stars">★★★★★</div>
          <p class="review-text">“${r.Text}”</p>
          <p class="review-author">— ${r.Name}</p>
        </div>`).join('\n');
    c = c.replace(/<div class="reviews-scroll">[\s\S]*?<\/div>/, `<div class="reviews-scroll">\n        ${reviewHtml}\n      </div>`);

    // 13. IMAGES (PER-PRODUCT OVERRIDES)
    const img = p.Images;
    // Primary Gallery Images
    if(img.Gallery) {
        c = c.replace(/nightcream-v3-1.jpeg/g, img.Gallery[0]);
        c = c.replace(/nightcream-v3-2.jpeg/g, img.Gallery[1]);
        c = c.replace(/nightcream-v3-3.jpeg/g, img.Gallery[2]);
        c = c.replace(/nightcream-v3-4.jpeg/g, img.Gallery[3]);
    }
    if(img.Hero) c = c.split('night-cream-suite.jpeg').join(img.Hero);
    if(img.Breakdown) c = c.split('plate.jpeg').join(img.Breakdown);
    if(img.WhatsInside) c = c.split('spoon.jpeg').join(img.WhatsInside);
    if(img.Spread) c = c.split('spread.jpeg').join(img.Spread);
    if(img.Stats) c = c.split('percentage.jpeg').join(img.Stats);

    // 14. Asset URL Conversion (Final Sweep)
    c = c.replace(/src="(?:\.\/assets\/|)([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"/g, 'src="{{ "$1" | asset_url }}"');

    const targetPath = path.join(templatesDir, p.File);
    fs.writeFileSync(targetPath, c, 'utf8');
}

products.forEach(updateTemplate);
console.log('Site-wide Content Overhaul Complete.');
