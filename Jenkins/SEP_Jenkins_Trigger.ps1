### This script is used to call Jenkins for build on Checkin ###############

# Changeset to be built should be the first argument to this script
[string]$changeset = $args[0]

# Branch to be built should be the second argument to this script
[string]$branch = $args[1]

# remove character passed by tfs
if ($changeset -match '^[a-zA-Z]+(?<number>\d+)')
{
    $changeset = $Matches.number
}

### CALL JENKINS ###########################################################
# Jenkins URI
$URI = "https://xsa-sandbox.jaas.cos.is.keysight.com/job/CITS/job/SEP_Pipeline/buildWithParameters?changeset=$changeset"
# credentials to communicate with Jenkins Encoded with: [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("user:token"))
$encodedCreds="anVsY2FzdHI6MTExMTYxZWFjYTExMTMzNTUwYzQwZDBkNTRkYjE4YTYzYg=="
# call Jenkins
Invoke-WebRequest -URI $URI -Method POST -Headers @{ Authorization = "Basic $encodedCreds"}

return 0