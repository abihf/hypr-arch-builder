# Hyprland Build Repository

A containerized build system for Hyprland and its ecosystem packages on Arch Linux. This repository automatically builds and maintains a custom Arch package repository for Hyprland and all related components from their git sources.

## Overview

This repository provides a Docker-based build environment that:

- Builds Hyprland and its entire ecosystem from AUR git packages
- Creates a custom Arch Linux package repository
- Handles all build dependencies automatically
- Maintains a local package cache for faster rebuilds

## Packages Built

The following packages are built in dependency order:

- **hyprutils-git** - Hyprland utilities library
- **hyprlang-git** - Hyprland configuration language library
- **hyprland-protocols-git** - Wayland protocol extensions for Hyprland
- **hyprwayland-scanner-git** - Wayland protocol scanner
- **aquamarine-git** - Rendering backend library
- **hyprcursor-git** - Cursor management library
- **hyprgraphics-git** - Graphics utilities
- **hyprtoolkit-git** - Toolkit library
- **hyprland-guiutils-git** - GUI utilities
- **hyprwire-git** - Wire protocol implementation
- **hyprland-git** - Hyprland compositor (main package)
- **hypridle-git** - Idle management daemon
- **hyprlock-git** - Screen locker
- **hyprshutdown-git** - Shutdown utilities
- **xdg-desktop-portal-hyprland-git** - XDG Desktop Portal backend

## Prerequisites

- Docker or Podman
- Docker Compose

## Usage

### Building Packages

Build all packages using Docker Compose:

```bash
docker compose up
```

### Manual Build

To run the build manually inside the container:

```bash
docker compose run --rm builder bash
./init.sh
sudo -u hypr bash build.sh
```

## Repository Structure

```
.
├── build.sh              # Main build script
├── init.sh               # Container initialization script
├── run.sh                # Convenience wrapper for Docker builds
├── compose.yml           # Docker Compose configuration
├── makepkg.conf          # Custom makepkg configuration
├── cache/                # Package cache directory
├── home/                 # Build user home directory
├── pkg/                  # AUR package sources (PKGBUILD files)
├── repo/                 # Built packages and repository database
└── src/                  # Source code directories
```

## Using the Repository

After building, the packages are available in the `repo/` directory. To use this repository on your Arch Linux system:

1. Copy the repository to a web-accessible location or local path
2. Add to `/etc/pacman.conf`:

```ini
[hypr]
SigLevel = Optional TrustAll
Server = file:///path/to/repo
```

3. Update and install:

```bash
sudo pacman -Sy
sudo pacman -S hyprland-git
```

## How It Works

1. **Initialization** (`init.sh`):
   - Updates the base Arch Linux container
   - Installs build dependencies
   - Creates a non-root build user
   - Sets up directory structure

2. **Building** (`build.sh`):
   - Clones/updates AUR packages for each component
   - Builds packages in dependency order using `makepkg`
   - Installs built packages to satisfy dependencies
   - Collects all built packages

3. **Repository Creation**:
   - Uses `repo-add` to create the package database
   - Generates `hypr.db.tar.gz` and `hypr.files.tar.gz`

## Configuration

### Custom makepkg.conf

The repository uses a custom `makepkg.conf` that can be modified to adjust:
- Compiler flags
- Compression settings
- Build parallelism
- Package output directory

### Cache Directory

The `cache/` directory is mounted as `/var/cache/pacman/` to speed up subsequent builds by caching downloaded dependencies.

## Development

### Adding New Packages

To add a new package to the build:

1. Add the package name to the `PKGS` array in [build.sh](build.sh)
2. Ensure it's added in the correct dependency order
3. The package will be automatically cloned from AUR and built

### Rebuilding Single Packages

To rebuild a specific package:

```bash
docker compose run --rm builder bash
./init.sh
sudo -u hypr bash
cd pkg/hyprland-git
makepkg -si --clean --noconfirm
```

## Troubleshooting

### Build Failures

- Check that packages are in correct dependency order
- Ensure the base image is up to date: `docker compose pull`
- Clear the cache if dependency issues occur: `rm -rf cache/pkg/*`

### Permission Issues

The build runs as user `hypr` (UID 1000) inside the container. Ensure your host user has permissions to write to the mounted directories.

## License

This build system is provided as-is. Individual packages maintain their own licenses as specified in their respective AUR repositories.

## Contributing

Contributions are welcome! Please:

1. Test your changes in a clean environment
2. Ensure all packages build successfully
3. Update documentation as needed

## Links

- [Hyprland Official Website](https://hyprland.org/)
- [Hyprland GitHub](https://github.com/hyprwm/Hyprland)
- [Arch User Repository](https://aur.archlinux.org/)
