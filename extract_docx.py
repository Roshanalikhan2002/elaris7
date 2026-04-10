import xml.etree.ElementTree as ET
import os

def extract_text_from_xml(xml_path):
    ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    paragraphs = []
    for p in root.findall('.//w:p', ns):
        texts = []
        for t in p.findall('.//w:t', ns):
            if t.text:
                texts.append(t.text)
        if texts:
            paragraphs.append("".join(texts))
        else:
            # Handle line breaks or empty paragraphs
            paragraphs.append("")
            
    return "\n".join(paragraphs)

xml_file = r'c:\Users\MY PC\OneDrive\Desktop\Elaris7\temp_docx\word\document.xml'
output_file = r'c:\Users\MY PC\OneDrive\Desktop\Elaris7\website_content.txt'

if os.path.exists(xml_file):
    txt_content = extract_text_from_xml(xml_file)
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(txt_content)
    print(f"Extraction successful: {output_file}")
else:
    print(f"Error: {xml_file} not found")
