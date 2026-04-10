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

// 1. Remove the original size selector block
// Search for <div class="product-options">...</div>
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
              max-height: 300px;
              overflow-y: auto;
              padding-right: 10px;
              scrollbar-width: thin;
              scrollbar-color: #002d5f #f1efea;
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
              border-color: #002d5f;
              background: #f0f7ff;
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
              border-color: #002d5f;
              background: #002d5f;
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
            }
          </script>
          </div>`;

masterCleaned = masterCleaned.replace(sizeSelectorPattern, bogoReplacement);

// 2. Remove the old BOGO drawer and overlay from the master
masterCleaned = masterCleaned.replace(/<div class="bogo-overlay"[\s\S]*?<\/script>/, '');

function updateTemplate(p) {
    console.log(`Syncing ${p.File}...`);
    let c = '{% layout none %}\n' + masterCleaned;

    // 1. Generate BOGO Cards for ALL products
    const bogoCardsHtml = products.map(prod => {
        return `
              <div class="bogo-inline-card" onclick="selectBogo(this)">
                <img src="{{ "${prod.Images.Hero}" | asset_url }}" alt="${prod.Title}">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">${prod.Title}</span>
                  <span class="bogo-inline-tag">${prod.Subtitle || 'Elaris Essential'}</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>`;
    }).join('\n');

    c = c.replace('<!-- BOGO_CARDS_PLACEHOLDER -->', bogoCardsHtml);

    // 2. Product Metadata
    const titleBr = p.Title.replace(/ /g, '<br>');
    c = c.replace('class="product-title">Centella<br>Night Cream', `class="product-title">${titleBr}`);
    c = c.replace('<title>Centella Night Cream', `<title>${p.Title}`);
    c = c.replace('class="product-subtitle">Night Renewal', `class="product-subtitle">${p.Subtitle}`);
    
    // Global Price Replacement
    c = c.split('2,660').join(p.Price);
    c = c.split('1,500').join(p.Price);

    // 3. Description
    const newDesc = `<div class="product-description">
            <p>${p.Description}</p>
            <p class="disclaimer">*with continued daily use</p>
          </div>`;
    c = c.replace(/<div class="product-description">[\s\S]*?<\/div>/, newDesc);

    // 4. Accordions
    const benefitItems = p.Benefits.map(item => `                  <li>${item}</li>`).join('\n');
    c = c.replace(/<summary><span>BENEFITS<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, `<summary><span>BENEFITS</span><span>+</span></summary><div class="accordion-content"><ul>${benefitItems}</ul></div>`);

    const appItems = `<summary><span>APPLICATION</span><span>+</span></summary><div class="accordion-content"><p style="margin:0;">${p.Application}</p></div>`;
    c = c.replace(/<summary><span>APPLICATION<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, appItems);

    const trickItems = p.Tricks.map(item => `                  <li>${item}</li>`).join('\n');
    c = c.replace(/<summary><span>TRICK<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, `<summary><span>TRICK</span><span>+</span></summary><div class="accordion-content"><ul>${trickItems}</ul></div>`);

    const ingItems = p.Ingredients.map(item => `                  <li>${item}</li>`).join('\n');
    c = c.replace(/<summary><span>KEY INGREDIENTS<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, `<summary><span>KEY INGREDIENTS</span><span>+</span></summary><div class="accordion-content"><ul>${ingItems}</ul></div>`);

    // 5. Catchy Line
    c = c.replace('<h2 class="meet-title">Your Overnight Glow Secret</h2>', `<h2 class="meet-title">${p.CatchyLine}</h2>`);

    // 6. Important Info
    const info = p.ImportantInfo;
    c = c.replace('<h2 class="bd-title">Wake Up to Refreshed, Radiant Skin.</h2>', `<h2 class="bd-title">${info.Headline}</h2>`);
    c = c.replace('<span class="bd-val">All skin types, including dry and sensitive skin</span>', `<span class="bd-val">${info.GoodFor}</span>`);
    if (info.FeelsLike) c = c.replace('<span class="bd-val">A rich, creamy formula that melts effortlessly into the skin</span>', `<span class="bd-val">${info.FeelsLike}</span>`);
    if (info.LooksLike) c = c.replace('<span class="bd-val">Smooth, plump, and poreless skin by morning</span>', `<span class="bd-val">${info.LooksLike}</span>`);
    if (info.SmellsLike) c = c.replace('<span class="bd-val">Subtle, calming freshness for a relaxing nighttime routine</span>', `<span class="bd-val">${info.SmellsLike}</span>`);
    if (info.FYI) c = c.replace('<span class="bd-val">Halal-Friendly • Dermatologist-Tested • Non-Sticky • Repair-Focused</span>', `<span class="bd-val">${info.FYI}</span>`);

    // 7. What's Inside
    const wi = p.WhatsInside;
    c = c.replace('Our formula is powered by advanced repair and brightening actives. Meet 2 of our favorites for overnight renewal.', wi.Intro);
    c = c.replace('<h3 class="wi-ingred-title">centella asiatica</h3>', `<h3 class="wi-ingred-title">${wi.I1Title}</h3>`);
    c = c.replace('<p class="wi-ingred-desc">a calming botanical that helps repair the skin barrier, reduce redness, and support healthier, more resilient skin overnight</p>', `<p class="wi-ingred-desc">${wi.I1Desc}</p>`);
    c = c.replace('<h3 class="wi-ingred-title">moisture-lock technology</h3>', `<h3 class="wi-ingred-title">${wi.I2Title}</h3>`);
    c = c.replace('<p class="wi-ingred-desc">a deep hydration system that helps retain moisture, prevent overnight dryness, and keep skin plump and smooth by morning</p>', `<p class="wi-ingred-desc">${wi.I2Desc}</p>`);
    c = c.replace('also made with <strong>BRIGHTENING COMPLEX, COLLAGEN SUPPORT BLEND, SPOT-CORRECTIVE ACTIVES, LINE-REDUCING COMPLEX, BARRIER REPAIR ACTIVES, EVEN-TONE ENHANCERS</strong>', `also made with <strong>${wi.Also}</strong>`);

    // 8. Spread It On For
    c = c.replace('<h2 class="spread-heading">deep repair</h2>', `<h2 class="spread-heading">${p.SpreadItOn[0]}</h2>`);
    c = c.replace('<h2 class="spread-heading">overnight hydration</h2>', `<h2 class="spread-heading">${p.SpreadItOn[1]}</h2>`);
    c = c.replace('<h2 class="spread-heading spread-green">revitalized, luminous skin</h2>', `<h2 class="spread-heading spread-green">${p.SpreadItOn[2]}</h2>`);

    // 9. Stats
    c = c.replace('97%', p.Stats[0].Pct);
    c = c.replace('SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED', p.Stats[0].Desc);
    if (p.Stats.length > 1) {
        c = c.replace('95%', p.Stats[1].Pct);
        c = c.replace('SAID IT ABSORBED WELL WITHOUT HEAVINESS', p.Stats[1].Desc);
    }
    c = c.replace('*Based on a 2-week consumer perception study with consistent nightly use.', p.StatsDisclaimer);

    // 10. FAQs
    const faqHtml = p.FAQs.map(f => `<details class="faq-item">
          <summary><span>${f.Q}</span><span>+</span></summary>
          <div class="faq-answer">${f.A}</div>
        </details>`).join('\n');
    c = c.replace(/<div class="faq-list">[\s\S]*?<\/div>/, `<div class="faq-list">\n        ${faqHtml}\n      </div>`);

    // 11. Reviews
    const reviewHtml = p.Reviews.map(r => `<div class="customer-review-card">
          <div class="review-stars">★★★★★</div>
          <p class="review-text">“${r.Text}”</p>
          <p class="review-author">— ${r.Name}</p>
        </div>`).join('\n');
    c = c.replace(/<div class="reviews-scroll">[\s\S]*?<\/div>/, `<div class="reviews-scroll">\n        ${reviewHtml}\n      </div>`);

    // 12. IMAGES (GLOBAL REPLACEMENT)
    const img = p.Images;
    c = c.split('night-cream-suite.jpeg').join(img.Hero);
    c = c.split('nightcream-v3-1.jpeg').join(img.Gallery[0]);
    c = c.split('nightcream-v3-2.jpeg').join(img.Gallery[1]);
    c = c.split('nightcream-v3-3.jpeg').join(img.Gallery[2]);
    c = c.split('nightcream-v3-4.jpeg').join(img.Gallery[3]);
    c = c.split('plate.jpeg').join(img.Breakdown);
    c = c.split('spoon.jpeg').join(img.WhatsInside);
    c = c.split('spread.jpeg').join(img.Spread);
    c = c.split('percentage.jpeg').join(img.Stats);
    c = c.split('night-cream-swatch.jpeg').join(img.Carousel[1]);
    c = c.split('night-cream-lifestyle.jpeg').join(img.Carousel[2]);
    c = c.split('night-cream-last.jpeg').join(img.Carousel[3]);

    // 13. Asset URL Conversion
    c = c.replace(/src="(?:\.\/assets\/|)([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"/g, 'src="{{ "$1" | asset_url }}"');

    const targetPath = path.join(templatesDir, p.File);
    fs.writeFileSync(targetPath, c, 'utf8');
}

products.forEach(updateTemplate);
console.log('Site-wide Content Overhaul Complete.');
