function Get-AlphabetChar([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($m -lt 36) { return [char](55 + $m) }
    return [char](61 + $m)
}

function Generate-From($data, $mod) {
    $out = New-Object char[] 8
    $len = $data.Count
    for ($i = 0; $i -lt 8; $i++) {
        $seed = 1
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
        $out[$i] = Get-AlphabetChar ($seed % $mod)
    }
    return -join $out
}

$imei = "862624055623767"
$mac = "D8:42:F7:B2:3A:8C"
$salts = @("", "zlt", "tozed", "dialog", "admin", "s50", "ZLT", "TOZED", "DIALOG", "ADMIN", "S50")

foreach ($salt in $salts) {
    # Test IMEI + Salt
    $data = [System.Text.Encoding]::ASCII.GetBytes($imei + $salt)
    $res = Generate-From $data 62
    if ($res -eq "dA5nzSYa") { Write-Host "FOUND! IMEI + '$salt' (mod 62) = $res" -ForegroundColor Green }
    
    # Test Salt + IMEI
    $data = [System.Text.Encoding]::ASCII.GetBytes($salt + $imei)
    $res = Generate-From $data 62
    if ($res -eq "dA5nzSYa") { Write-Host "FOUND! '$salt' + IMEI (mod 62) = $res" -ForegroundColor Green }

    # Test MAC + Salt
    $data = [System.Text.Encoding]::ASCII.GetBytes($mac + $salt)
    $res = Generate-From $data 62
    if ($res -eq "dA5nzSYa") { Write-Host "FOUND! MAC + '$salt' (mod 62) = $res" -ForegroundColor Green }

    # Test Salt + MAC
    $data = [System.Text.Encoding]::ASCII.GetBytes($salt + $mac)
    $res = Generate-From $data 62
    if ($res -eq "dA5nzSYa") { Write-Host "FOUND! '$salt' + MAC (mod 62) = $res" -ForegroundColor Green }
}

# Try without colons
$macNoColons = $mac.Replace(":", "")
foreach ($salt in $salts) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($macNoColons + $salt)
    $res = Generate-From $data 62
    if ($res -eq "dA5nzSYa") { Write-Host "FOUND! MAC No Colons + '$salt' (mod 62) = $res" -ForegroundColor Green }
}
