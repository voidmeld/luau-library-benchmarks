# UI components headless results

Harness commit: `3ea569c166b26cd4dcc66e7d72c766f6d5e865ff`. Workflow run: [Library comparison 40844851286](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40844851286). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](ui-components.md) before you compare the two lanes.

# UI components comparison

Harness revision: `3ea569c166b26cd4dcc66e7d72c766f6d5e865ff`. Facet: `9c37177a24c3414c71c9456c2e6c14c5389f4916`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Lane | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 22227.402 | 1.00x | 2675.000 | 1.00x | 247.000 | 1372 | 450 |
| main-menu-cold | 1 | facet | 16284.937 | 0.73x | 2749.000 | 1.03x | 246.000 | 1377 | 450 |
| hud-600-frames | 600 | plain | 14933.149 | 1.00x | 2661.000 | 1.00x | 238.000 | 2488 | 0 |
| hud-600-frames | 600 | facet | 34363.414 | 2.30x | 2744.000 | 1.03x | 236.000 | 2488 | 0 |
| progress-20-120-frames | 120 | plain | 21731.490 | 1.00x | 3287.000 | 1.00x | 266.000 | 2400 | 0 |
| progress-20-120-frames | 120 | facet | 33388.767 | 1.54x | 3718.000 | 1.13x | 151.000 | 2400 | 0 |
| badges-30-300-updates | 300 | plain | 45488.951 | 1.00x | 3012.000 | 1.00x | 307.000 | 9410 | 0 |
| badges-30-300-updates | 300 | facet | 180476.009 | 3.97x | 3929.000 | 1.30x | 227.000 | 9410 | 0 |
| world-markers-50 | 100 | plain | 30398.627 | 1.00x | 3762.000 | 1.00x | 319.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 93011.290 | 3.06x | 4802.000 | 1.28x | 355.000 | 11385 | 50 |
| inventory-100 | 200 | plain | 686.022 | 1.00x | 5574.000 | 1.00x | 335.000 | 0 | 0 |
| inventory-100 | 200 | facet | 5059.392 | 7.37x | 13403.000 | 2.40x | 519.000 | 0 | 0 |
| inventory-500 | 200 | plain | 933.822 | 1.00x | 17100.000 | 1.00x | 500.000 | 0 | 0 |
| inventory-500 | 200 | facet | 5221.499 | 5.59x | 54848.000 | 3.21x | 721.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 4327.484 | 1.00x | 4211.000 | 1.00x | 339.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 6706.687 | 1.55x | 7095.000 | 1.68x | 394.000 | 2032 | 14 |
| virtual-scroll-2000 | 100 | plain | 23865.812 | 1.00x | 2879.000 | 1.00x | 209.000 | 4681 | 0 |
| virtual-scroll-2000 | 100 | facet | 70559.743 | 2.96x | 4861.000 | 1.69x | 356.000 | 6401 | 42 |
| chat-append-500 | 500 | plain | 43260.812 | 1.00x | 3198.000 | 1.00x | 0.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 111578.579 | 2.58x | 5903.000 | 1.85x | 589.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 31578.406 | 1.00x | 5002.000 | 1.00x | 0.000 | 3541 | 982 |
| card-collection-60 | 1 | facet | 83396.947 | 2.64x | 14517.000 | 2.90x | 546.000 | 5221 | 1402 |
| mixed-scroll-300 | 100 | plain | 579.911 | 1.00x | 7144.000 | 1.00x | 468.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 683.347 | 1.18x | 20461.000 | 2.86x | 657.000 | 100 | 0 |
| settings-17-values | 17 | plain | 233.203 | 1.00x | 3203.000 | 1.00x | 353.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1432.293 | 6.14x | 4446.000 | 1.39x | 7.000 | 56 | 0 |
| text-input-200 | 200 | plain | 1157.377 | 1.00x | 2540.000 | 1.00x | 194.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2322.077 | 2.01x | 2670.000 | 1.05x | 213.000 | 220 | 0 |
| button-feedback-50 | 3 | plain | 235.175 | 1.00x | 2954.000 | 1.00x | 220.000 | 0 | 0 |
| button-feedback-50 | 3 | facet | 237.373 | 1.01x | 3658.000 | 1.24x | 258.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1400.245 | 1.00x | 2707.000 | 1.00x | 268.000 | 208 | 0 |
| stepper-segments-100 | 100 | facet | 12381.123 | 8.84x | 3141.000 | 1.16x | 306.000 | 806 | 0 |
| dialog-50-cycles | 100 | plain | 46259.112 | 1.00x | 2881.000 | 1.00x | 536.000 | 4350 | 1101 |
| dialog-50-cycles | 100 | facet | 160543.627 | 3.47x | 3342.000 | 1.16x | 657.000 | 4248 | 771 |
| toast-stream-100 | 200 | plain | 33757.137 | 1.00x | 3817.000 | 1.00x | 486.000 | 2500 | 701 |
| toast-stream-100 | 200 | facet | 194654.768 | 5.77x | 3459.000 | 0.91x | 1041.000 | 8200 | 1800 |
| tabs-5-100-switches | 100 | plain | 1904.262 | 1.00x | 2778.000 | 1.00x | 262.000 | 444 | 8 |
| tabs-5-100-switches | 100 | facet | 8222.472 | 4.32x | 3599.000 | 1.30x | 328.000 | 444 | 8 |
| radial-50-cycles | 100 | plain | 113979.308 | 1.00x | 2740.000 | 1.00x | 394.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 555927.144 | 4.88x | 3678.000 | 1.34x | 1152.000 | 21700 | 3700 |
| navigation-5-20-cycles | 200 | plain | 48039.654 | 1.00x | 2860.000 | 1.00x | 461.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 130223.287 | 2.71x | 2890.000 | 1.01x | 388.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 3688.230 | 1.00x | 6744.000 | 1.00x | 452.000 | 952 | 0 |
| leaderboard-100 | 6 | facet | 18069.649 | 4.90x | 40710.000 | 6.04x | 1413.000 | 957 | 0 |
| theme-swap-200 | 10 | plain | 32.250 | 1.00x | 6248.000 | 1.00x | 4720.000 | 10 | 0 |
| theme-swap-200 | 10 | facet | 192.751 | 5.98x | 10055.000 | 1.61x | 768.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 950214.709 | 1.00x | 3149.000 | 1.00x | 3157.000 | 78480 | 16860 |
| heavy-screen-20-cycles | 20 | facet | 1512115.134 | 1.59x | 3939.000 | 1.25x | 3978.000 | 86480 | 16840 |
| tile-transfer-20 | 20 | plain | 3597.386 | 1.00x | 3299.000 | 1.00x | 387.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 17442.319 | 4.85x | 4782.000 | 1.45x | 395.000 | 829 | 84 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 3.06x | 1.54x |

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
