# UI components headless results

Harness commit: `8eba50486ac69bbd06873b07e4789c9ba1ef6a63`. Workflow run: [Library comparison 41180932649](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41180932649). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](method.md) before you compare the two lanes.

# UI components comparison

Harness revision: `8eba50486ac69bbd06873b07e4789c9ba1ef6a63`. Facet: `9cb4aecd2b02b877f161f9a1c617b5445bebe019`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 10682.361 | 10194.615–33373.688 | 1.00x | 2830.000 | 1.00x | 248.000 | 1432 | 470 |
| main-menu-cold | 1 | facet | 13605.065 | 10999.781–17482.710 | 1.27x | 2941.000 | 1.04x | 269.000 | 1437 | 470 |
| hud-120-frames | 120 | plain | 1930.926 | 1661.319–2981.742 | 1.00x | 2827.000 | 1.00x | 232.000 | 500 | 0 |
| hud-120-frames | 120 | facet | 3764.334 | 3735.341–3874.110 | 1.95x | 2913.000 | 1.03x | 249.000 | 500 | 0 |
| world-markers-50 | 100 | plain | 17311.583 | 16146.124–33857.761 | 1.00x | 4030.000 | 1.00x | 316.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 41692.668 | 38640.140–62654.362 | 2.41x | 4926.000 | 1.22x | 377.000 | 6379 | 0 |
| inventory-500 | 40 | plain | 236.818 | 204.749–296.148 | 1.00x | 14024.000 | 1.00x | 485.000 | 0 | 0 |
| inventory-500 | 40 | facet | 815.381 | 780.920–2224.572 | 3.44x | 49619.000 | 3.54x | 1386.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 1922.543 | 1828.821–2875.331 | 1.00x | 4430.000 | 1.00x | 333.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 2859.968 | 2608.488–3049.374 | 1.49x | 7360.000 | 1.66x | 429.000 | 934 | 14 |
| virtual-scroll-2000 | 50 | plain | 5953.889 | 5595.108–7855.350 | 1.00x | 2098.000 | 1.00x | 0.000 | 2366 | 0 |
| virtual-scroll-2000 | 50 | facet | 21353.168 | 19621.824–26876.958 | 3.59x | 4868.000 | 2.32x | 361.000 | 3251 | 27 |
| chat-append-500 | 500 | plain | 30032.845 | 29188.531–43196.827 | 1.00x | 4379.000 | 1.00x | 507.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 75519.728 | 71976.200–107920.508 | 2.51x | 5928.000 | 1.35x | 352.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 19929.557 | 17696.927–41519.791 | 1.00x | 3322.000 | 1.00x | 0.000 | 3601 | 1002 |
| card-collection-60 | 1 | facet | 52044.432 | 49550.605–68607.945 | 2.61x | 14098.000 | 4.24x | 591.000 | 5281 | 1422 |
| mixed-scroll-300 | 100 | plain | 435.197 | 411.130–680.167 | 1.00x | 7019.000 | 1.00x | 476.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 433.014 | 407.846–702.600 | 0.99x | 20195.000 | 2.88x | 686.000 | 100 | 0 |
| settings-17-values | 17 | plain | 212.511 | 193.212–244.429 | 1.00x | 3385.000 | 1.00x | 356.000 | 25 | 0 |
| settings-17-values | 17 | facet | 975.623 | 897.875–2033.820 | 4.59x | 4910.000 | 1.45x | 421.000 | 29 | 0 |
| text-input-200 | 200 | plain | 687.257 | 667.547–701.078 | 1.00x | 2717.000 | 1.00x | 186.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1736.782 | 1229.185–2703.200 | 2.53x | 2849.000 | 1.05x | 226.000 | 220 | 0 |
| button-feedback-50 | 50 | plain | 534.867 | 514.116–545.053 | 1.00x | 3214.000 | 1.00x | 301.000 | 0 | 0 |
| button-feedback-50 | 50 | facet | 548.828 | 522.619–642.550 | 1.03x | 3837.000 | 1.19x | 328.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1191.278 | 1131.308–2313.412 | 1.00x | 2881.000 | 1.00x | 277.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 6088.251 | 6010.083–6421.905 | 5.11x | 3337.000 | 1.16x | 348.000 | 308 | 0 |
| toast-stream-20 | 40 | plain | 3329.266 | 3243.136–3375.616 | 1.00x | 3024.000 | 1.00x | 339.000 | 504 | 141 |
| toast-stream-20 | 40 | facet | 21162.068 | 19964.059–27740.320 | 6.36x | 2977.000 | 0.98x | 381.000 | 1353 | 283 |
| tabs-5-20-switches | 20 | plain | 370.990 | 349.407–383.128 | 1.00x | 2944.000 | 1.00x | 272.000 | 124 | 8 |
| tabs-5-20-switches | 20 | facet | 2102.484 | 1747.108–3379.442 | 5.67x | 3852.000 | 1.31x | 404.000 | 124 | 8 |
| radial-50-cycles | 100 | plain | 79651.099 | 75625.491–99335.907 | 1.00x | 6219.000 | 1.00x | 153.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 574130.615 | 512248.121–598741.760 | 7.21x | 3926.000 | 0.63x | 1241.000 | 21500 | 3700 |
| navigation-5-20-cycles | 200 | plain | 27248.231 | 26867.196–45103.613 | 1.00x | 3760.000 | 1.00x | 471.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 69371.797 | 67515.704–95584.534 | 2.55x | 3128.000 | 0.83x | 452.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 1762.581 | 1555.088–2792.386 | 1.00x | 8064.000 | 1.00x | 525.000 | 752 | 0 |
| leaderboard-100 | 6 | facet | 8671.550 | 8111.644–13171.042 | 4.92x | 39538.000 | 4.90x | 1409.000 | 952 | 0 |
| theme-swap-200 | 5 | plain | 10.566 | 9.815–17.396 | 1.00x | 6356.000 | 1.00x | 4797.000 | 5 | 0 |
| theme-swap-200 | 5 | facet | 96.355 | 85.269–109.536 | 9.12x | 9970.000 | 1.57x | 935.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 562976.516 | 487374.161–622179.106 | 1.00x | 1441.000 | 1.00x | 1377.000 | 79680 | 17260 |
| heavy-screen-20-cycles | 20 | facet | 971276.511 | 924671.420–1027303.802 | 1.73x | 5286.000 | 3.67x | 5283.000 | 87700 | 17240 |
| tile-transfer-20 | 20 | plain | 2834.079 | 2165.920–7232.799 | 1.00x | 3472.000 | 1.00x | 388.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 11096.502 | 10631.200–13114.298 | 3.92x | 4948.000 | 1.43x | 450.000 | 829 | 84 |
| input-type-switch-20 | 20 | plain | 3273.311 | 3079.920–5798.283 | 1.00x | 3459.000 | 1.00x | 349.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 2533.395 | 1627.948–3076.264 | 0.77x | 4279.000 | 1.24x | 347.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 6054.981 | 4786.756–8131.987 | 1.00x | 3522.000 | 1.00x | 320.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 8422.936 | 7948.299–16501.652 | 1.39x | 4255.000 | 1.21x | 340.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 8.643 | 7.271–32.429 | plain ≈ 0 | 3138.000 | 1.00x | 303.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 544.933 | 403.760–680.938 | plain ≈ 0 | 4616.000 | 1.47x | 330.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 184.298 | 163.046–319.722 | 1.00x | 2880.000 | 1.00x | 257.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 463.159 | 316.808–595.609 | 2.51x | 3232.000 | 1.12x | 317.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 231.580 | 221.624–246.472 | 1.00x | 2763.000 | 1.00x | 219.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2113.552 | 2056.726–3459.133 | 9.13x | 2975.000 | 1.08x | 258.000 | 120 | 0 |
| gamepad-grid-6x6 | 35 | plain | 8.723 | 8.303–9.724 | plain ≈ 0 | 3052.000 | 1.00x | 245.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 248.776 | 237.209–258.290 | plain ≈ 0 | 6001.000 | 1.97x | 438.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 1757.594 | 1656.872–1831.535 | 1.00x | 4386.000 | 1.00x | 353.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 37338.740 | 35861.039–55041.033 | 21.24x | 22993.000 | 5.24x | 864.000 | 2115 | 484 |
| modal-on-modal | 20 | plain | 6216.255 | 5583.790–6777.483 | 1.00x | 2990.000 | 1.00x | 378.000 | 650 | 121 |
| modal-on-modal | 20 | facet | 32167.885 | 31149.448–56143.572 | 5.17x | 3733.000 | 1.25x | 459.000 | 1089 | 192 |
| button-native-scale-50 | 20 | plain | 404.050 | 386.293–486.895 | 1.00x | 3921.000 | 1.00x | 326.000 | 0 | 0 |
| button-native-scale-50 | 20 | facet | 392.092 | 369.047–428.246 | 0.97x | 5030.000 | 1.28x | 375.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 3.00x | 1.57x |

