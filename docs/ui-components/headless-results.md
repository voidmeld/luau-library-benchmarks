# UI components comparison

Harness revision: `c53fa6da0dce63b307bbb9d3e57a934a18343f6a`. Facet: `895d0571dbe822f662ef4874a5b39b3b5b5ad6b2`.

Measured on 2026-11-25 (UTC) on `ubuntu-latest` in [Library comparison run 45524440946](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/45524440946). [Run 45524444075](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/45524444075) also ran the same UI comparison.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Each lane builds its theme StyleSheet at mount, so cold mounts and complete lifetimes include that setup cost in each lane. Parity compares the observable result of both lanes. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 1782.321 | 1655.500–1882.752 | 1.00x | 340.000 | 1.00x | 99.000 | 155 | 42 |
| main-menu-cold | 1 | facet | 13625.914 | 13540.766–13996.091 | 7.65x | 2203.000 | 6.48x | 157.000 | 1530 | 497 |
| hud-60-frames | 60 | plain | 1252.594 | 1221.418–1313.596 | 1.00x | 341.000 | 1.00x | 116.000 | 242 | 0 |
| hud-60-frames | 60 | facet | 2107.650 | 2016.334–2235.744 | 1.68x | 2199.000 | 6.45x | 97.000 | 254 | 0 |
| world-markers-50 | 100 | plain | 25811.067 | 25088.109–30688.892 | 1.00x | 1974.000 | 1.00x | 228.000 | 5956 | 1 |
| world-markers-50 | 100 | facet | 65923.290 | 64314.270–73746.695 | 2.55x | 5389.000 | 2.73x | 210.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 391.789 | 375.424–425.730 | 1.00x | 11431.000 | 1.00x | 111.000 | 0 | 0 |
| inventory-500 | 40 | facet | 930.780 | 915.016–951.811 | 2.38x | 26930.000 | 2.36x | 209.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3119.542 | 3085.861–3147.223 | 1.00x | 2404.000 | 1.00x | 151.000 | 1033 | 0 |
| shop-filter-200 | 10 | facet | 7676.875 | 7489.733–9166.946 | 2.46x | 6043.000 | 2.51x | 170.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 3418.719 | 3355.374–3502.555 | 1.00x | 573.000 | 1.00x | 77.000 | 1136 | 0 |
| virtual-scroll-2000 | 15 | facet | 6881.074 | 6480.563–9661.224 | 2.01x | 3296.000 | 5.75x | 147.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 12662.672 | 12378.616–13514.713 | 1.00x | 1128.000 | 1.00x | 117.000 | 2250 | 250 |
| chat-append-250 | 250 | facet | 50612.593 | 49807.252–52208.483 | 4.00x | 4294.000 | 3.81x | 88.000 | 3800 | 250 |
| card-collection-60 | 1 | plain | 23635.404 | 23155.392–25006.676 | 1.00x | 4461.000 | 1.00x | 117.000 | 3611 | 782 |
| card-collection-60 | 1 | facet | 75570.757 | 74385.825–76032.983 | 3.20x | 11907.000 | 2.67x | 158.000 | 4269 | 1082 |
| mixed-scroll-300 | 50 | plain | 272.119 | 267.692–282.856 | 1.00x | 6657.000 | 1.00x | 116.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 274.223 | 268.604–293.071 | 1.01x | 17394.000 | 2.61x | 254.000 | 50 | 0 |
| settings-17-values | 17 | plain | 1120.535 | 1105.823–1147.676 | 1.00x | 1751.000 | 1.00x | 152.000 | 53 | 4 |
| settings-17-values | 17 | facet | 2651.819 | 2586.281–2835.185 | 2.37x | 3968.000 | 2.27x | 249.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1084.571 | 1067.817–1110.250 | 1.00x | 316.000 | 1.00x | 107.000 | 225 | 0 |
| text-input-200 | 200 | facet | 1688.990 | 1669.571–1714.560 | 1.56x | 2147.000 | 6.79x | 79.000 | 225 | 0 |
| button-feedback-50 | 15 | plain | 586.702 | 578.200–599.362 | 1.00x | 751.000 | 1.00x | 112.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 567.193 | 561.054–587.904 | 0.97x | 3370.000 | 4.49x | 88.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 2343.384 | 2275.803–2354.741 | 1.00x | 697.000 | 1.00x | 201.000 | 303 | 1 |
| stepper-segments-100 | 100 | facet | 8326.452 | 8209.806–8496.417 | 3.55x | 2762.000 | 3.96x | 243.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 2603.215 | 2499.970–2639.299 | 1.00x | 380.000 | 1.00x | 140.000 | 214 | 52 |
| toast-stream-4 | 8 | facet | 6318.863 | 6265.462–6597.071 | 2.43x | 2262.000 | 5.95x | 181.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 742.838 | 720.294–774.184 | 1.00x | 553.000 | 1.00x | 146.000 | 68 | 8 |
| tabs-5-5-switches | 5 | facet | 2510.726 | 2450.976–2980.873 | 3.38x | 3212.000 | 5.81x | 209.000 | 80 | 8 |
| radial-8-cycles | 32 | plain | 21726.686 | 21511.703–22326.428 | 1.00x | 1913.000 | 1.00x | 164.000 | 2335 | 417 |
| radial-8-cycles | 32 | facet | 38785.392 | 38498.581–39623.693 | 1.79x | 3460.000 | 1.81x | 319.000 | 1805 | 295 |
| navigation-5-6-cycles | 60 | plain | 17464.615 | 16893.437–18047.532 | 1.00x | 394.000 | 1.00x | 172.000 | 2070 | 360 |
| navigation-5-6-cycles | 60 | facet | 35194.851 | 34875.761–35661.893 | 2.02x | 2557.000 | 6.49x | 191.000 | 2364 | 360 |
| leaderboard-100 | 6 | plain | 3558.051 | 3538.511–3590.180 | 1.00x | 8342.000 | 1.00x | 119.000 | 512 | 0 |
| leaderboard-100 | 6 | facet | 8260.092 | 8132.220–9907.470 | 2.32x | 21163.000 | 2.54x | 259.000 | 805 | 0 |
| theme-swap-200 | 4 | plain | 55.263 | 51.688–68.554 | 1.00x | 2305.000 | 1.00x | 119.000 | 0 | 0 |
| theme-swap-200 | 4 | facet | 3428.957 | 3341.946–3855.499 | 62.05x | 8210.000 | 3.56x | 460.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 388228.963 | 355677.330–400330.863 | 1.00x | 5949.000 | 1.00x | 167.000 | 60240 | 8040 |
| heavy-screen-20-cycles | 20 | facet | 1084591.441 | 1059762.666–1140699.582 | 2.79x | 9509.000 | 1.60x | 672.000 | 88260 | 8040 |
| tile-transfer-10 | 21 | plain | 2499.859 | 2419.518–2550.245 | 1.00x | 689.000 | 1.00x | 218.000 | 229 | 25 |
| tile-transfer-10 | 21 | facet | 15906.040 | 15375.472–16110.167 | 6.36x | 3389.000 | 4.92x | 253.000 | 605 | 84 |
| input-type-switch-20 | 20 | plain | 6109.887 | 5986.672–6344.431 | 1.00x | 1006.000 | 1.00x | 126.000 | 800 | 200 |
| input-type-switch-20 | 20 | facet | 22575.619 | 22021.306–23609.052 | 3.69x | 3808.000 | 3.79x | 146.000 | 1600 | 200 |
| localized-text-swap-50 | 10 | plain | 2451.337 | 2401.301–2521.102 | 1.00x | 1049.000 | 1.00x | 152.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 14347.206 | 13309.705–14666.106 | 5.85x | 4000.000 | 3.81x | 75.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 71.828 | 69.665–83.175 | 1.00x | 592.000 | 1.00x | 50.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1937.053 | 1898.144–1950.683 | 26.97x | 3467.000 | 5.86x | 65.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 278.749 | 253.852–291.147 | 1.00x | 434.000 | 1.00x | 145.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 531.879 | 460.272–665.160 | 1.91x | 2592.000 | 5.97x | 216.000 | 20 | 0 |
| hud-composition-step-down | 10 | plain | 334.673 | 311.369–368.785 | 1.00x | 308.000 | 1.00x | 80.000 | 20 | 0 |
| hud-composition-step-down | 10 | facet | 1095.197 | 1056.057–1107.095 | 3.27x | 2276.000 | 7.39x | 91.000 | 50 | 0 |
| gamepad-grid-6x6 | 35 | plain | 52222.110 | 52079.856–53008.582 | 1.00x | 4405.000 | 1.00x | 3318.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 70846.146 | 70522.179–75549.018 | 1.36x | 12662.000 | 2.87x | 4503.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 2849.434 | 2805.038–3191.509 | 1.00x | 4636.000 | 1.00x | 119.000 | 420 | 30 |
| drag-reorder-100 | 20 | facet | 21303.106 | 19618.032–21526.452 | 7.48x | 10143.000 | 2.19x | 204.000 | 975 | 134 |
| modal-on-modal | 12 | plain | 11033.733 | 10850.648–11492.203 | 1.00x | 419.000 | 1.00x | 230.000 | 1302 | 163 |
| modal-on-modal | 12 | facet | 29784.160 | 28733.089–30345.404 | 2.70x | 3056.000 | 7.29x | 205.000 | 784 | 137 |
| button-native-scale-50 | 6 | plain | 559.111 | 542.536–587.303 | 1.00x | 1641.000 | 1.00x | 90.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 508.745 | 494.233–543.608 | 0.91x | 4780.000 | 2.91x | 187.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 3.08x | 3.86x |

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
