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
            $query = "https://localhost/pdf/find?password=$($Password)&pages=$($Pages)&url=$($uploadedFileUrl)&searchString=$($SearchString)&regexSearch=$($RegexSearch)"
            $query = [System.Uri]::EscapeUriString($query)

            # Execute request
            $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query

            if ($jsonResponse.error -eq $false) {
                # Display found barcodes in console
                foreach ($item in $jsonResponse.body)
                {            
                    Write-Host "Found text $($item.text) at coordinates $($item.left), $($item.top)"
                }
            }
            else {
                # Display service reported error
                Write-Host $jsonResponse.message
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