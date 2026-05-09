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

function Test-Alg($data_str, $mod, $seed_start, $mapping) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($data_str)
    $len = $data.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = $seed_start
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
        $out[$i] = Get-Char ($seed % $mod) $mapping
    }
    return -join $out
}

$imei = "862624055623767"
$mac = "D8:42:F7:B2:3A:8C"
$target = "dA5nzSYa"

$inputs = @($imei, $mac, $mac.ToLower(), $mac.Replace(":",""), $mac.Replace(":","").ToLower())
$mods = @(52, 62)
$mappings = @(0, 1)

Write-Host "Brute forcing..."
foreach ($inp in $inputs) {
    foreach ($mod in $mods) {
        foreach ($m in $mappings) {
            for ($s = 0; $s -le 20; $s++) {
                $res = Test-Alg $inp $mod $s $m
                if ($res -eq $target) {
                    Write-Host "FOUND! Input: $inp, Mod: $mod, Seed: $s, Mapping: $m" -ForegroundColor Green
                    exit
                }
            }
        }
    }
}
Write-Host "No standard match found."
