/// <summary>
/// Page 50100 "ITI Artists"
/// This page displays a list of artists from the "ITI Artist" table. It allows users to load the 100 most viewed artists from Spotify and create records for them, as well as create a playlist from the top artists.
/// </summary>
page 50100 "ITI Spotify Artists"
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
            repeater(Artists)
            {
                field("Artist Name"; Rec."Artist Name")
                {
                    ToolTip = 'Specifies the artist name';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
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

                begin
                    Rec.CreateArtist();
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Player.UpdatePlayer('artist', Rec."Artist ID");
    end;


}