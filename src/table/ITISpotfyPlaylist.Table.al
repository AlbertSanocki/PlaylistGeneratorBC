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
}