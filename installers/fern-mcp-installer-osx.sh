#!/usr/bin/env bash
set -euo pipefail
REPO_BASE="https://raw.githubusercontent.com/meetfern/fern-mcp/main/bin"
ARCH="$(uname -m)"
case "$ARCH" in
  arm64) BIN_NAME="fern-exograph-mcp-bridge-darwin-arm64" ;;
  x86_64) BIN_NAME="fern-exograph-mcp-bridge-darwin-amd64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac
TARGET_DIR="$HOME/.fern/bin"
mkdir -p "$TARGET_DIR"
TARGET="$TARGET_DIR/fern-exograph-mcp-bridge"
curl -fsSL "$REPO_BASE/$BIN_NAME" -o "$TARGET"
chmod +x "$TARGET"
CONFIG_PATH="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
python3 - "$CONFIG_PATH" "$TARGET" <<'PY'
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
echo "Done"
