function Get-Char([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($m -lt 36) { return [char](55 + $m) }
    return [char](61 + $m)
}

function Test-NoMask($data_str, $mod) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($data_str)
    $len = $data.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = 1
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) # NO & 0xff
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
        $out[$i] = Get-Char ($seed % $mod)
    }
    return -join $out
}

$imei = "862624055623767"
$target = "dA5nzSYa"

$res = Test-NoMask $imei 62
Write-Host "IMEI No Mask (mod 62): $res"

if ($res -eq $target) { Write-Host "MATCH!" -ForegroundColor Green }
