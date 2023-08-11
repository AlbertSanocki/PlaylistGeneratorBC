/// <summary>
/// Codeunit 50101 "ITI Access Token"
/// This codeunit handles access tokens for Spotify API and provides functions for token retrieval and refresh.
/// </summary>
codeunit 50101 "ITI Access Token"
{
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
        if not IsolatedStorage.Contains(ITITextConstants.AccessToken()) then
            exit;

        if not IsolatedStorage.Get(ITITextConstants.ExpiresIn(), ExpiresDateTimeValue) then
            exit;

        if not Evaluate(ExpiresDateTime, ExpiresDateTimeValue) then
            exit;

        if CurrentDateTime() > ExpiresDateTime then
            exit;

        exit(true)
    end;

    local procedure RefreshToken()
    var
        ITIHttp: Codeunit "ITI Http";
        HttpResponseMessage: HttpResponseMessage;
        HttpResponseMessageText: Text;
    begin
        ITIHttp.SetMethod(ITITextConstants.HttpPOST());
        ITIHttp.SetRequestURI('https://accounts.spotify.com/api/token');
        ITIHttp.SetRequestContent(ITITextConstants.XWWWFormUrlEncodedGrantTypeData());
        ITIHttp.SetRequestContentHeaders(ITITextConstants.ContentType(), ITITextConstants.XWWWFormUrlEncoded());
        ITIHttp.SetAuthorization(ITITextConstants.Authorization(), GetAuthorizationHeaderValue());
        ITIHttp.Send();
        if not ITIHttp.GetIsSuccessStatusCode() then
            Error(HttpResponseMessage.ReasonPhrase())
        else begin
            ITIHttp.GetResponseMessage().Content.ReadAs(HttpResponseMessageText);
            SetNewToken(HttpResponseMessageText);
            SetNewTokenExpirationTime(HttpResponseMessageText);
        end;

    end;

    local procedure SetNewToken(ResponseMessageText: Text)
    var
        JsonObj: JsonObject;
        AccessTokenJsonKey: Text;
        AccessTokenJson: JsonToken;
        AccessTokenText: Text;


    begin
        AccessTokenJsonKey := ITITextConstants.AccessToken();
        JsonObj.ReadFrom(ResponseMessageText);
        JsonObj.Get(AccessTokenJsonKey, AccessTokenJson);
        AccessTokenText := AccessTokenJson.AsValue().AsText();
        IsolatedStorage.Set(AccessTokenJsonKey, AccessTokenText);
    end;

    local procedure SetNewTokenExpirationTime(ResponseMessageText: Text)
    var
        JsonObj: JsonObject;
        ExpiresinJsonKey: Text;
        ExpiresInJson: JsonToken;
        ExpiresInInteger: Integer;
    begin
        ExpiresinJsonKey := ITITextConstants.ExpiresIn();
        JsonObj.ReadFrom(ResponseMessageText);
        JsonObj.Get(ExpiresinJsonKey, ExpiresInJson);
        ExpiresInInteger := ExpiresInJson.AsValue().AsInteger();
        IsolatedStorage.Set(ExpiresinJsonKey, Format(CurrentDateTime() + ExpiresInInteger * 1000));
    end;

    local procedure GetAuthorizationHeaderValue() AuthorizationHeaderValue: Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        ClientID: Text[50];
        ClientSecret: Text[50];
    begin
        ClientID := ITITextConstants.ClientID();
        ClientSecret := ITITextConstants.ClientSecret();
        AuthorizationHeaderValue := ITITextConstants.Basic() + Base64Convert.ToBase64(ClientID + ':' + ClientSecret)
    end;

    var
        ITITextConstants: Codeunit "ITI Text Constants";
}