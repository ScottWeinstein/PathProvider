# assumes DLL is in current directory
ipmo .\PSProviderFramework.dll

# root parameter is mandatory, but you don't have to use it in your module script
Remove-PSDrive -Name PATH
new-psdrive -Name PATH -PSProvider containerscriptprovider -Root / -moduleinfo $(new-module -name PathProvider {



function GetChildItems {
    [cmdletbinding()]
    param(
		[string]$path, 
		[bool]$recurse
    )
    $ENV:Path.Split(";") | % { $psprovider.writeitemobject($_, $path, $false) }

    $psprovider.writeverbose("GetChildItems")
    # ...
}

function GetChildNames {
    [cmdletbinding()]
    param(
		[string]$path, 
		[Management.Automation.ReturnContainers]$returnContainers
    )

    $psprovider.writeverbose("GetChildNames")
    # ...
}
function GetItem {
    [cmdletbinding()]
    param(
		[string]$path
    )

    $psprovider.writeverbose("GetItem")
    # ...
}

function HasChildItems {
    [cmdletbinding()]
	[outputtype('bool')]
    param(
		[string]$path
    )

    $psprovider.writeverbose("HasChildItems")
    # ...
}

function IsItemContainer {
    [cmdletbinding()]
	[outputtype('bool')]
    param(
		[string]$path
    )
    !$path

    $psprovider.writeverbose("IsItemContainer")
    # ...
}
function IsValidPath {
    [cmdletbinding()]
	[outputtype('bool')]
    param(
		[string]$path
    )

    $psprovider.writeverbose("IsValidPath")
    # ...
}
function ItemExists {
    [cmdletbinding()]
	[outputtype('bool')]
    param(
		[string]$path
    )
    
    $ie = ($path -eq "") -or [bool]@(GetEnvPathItems | ? { $_ -eq $path }) 
    return $ie
    $psprovider.writeverbose("ItemExists")
    # ...
}

function NewItem {
    [cmdletbinding()]
    param(
		[string]$path, 
		[string]$itemTypeName, 
		[Object]$newItemValue
    )

    $psprovider.writeverbose("NewItem")
    # ...
}
function RemoveItem {
    [cmdletbinding()]
    param(
		[string]$path, 
		[bool]$recurse
    )
    
    $new = GetEnvPathItems | ? { $_ -ne $path }
    SetEnvPath($new)
}

function RenameItem {
    [cmdletbinding()]
    param(
		[string]$path, 
		[string]$newName
    )

    $psprovider.writeverbose("RenameItem")
    # ...
}


function GetEnvPathItems()
{
    $Env:Path.Split(";")
}

function SetEnvPath([string[]]$items)
{
    if ($items)
    {
        $Env:Path = [string]::Join(";", $items)  
    }
    else
    {
        $Env:Path="";
    } 
}


});

rm PATH:\c:\jruby\bin
