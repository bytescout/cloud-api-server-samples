# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("x-api-key", "{{x-api-key}}")

$multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
$body = $multipartContent

$response = Invoke-RestMethod 'https://localhost/file/delete?file=https://pdf-temp-files.s3.amazonaws.com/b5c1e67d98ab438292ff1fea0c7cdc9d/sample.pdf' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json