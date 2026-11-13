FROM mcr.microsoft.com/devcontainers/universal:linux@sha256:d7b342e610144566fdbe459a8d22322e3fffc511bf22b1083beea8d8f46d7c67

USER codespace
ENV HOME=/home/codespace
ENV PATH="/home/codespace/.local/bin:${PATH}"

RUN curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/install-codex.sh \
    && CODEX_NON_INTERACTIVE=1 sh /tmp/install-codex.sh \
    && rm /tmp/install-codex.sh \
    && codex --version
