# UI components comparison

Harness revision: `9648ba3fb8f26bf5d80ac5440b74f625e6d24f57`. Facet: `0dd87be5b647e52ec8f9f186a2d970e1796c1355`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 24213.577 | 23725.997–24392.671 | 1.00x | 2846.000 | 1.00x | 147.000 | 1486 | 488 |
| main-menu-cold | 1 | facet | 25174.931 | 24916.889–25447.690 | 1.04x | 2931.000 | 1.03x | 155.000 | 1501 | 488 |
| hud-60-frames | 60 | plain | 1269.079 | 1242.930–1340.361 | 1.00x | 2783.000 | 1.00x | 51.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 2771.343 | 2685.542–2837.255 | 2.18x | 2981.000 | 1.07x | 142.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 22116.188 | 21981.928–22373.616 | 1.00x | 4064.000 | 1.00x | 185.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 63678.939 | 61214.871–70842.979 | 2.88x | 5222.000 | 1.28x | 228.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 388.365 | 373.077–407.601 | 1.00x | 14956.000 | 1.00x | 160.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1077.600 | 1031.124–1267.495 | 2.77x | 26287.000 | 1.76x | 190.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 4668.572 | 4593.222–4687.497 | 1.00x | 4691.000 | 1.00x | 162.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 5592.232 | 5501.563–5667.933 | 1.20x | 6476.000 | 1.38x | 128.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 3091.756 | 2984.566–3487.565 | 1.00x | 3083.000 | 1.00x | 64.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 8302.003 | 8209.351–8420.314 | 2.69x | 3932.000 | 1.28x | 129.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 28626.483 | 28374.239–28854.658 | 1.00x | 4296.000 | 1.00x | 95.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 51027.780 | 50591.927–51447.833 | 1.78x | 4785.000 | 1.11x | 84.000 | 3550 | 250 |
| card-collection-60 | 1 | plain | 43395.040 | 42503.857–45153.679 | 1.00x | 5255.000 | 1.00x | 90.000 | 3655 | 1020 |
| card-collection-60 | 1 | facet | 105880.164 | 104206.792–117431.938 | 2.44x | 12355.000 | 2.35x | 129.000 | 5695 | 1560 |
| mixed-scroll-300 | 50 | plain | 354.531 | 343.882–367.435 | 1.00x | 7655.000 | 1.00x | 100.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 371.774 | 350.273–441.524 | 1.05x | 17182.000 | 2.24x | 204.000 | 50 | 0 |
| settings-17-values | 17 | plain | 300.171 | 285.523–313.635 | 1.00x | 3418.000 | 1.00x | 173.000 | 25 | 0 |
| settings-17-values | 17 | facet | 857.420 | 817.075–915.809 | 2.86x | 4560.000 | 1.33x | 176.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1216.120 | 1199.569–1251.876 | 1.00x | 2669.000 | 1.00x | 5.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1908.822 | 1876.060–1934.540 | 1.57x | 2866.000 | 1.07x | 110.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 311.391 | 300.621–326.349 | 1.00x | 3222.000 | 1.00x | 63.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 308.797 | 300.921–322.111 | 0.99x | 3670.000 | 1.14x | 121.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1782.555 | 1725.488–1810.347 | 1.00x | 2856.000 | 1.00x | 104.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 8299.551 | 8235.722–10172.695 | 4.66x | 3445.000 | 1.21x | 282.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 1938.878 | 1909.482–1988.731 | 1.00x | 2872.000 | 1.00x | 92.000 | 110 | 29 |
| toast-stream-4 | 8 | facet | 7921.030 | 7859.746–8156.029 | 4.09x | 2993.000 | 1.04x | 173.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 666.354 | 644.713–694.295 | 1.00x | 2953.000 | 1.00x | 108.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1664.085 | 1632.216–1856.133 | 2.50x | 3875.000 | 1.31x | 224.000 | 80 | 8 |
| radial-15-cycles | 30 | plain | 41227.189 | 39680.183–42518.007 | 1.00x | 4636.000 | 1.00x | 135.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 72850.058 | 71579.648–74168.357 | 1.77x | 4175.000 | 0.90x | 257.000 | 2679 | 497 |
| navigation-5-6-cycles | 60 | plain | 20295.487 | 19774.886–20863.818 | 1.00x | 3157.000 | 1.00x | 118.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 42248.977 | 41871.543–45012.144 | 2.08x | 3107.000 | 0.98x | 178.000 | 2364 | 360 |
| leaderboard-100 | 3 | plain | 1344.649 | 1328.119–1371.139 | 1.00x | 8216.000 | 1.00x | 104.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 4307.710 | 4134.667–4513.925 | 3.20x | 21357.000 | 2.60x | 224.000 | 300 | 0 |
| theme-swap-200 | 2 | plain | 38.051 | 35.266–47.909 | 1.00x | 6355.000 | 1.00x | 4759.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 273.540 | 260.555–289.259 | 7.19x | 7137.000 | 1.12x | 258.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 1149021.698 | 1009756.441–1196623.673 | 1.00x | 151.000 | 1.00x | 167.000 | 80760 | 17620 |
| heavy-screen-20-cycles | 20 | facet | 1774662.171 | 1739495.762–1791629.007 | 1.54x | 42.000 | 0.28x | 32.000 | 116780 | 17600 |
| tile-transfer-20 | 20 | plain | 6546.063 | 5952.737–7945.294 | 1.00x | 3496.000 | 1.00x | 118.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 15841.577 | 15465.084–16117.041 | 2.42x | 4856.000 | 1.39x | 233.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1625.362 | 1603.702–1683.622 | 1.00x | 3487.000 | 1.00x | 148.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 19090.669 | 18968.842–19669.959 | 11.75x | 4453.000 | 1.28x | 155.000 | 800 | 200 |
| localized-text-swap-50 | 10 | plain | 2850.058 | 2800.776–3099.042 | 1.00x | 3522.000 | 1.00x | 120.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 15868.395 | 15499.838–16481.800 | 5.57x | 4637.000 | 1.32x | 135.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 35.606 | 33.112–37.790 | 1.00x | 3165.000 | 1.00x | 90.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 2415.286 | 2336.138–2533.997 | 67.83x | 4854.000 | 1.53x | 122.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 290.061 | 277.949–309.046 | 1.00x | 2896.000 | 1.00x | 139.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 605.079 | 590.702–673.356 | 2.09x | 3283.000 | 1.13x | 208.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 536.921 | 519.780–657.777 | 1.00x | 2769.000 | 1.00x | 69.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2389.929 | 2363.239–3072.302 | 4.45x | 2990.000 | 1.08x | 135.000 | 100 | 0 |
| gamepad-grid-6x6 | 35 | plain | 49827.962 | 49634.832–50357.620 | 1.00x | 8462.000 | 1.00x | 224.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 75039.698 | 74423.989–77358.444 | 1.51x | 12371.000 | 1.46x | 3887.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 4005.493 | 3871.864–4244.560 | 1.00x | 4502.000 | 1.00x | 117.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 56384.009 | 55573.322–56917.423 | 14.08x | 17942.000 | 3.99x | 286.000 | 1851 | 304 |
| modal-on-modal | 20 | plain | 9400.100 | 9294.753–9553.957 | 1.00x | 3030.000 | 1.00x | 170.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 38177.173 | 37956.412–39318.122 | 4.06x | 3772.000 | 1.24x | 267.000 | 946 | 185 |
| button-native-scale-50 | 6 | plain | 647.068 | 616.350–662.526 | 1.00x | 3975.000 | 1.00x | 136.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 639.944 | 606.161–670.481 | 0.99x | 4736.000 | 1.19x | 160.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 2.88x | 1.29x |

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
