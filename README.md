# Fern MCP Installer

## Download

You can download the latest installer from the release page. 

https://github.com/meetfern/fern-mcp/releases


## Local compilation


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

Final output: `dist/Fern-MCP-Installer.dmg`

### Cleaning Build Artifacts

```sh
make clean
```

## Running the Installer

- User opens the `.dmg`
- User double-clicks the installer `.app`
- Currently the app is unsigned so the user needs to enable it in system preferences

The installer:

- Downloads the appropriate binary
- Installs it to `~/.fern/bin`
- Updates the `Library/Application Support/Claude/claude_desktop_config.json`
- Displays a success dialog box


