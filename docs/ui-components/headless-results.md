# UI components comparison

Harness revision: `f245db248e9a66d4451ade955367cb586ebbff8c`. Facet: `4b4755f84b368e7dc52fcc93feaee9d65cf34c13`.

Measured on 2026-11-25 (UTC) on `ubuntu-latest` (AMD EPYC 7763 64-Core Processor) in [Library comparison run 45552648244](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/45552648244). [Run 45552651142](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/45552651142) also ran the same UI comparison.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Each lane builds its theme StyleSheet at mount, so cold mounts and complete lifetimes include that setup cost in each lane. Parity compares the observable result of both lanes. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 2292.478 | 2234.601–2384.059 | 1.00x | 348.000 | 1.00x | 115.000 | 155 | 42 |
| main-menu-cold | 1 | facet | 21332.015 | 20896.356–22250.884 | 9.31x | 2194.000 | 6.30x | 150.000 | 1530 | 497 |
| hud-60-frames | 60 | plain | 1418.930 | 1401.368–1434.761 | 1.00x | 325.000 | 1.00x | 68.000 | 242 | 0 |
| hud-60-frames | 60 | facet | 3137.263 | 3090.897–3200.221 | 2.21x | 2214.000 | 6.81x | 120.000 | 254 | 0 |
| world-markers-50 | 100 | plain | 32337.319 | 30267.720–36724.989 | 1.00x | 1909.000 | 1.00x | 147.000 | 5953 | 0 |
| world-markers-50 | 100 | facet | 73934.222 | 70530.317–80485.292 | 2.29x | 5339.000 | 2.80x | 125.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 383.788 | 371.485–413.204 | 1.00x | 11431.000 | 1.00x | 121.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1157.146 | 1062.429–1209.333 | 3.02x | 25944.000 | 2.27x | 238.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3565.196 | 3545.148–3681.734 | 1.00x | 2388.000 | 1.00x | 137.000 | 1033 | 0 |
| shop-filter-200 | 10 | facet | 9020.820 | 8847.426–9149.759 | 2.53x | 6075.000 | 2.54x | 146.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 4427.815 | 4360.870–4920.152 | 1.00x | 573.000 | 1.00x | 68.000 | 1136 | 0 |
| virtual-scroll-2000 | 15 | facet | 9204.232 | 9081.513–10471.841 | 2.08x | 3293.000 | 5.75x | 132.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 19408.869 | 19029.431–20150.484 | 1.00x | 1144.000 | 1.00x | 117.000 | 2250 | 250 |
| chat-append-250 | 250 | facet | 64320.886 | 63987.352–67218.429 | 3.31x | 4317.000 | 3.77x | 103.000 | 3800 | 250 |
| card-collection-60 | 1 | plain | 34127.709 | 33664.777–35821.205 | 1.00x | 4422.000 | 1.00x | 109.000 | 3611 | 782 |
| card-collection-60 | 1 | facet | 97939.508 | 96812.124–99184.238 | 2.87x | 11860.000 | 2.68x | 183.000 | 4269 | 1082 |
| mixed-scroll-300 | 50 | plain | 315.898 | 307.032–351.696 | 1.00x | 6608.000 | 1.00x | 125.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 310.048 | 303.917–321.018 | 0.98x | 17410.000 | 2.63x | 278.000 | 50 | 0 |
| settings-17-values | 17 | plain | 1271.132 | 1246.085–1339.981 | 1.00x | 1767.000 | 1.00x | 160.000 | 53 | 4 |
| settings-17-values | 17 | facet | 3285.020 | 3176.618–3812.303 | 2.58x | 3960.000 | 2.24x | 233.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1241.747 | 1218.192–1277.944 | 1.00x | 292.000 | 1.00x | 68.000 | 225 | 0 |
| text-input-200 | 200 | facet | 2139.962 | 2077.276–2193.623 | 1.72x | 2148.000 | 7.36x | 112.000 | 225 | 0 |
| button-feedback-50 | 15 | plain | 674.869 | 657.397–685.098 | 1.00x | 734.000 | 1.00x | 89.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 687.893 | 669.299–738.097 | 1.02x | 3371.000 | 4.59x | 142.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 2811.823 | 2737.034–2849.864 | 1.00x | 681.000 | 1.00x | 180.000 | 303 | 1 |
| stepper-segments-100 | 100 | facet | 12920.313 | 12717.755–13182.051 | 4.59x | 2762.000 | 4.06x | 291.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 4035.307 | 3854.189–4326.190 | 1.00x | 399.000 | 1.00x | 138.000 | 211 | 52 |
| toast-stream-4 | 8 | facet | 9300.687 | 8767.844–9876.861 | 2.30x | 2246.000 | 5.63x | 173.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 923.262 | 889.419–959.960 | 1.00x | 537.000 | 1.00x | 146.000 | 68 | 8 |
| tabs-5-5-switches | 5 | facet | 3714.948 | 3669.103–4568.361 | 4.02x | 3212.000 | 5.98x | 233.000 | 80 | 8 |
| radial-8-cycles | 32 | plain | 30207.568 | 29054.326–30786.417 | 1.00x | 1930.000 | 1.00x | 139.000 | 2335 | 417 |
| radial-8-cycles | 32 | facet | 53318.414 | 51595.731–57606.845 | 1.77x | 3422.000 | 1.77x | 301.000 | 1770 | 295 |
| navigation-5-6-cycles | 60 | plain | 25155.783 | 24821.780–25653.792 | 1.00x | 394.000 | 1.00x | 140.000 | 2070 | 360 |
| navigation-5-6-cycles | 60 | facet | 48445.115 | 47685.146–49661.083 | 1.93x | 2517.000 | 6.39x | 196.000 | 2364 | 360 |
| leaderboard-100 | 6 | plain | 4519.429 | 4284.781–5170.263 | 1.00x | 8311.000 | 1.00x | 120.000 | 512 | 0 |
| leaderboard-100 | 6 | facet | 12298.177 | 11340.090–13363.701 | 2.72x | 21129.000 | 2.54x | 266.000 | 805 | 0 |
| theme-swap-200 | 4 | plain | 62.747 | 59.771–71.664 | 1.00x | 2289.000 | 1.00x | 79.000 | 0 | 0 |
| theme-swap-200 | 4 | facet | 4363.088 | 4169.337–4643.160 | 69.53x | 8082.000 | 3.53x | 291.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 585387.425 | 550419.418–609548.734 | 1.00x | 6045.000 | 1.00x | 127.000 | 60240 | 8040 |
| heavy-screen-20-cycles | 20 | facet | 1430296.845 | 1372554.313–1479316.890 | 2.44x | 9515.000 | 1.57x | 660.000 | 88260 | 8040 |
| tile-transfer-10 | 21 | plain | 3608.473 | 3515.661–3938.067 | 1.00x | 689.000 | 1.00x | 211.000 | 229 | 25 |
| tile-transfer-10 | 21 | facet | 21660.117 | 20915.740–32504.242 | 6.00x | 3351.000 | 4.86x | 202.000 | 605 | 84 |
| input-type-switch-20 | 20 | plain | 10012.680 | 9862.971–10467.319 | 1.00x | 993.000 | 1.00x | 93.000 | 800 | 200 |
| input-type-switch-20 | 20 | facet | 34853.919 | 32984.334–36447.069 | 3.48x | 3801.000 | 3.83x | 105.000 | 1600 | 200 |
| localized-text-swap-50 | 10 | plain | 3173.177 | 3019.871–3362.942 | 1.00x | 1008.000 | 1.00x | 79.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 21903.016 | 19397.782–22724.018 | 6.90x | 3992.000 | 3.96x | 107.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 82.544 | 74.779–121.046 | 1.00x | 568.000 | 1.00x | 59.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 2528.198 | 2432.649–2584.139 | 30.63x | 3482.000 | 6.13x | 95.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 337.890 | 308.025–344.753 | 1.00x | 450.000 | 1.00x | 154.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 736.825 | 724.041–897.935 | 2.18x | 2574.000 | 5.72x | 167.000 | 20 | 0 |
| hud-composition-step-down | 10 | plain | 490.837 | 452.906–500.114 | 1.00x | 300.000 | 1.00x | 81.000 | 20 | 0 |
| hud-composition-step-down | 10 | facet | 1614.231 | 1569.918–1770.362 | 3.29x | 2276.000 | 7.59x | 130.000 | 50 | 0 |
| gamepad-grid-6x6 | 35 | plain | 65369.904 | 63289.335–67901.657 | 1.00x | 4388.000 | 1.00x | 3310.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 83769.969 | 82606.547–88704.582 | 1.28x | 12665.000 | 2.89x | 4503.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 3951.094 | 3756.571–4122.244 | 1.00x | 4628.000 | 1.00x | 157.000 | 420 | 30 |
| drag-reorder-100 | 20 | facet | 25737.194 | 24818.991–27878.000 | 6.51x | 10111.000 | 2.18x | 204.000 | 975 | 134 |
| modal-on-modal | 12 | plain | 15232.413 | 14856.813–15746.282 | 1.00x | 418.000 | 1.00x | 223.000 | 1302 | 163 |
| modal-on-modal | 12 | facet | 39050.206 | 37593.630–41544.938 | 2.56x | 3039.000 | 7.27x | 190.000 | 784 | 137 |
| button-native-scale-50 | 6 | plain | 657.748 | 629.675–737.877 | 1.00x | 1633.000 | 1.00x | 106.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 615.028 | 585.613–675.270 | 0.94x | 4790.000 | 2.93x | 170.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 3.19x | 3.88x |

