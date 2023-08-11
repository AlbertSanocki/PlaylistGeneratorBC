/// <summary>
/// Page 50101 "ITI Spotify Playlist"
/// This page displays Spotify playlists and allows users to load existing playlists or create new playlist.
/// </summary>
page 50101 "ITI Spotify Playlist"
{
    PageType = List;
    Caption = 'Spotify Playlist';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ITI Spotfy Playlist";
    Editable = false;

    layout
    {
        area(Content)
        {
            usercontrol(Player; PlayerAddin) { }
            repeater(GroupName)
            {
                field("Playlist Name"; Rec."Playlist Name")
                {
                    ToolTip = 'Specifies the playlist name.';
                }
                field(Picture; Rec.Picture)
                {
                    ToolTip = 'Specifies the playlist image.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(LoadPlaylists)
            {
                Caption = 'LoadPlaylists';
                ToolTip = 'Load users playlists';
                Image = Download;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;


                trigger OnAction()
                var
                    ITILoadPlaylist: Codeunit "ITI Load Playlist";
                begin
                    ITILoadPlaylist.LoadPlaylistsFromAccount()
                end;
            }
            action(CreatePlaylist)
            {
                Caption = 'Create Playlist';
                ToolTip = 'Create Playlist';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()

                begin
                    Rec.CreatePlalist();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Player.UpdatePlayer('playlist', Rec."Playlist ID");
    end;
}