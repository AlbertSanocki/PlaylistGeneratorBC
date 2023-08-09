/// <summary>
/// Represents a standard dialog page for adding an artist card to the ITI database.
/// </summary>
page 50102 "ITI Add Artist Card"
{
    UsageCategory = Lists;
    PageType = StandardDialog;
    Caption = 'Add Artist';
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            field(ArtistName; ArtistName)
            {
                Caption = 'Artist Name';
                ToolTip = 'Name of the artist you want add to database';
            }
        }
    }

    /// <summary>
    /// Returns the artist name.
    /// </summary>
    /// <returns>The artist name.</returns>
    procedure GetArtistName(): Text
    begin
        exit(ArtistName);
    end;

    var
        ArtistName: Text;
}