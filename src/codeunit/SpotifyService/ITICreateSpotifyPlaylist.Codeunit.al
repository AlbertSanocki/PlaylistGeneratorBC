/// <summary>
/// Codeunit 50100 "ITI Create Spotify Playlist"
/// This codeunit handles the creation of Spotify playlists and adding tracks to them.
/// </summary>
codeunit 50100 "ITI Create Spotify Playlist"
{
    /// <summary>
    /// Creates a new playlist for an ITI Artist on Spotify, populating it with the artist's top tracks.
    /// </summary>
    /// <param name="ITIArtist">The record representing an "ITI Artist" in the database.</param>
    /// <param name="PlaylistName">The name of the playlist to be created.</param>
    /// <param name="PlaylistDesc">The description of the playlist.</param>
    procedure Create(var ITIArtist: Record "ITI Artist"; PlaylistName: Text; PlaylistDesc: Text)
    var
        ITICreateArtist: Codeunit "ITI Create Spotify Artist";
        ArtistJsonArray: JsonArray;
        TracksIDString: Text;
        PlaylistID: Text;
    begin
        if not CreatePlaylist(PlaylistID, PlaylistName, PlaylistDesc) then
            exit;

        ITICreateArtist.GetArtists(ITIArtist, ArtistJsonArray);
        GetArtistTopTracksUris(ArtistJsonArray, TracksIDString);
        AddTracksToPlaylist(PlaylistID, TracksIDString);
    end;

    local procedure CreatePlaylist(var PlaylistID: Text; PlaylistName: Text; PlaylistDesc: Text): Boolean;
    var
        ITIAccessToken: Codeunit "ITI Access Token";
        ITIHttp: Codeunit "ITI Http";
        RequestMethod: Text;
        RequestURI: Text;
        JsonString: Text;
        ResponseJsonString: Text;
        AccessToken: Text;
        JsonObjResponse: JsonObject;
        PlaylistIDJasonToken: JsonToken;
    begin
        RequestMethod := ITITextConstants.HttpPOST();
        RequestURI := 'https://api.spotify.com/v1/users/31rkjqx2c7vxjbyjhtyefxs4232q/playlists';
        ITIAccessToken.GetToken();
        IsolatedStorage.Get('access_token', AccessToken);
        CreateJsonString(JsonString, PlaylistName, PlaylistDesc);
        ITIHttp.SetMethod(RequestMethod);
        ITIHttp.SetRequestURI(RequestURI);
        ITIHttp.SetRequestContent(JsonString);
        ITIHttp.SetAuthorization(ITITextConstants.Authorization(), ITITextConstants.Bearer() + AccessToken);
        ITIHttp.Send();

        if not ITIHttp.GetIsSuccessStatusCode() then
            Error(ITIHttp.GetReasonPhrase())

        else begin
            ITIHttp.GetResponseMessage().Content.ReadAs(ResponseJsonString);
            JsonObjResponse.ReadFrom(ResponseJsonString);
            JsonObjResponse.Get(ITITextConstants.ID(), PlaylistIDJasonToken);
            PlaylistID := PlaylistIDJasonToken.AsValue().AsText();
        end;
        exit(true)
    end;

    local procedure GetArtistTopTracksUris(var ArtistJsonArray: JsonArray; var TracksIDString: Text)
    var
        ITICreateSpotifyArtist: Codeunit "ITI Create Spotify Artist";
        RequestMethod: Text;
        ArtistJsonToken: JsonToken;
        ArtistJsonObj: JsonObject;
        ArtistIDText: Text[50];
        ArtistNameText: Text[50];
    begin
        RequestMethod := ITITextConstants.HttpGET();
        foreach ArtistJsonToken in ArtistJsonArray do
            if ArtistJsonToken.IsObject then begin
                ArtistJsonObj := ArtistJsonToken.AsObject();
                if ITICreateSpotifyArtist.ExtractArtistData(ArtistJsonObj, ArtistIDText, ArtistNameText) then
                    GetTopTracks(TracksIDString, ArtistIDText, RequestMethod);
            end
    end;

    local procedure GetTopTracks(var TracksIDString: Text; ArtistID: Text; RequestMethod: Text)
    var
        ITIAccessToken: Codeunit "ITI Access Token";
        ITIHttp: Codeunit "ITI Http";
        RequestContentString: Text;
        RequestURI: Text;
        JsonObj: JsonObject;
        TrackIDJasonToken: JsonToken;
        JsonString: Text;
        AccessToken: Text;
        JsonArray: JsonArray;
        Track: JsonToken;
    begin
        RequestURI := 'https://api.spotify.com/v1/artists/' + ArtistID + '/top-tracks?market=US';
        ITIAccessToken.GetToken();
        IsolatedStorage.Get(ITITextConstants.AccessToken(), AccessToken);
        ITIHttp.SetMethod(RequestMethod);
        ITIHttp.SetRequestURI(RequestURI);
        ITIHttp.SetRequestContent(RequestContentString);
        ITIHttp.SetAuthorization(ITITextConstants.Authorization(), ITITextConstants.Bearer() + AccessToken);
        ITIHttp.Send();

        if not ITIHttp.GetIsSuccessStatusCode() then
            Error(ITIHttp.GetReasonPhrase());
        ITIHttp.GetResponseMessage().Content.ReadAs(JsonString);
        JsonObj.ReadFrom(JsonString);
        JsonObj.Get(ITITextConstants.Tracks(), TrackIDJasonToken);
        JsonArray := TrackIDJasonToken.AsArray();
        foreach Track in JsonArray do
            BuildTheStringOfTrackURI(TracksIDString, Track);
    end;

    local procedure AddTracksToPlaylist(PlaylistID: Text; TracksIDString: Text)
    var
        ITIAccessToken: Codeunit "ITI Access Token";
        ITIHttp: Codeunit "ITI Http";
        RequestContentString: Text;
        RequestURI: Text;
        RequestMethod: Text;
        AccessToken: Text;
    begin
        RequestMethod := ITITextConstants.HttpPOST();
        RequestURI := 'https://api.spotify.com/v1/playlists/' + PlaylistID + '/tracks?uris=' + TracksIDString;
        ITIAccessToken.GetToken();
        IsolatedStorage.Get(ITITextConstants.AccessToken(), AccessToken);
        ITIHttp.SetMethod(RequestMethod);
        ITIHttp.SetRequestURI(RequestURI);
        ITIHttp.SetRequestContent(RequestContentString);
        ITIHttp.SetAuthorization(ITITextConstants.Authorization(), ITITextConstants.Bearer() + AccessToken);
        ITIHttp.Send();

        if not ITIHttp.GetIsSuccessStatusCode() then
            Error(ITIHttp.GetReasonPhrase());
    end;

    local procedure BuildTheStringOfTrackURI(var TracksIDString: Text; var Track: JsonToken)
    var

        TrackURIText: Text;
        TrackJsonObj: JsonObject;
        TrackURIJsonTokn: JsonToken;
    begin
        TrackJsonObj := Track.AsObject();
        TrackJsonObj.Get(ITITextConstants.URI(), TrackURIJsonTokn);
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

    /// <summary>
    /// Validates the playlist form data to ensure that both the Playlist Name and Artist Filter are not empty.
    /// </summary>
    /// <param name="PlaylistName">The name of the playlist.</param>
    /// <param name="ArtistFilter">The artist filter for the playlist.</param>
    /// <returns>True if the data is valid; otherwise, false.</returns>
    procedure ValidatePlaylistFormData(PlaylistName: Text; ArtistFilter: Text): Boolean;
    begin
        if PlaylistName = '' then begin
            Message('Playlist Name can not be empty');
            exit;
        end;
        if ArtistFilter = '' then begin
            Message('Playlist Filter can not be empty');
            exit;
        end;
        exit(true)
    end;

    var
        ITITextConstants: Codeunit "ITI Text Constants";
}