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
| Harness revision | `4cc8201` |
| Facet commit | `c8ae0b9b80eb91d1cbcf1710cc4775bc25975f84` |
| Facet tree | `d7336e48c4ff7e098633f3a4754b7a33a6640f39` |
| Date | 2026-11-14 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 1100 | 1000–1409 | 1.00x | 3 | 1.00x | 0 | yes |
| main-menu-cold | 1 | facet | 4500 | 4200–4700 | 4.09x | 294 | 98.00x | 29 | yes |
| hud-60-frames | 60 | plain | 2600 | 2500–2900 | 1.00x | 12 | 1.00x | 0 | yes |
| hud-60-frames | 60 | facet | 5100 | 4900–6000 | 1.96x | 332 | 27.67x | 41 | yes |
| world-markers-50 | 100 | plain | 22809 | 20700–38605 | 1.00x | 213 | 1.00x | 0 | yes |
| world-markers-50 | 100 | facet | 29205 | 20829–30500 | 1.28x | 1638 | 7.69x | 281 | yes |
| inventory-500 | 40 | plain | 9400 | 8800–9600 | 1.00x | 298 | 1.00x | 0 | yes |
| inventory-500 | 40 | facet | 12400 | 12000–13805 | 1.32x | 7730 | 25.98x | 84 | yes |
| shop-filter-200 | 10 | plain | 1200 | 800–1500 | 1.00x | 53 | 1.00x | 0 | yes |
| shop-filter-200 | 10 | facet | 2900 | 2800–3244 | 2.42x | 1197 | 22.58x | 63 | yes |
| virtual-scroll-2000 | 15 | plain | 2000 | 1700–2100 | 1.00x | 104 | 1.00x | 0 | yes |
| virtual-scroll-2000 | 15 | facet | 4000 | 3263–4300 | 2.00x | 863 | 8.30x | 28 | yes |
| chat-append-250 | 250 | plain | 4100 | 3800–4100 | 1.00x | 7 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 12200 | 10100–13100 | 2.98x | 1124 | 160.57x | 32 | yes |
| card-collection-60 | 1 | plain | 11900 | 11600–18900 | 1.00x | 16 | 1.00x | 0 | yes |
| card-collection-60 | 1 | facet | 42020 | 40200–44350 | 3.53x | 4313 | 269.56x | 804 | yes |
| mixed-scroll-300 | 50 | plain | 400 | 100–1100 | 1.00x | 37 | 1.00x | 0 | yes |
| mixed-scroll-300 | 50 | facet | 2600 | 2500–3000 | 6.50x | 5859 | 158.35x | 78 | yes |
| settings-17-values | 17 | plain | 7600 | 6800–8501 | 1.00x | 220 | 1.00x | 0 | yes |
| settings-17-values | 17 | facet | 14700 | 14600–15700 | 1.93x | 1098 | 4.99x | 64 | yes |
| text-input-200 | 200 | plain | 600 | 400–900 | 1.00x | 0 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 900 | 700–1700 | 1.50x | 294 | 294.00x | 16 | yes |
| button-feedback-50 | 15 | plain | 4300 | 4200–5200 | 1.00x | 26 | 1.00x | 1 | yes |
| button-feedback-50 | 15 | facet | 5002 | 4900–6500 | 1.16x | 453 | 17.42x | 37 | yes |
| stepper-segments-100 | 100 | plain | 12760 | 11600–14300 | 1.00x | 41 | 1.00x | 0 | yes |
| stepper-segments-100 | 100 | facet | 38100 | 37800–40031 | 2.99x | 532 | 12.99x | 66 | yes |
| toast-stream-4 | 8 | plain | 7600 | 7200–8000 | 1.00x | 8 | 1.00x | 4 | yes |
| toast-stream-4 | 8 | facet | 24479 | 22700–24900 | 3.22x | 298 | 37.19x | 24 | yes |
| tabs-5-5-switches | 5 | plain | 2700 | 2300–3300 | 1.00x | 15 | 1.00x | 1 | yes |
| tabs-5-5-switches | 5 | facet | 6600 | 5604–6900 | 2.44x | 980 | 65.33x | 48 | yes |
| radial-8-cycles | 32 | plain | 27301 | 26900–29017 | 1.00x | 86 | 1.00x | 9 | yes |
| radial-8-cycles | 32 | facet | 138937 | 138216–142246 | 5.09x | 878 | 10.21x | 58 | yes |
| navigation-5-6-cycles | 60 | plain | 25300 | 24800–26200 | 1.00x | 7 | 1.00x | 0 | yes |
| navigation-5-6-cycles | 60 | facet | 74357 | 73613–75500 | 2.94x | 408 | 58.21x | 49 | yes |
| leaderboard-100 | 6 | plain | 8800 | 8200–10220 | 1.00x | 50 | 1.00x | 0 | yes |
| leaderboard-100 | 6 | facet | 13200 | 12302–14904 | 1.50x | 7321 | 146.42x | 184 | yes |
| theme-swap-200 | 4 | plain | 900 | 800–1000 | 1.00x | 11 | 1.00x | 0 | yes |
| theme-swap-200 | 4 | facet | 2800 | 2400–2800 | 3.11x | 2026 | 184.18x | 370 | yes |
| heavy-screen-20-cycles | 20 | plain | 387122 | 384859–415480 | 1.00x | 21 | 1.00x | 1 | yes |
| heavy-screen-20-cycles | 20 | facet | 635698 | 630432–652461 | 1.64x | 2432 | 115.81x | 261 | yes |
| tile-transfer-10 | 21 | plain | 22702 | 22501–23501 | 1.00x | 54 | 1.00x | 0 | yes |
| tile-transfer-10 | 21 | facet | 53200 | 50815–54327 | 2.34x | 678 | 12.67x | 48 | yes |
| input-type-switch-20 | 20 | plain | 4100 | 3800–4601 | 1.00x | 75 | 1.00x | 0 | yes |
| input-type-switch-20 | 20 | facet | 10128 | 9600–11000 | 2.47x | 987 | 13.16x | 209 | yes |
| localized-text-swap-50 | 10 | plain | 2000 | 1800–2400 | 1.00x | 178 | 1.00x | 1 | yes |
| localized-text-swap-50 | 10 | facet | 4000 | 3700–5300 | 2.00x | 1254 | 7.04x | 269 | yes |
| text-size-preference-50 | 8 | plain | 700 | 600–1000 | 1.00x | 0 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 10200 | 8212–10900 | 14.57x | 1337 | 1337.00x | 345 | yes |
| phone-rotation-hub | 20 | plain | 400 | 200–700 | 1.00x | 3 | 1.00x | 0 | yes |
| phone-rotation-hub | 20 | facet | 1100 | 600–1500 | 2.75x | 418 | 139.33x | 37 | yes |
| hud-composition-step-down | 10 | plain | 6600 | 6000–7100 | 1.00x | 16 | 1.00x | 4 | yes |
| hud-composition-step-down | 10 | facet | 33502 | 32903–34800 | 5.08x | 404 | 24.48x | 29 | yes |
| gamepad-grid-6x6 | 35 | plain | 3100 | 2400–3200 | 1.00x | 19 | 1.00x | 0 | yes |
| gamepad-grid-6x6 | 35 | facet | 17023 | 16600–17702 | 5.49x | 900 | 47.39x | 26 | yes |
| drag-reorder-100 | 20 | plain | 34100 | 34100–36105 | 1.00x | 170 | 1.00x | 4 | yes |
| drag-reorder-100 | 20 | facet | 82313 | 82202–84628 | 2.41x | 2239 | 13.21x | 42 | yes |
| modal-on-modal | 12 | plain | 16100 | 15400–16500 | 1.00x | 8 | 1.00x | 3 | yes |
| modal-on-modal | 12 | facet | 51401 | 51000–52139 | 3.19x | 720 | 96.00x | 31 | yes |
| button-native-scale-50 | 6 | plain | 2000 | 1900–2800 | 1.00x | 10 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 7500 | 7500–7900 | 3.75x | 683 | 68.30x | 42 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 2.75x | 30 | 44.19x |
