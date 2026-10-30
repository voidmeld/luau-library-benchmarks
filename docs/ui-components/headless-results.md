# UI components headless results

Harness commit: `425258bc2602725c302265cc41a92b3e503f8c23`. Workflow run: [Library comparison 41002131734](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41002131734). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](method.md) before you compare the two lanes.

# UI components comparison

Harness revision: `425258bc2602725c302265cc41a92b3e503f8c23`. Facet: `6215e6c7defca48f1451c333683ce357d365868f`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 12605.854 | 1.00x | 2741.000 | 1.00x | 262.000 | 1426 | 468 |
| main-menu-cold | 1 | facet | 15120.049 | 1.20x | 2851.000 | 1.04x | 254.000 | 1431 | 468 |
| hud-600-frames | 600 | plain | 12049.454 | 1.00x | 2739.000 | 1.00x | 230.000 | 2488 | 0 |
| hud-600-frames | 600 | facet | 25848.460 | 2.15x | 2822.000 | 1.03x | 237.000 | 2488 | 0 |
| progress-20-120-frames | 120 | plain | 15123.554 | 1.00x | 3340.000 | 1.00x | 264.000 | 2400 | 0 |
| progress-20-120-frames | 120 | facet | 22911.538 | 1.51x | 3702.000 | 1.11x | 0.000 | 2400 | 0 |
| badges-30-300-updates | 300 | plain | 38181.905 | 1.00x | 2815.000 | 1.00x | 0.000 | 9410 | 0 |
| badges-30-300-updates | 300 | facet | 136885.303 | 3.59x | 4118.000 | 1.46x | 339.000 | 9410 | 0 |
| world-markers-50 | 100 | plain | 22466.531 | 1.00x | 4016.000 | 1.00x | 320.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 83967.309 | 3.74x | 4936.000 | 1.23x | 420.000 | 11890 | 50 |
| inventory-100 | 200 | plain | 844.175 | 1.00x | 5576.000 | 1.00x | 334.000 | 0 | 0 |
| inventory-100 | 200 | facet | 3804.126 | 4.51x | 13163.000 | 2.36x | 118.000 | 0 | 0 |
| inventory-500 | 200 | plain | 1247.394 | 1.00x | 16690.000 | 1.00x | 338.000 | 0 | 0 |
| inventory-500 | 200 | facet | 4499.624 | 3.61x | 55782.000 | 3.34x | 1328.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3888.623 | 1.00x | 4232.000 | 1.00x | 332.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 4368.517 | 1.12x | 7220.000 | 1.71x | 420.000 | 934 | 14 |
| virtual-scroll-2000 | 100 | plain | 24748.575 | 1.00x | 2882.000 | 1.00x | 110.000 | 4681 | 0 |
| virtual-scroll-2000 | 100 | facet | 73719.831 | 2.98x | 4963.000 | 1.72x | 359.000 | 6401 | 42 |
| chat-append-500 | 500 | plain | 47614.799 | 1.00x | 4213.000 | 1.00x | 497.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 106624.663 | 2.24x | 5989.000 | 1.42x | 588.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 28463.092 | 1.00x | 5408.000 | 1.00x | 314.000 | 3595 | 1000 |
| card-collection-60 | 1 | facet | 70735.491 | 2.49x | 14737.000 | 2.73x | 543.000 | 5275 | 1420 |
| mixed-scroll-300 | 100 | plain | 501.727 | 1.00x | 7132.000 | 1.00x | 467.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 533.485 | 1.06x | 20730.000 | 2.91x | 676.000 | 100 | 0 |
| settings-17-values | 17 | plain | 331.910 | 1.00x | 3313.000 | 1.00x | 578.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1528.349 | 4.60x | 4943.000 | 1.49x | 394.000 | 35 | 0 |
| text-input-200 | 200 | plain | 1088.133 | 1.00x | 2617.000 | 1.00x | 178.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1736.862 | 1.60x | 2741.000 | 1.05x | 213.000 | 220 | 0 |
| button-feedback-50 | 50 | plain | 636.380 | 1.00x | 3108.000 | 1.00x | 301.000 | 0 | 0 |
| button-feedback-50 | 50 | facet | 582.160 | 0.91x | 3793.000 | 1.22x | 316.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1290.379 | 1.00x | 2790.000 | 1.00x | 311.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 9099.603 | 7.05x | 3229.000 | 1.16x | 314.000 | 508 | 0 |
| dialog-50-cycles | 100 | plain | 42666.775 | 1.00x | 2199.000 | 1.00x | 0.000 | 4350 | 1101 |
| dialog-50-cycles | 100 | facet | 128078.181 | 3.00x | 3402.000 | 1.55x | 628.000 | 3747 | 771 |
| toast-stream-100 | 200 | plain | 23739.852 | 1.00x | 3988.000 | 1.00x | 477.000 | 2518 | 701 |
| toast-stream-100 | 200 | facet | 162387.108 | 6.84x | 3357.000 | 0.84x | 862.000 | 8100 | 1800 |
| tabs-5-100-switches | 100 | plain | 1324.850 | 1.00x | 2859.000 | 1.00x | 368.000 | 444 | 8 |
| tabs-5-100-switches | 100 | facet | 10711.735 | 8.09x | 3773.000 | 1.32x | 390.000 | 444 | 8 |
| radial-50-cycles | 100 | plain | 76514.863 | 1.00x | 3320.000 | 1.00x | 890.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 425924.004 | 5.57x | 2447.000 | 0.74x | 0.000 | 21500 | 3700 |
| navigation-5-20-cycles | 200 | plain | 47317.370 | 1.00x | 2896.000 | 1.00x | 444.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 102618.109 | 2.17x | 3217.000 | 1.11x | 628.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 2603.611 | 1.00x | 7877.000 | 1.00x | 522.000 | 752 | 0 |
| leaderboard-100 | 6 | facet | 13625.280 | 5.23x | 40589.000 | 5.15x | 1062.000 | 952 | 0 |
| theme-swap-200 | 10 | plain | 29.976 | 1.00x | 6343.000 | 1.00x | 4888.000 | 10 | 0 |
| theme-swap-200 | 10 | facet | 188.945 | 6.30x | 10133.000 | 1.60x | 759.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 823699.595 | 1.00x | 3188.000 | 1.00x | 3187.000 | 79560 | 17220 |
| heavy-screen-20-cycles | 20 | facet | 1380040.810 | 1.68x | 5276.000 | 1.65x | 5258.000 | 87580 | 17200 |
| tile-transfer-20 | 20 | plain | 2805.355 | 1.00x | 3371.000 | 1.00x | 557.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 14653.992 | 5.22x | 4886.000 | 1.45x | 426.000 | 829 | 84 |
| input-type-switch-20 | 20 | plain | 4878.984 | 1.00x | 3369.000 | 1.00x | 330.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 3489.237 | 0.72x | 4297.000 | 1.28x | 358.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 9728.778 | 1.00x | 3406.000 | 1.00x | 311.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 11200.971 | 1.15x | 4119.000 | 1.21x | 307.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 11.487 | plain ≈ 0 | 3028.000 | 1.00x | 294.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1773.827 | plain ≈ 0 | 4747.000 | 1.57x | 331.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 284.219 | 1.00x | 2789.000 | 1.00x | 247.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 597.042 | 2.10x | 3146.000 | 1.13x | 303.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 331.150 | 1.00x | 2673.000 | 1.00x | 201.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 7104.164 | 21.45x | 2879.000 | 1.08x | 242.000 | 280 | 0 |
| gamepad-grid-6x6 | 35 | plain | 16.184 | plain ≈ 0 | 2933.000 | 1.00x | 229.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 2031.196 | plain ≈ 0 | 6358.000 | 2.17x | 429.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 3787.878 | 1.00x | 4451.000 | 1.00x | 352.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 206514.739 | 54.52x | 25476.000 | 5.72x | 848.000 | 2395 | 524 |
| modal-on-modal | 20 | plain | 9582.662 | 1.00x | 2823.000 | 1.00x | 390.000 | 650 | 121 |
| modal-on-modal | 20 | facet | 44017.594 | 4.59x | 3711.000 | 1.31x | 469.000 | 1129 | 192 |
| button-native-scale-50 | 20 | plain | 448.628 | 1.00x | 3898.000 | 1.00x | 325.000 | 0 | 0 |
| button-native-scale-50 | 20 | facet | 492.633 | 1.10x | 5055.000 | 1.30x | 358.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 3.09x | 1.53x |

