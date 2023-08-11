/// <summary>
/// Codeunit 50102 "ITI Http"
/// This codeunit provides functions to prepare and send HTTP requests using the provided parameters.
/// </summary>
codeunit 50102 "ITI Http"
{
    /// <summary>
    /// Sends an HTTP request using an instance of the HttpClient class and captures the corresponding response.
    /// </summary>
    procedure Send()
    var
        HttpClient: HttpClient;
    begin
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
    end;

    /// <summary>
    /// Checks whether the HTTP response indicates a successful status code.
    /// </summary>
    /// <returns>True if the HTTP response indicates success; otherwise, false.</returns>
    procedure GetIsSuccessStatusCode(): Boolean
    begin
        exit(HttpResponseMessage.IsSuccessStatusCode())
    end;

    /// <summary>
    /// Retrieves the reason phrase associated with the HTTP response.
    /// </summary>
    /// <returns>The reason phrase of the HTTP response.</returns>
    procedure GetReasonPhrase(): Text
    begin
        exit(HttpResponseMessage.ReasonPhrase)
    end;

    /// <summary>
    /// Retrieves the HttpResponseMessage associated with an HTTP response.
    /// </summary>
    /// <returns>The HttpResponseMessage object representing the HTTP response.</returns>
    procedure GetResponseMessage(): HttpResponseMessage
    begin
        exit(HttpResponseMessage)
    end;

    /// <summary>
    /// Sets the HTTP request method for the HttpRequestMessage.
    /// </summary>
    /// <param name="RequestMethod">The desired HTTP request method (e.g., GET, POST, PUT).</param>
    procedure SetMethod(RequestMethod: Text)
    begin
        HttpRequestMessage.Method(RequestMethod);
    end;

    /// <summary>
    /// Sets the request URI (Uniform Resource Identifier) for the HttpRequestMessage.
    /// </summary>
    /// <param name="RequestURI">The URI to set for the HTTP request.</param>
    procedure SetRequestURI(RequestURI: Text)
    begin
        HttpRequestMessage.SetRequestUri(RequestURI);
    end;

    /// <summary>
    /// Sets the HTTP request content for the HttpRequestMessage.
    /// </summary>
    /// <param name="RequestContent">The content to be set as the HTTP request body.</param>
    procedure SetRequestContent(RequestContent: Text)
    var
        HttpContent: HttpContent;
    begin
        HttpContent := HttpRequestMessage.Content();
        HttpContent.WriteFrom(RequestContent);
        HttpRequestMessage.Content(HttpContent);
    end;

    /// <summary>
    /// Sets a specific header for the HTTP request content of the HttpRequestMessage.
    /// </summary>
    /// <param name="ContentHeaderName">The name of the header to set.</param>
    /// <param name="ContentHeaderValue">The value to assign to the header.</param>
    procedure SetRequestContentHeaders(ContentHeaderName: Text; ContentHeaderValue: Text)
    var
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
    begin

        HttpContent := HttpRequestMessage.Content();
        HttpContent.GetHeaders(HttpHeaders);
        AddHeader(HttpHeaders, ContentHeaderName, ContentHeaderValue);

        HttpRequestMessage.Content(HttpContent);
    end;

    /// <summary>
    /// Sets an authorization header for the HTTP request of the HttpRequestMessage.
    /// </summary>
    /// <param name="AuthorizationHeaderName">The name of the authorization header.</param>
    /// <param name="AuthorizationHeaderValue">The value of the authorization header.</param>
    procedure SetAuthorization(AuthorizationHeaderName: Text; AuthorizationHeaderValue: Text)
    var
        HttpHeaders: HttpHeaders;
    begin
        HttpRequestMessage.GetHeaders(HttpHeaders);
        AddHeader(HttpHeaders, AuthorizationHeaderName, AuthorizationHeaderValue);
    end;

    local procedure AddHeader(var HttpHeaders: HttpHeaders; HeaderName: Text; HeaderValue: Text)
    begin
        if HttpHeaders.Contains(HeaderName) then
            HttpHeaders.Remove(HeaderName);
        HttpHeaders.Add(HeaderName, HeaderValue);
    end;

    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
}