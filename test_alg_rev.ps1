function Get-Char([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($m -lt 36) { return [char](55 + $m) }
    return [char](61 + $m)
}

function Test-Variant($data_str, $mod) {
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
        $out[$i] = Get-Char ($seed % $mod)
    }
    return -join $out
}

$mac = "D842F7B23A8C"
$target = "dA5nzSYa"

# Test Reversed MAC
$macRev = (-join $mac[($mac.Length-1)..0])
$res = Test-Variant $macRev 62
Write-Host "MAC Reversed (mod 62): $res"

# Test Reversed MAC Lower
$macRevLow = $macRev.ToLower()
$res = Test-Variant $macRevLow 62
Write-Host "MAC Reversed Lower (mod 62): $res"
