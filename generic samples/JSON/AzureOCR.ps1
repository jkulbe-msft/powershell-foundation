# https://rapidapi.com/microsoft-azure-org-microsoft-cognitive-services/api/microsoft-computer-vision3

$Headers = @{
        'x-rapidapi-host' = 'microsoft-computer-vision3.p.rapidapi.com'
        'x-rapidapi-key' = '69cf9f572fmsh28bd1ad9054c655p1e62d4jsn7ad552754719'
        'content-type' = 'application/json'
        'accept' = 'application/json'
    }

$Body = @{
        # URL = 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Blocksatz-Beispiel_deutsch%2C_German_text_sample_with_fully_justified_text.svg/960px-Blocksatz-Beispiel_deutsch%2C_German_text_sample_with_fully_justified_text.svg.png'
        # URL = 'https://www.eztexting.com/sites/default/files/images/use-case/lead-gen-sample.png'
        URL = 'https://i.pinimg.com/originals/15/38/e9/1538e921a362e2743cd006f71851423f.jpg'
        #URL = 'https://iovs.arvojournals.org/data/journals/iovs/933252/i1552-5783-53-9-5452-f01.jpeg'
    } | ConvertTo-JSON

$response = Invoke-RestMethod -Uri 'https://microsoft-computer-vision3.p.rapidapi.com/ocr?language=unk&detectOrientation=false' -Method POST -Headers $Headers -Body $Body -ContentType 'application/json'

$response.language
$response.regions.lines.words
$response.regions.lines.words.text -join ' '
# arvojournals example: exclude words in lower right corner
($response.regions.lines.words | Where-Object -FilterScript {[int]$_.boundingbox.split(',')[0] -lt 1400}).text -join ' '