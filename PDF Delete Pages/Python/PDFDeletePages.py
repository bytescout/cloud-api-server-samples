import requests

# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

url = "https://localhost/pdf/edit/delete-pages"

payload = {'url': 'https://bytescout-com.s3.amazonaws.com/files/demo-files/cloud-api/pdf-split/sample.pdf',
'name': 'result.pdf',
'pages': '1-2'}
files = [

]
headers = {
		'x-api-key': '{{x-api-key}}'
}

response = requests.request("POST", url, headers=headers, data = payload, files = files)

print(response.text.encode('utf8'))
