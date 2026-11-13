# UI components comparison

This comparison measures [Facet](https://github.com/josha/Facet), a library of Roblox UI controls, against a `plain` lane. It has 30 workloads. Each workload is a complete player task, such as a settings screen, a leaderboard or a chat log. The `plain` lane uses Instances, native layout objects, a hand-built StyleSheet and plain Luau state for the controls. The `plain` lane uses no library: no Facet, no Compose, no Facet theme compiler and no Facet theme tokens. Each lane builds its own StyleSheet when it mounts. Cold mounts and complete lifetimes include that setup cost in each lane.

## Disclosure

The maintainers of Facet wrote both lanes. Review the `plain` lane as strictly as the Facet lane. The `plain` lane must show the same player-visible result as the Facet lane, with no less and no more. If a `plain` lane does work that a careful Roblox developer would not do, or skips work that the task needs, open an issue or a pull request.

The `plain` StyleSheet copies its values from the Facet neutral Dark theme at the pinned commit: colours, typography, corners, padding, scrim, scroll bars and paint transitions. The copy keeps the two lanes visually equal. It does not make the `plain` lane depend on Facet. The `plain` lane also copies the theme motion values (dialog, toast, radial, travel and region pop durations and easings) as constants.

## What the lanes match

Each lane links its own theme StyleSheet inside its ScreenGui before the ScreenGui enters the DataModel. The Facet lane builds the Facet neutral theme StyleSheet and its StyleLink inside the Facet tree. The `plain` lane builds its StyleSheet in `workloads/plain-theme.luau` with StyleSheet, StyleRule, StyleLink, sheet attributes for colour and motion tokens and native StyleRule transitions. `plain` Instances carry `pl-` tags that this sheet styles. They do not carry `facet-` tags.

The `plain` controls match the Facet controls in player-visible behavior. Stacks hug their content unless the task gives a width, have no gap unless the task gives one and number their children in order. Grids fill the available width. Buttons keep a 44-pixel height and, when the preferred input is not keyboard and mouse, a 44-pixel minimum target. A selected `plain` button activates with Return or Space at priority 5000, except while a TextBox has focus, as a Facet Button does. `plain` readouts hold their widest same-length width, as Facet text does. Each world has its own width cache. `plain` keeps references to the Instances that it updates.

The `plain` lane runs in a world that has no library fields. A read of `world.Facet`, `world.Compose`, `world.runtime`, `world.Host`, `world.UI` or `world.motion` in the `plain` lane stops the run with an error. Both lanes get the same TextService, GuiService and UserInputService.

The `plain` lane implements the player-visible behavior that each task reaches: focus and selection, back and cancel input, modal traps, drag feedback and motion. Facet keeps extra internal policy for cases that these tasks do not reach, such as pooled adjustment contexts, rename actions and fallbacks. The `plain` lane does not copy that policy. The extra Facet policy is part of the Facet cost.

Facet adds wrappers and control chrome, so the two trees are not equal. Each workload declares the observations that both lanes must match. `S.observe` gives lane-independent observations for the named nodes that both lanes share: text, effective visibility, styled text colour, size, font and transparency, styled background colour and transparency, the selected object, the enabled input contexts with their keys in priority order, and rounded absolute position and size when the world computes layout. Workloads also compare fill fractions, selection traps and similar task state. Headless parity compares these observations at mount and after every iteration, then checks Instance and connection counts one frame after teardown. The frame lets the engine double release the style signals of destroyed Instances, as the engine does when it destroys them. Inventory, dialog, tabs, radial, transfer, grid traversal, drag reorder and stacked modal checks also require the requested result. Equal missed input cannot pass those checks. Inventory, localization, rotation and reorder checks retain Instance identity.

The `plain` lane is the floor. `tools/check-floor.luau` fails a comparison when every sample of a library lane is faster than every `plain` sample. It lists each workload where a library lane's median is below 0.9 of the `plain` median within the `plain` sample range, and each workload where `plain` writes or creates more than the library lane.

Studio runs an unmeasured parity pass through both lanes before it profiles either lane. It compares full strings at every checkpoint. A different checkpoint stops the case before timing. Each later sample must reach the final state that its own lane verified. Snapshot collection is outside the profiler. Each lane reports a digest of its own checkpoint sequence. The report shows "no" when the digest of a lane is not equal to the digest of the `plain` lane.

## Motion

The dialog, toast, radial and transfer workloads use `TweenService` in `plain` and the public control motion in Facet. Both lanes use the same duration and easing: Facet reads its theme, and `plain` uses the constants that it copied from that theme. Studio waits for the requested duration and advances real frames. Headless advances its simulation clock. Navigation and tabs set `transition = false` in both lanes.

Facet's [styling guide](https://github.com/josha/Facet/blob/9cb4aecd2b02b877f161f9a1c617b5445bebe019/docs/guide/styling.md) recommends native StyleRule transitions for paint and game-owned geometry. `button-feedback-50` uses native theme paint rules in both lanes: the Facet theme rules in Facet and the copied rules in `plain`. `button-native-scale-50` adds the geometry variant: a stable Button hit target contains a visual face and an inner `UIScale`. Both lanes install the same rest and pressed rules, with a Scale transition on entry and exit. The measured step changes the same state tag on 50 controls. It does not move a layout-owned Size or Position. Headless checks the styled Scale during and after the transition. Studio checks the settled styled Scale.

The pinned public Dialog, Toast, RadialMenu and draggable APIs do not offer a StyleSheet motion backend. Their presentation and drag motion also control retirement, input, focus or preview cleanup. A StyleRule cannot complete those Luau lifecycle operations. Replacing their private timelines would change library code. Those workloads therefore keep their public motion paths. The geometry variant measures native motion separately; it does not claim to replace a modal or a drag lifecycle.

## Workload catalog

Every workload has both lanes and headless parity.

| Workload | Task and observations |
| --- | --- |
| `main-menu-cold` | Install the theme StyleSheet and mount a title, six actions and a footer on a surface, as `Facet.app.mount` installs its theme with the screen. Check their text, paint and geometry. |
| `hud-60-frames` | Update health, ammo, coins and a timer once per frame for 60 frames. Check text, fill, paint and geometry. |
| `world-markers-50` | Update 50 BillboardGui labels in the player's GUI, adorned to anchored Parts in the Workspace. Facet uses `UI.worldSurface`. Check text, paint and placement. |
| `inventory-500` | Select retained slots in a 10-column grid through each slot's activation target. Check the requested key, one plate with selected paint after paint settles, retained labels and targets, and the plate, target and geometry of the edge and neighbouring slots. |
| `shop-filter-200` | Filter 200 retained actions through a TextBox, including empty and missing matches. Check the visible rows, field and button paint and geometry, the canvas and the editing input contexts. |
| `virtual-scroll-2000` | Move a 400-pixel window through 2,000 rows with two rows of overscan. Plain reuses a 15-row pool. Check the position and text of each shown row, the canvas and the first and last mounted rows. |
| `chat-append-250` | Append messages and retain the last 100. Check message order by position, the canvas and the oldest and newest message. |
| `card-collection-60` | Mount 60 cards in 128-pixel grid cells. Theme setup is outside the step. Check artwork, title and caption, and the card, body, artwork and text paint and geometry. |
| `mixed-scroll-300` | Scroll retained text, action and card rows. Check content, canvas size, the rows on screen and the paint of a text card. |
| `settings-17-values` | Activate ten toggles, set four sliders (through the model in headless, with a track drag in Studio) and activate three picker segments. Check readouts, toggle paint, slider fill and thumb, the picker fill slide and segment paint. |
| `text-input-200` | Type into a validated TextBox. While it edits, InputContexts hold the arrow keys, and Escape or ButtonB cancels to the text at focus. Cancel after the 100th character, then focus again. Check text, paint and contexts. |
| `button-feedback-50` | Visit Hover, Press and Idle, one frame each, on 15 of 50 buttons. Check the styled paint during each state and the settled paint. |
| `stepper-segments-100` | Change a bounded quantity and a segmented choice, one frame per change. Every tenth change goes through Increase and a segment. Check the readout, the dimmed limits, segment paint and the selection fill slide. |
| `toast-stream-4` | Show and expire 4 one-shot toasts, with at most three shown and eight queued. Check messages, the stack, row and message paint and geometry, and the fade one frame into each entry. |
| `tabs-5-5-switches` | Select and activate five tabs. Check the requested page, retained pages, each tab's ink, during and after its transition, and underline, the selected tab and the L1/R1 contexts. |
| `radial-15-cycles` | Open a donut ring from its launcher at the screen center and activate Wave. Facet sets `ringWidth = 96` and `contentFit = "none"`. Check one commit per close, the launcher, scrim and sector paint, center and item geometry during and at the end of each entry and exit, and the input contexts. |
| `navigation-5-6-cycles` | Push five pages, then select and activate each Back button. Check the top title, the Back button with its chevron and label, retained content, focus after each pop and the back context. |
| `leaderboard-100` | Sort 100 retained rows by name, replace scores and scroll down, press the Score header for ascending and then descending order, replace scores again and let rows settle. Facet columns set `resizable = false`. Check sort and row order, header labels and dividers, the scroll reset, row plates and cell text. Moving rows are reported without geometry. |
| `theme-swap-200` | Change the content colour on 200 buttons and back. Plain sets one colour attribute on its theme sheet; Facet updates its theme source. Check the colour token and each button during and after the transition. |
| `heavy-screen-20-cycles` | Replace a scroll view of 200 actions and 200 text rows 20 times inside one themed ScreenGui. Check that each lifetime is new and that the previous one is released, and check canvas, text, paint, geometry and teardown. |
| `tile-transfer-20` | Pick up 20 tiles with Return and drop each in a second grid after the previous preview shrinks. Check each requested parent, the held text, preview geometry, the status panel and its hint, input contexts, the shrinking preview and cleanup. |
| `gamepad-grid-6x6` | Walk all 36 cells in a snake path with D-pad input. Check focus, native selection inside the expected row and the priority-200 collection contexts at every requested cell. |
| `input-type-switch-20` | Switch a preferred-input fact between keyboard and gamepad on a 20-control screen. Facet reads `UI.environment().effectiveInput`. Check all prompts. This measures adaptation after device detection, not controller connection or detection. Check geometry and paint. |
| `phone-rotation-hub` | Resize a retained hub between portrait and landscape phone sizes. Facet binds `AdaptiveStack.axis` to `UI.environment(source).isLandscape`. Plain observes AbsoluteSize and changes its list direction. Each step waits two frames: Facet publishes measured geometry on the next frame, and both lanes show the new direction on the same rendered frame. Check card, task and action geometry and paint, and that the actions are retained. |
| `text-size-preference-50` | Change an authored preference through four text-size ranks. Facet uses `environment.preferredTextSize`; plain updates its own body rule. Check every label's styled TextSize and geometry. The native account preference stays fixed. |
| `localized-text-swap-50` | Change 50 labels between English and German through the same LocalizationTable translators. Facet binds Text to the selected translator; plain assigns translated text. Check text, identity and AutoLocalize. The native locale stays fixed. Check geometry and paint. |
| `hud-composition-step-down` | Resize a HUD between 800 and 400 layout units. Facet uses Composition and a Region with rich and compact forms. Plain measures each form against a centred top zone, shows the richest form that fits and pops it in with the theme pop rule. Check visibility, geometry and identity in both directions, and the pop scale in headless. |
| `drag-reorder-100` | Pick up the first row and drop it after the fifth, 20 times, in a retained 100-row list. Facet uses VirtualList `reorderable` and commits `onReorder` proposals to its source. Plain uses UIDragDetector with a 6-pixel start threshold, a drop line, a hidden source, keyboard reorder and row travel. Check the drop line, the cancel context and row travel during each drag, and every row's order and identity after each drop. |
| `modal-on-modal` | Open an inner confirmation over an outer dialog, then close each in stack order. Check titles, traps, one acceptance per close, panel geometry and paint, enabled inputs and native focus restoration. |
| `button-native-scale-50` | Change a geometry state on 50 retained button faces through native StyleRule transitions. Check the settled styled Scale, stable hit bounds and, in headless, the Scale during the transition. |

## Adapter review

The review uses the documentation and source at the Facet commit in `dependencies.lock.luau`. The source checkout can omit docs through sparse checkout; `git show HEAD:<path>` in that checkout reads the pinned docs without changing library files. The public site can describe a different revision.

The reviewed contracts are `docs/guide/styling.md`, `docs/guide/input.md`, `docs/guide/performance.md`, `skills/use-facet/SKILL.md` and these files under `docs/reference/nodes`: `Text.reference.md`, `AdaptiveStack.reference.md`, `environment.environment.md`, `environment.luau.md`, `Collections.focus-controls.md`, `VirtualList-and-VirtualGrid.ContentProvider.md`, `Editable-collections.reorderable.md`, `Editable-collections.single.md`, `Composition.call.md`, `Composition.regions.md`, `Composition.layout.step-down.md` and `focusSection.md`. Native input sequences also follow `tools/studio/live/interactive.luau` and `tools/studio/live/init.luau`. Source checks include the text measurement, picker, card, tab, collection reorder, environment, dialog, toast and theme implementations.

The review applies these choices and corrections:

- Readouts use public Text bindings in Facet. Plain keeps direct references and a same-length width reservation. Font or TextSize changes reset that reservation. Stale asynchronous measurements cannot restore an old reservation.
- Inventory uses public VirtualGrid selection. Plain changes only the old and new selected plates. Both lanes retain the slot targets. Virtual scrolling keeps the existing plain row pool. Chat keeps incremental append and removal. Mixed screens and complete lifetimes retain their native layout paths.
- Plain cards carry the `plain` panel and flush tags, label typography for titles and secondary caption typography. The plain main menu uses title typography on a surface. The artwork and aspect ratio stay the same in both lanes.
- Settings remain model-update tasks. Plain updates picker selection as well as the readout, and puts segments in their layout row. Stepper bounds include disabled and native Interactable state. Parity checks the selected and disabled tags.
- Tabs activate a real control in both lanes. Facet does not receive a direct selection-model write in place of input. Plain releases its GuiService selection subscription when the screen stops.
- Plain screens use one shared Return and Space binding at priority 5000 for the selected control. Disabled controls do not activate, and the binding does nothing while a TextBox has focus. The screen releases the selection observer at teardown. This supplies keyboard activation for native buttons without one InputContext per button.
- Dialog, toast and radial keep their public Facet controls and equivalent plain presentation state. The shared Studio driver adds real input. Plain uses the existing TweenService service in Studio and does not create or destroy a service Instance.
- Navigation retains covered pages and uses no transition in either lane. Transfer uses the same Return activation facts in both hosts, with public draggable and dropTarget helpers in Facet.
- Plain leaderboard score updates sort again only while score is the sort column. Name and win order do not change when only scores change. Theme swap keeps each lane's documented native styling path.
- Adaptation tasks use public environment facts, Text bindings, AdaptiveStack, Composition and Region. Reorder uses the public proposal callback and a new source array. Stacked modals use two public Dialog controls. No library implementation is changed.

The stacked modal task starts on a retained entry control and uses keyboard acceptance with a gamepad preferred-input fact. Both lanes disable the covered controls, keep only the upper modal input active and restore selection in stack order. Headless checks these states with a GuiService double as well as the final accepted state.

Each lane builds its own theme StyleSheet at mount. A cold-mount number includes the Facet theme compiler in Facet and the hand-built sheet in `plain`. A control-only mount comparison would need a separate workload with prebuilt theme sheets in both lanes.

## Headless run

The headless run uses the Verify reflection engine double, not the scene composition cost model, because the controls need text services, StyleSheets, input contexts and drag detectors. Facet loads through the same like-for-like loader as the scene composition libraries: optimization level 2 and no native code. Its source has no change. The loader binds the reflection datatypes and `typeof`, so vectors, enums and Instances have the same identities as the host double. Its `getfenv` returns those globals with no `game`, so Facet takes its headless paths. Reports disclose loader fallback files.

Headless parity runs every workload in a native world: simulated layout, the StyleSheet cascade with eased transitions, native selection validation, a GuiService, a PlayerGui and the simulated input host. Layout measures text with the same function that answers `TextService:GetTextBoundsAsync`. The native world does not project world-space GUI, so it does not lay out decorative BillboardGuis. Headless timing keeps its existing world: except for traversal, timing does not solve native geometry, does not apply StyleSheets and does not interpolate native StyleRule transitions. Rotation supplies the source size. Composition supplies the authored form sizes and available zone size to the double. Reorder supplies DragStart, DragContinue and DragEnd positions to the native detector handlers. These checks cover the library's state and public callbacks. They do not prove native hit testing, native focus reachability or rendered layout.

Headless traversal presses D-pad key pairs through Verify's simulated input host, as Studio does through its native input host. Its parity and timing worlds also connect a virtual controller, so the preferred input is the gamepad. Other parity worlds keep keyboard and mouse as the preferred input. Both lanes use the same key driver and check GuiService.SelectedObject at each cell. Simulated selection does not prove native spatial reachability.

After each workload mounts, both lanes run 30 frames before the first observation and before timing, in the headless and the Studio runs. Timing then measures updates, not mount-time settling. The cold-mount and lifetime workloads mount inside their timed steps.

The run checks parity for every workload, then collects nine time samples after two warm-up samples, with the yardstick and calibration attempts of the [scene composition method](../scene-composition/method.md#calibration), three retained-heap measurements and one instrumented pass that counts property writes and created Instances. Each time sample collects garbage after its scene is prepared and before the timed steps. Heap is the reading with the scene mounted less the reading before the scene was prepared, and Teardown is the reading after the scene stops less the same baseline. Every workload enters both geometric means, and a heap ratio counts a reading below 1 KiB as 1 KiB. Parity requires the Instance and connection counts one frame after the scene stops to equal the counts before it was prepared. In `gamepad-grid-6x6` both lanes include simulated input routing and selection work. Studio's native engine routing stays outside its profiler scope. In `drag-reorder-100` the plain lane draws an insertion line and Facet draws a drag ghost, so the Facet lane creates more Instances.

```bash
lute run comparisons/ui-components/compare.luau --verify
lute run comparisons/ui-components/compare.luau --out build/ui-components-comparison
```

## Studio client run

The Studio run enables every workload against real Instances in a Roblox Studio play client. It loads Facet once for each case, from a fresh copy of its module tree, and times Luau work with the client script profiler, as the scene composition Studio run does. Each sample ends with a real frame. Workloads alternate which lane runs first. Both lanes get the same warmup and sample count. When the warmup sample is shorter than 5 ms, each measured sample is the mean of up to 8 complete samples that fit in 0.5 seconds of wall time, so the 100 µs profiler resolution adds less error. A sample that the profiler counts below 100 µs takes the `os.clock` time of its steps instead, capped at 100 µs; work that short runs within its steps and has no frame wait to exclude. After 3 measured samples, a case stops when its samples have taken more than 4 seconds. The run has a 15-minute budget, checked against the recorded weights before it starts, as the scene composition Studio run describes. Facet ships `--!native` directives and the plain lane has none, so in Studio only the Facet lane can run native code; the headless run loads Facet without native code. After the timed samples, each case measures retained heap and teardown heap with the same method as the scene composition Studio run (see [the method](../scene-composition/method.md)). A full run uses 2 sequential batches, and memory samples follow the same budget. `--batches N`, `--shards N`, `--weights path` and `--record-weights path` work as in the scene composition Studio run, with weights in `comparisons/ui-components/studio-weights.json`.

```bash
lute run comparisons/ui-components/studio/run.luau
```

The shared input driver gets a `VirtualInput` from `UserInputService:CreateVirtualInput()`, the engine API for simulated player input in tests. It sends mouse positions, button pairs and key pairs to real controls. It scrolls a target into view, uses measured bounds and adds the GUI inset to pointer coordinates. Inventory, dialog, tabs and radial use pointer activation. Tile transfer and stacked modals use native selection and Return. After the driver selects a control, it waits two frames before the key goes down, so the selection observers in both lanes can enable their Return actions. Both lanes bind Return in an InputContext with `Sink` set, so a `UserInputService` observer can miss that key. The requested result of the workload checks keyboard delivery. The gamepad walk sends D-pad key pairs and requires delivered Gamepad1 events. Drag reorder holds the mouse button through intermediate positions. Button feedback visits one control at a time; simultaneous hover on 50 buttons is not a real pointer task. It checks Hover, Press and Idle before continuing. A TextBox gets focus through CaptureFocus.

The gamepad walk requires Studio Controller Emulator with its default keyboard bindings. As in the pinned Facet live driver, Three sends D-pad Down, Two sends D-pad Left and Four sends D-pad Right. The driver checks the resulting D-pad KeyCode and Gamepad1 input type. A normal keyboard event does not pass. On Windows, the Studio run opens Test > Controller Emulator through UI Automation only in a Studio that runs `gamepad-grid-6x6`. It does not change emulator settings. With the emulator open, simulated mouse drags do not land, so a batched run puts `gamepad-grid-6x6` in its own last batch and runs every other workload with the emulator closed.

The input driver and the resulting benchmark and library handlers are inside the profiler scope in both lanes. Native input routing outside those stacks, native interpolation, rendering and later engine layout are outside that scope. Results must state this boundary.

Toast expiry is the `World.toastDuration` parameter. Its default is four seconds in headless, which preserves the default lifetime. Studio sets it to 0.05 seconds in both lanes. Enter and exit motion keep their theme durations. Each close step waits for expiry and retirement. A sample shows 20 toasts; it does not wait several minutes for default expiry.

## Required Studio checks

Headless tests cover input call order, pointer coordinates and inset, key release, button feedback state checks, drag movement, rejected input, real-duration waiting, short toast expiry, checkpoint mismatch and cleanup. They do not replace these Studio checks:

1. Confirm that `UserInputService:CreateVirtualInput()` works in the play client. Confirm pointer and Return events reach controls and D-pad events arrive as Gamepad1. Check the active window and controller emulation settings. A missing event must fail, not use a direct callback.
2. Run `inventory-500` through all selections, including slots outside the initial viewport. Confirm clipping, scroll offsets and retained target identity.
3. Run all 50 feedback targets through Hover, Press and Idle. Confirm theme paint and that no overlay blocks the target.
4. Complete every radial selection. Confirm one callback per activation, settled entry and exit, scrim layering, selection traps and restored focus.
5. Visit every tab through pointer input. Confirm page retention, indicator placement and lower input-context cleanup.
6. Transfer every tile through Return. Confirm the held preview, accepted parent, preview retirement and cancel-context cleanup.
7. Expire all 20 short toasts. Confirm no queued toast or row remains and that entry cannot prevent expiry.
8. Walk all 36 grid cells with real D-pad input. Confirm native spatial neighbors and the final cell. Simulated selection cannot verify native spatial reachability.
9. Rotate the hub in both directions. Confirm measured widths, retained controls, clipping and the available phone area. Confirm the HUD chooses both forms and returns to the rich form after expansion.
10. Change the authored input and text-size preferences. Confirm prompt updates and native styled typography on all labels. Check localization with real translators and the longer German strings. Native account setting and locale changes are separate checks.
11. Drag across the first five rows repeatedly. Confirm native drag delivery, insertion position, scroll anchoring, feedback and retained row identity.
12. Stack the two dialogs and close them in order. Confirm the lower dialog cannot receive input while covered, and selection returns first to it and then to the prior target.
13. Run the native Scale variant through entry and exit. Confirm both styled goals, stable hit bounds and equal visual motion. Native interpolation is not verified headlessly.

Publish new results only after these checks and a complete clean-HEAD Studio run pass.

## Results

- [Headless results](headless-results.md)
- [Studio client results on Windows](studio-windows.md)
- [Studio client results on macOS](studio-macos.md)
