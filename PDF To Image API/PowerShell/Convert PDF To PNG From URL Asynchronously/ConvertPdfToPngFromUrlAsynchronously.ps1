# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Cloud API asynchronous "PDF To PNG" job example.
# Allows to avoid timeout errors when processing huge or scanned PDF documents.

# Direct URL of source PDF file.
$SourceFileUrl = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-to-image/sample.pdf"
# Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
$Pages = ""
# PDF document password. Leave empty for unprotected documents.
$Password = ""
# (!) Make asynchronous job
$Async = $true


# Prepare URL for `PDF To PNG` API call
$query = "https://localhost/pdf/convert/to/png?password={0}&pages={1}&url={2}&async={3}" -f `
    $Password, $Pages, $SourceFileUrl, $Async
$query = [System.Uri]::EscapeUriString($query)

try {
    # Execute request
    $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query

    if ($jsonResponse.error -eq $false) {
        # Asynchronous job ID
        $jobId = $jsonResponse.jobId
        # URL of generated JSON file available after the job completion; it will contain URLs of result PDF files.
        $resultJsonFileUrl = $jsonResponse.url

        # Check the job status in a loop. 
        do {
            $statusCheckUrl = "https://localhost/job/check?jobid=" + $jobId
            $jsonStatus = Invoke-RestMethod -Method Get  -Uri $statusCheckUrl

            # Display timestamp and status (for demo purposes)
            Write-Host "$(Get-date): $($jsonStatus.status)"

            if ($jsonStatus.status -eq "success") {
                # Download JSON file with URLs of result PDF files
                $jsonPngUrls = Invoke-RestMethod -Method Get -Uri $resultJsonFileUrl

                # Download generated PNG files
                $part = 1;
                foreach ($url in $jsonPngUrls) {
                    $localFileName = ".\page$($part).png"

                    Invoke-WebRequest  -OutFile $localFileName -Uri $url

                    Write-Host "Downloaded `"$($localFileName)`""
                    $part++
                }
                break
            }
            elseif ($jsonStatus.status -eq "working") {
                # Pause for a few seconds
                Start-Sleep -Seconds 3
            }
            else {
                Write-Host $jsonStatus.status
                break
            }
        }
        while ($true)
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
