FROM mcr.microsoft.com/devcontainers/base:trixie@sha256:41ff7ce12ec45f2704f27a6e091831186ad922ec8112e6339425bfefdf5a70f9 AS base

USER vscode
ENV HOME=/home/vscode
ENV PATH="/home/vscode/.local/bin:${PATH}"

RUN curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/install-codex.sh \
    && CODEX_NON_INTERACTIVE=1 sh /tmp/install-codex.sh \
    && rm /tmp/install-codex.sh \
    && codex --version

FROM base AS development

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v1.4.2
