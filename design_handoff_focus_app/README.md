# Handoff: Focus App (macOS) — Projects · App Blocker · Focus Session

## Overview
A macOS-first focus application. Three decoupled features:

1. **Projects** — saved window layouts ("workspaces"). Launching a project opens a set of apps/websites in their saved positions across the user's monitors.
2. **App blocker** — profiles bundling blocked apps and websites; a profile can be armed and runs independently of any project.
3. **Focus session** — an egg-timer style dial to set the session length, presets, and a distraction-free running state.

All three are independent: a project stores only its window layout; blocker profiles and the timer are global and never bound to a project.

## About the Design Files
The files in this bundle are **design references created in HTML** — prototypes showing intended look and behaviour, not production code to copy. The task is to **recreate these designs in the target codebase's environment** (for macOS: SwiftUI/AppKit; for a web shell: React/Electron/Tauri) using its established patterns. If no environment exists yet, pick the framework that fits a macOS menu-bar-capable desktop app.

Where the prototype fakes system behaviour (launching apps, blocking, Finder), the real implementation needs platform APIs — see *Platform notes*.

## Fidelity
**High-fidelity.** Colours, typography, spacing, radii, motion timings and copy are final and taken from the App-Care design system. Recreate pixel-accurately with the codebase's own components where they exist.

## Screens / Views

### 1. App window (idle state)
Window: 1240px wide, rounded 14px, 1px `#e2e8f0` border, `--shadow-xl`, background `#f8fafc`.

- **Title bar** — 46px tall, background `#ffffff` (idle) / `#172554` (session running), bottom border 1px `#e2e8f0` (idle) / `rgba(255,255,255,0.08)`. Left: three 12px traffic-light dots (`#ff5f57`, `#febc2e`, `#28c840`), 8px gap. Centre: window title, JetBrains Mono 12px/700, letter-spacing 0.1em, uppercase, `#64748b` — "Focus — <project name>" idle, "In focus" while running.
- **Body** — CSS grid `1fr 2fr 1fr`, gap 16px, padding 16px, height 736px, background `#f8fafc`. Three separate cards (Apple-style panels), each `#ffffff`, 1px `#e2e8f0`, radius 14px.

#### Card 1 — Projects (left, 1/4)
- Padding 20px 18px, column flex, gap 16px, `overflow-y: auto`.
- Header row: label "PROJECTS" (JetBrains Mono 10px/700, tracking 0.15em, uppercase, `#94a3b8`) and "+ NEW" (same type, `#2563eb`, hover `#1e40af`) which opens the project editor.
- Project cards: radius 12px, padding 14px, 1px border `#e2e8f0` (`#93c5fd` when active), background `#ffffff` (`#eff6ff` when active). Hover: `translateY(-2px)` + `--shadow-md`, 200ms. Entrance: `fadeUp` 320ms, 60ms stagger.
  - Row 1: 8px status dot (`#2563eb` active / `#cbd5e1`), project name (JetBrains Mono 14px/700, `#0f172a`), right-aligned "EDIT" (10px/700 uppercase, `#94a3b8`, hover `#2563eb`) — stops propagation, opens the editor.
  - Row 2 (subtitle, indented 17px): JetBrains Mono 11px, `#94a3b8` — "`<n>` apps · saved layout".
- Footer (pinned bottom, 1px top border, 16px padding-top): 14px Inter, `#64748b` — "A project is a saved window layout. Launching it opens the same apps in the same places, every time."

#### Card 2 — Workspace + session (middle, 2/4)
Column flex, gap 16px, `min-width: 0`.

**Workspace card** (top): `#ffffff`, 1px `#e2e8f0`, radius 14px, padding 20px 24px.
- Header row: project name (JetBrains Mono 22px/800, tracking -0.02em, `#0f172a`) and the launch button — JetBrains Mono 11px/700, tracking 0.1em, uppercase, white on `#2563eb`, radius 8px, padding 9px 16px; hover `translateY(-1px)` + `--shadow-md`. Label cycles "Launch workspace" → "Opening…" → "Re-arrange" (background `#94a3b8` once launched).
- App rows (one per window in the project), 8px 6px padding, radius 8px, hover background `#f8fafc`, entrance `rowIn` 300ms with 40ms stagger (re-runs on project change):
  - 17px checkbox-style tick, radius 5px. Pending: 1px `#cbd5e1`, transparent. Done: `#2563eb` fill, white check (Heroicons solid check, 11px), entrance `tickIn` 260ms.
  - App name, Inter 13.5px, `#1e293b`.
  - Right: state text, JetBrains Mono 10.5px — "—" `#cbd5e1`, "opening…" `#475569`, "open" `#2563eb`.
  - While opening: 2px progress bar pinned to the row bottom (track `#f1f5f9`, fill `#3b82f6`, `barGrow` 520ms linear).
