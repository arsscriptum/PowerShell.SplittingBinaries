
<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
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
    $DataPath = "F:\Development\Backup.Importants\CodeMeter_SDK"
    $FileUtilsScriptPath = Join-Path $ScriptsPath 'FileUtils.ps1'
    $DataFilePath = "E:\Data\CODEMETER_V2\CodeMeter-SDK\Windows\CodeMeterSDK64.exe"
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
        $Newsize = 35MB
        
        SplitDataFile -Path $DataFilePath -Newsize $Newsize -OutPath $DataPath -AsString 
        Set-Content $SizeDataFile -Value $FileLength
        $Hash = (Get-FileHash $DataFilePath -Algorithm SHA1).Hash

        Write-Host "Data File Hash $Hash" -f DarkRed
    }
    

}catch{
    Write-Error $_
}