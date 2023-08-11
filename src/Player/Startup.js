init();

function init() {
    var controlAddInDiv = document.getElementById(getControlAddInDivId());
    var SpotifyPlayer = document.createElement("iframe");
    SpotifyPlayer.setAttribute('id', 'spotify-player');
    SpotifyPlayer.setAttribute('width', '100%');
    SpotifyPlayer.setAttribute('height', '120%');
    SpotifyPlayer.setAttribute('frameborder', '0');
    SpotifyPlayer.setAttribute('allowtransparency', 'true');
    SpotifyPlayer.setAttribute('allow', 'encrypted-media');
    controlAddInDiv.appendChild(SpotifyPlayer);
}

function getControlAddInDivId() {
    return 'controlAddIn';
}