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
| Harness revision | `82fbc16` |
| Facet commit | `9dc3bdb6e1afd76dfd86a5427da140d41defc78a` |
| Facet tree | `d82f012344d1161d37b563d2977af7c0fe725600` |
| Date | 2026-11-13 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 10401 | 5436–11313 | 1.00x | 216 | 1.00x | 3 | yes |
| main-menu-cold | 1 | facet | 12047 | 11624–12443 | 1.16x | 288 | 1.33x | 26 | yes |
| hud-60-frames | 60 | plain | 1624 | 1570–1819 | 1.00x | 216 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 2457 | 2296–3000 | 1.51x | 217 | 1.00x | 0 | yes |
| world-markers-50 | 100 | plain | 20578 | 15240–21760 | 1.00x | 348 | 1.00x | 0 | yes |
| world-markers-50 | 100 | facet | 43573 | 35255–45129 | 2.12x | 913 | 2.62x | 0 | yes |
| inventory-500 | 40 | plain | 4705 | 3983–4719 | 1.00x | 448 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 6304 | 5170–7160 | 1.34x | 7878 | 17.57x | 86 | yes |
| shop-filter-200 | 10 | plain | 1803 | 1516–2232 | 1.00x | 230 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 5100 | 3849–5345 | 2.83x | 1182 | 5.14x | 53 | yes |
| virtual-scroll-2000 | 15 | plain | 900 | 735–1169 | 1.00x | 348 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 4803 | 4407–5839 | 5.34x | 869 | 2.50x | 19 | yes |
| chat-append-250 | 250 | plain | 20562 | 13468–22824 | 1.00x | 501 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 22813 | 20871–24572 | 1.11x | 1095 | 2.19x | 23 | yes |
| card-collection-60 | 1 | plain | 24322 | 16032–25318 | 1.00x | 212 | 1.00x | 2 | yes |
| card-collection-60 | 1 | facet | 69420 | 66941–73266 | 2.85x | 3442 | 16.24x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 471 | 300–523 | 1.00x | 227 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 2300 | 2101–2601 | 4.88x | 5887 | 25.93x | 84 | yes |
| settings-17-values | 17 | plain | 419 | 200–606 | 1.00x | 269 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1200 | 700–1448 | 2.86x | 1020 | 3.79x | 64 | yes |
| text-input-200 | 200 | plain | 1600 | 800–2115 | 1.00x | 212 | 1.00x | 3 | yes |
| text-input-200 | 200 | facet | 2211 | 1500–3101 | 1.38x | 290 | 1.37x | 13 | yes |
| button-feedback-50 | 15 | plain | 1501 | 1086–1680 | 1.00x | 232 | 1.00x | 1 | yes |
| button-feedback-50 | 15 | facet | 2241 | 1256–2736 | 1.49x | 448 | 1.94x | 32 | yes |
| stepper-segments-100 | 100 | plain | 2000 | 1222–2100 | 1.00x | 213 | 1.00x | 0 | yes |
| stepper-segments-100 | 100 | facet | 9349 | 6219–10408 | 4.67x | 349 | 1.64x | 0 | yes |
| toast-stream-4 | 8 | plain | 3223 | 3042–3326 | 1.00x | 215 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 16148 | 12897–16530 | 5.01x | 304 | 1.41x | 26 | yes |
| tabs-5-5-switches | 5 | plain | 1117 | 801–1280 | 1.00x | 228 | 1.00x | 1 | yes |
| tabs-5-5-switches | 5 | facet | 1942 | 1602–2376 | 1.74x | 879 | 3.86x | 44 | yes |
| radial-15-cycles | 30 | plain | 22270 | 20805–23416 | 1.00x | 256 | 1.00x | 2 | yes |
| radial-15-cycles | 30 | facet | 117480 | 111767–121587 | 5.28x | 869 | 3.39x | 64 | yes |
| navigation-5-6-cycles | 60 | plain | 13517 | 12531–14028 | 1.00x | 218 | 1.00x | 3 | yes |
| navigation-5-6-cycles | 60 | facet | 35783 | 32806–36939 | 2.65x | 374 | 1.72x | 45 | yes |
| leaderboard-100 | 3 | plain | 1100 | 1000–1117 | 1.00x | 1179 | 1.00x | 2 | yes |
| leaderboard-100 | 3 | facet | 3201 | 2906–3856 | 2.91x | 7224 | 6.13x | 0 | yes |
| theme-swap-200 | 2 | plain | 304 | 300–304 | 1.00x | 752 | 1.00x | 732 | yes |
| theme-swap-200 | 2 | facet | 104 | 100–205 | 0.34x | 2036 | 2.71x | 187 | yes |
| heavy-screen-20-cycles | 20 | plain | 360846 | 353421–383634 | 1.00x | 2 | 1.00x | 0 | yes |
| heavy-screen-20-cycles | 20 | facet | 512373 | 492517–532097 | 1.42x | 498 | 249.00x | 490 | yes |
| tile-transfer-20 | 20 | plain | 10023 | 9188–10246 | 1.00x | 250 | 1.00x | 0 | yes |
| tile-transfer-20 | 20 | facet | 39921 | 39364–40819 | 3.98x | 1286 | 5.15x | 44 | yes |
| input-type-switch-20 | 20 | plain | 1225 | 713–1514 | 1.00x | 274 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 12572 | 11529–13886 | 10.26x | 768 | 2.80x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2106 | 2000–2586 | 1.00x | 347 | 1.00x | 3 | yes |
| localized-text-swap-50 | 10 | facet | 4707 | 4273–5228 | 2.24x | 902 | 2.60x | 0 | yes |
| text-size-preference-50 | 8 | plain | 205 | 100–301 | 1.00x | 198 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 10630 | 9600–11920 | 51.85x | 979 | 4.94x | 0 | yes |
| phone-rotation-hub | 20 | plain | 250 | 200–405 | 1.00x | 223 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 852 | 700–992 | 3.41x | 409 | 1.83x | 39 | yes |
| hud-composition-step-down | 20 | plain | 1631 | 1353–1752 | 1.00x | 212 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 16100 | 15190–16449 | 9.87x | 334 | 1.57x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | 1507 | 1397–1861 | 1.00x | 218 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 11322 | 10600–11586 | 7.51x | 898 | 4.12x | 24 | yes |
| drag-reorder-100 | 20 | plain | 6705 | 6342–7839 | 1.00x | 250 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 75458 | 72828–75937 | 11.25x | 2278 | 9.13x | 39 | yes |
| modal-on-modal | 20 | plain | 9831 | 9711–10742 | 1.00x | 205 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 49217 | 47087–53914 | 5.01x | 704 | 3.43x | 24 | yes |
| button-native-scale-50 | 6 | plain | 988 | 600–1142 | 1.00x | 214 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 2349 | 2129–2364 | 2.38x | 677 | 3.16x | 33 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.15x | 30 | 3.84x |
