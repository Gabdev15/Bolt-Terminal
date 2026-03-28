# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**Realistic Fastfood v2.0.2** is a Garry's Mod addon (Lua) implementing a fast-food management and roleplay system. It has no build step — it loads entirely through Garry's Mod's Lua `include()` system at runtime.

## Development

There are no build, lint, or test commands. To test changes:
- Copy/symlink the addon folder into your Garry's Mod `addons/` directory
- Launch a local GMod server and use `lua_openscript` or `script` console commands for quick testing
- Reload the addon with `lua_openscript lua/autorun/rfs_loader.lua` or a full map restart

## Architecture

### Entry Point
`lua/autorun/rfs_loader.lua` bootstraps the entire addon, using `include()` and `AddCSLuaFile()` to load all modules with correct CLIENT/SERVER scope.

### Code Separation
- `lua/realistic_fastfood/server/` — server-only logic (database, net receivers, hooks, cooking timers)
- `lua/realistic_fastfood/client/` — client-only UI (3D2D panels, terminal UI, notifications, screens)
- `lua/realistic_fastfood/shared/` — runs on both sides (localization, money system helpers, ownership utils)
- `lua/realistic_fastfood/languages/` — 10 language files (`sh_language_en.lua`, `fr`, `de`, `es`, `it`, `jp`, `ptbr`, `ru`, `tr`)

### Configuration
- `sh_config.lua` — primary config (language, money system, feature flags, admin ranks, job restrictions, numerical balancing)
- `sh_advanced_config.lua` — constants (model mappings, vectors/angles, tray positions, allowed entities, status icons)
- `sv_sql.lua` — MySQL credentials (only relevant when `RFS.Mysql = true`)

### Entity System
Each of the 25 entity types under `lua/entities/rfs_*/` has three files:
- `shared.lua` — model, printname, entity type
- `init.lua` — server-side physics and use interactions
- `cl_init.lua` — client-side custom rendering

### Networking
- Server-to-client via `net` library using named strings (e.g., `RFS:MainNet`, `RFS:Notification`)
- Networked entity state via `RFSNWVariables` table per entity; accessed with `RFS.SetNWVariable()` / `RFS.GetNWVariables()`
- Spam protection: all net receivers throttle with `CurTime()` (0.5 s minimum interval)

### Database
`RFS.Query(query, callback)` abstracts SQLite (default) and MySQL (via `RFS.Mysql = true`). Tables: `rfs_ents` (persistence) and `rfs_link_entities` (screen↔terminal links).

### Gamemode Compatibility
Money system helpers in `shared/sh_functions.lua` support DarkRP, Helix, Nutscript, and Sandbox. Entity ownership supports CPPI (`CPPIGetOwner()`), DarkRP purchase hooks, and fallback NW variables.

### 3D2D UI
`RFS.Start3D2D()` / `RFS.End3D2D()` wrap Garry's Mod 3D2D rendering. Ray-trace-based cursor detection enables interactive 3D buttons on terminals and screens (`client/cl_main.lua`).

### Localization
`RFS.GetSentence(key)` returns the string for the configured language (`RFS.Lang`), falling back to English. Language files expose a `RFS.Language[code]` table.
