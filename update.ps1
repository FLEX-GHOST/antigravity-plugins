$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$BundleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$KeysFile = Join-Path $BundleRoot "keys\keys.json"
$PluginsSrc = Join-Path $BundleRoot "plugins"

$GeminiConfig = Join-Path $HOME ".gemini\config"
$PluginsDest = Join-Path $GeminiConfig "plugins"
$SkillsDest = Join-Path $GeminiConfig "skills"
$OAuthFile = Join-Path $HOME ".gemini\antigravity\mcp_oauth_tokens.json"

New-Item -ItemType Directory -Force -Path $PluginsDest, $SkillsDest | Out-Null

$Keys = @{
  CONTEXT7_API_KEY = ""
  EXA_API_KEY      = ""
  SNYK_TOKEN       = ""
}

if (Test-Path $KeysFile) {
  try {
    $LoadedKeys = Get-Content $KeysFile -Raw | ConvertFrom-Json
    if ($LoadedKeys.CONTEXT7_API_KEY) { $Keys.CONTEXT7_API_KEY = $LoadedKeys.CONTEXT7_API_KEY }
    if ($LoadedKeys.EXA_API_KEY) { $Keys.EXA_API_KEY = $LoadedKeys.EXA_API_KEY }
    if ($LoadedKeys.SNYK_TOKEN) { $Keys.SNYK_TOKEN = $LoadedKeys.SNYK_TOKEN }
  } catch {}
}

if (-not $Keys.CONTEXT7_API_KEY -or $Keys.CONTEXT7_API_KEY -eq "YOUR_CONTEXT7_API_KEY") {
  $ExistingCtx = Join-Path $PluginsDest "context7\mcp_config.json"
  if (Test-Path $ExistingCtx) {
    try {
      $Cfg = Get-Content $ExistingCtx -Raw | ConvertFrom-Json
      if ($Cfg.mcpServers.context7.env.CONTEXT7_API_KEY) {
        $Keys.CONTEXT7_API_KEY = $Cfg.mcpServers.context7.env.CONTEXT7_API_KEY
      }
    } catch {}
  }
}

if (-not $Keys.EXA_API_KEY -or $Keys.EXA_API_KEY -eq "YOUR_EXA_API_KEY") {
  $ExistingExa = Join-Path $PluginsDest "exa\mcp_config.json"
  if (Test-Path $ExistingExa) {
    try {
      $Cfg = Get-Content $ExistingExa -Raw | ConvertFrom-Json
      if ($Cfg.mcpServers.exa.env.EXA_API_KEY) {
        $Keys.EXA_API_KEY = $Cfg.mcpServers.exa.env.EXA_API_KEY
      }
    } catch {}
  }
}

if (-not $Keys.SNYK_TOKEN -or $Keys.SNYK_TOKEN -eq "YOUR_SNYK_TOKEN") {
  $ExistingSnyk = Join-Path $PluginsDest "snyk\mcp_config.json"
  if (Test-Path $ExistingSnyk) {
    try {
      $Cfg = Get-Content $ExistingSnyk -Raw | ConvertFrom-Json
      if ($Cfg.mcpServers.snyk.env.SNYK_TOKEN) {
        $Keys.SNYK_TOKEN = $Cfg.mcpServers.snyk.env.SNYK_TOKEN
      }
    } catch {}
  }
}

Write-Host "[1/5] Checking Remote Repository for Plugin Updates..." -ForegroundColor Cyan
$GitCmd = (Get-Command git -ErrorAction SilentlyContinue).Source
if ($GitCmd -and (Test-Path (Join-Path $BundleRoot ".git"))) {
  Push-Location $BundleRoot
  try {
    $HasStash = $false
    $DiffOutput = git status --porcelain 2>&1
    if ($DiffOutput) {
      git stash push -m "pre-update-backup" 2>&1 | Out-Null
      $HasStash = $true
    }
    git pull origin main --rebase
    if ($HasStash) {
      git stash pop 2>&1 | Out-Null
    }
  } catch {
    Write-Host "Warning: Git pull failed or encountered conflicts; continuing with local bundle." -ForegroundColor Yellow
  } finally {
    Pop-Location
  }
} else {
  Write-Host "Git repository not detected; skipping git pull." -ForegroundColor Yellow
}

if (Test-Path (Split-Path -Parent $KeysFile)) {
  $Keys | ConvertTo-Json -Depth 4 | Set-Content $KeysFile -Encoding UTF8
  if ($GitCmd -and (Test-Path (Join-Path $BundleRoot ".git"))) {
    git update-index --skip-worktree $KeysFile 2>$null
  }
}

Write-Host "[2/5] Updating Global NPM Packages to Latest..." -ForegroundColor Cyan
npm install -g @upstash/context7-mcp@latest exa-mcp-server@latest snyk@latest rea-agents@latest

