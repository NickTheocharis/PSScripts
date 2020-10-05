# Enter CSV file location
$csv = "C:\Temp\OUPing.csv"
# Add the target OU in the SearchBase parameter
$Computers = Get-ADComputer -Filter * -SearchBase "OU=Computers,DC=contoso,DC=com" | Select Name | Sort-Object Name
$Computers = $Computers.Name
$Headers = "ComputerName,IP Address"
$Headers | Out-File -FilePath $csv -Encoding UTF8
foreach ($computer in $Computers)
{
Write-host "Pinging $Computer"
$Test = Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue -ErrorVariable Err
if ($test -ne $null)
{
    $IP = $Test.IPV4Address.IPAddressToString
    $Output = "$Computer,$IP"
    $Output | Out-File -FilePath $csv -Encoding UTF8 -Append
}
Else
{
    $Output = "$Computer,$Err"
    $output | Out-File -FilePath $csv -Encoding UTF8 -Append
}
cls
}

# Make variable from specific cell . Save as the OUPing.csv σε OUPing.xls
$excel = Open-ExcelPackage -Path "C:\Temp\OUPing.xlsx"
$worksheet = $excel.Workbook.Worksheets['Sheet1']
$loc=$worksheet.Cells['A1'].Value

