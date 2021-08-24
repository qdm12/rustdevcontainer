# Rust Dev Container

Rust development container for Visual Studio Code

![Icon](https://github.com/qdm12/rustdevcontainer/raw/main/icon.svg)

[![Alpine](https://github.com/qdm12/rustdevcontainer/actions/workflows/alpine.yml/badge.svg)](https://github.com/qdm12/rustdevcontainer/actions/workflows/alpine.yml)
[![Debian](https://github.com/qdm12/rustdevcontainer/actions/workflows/debian.yml/badge.svg)](https://github.com/qdm12/rustdevcontainer/actions/workflows/debian.yml)

[![dockeri.co](https://dockeri.co/image/qmcgaw/rustdevcontainer)](https://hub.docker.com/r/qmcgaw/rustdevcontainer)

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

[![Lines of code](https://img.shields.io/tokei/lines/github/qdm12/rustdevcontainer)](https://github.com/qdm12/rustdevcontainer)
![Code size](https://img.shields.io/github/languages/code-size/qdm12/rustdevcontainer)
![GitHub repo size](https://img.shields.io/github/repo-size/qdm12/rustdevcontainer)

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=rustdevcontainer.readme)

## Features

- Rust 1.54
- Rust Analyzer 2021-08-23
- Clippy
- Alpine based with Docker tags `:latest` and `:alpine`
  - 1.19GB amd64 uncompressed image size
  - Compatible with `amd64`
  - Based on [qmcgaw/basedevcontainer:alpine](https://github.com/qdm12/basedevcontainer)
    - Based on Alpine 3.14
    - Minimal custom terminal and packages
    - See more [features](https://github.com/qdm12/basedevcontainer#features)
- Debian based with Docker tag `:debian` (1.51GB, based on [qmcgaw/basedevcontainer:debian](https://github.com/qdm12/basedevcontainer))
  - 1.1GB amd64 uncompressed image size
  - Compatible with `amd64` and `arm64`
  - Based on [qmcgaw/basedevcontainer:debian](https://github.com/qdm12/basedevcontainer)
    - Based on Debian Buster slim
    - Minimal custom terminal and packages
    - See more [features](https://github.com/qdm12/basedevcontainer#features)
- Cross platform
  - Easily bind mount your SSH keys to use with **git**
  - Manage your host Docker from within the dev container, more details at [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer#features)
- Extensible with docker-compose.yml
- Comes with extra binary tools for a few extra MBs: `kubectl`, `kubectx`, `kubens`, `stern` and `helm`

## Requirements

See [.devcontainer/README.md#Requirements](.devcontainer/README.md#Requirements)

## Setup for a project

1. Setup your configuration files
    - With style 💯

        ```sh
        docker run -it --rm -v "/yourrepopath:/repository" qmcgaw/devtainr:v0.2.0 -dev rust -path /repository -name projectname
        ```

        Or use the [built binary](https://github.com/qdm12/devtainr#binary)
    - Or manually: download this repository and put the [.devcontainer](.devcontainer) directory in your project.
1. If you have a *.vscode/settings.json*, eventually move the settings to *.devcontainer/devcontainer.json* in the `"settings"` section as *.vscode/settings.json* take precedence over the settings defined in *.devcontainer/devcontainer.json*.
1. Open the command palette in Visual Studio Code (CTRL+SHIFT+P) and select `Remote-Containers: Open Folder in Container...` and choose your project directory
1. See [.devcontainer/README.md#Setup](.devcontainer/README.md#Setup)

## Customization

See [.devcontainer/README.md#Customization](.devcontainer/README.md#Customization)

## License

This repository is under an [MIT license](https://github.com/qdm12/rustdevcontainer/main/LICENSE) unless indicated otherwise.