$NodeCmd = (Get-Command node -ErrorAction Stop).Source
$NpxCmd = (Get-Command npx.cmd -ErrorAction SilentlyContinue).Source
if (-not $NpxCmd) { $NpxCmd = (Get-Command npx -ErrorAction Stop).Source }
$UvxCmd = (Get-Command uvx -ErrorAction SilentlyContinue).Source
if (-not $UvxCmd) { $UvxCmd = "uvx" }
$NpmRoot = (npm root -g).Trim()

Write-Host "[3/5] Deploying Plugins (with isolated skills)..." -ForegroundColor Cyan
Copy-Item -Path "$PluginsSrc\*" -Destination $PluginsDest -Recurse -Force

Write-Host "[4/5] Regenerating Platform MCP Configurations & Preserving Keys..." -ForegroundColor Cyan

$CtxEnv = @{}
if ($Keys.CONTEXT7_API_KEY -and $Keys.CONTEXT7_API_KEY -ne "YOUR_CONTEXT7_API_KEY") {
  $CtxEnv["CONTEXT7_API_KEY"] = $Keys.CONTEXT7_API_KEY
}
$CtxConfig = @{
  mcpServers = @{
    context7 = @{
      command = $NodeCmd
      args    = @((Join-Path $NpmRoot "@upstash\context7-mcp\dist\index.js"))
      env     = $CtxEnv
    }
  }
}
$CtxConfig | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $PluginsDest "context7\mcp_config.json") -Encoding UTF8

$ExaEnv = @{}
if ($Keys.EXA_API_KEY -and $Keys.EXA_API_KEY -ne "YOUR_EXA_API_KEY") {
  $ExaEnv["EXA_API_KEY"] = $Keys.EXA_API_KEY
}
$ExaConfig = @{
  mcpServers = @{
    exa = @{
      command = $NpxCmd
      args    = @("-y", "exa-mcp-server")
      env     = $ExaEnv
    }
  }
}
$ExaConfig | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $PluginsDest "exa\mcp_config.json") -Encoding UTF8

$ReaConfig = @{
  mcpServers = @{
    rea = @{
      command = $NodeCmd
      args    = @((Join-Path $NpmRoot "rea-agents\scripts\rea.mjs"), "mcp")
      env     = @{
        PATH = "$env:PATH"
      }
    }
  }
}
$ReaConfig | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $PluginsDest "rea\mcp_config.json") -Encoding UTF8

$SerenaConfig = @{
  mcpServers = @{
    serena = @{
      command = $UvxCmd
      args    = @("--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server", "--open-web-dashboard", "False")
    }
  }
}
$SerenaConfig | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $PluginsDest "serena\mcp_config.json") -Encoding UTF8

$SnykEnv = @{}
if ($Keys.SNYK_TOKEN -and $Keys.SNYK_TOKEN -ne "YOUR_SNYK_TOKEN") {
  $SnykEnv["SNYK_TOKEN"] = $Keys.SNYK_TOKEN
}
$SnykConfig = @{
  mcpServers = @{
    snyk = @{
      command = $NodeCmd
      args    = @((Join-Path $NpmRoot "snyk\bin\snyk"), "mcp", "--disable-trust")
      env     = $SnykEnv
    }
  }
}
$SnykConfig | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $PluginsDest "snyk\mcp_config.json") -Encoding UTF8

$PythonCmd = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $PythonCmd) { $PythonCmd = "python" }
$TgsConfig = @{
  mcpServers = @{
    "tgs-studio-pro" = @{
      command = $PythonCmd
      args    = @((Join-Path $PluginsDest "tgs-studio-pro\server\tgs_mcp_server.py"))
      env     = @{
        PYTHONIOENCODING = "utf-8"
        PYTHONUTF8       = "1"
      }
    }
  }
}
$TgsConfig | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $PluginsDest "tgs-studio-pro\mcp_config.json") -Encoding UTF8

if ($Keys.SNYK_TOKEN -and $Keys.SNYK_TOKEN -ne "YOUR_SNYK_TOKEN") {
  & $NodeCmd (Join-Path $NpmRoot "snyk\bin\snyk") auth $Keys.SNYK_TOKEN | Out-Null
}

if (Test-Path (Split-Path -Parent $OAuthFile)) {
  "{}" | Set-Content $OAuthFile -Encoding UTF8
}

Write-Host "[5/5] All 7 Antigravity Plugins Updated Successfully!" -ForegroundColor Green

Get-ChildItem -Path $PluginsDest -Directory | ForEach-Object {
  $Manifest = Join-Path $_.FullName "plugin.json"
  if (Test-Path $Manifest) {
    try {
      $Meta = Get-Content $Manifest -Raw | ConvertFrom-Json
      $Name = if ($Meta.displayName) { $Meta.displayName } else { $Meta.name }
      $Ver = if ($Meta.version) { "v$($Meta.version)" } else { "active" }
      Write-Host "  -> $($Name): $($Ver)" -ForegroundColor White
    } catch {}
  }
}
