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
      ".local_session.nvim"
      "node_modules/"
    ];
    difftastic = {
      enable = true;
    };
    extraConfig = {
      core = {
        editor = "nvim";
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
