# Project: ETCC Dashboard

This project uses standard prompts stored in "Z:\Backup\Websites\Web Utilities\StandardPrompts.md"

## Standard Rules (from StandardPrompts.md)

- Always read the instructions in "Z:\Backup\Websites\Web Utilities\components\table\readme.md"
- Always read the instructions in "Z:\Backup\Websites\Web Utilities\components\toolbar\readme.md"
- Use the palette defined below (overrides StandardPalette.md — ETCC uses blue/white/dark, not gold/brown)
- Apply the Code Change, Debugging, Regression Protection, and Release Readiness guidelines
- Always protect existing working features
- Preserve existing functionality unless explicitly asked to change it
- Before coding, identify affected files and possible side effects
- Use the existing project structure and coding style
- After changes, provide a regression test checklist
- Do not delete or rewrite large sections unless necessary
- Always curl the regression test and check the result before reporting a task done
- Always report when any files are deployed
- Only commit, push, or deploy when explicitly given a checkpoint command
- Whenever files are changed, automatically deploy to Hostinger
- Whenever a checkpoint prompt is given with no description, use a good short name for the changes
- Instrument all code by creating an error.log
- When a checkpoint prompt is given, update the regression test, run it, prompt whether to commit and push
- Clearly indicate when a change has been deployed

## Palette

**Base Variables**
| Role | Color | Hex |
|---|---|---|
| Background | White | `#ffffff` |
| Dark background | Black | `#000000` |
| Section background | Light gray | `#f5f5f7` |
| Primary text | Near-black | `#1d1d1f` |
| Secondary text | Medium gray | `#6e6e73` |
| Tertiary text | Light gray | `#86868b` |
| Accent / Link | Blue | `#0071e3` |
| Accent hover | Dark blue | `#0077ed` |
| Border / Divider | Light gray | `#d2d2d7` |
| Nav bar | Near-black | `#1d1d1f` |
| Danger | Red | `#c62828` |
| Success | Green | `#1a7f37` |

**ETCC Brand Accents**
| Role | Color | Hex |
|---|---|---|
| ETCC Red | Red | `#c0392b` |
| ETCC Gold | Gold | `#f0a500` |
| ETCC Blue | Blue | `#1a56a0` |

**Table Headers (override)**
| Role | Color | Hex |
|---|---|---|
| Header background | Light blue | `#dbeafe` |
| Header text | Near-black (via `var(--text)`) | `#1d1d1f` |
| Header position | Sticky | — |

**Toolbar Overrides**
| Role | Color | Hex |
|---|---|---|
| Toolbar background | Nav bar (via `var(--nav-bar)`) | `#1d1d1f` |
| Toolbar border | Light gray (via `var(--border)`) | `#d2d2d7` |
| Logo text | Blue (via `var(--accent)`) | `#0071e3` |
| Title text | White | `#ffffff` |
| Button background | Light gray (via `var(--bg-section)`) | `#f5f5f7` |
| Button border | Light gray (via `var(--border)`) | `#d2d2d7` |
| Button text | Near-black (via `var(--text)`) | `#1d1d1f` |
| Button hover background | Blue (via `var(--accent)`) | `#0071e3` |
| Button hover border | Dark blue (via `var(--accent-hover)`) | `#0077ed` |
| Button hover text | White | `#ffffff` |
| Close button | Red (via `var(--danger)`) | `#c62828` |
