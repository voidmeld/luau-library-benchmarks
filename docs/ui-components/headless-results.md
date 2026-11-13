# UI components comparison

Harness revision: `a360b90fdecd5742232fa91d557806b2af9ded4d`. Facet: `9dc3bdb6e1afd76dfd86a5427da140d41defc78a`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Each lane builds its theme StyleSheet at mount, so cold mounts and complete lifetimes include that setup cost in each lane. Parity compares the observable result of both lanes. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 2025.404 | 1999.194–2064.176 | 1.00x | 347.000 | 1.00x | 107.000 | 155 | 42 |
| main-menu-cold | 1 | facet | 21806.562 | 20976.212–23023.377 | 10.77x | 2152.000 | 6.20x | 134.000 | 1500 | 487 |
| hud-60-frames | 60 | plain | 2269.071 | 2168.082–2470.740 | 1.00x | 348.000 | 1.00x | 108.000 | 383 | 0 |
| hud-60-frames | 60 | facet | 2788.216 | 2731.550–2836.517 | 1.23x | 2170.000 | 6.24x | 104.000 | 254 | 0 |
| world-markers-50 | 100 | plain | 61418.734 | 59902.286–62958.616 | 1.00x | 2785.000 | 1.00x | 1040.000 | 10000 | 0 |
| world-markers-50 | 100 | facet | 65991.722 | 64645.253–74837.104 | 1.07x | 5253.000 | 1.89x | 213.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 381.245 | 364.795–408.627 | 1.00x | 11443.000 | 1.00x | 127.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1102.941 | 1076.291–1153.456 | 2.89x | 25561.000 | 2.23x | 224.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3318.713 | 3283.116–3469.446 | 1.00x | 2379.000 | 1.00x | 127.000 | 1033 | 0 |
| shop-filter-200 | 10 | facet | 8573.612 | 8402.601–8777.194 | 2.58x | 6057.000 | 2.55x | 202.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 3938.106 | 3837.938–5177.543 | 1.00x | 575.000 | 1.00x | 68.000 | 1136 | 0 |
| virtual-scroll-2000 | 15 | facet | 8795.388 | 8655.877–8894.254 | 2.23x | 3231.000 | 5.62x | 156.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 18864.018 | 18376.353–19755.262 | 1.00x | 1140.000 | 1.00x | 142.000 | 2250 | 250 |
| chat-append-250 | 250 | facet | 57578.988 | 56895.695–59018.241 | 3.05x | 4115.000 | 3.61x | 103.000 | 3800 | 250 |
| card-collection-60 | 1 | plain | 34532.420 | 33153.469–35819.016 | 1.00x | 4416.000 | 1.00x | 100.000 | 3611 | 782 |
| card-collection-60 | 1 | facet | 91425.346 | 90635.202–93202.224 | 2.65x | 11579.000 | 2.62x | 138.000 | 4269 | 1082 |
| mixed-scroll-300 | 50 | plain | 323.718 | 293.491–443.343 | 1.00x | 6577.000 | 1.00x | 123.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 319.430 | 309.221–416.883 | 0.99x | 16875.000 | 2.57x | 242.000 | 50 | 0 |
| settings-17-values | 17 | plain | 1249.466 | 1215.433–1363.380 | 1.00x | 1743.000 | 1.00x | 150.000 | 54 | 4 |
| settings-17-values | 17 | facet | 3174.503 | 3064.526–3325.656 | 2.54x | 3868.000 | 2.22x | 232.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1150.310 | 1106.027–1165.118 | 1.00x | 316.000 | 1.00x | 100.000 | 225 | 0 |
| text-input-200 | 200 | facet | 1934.734 | 1886.122–2379.990 | 1.68x | 2084.000 | 6.59x | 71.000 | 225 | 0 |
| button-feedback-50 | 15 | plain | 642.868 | 632.848–655.912 | 1.00x | 726.000 | 1.00x | 96.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 639.581 | 623.752–714.942 | 0.99x | 3000.000 | 4.13x | 132.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 4902.528 | 4725.195–5022.654 | 1.00x | 733.000 | 1.00x | 236.000 | 604 | 1 |
| stepper-segments-100 | 100 | facet | 11614.504 | 11389.792–13671.067 | 2.37x | 2715.000 | 3.70x | 275.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 3298.326 | 3168.411–3418.180 | 1.00x | 399.000 | 1.00x | 140.000 | 202 | 52 |
| toast-stream-4 | 8 | facet | 8030.804 | 7916.509–8093.201 | 2.43x | 2215.000 | 5.55x | 174.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 853.373 | 826.964–879.903 | 1.00x | 551.000 | 1.00x | 162.000 | 68 | 8 |
| tabs-5-5-switches | 5 | facet | 3178.029 | 3037.415–3285.582 | 3.72x | 3160.000 | 5.74x | 232.000 | 80 | 8 |
| radial-15-cycles | 60 | plain | 55989.712 | 55214.756–56365.488 | 1.00x | 3132.000 | 1.00x | 124.000 | 4386 | 781 |
| radial-15-cycles | 60 | facet | 89653.054 | 88528.001–93415.470 | 1.60x | 3402.000 | 1.09x | 288.000 | 3114 | 512 |
| navigation-5-6-cycles | 60 | plain | 24757.338 | 24514.252–27624.102 | 1.00x | 393.000 | 1.00x | 172.000 | 2070 | 360 |
| navigation-5-6-cycles | 60 | facet | 47233.702 | 46107.657–48480.293 | 1.91x | 2475.000 | 6.30x | 189.000 | 2364 | 360 |
| leaderboard-100 | 6 | plain | 3926.534 | 3805.307–3988.731 | 1.00x | 8297.000 | 1.00x | 136.000 | 512 | 0 |
| leaderboard-100 | 6 | facet | 10996.423 | 9819.582–11391.083 | 2.80x | 20304.000 | 2.45x | 264.000 | 805 | 0 |
| theme-swap-200 | 4 | plain | 51.497 | 47.920–67.446 | 1.00x | 2285.000 | 1.00x | 71.000 | 0 | 0 |
| theme-swap-200 | 4 | facet | 3854.399 | 3586.034–4368.473 | 74.85x | 6918.000 | 3.03x | 413.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 519272.691 | 485107.329–554481.544 | 1.00x | 5928.000 | 1.00x | 151.000 | 60240 | 8040 |
| heavy-screen-20-cycles | 20 | facet | 1221815.912 | 1195915.493–1262168.986 | 2.35x | 8957.000 | 1.51x | 701.000 | 88260 | 8040 |
| tile-transfer-20 | 41 | plain | 5420.890 | 5304.150–6913.282 | 1.00x | 992.000 | 1.00x | 220.000 | 439 | 45 |
| tile-transfer-20 | 41 | facet | 42526.430 | 41222.181–42916.434 | 7.84x | 4045.000 | 4.08x | 221.000 | 1175 | 164 |
| input-type-switch-20 | 20 | plain | 8172.387 | 8016.665–8556.879 | 1.00x | 998.000 | 1.00x | 92.000 | 801 | 200 |
| input-type-switch-20 | 20 | facet | 31693.148 | 31223.525–32615.990 | 3.88x | 3724.000 | 3.73x | 153.000 | 1600 | 200 |
| localized-text-swap-50 | 10 | plain | 3198.346 | 3050.178–3408.090 | 1.00x | 1058.000 | 1.00x | 95.000 | 550 | 0 |
| localized-text-swap-50 | 10 | facet | 20406.833 | 19542.309–22631.167 | 6.38x | 3857.000 | 3.65x | 83.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 72.496 | 69.972–91.822 | 1.00x | 567.000 | 1.00x | 106.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 2402.080 | 2360.913–2595.163 | 33.13x | 3362.000 | 5.93x | 55.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 270.749 | 257.784–289.915 | 1.00x | 399.000 | 1.00x | 113.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 592.252 | 580.220–608.602 | 2.19x | 2489.000 | 6.24x | 214.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 705.324 | 655.891–740.460 | 1.00x | 323.000 | 1.00x | 113.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 2374.528 | 2332.930–3029.879 | 3.37x | 2226.000 | 6.89x | 145.000 | 100 | 0 |
| gamepad-grid-6x6 | 35 | plain | 61454.292 | 61084.016–62469.639 | 1.00x | 4390.000 | 1.00x | 3306.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 84459.942 | 80962.805–90402.110 | 1.37x | 12507.000 | 2.85x | 4519.000 | 35 | 0 |
| drag-reorder-100 | 40 | plain | 7012.999 | 6877.825–7349.791 | 1.00x | 4627.000 | 1.00x | 165.000 | 840 | 60 |
| drag-reorder-100 | 40 | facet | 56797.506 | 56005.559–61824.876 | 8.10x | 10459.000 | 2.26x | 220.000 | 1935 | 264 |
| modal-on-modal | 20 | plain | 24824.709 | 24676.230–25682.159 | 1.00x | 423.000 | 1.00x | 206.000 | 2170 | 271 |
| modal-on-modal | 20 | facet | 59136.924 | 58384.693–61013.650 | 2.38x | 2975.000 | 7.03x | 205.000 | 1206 | 205 |
| button-native-scale-50 | 6 | plain | 613.081 | 564.741–814.970 | 1.00x | 1633.000 | 1.00x | 113.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 594.026 | 561.565–838.375 | 0.97x | 4090.000 | 2.50x | 176.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 3.04x | 3.60x |

