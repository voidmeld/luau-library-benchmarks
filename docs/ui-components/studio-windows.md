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
| Roblox Studio | 0.745.0.7451137 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `83e7221` |
| Facet commit | `517628c72ef3187ee2eb8485a7f9387482331eaf` |
| Facet tree | `7043fb2a21556d8a718771873c2399caa664ce7c` |
| Date | 2026-11-04 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 4800 | 4100–5200 | 1.00x | 481 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 6200 | 5100–6200 | 1.29x | 596 | 1.24x | 26 | yes |
| hud-60-frames | 60 | plain | 1500 | 1400–1884 | 1.00x | 472 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 2700 | 1900–3100 | 1.80x | 578 | 1.22x | 19 | yes |
| world-markers-50 | 100 | plain | 8900 | 8800–9500 | 1.00x | 612 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 23300 | 22200–31000 | 2.62x | 994 | 1.62x | 0 | yes |
| inventory-500 | 40 | plain | 11400 | 10800–11400 | 1.00x | 724 | 1.00x | 1 | yes |
| inventory-500 | 40 | facet | 17000 | 15500–17402 | 1.49x | 15224 | 21.04x | 24 | yes |
| shop-filter-200 | 10 | plain | 1700 | 1250–1900 | 1.00x | 496 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 4100 | 3700–5000 | 2.41x | 1906 | 3.84x | 60 | yes |
| virtual-scroll-2000 | 15 | plain | 1450 | 1200–1750 | 1.00x | 604 | 1.00x | 3 | yes |
| virtual-scroll-2000 | 15 | facet | 6000 | 5530–7000 | 4.14x | 1297 | 2.15x | 0 | yes |
| chat-append-250 | 250 | plain | 8702 | 7600–9000 | 1.00x | 751 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 14001 | 12123–15712 | 1.61x | 1754 | 2.34x | 0 | yes |
| card-collection-60 | 1 | plain | 12920 | 12400–13282 | 1.00x | 482 | 1.00x | 10 | yes |
| card-collection-60 | 1 | facet | 41507 | 40778–45841 | 3.21x | 4589 | 9.52x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 400 | 100–700 | 1.00x | 497 | 1.00x | 0 | yes |
| mixed-scroll-300 | 50 | facet | 2400 | 1900–3602 | 6.00x | 8139 | 16.38x | 151 | yes |
| settings-17-values | 17 | plain | 550 | 350–600 | 1.00x | 534 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 2150 | 1600–3100 | 3.91x | 1507 | 2.82x | 66 | yes |
| text-input-200 | 200 | plain | 633 | 500–667 | 1.00x | 464 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 800 | 700–1167 | 1.26x | 539 | 1.16x | 13 | yes |
| button-feedback-50 | 15 | plain | 2100 | 1900–3000 | 1.00x | 490 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 3000 | 2500–3700 | 1.43x | 811 | 1.66x | 34 | yes |
| stepper-segments-100 | 100 | plain | 567 | 467–646 | 1.00x | 484 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 3400 | 2600–3800 | 6.00x | 643 | 1.33x | 0 | yes |
| toast-stream-4 | 8 | plain | 5100 | 5100–5300 | 1.00x | 484 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 25943 | 25000–27759 | 5.09x | 569 | 1.18x | 32 | yes |
| tabs-5-5-switches | 5 | plain | 1800 | 1500–2402 | 1.00x | 497 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 5000 | 4400–5823 | 2.78x | 1083 | 2.18x | 0 | yes |
| radial-15-cycles | 30 | plain | 31701 | 30034–31905 | 1.00x | 536 | 1.00x | 2 | yes |
| radial-15-cycles | 30 | facet | 217557 | 216824–227149 | 6.86x | 1194 | 2.23x | 70 | yes |
| navigation-5-6-cycles | 60 | plain | 16200 | 15600–17024 | 1.00x | 505 | 1.00x | 26 | yes |
| navigation-5-6-cycles | 60 | facet | 34547 | 32120–36077 | 2.13x | 682 | 1.35x | 62 | yes |
| leaderboard-100 | 3 | plain | 450 | 400–750 | 1.00x | 1443 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 2400 | 1900–3100 | 5.33x | 11852 | 8.21x | 0 | yes |
| theme-swap-200 | 2 | plain | 950 | 800–1800 | 1.00x | 724 | 1.00x | 707 | yes |
| theme-swap-200 | 2 | facet | 900 | 600–1000 | 0.95x | 2534 | 3.50x | 182 | yes |
| heavy-screen-20-cycles | 20 | plain | 515720 | 485714–540899 | 1.00x | 11 | 1.00x | 11 | yes |
| heavy-screen-20-cycles | 20 | facet | 682028 | 676816–709137 | 1.32x | 498 | 45.27x | 489 | yes |
| tile-transfer-20 | 20 | plain | 13700 | 12700–13700 | 1.00x | 510 | 1.00x | 0 | yes |
| tile-transfer-20 | 20 | facet | 78719 | 76855–80744 | 5.75x | 1622 | 3.18x | 42 | yes |
| input-type-switch-20 | 20 | plain | 1700 | 1200–1764 | 1.00x | 488 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 3500 | 3400–3950 | 2.06x | 1030 | 2.11x | 9 | yes |
| localized-text-swap-50 | 10 | plain | 1865 | 1743–2000 | 1.00x | 613 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 3600 | 2900–3650 | 1.93x | 1310 | 2.14x | 28 | yes |
| text-size-preference-50 | 8 | plain | 200 | 150–250 | 1.00x | 404 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 9900 | 8401–10200 | 49.50x | 1406 | 3.48x | 10 | yes |
| phone-rotation-hub | 20 | plain | 400 | 200–500 | 1.00x | 496 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 1100 | 1000–1600 | 2.75x | 726 | 1.46x | 39 | yes |
| hud-composition-step-down | 20 | plain | 3500 | 2700–3586 | 1.00x | 472 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 17840 | 17326–18586 | 5.10x | 601 | 1.27x | 14 | yes |
| gamepad-grid-6x6 | 35 | plain | 2147 | 2000–2600 | 1.00x | 473 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 14301 | 13000–15642 | 6.66x | 1537 | 3.25x | 0 | yes |
| drag-reorder-100 | 20 | plain | 16101 | 14900–17100 | 1.00x | 475 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 153649 | 150245–154502 | 9.54x | 2966 | 6.24x | 64 | yes |
| modal-on-modal | 20 | plain | 19202 | 18300–19704 | 1.00x | 450 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 91045 | 90402–91901 | 4.74x | 925 | 2.05x | 50 | yes |
| button-native-scale-50 | 6 | plain | 2200 | 1800–2500 | 1.00x | 493 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 8080 | 7300–10285 | 3.67x | 1589 | 3.22x | 51 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.28x | 30 | 2.96x |
