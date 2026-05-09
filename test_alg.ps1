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
            # while (seed > 0xffffff) seed = ~seed & 0xffffff;
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
$macFormatted = "D8:42:F7:B2:3A:8C"

$dataImei = [System.Text.Encoding]::ASCII.GetBytes($imei)
$dataMacRaw = [System.Text.Encoding]::ASCII.GetBytes($macRaw)
$dataMacFormatted = [System.Text.Encoding]::ASCII.GetBytes($macFormatted)

Write-Host "Target: dA5nzSYa" -ForegroundColor Cyan

$inputs = @(
    @{ name="IMEI"; data=$dataImei },
    @{ name="MAC Raw"; data=$dataMacRaw },
    @{ name="MAC Formatted"; data=$dataMacFormatted }
)

$mods = @(52, 62)

foreach ($input in $inputs) {
    foreach ($mod in $mods) {
        foreach ($filter in @($true, $false)) {
            $res = Generate-From $input.data $mod $filter
            $match = if ($res -eq "dA5nzSYa") { " MATCH!" } else { "" }
            Write-Host "$($input.name) (mod $mod, filter $filter): $res $match"
        }
    }
}
