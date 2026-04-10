import os
import json

templates_dir = r"c:\Users\MY PC\OneDrive\Desktop\Elaris7\templates"
product_files = [f for f in os.listdir(templates_dir) if f.startswith("product.") and f.endswith(".json")]

# Load product data for dynamic images
data_path = r"c:\Users\MY PC\OneDrive\Desktop\Elaris7\product_data.json"
try:
    with open(data_path, 'r', encoding='utf-8') as f:
        product_data = json.load(f)
except Exception as e:
    print(f"Could not load {data_path}: {e}")
    product_data = []

# Create a mapping from template filename to Spread image
image_map = {}
for pd in product_data:
    file_liquid = pd.get("File", "")
    # e.g. product.night-cream.liquid -> product.night-cream.json
    if file_liquid.endswith(".liquid"):
        file_json = file_liquid.replace(".liquid", ".json")
        img = pd.get("Images", {}).get("Spread", "spread.jpeg")
        image_map[file_json] = f"shopify://shop_images/{img}"

already_updated = []

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

    # Get the correct image or use a fallback
    spread_img = image_map.get(filename, "shopify://shop_images/spread.jpeg")

    benefits_focus_section = {
        "type": "product-benefits-focus",
        "settings": {
            "subtitle": "SPREAD IT ON FOR:",
            "image": spread_img
        }
    }

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