## Workloads

- `main-menu-cold`: Install the theme StyleSheet and mount a surface with a title, six actions and a footer; runtime and control-factory setup is excluded.
- `hud-60-frames`: Update health fill, ammo, currency and timer once per simulated frame.
- `world-markers-50`: Update the labels of 50 native BillboardGui markers in the player's GUI, adorned to anchored Parts in the Workspace.
- `inventory-500`: Select among 500 retained slots 40 times; each slot has an activation target and selected state.
- `shop-filter-200`: Edit a native TextBox with ten queries, including empty and no match; retain the 200 catalog rows and set their visibility.
- `virtual-scroll-2000`: Scroll a fixed 40-pixel row window down in 796-pixel steps; the plain lane keeps a small reusable row pool.
- `chat-append-250`: Append 250 keyed messages; remove the oldest when the log exceeds 100 rows.
- `card-collection-60`: Mount 60 cards with the same artwork, item title and price caption; theme setup is excluded.
- `mixed-scroll-300`: Scroll 300 retained mixed rows: 100 text rows, 100 action buttons and 100 text cards.
- `settings-17-values`: Change ten toggles, four sliders and three segmented pickers; native value readouts show the result. Toggles and picker segments change through their Activated input, sliders through the model in headless worlds and a track drag in Studio. While a slider holds native selection, its arrow, shoulder and cancel InputContexts follow its value; the picker selection fill slides with the theme control spring.
- `text-input-200`: Type 200 characters through a native TextBox; validation rejects punctuation and accepts letters. While the field edits, an InputContext holds the arrow keys and Escape or ButtonB cancels to the text at focus; the 100th character is followed by a cancel and the next by a new focus.
- `button-feedback-50`: Visit 15 of 50 buttons through Hover, Press and Idle, one frame each. Facet uses its theme state rules; plain uses its own Hover and Press StyleRules with the same colours and timings. Checkpoints compare the styled paint during the release transition and after it settles; the Studio driver uses real mouse input.
- `stepper-segments-100`: Change a bounded quantity and a segmented choice 100 times, then render one frame. Every tenth change goes through the Increase button and a segment's Activated input, the rest through the application model. The stepper has 44-pixel Decrease and Increase icon buttons that repeat while held and disable at the limits; the picker selection fill slides with the theme control spring.
- `toast-stream-4`: Show 4 one-shot result toasts with a shared expiry parameter (four seconds headless, 0.05 seconds Studio). Both lanes stack toasts at the top of the overlay, show at most three and queue up to eight, slide each in with the theme present easing while fading it linearly, and fade only under reduced motion.
- `tabs-5-5-switches`: Select a peer tab and activate it, 5 times among five tabs, keeping each visited page and its content. Both lanes centre a scrolling 44-pixel tab bar, paint the current tab and its 2-pixel underline, keep each page a selection group with a per-tab focus bookmark, and enable L1 and R1 while focus is in the bar.
- `radial-8-cycles`: Open a four-command donut radial menu from its launcher, activate Wave and let it close, 8 times, with a checkpoint in the middle of each enter and exit. Both lanes size the inner radius from the launcher with a 96-pixel ring, fit each label box to its sector, catch outside input on a transparent scrim, draw four Path2D sectors and a centre close button, spread the ring out from 0.2 scale with the theme radial timings, highlight the candidate or focused sector, hide the launcher until the exit ends, and add the modal back and radial input contexts.
- `navigation-5-6-cycles`: Push five child pages, then select and activate each page's Back button to pop it, 6 times. Both lanes keep covered pages, show a 44-pixel bar with the destination title (left on the root, centred on child pages) and a Back button with a chevron and label, bind Escape and ButtonB to back, and move focus into the page that becomes top; the root has no Back action.
- `leaderboard-100`: Sort 100 retained player rows by name, replace every score and scroll down, press the Score header twice for ascending and descending order, then replace every score again and let moved rows finish their glide. Checkpoints report rows in motion without their geometry.
- `theme-swap-200`: Swap the content colour on 200 themed buttons and back. Each swap is checked mid-transition and after the theme paint transition settles. Facet updates its theme source; plain sets one colour attribute on its theme StyleSheet.
- `heavy-screen-20-cycles`: Close a scrolling screen of 200 actions and 200 text rows and open a fresh one, 20 times, inside one themed ScreenGui. Each lifetime is laid out for one frame. The theme StyleSheet stays mounted.
- `tile-transfer-10`: Pick up 10 tiles with keyboard activation and drop each into the second grid. Before each pickup the player waits for the previous drop preview to shrink away. Checkpoints alternate between the held state and the moment after the drop; the last one waits for the final preview.
- `input-type-switch-20`: Switch the authored preferred-input fact between keyboard and gamepad on 20 action controls and prompts. This measures adaptation after input detection.
- `localized-text-swap-50`: Swap translated strings on 50 retained labels between English and German. Both lanes use the same LocalizationTable translators and disable automatic localization of translated text.
- `text-size-preference-50`: Change an authored text-size preference across four ranks on a 50-label screen. Facet updates its theme text-size tokens; plain updates one native StyleSheet text-size token that its body rule reads.
- `phone-rotation-hub`: Rotate a retained hub between 390 by 844 and 844 by 390 layout units. Turn its subject, task list and action column without remounting the controls.
- `hud-composition-step-down`: Resize a HUD from 800 to 400 layout units. Keep rich and compact status forms mounted, choose the richest form that fits, pop the new form in and restore the rich form on expansion.
- `gamepad-grid-6x6`: Walk all 36 retained cells of a six by six grid in a snake path. Both hosts send D-pad keys through their input host and check native selection. Facet uses VirtualGrid with its focus scope; plain uses transparent selectable hit buttons over text cells. Both hold Home, End, page and direction keys in priority 200 InputContexts while the grid holds selection.
- `drag-reorder-100`: Drag the first of 100 retained rows after the fifth row, 10 times: odd steps press and move past the 6-pixel threshold, even steps drop. Facet uses VirtualList reorderable and onReorder; plain uses a UIDragDetector per row, a divider drop line, a drag ghost, a priority 400 cancel InputContext and the theme snappy spring for row travel, plus keyboard pick-up, move, drop and cancel. Headless worlds fire the row detector after checking that it is enabled; Studio drags with the real mouse.
- `modal-on-modal`: Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.
- `button-native-scale-50`: Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.
