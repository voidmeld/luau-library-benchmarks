# UI components comparison

This comparison measures [Facet](https://github.com/josha/Facet), a library of Roblox UI controls, against a `plain` lane. It has 30 workloads. Each workload is a complete player task, such as a settings screen, a leaderboard or a chat log. The `plain` lane uses Instances, native layout objects and plain Luau state for the controls. Both lanes use the same Facet theme compiler to build their shared native style rules. Theme setup is outside update measurements. Cold mounts and complete lifetimes include that shared setup cost.

## Disclosure

The maintainers of Facet wrote both lanes. Review the `plain` lane as strictly as the Facet lane. If a `plain` lane does work that a careful Roblox developer would not do, or skips work that the task needs, open an issue or a pull request.

## What the lanes match

Both lanes link the same theme StyleSheet. `plain` Instances carry the same style tags, automatic size and auto-localization setting as the Facet controls. `plain` readouts hold their widest same-length width, as Facet text does. `plain` state changes toggle the same state tags. `plain` keeps references to the Instances that it updates.

Facet keeps its extra policy: measurement, accessibility, focus, modal behavior, selection and cancellation. The `plain` lane includes only the controls and state that the task needs. The extra Facet policy is part of the Facet cost.

Facet adds wrappers and control chrome, so the two trees are not equal. Each workload declares the observations that both lanes must match: text, fill fractions, tags, selection traps, input contexts and similar state. Headless parity compares these observations at mount and after every iteration, then checks Instance and connection counts after teardown. Inventory, dialog, tabs, radial, transfer, grid traversal, drag reorder and stacked modal checks also require the requested result. Equal missed input cannot pass those checks. Inventory, localization, rotation and reorder checks retain Instance identity.

Studio runs an unmeasured parity pass through both lanes before it profiles either lane. It compares full strings at every checkpoint. A different checkpoint stops the case before timing. Each later sample must reach the verified final state. Snapshot collection is outside the profiler. The report includes a digest of the verified checkpoint sequence.

## Motion

The dialog, toast, radial and transfer workloads use `TweenService` in `plain` and the public control motion in Facet. Both lanes use the theme duration and easing. Studio waits for the requested duration and advances real frames. Headless advances its simulation clock. Navigation and tabs set `transition = false` in both lanes.

Facet's [styling guide](https://github.com/josha/Facet/blob/09512b286ee26ff9910b9a3115b3401fd0837fe1/docs/guide/styling.md) recommends native StyleRule transitions for paint and game-owned geometry. `button-feedback-50` uses the same native theme paint rules in both lanes. `button-native-scale-50` adds the geometry variant: a stable Button hit target contains a visual face and an inner `UIScale`. Both lanes install the same rest and pressed rules, with a Scale transition on entry and exit. The measured step changes the same state tag on 50 controls. It does not move a layout-owned Size or Position. Headless checks the rule goals and state tags. Studio also checks the settled styled Scale.

The pinned public Dialog, Toast, RadialMenu and draggable APIs do not offer a StyleSheet motion backend. Their presentation and drag motion also control retirement, input, focus or preview cleanup. A StyleRule cannot complete those Luau lifecycle operations. Replacing their private timelines would change library code. Those workloads therefore keep their public motion paths. The geometry variant measures native motion separately; it does not claim to replace a modal or a drag lifecycle.

## Workload catalog

Every workload has both lanes and headless parity.

| Workload | Task and observations |
| --- | --- |
| `main-menu-cold` | Mount a title, six actions and a footer. Check their text. |
| `hud-600-frames` | Update health, ammo, coins and a timer. Check text and fill. |
| `world-markers-50` | Update 50 BillboardGui labels on Parts. |
| `inventory-500` | Select retained inventory slots. Check the requested key, one selected plate and retained targets. |
| `shop-filter-200` | Filter 200 retained actions through a TextBox, including empty and missing matches. |
| `virtual-scroll-2000` | Move a fixed-height window through 2,000 rows. Plain reuses a small row pool. Check the visible labels. |
| `chat-append-500` | Append messages and retain the last 100. |
| `card-collection-60` | Mount 60 cards. Check artwork, title and caption. |
| `mixed-scroll-300` | Scroll retained text, action and card rows. Check content and offset. |
| `settings-17-values` | Set toggle, slider and picker models. Check readouts and selected state. |
| `text-input-200` | Edit a TextBox with validation that accepts letters and rejects punctuation. |
| `button-feedback-50` | Visit Hover, Press and Idle on each of 50 buttons. Check each delivered state. |
| `stepper-segments-100` | Change a bounded quantity and a segmented choice. Check the summary, selection and disabled bounds. |
| `toast-stream-20` | Show and expire 20 one-shot toasts. Check messages and visible panels. |
| `tabs-5-20-switches` | Activate five tabs. Check the requested page, retained page content, current tag and indicator. |
| `radial-50-cycles` | Present a four-command ring and activate Wave. Check one commit per close, sectors, launcher and input contexts. |
| `navigation-5-20-cycles` | Push five pages, then pop them. Check visible and retained content. |
| `leaderboard-100` | Sort retained rows and update scores. Check row positions and all cell text. |
| `theme-swap-200` | Change the palette on 200 controls. Plain relinks prebuilt sheets; Facet updates its theme source. Wait for native paint to settle. |
| `heavy-screen-20-cycles` | Mount and dispose 200 actions and 200 text rows. Check teardown. |
| `tile-transfer-20` | Pick up tiles with Return and drop them in a second grid. Check each requested parent, held tags, previews and input contexts. |
| `gamepad-grid-6x6` | Walk all 36 cells in a snake path. Check every requested cell. Headless uses Facet's public `focus.move`; Studio sends native D-pad input. Plain uses native spatial selection in Studio and a grid index in headless. |
| `input-type-switch-20` | Switch a preferred-input fact between keyboard and gamepad on a 20-control screen. Facet reads `UI.environment().effectiveInput`. Check all prompts. This measures adaptation after device detection, not controller connection or detection. |
| `phone-rotation-hub` | Resize a retained hub between portrait and landscape phone sizes. Facet binds `AdaptiveStack.axis` to `UI.environment(source).isLandscape`. Plain observes AbsoluteSize and changes its list direction. Check direction, content and retained actions. |
| `text-size-preference-50` | Change an authored preference through four text-size ranks. Facet uses `environment.preferredTextSize`; plain updates one shared body rule. Check the rule's TextSize. The native account preference stays fixed. |
| `localized-text-swap-50` | Change 50 labels between English and German through the same LocalizationTable translators. Facet binds Text to the selected translator; plain assigns translated text. Check text, identity and AutoLocalize. The native locale stays fixed. |
| `hud-composition-step-down` | Resize a HUD between 800 and 400 layout units. Facet uses Composition and a Region with rich and compact fixed-size forms. Plain retains both forms and chooses the one that fits. Check FacetForm, visibility and identity in both directions. |
| `drag-reorder-100` | Drag the first row after the fifth in a retained 100-row list. Facet uses VirtualList `reorderable` and commits `onReorder` proposals to its source. Plain uses UIDragDetector and an insertion indicator. Check every row's order and identity after each drag. |
| `modal-on-modal` | Open an inner confirmation over an outer dialog, then close each in stack order. Check retained titles, traps, one acceptance per close and native focus restoration. |
| `button-native-scale-50` | Change a geometry state on 50 retained button faces through native StyleRule transitions. |

## Adapter review

The review uses the documentation and source at the Facet commit in `dependencies.lock.luau`. The source checkout can omit docs through sparse checkout; `git show HEAD:<path>` in that checkout reads the pinned docs without changing library files. The public site can describe a different revision.

The reviewed contracts are `docs/guide/styling.md`, `docs/guide/input.md`, `docs/guide/performance.md`, `skills/use-facet/SKILL.md` and these files under `docs/reference/nodes`: `Text.reference.md`, `AdaptiveStack.reference.md`, `environment.environment.md`, `environment.luau.md`, `Collections.focus-controls.md`, `VirtualList-and-VirtualGrid.ContentProvider.md`, `Editable-collections.reorderable.md`, `Editable-collections.single.md`, `Composition.call.md`, `Composition.regions.md`, `Composition.layout.step-down.md` and `focusSection.md`. Native input sequences also follow `tools/studio/live/interactive.luau` and `tools/studio/live/init.luau`. Source checks include the text measurement, picker, card, tab, collection reorder, environment, dialog, toast and theme implementations.

The review applies these choices and corrections:

- Readouts use public Text bindings in Facet. Plain keeps direct references and a same-length width reservation. Font or TextSize changes reset that reservation. Stale asynchronous measurements cannot restore an old reservation.
- Inventory uses public VirtualGrid selection. Plain changes only the old and new selected plates. Both lanes retain the slot targets. Virtual scrolling keeps the existing plain row pool. Chat keeps incremental append and removal. Mixed screens and complete lifetimes retain their native layout paths.
- Plain cards carry panel and card-body tags, label typography for titles and secondary caption typography. The plain main menu uses title typography. The artwork and aspect ratio stay the same in both lanes.
- Settings remain model-update tasks. Plain updates picker selection as well as the readout, and puts segments in their layout row. Stepper bounds include disabled and native Interactable state. Parity checks the selected and disabled tags.
- Tabs activate a real control in both lanes. Facet does not receive a direct selection-model write in place of input. Plain releases its GuiService selection subscription when the screen stops.
- Plain screens use one shared Return binding for the selected control. Disabled controls do not activate. The screen releases the selection observer at teardown. This supplies keyboard activation for native buttons without one InputContext per button.
- Dialog, toast and radial keep their public Facet controls and equivalent plain presentation state. The shared Studio driver adds real input. Plain uses the existing TweenService service in Studio and does not create or destroy a service Instance.
- Navigation retains covered pages and uses no transition in either lane. Transfer uses the same Return activation facts in both hosts, with public draggable and dropTarget helpers in Facet.
- Plain leaderboard score updates sort again only while score is the sort column. Name and win order do not change when only scores change. Theme swap keeps each lane's documented native styling path.
- Adaptation tasks use public environment facts, Text bindings, AdaptiveStack, Composition and Region. Reorder uses the public proposal callback and a new source array. Stacked modals use two public Dialog controls. No library implementation is changed.

The stacked modal task starts on a retained entry control and uses keyboard acceptance with a gamepad preferred-input fact. Both lanes disable the covered controls, keep only the upper modal input active and restore selection in stack order. Headless checks these states with a GuiService double as well as the final accepted state.

The common theme compiler remains shared infrastructure. A cold-mount number includes it. A control-only mount comparison would need a separate workload with prebuilt theme sheets in both lanes.

## Headless run

The headless run uses the Verify reflection engine double, not the scene composition cost model, because the controls need text services, StyleSheets, input contexts and drag detectors. Facet loads through the same like-for-like loader as the scene composition libraries: optimization level 2 and no native code. Its source has no change. The loader binds the reflection datatypes and `typeof`, so vectors, enums and Instances have the same identities as the host double. Its `getfenv` returns those globals with no `game`, so Facet takes its headless paths. Reports disclose loader fallback files.

Headless does not solve native geometry or interpolate native StyleRule transitions. Rotation supplies the source size. Composition supplies the authored form sizes and available zone size to the double. Reorder supplies DragStart, DragContinue and DragEnd positions to the native detector handlers. These checks cover the library's state and public callbacks. They do not prove native hit testing, native focus reachability or rendered layout.

After each workload mounts, both lanes run 30 frames before the first observation and before timing, in the headless and the Studio runs. Timing then measures updates, not mount-time settling. The cold-mount and lifetime workloads mount inside their timed steps.

The run checks parity for every workload, then collects nine time samples after two warm-up samples, three retained-heap measurements and one instrumented pass that counts property writes and created Instances.

```bash
lute run comparisons/ui-components/compare.luau --verify
lute run comparisons/ui-components/compare.luau --out build/ui-components-comparison
```

## Studio client run

The Studio run enables every workload against real Instances in a Roblox Studio play client. It loads Facet from a fresh copy of its module tree for each case, and times Luau work with the client script profiler, as the scene composition Studio run does. Each sample ends with a real frame. Workloads alternate which lane runs first. Both lanes get the same warmup and sample count. After the timed samples, each case measures retained heap and teardown heap with the same method as the scene composition Studio run (see [the method](../scene-composition/method.md)). `--shards N`, `--weights path` and `--record-weights path` work as in the scene composition Studio run, with weights in `comparisons/ui-components/studio-weights.json`.

```bash
lute run comparisons/ui-components/studio/run.luau
```

The shared input driver gets a `VirtualInput` from `UserInputService:CreateVirtualInput()`, the engine API for simulated player input in tests. It sends mouse positions, button pairs and key pairs to real controls. It scrolls a target into view, uses measured bounds and adds the GUI inset to pointer coordinates. Inventory, dialog, tabs and radial use pointer activation. Tile transfer uses native selection and Return. The gamepad walk sends D-pad key pairs and requires delivered Gamepad1 events. Drag reorder holds the mouse button through intermediate positions. Button feedback visits one control at a time; simultaneous hover on 50 buttons is not a real pointer task. It checks Hover, Press and Idle before continuing. A TextBox gets focus through CaptureFocus.

The gamepad walk requires Studio Controller Emulator with its default keyboard bindings. As in the pinned Facet live driver, Three sends D-pad Down, Two sends D-pad Left and Four sends D-pad Right. The driver checks the resulting D-pad KeyCode and Gamepad1 input type. A normal keyboard event does not pass. The comparison does not change emulator settings.

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
8. Walk all 36 grid cells with real D-pad input. Confirm native spatial neighbors and the final cell. Headless index movement cannot verify this path.
9. Rotate the hub in both directions. Confirm measured widths, retained controls, clipping and the available phone area. Confirm the HUD chooses both forms and returns to the rich form after expansion.
10. Change the authored input and text-size preferences. Confirm prompt updates and native styled typography on all labels. Check localization with real translators and the longer German strings. Native account setting and locale changes are separate checks.
11. Drag across the first five rows repeatedly. Confirm native drag delivery, insertion position, scroll anchoring, feedback and retained row identity.
12. Stack the two dialogs and close them in order. Confirm the lower dialog cannot receive input while covered, and selection returns first to it and then to the prior target.
13. Run the native Scale variant through entry and exit. Confirm both styled goals, stable hit bounds and equal visual motion. Native interpolation is not verified headlessly.

Publish new results only after these checks and a complete clean-HEAD Studio run pass. Existing result files are not evidence for this workload catalog.

## Results

- [Headless results](headless-results.md)
- [Studio client results on Windows](studio-windows.md)
- [Studio client results on macOS](studio-macos.md)
