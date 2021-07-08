ARG KUBECTL_VERSION=v1.21.1
ARG STERN_VERSION=v1.18.0
ARG KUBECTX_VERSION=v0.9.4
ARG KUBENS_VERSION=v0.9.4
ARG HELM_VERSION=v3.6.2

FROM qmcgaw/binpot:kubectl-${KUBECTL_VERSION} AS kubectl
FROM qmcgaw/binpot:stern-${STERN_VERSION} AS stern
FROM qmcgaw/binpot:kubectx-${KUBECTX_VERSION} AS kubectx
FROM qmcgaw/binpot:kubens-${KUBENS_VERSION} AS kubens
FROM qmcgaw/binpot:helm-${HELM_VERSION} AS helm

FROM qmcgaw/basedevcontainer:alpine
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
    org.opencontainers.image.title="Rust Alpine Dev container" \
    org.opencontainers.image.description="Rust development container for Visual Studio Code Remote Containers development"
WORKDIR /workspace

# Install Rust for the correct CPU architecture
RUN apk add --no-cache wget && \
    wget -qO- https://sh.rustup.rs | sh -s -- -q -y
ENV PATH=/root/.cargo/bin:${PATH}
# Install gcc required by Rust
RUN apk add --no-cache gcc

# Install Rust tooling
ARG RUST_ANALYZER_VERSION=2021-06-14
RUN wget -qO- "https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-$(uname -m)-unknown-linux-musl.gz" | \
    gunzip > /usr/local/bin/rust-analyzer && \
    chmod 500 /usr/local/bin/rust-analyzer
RUN rustup component add clippy

# Shell setup
COPY shell/.zshrc-specific shell/.welcome.sh /root/
RUN mkdir ~/.zfunc && /root/.cargo/bin/rustup completions zsh > ~/.zfunc/_rustup

# Extra binary tools
COPY --from=kubectl /bin /usr/local/bin/kubectl
COPY --from=stern /bin /usr/local/bin/stern
COPY --from=kubectx /bin /usr/local/bin/kubectx
COPY --from=kubectx /bin /usr/local/bin/kubens
COPY --from=helm /bin /usr/local/bin/helm
