import os
import requests # pip install requests

# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

# Base URL for PDF.co Web API requests
BASE_URL = "https://localhost"

# Source file name
SourceFile = ".\\sample.pdf"

# Comma-separated list of barcode types to search.
# See valid barcode types in the documentation https://app.pdf.co/documentation/api/1.0/barcode/read_from_url.html
BarcodeTypes = "Code128,Code39,Interleaved2of5,EAN13"

# Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
Pages = ""

def main(args = None):
    uploadedFileUrl = uploadFile(SourceFile)
    if (uploadedFileUrl != None):
        readBarcodes(uploadedFileUrl)


def readBarcodes(uploadedFileUrl):
    """Get Barcode Information using PDF.co Web API"""

    # Prepare URL for 'Barcode Reader' API request
    url = "{}/barcode/read/from/url?types={}&pages={}&url={}".format(
        BASE_URL,
        BarcodeTypes,
        Pages,
        uploadedFileUrl
    )

    # Execute request and get response as JSON
    response = requests.get(url, headers={ "content-type": "application/octet-stream" })
    if (response.status_code == 200):
        json = response.json()

        if json["error"] == False:
            # Display information
            for barcode in json["barcodes"]:
                print("Found barcode:")
                print(f"  Type: {barcode['TypeName']}")
                print(f"  Value: {barcode['Value']}")
                print(f"  Document Page Index: {barcode['Page']}")
                print(f"  Rectangle: {barcode['Rect']}")
                print(f"  Confidence: {barcode['Confidence']}")
                print("")
        else:
            # Show service reported error
            print(json["message"])
    else:
        print(f"Request error: {response.status_code} {response.reason}")


def uploadFile(fileName):
    """Uploads file to the cloud"""
    
    # 1. RETRIEVE PRESIGNED URL TO UPLOAD FILE.

    # Prepare URL for 'Get Presigned URL' API request
    url = "{}/file/upload/get-presigned-url?contenttype=application/octet-stream&name={}".format(
        BASE_URL, os.path.basename(fileName))
    
    # Execute request and get response as JSON
    response = requests.get(url)
    if (response.status_code == 200):
        json = response.json()
        
        if json["error"] == False:
            # URL to use for file upload
            uploadUrl = json["presignedUrl"]
            # URL for future reference
            uploadedFileUrl = json["url"]

            # 2. UPLOAD FILE TO CLOUD.
            with open(fileName, 'rb') as file:
                requests.put(uploadUrl, data=file, headers={  "content-type": "application/octet-stream" })

            return uploadedFileUrl
        else:
            # Show service reported error
            print(json["message"])    
    else:
        print(f"Request error: {response.status_code} {response.reason}")

    return None


if __name__ == '__main__':
    main()