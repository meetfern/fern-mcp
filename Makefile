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
	@which dmgbuild >/dev/null 2>&1 || { echo "Installing dmgbuild..."; pip3 install --user dmgbuild; }

bundle:
	cargo bundle --release

sign-app:
	codesign --force --deep --sign - "$(APP_PATH)"

dmg:
	mkdir -p dist
	rm -f "$(DMG_OUT)"
	dmgbuild -s scripts/dmgbuild.py "$(APP_NAME)" "$(DMG_OUT)"

sign-dmg:
	codesign --force --sign - "$(DMG_OUT)"

clean:
	cargo clean
	rm -rf dist
	rm -rf target
	rm -f dist/*.dmg
	rm -f dist/*.temp.dmg

release:
	scripts/release.sh $(VERSION)