## Workloads

- `main-menu-cold`: Install the theme StyleSheet and mount a surface with a title, six actions and a footer; runtime and control-factory setup is excluded.
- `hud-60-frames`: Update health fill, ammo, currency and timer once per simulated frame.
- `world-markers-50`: Update the labels of 50 native BillboardGui markers in the player's GUI, adorned to anchored Parts in the Workspace.
- `inventory-500`: Select among 500 retained slots 40 times; each slot has an activation target and selected state.
- `shop-filter-200`: Edit a native TextBox with ten queries, including empty and no match; retain the 200 catalog rows and set their visibility.
- `virtual-scroll-2000`: Scroll a fixed 40-pixel row window down in 796-pixel steps; the plain lane keeps a small reusable row pool.
- `chat-append-250`: Append 250 keyed messages; remove the oldest when the log exceeds 100 rows.
- `card-collection-60`: Mount 60 cards with the same artwork, item title and price caption; theme setup is excluded.
- `mixed-scroll-300`: Scroll 300 retained mixed rows: 100 text rows, 100 action buttons and 100 text cards.
- `settings-17-values`: Change ten toggles, four sliders and three segmented pickers; native value readouts show the result. Toggles and picker segments change through their Activated input, sliders through the model in headless worlds and a track drag in Studio. While a slider holds native selection, its arrow, shoulder and cancel InputContexts follow its value; the picker selection fill slides with the theme control spring.
- `text-input-200`: Type 200 characters through a native TextBox; validation rejects punctuation and accepts letters. While the field edits, an InputContext holds the arrow keys and Escape or ButtonB cancels to the text at focus; the 100th character is followed by a cancel and the next by a new focus.
- `button-feedback-50`: Visit 15 of 50 buttons through Hover, Press and Idle, one frame each. Facet uses its theme state rules; plain uses its own Hover and Press StyleRules with the same colours and timings. Checkpoints compare the styled paint during the release transition and after it settles; the Studio driver uses real mouse input.
- `stepper-segments-100`: Change a bounded quantity and a segmented choice 100 times, then render one frame. Every tenth change goes through the Increase button and a segment's Activated input, the rest through the application model. The stepper has 44-pixel Decrease and Increase icon buttons that repeat while held and disable at the limits; the picker selection fill slides with the theme control spring.
- `toast-stream-4`: Show 4 one-shot result toasts with a shared expiry parameter (four seconds headless, 0.05 seconds Studio). Both lanes stack toasts at the top of the overlay, show at most three and queue up to eight, slide each in with the theme present easing while fading it linearly, and fade only under reduced motion.
- `tabs-5-5-switches`: Select a peer tab and activate it, 5 times among five tabs, keeping each visited page and its content. Both lanes centre a scrolling 44-pixel tab bar, paint the current tab and its 2-pixel underline, keep each page a selection group with a per-tab focus bookmark, and enable L1 and R1 while focus is in the bar.
- `radial-15-cycles`: Open a four-command donut radial menu from its launcher, activate Wave and let it close, 15 times, with a checkpoint in the middle of each enter and exit. Both lanes size the inner radius from the launcher with a 96-pixel ring, fit each label box to its sector, catch outside input on a transparent scrim, draw four Path2D sectors and a centre close button, spread the ring out from 0.2 scale with the theme radial timings, highlight the candidate or focused sector, hide the launcher until the exit ends, and add the modal back and radial input contexts.
- `navigation-5-6-cycles`: Push five child pages, then select and activate each page's Back button to pop it, 6 times. Both lanes keep covered pages, show a 44-pixel bar with the destination title (left on the root, centred on child pages) and a Back button with a chevron and label, bind Escape and ButtonB to back, and move focus into the page that becomes top; the root has no Back action.
- `leaderboard-100`: Sort 100 retained player rows by name, replace every score and scroll down, press the Score header twice for ascending and descending order, then replace every score again and let moved rows finish their glide. Checkpoints report rows in motion without their geometry.
- `theme-swap-200`: Swap the content colour on 200 themed buttons and back. Each swap is checked mid-transition and after the theme paint transition settles. Facet updates its theme source; plain sets one colour attribute on its theme StyleSheet.
- `heavy-screen-20-cycles`: Close a scrolling screen of 200 actions and 200 text rows and open a fresh one, 20 times, inside one themed ScreenGui. Each lifetime is laid out for one frame. The theme StyleSheet stays mounted.
- `tile-transfer-20`: Pick up 20 tiles with keyboard activation and drop each into the second grid. Before each pickup the player waits for the previous drop preview to shrink away. Checkpoints alternate between the held state and the moment after the drop; the last one waits for the final preview.
- `input-type-switch-20`: Switch the authored preferred-input fact between keyboard and gamepad on 20 action controls and prompts. This measures adaptation after input detection.
- `localized-text-swap-50`: Swap translated strings on 50 retained labels between English and German. Both lanes use the same LocalizationTable translators and disable automatic localization of translated text.
- `text-size-preference-50`: Change an authored text-size preference across four ranks on a 50-label screen. Facet updates its theme text-size tokens; plain updates one native StyleSheet text-size token that its body rule reads.
- `phone-rotation-hub`: Rotate a retained hub between 390 by 844 and 844 by 390 layout units. Turn its subject, task list and action column without remounting the controls.
- `hud-composition-step-down`: Resize a HUD from 800 to 400 layout units. Keep rich and compact status forms mounted, choose the richest form that fits, pop the new form in and restore the rich form on expansion.
- `gamepad-grid-6x6`: Walk all 36 retained cells of a six by six grid in a snake path. Both hosts send D-pad keys through their input host and check native selection. Facet uses VirtualGrid with its focus scope; plain uses transparent selectable hit buttons over text cells. Both hold Home, End, page and direction keys in priority 200 InputContexts while the grid holds selection.
- `drag-reorder-100`: Drag the first of 100 retained rows after the fifth row, 20 times: odd steps press and move past the 6-pixel threshold, even steps drop. Facet uses VirtualList reorderable and onReorder; plain uses a UIDragDetector per row, a divider drop line, a drag ghost, a priority 400 cancel InputContext and the theme snappy spring for row travel, plus keyboard pick-up, move, drop and cancel. Headless worlds fire the row detector after checking that it is enabled; Studio drags with the real mouse.
- `modal-on-modal`: Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.
- `button-native-scale-50`: Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.
