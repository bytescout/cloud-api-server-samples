# Please NOTE: In this sample we're assuming Cloud Api Server is hosted at "https://localhost". 
# If it's not then please replace this with with your hosting url.

curl --location --request POST 'https://localhost/pdf/documentparser' \
--header 'Content-Type: application/json' \
--header 'x-api-key: {{x-api-key}}' \
--data-raw '{
    "url": "https://bytescout-com.s3-us-west-2.amazonaws.com/files/demo-files/cloud-api/document-parser/MultiPageTable.pdf",
    "template": "---\r\n# Template that demonstrates parsing of multi-page table using only\r\n# regular expressions for the table start, end, and rows.\r\n# If regular expression cannot be written for every table row (for example,\r\n# if the table contains empty cells), try the second method demonstrated\r\n# in `MultiPageTable-template2.yml` template.\r\ntemplateVersion: 3\r\ntemplatePriority: 0\r\nsourceId: Multipage Table Test\r\ndetectionRules:\r\n  keywords:\r\n  - Sample document with multi-page table\r\nfields:\r\n  total:\r\n    type: regex\r\n    expression: TOTAL {{DECIMAL}}\r\n    dataType: decimal\r\ntables:\r\n- name: table1\r\n  start:\r\n    # regular expression to find the table start in document\r\n    expression: Item\\s+Description\\s+Price\\s+Qty\\s+Extended Price\r\n  end:\r\n    # regular expression to find the table end in document\r\n    expression: TOTAL\\s+\\d+\\.\\d\\d\r\n  row:\r\n    # regular expression to find table rows\r\n    expression: '\''^\\s*(?<itemNo>\\d+)\\s+(?<description>.+?)\\s+(?<price>\\d+\\.\\d\\d)\\s+(?<qty>\\d+)\\s+(?<extPrice>\\d+\\.\\d\\d)'\''\r\n  columns:\r\n  - name: itemNo\r\n    type: integer\r\n  - name: description\r\n    type: string\r\n  - name: price\r\n    type: decimal\r\n  - name: qty\r\n    type: integer\r\n  - name: extPrice\r\n    type: decimal\r\n  multipage: true",
    "outputFormat": "JSON",
    "async": false,
    "encrypt": "false",
    "inline": "true",
    "profiles": "",
    "password": "",
    "storeResult": false
}'