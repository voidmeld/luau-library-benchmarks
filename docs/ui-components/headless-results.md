# UI components comparison

Harness revision: `82fbc165ef18a9a715588aca38c032e21e53b612`. Facet: `9dc3bdb6e1afd76dfd86a5427da140d41defc78a`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 20128.486 | 19770.314–22853.730 | 1.00x | 1889.000 | 1.00x | 83.000 | 1486 | 488 |
| main-menu-cold | 1 | facet | 20812.074 | 20505.560–21758.655 | 1.03x | 2007.000 | 1.06x | 145.000 | 1501 | 488 |
| hud-60-frames | 60 | plain | 1260.399 | 1222.260–1436.010 | 1.00x | 1873.000 | 1.00x | 83.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 2859.217 | 2777.319–2903.127 | 2.27x | 2025.000 | 1.08x | 86.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 19404.403 | 19296.192–19590.646 | 1.00x | 3133.000 | 1.00x | 145.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 68812.995 | 64166.390–81971.102 | 3.55x | 4329.000 | 1.38x | 261.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 394.017 | 377.925–400.736 | 1.00x | 14006.000 | 1.00x | 121.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1100.092 | 1081.661–1137.744 | 2.79x | 25337.000 | 1.81x | 166.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3892.333 | 3819.895–3950.020 | 1.00x | 3781.000 | 1.00x | 146.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 4948.354 | 4870.075–5123.131 | 1.27x | 5598.000 | 1.48x | 175.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 3033.351 | 2961.135–3207.218 | 1.00x | 2190.000 | 1.00x | 97.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 8087.498 | 8032.732–8230.416 | 2.67x | 2997.000 | 1.37x | 137.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 28694.202 | 28190.723–28787.056 | 1.00x | 3387.000 | 1.00x | 127.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 47339.186 | 47117.975–48245.550 | 1.65x | 3836.000 | 1.13x | 73.000 | 3550 | 250 |
| card-collection-60 | 1 | plain | 39856.591 | 39484.174–40197.518 | 1.00x | 4314.000 | 1.00x | 137.000 | 3655 | 1020 |
| card-collection-60 | 1 | facet | 114872.412 | 100403.100–123121.815 | 2.88x | 11407.000 | 2.64x | 129.000 | 5695 | 1560 |
| mixed-scroll-300 | 50 | plain | 382.448 | 365.204–944.688 | 1.00x | 6762.000 | 1.00x | 117.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 377.790 | 358.598–1121.858 | 0.99x | 16237.000 | 2.40x | 206.000 | 50 | 0 |
| settings-17-values | 17 | plain | 294.095 | 286.821–305.723 | 1.00x | 2461.000 | 1.00x | 134.000 | 25 | 0 |
| settings-17-values | 17 | facet | 888.100 | 857.022–921.660 | 3.02x | 3634.000 | 1.48x | 160.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1144.944 | 1127.497–1220.522 | 1.00x | 1783.000 | 1.00x | 60.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1899.148 | 1870.290–1972.949 | 1.66x | 1925.000 | 1.08x | 120.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 293.259 | 280.426–310.529 | 1.00x | 2320.000 | 1.00x | 103.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 286.011 | 280.382–294.417 | 0.98x | 2710.000 | 1.17x | 118.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1540.954 | 1500.321–1617.700 | 1.00x | 1946.000 | 1.00x | 136.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 7834.744 | 7788.259–7902.191 | 5.08x | 2497.000 | 1.28x | 267.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 1957.506 | 1888.457–2037.067 | 1.00x | 1935.000 | 1.00x | 123.000 | 106 | 29 |
| toast-stream-4 | 8 | facet | 7613.907 | 7491.425–7883.884 | 3.89x | 2044.000 | 1.06x | 109.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 640.946 | 622.821–655.937 | 1.00x | 2027.000 | 1.00x | 123.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1588.174 | 1558.765–1619.757 | 2.48x | 2926.000 | 1.44x | 194.000 | 80 | 8 |
| radial-15-cycles | 30 | plain | 41895.477 | 41177.307–42540.871 | 1.00x | 3735.000 | 1.00x | 152.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 75555.813 | 72972.928–77608.769 | 1.80x | 3265.000 | 0.87x | 333.000 | 2679 | 497 |
| navigation-5-6-cycles | 60 | plain | 20606.575 | 20275.627–20927.752 | 1.00x | 2239.000 | 1.00x | 174.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 44851.589 | 44243.471–45205.763 | 2.18x | 2141.000 | 0.96x | 170.000 | 2364 | 360 |
| leaderboard-100 | 3 | plain | 1226.775 | 1218.072–1326.785 | 1.00x | 7307.000 | 1.00x | 112.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 4623.895 | 4518.881–4911.769 | 3.77x | 20416.000 | 2.79x | 168.000 | 300 | 0 |
| theme-swap-200 | 2 | plain | 38.067 | 36.407–42.173 | 1.00x | 5735.000 | 1.00x | 4132.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 256.194 | 236.504–290.316 | 6.73x | 6783.000 | 1.18x | 282.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 980346.771 | 873024.008–1015290.443 | 1.00x | 153.000 | 1.00x | 145.000 | 80760 | 17620 |
| heavy-screen-20-cycles | 20 | facet | 1578702.901 | 1553739.003–1597930.265 | 1.61x | 170.000 | 1.11x | 178.000 | 116780 | 17600 |
| tile-transfer-20 | 20 | plain | 6352.410 | 6312.624–6759.481 | 1.00x | 2619.000 | 1.00x | 222.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 14908.253 | 14578.236–15649.376 | 2.35x | 3923.000 | 1.50x | 279.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1465.717 | 1427.368–1507.381 | 1.00x | 2546.000 | 1.00x | 99.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 18769.707 | 18460.415–19658.229 | 12.81x | 3512.000 | 1.38x | 139.000 | 800 | 200 |
| localized-text-swap-50 | 10 | plain | 2571.145 | 2544.666–2667.615 | 1.00x | 2599.000 | 1.00x | 101.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 18108.713 | 17418.574–18928.812 | 7.04x | 3703.000 | 1.42x | 132.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 36.436 | 34.794–38.257 | 1.00x | 2245.000 | 1.00x | 90.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 2116.967 | 2067.199–2189.743 | 58.10x | 3922.000 | 1.75x | 126.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 354.462 | 310.244–399.391 | 1.00x | 1947.000 | 1.00x | 132.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 753.492 | 688.503–811.631 | 2.13x | 2341.000 | 1.20x | 208.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 550.129 | 540.235–703.435 | 1.00x | 1835.000 | 1.00x | 93.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2567.251 | 2477.260–3273.508 | 4.67x | 2057.000 | 1.12x | 143.000 | 100 | 0 |
| gamepad-grid-6x6 | 35 | plain | 49742.350 | 49179.691–50592.431 | 1.00x | 7577.000 | 1.00x | 212.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 73382.104 | 72549.196–77225.614 | 1.48x | 11469.000 | 1.51x | 3913.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 3653.707 | 3567.406–3811.071 | 1.00x | 3569.000 | 1.00x | 116.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 57294.702 | 56057.529–58358.500 | 15.68x | 17081.000 | 4.79x | 320.000 | 1851 | 304 |
| modal-on-modal | 20 | plain | 8896.507 | 8646.021–9600.086 | 1.00x | 2098.000 | 1.00x | 182.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 38117.776 | 37648.820–39094.640 | 4.28x | 2815.000 | 1.34x | 244.000 | 946 | 185 |
| button-native-scale-50 | 6 | plain | 587.084 | 567.212–610.117 | 1.00x | 3049.000 | 1.00x | 104.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 583.334 | 564.261–643.051 | 0.99x | 3739.000 | 1.23x | 104.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 2.98x | 1.42x |

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
