FROM debian:bullseye-slim

# Install necessary packages including Node.js and npm
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    curl \
    git \
    gnupg \
    python3 \
    python3-pip \
    software-properties-common \
    wget \
    && curl -fsSL https://deb.nodesource.com/setup_current.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends dotnet-sdk-9.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verify Node.js, npm and dotnet installation
RUN node --version && npm --version && dotnet --version

# Install Claude Code globally
RUN npm config set prefix /usr/local/share/npm-global \
    && npm install -g @anthropic-ai/claude-code

# Add npm global bin to PATH
ENV PATH="/usr/local/share/npm-global/bin:${PATH}"

# Set working directory
WORKDIR /workspace

# Keep container running
CMD ["/bin/bash"]