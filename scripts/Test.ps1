
<#
#ฬท๐   ๐๐ก๐ข ๐ข๐๐ก๐๐๐ฃ๐ค๐
#ฬท๐   ๐ตโโโโโ๐ดโโโโโ๐ผโโโโโ๐ชโโโโโ๐ทโโโโโ๐ธโโโโโ๐ญโโโโโ๐ชโโโโโ๐ฑโโโโโ๐ฑโโโโโ ๐ธโโโโโ๐จโโโโโ๐ทโโโโโ๐ฎโโโโโ๐ตโโโโโ๐นโโโโโ ๐งโโโโโ๐พโโโโโ ๐ฌโโโโโ๐บโโโโโ๐ฎโโโโโ๐ฑโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐บโโโโโ๐ฒโโโโโ๐ชโโโโโ๐ตโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐ณโโโโโ๐นโโโโโ๐ชโโโโโ.๐ถโโโโโ๐จโโโโโ@๐ฌโโโโโ๐ฒโโโโโ๐ฆโโโโโ๐ฎโโโโโ๐ฑโโโโโ.๐จโโโโโ๐ดโโโโโ๐ฒโโโโโ
#>

[CmdletBinding(SupportsShouldProcess)]
param()

try{
        [string]$CheckSum1 = ''
        [string]$CheckSum2 = ''
        [byte[]] $inArray = [byte[]]::new(256)
        for ($x = 0; $x -lt $inArray.Length; $x++)
        {
            $inArray[$x] = [byte]$x;
            $CheckSum1 += "{0:X2} " -f  $inArray[$x]

        }

        $s = [convert]::ToBase64String($inArray, 0, $inArray.Length)
        $NewFilePath = Join-Path "$ENV:TEMP" "test.txt"
  
        Write-Host " >>> Writing $NewFilePath" -f Red
        Set-Content $NewFilePath $s

        Write-Host " <<< READING $NewFilePath" -f Green
        $ReadBytes = get-content -LiteralPath $NewFilePath
        [byte[]] $outArray = [byte[]]::new(256)
        $outArray =[convert]::FromBase64String($ReadBytes);
        for ($x = 0; $x -lt $outArray.Length; $x++)
        {
            $CheckSum2 += "{0:X2} " -f  $outArray[$x]
        }

        Write-Host "VALIDATING CHECKSUM..." -n -f MAgenta
        if($CheckSum1 -eq $CheckSum2){
            Write-Host "SUCCESS" -f Green
        }else{
            Write-Host "FAILURE" -f Red
        }

        Remove-Item "$NewFilePath" -Force
    
}catch [Exception]{
    Write-Error $_
}