# Fern MCP Installer Setup

## Prerequisites

- Install Rust (`brew install rustup` and `rustup-init`)
- Install `cargo-bundle` (`cargo install cargo-bundle`)
- Install `create-dmg` (`brew install create-dmg`)

## Building the Installer

```sh
make
```

This will:

- Build the `.app`
- Sign the `.app` (ad-hoc)
- Create the `.dmg`
- Sign the `.dmg` (ad-hoc)

Final output: `dist/Fern-MCP-Installer.dmg`

## Cleaning Build Artifacts

```sh
make clean
```

This removes:

- `target/`
- `dist/`

## How the Build Works

The `Makefile` automates:

1. `cargo bundle --release` — creates the `.app`
2. `codesign --force --deep --sign -` — signs the `.app`
3. `create-dmg` — packages the `.app` into a `.dmg`
4. `codesign --force --sign -` — signs the `.dmg`

## Running the Installer

- User opens the `.dmg`
- User double-clicks the installer `.app`

The installer:

- Downloads the appropriate binary
- Installs it to `~/.fern/bin`
- Updates the `Library/Application Support/Claude/claude_desktop_config.json`
- Displays a success dialog box

## Code Signing Details

The `.app` and `.dmg` are signed **ad-hoc**:

- No paid Apple Developer ID needed
- User still gets a prompt: "Are you sure you want to open this application?"
- No full notarization

**Important:** For full public distribution without macOS warnings, you would eventually need:

- Apple Developer ID
- Proper signing and notarization via `xcrun altool` and Apple Notary service
