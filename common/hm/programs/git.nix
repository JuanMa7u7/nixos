{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "JuanMa7u7";
        email = "jmlafuente97@gmail.com";
      };
      push = { autoSetupRemote = true; };
      pull = { rebase = false; };
    };
    lfs.enable = true;
  };
}
