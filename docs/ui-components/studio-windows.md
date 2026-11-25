# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances, against real Roblox Instances in a Roblox Studio play client. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D |
| Cores | 16 |
| Threads | 32 |
| Memory | 61.6 GB |
| Operating system | Windows 11 Pro 10.0.26200 |
| Display scaling | 150% |
| Roblox Studio | 0.748.0.7481526 |
| Harness revision | `b4a9ac7` |
| Facet commit | `895d0571` |
| Compose commit | `206648c0` |
| Verify commit | `2e8cedeb` |
| Date | 2026-11-24 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

29/30 workloads passed parity and have timings. The display was awake for `modal-on-modal` and the reruns of `world-markers-50`, `radial-8-cycles`, `leaderboard-100`, `tile-transfer-10`, and `drag-reorder-100`. A dash marks a value missing from the supplied results.

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | — | facet | — | — | 4.70x | — | 345.00x | — | yes |
| hud-60-frames | — | facet | — | — | 2.11x | — | 28.92x | — | yes |
| world-markers-50 | — | facet | — | — | 1.15x | — | 8.11x | — | yes |
| inventory-500 | — | facet | — | — | — | — | — | — | no |
| shop-filter-200 | — | facet | — | — | 3.27x | — | 51.08x | — | yes |
| virtual-scroll-2000 | — | facet | — | — | 2.58x | — | 8.65x | — | yes |
| chat-append-250 | — | facet | — | — | 3.83x | — | 35.08x | — | yes |
| card-collection-60 | — | facet | — | — | 3.50x | — | 272.88x | — | yes |
| mixed-scroll-300 | — | facet | — | — | 7.00x | — | 243.93x | — | yes |
| settings-17-values | — | facet | — | — | 1.59x | — | 6.67x | — | yes |
| text-input-200 | — | facet | — | — | 1.38x | — | 36.00x | — | yes |
| button-feedback-50 | — | facet | — | — | 1.04x | — | 31.96x | — | yes |
| stepper-segments-100 | — | facet | — | — | 2.92x | — | 13.00x | — | yes |
| toast-stream-4 | — | facet | — | — | 2.90x | — | 26.52x | — | yes |
| tabs-5-5-switches | — | facet | — | — | 2.56x | — | 74.14x | — | yes |
| radial-8-cycles | — | facet | — | — | 3.73x | — | 11.10x | — | yes |
| navigation-5-6-cycles | — | facet | — | — | 2.94x | — | 39.19x | — | yes |
| leaderboard-100 | — | facet | — | — | 1.60x | — | 161.58x | — | yes |
| theme-swap-200 | — | facet | — | — | 2.55x | — | 309.83x | — | yes |
| heavy-screen-20-cycles | — | facet | — | — | 2.11x | — | 154.96x | — | yes |
| tile-transfer-10 | — | facet | — | — | 2.19x | — | 13.43x | — | yes |
| input-type-switch-20 | — | facet | — | — | 2.42x | — | 13.54x | — | yes |
| localized-text-swap-50 | — | facet | — | — | 2.09x | — | 7.62x | — | yes |
| text-size-preference-50 | — | facet | — | — | 11.22x | — | 204.71x | — | yes |
| phone-rotation-hub | — | facet | — | — | 3.25x | — | 125.25x | — | yes |
| hud-composition-step-down | — | facet | — | — | 9.35x | — | 33.04x | — | yes |
| gamepad-grid-6x6 | — | facet | — | — | 4.94x | — | 89.45x | — | yes |
| drag-reorder-100 | — | facet | — | — | 2.42x | — | 12.89x | — | yes |
| modal-on-modal | — | plain | 15209 | — | — | 14 | — | — | yes |
| modal-on-modal | — | facet | 56306 | — | 3.70x | 728 | 50.17x | — | yes |
| button-native-scale-50 | — | facet | — | — | 68.80x | — | 30.44x | — | yes |

The inventory-500 parity failure remains an open Facet text-extent issue. With BuilderSans at size 18 and Windows display scaling at 150%, Facet measured 55x16 and plain measured 55x18.

## Summary

The geometric means cover 23 workloads from the full run.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| facet | 23 | 3.51x | 23 | 49.40x |
