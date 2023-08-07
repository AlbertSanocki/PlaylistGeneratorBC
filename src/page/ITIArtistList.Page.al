page 50100 "ITI Artist List"
{
    PageType = List;
    Caption = 'Artist List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ITI Artist";

    layout
    {
        area(Content)
        {
            usercontrol(Player; PlayerAddin)
            {
                ApplicationArea = All;
            }
            repeater(GroupName)
            {
                field("Artist Name"; Rec."Artist Name")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the artist name';
                }
                field("Artist ID"; Rec."Artist ID")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the artist ID';
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
                ApplicationArea = All;
                Caption = 'LoadArtists';
                ToolTip = 'Load 100 most viewed artists';
                Image = Download;

                trigger OnAction()
                var
                    ITIDBManager: Codeunit "ITI DB Manager";
                    SpotifyService: Codeunit "ITI Create Spotify Playlist";
                    ArtistJsonObjList: List of [JsonObject];
                    ArtistList: List of [Text];
                    ArtistIDList: List of [Text];
                    ArtistJsonObj: JsonObject;
                begin
                    // ArtistRecord.DeleteAll(true);
                    SpotifyService.IterateArtists(ArtistList, ArtistIDList, ArtistJsonObjList);
                    foreach ArtistJsonObj in ArtistJsonObjList do
                        ITIDBManager.CreateArtistRecord(ArtistJsonObj);
                end;
            }
            action(CreatePlaylistfFromTopArtists)
            {
                ApplicationArea = All;
                Caption = 'CreatePlaylistfFromTopArtists';
                ToolTip = 'CreatePlaylistfFromTopArtists of 100 most viewed artists';
                Image = CheckList;

                trigger OnAction()
                var
                    ITIArtist: Record "ITI Artist";
                    ITIDBManager: Codeunit "ITI DB Manager";
                    ArtistNoFilter: Text;
                begin
                    ITIDBManager.GetArtistFilter(ITIArtist, ArtistNoFilter)
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Player.UpdatePlayer('artist', Rec."Artist ID");
    end;
}