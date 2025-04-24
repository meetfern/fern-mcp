$ErrorActionPreference = 'Stop'
$repoBase = 'https://raw.githubusercontent.com/meetfern/fern-mcp/main/bin'
$arch = ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture).ToString().ToLower()
switch ($arch) {
  'arm64' { $binName = 'fern-exograph-mcp-bridge-windows-arm64.exe' }
  'x64'   { $binName = 'fern-exograph-mcp-bridge-windows-amd64.exe' }
  Default { Write-Error "Unsupported architecture $arch" }
}
$targetDir = "$env:LOCALAPPDATA\fern\bin"
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
$target = Join-Path $targetDir 'fern-exograph-mcp-bridge.exe'
Invoke-WebRequest -Uri "$repoBase/$binName" -OutFile $target
$configPath = Join-Path $env:APPDATA 'Claude Desktop\claude_desktop_config.json'
$json = @{}
if (Test-Path $configPath) { $json = Get-Content $configPath -Raw | ConvertFrom-Json }
if (-not $json.mcpServers) { $json.mcpServers = @{} }
$json.mcpServers.fern = @{
  command = $target
  args = @(
    '--api-endpoint','http://api.meetfern.ai/mcp',
    '--auth-endpoint','http://auth.meetfern.ai',
    '--redirect-url','http://localhost:31310/auth'
  )
}
$json | ConvertTo-Json -Depth 10 | Set-Content $configPath
Write-Host 'Done'
