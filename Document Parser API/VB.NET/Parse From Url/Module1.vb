'*******************************************************************************************'
'                                                                                           '
' Get API Key https://app.pdf.co/signup                                                     '
' API Documentation: https://developer.pdf.co/api/index.html                                '
'                                                                                           '
' Note: Replace placeholder values in the code with your API Key                            '
' and file paths (if applicable)                                                            '
'                                                                      '
'*******************************************************************************************'


Imports System.Collections.Specialized
Imports System.IO
Imports System.Net
Imports System.Text
Imports Newtonsoft.Json.Linq

' Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
' If it's not then please replace this with with your hosting url.

Module Module1

    ' Source PDF file Urll
    Const SourceFileUrl As String = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/document-parser/MultiPageTable.pdf"

    ' Destination TXT file name
    Const DestinationFile As String = ".\result.json"

    Sub Main()

        ' Template text. Use Document Parser (https://pdf.co/document-parser, https://app.pdf.co/document-parser)
        ' to create templates.
        ' Read template from file
        Dim templateText As String = File.ReadAllText("MultiPageTable-template1.yml")

        ' Create standard .NET web client instance
        Dim webClient As WebClient = New WebClient()

        Try

            ' PARSE UPLOADED PDF DOCUMENT

            ' URL for `Document Parser` API call
            Dim query As String = "https://localhost/pdf/documentparser"

            Dim requestBody As New NameValueCollection()
            requestBody.Add("url", SourceFileUrl)
            requestBody.Add("template", templateText)

            ' Execute request
            Dim responseBytes As Byte() = webClient.UploadValues(query, "POST", requestBody)
            Dim response As String = Encoding.UTF8.GetString(responseBytes)

            ' Parse JSON response
            Dim json As JObject = JObject.Parse(response)

            If json("error").ToObject(Of Boolean) = False Then

                ' Get URL of generated JSON file
                Dim resultFileUrl As String = json("url")

                ' Download JSON file
                webClient.DownloadFile(resultFileUrl, DestinationFile)

                Console.WriteLine("Generated JSON file saved as {0} file.", DestinationFile)
            Else
                Console.WriteLine(json("message").ToString())
            End If

        Catch ex As WebException
            Console.WriteLine(ex.ToString())
        End Try

        webClient.Dispose()

        Console.WriteLine()
        Console.WriteLine("Press any key...")
        Console.ReadKey()

    End Sub

End Module
