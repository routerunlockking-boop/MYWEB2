function Get-Char([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) } # 0-9
    if ($m -lt 36) { return [char](55 + $m) } # A-Z
    return [char](61 + $m) # a-z
}

function Test-Add($data_str, $mod, $seed_start) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($data_str)
    $len = $data.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = $seed_start
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
            $idx = ($i + $j) % $len
            $product = (($i + $j) + 1) -band 0xff # Additive instead of Multiplicative
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
        $out[$i] = Get-Char ($seed % $mod)
    }
    return -join $out
}

$imei = "862624055623767"
$target = "dA5nzSYa"

foreach ($s in 0..10) {
    $res = Test-Add $imei 62 $s
    if ($res -eq $target) { Write-Host "MATCH! Seed: $s" -ForegroundColor Green }
}
