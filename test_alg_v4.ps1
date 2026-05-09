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

function Generate-V4($data_str, $mod, $seed_start) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($data_str)
    $len = $data.Count
    $out = New-Object char[] 8
    for ($i = 0; $i -lt 8; $i++) {
        $seed = $seed_start
        for ($j = 0; $j -lt $len; $j++) {
            # Variant: No inversion inside loop, but mask
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product) -band 0xffffff
        }
        # Inversion ONLY at the end?
        $seed = (-bnot $seed) -band 0xffffff
        $out[$i] = Get-Char ($seed % $mod) 0
    }
    return -join $out
}

$imei = "862624055623767"
$target = "dA5nzSYa"

foreach ($s in 0..10) {
    $res = Generate-V4 $imei 62 $s
    if ($res -eq $target) { Write-Host "MATCH! Seed: $s" -ForegroundColor Green }
    Write-Host "V4 Seed $s: $res"
}
