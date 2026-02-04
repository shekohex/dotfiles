{ opencode }:
final: prev: {
  opencode = opencode.packages.${prev.stdenv.hostPlatform.system}.default;
}
