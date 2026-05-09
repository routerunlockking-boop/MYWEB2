function Get-AlphabetChar([int]$m) {
    if ($m -lt 10) { return [char](48 + $m) }
    if ($m -lt 36) { return [char](55 + $m) }
    return [char](61 + $m)
}

function Generate-From($data, $mod, $filterAmbiguous) {
    $ambiguous = "1ILil"
    $out = New-Object char[] 8
    $len = $data.Count
    
    for ($i = 0; $i -lt 8; $i++) {
        $seed = 1
        for ($j = 0; $j -lt $len; $j++) {
            while ($seed -gt 0xffffff) {
                $seed = (-bnot $seed) -band 0xffffff
            }
            $idx = ($i + $j) % $len
            $product = (($i + 1) * ($j + 1)) -band 0xff
            $seed = ($seed + $data[$idx] * $product)
        }
        while ($seed -gt 0xffffff) {
            $seed = (-bnot $seed) -band 0xffffff
        }
        $val = $seed % $mod
        $ch = Get-AlphabetChar $val
        if ($filterAmbiguous -and $ambiguous.Contains([string]$ch)) {
            $val = ($val + 1) % $mod
            $ch = Get-AlphabetChar $val
        }
        $out[$i] = $ch
    }
    return -join $out
}

$imei = "862624055623767"
$macRaw = "D842F7B23A8C"

$testData = @()
$testData += @{ name="IMEI"; data=[System.Text.Encoding]::ASCII.GetBytes($imei) }
$testData += @{ name="MAC"; data=[System.Text.Encoding]::ASCII.GetBytes($macRaw) }
$testData += @{ name="MAC+IMEI"; data=[System.Text.Encoding]::ASCII.GetBytes($macRaw + $imei) }
$testData += @{ name="IMEI+MAC"; data=[System.Text.Encoding]::ASCII.GetBytes($imei + $macRaw) }
$testData += @{ name="IMEI reversed"; data=[System.Text.Encoding]::ASCII.GetBytes((-join $imei[($imei.Length-1)..0])) }

$mods = @(52, 62)

foreach ($t in $testData) {
    foreach ($mod in $mods) {
        $res = Generate-From $t.data $mod $false
        if ($res -eq "dA5nzSYa") {
            Write-Host "FOUND IT! Input: $($t.name), Mod: $mod" -ForegroundColor Green
        }
        Write-Host "$($t.name) (mod $mod): $res"
    }
}
