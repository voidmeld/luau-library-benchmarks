# UI components headless results

Harness commit: `47be4e3df6cfe4bc3fd3d5ae392afbadef6cdbe8`. Workflow run: [Library comparison 40796735224](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40796735224). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](ui-components.md) before you compare the two lanes.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Lane | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 25079.460 | 1.00x | 2658.000 | 1.00x | 240.000 | 1372 | 450 |
| main-menu-cold | 1 | facet | 22766.504 | 0.91x | 2772.000 | 1.04x | 254.000 | 1377 | 450 |
| hud-600-frames | 600 | plain | 21954.077 | 1.00x | 2652.000 | 1.00x | 239.000 | 2488 | 0 |
| hud-600-frames | 600 | facet | 42337.153 | 1.93x | 2759.000 | 1.04x | 252.000 | 2488 | 0 |
| progress-20-120-frames | 120 | plain | 31966.269 | 1.00x | 3278.000 | 1.00x | 273.000 | 2400 | 0 |
| progress-20-120-frames | 120 | facet | 39260.068 | 1.23x | 3710.000 | 1.13x | 128.000 | 2400 | 0 |
| badges-30-300-updates | 300 | plain | 68439.185 | 1.00x | 2995.000 | 1.00x | 284.000 | 9410 | 0 |
| badges-30-300-updates | 300 | facet | 245543.138 | 3.59x | 3914.000 | 1.31x | 230.000 | 9410 | 0 |
| world-markers-50 | 100 | plain | 38074.989 | 1.00x | 3689.000 | 1.00x | 255.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 117840.552 | 3.09x | 4848.000 | 1.31x | 420.000 | 11385 | 50 |
| inventory-100 | 200 | plain | 1319.352 | 1.00x | 5574.000 | 1.00x | 335.000 | 0 | 0 |
| inventory-100 | 200 | facet | 5853.553 | 4.44x | 13394.000 | 2.40x | 484.000 | 0 | 0 |
| inventory-500 | 200 | plain | 1355.449 | 1.00x | 16971.000 | 1.00x | 331.000 | 0 | 0 |
| inventory-500 | 200 | facet | 7702.503 | 5.68x | 55326.000 | 3.26x | 1249.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 6406.434 | 1.00x | 4203.000 | 1.00x | 348.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 9448.751 | 1.47x | 7119.000 | 1.69x | 420.000 | 2032 | 14 |
| virtual-scroll-2000 | 100 | plain | 36223.549 | 1.00x | 2890.000 | 1.00x | 228.000 | 4681 | 0 |
| virtual-scroll-2000 | 100 | facet | 88014.354 | 2.43x | 4553.000 | 1.58x | 51.000 | 6401 | 42 |
| chat-append-500 | 500 | plain | 62603.688 | 1.00x | 3725.000 | 1.00x | 434.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 158844.745 | 2.54x | 5868.000 | 1.58x | 569.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 42825.984 | 1.00x | 5258.000 | 1.00x | 204.000 | 3541 | 982 |
| card-collection-60 | 1 | facet | 108493.740 | 2.53x | 13747.000 | 2.61x | 0.000 | 5221 | 1402 |
| mixed-scroll-300 | 100 | plain | 717.348 | 1.00x | 7151.000 | 1.00x | 475.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 716.888 | 1.00x | 20428.000 | 2.86x | 658.000 | 100 | 0 |
| settings-17-values | 17 | plain | 247.712 | 1.00x | 3187.000 | 1.00x | 345.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1664.736 | 6.72x | 4805.000 | 1.51x | 368.000 | 56 | 0 |
| text-input-200 | 200 | plain | 1460.354 | 1.00x | 2540.000 | 1.00x | 194.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2852.709 | 1.95x | 2647.000 | 1.04x | 204.000 | 220 | 0 |
| button-feedback-50 | 3 | plain | 316.271 | 1.00x | 2970.000 | 1.00x | 237.000 | 0 | 0 |
| button-feedback-50 | 3 | facet | 316.581 | 1.00x | 3650.000 | 1.23x | 250.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1878.215 | 1.00x | 2707.000 | 1.00x | 268.000 | 208 | 0 |
| stepper-segments-100 | 100 | facet | 15456.041 | 8.23x | 3147.000 | 1.16x | 321.000 | 806 | 0 |
| dialog-50-cycles | 100 | plain | 60626.277 | 1.00x | 2897.000 | 1.00x | 544.000 | 4350 | 1101 |
| dialog-50-cycles | 100 | facet | 195486.401 | 3.22x | 3259.000 | 1.12x | 565.000 | 4248 | 771 |
| toast-stream-100 | 200 | plain | 34528.117 | 1.00x | 3687.000 | 1.00x | 485.000 | 2508 | 701 |
| toast-stream-100 | 200 | facet | 220184.879 | 6.38x | 2765.000 | 0.75x | 348.000 | 8200 | 1800 |
| tabs-5-100-switches | 100 | plain | 2842.884 | 1.00x | 2785.000 | 1.00x | 270.000 | 444 | 8 |
| tabs-5-100-switches | 100 | facet | 10819.997 | 3.81x | 3601.000 | 1.29x | 317.000 | 444 | 8 |
| radial-50-cycles | 100 | plain | 129153.883 | 1.00x | 3235.000 | 1.00x | 890.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 682237.566 | 5.28x | 4020.000 | 1.24x | 1491.000 | 21700 | 3700 |
| navigation-5-20-cycles | 200 | plain | 75915.977 | 1.00x | 2850.000 | 1.00x | 449.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 161178.432 | 2.12x | 3144.000 | 1.10x | 652.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 4567.631 | 1.00x | 6759.000 | 1.00x | 459.000 | 952 | 0 |
| leaderboard-100 | 6 | facet | 18819.322 | 4.12x | 39999.000 | 5.92x | 876.000 | 957 | 0 |
| theme-swap-200 | 10 | plain | 40.185 | 1.00x | 6223.000 | 1.00x | 4702.000 | 10 | 0 |
| theme-swap-200 | 10 | facet | 263.482 | 6.56x | 10043.000 | 1.61x | 735.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 1185887.717 | 1.00x | 2453.000 | 1.00x | 2443.000 | 78480 | 16860 |
| heavy-screen-20-cycles | 20 | facet | 1933450.913 | 1.63x | 5276.000 | 2.15x | 5275.000 | 86480 | 16840 |
| tile-transfer-20 | 20 | plain | 4762.987 | 1.00x | 3291.000 | 1.00x | 381.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 25570.842 | 5.37x | 4806.000 | 1.46x | 424.000 | 829 | 84 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 2.88x | 1.54x |

