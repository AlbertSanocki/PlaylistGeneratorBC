/// <summary>
/// Represents a table storing information about ITI Spotify playlists.
/// </summary>
table 50100 "ITI Spotfy Playlist"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
        }
        field(2; "Playlist ID"; Text[50])
        {
            Caption = 'Playlist ID';
        }
        field(3; "Playlist Name"; Text[50])
        {
            Caption = 'Playlist Name';
        }
        field(4; Picture; Media)
        {
            Caption = 'Picture';
        }
    }

    keys
    {
        key(Key1; "No.", "Playlist ID")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Creates a new playlist on Spotify, filtered by artist, using information from the ITI Create Playlist Card.
    /// </summary>
    procedure CreatePlalist()
    var
        ITIArtist: Record "ITI Artist";
        ITICreateSpotifyPlaylist: Codeunit "ITI Create Spotify Playlist";
        ITILoadPlaylist: Codeunit "ITI Load Playlist";
        ITICreatePlaylistCard: Page "ITI Create Playlist Card";
        PlaylistName: Text;
        PlaylistDesc: Text;
        ArtistFilter: Text;
    begin
        if ITICreatePlaylistCard.RunModal() = Action::OK then begin
            PlaylistName := ITICreatePlaylistCard.GetPlaylistName();
            PlaylistDesc := ITICreatePlaylistCard.GetPlaylistDesc();
            ArtistFilter := ITICreatePlaylistCard.GetArtistFilter();

            if not ITICreateSpotifyPlaylist.ValidatePlaylistFormData(PlaylistName, ArtistFilter) then
                exit;

            ITIArtist.SetFilter("No.", ArtistFilter);
            ITICreateSpotifyPlaylist.Create(ITIArtist, PlaylistName, PlaylistDesc);
            ITILoadPlaylist.LoadPlaylistsFromAccount();
        end;
    end;
}