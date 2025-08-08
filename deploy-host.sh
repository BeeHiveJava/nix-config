#!/bin/sh

sudo chown -R "$UID:$UID" "/run/user/$UID/"
sudo nixos-rebuild switch --flake .#nixos
