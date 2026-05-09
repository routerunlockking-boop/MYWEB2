function Get-Char-AZaz09([int]$m) {
    if ($m -lt 26) { return [char](65 + $m) } # A-Z
    if ($m -lt 52) { return [char](97 + $m - 26) } # a-z
    return [char](48 + $m - 52) # 0-9
}

function Generate-V5($data_str, $mod) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($data_str)
    $len = $data.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = 1
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
        $out[$i] = Get-Char-AZaz09 ($seed % $mod)
    }
    return -join $out
}

$imei = "862624055623767"
$target = "dA5nzSYa"

$res = Generate-V5 $imei 62
Write-Host "IMEI (A-Z, a-z, 0-9): $res"

if ($res -eq $target) {
    Write-Host "FOUND IT!" -ForegroundColor Green
}
