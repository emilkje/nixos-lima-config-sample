{ config, pkgs, ... }:

{
    imports =
    [
      ./hardware-configuration.nix
    ];

    networking.hostName = "dev";

    # TODO: Consider setting some/all of the mandatory settings in `nixos-lima.nixosModules.lima`

    # Enable lima-init, lima-guestagent, other config needed for Lima support (via `nixos-lima.nixosModules.lima`)
    services.lima.enable = true;

    # Using Flakes is highly-recommended, maybe even required.
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # ssh
    services.openssh.enable = true;

    # pkgs
    environment = {
        systemPackages = with pkgs; [ vim ];
        shells = with pkgs; [ zsh ];
    };

    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    security = {
        sudo.wheelNeedsPassword = false;
    };

    boot.loader.grub = {
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
    };
}
