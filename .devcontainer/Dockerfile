FROM mcr.microsoft.com/devcontainers/universal:linux@sha256:7d644a3e845e78e2175c9c265a383436c93ab740e77947bbcaff9592e39f7205

USER codespace
ENV HOME=/home/codespace
ENV PATH="/home/codespace/.local/bin:${PATH}"

RUN curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/install-codex.sh \
    && CODEX_NON_INTERACTIVE=1 sh /tmp/install-codex.sh \
    && rm /tmp/install-codex.sh \
    && codex --version
