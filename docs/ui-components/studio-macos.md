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
| Roblox Studio | 0.746.0.7461264 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `ab25d4c` |
| Facet commit | `e707bb3cfe904ed951bd3fe3c9eb4965b90484ff` |
| Facet tree | `63a303a26ff11f628d930cd99f809ea5f607fe17` |
| Date | 2026-11-05 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 4331 | 4108–4545 | 1.00x | 498 | 1.00x | 10 | yes |
| main-menu-cold | 1 | facet | 5300 | 5206–5722 | 1.22x | 599 | 1.20x | 27 | yes |
| hud-60-frames | 60 | plain | 2180 | 1673–2495 | 1.00x | 488 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 3358 | 3060–3470 | 1.54x | 580 | 1.19x | 11 | yes |
| world-markers-50 | 100 | plain | 8905 | 8741–9128 | 1.00x | 627 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 24027 | 22794–32988 | 2.70x | 1011 | 1.61x | 0 | yes |
| inventory-500 | 40 | plain | 6161 | 4805–6498 | 1.00x | 713 | 1.00x | 1 | yes |
| inventory-500 | 40 | facet | 8358 | 7961–10301 | 1.36x | 15656 | 21.96x | 78 | yes |
| shop-filter-200 | 10 | plain | 1500 | 1307–1711 | 1.00x | 504 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 3801 | 3602–4023 | 2.53x | 1915 | 3.80x | 60 | yes |
| virtual-scroll-2000 | 15 | plain | 1100 | 614–1269 | 1.00x | 620 | 1.00x | 3 | yes |
| virtual-scroll-2000 | 15 | facet | 5601 | 4900–6346 | 5.09x | 1283 | 2.07x | 0 | yes |
| chat-append-250 | 250 | plain | 8213 | 7808–8446 | 1.00x | 764 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 14938 | 13430–15601 | 1.82x | 1757 | 2.30x | 0 | yes |
| card-collection-60 | 1 | plain | 11618 | 11341–12127 | 1.00x | 499 | 1.00x | 3 | yes |
| card-collection-60 | 1 | facet | 39533 | 25542–41905 | 3.40x | 4595 | 9.21x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 603 | 600–635 | 1.00x | 506 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 2812 | 2803–3709 | 4.66x | 8148 | 16.10x | 154 | yes |
| settings-17-values | 17 | plain | 400 | 206–700 | 1.00x | 543 | 1.00x | 0 | yes |
| settings-17-values | 17 | facet | 1675 | 1221–1900 | 4.19x | 1523 | 2.80x | 66 | yes |
| text-input-200 | 200 | plain | 500 | 200–700 | 1.00x | 463 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 900 | 700–1611 | 1.80x | 554 | 1.20x | 13 | yes |
| button-feedback-50 | 15 | plain | 2314 | 1804–2737 | 1.00x | 502 | 1.00x | 7 | yes |
| button-feedback-50 | 15 | facet | 2940 | 2065–3542 | 1.27x | 820 | 1.63x | 27 | yes |
| stepper-segments-100 | 100 | plain | 500 | 500–600 | 1.00x | 494 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 3300 | 2900–3728 | 6.60x | 679 | 1.37x | 0 | yes |
| toast-stream-4 | 8 | plain | 2945 | 2579–3062 | 1.00x | 486 | 1.00x | 1 | yes |
| toast-stream-4 | 8 | facet | 12046 | 10341–13531 | 4.09x | 574 | 1.18x | 29 | yes |
| tabs-5-5-switches | 5 | plain | 600 | 402–1360 | 1.00x | 506 | 1.00x | 0 | yes |
| tabs-5-5-switches | 5 | facet | 2916 | 2701–3031 | 4.86x | 1090 | 2.15x | 0 | yes |
| radial-15-cycles | 30 | plain | 13010 | 10978–13994 | 1.00x | 552 | 1.00x | 10 | yes |
| radial-15-cycles | 30 | facet | 55366 | 51690–59814 | 4.26x | 1188 | 2.15x | 81 | yes |
| navigation-5-6-cycles | 60 | plain | 14920 | 14297–15147 | 1.00x | 490 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 42271 | 41672–42768 | 2.83x | 691 | 1.41x | 56 | yes |
| leaderboard-100 | 3 | plain | 701 | 654–915 | 1.00x | 1452 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 3643 | 3263–3947 | 5.20x | 11957 | 8.23x | 0 | yes |
| theme-swap-200 | 2 | plain | 314 | 300–400 | 1.00x | 735 | 1.00x | 717 | yes |
| theme-swap-200 | 2 | facet | 409 | 400–600 | 1.30x | 2579 | 3.51x | 184 | yes |
| heavy-screen-20-cycles | 20 | plain | 390436 | 378029–406488 | 1.00x | 3 | 1.00x | 3 | yes |
| heavy-screen-20-cycles | 20 | facet | 593900 | 590237–601709 | 1.52x | 506 | 168.67x | 506 | yes |
| tile-transfer-20 | 20 | plain | 13957 | 13501–14918 | 1.00x | 524 | 1.00x | 1 | yes |
| tile-transfer-20 | 20 | facet | 54107 | 54093–54976 | 3.88x | 1568 | 2.99x | 43 | yes |
| input-type-switch-20 | 20 | plain | 1334 | 1243–1822 | 1.00x | 548 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 4215 | 3904–4723 | 3.16x | 1096 | 2.00x | 10 | yes |
| localized-text-swap-50 | 10 | plain | 2508 | 2161–2639 | 1.00x | 567 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 4459 | 4344–4694 | 1.78x | 1272 | 2.24x | 29 | yes |
| text-size-preference-50 | 8 | plain | 137 | 104–400 | 1.00x | 419 | 1.00x | 1 | yes |
| text-size-preference-50 | 8 | facet | 8802 | 8117–9745 | 64.25x | 1426 | 3.40x | 10 | yes |
| phone-rotation-hub | 20 | plain | 680 | 548–911 | 1.00x | 506 | 1.00x | 3 | yes |
| phone-rotation-hub | 20 | facet | 1406 | 807–2254 | 2.07x | 738 | 1.46x | 41 | yes |
| hud-composition-step-down | 20 | plain | 3287 | 3011–3544 | 1.00x | 476 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 34565 | 30269–35666 | 10.52x | 610 | 1.28x | 6 | yes |
| gamepad-grid-6x6 | 35 | plain | 1621 | 1619–2255 | 1.00x | 484 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 13991 | 13652–15020 | 8.63x | 1583 | 3.27x | 0 | yes |
| drag-reorder-100 | 20 | plain | 11328 | 11071–12348 | 1.00x | 486 | 1.00x | 6 | yes |
| drag-reorder-100 | 20 | facet | 99751 | 96251–105553 | 8.81x | 2982 | 6.14x | 62 | yes |
| modal-on-modal | 20 | plain | 10476 | 9807–11292 | 1.00x | 428 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 57361 | 56723–58858 | 5.48x | 926 | 2.16x | 41 | yes |
| button-native-scale-50 | 6 | plain | 1001 | 916–1019 | 1.00x | 502 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 3357 | 3343–3419 | 3.35x | 1603 | 3.19x | 37 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.48x | 30 | 3.08x |
