# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Cloud API asynchronous "Barcode Reader" job example.
# Allows to avoid timeout errors when processing huge or scanned PDF documents.

# Direct URL of source file to search barcodes in.
$SourceFileURL = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/barcode-reader/sample.pdf"
# Comma-separated list of barcode types to search. 
$BarcodeTypes = "Code128,Code39,Interleaved2of5,EAN13"
# Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
$Pages = ""
# (!) Make asynchronous job
$Async = $true

# Prepare URL for `Barcode Reader` API call
$query = "https://localhost/barcode/read/from/url?types=$($BarcodeTypes)&pages=$($Pages)&url=$($SourceFileURL)&async=$($Async)"
$query = [System.Uri]::EscapeUriString($query)

try {
    # Execute request
    $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query

    if ($jsonResponse.error -eq $false) {
        # Asynchronous job ID
        $jobId = $jsonResponse.jobId
        # URL of generated JSON file with decoded barcodes that will available after the job completion
        $resultFileUrl = $jsonResponse.url

        # Check the job status in a loop. 
        # If you don't want to pause the main thread you can rework the code 
        # to use a separate thread for the status checking and completion.
        do {
            $statusCheckUrl = "https://localhost/job/check?jobid=" + $jobId
            $jsonStatus = Invoke-RestMethod -Method Get  -Uri $statusCheckUrl

            # Display timestamp and status (for demo purposes)
            Write-Host "$(Get-date): $($jsonStatus.status)"

            if ($jsonStatus.status -eq "success") {
                # Download JSON file with decoded barcodes
                $jsonFoundBarcodes = Invoke-RestMethod -Method Get  -Uri $resultFileUrl
                
                # Display found barcodes in console
                foreach ($barcode in $jsonFoundBarcodes)
                {
                    Write-Host "Found barcode:"
                    Write-Host "  Type: " + $barcode.TypeName
                    Write-Host "  Value: " + $barcode."Value"
                    Write-Host "  Document Page Index: " + $barcode."Page"
                    Write-Host "  Rectangle: " + $barcode."Rect"
                    Write-Host "  Confidence: " + $barcode."Confidence"
                    Write-Host ""
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
