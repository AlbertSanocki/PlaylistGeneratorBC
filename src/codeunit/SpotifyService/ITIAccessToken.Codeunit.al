/// <summary>
/// Codeunit 50101 "ITI Access Token"
/// This codeunit handles access tokens for Spotify API and provides functions for token retrieval and refresh.
/// </summary>
codeunit 50101 "ITI Access Token"
{
    trigger OnRun()
    begin
        GetToken();
    end;

    /// <summary>
    /// Checks if the token is valid. Otherwise, refreshes the token.
    /// </summary>
    procedure GetToken()
    begin
        if IsTokenValid() then
            exit;

        RefreshToken();
    end;

    local procedure IsTokenValid(): Boolean
    var
        ExpiresDateTimeValue: Text;
        ExpiresDateTime: DateTime;
    begin
        if not IsolatedStorage.Contains('access_token') then
            exit;

        if not IsolatedStorage.Get('expires_in', ExpiresDateTimeValue) then
            exit;

        if not Evaluate(ExpiresDateTime, ExpiresDateTimeValue) then
            exit;

        if CurrentDateTime() > ExpiresDateTime then
            exit;

        exit(true)
    end;

    local procedure RefreshToken()
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpResponseMessageText: Text;
    begin
        PrepareRequest(HttpRequestMessage);

        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode() then
            Message(HttpResponseMessage.ReasonPhrase())
        else begin
            HttpResponseMessage.Content.ReadAs(HttpResponseMessageText);
            SetNewToken(HttpResponseMessageText);
        end;

    end;

    local procedure SetNewToken(ResponseMessageText: Text)
    var
        JsonObj: JsonObject;

        AccessTokenJsonKey: Text;
        AccessTokenJson: JsonToken;
        AccessTokenText: Text;

        ExpiresinJsonKey: Text;
        ExpiresInJson: JsonToken;
        ExpiresInInteger: Integer;
    begin
        AccessTokenJsonKey := 'access_token';
        ExpiresinJsonKey := 'expires_in';

        JsonObj.ReadFrom(ResponseMessageText);
        JsonObj.Get(AccessTokenJsonKey, AccessTokenJson);
        AccessTokenText := AccessTokenJson.AsValue().AsText();

        JsonObj.ReadFrom(ResponseMessageText);
        JsonObj.Get(ExpiresinJsonKey, ExpiresInJson);
        ExpiresInInteger := ExpiresInJson.AsValue().AsInteger();

        IsolatedStorage.Set(AccessTokenJsonKey, AccessTokenText);
        IsolatedStorage.Set(ExpiresinJsonKey, Format(CurrentDateTime() + ExpiresInInteger * 1000));
    end;

    local procedure PrepareRequest(var HttpRequestMessage: HttpRequestMessage)
    begin
        SetMethod(HttpRequestMessage);
        SetRequestURI(HttpRequestMessage);
        SetRequestContent(HttpRequestMessage);
        SetRequestContentHeaders(HttpRequestMessage);
        SetAuthorization(HttpRequestMessage);
    end;

    local procedure SetMethod(var HttpRequestMessage: HttpRequestMessage)
    begin
        HttpRequestMessage.Method(ITITextConstants.HttpPOST());
    end;

    local procedure SetRequestURI(var HttpRequestMessage: HttpRequestMessage)
    begin
        HttpRequestMessage.SetRequestUri('https://accounts.spotify.com/api/token');
    end;

    local procedure SetRequestContent(var HttpRequestMessage: HttpRequestMessage)
    var
        HttpContent: HttpContent;
    begin
        HttpContent := HttpRequestMessage.Content();
        HttpContent.WriteFrom('grant_type=refresh_token&refresh_token=AQAmPlkt6z5d5pnaHWopR7Nj5ZrvUfiML5_CwC3w2W6qpihy1jZk2P-m0mIoDFkKgQOt2a6cjA58vSpJcShlSRppiXGmSle2LybcnZwyfzkzlHf6RcE3dY0NDq3kanrNENU');
        HttpRequestMessage.Content(HttpContent);
    end;

    local procedure SetRequestContentHeaders(var HttpRequestMessage: HttpRequestMessage)
    var
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
    begin
        HttpContent := HttpRequestMessage.Content();
        HttpContent.GetHeaders(HttpHeaders);
        AddHeader(HttpHeaders, 'Content-Type', 'application/x-www-form-urlencoded');
        HttpRequestMessage.Content(HttpContent);
    end;

    local procedure SetAuthorization(var HttpRequestMessage: HttpRequestMessage)
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpHeaders: HttpHeaders;
        ClientID: Text[50];
        ClientSecret: Text[50];
    begin
        ClientID := '92615a6a4f4c4db988154105b51d7d18';
        ClientSecret := '035d690d55e247dc9e1a2c3dea6a8730';
        HttpRequestMessage.GetHeaders(HttpHeaders);
        AddHeader(HttpHeaders, 'Authorization', 'Basic ' + Base64Convert.ToBase64(ClientID + ':' + ClientSecret))
    end;

    local procedure AddHeader(var HttpHeaders: HttpHeaders; HeaderName: Text; HeaderValue: Text)
    begin
        if HttpHeaders.Contains(HeaderName) then
            HttpHeaders.Remove(HeaderName);
        HttpHeaders.Add(HeaderName, HeaderValue);
    end;

    var
        ITITextConstants: Codeunit "ITI Text Constants";
}