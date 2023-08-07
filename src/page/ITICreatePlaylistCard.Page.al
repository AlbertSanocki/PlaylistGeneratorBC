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
                ApplicationArea = All;
                Caption = 'Playlist Name';
                ToolTip = 'Name of the new Spotify playlist';
            }
            field(PlaylistDesc; PlaylistDesc)
            {
                ApplicationArea = All;
                Caption = 'Playlist Description';
                ToolTip = 'Description of the new Spotify playlist';
            }
            field(ArtistFilter; ArtistFilter)
            {
                ApplicationArea = All;
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

    procedure GetPlaylistName(): Text
    begin
        exit(PlaylistName)
    end;

    procedure GetPlaylistDesc(): Text
    begin
        exit(PlaylistDesc)
    end;

    procedure GetArtistFilter(): Text
    begin
        exit(ArtistFilter)
    end;

    var
        PlaylistName: Text;
        PlaylistDesc: Text;
        ArtistFilter: Text;
}