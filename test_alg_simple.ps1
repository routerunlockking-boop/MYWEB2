function Get-Char([int]$m, [int]$mapping) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($mapping -eq 0) {
        if ($m -lt 36) { return [char](55 + $m) }
        return [char](61 + $m)
    } else {
        if ($m -lt 36) { return [char](87 + $m) }
        return [char](29 + $m)
    }
}

function Test-Simple($data_str, $mod, $seed_start, $mapping) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($data_str)
    $len = $data.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = $seed_start
        for ($j = 0; $j -lt $len; $j++) {
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product) -band 0xffffff
        }
        $out[$i] = Get-Char ($seed % $mod) $mapping
    }
    return -join $out
}

$imei = "862624055623767"
$target = "dA5nzSYa"

foreach ($s in 0..10) {
    $res = Test-Simple $imei 62 $s 0
    if ($res -eq $target) { Write-Host "MATCH! Seed: $s" -ForegroundColor Green }
    Write-Host "Seed $s: $res"
}
