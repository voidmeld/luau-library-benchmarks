# Headless results

Run date: **2026-11-05 (UTC)**. Harness commit: `36cfbf958769527d0b3782a4328ad30b019c1d11`. Workflow run: [Library comparison 42038539979](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/42038539979). Runner: `ubuntu-latest`. Mode: `like-for-like`. Pins: Facet `e707bb3` (runtime source identical to the merged batch), Compose `e5e07de`, Verify `cbf4821`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `36cfbf958769527d0b3782a4328ad30b019c1d11`. Facet: `e707bb3cfe904ed951bd3fe3c9eb4965b90484ff`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 17008.773 | 16460.844–17739.239 | 1.00x | 2812.000 | 1.00x | 301.000 | 1456 | 478 |
| main-menu-cold | 1 | facet | 17539.437 | 16931.526–18207.187 | 1.03x | 2877.000 | 1.02x | 323.000 | 1461 | 478 |
| hud-60-frames | 60 | plain | 1287.899 | 1221.790–1361.041 | 1.00x | 2789.000 | 1.00x | 267.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 2246.241 | 2221.733–2333.062 | 1.74x | 2886.000 | 1.03x | 308.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 22456.962 | 22182.036–22814.353 | 1.00x | 3983.000 | 1.00x | 504.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 61670.759 | 59988.022–65724.796 | 2.75x | 4942.000 | 1.24x | 629.000 | 6353 | 50 |
| inventory-500 | 40 | plain | 432.354 | 422.200–454.748 | 1.00x | 14009.000 | 1.00x | 1135.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1053.564 | 1037.699–1259.015 | 2.44x | 36794.000 | 2.63x | 4925.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 4259.550 | 4157.024–4367.333 | 1.00x | 4378.000 | 1.00x | 555.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 5331.923 | 5291.092–5533.789 | 1.25x | 6212.000 | 1.42x | 1118.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 2629.007 | 2556.066–2754.807 | 1.00x | 3030.000 | 1.00x | 302.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 8308.848 | 8134.985–8455.009 | 3.16x | 4292.000 | 1.42x | 529.000 | 1025 | 12 |
| chat-append-250 | 250 | plain | 20406.249 | 19915.616–20756.781 | 1.00x | 4416.000 | 1.00x | 934.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 54283.016 | 53325.036–68006.527 | 2.66x | 6650.000 | 1.51x | 1520.000 | 2750 | 500 |
| card-collection-60 | 1 | plain | 31621.720 | 31207.332–32495.002 | 1.00x | 5183.000 | 1.00x | 396.000 | 3625 | 1010 |
| card-collection-60 | 1 | facet | 74328.441 | 72921.211–75659.136 | 2.35x | 12104.000 | 2.34x | 1583.000 | 5305 | 1430 |
| mixed-scroll-300 | 50 | plain | 361.457 | 350.280–375.669 | 1.00x | 6964.000 | 1.00x | 651.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 359.124 | 352.223–384.252 | 0.99x | 15537.000 | 2.23x | 1648.000 | 50 | 0 |
| settings-17-values | 17 | plain | 269.919 | 253.093–288.907 | 1.00x | 3312.000 | 1.00x | 393.000 | 25 | 0 |
| settings-17-values | 17 | facet | 858.699 | 818.999–863.918 | 3.18x | 4725.000 | 1.43x | 711.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1207.829 | 1183.412–1227.007 | 1.00x | 2691.000 | 1.00x | 225.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1795.639 | 1763.250–1981.740 | 1.49x | 2821.000 | 1.05x | 281.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 326.254 | 309.939–339.744 | 1.00x | 3206.000 | 1.00x | 397.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 328.077 | 317.902–337.080 | 1.01x | 3597.000 | 1.12x | 552.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1623.698 | 1611.741–1650.990 | 1.00x | 2853.000 | 1.00x | 315.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 6131.193 | 6055.879–6181.760 | 3.78x | 3267.000 | 1.15x | 430.000 | 308 | 0 |
| toast-stream-4 | 8 | plain | 1592.889 | 1563.856–1640.441 | 1.00x | 2758.000 | 1.00x | 233.000 | 110 | 29 |
| toast-stream-4 | 8 | facet | 6597.812 | 6519.681–7384.892 | 4.14x | 3000.000 | 1.09x | 479.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 501.218 | 483.301–516.812 | 1.00x | 2917.000 | 1.00x | 318.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1335.451 | 1292.657–1503.115 | 2.66x | 3794.000 | 1.30x | 596.000 | 64 | 8 |
| radial-15-cycles | 30 | plain | 29757.671 | 29496.175–30245.448 | 1.00x | 4372.000 | 1.00x | 1088.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 60406.069 | 59820.093–61069.933 | 2.03x | 4338.000 | 0.99x | 1005.000 | 2672 | 495 |
| navigation-5-6-cycles | 60 | plain | 14055.529 | 13867.835–14310.885 | 1.00x | 3063.000 | 1.00x | 378.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 31124.549 | 30580.239–31476.151 | 2.21x | 3326.000 | 1.09x | 757.000 | 2142 | 330 |
| leaderboard-100 | 3 | plain | 1113.315 | 1084.672–1315.812 | 1.00x | 7686.000 | 1.00x | 1209.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 5115.102 | 5052.006–5468.156 | 4.59x | 29023.000 | 3.78x | 3428.000 | 310 | 0 |
| theme-swap-200 | 2 | plain | 39.290 | 36.705–46.210 | 1.00x | 6360.000 | 1.00x | 4993.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 104.198 | 100.823–118.489 | 2.65x | 7211.000 | 1.13x | 1457.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 854571.839 | 729490.420–886150.832 | 1.00x | 13104.000 | 1.00x | 13110.000 | 80160 | 17420 |
| heavy-screen-20-cycles | 20 | facet | 1230768.514 | 1194415.309–1337009.104 | 1.44x | 29137.000 | 2.22x | 29144.000 | 88180 | 17400 |
| tile-transfer-20 | 20 | plain | 5022.792 | 4994.209–5088.292 | 1.00x | 3483.000 | 1.00x | 510.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 14881.763 | 14532.915–16869.231 | 2.96x | 4749.000 | 1.36x | 799.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1641.544 | 1605.049–1856.309 | 1.00x | 3419.000 | 1.00x | 461.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 2810.604 | 2763.042–2859.779 | 1.71x | 4178.000 | 1.22x | 581.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 2930.595 | 2887.380–3173.422 | 1.00x | 3468.000 | 1.00x | 478.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 13593.494 | 13453.402–14113.280 | 4.64x | 4272.000 | 1.23x | 565.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 36.255 | 35.233–38.248 | 1.00x | 3123.000 | 1.00x | 357.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 555.651 | 536.432–582.552 | 15.33x | 4617.000 | 1.48x | 612.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 326.254 | 302.408–357.431 | 1.00x | 2845.000 | 1.00x | 294.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 566.788 | 526.607–656.574 | 1.74x | 3140.000 | 1.10x | 399.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 618.366 | 606.928–649.713 | 1.00x | 2728.000 | 1.00x | 240.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2177.756 | 2109.572–2284.758 | 3.52x | 2930.000 | 1.07x | 307.000 | 80 | 0 |
| gamepad-grid-6x6 | 35 | plain | 24.927 | 23.586–36.605 | 1.00x | 3003.000 | 1.00x | 305.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 459.846 | 440.025–474.257 | 18.45x | 4900.000 | 1.63x | 704.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 3895.486 | 3783.205–4024.631 | 1.00x | 4412.000 | 1.00x | 734.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 44806.528 | 44263.997–45151.761 | 11.50x | 15022.000 | 3.40x | 2549.000 | 1775 | 264 |
| modal-on-modal | 20 | plain | 7380.560 | 7279.968–7481.613 | 1.00x | 3022.000 | 1.00x | 495.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 33441.612 | 33209.221–33678.541 | 4.53x | 3898.000 | 1.29x | 854.000 | 1009 | 192 |
| button-native-scale-50 | 6 | plain | 674.921 | 655.702–697.836 | 1.00x | 3907.000 | 1.00x | 441.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 673.269 | 659.268–680.339 | 1.00x | 4524.000 | 1.16x | 693.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 2.71x | 1.43x |

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
