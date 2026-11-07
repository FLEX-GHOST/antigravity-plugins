---
name: serena-mcp
description: Semantic code navigation, LSP symbol graph exploration, compiler diagnostics, and AST-level refactoring using Serena MCP tools. Use when navigating large codebases, tracing function callers/implementations, renaming symbols across files, or replacing symbol bodies cleanly.
---

# Serena Semantic Code Navigation & Refactoring

Use Serena MCP tools whenever compiler-accurate symbol resolution, call-graph tracing, or multi-file refactoring is required.

## Core Workflow

### 1. Project Activation & Onboarding
- Call `activate_project` with the workspace root path before running symbol queries.
- Use `get_current_config` and `list_memories` to inspect existing project context.

### 2. Semantic Symbol Exploration
- **File Overview**: Call `get_symbols_overview` on a file or directory to inspect top-level classes, functions, and exports without reading entire files.
- **Definition Lookup**: Call `find_symbol` with the symbol name path (e.g., `AuthService/verifyToken`) and `include_body: true` to read only the exact symbol implementation.
- **Call Graph & Impact Analysis**: Call `find_referencing_symbols` and `find_implementations` before modifying any shared interface or security check to identify every caller in the codebase.

### 3. Safe AST-Level Refactoring
- **Modify Function/Class Implementation**: Prefer `replace_symbol_body`, `insert_before_symbol`, or `insert_after_symbol` over line-based edits when updating complete methods or classes.
- **Workspace-Wide Rename**: Use `rename_symbol` to refactor identifiers across all referencing files simultaneously.
- **Verification**: Always run `get_diagnostics_for_file` after edits to confirm zero compiler or type errors were introduced.
