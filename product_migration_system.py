import json
import os
import re

source_file = r"c:\Users\MY PC\OneDrive\Desktop\Elaris7\night-cream.html"
templates_dir = r"c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"
json_data_path = r"c:\Users\MY PC\OneDrive\Desktop\Elaris7\product_data.json"

# Ensure templates directory exists
if not os.path.exists(templates_dir):
    os.makedirs(templates_dir)

with open(source_file, 'r', encoding='utf-8') as f:
    master_html = f.read()

with open(json_data_path, 'r', encoding='utf-8') as f:
    products = json.load(f)

def update_template(p):
    print(f"Syncing {p['File']}...")
    c = "{% layout none %}\n" + master_html
    
    # 1. Product Metadata
    title_br = p['Title'].replace(" ", "<br>")
    c = c.replace('class="product-title">Centella<br>Night Cream', f'class="product-title">{title_br}')
    c = c.replace('<title>Centella Night Cream', f"<title>{p['Title']}")
    c = c.replace('class="product-subtitle">Night Renewal', f"class=\"product-subtitle\">{p['Subtitle']}")
    c = c.replace('ADD TO BAG - <span>Rs. 2,660</span>', f"ADD TO BAG - <span>Rs. {p['Price']}</span>")
    
    # Prices
    c = c.replace('2,660', p['Price'])
    c = c.replace('1,500', p['Price'])

    # 2. Description
    new_desc = f"""<div class="product-description">
            <p>{p['Description']}</p>
            <p class="disclaimer">*with continued daily use</p>
          </div>"""
    c = re.sub(r'<div class="product-description">.*?</div>', new_desc, c, flags=re.DOTALL)

    # 3. Benefits
    benefit_items = "".join([f"                  <li>{item}</li>\n" for item in p['Benefits']])
    new_benefits = f"""<summary><span>BENEFITS</span><span>+</span></summary>
              <div class="accordion-content">
                <ul>
{benefit_items}                </ul>
              </div>"""
    c = re.sub(r'<summary><span>BENEFITS</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', new_benefits, c, flags=re.DOTALL)

    # 4. Application
    new_app = f"""<summary><span>APPLICATION</span><span>+</span></summary>
              <div class="accordion-content">
                <p style="margin:0;">{p['Application']}</p>
              </div>"""
    c = re.sub(r'<summary><span>APPLICATION</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', new_app, c, flags=re.DOTALL)

    # 5. Tricks
    trick_items = "".join([f"                  <li>{item}</li>\n" for item in p['Tricks']])
    new_tricks = f"""<summary><span>TRICK</span><span>+</span></summary>
              <div class="accordion-content">
                <ul>
{trick_items}                </ul>
              </div>"""
    c = re.sub(r'<summary><span>TRICK</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', new_tricks, c, flags=re.DOTALL)

    # 6. Key Ingredients
    ing_items = "".join([f"                  <li>{item}</li>\n" for item in p['Ingredients']])
    new_ings = f"""<summary><span>KEY INGREDIENTS</span><span>+</span></summary>
              <div class="accordion-content">
                <ul>
{ing_items}                </ul>
              </div>"""
    c = re.sub(r'<summary><span>KEY INGREDIENTS</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', new_ings, c, flags=re.DOTALL)

    # 7. Catchy Line
    c = c.replace('<h2 class="meet-title">Your Overnight Glow Secret</h2>', f"<h2 class=\"meet-title\">{p['CatchyLine']}</h2>")

    # 8. Important Info
    info = p['ImportantInfo']
    c = c.replace('<h2 class="bd-title">Wake Up to Refreshed, Radiant Skin.</h2>', f"<h2 class=\"bd-title\">{info['Headline']}</h2>")
    c = c.replace('<span class="bd-val">All skin types, including dry and sensitive skin</span>', f"<span class=\"bd-val\">{info['GoodFor']}</span>")
    
    if 'FeelsLike' in info:
        c = c.replace('<span class="bd-val">A rich, creamy formula that melts effortlessly into the skin</span>', f"<span class=\"bd-val\">{info['FeelsLike']}</span>")
    if 'LooksLike' in info:
        c = c.replace('<span class="bd-val">Smooth, plump, and poreless skin by morning</span>', f"<span class=\"bd-val\">{info['LooksLike']}</span>")
    if 'SmellsLike' in info:
        c = c.replace('<span class="bd-val">Subtle, calming freshness for a relaxing nighttime routine</span>', f"<span class=\"bd-val\">{info['SmellsLike']}</span>")
    if 'FYI' in info:
         c = c.replace('<span class="bd-val">Halal-Friendly • Dermatologist-Tested • Non-Sticky • Repair-Focused</span>', f"<span class=\"bd-val\">{info['FYI']}</span>")

    # 9. What's Inside
    wi = p['WhatsInside']
    c = c.replace('Our formula is powered by advanced repair and brightening actives. Meet 2 of our favorites for overnight renewal.', wi['Intro'])
    c = c.replace('<h3 class="wi-ingred-title">centella asiatica</h3>', f"<h3 class=\"wi-ingred-title\">{wi['I1Title']}</h3>")
    c = c.replace('<p class="wi-ingred-desc">a calming botanical that helps repair the skin barrier, reduce redness, and support healthier, more resilient skin overnight</p>', f"<p class=\"wi-ingred-desc\">{wi['I1Desc']}</p>")
    c = c.replace('<h3 class="wi-ingred-title">moisture-lock technology</h3>', f"<h3 class=\"wi-ingred-title\">{wi['I2Title']}</h3>")
    c = c.replace('<p class="wi-ingred-desc">a deep hydration system that helps retain moisture, prevent overnight dryness, and keep skin plump and smooth by morning</p>', f"<p class=\"wi-ingred-desc\">{wi['I2Desc']}</p>")
    c = c.replace('also made with <strong>BRIGHTENING COMPLEX, COLLAGEN SUPPORT BLEND, SPOT-CORRECTIVE ACTIVES, LINE-REDUCING COMPLEX, BARRIER REPAIR ACTIVES, EVEN-TONE ENHANCERS</strong>', f"also made with <strong>{wi['Also']}</strong>")

    # 10. Spread It On For
    c = c.replace('<h2 class="spread-heading">deep repair</h2>', f"<h2 class=\"spread-heading\">{p['SpreadItOn'][0]}</h2>")
    c = c.replace('<h2 class="spread-heading">overnight hydration</h2>', f"<h2 class=\"spread-heading\">{p['SpreadItOn'][1]}</h2>")
    c = c.replace('<h2 class="spread-heading spread-green">revitalized, luminous skin</h2>', f"<h2 class=\"spread-heading spread-green\">{p['SpreadItOn'][2]}</h2>")

    # 11. Stats
    c = c.replace('97%', p['Stats'][0]['Pct'])
    c = c.replace('SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED', p['Stats'][0]['Desc'])
    if len(p['Stats']) > 1:
        c = c.replace('95%', p['Stats'][1]['Pct'])
        c = c.replace('SAID IT ABSORBED WELL WITHOUT HEAVINESS', p['Stats'][1]['Desc'])
    c = c.replace('*Based on a 2-week consumer perception study with consistent nightly use.', p['StatsDisclaimer'])

    # 12. FAQs
    faq_html = "".join([f"""<details class="faq-item">
          <summary><span>{f['Q']}</span><span>+</span></summary>
          <div class="faq-answer">{f['A']}</div>
        </details>
        """ for f in p['FAQs']])
    c = re.sub(r'<div class="faq-list">.*?</div>', f'<div class="faq-list">\n        {faq_html}      </div>', c, flags=re.DOTALL)

    # 13. Reviews
    review_html = "".join([f"""<div class="customer-review-card">
          <div class="review-stars">★★★★★</div>
          <p class="review-text">“{r['Text']}”</p>
          <p class="review-author">— {r['Name']}</p>
        </div>
        """ for r in p['Reviews']])
    c = re.sub(r'<div class="reviews-scroll">.*?</div>', f'<div class="reviews-scroll">\n        {review_html}      </div>', c, flags=re.DOTALL)

    # 14. IMAGES
    img = p['Images']
    c = c.replace('night-cream-suite.jpeg', img['Hero'])
    c = c.replace('nightcream-v3-1.jpeg', img['Gallery'][0])
    c = c.replace('nightcream-v3-2.jpeg', img['Gallery'][1])
    c = c.replace('nightcream-v3-3.jpeg', img['Gallery'][2])
    c = c.replace('nightcream-v3-4.jpeg', img['Gallery'][3])
    c = c.replace('plate.jpeg', img['Breakdown'])
    c = c.replace('spoon.jpeg', img['WhatsInside'])
    c = c.replace('spread.jpeg', img['Spread'])
    c = c.replace('percentage.jpeg', img['Stats'])
    c = c.replace('night-cream-swatch.jpeg', img['Carousel'][1])
    c = c.replace('night-cream-lifestyle.jpeg', img['Carousel'][2])
    c = c.replace('night-cream-last.jpeg', img['Carousel'][3])

    # Asset URL Conversion (Final Cleanup)
    c = re.sub(r'src="(?:./assets/|)([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"', r'src="{{ "\1" | asset_url }}"', c)

    target_path = os.path.join(templates_dir, p['File'])
    with open(target_path, 'w', encoding='utf-8') as f:
        f.write(c)

for p in products:
    update_template(p)

print("Site-wide Content Overhaul Complete.")
