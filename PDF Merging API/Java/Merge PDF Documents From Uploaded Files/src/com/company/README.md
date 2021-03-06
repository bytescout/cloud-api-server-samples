## How to merge PDF documents from uploaded files for PDF merging API in Java using ByteScout Cloud API Server ByteScout Cloud API Server is API server that is ready to use and can be installed and deployed in less than 30 minutes on your own Windows server or server in a cloud. It can save data and files on your local server-based file storage or in Amazon AWS S3 storage. Data is processed solely on the API server and is powered by ByteScout engine, no cloud services or Internet connection is required for data processing..

## REQUEST FREE TECH SUPPORT

[Click here to get in touch](https://bytescout.zendesk.com/hc/en-us/requests/new?subject=ByteScout%20Cloud%20API%20Server%20Question)

or just send email to [support@bytescout.com](mailto:support@bytescout.com?subject=ByteScout%20Cloud%20API%20Server%20Question) 

## ON-PREMISE OFFLINE SDK 

[Get Your 60 Day Free Trial](https://bytescout.com/download/web-installer?utm_source=github-readme)
[Explore Documentation](https://bytescout.com/documentation/index.html?utm_source=github-readme)
[Explore Source Code Samples](https://github.com/bytescout/ByteScout-SDK-SourceCode/)
[Sign Up For Online Training](https://academy.bytescout.com/)


## ON-DEMAND REST WEB API

[Get your API key](https://app.pdf.co/signup?utm_source=github-readme)
[Security](https://pdf.co/security)
[Explore Web API Documentation](https://apidocs.pdf.co?utm_source=github-readme)
[Explore Web API Samples](https://github.com/bytescout/ByteScout-SDK-SourceCode/tree/master/PDF.co%20Web%20API)

## VIDEO REVIEW

[https://www.youtube.com/watch?v=NEwNs2b9YN8](https://www.youtube.com/watch?v=NEwNs2b9YN8)




<!-- code block begin -->

##### **Main.java:**
    
```
package com.company;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.*;

import java.io.*;
import java.net.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
// If it's not then please replace this with with your hosting url.
public class Main
{
    // Source PDF files
    final static Path[] SourceFiles = new Path[] {
            Paths.get(".\\sample1.pdf"),
            Paths.get(".\\sample2.pdf") };
    // Destination PDF file name
    final static Path DestinationFile = Paths.get(".\\result.pdf");

    public static void main(String[] args) throws IOException
    {
        // Create HTTP client instance
        OkHttpClient webClient = new OkHttpClient();

        // 1. UPLOAD FILES TO CLOUD

        ArrayList<String> uploadedFiles = new ArrayList<>();

        for (Path pdfFile : SourceFiles)
        {
            // 1a. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.

            // Prepare URL for `Get Presigned URL` API call
            String query = String.format(
                    "https://localhost/file/upload/get-presigned-url?contenttype=application/octet-stream&name=%s",
                    pdfFile.getFileName());

            // Prepare request
            Request request = new Request.Builder()
                    .url(query)
                    
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

                    // 1b. UPLOAD THE FILE TO CLOUD.

                    if (uploadFile(webClient, uploadUrl, pdfFile))
                    {
                        uploadedFiles.add(uploadedFileUrl);
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


        if (uploadedFiles.size() > 0)
        {
            // 2. MERGE UPLOADED PDF DOCUMENTS

            MergePdfDocuments(webClient, DestinationFile, uploadedFiles);
        }
    }

    public static void MergePdfDocuments(OkHttpClient webClient, Path destinationFile, List<String> uploadedFileUrls) throws IOException
    {
        // Prepare URL for `Merge PDF` API call
        String query = String.format(
                "https://localhost/pdf/merge?name=%s&url=%s",
                destinationFile.getFileName(),
                String.join(",", uploadedFileUrls));

        // Prepare request
        Request request = new Request.Builder()
                .url(query)
                
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
                // Get URL of generated PDF file
                String resultFileUrl = json.get("url").getAsString();

                // Download PDF file
                downloadFile(webClient, resultFileUrl, destinationFile.toFile());

                System.out.printf("Generated PDF file saved as \"%s\" file.", destinationFile.toString());
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

    public static boolean uploadFile(OkHttpClient webClient, String url, Path sourceFile) throws IOException
    {
        // Prepare request body
        RequestBody body = RequestBody.create(MediaType.parse("application/octet-stream"), sourceFile.toFile());

        // Prepare request
        Request request = new Request.Builder()
                .url(url)
                
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

```

<!-- code block end -->