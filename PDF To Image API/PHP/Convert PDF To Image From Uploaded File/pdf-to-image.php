<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PDF To Image Results</title>
</head>
<body>

<?php 

// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
// If it's not then please replace this with with your hosting url.

// Get submitted form data
  
$outputFormat = $_POST["outputFormat"];
$pages = $_POST["pages"];


// 1. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
// * If you already have a direct PDF file link, go to the step 3.

// Create URL
$url = "https://localhost/file/upload/get-presigned-url" .
    "?name=" . $_FILES["file"]["name"] .
    "&contenttype=application/octet-stream";
    
// Create request
$curl = curl_init();

curl_setopt($curl, CURLOPT_URL, $url);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
// Execute request
$result = curl_exec($curl);

if (curl_errno($curl) == 0)
{
    $status_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    
    if ($status_code == 200)
    {
        $json = json_decode($result, true);
        
        // Get URL to use for the file upload
        $uploadFileUrl = $json["presignedUrl"];
        // Get URL of uploaded file to use with later API calls
        $accessFileUrl = $json["url"];
        
        // 2. UPLOAD THE FILE TO CLOUD.
        
        $localFile = $_FILES["file"]["tmp_name"];
        $fileHandle = fopen($localFile, "r");
        
        curl_setopt($curl, CURLOPT_URL, $uploadFileUrl);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array("content-type: application/octet-stream"));
        curl_setopt($curl, CURLOPT_PUT, true);
        curl_setopt($curl, CURLOPT_INFILE, $fileHandle);
        curl_setopt($curl, CURLOPT_INFILESIZE, filesize($localFile));

        // Execute request
        curl_exec($curl);
        
        fclose($fileHandle);
        
        if (curl_errno($curl))
        {
            // Display request error
            echo "Error: " . curl_error($curl);
        }
        else
        {
            $status_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
            
            if ($status_code == 200)
            {
                // 3. CONVERT PDF TO IMAGE
                
                RenderPDF($accessFileUrl, $outputFormat, $pages);
            }
            else
            {
                // Display service reported error
                echo "<p>Status code: " . $status_code . "</p>"; 
                echo "<p>" . $result . "</p>"; 
            }
        }
    }
    else
    {
        // Display service reported error
        echo "<p>Status code: " . $status_code . "</p>"; 
        echo "<p>" . $result . "</p>"; 
    }
    
    curl_close($curl);
}
else
{
    // Display CURL error
    echo "Error: " . curl_error($curl);
}


function RenderPDF($fileUrl, $outputFormat, $pages) 
{
    $formats = array(0 => "png", 1 => "jpg", 2 => "tiff");
    $format = $formats[$outputFormat];

    // Create URL
    $url = "https://localhost/pdf/convert/to/" . $format .
        "?url=" . urlencode($fileUrl) .
        "&pages=" . urlencode($pages);
        
    // Create request
    $curl = curl_init();
    
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

    // Execute request
    $result = curl_exec($curl);
    
    if (curl_errno($curl) == 0)
    {
        $status_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        
        if ($status_code == 200)
        {
            $json = json_decode($result, true);
            
            if ($json["error"] == false)
            {
                if ($format == "tiff")
                {
                    // The TIFF format is multi-page, so the result is always the single file
                    $resultFileUrl = $json["url"];
                    echo "<p><a href=" . $resultFileUrl . ">" . $resultFileUrl . "</p>"; 
                }
                else
                {
                    // JPEG and PNG formats are single-page, so the results are multiple
                    $resultFiles = $json["urls"];
                    foreach ($resultFiles as &$resultFileUrl) 
                        echo "<p><a href=" . $resultFileUrl . ">" . $resultFileUrl . "</p>"; 
                }
            }
            else
            {
                // Display service reported error
                echo "<p>Error: " . $json["message"] . "</p>"; 
            }
        }
        else
        {
            // Display request error
            echo "<p>Status code: " . $status_code . "</p>"; 
            echo "<p>" . $result . "</p>"; 
        }
    }
    else
    {
        // Display CURL error
        echo "Error: " . curl_error($curl);
    }
    
    // Cleanup
    curl_close($curl);
}

?>

</body>
</html>