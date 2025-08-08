# NixOS Configuration

## prerequisites

- Ensure SSH keys are available at `/etc/ssh/wsl` & `/etc/ssh/wsl.pub`.

## WSL

1. Clone the repository
    ```bash
    nix-shell -p git home-manager
    mkdir -p "$HOME/.config/nix-config"
    git clone "https://github.com/BeeHiveJava/nix-config.git" "$HOME/.config/nix-config"
    ```

2. Install
    ```bash
    cd "$HOME/.config/nix-config"
    sh "deploy.sh"
    ```

3. Restart WSL
    ```PowerShell
    wsl --shutdown
    wsl -d "NixOS"
    ```

4. Move configuration to the correct user
    ```bash
    mkdir -p "$HOME/.config/nix-config"
    mv "/home/nixos/.config/nix-config" "$HOME/.config/nix-config"
    chown -R $(id -u):$(id -g) "$HOME/.config/nix-config"
    ```

5. Restart WSL (needed due to some bug in systemd)
    ```PowerShell
    wsl --shutdown
    wsl -d "NixOS"
    ```

6. Install again
    ```bash
    cd "$HOME/.config/nix-config"
    sh "deploy.sh"
    ```
