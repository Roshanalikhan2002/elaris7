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

function updateTemplate(p) {
    console.log(`Syncing ${p.File}...`);
    let c = '{% layout none %}\n' + masterHtml;

    // 1. Product Metadata
    const titleBr = p.Title.replace(/ /g, '<br>');
    c = c.replace('class="product-title">Centella<br>Night Cream', `class="product-title">${titleBr}`);
    c = c.replace('<title>Centella Night Cream', `<title>${p.Title}`);
    c = c.replace('class="product-subtitle">Night Renewal', `class="product-subtitle">${p.Subtitle}`);
    
    // Global Price Replacement
    c = c.split('2,660').join(p.Price);
    c = c.split('1,500').join(p.Price);

    // 2. Description
    const newDesc = `<div class="product-description">
            <p>${p.Description}</p>
            <p class="disclaimer">*with continued daily use</p>
          </div>`;
    c = c.replace(/<div class="product-description">[\s\S]*?<\/div>/, newDesc);

    // 3. Benefits
    const benefitItems = p.Benefits.map(item => `                  <li>${item}</li>`).join('\n');
    const newBenefits = `<summary><span>BENEFITS</span><span>+</span></summary>
              <div class="accordion-content">
                <ul>
${benefitItems}                </ul>
              </div>`;
    c = c.replace(/<summary><span>BENEFITS<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, newBenefits);

    // 4. Application
    const newApp = `<summary><span>APPLICATION</span><span>+</span></summary>
              <div class="accordion-content">
                <p style="margin:0;">${p.Application}</p>
              </div>`;
    c = c.replace(/<summary><span>APPLICATION<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, newApp);

    // 5. Tricks
    const trickItems = p.Tricks.map(item => `                  <li>${item}</li>`).join('\n');
    const newTricks = `<summary><span>TRICK</span><span>+</span></summary>
              <div class="accordion-content">
                <ul>
${trickItems}                </ul>
              </div>`;
    c = c.replace(/<summary><span>TRICK<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, newTricks);

    // 6. Ingredients
    const ingItems = p.Ingredients.map(item => `                  <li>${item}</li>`).join('\n');
    const newIngs = `<summary><span>KEY INGREDIENTS</span><span>+</span></summary>
              <div class="accordion-content">
                <ul>
${ingItems}                </ul>
              </div>`;
    c = c.replace(/<summary><span>KEY INGREDIENTS<\/span><span>\+<\/span><\/summary>[\s\S]*?<div class="accordion-content">[\s\S]*?<\/div>/, newIngs);

    // 7. Catchy Line
    c = c.replace('<h2 class="meet-title">Your Overnight Glow Secret</h2>', `<h2 class="meet-title">${p.CatchyLine}</h2>`);

    // 8. Important Info
    const info = p.ImportantInfo;
    c = c.replace('<h2 class="bd-title">Wake Up to Refreshed, Radiant Skin.</h2>', `<h2 class="bd-title">${info.Headline}</h2>`);
    c = c.replace('<span class="bd-val">All skin types, including dry and sensitive skin</span>', `<span class="bd-val">${info.GoodFor}</span>`);
    
    if (info.FeelsLike) c = c.replace('<span class="bd-val">A rich, creamy formula that melts effortlessly into the skin</span>', `<span class="bd-val">${info.FeelsLike}</span>`);
    if (info.LooksLike) c = c.replace('<span class="bd-val">Smooth, plump, and poreless skin by morning</span>', `<span class="bd-val">${info.LooksLike}</span>`);
    if (info.SmellsLike) c = c.replace('<span class="bd-val">Subtle, calming freshness for a relaxing nighttime routine</span>', `<span class="bd-val">${info.SmellsLike}</span>`);
    if (info.FYI) c = c.replace('<span class="bd-val">Halal-Friendly • Dermatologist-Tested • Non-Sticky • Repair-Focused</span>', `<span class="bd-val">${info.FYI}</span>`);

    // 9. What's Inside
    const wi = p.WhatsInside;
    c = c.replace('Our formula is powered by advanced repair and brightening actives. Meet 2 of our favorites for overnight renewal.', wi.Intro);
    c = c.replace('<h3 class="wi-ingred-title">centella asiatica</h3>', `<h3 class="wi-ingred-title">${wi.I1Title}</h3>`);
    c = c.replace('<p class="wi-ingred-desc">a calming botanical that helps repair the skin barrier, reduce redness, and support healthier, more resilient skin overnight</p>', `<p class="wi-ingred-desc">${wi.I1Desc}</p>`);
    c = c.replace('<h3 class="wi-ingred-title">moisture-lock technology</h3>', `<h3 class="wi-ingred-title">${wi.I2Title}</h3>`);
    c = c.replace('<p class="wi-ingred-desc">a deep hydration system that helps retain moisture, prevent overnight dryness, and keep skin plump and smooth by morning</p>', `<p class="wi-ingred-desc">${wi.I2Desc}</p>`);
    c = c.replace('also made with <strong>BRIGHTENING COMPLEX, COLLAGEN SUPPORT BLEND, SPOT-CORRECTIVE ACTIVES, LINE-REDUCING COMPLEX, BARRIER REPAIR ACTIVES, EVEN-TONE ENHANCERS</strong>', `also made with <strong>${wi.Also}</strong>`);

    // 10. Spread It On For
    c = c.replace('<h2 class="spread-heading">deep repair</h2>', `<h2 class="spread-heading">${p.SpreadItOn[0]}</h2>`);
    c = c.replace('<h2 class="spread-heading">overnight hydration</h2>', `<h2 class="spread-heading">${p.SpreadItOn[1]}</h2>`);
    c = c.replace('<h2 class="spread-heading spread-green">revitalized, luminous skin</h2>', `<h2 class="spread-heading spread-green">${p.SpreadItOn[2]}</h2>`);

    // 11. Stats
    c = c.replace('97%', p.Stats[0].Pct);
    c = c.replace('SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED', p.Stats[0].Desc);
    if (p.Stats.length > 1) {
        c = c.replace('95%', p.Stats[1].Pct);
        c = c.replace('SAID IT ABSORBED WELL WITHOUT HEAVINESS', p.Stats[1].Desc);
    }
    c = c.replace('*Based on a 2-week consumer perception study with consistent nightly use.', p.StatsDisclaimer);

    // 12. FAQs
    const faqHtml = p.FAQs.map(f => `<details class="faq-item">
          <summary><span>${f.Q}</span><span>+</span></summary>
          <div class="faq-answer">${f.A}</div>
        </details>`).join('\n');
    c = c.replace(/<div class="faq-list">[\s\S]*?<\/div>/, `<div class="faq-list">\n        ${faqHtml}\n      </div>`);

    // 13. Reviews
    const reviewHtml = p.Reviews.map(r => `<div class="customer-review-card">
          <div class="review-stars">★★★★★</div>
          <p class="review-text">“${r.Text}”</p>
          <p class="review-author">— ${r.Name}</p>
        </div>`).join('\n');
    c = c.replace(/<div class="reviews-scroll">[\s\S]*?<\/div>/, `<div class="reviews-scroll">\n        ${reviewHtml}\n      </div>`);

    // 14. IMAGES (GLOBAL REPLACEMENT)
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

    // 15. Finally convert all to Liquid asset tags
    c = c.replace(/src="(?:\.\/assets\/|)([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"/g, 'src="{{ "$1" | asset_url }}"');

    const targetPath = path.join(templatesDir, p.File);
    fs.writeFileSync(targetPath, c, 'utf8');
}

products.forEach(updateTemplate);
console.log('Site-wide Content Overhaul Complete.');
