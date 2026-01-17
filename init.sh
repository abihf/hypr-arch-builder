pacman -Syu --noconfirm sudo nvim git clang lld

[ -f /etc/machine-id ] || systemd-machine-id-setup

if getent passwd hypr >/dev/null 2>&1; then
  echo "user 'hypr' already exists, skipping creation"
else
  mkdir -p /workspace/home
  useradd -u 1000 -d /workspace/home/ hypr
  chown hypr:hypr /workspace/home
fi

mkdir -p pkg repo src
chown hypr:hypr -R pkg repo src

# allow passwordless sudo for user hypr
mkdir -p /etc/sudoers.d
[ -f /etc/sudoers.d/hypr ] || echo "hypr ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/hypr
