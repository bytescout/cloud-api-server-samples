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


using System;
using RestSharp;
namespace HelloWorldApplication {
	// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
	// If it's not then please replace this with with your hosting url.
		class HelloWorld {
				static void Main(string[] args) {
						var client = new RestClient("https://localhost/file/upload/base64");
						client.Timeout = -1;
						var request = new RestRequest(Method.POST);
						request.AddHeader("x-api-key", "{{x-api-key}}");
						request.AlwaysMultipartFormData = true;
						request.AddParameter("file", "data:image/gif;base64,R0lGODlhEAAQAPUtACIiIScnJigoJywsLDIyMjMzMzU1NTc3Nzg4ODk5OTs7Ozw8PEJCQlBQUFRUVFVVVVhYWG1tbXt7fInDRYvESYzFSo/HT5LJVJPJVJTKV5XKWJbKWZbLWpfLW5jLXJrMYaLRbaTScKXScKXScafTdIGBgYODg6alprLYhbvekr3elr3el9Dotf///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAAAAAAAIf8LSW1hZ2VNYWdpY2sNZ2FtbWE9MC40NTQ1NQAsAAAAABAAEAAABpJAFGgkKhpFIRHpw2qBLJiLdCrNTFKt0wjD2Xi/G09l1ZIwRJeNZs3uUFQtEwCCVrM1bnhJYHDU73ktJQELBH5pbW+CAQoIhn94ioMKB46HaoGTB5WPaZmMm5wOIRcekqChliIZFXqoqYYkE2SaoZuWH1gmAgsIvr8ICQUPTRIABgTJyskFAw1ZDBAO09TUDw0RQQA7");
						IRestResponse response = client.Execute(request);
						Console.WriteLine(response.Content);
				}
		}
}
