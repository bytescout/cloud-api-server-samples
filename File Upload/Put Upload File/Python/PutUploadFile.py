import requests

# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

url = "<insert presignedUrl generated by https://localhost/file/upload/get-presigned-url >"

payload = {}
files = [
		('file', open('/Users/em/Downloads/logo.png','rb'))
]
headers = {
		'x-api-key': '{{x-api-key}}'
}

response = requests.request("PUT", url, headers=headers, data = payload, files = files)

print(response.text.encode('utf8'))
