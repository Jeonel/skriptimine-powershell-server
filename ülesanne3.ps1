$file = "C:\users\Administrator\skriptimine\adusers.csv"
$users = Import-Csv $file -Encoding Default -Delimiter ";"

# Funktsioon Translit
function Translit {
    param(
        [string] $inputstring
    )

    $Translit = @{
        [char]'ä' = "a"
        [char]'ö' = "o"
        [char]'ü' = "u"
        [char]'õ' = "o"
        }  

    $outputString =""

    foreach ($character in $inputstring.ToCharArray()) {
        if ($Translit[$character] -ne $null) {
            
            $outputString += $Translit[$character]
        } else {
           
            $outputString += $character
        }
    }

    Write-Output $outputString
}

foreach ($user in $users) {
    $username = $user.FirstName + "." + $user.LastName
    $username = $username.ToLower()
    $username = Translit $username

    $upname = $username + "@sv-kool.local"

    $displayname = $user.FirstName + " " + $user.LastName

    # Kontrolli, kas UPN on unikaalne
    $isUniqueUPN = !(Get-ADUser -Filter {UserPrincipalName -eq $upname} -ErrorAction SilentlyContinue)

    if ($isUniqueUPN) {
        New-ADUser -Name $username `
            -DisplayName $displayname `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -Department $user.Department `
            -Title $user.Role `
            -UserPrincipalName $upname `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) -Enabled $true
        Write-Host "Kasutaja '$username' loodud."
    } else {
        Write-Host "User $upname already exists - can not add this users"
    }
}
