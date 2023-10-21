#powershell

#find all minifest.json files in resource_packs and behavior_packs
$resource_manifests = Get-ChildItem -Path .\resource_packs\ -Filter manifest.json -Recurse

#get the json from world_resource_packs.json
$worldPacks = Get-Content -Path .\world_resource_packs.json | ConvertFrom-Json


#loop through all the manifests and get the header uuid
foreach ($manifest in $resource_manifests) {
    $manifestJson = Get-Content -Path $manifest.FullName | ConvertFrom-Json
    $manifestHeader = $manifestJson.header
    $manifestHeaderUuid = $manifestHeader.uuid
    $manifestHeaderVersion = $manifestHeader.version


    $pack_dir = $manifest.DirectoryName

    $pack_folder = $pack_dir | Split-Path -Leaf

    #if the path contains 'resource_packs', it's a resource pack
    if ($pack_dir.Contains("resource_packs")) {
        $path = 'resource_packs/' + $pack_folder
    }

    #if the path contains 'behavior_packs', it's a behavior pack
    if ($pack_dir.Contains("behavior_packs")) {
        $path = 'behavior_packs/' + $pack_folder
    }


    echo ("adding pack to world_resource_packs.json: " + $manifestHeaderUuid + " " + $pack_folder)
    $worldPacks += @{
            "pack_id" = $manifestHeaderUuid
            "version" = $manifestHeaderVersion
    }

    #save the world_resource_packs.json in utf-8
    $worldPacks | ConvertTo-Json | Out-File -Encoding utf8 -FilePath .\world_resource_packs.json




    #build the valid_known_packs array
    $validPacks = @()

    $validPacks += @{
        "file_version" = 2
    }

    for ($i = 0; $i -lt $worldPacks.Count; $i++) {

        $validPacks += @{
            "file_system" = "RawPath"
            "path" = $path
            "uuid" = $manifestHeaderUuid
            "version" = $manifestHeaderVersion
        }


    }


    #save the valid_known_packs.json in utf-8
    $validPacks | ConvertTo-Json | Out-File -Encoding utf8 -FilePath .\valid_known_packs.json



}
