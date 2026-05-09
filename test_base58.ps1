function To-Base58([bigint]$n) {
    $chars = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    $res = ""
    while ($n -gt 0) {
        $rem = [int]($n % 58)
        $res = $chars[$rem] + $res
        $n = $n / 58
    }
    return $res
}

$imei = [bigint]::Parse("862624055623767")
$res = To-Base58 $imei
Write-Host "Base58(IMEI): $res"

# Try different alphabets
function To-Base58-Alt([bigint]$n, $chars) {
    $res = ""
    while ($n -gt 0) {
        $rem = [int]($n % 58)
        $res = $chars[$rem] + $res
        $n = $n / 58
    }
    return $res
}

$alphabets = @(
    "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz",
    "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ",
    "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789"
)

foreach ($a in $alphabets) {
    $res = To-Base58-Alt $imei $a
    Write-Host "Base58 with '$($a.Substring(0,10))...': $res"
}
