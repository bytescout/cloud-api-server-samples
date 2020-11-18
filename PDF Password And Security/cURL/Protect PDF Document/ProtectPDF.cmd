# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

curl --location --request POST 'https://localhost/pdf/security/add' \
--header 'Content-Type: application/json' \
--header 'x-api-key: {{x-api-key}}' \
--form 'url=https://bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/pdf-merge/sample1.pdf' \
--form 'ownerPassword=res12345' \
--form 'userPassword=54321' \
--form 'EncryptionAlgorithm=AES_128bit' \
--form 'AllowAccessibilitySupport=true' \
--form 'AllowAssemblyDocument=false' \
--form 'AllowPrintDocument=false' \
--form 'AllowFillForms=false' \
--form 'AllowModifyDocument=false' \
--form 'AllowContentExtraction=false' \
--form 'AllowModifyAnnotations=false' \
--form 'PrintQuality=LowResolution' \
--form 'encrypt=false' \
--form 'async=false'