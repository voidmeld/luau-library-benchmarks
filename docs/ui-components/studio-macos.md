# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | Apple M2 Max |
| Cores | 12 |
| Memory | 32 GiB |
| Model | Mac14,13 |
| Operating system | macOS 27.0 |
| Roblox Studio | 0.745.0.7451137 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `9095265` |
| Facet commit | `517628c72ef3187ee2eb8485a7f9387482331eaf` |
| Facet tree | `7043fb2a21556d8a718771873c2399caa664ce7c` |
| Date | 2026-11-04 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 12402 | 8152–13187 | 1.00x | 489 | 1.00x | 10 | yes |
| main-menu-cold | 1 | facet | 15061 | 8716–16244 | 1.21x | 597 | 1.22x | 27 | yes |
| hud-60-frames | 60 | plain | 1570 | 1351–1835 | 1.00x | 480 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 2114 | 2006–2250 | 1.35x | 570 | 1.19x | 18 | yes |
| world-markers-50 | 100 | plain | 19960 | 14413–21907 | 1.00x | 613 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 41499 | 35328–43712 | 2.08x | 1012 | 1.65x | 0 | yes |
| inventory-500 | 40 | plain | 4058 | 3549–4351 | 1.00x | 708 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 8903 | 7346–9439 | 2.19x | 15215 | 21.47x | 26 | yes |
| shop-filter-200 | 10 | plain | 1904 | 1705–2509 | 1.00x | 496 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 4954 | 4327–5942 | 2.60x | 1898 | 3.83x | 52 | yes |
| virtual-scroll-2000 | 15 | plain | 1001 | 647–1305 | 1.00x | 604 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 6756 | 6606–7415 | 6.75x | 1291 | 2.14x | 0 | yes |
| chat-append-250 | 250 | plain | 20161 | 15368–22182 | 1.00x | 756 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 27617 | 23061–27804 | 1.37x | 1751 | 2.32x | 0 | yes |
| card-collection-60 | 1 | plain | 24342 | 17631–26569 | 1.00x | 490 | 1.00x | 3 | yes |
| card-collection-60 | 1 | facet | 65506 | 50615–67146 | 2.69x | 4578 | 9.34x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 500 | 500–714 | 1.00x | 496 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 2913 | 2770–3013 | 5.83x | 8047 | 16.22x | 152 | yes |
| settings-17-values | 17 | plain | 217 | 100–300 | 1.00x | 534 | 1.00x | 0 | yes |
| settings-17-values | 17 | facet | 1528 | 1100–1903 | 7.04x | 1514 | 2.84x | 81 | yes |
| text-input-200 | 200 | plain | 1900 | 1200–2345 | 1.00x | 456 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 2303 | 1800–2609 | 1.21x | 554 | 1.21x | 13 | yes |
| button-feedback-50 | 15 | plain | 1525 | 1500–1932 | 1.00x | 490 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2034 | 1959–2427 | 1.33x | 813 | 1.66x | 22 | yes |
| stepper-segments-100 | 100 | plain | 1911 | 1200–2007 | 1.00x | 493 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 9649 | 8159–10727 | 5.05x | 659 | 1.34x | 0 | yes |
| toast-stream-4 | 8 | plain | 3364 | 3261–3893 | 1.00x | 474 | 1.00x | 0 | yes |
| toast-stream-4 | 8 | facet | 17849 | 14672–19137 | 5.31x | 564 | 1.19x | 28 | yes |
| tabs-5-5-switches | 5 | plain | 1400 | 802–1615 | 1.00x | 497 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 2695 | 2300–3107 | 1.93x | 1091 | 2.20x | 0 | yes |
| radial-15-cycles | 30 | plain | 23549 | 22043–24443 | 1.00x | 539 | 1.00x | 12 | yes |
| radial-15-cycles | 30 | facet | 131522 | 124783–136744 | 5.59x | 1169 | 2.17x | 74 | yes |
| navigation-5-6-cycles | 60 | plain | 14115 | 12813–17454 | 1.00x | 489 | 1.00x | 3 | yes |
| navigation-5-6-cycles | 60 | facet | 36804 | 33631–38711 | 2.61x | 682 | 1.39x | 55 | yes |
| leaderboard-100 | 3 | plain | 1000 | 800–1003 | 1.00x | 1451 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 4510 | 3938–5203 | 4.51x | 11920 | 8.22x | 0 | yes |
| theme-swap-200 | 2 | plain | 100 | 100–300 | 1.00x | 725 | 1.00x | 708 | yes |
| theme-swap-200 | 2 | facet | 100 | 100–200 | 1.00x | 2550 | 3.52x | 182 | yes |
| heavy-screen-20-cycles | 20 | plain | 370741 | 364816–391677 | 1.00x | 11 | 1.00x | 10 | yes |
| heavy-screen-20-cycles | 20 | facet | 530774 | 523835–553216 | 1.43x | 498 | 45.27x | 497 | yes |
| tile-transfer-20 | 20 | plain | 11155 | 10815–11885 | 1.00x | 510 | 1.00x | 0 | yes |
| tile-transfer-20 | 20 | facet | 45271 | 44760–46101 | 4.06x | 1547 | 3.03x | 40 | yes |
| input-type-switch-20 | 20 | plain | 1307 | 987–1408 | 1.00x | 539 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 3321 | 3137–4209 | 2.54x | 1073 | 1.99x | 9 | yes |
| localized-text-swap-50 | 10 | plain | 2700 | 2100–2800 | 1.00x | 562 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 4502 | 4058–5486 | 1.67x | 1248 | 2.22x | 20 | yes |
| text-size-preference-50 | 8 | plain | 100 | 100–200 | 1.00x | 412 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 10103 | 9034–10816 | 101.03x | 1406 | 3.41x | 9 | yes |
| phone-rotation-hub | 20 | plain | 500 | 355–613 | 1.00x | 496 | 1.00x | 3 | yes |
| phone-rotation-hub | 20 | facet | 1064 | 900–1303 | 2.13x | 733 | 1.48x | 39 | yes |
| hud-composition-step-down | 20 | plain | 1576 | 1408–2013 | 1.00x | 473 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 24891 | 22785–24955 | 15.79x | 594 | 1.25x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | 1110 | 867–1909 | 1.00x | 484 | 1.00x | 6 | yes |
| gamepad-grid-6x6 | 35 | facet | 12506 | 10900–13111 | 11.27x | 1566 | 3.24x | 4 | yes |
| drag-reorder-100 | 20 | plain | 7756 | 6679–7968 | 1.00x | 472 | 1.00x | 6 | yes |
| drag-reorder-100 | 20 | facet | 79791 | 77822–83986 | 10.29x | 2985 | 6.33x | 72 | yes |
| modal-on-modal | 20 | plain | 10536 | 9639–11186 | 1.00x | 425 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 55777 | 51673–56639 | 5.29x | 908 | 2.14x | 46 | yes |
| button-native-scale-50 | 6 | plain | 711 | 643–1117 | 1.00x | 485 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 3800 | 3735–3883 | 5.34x | 1580 | 3.26x | 44 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.54x | 30 | 2.96x |
