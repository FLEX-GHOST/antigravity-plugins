# REA — Reverse Engineer Anything Plugin for Antigravity

REA is an enterprise-grade reverse engineering and program analysis suite for AI agents. Instead of guessing how compiled binaries, obfuscated web bundles, mobile apps, or network protocols work, REA extracts verifiable static and dynamic runtime evidence across native, managed, web, mobile, and firmware targets.

## What's Included

- **MCP Server** — 229 specialized reverse engineering tools spanning native binaries, Ghidra/Rizin/Cutter, Frida dynamic instrumentation, Electron/Web bundle deobfuscation, Android APK/JEB/ADB, and PCAP protocol dissection
- **Skills (5 Included)**:
  - `reverse-engineer-anything` — End-to-end static & dynamic reverse engineering workflows and AgentEnv reconstruction
  - `rea-analysis-optimization` — Optimize provider queries, memory, and evidence caching
  - `rea-tool-design` — Design and extend REA investigation contracts and evidence schemas
  - `rea-ci-tests-audit` — Audit reverse engineering test suites and fixture integrity
  - `rea-changelog-update` — Synchronize release notes and pinned Git history

## Core Capabilities

### 1. Web, JavaScript & Electron Reconstruction
- `analyze_web_bundle` / `recover_javascript_sources` — Deobfuscate webpack/vite bundles and recover source maps
- `observe_web_session` / `inspect_web_network_capture` — Capture live DOM, storage, and authenticated API traffic
- `inspect_electron_fuses` / `capture_electron_scenario` — Audit Electron desktop app security boundaries

### 2. Native Binary & Firmware Analysis
- `binary_overview` / `procedure_pseudo_code` / `batch_decompile` — Full decompilation and CFG call-graph extraction
- `trace_feature` / `trace_call_path` / `xrefs` — Cross-reference strings, imports, exports, and dispatch tables
- `instrument_with_frida` / `start_gdb_session` — Live runtime hooking and register/memory inspection

### 3. Mobile (Android / iOS) & Network Protocols
- `inspect_android_package` / `decompile_jeb_item` — APK manifest, DEX class search, and JEB decompilation
- `inspect_macho` / `analyze_swift_types` / `get_objc_classes` — Mach-O, Objective-C, and Swift symbol recovery
- `inspect_packet_capture` / `inspect_packet_fields` — Deep packet inspection for `.pcap` and `.pcapng` captures

## Usage Examples

- "Decompile this binary and trace how license keys are validated"
- "Recover the original JavaScript modules from this production web bundle and list all hidden VIP endpoints"
- "Analyze this Android APK and find how API requests are signed"
