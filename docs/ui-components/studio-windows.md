# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances, against real Roblox Instances in a Roblox Studio play client. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Harness revision | `a360b90` |
| Facet commit | `9dc3bdb6e1afd76dfd86a5427da140d41defc78a` |
| Facet tree | `d82f012344d1161d37b563d2977af7c0fe725600` |
| Date | 2026-11-13 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 1000 | 900–1200 | 1.00x | 2 | 1.00x | 0 | yes |
| main-menu-cold | 1 | facet | 4402 | 4300–4700 | 4.40x | 294 | 147.00x | 28 | yes |
| hud-60-frames | 60 | plain | 9800 | 9300–10600 | 1.00x | 39 | 1.00x | 26 | yes |
| hud-60-frames | 60 | facet | 5900 | 5200–6300 | 0.60x | 339 | 8.69x | 41 | yes |
| world-markers-50 | 100 | plain | failed | — | — | — | — | — | — |
| world-markers-50 | 100 | facet | 23200 | 22104–47925 | — | 1598 | — | 258 | — |
| inventory-500 | 40 | plain | 7001 | 7000–7900 | 1.00x | 292 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 12700 | 12400–13002 | 1.81x | 7587 | 25.94x | 88 | yes |
| shop-filter-200 | 10 | plain | 1400 | 1300–1500 | 1.00x | 54 | 1.00x | 1 | yes |
| shop-filter-200 | 10 | facet | 3800 | 3600–5000 | 2.71x | 1206 | 22.33x | 63 | yes |
| virtual-scroll-2000 | 15 | plain | 2000 | 1700–2500 | 1.00x | 104 | 1.00x | 0 | yes |
| virtual-scroll-2000 | 15 | facet | 4000 | 3800–4700 | 2.00x | 864 | 8.31x | 28 | yes |
| chat-append-250 | 250 | plain | 13150 | 13000–19800 | 1.00x | 8 | 1.00x | 1 | yes |
| chat-append-250 | 250 | facet | 12300 | 11200–14000 | 0.94x | 1122 | 140.25x | 33 | yes |
| card-collection-60 | 1 | plain | 12450 | 11500–13100 | 1.00x | 16 | 1.00x | 0 | yes |
| card-collection-60 | 1 | facet | 43769 | 42700–45116 | 3.52x | 4377 | 273.56x | 868 | yes |
| mixed-scroll-300 | 50 | plain | 600 | 200–700 | 1.00x | 29 | 1.00x | 0 | yes |
| mixed-scroll-300 | 50 | facet | 2950 | 2700–3600 | 4.92x | 5855 | 201.90x | 88 | yes |
| settings-17-values | 17 | plain | 7100 | 7000–7300 | 1.00x | 205 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 11500 | 10400–12500 | 1.62x | 1085 | 5.29x | 65 | yes |
| text-input-200 | 200 | plain | 600 | 400–700 | 1.00x | 7 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 1300 | 1000–1500 | 2.17x | 294 | 42.00x | 15 | yes |
| button-feedback-50 | 15 | plain | 5400 | 5000–6400 | 1.00x | 33 | 1.00x | 1 | yes |
| button-feedback-50 | 15 | facet | 5200 | 4600–5700 | 0.96x | 446 | 13.52x | 37 | yes |
| stepper-segments-100 | 100 | plain | 34401 | 34001–36100 | 1.00x | 77 | 1.00x | 35 | yes |
| stepper-segments-100 | 100 | facet | 36301 | 35200–37300 | 1.06x | 526 | 6.83x | 62 | yes |
| toast-stream-4 | 8 | plain | 4400 | 4301–5000 | 1.00x | 12 | 1.00x | 0 | yes |
| toast-stream-4 | 8 | facet | 14700 | 14200–16400 | 3.34x | 298 | 25.96x | 33 | yes |
| tabs-5-5-switches | 5 | plain | 2900 | 2800–3000 | 1.00x | 14 | 1.00x | 1 | yes |
| tabs-5-5-switches | 5 | facet | 7000 | 6400–7100 | 2.41x | 973 | 69.50x | 54 | yes |
| radial-15-cycles | 60 | plain | 36700 | 35700–37300 | 1.00x | 103 | 1.00x | 0 | yes |
| radial-15-cycles | 60 | facet | 175641 | 172606–176206 | 4.79x | 890 | 8.64x | 62 | yes |
| navigation-5-6-cycles | 60 | plain | 25700 | 25400–25900 | 1.00x | 10 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 80007 | 76958–80465 | 3.11x | 427 | 42.70x | 73 | yes |
| leaderboard-100 | 6 | plain | 8400 | 8100–9800 | 1.00x | 59 | 1.00x | 1 | yes |
| leaderboard-100 | 6 | facet | 13400 | 12800–13509 | 1.60x | 7193 | 121.92x | 175 | yes |
| theme-swap-200 | 4 | plain | 1200 | 700–1500 | 1.00x | 11 | 1.00x | 0 | yes |
| theme-swap-200 | 4 | facet | 3000 | 2600–3000 | 2.50x | 2052 | 186.55x | 378 | yes |
| heavy-screen-20-cycles | 20 | plain | 377020 | 375914–379218 | 1.00x | 28 | 1.00x | 4 | yes |
| heavy-screen-20-cycles | 20 | facet | 605017 | 604718–606919 | 1.60x | 2200 | 78.57x | 276 | yes |
| tile-transfer-20 | 41 | plain | 46600 | 44000–48105 | 1.00x | 89 | 1.00x | 5 | yes |
| tile-transfer-20 | 41 | facet | 108310 | 106382–109400 | 2.32x | 1047 | 11.76x | 48 | yes |
| input-type-switch-20 | 20 | plain | 5000 | 5000–5500 | 1.00x | 84 | 1.00x | 0 | yes |
| input-type-switch-20 | 20 | facet | 13200 | 12500–13400 | 2.64x | 989 | 11.77x | 210 | yes |
| localized-text-swap-50 | 10 | plain | 3700 | 3700–4401 | 1.00x | 206 | 1.00x | 28 | yes |
| localized-text-swap-50 | 10 | facet | 5803 | 4300–6200 | 1.57x | 1254 | 6.09x | 269 | yes |
| text-size-preference-50 | 8 | plain | 700 | 500–800 | 1.00x | 7 | 1.00x | 1 | yes |
| text-size-preference-50 | 8 | facet | 9100 | 8800–10300 | 13.00x | 1336 | 190.86x | 345 | yes |
| phone-rotation-hub | 20 | plain | 800 | 500–800 | 1.00x | 0 | 1.00x | 0 | yes |
| phone-rotation-hub | 20 | facet | 1600 | 1500–1600 | 2.00x | 418 | 418.00x | 42 | yes |
| hud-composition-step-down | 20 | plain | 11600 | 11500–11700 | 1.00x | 12 | 1.00x | 0 | yes |
| hud-composition-step-down | 20 | facet | 72400 | 69102–73709 | 6.24x | 400 | 33.33x | 30 | yes |
| gamepad-grid-6x6 | 35 | plain | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | facet | failed | — | — | — | — | — | — |
| drag-reorder-100 | 40 | plain | 73000 | 71400–73300 | 1.00x | 185 | 1.00x | 4 | yes |
| drag-reorder-100 | 40 | facet | 117714 | 115408–126501 | 1.61x | 2222 | 12.01x | 73 | yes |
| modal-on-modal | 20 | plain | 26001 | 23600–28500 | 1.00x | 0 | 1.00x | 4 | yes |
| modal-on-modal | 20 | facet | 82414 | 80216–86200 | 3.17x | 736 | 736.00x | 36 | yes |
| button-native-scale-50 | 6 | plain | 2000 | 1800–2400 | 1.00x | 18 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 7000 | 6700–7600 | 3.50x | 682 | 37.89x | 42 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 28 | 1.00x | 28 | 1.00x |
| facet | 28 | 2.37x | 28 | 40.27x |