- Launch sequence: rows flip to "open" one by one, 520ms apart.

**Focus session card** (pinned to the bottom of the column via `margin-top: auto` so it never shifts when the project changes): `#ffffff`, 1px `#e2e8f0`, radius 14px, padding 18px 22px.
- Header: "FOCUS SESSION" (10px/700 uppercase `#94a3b8`) and hint (JetBrains Mono 11px `#94a3b8`) — "Drag the dial to set the length", during drag "Release to keep 50 min".
- Body: flex row, gap 32px.
  - **Dial** (left, 182×182px, `cursor: grab`), SVG `viewBox 0 0 200 200`:
    - Track: circle r=91, 1px `#f1f5f9`.
    - Progress arc: circle r=91, 3px `#2563eb`, round caps, rotated -90°, `stroke-dasharray = 2πr`, `dashoffset = C·(1 − minutes/120)`, transition 180ms.
    - 24 tick marks (every 5 min) from r=72→80 (inactive, 2px `#e2e8f0`) / r=68→80 (active, 2.6px `#3b82f6`), transition 220ms.
    - Knob at the arc end: white circle r=8 with 1px `#e2e8f0`, plus `#2563eb` dot r=3.4; scales to 1.22 while dragging, transition 180ms.
    - Centre: remaining time JetBrains Mono 34px/700, tabular nums, `#0f172a` (shows "∞" for open end); below it JetBrains Mono 11.5px `#94a3b8` — "ends 10:28" / "no end time". The number plays `numPop` (scale 1.07→1, 220ms) on each 5-minute snap.
  - **Right column**: four preset buttons stacked (gap 8px), each a row with name left and duration right — JetBrains Mono 11px/700 uppercase, padding 11px 14px, radius 8px, 1px `#e2e8f0`; selected: 1px `#2563eb`, background `#eff6ff`, text `#1d4ed8`, meta `#2563eb`. Presets: Pomodoro 25, Deep work 50, Long haul 90, Open end ∞.
  - Below: primary "Start focus" button (white on `#2563eb`, radius 8px, padding 12px 20px, hover lift + shadow); label becomes "Pause" while running. Under it a JetBrains Mono 11.5px `#94a3b8` line — "`<n>` sessions today · `<n>` blocked".

#### Card 3 — App blocker (right, 1/4)
Padding 20px 18px, column flex, gap 14px, radius 14px, `overflow: hidden`, `position: relative`.
Two visual states, transition 320ms:
- **Idle**: background `#ffffff`, 1px `#e2e8f0`.
- **Active**: background `#172554` (brand-950), border `#172554`; labels `#60a5fa`, item names `rgba(255,255,255,0.85)`, muted text `rgba(255,255,255,0.35)`, borders `rgba(255,255,255,0.12)`.

Contents top to bottom:
1. Header: "APP BLOCKER" label + switch (44×24px pill; off `#e2e8f0`, on `#2563eb`, 18px white knob, 200ms).
2. Profile block: "PROFILE" label; on the right "EDIT" / "+ NEW" links — kept in the DOM but faded to `opacity: 0` + `pointer-events: none` when active, so nothing shifts. Below, a fixed-height 30px row holding either the profile chips (idle) or the active profile name (JetBrains Mono 14px/700, white) when active.
3. A 2px-tall slot for the activation sweep (a `#3b82f6` bar scaling in from the left, 620ms, fading out).
4. Item list: rows 9px 11px, radius 9px, 1px border; 17px tick box (blocked = filled), name JetBrains Mono 12.5px (struck through + muted when unblocked), kind ("site"/"app") right-aligned JetBrains Mono 10.5px. Clicking a row toggles that entry.
5. Add row (`opacity: 0` + inert when active): mono input "add app or domain" + "ADD" ghost button. Entries containing a dot are stored as sites, otherwise as apps.
6. "Blocked today" tile pinned to the bottom (radius 12px, 1px border, padding 16px): label, count JetBrains Mono 28px/700, caption Inter 13px.

