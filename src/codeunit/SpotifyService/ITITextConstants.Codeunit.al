/// <summary>
/// Codeunit 50103 "ITI Text Constants"
/// This codeunit contains functions to return various text constants.
/// </summary>
codeunit 50103 "ITI Text Constants"
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// Returns the ID as text.
    /// </summary>
    /// <returns>The ID as text.</returns>
    procedure ID(): Text
    begin
        exit('id')
    end;

    /// <summary>
    /// Returns the name as text.
    /// </summary>
    /// <returns>The name as text.</returns>
    procedure Name(): Text
    begin
        exit('name')
    end;

    /// <summary>
    /// Returns the description as text.
    /// </summary>
    /// <returns>The description as text.</returns>
    procedure Desc(): Text
    begin
        exit('description')
    end;

    /// <summary>
    /// Returns 'public' as text.
    /// </summary>
    /// <returns>'public' as text.</returns>
    procedure Public(): Text
    begin
        exit('public')
    end;

    /// <summary>
    /// Returns 'expires_in' as text.
    /// </summary>
    /// <returns>'expires_in' as text.</returns>
    procedure ExpiresIn(): Text
    begin
        exit('expires_in')
    end;

    /// <summary>
    /// Returns 'access_token' as text.
    /// </summary>
    /// <returns>'access_token' as text.</returns>
    procedure AccessToken(): Text
    begin
        exit('access_token')
    end;

    /// <summary>
    /// Returns 'Content-Type' as text.
    /// </summary>
    /// <returns>'Content-Type' as text.</returns>
    procedure ContentType(): Text
    begin
        exit('Content-Type')
    end;

    /// <summary>
    /// Returns 'application/x-www-form-urlencoded' as text.
    /// </summary>
    /// <returns>'application/x-www-form-urlencoded' as text.</returns>
    procedure XWWWFormUrlEncoded(): Text
    begin
        exit('application/x-www-form-urlencoded')
    end;

    /// <summary>
    /// Returns '92615a6a4f4c4db988154105b51d7d18' as text.
    /// </summary>
    /// <returns>'92615a6a4f4c4db988154105b51d7d18' as text.</returns>
    procedure ClientID(): Text[50]
    begin
        exit('92615a6a4f4c4db988154105b51d7d18')
    end;

    /// <summary>
    /// Returns '035d690d55e247dc9e1a2c3dea6a8730' as text.
    /// </summary>
    /// <returns>'035d690d55e247dc9e1a2c3dea6a8730' as text.</returns>
    procedure ClientSecret(): Text[50]
    begin
        exit('035d690d55e247dc9e1a2c3dea6a8730')
    end;

    /// <summary>
    /// Returns 'Authorization' as text.
    /// </summary>
    /// <returns>'Authorization' as text.</returns>
    procedure Authorization(): Text
    begin
        exit('Authorization')
    end;

    /// <summary>
    /// Returns 'Basic' as text.
    /// </summary>
    /// <returns>'Basic' as text.</returns>
    procedure Basic(): Text
    begin
        exit('Basic ')
    end;

    /// <summary>
    /// Returns 'Bearer ' as text.
    /// </summary>
    /// <returns>'Bearer ' as text.</returns>
    procedure Bearer(): Text
    begin
        exit('Bearer ')
    end;

    /// <summary>
    /// Returns 'application/json' as text.
    /// </summary>
    /// <returns>'application/json' as text.</returns>
    procedure AplicationJson(): Text
    begin
        exit('application/json')
    end;

    /// <summary>
    /// Returns 'uri' as text.
    /// </summary>
    /// <returns>'uri' as text.</returns>
    procedure URI(): Text
    begin
        exit('uri')
    end;

    /// <summary>
    /// Returns 'tracks' as text.
    /// </summary>
    /// <returns>'tracks' as text.</returns>
    procedure Tracks(): Text
    begin
        exit('tracks')
    end;

    /// <summary>
    /// Returns 'grant_type url encoded data' as text.
    /// </summary>
    /// <returns>'grant_type url encoded data' as text.</returns>
    procedure XWWWFormUrlEncodedGrantTypeData(): Text
    begin
        exit('grant_type=refresh_token&refresh_token=AQAmPlkt6z5d5pnaHWopR7Nj5ZrvUfiML5_CwC3w2W6qpihy1jZk2P-m0mIoDFkKgQOt2a6cjA58vSpJcShlSRppiXGmSle2LybcnZwyfzkzlHf6RcE3dY0NDq3kanrNENU')
    end;

    /// <summary>
    /// Returns the HTTP method 'GET' as text.
    /// </summary>
    /// <returns>The HTTP method 'GET' as text.</returns>
    procedure HttpGET(): Text
    begin
        exit('GET')
    end;

    /// <summary>
    /// Returns the HTTP method 'POST' as text.
    /// </summary>
    /// <returns>The HTTP method 'POST' as text.</returns>
    procedure HttpPOST(): Text
    begin
        exit('POST')
    end;
}