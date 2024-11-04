{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Shady Khalifa";
    userEmail = "dev+github@shadykhalifa.me";
    signing = {
      key = "280AC7E475B1C3C74233C3FF52DFAC81BEA54EAA";
      signByDefault = true;
    };
    ignores = [
      ".undodir/"
      ".idea/"
      ".vscode/"
      "Session.vim"
      "node_modules/"
      ".direnv/"
      ".env"
      "target/"
    ];
    difftastic = {
      enable = true;
      display = "side-by-side-show-both";
    };
    delta = {
      enable = false;
      options = {
        side-by-side = true;
      };
    };
    aliases = {
      co = "checkout";
      c = "commit";
      s = "status";
      l = "log";
      ll = "log --graph --decorate --pretty=oneline --abbrev-commit";
      d = "diff";
      ds = "diff --staged";
      b = "branch";
      bd = "branch -D";
      sw = "switch";
      swc = "switch -c";
      p = "pull";
      P = "push";
      f = "fetch";
    };
    extraConfig = {
      core = {
        editor = "vim";
      };
      init = {
        defaultBranch = "main";
      };
      branch = {
        autosetuprebase = "always";
      };
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };
}
