# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Source file name
$SourceFile = ".\sample.pdf"

# Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
$Pages = ""

# PDF document password. Leave empty for unprotected documents.
$Password = ""

# Search string. 
$SearchString = '\d{1,}\.\d\d' #Regular expression to find numbers like '100.00'

# Enable regular expressions (Regex) 
$RegexSearch = 'True'

# (!) Make asynchronous job
$Async = $true

# 1. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
# * If you already have a direct file URL, skip to the step 3.

# Prepare URL for `Get Presigned URL` API call
$query = "https://localhost/file/upload/get-presigned-url?contenttype=application/octet-stream&name=" + `
    [System.IO.Path]::GetFileName($SourceFile)
$query = [System.Uri]::EscapeUriString($query)

try {
    # Execute request
    $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query
    
    if ($jsonResponse.error -eq $false) {
        # Get URL to use for the file upload
        $uploadUrl = $jsonResponse.presignedUrl
        # Get URL of uploaded file to use with later API calls
        $uploadedFileUrl = $jsonResponse.url

        # 2. UPLOAD THE FILE TO CLOUD.

        $r = Invoke-WebRequest -Method Put -Headers @{ "content-type" = "application/octet-stream" } -InFile $SourceFile -Uri $uploadUrl
        
        if ($r.StatusCode -eq 200) {
            
            # 3. TEXT SEARCH FROM UPLOADED FILE

            # Prepare URL for PDF text search API call.
            $query = "https://localhost/pdf/find?password=$($Password)&pages=$($Pages)&url=$($uploadedFileUrl)&searchString=$($SearchString)&regexSearch=$($RegexSearch)&async=$($Async)"
            $query = [System.Uri]::EscapeUriString($query)

            try {
                # Execute request
                $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query
            
                if ($jsonResponse.error -eq $false) {
                    # Asynchronous job ID
                    $jobId = $jsonResponse.jobId
            
                    # URL of generated JSON file with search result that will available after the job completion
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
                            # Get JSON for search result
                            $jsonSearchResult = Invoke-RestMethod -Method Get  -Uri $resultFileUrl
                            
                            # Display found result in console
                            foreach ($item in $jsonSearchResult)
                            {
                                Write-Host "Found text $($item.text) at coordinates $($item.left), $($item.top)"
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

        }
        else {
            # Display request error status
            Write-Host $r.StatusCode + " " + $r.StatusDescription
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