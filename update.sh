#!/usr/bin/env bash
set -euo pipefail

BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYS_FILE="$BUNDLE_ROOT/keys/keys.json"
PLUGINS_SRC="$BUNDLE_ROOT/plugins"

GEMINI_CONFIG="$HOME/.gemini/config"
PLUGINS_DEST="$GEMINI_CONFIG/plugins"
SKILLS_DEST="$GEMINI_CONFIG/skills"
OAUTH_DIR="$HOME/.gemini/antigravity"

mkdir -p "$PLUGINS_DEST" "$SKILLS_DEST"

PRESERVED_KEYS=""
if [ -f "$KEYS_FILE" ]; then
  PRESERVED_KEYS="$(cat "$KEYS_FILE")"
fi

echo "[1/5] Checking Remote Repository for Plugin Updates..."
if [ -d "$BUNDLE_ROOT/.git" ] && command -v git >/dev/null 2>&1; then
  cd "$BUNDLE_ROOT"
  HAS_STASH=0
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    git stash push -m "pre-update-backup" >/dev/null 2>&1 || true
    HAS_STASH=1
  fi
  git pull origin main --rebase || echo "Warning: Git pull encountered issue; continuing with local bundle."
  if [ "$HAS_STASH" -eq 1 ]; then
    git stash pop >/dev/null 2>&1 || true
  fi
fi

if [ -n "$PRESERVED_KEYS" ]; then
  mkdir -p "$(dirname "$KEYS_FILE")"
  echo "$PRESERVED_KEYS" > "$KEYS_FILE"
  if [ -d "$BUNDLE_ROOT/.git" ] && command -v git >/dev/null 2>&1; then
    git update-index --skip-worktree "$KEYS_FILE" 2>/dev/null || true
  fi
fi

if ! command -v uvx >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "[2/5] Updating Global NPM Packages to Latest..."
npm install -g @upstash/context7-mcp@latest exa-mcp-server@latest snyk@latest rea-agents@latest

echo "[3/5] Deploying Plugins (with isolated skills)..."
cp -R "$PLUGINS_SRC/"* "$PLUGINS_DEST/"

echo "[4/5] Regenerating Platform MCP Configurations & Preserving Keys..."
NODE_BIN="$(command -v node)"
NPX_BIN="$(command -v npx)"
UVX_BIN="$(command -v uvx || echo uvx)"
NPM_ROOT="$(npm root -g)"

"$NODE_BIN" - "$KEYS_FILE" "$PLUGINS_DEST" "$NODE_BIN" "$NPX_BIN" "$UVX_BIN" "$NPM_ROOT" << 'EOF'
const fs = require("fs");
const path = require("path");

const [keysFile, pluginsDest, nodeBin, npxBin, uvxBin, npmRoot] = process.argv.slice(2);
let keys = { CONTEXT7_API_KEY: "", EXA_API_KEY: "", SNYK_TOKEN: "" };
if (fs.existsSync(keysFile)) {
  try {
    keys = Object.assign(keys, JSON.parse(fs.readFileSync(keysFile, "utf8")));
  } catch {}
}

const writeJson = (p, obj) => fs.writeFileSync(p, JSON.stringify(obj, null, 2) + "\n", "utf8");

const ctxEnv = {};
if (keys.CONTEXT7_API_KEY && keys.CONTEXT7_API_KEY !== "YOUR_CONTEXT7_API_KEY") {
  ctxEnv.CONTEXT7_API_KEY = keys.CONTEXT7_API_KEY;
}
writeJson(path.join(pluginsDest, "context7", "mcp_config.json"), {
  mcpServers: {
    context7: {
      command: nodeBin,
      args: [path.join(npmRoot, "@upstash", "context7-mcp", "dist", "index.js")],
      env: ctxEnv
    }
  }
});

const exaEnv = {};
if (keys.EXA_API_KEY && keys.EXA_API_KEY !== "YOUR_EXA_API_KEY") {
  exaEnv.EXA_API_KEY = keys.EXA_API_KEY;
}
writeJson(path.join(pluginsDest, "exa", "mcp_config.json"), {
  mcpServers: {
    exa: {
      command: npxBin,
      args: ["-y", "exa-mcp-server"],
      env: exaEnv
    }
  }
});

writeJson(path.join(pluginsDest, "rea", "mcp_config.json"), {
  mcpServers: {
    rea: {
      command: nodeBin,
      args: [path.join(npmRoot, "rea-agents", "scripts", "rea.mjs"), "mcp"],
      env: { PATH: process.env.PATH || "" }
    }
  }
});

writeJson(path.join(pluginsDest, "serena", "mcp_config.json"), {
  mcpServers: {
    serena: {
      command: uvxBin,
      args: ["--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server", "--open-web-dashboard", "False"]
    }
  }
});

const snykEnv = {};
if (keys.SNYK_TOKEN && keys.SNYK_TOKEN !== "YOUR_SNYK_TOKEN") {
  snykEnv.SNYK_TOKEN = keys.SNYK_TOKEN;
}
writeJson(path.join(pluginsDest, "snyk", "mcp_config.json"), {
  mcpServers: {
    snyk: {
      command: nodeBin,
      args: [path.join(npmRoot, "snyk", "bin", "snyk"), "mcp", "--disable-trust"],
      env: snykEnv
    }
  }
});

writeJson(path.join(pluginsDest, "tgs-studio-pro", "mcp_config.json"), {
  mcpServers: {
    "tgs-studio-pro": {
      command: "python3",
      args: [path.join(pluginsDest, "tgs-studio-pro", "server", "tgs_mcp_server.py")],
      env: { PYTHONIOENCODING: "utf-8", PYTHONUTF8: "1" }
    }
  }
});
EOF

SNYK_TOKEN_VAL="$("$NODE_BIN" -e 'const fs=require("fs"); const k=fs.existsSync(process.argv[1])?JSON.parse(fs.readFileSync(process.argv[1],"utf8")):{}; process.stdout.write(k.SNYK_TOKEN||"");' "$KEYS_FILE")"
if [ -n "$SNYK_TOKEN_VAL" ] && [ "$SNYK_TOKEN_VAL" != "YOUR_SNYK_TOKEN" ]; then
  "$NODE_BIN" "$NPM_ROOT/snyk/bin/snyk" auth "$SNYK_TOKEN_VAL" >/dev/null 2>&1 || true
fi

if [ -d "$OAUTH_DIR" ]; then
  echo "{}" > "$OAUTH_DIR/mcp_oauth_tokens.json"
fi

echo "[5/5] All 7 Antigravity Plugins Updated Successfully!"
