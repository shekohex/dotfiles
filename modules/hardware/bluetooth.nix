{ pkgs, ... }:

{
  # 0.5.17 can restore A2DP during HFP capture, leaving Bluetooth nodes in error.
  # Keep this scoped to the daemon; avoid rebuilding GNOME's library consumers.
  services.pipewire.wireplumber.package = pkgs.wireplumber.overrideAttrs (_: {
    version = "0.5.18";
    src = pkgs.fetchFromGitHub {
      owner = "PipeWire";
      repo = "wireplumber";
      rev = "81606cbb32d29df20147d1b68b662c1082654d81";
      hash = "sha256-VIa11ynYJsr4zqZ7XogPin4Ks0oEDltCjo51aWVMH8c=";
    };
  });

  hardware.bluetooth = {
    enable = true;
    #hsphfpd.enable = true;         # HSP & HFP daemon
    settings = {
      General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}
