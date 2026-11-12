# UI components comparison

Harness revision: `df1056eefe8fe0de66eecef79f695bbcc3c0594d`. Facet: `6a6cbbf8f32e1036fc03da477c84b2149640f369`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 23428.824 | 22726.491–24070.041 | 1.00x | 2839.000 | 1.00x | 115.000 | 1486 | 488 |
| main-menu-cold | 1 | facet | 23619.366 | 23161.651–24893.275 | 1.01x | 2951.000 | 1.04x | 170.000 | 1501 | 488 |
| hud-60-frames | 60 | plain | 1257.979 | 1221.113–1287.113 | 1.00x | 2799.000 | 1.00x | 68.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 2564.706 | 2505.994–5460.820 | 2.04x | 2956.000 | 1.06x | 94.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 20212.412 | 19918.444–20469.648 | 1.00x | 4050.000 | 1.00x | 131.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 62305.826 | 60790.499–71850.531 | 3.08x | 5208.000 | 1.29x | 179.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 408.335 | 384.386–428.642 | 1.00x | 14900.000 | 1.00x | 89.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1036.799 | 1017.609–1084.659 | 2.54x | 26013.000 | 1.75x | 158.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3805.457 | 3674.724–3930.349 | 1.00x | 4714.000 | 1.00x | 137.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 4900.998 | 4818.470–5029.576 | 1.29x | 6518.000 | 1.38x | 159.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 2833.352 | 2710.910–3653.794 | 1.00x | 3131.000 | 1.00x | 96.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 7591.490 | 7531.712–7694.230 | 2.68x | 3931.000 | 1.26x | 136.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 28357.945 | 28118.363–29173.229 | 1.00x | 4320.000 | 1.00x | 79.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 48502.428 | 48012.915–49173.955 | 1.71x | 4749.000 | 1.10x | 124.000 | 3550 | 250 |
| card-collection-60 | 1 | plain | 42680.886 | 42353.363–43989.808 | 1.00x | 5263.000 | 1.00x | 105.000 | 3655 | 1020 |
| card-collection-60 | 1 | facet | 121075.800 | 105742.715–127308.778 | 2.84x | 12324.000 | 2.34x | 129.000 | 5695 | 1560 |
| mixed-scroll-300 | 50 | plain | 392.331 | 381.906–984.279 | 1.00x | 7719.000 | 1.00x | 109.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 381.532 | 372.602–394.782 | 0.97x | 17085.000 | 2.21x | 186.000 | 50 | 0 |
| settings-17-values | 17 | plain | 284.488 | 273.579–299.881 | 1.00x | 3386.000 | 1.00x | 94.000 | 25 | 0 |
| settings-17-values | 17 | facet | 815.969 | 777.169–859.770 | 2.87x | 4553.000 | 1.34x | 209.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1136.517 | 1119.451–1175.119 | 1.00x | 2677.000 | 1.00x | 21.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1773.069 | 1746.596–1847.147 | 1.56x | 2874.000 | 1.07x | 80.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 285.019 | 274.055–298.206 | 1.00x | 3246.000 | 1.00x | 61.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 289.220 | 282.205–306.668 | 1.01x | 3656.000 | 1.13x | 103.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1552.147 | 1527.043–1576.424 | 1.00x | 2880.000 | 1.00x | 120.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 7565.730 | 7479.963–7683.787 | 4.87x | 3439.000 | 1.19x | 250.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 1896.036 | 1880.525–1915.530 | 1.00x | 2888.000 | 1.00x | 108.000 | 108 | 29 |
| toast-stream-4 | 8 | facet | 7572.152 | 7404.878–7644.949 | 3.99x | 2993.000 | 1.04x | 149.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 640.304 | 609.967–664.266 | 1.00x | 2979.000 | 1.00x | 118.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1540.377 | 1511.408–1611.488 | 2.41x | 3886.000 | 1.30x | 202.000 | 80 | 8 |
| radial-15-cycles | 30 | plain | 41772.073 | 41591.543–42263.146 | 1.00x | 4620.000 | 1.00x | 127.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 77115.823 | 76530.447–79330.619 | 1.85x | 4224.000 | 0.91x | 283.000 | 2678 | 497 |
| navigation-5-6-cycles | 60 | plain | 20016.679 | 19881.325–20398.741 | 1.00x | 3173.000 | 1.00x | 119.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 44860.020 | 44565.403–46792.226 | 2.24x | 3076.000 | 0.97x | 209.000 | 2364 | 360 |
| leaderboard-100 | 3 | plain | 1213.190 | 1181.737–1236.924 | 1.00x | 8209.000 | 1.00x | 112.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 4292.605 | 4006.107–4447.995 | 3.54x | 21252.000 | 2.59x | 193.000 | 300 | 0 |
| theme-swap-200 | 2 | plain | 38.844 | 36.364–43.474 | 1.00x | 6435.000 | 1.00x | 4847.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 292.646 | 277.994–303.971 | 7.53x | 7114.000 | 1.11x | 273.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 1073339.124 | 925284.767–1091177.718 | 1.00x | 0.000 | 1.00x | 0.000 | 80760 | 17620 |
| heavy-screen-20-cycles | 20 | facet | 1637869.871 | 1633411.400–1655319.417 | 1.53x | 81.000 | 81.00x | 47.000 | 116780 | 17600 |
| tile-transfer-20 | 20 | plain | 6434.736 | 6393.641–6594.474 | 1.00x | 3488.000 | 1.00x | 150.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 14616.630 | 14378.509–15581.316 | 2.27x | 4857.000 | 1.39x | 249.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1561.896 | 1550.192–1587.772 | 1.00x | 3496.000 | 1.00x | 107.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 19630.263 | 17991.358–22763.245 | 12.57x | 4443.000 | 1.27x | 171.000 | 800 | 200 |
| localized-text-swap-50 | 10 | plain | 2780.958 | 2733.969–2825.096 | 1.00x | 3525.000 | 1.00x | 119.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 16151.486 | 15690.446–16757.767 | 5.81x | 4618.000 | 1.31x | 92.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 34.900 | 33.388–37.697 | 1.00x | 3181.000 | 1.00x | 130.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 2143.544 | 2059.038–2253.402 | 61.42x | 4840.000 | 1.52x | 123.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 312.907 | 287.625–328.719 | 1.00x | 2832.000 | 1.00x | 68.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 621.001 | 596.310–640.058 | 1.98x | 3270.000 | 1.15x | 199.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 504.007 | 488.065–658.807 | 1.00x | 2737.000 | 1.00x | 53.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2335.371 | 2286.898–2357.011 | 4.63x | 2989.000 | 1.09x | 127.000 | 100 | 0 |
| gamepad-grid-6x6 | 35 | plain | 48517.153 | 48069.033–49841.340 | 1.00x | 8487.000 | 1.00x | 173.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 77463.218 | 77060.849–78259.148 | 1.60x | 12392.000 | 1.46x | 3880.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 3497.806 | 3462.447–3607.598 | 1.00x | 4502.000 | 1.00x | 118.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 56653.930 | 55334.614–70243.268 | 16.20x | 17945.000 | 3.99x | 319.000 | 1851 | 304 |
| modal-on-modal | 20 | plain | 8501.956 | 8359.063–9505.952 | 1.00x | 3023.000 | 1.00x | 133.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 38614.789 | 38238.270–39724.480 | 4.54x | 3773.000 | 1.25x | 242.000 | 946 | 185 |
| button-native-scale-50 | 6 | plain | 586.499 | 571.097–615.236 | 1.00x | 3982.000 | 1.00x | 112.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 570.629 | 557.447–604.280 | 0.97x | 4646.000 | 1.17x | 87.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 2.93x | 1.55x |

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
