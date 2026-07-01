# Roblox Cursor Starter 🎮

Build Roblox games by coding in **Cursor** (with AI), live-syncing into **Roblox Studio**
with **Rojo**, and testing on a baseplate. Git is included for backups, but the part that
actually makes this work is **Cursor + the Rojo CLI + the Rojo Studio plugin + version match + sync.**

> The two things that trip everyone up:
> 1. **The Rojo CLI (terminal) and the Rojo Studio plugin must be the *same version*** or you get a
>    "protocol mismatch" and can't connect.
> 2. **Connecting is not syncing.** Rojo only syncs files that live inside a folder your
>    `default.project.json` maps. Everything else is ignored.

---

## The mental model (30 seconds)

```
Cursor (edit .luau)  ──►  Rojo CLI: `rojo serve`  ──►  Rojo Studio plugin: Connect  ──►  Roblox Studio
        you write code          a local server on             the plugin pulls from            files appear
                                 localhost:34872              that server                       in Explorer
```

Studio never reads your Mac folder directly, and it never reads Git. **The Rojo plugin talking
to the Rojo server is the only bridge.** Same version on both sides, server running, then connect.

---

# Step 1 — Add two extensions in Cursor

Open **Cursor**, then go to **Cursor → Settings… → Extensions** (or press `Cmd + Shift + X`).
Install **both** of these:

### 1a. Rojo (required)
Search the Extensions box for **`rojo`**. Install:

- **Rojo – Roblox Studio Sync** — subtitle *"Rojo for VS Code"*, publisher **evaera**,
  red cursive **Rojo** logo, ~25K installs.

> ⚠️ There are ~20 results for "rojo" (Roo Code, etc.). Only install **evaera's** one — the
> one with the red cursive logo. It adds Command-Palette shortcuts like `Rojo: Start Server`
> and `Rojo: Install Roblox Studio Plugin`, and can offer to install the Rojo CLI for you.

### 1b. Lua (recommended)
Search the Extensions box for **`lua`**. Install:

- **Lua** — *"Lua Language Server"*, publisher **sumneko**, blue "Lua" logo.

