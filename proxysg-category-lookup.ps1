# wget powershell for retrieving Blue Coat ProxySG categorization
# uses the advanced URL https://<IP>:8082/ContentFilter/TestURL/
# Author: ebeahan
# Date 7-11-2014

# Disable SSL certificate validation
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

# Initialize variables
# Input CSV file
$source = ""
# Target ProxySG hostname/IP to perform lookups against
# Replace <IP> with the hostname or IP address of the proxy
$targetURL = "https://<IP>:8082/ContentFilter/TestURL/"
# Define WebClient resource
$webClient = new-object System.Net.WebClient
# Gather Credentials to authenticate against proxy
$webClient.Credentials = Get-Credential

# Import the source CSV

$inputCSV = Import $source
$outputCSV = ".\output.csv"

# Adds new column in CSV file to hold the resulting URL category
$inputCSV | Add-Member -MemberType NoteProperty -Name "Category" -Value $null

ForEach ($line in $inputCsv) {
	$value = $targetURL + $line.URL
	$line.Category = $webClient.DownloadString("$value")
	# Writes resulting output to STDOUT for troubleshooting
	Write-Host $line
}

$inputCSV | Export-Csv $outputCSV -noType
