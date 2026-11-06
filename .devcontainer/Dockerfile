FROM mcr.microsoft.com/devcontainers/universal:linux

USER codespace
ENV HOME=/home/codespace
ENV PATH="/home/codespace/.local/bin:${PATH}"

RUN curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/install-codex.sh \
    && CODEX_NON_INTERACTIVE=1 sh /tmp/install-codex.sh \
    && rm /tmp/install-codex.sh \
    && codex --version
