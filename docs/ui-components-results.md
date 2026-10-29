# UI components headless results

Harness commit: `688d482bab458186b251625ccad29a686747cf5c`. Workflow run: [Library comparison 40921659782](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40921659782). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](ui-components.md) before you compare the two lanes.

# UI components comparison

Harness revision: `688d482bab458186b251625ccad29a686747cf5c`. Facet: `8a319b615f42e338878c7a69b4495542545b0c31`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Lane | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 27092.834 | 1.00x | 2646.000 | 1.00x | 255.000 | 1369 | 449 |
| main-menu-cold | 1 | facet | 21518.838 | 0.79x | 2776.000 | 1.05x | 246.000 | 1374 | 449 |
| hud-600-frames | 600 | plain | 18322.069 | 1.00x | 2650.000 | 1.00x | 239.000 | 2488 | 0 |
| hud-600-frames | 600 | facet | 45435.862 | 2.48x | 2731.000 | 1.03x | 229.000 | 2488 | 0 |
| progress-20-120-frames | 120 | plain | 26079.560 | 1.00x | 3091.000 | 1.00x | 74.000 | 2400 | 0 |
| progress-20-120-frames | 120 | facet | 42036.428 | 1.61x | 3821.000 | 1.24x | 269.000 | 2400 | 0 |
| badges-30-300-updates | 300 | plain | 65147.939 | 1.00x | 3007.000 | 1.00x | 299.000 | 9410 | 0 |
| badges-30-300-updates | 300 | facet | 234248.912 | 3.60x | 3788.000 | 1.26x | 83.000 | 9410 | 0 |
| world-markers-50 | 100 | plain | 41938.981 | 1.00x | 3766.000 | 1.00x | 327.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 122251.525 | 2.91x | 4851.000 | 1.29x | 407.000 | 11385 | 50 |
| inventory-100 | 200 | plain | 1065.422 | 1.00x | 5571.000 | 1.00x | 344.000 | 0 | 0 |
| inventory-100 | 200 | facet | 6031.349 | 5.66x | 13423.000 | 2.41x | 519.000 | 0 | 0 |
| inventory-500 | 200 | plain | 1287.026 | 1.00x | 17096.000 | 1.00x | 506.000 | 0 | 0 |
| inventory-500 | 200 | facet | 7427.790 | 5.77x | 55032.000 | 3.22x | 856.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 6560.131 | 1.00x | 4199.000 | 1.00x | 340.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 9900.839 | 1.51x | 7092.000 | 1.69x | 404.000 | 2032 | 14 |
| virtual-scroll-2000 | 100 | plain | 41650.318 | 1.00x | 2870.000 | 1.00x | 221.000 | 4681 | 0 |
| virtual-scroll-2000 | 100 | facet | 87575.191 | 2.10x | 4785.000 | 1.67x | 277.000 | 6401 | 42 |
| chat-append-500 | 500 | plain | 66095.927 | 1.00x | 3722.000 | 1.00x | 426.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 146361.945 | 2.21x | 5907.000 | 1.59x | 597.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 41245.636 | 1.00x | 5382.000 | 1.00x | 332.000 | 3538 | 981 |
| card-collection-60 | 1 | facet | 115957.707 | 2.81x | 14272.000 | 2.65x | 312.000 | 5218 | 1401 |
| mixed-scroll-300 | 100 | plain | 742.309 | 1.00x | 6916.000 | 1.00x | 219.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 767.976 | 1.03x | 20480.000 | 2.96x | 673.000 | 100 | 0 |
| settings-17-values | 17 | plain | 285.594 | 1.00x | 3184.000 | 1.00x | 337.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1943.686 | 6.81x | 4820.000 | 1.51x | 385.000 | 56 | 0 |
| text-input-200 | 200 | plain | 2083.185 | 1.00x | 2544.000 | 1.00x | 170.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2546.130 | 1.22x | 2667.000 | 1.05x | 214.000 | 220 | 0 |
| button-feedback-50 | 3 | plain | 316.953 | 1.00x | 2967.000 | 1.00x | 237.000 | 0 | 0 |
| button-feedback-50 | 3 | facet | 303.237 | 0.96x | 3639.000 | 1.23x | 244.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1764.239 | 1.00x | 2702.000 | 1.00x | 274.000 | 208 | 0 |
| stepper-segments-100 | 100 | facet | 15134.900 | 8.58x | 3143.000 | 1.16x | 319.000 | 806 | 0 |
| dialog-50-cycles | 100 | plain | 57775.437 | 1.00x | 2140.000 | 1.00x | 0.000 | 4350 | 1101 |
| dialog-50-cycles | 100 | facet | 183588.266 | 3.18x | 3330.000 | 1.56x | 650.000 | 4248 | 771 |
| toast-stream-100 | 200 | plain | 39132.831 | 1.00x | 3773.000 | 1.00x | 485.000 | 2506 | 701 |
| toast-stream-100 | 200 | facet | 222681.563 | 5.69x | 2825.000 | 0.75x | 412.000 | 8200 | 1800 |
| tabs-5-100-switches | 100 | plain | 3176.338 | 1.00x | 2781.000 | 1.00x | 278.000 | 444 | 8 |
| tabs-5-100-switches | 100 | facet | 10857.038 | 3.42x | 3586.000 | 1.29x | 311.000 | 444 | 8 |
| radial-50-cycles | 100 | plain | 139609.968 | 1.00x | 2719.000 | 1.00x | 370.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 664050.193 | 4.76x | 4014.000 | 1.48x | 1480.000 | 21700 | 3700 |
| navigation-5-20-cycles | 200 | plain | 70893.669 | 1.00x | 2856.000 | 1.00x | 461.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 157389.718 | 2.22x | 3150.000 | 1.10x | 652.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 4636.367 | 1.00x | 6763.000 | 1.00x | 467.000 | 952 | 0 |
| leaderboard-100 | 6 | facet | 20295.131 | 4.38x | 39850.000 | 5.89x | 613.000 | 957 | 0 |
| theme-swap-200 | 10 | plain | 37.560 | 1.00x | 6223.000 | 1.00x | 4704.000 | 10 | 0 |
| theme-swap-200 | 10 | facet | 248.936 | 6.63x | 10040.000 | 1.61x | 753.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 1181349.468 | 1.00x | 2436.000 | 1.00x | 2444.000 | 78420 | 16840 |
| heavy-screen-20-cycles | 20 | facet | 1966107.107 | 1.66x | 4229.000 | 1.74x | 4244.000 | 86420 | 16820 |
| tile-transfer-20 | 20 | plain | 5863.721 | 1.00x | 3287.000 | 1.00x | 389.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 22207.741 | 3.79x | 4794.000 | 1.46x | 418.000 | 829 | 84 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 2.82x | 1.57x |

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
