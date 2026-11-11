# Headless results

Run date: **2026-11-11 (UTC)**. Harness commit: `e058f999c6e9d59126e3f46c60ba399956a30a6b`. Workflow run: [Library comparison 42962962167](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/42962962167). Runner: `ubuntu-latest`. Mode: `like-for-like`. Pins: Facet `237ca75`, Compose `3eb071a`, Verify `2528d1e`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `e058f999c6e9d59126e3f46c60ba399956a30a6b`. Facet: `237ca75fe1befc8fc102d14a47b847c3a8915686`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 15491.451 | 15157.700–16303.417 | 1.00x | 2830.000 | 1.00x | 131.000 | 1471 | 483 |
| main-menu-cold | 1 | facet | 16816.506 | 15830.639–17428.072 | 1.09x | 2908.000 | 1.03x | 137.000 | 1486 | 483 |
| hud-60-frames | 60 | plain | 879.771 | 843.306–909.636 | 1.00x | 2814.000 | 1.00x | 122.000 | 240 | 0 |
| hud-60-frames | 60 | facet | 1688.694 | 1664.426–1739.203 | 1.92x | 2929.000 | 1.04x | 123.000 | 252 | 0 |
| world-markers-50 | 100 | plain | 12506.103 | 12233.312–13018.157 | 1.00x | 3961.000 | 1.00x | 82.000 | 5000 | 0 |
| world-markers-50 | 100 | facet | 43889.185 | 39260.420–66426.477 | 3.51x | 5167.000 | 1.30x | 204.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 317.128 | 310.789–338.070 | 1.00x | 14830.000 | 1.00x | 136.000 | 0 | 0 |
| inventory-500 | 40 | facet | 831.224 | 792.576–895.942 | 2.62x | 26403.000 | 1.78x | 197.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 2576.353 | 2494.881–2630.165 | 1.00x | 4648.000 | 1.00x | 136.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 3396.080 | 3276.298–3488.769 | 1.32x | 6405.000 | 1.38x | 174.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 2001.860 | 1880.367–2210.876 | 1.00x | 3054.000 | 1.00x | 96.000 | 690 | 0 |
| virtual-scroll-2000 | 15 | facet | 5725.990 | 5419.799–6263.801 | 2.86x | 3975.000 | 1.30x | 138.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 19758.254 | 19040.551–23157.313 | 1.00x | 4238.000 | 1.00x | 118.000 | 2250 | 500 |
| chat-append-250 | 250 | facet | 32672.691 | 31906.780–39974.985 | 1.65x | 4698.000 | 1.11x | 113.000 | 3550 | 250 |
| card-collection-60 | 1 | plain | 28102.450 | 28018.543–28738.470 | 1.00x | 5232.000 | 1.00x | 128.000 | 3640 | 1015 |
| card-collection-60 | 1 | facet | 71430.087 | 69679.135–77790.065 | 2.54x | 12213.000 | 2.33x | 176.000 | 5680 | 1555 |
| mixed-scroll-300 | 50 | plain | 281.344 | 263.087–296.778 | 1.00x | 7662.000 | 1.00x | 139.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 264.319 | 248.285–379.583 | 0.94x | 16905.000 | 2.21x | 213.000 | 50 | 0 |
| settings-17-values | 17 | plain | 223.517 | 216.166–232.701 | 1.00x | 3384.000 | 1.00x | 148.000 | 25 | 0 |
| settings-17-values | 17 | facet | 693.476 | 670.211–879.557 | 3.10x | 4499.000 | 1.33x | 213.000 | 29 | 0 |
| text-input-200 | 200 | plain | 737.654 | 715.140–783.683 | 1.00x | 2701.000 | 1.00x | 44.000 | 220 | 0 |
| text-input-200 | 200 | facet | 1129.896 | 1104.898–1157.808 | 1.53x | 2841.000 | 1.05x | 103.000 | 220 | 0 |
| button-feedback-50 | 15 | plain | 218.660 | 213.232–226.592 | 1.00x | 3230.000 | 1.00x | 95.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 227.143 | 214.073–233.322 | 1.04x | 3608.000 | 1.12x | 119.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1009.513 | 983.915–1050.716 | 1.00x | 2871.000 | 1.00x | 159.000 | 400 | 0 |
| stepper-segments-100 | 100 | facet | 4947.507 | 4862.098–5111.815 | 4.90x | 3416.000 | 1.19x | 273.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 1392.240 | 1370.477–1421.235 | 1.00x | 2825.000 | 1.00x | 131.000 | 110 | 29 |
| toast-stream-4 | 8 | facet | 5852.740 | 5648.302–6243.971 | 4.20x | 2962.000 | 1.05x | 164.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 451.942 | 437.370–488.257 | 1.00x | 2937.000 | 1.00x | 139.000 | 64 | 8 |
| tabs-5-5-switches | 5 | facet | 1225.059 | 1212.459–1262.044 | 2.71x | 3837.000 | 1.31x | 225.000 | 80 | 8 |
| radial-15-cycles | 30 | plain | 27176.429 | 26703.198–28162.580 | 1.00x | 4609.000 | 1.00x | 175.000 | 2475 | 676 |
| radial-15-cycles | 30 | facet | 49512.853 | 48733.519–50594.185 | 1.82x | 4198.000 | 0.91x | 291.000 | 2678 | 497 |
| navigation-5-6-cycles | 60 | plain | 13142.422 | 12846.335–13556.416 | 1.00x | 3144.000 | 1.00x | 141.000 | 1890 | 390 |
| navigation-5-6-cycles | 60 | facet | 29992.187 | 28893.048–37056.066 | 2.28x | 3083.000 | 0.98x | 217.000 | 2364 | 360 |
| leaderboard-100 | 3 | plain | 819.767 | 778.484–880.538 | 1.00x | 8129.000 | 1.00x | 143.000 | 300 | 0 |
| leaderboard-100 | 3 | facet | 3814.736 | 3590.557–4020.055 | 4.65x | 22537.000 | 2.77x | 231.000 | 300 | 0 |
| theme-swap-200 | 2 | plain | 31.557 | 29.695–33.320 | 1.00x | 6341.000 | 1.00x | 4772.000 | 2 | 0 |
| theme-swap-200 | 2 | facet | 190.908 | 180.092–229.977 | 6.05x | 6955.000 | 1.10x | 254.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 678288.380 | 576737.169–770860.150 | 1.00x | 39.000 | 1.00x | 46.000 | 80460 | 17520 |
| heavy-screen-20-cycles | 20 | facet | 1080637.674 | 1047548.011–1103127.018 | 1.59x | 153.000 | 3.92x | 143.000 | 116480 | 17500 |
| tile-transfer-20 | 20 | plain | 3859.195 | 3769.080–4027.388 | 1.00x | 3506.000 | 1.00x | 198.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 10853.413 | 10577.787–17823.998 | 2.81x | 4783.000 | 1.36x | 223.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 965.196 | 949.433–973.128 | 1.00x | 3446.000 | 1.00x | 131.000 | 400 | 0 |
| input-type-switch-20 | 20 | facet | 12338.905 | 11973.304–12723.754 | 12.78x | 4402.000 | 1.28x | 160.000 | 800 | 200 |
| localized-text-swap-50 | 10 | plain | 1825.894 | 1745.293–1877.733 | 1.00x | 3479.000 | 1.00x | 117.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 10338.997 | 9930.511–10734.574 | 5.66x | 4565.000 | 1.31x | 123.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 30.857 | 28.544–32.058 | 1.00x | 3142.000 | 1.00x | 98.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1396.747 | 1327.343–1517.258 | 45.27x | 4793.000 | 1.53x | 123.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 225.089 | 210.869–237.789 | 1.00x | 2871.000 | 1.00x | 131.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 452.292 | 402.828–520.706 | 2.01x | 3144.000 | 1.10x | 198.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 393.764 | 360.764–426.062 | 1.00x | 2746.000 | 1.00x | 69.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 1581.465 | 1527.274–1624.541 | 4.02x | 2962.000 | 1.08x | 133.000 | 100 | 0 |
| gamepad-grid-6x6 | 35 | plain | 30277.457 | 29808.369–30933.786 | 1.00x | 8074.000 | 1.00x | 223.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 48137.971 | 46032.195–49615.220 | 1.59x | 11942.000 | 1.48x | 3799.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 2390.066 | 2304.297–2502.896 | 1.00x | 4419.000 | 1.00x | 116.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 36968.444 | 35852.570–38620.636 | 15.47x | 17802.000 | 4.03x | 311.000 | 1851 | 304 |
| modal-on-modal | 20 | plain | 6203.729 | 5943.887–6518.734 | 1.00x | 2999.000 | 1.00x | 163.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 26051.206 | 25679.236–26553.495 | 4.20x | 3716.000 | 1.24x | 242.000 | 946 | 185 |
| button-native-scale-50 | 6 | plain | 461.566 | 446.313–475.167 | 1.00x | 3935.000 | 1.00x | 127.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 459.624 | 428.557–469.539 | 1.00x | 4660.000 | 1.18x | 151.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 2.94x | 1.40x |

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
