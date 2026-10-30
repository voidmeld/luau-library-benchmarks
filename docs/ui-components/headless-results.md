# UI components headless results

Harness commit: `c77fc4151c8459e6f6e922913b9d71805b16c776`. Workflow run: [Library comparison 41107250479](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41107250479). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](method.md) before you compare the two lanes.

# UI components comparison

Harness revision: `c77fc4151c8459e6f6e922913b9d71805b16c776`. Facet: `265536b907f76f9fd8f4c7fdcb7a958c2c44a8f4`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 19109.995 | 13640.862–37197.433 | 1.00x | 2862.000 | 1.00x | 255.000 | 1426 | 468 |
| main-menu-cold | 1 | facet | 15458.154 | 14395.963–17765.789 | 0.81x | 2964.000 | 1.04x | 271.000 | 1431 | 468 |
| hud-120-frames | 120 | plain | 2312.434 | 2166.077–2801.509 | 1.00x | 2851.000 | 1.00x | 255.000 | 500 | 0 |
| hud-120-frames | 120 | facet | 6911.967 | 6307.426–8352.388 | 2.99x | 2937.000 | 1.03x | 249.000 | 500 | 0 |
| world-markers-50 | 100 | plain | 21706.521 | 21261.083–22327.349 | 1.00x | 4077.000 | 1.00x | 332.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 77071.198 | 61756.722–90439.774 | 3.55x | 4707.000 | 1.15x | 129.000 | 6378 | 0 |
| inventory-500 | 40 | plain | 268.775 | 213.001–347.279 | 1.00x | 14056.000 | 1.00x | 507.000 | 0 | 0 |
| inventory-500 | 40 | facet | 940.562 | 889.823–1348.369 | 3.50x | 48371.000 | 3.44x | 1459.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 2601.967 | 2361.618–2922.732 | 1.00x | 4454.000 | 1.00x | 342.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 3835.052 | 3501.359–4737.972 | 1.47x | 7355.000 | 1.65x | 438.000 | 934 | 14 |
| virtual-scroll-2000 | 50 | plain | 9186.435 | 7275.189–12321.647 | 1.00x | 3081.000 | 1.00x | 223.000 | 2366 | 0 |
| virtual-scroll-2000 | 50 | facet | 29727.962 | 27664.432–43035.669 | 3.24x | 4865.000 | 1.58x | 359.000 | 3251 | 27 |
| chat-append-500 | 500 | plain | 38353.923 | 36560.890–52057.436 | 1.00x | 4403.000 | 1.00x | 504.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 101383.482 | 94021.991–120856.101 | 2.64x | 6162.000 | 1.40x | 607.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 25540.250 | 24306.747–32587.748 | 1.00x | 5250.000 | 1.00x | 309.000 | 3595 | 1000 |
| card-collection-60 | 1 | facet | 86616.418 | 70894.507–103737.409 | 3.39x | 14082.000 | 2.68x | 556.000 | 5275 | 1420 |
| mixed-scroll-300 | 100 | plain | 603.675 | 555.466–944.380 | 1.00x | 7044.000 | 1.00x | 469.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 638.996 | 570.109–862.167 | 1.06x | 20020.000 | 2.84x | 677.000 | 100 | 0 |
| settings-17-values | 17 | plain | 209.908 | 206.246–242.148 | 1.00x | 3408.000 | 1.00x | 600.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1379.726 | 1208.111–2069.686 | 6.57x | 4956.000 | 1.45x | 427.000 | 35 | 0 |
| text-input-200 | 200 | plain | 908.272 | 826.062–956.232 | 1.00x | 2749.000 | 1.00x | 193.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1989.904 | 1481.362–2421.401 | 2.19x | 2849.000 | 1.04x | 217.000 | 220 | 0 |
| button-feedback-50 | 50 | plain | 672.483 | 660.591–740.716 | 1.00x | 3223.000 | 1.00x | 293.000 | 0 | 0 |
| button-feedback-50 | 50 | facet | 767.447 | 727.165–794.499 | 1.14x | 3855.000 | 1.20x | 329.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1403.454 | 1358.699–1565.806 | 1.00x | 2904.000 | 1.00x | 331.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 10660.298 | 9847.216–12160.006 | 7.60x | 3357.000 | 1.16x | 357.000 | 508 | 0 |
| toast-stream-20 | 40 | plain | 4500.684 | 4445.947–9287.590 | 1.00x | 3002.000 | 1.00x | 347.000 | 494 | 141 |
| toast-stream-20 | 40 | facet | 33993.926 | 31854.317–40627.881 | 7.55x | 2993.000 | 1.00x | 383.000 | 1620 | 360 |
| tabs-5-20-switches | 20 | plain | 509.207 | 489.089–533.297 | 1.00x | 2936.000 | 1.00x | 321.000 | 124 | 8 |
| tabs-5-20-switches | 20 | facet | 3005.238 | 2533.727–3514.655 | 5.90x | 3864.000 | 1.32x | 411.000 | 124 | 8 |
| radial-50-cycles | 100 | plain | 112038.690 | 107731.794–149212.149 | 1.00x | 3468.000 | 1.00x | 936.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 880416.755 | 828111.885–944727.981 | 7.86x | 4758.000 | 1.37x | 2058.000 | 21500 | 3700 |
| navigation-5-20-cycles | 200 | plain | 37252.468 | 34725.769–77970.304 | 1.00x | 3057.000 | 1.00x | 447.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 104692.725 | 98212.150–137136.895 | 2.81x | 3342.000 | 1.09x | 646.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 2705.642 | 2499.976–3990.644 | 1.00x | 8095.000 | 1.00x | 540.000 | 752 | 0 |
| leaderboard-100 | 6 | facet | 14896.908 | 13229.707–25106.185 | 5.51x | 38848.000 | 4.80x | 978.000 | 952 | 0 |
| theme-swap-200 | 5 | plain | 15.189 | 13.216–17.994 | 1.00x | 6494.000 | 1.00x | 4920.000 | 5 | 0 |
| theme-swap-200 | 5 | facet | 155.298 | 143.037–172.805 | 10.22x | 9982.000 | 1.54x | 966.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 739606.562 | 693529.661–825043.084 | 1.00x | 1844.000 | 1.00x | 1836.000 | 79560 | 17220 |
| heavy-screen-20-cycles | 20 | facet | 1348910.843 | 1326958.038–1389329.238 | 1.82x | 4261.000 | 2.31x | 4310.000 | 87580 | 17200 |
| tile-transfer-20 | 20 | plain | 3070.168 | 2994.535–3938.266 | 1.00x | 3466.000 | 1.00x | 555.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 18578.173 | 13747.694–29325.283 | 6.05x | 4906.000 | 1.42x | 402.000 | 829 | 84 |
| input-type-switch-20 | 20 | plain | 4705.497 | 4634.841–5591.947 | 1.00x | 3459.000 | 1.00x | 325.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 2203.267 | 2073.602–5227.104 | 0.47x | 4338.000 | 1.25x | 324.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 7808.025 | 6735.507–11362.206 | 1.00x | 3585.000 | 1.00x | 350.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 11816.534 | 11127.239–14437.148 | 1.51x | 4262.000 | 1.19x | 349.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 11.201 | 10.021–13.026 | plain ≈ 0 | 3144.000 | 1.00x | 293.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1552.964 | 1443.784–2237.686 | plain ≈ 0 | 4741.000 | 1.51x | 356.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 218.001 | 202.520–359.889 | 1.00x | 2903.000 | 1.00x | 257.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 452.451 | 441.902–592.313 | 2.08x | 3238.000 | 1.12x | 310.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 315.362 | 298.989–359.702 | 1.00x | 2818.000 | 1.00x | 251.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 5447.803 | 5174.924–8722.671 | 17.27x | 2973.000 | 1.06x | 241.000 | 280 | 0 |
| gamepad-grid-6x6 | 35 | plain | 11.287 | 10.494–11.988 | plain ≈ 0 | 3020.000 | 1.00x | 205.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 839.282 | 745.744–947.949 | plain ≈ 0 | 5951.000 | 1.97x | 450.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 2399.729 | 2292.441–3771.615 | 1.00x | 4402.000 | 1.00x | 353.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 234371.229 | 218240.476–291298.804 | 97.67x | 22640.000 | 5.14x | 907.000 | 2395 | 524 |
| modal-on-modal | 20 | plain | 6259.788 | 6103.771–6687.515 | 1.00x | 2882.000 | 1.00x | 340.000 | 650 | 121 |
| modal-on-modal | 20 | facet | 58937.299 | 48622.284–67067.442 | 9.42x | 3781.000 | 1.31x | 502.000 | 1129 | 192 |
| button-native-scale-50 | 20 | plain | 567.152 | 545.544–646.941 | 1.00x | 3945.000 | 1.00x | 335.000 | 0 | 0 |
| button-native-scale-50 | 20 | facet | 563.710 | 541.975–585.622 | 0.99x | 5047.000 | 1.28x | 391.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 3.54x | 1.55x |

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
