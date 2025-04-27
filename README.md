# Fern MCP Installer

## Download

You can download the latest installer for MacOS from the releases page:

https://github.com/meetfern/fern-mcp/releases

## Terminal Installation

Alternatively, you can run the installer from the terminal with the command:

```sh
curl -fsSL https://raw.githubusercontent.com/meetfern/fern-mcp/main/scripts/install.sh | bash
```

## Features

The installer:

- Downloads the appropriate binary for running the Fern MCP bridge
- Installs it to `~/.fern/bin`
- Updates the `Library/Application Support/Claude/claude_desktop_config.json`
- Displays a success dialog box

## Development

### Prerequisites

- Install Rust (`brew install rustup` and `rustup-init`)
- Install `cargo-bundle` (`cargo install cargo-bundle`)

### Compile

Run:

```sh
make
```

This will:

- Build the `.app`
- Sign the `.app` (ad-hoc)
- Create the `.dmg`
- Sign the `.dmg` (ad-hoc)

Final output: `dist/fern-mcp-installer.dmg`
