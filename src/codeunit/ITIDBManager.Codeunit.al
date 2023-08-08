/// <summary>
/// Codeunit 50105 "ITI DB Manager"
/// This codeunit manages the database operations for ITI artists and provides functions for creating, filtering, and retrieving artist records.
/// </summary>
codeunit 50105 "ITI DB Manager"
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// Creates an artist record in the "ITI Artist" table based on the provided JsonObject containing artist data.
    /// </summary>
    /// <param name="ArtistJsonObj">The JsonObject containing artist data.</param>
    procedure CreateArtist(var ArtistJsonObj: JsonObject)
    var
        ITIArtistRecord: Record "ITI Artist";
        ArtistIDText: Text[50];
        ArtistNameText: Text[50];
    begin
        ExtractArtistData(ArtistJsonObj, ArtistIDText, ArtistNameText);
        Clear(ITIArtistRecord);
        ITIArtistRecord.Init();
        ITIArtistRecord.Validate("Artist ID", ArtistIDText);
        ITIArtistRecord.Validate("Artist Name", ArtistNameText);
        ITIArtistRecord.Insert(true);
    end;

    local procedure ExtractArtistData(var ArtistJsonObj: JsonObject; var ArtistIDText: Text[50]; var ArtistNameText: Text[50])
    var
        ArtistIDJsonToken: JsonToken;
        ArtistNameJsonToken: JsonToken;
    begin
        ArtistJsonObj.Get(ITITextConstants.ID(), ArtistIDJsonToken);
        ArtistJsonObj.Get(ITITextConstants.Name(), ArtistNameJsonToken);
        ArtistIDText := CopyStr(ArtistIDJsonToken.AsValue().AsText(), 1, 50);
        ArtistNameText := CopyStr(ArtistNameJsonToken.AsValue().AsText(), 1, 50);
    end;

    /// <summary>
    /// Opens a lookup window for selecting an artist filter from the "ITI Artist" table.
    /// </summary>
    /// <param name="ITIArtist">The record variable representing the "ITI Artist" table.</param>
    /// <param name="ArtistNoFilter">Output parameter that will store the selected artist filter.</param>
    /// <returns>True if a filter is selected, False otherwise.</returns>
    procedure GetArtistFilter(var ITIArtist: Record "ITI Artist"; var ArtistNoFilter: Text): Boolean
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        ITIArtists: Page "ITI Artists";
        RecordRef: RecordRef;
    begin
        ITIArtists.SetTableView(ITIArtist);
        ITIArtists.LookupMode := true;

        if ITIArtists.RunModal() <> Action::LookupOK then
            exit;

        ITIArtists.SetSelectionFilter(ITIArtist);
        RecordRef.GetTable(ITIArtist);

        ArtistNoFilter := SelectionFilterManagement.GetSelectionFilter(RecordRef, ITIArtist.FieldNo("No."));
        exit(true);
    end;

    /// <summary>
    /// Retrieves a list of artist names based on the specified artist filter.
    /// </summary>
    /// <param name="ArtistList">Output parameter that will store the list of artist names.</param>
    /// <param name="ArtistFilter">The filter criteria to apply for retrieving artists.</param>
    procedure GetArtistWithFilter(var ArtistList: List of [Text]; ArtistFilter: Text)
    var
        ITIArtist: Record "ITI Artist";
    begin
        ITIArtist.SetFilter("No.", ArtistFilter);
        if ITIArtist.FindSet() then
            repeat
                ArtistList.Add(ITIArtist."Artist Name");
            until ITIArtist.Next() = 0;
    end;

    var
        ITITextConstants: Codeunit "ITI Text Constants";
}