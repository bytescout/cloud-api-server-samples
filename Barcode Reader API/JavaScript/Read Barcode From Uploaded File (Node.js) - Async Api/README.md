## How to read barcode from uploaded file (node for barcode reader API in JavaScript with ByteScout Cloud API Server

### Learn to write code read barcode from uploaded file (node for barcode reader API in JavaScript: Simple How To Tutorial

The documentation is written to assist you to apply all the necessary features on your side. Barcode reader API in JavaScript can be applied with ByteScout Cloud API Server. ByteScout Cloud API Server is API server that is ready to use and can be installed and deployed in less than 30 minutes on your own Windows server or server in a cloud. It can save data and files on your local server-based file storage or in Amazon AWS S3 storage. Data is processed solely on the API server and is powered by ByteScout engine, no cloud services or Internet connection is required for data processing..

Use the code displayed below in your application to save a lot of time on writing and testing code. Open your JavaScript project and simply copy & paste the code and then run your app!  Easy to understand tutorials are available along with installed ByteScout Cloud API Server if you'd like to learn more about the topic and the details of the API.

Free! Free! Free! ByteScout free trial version is available for FREE download from our website. Programming tutorials along with source code samples are assembled.

## REQUEST FREE TECH SUPPORT

[Click here to get in touch](https://bytescout.zendesk.com/hc/en-us/requests/new?subject=ByteScout%20Cloud%20API%20Server%20Question)

or just send email to [support@bytescout.com](mailto:support@bytescout.com?subject=ByteScout%20Cloud%20API%20Server%20Question) 

## ON-PREMISE OFFLINE SDK 

[Get Your 60 Day Free Trial](https://bytescout.com/download/web-installer?utm_source=github-readme)
[Explore SDK Docs](https://bytescout.com/documentation/index.html?utm_source=github-readme)
[Sign Up For Online Training](https://academy.bytescout.com/)


## ON-DEMAND REST WEB API

[Get your API key](https://pdf.co/documentation/api?utm_source=github-readme)
[Explore Web API Documentation](https://pdf.co/documentation/api?utm_source=github-readme)
[Explore Web API Samples](https://github.com/bytescout/ByteScout-SDK-SourceCode/tree/master/PDF.co%20Web%20API)

## VIDEO REVIEW

[https://www.youtube.com/watch?v=NEwNs2b9YN8](https://www.youtube.com/watch?v=NEwNs2b9YN8)




<!-- code block begin -->

##### ****ReadBarcodeFromUploadedFile.js:**
    
```
/*jshint esversion: 6 */

// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
// If it's not then please replace this with with your hosting url.

var https = require("https");
var path = require("path");
var fs = require("fs");

// `request` module is required for file upload.
// Use "npm install request" command to install.
var request = require("request");

// Source file name
const SourceFile = "./sample.pdf";
// Comma-separated list of barcode types to search. 
// barcode types
const BarcodeTypes = "Code128,Code39,Interleaved2of5,EAN13";
// Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
const Pages = "";

// 1. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
getPresignedUrl(SourceFile)
.then(([uploadUrl, uploadedFileUrl]) => {
    // 2. UPLOAD THE FILE TO CLOUD.
    uploadFile(SourceFile, uploadUrl)
    .then(() => {
        // 3. READ BARCODES FROM UPLOADED FILE
        readBarcodes(uploadedFileUrl, Pages, BarcodeTypes);
    })
    .catch(e => {
        console.log(e);
    });
})
.catch(e => {
    console.log(e);
});


function getPresignedUrl(localFile) {
    return new Promise(resolve => {
        // Prepare request to `Get Presigned URL` API endpoint
        let queryPath = `/file/upload/get-presigned-url?contenttype=application/octet-stream&name=${path.basename(SourceFile)}`;
        let reqOptions = {
            host: "localhost",
            path: encodeURI(queryPath)
        };
        // Send request
        https.get(reqOptions, (response) => {
            response.on("data", (d) => {
                let data = JSON.parse(d);
                if (data.error == false) {
                    // Return presigned url we received
                    resolve([data.presignedUrl, data.url]);
                }
                else {
                    // Service reported error
                    console.log("getPresignedUrl(): " + data.message);
                }
            });
        })
        .on("error", (e) => {
            // Request error
            console.log("getPresignedUrl(): " + e);
        });
    });
}

function uploadFile(localFile, uploadUrl) {
    return new Promise(resolve => {
        fs.readFile(SourceFile, (err, data) => {
            request({
                method: "PUT",
                url: uploadUrl,
                body: data,
                headers: {
                    "Content-Type": "application/octet-stream"
                }
            }, (err, res, body) => {
                if (!err) {
                    resolve();
                }
                else {
                    console.log("uploadFile() request error: " + e);
                }
            });
        });
    });
}

function readBarcodes(uploadedFileUrl, pages, barcodeTypes) {
    // Prepare request to `Barcode Reader` API endpoint
    let queryPath = `/barcode/read/from/url?types=${BarcodeTypes}&pages=${Pages}&url=${uploadedFileUrl}&async=True`;
    let reqOptions = {
        host: "localhost",
        path: encodeURI(queryPath),
        method: "GET"
    };
    // Send request
    https.get(reqOptions, (response) => {
        response.on("data", (d) => {
            response.setEncoding("utf8");
            // Parse JSON response
            let data = JSON.parse(d);
            if (data.error == false) {
                console.log(`Job #${data.jobId} has been created!`);
                checkIfJobIsCompleted(data.jobId, data.url);
            }
            else {
                // Service reported error
                console.log("readBarcodes(): " + data.message);
            }
        });
    })
    .on("error", (e) => {
        // Request error
        console.log("readBarcodes(): " + e);
    });
}

function checkIfJobIsCompleted(jobId, resultFileUrlJson) {
    let queryPath = `/job/check?jobid=${jobId}`;
    let reqOptions = {
        host: "localhost",
        path: encodeURI(queryPath),
        method: "GET"
    };

    https.get(reqOptions, (response) => {
        response.on("data", (d) => {
            response.setEncoding("utf8");
            // Parse JSON response
            let data = JSON.parse(d);
            console.log(`Checking Job #${jobId}, Status: ${data.status}, Time: ${new Date().toLocaleString()}`);

            if (data.status == "working") {
                // Check again after 3 seconds
				setTimeout(function(){ checkIfJobIsCompleted(jobId, resultFileUrlJson);}, 3000);
            }
            else if (data.status == "success") {

                request({ method: 'GET', uri: resultFileUrlJson, gzip: true },
                function (error, response, body) {

                    // Parse JSON response
                    let respJsonFileArray = JSON.parse(body);

                    respJsonFileArray.forEach((element) => {
                        console.log("Found barcode:");
                        console.log("  Type: " + element["TypeName"]);
                        console.log("  Value: " + element["Value"]);
                        console.log("  Document Page Index: " + element["Page"]);
                        console.log("  Rectangle: " + element["Rect"]);
                        console.log("  Confidence: " + element["Confidence"]);
                        console.log();
                    }, this);
                });
            }
            else {
                console.log(`Operation ended with status: "${data.status}".`);
            }
        })
    });
}

```

<!-- code block end -->