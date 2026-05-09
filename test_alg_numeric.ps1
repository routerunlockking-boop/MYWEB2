function Get-Char([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($m -lt 36) { return [char](55 + $m) }
    return [char](61 + $m)
}

function Test-Numeric($data_bytes, $mod) {
    $len = $data_bytes.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = 1
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data_bytes[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
        $out[$i] = Get-Char ($seed % $mod)
    }
    return -join $out
}

$imei = "862624055623767"
$target = "dA5nzSYa"

# Numeric values: [8, 6, 2, ...]
$numericData = $imei.ToCharArray() | ForEach-Object { [int][string]$_ }

$res = Test-Numeric $numericData 62
Write-Host "IMEI Numeric (mod 62): $res"

if ($res -eq $target) { Write-Host "FOUND IT!" -ForegroundColor Green }
