$taskTimeOnly = [System.TimeOnly]::MaxValue
$taskDateOnly = [System.DateOnly]::new(2022, 10, 24)
$taskDateTimeOffset = [System.DateTimeOffset]::new($taskDateOnly.ToDateTime($taskTimeOnly), [System.TimeSpan]::FromHours(2))
$taskRecord = [ordered]@{
  source = 'actual-dotnet-TimeOnly.MaxValue'
  value = $taskDateTimeOffset.ToString('O', [System.Globalization.CultureInfo]::InvariantCulture)
  expected = '2022-10-24T21:59:59.999Z'
  producer = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
  powershellVersion = $PSVersionTable.PSVersion.ToString()
}
$taskRecord | ConvertTo-Json -Compress | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'actual-dotnet-record.jsonl') -Encoding utf8
$taskRecord | ConvertTo-Json -Compress
