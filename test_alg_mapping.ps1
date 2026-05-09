function Get-AlphabetChar-Variant([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) } # 0-9
    if ($m -lt 36) { return [char](87 + $m) } # a-z (97-122) -> 87 + 10 = 97
    return [char](29 + $m) # A-Z (65-90) -> 29 + 36 = 65
}

function Generate-Variant($data, $mod) {
    $out = New-Object char[] 8
    $len = $data.Count
    for ($i = 0; $i -lt 8; $i++) {
        $seed = 1
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) { $seed = (-bnot $seed) -band 0xffffff }
        $out[$i] = Get-AlphabetChar-Variant ($seed % $mod)
    }
    return -join $out
}

$imei = "862624055623767"
$data = [System.Text.Encoding]::ASCII.GetBytes($imei)
$res = Generate-Variant $data 62
Write-Host "IMEI (Alternative Mapping): $res"

if ($res -eq "dA5nzSYa") {
    Write-Host "FOUND IT!" -ForegroundColor Green
}
