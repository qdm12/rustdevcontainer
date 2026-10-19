# Rust Dev Container

Rust development container for Visual Studio Code

![Icon](https://github.com/qdm12/rustdevcontainer/raw/main/icon.svg)

[![Alpine](https://github.com/qdm12/rustdevcontainer/actions/workflows/alpine.yml/badge.svg)](https://github.com/qdm12/rustdevcontainer/actions/workflows/alpine.yml)
[![Debian](https://github.com/qdm12/rustdevcontainer/actions/workflows/debian.yml/badge.svg)](https://github.com/qdm12/rustdevcontainer/actions/workflows/debian.yml)

![Last Docker tag](https://img.shields.io/docker/v/qmcgaw/rustdevcontainer?sort=semver&label=Last%20Docker%20tag)
[![Latest size](https://img.shields.io/docker/image-size/qmcgaw/rustdevcontainer/latest?label=Latest%20image)](https://hub.docker.com/r/qmcgaw/rustdevcontainer/tags)

![Last release](https://img.shields.io/github/release/qdm12/rustdevcontainer?label=Last%20release)
[![Last release size](https://img.shields.io/docker/image-size/qmcgaw/rustdevcontainer?sort=semver&label=Last%20released%20image)](https://hub.docker.com/r/qmcgaw/rustdevcontainer/tags?page=1&ordering=last_updated)
![GitHub last release date](https://img.shields.io/github/release-date/qdm12/rustdevcontainer?label=Last%20release%20date)
![Commits since release](https://img.shields.io/github/commits-since/qdm12/rustdevcontainer/latest?sort=semver)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/commits/main)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/graphs/contributors)
[![GitHub closed PRs](https://img.shields.io/github/issues-pr-closed/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/pulls?q=is%3Apr+is%3Aclosed)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/issues?q=is%3Aissue+is%3Aclosed)

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=rustdevcontainer.readme)

## Features

- Rust 1.99.1
- Rust Analyzer 2026-10-12
- Clippy
- Rustfmt
- cargo-binstall 1.26.0, to install Rust command line tools from pre-compiled binaries rather than compiling them: `cargo binstall ripgrep cargo-watch`
- Alpine based with Docker tags `ghcr.io/qdm12/rustdevcontainer:latest` and `ghcr.io/qdm12/rustdevcontainer:alpine`
  - Compatible with `amd64` (2.1GB uncompressed image size)
  - Based on [qmcgaw/basedevcontainer:alpine](https://github.com/qdm12/basedevcontainer)
    - Based on Alpine 3.24
    - Minimal custom terminal and packages
    - See more [features](https://github.com/qdm12/basedevcontainer#features)
- Debian based with Docker tag `ghcr.io/qdm12/rustdevcontainer:debian`
  - Compatible with `amd64` (2.08GB uncompressed image size) and `arm64` (1.96GB uncompressed image size)
  - Based on [qmcgaw/basedevcontainer:debian](https://github.com/qdm12/basedevcontainer)
    - Based on Debian Trixie
    - Minimal custom terminal and packages
    - See more [features](https://github.com/qdm12/basedevcontainer#features)
- Runs as an unprivileged user (`user`, uid/gid `1000` by default, configurable), see [Non-root user](#non-root-user)
  - `apk` (Alpine) and `apt-get` (Debian) install packages from that user, no sudo involved
- Cross platform
  - Easily bind mount your SSH keys to use with **git**
  - Manage your host Docker from within the dev container, more details at [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer#features)
- Compatible with both the Docker and Podman engines
- Extensible with docker-compose.yml
- Comes with extra binary tools for a few extra MBs: `kubectl`, `kubectx`, `kubens`, `stern` and `helm`

Image sizes are the **uncompressed** ones, as reported by `podman image ls` or `docker image ls`. The compressed size transferred on a pull is roughly a third of that.

## Requirements

See [.devcontainer/README.md#Requirements](.devcontainer/README.md#Requirements)

## Setup for a project

1. Setup your configuration files
    - With style 💯

        ```sh
        docker run -it --rm -v "/yourrepopath:/repository" qmcgaw/devtainr:v0.2.0 -dev rust -path /repository -name projectname
        ```

        If you run on Linux not as root, run the `docker run` command with `--user="$(id -u):$(id -g)"`.

        Or use the [built binary](https://github.com/qdm12/devtainr#binary)
    - Or manually: download this repository and put the [.devcontainer](.devcontainer) directory in your project. It holds a `docker/` and a `podman/` configuration, pick the one matching your container engine.
1. If you have a *.vscode/settings.json*, eventually move the settings to *`.devcontainer/*/devcontainer.json`* in the `"settings"` section as *.vscode/settings.json* take precedence over the settings defined in *.devcontainer/*/devcontainer.json*.
1. Open the command palette in Visual Studio Code (CTRL+SHIFT+P) and select `Remote-Containers: Open Folder in Container...` and choose your project directory
1. See [.devcontainer/README.md#Setup](.devcontainer/README.md#Setup)

## Non-root user

The image runs using an unprivileged account `user`, created by the [base image](https://github.com/qdm12/basedevcontainer#non-root-user).

💁 In case you need root access, see [the root user section](#root-user)

The non root user is configurable with container build arguments, defined both in the Dockerfiles and in the devcontainer.json files:

| Build argument | Default | Description |
| --- | --- | --- |
| `USERNAME` | `user` | account name, home is `/home/$USERNAME`. Update the `"remoteUser"` key and mount targets in `devcontainer.json` to match this one if changed. |
| `GROUP_NAME` | `user` | name of the account's primary group |
| `USER_UID` | `1000` | user ID of the account |
| `USER_GID` | `1000` | group ID of the account's primary group (`$GROUP_NAME`) |
| `DOCKER_GID` | | create a `docker` group with this GID and put the account in it, to reach a rootful engine's socket, see [Container engine](.devcontainer/README.md#docker-engine) |

The unprivileged account:

- owns its home, `/usr/local/cargo` (its `CARGO_HOME`) and `/usr/local/rustup` (its `RUSTUP_HOME`), so it can install and remove packages without `sudo` or `doas`
- can write to a directory a package may add or remove a file in (`/usr/local/bin`, `/etc/ssl/certs`, `/var/log`...), which all belong to `$GROUP_NAME` and are group-writable.
- can only read and execute files installed in the container image and setup by the container engine
- cannot read `/root` and `/etc/shadow`

On system package management, note:

- it cannot replace a file the image already has installed, since those keep their root ownership
- for the Debian container, some packages have maintainer scripts that insist on running as root, and will fail to install (i.e. `dbus`); the fix is to finish the job as root for example `docker exec --user root <container-name> sh -c 'apt-get install -y dbus && dpkg --configure -a'`

## Root user

If you need to run a command as root, exec in the container using for example

```sh
docker exec --user root <container-name> command
```

Root has the same terminal setup as the unprivileged account, given its configuration files are symlinks into `/home/user`.
Note however that by default the zsh history and ssh files are not symlinked or copied from the unprivileged user to root.
The shell prints `Running as root` at startup, so you always know which account a terminal belongs to.

## Customization

See [.devcontainer/README.md#Customization](.devcontainer/README.md#Customization)

When you extend the image in a Dockerfile, the build runs as the unprivileged account: use `USER root` before instructions that do need root, and `USER user` to give it back.

### docker-compose.yml

You can create a `.devcontainer/docker-compose.yml` to create the devcontainer and other containers at the same time:

```yml
services:
  vscode: # configured in devcontainer.json
    build: .
  postgres: # example of a database container
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: password
```

And change the following in your relevant `devcontainer.json`:

- remove `"build": { "dockerfile": "../Dockerfile" },`
- add `"dockerComposeFile": "../docker-compose.yml",`
- add `"overrideCommand": true,`
- add `"service": "vscode",`
- add `"runServices": ["vscode", "postgres"],`

Finally, open the command palette in Visual Studio Code (CTRL+SHIFT+P) and select `Dev-Containers: Rebuild Container`

## License

This repository is under an [MIT license](https://github.com/qdm12/rustdevcontainer/main/LICENSE) unless indicated otherwise.
