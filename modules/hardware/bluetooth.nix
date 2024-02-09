{ pkgs, ... }:

{
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
