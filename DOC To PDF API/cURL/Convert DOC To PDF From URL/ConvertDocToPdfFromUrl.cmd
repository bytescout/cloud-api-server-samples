# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

@echo off

:: Path of the cURL executable
set CURL="curl.exe"

:: Direct URL of source DOC or DOCX file.
set SOURCE_FILE_URL=https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/doc-to-pdf/sample.docx
:: Result PDF file name
set RESULT_FILE_NAME=result.pdf

:: Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
:: If it's not then please replace this with with your hosting url.

:: Prepare URL for `DOC To PDF` API call
set QUERY="https://localhost/pdf/convert/from/doc?name=%RESULT_FILE_NAME%&url=%SOURCE_FILE_URL%"

:: Perform request and save response to a file
%CURL% -# -X GET %QUERY% >response.json

:: Display the response
type response.json

:: Use any convenient way to parse JSON response and get URL of generated file(s)


echo.
pause