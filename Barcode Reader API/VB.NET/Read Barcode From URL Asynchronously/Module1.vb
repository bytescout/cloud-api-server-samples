'*******************************************************************************************'
'                                                                                           '
' Get API Key https://app.pdf.co/signup                                                     '
' API Documentation: https://developer.pdf.co/api/index.html                                '
'                                                                                           '
' Note: Replace placeholder values in the code with your API Key                            '
' and file paths (if applicable)                                                            '
'                                                                      '
'*******************************************************************************************'


Imports System.IO
Imports System.Net
Imports System.Threading
Imports Newtonsoft.Json.Linq

' Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
' If it's not then please replace this with with your hosting url.

' Cloud API asynchronous "Barcode Reader" job example.
' Allows to avoid timeout errors when processing huge or scanned PDF documents.

Module Module1

	' Direct URL of source file to search barcodes in.
	Const SourceFileURL As String = "https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/barcode-reader/sample.pdf"
	' Comma-separated list of barcode types to search. 
	Const BarcodeTypes As String = "Code128,Code39,Interleaved2of5,EAN13"
	' Comma-separated list of page indices (or ranges) to process. Leave empty for all pages. Example: '0,2-5,7-'.
	Const Pages As String = ""
	' (!) Make asynchronous job
	Const Async As Boolean = True

	Sub Main()

		' Create standard .NET web client instance
		Dim webClient As WebClient = New WebClient()

		' Prepare URL for `Barcode Reader` API call
		Dim query As String = Uri.EscapeUriString(String.Format(
			"https://localhost/barcode/read/from/url?types={0}&pages={1}&url={2}&async={3}",
			BarcodeTypes,
			Pages,
			SourceFileURL, 
			Async))

		Try
			' Execute request
			Dim response As String = webClient.DownloadString(query)

			' Parse JSON response
			Dim json As JObject = JObject.Parse(response)

			If json("error").ToObject(Of Boolean) = False Then
				
				' Asynchronous job ID
				Dim jobId As String = json("jobId").ToString()
				' URL of generated JSON file with decoded barcodes that will available after the job completion
				Dim resultFileUrl As String = json("url").ToString()

				' Check the job status in a loop. 
				' If you don't want to pause the main thread you can rework the code 
				' to use a separate thread for the status checking and completion.
				Do
					Dim status As String = CheckJobStatus(jobId) ' Possible statuses: "working", "failed", "aborted", "success".

					' Display timestamp and status (for demo purposes)
					Console.WriteLine(DateTime.Now.ToLongTimeString() + ": " + status)

					If status = "success" Then
						
						' Download generated JSON results file as string
						Dim jsonFileString As String = webClient.DownloadString(resultFileUrl)

						Dim jsonFoundBarcodes As JArray = JArray.Parse(jsonFileString)

						' Display found barcodes in console
						For Each token As JToken In jsonFoundBarcodes
							Console.WriteLine("Found barcode:")
							Console.WriteLine("  Type: " + token("TypeName").ToString())
							Console.WriteLine("  Value: " + token("Value").ToString())
							Console.WriteLine("  Document Page Index: " + token("Page").ToString())
							Console.WriteLine("  Rectangle: " + token("Rect").ToString())
							Console.WriteLine("  Confidence: " + token("Confidence").ToString())
							Console.WriteLine()
						Next
						Exit Do

					ElseIf status = "working" Then

						' Pause for a few seconds
						Thread.Sleep(3000)

					Else

						Console.WriteLine(status)
						Exit Do

					End If

				Loop

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

	Function CheckJobStatus(jobId As String) As String

		Using webClient As WebClient = New WebClient()
			
			Dim url As String = "https://localhost/job/check?jobid=" + jobId

			Dim response As String = webClient.DownloadString(url)
			Dim json As JObject = JObject.Parse(response)

			return Convert.ToString(json("status"))

		End Using

	End Function

End Module
