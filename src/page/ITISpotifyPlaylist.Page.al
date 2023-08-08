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
        area(Factboxes)
        {

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
                Image = GiroPlus;

                trigger OnAction()
                var
                    ITICreatePlaylist: Codeunit "ITI Create Spotify Playlist";
                    ITILoadPlaylist: Codeunit "ITI Load Playlist";
                    ITIDBManager: Codeunit "ITI DB Manager";
                    ITICreatePlaylistPage: Page "ITI Create Playlist Card";
                    ArtistList: List of [Text];
                    PlaylistName: Text;
                    PlaylistDesc: Text;
                    ArtistFilter: Text;

                begin
                    if ITICreatePlaylistPage.RunModal() = Action::OK then begin
                        PlaylistName := ITICreatePlaylistPage.GetPlaylistName();
                        PlaylistDesc := ITICreatePlaylistPage.GetPlaylistDesc();
                        ArtistFilter := ITICreatePlaylistPage.GetArtistFilter();
                        ITIDBManager.GetArtistWithFilter(ArtistList, ArtistFilter);
                        ITICreatePlaylist.Create(ArtistList, PlaylistName, PlaylistDesc);
                        ITILoadPlaylist.LoadPlaylistsFromAccount();
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Player.UpdatePlayer('playlist', Rec."Playlist ID");
    end;
}