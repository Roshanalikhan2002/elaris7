# PowerShell script to update fallback arrays in featured-products.liquid
$f = "c:\Users\MY PC\OneDrive\Desktop\Elaris7\sections\featured-products.liquid"
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# 1. Update fallback_names
$c = $c -replace '(?s)fallback_names = "(.*?)"', 'fallback_names = "Oil to Foam Cleanser,Gel Cleanser,Hair Regrow Spray,Night Cream,Tranexamic Serum,Anti Frizz Keratin Serum,Glow Serum,Glutathione Cream,Floral Blossom Hair Mist,Face Wash,Anti Acne,Sunscreen SPF60+,Renewal Cleanser,Hydra Burst Moisturizer,Renewal Toner"'

# 2. Update fallback_images (adding placeholders/placeholders for now)
$c = $c -replace '(?s)fallback_images = "(.*?)"', 'fallback_images = "facewash1.jpeg,gel cleanser-100.jpg,hair-mist.jpg,night-cream.jpg,tranexamic-serum.jpg,keratin-serum.jpg,glow-serum-100.jpg,glutathione-cream-100.jpg,hair-mist.jpg,facewash-100.jpg,anti-acne-100.jpg,sunscreen-100.jpg,renewal-cleanser-1.jpg,moisturizer-100.jpg,toner1.jpeg"'

# 3. Update fallback_hovers
$c = $c -replace '(?s)fallback_hovers = "(.*?)"', 'fallback_hovers = "facewash2.jpg,deep-hydration-facewash.jpg,hair-mist-hover.jpg,night-cream-hover.jpg,tranexamic-meet-1.jpg,keratin-serum-hover.jpg,glow-serum-hover.jpg,deep-hydration-100.jpg,hair-mist-hover.jpg,deep-hydration-facewash.jpg,hover-anti-acne.png,sunscreen-hover.jpg,renewal-cleanser-2.jpg,moisturizer-hover.jpg,toner-hover.jpg"'

# 4. Update fallback_labels
$c = $c -replace '(?s)fallback_labels = "(.*?)"', 'fallback_labels = "korean-glass-skin,korean-brightening,hair-care,korean-glass-skin,korean-brightening,hair-care,korean-glass-skin,korean-brightening,hair-care,korean-glass-skin,anti-acne,korean-glass-skin,korean-glass-skin,korean-glass-skin,featured"'

# 5. Fix loop range (from 0 to 14 now)
$c = $c -replace 'for i in \(0\.\.12\)', 'for i in (0..14)'

# 6. Add phandle cases
$phandleInsert = @"
        {%- elsif pname == "Oil to Foam Cleanser" -%}
          {%- assign phandle = "oil-to-foam-cleanser" -%}
        {%- elsif pname == "Gel Cleanser" -%}
          {%- assign phandle = "gel-cleanser" -%}
        {%- elsif pname == "Hair Regrow Spray" -%}
          {%- assign phandle = "hair-regrow-spray" -%}
"@

# Match the existing set/bundle check to insert BEFORE it or update it
if ($c -match '{%- elsif pname contains "Set" or pname contains "Bundle" -%}\s+{%- assign phandle = "elaris-7-korean-glass-skin-bundle" -%}\s+{%- elsif pname == "Oil to Foam Cleanser" -%}\s+{%- assign phandle = "oil-to-foam-cleanser" -%}\s+{%- endif -%}') {
    # Remove the partial one I added before
    $c = $c -replace '{%- elsif pname == "Oil to Foam Cleanser" -%}\s+{%- assign phandle = "oil-to-foam-cleanser" -%}', ''
}

# Surgical insertion in the phandle block
$c = $c -replace '\{%- assign phandle = "elaris-7-korean-glass-skin-bundle" -%\}', "{%- assign phandle = `"elaris-7-korean-glass-skin-bundle`" -%}$phandleInsert"

# 7. Add price cases
$priceInsert = @"
                {%- when 'oil-to-foam-cleanser' -%}{%- assign custom_price = "2,620" -%}
                {%- when 'gel-cleanser' -%}{%- assign custom_price = "2,620" -%}
                {%- when 'hair-regrow-spray' -%}{%- assign custom_price = "2,960" -%}
"@
$c = $c -replace '\{%- when \x27renewal-toner\x27 or \x27renewal-toner-v2\x27 -%\}\x7B%- assign custom_price = \x222,780\x22 -%\}', "{%- when 'renewal-toner' or 'renewal-toner-v2' -%}{%- assign custom_price = `"2,780`" -%}$priceInsert"

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "Updated featured-products labels and handles"
