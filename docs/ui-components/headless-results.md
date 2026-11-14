# UI components comparison

Harness revision: `4cc8201897bde3a21b3f8616e7a5068e7ec582d4`. Facet: `c8ae0b9b80eb91d1cbcf1710cc4775bc25975f84`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Each lane builds its theme StyleSheet at mount, so cold mounts and complete lifetimes include that setup cost in each lane. Parity compares the observable result of both lanes. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 1982.459 | 1949.628–2033.144 | 1.00x | 347.000 | 1.00x | 123.000 | 155 | 42 |
| main-menu-cold | 1 | facet | 18231.512 | 17997.875–18593.870 | 9.20x | 2176.000 | 6.27x | 148.000 | 1500 | 487 |
| hud-60-frames | 60 | plain | 1222.429 | 1208.532–1242.346 | 1.00x | 276.000 | 1.00x | 52.000 | 242 | 0 |
| hud-60-frames | 60 | facet | 2727.046 | 2675.207–2775.275 | 2.23x | 2201.000 | 7.97x | 136.000 | 254 | 0 |
| world-markers-50 | 100 | plain | 27930.764 | 26616.705–33971.540 | 1.00x | 1967.000 | 1.00x | 221.000 | 5956 | 1 |
| world-markers-50 | 100 | facet | 68344.952 | 65120.967–71749.163 | 2.45x | 5262.000 | 2.68x | 217.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 354.743 | 332.101–384.018 | 1.00x | 11451.000 | 1.00x | 134.000 | 0 | 0 |
| inventory-500 | 40 | facet | 1056.838 | 1009.039–1112.001 | 2.98x | 25586.000 | 2.23x | 231.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3256.234 | 3213.473–3581.723 | 1.00x | 2363.000 | 1.00x | 127.000 | 1033 | 0 |
| shop-filter-200 | 10 | facet | 8144.321 | 8049.904–8316.774 | 2.50x | 6050.000 | 2.56x | 207.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 3882.016 | 3804.481–4005.516 | 1.00x | 583.000 | 1.00x | 84.000 | 1136 | 0 |
| virtual-scroll-2000 | 15 | facet | 8319.438 | 8114.216–8739.021 | 2.14x | 3223.000 | 5.53x | 148.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 18920.407 | 18680.880–19344.361 | 1.00x | 1148.000 | 1.00x | 142.000 | 2250 | 250 |
| chat-append-250 | 250 | facet | 56109.141 | 55587.946–56762.234 | 2.97x | 4113.000 | 3.58x | 101.000 | 3800 | 250 |
| card-collection-60 | 1 | plain | 33295.998 | 32395.990–33804.371 | 1.00x | 4400.000 | 1.00x | 100.000 | 3611 | 782 |
| card-collection-60 | 1 | facet | 88711.748 | 87567.627–89902.386 | 2.66x | 11579.000 | 2.63x | 170.000 | 4269 | 1082 |
| mixed-scroll-300 | 50 | plain | 298.809 | 290.103–424.595 | 1.00x | 6585.000 | 1.00x | 132.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 302.106 | 282.819–341.679 | 1.01x | 16883.000 | 2.56x | 241.000 | 50 | 0 |
| settings-17-values | 17 | plain | 1208.892 | 1140.835–1384.330 | 1.00x | 1782.000 | 1.00x | 136.000 | 53 | 4 |
| settings-17-values | 17 | facet | 3175.452 | 3107.144–3257.876 | 2.63x | 3844.000 | 2.16x | 190.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1141.195 | 1123.292–1169.679 | 1.00x | 323.000 | 1.00x | 108.000 | 225 | 0 |
| text-input-200 | 200 | facet | 1906.067 | 1877.333–2023.396 | 1.67x | 2116.000 | 6.55x | 55.000 | 225 | 0 |
| button-feedback-50 | 15 | plain | 646.800 | 636.682–660.847 | 1.00x | 742.000 | 1.00x | 104.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 651.900 | 636.260–691.524 | 1.01x | 2999.000 | 4.04x | 132.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 2495.362 | 2443.523–2559.362 | 1.00x | 680.000 | 1.00x | 193.000 | 303 | 1 |
| stepper-segments-100 | 100 | facet | 11358.858 | 11292.183–11725.494 | 4.55x | 2723.000 | 4.00x | 298.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 3397.318 | 3283.244–3478.129 | 1.00x | 404.000 | 1.00x | 132.000 | 196 | 52 |
| toast-stream-4 | 8 | facet | 7996.244 | 7929.640–8288.421 | 2.35x | 2215.000 | 5.48x | 174.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 849.329 | 830.384–1034.526 | 1.00x | 536.000 | 1.00x | 146.000 | 68 | 8 |
| tabs-5-5-switches | 5 | facet | 3108.738 | 3053.415–3199.397 | 3.66x | 3160.000 | 5.90x | 223.000 | 80 | 8 |
| radial-8-cycles | 32 | plain | 31020.413 | 30278.254–32005.107 | 1.00x | 1909.000 | 1.00x | 154.000 | 2335 | 417 |
| radial-8-cycles | 32 | facet | 57192.684 | 56383.659–62545.050 | 1.84x | 3385.000 | 1.77x | 295.000 | 1805 | 295 |
| navigation-5-6-cycles | 60 | plain | 25308.326 | 24913.177–25917.085 | 1.00x | 393.000 | 1.00x | 132.000 | 2070 | 360 |
| navigation-5-6-cycles | 60 | facet | 47333.577 | 46242.034–47881.703 | 1.87x | 2483.000 | 6.32x | 181.000 | 2364 | 360 |
| leaderboard-100 | 6 | plain | 3854.834 | 3757.793–3960.252 | 1.00x | 8297.000 | 1.00x | 127.000 | 512 | 0 |
| leaderboard-100 | 6 | facet | 9876.434 | 9262.524–11131.913 | 2.56x | 20314.000 | 2.45x | 257.000 | 805 | 0 |
| theme-swap-200 | 4 | plain | 58.539 | 52.599–60.794 | 1.00x | 2293.000 | 1.00x | 119.000 | 0 | 0 |
| theme-swap-200 | 4 | facet | 3744.989 | 3649.230–4163.644 | 63.97x | 6942.000 | 3.03x | 430.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 518088.152 | 471854.137–541903.111 | 1.00x | 5936.000 | 1.00x | 152.000 | 60240 | 8040 |
| heavy-screen-20-cycles | 20 | facet | 1169573.501 | 1139101.875–1228784.428 | 2.26x | 9429.000 | 1.59x | 1173.000 | 88260 | 8040 |
| tile-transfer-10 | 21 | plain | 3168.029 | 3126.171–3523.103 | 1.00x | 678.000 | 1.00x | 211.000 | 229 | 25 |
| tile-transfer-10 | 21 | facet | 22109.197 | 20975.515–24064.587 | 6.98x | 3209.000 | 4.73x | 187.000 | 595 | 84 |
| input-type-switch-20 | 20 | plain | 8165.702 | 8031.370–8293.772 | 1.00x | 990.000 | 1.00x | 109.000 | 800 | 200 |
| input-type-switch-20 | 20 | facet | 32092.000 | 31527.513–33094.787 | 3.93x | 3717.000 | 3.75x | 122.000 | 1600 | 200 |
| localized-text-swap-50 | 10 | plain | 2757.982 | 2657.464–2875.281 | 1.00x | 1000.000 | 1.00x | 79.000 | 500 | 0 |
| localized-text-swap-50 | 10 | facet | 20798.896 | 19606.543–22981.399 | 7.54x | 3888.000 | 3.89x | 130.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 71.093 | 67.827–89.698 | 1.00x | 592.000 | 1.00x | 58.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 2460.796 | 2382.859–2536.688 | 34.61x | 3322.000 | 5.61x | 63.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 270.256 | 252.463–283.441 | 1.00x | 408.000 | 1.00x | 113.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 582.951 | 560.299–706.713 | 2.16x | 2489.000 | 6.10x | 214.000 | 20 | 0 |
| hud-composition-step-down | 10 | plain | 368.910 | 358.501–415.558 | 1.00x | 316.000 | 1.00x | 97.000 | 20 | 0 |
| hud-composition-step-down | 10 | facet | 1272.462 | 1218.076–1333.015 | 3.45x | 2226.000 | 7.04x | 145.000 | 50 | 0 |
| gamepad-grid-6x6 | 35 | plain | 60911.599 | 60379.453–61741.771 | 1.00x | 4382.000 | 1.00x | 3299.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 81207.901 | 79721.669–83155.311 | 1.33x | 12481.000 | 2.85x | 4476.000 | 35 | 0 |
| drag-reorder-100 | 20 | plain | 3825.720 | 3665.139–3896.653 | 1.00x | 4612.000 | 1.00x | 117.000 | 420 | 30 |
| drag-reorder-100 | 20 | facet | 26240.326 | 25161.065–27928.987 | 6.86x | 9979.000 | 2.16x | 253.000 | 975 | 134 |
| modal-on-modal | 12 | plain | 15729.688 | 15486.993–16347.704 | 1.00x | 422.000 | 1.00x | 182.000 | 1302 | 163 |
| modal-on-modal | 12 | facet | 36684.564 | 36138.100–38775.658 | 2.33x | 2978.000 | 7.06x | 205.000 | 784 | 137 |
| button-native-scale-50 | 6 | plain | 571.600 | 552.854–602.468 | 1.00x | 1657.000 | 1.00x | 153.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 571.379 | 520.744–611.604 | 1.00x | 4072.000 | 2.46x | 104.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 3.21x | 3.76x |

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
- `radial-8-cycles`: Open a four-command donut radial menu from its launcher, activate Wave and let it close, 8 times, with a checkpoint in the middle of each enter and exit. Both lanes size the inner radius from the launcher with a 96-pixel ring, fit each label box to its sector, catch outside input on a transparent scrim, draw four Path2D sectors and a centre close button, spread the ring out from 0.2 scale with the theme radial timings, highlight the candidate or focused sector, hide the launcher until the exit ends, and add the modal back and radial input contexts.
- `navigation-5-6-cycles`: Push five child pages, then select and activate each page's Back button to pop it, 6 times. Both lanes keep covered pages, show a 44-pixel bar with the destination title (left on the root, centred on child pages) and a Back button with a chevron and label, bind Escape and ButtonB to back, and move focus into the page that becomes top; the root has no Back action.
- `leaderboard-100`: Sort 100 retained player rows by name, replace every score and scroll down, press the Score header twice for ascending and descending order, then replace every score again and let moved rows finish their glide. Checkpoints report rows in motion without their geometry.
- `theme-swap-200`: Swap the content colour on 200 themed buttons and back. Each swap is checked mid-transition and after the theme paint transition settles. Facet updates its theme source; plain sets one colour attribute on its theme StyleSheet.
- `heavy-screen-20-cycles`: Close a scrolling screen of 200 actions and 200 text rows and open a fresh one, 20 times, inside one themed ScreenGui. Each lifetime is laid out for one frame. The theme StyleSheet stays mounted.
- `tile-transfer-10`: Pick up 10 tiles with keyboard activation and drop each into the second grid. Before each pickup the player waits for the previous drop preview to shrink away. Checkpoints alternate between the held state and the moment after the drop; the last one waits for the final preview.
- `input-type-switch-20`: Switch the authored preferred-input fact between keyboard and gamepad on 20 action controls and prompts. This measures adaptation after input detection.
- `localized-text-swap-50`: Swap translated strings on 50 retained labels between English and German. Both lanes use the same LocalizationTable translators and disable automatic localization of translated text.
- `text-size-preference-50`: Change an authored text-size preference across four ranks on a 50-label screen. Facet updates its theme text-size tokens; plain updates one native StyleSheet text-size token that its body rule reads.
- `phone-rotation-hub`: Rotate a retained hub between 390 by 844 and 844 by 390 layout units. Turn its subject, task list and action column without remounting the controls.
- `hud-composition-step-down`: Resize a HUD from 800 to 400 layout units. Keep rich and compact status forms mounted, choose the richest form that fits, pop the new form in and restore the rich form on expansion.
- `gamepad-grid-6x6`: Walk all 36 retained cells of a six by six grid in a snake path. Both hosts send D-pad keys through their input host and check native selection. Facet uses VirtualGrid with its focus scope; plain uses transparent selectable hit buttons over text cells. Both hold Home, End, page and direction keys in priority 200 InputContexts while the grid holds selection.
- `drag-reorder-100`: Drag the first of 100 retained rows after the fifth row, 10 times: odd steps press and move past the 6-pixel threshold, even steps drop. Facet uses VirtualList reorderable and onReorder; plain uses a UIDragDetector per row, a divider drop line, a drag ghost, a priority 400 cancel InputContext and the theme snappy spring for row travel, plus keyboard pick-up, move, drop and cancel. Headless worlds fire the row detector after checking that it is enabled; Studio drags with the real mouse.
- `modal-on-modal`: Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.
- `button-native-scale-50`: Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.
