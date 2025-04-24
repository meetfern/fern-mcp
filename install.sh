#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)
OS=$(uname -s)

case "$OS-$ARCH" in
  Darwin-arm64) BIN="fern-mcp-bridge-darwin-arm64" ;;
  Darwin-x86_64) BIN="fern-mcp-bridge-darwin-amd64" ;;
  *) echo "Unsupported platform: $OS-$ARCH"; exit 1 ;;
esac

BIN_URL="https://github.com/meetfern/fern-mcp/raw/refs/heads/main/bin/$BIN"
INSTALL_DIR="$HOME/.fern/bin"
mkdir -p "$INSTALL_DIR"
TARGET="$INSTALL_DIR/fern-mcp-bridge"

curl -fsSL "$BIN_URL" -o "$TARGET"
chmod +x "$TARGET"

CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

python3 - "$CONFIG" "$TARGET" <<'PY'
import json, sys, pathlib, shutil
cfg=pathlib.Path(sys.argv[1]); bin=sys.argv[2]
data=json.loads(cfg.read_text()) if cfg.exists() else {}
data.setdefault("mcpServers",{})["fern"]={
 "command": bin,
 "args":[
  "--api-endpoint","http://api.meetfern.ai/mcp",
  "--auth-endpoint","http://auth.meetfern.ai",
  "--redirect-url","http://localhost:31310/auth"
 ]}
tmp=cfg.with_suffix(".tmp"); tmp.write_text(json.dumps(data,indent=2))
shutil.move(tmp,cfg)
PY

echo "Installed fern-mcp-bridge to $TARGET"
