//*******************************************************************************************//
//                                                                                           //
// Get Your API Key: https://app.pdf.co/signup                                               //
// API Documentation: https://developer.pdf.co/api/index.html                                //
//                                                                                           //
// Note: Replace placeholder values in the code with your API Key                            //
// and file paths (if applicable)                                                            //
//                                                                                           //
//*******************************************************************************************//


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

// Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
const Pages = "";

// PDF document password. Leave empty for unprotected documents.
const Password = "";

// Search string. 
const SearchString = '[4-9][0-9].[0-9][0-9]'; // Regular expression to find numbers in format dd.dd and between 40.00 to 99.99

// Enable regular expressions (Regex) 
const RegexSearch = 'True';

// 1. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
getPresignedUrl(SourceFile)
    .then(([uploadUrl, uploadedFileUrl]) => {
        // 2. UPLOAD THE FILE TO CLOUD.
        uploadFile(SourceFile, uploadUrl)
            .then(() => {
                // 3. PDF Text Search FROM UPLOADED FILE
                pdfTextSearch(uploadedFileUrl);
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

function pdfTextSearch(uploadedFileUrl) {
    // Prepare URL for PDF text search API call.
    var query = `https://localhost/pdf/find`;
    let reqOptions = {
        uri: query,
        formData: {
            password: Password,
            pages: Pages,
            url: uploadedFileUrl,
            searchString: SearchString,
            regexSearch: RegexSearch
        }
    };

    // Send request
    request.get(reqOptions, function (error, response, body) {
        if (error) {
            return console.error("Error: ", error);
        }

        // Parse JSON response
        let data = JSON.parse(body);

        for (let index = 0; index < data.body.length; index++) {
            const element = data.body[index];
            console.log("Found text " + element["text"] + " at coordinates " + element["left"] + ", " + element["top"]);
        }
    });
}
