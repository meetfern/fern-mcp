#!/bin/bash

set -e

# Terminal colors
BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BOLD}${BLUE}Fern MCP Installer${RESET}"
echo -e "Downloading the Fern MCP installer..."

# Create a temporary file
TMP_FILE=$(mktemp /tmp/fern-mcp-installer.XXXXXX)
trap 'rm -f $TMP_FILE' EXIT

# Download the latest installer binary
echo -e "Fetching from GitHub releases..."
DOWNLOAD_URL="https://github.com/meetfern/fern-mcp/releases/latest/download/fern-mcp-installer"
if ! curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"; then
    echo -e "${RED}Error: Failed to download the installer.${RESET}"
    echo "Please check your internet connection and try again."
    exit 1
fi

# Make it executable
chmod +x "$TMP_FILE"

echo -e "${GREEN}Download complete!${RESET}"
echo "Running the installer..."
echo ""

# Run the installer
"$TMP_FILE"

# Success message
echo ""
echo -e "${GREEN}Installation complete!${RESET}"
echo "Fern MCP has been successfully installed on your system." 