# NixOS Configuration

## Applying Configuration

### Cloning (first time only)

```bash
nix-shell -p git home-manager
mkdir -p "$HOME/.config/nix-config"
git clone "https://github.com/BeeHiveJava/nix-config.git" "$HOME/.config/nix-config"
```

### Updating

#### Everything

```bash
git pull --rebase && sh "nixos.sh"
```

### System only

```bash
git pull --rebase && sh "nixos-system.sh"
```

### Home-Manager only

```bash
git pull --rebase && sh "nixos-home.sh"
```

## WSL

1. Follow steps from [nix-community/NixOS-WSL](https://github.com/nix-community/NixOS-WSL) and install NixOS.
2. Update to latest channels:
    ```bash
    sudo nix-channel --add "https://nixos.org/channels/nixos-24.05" "nixos"
    sudo nix-channel --update
    sudo nixos-rebuild switch
    ```
3. Take ownership of runtime directory:
    ```bash
    sudo chown -R "$UID:$UID" "/run/user/$UID/"
    ```
4. Restart NixOS:
    ```PowerShell
    wsl -t "NixOS"
    wsl -d "NixOS"
    ```
