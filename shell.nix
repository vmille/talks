{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = [ pkgs.git pkgs.nodejs pkgs.jetbrains.webstorm ];
  shellHook = ''
    npm install @marp-team/marp-cli
    '';
}
