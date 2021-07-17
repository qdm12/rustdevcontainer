# Rust Dev Container

**Rust development container for Visual Studio Code**

![Icon](https://github.com/qdm12/rustdevcontainer/raw/main/icon.svg)

[![CI](https://github.com/qdm12/rustdevcontainer/actions/workflows/ci.yml/badge.svg)](https://github.com/qdm12/rustdevcontainer/actions/workflows/ci.yml)

[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/rustdevcontainer.svg)](https://hub.docker.com/r/qmcgaw/rustdevcontainer)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/rustdevcontainer.svg)](https://hub.docker.com/r/qmcgaw/rustdevcontainer)
[![Image size](https://images.microbadger.com/badges/image/qmcgaw/rustdevcontainer.svg)](https://microbadger.com/images/qmcgaw/rustdevcontainer)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/rustdevcontainer.svg)](https://microbadger.com/images/qmcgaw/rustdevcontainer)

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=rustdevcontainer.readme)
[![Join Slack channel](https://img.shields.io/badge/slack-@qdm12-yellow.svg?logo=slack)](https://join.slack.com/t/qdm12/shared_invite/enQtOTE0NjcxNTM1ODc5LTYyZmVlOTM3MGI4ZWU0YmJkMjUxNmQ4ODQ2OTAwYzMxMTlhY2Q1MWQyOWUyNjc2ODliNjFjMDUxNWNmNzk5MDk)
[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/rustdevcontainer.svg)](https://github.com/qdm12/rustdevcontainer/issues)

## Features

- Rust 1.52.1
- Rust Analyzer 2021-06-14
- Clippy
- Relatively small: 1.46GB (amd64 image size)
- Based on [qmcgaw/basedevcontainer:alpine](https://github.com/qdm12/basedevcontainer)
    - Based on Alpine 3.14
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
