APP_NAME=Fern MCP Installer
BUNDLE_DIR=target/release/bundle/osx
DMG_OUT=dist/Fern-MCP-Installer.dmg

.PHONY: all bundle sign-app dmg sign-dmg clean

all: bundle sign-app dmg sign-dmg

bundle:
	cargo bundle --release

sign-app:
	codesign --force --deep --sign - "$(BUNDLE_DIR)/$(APP_NAME).app"

dmg:
	mkdir -p dist
	rm -f "$(DMG_OUT)"
	create-dmg \
		--volname "$(APP_NAME)" \
		--window-pos 200 120 \
		--window-size 600 400 \
		--icon-size 100 \
		--icon "$(APP_NAME).app" 250 150 \
		"$(DMG_OUT)" \
		"$(BUNDLE_DIR)"

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