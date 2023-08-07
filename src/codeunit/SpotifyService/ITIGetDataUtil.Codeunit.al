codeunit 50104 "ITI Get Data Util"
{
    trigger OnRun()
    begin

    end;

    procedure GetUserPlaylistsJsonArray(var JsonArray: JsonArray)
    var
        ITIHttp: Codeunit "ITI Http";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestContentString: Text;
        RequestMethod: Text;
        RequestURI: Text;
        JsonObj: JsonObject;
        JsonString: Text;
        ItemsJsonToken: JsonToken;
    begin
        RequestMethod := 'GET';
        RequestURI := 'https://api.spotify.com/v1/users/31rkjqx2c7vxjbyjhtyefxs4232q/playlists';
        ITIHttp.PrepareAndSendRequest(HttpRequestMessage, HttpClient, HttpResponseMessage, RequestMethod, RequestURI, RequestContentString);
        HttpResponseMessage.Content.ReadAs(JsonString);
        JsonObj.ReadFrom(JsonString);
        JsonObj.Get('items', ItemsJsonToken);
        JsonArray := ItemsJsonToken.AsArray();
    end;

    procedure GetPictureFromUrl(PictureUrl: Text) InStream: InStream
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
    begin
        HttpClient.Get(PictureUrl, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(InStream);
    end;


}