{ lib, ... }:
{
  services.udev.extraRules = lib.mkAfter ''
    ACTION=="add|change", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
