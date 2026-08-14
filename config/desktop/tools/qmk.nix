{ pkgs, ... }:

{
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.vial ];
  hm.home.packages = with pkgs; [ qmk vial dos2unix ];
}
