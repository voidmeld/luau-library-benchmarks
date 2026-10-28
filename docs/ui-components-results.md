# UI components headless results

Harness commit: `27a2a583674dbdbf25afed549be5dc13a0c9746c`. Workflow run: [Library comparison 40770211887](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40770211887). Runner: `ubuntu-latest`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read [the method](ui-components.md) before you compare the two lanes.


Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Lane | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 25292.794 | 1.00x | 2666.000 | 1.00x | 255.000 | 1372 | 450 |
| main-menu-cold | 1 | facet | 21233.354 | 0.84x | 2772.000 | 1.04x | 268.000 | 1377 | 450 |
| hud-600-frames | 600 | plain | 18379.289 | 1.00x | 2653.000 | 1.00x | 239.000 | 2488 | 0 |
| hud-600-frames | 600 | facet | 43230.995 | 2.35x | 2743.000 | 1.03x | 243.000 | 2488 | 0 |
| progress-20-120-frames | 120 | plain | 25906.865 | 1.00x | 3278.000 | 1.00x | 265.000 | 2400 | 0 |
| progress-20-120-frames | 120 | facet | 41913.098 | 1.62x | 2285.000 | 0.70x | 0.000 | 2400 | 0 |
| badges-30-300-updates | 300 | plain | 60937.121 | 1.00x | 2915.000 | 1.00x | 203.000 | 9410 | 0 |
| badges-30-300-updates | 300 | facet | 236415.271 | 3.88x | 3904.000 | 1.34x | 194.000 | 9410 | 0 |
| world-markers-50 | 100 | plain | 41080.090 | 1.00x | 3721.000 | 1.00x | 271.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 122195.633 | 2.97x | 4854.000 | 1.30x | 419.000 | 11385 | 50 |
| inventory-100 | 200 | plain | 1128.802 | 1.00x | 5582.000 | 1.00x | 327.000 | 0 | 0 |
| inventory-100 | 200 | facet | 5957.608 | 5.28x | 13409.000 | 2.40x | 538.000 | 0 | 0 |
| inventory-500 | 200 | plain | 1458.470 | 1.00x | 17075.000 | 1.00x | 483.000 | 0 | 0 |
| inventory-500 | 200 | facet | 7913.337 | 5.43x | 53849.000 | 3.15x | 0.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 6669.004 | 1.00x | 4123.000 | 1.00x | 244.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 9392.712 | 1.41x | 7102.000 | 1.72x | 417.000 | 2032 | 14 |
| virtual-scroll-2000 | 100 | plain | 43125.813 | 1.00x | 2873.000 | 1.00x | 212.000 | 4681 | 0 |
| virtual-scroll-2000 | 100 | facet | 99503.482 | 2.31x | 4865.000 | 1.69x | 358.000 | 6401 | 42 |
| chat-append-500 | 500 | plain | 60547.485 | 1.00x | 3725.000 | 1.00x | 434.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 167481.796 | 2.77x | 5895.000 | 1.58x | 599.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 41421.484 | 1.00x | 5385.000 | 1.00x | 331.000 | 3541 | 982 |
| card-collection-60 | 1 | facet | 119447.653 | 2.88x | 14499.000 | 2.69x | 543.000 | 5221 | 1402 |
| mixed-scroll-300 | 100 | plain | 750.780 | 1.00x | 7152.000 | 1.00x | 476.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 920.026 | 1.23x | 20306.000 | 2.84x | 531.000 | 100 | 0 |
| settings-17-values | 17 | plain | 290.232 | 1.00x | 3187.000 | 1.00x | 327.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1959.414 | 6.75x | 4802.000 | 1.51x | 379.000 | 56 | 0 |
| text-input-200 | 200 | plain | 1462.076 | 1.00x | 2539.000 | 1.00x | 186.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2840.476 | 1.94x | 2607.000 | 1.03x | 156.000 | 220 | 0 |
| button-feedback-50 | 3 | plain | 321.733 | 1.00x | 2970.000 | 1.00x | 237.000 | 0 | 0 |
| button-feedback-50 | 3 | facet | 310.372 | 0.96x | 3658.000 | 1.23x | 252.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1942.742 | 1.00x | 2700.000 | 1.00x | 275.000 | 208 | 0 |
| stepper-segments-100 | 100 | facet | 15831.690 | 8.15x | 3135.000 | 1.16x | 310.000 | 806 | 0 |
| dialog-50-cycles | 100 | plain | 58351.082 | 1.00x | 2873.000 | 1.00x | 528.000 | 4350 | 1101 |
| dialog-50-cycles | 100 | facet | 176587.539 | 3.03x | 3203.000 | 1.11x | 509.000 | 4248 | 771 |
| toast-stream-100 | 200 | plain | 38380.864 | 1.00x | 3910.000 | 1.00x | 477.000 | 2500 | 701 |
| toast-stream-100 | 200 | facet | 244474.973 | 6.37x | 2953.000 | 0.76x | 545.000 | 8200 | 1800 |
| tabs-5-100-switches | 100 | plain | 2388.053 | 1.00x | 2649.000 | 1.00x | 142.000 | 444 | 8 |
| tabs-5-100-switches | 100 | facet | 10959.521 | 4.59x | 3608.000 | 1.36x | 309.000 | 444 | 8 |
| radial-50-cycles | 100 | plain | 139591.651 | 1.00x | 3002.000 | 1.00x | 649.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 665646.772 | 4.77x | 3930.000 | 1.31x | 1409.000 | 21700 | 3700 |
| navigation-5-20-cycles | 200 | plain | 71321.352 | 1.00x | 2796.000 | 1.00x | 397.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 160357.968 | 2.25x | 3145.000 | 1.12x | 642.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 4821.660 | 1.00x | 6743.000 | 1.00x | 459.000 | 952 | 0 |
| leaderboard-100 | 6 | facet | 28364.011 | 5.88x | 40519.000 | 6.01x | 1366.000 | 957 | 0 |
| theme-swap-200 | 10 | plain | 36.037 | 1.00x | 6239.000 | 1.00x | 4727.000 | 10 | 0 |
| theme-swap-200 | 10 | facet | 226.332 | 6.28x | 10054.000 | 1.61x | 757.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 1204734.720 | 1.00x | 3461.000 | 1.00x | 3469.000 | 78480 | 16860 |
| heavy-screen-20-cycles | 20 | facet | 1974063.026 | 1.64x | 4185.000 | 1.21x | 4192.000 | 86480 | 16840 |
| tile-transfer-20 | 20 | plain | 5980.273 | 1.00x | 3291.000 | 1.00x | 380.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 22070.301 | 3.69x | 4309.000 | 1.31x | 0.000 | 829 | 84 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 2.98x | 1.49x |

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
