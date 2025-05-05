{ pkgs, user, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
      OLLAMA_DEBUG = "1";
    };
  };
}
