ARG BASEDEV_VERSION=v0.25.0
ARG KUBECTL_VERSION=v1.29.1
ARG STERN_VERSION=v1.28.0
ARG KUBECTX_VERSION=v0.9.5
ARG KUBENS_VERSION=v0.9.5
ARG HELM_VERSION=v3.14.0

FROM qmcgaw/binpot:kubectl-${KUBECTL_VERSION} AS kubectl
FROM qmcgaw/binpot:stern-${STERN_VERSION} AS stern
FROM qmcgaw/binpot:kubectx-${KUBECTX_VERSION} AS kubectx
FROM qmcgaw/binpot:kubens-${KUBENS_VERSION} AS kubens
FROM qmcgaw/binpot:helm-${HELM_VERSION} AS helm

FROM qmcgaw/basedevcontainer:${BASEDEV_VERSION}-debian
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
WORKDIR /workspace

# Install Rust for the correct CPU architecture
ARG RUST_VERSION=1.76.0
ARG RUSTUP_INIT_VERSION=1.26.0
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN arch="$(uname -m)" && \
    case "$arch" in \
    x86_64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='0b2f6c8f85a3d02fde2efc0ced4657869d73fccfce59defb4e8d29233116e6db' ;; \
    aarch64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='673e336c81c65e6b16dcdede33f4cc9ed0f08bde1dbe7a935f113605292dc800' ;; \
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac && \
    wget -qO /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/${rustArch}/rustup-init" && \
    echo "${rustupSha256}  /tmp/rustup-init" | sha256sum -c - && \
    chmod +x /tmp/rustup-init && \
    /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION} --default-host ${rustArch} && \
    rm /tmp/rustup-init && \
    chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}

# Install:
# - gcc, libc6-dev required by Rust
# - musl-tools required for static binaries
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install --no-install-recommends gcc libc6-dev musl-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Rust tooling
ARG RUST_ANALYZER_VERSION=2024-02-05
RUN wget -qO- "https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-$(uname -m)-unknown-linux-gnu.gz" | \
    gunzip > /usr/local/bin/rust-analyzer && \
    chmod 500 /usr/local/bin/rust-analyzer
RUN rustup component add clippy rustfmt
RUN cargo install cargo-binstall

# Shell setup
COPY shell/.zshrc-specific shell/.welcome.sh /root/
RUN mkdir ~/.zfunc && rustup completions zsh > ~/.zfunc/_rustup

# Extra binary tools
COPY --from=kubectl /bin /usr/local/bin/kubectl
COPY --from=stern /bin /usr/local/bin/stern
COPY --from=kubectx /bin /usr/local/bin/kubectx
COPY --from=kubectx /bin /usr/local/bin/kubens
COPY --from=helm /bin /usr/local/bin/helm
