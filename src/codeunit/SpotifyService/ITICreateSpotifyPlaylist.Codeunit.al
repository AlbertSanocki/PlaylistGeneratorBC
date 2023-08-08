/// <summary>
/// Codeunit 50100 "ITI Create Spotify Playlist"
/// This codeunit handles the creation of Spotify playlists and adding tracks to them.
/// </summary>
codeunit 50100 "ITI Create Spotify Playlist"
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// Creates a new playlist on Spotify and adds tracks from the specified artists to the playlist.
    /// </summary>
    /// <param name="ArtistList">A list of artist names.</param>
    /// <param name="PlaylistName">Name of the new playlist.</param>
    /// <param name="PlaylistDesc">Description of the new playlist.</param>
    procedure Create(var ArtistList: List of [Text]; PlaylistName: Text; PlaylistDesc: Text)
    var
        ArtistsIDList: List of [Text];
        ArtistJsonObjList: List of [JsonObject];
        TracksIDString: Text;
        PlaylistID: Text;
    begin
        CreatePlaylist(PlaylistID, PlaylistName, PlaylistDesc);
        IterateArtists(ArtistList, ArtistsIDList, ArtistJsonObjList);
        GetArtistTopTracksUris(ArtistsIDList, TracksIDString);
        AddTracksToPlaylist(PlaylistID, TracksIDString);
    end;

    local procedure CreatePlaylist(var PlaylistID: Text; PlaylistName: Text; PlaylistDesc: Text)
    var
        ITIHttp: Codeunit "ITI Http";
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpClient: HttpClient;
        RequestMethod: Text;
        RequestURI: Text;
        JsonString: Text;
        ResponseJsonString: Text;
        JsonObjResponse: JsonObject;
        PlaylistIDJasonToken: JsonToken;

    begin
        RequestMethod := ITITextConstants.HttpPOST();
        RequestURI := 'https://api.spotify.com/v1/users/31rkjqx2c7vxjbyjhtyefxs4232q/playlists';

        CreateJsonString(JsonString, PlaylistName, PlaylistDesc);
        ITIHttp.PrepareAndSendRequest(HttpRequestMessage, HttpClient, HttpResponseMessage, RequestMethod, RequestURI, JsonString);

        if not HttpResponseMessage.IsSuccessStatusCode() then
            Message(HttpResponseMessage.ReasonPhrase())

        else begin
            HttpResponseMessage.Content.ReadAs(ResponseJsonString);
            JsonObjResponse.ReadFrom(ResponseJsonString);
            JsonObjResponse.Get(ITITextConstants.ID(), PlaylistIDJasonToken);
            PlaylistID := PlaylistIDJasonToken.AsValue().AsText();
        end;
    end;

    local procedure GetArtistTopTracksUris(var ArtistsIDList: List of [Text]; var TracksIDString: Text)
    var
        RequestMethod: Text;
        ArtistID: Text;
    begin
        RequestMethod := ITITextConstants.HttpGET();
        foreach ArtistID in ArtistsIDList do
            GetTopTracks(TracksIDString, ArtistID, RequestMethod);
    end;

    local procedure GetArtist(var ArtistsID: List of [Text]; var ArtistJsonObjList: List of [JsonObject]; Artist: Text)
    var
        ITIHttp: Codeunit "ITI Http";
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpClient: HttpClient;
        RequestContentString: Text;
        RequestMethod: Text;
        RequestURI: Text;
        JsonObj: JsonObject;
        ArtistIDJasonToken: JsonToken;
        ArtistNameJasonToken: JsonToken;
        ArtistIDText: Text;
        ArtistNameText: Text;
        JsonString: Text;
        queryid: Text;
        queryname: Text;
        ArtistJsonObj: JsonObject;
    begin
        RequestMethod := ITITextConstants.HttpGET();
        RequestURI := 'https://api.spotify.com/v1/search?q=' + Artist + '&type=artist&limit=1';
        ITIHttp.PrepareAndSendRequest(HttpRequestMessage, HttpClient, HttpResponseMessage, RequestMethod, RequestURI, RequestContentString);
        HttpResponseMessage.Content.ReadAs(JsonString);
        JsonObj.ReadFrom(JsonString);
        queryid := '$.artists.items[0].id';
        queryname := '$.artists.items[0].name';
        if not JsonObj.SelectToken(queryid, ArtistIDJasonToken) then
            exit;
        JsonObj.SelectToken(queryname, ArtistNameJasonToken);
        ArtistIDText := ArtistIDJasonToken.AsValue().AsText();
        ArtistNameText := ArtistNameJasonToken.AsValue().AsText();
        ArtistJsonObj.Add(ITITextConstants.ID(), ArtistIDText);
        ArtistJsonObj.Add(ITITextConstants.Name(), ArtistNameText);
        ArtistJsonObjList.Add(ArtistJsonObj);
        ArtistsID.Add(ArtistIDText);
    end;

    /// <summary>
    /// Iterates through the list of artist names, gets their IDs and JSON objects, and stores them in the respective lists.
    /// </summary>
    /// <param name="Artists">A list of artist names.</param>
    /// <param name="ArtistsIDList">An output list to store artist IDs.</param>
    /// <param name="ArtistJsonObjList">An output list to store artist JSON objects.</param>
    procedure IterateArtists(var Artists: List of [Text]; var ArtistsIDList: List of [Text]; var ArtistJsonObjList: List of [JsonObject])
    var
        Artist: Text;
    begin
        foreach Artist in Artists do
            GetArtist(ArtistsIDList, ArtistJsonObjList, Artist);
    end;

    local procedure GetTopTracks(var TracksIDString: Text; ArtistID: Text; RequestMethod: Text)
    var
        ITIHttp: Codeunit "ITI Http";
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestContentString: Text;
        RequestURI: Text;
        HttpClient: HttpClient;
        JsonObj: JsonObject;
        TrackIDJasonToken: JsonToken;
        JsonString: Text;
        JsonArray: JsonArray;
        Track: JsonToken;
    begin
        RequestURI := 'https://api.spotify.com/v1/artists/' + ArtistID + '/top-tracks?market=US';
        ITIHttp.PrepareAndSendRequest(HttpRequestMessage, HttpClient, HttpResponseMessage, RequestMethod, RequestURI, RequestContentString);
        HttpResponseMessage.Content.ReadAs(JsonString);
        JsonObj.ReadFrom(JsonString);
        JsonObj.Get('tracks', TrackIDJasonToken);
        JsonArray := TrackIDJasonToken.AsArray();
        foreach Track in JsonArray do
            BuildTheStringOfTrackURI(TracksIDString, Track);
    end;

    local procedure AddTracksToPlaylist(PlaylistID: Text; TracksIDString: Text)
    var
        ITIHttp: Codeunit "ITI Http";
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestContentString: Text;
        RequestURI: Text;
        HttpClient: HttpClient;
        RequestMethod: Text;
    begin
        RequestMethod := ITITextConstants.HttpPOST();
        RequestURI := 'https://api.spotify.com/v1/playlists/' + PlaylistID + '/tracks?uris=' + TracksIDString;
        ITIHttp.PrepareAndSendRequest(HttpRequestMessage, HttpClient, HttpResponseMessage, RequestMethod, RequestURI, RequestContentString);
    end;

    local procedure BuildTheStringOfTrackURI(var TracksIDString: Text; var Track: JsonToken)
    var

        TrackURIText: Text;
        TrackJsonObj: JsonObject;
        TrackURIJsonTokn: JsonToken;
    begin
        TrackJsonObj := Track.AsObject();
        TrackJsonObj.Get('uri', TrackURIJsonTokn);
        TrackURIText := TrackURIJsonTokn.AsValue().AsText();
        TracksIDString += TrackURIText + ',';
    end;

    local procedure CreateJsonString(var JsonString: Text; PlaylistName: Text; PlaylistDesc: Text)
    var
        JsonObj: JsonObject;
    begin
        JsonObj.Add(ITITextConstants.Name(), PlaylistName);
        JsonObj.Add(ITITextConstants.Desc(), PlaylistDesc);
        JsonObj.Add(ITITextConstants.Public(), true);
        JsonObj.WriteTo(JsonString);
    end;

    var
        ITITextConstants: Codeunit "ITI Text Constants";
}