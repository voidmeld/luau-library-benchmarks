# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D 16-Core Processor           |
| Cores | 32 |
| Memory | 62 GiB |
| Model | Micro-Star International Co., Ltd. MS-7E47 |
| Operating system | Microsoft Windows 11 Pro 10.0.26200 |
| Roblox Studio | 0.747.0.7471481 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `df1056e` |
| Facet commit | `6a6cbbf8f32e1036fc03da477c84b2149640f369` |
| Facet tree | `603903e5da8a8d9ca700c5c3eafe05a0728dc832` |
| Date | 2026-11-11 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 4800 | 4400–5800 | 1.00x | 512 | 1.00x | 3 | yes |
| main-menu-cold | 1 | facet | 4764 | 4500–5200 | 0.99x | 606 | 1.18x | 26 | yes |
| hud-60-frames | 60 | plain | 1700 | 1300–2300 | 1.00x | 508 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 3100 | 2200–3701 | 1.82x | 504 | 0.99x | 0 | yes |
| world-markers-50 | 100 | plain | 9500 | 8395–10411 | 1.00x | 641 | 1.00x | 3 | yes |
| world-markers-50 | 100 | facet | 24343 | 22400–32162 | 2.56x | 1199 | 1.87x | 0 | yes |
| inventory-500 | 40 | plain | 6440 | 6415–7407 | 1.00x | 742 | 1.00x | 1 | yes |
| inventory-500 | 40 | facet | 9300 | 8670–9601 | 1.44x | 7896 | 10.65x | 78 | yes |
| shop-filter-200 | 10 | plain | 950 | 850–1050 | 1.00x | 524 | 1.00x | 10 | yes |
| shop-filter-200 | 10 | facet | 2400 | 2100–2800 | 2.53x | 1689 | 3.22x | 52 | yes |
| virtual-scroll-2000 | 15 | plain | 850 | 800–1000 | 1.00x | 640 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 3650 | 2850–3737 | 4.29x | 1147 | 1.79x | 19 | yes |
| chat-append-250 | 250 | plain | 7805 | 7400–8302 | 1.00x | 777 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 12504 | 9828–18897 | 1.60x | 1336 | 1.72x | 30 | yes |
| card-collection-60 | 1 | plain | 14109 | 13207–14824 | 1.00x | 519 | 1.00x | 10 | yes |
| card-collection-60 | 1 | facet | 48226 | 42909–52964 | 3.42x | 3750 | 7.23x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 501 | 300–700 | 1.00x | 527 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 2900 | 2800–3500 | 5.79x | 6273 | 11.90x | 84 | yes |
| settings-17-values | 17 | plain | 350 | 250–450 | 1.00x | 572 | 1.00x | 3 | yes |
| settings-17-values | 17 | facet | 1300 | 1200–1400 | 3.71x | 1347 | 2.35x | 64 | yes |
| text-input-200 | 200 | plain | 696 | 500–700 | 1.00x | 492 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 733 | 588–967 | 1.05x | 587 | 1.19x | 20 | yes |
| button-feedback-50 | 15 | plain | 2500 | 2000–2900 | 1.00x | 527 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2906 | 2300–3500 | 1.16x | 787 | 1.49x | 30 | yes |
| stepper-segments-100 | 100 | plain | 538 | 500–699 | 1.00x | 506 | 1.00x | 0 | yes |
| stepper-segments-100 | 100 | facet | 3400 | 3300–3620 | 6.32x | 686 | 1.36x | 0 | yes |
| toast-stream-4 | 8 | plain | 4488 | 4400–4600 | 1.00x | 510 | 1.00x | 6 | yes |
| toast-stream-4 | 8 | facet | 22009 | 21279–22503 | 4.90x | 600 | 1.18x | 26 | yes |
| tabs-5-5-switches | 5 | plain | 1100 | 900–1403 | 1.00x | 527 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 2518 | 2400–2800 | 2.29x | 1208 | 2.29x | 52 | yes |
| radial-15-cycles | 30 | plain | 33085 | 31943–33604 | 1.00x | 588 | 1.00x | 6 | yes |
| radial-15-cycles | 30 | facet | 221349 | 212624–224752 | 6.69x | 1194 | 2.03x | 49 | yes |
| navigation-5-6-cycles | 60 | plain | 15500 | 15005–16600 | 1.00x | 518 | 1.00x | 10 | yes |
| navigation-5-6-cycles | 60 | facet | 34227 | 32280–35310 | 2.21x | 684 | 1.32x | 37 | yes |
| leaderboard-100 | 3 | plain | 500 | 450–550 | 1.00x | 1488 | 1.00x | 4 | yes |
| leaderboard-100 | 3 | facet | 1500 | 1200–1900 | 3.00x | 7442 | 5.00x | 0 | yes |
| theme-swap-200 | 2 | plain | 1000 | 500–1200 | 1.00x | 771 | 1.00x | 749 | yes |
| theme-swap-200 | 2 | facet | 950 | 800–1500 | 0.95x | 2145 | 2.78x | 186 | yes |
| heavy-screen-20-cycles | 20 | plain | 526459 | 505170–550013 | 1.00x | 0 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 703788 | 688113–734418 | 1.34x | 498 | 498.00x | 490 | yes |
| tile-transfer-20 | 20 | plain | 14001 | 12600–14100 | 1.00x | 545 | 1.00x | 2 | yes |
| tile-transfer-20 | 20 | facet | 73008 | 71472–73832 | 5.21x | 1696 | 3.11x | 36 | yes |
| input-type-switch-20 | 20 | plain | 800 | 700–1100 | 1.00x | 569 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 9612 | 8742–9800 | 12.02x | 1068 | 1.88x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 1820 | 1596–2150 | 1.00x | 584 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 3488 | 3207–4300 | 1.92x | 1111 | 1.90x | 0 | yes |
| text-size-preference-50 | 8 | plain | 150 | 100–250 | 1.00x | 427 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 8804 | 8307–10300 | 58.69x | 1186 | 2.78x | 0 | yes |
| phone-rotation-hub | 20 | plain | 500 | 400–600 | 1.00x | 525 | 1.00x | 1 | yes |
| phone-rotation-hub | 20 | facet | 1000 | 400–1200 | 2.00x | 746 | 1.42x | 46 | yes |
| hud-composition-step-down | 20 | plain | 2700 | 2300–3500 | 1.00x | 506 | 1.00x | 10 | yes |
| hud-composition-step-down | 20 | facet | 13355 | 11083–15127 | 4.95x | 615 | 1.22x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | 2400 | 2246–2508 | 1.00x | 509 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 12400 | 11558–12939 | 5.17x | 1187 | 2.33x | 32 | yes |
| drag-reorder-100 | 20 | plain | 11683 | 10029–12282 | 1.00x | 498 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 125237 | 122592–125481 | 10.72x | 2534 | 5.09x | 29 | yes |
| modal-on-modal | 20 | plain | 15208 | 15046–16626 | 1.00x | 476 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 82109 | 79100–83322 | 5.40x | 956 | 2.01x | 20 | yes |
| button-native-scale-50 | 6 | plain | 1700 | 1188–2078 | 1.00x | 523 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 6900 | 6900–7225 | 4.06x | 1000 | 1.91x | 37 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.30x | 30 | 2.74x |
