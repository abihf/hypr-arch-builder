#!/usr/bin/env bash
set -epuox pipefail

PKGS=(
  hyprutils-git
  hyprlang-git
  hyprland-protocols-git
  hyprwayland-scanner-git
  aquamarine-git
  hyprcursor-git
  hyprgraphics-git
  hyprtoolkit-git
  hyprland-guiutils-git
  hyprwire-git
  hyprland-git
  hypridle-git
  hyprlock-git
  hyprshutdown-git
  xdg-desktop-portal-hyprland-git
)

function get_pkg_file() {
  local pkgname="$1"
  version="$(pacman -Qi $pkgname | grep ^Version | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//')"
  echo "${pkgname}-${version}-x86_64.pkg.tar.zst"
}


files=()
pushd pkg
for pkg in "${PKGS[@]}"; do
  
    [ -d "${pkg}" ] || git clone --branch "${pkg}" --single-branch https://github.com/archlinux/aur.git "${pkg}"
    pushd "${pkg}"
    git restore .
    git pull || true
    makepkg -si --clean --noconfirm
    files+=("$(get_pkg_file "${pkg}")")
    popd
done
popd

pushd repo
rm -f hypr.db.tar.gz hypr.db
repo-add hypr.db.tar.gz "${files[@]}"
popd