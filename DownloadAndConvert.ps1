$url = "https://isc.sans.edu/block.txt"
$outputFile = "c:\\output.csv"
$wc = New-Object System.Net.WebClient
# ------------------------
# Use These lines if you're behind a proxy
# $proxy = New-Object System.Net.WebProxy("x.x.x.x", yyyy)
# $proxy.Credentials = (Get-Credential).GetNetworkCredential()
# $wc.Proxy = $proxy
# ------------------------
$html = $wc.DownloadString($url)
$output = ""
foreach($i in $html.Split("`n"))
{
    if($i -Match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")
    {
        $values = $i.Split("`t")
        $start = $values[0]
        $end = $values[1]
        $block = $values[2]
        if($block -eq "24")
        {
            $startPoints= $start.Split(".")
            $prefix = $startPoints[0] + "." + $startPoints[1] + "." + $startPoints[2] + "."
            for($p = 0 ; $p -le 255 ; $p++)
            {
                $output += $prefix + $p + ","
            }
        }
        else
        {
            Write-Host "Script only works for Netblocks of "$block
        }
        
    }
}
Write-Output $output | Out-File $outputFile
Write-Host "Wrote to "$outputFile
