//*******************************************************************************************//
//                                                                                           //
// Get Your API Key: https://app.pdf.co/signup                                               //
// API Documentation: https://developer.pdf.co/api/index.html                                //
//                                                                                           //
// Note: Replace placeholder values in the code with your API Key                            //
// and file paths (if applicable)                                                            //
//                                                                                           //
//*******************************************************************************************//


package com.company;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.*;

import java.io.*;
import java.net.*;
import java.nio.file.Path;
import java.nio.file.Paths;

public class Main
{
    // The authentication key (API Key).
    // Get your own by registering at https://app.pdf.co/documentation/api
    final static String API_KEY = "***********************************";

    // Source PDF file
    final static Path SourceFile = Paths.get(".\\sample-rotated.pdf");
    // Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
    final static String Pages = "";
    // PDF document password. Leave empty for unprotected documents.
    final static String Password = "";
    // Destination JSON file name
    final static Path DestinationFile = Paths.get(".\\result.json");


    public static void main(String[] args) throws IOException
    {
        // Create HTTP client instance
        OkHttpClient webClient = new OkHttpClient();

        // 1. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
        // * If you already have a direct file URL, skip to the step 3.

        // Prepare URL for `Get Presigned URL` API call
        String query = String.format(
                "https://api.pdf.co/v1/file/upload/get-presigned-url?contenttype=application/octet-stream&name=%s",
                SourceFile.getFileName());

        // Prepare request
        Request request = new Request.Builder()
                .url(query)
                .addHeader("x-api-key", API_KEY) // (!) Set API Key
                .build();
        // Execute request
        Response response = webClient.newCall(request).execute();

        if (response.code() == 200)
        {
            // Parse JSON response
            JsonObject json = new JsonParser().parse(response.body().string()).getAsJsonObject();

            boolean error = json.get("error").getAsBoolean();
            if (!error)
            {
                // Get URL to use for the file upload
                String uploadUrl = json.get("presignedUrl").getAsString();
                // Get URL of uploaded file to use with later API calls
                String uploadedFileUrl = json.get("url").getAsString();

                // 2. UPLOAD THE FILE TO CLOUD.

                if (uploadFile(webClient, API_KEY, uploadUrl, SourceFile))
                {
                    // 3. CONVERT UPLOADED PDF FILE TO JSON

                    PdfToJson(webClient, API_KEY, DestinationFile, Password, Pages, uploadedFileUrl);
                }
            }
            else
            {
                // Display service reported error
                System.out.println(json.get("message").getAsString());
            }
        }
        else
        {
            // Display request error
            System.out.println(response.code() + " " + response.message());
        }
    }

    public static void PdfToJson(OkHttpClient webClient, String apiKey, Path destinationFile,
        String password, String pages, String uploadedFileUrl) throws IOException
    {

		/*
		Some of advanced options available through profiles:
		(it can be single/double-quoted and contain comments.)
		{
			"profiles": [
				{
					"profile1": {
						"SaveImages": "None", // Whether to extract images. Values: "None", "Embed".
						"ImageFormat": "PNG", // Image format for extracted images. Values: "PNG", "JPEG", "GIF", "BMP".
						"SaveVectors": false, // Whether to extract vector objects (vertical and horizontal lines). Values: true / false
						"ExtractInvisibleText": true, // Invisible text extraction. Values: true / false
						"ExtractShadowLikeText": true, // Shadow-like text extraction. Values: true / false
						"LineGroupingMode": "None", // Values: "None", "GroupByRows", "GroupByColumns", "JoinOrphanedRows"
						"ColumnDetectionMode": "ContentGroupsAndBorders", // Values: "ContentGroupsAndBorders", "ContentGroups", "Borders", "BorderedTables"
						"Unwrap": false, // Unwrap grouped text in table cells. Values: true / false
						"ShrinkMultipleSpaces": false, // Shrink multiple spaces in table cells that affect column detection. Values: true / false
						"DetectNewColumnBySpacesRatio": 1, // Spacing ratio that affects column detection.
						"CustomExtractionColumns": [ 0, 50, 150, 200, 250, 300 ], // Explicitly specify columns coordinates for table extraction.
						"CheckPermissions": true, // Ignore document permissions. Values: true / false
					}
				}
			]
		}
		*/

        // Sample profile that sets advanced conversion options
        // Advanced options are properties of JSONExtractor class from ByteScout PDF Extractor SDK used in the back-end:
        // https://cdn.bytescout.com/help/BytescoutPDFExtractorSDK/html/87ce5fa6-3143-167d-abbd-bc7b5e160fe5.htm

        // Valid RotationAngle values:
        // 0 - no rotation
        // 1 - 90 degrees
        // 2 - 180 degrees
        // 3 - 270 degrees
        String profiles = "{ 'profiles': [{ 'profile1': { 'RotationAngle': 1 } } ] }";


        // Prepare URL for `PDF To JSON` API call
        String query = "https://api.pdf.co/v1/pdf/convert/to/json";

        // Make correctly escaped (encoded) URL
        URL url = null;
        try
        {
            url = new URI(null, query, null).toURL();
        }
        catch (URISyntaxException e)
        {
            e.printStackTrace();
        }

        // Create JSON payload
		String jsonPayload = String.format("{\"name\": \"%s\", \"password\": \"%s\", \"pages\": \"%s\", \"url\": \"%s\", \"profiles\": \"%s\"}",
                destinationFile.getFileName(),
                password,
                pages,
                uploadedFileUrl,
                profiles);

        // Prepare request body
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), jsonPayload);
        
        // Prepare request
        Request request = new Request.Builder()
            .url(url)
            .addHeader("x-api-key", API_KEY) // (!) Set API Key
            .addHeader("Content-Type", "application/json")
            .post(body)
            .build();
        
        // Execute request
        Response response = webClient.newCall(request).execute();
        

        if (response.code() == 200)
        {
            // Parse JSON response
            JsonObject json = new JsonParser().parse(response.body().string()).getAsJsonObject();

            boolean error = json.get("error").getAsBoolean();
            if (!error)
            {
                // Get URL of generated JSON file
                String resultFileUrl = json.get("url").getAsString();

                // Download JSON file
                downloadFile(webClient, resultFileUrl, destinationFile.toFile());

                System.out.printf("Generated JSON file saved as \"%s\" file.", destinationFile.toString());
            }
            else
            {
                // Display service reported error
                System.out.println(json.get("message").getAsString());
            }
        }
        else
        {
            // Display request error
            System.out.println(response.code() + " " + response.message());
        }
    }

    public static boolean uploadFile(OkHttpClient webClient, String apiKey, String url, Path sourceFile) throws IOException
    {
        // Prepare request body
        RequestBody body = RequestBody.create(MediaType.parse("application/octet-stream"), sourceFile.toFile());

        // Prepare request
        Request request = new Request.Builder()
                .url(url)
                .addHeader("x-api-key", apiKey) // (!) Set API Key
                .addHeader("content-type", "application/octet-stream")
                .put(body)
                .build();

        // Execute request
        Response response = webClient.newCall(request).execute();

        return (response.code() == 200);
    }

    public static void downloadFile(OkHttpClient webClient, String url, File destinationFile) throws IOException
    {
        // Prepare request
        Request request = new Request.Builder()
                .url(url)
                .build();
        // Execute request
        Response response = webClient.newCall(request).execute();

        byte[] fileBytes = response.body().bytes();

        // Save downloaded bytes to file
        OutputStream output = new FileOutputStream(destinationFile);
        output.write(fileBytes);
        output.flush();
        output.close();

        response.close();
    }
}
