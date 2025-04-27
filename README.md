# Fern MCP Installer

## Download

You can download the latest installer from the releases page:

https://github.com/meetfern/fern-mcp/releases

## Terminal Installation

You can install Fern MCP directly from the terminal using the following command:

```sh
curl -fsSL https://raw.githubusercontent.com/meetfern/fern-mcp/main/scripts/install.sh | bash
```

Or you can download and run the binary directly:

```sh
curl -fsSL https://github.com/meetfern/fern-mcp/releases/latest/download/fern-mcp-installer -o /tmp/fern-mcp-installer && chmod +x /tmp/fern-mcp-installer && /tmp/fern-mcp-installer
```

## Running the Installer

- Open the downloaded `.dmg`
- Open the installer app
- Currently the app is unsigned so it needs to be enabled via system preferences

The installer:

- Downloads the appropriate binary for running the Fern MCP bridge
- Installs it to `~/.fern/bin`
- Updates the `Library/Application Support/Claude/claude_desktop_config.json`
- Displays a success dialog box

## Building locally

### Prerequisites

- Install Rust (`brew install rustup` and `rustup-init`)
- Install `cargo-bundle` (`cargo install cargo-bundle`)

### Build

```sh
make
```

This will:

- Build the `.app`
- Sign the `.app` (ad-hoc)
- Create the `.dmg`
- Sign the `.dmg` (ad-hoc)

Final output: `dist/fern-mcp-installer.dmg`

### Cleaning Build Artifacts

```sh
make clean
```
