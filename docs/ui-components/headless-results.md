# UI components headless results

Harness commit: `7440d2e2378d498bc93ea7da2c9c2d5e70893be1`. Workflow run: [Library comparison 41054872733](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41054872733). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](method.md) before you compare the two lanes.

# UI components comparison

Harness revision: `7440d2e2378d498bc93ea7da2c9c2d5e70893be1`. Facet: `09512b286ee26ff9910b9a3115b3401fd0837fe1`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 18812.038 | 17937.518–21604.379 | 1.00x | 2756.000 | 1.00x | 260.000 | 1426 | 468 |
| main-menu-cold | 1 | facet | 17929.052 | 16766.466–35327.383 | 0.95x | 2853.000 | 1.04x | 263.000 | 1431 | 468 |
| hud-600-frames | 600 | plain | 13230.182 | 12351.775–16343.673 | 1.00x | 2729.000 | 1.00x | 223.000 | 2488 | 0 |
| hud-600-frames | 600 | facet | 34103.756 | 31290.594–48997.739 | 2.58x | 2805.000 | 1.03x | 238.000 | 2488 | 0 |
| world-markers-50 | 100 | plain | 28159.835 | 27219.292–31165.825 | 1.00x | 3940.000 | 1.00x | 329.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 88396.400 | 74673.294–108967.548 | 3.14x | 4816.000 | 1.22x | 373.000 | 6702 | 50 |
| inventory-500 | 40 | plain | 290.782 | 255.967–521.522 | 1.00x | 13429.000 | 1.00x | 499.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1100.381 | 1040.538–1347.190 | 3.78x | 47681.000 | 3.55x | 1444.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3606.520 | 3423.228–3905.066 | 1.00x | 4271.000 | 1.00x | 334.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 4828.447 | 4729.722–7178.254 | 1.34x | 7087.000 | 1.66x | 414.000 | 934 | 14 |
| virtual-scroll-2000 | 100 | plain | 18642.655 | 18283.776–22653.508 | 1.00x | 2941.000 | 1.00x | 215.000 | 4681 | 0 |
| virtual-scroll-2000 | 100 | facet | 71098.029 | 66501.345–80710.870 | 3.81x | 4832.000 | 1.64x | 337.000 | 6401 | 42 |
| chat-append-500 | 500 | plain | 44106.768 | 39679.083–52906.336 | 1.00x | 4065.000 | 1.00x | 299.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 127549.821 | 113064.823–135625.879 | 2.89x | 5983.000 | 1.47x | 530.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 28751.420 | 28232.854–58513.043 | 1.00x | 5019.000 | 1.00x | 325.000 | 3595 | 1000 |
| card-collection-60 | 1 | facet | 85609.771 | 79729.694–116318.097 | 2.98x | 13903.000 | 2.77x | 602.000 | 5275 | 1420 |
| mixed-scroll-300 | 100 | plain | 577.146 | 552.269–794.681 | 1.00x | 6713.000 | 1.00x | 460.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 579.770 | 534.195–1396.352 | 1.00x | 19419.000 | 2.89x | 271.000 | 100 | 0 |
| settings-17-values | 17 | plain | 197.729 | 184.184–251.359 | 1.00x | 3284.000 | 1.00x | 590.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1350.469 | 1150.956–1687.546 | 6.83x | 4784.000 | 1.46x | 395.000 | 35 | 0 |
| text-input-200 | 200 | plain | 1132.868 | 1115.536–1195.668 | 1.00x | 2630.000 | 1.00x | 186.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2412.371 | 2037.971–2629.587 | 2.13x | 2764.000 | 1.05x | 232.000 | 220 | 0 |
| button-feedback-50 | 50 | plain | 841.377 | 821.030–903.003 | 1.00x | 3114.000 | 1.00x | 302.000 | 0 | 0 |
| button-feedback-50 | 50 | facet | 823.003 | 807.755–878.918 | 0.98x | 3710.000 | 1.19x | 317.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1725.095 | 1704.146–1790.797 | 1.00x | 2799.000 | 1.00x | 321.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 12593.269 | 11685.326–13264.850 | 7.30x | 3211.000 | 1.15x | 322.000 | 508 | 0 |
| toast-stream-20 | 40 | plain | 5351.125 | 4989.891–6486.972 | 1.00x | 2877.000 | 1.00x | 323.000 | 508 | 141 |
| toast-stream-20 | 40 | facet | 36186.494 | 33385.503–54656.493 | 6.76x | 2887.000 | 1.00x | 373.000 | 1620 | 360 |
| tabs-5-20-switches | 20 | plain | 523.135 | 476.498–1178.055 | 1.00x | 2858.000 | 1.00x | 349.000 | 124 | 8 |
| tabs-5-20-switches | 20 | facet | 3455.249 | 3003.748–3560.375 | 6.60x | 3733.000 | 1.31x | 393.000 | 124 | 8 |
| radial-50-cycles | 100 | plain | 82785.141 | 80937.227–138844.216 | 1.00x | 3346.000 | 1.00x | 909.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 520286.107 | 516101.268–548685.373 | 6.28x | 3114.000 | 0.93x | 500.000 | 21500 | 3700 |
| navigation-5-20-cycles | 200 | plain | 43470.581 | 42046.500–53210.494 | 1.00x | 2952.000 | 1.00x | 471.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 113441.778 | 109319.083–164641.590 | 2.61x | 3212.000 | 1.09x | 607.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 2831.883 | 2757.506–2976.010 | 1.00x | 7743.000 | 1.00x | 540.000 | 752 | 0 |
| leaderboard-100 | 6 | facet | 14949.656 | 13487.324–25049.545 | 5.28x | 37775.000 | 4.88x | 1390.000 | 952 | 0 |
| theme-swap-200 | 10 | plain | 25.508 | 23.173–30.787 | 1.00x | 6401.000 | 1.00x | 4923.000 | 10 | 0 |
| theme-swap-200 | 10 | facet | 233.945 | 217.074–258.080 | 9.17x | 9778.000 | 1.53x | 745.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 828204.943 | 757506.099–894761.332 | 1.00x | 7047.000 | 1.00x | 7047.000 | 79560 | 17220 |
| heavy-screen-20-cycles | 20 | facet | 1509700.910 | 1468236.897–1534235.611 | 1.82x | 5006.000 | 0.71x | 5006.000 | 87580 | 17200 |
| tile-transfer-20 | 20 | plain | 4680.182 | 3559.446–8009.560 | 1.00x | 3370.000 | 1.00x | 568.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 19010.466 | 17587.703–41349.325 | 4.06x | 4795.000 | 1.42x | 424.000 | 829 | 84 |
| input-type-switch-20 | 20 | plain | 6476.087 | 6138.089–6878.195 | 1.00x | 3345.000 | 1.00x | 331.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 3308.530 | 2594.252–5220.013 | 0.51x | 4236.000 | 1.27x | 350.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 8107.158 | 7669.585–11398.155 | 1.00x | 3432.000 | 1.00x | 336.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 13026.391 | 12566.196–15505.329 | 1.61x | 4152.000 | 1.21x | 325.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 11.591 | 11.291–12.032 | plain ≈ 0 | 3061.000 | 1.00x | 303.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1910.632 | 1807.771–2564.699 | plain ≈ 0 | 4578.000 | 1.50x | 242.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 234.546 | 221.241–489.851 | 1.00x | 2795.000 | 1.00x | 272.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 547.578 | 536.968–568.939 | 2.33x | 3112.000 | 1.11x | 291.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 375.959 | 361.442–394.794 | 1.00x | 2690.000 | 1.00x | 235.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 6728.021 | 6499.314–10296.642 | 17.90x | 2878.000 | 1.07x | 228.000 | 280 | 0 |
| gamepad-grid-6x6 | 35 | plain | 13.154 | 12.914–14.476 | plain ≈ 0 | 2949.000 | 1.00x | 245.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 1332.910 | 1297.623–1384.325 | plain ≈ 0 | 5784.000 | 1.96x | 416.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 3143.561 | 3013.619–3314.769 | 1.00x | 4270.000 | 1.00x | 386.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 278031.687 | 262606.215–321681.174 | 88.44x | 22135.000 | 5.18x | 810.000 | 2395 | 524 |
| modal-on-modal | 20 | plain | 7900.011 | 7605.854–8354.247 | 1.00x | 2865.000 | 1.00x | 402.000 | 650 | 121 |
| modal-on-modal | 20 | facet | 55968.305 | 54931.776–56964.077 | 7.08x | 3709.000 | 1.29x | 469.000 | 1129 | 192 |
| button-native-scale-50 | 20 | plain | 623.961 | 612.932–640.642 | 1.00x | 3811.000 | 1.00x | 358.000 | 0 | 0 |
| button-native-scale-50 | 20 | facet | 628.339 | 618.020–654.609 | 1.01x | 4876.000 | 1.28x | 360.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 3.40x | 1.49x |

## Workloads

- `main-menu-cold`: Mount a background, title, six actions and footer; runtime and control-factory setup is excluded.
- `hud-600-frames`: Update health fill, ammo, currency and timer once per simulated frame.
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
