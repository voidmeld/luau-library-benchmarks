# UI components comparison

Harness revision: `fc55a3bc5a39dd9ddc1915e35e583f7e1ceb58e8`. Facet: `9dc3bdb6e1afd76dfd86a5427da140d41defc78a`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Each lane builds its theme StyleSheet at mount, so cold mounts and complete lifetimes include that setup cost in each lane. Parity compares the observable result of both lanes. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 1828.652 | 1712.589–1946.916 | 1.00x | 340.000 | 1.00x | 116.000 | 155 | 42 |
| main-menu-cold | 1 | facet | 16322.371 | 15429.097–16932.946 | 8.93x | 2096.000 | 6.16x | 148.000 | 1500 | 487 |
| hud-60-frames | 60 | plain | 1072.670 | 1053.562–1251.375 | 1.00x | 352.000 | 1.00x | 130.000 | 243 | 0 |
| hud-60-frames | 60 | facet | 2244.508 | 2158.651–2332.939 | 2.09x | 2137.000 | 6.07x | 144.000 | 254 | 0 |
| world-markers-50 | 100 | plain | 16717.469 | 16372.277–17314.534 | 1.00x | 1960.000 | 1.00x | 198.000 | 5150 | 0 |
| world-markers-50 | 100 | facet | 64105.948 | 62403.864–71503.918 | 3.83x | 5126.000 | 2.62x | 117.000 | 6255 | 1 |
| inventory-500 | 40 | plain | 378.511 | 361.846–400.895 | 1.00x | 11475.000 | 1.00x | 153.000 | 0 | 0 |
| inventory-500 | 40 | facet | 940.344 | 807.287–971.570 | 2.48x | 25601.000 | 2.23x | 240.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3130.232 | 3029.472–3227.656 | 1.00x | 2355.000 | 1.00x | 167.000 | 1033 | 0 |
| shop-filter-200 | 10 | facet | 7481.204 | 7282.018–7809.631 | 2.39x | 6050.000 | 2.57x | 153.000 | 934 | 14 |
| virtual-scroll-2000 | 15 | plain | 3516.094 | 3320.624–3614.710 | 1.00x | 574.000 | 1.00x | 67.000 | 1136 | 0 |
| virtual-scroll-2000 | 15 | facet | 6928.621 | 6388.548–7189.709 | 1.97x | 3167.000 | 5.52x | 156.000 | 980 | 9 |
| chat-append-250 | 250 | plain | 15927.663 | 15507.170–16403.828 | 1.00x | 1140.000 | 1.00x | 141.000 | 2250 | 250 |
| chat-append-250 | 250 | facet | 45341.131 | 43537.946–47402.407 | 2.85x | 4065.000 | 3.57x | 52.000 | 3800 | 250 |
| card-collection-60 | 1 | plain | 27124.132 | 26144.460–28324.342 | 1.00x | 4377.000 | 1.00x | 149.000 | 3611 | 782 |
| card-collection-60 | 1 | facet | 75303.209 | 74352.099–76618.850 | 2.78x | 11515.000 | 2.63x | 106.000 | 4269 | 1082 |
| mixed-scroll-300 | 50 | plain | 319.614 | 273.606–338.171 | 1.00x | 6617.000 | 1.00x | 108.000 | 50 | 0 |
| mixed-scroll-300 | 50 | facet | 299.114 | 287.016–412.121 | 0.94x | 16859.000 | 2.55x | 249.000 | 50 | 0 |
| settings-17-values | 17 | plain | 1091.529 | 1007.815–1171.208 | 1.00x | 1774.000 | 1.00x | 214.000 | 53 | 4 |
| settings-17-values | 17 | facet | 2617.173 | 2551.524–2810.479 | 2.40x | 3822.000 | 2.15x | 216.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1078.188 | 1034.443–1096.926 | 1.00x | 323.000 | 1.00x | 100.000 | 225 | 0 |
| text-input-200 | 200 | facet | 1668.293 | 1589.205–1717.045 | 1.55x | 2052.000 | 6.35x | 63.000 | 225 | 0 |
| button-feedback-50 | 15 | plain | 575.554 | 549.175–600.651 | 1.00x | 758.000 | 1.00x | 120.000 | 0 | 0 |
| button-feedback-50 | 15 | facet | 572.219 | 560.221–621.661 | 0.99x | 2887.000 | 3.81x | 94.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 2126.604 | 2081.277–2200.113 | 1.00x | 716.000 | 1.00x | 208.000 | 308 | 1 |
| stepper-segments-100 | 100 | facet | 8267.230 | 8115.396–8612.482 | 3.89x | 2659.000 | 3.71x | 250.000 | 304 | 0 |
| toast-stream-4 | 8 | plain | 2728.733 | 2631.478–2886.937 | 1.00x | 421.000 | 1.00x | 163.000 | 211 | 52 |
| toast-stream-4 | 8 | facet | 6569.413 | 6360.243–7602.073 | 2.41x | 2151.000 | 5.11x | 180.000 | 269 | 59 |
| tabs-5-5-switches | 5 | plain | 755.953 | 732.268–782.222 | 1.00x | 559.000 | 1.00x | 170.000 | 68 | 8 |
| tabs-5-5-switches | 5 | facet | 3059.706 | 2793.490–3835.749 | 4.05x | 3080.000 | 5.51x | 176.000 | 80 | 8 |
| radial-15-cycles | 60 | plain | 47357.877 | 45946.584–49866.888 | 1.00x | 3091.000 | 1.00x | 186.000 | 4386 | 781 |
| radial-15-cycles | 60 | facet | 78292.051 | 75799.394–80687.174 | 1.65x | 3346.000 | 1.08x | 337.000 | 3114 | 512 |
| navigation-5-6-cycles | 60 | plain | 21238.338 | 20470.820–22026.978 | 1.00x | 409.000 | 1.00x | 204.000 | 2070 | 360 |
| navigation-5-6-cycles | 60 | facet | 39123.935 | 38602.942–40630.128 | 1.84x | 2403.000 | 5.88x | 198.000 | 2364 | 360 |
| leaderboard-100 | 6 | plain | 4017.237 | 3822.199–4440.906 | 1.00x | 8337.000 | 1.00x | 159.000 | 512 | 0 |
| leaderboard-100 | 6 | facet | 9430.555 | 8940.469–9988.693 | 2.35x | 20352.000 | 2.44x | 210.000 | 805 | 0 |
| theme-swap-200 | 4 | plain | 55.232 | 48.763–77.205 | 1.00x | 2245.000 | 1.00x | 135.000 | 0 | 0 |
| theme-swap-200 | 4 | facet | 3835.236 | 3645.925–4343.189 | 69.44x | 6881.000 | 3.07x | 382.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 406252.072 | 371958.979–455162.915 | 1.00x | 5896.000 | 1.00x | 161.000 | 60240 | 8040 |
| heavy-screen-20-cycles | 20 | facet | 972813.912 | 925095.069–999194.131 | 2.39x | 8949.000 | 1.52x | 685.000 | 88260 | 8040 |
| tile-transfer-20 | 41 | plain | 4581.275 | 4378.234–5723.910 | 1.00x | 929.000 | 1.00x | 227.000 | 439 | 45 |
| tile-transfer-20 | 41 | facet | 39827.474 | 37693.879–41718.729 | 8.69x | 3989.000 | 4.29x | 167.000 | 1175 | 164 |
| input-type-switch-20 | 20 | plain | 6359.123 | 6261.989–6767.629 | 1.00x | 994.000 | 1.00x | 146.000 | 801 | 200 |
| input-type-switch-20 | 20 | facet | 26713.755 | 25642.447–27929.218 | 4.20x | 3621.000 | 3.64x | 89.000 | 1600 | 200 |
| localized-text-swap-50 | 10 | plain | 2929.126 | 2745.713–3040.281 | 1.00x | 1091.000 | 1.00x | 167.000 | 550 | 0 |
| localized-text-swap-50 | 10 | facet | 17101.371 | 16649.661–17891.354 | 5.84x | 3793.000 | 3.48x | 107.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 70.625 | 68.922–83.904 | 1.00x | 575.000 | 1.00x | 98.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 1987.508 | 1932.447–2078.814 | 28.14x | 3314.000 | 5.76x | 117.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 309.479 | 266.004–329.709 | 1.00x | 384.000 | 1.00x | 90.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 602.263 | 562.605–735.000 | 1.95x | 2441.000 | 6.36x | 223.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 643.805 | 626.960–696.703 | 1.00x | 332.000 | 1.00x | 113.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 1972.756 | 1833.559–2050.281 | 3.06x | 2161.000 | 6.51x | 152.000 | 100 | 0 |
| gamepad-grid-6x6 | 35 | plain | 57329.728 | 56375.614–58873.007 | 1.00x | 4389.000 | 1.00x | 3274.000 | 35 | 0 |
| gamepad-grid-6x6 | 35 | facet | 76101.447 | 75393.868–77908.326 | 1.33x | 12420.000 | 2.83x | 4446.000 | 35 | 0 |
| drag-reorder-100 | 40 | plain | 6003.334 | 5776.738–6717.534 | 1.00x | 4763.000 | 1.00x | 165.000 | 840 | 60 |
| drag-reorder-100 | 40 | facet | 48173.182 | 47432.143–49180.696 | 8.02x | 10515.000 | 2.21x | 196.000 | 1935 | 264 |
| modal-on-modal | 20 | plain | 22745.752 | 21747.691–23258.202 | 1.00x | 434.000 | 1.00x | 246.000 | 2170 | 271 |
| modal-on-modal | 20 | facet | 56503.301 | 53050.910–58701.178 | 2.48x | 2944.000 | 6.78x | 205.000 | 1206 | 205 |
| button-native-scale-50 | 6 | plain | 540.894 | 510.919–573.403 | 1.00x | 1609.000 | 1.00x | 89.000 | 0 | 0 |
| button-native-scale-50 | 6 | facet | 514.265 | 490.750–523.719 | 0.95x | 4008.000 | 2.49x | 176.000 | 0 | 0 |

## Summary

| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x |
| facet | 30 | 3.15x | 3.58x |

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
