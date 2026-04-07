import os
import json

templates_dir = r"c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"
product_files = [f for f in os.listdir(templates_dir) if f.startswith("product.") and f.endswith(".json")]

# Skip the ones we already handled or special ones if needed
# But better to just check if 'benefits_focus' is already there
already_updated = []

benefits_focus_section = {
    "type": "product-benefits-focus",
    "settings": {
        "subtitle": "SPREAD IT ON FOR:",
        "image": "shopify://shop_images/night_cream_4-100_jpg.jpg"
    }
}

for filename in product_files:
    if filename == "product.json": continue # handled manually or skip
    path = os.path.join(templates_dir, filename)
    
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Handle the leading Shopify comments if they exist
    json_start = content.find('{')
    if json_start == -1: continue
    
    comments = content[:json_start]
    json_text = content[json_start:]
    
    try:
        data = json.loads(json_text)
    except json.JSONDecodeError:
        print(f"Skipping {filename} due to JSON error")
        continue

    if "benefits_focus" not in data["sections"]:
        data["sections"]["benefits_focus"] = benefits_focus_section
        
        # Insert into order before study_results if possible, or after ingredients
        order = data.get("order", [])
        if "benefits_focus" not in order:
            if "study_results" in order:
                idx = order.index("study_results")
                order.insert(idx, "benefits_focus")
            elif "ingredients" in order:
                idx = order.index("ingredients")
                order.insert(idx + 1, "benefits_focus")
            else:
                order.append("benefits_focus")
        
        # Write back
        new_json = json.dumps(data, indent=2)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(comments + new_json)
        already_updated.append(filename)

print(f"Updated: {already_updated}")
