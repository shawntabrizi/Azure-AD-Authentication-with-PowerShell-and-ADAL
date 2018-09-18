# This module acts as a "fake" endpoint for catching the authorization code that comes back with the Reply URL
# We 'control' the browser used for login, thus we can sniff the URL at the end of authentication, and parse the CODE
# We can detect the end of the login process because we compare the URL to the Reply URL used for authentication

Add-Type -AssemblyName System.Web
$outputAuth = ".\Code.txt"
$outputError = ".\Error.txt"

function Add-NativeHelperType
{
    $nativeHelperTypeDefinition =
    @"
    using System;
    using System.Runtime.InteropServices;

    public static class NativeHelper
        {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        public static bool SetForeground(IntPtr windowHandle)
        {
           return NativeHelper.SetForegroundWindow(windowHandle);
        }

    }
"@
    if(-not ([System.Management.Automation.PSTypeName] "NativeHelper").Type)
    {
        Add-Type -TypeDefinition $nativeHelperTypeDefinition
    }
}

function LoginBrowser
{
    param
    (
        [Parameter(HelpMessage='Authorization URL')]
        [ValidateNotNull()]
        [string]$authorizationUrl,
        
        [Parameter(HelpMessage='Redirect URI')]
        [ValidateNotNull()]
        [uri]$redirectUri
    )

    Add-NativeHelperType
    # Create an Internet Explorer Window for the Login Experience
    $ie = New-Object -ComObject InternetExplorer.Application
    $ie.Width = 600
    $ie.Height = 500
    $ie.AddressBar = $false
    $ie.ToolBar = $false
    $ie.StatusBar = $false
    $ie.visible = $true
    $ie.navigate($authorizationUrl)
    $handle = $ie.HWND
    $winForeground = [NativeHelper]::SetForeground($handle)
    # Grab the window
    $wind = (New-Object -ComObject Shell.Application).Windows() | Where-Object { $_.HWND -eq $handle }
    $sleepCounter = 0

    while ($ie.Busy)
    {
        Start-Sleep -Milliseconds 50
        $sleepCounter++

        if ($sleepCounter -eq 100)
        {
            throw "Unable to connect to $authorizationUrl, timed out waiting for page."
        }
    }

    try
    {
        while($true)
        {
            $urls = @()
            $urls += $wind.LocationUrl | Where-Object { $_ -and $_ -match "(^https?://.+)|(^ftp://)" }
            if (-not $urls) 
            {
                # "No urls found, refreshing window"
                $wind = (New-Object -ComObject Shell.Application).Windows() | Where-Object { $_.HWND -eq $handle }
                if (-not $wind)
                {
                    throw "Could not find IE window with handle: $handle"
                }
            }
            
            foreach ($url in $urls)
            {
                if (($url).StartsWith($RedirectUri.ToString()+"?code="))
                {
                    ($code = $url -replace (".*code=") -replace ("&.*"))  | Out-File $outputAuth
                    return $code
                }
                elseif (($url).StartsWith($RedirectUri.ToString()+"?error="))
                {
                    $error = [System.Web.HttpUtility]::UrlDecode(($a.LocationUrl) -replace (".*error="))
                    $error | Out-File $outputError
                    return
                }
            }
        }
    }
    finally
    {
        if (-not $wind)
        {
            $wind = (New-Object -ComObject Shell.Application).Windows() | Where-Object { $_.HWND -eq $handle }
        }
        
        if ($wind)
        {
            $wind.Quit()
        }
    }
}

