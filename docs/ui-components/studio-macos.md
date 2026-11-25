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
| Roblox Studio | 0.748.0.7481526 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `f245db2` |
| Facet commit | `4b4755f84b368e7dc52fcc93feaee9d65cf34c13` |
| Facet tree | `lute pkg` |
| Date | 2026-11-25 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 1358 | 900–1947 | 1.00x | 2 | 1.00x | 1 | yes |
| main-menu-cold | 1 | facet | 11161 | 10301–13261 | 8.22x | 294 | 147.00x | 29 | yes |
| hud-60-frames | 60 | plain | 1400 | 1056–1700 | 1.00x | 12 | 1.00x | 0 | yes |
| hud-60-frames | 60 | facet | 3355 | 3108–3790 | 2.40x | 346 | 28.83x | 40 | yes |
| world-markers-50 | 100 | plain | 36605 | 26183–51920 | 1.00x | 213 | 1.00x | 0 | yes |
| world-markers-50 | 100 | facet | 38972 | 32223–45750 | 1.06x | 1739 | 8.16x | 283 | yes |
| inventory-500 | 40 | plain | 4640 | 4323–4709 | 1.00x | 285 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 7358 | 7212–7874 | 1.59x | 7066 | 24.79x | 90 | yes |
| shop-filter-200 | 10 | plain | 1701 | 1421–1900 | 1.00x | 53 | 1.00x | 0 | yes |
| shop-filter-200 | 10 | facet | 4349 | 3711–5060 | 2.56x | 1199 | 22.62x | 62 | yes |
| virtual-scroll-2000 | 15 | plain | 1800 | 1500–1811 | 1.00x | 97 | 1.00x | 0 | yes |
| virtual-scroll-2000 | 15 | facet | 5537 | 4104–6312 | 3.08x | 897 | 9.25x | 14 | yes |
| chat-append-250 | 250 | plain | 6900 | 5014–11742 | 1.00x | 40 | 1.00x | 1 | yes |
| chat-append-250 | 250 | facet | 23332 | 19918–24644 | 3.38x | 1376 | 34.40x | 38 | yes |
| card-collection-60 | 1 | plain | 14110 | 9557–19952 | 1.00x | 15 | 1.00x | 0 | yes |
| card-collection-60 | 1 | facet | 53112 | 49856–59474 | 3.76x | 4390 | 292.67x | 806 | yes |
| mixed-scroll-300 | 50 | plain | 200 | 100–503 | 1.00x | 21 | 1.00x | 1 | yes |
| mixed-scroll-300 | 50 | facet | 2331 | 2200–3509 | 11.65x | 6187 | 294.62x | 97 | yes |
| settings-17-values | 17 | plain | 3907 | 3606–4304 | 1.00x | 212 | 1.00x | 0 | yes |
| settings-17-values | 17 | facet | 7311 | 6924–8738 | 1.87x | 1138 | 5.38x | 73 | yes |
| text-input-200 | 200 | plain | 907 | 508–1321 | 1.00x | 8 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 2201 | 1603–2504 | 2.43x | 296 | 37.00x | 16 | yes |
| button-feedback-50 | 15 | plain | 2522 | 2308–2531 | 1.00x | 30 | 1.00x | 0 | yes |
| button-feedback-50 | 15 | facet | 3041 | 2510–3702 | 1.21x | 486 | 16.47x | 36 | yes |
| stepper-segments-100 | 100 | plain | 7561 | 7218–8163 | 1.00x | 41 | 1.00x | 4 | yes |
| stepper-segments-100 | 100 | facet | 23575 | 22713–23825 | 3.12x | 524 | 12.78x | 59 | yes |
| toast-stream-4 | 8 | plain | 3020 | 2923–3051 | 1.00x | 8 | 1.00x | 0 | yes |
| toast-stream-4 | 8 | facet | 12664 | 12029–13965 | 4.19x | 290 | 34.18x | 28 | yes |
| tabs-5-5-switches | 5 | plain | 2328 | 2292–2564 | 1.00x | 7 | 1.00x | 1 | yes |
| tabs-5-5-switches | 5 | facet | 5006 | 4502–5131 | 2.15x | 986 | 140.86x | 46 | yes |
| radial-8-cycles | 32 | plain | 14868 | 14062–15356 | 1.00x | 74 | 1.00x | 0 | yes |
| radial-8-cycles | 32 | facet | 66161 | 65440–67166 | 4.45x | 862 | 11.58x | 64 | yes |
| navigation-5-6-cycles | 60 | plain | 18211 | 17410–18452 | 1.00x | 7 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 65198 | 64823–65518 | 3.58x | 432 | 61.64x | 64 | yes |
| leaderboard-100 | 6 | plain | 5004 | 4611–5041 | 1.00x | 52 | 1.00x | 1 | yes |
| leaderboard-100 | 6 | facet | 10441 | 9200–10690 | 2.09x | 7978 | 153.42x | 175 | yes |
| theme-swap-200 | 4 | plain | 100 | 100–200 | 1.00x | 12 | 1.00x | 0 | yes |
| theme-swap-200 | 4 | facet | 4206 | 2418–5269 | 42.06x | 2012 | 167.67x | 232 | yes |
| heavy-screen-20-cycles | 20 | plain | 253511 | 250842–255810 | 1.00x | 27 | 1.00x | 8 | yes |
| heavy-screen-20-cycles | 20 | facet | 553220 | 543381–553895 | 2.18x | 2691 | 99.67x | 276 | yes |
| tile-transfer-10 | 21 | plain | 9139 | 8319–9616 | 1.00x | 60 | 1.00x | 0 | yes |
| tile-transfer-10 | 21 | facet | 31438 | 30749–31536 | 3.44x | 701 | 11.68x | 44 | yes |
| input-type-switch-20 | 20 | plain | 3855 | 3639–3974 | 1.00x | 68 | 1.00x | 0 | yes |
| input-type-switch-20 | 20 | facet | 11776 | 10837–12874 | 3.05x | 1028 | 15.12x | 219 | yes |
| localized-text-swap-50 | 10 | plain | 1924 | 1805–2149 | 1.00x | 163 | 1.00x | 0 | yes |
| localized-text-swap-50 | 10 | facet | 5034 | 4532–5340 | 2.62x | 1349 | 8.28x | 263 | yes |
| text-size-preference-50 | 8 | plain | 921 | 700–1209 | 1.00x | 0 | 1.00x | 1 | yes |
| text-size-preference-50 | 8 | facet | 10832 | 9514–14175 | 11.76x | 1443 | 1443.00x | 356 | yes |
| phone-rotation-hub | 20 | plain | 801 | 600–1010 | 1.00x | 3 | 1.00x | 1 | yes |
| phone-rotation-hub | 20 | facet | 1308 | 700–2027 | 1.63x | 458 | 152.67x | 50 | yes |
| hud-composition-step-down | 10 | plain | 2105 | 1904–2323 | 1.00x | 12 | 1.00x | 0 | yes |
| hud-composition-step-down | 10 | facet | 12756 | 12274–12920 | 6.06x | 426 | 34.12x | 30 | yes |
| gamepad-grid-6x6 | 35 | plain | 1300 | 900–1600 | 1.00x | 7 | 1.00x | 0 | yes |
| gamepad-grid-6x6 | 35 | facet | 12948 | 12522–13529 | 9.96x | 983 | 140.43x | 24 | yes |
| drag-reorder-100 | 20 | plain | 24308 | 24263–25961 | 1.00x | 168 | 1.00x | 0 | yes |
| drag-reorder-100 | 20 | facet | 45742 | 45205–48407 | 1.88x | 2229 | 13.23x | 38 | yes |
| modal-on-modal | 12 | plain | 8446 | 8244–8603 | 1.00x | 10 | 1.00x | 2 | yes |
| modal-on-modal | 12 | facet | 35168 | 31401–43951 | 4.16x | 693 | 66.00x | 26 | yes |
| button-native-scale-50 | 6 | plain | 700 | 500–900 | 1.00x | 35 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 47979 | 46725–53123 | 68.54x | 908 | 25.94x | 38 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.83x | 30 | 42.45x |
