# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Source PDF file to split
$SourceFileUrl = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-split/sample.pdf"
# Comma-separated list of page numbers (or ranges) to process. Example: '1,3-5,7-'.
$Pages = "1-2,3-"

# Prepare URL for `Split PDF` API call
$query = "https://localhost/pdf/split?pages=$($Pages)&url=$($SourceFileUrl)"
$query = [System.Uri]::EscapeUriString($query)

try {
    # Execute request
    $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query

    if ($jsonResponse.error -eq $false) {
        # Download generated PDF files
        $part = 1;
        foreach ($url in $jsonResponse.urls) {
            $localFileName = ".\part$($part).pdf"

            # Download PDF file
            Invoke-WebRequest  -OutFile $localFileName -Uri $url

            Write-Host "Downloaded `"$($localFileName)`""
            $part++
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