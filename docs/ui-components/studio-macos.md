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
| Harness revision | `a360b90` |
| Facet commit | `9dc3bdb6e1afd76dfd86a5427da140d41defc78a` |
| Facet tree | `d82f012344d1161d37b563d2977af7c0fe725600` |
| Date | 2026-11-13 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 2356 | 2206–3437 | 1.00x | 3 | 1.00x | 0 | yes |
| main-menu-cold | 1 | facet | 13656 | 12544–14784 | 5.80x | 287 | 95.67x | 29 | yes |
| hud-60-frames | 60 | plain | 4435 | 4170–4796 | 1.00x | 47 | 1.00x | 26 | yes |
| hud-60-frames | 60 | facet | 2680 | 2110–2856 | 0.60x | 339 | 7.21x | 41 | yes |
| world-markers-50 | 100 | plain | 106125 | 105079–107180 | 1.00x | 1222 | 1.00x | 1009 | yes |
| world-markers-50 | 100 | facet | 44091 | 35745–46143 | 0.42x | 1678 | 1.37x | 330 | yes |
| inventory-500 | 40 | plain | 3747 | 3718–4049 | 1.00x | 298 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 6400 | 5116–6415 | 1.71x | 7631 | 25.65x | 84 | yes |
| shop-filter-200 | 10 | plain | 1303 | 1271–1511 | 1.00x | 53 | 1.00x | 0 | yes |
| shop-filter-200 | 10 | facet | 5230 | 4000–5608 | 4.01x | 1213 | 22.89x | 64 | yes |
| virtual-scroll-2000 | 15 | plain | 1948 | 1719–2001 | 1.00x | 103 | 1.00x | 0 | yes |
| virtual-scroll-2000 | 15 | facet | 4902 | 3714–5381 | 2.52x | 864 | 8.39x | 20 | yes |
| chat-append-250 | 250 | plain | 17560 | 15956–18099 | 1.00x | 16 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 24710 | 22924–26613 | 1.41x | 1122 | 70.12x | 33 | yes |
| card-collection-60 | 1 | plain | 24423 | 16668–25695 | 1.00x | 16 | 1.00x | 0 | yes |
| card-collection-60 | 1 | facet | 64323 | 62199–67452 | 2.63x | 4321 | 270.06x | 813 | yes |
| mixed-scroll-300 | 50 | plain | 300 | 100–404 | 1.00x | 37 | 1.00x | 1 | yes |
| mixed-scroll-300 | 50 | facet | 1739 | 1700–2368 | 5.80x | 5846 | 158.00x | 87 | yes |
| settings-17-values | 17 | plain | 3938 | 3523–4040 | 1.00x | 197 | 1.00x | 1 | yes |
| settings-17-values | 17 | facet | 6561 | 5949–6737 | 1.67x | 1094 | 5.55x | 76 | yes |
| text-input-200 | 200 | plain | 900 | 700–1307 | 1.00x | 0 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 2098 | 1500–2229 | 2.33x | 293 | 293.00x | 15 | yes |
| button-feedback-50 | 15 | plain | 1617 | 1481–1628 | 1.00x | 26 | 1.00x | 0 | yes |
| button-feedback-50 | 15 | facet | 2176 | 2100–2328 | 1.35x | 437 | 17.14x | 25 | yes |
| stepper-segments-100 | 100 | plain | 12524 | 12275–12659 | 1.00x | 73 | 1.00x | 34 | yes |
| stepper-segments-100 | 100 | facet | 18755 | 15862–19889 | 1.50x | 524 | 7.18x | 62 | yes |
| toast-stream-4 | 8 | plain | 2446 | 2301–3096 | 1.00x | 11 | 1.00x | 0 | yes |
| toast-stream-4 | 8 | facet | 19780 | 14727–20687 | 8.09x | 291 | 26.45x | 30 | yes |
| tabs-5-5-switches | 5 | plain | 1600 | 1497–1604 | 1.00x | 6 | 1.00x | 0 | yes |
| tabs-5-5-switches | 5 | facet | 4245 | 4231–4718 | 2.65x | 980 | 163.33x | 47 | yes |
| radial-15-cycles | 60 | plain | 23593 | 23121–23629 | 1.00x | 99 | 1.00x | 0 | yes |
| radial-15-cycles | 60 | facet | 101248 | 99677–105849 | 4.29x | 847 | 8.56x | 58 | yes |
| navigation-5-6-cycles | 60 | plain | 15168 | 14529–15201 | 1.00x | 6 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 59769 | 57640–60667 | 3.94x | 411 | 63.23x | 51 | yes |
| leaderboard-100 | 6 | plain | 4520 | 4318–4705 | 1.00x | 59 | 1.00x | 1 | yes |
| leaderboard-100 | 6 | facet | 7474 | 7308–7712 | 1.65x | 7241 | 122.73x | 175 | yes |
| theme-swap-200 | 4 | plain | 100 | 100–232 | 1.00x | 12 | 1.00x | 0 | yes |
| theme-swap-200 | 4 | facet | 7203 | 4600–7527 | 72.03x | 2052 | 171.00x | 386 | yes |
| heavy-screen-20-cycles | 20 | plain | 261319 | 256316–262029 | 1.00x | 20 | 1.00x | 0 | yes |
| heavy-screen-20-cycles | 20 | facet | 494112 | 490479–495483 | 1.89x | 2436 | 121.80x | 276 | yes |
| tile-transfer-20 | 41 | plain | 17339 | 16076–17781 | 1.00x | 90 | 1.00x | 1 | yes |
| tile-transfer-20 | 41 | facet | 52875 | 52860–53144 | 3.05x | 1028 | 11.49x | 46 | yes |
| input-type-switch-20 | 20 | plain | 4364 | 4103–4606 | 1.00x | 77 | 1.00x | 1 | yes |
| input-type-switch-20 | 20 | facet | 13404 | 11101–14444 | 3.07x | 979 | 12.71x | 210 | yes |
| localized-text-swap-50 | 10 | plain | 4727 | 3913–5113 | 1.00x | 205 | 1.00x | 28 | yes |
| localized-text-swap-50 | 10 | facet | 4681 | 4527–5709 | 0.99x | 1254 | 6.12x | 261 | yes |
| text-size-preference-50 | 8 | plain | 935 | 719–1216 | 1.00x | 8 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 11813 | 10637–12502 | 12.63x | 1332 | 166.50x | 340 | yes |
| phone-rotation-hub | 20 | plain | 363 | 100–400 | 1.00x | 4 | 1.00x | 1 | yes |
| phone-rotation-hub | 20 | facet | 612 | 606–904 | 1.69x | 426 | 106.50x | 42 | yes |
| hud-composition-step-down | 20 | plain | 2388 | 2213–3339 | 1.00x | 4 | 1.00x | 0 | yes |
| hud-composition-step-down | 20 | facet | 16622 | 15593–17010 | 6.96x | 392 | 98.00x | 24 | yes |
| gamepad-grid-6x6 | 35 | plain | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | facet | failed | — | — | — | — | — | — |
| drag-reorder-100 | 40 | plain | 32679 | 32487–33642 | 1.00x | 181 | 1.00x | 0 | yes |
| drag-reorder-100 | 40 | facet | 79934 | 77798–82844 | 2.45x | 2190 | 12.10x | 36 | yes |
| modal-on-modal | 20 | plain | 12326 | 10033–12707 | 1.00x | 12 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 54176 | 54021–54312 | 4.40x | 720 | 57.56x | 34 | yes |
| button-native-scale-50 | 6 | plain | 907 | 802–1071 | 1.00x | 18 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 2920 | 2700–3170 | 3.22x | 678 | 36.68x | 43 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 29 | 1.00x | 29 | 1.00x |
| facet | 29 | 2.86x | 29 | 35.12x |
