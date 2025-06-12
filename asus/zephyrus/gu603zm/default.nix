{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../shared/backlight.nix
  ];

  hardware.nvidia = {
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = lib.mkDefault true;
    dynamicBoost.enable = lib.mkDefault true;
  };

  services = {
    asusd = {
      enable = lib.mkDefault true;
      enableUserService = lib.mkDefault true;
    };

    udev = {
      extraHwdb = ''
        evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
         KEYBOARD_KEY_ff31007c=f20    # Fix mic mute button
         KEYBOARD_KEY_ff3100b2=home   # Set Fn+LeftArrow as Home
         KEYBOARD_KEY_ff3100b3=end    # Set Fn+RightArrow as End
         KEYBOARD_KEY_7003f=print     # Set F6 as PrtSc
      '';
      # Disable auto-suspend for the ASUS N-KEY Device, i.e. USB Keyboard
      # Otherwise, it will tend to take 1-2 key-presses to wake-up after suspending
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{idVendor}=="0b05", ATTR{idProduct}=="19b6", ATTR{power/autosuspend}="-1"
      '';
    };
  };
}
