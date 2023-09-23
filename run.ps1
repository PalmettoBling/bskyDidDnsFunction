using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

Write-Host "Request body: "
Write-Host ($Request.Body | Format-Table | Out-String)

# Getting the request options:
$bskyUserName = $Request.Body.user
$bskyDid = $Request.Body.did
Write-Host "Username: " $bskyUserName
Write-Host "did:  " $bskyDid

$Zone = New-AzDnsZone -Name "$bskyUserName.xboxplaydates.me" -ResourceGroupName "atProtocol" -ParentZoneName "xboxplaydates.me"
Write-Host "Zone request created"
Write-Host $Zone

$Record = New-AzDnsRecordSet -Name "_atproto" -RecordType TXT -ZoneName "$bskyUserName.xboxplaydates.me" -ResourceGroupName "atProtocol" -Ttl 3600 -DnsRecords (New-AzDnsRecordConfig -Value $bskyDid)
Write-Host "Record Request created"
Write-Host $Record

$body = "Zone and record created"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
