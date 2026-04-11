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

// ----------------------------------------------------------------------------
// CLEAN MASTER TEMPLATE
// ----------------------------------------------------------------------------
let masterCleaned = masterHtml;

// 1. Remove the original BOGO Drawer and its scripts to prevent duplication
const drawerFullBlockPattern = /\/\* BOGO Drawer Styling \*\/[\s\S]*?<div class="bogo-overlay" id="bogoOverlay"><\/div>[\s\S]*?<div class="bogo-drawer" id="bogoDrawer">[\s\S]*?<\/div>\s*<\/div>[\s\S]*?<script>[\s\S]*?const openBogo = document\.getElementById\('openBogo'\);[\s\S]*?<\/script>/;
masterCleaned = masterCleaned.replace(drawerFullBlockPattern, '');

// Also remove any existing selectBogo script at the top level to let our injected one take over
masterCleaned = masterCleaned.replace(/<script>\s*function selectBogo\(card\) {[\s\S]*?}<\s*<\/script>/g, '');

// 2. Prepare BOGO Section Placeholder
const bogoSectionPattern = /<div class="bogo-inline-section">[\s\S]*?<!-- BOGO_CARDS_PLACEHOLDER -->[\s\S]*?<\/div>[\s\S]*?<\/style>/;
const fallbackBogoPattern = /<div class="bogo-inline-section">[\s\S]*?<\/style>/;

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
          </style>`;

if (masterCleaned.match(bogoSectionPattern)) {
    masterCleaned = masterCleaned.replace(bogoSectionPattern, bogoReplacement);
} else {
    masterCleaned = masterCleaned.replace(fallbackBogoPattern, bogoReplacement);
}

// 3. Prepare Featured Collection Placeholder
const featuredSliderPattern = /<div class="product-collection" id="product-slider">[\s\S]*?<\/div>\s*<\/section>/;
masterCleaned = masterCleaned.replace(featuredSliderPattern, `<div class="product-collection" id="product-slider"><!-- FEATURED_CARDS_PLACEHOLDER --></div>\n    </section>`);

// ----------------------------------------------------------------------------
// CORE SYNC LOGIC
// ----------------------------------------------------------------------------
function getHandle(fileName) {
    return fileName.replace('product.', '').replace('.liquid', '');
}

function updateTemplate(p) {
    console.log(`Syncing ${p.File}...`);
    let c = '{% layout none %}\n' + masterCleaned;

    // --- BOGO EXCLUSIVITY ---
    const bogoHandles = [
        'glow-serum',
        'sunscreen-v2',
        'face-wash',
        'tranexamic-serum-v2',
        'anti-acne',
        'night-cream'
    ];

    const currentHandle = getHandle(p.File);
    const isBogoEligible = bogoHandles.includes(currentHandle);

    if (isBogoEligible) {
        const bogoSelectionHtml = products
            .filter(prod => bogoHandles.includes(getHandle(prod.File)))
            .map(prod => {
                const handle = getHandle(prod.File);
                const isSelected = handle === currentHandle ? 'selected' : '';
                const isChecked = handle === currentHandle ? 'checked' : '';
                return `
              <div class="bogo-inline-card ${isSelected}" onclick="selectBogo(this)">
                <input type="radio" name="free_gift" data-gift-handle="${handle}" style="display:none;" ${isChecked}>
                <img src="{{ "${prod.Images.Hero}" | asset_url }}" alt="${prod.Title}">
                <div class="bogo-inline-info">
                  <span class="bogo-inline-name">${prod.Title}</span>
                  <span class="bogo-inline-tag">${prod.Subtitle || 'Elaris Essential'}</span>
                </div>
                <div class="bogo-select-indicator"></div>
              </div>`;
            }).join('\n');

        c = c.replace('<!-- BOGO_CARDS_PLACEHOLDER -->', bogoSelectionHtml);
        
        // Update the BOGO button behavior
        c = c.replace(/<button class="buy-button bogo-btn" id="openBogo">[\s\S]*?<\/button>/, `<button class="buy-button bogo-btn" id="bogoAddToCart">BUY 1 GET 1 FREE</button>`);
        
        // Inject Add to Cart Logic
        const bogoScript = `
          <script>
            function selectBogo(card) {
                document.querySelectorAll('.bogo-inline-card').forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
                const input = card.querySelector('input[type="radio"]');
                if(input) input.checked = true;
            }

            const handleToIdMap = {
                'glow-serum': '{{ all_products["glow-serum"].variants.first.id }}',
                'sunscreen-v2': '{{ all_products["sunscreen-v2"].variants.first.id }}',
                'face-wash': '{{ all_products["face-wash"].variants.first.id }}',
                'tranexamic-serum-v2': '{{ all_products["tranexamic-serum-v2"].variants.first.id }}',
                'anti-acne': '{{ all_products["anti-acne"].variants.first.id }}',
                'night-cream': '{{ all_products["night-cream"].variants.first.id }}'
            };

            document.getElementById('bogoAddToCart')?.addEventListener('click', function() {
                const selectedGift = document.querySelector('input[name="free_gift"]:checked');
                if (!selectedGift) {
                    alert('Please select your free gift first.');
                    return;
                }
                const giftHandle = selectedGift.getAttribute('data-gift-handle');
                const giftVariantId = handleToIdMap[giftHandle];
                const mainVariantId = "{{ product.variants.first.id }}";
                
                if (!giftVariantId) {
                    console.error('Variant ID not found for handle:', giftHandle);
                    return;
                }

                const items = [
                    { id: mainVariantId, quantity: 1 },
                    { id: giftVariantId, quantity: 1 }
                ];

                fetch('/cart/add.js', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ items: items })
                })
                .then(response => response.json())
                .then(data => { window.location.href = '/cart'; })
                .catch(error => { alert('Error adding to cart.'); });
            });
          </script>`;
        
    // --- GLOBAL STANDART ADD TO CART ---
    const standardCartScript = `
          <script>
            document.querySelector('.add-to-cart-btn')?.addEventListener('click', function() {
                const mainVariantId = "{{ product.variants.first.id }}";
                
                fetch('/cart/add.js', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ items: [{ id: mainVariantId, quantity: 1 }] })
                })
                .then(response => response.json())
                .then(data => { window.location.href = '/cart'; })
                .catch(error => { alert('Error adding to cart.'); });
            });
          </script>`;

    if (isBogoEligible) {
        c = c.replace(/<\/body>/, `${bogoScript}\n${standardCartScript}\n</body>`);
    } else {
        // Remove BOGO for non-eligible
        c = c.replace(/<div class="bogo-inline-section">[\s\S]*?<\/style>[\s\S]*?<\/div>/, '');
        c = c.replace(/<button class="buy-button bogo-btn" id="openBogo">[\s\S]*?<\/button>/, '');
        c = c.replace(/grid-template-columns: 1fr 1fr;/, 'grid-template-columns: 1fr;');
        c = c.replace(/<\/body>/, `${standardCartScript}\n</body>`);
    }

    // --- ASSET MAPPING ---
    if (p.Images) {
        if (p.Images.Hero) c = c.replaceAll('./assets/night-cream-suite.jpeg', `{{ "${p.Images.Hero}" | asset_url }}`);
        if (p.Images.Carousel) {
            c = c.replace('./assets/night-cream-suite.jpeg', `{{ "${p.Images.Carousel[0]}" | asset_url }}`);
            c = c.replace('./assets/night-cream-swatch.jpeg', `{{ "${p.Images.Carousel[1]}" | asset_url }}`);
            c = c.replace('./assets/night-cream-lifestyle.jpeg', `{{ "${p.Images.Carousel[2]}" | asset_url }}`);
            c = c.replace('./assets/night-cream-last.jpeg', `{{ "${p.Images.Carousel[3]}" | asset_url }}`);
        }
        if (p.Images.Plate) c = c.replace('./assets/plate.jpeg', `{{ "${p.Images.Plate}" | asset_url }}`);
        if (p.Images.Spoon) c = c.replace('./assets/spoon.jpeg', `{{ "${p.Images.Spoon}" | asset_url }}`);
        if (p.Images.Spread) c = c.replace('./assets/spread.jpeg', `{{ "${p.Images.Spread}" | asset_url }}`);
        if (p.Images.Stats) c = c.replace('./assets/percentage.jpeg', `{{ "${p.Images.Stats}" | asset_url }}`);
        if (p.Images.FAQ) c = c.replace('./assets/faq.jpeg', `{{ "${p.Images.FAQ}" | asset_url }}`);
    }

    // --- CONTENT INJECTION ---
    c = c.replaceAll('Centella<br>Night<br>Cream', p.Title.split(' ').join('<br>'));
    c = c.replaceAll('Centella Night Cream', p.Title);
    c = c.replaceAll('Night Renewal', p.Subtitle || '');
    if (p.Price) c = c.replace('Rs. 2,660', `Rs. ${p.Price}`);
    if (p.Description) c = c.replace(/An intensive overnight formula[\s\S]*?morning\./, p.Description);
    if (p.CatchyLine) c = c.replace('Your Overnight Glow Secret', p.CatchyLine);

    if (p.Benefits) {
        const benHtml = p.Benefits.map(b => `<li>${b}</li>`).join('\n                  ');
        c = c.replace(/<li>Boosts skin radiance[\s\S]*?<\/li>/, benHtml);
    }
    if (p.Application) {
        c = c.replace(/<p style="margin:0;">After cleansing[\s\S]*?<\/p>/, `<p style="margin:0;">${p.Application}</p>`);
    }
    if (p.Tricks) {
        const trickHtml = p.Tricks.map(t => `<li>${t}</li>`).join('\n                  ');
        c = c.replace(/<li>Apply a slightly thicker layer[\s\S]*?<\/li>/, trickHtml);
    }
    if (p.Ingredients) {
        const ingHtml = p.Ingredients.map(i => `<li>${i}</li>`).join('\n                  ');
        c = c.replace(/<li>Centella Asiatica<\/li>[\s\S]*?Even-Tone Enhancer<\/li>/, ingHtml);
    }

    if (p.ImportantInfo) {
        c = c.replace('Wake Up to Refreshed, Radiant Skin.', p.ImportantInfo.Headline);
        c = c.replace('All skin types, including dry and sensitive skin', p.ImportantInfo.GoodFor);
        c = c.replace('A rich, creamy formula that melts effortlessly into the skin', p.ImportantInfo.FeelsLike);
        c = c.replace('Smooth, plump, and poreless skin by morning', p.ImportantInfo.LooksLike);
        c = c.replace('Subtle, calming freshness for a relaxing nighttime routine', p.ImportantInfo.SmellsLike);
        c = c.replace('Halal-Friendly • Dermatologist-Tested • Non-Sticky • Repair-Focused', p.ImportantInfo.FYI);
    }

    if (p.WhatsInside) {
        c = c.replace('Our formula is powered by advanced repair and brightening actives. Meet 2 of our favorites for overnight renewal.', p.WhatsInside.Intro);
        c = c.replace('centella asiatica', p.WhatsInside.I1Title);
        c = c.replace('a calming botanical that helps repair the skin barrier, reduce redness, and support healthier, more resilient skin overnight', p.WhatsInside.I1Desc);
        c = c.replace('moisture-lock technology', p.WhatsInside.I2Title);
        c = c.replace('a deep hydration system that helps retain moisture, prevent overnight dryness, and keep skin plump and smooth by morning', p.WhatsInside.I2Desc);
        c = c.replace('BRIGHTENING COMPLEX, COLLAGEN SUPPORT BLEND, SPOT-CORRECTIVE ACTIVES, LINE-REDUCING COMPLEX, BARRIER REPAIR ACTIVES, EVEN-TONE ENHANCERS', p.WhatsInside.Also);
    }

    if (p.SpreadItOn) {
        c = c.replace('deep repair', p.SpreadItOn[0]);
        c = c.replace('overnight hydration', p.SpreadItOn[1]);
        c = c.replace('revitalized, luminous skin', p.SpreadItOn[2]);
    }

    if (p.Stats && p.Stats.length > 0) {
        const defaultStatDescs = [
            'SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED',
            'SAID IT ABSORBED WELL WITHOUT HEAVINESS',
            'NOTICED SMOOTHER, SOFTER, AND REFINED SKIN BY MORNING',
            'REPORTED A VISIBLE REDUCTION IN FINE LINES AND DARK SPOTS'
        ];

        p.Stats.forEach((s, i) => {
            if (i > 3) return; // Only 4 slots in template
            
            // 1. Replace percentage
            // Pattern matches either "X%" or "3 out of 4"
            const pctPattern = new RegExp(`<div class="stat-pct">(${i === 3 ? '3 out of 4' : '\\d+%'}|[\\d/\\s\\w]+)<\\/div>`);
            if (s.Pct) {
                c = c.replace(pctPattern, `<div class="stat-pct">${s.Pct}</div>`);
            }

            // 2. Replace description
            if (s.Desc) {
                c = c.replace(defaultStatDescs[i], s.Desc);
            }
        });
    }
    if (p.StatsDisclaimer) c = c.replace('*Based on a 2-week consumer perception study with consistent nightly use.', p.StatsDisclaimer);

    if (p.FAQs) {
        const faqHtml = p.FAQs.map(f => `
          <div class="faq-item">
            <div class="faq-qa">
              <span class="faq-question">${f.Q}</span>
              <p class="faq-answer">${f.A}</p>
            </div>
            <span class="faq-icon">+</span>
          </div>`).join('\n');
        c = c.replace(/<div class="faq-accordion">[\s\S]*?<\/div>\s*<\/div>\s*<\/div>\s*<div class="faq-image-col">/, `<div class="faq-accordion">\n${faqHtml}\n        </div>\n      </div>\n      <div class="faq-image-col">`);
    }

    if (p.Reviews && p.Reviews.length > 0) {
        const revHtml = p.Reviews.map(r => `
      <div class="review-card">
        <div class="rv-sidebar">
          <div class="rv-author">${r.Name}</div>
          <div class="rv-verified">Verified Buyer</div>
        </div>
        <div class="rv-main">
          <div class="rv-main-header"><div class="rv-stars">★★★★★</div></div>
          <div class="rv-title">Verified Selection</div>
          <div class="rv-body">"${r.Text}"</div>
        </div>
      </div>`).join('\n<hr class="rv-divider">\n');
        c = c.replace(/<div class="review-card">[\s\S]*?<\/div>[\s\S]*?<\/section>/, `${revHtml}\n    </section>`);
    }

    // 4. Inject Featured Collection Cards
    const featuredHtml = products.map(prod => {
        const handle = getHandle(prod.File);
        return `
        <div class="card card-rhode" data-category="skincare">
          <a href="/products/${handle}" class="card-link-wrapper">
            <img src="{{ "${prod.Images.Hero}" | asset_url }}" class="card-hover-bg" alt="${prod.Title}">
            <div class="card-rhode-top">
              <span class="card-brand-label">ELARIS</span>
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
          </a>
        </div>`;
    }).join('\n');

    c = c.replace('<!-- FEATURED_CARDS_PLACEHOLDER -->', featuredHtml);

    fs.writeFileSync(path.join(templatesDir, p.File), c);
}

products.forEach(updateTemplate);
console.log('Site-wide Content Overhaul Complete.');
