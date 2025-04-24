$ErrorActionPreference = 'Stop'

$arch = ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture).ToString().ToLower()
switch ($arch) {
  'arm64' { $binName = 'fern-mcp-bridge-windows-arm64.exe' }
  'x64'   { $binName = 'fern-mcp-bridge-windows-amd64.exe' }
  Default { Write-Error "Unsupported architecture: $arch" }
}

$binUrl = "https://github.com/meetfern/fern-mcp/raw/refs/heads/main/bin/$binName"
$targetDir = "$env:LOCALAPPDATA\fern\bin"
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
$targetPath = Join-Path $targetDir "fern-mcp-bridge.exe"

Invoke-WebRequest -Uri $binUrl -OutFile $targetPath

$configPath = Join-Path $env:APPDATA "Claude Desktop\claude_desktop_config.json"

$json = @{}
if (Test-Path $configPath) {
  $json = Get-Content $configPath -Raw | ConvertFrom-Json
}
if (-not $json.mcpServers) {
  $json.mcpServers = @{}
}
$json.mcpServers.fern = @{
  command = $targetPath
  args = @(
    "--api-endpoint", "http://api.meetfern.ai/mcp",
    "--auth-endpoint", "http://auth.meetfern.ai",
    "--redirect-url", "http://localhost:31310/auth"
  )
}

$json | ConvertTo-Json -Depth 10 | Set-Content -Path $configPath -Encoding UTF8

Write-Host "Installed fern-mcp-bridge to $targetPath"
