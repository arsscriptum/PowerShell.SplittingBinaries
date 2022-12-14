
<#
#ฬท๐   ๐๐ก๐ข ๐ข๐๐ก๐๐๐ฃ๐ค๐
#ฬท๐   ๐ตโโโโโ๐ดโโโโโ๐ผโโโโโ๐ชโโโโโ๐ทโโโโโ๐ธโโโโโ๐ญโโโโโ๐ชโโโโโ๐ฑโโโโโ๐ฑโโโโโ ๐ธโโโโโ๐จโโโโโ๐ทโโโโโ๐ฎโโโโโ๐ตโโโโโ๐นโโโโโ ๐งโโโโโ๐พโโโโโ ๐ฌโโโโโ๐บโโโโโ๐ฎโโโโโ๐ฑโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐บโโโโโ๐ฒโโโโโ๐ชโโโโโ๐ตโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐ณโโโโโ๐นโโโโโ๐ชโโโโโ.๐ถโโโโโ๐จโโโโโ@๐ฌโโโโโ๐ฒโโโโโ๐ฆโโโโโ๐ฎโโโโโ๐ฑโโโโโ.๐จโโโโโ๐ดโโโโโ๐ฒโโโโโ
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)] 
    [Alias('d')]
    [switch]$Divide,
    [Parameter(Mandatory = $false)] 
    [Alias('c')]
    [switch]$Combine,
    [Parameter(Mandatory = $false)] 
    [Alias('t')]
    [switch]$Test
)


try{
    function Get-Script([string]$prop){
        $ThisFile = $script:MyInvocation.MyCommand.Path
        return ((Get-Item $ThisFile)|select $prop).$prop
    }

    $MakeScriptPath = split-path $script:MyInvocation.MyCommand.Path
    $ScriptFullName =(Get-Item -Path $script:MyInvocation.MyCommand.Path).FullName
    $ScriptsPath = Join-Path $MakeScriptPath 'scripts'
    $PackagePath = Join-Path $MakeScriptPath 'package'
    $DataPath = Join-Path $MakeScriptPath 'data'
    $FileUtilsScriptPath = Join-Path $ScriptsPath 'FileUtils.ps1'
    $DataFilePath = Join-Path $PackagePath 'File.pdf'
    $CombinedDataFilePath = Join-Path $PackagePath 'Recombined-File.pdf'
    $SizeDataFile = Join-Path $DataPath 'Size.dat'
    . "$FileUtilsScriptPath"
    #===============================================================================
    # Root Path
    #===============================================================================
    $Global:ConsoleOutEnabled              = $true
    $Global:CurrentRunningScript           = Get-Script basename
    $Script:CurrPath                       = $MakeScriptPath
    $Script:RootPath                       = (Get-Location).Path
    If( $PSBoundParameters.ContainsKey('Path') -eq $True ){
        $Script:RootPath = $Path
    }
 
    #===============================================================================
    # Script Variables
    #===============================================================================
    $Global:CurrentRunningScript           = Get-Script basename
    $Script:Time                           = Get-Date
    $Script:Date                           = $Time.GetDateTimeFormats()[13]

   
    Write-Host "RUN" -f DarkRed
   
    if($Combine){
        [int]$FileLength = Get-Content $SizeDataFile 
        CombineSplitFiles -Path $DataPath -OutFilePath $CombinedDataFilePath -TotalSize $FileLength 

        $Hash = (Get-FileHash $CombinedDataFilePath -Algorithm SHA1).Hash
        Write-Host "ReCombined Data File Hash $Hash" -f DarkRed
    } 
    elseif($Divide){
        if(-not (Test-Path -Path "$DataFilePath")){ throw "Cannot DIvide: no file $DataFilePath" }
        $FileLength = (gi -Path "$DataFilePath").Length
        $Newsize = 5MB
        
        SplitDataFile -Path $DataFilePath -Newsize 10kb -OutPath $DataPath -AsString 
        Set-Content $SizeDataFile -Value $FileLength
        $Hash = (Get-FileHash $DataFilePath -Algorithm SHA1).Hash

        Write-Host "Data File Hash $Hash" -f DarkRed
    }
    

}catch{
    Write-Error $_
}