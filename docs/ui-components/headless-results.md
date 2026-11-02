# UI components headless results

Run date: **2026-11-02 (UTC)**. Harness commit: `2b5799f70843a256f612eae677e181af0d8057f4`. Workflow run: [Library comparison 41375940301](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41375940301). Runner: `ubuntu-latest`. Pins: Facet `5d47e6e`, Compose `6a98c04`, Verify `e704fad`.

The Studio client results in this folder are older than this run. They were measured on 2026-10-31 at Facet `9cb4aec` and Compose `2d03ca1`. Do not compare them with these headless numbers until the Studio rerun is published.

The content below is the `comparison.md` file of the `ui-components-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

# UI components comparison

Harness revision: `2b5799f70843a256f612eae677e181af0d8057f4`. Facet: `5d47e6e5e02b349625e27f7cc3f004852137f8ef`.

Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. When the plain lane takes less than 2 µs per iteration, the engine does its task with almost no Luau work: the table shows plain ≈ 0 instead of a time ratio, the geometric mean leaves that workload out, and the Facet time shows the whole cost. A ratio describes one workload on one host. It does not rank the quality of a library.

Loader fallbacks: none.

| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main-menu-cold | 1 | plain | 24228.938 | 18407.557–46204.701 | 1.00x | 2809.000 | 1.00x | 256.000 | 1432 | 470 |
| main-menu-cold | 1 | facet | 18753.377 | 18213.071–20252.374 | 0.77x | 2903.000 | 1.03x | 259.000 | 1437 | 470 |
| hud-120-frames | 120 | plain | 3107.308 | 2721.042–4108.830 | 1.00x | 2790.000 | 1.00x | 241.000 | 500 | 0 |
| hud-120-frames | 120 | facet | 5825.876 | 5642.181–6597.045 | 1.87x | 2874.000 | 1.03x | 256.000 | 500 | 0 |
| world-markers-50 | 100 | plain | 29160.790 | 28829.007–30759.695 | 1.00x | 4009.000 | 1.00x | 332.000 | 5300 | 0 |
| world-markers-50 | 100 | facet | 57789.553 | 51523.940–100195.639 | 1.98x | 3638.000 | 0.91x | 0.000 | 6379 | 0 |
| inventory-500 | 40 | plain | 273.293 | 259.267–393.679 | 1.00x | 13995.000 | 1.00x | 493.000 | 0 | 0 |
| inventory-500 | 40 | facet | 868.782 | 823.016–1201.167 | 3.18x | 42068.000 | 3.01x | 0.000 | 0 | 0 |
| shop-filter-200 | 10 | plain | 3808.586 | 3619.801–4053.556 | 1.00x | 4402.000 | 1.00x | 318.000 | 2010 | 0 |
| shop-filter-200 | 10 | facet | 5371.953 | 4956.573–5528.608 | 1.41x | 7352.000 | 1.67x | 437.000 | 934 | 14 |
| virtual-scroll-2000 | 50 | plain | 12095.138 | 10037.901–18959.262 | 1.00x | 3037.000 | 1.00x | 216.000 | 2366 | 0 |
| virtual-scroll-2000 | 50 | facet | 32436.679 | 30603.653–39941.367 | 2.68x | 4747.000 | 1.56x | 360.000 | 3251 | 27 |
| chat-append-500 | 500 | plain | 49494.753 | 46684.292–63455.437 | 1.00x | 4351.000 | 1.00x | 515.000 | 5000 | 1000 |
| chat-append-500 | 500 | facet | 117061.104 | 113063.573–153164.364 | 2.37x | 6087.000 | 1.40x | 633.000 | 5500 | 1000 |
| card-collection-60 | 1 | plain | 31502.735 | 30466.338–65151.793 | 1.00x | 5190.000 | 1.00x | 325.000 | 3601 | 1002 |
| card-collection-60 | 1 | facet | 85834.167 | 81024.930–125462.831 | 2.72x | 13742.000 | 2.65x | 605.000 | 5281 | 1422 |
| mixed-scroll-300 | 100 | plain | 692.931 | 571.674–1991.742 | 1.00x | 6984.000 | 1.00x | 460.000 | 100 | 0 |
| mixed-scroll-300 | 100 | facet | 617.079 | 594.096–1702.970 | 0.89x | 19547.000 | 2.80x | 709.000 | 100 | 0 |
| settings-17-values | 17 | plain | 253.115 | 225.153–283.553 | 1.00x | 3353.000 | 1.00x | 344.000 | 25 | 0 |
| settings-17-values | 17 | facet | 1537.669 | 1459.862–2750.417 | 6.07x | 4861.000 | 1.45x | 436.000 | 29 | 0 |
| text-input-200 | 200 | plain | 1167.283 | 1150.322–1191.129 | 1.00x | 2673.000 | 1.00x | 187.000 | 220 | 0 |
| text-input-200 | 200 | facet | 2391.594 | 2004.337–4955.322 | 2.05x | 2809.000 | 1.05x | 219.000 | 220 | 0 |
| button-feedback-50 | 50 | plain | 932.332 | 911.222–964.492 | 1.00x | 3170.000 | 1.00x | 310.000 | 0 | 0 |
| button-feedback-50 | 50 | facet | 948.833 | 931.189–1002.544 | 1.02x | 3803.000 | 1.20x | 328.000 | 0 | 0 |
| stepper-segments-100 | 100 | plain | 1810.652 | 1793.611–1853.303 | 1.00x | 2853.000 | 1.00x | 276.000 | 408 | 0 |
| stepper-segments-100 | 100 | facet | 11124.426 | 9764.470–16098.042 | 6.14x | 3304.000 | 1.16x | 347.000 | 308 | 0 |
| toast-stream-20 | 40 | plain | 5734.226 | 5542.717–7568.584 | 1.00x | 2927.000 | 1.00x | 331.000 | 504 | 141 |
| toast-stream-20 | 40 | facet | 33162.953 | 30686.779–49376.914 | 5.78x | 2957.000 | 1.01x | 391.000 | 1353 | 283 |
| tabs-5-20-switches | 20 | plain | 705.446 | 635.004–839.087 | 1.00x | 2908.000 | 1.00x | 272.000 | 124 | 8 |
| tabs-5-20-switches | 20 | facet | 3199.463 | 3139.890–3411.200 | 4.54x | 3823.000 | 1.31x | 406.000 | 124 | 8 |
| radial-50-cycles | 100 | plain | 134361.401 | 131256.035–166071.337 | 1.00x | 6927.000 | 1.00x | 905.000 | 8250 | 2251 |
| radial-50-cycles | 100 | facet | 1097934.229 | 961181.300–1163414.276 | 8.17x | 3307.000 | 0.48x | 658.000 | 20900 | 3500 |
| navigation-5-20-cycles | 200 | plain | 48406.481 | 46457.268–80287.709 | 1.00x | 3723.000 | 1.00x | 471.000 | 6300 | 1300 |
| navigation-5-20-cycles | 200 | facet | 127637.590 | 109195.540–162662.628 | 2.64x | 3303.000 | 0.89x | 671.000 | 7140 | 1100 |
| leaderboard-100 | 6 | plain | 3735.703 | 3375.415–4697.721 | 1.00x | 8027.000 | 1.00x | 525.000 | 752 | 0 |
| leaderboard-100 | 6 | facet | 16485.001 | 14768.131–38033.710 | 4.41x | 34725.000 | 4.33x | 1259.000 | 952 | 0 |
| theme-swap-200 | 5 | plain | 17.222 | 16.471–37.541 | 1.00x | 6283.000 | 1.00x | 4708.000 | 5 | 0 |
| theme-swap-200 | 5 | facet | 151.986 | 144.021–165.181 | 8.83x | 9966.000 | 1.59x | 966.000 | 0 | 0 |
| heavy-screen-20-cycles | 20 | plain | 929139.128 | 860293.994–998632.080 | 1.00x | 1450.000 | 1.00x | 1417.000 | 79680 | 17260 |
| heavy-screen-20-cycles | 20 | facet | 1628538.763 | 1587279.649–1745814.448 | 1.75x | 5293.000 | 3.65x | 5282.000 | 87700 | 17240 |
| tile-transfer-20 | 20 | plain | 4620.804 | 3718.118–9070.546 | 1.00x | 3443.000 | 1.00x | 404.000 | 283 | 81 |
| tile-transfer-20 | 20 | facet | 18256.549 | 17608.301–26468.792 | 3.95x | 4901.000 | 1.42x | 438.000 | 849 | 104 |
| input-type-switch-20 | 20 | plain | 5852.027 | 5509.203–6184.442 | 1.00x | 3431.000 | 1.00x | 365.000 | 1200 | 0 |
| input-type-switch-20 | 20 | facet | 2775.146 | 2691.618–3764.534 | 0.47x | 4232.000 | 1.23x | 366.000 | 400 | 0 |
| localized-text-swap-50 | 10 | plain | 8109.561 | 7936.045–8756.437 | 1.00x | 3493.000 | 1.00x | 312.000 | 1500 | 0 |
| localized-text-swap-50 | 10 | facet | 15286.760 | 14414.130–20694.914 | 1.89x | 4186.000 | 1.20x | 336.000 | 1500 | 0 |
| text-size-preference-50 | 8 | plain | 14.979 | 13.605–20.308 | plain ≈ 0 | 3094.000 | 1.00x | 295.000 | 0 | 0 |
| text-size-preference-50 | 8 | facet | 624.344 | 487.306–731.956 | plain ≈ 0 | 4553.000 | 1.47x | 336.000 | 0 | 0 |
| phone-rotation-hub | 20 | plain | 263.154 | 229.882–430.629 | 1.00x | 2852.000 | 1.00x | 281.000 | 20 | 0 |
| phone-rotation-hub | 20 | facet | 551.085 | 527.591–562.397 | 2.09x | 3197.000 | 1.12x | 327.000 | 20 | 0 |
| hud-composition-step-down | 20 | plain | 396.546 | 366.990–415.592 | 1.00x | 2733.000 | 1.00x | 219.000 | 40 | 0 |
| hud-composition-step-down | 20 | facet | 3418.856 | 3312.205–3625.685 | 8.62x | 2946.000 | 1.08x | 251.000 | 120 | 0 |
| gamepad-grid-6x6 | 35 | plain | 14.347 | 13.796–15.440 | plain ≈ 0 | 3016.000 | 1.00x | 254.000 | 0 | 0 |
| gamepad-grid-6x6 | 35 | facet | 384.693 | 367.351–414.329 | plain ≈ 0 | 5558.000 | 1.84x | 401.000 | 1 | 0 |
| drag-reorder-100 | 20 | plain | 3419.496 | 3263.052–6823.002 | 1.00x | 4357.000 | 1.00x | 370.000 | 2100 | 0 |
| drag-reorder-100 | 20 | facet | 61910.376 | 60659.965–78169.213 | 18.11x | 20156.000 | 4.63x | 871.000 | 2135 | 504 |
| modal-on-modal | 20 | plain | 8088.462 | 7876.234–8228.796 | 1.00x | 2906.000 | 1.00x | 315.000 | 650 | 121 |
| modal-on-modal | 20 | facet | 59366.274 | 50843.715–65012.446 | 7.34x | 3736.000 | 1.29x | 486.000 | 1089 | 192 |
| button-native-scale-50 | 20 | plain | 681.831 | 649.972–686.991 | 1.00x | 3893.000 | 1.00x | 326.000 | 0 | 0 |
| button-native-scale-50 | 20 | facet | 694.736 | 671.382–734.580 | 1.02x | 4980.000 | 1.28x | 364.000 | 0 | 0 |

## Summary

| Lane | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: |
| plain | 1.00x | 1.00x |
| facet | 2.84x | 1.48x |

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
