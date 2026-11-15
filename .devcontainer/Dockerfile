FROM mcr.microsoft.com/devcontainers/base:trixie

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor \
    && apt-get clean

RUN install -d -o vscode -g vscode -m 700 \
    /home/vscode/.local/state/homelab \
    /home/vscode/.local/state/homelab/dogs \
    /home/vscode/.local/state/homelab/dogs/exchange \
    /home/vscode/.local/state/homelab/echoes \
    /home/vscode/.local/state/homelab/echoes/exchange
COPY platform/supervisord.conf /etc/homelab-supervisord.conf
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/homelab-supervisord.conf"]

USER vscode
ENV HOME=/home/vscode
ENV PATH="/home/vscode/.local/bin:${PATH}"

RUN curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/install-codex.sh \
    && CODEX_NON_INTERACTIVE=1 sh /tmp/install-codex.sh \
    && rm /tmp/install-codex.sh \
    && codex --version
