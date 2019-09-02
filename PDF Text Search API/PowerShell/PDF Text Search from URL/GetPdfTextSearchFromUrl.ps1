# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Direct URL of PDF file to get information
$SourceFileURL = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-to-text/sample.pdf"

# Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
$Pages = ""

# PDF document password. Leave empty for unprotected documents.
$Password = ""

# Search string. 
$SearchString = '\d{1,}\.\d\d' #Regular expression to find numbers like '100.00'

# Enable regular expressions (Regex) 
$RegexSearch = 'True'

# Prepare URL for PDF text search API call.
$query = "https://localhost/pdf/find?password=$($Password)&pages=$($Pages)&url=$($SourceFileURL)&searchString=$($SearchString)&regexSearch=$($RegexSearch)"
$query = [System.Uri]::EscapeUriString($query)

try {
    # Execute request
    $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query

    if ($jsonResponse.error -eq $false) {
        # Display search information
        foreach ($item in $jsonResponse.body) {
            Write-Host "Found text $($item.text) at coordinates $($item.left), $($item.top)"
        }
    }
    else {
        # Display service reported error
        Write-Host $jsonResponse.message
    }
}
catch {
    # Display request error
    Write-Host $_.Exception
}