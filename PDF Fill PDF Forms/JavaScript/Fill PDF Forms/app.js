//*******************************************************************************************//
//                                                                                           //
// Get Your API Key: https://app.pdf.co/signup                                               //
// API Documentation: https://developer.pdf.co/api/index.html                                //
//                                                                                           //
// Note: Replace placeholder values in the code with your API Key                            //
// and file paths (if applicable)                                                            //
//                                                                                           //
//*******************************************************************************************//


// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
// If it's not then please replace this with with your hosting url.

var https = require("https");
var path = require("path");
var fs = require("fs");

// The authentication key (API Key).
// Get your own by registering at https://app.pdf.co/documentation/api
const API_KEY = "***********************************";

// Direct URL of source PDF file.
const SourceFileUrl = "https://bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/pdf-form/f1040.pdf";

// PDF document password. Leave empty for unprotected documents.
const Password = "";

// Destination PDF file name
const DestinationFile = "./result.pdf";

// Runs processing asynchronously. Returns Use JobId that you may use with /job/check to check state of the processing (possible states: working, failed, aborted and success). Must be one of: true, false.
const async = false;

// Form field data
var fields = [
    {
        "fieldName": "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[1]",
        "pages": "1",
        "text": "True"
    },
    {
        "fieldName": "topmostSubform[0].Page1[0].f1_02[0]",
        "pages": "1",
        "text": "John A."
    },        
    {
        "fieldName": "topmostSubform[0].Page1[0].f1_03[0]",
        "pages": "1",
        "text": "Doe"
    },        
    {
        "fieldName": "topmostSubform[0].Page1[0].YourSocial_ReadOrderControl[0].f1_04[0]",
        "pages": "1",
        "text": "123456789"
    },
    {
        "fieldName": "topmostSubform[0].Page1[0].YourSocial_ReadOrderControl[0].f1_05[0]",
        "pages": "1",
        "text": "Joan B."
    },
    {
        "fieldName": "topmostSubform[0].Page1[0].YourSocial_ReadOrderControl[0].f1_05[0]",
        "pages": "1",
        "text": "Joan B."
    },
    {
        "fieldName": "topmostSubform[0].Page1[0].YourSocial_ReadOrderControl[0].f1_06[0]",
        "pages": "1",
        "text": "Doe"
    },
    {
        "fieldName": "topmostSubform[0].Page1[0].YourSocial_ReadOrderControl[0].f1_07[0]",
        "pages": "1",
        "text": "987654321"
    }     
];


// * Fill forms *
// Prepare request to `PDF Edit` API endpoint
var queryPath = `/v1/pdf/edit/add`;

// JSON payload for api request
var jsonPayload = JSON.stringify({
    name: path.basename(DestinationFile),
    password: Password,
    url: SourceFileUrl,
    async: async,
    fields: fields
});

var reqOptions = {
    host: "api.pdf.co",
    method: "POST",
    path: queryPath,
    headers: {
        "x-api-key": API_KEY,
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(jsonPayload, 'utf8')
    }
};
// Send request
var postRequest = https.request(reqOptions, (response) => {
    response.on("data", (d) => {
        // Parse JSON response
        var data = JSON.parse(d);

        if (data.error == false) {
            // Download the PDF file
            var file = fs.createWriteStream(DestinationFile);
            https.get(data.url, (response2) => {
                response2.pipe(file).on("close", () => {
                    console.log(`Generated PDF file saved to '${DestinationFile}' file.`);
                });
            });
        }
        else {
            // Service reported error
            console.log(data.message);
        }
    });
}).on("error", (e) => {
    // Request error
    console.error(e);
});

// Write request data
postRequest.write(jsonPayload);
postRequest.end();
