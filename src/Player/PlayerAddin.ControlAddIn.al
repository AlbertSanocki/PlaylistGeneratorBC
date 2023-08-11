/// <summary>
/// controladdin that allows to play 30 sec sample of the songs
/// </summary>
controladdin PlayerAddin
{
    RequestedHeight = 250;
    MaximumHeight = 250;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    StartupScript = 'src\Player\Startup.js';
    Scripts = 'src\Player\Scripts.js';

    procedure UpdatePlayer(PlayerType: Text; ResourceId: Text)
}