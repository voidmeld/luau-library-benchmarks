# UI components headless results

Run date: **2026-11-04 (UTC)**. Harness commit: `83e7221c07f1277ce2dc90e70798d3e8b6f0b16d`. Workflow run: [Library comparison 41766605741](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41766605741). Runner: `ubuntu-latest`. Pins: Facet `517628c`, Compose `198c954`, Verify `c6e7d05`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `83e7221c07f1277ce2dc90e70798d3e8b6f0b16d`. Facet: `517628c72ef3187ee2eb8485a7f9387482331eaf`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 11421.260 | 10975.841–11781.682 | 1.00x | 2719.000 | 1.00x | 293.000 | 1432 | 470 |
| main-menu-cold | 1 | facet | 11982.365 | 11572.307–12328.325 | 1.05x | 2793.000 | 1.03x | 337.000 | 1437 | 470 |
| hud-60-frames | 60 | plain | 917.420 | 830.579–1370.081 | 1.00x | 2664.000 | 1.00x | 252.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 1668.720 | 1623.642–1708.149 | 1.82x | 2792.000 | 1.05x | 299.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 12503.838 | 11910.686–13376.461 | 1.00x | 3770.000 | 1.00x | 378.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 39280.686 | 37593.709–49063.521 | 3.14x | 4853.000 | 1.29x | 652.000 | 6972 | 50 |
| inventory-500 | 40 | plain | 319.450 | 284.478–345.991 | 1.00x | 13908.000 | 1.00x | 1127.000 | 0 | 0 |
| inventory-500 | 40 | facet | 822.728 | 769.818–962.518 | 2.58x | 36255.000 | 2.61x | 4908.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 2308.382 | 2249.683–2350.696 | 1.00x | 4341.000 | 1.00x | 611.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 3073.091 | 2913.722–3167.314 | 1.33x | 6142.000 | 1.41x | 1132.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 1719.496 | 1642.450–1836.121 | 1.00x | 2938.000 | 1.00x | 294.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 6344.551 | 6263.489–10005.736 | 3.69x | 4213.000 | 1.43x | 533.000 | 1047 | 18 |
| chat-append-250 | 250 | plain | 15273.501 | 14999.429–15795.225 | 1.00x | 4315.000 | 1.00x | 926.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 36654.898 | 36157.340–37842.846 | 2.40x | 6522.000 | 1.51x | 1537.000 | 2750 | 500 |
| card-collection-60 | 1 | plain | 22738.838 | 21898.584–23542.056 | 1.00x | 5091.000 | 1.00x | 396.000 | 3601 | 1002 |
| card-collection-60 | 1 | facet | 53493.425 | 52442.184–55021.684 | 2.35x | 11906.000 | 2.34x | 1581.000 | 5281 | 1422 |
| mixed-scroll-300 | 50 | plain | 247.392 | 232.339–270.837 | 1.00x | 6871.000 | 1.00x | 634.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 248.964 | 233.522–291.468 | 1.01x | 15381.000 | 2.24x | 1657.000 | 50 | 0 |
| settings-17-values | 17 | plain | 212.469 | 185.669–243.246 | 1.00x | 3260.000 | 1.00x | 457.000 | 25 | 0 |
| settings-17-values | 17 | facet | 659.652 | 612.812–984.151 | 3.10x | 4619.000 | 1.42x | 697.000 | 29 | 0 |
| text-input-200 | 200 | plain | 676.958 | 654.925–700.804 | 1.00x | 2590.000 | 1.00x | 225.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1058.763 | 1042.448–1138.142 | 1.56x | 2728.000 | 1.05x | 281.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 182.895 | 176.416–196.736 | 1.00x | 3113.000 | 1.00x | 405.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 185.409 | 181.984–203.316 | 1.01x | 3503.000 | 1.13x | 550.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 978.441 | 952.903–1308.658 | 1.00x | 2752.000 | 1.00x | 315.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 5099.291 | 4888.604–5183.237 | 5.21x | 3148.000 | 1.14x | 423.000 | 308 | 0 |
| toast-stream-4 | 8 | plain | 1161.968 | 1114.516–1919.839 | 1.00x | 2712.000 | 1.00x | 303.000 | 106 | 29 |
| toast-stream-4 | 8 | facet | 4955.796 | 4853.342–6257.194 | 4.27x | 2907.000 | 1.07x | 479.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 349.065 | 334.663–360.182 | 1.00x | 2792.000 | 1.00x | 285.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1008.657 | 984.060–1098.783 | 2.89x | 3711.000 | 1.33x | 599.000 | 64 | 8 |
| radial-15-cycles | 30 | plain | 22321.828 | 21898.972–22465.394 | 1.00x | 4279.000 | 1.00x | 1088.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 44421.092 | 43273.536–45499.164 | 1.99x | 4224.000 | 0.99x | 1002.000 | 2672 | 495 |
| navigation-5-6-cycles | 60 | plain | 10219.372 | 10038.100–10770.651 | 1.00x | 2994.000 | 1.00x | 394.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 22362.388 | 22006.233–22993.117 | 2.19x | 3224.000 | 1.08x | 757.000 | 2142 | 330 |
| leaderboard-100 | 3 | plain | 781.926 | 695.477–854.745 | 1.00x | 7658.000 | 1.00x | 1281.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 4101.180 | 3787.117–4722.804 | 5.24x | 28564.000 | 3.73x | 3436.000 | 310 | 0 |
| theme-swap-200 | 2 | plain | 33.590 | 26.220–34.622 | 1.00x | 6181.000 | 1.00x | 4814.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 83.856 | 80.180–95.153 | 2.50x | 7097.000 | 1.15x | 1462.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 624388.440 | 526209.443–679290.440 | 1.00x | 8998.000 | 1.00x | 9006.000 | 79680 | 17260 |
| heavy-screen-20-cycles | 20 | facet | 950802.948 | 888610.058–1012532.441 | 1.52x | 27095.000 | 3.01x | 27094.000 | 87700 | 17240 |
| tile-transfer-20 | 20 | plain | 3634.868 | 3587.057–3684.042 | 1.00x | 3383.000 | 1.00x | 494.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 10495.339 | 10188.637–10896.953 | 2.89x | 4663.000 | 1.38x | 804.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 1015.408 | 987.215–1054.497 | 1.00x | 3326.000 | 1.00x | 453.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 1871.705 | 1817.374–1913.048 | 1.84x | 4079.000 | 1.23x | 572.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 1957.835 | 1886.088–1985.748 | 1.00x | 3366.000 | 1.00x | 484.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 10289.710 | 10108.778–10899.868 | 5.26x | 4167.000 | 1.24x | 558.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 31.848 | 29.524–34.041 | 1.00x | 3031.000 | 1.00x | 358.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 423.227 | 395.485–496.978 | 13.29x | 4508.000 | 1.49x | 612.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 251.018 | 229.745–306.411 | 1.00x | 2753.000 | 1.00x | 303.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 441.425 | 422.625–495.325 | 1.76x | 3045.000 | 1.11x | 399.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 374.744 | 340.012–1181.337 | 1.00x | 2635.000 | 1.00x | 250.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 1558.625 | 1484.303–1612.546 | 4.16x | 2837.000 | 1.08x | 307.000 | 80 | 0 |
| gamepad-grid-6x6 | 35 | plain | 19.339 | 18.388–34.312 | 1.00x | 2927.000 | 1.00x | 305.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 340.272 | 329.345–347.543 | 17.60x | 4779.000 | 1.63x | 711.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 2392.598 | 2328.011–2457.856 | 1.00x | 4319.000 | 1.00x | 718.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 30811.618 | 30565.949–33073.670 | 12.88x | 14998.000 | 3.47x | 2633.000 | 1775 | 264 |
| modal-on-modal | 20 | plain | 5455.366 | 5341.004–5774.305 | 1.00x | 2938.000 | 1.00x | 488.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 25111.220 | 24366.039–25940.577 | 4.60x | 3800.000 | 1.29x | 854.000 | 1009 | 192 |
| button-native-scale-50 | 6 | plain | 474.534 | 460.634–505.821 | 1.00x | 3758.000 | 1.00x | 376.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 466.381 | 449.016–485.862 | 0.98x | 4432.000 | 1.18x | 698.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 2.82x | 1.45x |

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
