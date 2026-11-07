$ErrorActionPreference = "Stop"
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
  $LoadedKeys = Get-Content $KeysFile -Raw | ConvertFrom-Json
  if ($LoadedKeys.CONTEXT7_API_KEY) { $Keys.CONTEXT7_API_KEY = $LoadedKeys.CONTEXT7_API_KEY }
  if ($LoadedKeys.EXA_API_KEY) { $Keys.EXA_API_KEY = $LoadedKeys.EXA_API_KEY }
  if ($LoadedKeys.SNYK_TOKEN) { $Keys.SNYK_TOKEN = $LoadedKeys.SNYK_TOKEN }
}

Write-Host "[1/5] Checking & Installing Global Packages..." -ForegroundColor Cyan
npm install -g @upstash/context7-mcp exa-mcp-server snyk rea-agents

$NodeCmd = (Get-Command node -ErrorAction Stop).Source
$NpxCmd = (Get-Command npx.cmd -ErrorAction SilentlyContinue).Source
if (-not $NpxCmd) { $NpxCmd = (Get-Command npx -ErrorAction Stop).Source }
$UvxCmd = (Get-Command uvx -ErrorAction SilentlyContinue).Source
if (-not $UvxCmd) { $UvxCmd = "uvx" }
$NpmRoot = (npm root -g).Trim()

Write-Host "[2/5] Copying Plugins & Official Skills..." -ForegroundColor Cyan
Copy-Item -Path "$PluginsSrc\*" -Destination $PluginsDest -Recurse -Force

Get-ChildItem -Path $PluginsDest -Directory | ForEach-Object {
  $PluginSkillsDir = Join-Path $_.FullName "skills"
  if (Test-Path $PluginSkillsDir) {
    Copy-Item -Path "$PluginSkillsDir\*" -Destination $SkillsDest -Recurse -Force
  }
}

Write-Host "[3/5] Generating Platform MCP Configurations & Injecting Isolated Keys..." -ForegroundColor Cyan

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

if ($Keys.SNYK_TOKEN -and $Keys.SNYK_TOKEN -ne "YOUR_SNYK_TOKEN") {
  Write-Host "[4/5] Authenticating Snyk CLI..." -ForegroundColor Cyan
  & $NodeCmd (Join-Path $NpmRoot "snyk\bin\snyk") auth $Keys.SNYK_TOKEN | Out-Null
}

if (Test-Path (Split-Path -Parent $OAuthFile)) {
  "{}" | Set-Content $OAuthFile -Encoding UTF8
}

Write-Host "[5/5] All 5 Antigravity Plugins Installed Successfully!" -ForegroundColor Green
