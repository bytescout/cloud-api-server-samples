# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("x-api-key", "{{x-api-key}}")

$body = "{`n    `"async`": false,`n    `"encrypt`": true,`n    `"name`": `"newDocument`",`n    `"url`": `"https://bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/pdf-edit/sample.pdf`",`n    `"annotations`":[        `n       {`n            `"text`":`"sample prefilled text`",`n            `"x`": 10,`n            `"y`": 30,`n            `"size`": 12,`n            `"pages`": `"0-`",`n            `"type`": `"TextField`",`n            `"id`": `"textfield1`"`n        },`n        {`n            `"x`": 100,`n            `"y`": 150,`n            `"size`": 12,`n            `"pages`": `"0-`",`n            `"type`": `"Checkbox`",`n            `"id`": `"checkbox2`"`n        },`n        {`n            `"x`": 100,`n            `"y`": 170,`n            `"size`": 12,`n            `"pages`": `"0-`",`n            `"link`": `"https://bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/pdf-edit/logo.png`",`n            `"type`": `"CheckboxChecked`",`n            `"id`":`"checkbox3`"`n        }          `n        `n    ],`n    `n    `"images`": [`n        {`n            `"url`": `"bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/pdf-edit/logo.png`",`n            `"x`": 200,`n            `"y`": 250,`n            `"pages`": `"0`",`n            `"link`": `"www.pdf.co`"`n        }`n        `n    ]`n}"

$response = Invoke-RestMethod 'https://localhost/pdf/edit/add' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json