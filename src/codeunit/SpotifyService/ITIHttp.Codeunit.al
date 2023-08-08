/// <summary>
/// Codeunit 50102 "ITI Http"
/// This codeunit provides functions to prepare and send HTTP requests using the provided parameters.
/// </summary>
codeunit 50102 "ITI Http"
{
    /// <summary>
    /// Prepares and sends an HTTP request using the provided parameters.
    /// </summary>
    /// <param name="HttpRequestMessage">The HTTP request message object.</param>
    /// <param name="HttpClient">The HTTP client object.</param>
    /// <param name="HttpResponseMessage">The HTTP response message object.</param>
    /// <param name="RequestMethod">The HTTP request method (GET, POST, etc.).</param>
    /// <param name="RequestURI">The URI of the request.</param>
    /// <param name="RequestContent">The content of the request.</param>
    procedure PrepareAndSendRequest(var HttpRequestMessage: HttpRequestMessage; var HttpClient: HttpClient; var HttpResponseMessage: HttpResponseMessage; RequestMethod: Text; RequestURI: Text; RequestContent: Text)
    var
        ITIAccessToken: Codeunit "ITI Access Token";
    begin
        ITIAccessToken.Run();
        SetMethod(HttpRequestMessage, RequestMethod);
        SetRequestURI(HttpRequestMessage, RequestURI);
        SetRequestContent(HttpRequestMessage, RequestContent);
        SetRequestContentHeaders(HttpRequestMessage);
        SetAuthorization(HttpRequestMessage);
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
    end;

    local procedure SetMethod(var HttpRequestMessage: HttpRequestMessage; RequestMethod: Text)
    begin
        HttpRequestMessage.Method(RequestMethod);
    end;

    local procedure SetRequestURI(var HttpRequestMessage: HttpRequestMessage; RequestURI: Text)
    begin
        HttpRequestMessage.SetRequestUri(RequestURI);
    end;

    local procedure SetRequestContent(var HttpRequestMessage: HttpRequestMessage; RequestContent: Text)
    var
        HttpContent: HttpContent;
    begin
        HttpContent := HttpRequestMessage.Content();
        HttpContent.WriteFrom(RequestContent);
        HttpRequestMessage.Content(HttpContent);
    end;

    local procedure SetRequestContentHeaders(var HttpRequestMessage: HttpRequestMessage)
    var
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
    begin

        HttpContent := HttpRequestMessage.Content();
        HttpContent.GetHeaders(HttpHeaders);
        AddHeader(HttpHeaders, 'Content-Type', 'application/json');

        HttpRequestMessage.Content(HttpContent);
    end;

    local procedure SetAuthorization(var HttpRequestMessage: HttpRequestMessage)
    var
        HttpHeaders: HttpHeaders;
        AccessToken: Text;
    begin
        IsolatedStorage.Get('access_token', AccessToken);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        AddHeader(HttpHeaders, 'Authorization', 'Bearer ' + AccessToken);
    end;

    local procedure AddHeader(var HttpHeaders: HttpHeaders; HeaderName: Text; HeaderValue: Text)
    begin
        if HttpHeaders.Contains(HeaderName) then
            HttpHeaders.Remove(HeaderName);
        HttpHeaders.Add(HeaderName, HeaderValue);
    end;
}