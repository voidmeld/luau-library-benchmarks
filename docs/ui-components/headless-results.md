# Headless results

Run date: **2026-11-11 (UTC)**. Harness commit: `3995ec10db4f021b15fbcf0be491c691020ef781`. Workflow run: [Library comparison 43003919063](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/43003919063). Runner: `ubuntu-latest`. Mode: `like-for-like`. Pins: Facet `655cacd`, Compose `8e37196`, Verify `006f6d5`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `3995ec10db4f021b15fbcf0be491c691020ef781`. Facet: `655cacd6a38ed1a9d66f7a88a0eac2383a8bdfe5`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 17298.886 | 16821.823–18597.679 | 1.00x | 2841.000 | 1.00x | 139.000 | 1471 | 483 |
| main-menu-cold | 1 | facet | 17480.694 | 17338.455–17812.913 | 1.01x | 2897.000 | 1.02x | 138.000 | 1486 | 483 |
| hud-60-frames | 60 | plain | 1060.223 | 1039.963–1116.395 | 1.00x | 2778.000 | 1.00x | 35.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 1865.088 | 1767.976–2204.268 | 1.76x | 2933.000 | 1.06x | 126.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 18246.803 | 18072.717–18852.996 | 1.00x | 4061.000 | 1.00x | 163.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 54315.435 | 53133.044–59445.981 | 2.98x | 5202.000 | 1.28x | 204.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 378.217 | 363.346–402.423 | 1.00x | 14941.000 | 1.00x | 88.000 | 0 | 0 |
| inventory-500 | 40 | facet | 854.970 | 839.376–953.103 | 2.26x | 26478.000 | 1.77x | 150.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3653.864 | 3605.312–3737.987 | 1.00x | 4629.000 | 1.00x | 105.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 4453.552 | 4387.664–4542.413 | 1.22x | 6497.000 | 1.40x | 141.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 2384.973 | 2332.765–2829.487 | 1.00x | 3086.000 | 1.00x | 145.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 6085.922 | 5952.246–6126.934 | 2.55x | 3920.000 | 1.27x | 131.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 21058.254 | 20606.128–31808.416 | 1.00x | 4226.000 | 1.00x | 94.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 39264.307 | 38682.300–51992.173 | 1.86x | 4703.000 | 1.11x | 75.000 | 3550 | 250 |
| card-collection-60 | 1 | plain | 31314.048 | 30197.854–31675.962 | 1.00x | 5265.000 | 1.00x | 161.000 | 3640 | 1015 |
| card-collection-60 | 1 | facet | 94036.194 | 82500.255–111098.242 | 3.00x | 12309.000 | 2.34x | 90.000 | 5680 | 1555 |
| mixed-scroll-300 | 50 | plain | 312.870 | 304.429–325.589 | 1.00x | 7689.000 | 1.00x | 148.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 306.191 | 298.200–349.115 | 0.98x | 17115.000 | 2.23x | 195.000 | 50 | 0 |
| settings-17-values | 17 | plain | 275.796 | 261.555–289.737 | 1.00x | 3380.000 | 1.00x | 141.000 | 25 | 0 |
| settings-17-values | 17 | facet | 707.782 | 670.738–796.562 | 2.57x | 4531.000 | 1.34x | 217.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1022.365 | 995.075–1052.540 | 1.00x | 2687.000 | 1.00x | 37.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1491.315 | 1478.998–1514.470 | 1.46x | 2861.000 | 1.06x | 118.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 274.584 | 270.739–288.735 | 1.00x | 3232.000 | 1.00x | 102.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 271.099 | 261.905–283.517 | 0.99x | 3644.000 | 1.13x | 134.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1378.170 | 1333.684–1410.767 | 1.00x | 2858.000 | 1.00x | 136.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 4767.100 | 4696.907–4824.985 | 3.46x | 3442.000 | 1.20x | 282.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 1452.529 | 1394.844–1470.706 | 1.00x | 2810.000 | 1.00x | 123.000 | 106 | 29 |
| toast-stream-4 | 8 | facet | 5943.303 | 5813.762–5963.483 | 4.09x | 2981.000 | 1.06x | 180.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 516.391 | 501.869–880.867 | 1.00x | 2923.000 | 1.00x | 139.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1263.210 | 1241.098–1287.917 | 2.45x | 3857.000 | 1.32x | 225.000 | 80 | 8 |
| radial-15-cycles | 30 | plain | 31035.615 | 30793.309–31602.810 | 1.00x | 4646.000 | 1.00x | 175.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 56156.109 | 55832.951–56832.796 | 1.81x | 4215.000 | 0.91x | 291.000 | 2678 | 497 |
| navigation-5-6-cycles | 60 | plain | 14410.041 | 14249.764–14535.285 | 1.00x | 3199.000 | 1.00x | 206.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 32267.488 | 31999.023–32389.357 | 2.24x | 3093.000 | 0.97x | 225.000 | 2364 | 360 |
| leaderboard-100 | 3 | plain | 1230.642 | 1210.172–1240.847 | 1.00x | 8235.000 | 1.00x | 88.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 4353.070 | 4037.075–4420.520 | 3.54x | 22645.000 | 2.75x | 208.000 | 300 | 0 |
| theme-swap-200 | 2 | plain | 34.591 | 32.678–39.818 | 1.00x | 6386.000 | 1.00x | 4775.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 253.723 | 239.583–285.280 | 7.33x | 7069.000 | 1.11x | 255.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 849915.690 | 713128.087–872215.517 | 1.00x | 143.000 | 1.00x | 143.000 | 80460 | 17520 |
| heavy-screen-20-cycles | 20 | facet | 1325428.252 | 1281057.724–1356398.372 | 1.56x | 162.000 | 1.13x | 146.000 | 116480 | 17500 |
| tile-transfer-20 | 20 | plain | 4413.149 | 4368.644–4461.520 | 1.00x | 3507.000 | 1.00x | 183.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 12640.136 | 12419.040–13129.946 | 2.86x | 4825.000 | 1.38x | 233.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1364.951 | 1340.034–1397.659 | 1.00x | 3458.000 | 1.00x | 132.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 12923.964 | 12820.521–13662.842 | 9.47x | 4416.000 | 1.28x | 155.000 | 800 | 200 |
| localized-text-swap-50 | 10 | plain | 2421.265 | 2354.648–2449.478 | 1.00x | 3434.000 | 1.00x | 46.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 11987.795 | 11716.145–12356.338 | 4.95x | 4588.000 | 1.34x | 124.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 33.069 | 30.606–35.993 | 1.00x | 3152.000 | 1.00x | 98.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1839.509 | 1797.537–1909.612 | 55.63x | 4813.000 | 1.53x | 116.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 255.836 | 251.841–277.298 | 1.00x | 2867.000 | 1.00x | 116.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 460.068 | 434.029–478.384 | 1.80x | 3153.000 | 1.10x | 199.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 438.906 | 426.708–460.448 | 1.00x | 2748.000 | 1.00x | 77.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 1746.032 | 1717.309–1770.888 | 3.98x | 2967.000 | 1.08x | 135.000 | 100 | 0 |
| gamepad-grid-6x6 | 35 | plain | 41787.348 | 41474.787–42002.215 | 1.00x | 8404.000 | 1.00x | 234.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 63911.537 | 63500.873–65177.922 | 1.53x | 12355.000 | 1.47x | 3894.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 3178.170 | 3087.257–3310.807 | 1.00x | 4480.000 | 1.00x | 125.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 44262.179 | 43265.812–45126.933 | 13.93x | 17960.000 | 4.01x | 302.000 | 1851 | 304 |
| modal-on-modal | 20 | plain | 7124.473 | 6975.173–7288.334 | 1.00x | 3010.000 | 1.00x | 172.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 29375.173 | 29023.736–30191.847 | 4.12x | 3750.000 | 1.25x | 245.000 | 946 | 185 |
| button-native-scale-50 | 6 | plain | 562.719 | 553.806–574.226 | 1.00x | 3945.000 | 1.00x | 134.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 564.612 | 549.138–571.682 | 1.00x | 4689.000 | 1.19x | 152.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 2.78x | 1.35x |

