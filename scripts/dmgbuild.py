application = 'Fern MCP Installer.app'
volume_name = 'Fern MCP Installer'

files = ["target/release/bundle/osx/Fern MCP Installer.app"]

format = 'UDZO'

size = None  # Auto-size

icon_locations = {
    application: (100, 100),
}

window_rect = ((50, 50), (500, 280))  # (origin_x, origin_y), (width, height)
show_status_bar = False
show_tab_view = False
show_toolbar = False
show_pathbar = False

default_view = 'icon-view'
