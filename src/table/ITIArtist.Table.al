/// <summary>
/// Represents a table storing information about ITI artists.
/// </summary>
table 50101 "ITI Artist"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
        }
        field(2; "Artist ID"; Text[50])
        {
            Caption = 'Artist ID';
        }
        field(3; "Artist Name"; Text[50])
        {
            Caption = 'Artist Name';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(ArtistID; "Artist ID")
        {
            Unique = true;
        }
    }

    /// <summary>
    /// Creates a new artist using data from the ITI Add Artist Card, and adds the artist to Spotify using the ITI Create Spotify Artist codeunit.
    /// </summary>
    procedure CreateArtist()
    var
        ITICreateSpotifyArtist: Codeunit "ITI Create Spotify Artist";
        ITITextConstants: Codeunit "ITI Text Constants";
        ITIAddArtistCard: Page "ITI Add Artist Card";
        ArtistName: Text;
        ArtistJsonObj: JsonObject;
        IDResult: JsonToken;
    begin
        if ITIAddArtistCard.RunModal() = Action::OK then begin
            ArtistName := ITIAddArtistCard.GetArtistName();
            if not ArtistJsonObj.Get(ITITextConstants.ID(), IDResult) then
                Error(InvalidArtistNameErrorLbl);
            ITICreateSpotifyArtist.Create(ArtistJsonObj);
            Message('Success! Artist Added.');
        end;
    end;

    var
        InvalidArtistNameErrorLbl: Label 'There is no Artist with such a name on Spotify';
}