## Workloads

- `main-menu-cold`: Mount a background, title, six actions and footer; runtime and control-factory setup is excluded.
- `hud-600-frames`: Update health fill, ammo, currency and timer once per simulated frame.
- `progress-20-120-frames`: Drive 20 measured progress fills with per-frame values; both lanes use the same linear frame sequence.
- `badges-30-300-updates`: Update all 30 notification counts, 300 times; badges keep their native text nodes.
- `world-markers-50`: Update the labels of 50 native BillboardGui markers anchored to Parts.
- `inventory-100`: Select among 100 retained slots 200 times; each slot has an activation target and selected state.
- `inventory-500`: Select among 500 retained slots 200 times; each slot has an activation target and selected state.
- `shop-filter-200`: Edit a native TextBox with ten queries, including empty and no match; retain the 200 catalog rows and set their visibility.
- `virtual-scroll-2000`: Scroll a fixed 40-pixel row window from top to bottom; the plain lane keeps a small reusable row pool.
- `chat-append-500`: Append 500 keyed messages; remove the oldest when the log exceeds 100 rows.
- `card-collection-60`: Mount 60 cards with the same artwork, item title and price caption.
- `mixed-scroll-300`: Scroll 300 retained mixed rows: 100 text rows, 100 action buttons and 100 text cards.
- `settings-17-values`: Change each of ten toggle, four slider and three segmented-picker model values; native value readouts show the result.
- `text-input-200`: Type 200 characters through a native TextBox; validation rejects punctuation and accepts letters.
- `button-feedback-50`: Set native GuiState to Hover, Press and Idle on 50 buttons. Both lanes style feedback with the same theme StyleSheet state rules.
- `stepper-segments-100`: Change a bounded quantity and a segmented choice 100 times through the application model.
- `dialog-50-cycles`: Open a confirmation dialog, then activate Confirm and close it, 50 times. Both lanes add a scrim, an outside dismiss target, a selection trap, Back and Return input contexts and the theme dialog fade.
- `toast-stream-100`: Show 100 one-shot result toasts. Each toast stays for four seconds and then closes. Both lanes put the toast in a panel row in a stack and use the theme toast enter and exit motion.
- `tabs-5-100-switches`: Switch 100 times among five peer pages and keep each visited page and its content. Both lanes mark the current tab, show its selection indicator and add shoulder-button input contexts.
- `radial-50-cycles`: Open a four-command radial menu, select Wave and close it, 50 times. Both lanes draw four Path2D ring sectors, a centre close button, a selection preview, a scrim, gamepad and keyboard input contexts and the theme radial fade, and hide the launcher while the menu is open.
- `navigation-5-20-cycles`: Push five child pages and pop them, 20 times; root has no Back action and covered pages remain retained.
- `leaderboard-100`: Sort 100 retained player rows by name, score and wins; replace every score after each sort.
- `theme-swap-200`: Swap two neutral packages on 200 themed buttons. Both lanes build both themes in setup. Facet updates its StyleSheet tokens while plain relinks one of two prebuilt theme StyleSheets.
- `heavy-screen-20-cycles`: Mount and dispose 200 action controls and 200 text rows, 20 complete lifetimes.
- `tile-transfer-20`: Pick up 20 tiles with gamepad activation and drop each into the second grid. Both lanes show a drag preview, a held state, a status hint and a cancel input context, and shrink the preview with the theme travel motion after the drop. Facet also installs pointer drop resolution.
