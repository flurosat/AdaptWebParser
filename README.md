# AdaptWebParser

This web api contains one endpoint `/api/parse` where a zip file containing .dat files is posted to. 
The web api will then parse the .dat file contents to return json objects representing field crop names and crop varieties:
```
{
        "crop_Name": [
            "Corn"
        ],
        "crop_Variety_Name": [
            "DKC62-77RIB"
        ]
 }
 ```
