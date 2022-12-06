

# SPLITTING BINARIES


## WHY

I wanted to archive a big ZIP file on Github. But as you can imagine, github prevents the usage of repositories to archive sizeable binaries like movies, audio files, zip files, etc...

## Concept

I created a script that changes a given binary file so that it is split in files on a maximum size and with the content being text, that is, converted to Base64. 

***Example***

A movie file named **Titanic.mp4 (400Mb)** will be converted to **400 text files** names *Titanic001.cpp ... Titanic400.cpp* which can then be commited in Github. 

---------------------------------------------------------------------------------------------------------

## Run Example

The example code will ***split the PDF file File.pdf in segments of 10Kb***


```SplitDataFile -Path $DataFilePath -Newsize 10kb -OutPath $DataPath -AsString ```



### Splitting

```
    .\run.ps1 -Divide
```

### Re-Combining


```
    .\run.ps1 -Combine
```


---------------------------------------------------------------------------------------------------------

Demo

![DEMO](https://raw.githubusercontent.com/arsscriptum/PowerShell.SplittingBinaries/master/doc/demo.gif)