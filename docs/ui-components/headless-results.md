# Headless results

Run date: **2026-11-07 (UTC)**. Harness commit: `52fcdf85f8c2bbf69145f6dde36374a0e45f205f`. Workflow run: [Library comparison 42362732673](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/42362732673). Runner: `ubuntu-latest`. Mode: `like-for-like`. Pins: Facet `763a2a4`, Compose `9b7c217`, Verify `2528d1e`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `52fcdf85f8c2bbf69145f6dde36374a0e45f205f`. Facet: `763a2a4f2f901a0cde9e0ccd05d5436110d7cb5d`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 23429.080 | 23080.268–23997.372 | 1.00x | 2831.000 | 1.00x | 106.000 | 1468 | 482 |
| main-menu-cold | 1 | facet | 26684.725 | 24155.758–27313.180 | 1.14x | 2951.000 | 1.04x | 160.000 | 1483 | 482 |
| hud-60-frames | 60 | plain | 1235.901 | 1187.069–1264.303 | 1.00x | 2816.000 | 1.00x | 91.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 2777.062 | 2751.624–2971.736 | 2.25x | 2940.000 | 1.04x | 84.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 21671.907 | 20997.878–22142.386 | 1.00x | 4043.000 | 1.00x | 137.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 66522.064 | 63026.866–73469.249 | 3.07x | 5213.000 | 1.29x | 220.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 377.556 | 361.216–418.202 | 1.00x | 14880.000 | 1.00x | 86.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1104.093 | 1066.293–1161.380 | 2.92x | 28116.000 | 1.89x | 205.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 4596.982 | 4449.526–4758.373 | 1.00x | 4641.000 | 1.00x | 112.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 5563.097 | 5432.782–5811.440 | 1.21x | 6400.000 | 1.38x | 158.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 2959.252 | 2803.631–3248.662 | 1.00x | 3080.000 | 1.00x | 104.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 9076.334 | 8891.819–9290.083 | 3.07x | 4036.000 | 1.31x | 97.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 27891.462 | 27633.800–28478.078 | 1.00x | 4247.000 | 1.00x | 86.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 51412.994 | 51082.055–53948.374 | 1.84x | 4694.000 | 1.11x | 51.000 | 3550 | 250 |
| card-collection-60 | 1 | plain | 43597.098 | 42851.053–44142.798 | 1.00x | 5241.000 | 1.00x | 96.000 | 3637 | 1014 |
| card-collection-60 | 1 | facet | 107360.164 | 106047.370–112003.614 | 2.46x | 12306.000 | 2.35x | 121.000 | 5677 | 1554 |
| mixed-scroll-300 | 50 | plain | 353.271 | 336.249–393.025 | 1.00x | 7695.000 | 1.00x | 172.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 347.489 | 338.672–375.261 | 0.98x | 17035.000 | 2.21x | 181.000 | 50 | 0 |
| settings-17-values | 17 | plain | 282.247 | 263.443–289.131 | 1.00x | 3386.000 | 1.00x | 133.000 | 25 | 0 |
| settings-17-values | 17 | facet | 857.913 | 824.501–1037.018 | 3.04x | 4538.000 | 1.34x | 232.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1200.553 | 1159.758–1277.297 | 1.00x | 2726.000 | 1.00x | 60.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1840.841 | 1816.235–1886.977 | 1.53x | 2858.000 | 1.05x | 109.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 310.741 | 300.962–319.288 | 1.00x | 3231.000 | 1.00x | 70.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 322.443 | 308.798–344.995 | 1.04x | 3631.000 | 1.12x | 119.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1666.655 | 1592.286–1722.600 | 1.00x | 2848.000 | 1.00x | 103.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 8115.428 | 7879.297–8214.143 | 4.87x | 3453.000 | 1.21x | 281.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 1878.410 | 1851.390–1967.026 | 1.00x | 2790.000 | 1.00x | 99.000 | 106 | 29 |
| toast-stream-4 | 8 | facet | 7685.663 | 7561.481–8002.024 | 4.09x | 2987.000 | 1.07x | 173.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 589.172 | 574.714–630.038 | 1.00x | 2906.000 | 1.00x | 99.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1662.246 | 1595.331–1738.789 | 2.82x | 3867.000 | 1.33x | 224.000 | 80 | 8 |
| radial-15-cycles | 30 | plain | 40334.455 | 39562.062–42831.311 | 1.00x | 4594.000 | 1.00x | 143.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 74504.681 | 73160.258–75247.268 | 1.85x | 4218.000 | 0.92x | 248.000 | 2678 | 497 |
| navigation-5-6-cycles | 60 | plain | 20058.266 | 19441.463–20271.034 | 1.00x | 3169.000 | 1.00x | 125.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 42576.880 | 42153.920–43034.626 | 2.12x | 3083.000 | 0.97x | 192.000 | 2364 | 360 |
| leaderboard-100 | 3 | plain | 1099.145 | 1084.347–1180.767 | 1.00x | 8131.000 | 1.00x | 135.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 4690.100 | 4507.204–4937.422 | 4.27x | 22953.000 | 2.82x | 215.000 | 300 | 0 |
| theme-swap-200 | 2 | plain | 37.450 | 33.513–38.952 | 1.00x | 6336.000 | 1.00x | 4759.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 276.146 | 251.630–286.505 | 7.37x | 7198.000 | 1.14x | 253.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 1104933.834 | 1019401.778–1176612.403 | 1.00x | 175.000 | 1.00x | 151.000 | 80400 | 17500 |
| heavy-screen-20-cycles | 20 | facet | 1897057.569 | 1865647.215–1917228.748 | 1.72x | 39.000 | 0.22x | 47.000 | 116420 | 17480 |
| tile-transfer-20 | 20 | plain | 5891.841 | 5820.128–6083.519 | 1.00x | 3533.000 | 1.00x | 189.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 15648.295 | 15135.470–16129.567 | 2.66x | 4856.000 | 1.37x | 230.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1553.914 | 1530.460–1612.473 | 1.00x | 3473.000 | 1.00x | 147.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 18832.405 | 18488.552–18979.650 | 12.12x | 4409.000 | 1.27x | 143.000 | 800 | 200 |
| localized-text-swap-50 | 10 | plain | 2760.840 | 2674.919–2802.058 | 1.00x | 3496.000 | 1.00x | 92.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 15643.259 | 15307.291–16558.690 | 5.67x | 4630.000 | 1.32x | 124.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 36.759 | 35.617–41.517 | 1.00x | 3168.000 | 1.00x | 82.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 2347.110 | 2207.840–2495.388 | 63.85x | 4827.000 | 1.52x | 115.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 290.984 | 265.576–302.916 | 1.00x | 2896.000 | 1.00x | 131.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 612.655 | 597.447–647.635 | 2.11x | 3181.000 | 1.10x | 207.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 522.046 | 508.290–659.673 | 1.00x | 2780.000 | 1.00x | 29.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2267.661 | 2223.679–2426.047 | 4.34x | 2978.000 | 1.07x | 125.000 | 80 | 0 |
| gamepad-grid-6x6 | 35 | plain | 49094.100 | 48902.141–49704.070 | 1.00x | 8082.000 | 1.00x | 229.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 77437.263 | 76426.615–78190.283 | 1.58x | 12083.000 | 1.50x | 3797.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 3893.938 | 3813.207–3962.615 | 1.00x | 4444.000 | 1.00x | 124.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 56959.495 | 55963.152–59480.085 | 14.63x | 18186.000 | 4.09x | 303.000 | 1851 | 304 |
| modal-on-modal | 20 | plain | 9277.559 | 9103.104–9506.166 | 1.00x | 3023.000 | 1.00x | 155.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 39106.650 | 38854.486–40751.711 | 4.22x | 3739.000 | 1.24x | 271.000 | 1010 | 193 |
| button-native-scale-50 | 6 | plain | 618.486 | 598.519–665.333 | 1.00x | 3968.000 | 1.00x | 119.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 626.320 | 590.123–648.592 | 1.01x | 4713.000 | 1.19x | 167.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 3.01x | 1.28x |

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
