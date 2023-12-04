Import-Module ActiveDirectory

$Eesnimi = Read-Host "Sisesta kasutaja eesnimi"
$Perenimi = Read-Host "Sisesta kasutaja perekonnanimi"

$Kasutajanimi = "$Eesnimi.$Perenimi"

try {
    Remove-ADUser -Identity $Kasutajanimi -Confirm:$false -ErrorAction Stop
    Write-Host "User $Kasutajanimi is removed succesfully."
}
catch {
    Write-Host "User not exists or problem is occuring during user removing. $($_.Exception.Message)"
}
