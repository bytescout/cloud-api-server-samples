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


import java.io.*;
import okhttp3.*;
public class main {
	public static void main(String []args) throws IOException{
		OkHttpClient client = new OkHttpClient().newBuilder()
			.build();
		MediaType mediaType = MediaType.parse("application/json");
		RequestBody body = RequestBody.create(mediaType, "{\n    \"url\": \"https://bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/document-parser/sample-invoice.pdf\",\n    \"rulescsv\": \"Amazon,Amazon Web Services Invoice|Amazon CloudFront\\nDigital Ocean,DigitalOcean|DOInvoice\\nAcme,ACME Inc.|1540 Long Street, Jacksonville, 32099\",\n    \"caseSensitive\": \"true\",\n    \"async\": false,\n    \"encrypt\": \"false\",\n    \"inline\": \"true\",\n    \"password\": \"\",\n    \"profiles\": \"\"\n} ");
		Request request = new Request.Builder()
			.url("http://localhost:80/pdf/classifier")
			.method("POST", body)
			.addHeader("Content-Type", "application/json")
			.build();
		Response response = client.newCall(request).execute();
		System.out.println(response.body().string());
	}
}