## Workloads

- `main-menu-cold`: Mount a background, title, six actions and footer; runtime and control-factory setup is excluded.
- `hud-120-frames`: Update health fill, ammo, currency and timer once per simulated frame.
- `world-markers-50`: Update the labels of 50 native BillboardGui markers anchored to Parts.
- `inventory-500`: Select among 500 retained slots 40 times; each slot has an activation target and selected state.
- `shop-filter-200`: Edit a native TextBox with ten queries, including empty and no match; retain the 200 catalog rows and set their visibility.
- `virtual-scroll-2000`: Scroll a fixed 40-pixel row window from top to bottom; the plain lane keeps a small reusable row pool.
- `chat-append-500`: Append 500 keyed messages; remove the oldest when the log exceeds 100 rows.
- `card-collection-60`: Mount 60 cards with the same artwork, item title and price caption.
- `mixed-scroll-300`: Scroll 300 retained mixed rows: 100 text rows, 100 action buttons and 100 text cards.
- `settings-17-values`: Change each of ten toggle, four slider and three segmented-picker model values; native value readouts show the result.
- `text-input-200`: Type 200 characters through a native TextBox; validation rejects punctuation and accepts letters.
- `button-feedback-50`: Visit each of 50 buttons through Hover, Press and Idle. Both lanes use the same theme StyleSheet state rules and the Studio driver uses real mouse input.
- `stepper-segments-100`: Change a bounded quantity and a segmented choice 100 times through the application model.
- `toast-stream-20`: Show 20 one-shot result toasts with a shared expiry parameter (four seconds headless, 0.05 seconds Studio). Both lanes use the theme toast enter and exit motion.
- `tabs-5-20-switches`: Switch 20 times among five peer pages and keep each visited page and its content. Both lanes mark the current tab, show its selection indicator and add shoulder-button input contexts.
- `radial-50-cycles`: Open a four-command radial menu, select Wave and close it, 50 times. Both lanes draw four Path2D ring sectors, a centre close button, a selection preview, a scrim, gamepad and keyboard input contexts and the theme radial fade, and hide the launcher while the menu is open. Both lanes put the launcher at the screen centre, so the ring opens around it.
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
