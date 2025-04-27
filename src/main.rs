use std::env;
use std::fs;
use std::io::Write;
use std::os::unix::fs::PermissionsExt;
use reqwest::blocking::get;
use serde_json::{json, Value};
use rfd::{MessageDialog, MessageLevel};

fn exit_with_error(title: &str, description: &str) -> ! {
    MessageDialog::new()
        .set_level(MessageLevel::Error)
        .set_title(title)
        .set_description(description)
        .show();
    std::process::exit(1);
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let arch = match env::consts::ARCH {
        "aarch64" => "arm64",
        "x86_64" => "amd64",
        _ => exit_with_error(
            "Unsupported Platform",
            &format!("Unsupported platform: {}-{}", env::consts::OS, env::consts::ARCH)
        ),
    };

    let os = match env::consts::OS {
        "macos" => "darwin",
        _ => exit_with_error(
            "Unsupported Platform",
            &format!("Unsupported platform: {}-{}", env::consts::OS, env::consts::ARCH)
        ),
    };

    let bin_name = format!("fern-mcp-bridge-{}-{}", os, arch);
    let bin_url = format!("https://github.com/meetfern/fern-mcp/raw/refs/heads/main/bin/{}", bin_name);

    let install_dir = dirs::home_dir()
        .expect("Could not find home directory")
        .join(".fern/bin");
    fs::create_dir_all(&install_dir)?;
    let target_path = install_dir.join("fern-mcp-bridge");

    let mut resp = get(&bin_url)?;
    if !resp.status().is_success() {
        exit_with_error(
            "Download Failed",
            &format!("Failed to download binary from {}", bin_url)
        );
    }
    let mut out = fs::File::create(&target_path)?;
    std::io::copy(&mut resp, &mut out)?;
    let mut perms = out.metadata()?.permissions();
    perms.set_mode(0o755);
    fs::set_permissions(&target_path, perms)?;

    let config_path = dirs::home_dir()
        .expect("Could not find home directory")
        .join("Library/Application Support/Claude/claude_desktop_config.json");

    if !config_path.parent().unwrap().exists() {
        exit_with_error(
            "Claude Desktop Not Found",
            "The Claude Desktop configuration directory was not found. Are you sure Claude Desktop is installed?"
        );
    }

    let mut config: Value = if config_path.exists() {
        serde_json::from_str(&fs::read_to_string(&config_path)?)?
    } else {
        json!({})
    };

    config["mcpServers"]["fern"] = json!({
        "command": target_path.to_string_lossy(),
        "args": [
            "--api-endpoint", "https://api.meetfern.ai/mcp",
            "--auth-endpoint", "https://app.meetfern.ai/v1/mcp/login",
            "--redirect-url", "http://localhost:31310/auth"
        ]
    });

    let tmp_path = config_path.with_extension("tmp");
    let mut tmp_file = fs::File::create(&tmp_path)?;
    tmp_file.write_all(serde_json::to_string_pretty(&config)?.as_bytes())?;
    fs::rename(tmp_path, config_path)?;

    MessageDialog::new()
        .set_level(MessageLevel::Info)
        .set_title("Installation Complete")
        .set_description("Fern MCP Bridge has been installed successfully.")
        .show();

    Ok(())
}