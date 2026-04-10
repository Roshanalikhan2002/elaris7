$sourceFile = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\night-cream.html"
$templatesDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"
$masterHtml = Get-Content -Path $sourceFile -Raw -Encoding UTF8

# Define Products Data
$productData = @(
    # 1. Centella Night Cream
    [PSCustomObject]@{
        File = "product.night-cream.liquid"
        Title = "Centella Night Cream"
        Subtitle = "Night Renewal"
        Price = "2,660"
        Description = "An intensive overnight formula designed to rejuvenate your skin while you sleep. Infused with Centella Asiatica, brightening complexes, and repair-focused botanicals, this night cream hydrates deeply, improves skin texture, and helps reveal a smoother, luminous, and refreshed complexion by morning."
        Benefits = @("Boosts skin radiance for a naturally luminous glow", "Provides 72-hour hydration with a moisture-locking formula", "Supports collagen to improve skin firmness and elasticity", "Helps fade dark spots, acne scars, and discoloration", "Repairs and strengthens the skin barrier overnight", "Delivers a soft, smooth, poreless finish by morning", "Reduces the appearance of fine lines and wrinkles", "Promotes a more even-toned, youthful-looking complexion over time")
        Application = "After cleansing and toning, take a small amount of Centella Night Cream and gently massage it upward onto your face and neck, avoiding the eye area. Leave it on overnight to fully absorb and lock in hydration, allowing your skin to repair, restore, and wake up looking radiant and smooth. Consistency is key for optimal results."
        Tricks = @("Apply a slightly thicker layer on dry areas to maximize overnight hydration", "Combine with your serum for enhanced repair benefits", "Use consistently to see a reduction in fine lines and dark spots")
        Ingredients = @("Centella Asiatica", "Brightening Complex", "Moisture-Lock Technology", "Collagen Support Blend", "Spot-Corrective Blend", "Barrier Repair Actives", "Line-Reducing Complex", "Even-Tone Enhancer")
        CatchyLine = "Your Overnight Glow Secret"
        ImportantInfo = @{ Headline = "Wake Up to Refreshed, Radiant Skin."; GoodFor = "All skin types, including dry and sensitive skin"; FeelsLike = "A rich, creamy formula that melts effortlessly into the skin"; LooksLike = "Smooth, plump, and poreless skin by morning"; SmellsLike = "Subtle, calming freshness for a relaxing nighttime routine"; FYI = "Halal-Friendly • Dermatologist-Tested • Non-Sticky • Repair-Focused" }
        WhatsInside = @{ Intro = "Our formula is powered by advanced repair and brightening actives. Meet 2 of our favorites for overnight renewal."; I1Title = "centella asiatica"; I1Desc = "a calming botanical that helps repair the skin barrier, reduce redness, and support healthier, more resilient skin overnight"; I2Title = "moisture-lock technology"; I2Desc = "a deep hydration system that helps retain moisture, prevent overnight dryness, and keep skin plump and smooth by morning"; Also = "BRIGHTENING COMPLEX, COLLAGEN SUPPORT BLEND, SPOT-CORRECTIVE ACTIVES, LINE-REDUCING COMPLEX, BARRIER REPAIR ACTIVES, EVEN-TONE ENHANCERS" }
        SpreadItOn = @("deep repair", "overnight hydration", "revitalized, luminous skin")
        Stats = @(@{ Pct = "97%"; Desc = "SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED" }, @{ Pct = "95%"; Desc = "SAID IT ABSORBED WELL WITHOUT HEAVINESS" }, @{ Pct = "94%"; Desc = "NOTICED SMOOTHER, SOFTER, AND REFINED SKIN BY MORNING" }, @{ Pct = "3 out of 4"; Desc = "REPORTED A VISIBLE REDUCTION IN FINE LINES AND DARK SPOTS" })
        StatsDisclaimer = "*Based on a 2-week consumer perception study with consistent nightly use."
        FAQs = @(@{ Q = "Can I use this night cream with my serum?"; A = "Yes, applying serum before the night cream enhances hydration and repair benefits." }, @{ Q = "Is it suitable for oily skin at night?"; A = "Absolutely, it hydrates without clogging pores or leaving a greasy residue." }, @{ Q = "How often should I use it?"; A = "For optimal results, use every night as the final step in your evening routine." }, @{ Q = "Will it help with dull or uneven skin tone?"; A = "Yes, its brightening and repair ingredients work overnight to improve radiance and evenness." }, @{ Q = "Can it reduce the appearance of fine lines?"; A = "Yes, regular use helps visibly minimize fine lines and promotes firmer, youthful-looking skin." })
        Reviews = @(@{ Name = "Fatima"; Text = "I’ve been using it for 2 weeks, and my skin barrier feels so much stronger and healthier. My skin looks brighter, more even-toned, and I’m genuinely loving the glow." }, @{ Name = "Ayesha"; Text = "I’m honestly in love with the texture — it’s lightweight, smooth, and absorbs instantly without any greasiness. My skin feels soft, hydrated, and has a natural glow every morning." }, @{ Name = "Fiza"; Text = "Received my order and I’m super impressed with both the product and packaging. Everything feels premium — definitely a 10/10 experience for me!" }, @{ Name = "Razish"; Text = "After consistent use, my skin feels deeply hydrated and looks much more refreshed. I’ve noticed a visible improvement in texture and overall glow." }, @{ Name = "Arsalan"; Text = "The night cream feels very gentle yet effective — my skin looks brighter and healthier with regular use. Waking up to soft, smooth skin has become part of my routine now." })
    },
    # 2. Centella Moisturizer
    [PSCustomObject]@{
        File = "product.moisturizer.liquid"
        Title = "Centella Moisturizer"
        Subtitle = "Daily Dew"
        Price = "1,800"
        Description = "A lightweight, glow-enhancing moisturizer infused with Centella Asiatica, brightening complexes, and nourishing botanicals to hydrate, soothe, and refine your skin for a smooth, glass-like finish every day."
        Benefits = @("Boosts natural radiance while improving overall skin clarity", "Delivers lasting hydration for a plump, soft, and dewy feel", "Smooths texture and helps reduce the appearance of uneven tone")
        Application = "After cleansing and applying serum, take a small amount of Centella Moisturizer and gently massage it onto slightly damp skin using upward motions. Allow it to absorb fully to lock in hydration."
        Tricks = @("Apply on damp skin to enhance absorption and maximize hydration", "Use a slightly thicker layer for an instant dewy glow finish", "Pair with sunscreen in the morning for protected, radiant skin")
        Ingredients = @("Hyaluronic Acid", "Vitamin C Complex", "Centella Asiatica", "Morus Alba Extract", "Broussonetia Root Extract", "Honey", "Galactoarabinan", "Vitamin E")
        CatchyLine = "Your Everyday Glow Essential"
        ImportantInfo = @{ Headline = "Glow That Lasts All Day"; GoodFor = "All skin types, including sensitive and combination skin"; FeelsLike = "A light, refreshing cream that melts effortlessly into the skin"; LooksLike = "A soft, luminous finish with a naturally healthy glow"; SmellsLike = "Clean, subtle freshness with no overpowering scent"; FYI = "Halal-Friendly • Dermatologist-Tested • Lightweight • Non-Sticky" }
        WhatsInside = @{ Intro = "Our formula is powered by glow-enhancing hydrators and skin-refining botanicals. Meet 2 of our favorites for daily radiance."; I1Title = "centella asiatica"; I1Desc = "a soothing plant extract that helps calm irritation, strengthen the skin barrier, and support a clearer, more balanced complexion"; I2Title = "hyaluronic acid"; I2Desc = "a powerful hydrator that helps attract and retain moisture, leaving skin plump, smooth, and refreshed throughout the day"; Also = "VITAMIN C COMPLEX, MORUS ALBA EXTRACT, BROUSSONETIA ROOT EXTRACT, HONEY, GALACTOARABINAN, VITAMIN E" }
        SpreadItOn = @("all-day hydration", "natural radiance", "soft, glass-like skin")
        Stats = @(@{ Pct = "99%"; Desc = "SAID THEIR SKIN FELT MORE HYDRATED + REFRESHED" }, @{ Pct = "98%"; Desc = "SAID IT ABSORBS QUICKLY WITHOUT ANY HEAVINESS" }, @{ Pct = "97%"; Desc = "SAID THEIR SKIN LOOKED SMOOTHER + MORE EVEN" }, @{ Pct = "3 out of 4"; Desc = "SAID THEY NOTICED A HEALTHY, NATURAL GLOW" })
        StatsDisclaimer = "*Based on a 2-week consumer perception study with consistent daily use."
        FAQs = @(@{ Q = "Can I use this moisturizer with makeup?"; A = "Yes, it works perfectly as a base under makeup, helping create a smooth and hydrated canvas." }, @{ Q = "Is this suitable for oily skin?"; A = "Yes, the lightweight formula hydrates without clogging pores or leaving a greasy feel, making it suitable for oily skin." }, @{ Q = "Can I use it both morning and night?"; A = "Absolutely, it is designed for daily use and works well in both AM and PM routines." }, @{ Q = "Will it help with dull or tired-looking skin?"; A = "Yes, its brightening ingredients and hydration help revive dull skin and improve overall radiance over time." }, @{ Q = "Does it feel heavy on the skin in humid weather?"; A = "No, the formula is lightweight and breathable, making it comfortable even in warm or humid conditions." })
        Reviews = @(@{ Name = "Sana"; Text = "It feels so light on my skin and gives me a soft, natural glow throughout the day. My skin looks healthier and more refreshed." }, @{ Name = "Hira"; Text = "I’ve been using it daily, and my skin feels hydrated without any oiliness. It’s perfect for my combination skin." }, @{ Name = "Mahnoor"; Text = "The texture is very smooth and absorbs quickly. My skin looks more even and feels really soft after using it." }, @{ Name = "Ali"; Text = "I like how it keeps my skin moisturized all day without feeling heavy. It’s simple, effective, and works really well." }, @{ Name = "Usman"; Text = "This moisturizer gives a clean, fresh feel, and my skin looks brighter with regular use. Definitely part of my daily routine now." })
    },
    # 3. Centella Face Wash
    [PSCustomObject]@{
        File = "product.face-wash.liquid"
        Title = "Centella Face Wash"
        Subtitle = "Pure Start"
        Price = "1,800"
        Description = "A gentle, glow-reviving cleanser infused with Centella Asiatica, brightening actives, and hydrating botanicals to cleanse, soothe, and refresh your skin for a soft, balanced, and radiant look every day."
        Benefits = @("Gently removes dirt, oil, and impurities without stripping the skin", "Helps brighten complexion and revive dull, tired-looking skin", "Supports hydration for a soft, fresh, and balanced feel", "Calms irritation and reduces the look of redness", "Helps maintain a healthy skin barrier for daily protection")
        Application = "After wetting your face, take a small amount of Centella Face Wash and gently massage onto skin in circular motions for about 60 seconds. Rinse thoroughly with water and pat dry, then follow with your skincare routine."
        Tricks = @("Use lukewarm water to avoid drying out your skin while cleansing", "Massage gently for a full 60 seconds to allow ingredients to work effectively", "Follow immediately with serum or moisturizer on damp skin to lock in hydration")
        Ingredients = @("3-0-Ethyl Ascorbic Acid", "Hyaluronic Acid", "Rice Extract", "Licorice Extract", "Morus Alba", "Centella Asiatica", "Honey", "D-Panthenol", "Sodium PCA", "Glycerin", "Apple Extract")
        CatchyLine = "Fresh Skin Begins Here"
        ImportantInfo = @{ Headline = "Cleanse. Refresh. Glow."; GoodFor = "All skin types, especially dull, sensitive, or acne-prone skin"; FeelsLike = "A soft, airy lather that cleanses gently without tightness"; LooksLike = "Fresh, clear skin with a natural, healthy glow"; SmellsLike = "Light, clean freshness that feels calming and pure"; FYI = "Halal-Friendly • Dermatologist-Tested • Non-Drying • Gentle for Daily Use" }
        WhatsInside = @{ Intro = "Our formula is powered by gentle cleansers and glow-boosting hydrators. Meet 2 of our favorites for a fresh, balanced cleanse."; I1Title = "hyaluronic acid"; I1Desc = "a moisture-binding ingredient that helps keep skin hydrated and plump while cleansing, preventing dryness and tightness"; I2Title = "3-o-ethyl ascorbic acid"; I2Desc = "a stable form of vitamin C that helps brighten the complexion, reduce dullness, and support a more radiant, even look"; Also = "RICE EXTRACT, LICORICE EXTRACT, MORUS ALBA, HONEY, D-PANTHENOL, SODIUM PCA, GLYCERIN, APPLE EXTRACT, CENTELLA ASIATICA" }
        SpreadItOn = @("fresh, balanced skin", "gentle daily cleansing", "natural, radiant glow")
        Stats = @(@{ Pct = "99%"; Desc = "SAID THEIR SKIN FELT CLEAN + REFRESHED AFTER EVERY WASH" }, @{ Pct = "98%"; Desc = "SAID IT DID NOT DRY OUT THEIR SKIN" }, @{ Pct = "97%"; Desc = "SAID THEIR SKIN LOOKED CLEARER + MORE BALANCED" }, @{ Pct = "3 out of 4"; Desc = "SAID THEY NOTICED LESS DULLNESS WITH DAILY USE" })
        StatsDisclaimer = "*Based on a 2-week consumer perception study with consistent daily use."
        FAQs = @(@{ Q = "Can I use this face wash twice a day?"; A = "Yes, it is gentle enough for both morning and evening use without over-drying your skin." }, @{ Q = "Is it suitable for sensitive skin?"; A = "Yes, the formula includes calming ingredients like Centella Asiatica and honey, making it ideal for sensitive skin." }, @{ Q = "Will it help with acne or breakouts?"; A = "It helps cleanse pores, remove excess oil, and soothe irritation, which can support clearer skin over time." }, @{ Q = "Does it remove makeup?"; A = "It can remove light makeup, but for heavy or waterproof makeup, use a remover before cleansing." }, @{ Q = "Will my skin feel dry after washing?"; A = "No, it is designed to maintain hydration and leave your skin feeling soft and balanced." })
        Reviews = @(@{ Name = "Areeba"; Text = "I love how gentle this face wash feels on my skin. It cleans properly without making my skin dry, and my face looks fresh after every wash." }, @{ Name = "Mehwish"; Text = "My skin feels so soft and clean after using it. I’ve noticed less dullness and my complexion looks more even now." }, @{ Name = "Kiran"; Text = "It’s very mild yet effective. My skin doesn’t feel tight anymore after washing, and it actually feels hydrated." }, @{ Name = "Bilal"; Text = "This face wash gives a really clean feeling without irritation. My skin looks clearer and feels balanced throughout the day." }, @{ Name = "Hamza"; Text = "I’ve been using it daily and my skin feels healthier overall. It’s simple, gentle, and does exactly what I needed." })
    }
    # (Remaining 12 products defined similarly in the final script)
)

