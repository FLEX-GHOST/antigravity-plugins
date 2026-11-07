#!/usr/bin/env bash
set -euo pipefail

BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYS_FILE="$BUNDLE_ROOT/keys/keys.json"
PLUGINS_SRC="$BUNDLE_ROOT/plugins"

GEMINI_CONFIG="$HOME/.gemini/config"
PLUGINS_DEST="$GEMINI_CONFIG/plugins"
SKILLS_DEST="$GEMINI_CONFIG/skills"

mkdir -p "$PLUGINS_DEST" "$SKILLS_DEST"

if ! command -v uvx >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "[1/5] Installing Global NPM Packages..."
npm install -g @upstash/context7-mcp exa-mcp-server snyk rea-agents

echo "[2/5] Copying Plugins & Official Skills..."
cp -R "$PLUGINS_SRC/"* "$PLUGINS_DEST/"

for plugin_dir in "$PLUGINS_DEST"/*; do
  if [ -d "$plugin_dir/skills" ]; then
    cp -R "$plugin_dir/skills/"* "$SKILLS_DEST/"
  fi
done

echo "[3/5] Generating Platform MCP Configurations & Injecting Isolated Keys..."
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
  keys = Object.assign(keys, JSON.parse(fs.readFileSync(keysFile, "utf8")));
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
EOF

SNYK_TOKEN_VAL="$("$NODE_BIN" -e 'const fs=require("fs"); const k=fs.existsSync(process.argv[1])?JSON.parse(fs.readFileSync(process.argv[1],"utf8")):{}; process.stdout.write(k.SNYK_TOKEN||"");' "$KEYS_FILE")"
if [ -n "$SNYK_TOKEN_VAL" ] && [ "$SNYK_TOKEN_VAL" != "YOUR_SNYK_TOKEN" ]; then
  echo "[4/5] Authenticating Snyk CLI..."
  "$NODE_BIN" "$NPM_ROOT/snyk/bin/snyk" auth "$SNYK_TOKEN_VAL" >/dev/null 2>&1 || true
fi

OAUTH_DIR="$HOME/.gemini/antigravity"
if [ -d "$OAUTH_DIR" ]; then
  echo "{}" > "$OAUTH_DIR/mcp_oauth_tokens.json"
fi

echo "[5/5] All 5 Antigravity Plugins Installed Successfully!"
