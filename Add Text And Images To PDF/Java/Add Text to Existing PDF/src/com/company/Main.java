//*******************************************************************************************//
//                                                                                           //
// Download Free Evaluation Version From: https://bytescout.com/download/web-installer       //
//                                                                                           //
// Also available as Web API! Get Your Free API Key: https://app.pdf.co/signup               //
//                                                                                           //
// Copyright © 2017-2020 ByteScout, Inc. All rights reserved.                                //
// https://www.bytescout.com                                                                 //
// https://pdf.co                                                                            //
//                                                                                           //
//*******************************************************************************************//


package com.company;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.*;
import java.net.*;
import java.nio.file.Path;
import java.nio.file.Paths;

// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
// If it's not then please replace this with with your hosting url.

public class Main
{
    // Direct URL of source PDF file.
    final static String SourceFileUrl = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-edit/sample.pdf";
    // Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
	final static String Pages = "";
    // PDF document password. Leave empty for unprotected documents.
	final static String Password = "";

    // Destination PDF file name
	final static Path ResultFile = Paths.get(".\\result.pdf");

    // Text annotation params
    private final static String Type2 = "annotation";
    private final static int X2 = 400;
    private final static int Y2 = 600;
    private final static String Text = "APPROVED";
    private final static String FontName = "Times New Roman";
    private final static float FontSize = 24;
    private final static String Color = "FF0000";

    public static void main(String[] args) throws IOException
    {
        // Create HTTP client instance
        OkHttpClient webClient = new OkHttpClient();

        // * Add text annotation *
        // Prepare URL for `PDF Edit` API call
        String query = String.format(
                "https://localhost/pdf/edit/add?name=%s&password=%s&pages=%s&url=%s&type=%s&x=%s&y=%s&text=%s&fontname=%s&size=%s&color=%s",
                ResultFile.getFileName(),
                Password,
                Pages,
                SourceFileUrl,
                Type2,
                X2,
                Y2,
                Text,
                FontName,
                FontSize,
                Color);

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

        // Prepare request
        Request request = new Request.Builder()
                .url(url)
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
                // Get URL of generated output file
                String resultFileUrl = json.get("url").getAsString();

                // Download the image file
                downloadFile(webClient, resultFileUrl, ResultFile);

                System.out.printf("Generated file saved to \"%s\" file.", ResultFile.toString());
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

    public static void downloadFile(OkHttpClient webClient, String url, Path destinationFile) throws IOException
    {
        // Prepare request
        Request request = new Request.Builder()
                .url(url)
                .build();

        // Execute request
        Response response = webClient.newCall(request).execute();

        byte[] fileBytes = response.body().bytes();

        // Save downloaded bytes to file
        OutputStream output = new FileOutputStream(destinationFile.toFile());
        output.write(fileBytes);
        output.flush();
        output.close();

        response.close();
    }
}