function Update-Template($p) {
    Write-Host "Updating $($p.File)..."
    $c = $masterHtml
    
    # 0. Layout
    $c = "{% layout none %}`n" + $c

    # 1. Product Metadata
    $titleHtml = $p.Title -replace " ", "<br>"
    $c = $c -replace 'class="product-title">Centella<br>Night Cream', "class=`"product-title`">$titleHtml"
    $c = $c -replace '<title>Centella Night Cream', "<title>$($p.Title)"
    $c = $c -replace 'class="product-subtitle">Night Renewal', "class=`"product-subtitle`">$($p.Subtitle)"
    $c = $c -replace 'ADD TO BAG - <span>Rs. 1,500</span>', "ADD TO BAG - <span>Rs. $($p.Price)</span>"
    $c = $c -replace 'RS. 2,660', "RS. $($p.Price)"
    $c = $c -replace '2,660', $p.Price
    
    # 2. Description
    $c = $c -replace '(?s)<div class="product-description">.*?</div>', "<div class=`"product-description`">`n            <p>$($p.Description)</p>`n            <p class=`"disclaimer`">*with continued daily use</p>`n          </div>"

    # 3. Benefits Accordion
    $benefitsHtml = "<ul>`n"
    foreach ($item in $p.Benefits) { $benefitsHtml += "                  <li>$item</li>`n" }
    $benefitsHtml += "                </ul>"
    $c = $c -replace '(?s)<summary><span>BENEFITS</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', "<summary><span>BENEFITS</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                $benefitsHtml`n              </div>"

    # 4. Application Accordion
    $c = $c -replace '(?s)<summary><span>APPLICATION</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', "<summary><span>APPLICATION</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                <p style=`"margin:0;`">$($p.Application)</p>`n              </div>"

    # 5. Tricks Accordion
    $tricksHtml = "<ul>`n"
    foreach ($item in $p.Tricks) { $tricksHtml += "                  <li>$item</li>`n" }
    $tricksHtml += "                </ul>"
    $c = $c -replace '(?s)<summary><span>TRICK</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', "<summary><span>TRICK</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                $tricksHtml`n              </div>"

    # 6. Key Ingredients Accordion
    $ingredHtml = "<ul>`n"
    foreach ($item in $p.Ingredients) { $ingredHtml += "                  <li>$item</li>`n" }
    $ingredHtml += "                </ul>"
    $c = $c -replace '(?s)<summary><span>KEY INGREDIENTS</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', "<summary><span>KEY INGREDIENTS</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                $ingredHtml`n              </div>"

    # 7. Catchy Line
    $c = $c -replace '<h2 class="meet-title">Your Overnight Glow Secret</h2>', "<h2 class=`"meet-title`">$($p.CatchyLine)</h2>"

    # 8. Important Info (Breakdown Table)
    $c = $c -replace '<h2 class="bd-title">Wake Up to Refreshed, Radiant Skin.</h2>', "<h2 class=`"bd-title`">$($p.ImportantInfo.Headline)</h2>"
    $c = $c -replace '<span class="bd-val">All skin types, including dry and sensitive skin</span>', "<span class=`"bd-val`">$($p.ImportantInfo.GoodFor)</span>"
    $c = $c -replace '<span class="bd-val">A rich, creamy formula that melts effortlessly into the skin</span>', "<span class=`"bd-val`">$($p.ImportantInfo.FeelsLike)</span>"
    $c = $c -replace '<span class="bd-val">Smooth, plump, and poreless skin by morning</span>', "<span class=`"bd-val`">$($p.ImportantInfo.LooksLike)</span>"
    $c = $c -replace '<span class="bd-val">Subtle, calming freshness for a relaxing nighttime routine</span>', "<span class=`"bd-val`">$($p.ImportantInfo.SmellsLike)</span>"
    $c = $c -replace '<span class="bd-val">Halal-Friendly • Dermatologist-Tested • Non-Sticky • Repair-Focused</span>', "<span class=`"bd-val`">$($p.ImportantInfo.FYI)</span>"

    # 9. What's Inside
    $c = $c -replace '<p class="wi-intro">Our formula is powered by advanced repair and brightening actives. Meet 2 of our favorites for overnight renewal.</p>', "<p class=`"wi-intro`">$($p.WhatsInside.Intro)</p>"
    $c = $c -replace '<h3 class="wi-ingred-title">centella asiatica</h3>', "<h3 class=`"wi-ingred-title`">$($p.WhatsInside.I1Title)</h3>"
    $c = $c -replace '<p class="wi-ingred-desc">a calming botanical that helps repair the skin barrier, reduce redness, and support healthier, more resilient skin overnight</p>', "<p class=`"wi-ingred-desc`">$($p.WhatsInside.I1Desc)</p>"
    $c = $c -replace '<h3 class="wi-ingred-title">moisture-lock technology</h3>', "<h3 class=`"wi-ingred-title`">$($p.WhatsInside.I2Title)</h3>"
    $c = $c -replace '<p class="wi-ingred-desc">a deep hydration system that helps retain moisture, prevent overnight dryness, and keep skin plump and smooth by morning</p>', "<p class=`"wi-ingred-desc`">$($p.WhatsInside.I2Desc)</p>"
    $c = $c -replace 'also made with <strong>BRIGHTENING COMPLEX, COLLAGEN SUPPORT BLEND, SPOT-CORRECTIVE ACTIVES, LINE-REDUCING COMPLEX, BARRIER REPAIR ACTIVES, EVEN-TONE ENHANCERS</strong>', "also made with <strong>$($p.WhatsInside.Also)</strong>"

    # 10. Spread It On For
    $c = $c -replace '<h2 class="spread-heading">deep repair</h2>', "<h2 class=`"spread-heading`">$($p.SpreadItOn[0])</h2>"
    $c = $c -replace '<h2 class="spread-heading">overnight hydration</h2>', "<h2 class=`"spread-heading`">$($p.SpreadItOn[1])</h2>"
    $c = $c -replace '<h2 class="spread-heading spread-green">revitalized, luminous skin</h2>', "<h2 class=`"spread-heading spread-green`">$($p.SpreadItOn[2])</h2>"

    # 11. Stats
    $c = $c -replace '<div class="stat-pct">97%</div>', "<div class=`"stat-pct`">$($p.Stats[0].Pct)</div>"
    $c = $c -replace '<div class="stat-desc">SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED</div>', "<div class=`"stat-desc`">$($p.Stats[0].Desc)</div>"
    $c = $c -replace '<div class="stat-pct">95%</div>', "<div class=`"stat-pct`">$($p.Stats[1].Pct)</div>"
    $c = $c -replace '<div class="stat-desc">SAID IT ABSORBED WELL WITHOUT HEAVINESS</div>', "<div class=`"stat-desc`">$($p.Stats[1].Desc)</div>"
    $c = $c -replace '<div class="stat-pct">94%</div>', "<div class=`"stat-pct`">$($p.Stats[2].Pct)</div>"
    $c = $c -replace '<div class="stat-desc">NOTICED SMOOTHER, SOFTER, AND REFINED SKIN BY MORNING</div>', "<div class=`"stat-desc`">$($p.Stats[2].Desc)</div>"
    $c = $c -replace '<div class="stat-pct">3 out of 4</div>', "<div class=`"stat-pct`">$($p.Stats[3].Pct)</div>"
    $c = $c -replace '<div class="stat-desc">REPORTED A VISIBLE REDUCTION IN FINE LINES AND DARK SPOTS</div>', "<div class=`"stat-desc`">$($p.Stats[3].Desc)</div>"
    $c = $c -replace '\*Based on a 2-week consumer perception study with consistent nightly use.', $p.StatsDisclaimer

    # 12. FAQs
    $faqHtml = ""
    foreach ($f in $p.FAQs) {
        $faqHtml += "<details class=`"faq-item`">`n          <summary><span>$($f.Q)</span><span>+</span></summary>`n          <div class=`"faq-answer`">$($f.A)</div>`n        </details>`n        "
    }
    $c = $c -replace '(?s)<div class="faq-list">.*?</div>', "<div class=`"faq-list`">`n        $faqHtml`n      </div>"

    # 13. Reviews
    $reviewsHtml = ""
    foreach ($r in $p.Reviews) {
        $reviewsHtml += "<div class=`"customer-review-card`">`n          <div class=`"review-stars`">★★★★★</div>`n          <p class=`"review-text`">`“$($r.Text)`”</p>`n          <p class=`"review-author`">— $($r.Name)</p>`n        </div>`n        "
    }
    $c = $c -replace '(?s)<div class="reviews-scroll">.*?</div>', "<div class=`"reviews-scroll`">`n        $reviewsHtml`n      </div>"

    # Asset URL Conversion (Enforce double-single quotes for Liquid)
    $c = [regex]::Replace($c, 'src="\./assets/([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"', 'src="{{ ''$1'' | asset_url }}"')
    $c = [regex]::Replace($c, 'src="([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"', 'src="{{ ''$1'' | asset_url }}"')

    $targetPath = "$templatesDir\$($p.File)"
    Set-Content -Path $targetPath -Value $c -Encoding UTF8
}

foreach ($p in $productData) {
    Update-Template $p
}

Write-Host "Site-wide Content Overhaul Complete."
