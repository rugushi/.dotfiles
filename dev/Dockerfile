FROM ubuntu:24.04@sha256:186072bba1b2f436cbb91ef2567abca677337cfc786c86e107d25b7072feef0c

ENV HOME=/root

WORKDIR ${HOME}

# Install curl first
RUN apt-get update && apt-get install -y curl build-essential xz-utils man-db openssh-server

# Install Nix (single-user mode)
RUN curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon

ENV PATH="/root/.nix-profile/bin:/root/.nix-profile/sbin:${PATH}"

# Copy packages and nixpkgs
COPY packages/packages.json .nix/packages.json
COPY packages/config.nix .config/nixpkgs/config.nix

# Copy default.nix that uses packages JSON
RUN nix-env -iA nixpkgs.packages

# Pre-build the environment to cache it
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Pre-build the environment to cache it
COPY zsh/.zshrc .zshrc

# Copy Zed server settings
COPY zed/settings.json .config/zed/settings.json

# Copy OpenCode settings
COPY opencode/ .config/opencode/

# Copy the script and ensure it's executable
COPY setup-and-run-ssh.sh setup-and-run-ssh.sh
RUN chmod +x setup-and-run-ssh.sh

# Create the .ssh dir now so we can mount/copy keys into it later
RUN mkdir -p .ssh && chmod 700 .ssh

EXPOSE 22

CMD ["/root/setup-and-run-ssh.sh"]
