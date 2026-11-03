# UI components headless results

Run date: **2026-11-03 (UTC)**. Harness commit: `4dcbd15e5612364e94a41dc6dbcb47c0d496d8b6`. Workflow run: [Library comparison 41585897438](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41585897438). Runner: `ubuntu-latest`. Pins: Facet `053b475`, Compose `32dd747`, Verify `363ce5b`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `4dcbd15e5612364e94a41dc6dbcb47c0d496d8b6`. Facet: `053b475d628f1a96abc5293247ecd46295688fb1`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 11130.854 | 10781.370–12553.017 | 1.00x | 2417.000 | 1.00x | 269.000 | 1432 | 470 |
| main-menu-cold | 1 | facet | 15300.327 | 12275.310–27054.836 | 1.37x | 2455.000 | 1.02x | 307.000 | 1437 | 470 |
| hud-60-frames | 60 | plain | 1061.201 | 1024.797–2202.402 | 1.00x | 2414.000 | 1.00x | 253.000 | 252 | 0 |
| hud-60-frames | 60 | facet | 2391.105 | 1520.660–8576.200 | 2.25x | 2483.000 | 1.03x | 273.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 22238.711 | 21588.696–28686.891 | 1.00x | 3450.000 | 1.00x | 434.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 50920.664 | 41943.952–84323.207 | 2.29x | 4194.000 | 1.22x | 586.000 | 6972 | 50 |
| inventory-500 | 40 | plain | 254.011 | 219.029–318.447 | 1.00x | 12764.000 | 1.00x | 1007.000 | 0 | 0 |
| inventory-500 | 40 | facet | 655.423 | 633.430–1746.289 | 2.58x | 33912.000 | 2.66x | 4924.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 2816.404 | 2641.441–4129.913 | 1.00x | 3730.000 | 1.00x | 547.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 3898.466 | 3572.968–5563.373 | 1.38x | 4990.000 | 1.34x | 1079.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 2443.233 | 2387.380–2547.679 | 1.00x | 2660.000 | 1.00x | 262.000 | 738 | 0 |
| virtual-scroll-2000 | 15 | facet | 6899.615 | 6631.593–12497.238 | 2.82x | 3725.000 | 1.40x | 475.000 | 1047 | 18 |
| chat-append-250 | 250 | plain | 18840.573 | 13562.639–23620.871 | 1.00x | 3506.000 | 1.00x | 854.000 | 2500 | 500 |
| chat-append-250 | 250 | facet | 40334.214 | 35425.383–72218.107 | 2.14x | 4964.000 | 1.42x | 1463.000 | 2750 | 500 |
| card-collection-60 | 1 | plain | 19885.249 | 19610.036–21594.662 | 1.00x | 4701.000 | 1.00x | 332.000 | 3601 | 1002 |
| card-collection-60 | 1 | facet | 55781.438 | 49978.255–90623.835 | 2.81x | 10274.000 | 2.19x | 1462.000 | 5281 | 1422 |
| mixed-scroll-300 | 50 | plain | 257.947 | 243.916–334.322 | 1.00x | 6220.000 | 1.00x | 554.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 261.112 | 252.229–573.480 | 1.01x | 13683.000 | 2.20x | 2033.000 | 50 | 0 |
| settings-17-values | 17 | plain | 154.041 | 145.668–173.981 | 1.00x | 2829.000 | 1.00x | 387.000 | 25 | 0 |
| settings-17-values | 17 | facet | 553.990 | 446.921–1759.528 | 3.60x | 3908.000 | 1.38x | 640.000 | 29 | 0 |
| text-input-200 | 200 | plain | 975.813 | 953.440–1218.867 | 1.00x | 2372.000 | 1.00x | 178.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1321.482 | 1276.193–3361.942 | 1.35x | 2438.000 | 1.03x | 257.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 194.092 | 189.073–203.775 | 1.00x | 2713.000 | 1.00x | 359.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 209.665 | 193.480–229.625 | 1.08x | 2952.000 | 1.09x | 492.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1320.771 | 1299.289–1333.840 | 1.00x | 2438.000 | 1.00x | 283.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 4565.697 | 3621.380–7832.846 | 3.46x | 2724.000 | 1.12x | 404.000 | 308 | 0 |
| toast-stream-4 | 8 | plain | 1357.376 | 1010.476–2744.145 | 1.00x | 2394.000 | 1.00x | 279.000 | 110 | 29 |
| toast-stream-4 | 8 | facet | 5032.397 | 4846.659–6089.592 | 3.71x | 2420.000 | 1.01x | 421.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 312.609 | 293.821–338.358 | 1.00x | 2497.000 | 1.00x | 262.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 860.590 | 811.547–1873.008 | 2.75x | 3107.000 | 1.24x | 528.000 | 64 | 8 |
| radial-15-cycles | 30 | plain | 18828.676 | 18438.492–26069.055 | 1.00x | 3190.000 | 1.00x | 0.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 43994.176 | 40870.312–76468.315 | 2.34x | 3212.000 | 1.01x | 948.000 | 2672 | 495 |
| navigation-5-6-cycles | 60 | plain | 11279.975 | 8622.941–21318.770 | 1.00x | 2592.000 | 1.00x | 370.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 21007.353 | 19398.210–25835.643 | 1.86x | 2468.000 | 0.95x | 691.000 | 2142 | 330 |
| leaderboard-100 | 3 | plain | 938.828 | 905.638–1211.476 | 1.00x | 6735.000 | 1.00x | 1144.000 | 310 | 0 |
| leaderboard-100 | 3 | facet | 3767.570 | 3619.028–4385.737 | 4.01x | 25591.000 | 3.80x | 3058.000 | 310 | 0 |
| theme-swap-200 | 2 | plain | 7.401 | 6.440–11.057 | 1.00x | 1367.000 | 1.00x | 4683.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 43.165 | 42.183–56.024 | 5.83x | 7280.000 | 5.33x | 1348.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 603350.343 | 520097.507–734221.235 | 1.00x | 0.000 | — | 3836.000 | 79680 | 17260 |
| heavy-screen-20-cycles | 20 | facet | 975280.277 | 822341.054–1007320.613 | 1.62x | 0.000 | — | 26053.000 | 87700 | 17240 |
| tile-transfer-20 | 20 | plain | 3217.155 | 2972.088–3297.106 | 1.00x | 2903.000 | 1.00x | 415.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 13992.276 | 10313.549–27132.074 | 4.35x | 3850.000 | 1.33x | 740.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 4428.762 | 4207.610–4657.575 | 1.00x | 2895.000 | 1.00x | 386.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 2137.886 | 2106.970–2209.113 | 0.48x | 3491.000 | 1.21x | 516.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 6392.537 | 6237.334–8062.341 | 1.00x | 2947.000 | 1.00x | 422.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 14229.701 | 9969.641–22550.829 | 2.23x | 3587.000 | 1.22x | 485.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 12.028 | 10.566–15.854 | plain ≈ 0 | 2672.000 | 1.00x | 302.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 21424.391 | 16604.412–30366.211 | plain ≈ 0 | 4380.000 | 1.64x | 538.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 202.143 | 167.962–311.857 | 1.00x | 2457.000 | 1.00x | 255.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 459.058 | 387.881–556.535 | 2.27x | 2637.000 | 1.07x | 366.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 360.701 | 324.216–427.291 | 1.00x | 2400.000 | 1.00x | 210.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 1407.030 | 1374.822–3225.347 | 3.90x | 2529.000 | 1.05x | 273.000 | 80 | 0 |
| gamepad-grid-6x6 | 35 | plain | 10.506 | 10.375–12.429 | plain ≈ 0 | 2613.000 | 1.00x | 273.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 263.064 | 254.522–286.480 | plain ≈ 0 | 4232.000 | 1.62x | 728.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 2565.658 | 2504.687–2658.558 | 1.00x | 3592.000 | 1.00x | 654.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 27687.667 | 24390.491–48285.669 | 10.79x | 12670.000 | 3.53x | 2608.000 | 1775 | 264 |
| modal-on-modal | 20 | plain | 5699.605 | 5092.445–7756.168 | 1.00x | 2440.000 | 1.00x | 424.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 31884.131 | 24956.336–40678.707 | 5.59x | 2943.000 | 1.21x | 798.000 | 1009 | 192 |
| button-native-scale-50 | 6 | plain | 186.119 | 169.875–218.167 | 1.00x | 3372.000 | 1.00x | 369.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 184.456 | 174.512–197.105 | 0.99x | 3739.000 | 1.11x | 634.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 2.37x | 1.45x |

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
