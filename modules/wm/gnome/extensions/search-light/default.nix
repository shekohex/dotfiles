{ lib, pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "gnome-shell-extension-search-light";
  version = "git-unstable-12";

  src = pkgs.fetchFromGitHub {
    owner = "icedman";
    repo = "search-light";
    rev = "ac917961efa9b4aa203748072d7acb1ae144fc24";
    sha256 = "sha256-eSQ562tNFSkIJdyWNsaYrpJQS20o+j8LpKIzn6vAc6U=";
  };

  buildInputs = [
    pkgs.glib
  ];

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/search-light@icedman.github.com
    cp -R ./* "$out/share/gnome-shell/extensions/search-light@icedman.github.com/"
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "search-light@icedman.github.com";
    extensionPortalSlug = "search-light";
  };

  meta = with lib; {
    description = "Take the apps search out of overview";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    homepage = "https://github.com/icedman/search-light";
  };
}
