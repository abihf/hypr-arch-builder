#!/usr/bin/env bash

set -epuox pipefail

PKG_NAME="${1}"

cd "pkg/${PKG_NAME}"
makepkg --nobuild
source PKGBUILD
echo "$(pkgver)"
