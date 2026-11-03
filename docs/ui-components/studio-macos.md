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
| Roblox Studio | 0.745.0.7451137 |
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
| main-menu-cold | 1 | plain | 20050 | 16509–20789 | 1.00x | 518 | 1.00x | 11 | yes |
| main-menu-cold | 1 | facet | 22241 | 17748–23296 | 1.11x | 618 | 1.19x | 26 | yes |
| hud-60-frames | 60 | plain | 625 | 510–702 | 1.00x | 497 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 2112 | 1618–2844 | 3.38x | 586 | 1.18x | 18 | yes |
| world-markers-50 | 100 | plain | 14798 | 14005–21617 | 1.00x | 627 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 41255 | 39583–46564 | 2.79x | 1340 | 2.14x | 16 | yes |
| inventory-500 | 40 | plain | 4394 | 4145–4529 | 1.00x | 711 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 9956 | 9013–10940 | 2.27x | 15748 | 22.15x | 152 | yes |
| shop-filter-200 | 10 | plain | 1650 | 1000–2043 | 1.00x | 505 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 3701 | 3550–6247 | 2.24x | 1934 | 3.83x | 67 | yes |
| virtual-scroll-2000 | 15 | plain | 1010 | 801–1429 | 1.00x | 598 | 1.00x | 1 | yes |
| virtual-scroll-2000 | 15 | facet | 6900 | 5816–7733 | 6.83x | 1448 | 2.42x | 19 | yes |
| chat-append-250 | 250 | plain | 21499 | 13034–24660 | 1.00x | 772 | 1.00x | 3 | yes |
| chat-append-250 | 250 | facet | 28953 | 26140–34036 | 1.35x | 2394 | 3.10x | 47 | yes |
| card-collection-60 | 1 | plain | 32327 | 28628–33670 | 1.00x | 471 | 1.00x | 0 | yes |
| card-collection-60 | 1 | facet | 73145 | 72179–77121 | 2.26x | 5528 | 11.74x | 112 | yes |
| mixed-scroll-300 | 50 | plain | 200 | 200–400 | 1.00x | 512 | 1.00x | 4 | yes |
| mixed-scroll-300 | 50 | facet | 2800 | 2500–2914 | 14.00x | 8067 | 15.76x | 145 | yes |
| settings-17-values | 17 | plain | 402 | 200–600 | 1.00x | 538 | 1.00x | 0 | yes |
| settings-17-values | 17 | facet | 1522 | 1008–1730 | 3.79x | 1536 | 2.86x | 65 | yes |
| text-input-200 | 200 | plain | 1137 | 1006–2100 | 1.00x | 455 | 1.00x | 3 | yes |
| text-input-200 | 200 | facet | 2102 | 1300–2803 | 1.85x | 555 | 1.22x | 12 | yes |
| button-feedback-50 | 15 | plain | 1602 | 1423–2035 | 1.00x | 496 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2002 | 1985–2944 | 1.25x | 826 | 1.66x | 26 | yes |
| stepper-segments-100 | 100 | plain | 2003 | 400–2200 | 1.00x | 495 | 1.00x | 3 | yes |
| stepper-segments-100 | 100 | facet | 8816 | 5110–10011 | 4.40x | 823 | 1.66x | 43 | yes |
| toast-stream-4 | 8 | plain | 12177 | 10654–13983 | 1.00x | 486 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 19944 | 18013–20702 | 1.64x | 560 | 1.15x | 32 | yes |
| tabs-5-5-switches | 5 | plain | 1000 | 810–1100 | 1.00x | 518 | 1.00x | 3 | yes |
| tabs-5-5-switches | 5 | facet | 2100 | 1900–2204 | 2.10x | 1246 | 2.41x | 44 | yes |
| radial-15-cycles | 30 | plain | 48627 | 40415–49732 | 1.00x | 610 | 1.00x | 18 | yes |
| radial-15-cycles | 30 | facet | 159255 | 155832–162042 | 3.28x | 1194 | 1.96x | 78 | yes |
| navigation-5-6-cycles | 60 | plain | 17213 | 14808–18515 | 1.00x | 483 | 1.00x | 2 | yes |
| navigation-5-6-cycles | 60 | facet | 43131 | 41931–46503 | 2.51x | 683 | 1.41x | 53 | yes |
| leaderboard-100 | 3 | plain | 1043 | 700–1091 | 1.00x | 1444 | 1.00x | 0 | yes |
| leaderboard-100 | 3 | facet | 4313 | 3103–4732 | 4.14x | 13435 | 9.30x | 230 | yes |
| theme-swap-200 | 2 | plain | 300 | 100–300 | 1.00x | 723 | 1.00x | 704 | yes |
| theme-swap-200 | 2 | facet | 200 | 100–200 | 0.67x | 2565 | 3.55x | 182 | yes |
| heavy-screen-20-cycles | 20 | plain | 500187 | 476126–517406 | 1.00x | 11 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 641334 | 619090–657945 | 1.28x | 495 | 45.00x | 487 | yes |
| tile-transfer-20 | 20 | plain | 13207 | 11977–14267 | 1.00x | 468 | 1.00x | 5 | yes |
| tile-transfer-20 | 20 | facet | 54603 | 53633–54749 | 4.13x | 1474 | 3.15x | 28 | yes |
| input-type-switch-20 | 20 | plain | 1208 | 1124–1324 | 1.00x | 491 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 5234 | 4674–5813 | 4.33x | 1027 | 2.09x | 8 | yes |
| localized-text-swap-50 | 10 | plain | 2708 | 2020–3011 | 1.00x | 562 | 1.00x | 3 | yes |
| localized-text-swap-50 | 10 | facet | 6959 | 6505–7349 | 2.57x | 1241 | 2.21x | 26 | yes |
| text-size-preference-50 | 8 | plain | 112 | 100–410 | 1.00x | 414 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 30709 | 25238–34027 | 274.19x | 1359 | 3.28x | 10 | yes |
| phone-rotation-hub | 20 | plain | 556 | 404–939 | 1.00x | 452 | 1.00x | 0 | yes |
| phone-rotation-hub | 20 | facet | 1202 | 900–1500 | 2.16x | 693 | 1.53x | 47 | yes |
| hud-composition-step-down | 20 | plain | 1622 | 1616–2226 | 1.00x | 473 | 1.00x | 1 | yes |
| hud-composition-step-down | 20 | facet | 26105 | 25117–28172 | 16.09x | 606 | 1.28x | 6 | yes |
| gamepad-grid-6x6 | 35 | plain | 1301 | 1100–1700 | 1.00x | 478 | 1.00x | 1 | yes |
| gamepad-grid-6x6 | 35 | facet | 12806 | 12702–13201 | 9.84x | 1832 | 3.84x | 48 | yes |
| drag-reorder-100 | 20 | plain | 8415 | 6342–8736 | 1.00x | 476 | 1.00x | 5 | yes |
| drag-reorder-100 | 20 | facet | 84042 | 81529–87670 | 9.99x | 2927 | 6.15x | 62 | yes |
| modal-on-modal | 20 | plain | 20948 | 20112–22858 | 1.00x | 511 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 58481 | 55494–62783 | 2.79x | 1001 | 1.96x | 52 | yes |
| button-native-scale-50 | 6 | plain | 911 | 605–960 | 1.00x | 504 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 16338 | 16329–16345 | 17.93x | 1600 | 3.17x | 43 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.72x | 30 | 3.10x |
