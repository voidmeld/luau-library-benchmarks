# UI components headless results

Run date: **2026-11-03 (UTC)**. Harness commit: `a07c78bb991fdec1695dcb0878c6767d65e85ffc`. Workflow run: [Library comparison 41692605212](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41692605212). Runner: `ubuntu-latest`. Pins: Facet `643da0c`, Compose `32dd747`, Verify `c3bf503`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `a07c78bb991fdec1695dcb0878c6767d65e85ffc`. Facet: `643da0c3c26994e60c177453959cd853361ef0e9`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 17958.611 | 17434.419–18371.193 | 1.00x | 2678.000 | 1.00x | 261.000 | 1432 | 470 |
| main-menu-cold | 1 | facet | 18356.605 | 18135.314–18930.709 | 1.02x | 2752.000 | 1.03x | 291.000 | 1437 | 470 |
| hud-60-frames | 60 | plain | 1121.649 | 1080.712–1130.896 | 1.00x | 2663.000 | 1.00x | 253.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 2412.644 | 2374.704–2533.610 | 2.15x | 2750.000 | 1.03x | 275.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 18447.865 | 17919.968–19101.579 | 1.00x | 3831.000 | 1.00x | 449.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 54540.103 | 53830.835–63568.129 | 2.96x | 4718.000 | 1.23x | 522.000 | 6972 | 50 |
| inventory-500 | 40 | plain | 274.795 | 236.282–293.810 | 1.00x | 13795.000 | 1.00x | 999.000 | 0 | 0 |
| inventory-500 | 40 | facet | 854.370 | 834.202–873.515 | 3.11x | 35950.000 | 2.61x | 4771.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3924.268 | 3788.162–4104.365 | 1.00x | 4284.000 | 1.00x | 556.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 5094.268 | 4955.307–5270.248 | 1.30x | 6075.000 | 1.42x | 1070.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 2588.850 | 2462.634–2622.754 | 1.00x | 2897.000 | 1.00x | 262.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 9010.992 | 8837.937–9344.997 | 3.48x | 4144.000 | 1.43x | 459.000 | 1047 | 18 |
| chat-append-250 | 250 | plain | 22720.810 | 21900.224–23265.941 | 1.00x | 4234.000 | 1.00x | 854.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 56224.925 | 55976.910–58212.307 | 2.47x | 6429.000 | 1.52x | 1474.000 | 2750 | 500 |
| card-collection-60 | 1 | plain | 34915.834 | 33989.579–36295.638 | 1.00x | 5025.000 | 1.00x | 324.000 | 3601 | 1002 |
| card-collection-60 | 1 | facet | 77491.152 | 77036.140–79518.719 | 2.22x | 11758.000 | 2.34x | 1470.000 | 5281 | 1422 |
| mixed-scroll-300 | 50 | plain | 334.045 | 304.781–356.065 | 1.00x | 6790.000 | 1.00x | 562.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 335.227 | 309.158–365.043 | 1.00x | 15597.000 | 2.30x | 1913.000 | 50 | 0 |
| settings-17-values | 17 | plain | 223.899 | 199.393–247.904 | 1.00x | 3203.000 | 1.00x | 401.000 | 25 | 0 |
| settings-17-values | 17 | facet | 757.097 | 705.821–824.283 | 3.38x | 4564.000 | 1.42x | 633.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1067.047 | 1046.840–1107.233 | 1.00x | 2557.000 | 1.00x | 194.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1728.486 | 1651.241–1769.173 | 1.62x | 2687.000 | 1.05x | 241.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 260.437 | 255.137–277.940 | 1.00x | 3056.000 | 1.00x | 351.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 273.311 | 263.864–289.752 | 1.05x | 3444.000 | 1.13x | 478.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1368.172 | 1342.164–1407.926 | 1.00x | 2727.000 | 1.00x | 292.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 6581.703 | 6537.591–6684.967 | 4.81x | 3145.000 | 1.15x | 415.000 | 308 | 0 |
| toast-stream-4 | 8 | plain | 1603.501 | 1567.464–1662.682 | 1.00x | 2678.000 | 1.00x | 263.000 | 106 | 29 |
| toast-stream-4 | 8 | facet | 6926.817 | 6676.026–7538.752 | 4.32x | 2841.000 | 1.06x | 430.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 463.959 | 424.735–487.584 | 1.00x | 2784.000 | 1.00x | 262.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1309.381 | 1235.674–1354.736 | 2.82x | 3638.000 | 1.31x | 547.000 | 64 | 8 |
| radial-15-cycles | 30 | plain | 29625.721 | 29446.737–31247.982 | 1.00x | 4150.000 | 1.00x | 952.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 61923.434 | 61149.265–62909.348 | 2.09x | 4175.000 | 1.01x | 932.000 | 2672 | 495 |
| navigation-5-6-cycles | 60 | plain | 14849.924 | 13961.170–15039.119 | 1.00x | 2921.000 | 1.00x | 338.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 31522.040 | 31146.446–32059.957 | 2.12x | 3166.000 | 1.08x | 685.000 | 2142 | 330 |
| leaderboard-100 | 3 | plain | 918.293 | 886.734–1016.677 | 1.00x | 7456.000 | 1.00x | 1065.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 4434.303 | 4342.021–4613.138 | 4.83x | 28220.000 | 3.78x | 3180.000 | 310 | 0 |
| theme-swap-200 | 2 | plain | 32.621 | 30.718–47.879 | 1.00x | 6050.000 | 1.00x | 4683.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 80.742 | 78.307–89.538 | 2.48x | 6964.000 | 1.15x | 1333.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 880483.142 | 772271.403–933803.125 | 1.00x | 9005.000 | 1.00x | 9013.000 | 79680 | 17260 |
| heavy-screen-20-cycles | 20 | facet | 1274930.563 | 1256250.539–1323325.304 | 1.45x | 29112.000 | 3.23x | 29120.000 | 87700 | 17240 |
| tile-transfer-20 | 20 | plain | 4990.890 | 4972.856–5900.316 | 1.00x | 3318.000 | 1.00x | 423.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 13976.751 | 13877.705–15035.657 | 2.80x | 4590.000 | 1.38x | 731.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1314.753 | 1289.857–1338.628 | 1.00x | 3272.000 | 1.00x | 400.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 2601.406 | 2578.763–2664.594 | 1.98x | 4000.000 | 1.22x | 509.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 2507.434 | 2461.067–2606.369 | 1.00x | 3311.000 | 1.00x | 414.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 13349.873 | 13191.166–13465.930 | 5.32x | 4089.000 | 1.23x | 502.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 29.025 | 28.143–29.696 | 1.00x | 2966.000 | 1.00x | 294.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 21153.209 | 21007.937–21356.497 | 728.79x | 4929.000 | 1.66x | 548.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 250.249 | 242.274–267.361 | 1.00x | 2712.000 | 1.00x | 255.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 548.287 | 530.985–1077.548 | 2.19x | 3019.000 | 1.11x | 373.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 452.607 | 434.884–467.274 | 1.00x | 2602.000 | 1.00x | 218.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2023.628 | 2002.738–2090.563 | 4.47x | 2805.000 | 1.08x | 282.000 | 80 | 0 |
| gamepad-grid-6x6 | 35 | plain | 20.749 | 20.268–21.801 | 1.00x | 2886.000 | 1.00x | 273.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 433.642 | 422.081–448.169 | 20.90x | 4713.000 | 1.63x | 639.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 3560.412 | 3517.893–3616.607 | 1.00x | 4189.000 | 1.00x | 597.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 32733.334 | 32083.376–33116.211 | 9.19x | 14863.000 | 3.55x | 2506.000 | 1775 | 264 |
| modal-on-modal | 20 | plain | 7506.845 | 7333.782–8059.210 | 1.00x | 2848.000 | 1.00x | 408.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 34262.033 | 33661.829–34480.371 | 4.56x | 3741.000 | 1.31x | 798.000 | 1009 | 192 |
| button-native-scale-50 | 6 | plain | 294.822 | 284.993–341.028 | 1.00x | 3757.000 | 1.00x | 377.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 288.680 | 273.933–314.379 | 0.98x | 4367.000 | 1.16x | 635.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 3.25x | 1.46x |

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
- `gamepad-grid-6x6`: Walk all 36 retained cells of a six by six grid in a snake path. Headless uses the public focus move API; Studio sends directional keys through the native input pipeline.
- `drag-reorder-100`: Drag the first of 100 retained rows after the fifth row, 20 times. Facet uses VirtualList reorderable and onReorder; plain uses a native UIDragDetector and insertion indicator.
- `modal-on-modal`: Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.
- `button-native-scale-50`: Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.
