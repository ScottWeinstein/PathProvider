function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}

Import-Module "$(Get-ScriptDirectory)\lib\PSProviderFramework.dll"

if ([bool](Get-PSDrive PATHs -ErrorAction SilentlyContinue))
{
    Remove-PSDrive -Name PATH
}

New-PSDrive -Name PATH -PSProvider containerscriptprovider -Root / -moduleinfo $(new-module -name PathProvider {


function GetChildItems {
    [cmdletbinding()]
    param([string]$path,[bool]$recurse)
    GetEnvPathItems | % { $psprovider.writeitemobject($_, $path, $false) }
}

function IsItemContainer {
    [cmdletbinding()]
	[outputtype('bool')]
    param([string]$path)
    ($path -eq "")
}

function ItemExists {
    [cmdletbinding()]
	[outputtype('bool')]param([string]$path)
    
    $ie = ($path -eq "") -or [bool]@(GetEnvPathItems | ? { $_ -eq $path }) 
    return $ie
}

function NewItem {
    [cmdletbinding()]
    param(
		[string]$path, 
		[string]$itemTypeName, 
		[Object]$newItemValue
    )
    $new = @(GetEnvPathItems) + @($NewItemValue)
    SetEnvPath $new
    $psprovider.writeverbose("NewItem")
}

function RemoveItem {
    [cmdletbinding()]
    param([string]$path,[bool]$recurse)
    
    $new = GetEnvPathItems | ? { $_ -ne $path }
    SetEnvPath($new)
}

function RenameItem {
    [cmdletbinding()] param([string]$path, [string]$newName)

}


function GetEnvPathItems()
{
    $p = $Env:Path
    if ($p)
    {
        $p.Split(";")
    }
    else
    {
        @()
    }
}

function SetEnvPath([string[]]$items)
{
    if ($items)
    {
        $Env:Path = [string]::Join(";", ( $items | Get-Unique ) )  
    }
    else
    {
        $Env:Path="";
    } 
}


});

