{ lib, config, ... }:

{
  imports = [ ./. ];

  hardware.nvidia.prime = {
    reverseSync.enable = lib.mkOverride 990 true;
    offload.enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.reverseSync.enable true; # Provides `nvidia-offload` command.
    # Hardware should specify the bus ID for intel/nvidia devices
  };
}
