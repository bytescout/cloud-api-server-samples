<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Image To PDF Conversion Results</title>
</head>
<body>

<?php 

// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
// If it's not then please replace this with with your hosting url.

// Get submitted form data

// 1. UPLOAD FILES TO CLOUD
// If you already have direct file links, skip to Step 2.

$uploadedFiles = array();
$fileCount = count($_FILES["files"]["name"]);

for($i = 0; $i < $fileCount; $i++)
{
    // 1a. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
    
    // Create URL
    $url = "https://localhost/file/upload/get-presigned-url" . 
        "?name=" . $_FILES["files"]["name"][$i] .
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
            $uploadedFileUrl = $json["url"];
            
            // 1b. UPLOAD THE FILE TO CLOUD.
            
            $tmpFilePath = $_FILES["files"]["tmp_name"][$i];            
            $fileHandle = fopen($tmpFilePath, "r");
            
            curl_setopt($curl, CURLOPT_URL, $uploadFileUrl);
            curl_setopt($curl, CURLOPT_HTTPHEADER, array("content-type: application/octet-stream"));
            curl_setopt($curl, CURLOPT_PUT, true);
            curl_setopt($curl, CURLOPT_INFILE, $fileHandle);
            curl_setopt($curl, CURLOPT_INFILESIZE, filesize($tmpFilePath));
    
            // Execute request
            curl_exec($curl);
            
            if (curl_errno($curl) == 0)
            {
                $status_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
                
                if ($status_code == 200)
                {
                    $uploadedFiles[] = $uploadedFileUrl;
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
            
            fclose($fileHandle);
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
    
    curl_close($curl); 
}

// 2. MERGE UPLOADED PDF DOCUMENTS

if (count($uploadedFiles) > 0) 
{
    MergePdf($uploadedFiles);
}


function MergePdf($uploadedFiles) 
{
    // Create URL
    $url = "https://localhost/pdf/merge" .
        "?name=result.pdf" .
        "&url=" . join(",", $uploadedFiles);
    
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
                $resultFileUrl = $json["url"];
                
                // Display link to the result document
                echo "<div><h2>Conversion Result:</h2><a href='" . $resultFileUrl . "' target='_blank'>" . $resultFileUrl . "</a></div>";
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
