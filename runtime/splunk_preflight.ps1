$baseUrl = 'https://localhost:8089'
$tokenLine = Get-Content ../.env | Where-Object { $_ -match '^SPLUNK_ACCESS_TOKEN=' } | Select-Object -First 1
if (-not $tokenLine) { throw 'SPLUNK_ACCESS_TOKEN fehlt in .env.' }
$env:SPLUNK_ACCESS_TOKEN = ($tokenLine -replace '^SPLUNK_ACCESS_TOKEN=', '').Trim()
if (-not $env:SPLUNK_ACCESS_TOKEN) { throw 'SPLUNK_ACCESS_TOKEN ist leer.' }
$authHeader = "Authorization: Bearer $($env:SPLUNK_ACCESS_TOKEN)"

Write-Output "Checking Token Auth Status..."
$statusCheck = curl.exe -k -sS -H $authHeader "$baseUrl/services/admin/token-auth/tokens_auth?output_mode=json"
Write-Output $statusCheck

Write-Output "Checking Token Validation..."
$httpStatus = curl.exe -k -sS -o NUL -w '%{http_code}' -H $authHeader "$baseUrl/services/server/info?output_mode=json"
Write-Output "HTTP Status: $httpStatus"

Write-Output "Checking App Status..."
$appStatus = curl.exe -k -sS -w "`nHTTP %{http_code}" -H $authHeader "$baseUrl/services/apps/local/Splunk_MCP_Server?output_mode=json"
Write-Output $appStatus
