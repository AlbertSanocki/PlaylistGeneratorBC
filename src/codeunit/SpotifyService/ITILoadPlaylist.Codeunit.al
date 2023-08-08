/// <summary>
/// Codeunit 50106 "ITI Load Playlist"
/// This codeunit handles loading Spotify playlists from the user's account and creating records for them in the "ITI Spotify Playlist" table.
/// </summary>
codeunit 50106 "ITI Load Playlist"
{
    trigger OnRun()
    begin

    end;
    /// <summary>
    /// Loads playlists from the user's Spotify account and creates corresponding records in the "ITI Spotify Playlist" table.
    /// </summary>
    procedure LoadPlaylistsFromAccount()
    var
        ITISpotfyPlaylist: Record "ITI Spotfy Playlist";
        JsonArray: JsonArray;
        PlaylistJsonToken: JsonToken;
    begin
        ITISpotfyPlaylist.DeleteAll(true);
        GetUserPlaylistsJsonArray(JsonArray);
        foreach PlaylistJsonToken in JsonArray do
            CreateUserPlaylistRecord(PlaylistJsonToken);
    end;

    local procedure CreateUserPlaylistRecord(var PlaylistJsonToken: JsonToken)
    var
        ITISpotfyPlaylist: Record "ITI Spotfy Playlist";
        PlaylistIDText: Text[50];
        PlaylistNameText: Text[50];
        PlaylistImageURLText: Text[1000];
    begin
        ExtractDataFromJsonObjToText(PlaylistJsonToken, PlaylistIDText, PlaylistNameText, PlaylistImageURLText);
        Clear(ITISpotfyPlaylist);
        ITISpotfyPlaylist.Init();
        ITISpotfyPlaylist.Validate("Playlist ID", PlaylistIDText);
        ITISpotfyPlaylist.Validate("Playlist Name", PlaylistNameText);
        GetImageFromUrl(ITISpotfyPlaylist, PlaylistImageURLText);
        ITISpotfyPlaylist.Insert(true);
    end;

    local procedure ExtractDataFromJsonObjToText(var PlaylistJsonToken: JsonToken; var PlaylistIDText: Text[50]; var PlaylistNameText: Text[50]; var PlaylistImageURLText: Text[1000])
    var
        PlaylistJsonObj: JsonObject;
        PlaylistNameJsonToken: JsonToken;
        PlaylistIDJsonToken: JsonToken;
        PlaylistImageURLJsonObj: JsonToken;
        query: Text;
    begin
        query := '$.images[0].url';
        PlaylistJsonObj := PlaylistJsonToken.AsObject();
        PlaylistJsonObj.Get(ITITextConstants.ID(), PlaylistIDJsonToken);
        PlaylistJsonObj.Get(ITITextConstants.Name(), PlaylistNameJsonToken);
        if PlaylistJsonObj.SelectToken(query, PlaylistImageURLJsonObj) then
            PlaylistImageURLText := CopyStr(PlaylistImageURLJsonObj.AsValue().AsText(), 1, 1000);
        PlaylistIDText := CopyStr(PlaylistIDJsonToken.AsValue().AsText(), 1, 50);
        PlaylistNameText := CopyStr(PlaylistNameJsonToken.AsValue().AsText(), 1, 50);

    end;

    local procedure GetImageFromUrl(var ITISpotfyPlaylist: Record "ITI Spotfy Playlist"; PlaylistImageURLText: Text[1000])
    begin
        if PlaylistImageURLText = '' then
            exit;
        ITISpotfyPlaylist.Picture.ImportStream(GetPictureFromUrl(PlaylistImageURLText), '');
    end;

    local procedure GetUserPlaylistsJsonArray(var JsonArray: JsonArray)
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
        RequestMethod := ITITextConstants.HttpGET();
        RequestURI := 'https://api.spotify.com/v1/users/31rkjqx2c7vxjbyjhtyefxs4232q/playlists';
        ITIHttp.PrepareAndSendRequest(HttpRequestMessage, HttpClient, HttpResponseMessage, RequestMethod, RequestURI, RequestContentString);
        HttpResponseMessage.Content.ReadAs(JsonString);
        JsonObj.ReadFrom(JsonString);
        JsonObj.Get('items', ItemsJsonToken);
        JsonArray := ItemsJsonToken.AsArray();
    end;

    local procedure GetPictureFromUrl(PictureUrl: Text) InStream: InStream
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
    begin
        HttpClient.Get(PictureUrl, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(InStream);
    end;

    var
        ITITextConstants: Codeunit "ITI Text Constants";

}