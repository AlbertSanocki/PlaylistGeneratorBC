table 50101 "ITI Artist"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
        }
        field(2; "Artist ID"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Artist ID';
        }
        field(3; "Artist Name"; Text[50])
        {
            Caption = 'Artist Name';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(ArtistID; "Artist ID")
        {
            Unique = true;
        }
    }
}