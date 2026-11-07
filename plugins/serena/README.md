# Serena Code Agent Plugin for Antigravity

Serena equips Antigravity with Language Server Protocol (LSP) semantic intelligence. Instead of relying on raw text search or regex replacements, Serena navigates definitions, call hierarchies, and type references with compiler-grade precision.

## What's Included

- **MCP Server** — 25 semantic code analysis, symbol refactoring, LSP diagnostic, and project memory tools
- **Skills** — A `serena-mcp` skill for AST-level code navigation, safe symbol renaming, and architectural mapping

## Available Tools

### Semantic Navigation (`find_symbol`, `find_referencing_symbols`, `find_implementations`, `get_symbols_overview`)
Resolves exact symbol definitions, interfaces, subclasses, and every call site across the workspace.

### Precision Refactoring (`replace_symbol_body`, `rename_symbol`, `insert_after_symbol`, `insert_before_symbol`, `safe_delete_symbol`)
Modifies functions, methods, and classes at the symbol boundary and renames identifiers safely across the entire repository.

### Diagnostics & Project Memory (`get_diagnostics_for_file`, `write_memory`, `read_memory`)
Queries live compiler/LSP diagnostics for errors and warnings, and persists architectural knowledge across sessions.

## Usage Examples

- "Activate Serena on this repository and map all callers of `verifyMembershipTier`"
- "Rename this interface across the entire project using Serena LSP refactoring"
- "Replace the body of `validateToken` and verify zero LSP diagnostic errors remain"
