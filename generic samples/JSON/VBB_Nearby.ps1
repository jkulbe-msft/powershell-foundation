# VBB API https://github.com/derhuerst/vbb-rest
$latitude = 52.518749
$longitude = 13.382158
$Destination="Flughafen BER - Terminal 1-2"

<# older style
$JSON = (Invoke-WebRequest -Uri "https://v5.vbb.transport.rest/stops/nearby?latitude=$latitude&longitude=$longitude").content
$NearbyStations = $JSON | ConvertFrom-Json
#>

# more modern, and without dependency on Internet Explorer
$NearbyStations = Invoke-RestMethod -Uri "https://v5.vbb.transport.rest/stops/nearby?latitude=$latitude&longitude=$longitude"

$NearbyStations | Select-Object -first 5
$NearbyStations | Where-Object {$_.products.suburban}

$FromStationID = ($NearbyStations | Sort-Object -Property Distance | Select-Object -First 1).id
$ToStationID = ((Invoke-RestMethod -Uri "https://v5.vbb.transport.rest/locations?query=$($Destination -replace ' ','%20')") | Where Name -Like $Destination).id
$Journey = Invoke-RestMethod -Uri "https://v5.vbb.transport.rest/journeys?from=$FromStationID&to=$ToStationID&tickets=true&results=1"

$Journey.journeys.legs
$journey.journeys.tickets | Sort-Object -Property price