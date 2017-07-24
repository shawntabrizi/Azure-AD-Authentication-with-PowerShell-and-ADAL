# Azure-AD-Authentication-with-PowerShell-and-ADAL
This is a set of really simple PowerShell scripts which allow you to get access tokens with with Azure Active Directory using ADAL. Whereas other samples may require you to write many lines of code, compile, and possibly even publish your web application, these PowerShell scripts can use as little as 13 lines of code to authenticate and make a call to the AAD Graph API.

Read more about it here: http://shawntabrizi.com/aad/azure-ad-authentication-with-powershell-and-adal/

# Overview
I have found in the past that just being able to do really basic things with Azure Active Directory or the AAD Graph API is unnessecarily complicated. I just want to get a token and start making direct REST API calls. Fortunately, you can use .NET assemblies in PowerShell, so we can really easily hook up ADAL to get a token, and then use "Invoke-RestMethod" to then call downstream APIs.

I provide samples on how to do this using a number of different authentication flows:
1. Authorization Code Grant Flow for Confidential Client
2. Native Client Authentication
3. Client Credential Flow
    1. Using Application Key
    2. Using Client Certificate
     
These samples output the Access Token that was generated through authenticatoin which allows you to really easily check or verify the claims you recieve using JWT decoder like the one [here](https://github.com/shawntabrizi/JWT-Decoder-Javascript). Furthermore, you can start using these samples like POSTMan or other simple REST API callers to make quick and easy queries to AAD protected APIs.

# Prerequisites
Note that you will need to download the .NET dlls for ADAL v2 in order to get these scripts to work.
You can find those files on the [Nuget website for ADAL](https://www.nuget.org/packages/Microsoft.IdentityModel.Clients.ActiveDirectory/2.28.4).

Download the .nukpg file and unpack it with any file extrator.
Take the contents from \lib\net45\ and copy them into the ADAL folder. There should be 3 files total:
1. Microsoft.IdentityModel.Clients.ActiveDirectory.dll
2. Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll
3. Microsoft.IdentityModel.Clients.ActiveDirectory.XML

That's it!
