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
| Harness revision | `3995ec1` |
| Facet commit | `655cacd6a38ed1a9d66f7a88a0eac2383a8bdfe5` |
| Facet tree | `0383388ecc6c35ab27c247d4e1d387c646daafa1` |
| Date | 2026-11-11 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 4700 | 4307–5863 | 1.00x | 507 | 1.00x | 0 | yes |
| main-menu-cold | 1 | facet | 5400 | 4537–6069 | 1.15x | 602 | 1.19x | 27 | yes |
| hud-60-frames | 60 | plain | 1900 | 1600–2600 | 1.00x | 498 | 1.00x | 0 | yes |
| hud-60-frames | 60 | facet | 3801 | 2707–4200 | 2.00x | 500 | 1.00x | 0 | yes |
| world-markers-50 | 100 | plain | 9201 | 8800–9706 | 1.00x | 636 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 22539 | 20903–34800 | 2.45x | 1188 | 1.87x | 0 | yes |
| inventory-500 | 40 | plain | 7800 | 7716–8205 | 1.00x | 734 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 10401 | 10102–11400 | 1.33x | 8920 | 12.15x | 74 | yes |
| shop-filter-200 | 10 | plain | 1050 | 600–1300 | 1.00x | 521 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 2850 | 2500–3100 | 2.71x | 1704 | 3.27x | 61 | yes |
| virtual-scroll-2000 | 15 | plain | 1150 | 658–1150 | 1.00x | 621 | 1.00x | 0 | yes |
| virtual-scroll-2000 | 15 | facet | 3850 | 3383–3950 | 3.35x | 1177 | 1.90x | 20 | yes |
| chat-append-250 | 250 | plain | 8300 | 7800–8611 | 1.00x | 791 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 14400 | 9586–16204 | 1.73x | 1326 | 1.68x | 31 | yes |
| card-collection-60 | 1 | plain | 13727 | 13054–14701 | 1.00x | 517 | 1.00x | 11 | yes |
| card-collection-60 | 1 | facet | 53748 | 52553–64178 | 3.92x | 3763 | 7.28x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 700 | 500–939 | 1.00x | 523 | 1.00x | 0 | yes |
| mixed-scroll-300 | 50 | facet | 2500 | 2300–2800 | 3.57x | 6288 | 12.02x | 82 | yes |
| settings-17-values | 17 | plain | 650 | 350–774 | 1.00x | 561 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1350 | 1250–1750 | 2.08x | 1344 | 2.40x | 64 | yes |
| text-input-200 | 200 | plain | 735 | 533–767 | 1.00x | 481 | 1.00x | 4 | yes |
| text-input-200 | 200 | facet | 1067 | 667–1100 | 1.45x | 576 | 1.20x | 12 | yes |
| button-feedback-50 | 15 | plain | 3400 | 3300–3700 | 1.00x | 531 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 3602 | 3000–3901 | 1.06x | 775 | 1.46x | 27 | yes |
| stepper-segments-100 | 100 | plain | 543 | 500–667 | 1.00x | 511 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 3494 | 3250–3750 | 6.43x | 667 | 1.31x | 0 | yes |
| toast-stream-4 | 8 | plain | 4604 | 4118–4700 | 1.00x | 504 | 1.00x | 6 | yes |
| toast-stream-4 | 8 | facet | 22203 | 22103–22900 | 4.82x | 589 | 1.17x | 22 | yes |
| tabs-5-5-switches | 5 | plain | 1549 | 1089–1892 | 1.00x | 531 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 3500 | 3200–4300 | 2.26x | 1194 | 2.25x | 45 | yes |
| radial-15-cycles | 30 | plain | 34144 | 34060–35386 | 1.00x | 570 | 1.00x | 2 | yes |
| radial-15-cycles | 30 | facet | 239033 | 225386–243177 | 7.00x | 1178 | 2.07x | 50 | yes |
| navigation-5-6-cycles | 60 | plain | 16741 | 15507–18300 | 1.00x | 507 | 1.00x | 2 | yes |
| navigation-5-6-cycles | 60 | facet | 35430 | 32500–37006 | 2.12x | 683 | 1.35x | 45 | yes |
| leaderboard-100 | 3 | plain | 600 | 500–600 | 1.00x | 1493 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 1900 | 1500–2200 | 3.17x | 8422 | 5.64x | 0 | yes |
| theme-swap-200 | 2 | plain | 700 | 623–1100 | 1.00x | 766 | 1.00x | 741 | yes |
| theme-swap-200 | 2 | facet | 1000 | 500–1500 | 1.43x | 2143 | 2.80x | 187 | yes |
| heavy-screen-20-cycles | 20 | plain | 540377 | 490084–570367 | 1.00x | 2 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 744564 | 678688–774783 | 1.38x | 499 | 249.50x | 499 | yes |
| tile-transfer-20 | 20 | plain | 15600 | 15300–15600 | 1.00x | 545 | 1.00x | 2 | yes |
| tile-transfer-20 | 20 | facet | 75812 | 75400–76883 | 4.86x | 1692 | 3.10x | 32 | yes |
| input-type-switch-20 | 20 | plain | 1050 | 900–1300 | 1.00x | 565 | 1.00x | 0 | yes |
| input-type-switch-20 | 20 | facet | 9247 | 9100–9549 | 8.81x | 1067 | 1.89x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 1850 | 1800–2000 | 1.00x | 582 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 3750 | 3450–4100 | 2.03x | 1116 | 1.92x | 0 | yes |
| text-size-preference-50 | 8 | plain | 150 | 100–250 | 1.00x | 430 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 10000 | 8820–10648 | 66.67x | 1198 | 2.79x | 0 | yes |
| phone-rotation-hub | 20 | plain | 600 | 300–700 | 1.00x | 522 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 900 | 900–1200 | 1.50x | 736 | 1.41x | 39 | yes |
| hud-composition-step-down | 20 | plain | 3132 | 3100–3400 | 1.00x | 498 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 16922 | 15397–17500 | 5.40x | 614 | 1.23x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | 2100 | 1900–3300 | 1.00x | 507 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 12801 | 12301–14501 | 6.10x | 1249 | 2.46x | 32 | yes |
| drag-reorder-100 | 20 | plain | 11900 | 10800–13100 | 1.00x | 490 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 127093 | 127054–130741 | 10.68x | 2678 | 5.46x | 42 | yes |
| modal-on-modal | 20 | plain | 15601 | 14448–17389 | 1.00x | 476 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 84451 | 79605–92871 | 5.41x | 962 | 2.02x | 28 | yes |
| button-native-scale-50 | 6 | plain | 1900 | 1747–1902 | 1.00x | 527 | 1.00x | 3 | yes |
| button-native-scale-50 | 6 | facet | 6402 | 4600–7600 | 3.37x | 1003 | 1.90x | 32 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.23x | 30 | 2.72x |
