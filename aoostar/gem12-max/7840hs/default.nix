{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/cpu/amd/raphael/igpu.nix
    ../../common/pc/ssd
  ];

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  boot.kernelParams =
    [
      # There seems to be an issue with panel self-refresh (PSR) that
      # causes hangs for users.
      #
      # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
      # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
      "amdgpu.dcdebugmask=0x10"
    ]
    # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
    ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") [
      "rtc_cmos.use_acpi_alarm=1"
    ];
}
