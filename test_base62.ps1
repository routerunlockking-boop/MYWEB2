function To-Base62([bigint]$n) {
    $chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $res = ""
    while ($n -gt 0) {
        $rem = [int]($n % 62)
        $res = $chars[$rem] + $res
        $n = $n / 62
    }
    return $res
}

$imei = [bigint]::Parse("862624055623767")
$res = To-Base62 $imei
Write-Host "Base62(IMEI): $res"

# Try different alphabets
function To-Base62-Alt([bigint]$n, $chars) {
    $res = ""
    while ($n -gt 0) {
        $rem = [int]($n % 62)
        $res = $chars[$rem] + $res
        $n = $n / 62
    }
    return $res
}

$alphabets = @(
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
)

foreach ($a in $alphabets) {
    $res = To-Base62-Alt $imei $a
    Write-Host "Base62 with '$($a.Substring(0,10))...': $res"
}
