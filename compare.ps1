# compare.ps1 - script for doing diffs on ID number lists

# Written and tested on a Windows XP Professional SP3 host running Powershell 2.0.
# Written by Chang-Yi Yen <changyiyen@gmail.com>
# Initial version written in early November 2017.

## I wrote this script as part of my work at the Kaohsiung City Government Social Bureau
## managing applications for senior citizen transit cards. Every month or so lists containing
## ID numbers of applicants need to be compiled and compared against lists containing ID
## numbers of senior citizens who have deceased or had their registered place of residence
## changed to another city. I wrote this script using Powershell partly as a learning experience
## and partly because I wasn't allowed to install additional software on the office computer.
## This task is probably better done using the standard Unix tools (e.g. sort, uniq, diff).

cd 桌面
# Get ID numbers from exported Excel file ("a.txt")
Get-Content .\a.txt | Select-String -AllMatches -Pattern "[A-Z][0-9]{9}[^0-9]" | foreach {$_.matches} | select -ExpandProperty Value | %{$_ -replace ",",""} | %{$_ -replace " ",""} > b.txt
cat b.txt | sort | Get-Unique > c.txt
# Search for matches using regex engine
Get-Content .\c.txt | Select-String -Pattern (Get-Content .\regex.txt) | foreach {$_.matches} | select -ExpandProperty Value > d.txt
# Search for matches using string comparison; this seems to be slower than using regexes for some reason
#$a = Get-Content .\a.txt; $b = Get-Content .\b.txt;
#$arr = New-Object System.Collections.ArrayList
#foreach ($i in $a) {
#  foreach ($j in $b) {
#    if ($i -eq $j)
#    {
#      $arr.Add($i)
#    }
#  }
#}
#Write-Output $arr >> c.txt
