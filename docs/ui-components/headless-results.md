# UI components headless results

Run date: **2026-11-02 (UTC)**. Harness commit: `b27a079d5bf0d62c1d61608cfad172322fa3da45`. Workflow run: [Library comparison 41494833986](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41494833986). Runner: `ubuntu-latest`. Pins: Facet `053b475`, Compose `9d7a963`, Verify `e1ebf16`.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `b27a079d5bf0d62c1d61608cfad172322fa3da45`. Facet: `053b475d628f1a96abc5293247ecd46295688fb1`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 16984.991 | 16311.817–17178.813 | 1.00x | 2409.000 | 1.00x | 276.000 | 1432 | 470 |
| main-menu-cold | 1 | facet | 20666.459 | 17329.721–24766.736 | 1.22x | 2460.000 | 1.02x | 298.000 | 1437 | 470 |
| hud-120-frames | 120 | plain | 2855.359 | 2682.818–3077.573 | 1.00x | 2414.000 | 1.00x | 252.000 | 500 | 0 |
| hud-120-frames | 120 | facet | 4605.519 | 3919.684–15252.043 | 1.61x | 2483.000 | 1.03x | 275.000 | 500 | 0 |
| world-markers-50 | 100 | plain | 28914.399 | 28403.209–31039.792 | 1.00x | 3442.000 | 1.00x | 417.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 71387.714 | 53243.338–90293.769 | 2.47x | 4186.000 | 1.22x | 585.000 | 6353 | 50 |
| inventory-500 | 40 | plain | 321.805 | 285.961–371.210 | 1.00x | 12771.000 | 1.00x | 1022.000 | 0 | 0 |
| inventory-500 | 40 | facet | 825.995 | 792.935–1005.695 | 2.57x | 33905.000 | 2.65x | 5978.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3589.691 | 3499.946–3787.950 | 1.00x | 3737.000 | 1.00x | 531.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 5014.298 | 4600.535–6632.368 | 1.40x | 4997.000 | 1.34x | 1077.000 | 934 | 14 |
| virtual-scroll-2000 | 50 | plain | 10059.872 | 9788.112–11311.958 | 1.00x | 2645.000 | 1.00x | 269.000 | 2366 | 0 |
| virtual-scroll-2000 | 50 | facet | 24726.175 | 22876.858–55592.013 | 2.46x | 3821.000 | 1.44x | 507.000 | 3251 | 27 |
| chat-append-500 | 500 | plain | 42512.971 | 40136.539–54586.246 | 1.00x | 3506.000 | 1.00x | 1536.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 104459.028 | 98876.465–150009.126 | 2.46x | 4965.000 | 1.42x | 2702.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 27648.370 | 26335.522–55540.318 | 1.00x | 4701.000 | 1.00x | 323.000 | 3601 | 1002 |
| card-collection-60 | 1 | facet | 71238.904 | 64943.798–106712.266 | 2.58x | 10281.000 | 2.19x | 1461.000 | 5281 | 1422 |
| mixed-scroll-300 | 100 | plain | 706.134 | 663.920–778.443 | 1.00x | 6228.000 | 1.00x | 577.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 669.860 | 623.580–793.946 | 0.95x | 13683.000 | 2.20x | 2040.000 | 100 | 0 |
| settings-17-values | 17 | plain | 221.054 | 212.010–237.618 | 1.00x | 2821.000 | 1.00x | 369.000 | 25 | 0 |
| settings-17-values | 17 | facet | 843.732 | 745.284–990.022 | 3.82x | 3907.000 | 1.38x | 638.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1186.268 | 1168.792–1227.480 | 1.00x | 2372.000 | 1.00x | 193.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2213.866 | 1825.621–4831.271 | 1.87x | 2438.000 | 1.03x | 256.000 | 220 | 0 |
| button-feedback-50 | 50 | plain | 782.689 | 759.865–839.295 | 1.00x | 2705.000 | 1.00x | 342.000 | 0 | 0 |
| button-feedback-50 | 50 | facet | 836.801 | 813.857–934.458 | 1.07x | 2968.000 | 1.10x | 485.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1703.898 | 1667.763–1735.074 | 1.00x | 2430.000 | 1.00x | 291.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 5959.972 | 5155.079–17176.385 | 3.50x | 2723.000 | 1.12x | 413.000 | 308 | 0 |
| toast-stream-20 | 40 | plain | 6503.371 | 5892.491–16861.361 | 1.00x | 2555.000 | 1.00x | 378.000 | 542 | 141 |
| toast-stream-20 | 40 | facet | 29623.786 | 29249.782–30011.699 | 4.56x | 2427.000 | 0.95x | 621.000 | 1293 | 283 |
| tabs-5-20-switches | 20 | plain | 634.506 | 603.400–804.503 | 1.00x | 2505.000 | 1.00x | 269.000 | 124 | 8 |
| tabs-5-20-switches | 20 | facet | 1968.376 | 1820.043–3970.183 | 3.10x | 3100.000 | 1.24x | 543.000 | 124 | 8 |
| radial-50-cycles | 100 | plain | 82556.486 | 79217.935–132418.851 | 1.00x | 5099.000 | 1.00x | 2310.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 174541.812 | 162357.009–215779.218 | 2.11x | 3204.000 | 0.63x | 1985.000 | 8202 | 1545 |
| navigation-5-20-cycles | 200 | plain | 44763.900 | 39588.520–99543.733 | 1.00x | 3030.000 | 1.00x | 580.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 103554.091 | 87764.706–120236.958 | 2.31x | 2474.000 | 0.82x | 1445.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 3573.085 | 3440.525–4016.052 | 1.00x | 6727.000 | 1.00x | 1160.000 | 752 | 0 |
| leaderboard-100 | 6 | facet | 17922.229 | 14285.108–39838.085 | 5.02x | 25628.000 | 3.81x | 3514.000 | 952 | 0 |
| theme-swap-200 | 5 | plain | 21.893 | 18.227–29.995 | 1.00x | 1366.000 | 1.00x | 4690.000 | 5 | 0 |
| theme-swap-200 | 5 | facet | 115.805 | 100.161–137.858 | 5.29x | 7064.000 | 5.17x | 1557.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 887283.607 | 718704.351–996128.464 | 1.00x | 0.000 | — | 4877.000 | 79680 | 17260 |
| heavy-screen-20-cycles | 20 | facet | 1286323.278 | 1210169.729–1446466.675 | 1.45x | 0.000 | — | 26053.000 | 87700 | 17240 |
| tile-transfer-20 | 20 | plain | 4405.338 | 3990.232–4443.075 | 1.00x | 2903.000 | 1.00x | 413.000 | 487 | 81 |
| tile-transfer-20 | 20 | facet | 18313.297 | 13827.637–23839.948 | 4.16x | 3852.000 | 1.33x | 745.000 | 725 | 44 |
| input-type-switch-20 | 20 | plain | 5810.798 | 5484.877–6069.599 | 1.00x | 2895.000 | 1.00x | 400.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 2772.444 | 2695.638–2787.156 | 0.48x | 3492.000 | 1.21x | 508.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 8614.568 | 8307.565–14000.555 | 1.00x | 2948.000 | 1.00x | 421.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 18557.071 | 12884.200–27119.420 | 2.15x | 3586.000 | 1.22x | 499.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 14.863 | 13.871–24.767 | plain ≈ 0 | 2664.000 | 1.00x | 301.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 24644.884 | 23178.683–27537.077 | plain ≈ 0 | 4380.000 | 1.64x | 545.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 255.164 | 231.950–491.492 | 1.00x | 2457.000 | 1.00x | 262.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 691.253 | 436.008–779.736 | 2.71x | 2645.000 | 1.08x | 365.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 484.401 | 456.618–566.855 | 1.00x | 2400.000 | 1.00x | 209.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 1873.545 | 1799.363–4400.145 | 3.87x | 2529.000 | 1.05x | 275.000 | 80 | 0 |
| gamepad-grid-6x6 | 35 | plain | 14.873 | 14.502–15.543 | plain ≈ 0 | 2612.000 | 1.00x | 271.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 355.496 | 347.744–363.107 | plain ≈ 0 | 4231.000 | 1.62x | 737.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 3364.343 | 3263.221–5077.517 | 1.00x | 3592.000 | 1.00x | 652.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 35318.810 | 33096.129–46560.303 | 10.50x | 12669.000 | 3.53x | 2607.000 | 1775 | 264 |
| modal-on-modal | 20 | plain | 7451.004 | 7131.242–9684.661 | 1.00x | 2448.000 | 1.00x | 422.000 | 610 | 121 |
| modal-on-modal | 20 | facet | 42744.535 | 32711.789–55470.452 | 5.74x | 2944.000 | 1.20x | 795.000 | 1009 | 192 |
| button-native-scale-50 | 20 | plain | 665.184 | 655.369–673.195 | 1.00x | 3380.000 | 1.00x | 376.000 | 0 | 0 |
| button-native-scale-50 | 20 | facet | 691.533 | 666.304–734.878 | 1.04x | 3731.000 | 1.10x | 635.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 2.41x | 1.42x |

## Workloads

- `main-menu-cold`: Mount a background, title, six actions and footer; runtime and control-factory setup is excluded.
- `hud-120-frames`: Update health fill, ammo, currency and timer once per simulated frame.
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
- `radial-50-cycles`: Open a four-command radial menu, select Wave and close it, 50 times. Both lanes draw four Path2D ring sectors, a centre close button, a selection preview, a scrim, gamepad and keyboard input contexts and the theme radial fade, and hide the launcher while the menu is open. Both lanes put the launcher at the screen centre, so the ring opens around it.
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