**Activation animation (lock).** When the blocker is switched on:
- Full-card overlay (`z-index: 3`, non-interactive) with a 72px Heroicons-style padlock outline in `#60a5fa`: `lockPop` (scale 0.7→1→1.04, opacity 0→1→0) 900ms; the shackle path additionally plays `shackle` (translateY -5px→0, fade out); a 150px ring with 2px `#3b82f6` border plays `ringOut` (scale 0.5→2.1, opacity 0.45→0).
- The 2px sweep bar scales in horizontally.
- Every item row flashes `lockIn` (background `#eff6ff`, border `#93c5fd`, translateX -3px → its own styles) 380ms with 45ms stagger. **No `animation-fill-mode`** — the rows must fall back to their own styles and hover states.
- Animation names alternate between `…A`/`…B` variants so they restart on every activation.

### 2. Focus session running (full-window)
Replaces the whole body (height 736px, background `#172554`), entrance `focusIn` (opacity + scale 0.97→1) 420ms.
- Start burst: 300px `#2563eb` circle, `startBurst` (scale 0.05→2.6, opacity 1→0) 620ms.
- "In focus": 8px `#60a5fa` dot with `pulseDot` 2.6s infinite + label JetBrains Mono 11px/700, tracking 0.2em, uppercase, `#60a5fa`.
- Ring: 340×340px SVG (`viewBox 0 0 200 200`), track circle r=91 3px `rgba(255,255,255,0.10)`, progress circle r=91 3px `#3b82f6` round caps rotated -90°, `dashoffset` driven by remaining fraction with `transition: stroke-dashoffset 1000ms linear` (smooth, no per-second flicker).
- Centre: remaining time JetBrains Mono 72px/700, tabular nums, white. **No animation on the digits.**
- "STOP" button: transparent, 2px `rgba(255,255,255,0.16)`, radius 8px, padding 13px 30px, text `rgba(255,255,255,0.7)`; hover border `rgba(255,255,255,0.4)`, text white.
Nothing else is visible during a session.

### 3. Project editor (sheet)
Overlay `rgba(15,23,42,0.4)` over the window, `backdropIn` 200ms; sheet centred horizontally, 36px from the top, `sheetIn` (translateY -18px + scale 0.985 → none) 260ms. Sheet: 900px wide (600px for the profile editor), `#ffffff`, 1px `#e2e8f0`, radius 14px, `--shadow-xl`, padding 26px 30px. Designed to fit **without scrolling**.
- Eyebrow "SETTINGS · PROJECT", title "New project" / "Edit project" (JetBrains Mono 22px/800).
- Name field: label + input (radius 8px, 1px `#e2e8f0`, padding 11px 13px, focus ring `#3b82f6` + 3px `rgba(59,130,246,0.18)`).
- Two-column grid `268px 1fr`, gap 26px:
  - **Left — "APPS & WEBSITES"**: "Choose from Finder…" button (ghost, 2px `#e2e8f0`, folder icon) opens the Finder picker; a website input + "ADD" button (adds and places it immediately); below, a 2-column chip grid inside a `#f8fafc` box — one chip per app in the library (Inter 11.5px, pill, 1px `#e2e8f0`). Chips already placed in this project are **greyed out** (`#f1f5f9` background, `#cbd5e1` text, `cursor: default`, not draggable).
  - **Right — "WINDOW LAYOUT"**: the monitor stage; below it two `ds-small` hints.
- **Monitor stage**: flex row, gap 12px. Monitor 1 wrapper `flex: 1.6`, Monitor 2 `flex: 1` (the ratio must sit on the wrapper, not the aspect-ratio box). Each monitor: `width: 100%`, `aspect-ratio: 16/10`, background `#f8fafc`, 2px `#172554` bezel, radius 10px, `overflow: hidden`; caption below (JetBrains Mono 10px `#94a3b8`) — "Monitor 1 · 27″", "Monitor 2 · 14″".
- **Window tiles** (absolutely positioned in % of their monitor): radius 7px, padding 8px 10px, 1px `#bfdbfe` / selected 1px `#2563eb`, background `#ffffff` / selected `#dbeafe` + `--shadow-md`. Content: app name (JetBrains Mono 11.5px/700, ellipsis), size readout ("62×100", JetBrains Mono 10px `#94a3b8`), an 18px round × button top-right (grey idle, `#2563eb` when selected), and a 14px resize handle bottom-right drawn as two 2px `#2563eb` borders (`cursor: nwse-resize`).
- Footer: 1px top border; "SAVE" (primary), "CANCEL" (ghost), and "DELETE" pushed right (10.5px/700 uppercase `#94a3b8`, hidden when creating).

