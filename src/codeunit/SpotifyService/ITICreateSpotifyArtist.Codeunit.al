/// <summary>
/// Codeunit 50104 "ITI Create Spotify Artist"
/// This codeunit facilitates the creation and retrieval of artist records from the Spotify API, storing the data in the "ITI Artist" table.
/// </summary>
codeunit 50104 "ITI Create Spotify Artist"
{
    /// <summary>
    /// Creates an artist record in the "ITI Artist" table based on the provided JsonObject containing artist data.
    /// </summary>
    /// <param name="ArtistJsonObj">The JsonObject containing artist data.</param>
    procedure Create(var ArtistJsonObj: JsonObject)
    var
        ITIArtist: Record "ITI Artist";
        ArtistIDText: Text[50];
        ArtistNameText: Text[50];
    begin
        ExtractArtistData(ArtistJsonObj, ArtistIDText, ArtistNameText);
        Clear(ITIArtist);
        ITIArtist.Init();
        ITIArtist.Validate("Artist ID", ArtistIDText);
        ITIArtist.Validate("Artist Name", ArtistNameText);
        ITIArtist.Insert(true);
    end;

    /// <summary>
    /// Retrieves artist information from the ITI database and populates a JSON array with the corresponding data.
    /// </summary>
    /// <param name="ITIArtist">The record representing an "ITI Artist" in the database.</param>
    /// <param name="ArtistJsonArray">The JSON array to store the artist information.</param>
    procedure GetArtists(var ITIArtist: Record "ITI Artist"; var ArtistJsonArray: JsonArray)
    var
        ArtistJsonObj: JsonObject;
    begin
        if ITIArtist.FindSet() then
            repeat
                ArtistJsonObj := GetArtist(ITIArtist."Artist Name");
                ArtistJsonArray.Add(ArtistJsonObj);
            until ITIArtist.Next() = 0;
    end;

    /// <summary>
    /// Retrieves artist information from Spotify API and returns it as a JSON object.
    /// </summary>
    /// <param name="ArtistName">The name of the artist to search for.</param>
    /// <returns>A JsonObject containing artist information.</returns>
    procedure GetArtist(ArtistName: Text) ArtistJsonObj: JsonObject
    var
        ITIAccessToken: Codeunit "ITI Access Token";
        ITIHttp: Codeunit "ITI Http";
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
        AccessToken: Text;
    begin
        RequestMethod := ITITextConstants.HttpGET();
        RequestURI := 'https://api.spotify.com/v1/search?q=' + ArtistName + '&type=artist&limit=1';
        ITIAccessToken.GetToken();
        IsolatedStorage.Get('access_token', AccessToken);
        ITIHttp.SetMethod(RequestMethod);
        ITIHttp.SetRequestURI(RequestURI);
        ITIHttp.SetRequestContent(RequestContentString);
        ITIHttp.SetAuthorization(ITITextConstants.Authorization(), ITITextConstants.Bearer() + AccessToken);
        ITIHttp.Send();

        if not ITIHttp.GetIsSuccessStatusCode() then
            Error(ITIHttp.GetReasonPhrase());
        ITIHttp.GetResponseMessage().Content.ReadAs(JsonString);

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
    end;

    /// <summary>
    /// Opens a lookup window for selecting an artist filter from the "ITI Artist" table.
    /// </summary>
    /// <param name="ITIArtist">The record variable representing the "ITI Artist" table.</param>
    /// <param name="ArtistNoFilter">Output parameter that will store the selected artist filter.</param>
    /// <returns>True if the artist filter is retrieved and valid, otherwise false.</returns>
    procedure GetArtistFilter(var ITIArtist: Record "ITI Artist"; var ArtistNoFilter: Text): Boolean
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        ITISpotifyArtists: Page "ITI Spotify Artists";
        RecordRef: RecordRef;
    begin
        ITISpotifyArtists.SetTableView(ITIArtist);
        ITISpotifyArtists.LookupMode := true;

        if ITISpotifyArtists.RunModal() <> Action::LookupOK then
            exit;

        ITISpotifyArtists.SetSelectionFilter(ITIArtist);
        RecordRef.GetTable(ITIArtist);

        ArtistNoFilter := SelectionFilterManagement.GetSelectionFilter(RecordRef, ITIArtist.FieldNo("No."));

        if not ValidateNumberOfArtists(ITIArtist, ArtistNoFilter) then begin
            ArtistNoFilter := '';
            exit;
        end;

        exit(true);
    end;

    local procedure ValidateNumberOfArtists(var ITIArtist: Record "ITI Artist"; ArtistFilter: Text): Boolean;
    begin
        ITIArtist.SetFilter("No.", ArtistFilter);
        if ITIArtist.FindSet() then
            if ITIArtist.Count > 10 then begin
                Message('The number of choosen artists must be up to 10');
                exit;
            end;

        exit(true);
    end;

    /// <summary>
    /// Extracts artist data from a JSON object and stores it in variables.
    /// </summary>
    /// <param name="ArtistJsonObj">The JsonObject containing artist data.</param>
    /// <param name="ArtistIDText">Output parameter for artist ID.</param>
    /// <param name="ArtistNameText">Output parameter for artist name.</param>
    /// <returns>True if there is some data in json, False otherwise.</returns>
    procedure ExtractArtistData(var ArtistJsonObj: JsonObject; var ArtistIDText: Text[50]; var ArtistNameText: Text[50]): Boolean
    var
        ArtistIDJsonToken: JsonToken;
        ArtistNameJsonToken: JsonToken;
    begin
        if not ArtistJsonObj.Get(ITITextConstants.ID(), ArtistIDJsonToken) then
            exit(false);
        ArtistJsonObj.Get(ITITextConstants.Name(), ArtistNameJsonToken);
        ArtistIDText := CopyStr(ArtistIDJsonToken.AsValue().AsText(), 1, 50);
        ArtistNameText := CopyStr(ArtistNameJsonToken.AsValue().AsText(), 1, 50);
        exit(true)
    end;

    var
        ITITextConstants: Codeunit "ITI Text Constants";
}