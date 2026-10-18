ARG BASEDEV_VERSION=v0.30.0
ARG KUBECTL_VERSION=v1.35.3
ARG STERN_VERSION=v1.33.1
ARG KUBECTX_VERSION=v0.11.0
ARG KUBENS_VERSION=v0.11.0
ARG HELM_VERSION=v4.1.3

FROM ghcr.io/qdm12/binpot:kubectl-${KUBECTL_VERSION} AS kubectl
FROM ghcr.io/qdm12/binpot:stern-${STERN_VERSION} AS stern
FROM ghcr.io/qdm12/binpot:kubectx-${KUBECTX_VERSION} AS kubectx
FROM ghcr.io/qdm12/binpot:kubens-${KUBENS_VERSION} AS kubens
FROM ghcr.io/qdm12/binpot:helm-${HELM_VERSION} AS helm

FROM ghcr.io/qdm12/basedevcontainer:${BASEDEV_VERSION}-debian
ARG CREATED
ARG COMMIT
ARG VERSION=local
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$CREATED \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$COMMIT \
    org.opencontainers.image.url="https://github.com/qdm12/rustdevcontainer" \
    org.opencontainers.image.documentation="https://github.com/qdm12/rustdevcontainer" \
    org.opencontainers.image.source="https://github.com/qdm12/rustdevcontainer" \
    org.opencontainers.image.title="Rust Debian Dev container" \
    org.opencontainers.image.description="Rust development container for Visual Studio Code Remote Containers development"
# The base image creates and runs an unprivileged account (uid/gid 1000 by default,
# named `user`). These build arguments mirror it so the paths below follow the account
# you build with: keep them in sync with the "remoteUser" key and the mount targets in
# devcontainer.json.
ARG USERNAME=user
ARG GROUP_NAME=user
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_HOME=/home/${USERNAME}

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
WORKDIR /workspace

# Only this block needs root, the rest of the build runs as the unprivileged account,
# like the container does.
USER root
# Group ID of the `docker` group on the host, needed to open a rootful engine's
# /var/run/docker.sock. The published base image has no such group, so create it here.
# Left empty, the group is not created. Alternatively pass
# --group-add=$(stat -c %g /var/run/docker.sock) to the container, no rebuild needed.
ARG DOCKER_GID=
RUN set -eux && \
    if [ -n "${DOCKER_GID}" ] && ! grep -q "^docker:" /etc/group; then \
    groupadd -g "${DOCKER_GID}" docker && \
    usermod -aG docker "${USERNAME}"; \
    fi

# Install Rust for the correct CPU architecture
ARG RUST_VERSION=1.99.1
ARG RUSTUP_INIT_VERSION=1.29.1
RUN arch="$(uname -m)" && \
    case "$arch" in \
    x86_64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='dda7234360b7f578ca8b0ddcb80145646fa61a67c1720a5abc7051b35c9fcb71' ;; \
    aarch64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='15f6e4ce9f583b929c996c91562bad6d4454f3281de858b02cdfdef615fac433' ;; \
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac && \
    wget -qO /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/${rustArch}/rustup-init" && \
    echo "${rustupSha256}  /tmp/rustup-init" | sha256sum -c - && \
    chmod +x /tmp/rustup-init && \
    /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION} --default-host ${rustArch} && \
    rm /tmp/rustup-init && \
    chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME} && \
    # The unprivileged account builds into these two directories (rustup components,
    # cargo install), so it owns them.
    chown -R "${USER_UID}:${USER_GID}" ${RUSTUP_HOME} ${CARGO_HOME}

# Install:
# - gcc, libc6-dev required by Rust
# - musl-tools required for static binaries
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install --no-install-recommends gcc libc6-dev musl-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Rust tooling
ARG RUST_ANALYZER_VERSION=2026-10-12
RUN wget -qO- "https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-$(uname -m)-unknown-linux-gnu.gz" | \
    gunzip > /usr/local/bin/rust-analyzer && \
    chmod 755 /usr/local/bin/rust-analyzer
USER ${USERNAME}

RUN rustup component add clippy rustfmt
RUN cargo install cargo-binstall

# Shell setup
COPY --chown="${USER_UID}:${USER_GID}" --chmod=644 shell/.zshrc-plugins shell/.welcome.sh ${USER_HOME}/
RUN mkdir ~/.zfunc && rustup completions zsh > ~/.zfunc/_rustup

# Extra binary tools
COPY --chown="${USER_UID}:${USER_GID}" --from=kubectl /bin /usr/local/bin/kubectl
COPY --chown="${USER_UID}:${USER_GID}" --from=stern /bin /usr/local/bin/stern
COPY --chown="${USER_UID}:${USER_GID}" --from=kubectx /bin /usr/local/bin/kubectx
COPY --chown="${USER_UID}:${USER_GID}" --from=kubectx /bin /usr/local/bin/kubens
COPY --chown="${USER_UID}:${USER_GID}" --from=helm /bin /usr/local/bin/helm
