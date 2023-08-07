function UpdatePlayer(PlayerType, ResourceId) {
    var spotifyPlayer = document.getElementById("spotify-player");
    spotifyPlayer.setAttribute('src', 'https://open.spotify.com/embed/' + PlayerType + '/' + ResourceId)
}