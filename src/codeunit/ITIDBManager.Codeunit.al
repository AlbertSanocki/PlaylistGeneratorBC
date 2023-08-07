codeunit 50105 "ITI DB Manager"
{
    trigger OnRun()
    begin

    end;

    procedure CreateArtistRecord(var ArtistJsonObj: JsonObject)
    var
        ITIArtistRecord: Record "ITI Artist";
        ArtistIDText: Text[50];
        ArtistNameText: Text[50];
    begin
        ExtracArtistData(ArtistJsonObj, ArtistIDText, ArtistNameText);
        Clear(ITIArtistRecord);
        ITIArtistRecord.Init();
        ITIArtistRecord.Validate("Artist ID", ArtistIDText);
        ITIArtistRecord.Validate("Artist Name", ArtistNameText);
        ITIArtistRecord.Insert(true);
    end;

    local procedure ExtracArtistData(var ArtistJsonObj: JsonObject; var ArtistIDText: Text[50]; var ArtistNameText: Text[50])
    var
        ArtistIDJasonToken: JsonToken;
        ArtistNameJasonToken: JsonToken;
    begin
        ArtistJsonObj.Get('id', ArtistIDJasonToken);
        ArtistJsonObj.Get('name', ArtistNameJasonToken);
        ArtistIDText := ArtistIDJasonToken.AsValue().AsText();
        ArtistNameText := ArtistNameJasonToken.AsValue().AsText();
    end;

    procedure GetArtistFilter(var ITIArtist: Record "ITI Artist"; var ArtistNoFilter: Text): Boolean
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        ITIArtistList: Page "ITI Artist List";
        RecordRef: RecordRef;
    begin
        ITIArtistList.SetTableView(ITIArtist);
        ITIArtistList.LookupMode := true;
        if ITIArtistList.RunModal() <> Action::LookupOK then
            exit;
        ITIArtistList.SetSelectionFilter(ITIArtist);
        RecordRef.GetTable(ITIArtist);

        ArtistNoFilter := SelectionFilterManagement.GetSelectionFilter(RecordRef, ITIArtist.FieldNo("No."));
        exit(true);
    end;

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
}