## How to async file upload and async merge PDF for PDF merging API in C# with ByteScout Cloud API Server ByteScout Cloud API Server is the ready to deploy Web API Server that can be deployed in less than thirty minutes into your own in-house Windows server (no Internet connnection is required to process data!) or into private cloud server. Can store data on in-house local server based storage or in Amazon AWS S3 bucket. Processing data solely on the server using built-in ByteScout powered engine, no cloud services are used to process your data!.

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
    <AppDesignerFolder>Properties</AppDesignerFolder>
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
    <Compile Include="Properties\AssemblyInfo.cs" />
  </ItemGroup>
  <ItemGroup>
    <None Include="packages.config" />
    <Content Include="sample1.pdf">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </Content>
    <Content Include="sample2.pdf">
      <CopyToOutputDirectory>Always</CopyToOutputDirectory>
    </Content>
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

##### **Program.cs:**
    
```
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Threading;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace ByteScoutWebApiExample
{
	// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
	// If it's not then please replace this with with your hosting url.
	class Program
	{
		// The authentication key (API Key).
		// Get your own by registering at https://app.pdf.co/documentation/api
		const String API_KEY = "***********************************";
		
		// Source PDF files
		static string[] SourceFiles = new string[] { @".\sample1.pdf", @".\sample2.pdf" };
		// Destination PDF file name
		const string DestinationFile = @".\result.pdf";
        // (!) Make asynchronous job
        const bool Async = true;

        static void Main(string[] args)
		{
			// Create standard .NET web client instance
			WebClient webClient = new WebClient();

			// Set API Key
			webClient.Headers.Add("x-api-key", API_KEY);

			// 1. UPLOAD FILES TO CLOUD

			List<string> uploadedFiles = new List<string>();

			try
			{
				foreach (string pdfFile in SourceFiles)
				{
					// 1a. RETRIEVE THE PRESIGNED URL TO UPLOAD THE FILE.
					
					// Prepare URL for `Get Presigned URL` API call
					string query = Uri.EscapeUriString(string.Format(
						"https://localhost/file/upload/get-presigned-url?contenttype=application/octet-stream&name={0}",
						Path.GetFileName(pdfFile)));

					// Execute request
					string response = webClient.DownloadString(query);

					// Parse JSON response
					JObject json = JObject.Parse(response);

					if (json["error"].ToObject<bool>() == false)
					{
						// Get URL to use for the file upload
						string uploadUrl = json["presignedUrl"].ToString();
						// Get URL of uploaded file to use with later API calls
						string uploadedFileUrl = json["url"].ToString();

						// 1b. UPLOAD THE FILE TO CLOUD.

						webClient.Headers.Add("content-type", "application/octet-stream");
						webClient.UploadFile(uploadUrl, "PUT", pdfFile); // You can use UploadData() instead if your file is byte[] or Stream
						
						uploadedFiles.Add(uploadedFileUrl);
					}
					else
					{
						Console.WriteLine(json["message"].ToString());
					}
				}

				if (uploadedFiles.Count > 0)
				{
                    // 2. MERGE UPLOADED PDF DOCUMENTS

                    // URL for `Merge PDF` API call
                    string url = "https://localhost/pdf/merge";

                    // Prepare requests params as JSON
                    Dictionary<string, object> parameters = new Dictionary<string, object>();
                    parameters.Add("name", Path.GetFileName(DestinationFile));
                    parameters.Add("url", string.Join(",", uploadedFiles));
                    parameters.Add("async", Async);

                    // Convert dictionary of params to JSON
                    string jsonPayload = JsonConvert.SerializeObject(parameters);

                    try
                    {
                        // Execute POST request with JSON payload
                        string response = webClient.UploadString(url, jsonPayload);

                        // Parse JSON response
                        JObject json = JObject.Parse(response);

                        if (json["error"].ToObject<bool>() == false)
                        {
                            // Asynchronous job ID
                            string jobId = json["jobId"].ToString();
                            // URL of generated PDF file that will available after the job completion
                            string resultFileUrl = json["url"].ToString();

                            // Check the job status in a loop. 
                            // If you don't want to pause the main thread you can rework the code 
                            // to use a separate thread for the status checking and completion.
                            do
                            {
                                string status = CheckJobStatus(jobId); // Possible statuses: "working", "failed", "aborted", "success".

                                // Display timestamp and status (for demo purposes)
                                Console.WriteLine(DateTime.Now.ToLongTimeString() + ": " + status);

                                if (status == "success")
                                {
                                    // Download PDF file
                                    webClient.DownloadFile(resultFileUrl, DestinationFile);

                                    Console.WriteLine("Generated PDF file saved as \"{0}\" file.", DestinationFile);
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
                    catch (WebException e)
                    {
                        Console.WriteLine(e.ToString());
                    }
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


        /// <summary>
        /// Check job status
        /// </summary>
        static string CheckJobStatus(string jobId)
        {
            using (WebClient webClient = new WebClient())
            {
                // Set API Key
                webClient.Headers.Add("x-api-key", API_KEY);

                string url = "https://localhost/job/check?jobid=" + jobId;

                string response = webClient.DownloadString(url);
                JObject json = JObject.Parse(response);

                return Convert.ToString(json["status"]);
            }
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