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
| Roblox Studio | 0.745.449.7450003 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `a07c78b` |
| Facet commit | `643da0c3c26994e60c177453959cd853361ef0e9` |
| Facet tree | `d6e603faf61168f08e05e3c583e8816db486d948` |
| Date | 2026-11-03 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 7400 | 6500–8516 | 1.00x | 510 | 1.00x | 4 | yes |
| main-menu-cold | 1 | facet | 7247 | 6413–9300 | 0.98x | 616 | 1.21x | 25 | yes |
| hud-60-frames | 60 | plain | 1500 | 1100–1800 | 1.00x | 497 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 2804 | 2300–3111 | 1.87x | 578 | 1.16x | 19 | yes |
| world-markers-50 | 100 | plain | 9000 | 8500–10773 | 1.00x | 621 | 1.00x | 0 | yes |
| world-markers-50 | 100 | facet | 23100 | 22300–32207 | 2.57x | 1357 | 2.19x | 25 | yes |
| inventory-500 | 40 | plain | 6600 | 5800–7803 | 1.00x | 710 | 1.00x | 1 | yes |
| inventory-500 | 40 | facet | 12102 | 10976–12430 | 1.83x | 15776 | 22.22x | 156 | yes |
| shop-filter-200 | 10 | plain | 1012 | 850–1250 | 1.00x | 498 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 3000 | 2600–3100 | 2.96x | 1926 | 3.87x | 52 | yes |
| virtual-scroll-2000 | 15 | plain | 800 | 750–1150 | 1.00x | 614 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 5000 | 4400–5400 | 6.25x | 1449 | 2.36x | 21 | yes |
| chat-append-250 | 250 | plain | 11400 | 8211–12021 | 1.00x | 758 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 16500 | 13504–17782 | 1.45x | 2393 | 3.16x | 38 | yes |
| card-collection-60 | 1 | plain | 15561 | 15300–15588 | 1.00x | 485 | 1.00x | 2 | yes |
| card-collection-60 | 1 | facet | 45349 | 38404–48200 | 2.91x | 5521 | 11.38x | 112 | yes |
| mixed-scroll-300 | 50 | plain | 700 | 200–743 | 1.00x | 503 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 2656 | 1800–2901 | 3.79x | 8072 | 16.05x | 153 | yes |
| settings-17-values | 17 | plain | 550 | 350–850 | 1.00x | 537 | 1.00x | 1 | yes |
| settings-17-values | 17 | facet | 1600 | 1255–1615 | 2.91x | 1537 | 2.86x | 73 | yes |
| text-input-200 | 200 | plain | 533 | 467–700 | 1.00x | 448 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 800 | 633–938 | 1.50x | 556 | 1.24x | 13 | yes |
| button-feedback-50 | 15 | plain | 2200 | 2200–2900 | 1.00x | 507 | 1.00x | 1 | yes |
| button-feedback-50 | 15 | facet | 2600 | 2400–3000 | 1.18x | 820 | 1.62x | 26 | yes |
| stepper-segments-100 | 100 | plain | 467 | 433–533 | 1.00x | 489 | 1.00x | 3 | yes |
| stepper-segments-100 | 100 | facet | 3509 | 2800–4000 | 7.52x | 829 | 1.70x | 51 | yes |
| toast-stream-4 | 8 | plain | 7500 | 6800–7875 | 1.00x | 486 | 1.00x | 6 | yes |
| toast-stream-4 | 8 | facet | 21283 | 21101–22232 | 2.84x | 569 | 1.17x | 28 | yes |
| tabs-5-5-switches | 5 | plain | 1600 | 1300–1900 | 1.00x | 511 | 1.00x | 3 | yes |
| tabs-5-5-switches | 5 | facet | 4000 | 3500–5900 | 2.50x | 1237 | 2.42x | 53 | yes |
| radial-15-cycles | 30 | plain | 41862 | 39828–44500 | 1.00x | 594 | 1.00x | 0 | yes |
| radial-15-cycles | 30 | facet | 253414 | 250810–253829 | 6.05x | 1214 | 2.04x | 74 | yes |
| navigation-5-6-cycles | 60 | plain | 16700 | 16200–18400 | 1.00x | 483 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 36028 | 34942–37704 | 2.16x | 692 | 1.43x | 62 | yes |
| leaderboard-100 | 3 | plain | 450 | 400–700 | 1.00x | 1459 | 1.00x | 10 | yes |
| leaderboard-100 | 3 | facet | 2100 | 1700–2700 | 4.67x | 13440 | 9.21x | 229 | yes |
| theme-swap-200 | 2 | plain | 600 | 400–700 | 1.00x | 730 | 1.00x | 712 | yes |
| theme-swap-200 | 2 | facet | 950 | 700–1100 | 1.58x | 2557 | 3.50x | 174 | yes |
| heavy-screen-20-cycles | 20 | plain | 573345 | 566118–593475 | 1.00x | 3 | 1.00x | 0 | yes |
| heavy-screen-20-cycles | 20 | facet | 776529 | 745878–808086 | 1.35x | 506 | 168.67x | 498 | yes |
| tile-transfer-20 | 20 | plain | 14503 | 13800–16383 | 1.00x | 472 | 1.00x | 6 | yes |
| tile-transfer-20 | 20 | facet | 77932 | 73305–78472 | 5.37x | 1588 | 3.36x | 42 | yes |
| input-type-switch-20 | 20 | plain | 1050 | 900–1200 | 1.00x | 490 | 1.00x | 1 | yes |
| input-type-switch-20 | 20 | facet | 3700 | 3200–4300 | 3.52x | 1028 | 2.10x | 9 | yes |
| localized-text-swap-50 | 10 | plain | 1800 | 1700–2085 | 1.00x | 562 | 1.00x | 1 | yes |
| localized-text-swap-50 | 10 | facet | 4627 | 3800–5391 | 2.57x | 1248 | 2.22x | 28 | yes |
| text-size-preference-50 | 8 | plain | 150 | 100–200 | 1.00x | 413 | 1.00x | 3 | yes |
| text-size-preference-50 | 8 | facet | 17500 | 16100–20178 | 116.67x | 1392 | 3.37x | 18 | yes |
| phone-rotation-hub | 20 | plain | 400 | 200–900 | 1.00x | 452 | 1.00x | 9 | yes |
| phone-rotation-hub | 20 | facet | 800 | 500–900 | 2.00x | 684 | 1.51x | 39 | yes |
| hud-composition-step-down | 20 | plain | 2200 | 1875–3212 | 1.00x | 489 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 16300 | 15900–16600 | 7.41x | 595 | 1.22x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | 2411 | 2231–2957 | 1.00x | 482 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 12806 | 11904–12918 | 5.31x | 1840 | 3.82x | 49 | yes |
| drag-reorder-100 | 20 | plain | 11200 | 8000–11300 | 1.00x | 476 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 129665 | 125470–130042 | 11.58x | 2927 | 6.15x | 61 | yes |
| modal-on-modal | 20 | plain | 18905 | 18822–19200 | 1.00x | 524 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 79496 | 74290–81617 | 4.21x | 998 | 1.91x | 62 | yes |
| button-native-scale-50 | 6 | plain | 1803 | 1700–2100 | 1.00x | 503 | 1.00x | 3 | yes |
| button-native-scale-50 | 6 | facet | 50591 | 49146–50932 | 28.06x | 1608 | 3.20x | 42 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.62x | 30 | 3.25x |
