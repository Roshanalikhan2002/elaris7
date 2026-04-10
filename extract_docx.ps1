[xml]$xml = Get-Content 'c:\Users\MY PC\OneDrive\Desktop\Elaris7\temp_docx\word\document.xml' -Encoding UTF8
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')
$nodes = $xml.SelectNodes('//w:p', $ns)
$output = New-Object System.Collections.Generic.List[string]
foreach ($p in $nodes) {
    $texts = $p.SelectNodes('.//w:t', $ns)
    if ($texts) {
        $fullText = ""
        foreach ($t in $texts) {
            $fullText += $t.'#text'
        }
        $output.Add($fullText)
    } else {
        $output.Add("")
    }
}
$output | Out-File 'c:\Users\MY PC\OneDrive\Desktop\Elaris7\website_content.txt' -Encoding UTF8
