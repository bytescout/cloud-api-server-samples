## How to parse simple document for document parser API in C# using ByteScout Cloud API Server ByteScout Cloud API Server is API server that is ready to use and can be installed and deployed in less than 30 minutes on your own Windows server or server in a cloud. It can save data and files on your local server-based file storage or in Amazon AWS S3 storage. Data is processed solely on the API server and is powered by ByteScout engine, no cloud services or Internet connection is required for data processing..

## REQUEST FREE TECH SUPPORT

[Click here to get in touch](https://bytescout.zendesk.com/hc/en-us/requests/new?subject=ByteScout%20Cloud%20API%20Server%20Question)

or just send email to [support@bytescout.com](mailto:support@bytescout.com?subject=ByteScout%20Cloud%20API%20Server%20Question) 

## ON-PREMISE OFFLINE SDK 

[Get Your 60 Day Free Trial](https://bytescout.com/download/web-installer?utm_source=github-readme)
[Explore Documentation](https://bytescout.com/documentation/index.html?utm_source=github-readme)
[Explore Source Code Samples](https://github.com/bytescout/ByteScout-SDK-SourceCode/)
[Sign Up For Online Training](https://academy.bytescout.com/)


## ON-DEMAND REST WEB API

[Get your API key](https://app.pdf.co/signup?utm_source=github-readme)
[Security](https://pdf.co/security)
[Explore Web API Documentation](https://apidocs.pdf.co?utm_source=github-readme)
[Explore Web API Samples](https://github.com/bytescout/ByteScout-SDK-SourceCode/tree/master/PDF.co%20Web%20API)

## VIDEO REVIEW

[https://www.youtube.com/watch?v=NEwNs2b9YN8](https://www.youtube.com/watch?v=NEwNs2b9YN8)




<!-- code block begin -->

##### **AmazonAWS.yml:**
    
```
templateName: Amazon Web Services Invoice
templateVersion: 4
templatePriority: 0
detectionRules:
  keywords:
  - Amazon Web Services
  - ATTN
  - Invoice
objects:
- name: total
  objectType: field
  fieldProperties:
    fieldType: macros
    expression: TOTAL AMOUNT DUE ON{{Anything}}{{Dollar}}({{Number}})
    regex: true
    dataType: decimal
- name: subTotal
  objectType: field
  fieldProperties:
    fieldType: macros
    expression: '{{LineStart}}{{Spaces}}Charges{{Spaces}}{{Dollar}}({{Number}})'
    regex: true
    dataType: decimal
- name: dateIssued
  objectType: field
  fieldProperties:
    fieldType: macros
    expression: Invoice Date:{{Spaces}}({{Anything}}){{LineEnd}}
    regex: true
    dataType: date
    dateFormat: MMMM d , yyyy
- name: invoiceId
  objectType: field
  fieldProperties:
    fieldType: macros
    expression: Invoice Number:{{Spaces}}({{Digits}})
    regex: true
- name: companyName
  objectType: field
  fieldProperties:
    fieldType: static
    expression: Amazon Web Services, Inc.
    regex: true
- name: companyWebsite
  objectType: field
  fieldProperties:
    fieldType: static
    expression: aws.amazon.com
    regex: true
- name: billTo
  objectType: field
  fieldProperties:
    fieldType: rectangle
    expression: Bill to Address:{{ToggleSingleLineMode}}({{AnythingGreedy}})
    regex: true
    rectangle:
    - 33
    - 115.5
    - 213.75
    - 72.75
    pageIndex: 0
- name: currency
  objectType: field
  fieldProperties:
    fieldType: static
    expression: USD
    regex: true
- name: table1
  objectType: table
  tableProperties:
    start:
      expression: '{{LineStart}}{{Spaces}}Detail{{LineEnd}}'
      regex: true
    end:
      expression: '{{EndOfPage}}'
      regex: true
    row:
      expression: '{{LineStart}}{{Spaces}}(?<description>{{SentenceWithSingleSpaces}}){{Spaces}}{{Dollar}}(?<unitPrice>{{Number}}){{LineEnd}}'
      regex: true
    columns:
    - name: unitPrice
      dataType: decimal


```

<!-- code block end -->    

<!-- code block begin -->

##### **ByteScoutWebApiExample.csproj:**
    
```
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="12.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
    <ProjectGuid>{1E1C2C34-017E-4605-AE2B-55EA3313BE51}</ProjectGuid>
    <OutputType>Exe</OutputType>
    <RootNamespace>ByteScoutWebApiExample</RootNamespace>
    <AssemblyName>ByteScoutWebApiExample</AssemblyName>
    <TargetFrameworkVersion>v4.0</TargetFrameworkVersion>
    <FileAlignment>512</FileAlignment>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
    <PlatformTarget>AnyCPU</PlatformTarget>
    <DebugSymbols>true</DebugSymbols>
    <DebugType>full</DebugType>
    <Optimize>false</Optimize>
    <OutputPath>bin\Debug\</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
    <PlatformTarget>AnyCPU</PlatformTarget>
    <DebugType>pdbonly</DebugType>
    <Optimize>true</Optimize>
    <OutputPath>bin\Release\</OutputPath>
    <DefineConstants>TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Newtonsoft.Json, Version=10.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed, processorArchitecture=MSIL">
      <HintPath>packages\Newtonsoft.Json.10.0.3\lib\net40\Newtonsoft.Json.dll</HintPath>
      <Private>True</Private>
    </Reference>
    <Reference Include="System" />
    <Reference Include="System.Core" />
    <Reference Include="System.Xml.Linq" />
    <Reference Include="System.Data" />
    <Reference Include="System.Xml" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Program.cs" />
  </ItemGroup>
  <ItemGroup>
    <None Include="AmazonAWS.yml">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </None>
    <None Include="DigitalOcean.yml">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </None>
    <None Include="Google.yml">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </None>
    <None Include="AmazonAWS.pdf">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </None>
    <None Include="DigitalOcean.pdf">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </None>
    <None Include="Google.pdf">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </None>
    <None Include="packages.config" />
  </ItemGroup>
  <Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
  <!-- To modify your build process, add your task inside one of the targets below and uncomment it. 
       Other similar extension points exist, see Microsoft.Common.targets.
  <Target Name="BeforeBuild">
  </Target>
  <Target Name="AfterBuild">
  </Target>
  -->
</Project>
```

<!-- code block end -->    

<!-- code block begin -->

##### **ByteScoutWebApiExample.sln:**
    
```

Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio 2013
VisualStudioVersion = 12.0.40629.0
MinimumVisualStudioVersion = 10.0.40219.1
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "ByteScoutWebApiExample", "ByteScoutWebApiExample.csproj", "{1E1C2C34-017E-4605-AE2B-55EA3313BE51}"
EndProject
Global
	GlobalSection(SolutionConfigurationPlatforms) = preSolution
		Debug|Any CPU = Debug|Any CPU
		Release|Any CPU = Release|Any CPU
	EndGlobalSection
	GlobalSection(ProjectConfigurationPlatforms) = postSolution
		{1E1C2C34-017E-4605-AE2B-55EA3313BE51}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		{1E1C2C34-017E-4605-AE2B-55EA3313BE51}.Debug|Any CPU.Build.0 = Debug|Any CPU
		{1E1C2C34-017E-4605-AE2B-55EA3313BE51}.Release|Any CPU.ActiveCfg = Release|Any CPU
		{1E1C2C34-017E-4605-AE2B-55EA3313BE51}.Release|Any CPU.Build.0 = Release|Any CPU
	EndGlobalSection
	GlobalSection(SolutionProperties) = preSolution
		HideSolutionNode = FALSE
	EndGlobalSection
EndGlobal

```

<!-- code block end -->    

<!-- code block begin -->

##### **DigitalOcean.yml:**
    
```
templateName: DigitalOcean Invoice
templateVersion: 4
templatePriority: 0
detectionRules:
  keywords:
  - DigitalOcean
  - 101 Avenue of the Americas
  - Invoice Number
objects:
- name: companyName
  objectType: field
  fieldProperties:
    fieldType: static
    expression: DigitalOcean
    regex: true
- name: invoiceId
  objectType: field
  fieldProperties:
    fieldType: macros
    expression: 'Invoice Number: ({{Digits}})'
    regex: true
- name: dateIssued
  objectType: field
  fieldProperties:
    fieldType: macros
    expression: 'Date Issued: ({{SmartDate}})'
    regex: true
    dataType: date
    dateFormat: auto-mdy
- name: total
  objectType: field
  fieldProperties:
    fieldType: macros
    expression: 'Total: {{Dollar}}({{Number}})'
    regex: true
    dataType: decimal
- name: currency
  objectType: field
  fieldProperties:
    fieldType: static
    expression: USD
    regex: true
- name: table1
  objectType: table
  tableProperties:
    start:
      expression: Description{{Spaces}}Hours
      regex: true
    end:
      expression: 'Total:'
      regex: true
    row:
      expression: '{{LineStart}}{{Spaces}}(?<description>{{SentenceWithSingleSpaces}}){{Spaces}}(?<hours>{{Digits}}){{Spaces}}(?<start>{{2Digits}}{{Minus}}{{2Digits}}{{Space}}{{2Digits}}{{Colon}}{{2Digits}}){{Spaces}}(?<end>{{2Digits}}{{Minus}}{{2Digits}}{{Space}}{{2Digits}}{{Colon}}{{2Digits}}){{Spaces}}{{Dollar}}(?<unitPrice>{{Number}})'
      regex: true
    columns:
    - name: hours
      dataType: integer
    - name: unitPrice
      dataType: decimal


```

<!-- code block end -->    

<!-- code block begin -->

##### **Google.yml:**
    
```
templateName: Google Invoice
templateVersion: 4
templatePriority: 0
detectionRules:
  keywords:
  - Google
  - 77-0493581
  - Invoice
objects:
- name: invoiceId
  objectType: field
  fieldProperties:
    expression: Invoice number:{{Spaces}}({{Digits}})
    regex: true
- name: dateIssued
  objectType: field
  fieldProperties:
    expression: Issue date:{{Spaces}}({{SmartDate}})
    regex: true
    dataType: date
    dateFormat: MMM d, yyyy
- name: total
  objectType: field
  fieldProperties:
    expression: Amount due in USD:{{Spaces}}{{Number}}
    regex: true
    dataType: decimal
- name: subTotal
  objectType: field
  fieldProperties:
    expression: Subtotal in USD:{{Spaces}}{{Number}}
    regex: true
    dataType: decimal
- name: taxRate
  objectType: field
  fieldProperties:
    expression: State sales tax {{OpeningParenthesis}}{{Digits}}{{Percent}}{{ClosingParenthesis}}
    regex: true
    dataType: integer
- name: tax
  objectType: field
  fieldProperties:
    expression: State sales tax{{Anything}}{{Number}}{{LineEnd}}
    regex: true
    dataType: decimal
- name: companyName
  objectType: field
  fieldProperties:
    fieldType: static
    expression: Google LLC
    regex: true
- name: billTo
  objectType: field
  fieldProperties:
    fieldType: rectangle
    regex: true
    rectangle:
    - 0
    - 152
    - 280
    - 72
    pageIndex: 0
- name: billingId
  objectType: field
  fieldProperties:
    expression: Billing ID:{{Spaces}}({{DigitsOrSymbols}})
    regex: true
- name: currency
  objectType: field
  fieldProperties:
    fieldType: static
    expression: USD
    regex: true
- name: table1
  objectType: table
  tableProperties:
    start:
      expression: Description{{Spaces}}Interval{{Spaces}}Quantity{{Spaces}}Amount
      regex: true
    end:
      expression: Subtotal in USD
      regex: true
    row:
      expression: '{{LineStart}}{{Spaces}}(?<description>{{SentenceWithSingleSpaces}}){{Spaces}}(?<interval>{{3Letters}}{{Space}}{{Digits}}{{Space}}{{Minus}}{{Space}}{{3Letters}}{{Space}}{{Digits}}){{Spaces}}(?<quantity>{{Digits}}){{Spaces}}(?<amount>{{Number}})'
      regex: true
    columns:
    - name: quantity
      dataType: integer
    - name: amount
      dataType: decimal


```

<!-- code block end -->    

<!-- code block begin -->

##### **Program.cs:**
    
```
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Threading;

// Cloud API asynchronous "Document Parser" job example.
// Allows to avoid timeout errors when processing huge or scanned PDF documents.

namespace ByteScoutWebApiExample
{
	// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
	// If it's not then please replace this with with your hosting url.
    class Program
	{
		// The authentication key (API Key).
		// Get your own by registering at https://app.pdf.co/documentation/api
		const String API_KEY = "*************************";
		
		// Source PDF file
		const string SourceFile = @".\AmazonAWS.pdf";
        //const string SourceFile = @".\DigitalOcean.pdf";
        //const string SourceFile = @".\Google.pdf";

        // PDF document password. Leave empty for unprotected documents.
        const string Password = "";

		// Destination TXT file name
		const string DestinationFile = @".\result.json";

        // (!) Make asynchronous job
        const bool Async = true;


		static void Main(string[] args)
		{
			// Template text. Use Document Parser (https://pdf.co/document-parser, https://app.pdf.co/document-parser)
			// to create templates.
			// Read template from file:
			String templateText = File.ReadAllText(@".\AmazonAWS.yml");
            //String templateText = File.ReadAllText(@".\DigitalOcean.yml");
            //String templateText = File.ReadAllText(@".\Google.yml");

            // Create standard .NET web client instance
            WebClient webClient = new WebClient();

			// Set API Key
			webClient.Headers.Add("x-api-key", API_KEY);

			// 1. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
			// * If you already have a direct file URL, skip to the step 3.
			
			// Prepare URL for `Get Presigned URL` API call
			string query = Uri.EscapeUriString(string.Format(
				"https://localhost/file/upload/get-presigned-url?contenttype=application/octet-stream&name={0}", 
				Path.GetFileName(SourceFile)));

			try
			{
				// Execute request
				string response = webClient.DownloadString(query);

				// Parse JSON response
				JObject json = JObject.Parse(response);

				if (json["error"].ToObject<bool>() == false)
				{
					// Get URL to use for the file upload
					string uploadUrl = json["presignedUrl"].ToString();
					string uploadedFileUrl = json["url"].ToString();

					// 2. UPLOAD THE FILE TO CLOUD.

					webClient.Headers.Add("content-type", "application/octet-stream");
					webClient.UploadFile(uploadUrl, "PUT", SourceFile); // You can use UploadData() instead if your file is byte[] or Stream
					webClient.Headers.Remove("content-type");

                    // 3. PARSE UPLOADED PDF DOCUMENT

                    // URL of `Document Parser` API call
                    string url = "https://localhost/pdf/documentparser";

                    Dictionary<string, object> requestBody = new Dictionary<string, object>();
                    requestBody.Add("template", templateText);
                    requestBody.Add("name", Path.GetFileName(DestinationFile));
                    requestBody.Add("url", uploadedFileUrl);
                    requestBody.Add("async", Async);

                    // Convert dictionary of params to JSON
                    string jsonPayload = JsonConvert.SerializeObject(requestBody);

                    // Execute request
                    response = webClient.UploadString(url, "POST", jsonPayload);
                    
                    // Parse JSON response
                    json = JObject.Parse(response);

                    if (json["error"].ToObject<bool>() == false)
                    {
                        // Asynchronous job ID
                        string jobId = json["jobId"].ToString();
                        // Get URL of generated JSON file
                        string resultFileUrl = json["url"].ToString();

                        // Check the job status in a loop. 
                        // If you don't want to pause the main thread you can rework the code 
                        // to use a separate thread for the status checking and completion.
                        do
                        {
                            string status = CheckJobStatus(webClient, jobId); // Possible statuses: "working", "failed", "aborted", "success".

                            // Display timestamp and status (for demo purposes)
                            Console.WriteLine(DateTime.Now.ToLongTimeString() + ": " + status);

                            if (status == "success")
                            {
                                // Download JSON file
                                webClient.DownloadFile(resultFileUrl, DestinationFile);

                                Console.WriteLine("Generated JSON file saved as \"{0}\" file.", DestinationFile);
                                break;
                            }
                            else if (status == "working")
                            {
                                // Pause for a few seconds
                                Thread.Sleep(3000);
                            }
                            else 
                            {
                                Console.WriteLine(status);
                                break;
                            }
                        }
                        while (true);
                    }
                    else
                    {
                        Console.WriteLine(json["message"].ToString());
                    }
				}
				else
				{
					Console.WriteLine(json["message"].ToString());
				}
			}
			catch (WebException e)
			{
				Console.WriteLine(e.ToString());
			}

			webClient.Dispose();


			Console.WriteLine();
			Console.WriteLine("Press any key...");
			Console.ReadKey();
		}

        static string CheckJobStatus(WebClient webClient, string jobId)
        {
            string url = "https://localhost/job/check?jobid=" + jobId;

            string response = webClient.DownloadString(url);
            JObject json = JObject.Parse(response);

            return Convert.ToString(json["status"]);
        }
	}
}

```

<!-- code block end -->    

<!-- code block begin -->

##### **packages.config:**
    
```
<?xml version="1.0" encoding="utf-8"?>
<packages>
  <package id="Newtonsoft.Json" version="10.0.3" targetFramework="net40" />
</packages>
```

<!-- code block end -->