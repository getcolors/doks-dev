{ pkgs, ... }:
{
  languages.clojure.enable = true;
  languages.opentofu.enable = true;
  packages = with pkgs; [ babashka bun uv curl jq kubectl ];
}
