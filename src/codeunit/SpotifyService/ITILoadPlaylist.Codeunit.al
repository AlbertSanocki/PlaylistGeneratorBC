codeunit 50106 "ITI Load Playlist"
{
    trigger OnRun()
    begin

    end;

    procedure LoadPlaylistsFromUsersAccount()
    var
        ITIPlaylistRecord: Record "ITI Spotfy Playlist";
        ITIGetUserData: Codeunit "ITI Get Data Util";
        JsonArray: JsonArray;
        PlaylistJsonToken: JsonToken;
    begin
        ITIPlaylistRecord.DeleteAll(true);
        ITIGetUserData.GetUserPlaylistsJsonArray(JsonArray);
        foreach PlaylistJsonToken in JsonArray do
            CreateUserPlaylistRecord(PlaylistJsonToken);
    end;

    local procedure CreateUserPlaylistRecord(var PlaylistJsonToken: JsonToken)
    var
        ITIPlaylistRecord: Record "ITI Spotfy Playlist";
        PlaylistIDText: Text[50];
        PlaylistNameText: Text[50];
        PlaylistImageURLText: Text[1000];
    begin
        ExtractDataFromJsonObjToText(PlaylistJsonToken, PlaylistIDText, PlaylistNameText, PlaylistImageURLText);
        Clear(ITIPlaylistRecord);
        ITIPlaylistRecord.Init();
        ITIPlaylistRecord.Validate("Playlist ID", PlaylistIDText);
        ITIPlaylistRecord.Validate("Playlist Name", PlaylistNameText);
        GetImageFromUrl(ITIPlaylistRecord, PlaylistImageURLText);
        ITIPlaylistRecord.Insert(true);
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
        PlaylistJsonObj.Get('id', PlaylistIDJsonToken);
        PlaylistJsonObj.Get('name', PlaylistNameJsonToken);
        if PlaylistJsonObj.SelectToken(query, PlaylistImageURLJsonObj) then
            PlaylistImageURLText := PlaylistImageURLJsonObj.AsValue().AsText();
        PlaylistIDText := PlaylistIDJsonToken.AsValue().AsText();
        PlaylistNameText := PlaylistNameJsonToken.AsValue().AsText();
    end;

    local procedure GetImageFromUrl(var PlaylistRecord: Record "ITI Spotfy Playlist"; PlaylistImageURLText: Text[1000])
    var
        ITIGetDataUtil: Codeunit "ITI Get Data Util";
    begin
        if PlaylistImageURLText = '' then
            exit;
        PlaylistRecord.Picture.ImportStream(ITIGetDataUtil.GetPictureFromUrl(PlaylistImageURLText), '');
    end;
}