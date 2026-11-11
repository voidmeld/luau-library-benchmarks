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
| Harness revision | `3995ec1` |
| Facet commit | `655cacd6a38ed1a9d66f7a88a0eac2383a8bdfe5` |
| Facet tree | `0383388ecc6c35ab27c247d4e1d387c646daafa1` |
| Date | 2026-11-11 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 9674 | 7000–13228 | 1.00x | 515 | 1.00x | 3 | yes |
| main-menu-cold | 1 | facet | 14429 | 7301–15813 | 1.49x | 611 | 1.19x | 27 | yes |
| hud-60-frames | 60 | plain | 1006 | 666–1182 | 1.00x | 505 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 2865 | 2842–3147 | 2.85x | 499 | 0.99x | 0 | yes |
| world-markers-50 | 100 | plain | 20375 | 19480–20669 | 1.00x | 644 | 1.00x | 10 | yes |
| world-markers-50 | 100 | facet | 43730 | 36046–49825 | 2.15x | 1187 | 1.84x | 0 | yes |
| inventory-500 | 40 | plain | 3596 | 3393–4669 | 1.00x | 738 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 5978 | 5600–6416 | 1.66x | 8916 | 12.08x | 86 | yes |
| shop-filter-200 | 10 | plain | 1534 | 1316–1919 | 1.00x | 514 | 1.00x | 0 | yes |
| shop-filter-200 | 10 | facet | 4946 | 4037–5547 | 3.22x | 1688 | 3.28x | 60 | yes |
| virtual-scroll-2000 | 15 | plain | 999 | 900–1034 | 1.00x | 637 | 1.00x | 3 | yes |
| virtual-scroll-2000 | 15 | facet | 5715 | 3601–6130 | 5.72x | 1176 | 1.85x | 19 | yes |
| chat-append-250 | 250 | plain | 23110 | 17868–25044 | 1.00x | 782 | 1.00x | 3 | yes |
| chat-append-250 | 250 | facet | 24971 | 22861–27324 | 1.08x | 1325 | 1.69x | 23 | yes |
| card-collection-60 | 1 | plain | 28118 | 21028–29939 | 1.00x | 509 | 1.00x | 11 | yes |
| card-collection-60 | 1 | facet | 67295 | 56246–75034 | 2.39x | 3771 | 7.41x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 300 | 200–400 | 1.00x | 524 | 1.00x | 3 | yes |
| mixed-scroll-300 | 50 | facet | 1605 | 1600–2031 | 5.35x | 6297 | 12.02x | 84 | yes |
| settings-17-values | 17 | plain | 222 | 100–300 | 1.00x | 560 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1100 | 1000–1200 | 4.95x | 1344 | 2.40x | 63 | yes |
| text-input-200 | 200 | plain | 1803 | 800–2689 | 1.00x | 480 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 2900 | 2414–3400 | 1.61x | 592 | 1.23x | 21 | yes |
| button-feedback-50 | 15 | plain | 1237 | 1100–1410 | 1.00x | 521 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 1652 | 1354–1991 | 1.34x | 771 | 1.48x | 27 | yes |
| stepper-segments-100 | 100 | plain | 1408 | 1000–2397 | 1.00x | 518 | 1.00x | 3 | yes |
| stepper-segments-100 | 100 | facet | 10172 | 5435–11719 | 7.22x | 676 | 1.31x | 0 | yes |
| toast-stream-4 | 8 | plain | 3817 | 3183–4001 | 1.00x | 499 | 1.00x | 0 | yes |
| toast-stream-4 | 8 | facet | 15755 | 15282–21168 | 4.13x | 596 | 1.20x | 26 | yes |
| tabs-5-5-switches | 5 | plain | 1102 | 905–1200 | 1.00x | 523 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 2016 | 1600–2400 | 1.83x | 1211 | 2.32x | 52 | yes |
| radial-15-cycles | 30 | plain | 23270 | 21681–25074 | 1.00x | 570 | 1.00x | 14 | yes |
| radial-15-cycles | 30 | facet | 115088 | 114972–118808 | 4.95x | 1179 | 2.07x | 56 | yes |
| navigation-5-6-cycles | 60 | plain | 13079 | 12769–13805 | 1.00x | 507 | 1.00x | 3 | yes |
| navigation-5-6-cycles | 60 | facet | 36008 | 35870–40290 | 2.75x | 674 | 1.33x | 36 | yes |
| leaderboard-100 | 3 | plain | 1000 | 900–1007 | 1.00x | 1477 | 1.00x | 0 | yes |
| leaderboard-100 | 3 | facet | 3618 | 3300–3714 | 3.62x | 8462 | 5.73x | 0 | yes |
| theme-swap-200 | 2 | plain | 203 | 200–224 | 1.00x | 756 | 1.00x | 739 | yes |
| theme-swap-200 | 2 | facet | 152 | 100–400 | 0.75x | 2135 | 2.82x | 179 | yes |
| heavy-screen-20-cycles | 20 | plain | 394327 | 390034–419640 | 1.00x | 2 | 1.00x | 1 | yes |
| heavy-screen-20-cycles | 20 | facet | 556088 | 548285–574376 | 1.41x | 506 | 253.00x | 498 | yes |
| tile-transfer-20 | 20 | plain | 9869 | 9570–10421 | 1.00x | 545 | 1.00x | 4 | yes |
| tile-transfer-20 | 20 | facet | 39700 | 39291–41141 | 4.02x | 1612 | 2.96x | 38 | yes |
| input-type-switch-20 | 20 | plain | 1000 | 715–1504 | 1.00x | 565 | 1.00x | 3 | yes |
| input-type-switch-20 | 20 | facet | 12728 | 10113–14555 | 12.73x | 1064 | 1.88x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2434 | 2317–2630 | 1.00x | 582 | 1.00x | 3 | yes |
| localized-text-swap-50 | 10 | facet | 5806 | 5541–6178 | 2.39x | 1111 | 1.91x | 0 | yes |
| text-size-preference-50 | 8 | plain | 100 | 100–200 | 1.00x | 431 | 1.00x | 3 | yes |
| text-size-preference-50 | 8 | facet | 10813 | 9546–12600 | 108.13x | 1190 | 2.76x | 0 | yes |
| phone-rotation-hub | 20 | plain | 204 | 100–300 | 1.00x | 530 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 762 | 500–1000 | 3.74x | 728 | 1.37x | 39 | yes |
| hud-composition-step-down | 20 | plain | 1104 | 912–1289 | 1.00x | 492 | 1.00x | 1 | yes |
| hud-composition-step-down | 20 | facet | 18563 | 17741–21644 | 16.81x | 616 | 1.25x | 14 | yes |
| gamepad-grid-6x6 | 35 | plain | 1300 | 1200–1430 | 1.00x | 502 | 1.00x | 1 | yes |
| gamepad-grid-6x6 | 35 | facet | 10781 | 10101–11129 | 8.29x | 1234 | 2.46x | 28 | yes |
| drag-reorder-100 | 20 | plain | 6522 | 6483–6737 | 1.00x | 490 | 1.00x | 0 | yes |
| drag-reorder-100 | 20 | facet | 70369 | 70274–74486 | 10.79x | 2643 | 5.40x | 28 | yes |
| modal-on-modal | 20 | plain | 10748 | 9721–11024 | 1.00x | 451 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 53860 | 47339–54369 | 5.01x | 949 | 2.10x | 24 | yes |
| button-native-scale-50 | 6 | plain | 800 | 554–913 | 1.00x | 518 | 1.00x | 3 | yes |
| button-native-scale-50 | 6 | facet | 1805 | 1642–2024 | 2.26x | 1003 | 1.94x | 40 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.68x | 30 | 2.73x |
