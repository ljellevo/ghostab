# ghostty-tab-preset — Claude context

## What this repo is

A collection of Ghostty terminal tab-preset scripts. Each script opens a new Ghostty window with multiple tabs, each pointing to a specific project directory. The repo directory is on PATH so any script here can be called by name from any terminal.

The `create-ghostty-tabs` script is the generator tool — it scans a directory, prompts for tab titles, and writes a new preset script into this repo.

## Script format

Every generated preset is a bash script wrapping an inline AppleScript block:

```bash
#!/bin/bash
# ghostty-tab-preset: generated   ← REQUIRED marker on line 2

osascript <<'EOF'

set tab1Dir to "/absolute/path/to/dir"
set tab2Dir to "/absolute/path/to/dir"   ← same dir repeated (two tabs per folder)
...

tell application "Ghostty"
    activate

    -- Tab 1: first tab uses "new window" and a different term reference
    set cfg1 to new surface configuration
    set initial working directory of cfg1 to tab1Dir
    set win to new window with configuration cfg1
    delay 0.3
    set term to focused terminal of selected tab of win
    perform action "set_tab_title:Title" on term

    -- Tab 2+: subsequent tabs use "new tab in win"
    set cfg2 to new surface configuration
    set initial working directory of cfg2 to tab2Dir
    set t2 to new tab in win with configuration cfg2
    delay 0.3
    perform action "set_tab_title:Title" on focused terminal of t2

    select tab (tab 1 of win)
end tell
EOF
```

**The asymmetry between tab 1 and tab 2+ is intentional** — do not "fix" it. Ghostty's AppleScript API requires `new window` for the first surface and `new tab in win` for subsequent ones, and the term reference for tab 1 uses `focused terminal of selected tab of win` rather than `focused terminal of tN`.

## Marker convention

- `# ghostty-tab-preset: generated` on line 2 → a generated preset script
- `# ghostty-tab-preset: meta` on line 2 → the `create-ghostty-tabs` tool itself

The `-l` and `-d` commands in `create-ghostty-tabs` rely on this marker to identify generated scripts. **Never delete or rename files that lack the `generated` marker** (e.g. `README.md`, `CLAUDE.md`).

## create-ghostty-tabs internals

- `REPO_DIR` is resolved from `BASH_SOURCE[0]` (not `$0`) so it works correctly when invoked via PATH.
- Generated scripts are written to a temp file first, then moved atomically — no partial writes on interrupt.
- Paths containing single quotes are rejected (would break the AppleScript heredoc quoting).
- Colons in user-supplied tab titles are stripped (AppleScript uses `:` as the delimiter in `set_tab_title:`).
- Subdirectories are sorted with `sort -V` for consistent, deterministic output.

## Testing

These scripts invoke `osascript` and open Ghostty windows — they cannot be unit tested headlessly. Manual verification steps:

1. `create-ghostty-tabs -h` → shows help text
2. `create-ghostty-tabs -l` → lists all scripts with the `generated` marker
3. `create-ghostty-tabs /path/with/subdirs` → prompts for titles, creates script
4. `create-ghostty-tabs -l` → new script appears in the list
5. Open the generated script and confirm its structure matches the format above
6. `create-ghostty-tabs -d <name>` → confirmation prompt, then script removed
7. `create-ghostty-tabs /same/path` → overwrite prompt appears