### 4. Focus-profile editor (sheet)
Same shell, 600px wide. Name field, then "BLOCKED APPS & SITES" with "+ ADD ENTRY"; each row: mono name input, a pill button toggling kind between `site` (`#1d4ed8`) and `app` (`#64748b`), and a × remove. Rows enter with `fadeUp` 240ms. Footer identical (Save / Cancel / Delete). Deleting is blocked when only one profile remains.

### 5. Finder picker (sheet above the editor)
Overlay `rgba(15,23,42,0.45)`, 96px top padding. Panel 700px, radius 12px, `overflow: hidden`.
- Chrome bar 42px, `#f8fafc`, traffic lights + centred title "OPEN — <folder>".
- Grid `176px 1fr`, height 320px. Sidebar `#f8fafc`, "FAVOURITES" label, entries Applications / Desktop / Documents / Downloads with folder icon; selected `#eff6ff` + `#1e40af`.
- File list: header row (Name / Date modified / Kind / Size, columns `1.4fr 1fr 0.9fr 0.6fr`), rows 8px 12px, 12.5px; selected row background `#2563eb`, white text, `translateX(3px)`, 160ms transition. Folders are muted `#64748b` and not openable. Empty folder → centred "Empty folder".
- Footer `#f8fafc`: current selection (mono 11.5px), "CANCEL" ghost, "OPEN" primary — disabled look (`#e2e8f0` / `#94a3b8`) with no selection; on each new selection it plays `btnPulse` (box-shadow ring 0→11px, 620ms).
- Double-clicking a file opens it directly. Opening adds the app to the library and places a 50×100% window on Monitor 1.

### 6. Blocked page (separate surface)
700×340px, `#172554`, radius 14px, centred: 44px icon chip `rgba(37,99,235,0.2)` with the no-symbol icon in `#60a5fa`; eyebrow "<site> IS BLOCKED · <profile>"; headline "Session runs until 10:28." (JetBrains Mono 28px/800); sub-line "<project> · <profile> · 12:34 left"; buttons "Back to work" (primary) and "Unlock 2 min · 1 left" (ghost on dark).