## Workloads

- `main-menu-cold`: Mount a background, title, six actions and footer; runtime and control-factory setup is excluded.
- `hud-600-frames`: Update health fill, ammo, currency and timer once per simulated frame.
- `progress-20-120-frames`: Drive 20 measured progress fills with per-frame values; both lanes use the same linear frame sequence.
- `badges-30-300-updates`: Update all 30 notification counts, 300 times; badges keep their native text nodes.
- `world-markers-50`: Update the labels of 50 native BillboardGui markers anchored to Parts.
- `inventory-100`: Select among 100 retained slots 200 times; each slot has an activation target and selected state.
- `inventory-500`: Select among 500 retained slots 200 times; each slot has an activation target and selected state.
- `shop-filter-200`: Edit a native TextBox with ten queries, including empty and no match; retain the 200 catalog rows and set their visibility.
- `virtual-scroll-2000`: Scroll a fixed 40-pixel row window from top to bottom; the plain lane keeps a small reusable row pool.
- `chat-append-500`: Append 500 keyed messages; remove the oldest when the log exceeds 100 rows.
- `card-collection-60`: Mount 60 cards with the same artwork, item title and price caption.
- `mixed-scroll-300`: Scroll 300 retained mixed rows: 100 text rows, 100 action buttons and 100 text cards.
- `settings-17-values`: Change each of ten toggle, four slider and three segmented-picker model values; native value readouts show the result.
- `text-input-200`: Type 200 characters through a native TextBox; validation rejects punctuation and accepts letters.
- `button-feedback-50`: Visit each of 50 buttons through Hover, Press and Idle. Both lanes use the same theme StyleSheet state rules and the Studio driver uses real mouse input.
- `stepper-segments-100`: Change a bounded quantity and a segmented choice 100 times through the application model.
- `dialog-50-cycles`: Open a confirmation dialog, then activate Confirm and close it, 50 times. Both lanes add a scrim, an outside dismiss target, a selection trap, Back and Return input contexts and the theme dialog fade.
- `toast-stream-100`: Show 100 one-shot result toasts with a shared expiry parameter (four seconds headless, 0.05 seconds Studio). Both lanes use the theme toast enter and exit motion.
- `tabs-5-100-switches`: Switch 100 times among five peer pages and keep each visited page and its content. Both lanes mark the current tab, show its selection indicator and add shoulder-button input contexts.
- `radial-50-cycles`: Open a four-command radial menu, select Wave and close it, 50 times. Both lanes draw four Path2D ring sectors, a centre close button, a selection preview, a scrim, gamepad and keyboard input contexts and the theme radial fade, and hide the launcher while the menu is open.
- `navigation-5-20-cycles`: Push five child pages and pop them, 20 times; root has no Back action and covered pages remain retained.
- `leaderboard-100`: Sort 100 retained player rows by name, score and wins; replace every score after each sort.
- `theme-swap-200`: Swap two neutral packages on 200 themed buttons. Both lanes build both themes in setup. Facet updates its StyleSheet tokens while plain relinks one of two prebuilt theme StyleSheets.
- `heavy-screen-20-cycles`: Mount and dispose 200 action controls and 200 text rows, 20 complete lifetimes.
- `tile-transfer-20`: Pick up 20 tiles with keyboard activation and drop each into the second grid. Both lanes show a drag preview, a held state, a status hint and a cancel input context, and shrink the preview with the theme travel motion after the drop. Facet also installs pointer drop resolution.
- `input-type-switch-20`: Switch the authored preferred-input fact between keyboard and gamepad on 20 action controls and prompts. This measures adaptation after input detection.
- `localized-text-swap-50`: Swap translated strings on 50 retained labels between English and German. Both lanes use the same LocalizationTable translators and disable automatic localization of translated text.
- `text-size-preference-50`: Change an authored text-size preference across four ranks on a 50-label screen. Facet updates the theme StyleRules; plain updates one shared native body rule.
- `phone-rotation-hub`: Rotate a retained hub between 390 by 844 and 844 by 390 layout units. Turn its subject, task list and action column without remounting the controls.
- `hud-composition-step-down`: Resize a HUD from 800 to 400 layout units. Keep rich and compact status forms mounted, choose the form that fits and restore the rich form on expansion.
- `gamepad-grid-6x6`: Walk all 36 retained cells of a six by six grid in a snake path. Headless uses the public focus move API; Studio sends directional keys through the native input pipeline.
- `drag-reorder-100`: Drag the first of 100 retained rows after the fifth row, 20 times. Facet uses VirtualList reorderable and onReorder; plain uses a native UIDragDetector and insertion indicator.
- `modal-on-modal`: Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.
- `button-native-scale-50`: Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.
