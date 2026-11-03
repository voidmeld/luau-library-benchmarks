# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, in KiB. Teardown is the median retained heap after release. Both use the Verify `gc-witness-low-water/2` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | Apple M2 Max |
| Cores | 12 |
| Memory | 32 GiB |
| Model | Mac14,13 |
| Operating system | macOS 27.0 |
| Roblox Studio | 0.745.0.7451137 |
| Context | client |
| Harness revision | `28ac21c` |
| Facet commit | `053b475d628f1a96abc5293247ecd46295688fb1` |
| Facet tree | `42054c606ee5f7d27365b94aa441664a311e9303` |
| Date | 2026-11-03 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 6500 | 6118–8405 | 1.00x | 516 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 20867 | 16890–22756 | 3.21x | 599 | 1.16x | 26 | yes |
| hud-60-frames | 60 | plain | 1521 | 1152–2402 | 1.00x | 502 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 1203 | 1001–1600 | 0.79x | 567 | 1.13x | 18 | yes |
| world-markers-50 | 100 | plain | 32221 | 23966–33614 | 1.00x | 627 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 39535 | 22925–51749 | 1.23x | 1332 | 2.12x | 25 | yes |
| inventory-500 | 40 | plain | 4098 | 3713–4993 | 1.00x | 757 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 8817 | 7713–9717 | 2.15x | 18538 | 24.49x | 164 | yes |
| shop-filter-200 | 10 | plain | 1710 | 1306–1862 | 1.00x | 504 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 6156 | 4413–7329 | 3.60x | 1883 | 3.74x | 57 | yes |
| virtual-scroll-2000 | 15 | plain | 1613 | 1300–1633 | 1.00x | 609 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 7013 | 6324–8015 | 4.35x | 1487 | 2.44x | 20 | yes |
| chat-append-250 | 250 | plain | 18261 | 17438–18643 | 1.00x | 740 | 1.00x | 2 | yes |
| chat-append-250 | 250 | facet | 31807 | 26936–33224 | 1.74x | 2363 | 3.19x | 46 | yes |
| card-collection-60 | 1 | plain | 24421 | 18354–25268 | 1.00x | 492 | 1.00x | 3 | yes |
| card-collection-60 | 1 | facet | 71766 | 70212–76889 | 2.94x | 5447 | 11.07x | 121 | yes |
| mixed-scroll-300 | 50 | plain | 300 | 100–424 | 1.00x | 509 | 1.00x | 10 | yes |
| mixed-scroll-300 | 50 | facet | 400 | 300–516 | 1.33x | 7964 | 15.65x | 148 | yes |
| settings-17-values | 17 | plain | 301 | 100–414 | 1.00x | 549 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 612 | 400–804 | 2.03x | 1464 | 2.67x | 74 | yes |
| text-input-200 | 200 | plain | 1403 | 607–1427 | 1.00x | 470 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 1901 | 1200–3007 | 1.35x | 551 | 1.17x | 13 | yes |
| button-feedback-50 | 15 | plain | 1508 | 900–2524 | 1.00x | 506 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 1736 | 1406–1902 | 1.15x | 796 | 1.57x | 33 | yes |
| stepper-segments-100 | 100 | plain | 3010 | 0–3119 | 1.00x | 494 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 9812 | 7449–10742 | 3.26x | 785 | 1.59x | 51 | yes |
| toast-stream-4 | 8 | plain | 12378 | 7615–13057 | 1.00x | 504 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 13821 | 11423–15540 | 1.12x | 537 | 1.07x | 36 | yes |
| tabs-5-5-switches | 5 | plain | 1006 | 701–1415 | 1.00x | 516 | 1.00x | 1 | yes |
| tabs-5-5-switches | 5 | facet | 1903 | 1803–2301 | 1.89x | 1193 | 2.31x | 53 | yes |
| radial-15-cycles | 30 | plain | 48127 | 42390–49690 | 1.00x | 624 | 1.00x | 0 | yes |
| radial-15-cycles | 30 | facet | 43116 | 42693–43965 | 0.90x | 1132 | 1.81x | 79 | yes |
| navigation-5-6-cycles | 60 | plain | 12548 | 12169–13079 | 1.00x | 481 | 1.00x | 2 | yes |
| navigation-5-6-cycles | 60 | facet | 44616 | 38354–44783 | 3.56x | 645 | 1.34x | 60 | yes |
| leaderboard-100 | 3 | plain | 1406 | 1215–1531 | 1.00x | 1431 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 2904 | 2501–3328 | 2.07x | 13891 | 9.71x | 230 | yes |
| theme-swap-200 | 2 | plain | 100 | 0–449 | 1.00x | 17 | 1.00x | 708 | yes |
| theme-swap-200 | 2 | facet | 200 | 0–402 | 2.00x | 3372 | 198.35x | 187 | yes |
| heavy-screen-20-cycles | 20 | plain | 449452 | 441267–482246 | 1.00x | 8 | 1.00x | 3 | yes |
| heavy-screen-20-cycles | 20 | facet | 516213 | 486142–535622 | 1.15x | 0 | 0.00x | 505 | yes |
| tile-transfer-20 | 20 | plain | 9675 | 8838–10465 | 1.00x | 470 | 1.00x | 2 | yes |
| tile-transfer-20 | 20 | facet | 48289 | 45335–51728 | 4.99x | 1489 | 3.16x | 38 | yes |
| input-type-switch-20 | 20 | plain | 2559 | 2216–2854 | 1.00x | 486 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 935 | 500–1605 | 0.37x | 1019 | 2.10x | 10 | yes |
| localized-text-swap-50 | 10 | plain | 4420 | 3521–4933 | 1.00x | 554 | 1.00x | 3 | yes |
| localized-text-swap-50 | 10 | facet | 6410 | 5400–7432 | 1.45x | 1226 | 2.21x | 27 | yes |
| text-size-preference-50 | 8 | plain | 106 | 100–300 | 1.00x | 411 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 18022 | 16758–19328 | 170.02x | 1373 | 3.34x | 5 | yes |
| phone-rotation-hub | 20 | plain | 304 | 100–611 | 1.00x | 449 | 1.00x | 11 | yes |
| phone-rotation-hub | 20 | facet | 1004 | 806–1732 | 3.30x | 645 | 1.44x | 39 | yes |
| hud-composition-step-down | 20 | plain | 1816 | 1521–2005 | 1.00x | 491 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 1426 | 1110–2009 | 0.79x | 642 | 1.31x | 13 | yes |
| gamepad-grid-6x6 | 35 | plain | 806 | 704–1359 | 1.00x | 479 | 1.00x | 10 | yes |
| gamepad-grid-6x6 | 35 | facet | 3711 | 3500–4026 | 4.60x | 1972 | 4.12x | 57 | yes |
| drag-reorder-100 | 20 | plain | 6068 | 5740–6440 | 1.00x | 474 | 1.00x | 6 | yes |
| drag-reorder-100 | 20 | facet | 8935 | 7400–9231 | 1.47x | 3208 | 6.77x | 72 | yes |
| modal-on-modal | 20 | plain | 7892 | 7127–8239 | 1.00x | 517 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 59879 | 55716–62496 | 7.59x | 943 | 1.82x | 66 | yes |
| button-native-scale-50 | 6 | plain | 818 | 707–1013 | 1.00x | 511 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 800 | 620–1039 | 0.98x | 1574 | 3.08x | 44 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 29 | 1.00x |
| facet | 30 | 2.18x | 29 | 3.20x |