## Interactions & Behavior
- **Project select** — click a card: activates it, resets the launch state. Does **not** touch blocker profile or timer.
- **Launch workspace** — 520ms interval flips each app row to "open"; after the last one the button becomes "Re-arrange".
- **Dial** — `mousedown` on the dial starts a drag; `mousemove` computes the angle from the dial centre (`atan2(dx, −dy)`, 0° at 12 o'clock), maps it onto 0–120 min, snaps to 5-minute steps, clamps to ≥5. Releasing ends the drag. Every snap resets `secondsLeft` and pulses the centre number.
- **Presets** — set minutes (0 = open end) and reset the countdown.
- **Start / Pause** — toggles the running state; starting resets elapsed. Running swaps the whole body to the focus view. "Stop" ends the session, counts it, and resets the countdown.
- **Timer tick** — 1s interval: open end counts up, otherwise counts down; at 0 it stops and increments the session count.
- **Blocker switch** — toggles active state; turning on plays the lock animation and hides profile switching, Edit/New and the add row (opacity, not removal, so nothing jumps).
- **Item toggle** — click a row to include/exclude that entry for the selected profile (per-profile state, keyed `profileIdx|name`).
- **Window layout** — drag a chip from the library onto a monitor (HTML5 drag & drop) to place a 50×100% window centred on the cursor; drag a tile with the mouse to move it (it can cross monitors — the monitor under the pointer wins); drag the corner handle to resize (min 15%, snapped to 2.5%); drop a tile outside both monitors, or click its ×, to remove it.
- **Save / Cancel / Delete** — Save writes the draft back (empty name → "Untitled project"/"Untitled profile"; windows without a name are dropped) and closes; Cancel discards; Delete removes the entity unless it is the last one.

### Motion tokens
Easing `cubic-bezier(0.4, 0, 0.2, 1)` everywhere. Buttons 200ms (`translateY(-1px)` + `--shadow-md`), cards 300ms (`translateY(-4px)` + `--shadow-lg`), colour/state transitions 200–320ms, focus ring `0 0 0 3px rgba(59,130,246,0.18)`.
Keyframes used: `fadeUp`, `rowIn`, `tickIn`, `barGrow`, `numPop`, `focusIn`, `startBurst`, `pulseDot`, `sheetIn`, `backdropIn`, `lockPop`, `ringOut`, `shackle`, `shieldSweep`, `lockIn`, `btnPulse`. Where an animation must replay on repeated triggers, two identical variants (`…A` / `…B`) alternate by a counter's parity — a real implementation can instead re-key the element.

## State Management
```
projects: [{ name, apps: [{ name, mon, x, y, w, h }] }]   // x/y/w/h in % of the monitor
profiles: [{ name, items: [[name, "site" | "app"]] }]
activeIdx        // selected project
profileIdx       // selected blocker profile
launchStep, launched
running, minutes (0 = open end), secondsLeft, elapsed, sessions
blockingOn, off: { "<profileIdx>|<name>": true }   // per-profile exclusions
attempts         // blocked attempts today
editor: null | { kind: "project" | "profile", idx: number | null, draft }
selWin           // selected window tile in the editor
customApps, newAppName, newItem
finderOpen, finderDir, finderSel
dialActive, dialPulse, blockPulse, finderPulse   // animation triggers
```
Drag state is kept outside React state (`this.drag = { mode: "move" | "resize" | "dial", i, grabX, grabY, outside }`) with `mousemove`/`mouseup` listeners on `document`.

No data fetching in the prototype. A real app needs: persisted projects/profiles/stats, live window geometry from the OS, and blocked-attempt counters.

## Design Tokens
Colours (App-Care design system, single blue accent + slate neutrals):
`brand-50 #eff6ff`, `100 #dbeafe`, `200 #bfdbfe`, `300 #93c5fd`, `400 #60a5fa`, `500 #3b82f6`, `600 #2563eb` (primary), `700 #1d4ed8`, `800 #1e40af`, `900 #1e3a8a`, `950 #172554` (dark surfaces).
`slate-50 #f8fafc`, `100 #f1f5f9`, `200 #e2e8f0`, `300 #cbd5e1`, `400 #94a3b8`, `500 #64748b`, `600 #475569`, `700 #334155`, `800 #1e293b`, `900 #0f172a`, `950 #020617`. White `#ffffff`. Traffic lights `#ff5f57 / #febc2e / #28c840`.

Type: **JetBrains Mono** (headlines, labels, buttons, all numerals — 800 for titles, 700 for labels, tracking -0.02em on headlines, 0.1–0.15em uppercase on labels) and **Inter** (body). Sizes in use: 9.5, 10, 10.5, 11, 11.5, 12, 12.5, 13, 13.5, 14, 22, 28, 34, 72px.

Radii: 5px (ticks/boxes), 7px (window tiles), 8px (buttons, inputs), 9–10px (list rows), 12px (inner panels), 14px (cards, window), pill/`9999px` (chips, switches).
Borders: 1px `#e2e8f0` default, 2px `#e2e8f0` for ghost buttons, 2px `#172554` monitor bezels.
Shadows: `sm 0 1px 2px rgba(15,23,42,.05)`, `md 0 4px 6px -1px rgba(15,23,42,.08), 0 2px 4px -2px rgba(15,23,42,.06)`, `lg 0 10px 15px -3px rgba(15,23,42,.08)`, `xl 0 20px 25px -5px rgba(15,23,42,.10)`. Flat at rest, shadow on hover only. No gradients, no blur, no emoji.
Spacing: 4 / 6 / 8 / 10 / 12 / 14 / 16 / 20 / 26 / 32px.

## Assets
No bitmaps. All icons are inline SVG in the Heroicons style (folder, no-symbol, padlock, check, play/pause) — outline `stroke-width 1.5–2`, `viewBox 0 0 24 24`; solid check `viewBox 0 0 20 20`. Fonts are the self-hosted App-Care variable fonts (Inter, JetBrains Mono); use the equivalents already in the target codebase.

## Platform notes (macOS)
- **Window arrangement** requires Accessibility permissions (`AXUIElement`) to move/resize other apps' windows; monitor geometry via `NSScreen`. The editor's %-based coordinates map onto each screen's `visibleFrame`.
- **App blocking** needs either a Screen Time/`FamilyControls`-style approach or a supervising helper; website blocking typically a browser extension or a local DNS/proxy. The prototype's blocked page is the design for that intercept screen.
- **Status bar** — the running session should be reachable from a menu-bar item (an earlier iteration of this design showed the countdown there); the window is optional while a session runs.
- **Launching** apps: `NSWorkspace.openApplication`, websites via the default browser.

## Files
- `Focus Prototype.dc.html` — the prototype in this handoff (Projects, blocker, session, editors, Finder picker, blocked page). Open directly in a browser.
- `Focus App.dc.html` — the earlier, broader concept (dashboard, tasks & calendar, blocking, stats) kept as reference for where the product could grow.
- `_ds/app-care-design-system-…/colors_and_type.css` — the design tokens both files consume.
