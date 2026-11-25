# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances, against real Roblox Instances in a Roblox Studio play client. The plain lane uses no library; it builds its own StyleSheet with values copied from the Facet neutral theme. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D |
| Threads | 32 |
| Memory | 62 GiB |
| Motherboard | MSI MS-7E47 |
| Operating system | Windows 11 Pro 10.0.26200 |
| Display scaling | 150% |
| Roblox Studio | 0.748.0.7481526 |
| Device | hd_1080 |
| Context | Client |
| Harness revision | `f245db2` |
| Facet commit | `4b4755f8` |
| Compose commit | `8defb058` (0.1.2) |
| Verify commit | `2e8cedeb` |
| Date | 2026-11-24 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks the first and last checkpoints and up to 10 evenly spaced checkpoints in an unmeasured parity pass before profiling.

## Results

All 30 workloads have timings. The full run passed 58/60 cases in 1318 s. Isolated retries measured `world-markers-50` and `navigation-5-6-cycles`. A dash marks a value missing from the supplied results.

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | — | facet | — | — | 4.40x | — | 294.00x | — | yes |
| hud-60-frames | — | facet | — | — | 3.14x | — | 67.80x | — | yes |
| world-markers-50 | — | facet | — | — | 1.09x | — | 8.12x | — | yes |
| inventory-500 | — | facet | — | — | 1.35x | — | 23.68x | — | yes |
| shop-filter-200 | — | facet | — | — | 2.42x | — | 22.77x | — | yes |
| virtual-scroll-2000 | — | facet | — | — | 2.32x | — | 8.70x | — | yes |
| chat-append-250 | — | facet | — | — | 3.71x | — | 35.28x | — | yes |
| card-collection-60 | — | facet | — | — | 3.71x | — | 190.87x | — | yes |
| mixed-scroll-300 | — | facet | — | — | 6.00x | — | 215.97x | — | yes |
| settings-17-values | — | facet | — | — | 1.85x | — | 5.26x | — | yes |
| text-input-200 | — | facet | — | — | 1.83x | — | 37.00x | — | yes |
| button-feedback-50 | — | facet | — | — | 1.25x | — | 14.32x | — | yes |
| stepper-segments-100 | — | facet | — | — | 3.53x | — | 12.89x | — | yes |
| toast-stream-4 | — | facet | — | — | 3.68x | — | 26.00x | — | yes |
| tabs-5-5-switches | — | facet | — | — | 2.59x | — | 45.23x | — | yes |
| radial-8-cycles | — | facet | — | — | 4.31x | — | 11.48x | — | yes |
| navigation-5-6-cycles | — | facet | — | — | 3.17x | — | 69.25x | — | yes |
| leaderboard-100 | — | facet | — | — | 1.55x | — | 135.78x | — | yes |
| theme-swap-200 | — | facet | — | — | 2.50x | — | 168.33x | — | yes |
| heavy-screen-20-cycles | — | facet | — | — | 1.69x | — | 141.68x | — | yes |
| tile-transfer-10 | — | facet | — | — | 2.70x | — | 12.41x | — | yes |
| input-type-switch-20 | — | facet | — | — | 2.90x | — | 13.61x | — | yes |
| localized-text-swap-50 | — | facet | — | — | 1.95x | — | 7.63x | — | yes |
| text-size-preference-50 | — | facet | — | — | 9.50x | — | 179.12x | — | yes |
| phone-rotation-hub | — | facet | — | — | 3.67x | — | 152.67x | — | yes |
| hud-composition-step-down | — | facet | — | — | 6.33x | — | 48.44x | — | yes |
| gamepad-grid-6x6 | — | facet | — | — | 6.15x | — | 81.58x | — | yes |
| drag-reorder-100 | — | facet | — | — | 2.50x | — | 13.20x | — | yes |
| modal-on-modal | — | facet | — | — | 3.56x | — | 100.21x | — | yes |
| button-native-scale-50 | — | facet | — | — | 64.66x | — | 21.02x | — | yes |

## Summary

The geometric means cover 28 workloads from the full run.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| facet | 28 | 3.33x | 28 | 40.20x |
