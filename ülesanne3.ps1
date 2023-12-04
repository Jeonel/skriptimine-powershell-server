$file = "C:\users\Administrator\skriptimine\adusers.csv"

$users = Import-Csv $file -Encoding Default -Delimiter ";"

foreach ($user in $users){
    $username = $user.FirstName + "." $user.LastName
    $username = $username.ToLower()
    $username = Translit($username)
    
    $upname = $username + "@sv-kool.local"

    $displayname = $user.FirstName + " " + $user.LastName
    New-ADUser -Name $username
        -DispayName $displayname
        -GivenName $user.FirstName
        -Surname $user.LastName
        -Departmemt $user.Department
        -Title $user.Role
        -userPrincipalName $upname
        -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -force) -Enabled $true
    

}

function Translit {

    param(
        [string] $inputstring
    )

        $Translit = @{
        [char] 'ä' = "a"
        [char] 'ö' = "o"
        [char] 'ü' = "u"
        [char] 'õ' = "o"
        }  

    $outputspring=""

    foreach ($character in $inputCharacter = $inputString.ToCharaArray())
    {

        if ($Translit[$character] -cne $Null){

        $outputString += $Translit[$character]
    } else {
        
        $outputString += $character
    }
}
write-outout $outputString