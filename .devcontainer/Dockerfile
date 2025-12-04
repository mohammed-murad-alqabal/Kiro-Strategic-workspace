# [اسم_فريق_التطوير] Kiro Workspace Base Image
# This Dockerfile is used by devcontainer.json to ensure a consistent development environment.

FROM mcr.microsoft.com/devcontainers/universal:latest

# Install Kiro-specific tools (Mocking the installation of Kiro CLI, Snyk, Trivy, etc.)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    # Install tools for IaC scanning and security checks
    curl \
    jq \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies for the bootstrap script
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Set the default user to 'vscode' as defined in devcontainer.json
USER vscode
