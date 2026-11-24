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
| Harness revision | `4cc8201` |
| Facet commit | `c8ae0b9b80eb91d1cbcf1710cc4775bc25975f84` |
| Facet tree | `d7336e48c4ff7e098633f3a4754b7a33a6640f39` |
| Date | 2026-11-14 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 1800 | 1411–2500 | 1.00x | 2 | 1.00x | 0 | yes |
| main-menu-cold | 1 | facet | 7013 | 5956–12522 | 3.90x | 293 | 146.50x | 27 | yes |
| hud-60-frames | 60 | plain | 1766 | 915–1920 | 1.00x | 5 | 1.00x | 0 | yes |
| hud-60-frames | 60 | facet | 2705 | 2600–2770 | 1.53x | 339 | 67.80x | 41 | yes |
| world-markers-50 | 100 | plain | 42761 | 40790–52872 | 1.00x | 213 | 1.00x | 0 | yes |
| world-markers-50 | 100 | facet | 38093 | 35491–47466 | 0.89x | 1636 | 7.68x | 274 | yes |
| inventory-500 | 40 | plain | 3693 | 3601–4050 | 1.00x | 284 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 6872 | 4872–7694 | 1.86x | 7691 | 27.03x | 84 | yes |
| shop-filter-200 | 10 | plain | 1310 | 1300–2212 | 1.00x | 53 | 1.00x | 0 | yes |
| shop-filter-200 | 10 | facet | 5130 | 4218–6914 | 3.92x | 1204 | 22.72x | 55 | yes |
| virtual-scroll-2000 | 15 | plain | 1800 | 1519–2055 | 1.00x | 96 | 1.00x | 1 | yes |
| virtual-scroll-2000 | 15 | facet | 4605 | 4534–5000 | 2.56x | 864 | 9.00x | 20 | yes |
| chat-append-250 | 250 | plain | 13823 | 4119–14958 | 1.00x | 8 | 1.00x | 1 | yes |
| chat-append-250 | 250 | facet | 22744 | 20229–25936 | 1.65x | 1123 | 140.38x | 32 | yes |
| card-collection-60 | 1 | plain | 23463 | 16218–25027 | 1.00x | 15 | 1.00x | 0 | yes |
| card-collection-60 | 1 | facet | 57859 | 53743–65134 | 2.47x | 4314 | 287.60x | 805 | yes |
| mixed-scroll-300 | 50 | plain | 100 | 100–400 | 1.00x | 28 | 1.00x | 0 | yes |
| mixed-scroll-300 | 50 | facet | 2100 | 2000–2500 | 21.00x | 5851 | 208.96x | 84 | yes |
| settings-17-values | 17 | plain | 4014 | 3818–4136 | 1.00x | 207 | 1.00x | 4 | yes |
| settings-17-values | 17 | facet | 6265 | 5461–6445 | 1.56x | 1086 | 5.25x | 72 | yes |
| text-input-200 | 200 | plain | 1101 | 700–1417 | 1.00x | 8 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 1807 | 1102–2205 | 1.64x | 293 | 36.62x | 16 | yes |
| button-feedback-50 | 15 | plain | 2015 | 1933–2454 | 1.00x | 26 | 1.00x | 0 | yes |
| button-feedback-50 | 15 | facet | 2231 | 2231–2423 | 1.11x | 445 | 17.12x | 30 | yes |
| stepper-segments-100 | 100 | plain | 6466 | 5646–6586 | 1.00x | 34 | 1.00x | 0 | yes |
| stepper-segments-100 | 100 | facet | 18037 | 16482–19135 | 2.79x | 520 | 15.54x | 62 | yes |
| toast-stream-4 | 8 | plain | 2402 | 2108–2845 | 1.00x | 2 | 1.00x | 0 | yes |
| toast-stream-4 | 8 | facet | 13885 | 13801–15954 | 5.78x | 294 | 147.25x | 32 | yes |
| tabs-5-5-switches | 5 | plain | 1742 | 1500–1800 | 1.00x | 14 | 1.00x | 8 | yes |
| tabs-5-5-switches | 5 | facet | 4642 | 3800–5636 | 2.66x | 972 | 69.43x | 47 | yes |
| radial-8-cycles | 32 | plain | 12954 | 12584–13869 | 1.00x | 66 | 1.00x | 0 | yes |
| radial-8-cycles | 32 | facet | 59938 | 59835–60512 | 4.63x | 865 | 13.21x | 65 | yes |
| navigation-5-6-cycles | 60 | plain | 13601 | 13394–14665 | 1.00x | 14 | 1.00x | 5 | yes |
| navigation-5-6-cycles | 60 | facet | 57965 | 56902–59216 | 4.26x | 432 | 29.76x | 70 | yes |
| leaderboard-100 | 6 | plain | 4655 | 4200–4737 | 1.00x | 51 | 1.00x | 0 | yes |
| leaderboard-100 | 6 | facet | 8656 | 7910–8704 | 1.86x | 7265 | 142.45x | 175 | yes |
| theme-swap-200 | 4 | plain | 100 | 100–229 | 1.00x | 11 | 1.00x | 0 | yes |
| theme-swap-200 | 4 | facet | 7304 | 5892–7502 | 73.04x | 2035 | 185.00x | 377 | yes |
| heavy-screen-20-cycles | 20 | plain | 261874 | 256812–265480 | 1.00x | 20 | 1.00x | 0 | yes |
| heavy-screen-20-cycles | 20 | facet | 496049 | 487752–497924 | 1.89x | 2419 | 120.95x | 276 | yes |
| tile-transfer-10 | 21 | plain | 8411 | 8153–8471 | 1.00x | 50 | 1.00x | 0 | yes |
| tile-transfer-10 | 21 | facet | 26440 | 25438–26614 | 3.14x | 672 | 13.43x | 46 | yes |
| input-type-switch-20 | 20 | plain | 4264 | 3670–4434 | 1.00x | 76 | 1.00x | 8 | yes |
| input-type-switch-20 | 20 | facet | 13254 | 11185–13876 | 3.11x | 988 | 13.00x | 218 | yes |
| localized-text-swap-50 | 10 | plain | 2400 | 2220–2439 | 1.00x | 163 | 1.00x | 0 | yes |
| localized-text-swap-50 | 10 | facet | 5430 | 4630–5913 | 2.26x | 1246 | 7.64x | 259 | yes |
| text-size-preference-50 | 8 | plain | 1114 | 803–1427 | 1.00x | 7 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 10205 | 9211–11306 | 9.16x | 1340 | 191.43x | 347 | yes |
| phone-rotation-hub | 20 | plain | 300 | 200–400 | 1.00x | 5 | 1.00x | 1 | yes |
| phone-rotation-hub | 20 | facet | 1000 | 905–1065 | 3.33x | 418 | 83.60x | 42 | yes |
| hud-composition-step-down | 10 | plain | 1447 | 995–2000 | 1.00x | 12 | 1.00x | 4 | yes |
| hud-composition-step-down | 10 | facet | 8426 | 8157–9611 | 5.82x | 384 | 30.68x | 21 | yes |
| gamepad-grid-6x6 | 35 | plain | 1746 | 1312–1800 | 1.00x | 4 | 1.00x | 0 | yes |
| gamepad-grid-6x6 | 35 | facet | 11603 | 11104–11982 | 6.65x | 916 | 261.57x | 42 | yes |
| drag-reorder-100 | 20 | plain | 16076 | 15443–18579 | 1.00x | 173 | 1.00x | 0 | yes |
| drag-reorder-100 | 20 | facet | 40469 | 39812–42828 | 2.52x | 2243 | 12.97x | 44 | yes |
| modal-on-modal | 12 | plain | 8228 | 7242–8340 | 1.00x | 11 | 1.00x | 7 | yes |
| modal-on-modal | 12 | facet | 36517 | 35994–38525 | 4.44x | 708 | 64.32x | 27 | yes |
| button-native-scale-50 | 6 | plain | 882 | 714–1174 | 1.00x | 18 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 2200 | 1700–2246 | 2.49x | 683 | 36.92x | 43 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.31x | 30 | 43.28x |
