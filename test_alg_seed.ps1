function Get-AlphabetChar([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($m -lt 36) { return [char](55 + $m) }
    return [char](61 + $m)
}

function Generate-Variant($data, $mod, $startSeed) {
    $out = New-Object char[] 8
    $len = $data.Count
    for ($i = 0; $i -lt 8; $i++) {
        $seed = $startSeed
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
$macNoColons = "D842F7B23A8C"

$testInputs = @(
    @{ name="IMEI"; val=$imei },
    @{ name="MAC"; val=$mac },
    @{ name="MAC No Colons"; val=$macNoColons },
    @{ name="MAC No Colons Lower"; val=$macNoColons.ToLower() }
)

foreach ($input in $testInputs) {
    $data = [System.Text.Encoding]::ASCII.GetBytes($input.val)
    for ($s = 0; $s -le 15; $s++) {
        $res = Generate-Variant $data 62 $s
        if ($res -eq "dA5nzSYa") {
            Write-Host "FOUND! Input: $($input.name), StartSeed: $s, Mod: 62" -ForegroundColor Green
        }
    }
}
