# Azure-AD-Authentication-with-PowerShell-and-ADAL
This is a set of really simple PowerShell scripts which allow you to get access tokens with with Azure Active Directory using ADAL. Whereas other samples may require you to write many lines of code, compile, and possibly even publish your web application, these PowerShell scripts can use as little as 13 lines of code to authenticate and make a call to the AAD Graph API.

# Overview
I have found in the past that just being able to do really basic things with Azure Active Directory or the AAD Graph API is unnessecarily complicated. I just want to get a token and start making direct REST API calls. Fortunately, you can use .NET assemblies in PowerShell, so we can really easily hook up ADAL to get a token, and then use "Invoke-RestMethod" to then call downstream APIs.

I provide samples on how to do this using a number of different authentication flows:
  1) Authorization Code Grant Flow for Confidential Client
  2) Native Client Authentication
  3) Client Credential Flow
    a) Using Application Key
    b) Using Client Certificate
     
These samples output the Access Token that was generated through authenticatoin which allows you to really easily check or verify the claims you recieve using JWT decoder like the one [here](https://github.com/shawntabrizi/JWT-Decoder-Javascript). Furthermore, you can start using these samples like POSTMan or other simple REST API callers to make quick and easy queries to AAD protected APIs.
