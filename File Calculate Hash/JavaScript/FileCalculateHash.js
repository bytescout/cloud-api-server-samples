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

var request = require('request');
var options = {
  'method': 'POST',
  'url': 'https://localhost/file/hash',
  'headers': {
    'x-api-key': '{{x-api-key}}',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({"url":"https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-split/sample.pdf"})

};
request(options, function (error, response) {
  if (error) throw new Error(error);
  console.log(response.body);
});