## Workloads

- `main-menu-cold`: Mount a background, title, six actions and footer; runtime and control-factory setup is excluded.
- `hud-60-frames`: Update health fill, ammo, currency and timer once per simulated frame.
- `world-markers-50`: Update the labels of 50 native BillboardGui markers anchored to Parts.
- `inventory-500`: Select among 500 retained slots 40 times; each slot has an activation target and selected state.
- `shop-filter-200`: Edit a native TextBox with ten queries, including empty and no match; retain the 200 catalog rows and set their visibility.
- `virtual-scroll-2000`: Scroll a fixed 40-pixel row window down in 796-pixel steps; the plain lane keeps a small reusable row pool.
- `chat-append-250`: Append 250 keyed messages; remove the oldest when the log exceeds 100 rows.
- `card-collection-60`: Mount 60 cards with the same artwork, item title and price caption.
- `mixed-scroll-300`: Scroll 300 retained mixed rows: 100 text rows, 100 action buttons and 100 text cards.
- `settings-17-values`: Change each of ten toggle, four slider and three segmented-picker model values; native value readouts show the result.
- `text-input-200`: Type 200 characters through a native TextBox; validation rejects punctuation and accepts letters.
- `button-feedback-50`: Visit 15 of 50 buttons through Hover, Press and Idle. Both lanes use the same theme StyleSheet state rules and the Studio driver uses real mouse input.
- `stepper-segments-100`: Change a bounded quantity and a segmented choice 100 times through the application model.
- `toast-stream-4`: Show 4 one-shot result toasts with a shared expiry parameter (four seconds headless, 0.05 seconds Studio). Both lanes use the theme toast enter and exit motion.
- `tabs-5-5-switches`: Switch 5 times among five peer pages and keep each visited page and its content. Both lanes mark the current tab, show its selection indicator and add shoulder-button input contexts.
- `radial-15-cycles`: Open a four-command radial menu, select Wave and close it, 15 times. Both lanes draw four Path2D ring sectors, a centre close button, a selection preview, a scrim, gamepad and keyboard input contexts and the theme radial fade, and hide the launcher while the menu is open. Both lanes put the launcher at the screen centre, so the ring opens around it.
- `navigation-5-6-cycles`: Push five child pages and pop them, 6 times; root has no Back action and covered pages remain retained.
- `leaderboard-100`: Sort 100 retained player rows by name, score and wins; replace every score after each sort.
- `theme-swap-200`: Swap two neutral packages on 200 themed buttons. Both lanes build both themes in setup. Facet updates its StyleSheet tokens while plain relinks one of two prebuilt theme StyleSheets.
- `heavy-screen-20-cycles`: Mount and dispose 200 action controls and 200 text rows, 20 complete lifetimes.
- `tile-transfer-20`: Pick up 20 tiles with keyboard activation and drop each into the second grid. Both lanes show a drag preview, a held state, a status hint and a cancel input context, and shrink the preview with the theme travel motion after the drop. Facet also installs pointer drop resolution.
- `input-type-switch-20`: Switch the authored preferred-input fact between keyboard and gamepad on 20 action controls and prompts. This measures adaptation after input detection.
- `localized-text-swap-50`: Swap translated strings on 50 retained labels between English and German. Both lanes use the same LocalizationTable translators and disable automatic localization of translated text.
- `text-size-preference-50`: Change an authored text-size preference across four ranks on a 50-label screen. Facet updates the theme StyleRules; plain updates one shared native body rule.
- `phone-rotation-hub`: Rotate a retained hub between 390 by 844 and 844 by 390 layout units. Turn its subject, task list and action column without remounting the controls.
- `hud-composition-step-down`: Resize a HUD from 800 to 400 layout units. Keep rich and compact status forms mounted, choose the form that fits and restore the rich form on expansion.
- `gamepad-grid-6x6`: Walk all 36 retained cells of a six by six grid in a snake path. Both hosts send D-pad keys through their input host and check native selection.
- `drag-reorder-100`: Drag the first of 100 retained rows after the fifth row, 20 times. Facet uses VirtualList reorderable and onReorder; plain uses a native UIDragDetector and insertion indicator.
- `modal-on-modal`: Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.
- `button-native-scale-50`: Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.
