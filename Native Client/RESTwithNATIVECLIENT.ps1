# Load ADAL
Add-Type -Path "..\ADAL\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"

# Output Token and Response from AAD Graph API
$accessToken = ".\Token.txt"
$output = ".\Output.json"

# Application and Tenant Configuration
$clientId = "<AppIDGUID>"
$tenantId = "<TenantID>"
$resourceId = "https://graph.windows.net"
$redirectUri = New-Object system.uri("<ReplyURL>")
$login = "https://login.microsoftonline.com"

#ADAL Prompt Behavior Configuration (Always, Auto, Never)
$promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto

# Get an Access Token with ADAL
$authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext ("{0}/{1}" -f $login,$tenantId)
$authenticationResult = $authContext.AcquireToken($resourceId, $clientID, $redirectUri, $promptBehavior) 
($token = $authenticationResult.AccessToken) | Out-File $accessToken

# Call the AAD Graph API
$headers = @{ 
    "Authorization" = ("Bearer {0}" -f $token);
    "Content-Type" = "application/json";
}

# Output response as a JSON file
Invoke-RestMethod -Method Get -Uri ("{0}/{1}/users?api-version=1.6" -f $resourceId, $tenantId) -Headers $headers -OutFile $output
