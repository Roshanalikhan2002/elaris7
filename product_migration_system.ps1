$sourceFile = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\night-cream.html"
$templatesDir = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"
$jsonDataPath = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\product_data.json"

$masterHtml = [System.IO.File]::ReadAllText($sourceFile, [System.Text.Encoding]::UTF8)
$jsonRaw = [System.IO.File]::ReadAllText($jsonDataPath, [System.Text.Encoding]::UTF8)
$products = $jsonRaw | ConvertFrom-Json

function Update-Template($p) {
    Write-Host "Syncing $($p.File)..."
    $c = $masterHtml
    
    # Prefix layout none
    $c = "{% layout none %}`n" + $c

    # 1. Product Metadata
    $titleWithBr = $p.Title.Replace(" ", "<br>")
    $c = $c.Replace('class="product-title">Centella<br>Night Cream', "class=`"product-title`">$titleWithBr")
    $c = $c.Replace('<title>Centella Night Cream', "<title>$($p.Title)")
    $c = $c.Replace('class="product-subtitle">Night Renewal', "class=`"product-subtitle`">$($p.Subtitle)")
    $c = $c.Replace('ADD TO BAG - <span>Rs. 2,660</span>', "ADD TO BAG - <span>Rs. $($p.Price)</span>")
    
    # Generic Prices
    $c = $c.Replace('2,660', $p.Price)
    $c = $c.Replace('1,500', $p.Price)

    # 2. Description
    # Use -replace with [regex]::Escape for the target
    $oldDescPattern = '(?s)<div class="product-description">.*?</div>'
    $newDesc = "<div class=`"product-description`">`n            <p>$($p.Description)</p>`n            <p class=`"disclaimer`">*with continued daily use</p>`n          </div>"
    $c = [Regex]::Replace($c, $oldDescPattern, $newDesc)

    # 3. Benefits
    $benefitItems = ""
    foreach ($item in $p.Benefits) { $benefitItems += "                  <li>$item</li>`n" }
    $newBenefits = "<summary><span>BENEFITS</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                <ul>`n$benefitItems                </ul>`n              </div>"
    $c = [Regex]::Replace($c, '(?s)<summary><span>BENEFITS</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', $newBenefits)

    # 4. Application
    $newApp = "<summary><span>APPLICATION</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                <p style=`"margin:0;`">$($p.Application)</p>`n              </div>"
    $c = [Regex]::Replace($c, '(?s)<summary><span>APPLICATION</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', $newApp)

    # 5. Tricks
    $trickItems = ""
    foreach ($item in $p.Tricks) { $trickItems += "                  <li>$item</li>`n" }
    $newTricks = "<summary><span>TRICK</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                <ul>`n$trickItems                </ul>`n              </div>"
    $c = [Regex]::Replace($c, '(?s)<summary><span>TRICK</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', $newTricks)

    # 6. Ingredients
    $ingredItems = ""
    foreach ($item in $p.Ingredients) { $ingredItems += "                  <li>$item</li>`n" }
    $newIngreds = "<summary><span>KEY INGREDIENTS</span><span>+</span></summary>`n              <div class=`"accordion-content`">`n                <ul>`n$ingredItems                </ul>`n              </div>"
    $c = [Regex]::Replace($c, '(?s)<summary><span>KEY INGREDIENTS</span><span>\+</span></summary>.*?<div class="accordion-content">.*?</div>', $newIngreds)

    # 7. Catchy Line
    $c = $c.Replace('<h2 class="meet-title">Your Overnight Glow Secret</h2>', "<h2 class=`"meet-title`">$($p.CatchyLine)</h2>")

    # 8. Important Info
    $c = $c.Replace('<h2 class="bd-title">Wake Up to Refreshed, Radiant Skin.</h2>', "<h2 class=`"bd-title`">$($p.ImportantInfo.Headline)</h2>")
    $c = $c.Replace('<span class="bd-val">All skin types, including dry and sensitive skin</span>', "<span class=`"bd-val`">$($p.ImportantInfo.GoodFor)</span>")
    $c = $c.Replace('<span class="bd-val">A rich, creamy formula that melts effortlessly into the skin</span>', "<span class=`"bd-val`">$($p.ImportantInfo.FeelsLike)</span>")
    $c = $c.Replace('<span class="bd-val">Smooth, plump, and poreless skin by morning</span>', "<span class=`"bd-val`">$($p.ImportantInfo.LooksLike)</span>")
    $c = $c.Replace('<span class="bd-val">Subtle, calming freshness for a relaxing nighttime routine</span>', "<span class=`"bd-val`">$($p.ImportantInfo.SmellsLike)</span>")
    $c = $c.Replace('<span class="bd-val">Halal-Friendly • Dermatologist-Tested • Non-Sticky • Repair-Focused</span>', "<span class=`"bd-val`">$($p.ImportantInfo.FYI)</span>")

    # 9. What's Inside
    $c = $c.Replace('Our formula is powered by advanced repair and brightening actives. Meet 2 of our favorites for overnight renewal.', $p.WhatsInside.Intro)
    $c = $c.Replace('<h3 class="wi-ingred-title">centella asiatica</h3>', "<h3 class=`"wi-ingred-title`">$($p.WhatsInside.I1Title)</h3>")
    $c = $c.Replace('<p class="wi-ingred-desc">a calming botanical that helps repair the skin barrier, reduce redness, and support healthier, more resilient skin overnight</p>', "<p class=`"wi-ingred-desc`">$($p.WhatsInside.I1Desc)</p>")
    $c = $c.Replace('<h3 class="wi-ingred-title">moisture-lock technology</h3>', "<h3 class=`"wi-ingred-title`">$($p.WhatsInside.I2Title)</h3>")
    $c = $c.Replace('<p class="wi-ingred-desc">a deep hydration system that helps retain moisture, prevent overnight dryness, and keep skin plump and smooth by morning</p>', "<p class=`"wi-ingred-desc`">$($p.WhatsInside.I2Desc)</p>")
    $c = $c.Replace('also made with <strong>BRIGHTENING COMPLEX, COLLAGEN SUPPORT BLEND, SPOT-CORRECTIVE ACTIVES, LINE-REDUCING COMPLEX, BARRIER REPAIR ACTIVES, EVEN-TONE ENHANCERS</strong>', "also made with <strong>$($p.WhatsInside.Also)</strong>")

    # 10. Spread It On For
    $c = $c.Replace('<h2 class="spread-heading">deep repair</h2>', "<h2 class=`"spread-heading`">$($p.SpreadItOn[0])</h2>")
    $c = $c.Replace('<h2 class="spread-heading">overnight hydration</h2>', "<h2 class=`"spread-heading`">$($p.SpreadItOn[1])</h2>")
    $c = $c.Replace('<h2 class="spread-heading spread-green">revitalized, luminous skin</h2>', "<h2 class=`"spread-heading spread-green`">$($p.SpreadItOn[2])</h2>")

    # 11. Stats
    $c = $c.Replace('97%', $p.Stats[0].Pct)
    $c = $c.Replace('SAID THEIR SKIN FELT DEEPLY HYDRATED AND NOURISHED', $p.Stats[0].Desc)
    if ($p.Stats.Count -gt 1) {
        $c = $c.Replace('95%', $p.Stats[1].Pct)
        $c = $c.Replace('SAID IT ABSORBED WELL WITHOUT HEAVINESS', $p.Stats[1].Desc)
    }
    $c = $c.Replace('*Based on a 2-week consumer perception study with consistent nightly use.', $p.StatsDisclaimer)

    # 12. FAQs
    $faqItems = ""
    foreach ($f in $p.FAQs) {
        $faqItems += "<details class=`"faq-item`">`n          <summary><span>$($f.Q)</span><span>+</span></summary>`n          <div class=`"faq-answer`">$($f.A)</div>`n        </details>`n"
    }
    $c = [Regex]::Replace($c, '(?s)<div class="faq-list">.*?</div>', "<div class=`"faq-list`">`n        $faqItems      </div>")

    # 13. Reviews
    $reviewCards = ""
    foreach ($r in $p.Reviews) {
        $reviewCards += "<div class=`"customer-review-card`">`n"
        $reviewCards += "          <div class=`"review-stars`">★★★★★</div>`n"
        $reviewCards += "          <p class=`"review-text`">$($r.Text)</p>`n"
        $reviewCards += "          <p class=`"review-author`">— $($r.Name)</p>`n"
        $reviewCards += "        </div>`n"
    }
    $c = [Regex]::Replace($c, '(?s)<div class="reviews-scroll">.*?</div>', "<div class=`"reviews-scroll`">`n        $reviewCards      </div>")

    # 14. IMAGES
    $c = $c.Replace('night-cream-suite.jpeg', $p.Images.Hero)
    $c = $c.Replace('nightcream-v3-1.jpeg', $p.Images.Gallery[0])
    $c = $c.Replace('nightcream-v3-2.jpeg', $p.Images.Gallery[1])
    $c = $c.Replace('nightcream-v3-3.jpeg', $p.Images.Gallery[2])
    $c = $c.Replace('nightcream-v3-4.jpeg', $p.Images.Gallery[3])
    $c = $c.Replace('plate.jpeg', $p.Images.Breakdown)
    $c = $c.Replace('spoon.jpeg', $p.Images.WhatsInside)
    $c = $c.Replace('spread.jpeg', $p.Images.Spread)
    $c = $c.Replace('percentage.jpeg', $p.Images.Stats)
    $c = $c.Replace('night-cream-swatch.jpeg', $p.Images.Carousel[1])
    $c = $c.Replace('night-cream-lifestyle.jpeg', $p.Images.Carousel[2])
    $c = $c.Replace('night-cream-last.jpeg', $p.Images.Carousel[3])

    # Asset URL Conversion
    $pattern = 'src="(?:\./assets/|)([\w\.-]+\.(?:jpg|png|jpeg|webp|gif|svg))"'
    $replace = 'src="{{ ''$1'' | asset_url }}"'
    $c = [regex]::Replace($c, $pattern, $replace)

    $targetPath = Join-Path $templatesDir $p.File
    [System.IO.File]::WriteAllText($targetPath, $c, [System.Text.Encoding]::UTF8)
}

foreach ($p in $products) {
    Update-Template $p
}

Write-Host "Site-wide Content Overhaul Complete."
