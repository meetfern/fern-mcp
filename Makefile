APP_NAME=Fern MCP Installer
BUNDLE_DIR=target/release/bundle/osx
DMG_OUT=dist/Fern-MCP-Installer.dmg
APP_PATH=$(BUNDLE_DIR)/$(APP_NAME).app

.PHONY: all deps bundle sign-app dmg sign-dmg clean release

all:
	make deps
	make bundle
	make sign-app
	make dmg
	make sign-dmg

deps:
	@which dmgbuild >/dev/null 2>&1 || { \
		if ! command -v pipx >/dev/null 2>&1; then \
			echo "pipx is required but not installed. Install it with: brew install pipx && pipx ensurepath"; \
			exit 1; \
		fi; \
		echo "Installing dmgbuild via pipx..."; \
		pipx install dmgbuild; \
	}

bundle:
	cargo build --release --target aarch64-apple-darwin
	cargo build --release --target x86_64-apple-darwin
	mkdir -p target/universal
	lipo -create \
		target/aarch64-apple-darwin/release/fern-mcp-installer \
		target/x86_64-apple-darwin/release/fern-mcp-installer \
		-output target/universal/fern-mcp-installer
	cargo bundle --release
	cp target/universal/fern-mcp-installer "$(APP_PATH)/Contents/MacOS/fern-mcp-installer"

sign-app:
ifdef SIGN_IDENTITY
	codesign --force --deep --sign "$(SIGN_IDENTITY)" "$(APP_PATH)"
endif

dmg:
	mkdir -p dist
	rm -f "$(DMG_OUT)"
	dmgbuild -s scripts/dmgbuild.py "$(APP_NAME)" "$(DMG_OUT)"

sign-dmg:
ifdef SIGN_IDENTITY
	codesign --force --sign "$(SIGN_IDENTITY)" "$(DMG_OUT)"
endif

clean:
	cargo clean
	rm -rf dist
	rm -rf target
	rm -f dist/*.dmg
	rm -f dist/*.temp.dmg

# Usage: make release version=v0.1.1
release:
	scripts/release.sh $(version)