function Get-Char([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($m -lt 36) { return [char](55 + $m) }
    return [char](61 + $m)
}

function Test-Xor-Inv($data_str, $mod) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($data_str)
    $len = $data.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = 1
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = $seed -bxor 0xffffff } # XOR inversion
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = $seed -bxor 0xffffff }
        $out[$i] = Get-Char ($seed % $mod)
    }
    return -join $out
}

$imei = "862624055623767"
$target = "dA5nzSYa"

$res = Test-Xor-Inv $imei 62
Write-Host "IMEI XOR Inv (mod 62): $res"
