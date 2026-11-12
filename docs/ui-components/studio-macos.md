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
| Harness revision | `929dd0c` |
| Facet commit | `6a6cbbf8f32e1036fc03da477c84b2149640f369` |
| Facet tree | `603903e5da8a8d9ca700c5c3eafe05a0728dc832` |
| Date | 2026-11-12 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 10032 | 5414–14109 | 1.00x | 519 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 12885 | 9927–15790 | 1.28x | 599 | 1.15x | 27 | yes |
| hud-60-frames | 60 | plain | 1300 | 1200–1359 | 1.00x | 501 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 3477 | 2900–3730 | 2.67x | 495 | 0.99x | 0 | yes |
| world-markers-50 | 100 | plain | 20058 | 14295–21912 | 1.00x | 639 | 1.00x | 0 | yes |
| world-markers-50 | 100 | facet | 44060 | 36125–51434 | 2.20x | 1199 | 1.88x | 0 | yes |
| inventory-500 | 40 | plain | 4355 | 3084–4398 | 1.00x | 742 | 1.00x | 1 | yes |
| inventory-500 | 40 | facet | 6573 | 6444–6805 | 1.51x | 7920 | 10.67x | 78 | yes |
| shop-filter-200 | 10 | plain | 1812 | 1308–2100 | 1.00x | 525 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 5564 | 4729–6321 | 3.07x | 1684 | 3.21x | 60 | yes |
| virtual-scroll-2000 | 15 | plain | 903 | 605–1227 | 1.00x | 640 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 4864 | 4546–5281 | 5.39x | 1146 | 1.79x | 19 | yes |
| chat-append-250 | 250 | plain | 22296 | 14142–23830 | 1.00x | 801 | 1.00x | 2 | yes |
| chat-append-250 | 250 | facet | 24665 | 22416–25985 | 1.11x | 1361 | 1.70x | 31 | yes |
| card-collection-60 | 1 | plain | 29631 | 21205–31731 | 1.00x | 520 | 1.00x | 11 | yes |
| card-collection-60 | 1 | facet | 68130 | 54051–73917 | 2.30x | 3759 | 7.23x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 600 | 100–619 | 1.00x | 527 | 1.00x | 3 | yes |
| mixed-scroll-300 | 50 | facet | 2022 | 1700–2326 | 3.37x | 6286 | 11.93x | 81 | yes |
| settings-17-values | 17 | plain | 400 | 100–620 | 1.00x | 572 | 1.00x | 0 | yes |
| settings-17-values | 17 | facet | 1268 | 1100–1320 | 3.17x | 1346 | 2.35x | 63 | yes |
| text-input-200 | 200 | plain | 1000 | 502–1400 | 1.00x | 485 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 2800 | 900–4113 | 2.80x | 588 | 1.21x | 13 | yes |
| button-feedback-50 | 15 | plain | 1468 | 1338–1502 | 1.00x | 525 | 1.00x | 1 | yes |
| button-feedback-50 | 15 | facet | 1734 | 1210–2012 | 1.18x | 782 | 1.49x | 28 | yes |
| stepper-segments-100 | 100 | plain | 1801 | 1125–2204 | 1.00x | 522 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 11293 | 5315–11550 | 6.27x | 679 | 1.30x | 0 | yes |
| toast-stream-4 | 8 | plain | 3127 | 2521–3908 | 1.00x | 510 | 1.00x | 6 | yes |
| toast-stream-4 | 8 | facet | 17355 | 12140–17709 | 5.55x | 597 | 1.17x | 16 | yes |
| tabs-5-5-switches | 5 | plain | 1100 | 904–1413 | 1.00x | 527 | 1.00x | 0 | yes |
| tabs-5-5-switches | 5 | facet | 1860 | 1759–2200 | 1.69x | 1208 | 2.29x | 44 | yes |
| radial-15-cycles | 30 | plain | 24280 | 20975–24672 | 1.00x | 578 | 1.00x | 14 | yes |
| radial-15-cycles | 30 | facet | 121701 | 116684–124276 | 5.01x | 1179 | 2.04x | 60 | yes |
| navigation-5-6-cycles | 60 | plain | 12498 | 12204–14547 | 1.00x | 511 | 1.00x | 3 | yes |
| navigation-5-6-cycles | 60 | facet | 36619 | 33349–37680 | 2.93x | 685 | 1.34x | 36 | yes |
| leaderboard-100 | 3 | plain | 900 | 700–1108 | 1.00x | 1488 | 1.00x | 2 | yes |
| leaderboard-100 | 3 | facet | 3601 | 3171–4012 | 4.00x | 7513 | 5.05x | 0 | yes |
| theme-swap-200 | 2 | plain | 100 | 100–300 | 1.00x | 770 | 1.00x | 744 | yes |
| theme-swap-200 | 2 | facet | 300 | 200–300 | 3.00x | 2146 | 2.79x | 186 | yes |
| heavy-screen-20-cycles | 20 | plain | 434778 | 404199–452924 | 1.00x | 10 | 1.00x | 10 | yes |
| heavy-screen-20-cycles | 20 | facet | 583958 | 576528–625025 | 1.34x | 490 | 49.00x | 490 | yes |
| tile-transfer-20 | 20 | plain | 9825 | 9562–10318 | 1.00x | 544 | 1.00x | 1 | yes |
| tile-transfer-20 | 20 | facet | 44474 | 43274–46398 | 4.53x | 1612 | 2.96x | 42 | yes |
| input-type-switch-20 | 20 | plain | 1107 | 739–1514 | 1.00x | 576 | 1.00x | 3 | yes |
| input-type-switch-20 | 20 | facet | 12760 | 11820–14352 | 11.53x | 1070 | 1.86x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2537 | 2370–3243 | 1.00x | 582 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 6314 | 4949–6989 | 2.49x | 1115 | 1.92x | 0 | yes |
| text-size-preference-50 | 8 | plain | 200 | 100–300 | 1.00x | 433 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 10709 | 9201–11906 | 53.55x | 1193 | 2.76x | 0 | yes |
| phone-rotation-hub | 20 | plain | 200 | 101–600 | 1.00x | 525 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 1060 | 904–1603 | 5.30x | 738 | 1.41x | 39 | yes |
| hud-composition-step-down | 20 | plain | 1621 | 1475–2376 | 1.00x | 500 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 15955 | 14765–16387 | 9.84x | 613 | 1.22x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | facet | 11619 | 10819–11823 | — | 1160 | — | 24 | — |
| drag-reorder-100 | 20 | plain | 6769 | 6745–6989 | 1.00x | 498 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 76819 | 73662–82017 | 11.35x | 2510 | 5.05x | 36 | yes |
| modal-on-modal | 20 | plain | 10967 | 8644–11048 | 1.00x | 446 | 1.00x | 0 | yes |
| modal-on-modal | 20 | facet | 52835 | 45671–55132 | 4.82x | 966 | 2.16x | 36 | yes |
| button-native-scale-50 | 6 | plain | 729 | 624–907 | 1.00x | 515 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 2608 | 2303–2900 | 3.58x | 999 | 1.94x | 40 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 29 | 1.00x | 29 | 1.00x |
| facet | 29 | 3.63x | 29 | 2.54x |
