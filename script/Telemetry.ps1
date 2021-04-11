Param(
    [Parameter(Mandatory = $true)][string] $InstrumentationKey,
    [bool] $isFail = $false
)

$name = "$($env:AGENT_JOBNAME)"
$started = [datetime]::Parse($($env:STARTTIME))
$duration = ([System.DateTimeOffset]::UctNow - $started)
$client = New-Object -TypeName Microsoft.ApplicationInsights.TelemetryClient
$client.InstrumentationKey = $InstrumentationKey
$client.Context.Session.Id = "$($env:SYSTEM_TEAMPROJECT)/$($env:BUILD_BUILDID)"
$client.Context.User.Id = "$($env:AGENT_ID)"
$client.Context.Operation.Id = $name
$client.Context.Operation.Name = $name

$request = New-Object -TypeName Microsoft.ApplicationInsights.DataContracts.RequestTelemetry
$request.Name = $name
$request.StartTime = $started
$request.Duration = $duration

if($isFail){
    $request.Success = $false
    $request.ResponseCode = 400
}
else{
    $request.Success = $true
}

$client.TrackRequest($request)
$client.Flush()