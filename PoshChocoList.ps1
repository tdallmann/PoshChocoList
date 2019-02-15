[xml]$Doc = New-Object System.Xml.XmlDocument
$dec = $Doc.CreateXmlDeclaration("1.0","UTF-8",$null)
$doc.AppendChild($dec) | Out-Null

$comment = @"

Chocolatey Installation List
Generated $(Get-Date)

"@
$doc.AppendChild($doc.CreateComment($comment)) | Out-Null

$root = $doc.CreateNode('element','packages',$null)

choco list -lo -r | ForEach-Object {
    $package = $_
    $parts = $package -split '\|'
    $pnode = $doc.CreateNode('element', 'package', $null)
    $pnode.SetAttribute('id', $parts[0])
    $pnode.SetAttribute('version', $parts[1])
    $root.AppendChild($pnode) | Out-Null
}
$doc.AppendChild($root) | Out-Null
$Doc.Save("$PSScriptRoot\Packages.config")

