# UI components headless results

Harness commit: `641a655a2c64225e868c9a69a6289605f8513619`. Workflow run: [Library comparison 41034898619](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41034898619). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](method.md) before you compare the two lanes.

# UI components comparison

Harness revision: `641a655a2c64225e868c9a69a6289605f8513619`. Facet: `09512b286ee26ff9910b9a3115b3401fd0837fe1`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 18411.310 | 1.00x | 2763.000 | 1.00x | 263.000 | 1426 | 468 |
| main-menu-cold | 1 | facet | 17800.403 | 0.97x | 2869.000 | 1.04x | 255.000 | 1431 | 468 |
| hud-600-frames | 600 | plain | 13168.954 | 1.00x | 2737.000 | 1.00x | 219.000 | 2488 | 0 |
| hud-600-frames | 600 | facet | 35146.040 | 2.67x | 2829.000 | 1.03x | 245.000 | 2488 | 0 |
| progress-20-120-frames | 120 | plain | 11247.650 | 1.00x | 3172.000 | 1.00x | 273.000 | 2400 | 0 |
| progress-20-120-frames | 120 | facet | 26091.659 | 2.32x | 3731.000 | 1.18x | 216.000 | 2400 | 0 |
| badges-30-300-updates | 300 | plain | 43780.442 | 1.00x | 3217.000 | 1.00x | 320.000 | 9410 | 0 |
| badges-30-300-updates | 300 | facet | 183188.699 | 4.18x | 4122.000 | 1.28x | 316.000 | 9410 | 0 |
| world-markers-50 | 100 | plain | 27801.941 | 1.00x | 3940.000 | 1.00x | 332.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 94215.445 | 3.39x | 4480.000 | 1.14x | 37.000 | 6758 | 50 |
| inventory-100 | 200 | plain | 864.432 | 1.00x | 4914.000 | 1.00x | 312.000 | 0 | 0 |
| inventory-100 | 200 | facet | 4730.562 | 5.47x | 11945.000 | 2.43x | 525.000 | 0 | 0 |
| inventory-500 | 200 | plain | 1339.022 | 1.00x | 13373.000 | 1.00x | 348.000 | 0 | 0 |
| inventory-500 | 200 | facet | 5098.705 | 3.81x | 45716.000 | 3.42x | 0.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3415.115 | 1.00x | 4263.000 | 1.00x | 326.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 5130.427 | 1.50x | 7080.000 | 1.66x | 405.000 | 934 | 14 |
| virtual-scroll-2000 | 100 | plain | 20416.865 | 1.00x | 2957.000 | 1.00x | 231.000 | 4681 | 0 |
| virtual-scroll-2000 | 100 | facet | 75302.930 | 3.69x | 4840.000 | 1.64x | 353.000 | 6401 | 42 |
| chat-append-500 | 500 | plain | 42692.202 | 1.00x | 4242.000 | 1.00x | 508.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 143209.808 | 3.35x | 6063.000 | 1.43x | 622.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 32395.195 | 1.00x | 5017.000 | 1.00x | 325.000 | 3595 | 1000 |
| card-collection-60 | 1 | facet | 84751.908 | 2.62x | 13921.000 | 2.77x | 593.000 | 5275 | 1420 |
| mixed-scroll-300 | 100 | plain | 560.041 | 1.00x | 6714.000 | 1.00x | 475.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 629.171 | 1.12x | 19809.000 | 2.95x | 663.000 | 100 | 0 |
| settings-17-values | 17 | plain | 218.941 | 1.00x | 3283.000 | 1.00x | 591.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1206.374 | 5.51x | 4782.000 | 1.46x | 367.000 | 35 | 0 |
| text-input-200 | 200 | plain | 1570.537 | 1.00x | 2638.000 | 1.00x | 194.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2122.553 | 1.35x | 2757.000 | 1.05x | 223.000 | 220 | 0 |
| button-feedback-50 | 50 | plain | 823.215 | 1.00x | 3106.000 | 1.00x | 294.000 | 0 | 0 |
| button-feedback-50 | 50 | facet | 821.622 | 1.00x | 3711.000 | 1.19x | 316.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1772.566 | 1.00x | 2800.000 | 1.00x | 337.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 11872.709 | 6.70x | 3211.000 | 1.15x | 324.000 | 508 | 0 |
| dialog-50-cycles | 100 | plain | 45886.894 | 1.00x | 2984.000 | 1.00x | 546.000 | 4350 | 1101 |
| dialog-50-cycles | 100 | facet | 146719.359 | 3.20x | 3433.000 | 1.15x | 647.000 | 3747 | 771 |
| toast-stream-100 | 200 | plain | 24747.941 | 1.00x | 3513.000 | 1.00x | 486.000 | 2502 | 701 |
| toast-stream-100 | 200 | facet | 195472.485 | 7.90x | 2922.000 | 0.83x | 430.000 | 8100 | 1800 |
| tabs-5-100-switches | 100 | plain | 1415.666 | 1.00x | 2866.000 | 1.00x | 366.000 | 444 | 8 |
| tabs-5-100-switches | 100 | facet | 13638.098 | 9.63x | 3741.000 | 1.31x | 386.000 | 444 | 8 |
| radial-50-cycles | 100 | plain | 87758.028 | 1.00x | 3338.000 | 1.00x | 885.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 563754.014 | 6.42x | 4563.000 | 1.37x | 1941.000 | 21500 | 3700 |
| navigation-5-20-cycles | 200 | plain | 44231.129 | 1.00x | 2952.000 | 1.00x | 463.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 111692.613 | 2.53x | 3220.000 | 1.09x | 638.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 3139.090 | 1.00x | 7686.000 | 1.00x | 484.000 | 752 | 0 |
| leaderboard-100 | 6 | facet | 14910.327 | 4.75x | 37815.000 | 4.92x | 1472.000 | 952 | 0 |
| theme-swap-200 | 10 | plain | 26.580 | 1.00x | 6393.000 | 1.00x | 4931.000 | 10 | 0 |
| theme-swap-200 | 10 | facet | 240.411 | 9.04x | 9766.000 | 1.53x | 749.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 839276.626 | 1.00x | 3486.000 | 1.00x | 3492.000 | 79560 | 17220 |
| heavy-screen-20-cycles | 20 | facet | 1538122.101 | 1.83x | 3685.000 | 1.06x | 3693.000 | 87580 | 17200 |
| tile-transfer-20 | 20 | plain | 4271.905 | 1.00x | 3377.000 | 1.00x | 560.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 21314.673 | 4.99x | 4788.000 | 1.42x | 432.000 | 829 | 84 |
| input-type-switch-20 | 20 | plain | 6744.304 | 1.00x | 3329.000 | 1.00x | 316.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 3115.195 | 0.46x | 4239.000 | 1.27x | 358.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 8062.247 | 1.00x | 3416.000 | 1.00x | 328.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 12977.419 | 1.61x | 4151.000 | 1.22x | 316.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 12.033 | plain ≈ 0 | 3043.000 | 1.00x | 296.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1985.185 | plain ≈ 0 | 4674.000 | 1.54x | 328.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 244.529 | 1.00x | 2787.000 | 1.00x | 265.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 562.856 | 2.30x | 3120.000 | 1.12x | 300.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 374.191 | 1.00x | 2683.000 | 1.00x | 219.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 6788.196 | 18.14x | 2878.000 | 1.07x | 236.000 | 280 | 0 |
| gamepad-grid-6x6 | 35 | plain | 14.106 | plain ≈ 0 | 2942.000 | 1.00x | 245.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 1341.928 | plain ≈ 0 | 5794.000 | 1.97x | 425.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 3142.897 | 1.00x | 4256.000 | 1.00x | 370.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 297517.374 | 94.66x | 22184.000 | 5.21x | 842.000 | 2395 | 524 |
| modal-on-modal | 20 | plain | 8072.225 | 1.00x | 2849.000 | 1.00x | 402.000 | 650 | 121 |
| modal-on-modal | 20 | facet | 57336.088 | 7.10x | 3700.000 | 1.30x | 469.000 | 1129 | 192 |
| button-native-scale-50 | 20 | plain | 671.130 | 1.00x | 3810.000 | 1.00x | 350.000 | 0 | 0 |
| button-native-scale-50 | 20 | facet | 679.906 | 1.01x | 4868.000 | 1.28x | 335.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 3.45x | 1.50x |

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
