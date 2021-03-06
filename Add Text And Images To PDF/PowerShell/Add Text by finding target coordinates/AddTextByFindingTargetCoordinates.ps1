# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Direct URL of source PDF file.
$SourceFileUrl = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-edit/sample.pdf"

# Search string.
$SearchString = 'Notes'

# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Prepare URL for PDF text search API call.
$queryFindText = "https://localhost/pdf/find?url=$($SourceFileURL)&searchString=$($SearchString)"
$queryFindText = [System.Uri]::EscapeUriString($queryFindText)

try {
    # Execute request
    $jsonResponseFindText = Invoke-RestMethod -Method Get  -Uri $queryFindText

    if ($jsonResponseFindText.error -eq $false) {

        # Display search information
        $itemFindText = $jsonResponseFindText.body[0];

        Write-Host "Found text at coordinates $($itemFindText.left), $($itemFindText.top)"

        #Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
        $Pages = ""

        # PDF document password. Leave empty for unprotected documents.
        $Password = ""

        # Destination PDF file name
        $DestinationFile = "./result.pdf"

        # Text annotation params
        $Type = "annotation";
        $X = $itemFindText.left;
        $Y = $itemFindText.top + 25;
        $Text = "Some notes will go here... Some notes will go here.... Some notes will go here.....";
        $FontName = "Times New Roman";
        $FontSize = 12;
        $Color = "FF0000";

        $resultFileName = [System.IO.Path]::GetFileName($DestinationFile)

        # * Add Text *
        # Prepare request to `PDF Edit` API endpoint
        $query = "https://localhost/pdf/edit/add?name=$($resultFileName)&password=$($Password)&pages=$($Pages)&url=$($SourceFileUrl)&type=$($Type)&x=$($X)&y=$($Y)&text=$($Text)&fontname=$($FontName)&size=$($FontSize)&color=$($Color)";
        $query = [System.Uri]::EscapeUriString($query)

        try {
            # Execute request
            $jsonResponse = Invoke-RestMethod -Method Get  -Uri $query

            if ($jsonResponse.error -eq $false) {
                # Get URL of generated barcode image file
                $resultFileUrl = $jsonResponse.url
                
                # Download output file
                Invoke-WebRequest -Uri $resultFileUrl -OutFile $DestinationFile

                Write-Host "Generated PDF saved to '$($DestinationFile)' file."
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
        # Display service reported error
        Write-Host $jsonResponse.message
    }
}
catch {
    # Display request error
    Write-Host $_.Exception
}