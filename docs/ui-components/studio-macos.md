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
| Roblox Studio | 0.747.0.7471481 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `e058f99` |
| Facet commit | `237ca75fe1befc8fc102d14a47b847c3a8915686` |
| Facet tree | `5e60969f500b5d6bb694266b71ef478156889832` |
| Date | 2026-11-11 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 11723 | 8643–15952 | 1.00x | 508 | 1.00x | 3 | yes |
| main-menu-cold | 1 | facet | 16936 | 9200–17896 | 1.44x | 601 | 1.18x | 25 | yes |
| hud-60-frames | 60 | plain | 606 | 500–1373 | 1.00x | 497 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 2649 | 1814–2700 | 4.37x | 492 | 0.99x | 0 | yes |
| world-markers-50 | 100 | plain | 20974 | 17134–22448 | 1.00x | 643 | 1.00x | 3 | yes |
| world-markers-50 | 100 | facet | 44403 | 36121–53646 | 2.12x | 1188 | 1.85x | 0 | yes |
| inventory-500 | 40 | plain | 3715 | 3369–3920 | 1.00x | 734 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 5635 | 5025–6363 | 1.52x | 8982 | 12.24x | 82 | yes |
| shop-filter-200 | 10 | plain | 1500 | 1431–1748 | 1.00x | 521 | 1.00x | 10 | yes |
| shop-filter-200 | 10 | facet | 5332 | 4122–5800 | 3.55x | 1687 | 3.24x | 53 | yes |
| virtual-scroll-2000 | 15 | plain | 1210 | 801–1300 | 1.00x | 636 | 1.00x | 10 | yes |
| virtual-scroll-2000 | 15 | facet | 5831 | 4423–7209 | 4.82x | 1255 | 1.97x | 19 | yes |
| chat-append-250 | 250 | plain | 20844 | 12353–22756 | 1.00x | 790 | 1.00x | 2 | yes |
| chat-append-250 | 250 | facet | 25151 | 18606–28903 | 1.21x | 1325 | 1.68x | 23 | yes |
| card-collection-60 | 1 | plain | 27672 | 21139–29475 | 1.00x | 516 | 1.00x | 11 | yes |
| card-collection-60 | 1 | facet | 69595 | 55978–71759 | 2.51x | 3808 | 7.38x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 315 | 300–576 | 1.00x | 530 | 1.00x | 3 | yes |
| mixed-scroll-300 | 50 | facet | 4100 | 3745–4101 | 13.02x | 6354 | 11.99x | 84 | yes |
| settings-17-values | 17 | plain | 306 | 134–627 | 1.00x | 568 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1284 | 804–1388 | 4.20x | 1352 | 2.38x | 72 | yes |
| text-input-200 | 200 | plain | 1700 | 1204–1744 | 1.00x | 488 | 1.00x | 3 | yes |
| text-input-200 | 200 | facet | 2407 | 800–2551 | 1.42x | 584 | 1.20x | 21 | yes |
| button-feedback-50 | 15 | plain | 1331 | 1200–1604 | 1.00x | 519 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2004 | 1452–2034 | 1.51x | 779 | 1.50x | 31 | yes |
| stepper-segments-100 | 100 | plain | 1831 | 1000–2473 | 1.00x | 519 | 1.00x | 3 | yes |
| stepper-segments-100 | 100 | facet | 10725 | 10024–11417 | 5.86x | 692 | 1.33x | 0 | yes |
| toast-stream-4 | 8 | plain | 3724 | 3136–4338 | 1.00x | 506 | 1.00x | 6 | yes |
| toast-stream-4 | 8 | facet | 18746 | 18208–18988 | 5.03x | 596 | 1.18x | 26 | yes |
| tabs-5-5-switches | 5 | plain | 1038 | 929–1103 | 1.00x | 523 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 1810 | 1700–2515 | 1.74x | 1203 | 2.30x | 51 | yes |
| radial-15-cycles | 30 | plain | 24104 | 23951–24191 | 1.00x | 578 | 1.00x | 14 | yes |
| radial-15-cycles | 30 | facet | 115748 | 113883–115805 | 4.80x | 1180 | 2.04x | 56 | yes |
| navigation-5-6-cycles | 60 | plain | 13779 | 13327–14673 | 1.00x | 515 | 1.00x | 2 | yes |
| navigation-5-6-cycles | 60 | facet | 39270 | 37978–39886 | 2.85x | 684 | 1.33x | 38 | yes |
| leaderboard-100 | 3 | plain | 906 | 900–1013 | 1.00x | 1477 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 3100 | 2500–3947 | 3.42x | 8570 | 5.80x | 0 | yes |
| theme-swap-200 | 2 | plain | 100 | 100–166 | 1.00x | 748 | 1.00x | 738 | yes |
| theme-swap-200 | 2 | facet | 410 | 100–435 | 4.10x | 2143 | 2.86x | 186 | yes |
| heavy-screen-20-cycles | 20 | plain | 395677 | 367956–397508 | 1.00x | 2 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 542934 | 529514–556683 | 1.37x | 498 | 249.00x | 498 | yes |
| tile-transfer-20 | 20 | plain | 9424 | 8955–10156 | 1.00x | 544 | 1.00x | 2 | yes |
| tile-transfer-20 | 20 | facet | 40225 | 38662–41637 | 4.27x | 1604 | 2.94x | 38 | yes |
| input-type-switch-20 | 20 | plain | 1104 | 904–1449 | 1.00x | 573 | 1.00x | 3 | yes |
| input-type-switch-20 | 20 | facet | 11125 | 10640–14635 | 10.08x | 1070 | 1.87x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2303 | 2118–2745 | 1.00x | 581 | 1.00x | 0 | yes |
| localized-text-swap-50 | 10 | facet | 4908 | 3942–6667 | 2.13x | 1103 | 1.90x | 0 | yes |
| text-size-preference-50 | 8 | plain | 100 | 100–100 | 1.00x | 431 | 1.00x | 3 | yes |
| text-size-preference-50 | 8 | facet | 12890 | 9216–14518 | 128.90x | 1190 | 2.76x | 0 | yes |
| phone-rotation-hub | 20 | plain | 250 | 100–351 | 1.00x | 514 | 1.00x | 3 | yes |
| phone-rotation-hub | 20 | facet | 650 | 600–1081 | 2.60x | 744 | 1.45x | 39 | yes |
| hud-composition-step-down | 20 | plain | 1252 | 1103–1734 | 1.00x | 504 | 1.00x | 8 | yes |
| hud-composition-step-down | 20 | facet | 16864 | 16864–17289 | 13.47x | 604 | 1.20x | 6 | yes |
| gamepad-grid-6x6 | 35 | plain | 900 | 668–1031 | 1.00x | 506 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 10610 | 10506–10817 | 11.79x | 1236 | 2.45x | 24 | yes |
| drag-reorder-100 | 20 | plain | 6104 | 5347–6144 | 1.00x | 494 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 75056 | 75051–76972 | 12.30x | 2706 | 5.48x | 38 | yes |
| modal-on-modal | 20 | plain | 10410 | 9624–12297 | 1.00x | 438 | 1.00x | 0 | yes |
| modal-on-modal | 20 | facet | 52537 | 47539–53070 | 5.05x | 958 | 2.19x | 24 | yes |
| button-native-scale-50 | 6 | plain | 618 | 500–870 | 1.00x | 518 | 1.00x | 3 | yes |
| button-native-scale-50 | 6 | facet | 2200 | 1953–2600 | 3.56x | 995 | 1.92x | 36 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 4.06x | 30 | 2.73x |
