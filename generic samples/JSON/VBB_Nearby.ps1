# VBB API https://github.com/derhuerst/vbb-rest/blob/3/docs/index.md
$latitude = 52.518749
$longitude = 13.382158

<# older style
$JSON = (Invoke-WebRequest -Uri "https://3.vbb.transport.rest/stops/nearby?latitude=$latitude&longitude=$longitude").content
$NearbyStations = $JSON | ConvertFrom-Json
#>

# more modern, and without dependency on Internet Explorer
$NearbyStations = Invoke-RestMethod -Uri "https://3.vbb.transport.rest/stops/nearby?latitude=$latitude&longitude=$longitude"

$NearbyStations | Select-Object -first 5
$NearbyStations | Where-Object {$_.products.suburban}
