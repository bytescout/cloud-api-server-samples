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


/*jshint esversion: 6 */

var https = require("https");
var path = require("path");
var fs = require("fs");

// `request` module is required for file upload.
// Use "npm install request" command to install.
var request = require("request");

// The authentication key (API Key).
// Get your own by registering at https://app.pdf.co/documentation/api
const API_KEY = "***************************************";

// Source PDF file
const SourceFile = "./sample-rotated.pdf";
// Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
const Pages = "";
// PDF document password. Leave empty for unprotected documents.
const Password = "";
// Destination XLS file name
const DestinationFile = "./result.xls";

/*
Some of advanced options available through profiles:
(JSON can be single/double-quoted and contain comments.)
{
    "profiles": [
        {
            "profile1": {
                "NumberDecimalSeparator": "", // Allows to customize decimal separator in numbers.
                "NumberGroupSeparator": "", // Allows to customize thousands separator.
                "AutoDetectNumbers": true, // Whether to detect numbers. Values: true / false
                "RichTextFormatting": true, // Whether to keep text style and fonts. Values: true / false
                "PageToWorksheet": true, // Whether to create separate worksheet for each page of PDF document. Values: true / false
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
// Advanced options are properties of CSVExtractor class from ByteScout PDF Extractor SDK used in the back-end:
// https://cdn.bytescout.com/help/BytescoutPDFExtractorSDK/html/87ce5fa6-3143-167d-abbd-bc7b5e160fe5.htm

/*
Valid RotationAngle values:
0 - no rotation
1 - 90 degrees
2 - 180 degrees
3 - 270 degrees
*/
const Profiles = '{ "profiles": [{ "profile1": { "RotationAngle": 1 } } ] }';


// Prepare URL for `PDF To XLS` API call
var query = `https://api.pdf.co/v1/pdf/convert/to/xls`;
let reqOptions = {
    uri: query,
    headers: { "x-api-key": API_KEY },
    formData: {
        name: path.basename(DestinationFile),
        password: Password,
        pages: Pages,
        file: fs.createReadStream(SourceFile),
        profiles:Profiles
    }
};

// Send request
request.post(reqOptions, function (error, response, body) {
    if (error) {
        return console.error("Error: ", error);
    }

    // Parse JSON response
    let data = JSON.parse(body);
    if (data.error == false) {
        // Download XLS file
        var file = fs.createWriteStream(DestinationFile);
        https.get(data.url, (response2) => {
            response2.pipe(file)
            .on("close", () => {
                console.log(`Generated XLS file saved as "${DestinationFile}" file.`);
            });
        });
    }
    else {
        // Service reported error
        console.log("Error: " + data.message);
    }
});
