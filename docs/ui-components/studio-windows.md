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
| Harness revision | `c9a1a50` |
| Facet commit | `237ca75fe1befc8fc102d14a47b847c3a8915686` |
| Facet tree | `5e60969f500b5d6bb694266b71ef478156889832` |
| Date | 2026-11-11 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 4571 | 4361–5023 | 1.00x | 516 | 1.00x | 11 | yes |
| main-menu-cold | 1 | facet | 4634 | 4300–5108 | 1.01x | 602 | 1.17x | 26 | yes |
| hud-60-frames | 60 | plain | 1700 | 1400–1800 | 1.00x | 496 | 1.00x | 0 | yes |
| hud-60-frames | 60 | facet | 3100 | 2900–3800 | 1.82x | 492 | 0.99x | 0 | yes |
| world-markers-50 | 100 | plain | 9046 | 9000–9400 | 1.00x | 637 | 1.00x | 3 | yes |
| world-markers-50 | 100 | facet | 24804 | 21700–31605 | 2.74x | 1186 | 1.86x | 0 | yes |
| inventory-500 | 40 | plain | 6600 | 6100–6700 | 1.00x | 741 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 9021 | 8252–10400 | 1.37x | 8978 | 12.12x | 86 | yes |
| shop-filter-200 | 10 | plain | 1050 | 750–1100 | 1.00x | 513 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 2550 | 2402–3150 | 2.43x | 1712 | 3.34x | 61 | yes |
| virtual-scroll-2000 | 15 | plain | 800 | 700–950 | 1.00x | 636 | 1.00x | 10 | yes |
| virtual-scroll-2000 | 15 | facet | 3570 | 3446–3902 | 4.46x | 1247 | 1.96x | 19 | yes |
| chat-append-250 | 250 | plain | 7800 | 6900–8908 | 1.00x | 790 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 11582 | 11100–13400 | 1.48x | 1324 | 1.68x | 31 | yes |
| card-collection-60 | 1 | plain | 13028 | 11689–13501 | 1.00x | 516 | 1.00x | 3 | yes |
| card-collection-60 | 1 | facet | 48909 | 42700–52177 | 3.75x | 3807 | 7.38x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 600 | 395–730 | 1.00x | 530 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 4020 | 3900–4337 | 6.70x | 6354 | 11.99x | 74 | yes |
| settings-17-values | 17 | plain | 550 | 350–600 | 1.00x | 560 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1200 | 1100–1300 | 2.18x | 1345 | 2.40x | 64 | yes |
| text-input-200 | 200 | plain | 567 | 400–768 | 1.00x | 488 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 893 | 800–1200 | 1.58x | 576 | 1.18x | 5 | yes |
| button-feedback-50 | 15 | plain | 3000 | 1720–3200 | 1.00x | 515 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2800 | 2700–3601 | 0.93x | 783 | 1.52x | 35 | yes |
| stepper-segments-100 | 100 | plain | 500 | 467–533 | 1.00x | 510 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 3400 | 3000–3474 | 6.80x | 676 | 1.33x | 0 | yes |
| toast-stream-4 | 8 | plain | 4503 | 4500–4600 | 1.00x | 506 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 23378 | 21568–24065 | 5.19x | 592 | 1.17x | 18 | yes |
| tabs-5-5-switches | 5 | plain | 1300 | 1200–1700 | 1.00x | 523 | 1.00x | 0 | yes |
| tabs-5-5-switches | 5 | facet | 2900 | 2500–3200 | 2.23x | 1210 | 2.31x | 52 | yes |
| radial-15-cycles | 30 | plain | 31620 | 29793–32389 | 1.00x | 578 | 1.00x | 10 | yes |
| radial-15-cycles | 30 | facet | 213046 | 206298–215878 | 6.74x | 1215 | 2.10x | 66 | yes |
| navigation-5-6-cycles | 60 | plain | 15760 | 15459–16601 | 1.00x | 507 | 1.00x | 2 | yes |
| navigation-5-6-cycles | 60 | facet | 33487 | 30727–34686 | 2.12x | 677 | 1.34x | 45 | yes |
| leaderboard-100 | 3 | plain | 500 | 400–550 | 1.00x | 1484 | 1.00x | 2 | yes |
| leaderboard-100 | 3 | facet | 1600 | 1400–2000 | 3.20x | 8432 | 5.68x | 0 | yes |
| theme-swap-200 | 2 | plain | 900 | 600–1500 | 1.00x | 765 | 1.00x | 748 | yes |
| theme-swap-200 | 2 | facet | 1150 | 800–1300 | 1.28x | 2134 | 2.79x | 186 | yes |
| heavy-screen-20-cycles | 20 | plain | 512587 | 503876–535368 | 1.00x | 2 | 1.00x | 0 | yes |
| heavy-screen-20-cycles | 20 | facet | 693343 | 671605–756158 | 1.35x | 498 | 249.00x | 498 | yes |
| tile-transfer-20 | 20 | plain | 14900 | 14500–15051 | 1.00x | 540 | 1.00x | 1 | yes |
| tile-transfer-20 | 20 | facet | 71725 | 69097–72644 | 4.81x | 1650 | 3.05x | 38 | yes |
| input-type-switch-20 | 20 | plain | 950 | 900–1250 | 1.00x | 572 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 9300 | 8800–9561 | 9.79x | 1072 | 1.87x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 1800 | 1600–1950 | 1.00x | 581 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 3500 | 3200–3600 | 1.94x | 1108 | 1.91x | 0 | yes |
| text-size-preference-50 | 8 | plain | 150 | 100–150 | 1.00x | 430 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 9800 | 8023–11102 | 65.33x | 1174 | 2.73x | 0 | yes |
| phone-rotation-hub | 20 | plain | 439 | 200–800 | 1.00x | 528 | 1.00x | 3 | yes |
| phone-rotation-hub | 20 | facet | 1000 | 700–1200 | 2.28x | 752 | 1.42x | 47 | yes |
| hud-composition-step-down | 20 | plain | 2600 | 2203–3000 | 1.00x | 508 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 14800 | 14404–16802 | 5.69x | 608 | 1.20x | 6 | yes |
| gamepad-grid-6x6 | 35 | plain | 1900 | 1504–3100 | 1.00x | 506 | 1.00x | 3 | yes |
| gamepad-grid-6x6 | 35 | facet | 11342 | 11039–11712 | 5.97x | 1253 | 2.48x | 24 | yes |
| drag-reorder-100 | 20 | plain | 11003 | 10602–11500 | 1.00x | 490 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 124446 | 120681–124679 | 11.31x | 2732 | 5.57x | 32 | yes |
| modal-on-modal | 20 | plain | 14300 | 14201–15090 | 1.00x | 474 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 75119 | 73915–76623 | 5.25x | 958 | 2.02x | 24 | yes |
| button-native-scale-50 | 6 | plain | 1900 | 1600–1947 | 1.00x | 519 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 6223 | 5900–6400 | 3.28x | 996 | 1.92x | 40 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.34x | 30 | 2.73x |
