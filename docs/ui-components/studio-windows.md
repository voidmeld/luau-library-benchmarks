# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Harness revision | `82fbc16` |
| Facet commit | `9dc3bdb6e1afd76dfd86a5427da140d41defc78a` |
| Facet tree | `d82f012344d1161d37b563d2977af7c0fe725600` |
| Date | 2026-11-13 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 3392 | 3300–3600 | 1.00x | 225 | 1.00x | 3 | yes |
| main-menu-cold | 1 | facet | 4400 | 4000–4501 | 1.30x | 296 | 1.32x | 27 | yes |
| hud-60-frames | 60 | plain | 1400 | 900–1900 | 1.00x | 215 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 5300 | 3800–8300 | 3.79x | 209 | 0.97x | 0 | yes |
| world-markers-50 | 100 | plain | 8801 | 8600–9000 | 1.00x | 356 | 1.00x | 3 | yes |
| world-markers-50 | 100 | facet | 24202 | 22302–39806 | 2.75x | 912 | 2.56x | 0 | yes |
| inventory-500 | 40 | plain | 8500 | 8300–8600 | 1.00x | 445 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 12900 | 12700–13202 | 1.52x | 7783 | 17.49x | 82 | yes |
| shop-filter-200 | 10 | plain | 1250 | 1150–1500 | 1.00x | 230 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 3100 | 3000–3450 | 2.48x | 1182 | 5.14x | 54 | yes |
| virtual-scroll-2000 | 15 | plain | 1000 | 700–1050 | 1.00x | 347 | 1.00x | 0 | yes |
| virtual-scroll-2000 | 15 | facet | 4000 | 3603–4250 | 4.00x | 869 | 2.50x | 19 | yes |
| chat-append-250 | 250 | plain | 8500 | 8100–9100 | 1.00x | 500 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 12500 | 9810–14139 | 1.47x | 1087 | 2.17x | 31 | yes |
| card-collection-60 | 1 | plain | 11800 | 11600–12600 | 1.00x | 212 | 1.00x | 10 | yes |
| card-collection-60 | 1 | facet | 48100 | 46400–48802 | 4.08x | 3433 | 16.19x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 600 | 500–800 | 1.00x | 228 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 3100 | 2600–3900 | 5.17x | 5983 | 26.24x | 83 | yes |
| settings-17-values | 17 | plain | 400 | 200–550 | 1.00x | 271 | 1.00x | 3 | yes |
| settings-17-values | 17 | facet | 1650 | 1350–1800 | 4.12x | 1027 | 3.79x | 65 | yes |
| text-input-200 | 200 | plain | 600 | 400–733 | 1.00x | 211 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 667 | 533–933 | 1.11x | 282 | 1.34x | 5 | yes |
| button-feedback-50 | 15 | plain | 3800 | 3800–4000 | 1.00x | 239 | 1.00x | 3 | yes |
| button-feedback-50 | 15 | facet | 3800 | 3300–4200 | 1.00x | 457 | 1.91x | 36 | yes |
| stepper-segments-100 | 100 | plain | 533 | 401–567 | 1.00x | 221 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 3300 | 2900–3600 | 6.19x | 348 | 1.57x | 0 | yes |
| toast-stream-4 | 8 | plain | 5200 | 4600–5500 | 1.00x | 214 | 1.00x | 1 | yes |
| toast-stream-4 | 8 | facet | 24023 | 23800–24200 | 4.62x | 300 | 1.40x | 18 | yes |
| tabs-5-5-switches | 5 | plain | 1900 | 1200–2200 | 1.00x | 228 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 3400 | 3100–3700 | 1.79x | 887 | 3.89x | 52 | yes |
| radial-15-cycles | 30 | plain | 36003 | 34803–37600 | 1.00x | 268 | 1.00x | 2 | yes |
| radial-15-cycles | 30 | facet | 234541 | 231342–238389 | 6.51x | 888 | 3.31x | 60 | yes |
| navigation-5-6-cycles | 60 | plain | 18300 | 18100–19101 | 1.00x | 224 | 1.00x | 1 | yes |
| navigation-5-6-cycles | 60 | facet | 38107 | 36914–39707 | 2.08x | 374 | 1.67x | 37 | yes |
| leaderboard-100 | 3 | plain | 700 | 650–858 | 1.00x | 1179 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 2301 | 1800–2800 | 3.29x | 7249 | 6.15x | 0 | yes |
| theme-swap-200 | 2 | plain | 1200 | 600–1600 | 1.00x | 756 | 1.00x | 738 | yes |
| theme-swap-200 | 2 | facet | 1200 | 800–1600 | 1.00x | 2045 | 2.71x | 180 | yes |
| heavy-screen-20-cycles | 20 | plain | 475988 | 467038–491495 | 1.00x | 0 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 677483 | 653016–689585 | 1.42x | 506 | 506.00x | 498 | yes |
| tile-transfer-20 | 20 | plain | 19102 | 18600–20300 | 1.00x | 254 | 1.00x | 6 | yes |
| tile-transfer-20 | 20 | facet | 87900 | 86000–89125 | 4.60x | 1333 | 5.26x | 42 | yes |
| input-type-switch-20 | 20 | plain | 1000 | 900–1100 | 1.00x | 275 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 10000 | 9417–10400 | 10.00x | 768 | 2.79x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2150 | 1800–2200 | 1.00x | 347 | 1.00x | 3 | yes |
| localized-text-swap-50 | 10 | facet | 3700 | 3403–4600 | 1.72x | 897 | 2.59x | 0 | yes |
| text-size-preference-50 | 8 | plain | 200 | 100–250 | 1.00x | 198 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 10007 | 9703–10900 | 50.03x | 972 | 4.91x | 0 | yes |
| phone-rotation-hub | 20 | plain | 500 | 300–700 | 1.00x | 223 | 1.00x | 3 | yes |
| phone-rotation-hub | 20 | facet | 1100 | 900–1300 | 2.20x | 417 | 1.87x | 41 | yes |
| hud-composition-step-down | 20 | plain | 3200 | 2900–3500 | 1.00x | 212 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 14500 | 13800–14501 | 4.53x | 320 | 1.51x | 6 | yes |
| gamepad-grid-6x6 | 35 | plain | 3011 | 3000–3700 | 1.00x | 222 | 1.00x | 3 | yes |
| gamepad-grid-6x6 | 35 | facet | 15303 | 15005–15800 | 5.08x | 905 | 4.08x | 24 | yes |
| drag-reorder-100 | 20 | plain | 14900 | 14700–15429 | 1.00x | 257 | 1.00x | 1 | yes |
| drag-reorder-100 | 20 | facet | 141005 | 136205–142193 | 9.46x | 2268 | 8.82x | 39 | yes |
| modal-on-modal | 20 | plain | 16205 | 14500–16417 | 1.00x | 227 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 86603 | 86104–87503 | 5.34x | 704 | 3.10x | 22 | yes |
| button-native-scale-50 | 6 | plain | 1800 | 1600–2000 | 1.00x | 230 | 1.00x | 11 | yes |
| button-native-scale-50 | 6 | facet | 7300 | 6801–8200 | 4.06x | 677 | 2.94x | 33 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.31x | 30 | 3.88x |
