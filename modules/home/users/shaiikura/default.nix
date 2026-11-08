{
  imports = [
    ./firefox.nix
  ];

  alexos.user = {
    profilePicture = "jpg";
    wallpaper = "wallhaven-2y7q2y.png";

    assets = {
      wallpapers = "1crgh0rmraj0jysshxw51v39982yh9qw2ynylvjvhnk65yg235bm";
      profile = "0kxjiyn0yh6fsijc0m6mscwy1vivi8pv7pixsbjx2idwwss6l30z";
    };

    obsidian.enable = true;
  };
}
