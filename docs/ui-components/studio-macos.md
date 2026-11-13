# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances, against real Roblox Instances in a Roblox Studio play client. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Harness revision | `1cf4533` |
| Facet commit | `9dc3bdb6e1afd76dfd86a5427da140d41defc78a` |
| Facet tree | `d82f012344d1161d37b563d2977af7c0fe725600` |
| Date | 2026-11-13 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 2162 | 1300–2202 | 1.00x | 2 | 1.00x | 0 | yes |
| main-menu-cold | 1 | facet | 13136 | 12428–14407 | 6.08x | 286 | 143.00x | 28 | yes |
| hud-60-frames | 60 | plain | 1263 | 808–1822 | 1.00x | 18 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 3032 | 2981–3397 | 2.40x | 339 | 18.83x | 40 | yes |
| world-markers-50 | 100 | plain | 15647 | 12537–20897 | 1.00x | 300 | 1.00x | 41 | yes |
| world-markers-50 | 100 | facet | 34526 | 32728–41827 | 2.21x | 1685 | 5.62x | 330 | yes |
| inventory-500 | 40 | plain | 3416 | 3009–3800 | 1.00x | 301 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 6341 | 5808–7252 | 1.86x | 7646 | 25.40x | 87 | yes |
| shop-filter-200 | 10 | plain | 1602 | 1506–1717 | 1.00x | 53 | 1.00x | 0 | yes |
| shop-filter-200 | 10 | facet | 4734 | 4000–6893 | 2.96x | 1205 | 22.74x | 63 | yes |
| virtual-scroll-2000 | 15 | plain | 1730 | 1657–1933 | 1.00x | 103 | 1.00x | 0 | yes |
| virtual-scroll-2000 | 15 | facet | 4613 | 4009–5216 | 2.67x | 864 | 8.39x | 21 | yes |
| chat-append-250 | 250 | plain | 20684 | 17682–22877 | 1.00x | 15 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 24373 | 22255–27629 | 1.18x | 1124 | 74.93x | 34 | yes |
| card-collection-60 | 1 | plain | 21114 | 14830–23515 | 1.00x | 16 | 1.00x | 0 | yes |
| card-collection-60 | 1 | facet | 66221 | 62071–67242 | 3.14x | 4337 | 271.06x | 829 | yes |
| mixed-scroll-300 | 50 | plain | 300 | 100–312 | 1.00x | 21 | 1.00x | 0 | yes |
| mixed-scroll-300 | 50 | facet | 2905 | 2706–3000 | 9.68x | 5854 | 278.76x | 95 | yes |
| settings-17-values | 17 | plain | 4328 | 4115–4631 | 1.00x | 220 | 1.00x | 5 | yes |
| settings-17-values | 17 | facet | 7113 | 6410–7733 | 1.64x | 1082 | 4.92x | 63 | yes |
| text-input-200 | 200 | plain | 950 | 601–1310 | 1.00x | 16 | 1.00x | 1 | yes |
| text-input-200 | 200 | facet | 1550 | 1200–1878 | 1.63x | 294 | 18.38x | 16 | yes |
| button-feedback-50 | 15 | plain | 2203 | 1934–2673 | 1.00x | 26 | 1.00x | 0 | yes |
| button-feedback-50 | 15 | facet | 2512 | 2231–2672 | 1.14x | 450 | 17.31x | 30 | yes |
| stepper-segments-100 | 100 | plain | 6955 | 5758–7164 | 1.00x | 37 | 1.00x | 1 | yes |
| stepper-segments-100 | 100 | facet | 21137 | 19460–21249 | 3.04x | 524 | 14.16x | 62 | yes |
| toast-stream-4 | 8 | plain | 2070 | 1863–2610 | 1.00x | 4 | 1.00x | 0 | yes |
| toast-stream-4 | 8 | facet | 14625 | 11948–18953 | 7.07x | 294 | 65.33x | 32 | yes |
| tabs-5-5-switches | 5 | plain | 1444 | 1302–2008 | 1.00x | 14 | 1.00x | 0 | yes |
| tabs-5-5-switches | 5 | facet | 4125 | 4119–4430 | 2.86x | 972 | 69.43x | 48 | yes |
| radial-15-cycles | 60 | plain | 23746 | 22328–23784 | 1.00x | 107 | 1.00x | 0 | yes |
| radial-15-cycles | 60 | facet | 104418 | 102356–105594 | 4.40x | 854 | 7.99x | 62 | yes |
| navigation-5-6-cycles | 60 | plain | 14097 | 13854–14994 | 1.00x | 10 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 62278 | 54349–62447 | 4.42x | 411 | 39.14x | 52 | yes |
| leaderboard-100 | 6 | plain | 5041 | 4624–5082 | 1.00x | 51 | 1.00x | 1 | yes |
| leaderboard-100 | 6 | facet | 7413 | 6716–7467 | 1.47x | 7257 | 142.29x | 176 | yes |
| theme-swap-200 | 4 | plain | 100 | 100–207 | 1.00x | 12 | 1.00x | 1 | yes |
| theme-swap-200 | 4 | facet | 4009 | 3853–7807 | 40.09x | 2053 | 171.08x | 386 | yes |
| heavy-screen-20-cycles | 20 | plain | 266543 | 254516–272290 | 1.00x | 29 | 1.00x | 1 | yes |
| heavy-screen-20-cycles | 20 | facet | 495396 | 488295–500261 | 1.86x | 2271 | 78.31x | 150 | yes |
| tile-transfer-20 | 41 | plain | 14795 | 13827–14906 | 1.00x | 84 | 1.00x | 0 | yes |
| tile-transfer-20 | 41 | facet | 52264 | 52199–54860 | 3.53x | 1011 | 12.04x | 48 | yes |
| input-type-switch-20 | 20 | plain | 5830 | 5443–6138 | 1.00x | 93 | 1.00x | 8 | yes |
| input-type-switch-20 | 20 | facet | 12124 | 10009–14968 | 2.08x | 987 | 10.61x | 209 | yes |
| localized-text-swap-50 | 10 | plain | 6455 | 6312–8628 | 1.00x | 252 | 1.00x | 28 | yes |
| localized-text-swap-50 | 10 | facet | 5618 | 5127–6998 | 0.87x | 1245 | 4.94x | 260 | yes |
| text-size-preference-50 | 8 | plain | 900 | 575–900 | 1.00x | 7 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 10908 | 10234–11109 | 12.12x | 1339 | 191.29x | 339 | yes |
| phone-rotation-hub | 20 | plain | 100 | 100–545 | 1.00x | 4 | 1.00x | 0 | yes |
| phone-rotation-hub | 20 | facet | 958 | 804–1142 | 9.58x | 418 | 104.50x | 42 | yes |
| hud-composition-step-down | 20 | plain | 2412 | 2337–3844 | 1.00x | 17 | 1.00x | 5 | yes |
| hud-composition-step-down | 20 | facet | 17916 | 17668–18010 | 7.43x | 394 | 23.15x | 26 | yes |
| gamepad-grid-6x6 | 35 | plain | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | facet | failed | — | — | — | — | — | — |
| drag-reorder-100 | 40 | plain | 33108 | 32634–34900 | 1.00x | 182 | 1.00x | 0 | yes |
| drag-reorder-100 | 40 | facet | 78981 | 78319–79672 | 2.39x | 2206 | 12.15x | 40 | yes |
| modal-on-modal | 20 | plain | 12073 | 10691–12317 | 1.00x | 9 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 46799 | 45254–53861 | 3.88x | 708 | 78.67x | 26 | yes |
| button-native-scale-50 | 6 | plain | 826 | 796–1069 | 1.00x | 26 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 2033 | 1622–2049 | 2.46x | 679 | 25.62x | 39 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 29 | 1.00x | 29 | 1.00x |
| facet | 29 | 3.27x | 29 | 33.56x |
