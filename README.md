# Focus (workspace_flow)

A macOS focus app with three decoupled features:

1. **Projects** — saved window layouts. Launching a project opens the same apps in the same
   places across the attached displays, every time.
2. **App blocker** — profiles bundling blocked apps and websites; a profile is armed on its
   own and is never bound to a project.
3. **Focus session** — an egg-timer dial, four presets, and a distraction-free running view.

The UI is a 1:1 build of `design_handoff_focus_app/` (see its `README.md` for the design
contract: colours, type, spacing, radii, motion timings and copy).

## Running

```
make run          # flutter run -d macos
make build-runner # riverpod + freezed + drift codegen
make analyze
make test
make test-architecture
```

Requires Flutter 3.41.9 / Dart 3.11.5 and Xcode. Deployment target is macOS 13
(`SMAppService` for the login item).

**The app sandbox is deliberately off.** Positioning other apps' windows through
`AXUIElement`, launching arbitrary apps and writing `/etc/hosts` are all impossible inside
it. Distribution is Developer ID + notarisation, not the Mac App Store.

On first launch macOS asks for **Accessibility** permission. Without it a project still
opens its apps, but their windows land wherever macOS puts them — the launch reports this
so the UI can offer the system settings.

## Architecture

Four layers, following `s-broker-mobile-app`:

```
lib/
├── common/        cross-cutting; depends on no other layer
├── data/          repositories, drift tables and DAOs, the macOS bridge
├── domain/        models and services (= use cases); never reaches into the UI
└── presentation/  design system, router, screens; goes through domain, never data
```

The layer rules, the file-naming conventions and the "no relative imports / no
`print` / no direct `Platform.`" rules are **enforced by tests** in `test/architecture/`.
That suite is what keeps the conventions true — run it before pushing.

| Concern | Choice |
|---|---|
| State + DI | Riverpod 2 with `riverpod_generator`; no `get_it`. Riverpod *is* the container. |
| Models / state | `freezed` |
| Persistence | `drift` (SQLite) in Application Support |
| Routing | `go_router` with a `UiRoute` enum; the editors are transparent sheet routes |
| Errors | Plain exceptions plus `AsyncValue.guard` — no `Either`/`Result` |
| i18n | `gen-l10n`, template `lib/common/translation/app_en.arb` |
| Tests | `mocktail`, Given/When/Then descriptions |

### File naming

`snake_case` plus a role suffix, and the file must declare what its name promises:
`*.repository.dart` (data only) · `*.dao.dart` · `*.tables.dart` · `*.entity_mapper.dart` ·
`*.service.dart` (domain only) · `*.screen.dart` / `*.controller.dart` / `*.state.dart`
(presentation only) · `*.enum.dart` · `*.extension.dart` · `*.util.dart` ·
`*.color_palette.dart` · `*.channel.dart`.

### Design system

`lib/presentation/design_system/` — atoms (`UiColor`, `UiSize`, `UiRadius`, `UiSpacer`,
`UiShadow`, `UiMotion`, `UiTypography`, `UiIcon`), molecules, organisms. **Use `UiColor.x`
and `UiSize.x` in screens**; reach for `Theme.of(context)` only where a Material widget
insists on it.

The app has a single light theme. The dark surfaces — the armed blocker card and the
running session — are *component* variants using the `UiColor.onDark*` roles, not a second
theme.

Icons are Heroicons path data (`UiIcon`) rendered by `UiSvgIcon`; `SvgPathUtil` parses the
`d` attribute so paths can be copied verbatim from the design.

### macOS bridge

`packages/workspace_flow_system/` is a local Flutter plugin holding all the Swift. Keeping
it in a plugin means CocoaPods picks up every file in `macos/Classes/` — no manual
`project.pbxproj` bookkeeping when a service is added.

| Swift | Purpose |
|---|---|
| `ScreenService` | `NSScreen` geometry, flipped into a top-left origin |
| `AppLauncherService` | `NSWorkspace` launching, installed-app discovery, `NSOpenPanel` |
| `WindowControlService` | `AXUIElement` position/size, polling until a window exists |
| `StatusItemService` | menu-bar countdown |
| `LoginItemService` | `SMAppService` |
| `BlockedWindowService` | the blocked page in a second `FlutterEngine` |
| `BlockerEnforcementService` | **stub** — see below |

Dart reaches it through the single `MacosBridgeChannel`, with one typed repository per
concern in `data/system/repository/`.

## Not done yet

**Blocker enforcement.** Profiles, arming, the animation, the per-entry toggles and the
statistics all work, but nothing is actually blocked: `blockerEnforcementRepositoryProvider`
returns `FakeBlockerEnforcementRepository`. The interface is already shaped for the intended
macOS approach — apps polled through `NSWorkspace.runningApplications` and hidden or
terminated, domains written into `/etc/hosts` by a privileged helper the user approves once.
Swapping the provider for `MacosBlockerEnforcementRepository` and filling in
`BlockerEnforcementService.swift` is the whole remaining change on the app side.

Because of that, the blocked-page window is reachable only from native code today, and
"Blocked today" stays at zero until something records an attempt.
