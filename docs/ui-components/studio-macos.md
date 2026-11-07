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
| Roblox Studio | 0.746.0.7461269 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `52fcdf8` |
| Facet commit | `763a2a4f2f901a0cde9e0ccd05d5436110d7cb5d` |
| Facet tree | `af3c41897b74084880f09c4858177b6233f51e3f` |
| Date | 2026-11-07 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 15566 | 7401–15781 | 1.00x | 516 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 14578 | 9617–17717 | 0.94x | 633 | 1.23x | 28 | yes |
| hud-60-frames | 60 | plain | 1234 | 815–1608 | 1.00x | 497 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 2630 | 2496–2741 | 2.13x | 496 | 1.00x | 0 | yes |
| world-markers-50 | 100 | plain | 21924 | 20691–22396 | 1.00x | 636 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 48107 | 38040–51379 | 2.19x | 1201 | 1.89x | 0 | yes |
| inventory-500 | 40 | plain | 4535 | 3679–4593 | 1.00x | 738 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 6619 | 6530–7284 | 1.46x | 10690 | 14.50x | 89 | yes |
| shop-filter-200 | 10 | plain | 2252 | 1465–2477 | 1.00x | 521 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 5014 | 4500–7018 | 2.23x | 2653 | 5.09x | 60 | yes |
| virtual-scroll-2000 | 15 | plain | 1008 | 507–1124 | 1.00x | 644 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 5688 | 4415–7080 | 5.64x | 1306 | 2.03x | 19 | yes |
| chat-append-250 | 250 | plain | 23417 | 19930–25767 | 1.00x | 782 | 1.00x | 3 | yes |
| chat-append-250 | 250 | facet | 25457 | 22986–28166 | 1.09x | 1344 | 1.72x | 23 | yes |
| card-collection-60 | 1 | plain | 29360 | 19546–30773 | 1.00x | 517 | 1.00x | 10 | yes |
| card-collection-60 | 1 | facet | 73792 | 62544–77546 | 2.51x | 3918 | 7.58x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 410 | 400–607 | 1.00x | 531 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 4600 | 4281–4811 | 11.22x | 6948 | 13.08x | 60 | yes |
| settings-17-values | 17 | plain | 200 | 100–300 | 1.00x | 560 | 1.00x | 1 | yes |
| settings-17-values | 17 | facet | 1129 | 706–1266 | 5.64x | 1447 | 2.58x | 71 | yes |
| text-input-200 | 200 | plain | 1505 | 1213–2100 | 1.00x | 479 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 2024 | 1600–3100 | 1.34x | 584 | 1.22x | 13 | yes |
| button-feedback-50 | 15 | plain | 1522 | 1200–1934 | 1.00x | 519 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2015 | 1214–2200 | 1.32x | 1010 | 1.95x | 26 | yes |
| stepper-segments-100 | 100 | plain | 1600 | 1413–2103 | 1.00x | 511 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 11608 | 5908–11711 | 7.25x | 716 | 1.40x | 0 | yes |
| toast-stream-4 | 8 | plain | 4140 | 3715–5280 | 1.00x | 500 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 17952 | 12094–18515 | 4.34x | 594 | 1.19x | 25 | yes |
| tabs-5-5-switches | 5 | plain | 1108 | 900–1433 | 1.00x | 524 | 1.00x | 3 | yes |
| tabs-5-5-switches | 5 | facet | 2000 | 1912–2001 | 1.81x | 1224 | 2.34x | 51 | yes |
| radial-15-cycles | 30 | plain | 24839 | 21826–25252 | 1.00x | 580 | 1.00x | 22 | yes |
| radial-15-cycles | 30 | facet | 131133 | 131061–131354 | 5.28x | 1227 | 2.12x | 63 | yes |
| navigation-5-6-cycles | 60 | plain | 13540 | 13459–13876 | 1.00x | 499 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 38229 | 32654–40547 | 2.82x | 686 | 1.37x | 36 | yes |
| leaderboard-100 | 3 | plain | 826 | 800–959 | 1.00x | 1485 | 1.00x | 2 | yes |
| leaderboard-100 | 3 | facet | 3101 | 2115–3403 | 3.75x | 8995 | 6.06x | 0 | yes |
| theme-swap-200 | 2 | plain | 100 | 100–100 | 1.00x | 763 | 1.00x | 746 | yes |
| theme-swap-200 | 2 | facet | 100 | 100–100 | 1.00x | 3283 | 4.30x | 187 | yes |
| heavy-screen-20-cycles | 20 | plain | 414031 | 367067–430040 | 1.00x | 19 | 1.00x | 11 | yes |
| heavy-screen-20-cycles | 20 | facet | 704292 | 666891–712151 | 1.70x | 505 | 26.58x | 497 | yes |
| tile-transfer-20 | 20 | plain | 10651 | 10269–11319 | 1.00x | 542 | 1.00x | 1 | yes |
| tile-transfer-20 | 20 | facet | 41523 | 40267–43129 | 3.90x | 1710 | 3.16x | 37 | yes |
| input-type-switch-20 | 20 | plain | 1337 | 900–1432 | 1.00x | 565 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 12354 | 11345–13230 | 9.24x | 1065 | 1.88x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2569 | 2200–3256 | 1.00x | 581 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 6104 | 4428–6829 | 2.38x | 1141 | 1.96x | 0 | yes |
| text-size-preference-50 | 8 | plain | 207 | 100–318 | 1.00x | 423 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 13929 | 11984–15079 | 67.29x | 1218 | 2.88x | 0 | yes |
| phone-rotation-hub | 20 | plain | 250 | 100–502 | 1.00x | 523 | 1.00x | 3 | yes |
| phone-rotation-hub | 20 | facet | 1200 | 900–1664 | 4.79x | 775 | 1.48x | 47 | yes |
| hud-composition-step-down | 20 | plain | 1625 | 1431–2142 | 1.00x | 498 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 21218 | 20564–21487 | 13.06x | 618 | 1.24x | 6 | yes |
| gamepad-grid-6x6 | 35 | plain | 1100 | 989–1221 | 1.00x | 506 | 1.00x | 7 | yes |
| gamepad-grid-6x6 | 35 | facet | 10851 | 10410–11135 | 9.86x | 1374 | 2.72x | 28 | yes |
| drag-reorder-100 | 20 | plain | 6006 | 5317–7797 | 1.00x | 490 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 74382 | 71007–82375 | 12.38x | 3068 | 6.26x | 34 | yes |
| modal-on-modal | 20 | plain | 10669 | 8404–11154 | 1.00x | 446 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 55067 | 49540–56753 | 5.16x | 960 | 2.16x | 32 | yes |
| button-native-scale-50 | 6 | plain | 737 | 721–901 | 1.00x | 512 | 1.00x | 3 | yes |
| button-native-scale-50 | 6 | facet | 2100 | 2100–2802 | 2.85x | 1163 | 2.27x | 39 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.67x | 30 | 2.75x |
