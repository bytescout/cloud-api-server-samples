import os
import requests # pip install requests

# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# The authentication key (API Key).
# Get your own by registering at https://app.pdf.co/documentation/api
API_KEY = "********************************"

# Base URL for PDF.co Web API requests
BASE_URL = "https://localhost"

# Direct URL of source PDF file.
SourceFileURL = "https://bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/pdf-security/ProtectedPDFFile.pdf"

# Destination PDF file name
DestinationFile = ".\\unprotected.pdf"

# The owner/user password to open file and to remove security features
PDFFilePassword = "admin@123"

# Runs processing asynchronously. 
# Returns Use JobId that you may use with /job/check to check state of the processing (possible states: working, failed, aborted and success).
Async = False

def main(args = None):
    unprotectPDF(SourceFileURL, DestinationFile)


def unprotectPDF(uploadedFileUrl, destinationFile):
    """Remove password from PDF using PDF.co Web API"""

    # Prepare requests params as JSON
    # See documentation: https://apidocs.pdf.co
    parameters = {"name": os.path.basename(destinationFile), "url": uploadedFileUrl, "password": PDFFilePassword, "async": Async}

    # Serializing json
    import json
    json_object = json.dumps(parameters, indent=4)

    # Prepare URL for 'PDF Security' API request
    url = "{}/pdf/security/remove".format(BASE_URL)

    # Execute request and get response as JSON
    response = requests.post(url, data=json_object, headers={"x-api-key": API_KEY})
    if (response.status_code == 200):
        jsonResp = response.json()

        if jsonResp["error"] == False:
            #  Get URL of result file
            resultFileUrl = jsonResp["url"]
            # Download result file
            r = requests.get(resultFileUrl, stream=True)
            if (r.status_code == 200):
                with open(destinationFile, 'wb') as file:
                    for chunk in r:
                        file.write(chunk)
                print(f"Result file saved as \"{destinationFile}\" file.")
            else:
                print(f"Request error: {response.status_code} {response.reason}")
        else:
            # Show service reported error
            print(jsonResp["message"])
    else:
        print(f"Request error: {response.status_code} {response.reason}")

if __name__ == '__main__':
    main()