This gives you autocomplete, syntax colors, and error squiggles while you write. (A dedicated
"Luau Language Server" extension also exists and is fine; sumneko's **Lua** is the common pick.)

---

# Step 2 — Open a terminal and get the Rojo CLI

### 2a. Open a terminal in Cursor
Top menu: **Terminal → New Terminal**. A shell opens at the bottom. `cd` into your project folder:

```bash
cd ~/Desktop/roblox        # wherever you unzipped this starter
pwd                        # confirm you're in the project folder
ls                         # you should see: default.project.json  src  docs  README.md
```

### 2b. Install the Rojo command-line tool
The modern way is with **Rokit** (a version manager for Roblox tools). Install Rokit once:

```bash
curl -fsSL https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash
```

Close and reopen the terminal, then add Rojo:

```bash
rokit add rojo-rbx/rojo
rokit install
```

*(If you already had `aftman`, `aftman add rojo-rbx/rojo` works too. Or let the Cursor Rojo
extension install it when it asks.)*

### 2c. Check the version — WRITE IT DOWN
```bash
rojo --version
```

You'll see something like:

```
Rojo 7.7.0-rc.1
```

**Remember this number.** In Step 4 the Studio plugin must show the *exact same* version.
(`rc` = release candidate — a pre-release. `7.7.0-rc.1` is **not** the same as stable `7.6.1`,
and mixing them causes the mismatch error.)

### 2d. Start the Rojo server
```bash
rojo serve
```

You should see exactly this shape (your port number may differ):

```
Rojo server listening:
  Address: localhost
  Port:    34872

Visit http://localhost:34872/ in your browser for more information.
```

**Leave this terminal running.** This is the server the Studio plugin connects to. To stop it
later, click the terminal and press `Ctrl + C`. If you close it, sync stops.

> Tip: `rojo serve` and `rojo serve default.project.json` are the same when the file is named
> `default.project.json`. If you have multiple project files, name the one you want:
> `rojo serve dev.project.json`.

---

# Step 3 — Install the Rojo *plugin* inside Roblox Studio

This is a **different piece** from the CLI. The CLI runs the server; the **plugin** lives inside
Studio and does the pulling. You need both.

### The easy, version-safe way (do this) ✅
In your Cursor terminal (Rojo CLI installed), run:

```bash
rojo plugin install
```

This builds and installs a Studio plugin that **matches your CLI version automatically** — which
kills the mismatch problem before it starts. Then fully quit and reopen Studio.

### The Toolbox way — "there are 9 Rojos, which one?" 🧭
If you install from Studio's **Toolbox → Plugins** (Creator Store) search instead, you'll get a
pile of results. Pick the official one:

- Name is **exactly "Rojo"** (not "Rojo Sync Helper", "Auto Rojo", etc.).
- It shows the **red cursive Rojo logo**.
- Published by the **Rojo team** (the official maintainers).
- Click it, then **Install**, and confirm its **version matches** your `rojo --version` from Step 2c.

> ⚠️ Whatever you install here has a version. If the Toolbox gives you `7.6.1` but your CLI is
> `7.7.0-rc.1`, they won't connect. The `rojo plugin install` method above avoids this entirely,
> so prefer it. (In your screenshot you actually have two plugin versions loaded — `Rojo 7.6.1`
> and `Rojo 7.7.0-rc.1` — and you connect using the tab that matches the CLI.)

---

# Step 4 — Find Rojo in the Plugins tab and match versions

1. In Roblox Studio, open the **Plugins** tab in the top ribbon.
2. You'll see a **Rojo** button/section. Click it to open the Rojo panel.
3. The panel shows a **version number** (e.g. `7.7.0-rc.1`) near the Rojo logo.
4. **Compare it to `rojo --version` from Step 2c. They must be identical.**

**If they don't match (protocol mismatch):** pick ONE version and make both sides equal.
- Easiest: run `rojo plugin install` again in the terminal (installs a plugin matching your CLI),
  then **fully quit and reopen Studio**.
- Or pin your CLI to the plugin's version: `rokit add rojo-rbx/rojo@7.6.1 && rokit install`, then
  re-run `rojo --version` to confirm.

---

# Step 5 — Connect to your Rojo server

1. Make sure `rojo serve` is still running in the terminal (Step 2d).
2. In the Studio Rojo panel, you'll see your project name (**roblox**) and the address
   (**localhost:34872**).
3. Click **Connect**.
4. The button flips to **Disconnect** and shows a "synced X minutes ago" line. You're live. 🎉

If you see a mismatch error here, go back to Step 4 — the versions aren't equal.

---

# Step 6 — Verify the sync actually works (the "I connected but see no files" fix)

**Connecting only means Studio can *talk* to Rojo. It does not mean your files show up.**
Rojo only syncs files inside folders your `default.project.json` maps.

### What this starter maps
`default.project.json` says:

| Local folder | Appears in Studio at |
|--------------|----------------------|
| `src/server`  | ServerScriptService → **Server** |
| `src/shared`  | ReplicatedStorage → **Shared** |
| `src/client`  | StarterPlayer → StarterPlayerScripts → **Client** |

So after you connect, open **Explorer** in Studio and you should see:

```
ServerScriptService
└── Server
    ├── Main            (from src/server/Main.server.luau)
    └── CoinSpawner     (from src/server/CoinSpawner.server.luau)
ReplicatedStorage
└── Shared
    └── GameConfig      (from src/shared/GameConfig.luau)
StarterPlayer
└── StarterPlayerScripts
    └── Client
        └── Main        (from src/client/Main.client.luau)
```

### Do a live test
1. In Cursor, open `src/server/Main.server.luau` and add a line at the top:
   ```lua
   print("Hello from Rojo")
   ```
2. **Save** (`Cmd + S`).
3. In Studio, press **Play**. In the **Output** window you'll see `Hello from Rojo`.

If it shows up, sync works. If not, see the naming rules below.

### File-naming rules (this is usually the real problem)
The suffix decides what Studio makes:

| File name | Becomes in Studio |
|-----------|-------------------|
| `Main.server.luau`  | a **Script** (runs on the server) |
| `Main.client.luau`  | a **LocalScript** (runs on each player) |
| `GameConfig.luau`   | a **ModuleScript** (shared code you `require`) |
| `init.luau` (inside a folder) | turns that folder into a ModuleScript |

A file just sitting at `roblox/script.luau` (not under a mapped folder, or missing the
`.server` / `.client` suffix) **will not sync**. Move it under `src/server`, `src/client`, or
`src/shared` and give it the right suffix.

---

# Step 7 — Let Cursor's AI reverse-engineer your Rojo setup

If sync still misbehaves, paste this into Cursor's chat. It reads your files and fixes the mapping.
(Cursor can only see your **local** folder — not what's inside Studio — so it works *files → Studio*, not the other way.)

```
Inspect this Roblox Rojo project.

Goal: Rojo connects to Studio but the expected files/folders don't appear in Explorer.

Please:
1. Read default.project.json.
2. List exactly which local folders map to which Roblox services.
3. Compare those mappings to the actual folder tree in src/.
4. Flag any missing folders, wrong $path values, or bad file names
   (.server.luau / .client.luau / plain .luau for modules).
5. Fix the folder structure if needed — but do NOT delete or overwrite my
   existing code without asking first.
6. Create a minimal sync test:
   - src/server/HelloTest.server.luau  -> print("Hello from Rojo")
   - src/shared/TestModule.luau        -> a tiny ModuleScript
7. Tell me the exact command to run with rojo serve, and what I should
   see in Studio's Explorer after I reconnect.
```

---

## Quick command cheat-sheet

```bash
rojo --version          # check CLI version (must match the Studio plugin)
rojo serve              # start the sync server (leave running)
rojo plugin install     # install a Studio plugin that matches your CLI
Ctrl + C                # stop the server
```

## Troubleshooting fast table

| Symptom | Cause | Fix |
|---------|-------|-----|
| "Protocol mismatch" on Connect | CLI ≠ plugin version | Make both equal (Step 4). Restart Studio. |
| Connected but Explorer is empty | Files aren't under a mapped `$path` | Move code into `src/server`/`src/client`/`src/shared` (Step 6). |
| File shows as wrong type | Wrong suffix | `.server.luau` / `.client.luau` / `.luau` (Step 6). |
| Nothing updates when I save | `rojo serve` not running / disconnected | Restart `rojo serve`, click Connect. |
| Can't find the plugin in Studio | Not installed, or Studio not restarted | `rojo plugin install`, fully quit + reopen Studio. |

---

## Git (optional — just for backups)

Not required for the sync above. When you want history/backup:

```bash
git init
git add .
git commit -m "First working Rojo sync"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/roblox-cursor-starter.git
git push -u origin main
```

Commit whenever something works so you can always roll back. **Publishing the game is separate**
and manual: in Studio, `File → Publish to Roblox`.

---

## Using AI to learn (Cursor tips)
- Highlight code → `Cmd + L` → "what does this do?"
- "Add a sound when the coin is collected" — let it edit, then read the diff before saving.
- The `.cursor/rules` file already tells the AI to keep code simple, safe, and server-authoritative.

Tell Cursor what game you want (obby, tycoon, simulator, racing…) and it'll build it with you.
