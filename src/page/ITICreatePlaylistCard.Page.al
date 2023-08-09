/// <summary>
/// Page 50104 "ITI Create Playlist Card"
/// This page serves as a standard dialog for creating a new Spotify playlist. It allows users to enter the playlist name and description and also select specific artists as filters for creating the playlist.
/// </summary>
page 50104 "ITI Create Playlist Card"
{
    UsageCategory = Lists;
    PageType = StandardDialog;
    Caption = 'Create Playlist';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(PlaylistName; PlaylistName)
            {
                Caption = 'Playlist Name';
                ToolTip = 'Name of the new Spotify playlist';
            }
            field(PlaylistDesc; PlaylistDesc)
            {
                Caption = 'Playlist Description';
                ToolTip = 'Description of the new Spotify playlist';
            }
            field(ArtistFilter; ArtistFilter)
            {
                Caption = 'Artist filter';
                ToolTip = 'Allows to select specific artists for creating a playlist';
                Editable = false;
                trigger OnAssistEdit()
                var
                    ITIArtist: Record "ITI Artist";
                    ITIDBManager: Codeunit "ITI DB Manager";
                begin
                    ITIDBManager.GetArtistFilter(ITIArtist, ArtistFilter);
                end;
            }
        }
    }
    actions
    {

    }

    /// <summary>
    /// Retrieves the playlist name from the "ITI Create Playlist Card" page.
    /// </summary>
    /// <returns>The playlist name as a Text value.</returns>
    procedure GetPlaylistName(): Text
    begin
        exit(PlaylistName)
    end;

    /// <summary>
    /// Retrieves the playlist description from the "ITI Create Playlist Card" page.
    /// </summary>
    /// <returns>The playlist description as a Text value.</returns>
    procedure GetPlaylistDesc(): Text
    begin
        exit(PlaylistDesc)
    end;

    /// <summary>
    /// Retrieves the artist filter from the "ITI Create Playlist Card" page.
    /// </summary>
    /// <returns>The artist filter as a Text value.</returns>
    procedure GetArtistFilter(): Text
    begin
        exit(ArtistFilter)
    end;

    var
        PlaylistName: Text;
        PlaylistDesc: Text;
        ArtistFilter: Text;
}