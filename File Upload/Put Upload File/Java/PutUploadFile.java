//*******************************************************************************************//
//                                                                                           //
// Get Your API Key: https://app.pdf.co/signup                                               //
// API Documentation: https://developer.pdf.co/api/index.html                                //
//                                                                                           //
// Note: Replace placeholder values in the code with your API Key                            //
// and file paths (if applicable)                                                            //
//                                                                                           //
//*******************************************************************************************//


import java.io.*;
import okhttp3.*;

// Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
// If it's not then please replace this with with your hosting url.
public class main {
		public static void main(String []args) throws IOException{
				OkHttpClient client = new OkHttpClient().newBuilder()
						.build();
				MediaType mediaType = MediaType.parse("text/plain");
				RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
						.addFormDataPart("file","/Users/em/Downloads/logo.png",
								RequestBody.create(MediaType.parse("application/octet-stream"),
								new File("/Users/em/Downloads/logo.png")))
						.build();
				Request request = new Request.Builder()
						.url("<insert presignedUrl generated by https://localhost/file/upload/get-presigned-url >")
						.method("PUT", body)
						.addHeader("x-api-key", "{{x-api-key}}")
						.build();
				Response response = client.newCall(request).execute();
				System.out.println(response.body().string());
		}
}
