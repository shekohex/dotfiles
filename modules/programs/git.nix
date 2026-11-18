{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs = {
      enable = true;
      skipSmudge = false;
    };
    signing = {
      key = "F9F2447AD04C829791F1DE20987ED27840ED60F5";
      signByDefault = true;
    };
    ignores = [
      ".undodir/"
      ".idea/"
      ".vscode/"
      ".zed/"
      ".DS_Store"
      "Session.vim"
      "node_modules/"
      ".direnv/"
      ".composer/"
      ".env"
      "target/"
      "vendor/"
      "dist/"
    ];
    settings = {
      user = {
        name = "Shady Khalifa";
        email = "dev+github@shadykhalifa.me";
      };
      alias = {
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
      core = {
        editor = "vim";
      };
      init = {
        defaultBranch = "main";
      };
      branch = {
        autosetuprebase = "always";
      };
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };
}
