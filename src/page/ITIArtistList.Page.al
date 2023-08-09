/// <summary>
/// Page 50100 "ITI Artists"
/// This page displays a list of artists from the "ITI Artist" table. It allows users to load the 100 most viewed artists from Spotify and create records for them, as well as create a playlist from the top artists.
/// </summary>
page 50100 "ITI Artists"
{
    PageType = List;
    Caption = 'Artist List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ITI Artist";
    Editable = false;

    layout
    {
        area(Content)
        {
            usercontrol(Player; PlayerAddin) { }
            repeater(GroupName)
            {
                field("Artist Name"; Rec."Artist Name")
                {
                    NotBlank = true;
                    ToolTip = 'Specifies the artist name';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(LoadArtists)
            {
                Caption = 'LoadArtists';
                ToolTip = 'Load 100 most viewed artists';
                Image = Download;
                Visible = false;

                trigger OnAction()
                var
                    ITIDBManager: Codeunit "ITI DB Manager";
                    SpotifyService: Codeunit "ITI Create Spotify Playlist";
                    ArtistJsonObjList: List of [JsonObject];
                    ArtistList: List of [Text];
                    ArtistJsonObj: JsonObject;
                begin
                    // ArtistRecord.DeleteAll(true);
                    SpotifyService.IterateArtists(ArtistList, ArtistJsonObjList);
                    foreach ArtistJsonObj in ArtistJsonObjList do
                        ITIDBManager.CreateArtist(ArtistJsonObj);
                end;
            }

            action(AddArtist)
            {
                Caption = 'Add Artist';
                ToolTip = 'Add Artist';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ITIDBManager: Codeunit "ITI DB Manager";
                    ITICreateSpotifyPlaylist: Codeunit "ITI Create Spotify Playlist";
                    ITITextConstants: Codeunit "ITI Text Constants";
                    ITIAddArtistCard: Page "ITI Add Artist Card";
                    ArtistName: Text;
                    ArtistJsonObj: JsonObject;
                    IDResult: JsonToken;

                begin
                    if ITIAddArtistCard.RunModal() = Action::OK then begin
                        ArtistName := ITIAddArtistCard.GetArtistName();
                        ArtistJsonObj := ITICreateSpotifyPlaylist.GetArtist(ArtistName);
                        if not ArtistJsonObj.Get(ITITextConstants.ID(), IDResult) then
                            Error('There is no Artist with such a name on Spotify');
                        ITIDBManager.CreateArtist(ArtistJsonObj);
                        Message('Success! Artist Added.');
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Player.UpdatePlayer('artist', Rec."Artist ID");
    end;
}