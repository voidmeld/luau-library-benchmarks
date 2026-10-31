# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, in KiB. Teardown is the median retained heap after release. Both use the Verify `gc-witness-low-water/2` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | Apple M2 Max |
| Cores | 12 |
| Memory | 32 GiB |
| Model | Mac14,13 |
| Operating system | macOS 27.0 |
| Roblox Studio | 0.745.0.7451137 |
| Context | client |
| Harness revision | `8eba504` |
| Facet commit | `9cb4aecd2b02b877f161f9a1c617b5445bebe019` |
| Facet tree | `5800e47d72e81b37c17e48b64c491a6a39f4a55b` |
| Date | 2026-10-31 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 10640 | 5733–12995 | 1.00x | 493 | 1.00x | 9 | yes |
| main-menu-cold | 1 | facet | 13983 | 8113–17239 | 1.31x | 622 | 1.26x | 24 | yes |
| hud-120-frames | 120 | plain | 2831 | 1715–3207 | 1.00x | 490 | 1.00x | 2 | yes |
| hud-120-frames | 120 | facet | 3343 | 2000–3689 | 1.18x | 585 | 1.19x | 18 | yes |
| world-markers-50 | 100 | plain | 32684 | 31868–32900 | 1.00x | 607 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 45436 | 37247–60481 | 1.39x | 1347 | 2.22x | 13 | yes |
| inventory-500 | 40 | plain | 3534 | 3079–4114 | 1.00x | 815 | 1.00x | 9 | yes |
| inventory-500 | 40 | facet | 9826 | 9235–11358 | 2.78x | 23500 | 28.83x | 188 | yes |
| shop-filter-200 | 10 | plain | 1601 | 1509–1724 | 1.00x | 500 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 5316 | 4551–5618 | 3.32x | 2685 | 5.37x | 65 | yes |
| virtual-scroll-2000 | 50 | plain | 4539 | 4345–5365 | 1.00x | 612 | 1.00x | 1 | yes |
| virtual-scroll-2000 | 50 | facet | 18590 | 17681–20972 | 4.10x | 1984 | 3.24x | 29 | yes |
| chat-append-500 | 500 | plain | 31442 | 24310–34169 | 1.00x | 760 | 1.00x | 2 | yes |
| chat-append-500 | 500 | facet | 39749 | 32621–44229 | 1.26x | 1804 | 2.37x | 46 | yes |
| card-collection-60 | 1 | plain | 23960 | 13205–24384 | 1.00x | 502 | 1.00x | 2 | yes |
| card-collection-60 | 1 | facet | 51114 | 36358–56614 | 2.13x | 7151 | 14.25x | 78 | yes |
| mixed-scroll-300 | 100 | plain | 2829 | 2682–3428 | 1.00x | 509 | 1.00x | 1 | yes |
| mixed-scroll-300 | 100 | facet | 5625 | 4346–6320 | 1.99x | 10305 | 20.25x | 151 | yes |
| settings-17-values | 17 | plain | 302 | 200–599 | 1.00x | 543 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 921 | 701–1211 | 3.05x | 1618 | 2.98x | 61 | yes |
| text-input-200 | 200 | plain | 1000 | 600–1600 | 1.00x | 459 | 1.00x | 1 | yes |
| text-input-200 | 200 | facet | 2101 | 1204–3114 | 2.10x | 559 | 1.22x | 10 | yes |
| button-feedback-50 | 50 | plain | 5411 | 5034–6435 | 1.00x | 550 | 1.00x | 2 | yes |
| button-feedback-50 | 50 | facet | 5162 | 4519–6125 | 0.95x | 1065 | 1.93x | 40 | yes |
| stepper-segments-100 | 100 | plain | 2514 | 1400–3300 | 1.00x | 488 | 1.00x | 0 | yes |
| stepper-segments-100 | 100 | facet | 8230 | 6400–12476 | 3.27x | 833 | 1.71x | 57 | yes |
| toast-stream-20 | 40 | plain | 9990 | 8772–10679 | 1.00x | 480 | 1.00x | 2 | yes |
| toast-stream-20 | 40 | facet | 30268 | 28606–32224 | 3.03x | 591 | 1.23x | 40 | yes |
| tabs-5-20-switches | 20 | plain | 2408 | 1902–3315 | 1.00x | 510 | 1.00x | 1 | yes |
| tabs-5-20-switches | 20 | facet | 6622 | 6472–7083 | 2.75x | 1232 | 2.42x | 49 | yes |
| radial-50-cycles | 100 | plain | 66593 | 63577–67218 | 1.00x | 675 | 1.00x | 14 | yes |
| radial-50-cycles | 100 | facet | 634571 | 632215–641986 | 9.53x | 732 | 1.08x | 112 | yes |
| navigation-5-20-cycles | 200 | plain | 37800 | 35084–39746 | 1.00x | 487 | 1.00x | 2 | yes |
| navigation-5-20-cycles | 200 | facet | 104080 | 99071–108950 | 2.75x | 690 | 1.42x | 63 | yes |
| leaderboard-100 | 6 | plain | 2505 | 2444–2851 | 1.00x | 1442 | 1.00x | 2 | yes |
| leaderboard-100 | 6 | facet | 12015 | 11820–13015 | 4.80x | 18101 | 12.55x | 229 | yes |
| theme-swap-200 | 5 | plain | 300 | 200–823 | 1.00x | 739 | 1.00x | 721 | yes |
| theme-swap-200 | 5 | facet | 500 | 100–702 | 1.67x | 4525 | 6.12x | 367 | yes |
| heavy-screen-20-cycles | 20 | plain | 378501 | 359097–395418 | 1.00x | 3 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 609792 | 589377–628739 | 1.61x | 513 | 171.00x | 512 | yes |
| tile-transfer-20 | 20 | plain | 10480 | 9763–11817 | 1.00x | 523 | 1.00x | 1 | yes |
| tile-transfer-20 | 20 | facet | 48520 | 47165–48913 | 4.63x | 1759 | 3.36x | 46 | yes |
| input-type-switch-20 | 20 | plain | 2352 | 2237–2723 | 1.00x | 540 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 708 | 600–1106 | 0.30x | 1171 | 2.17x | 8 | yes |
| localized-text-swap-50 | 10 | plain | 4382 | 3603–4432 | 1.00x | 565 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 6808 | 6205–7137 | 1.55x | 1238 | 2.19x | 18 | yes |
| text-size-preference-50 | 8 | plain | 200 | 0–214 | 1.00x | 414 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 504 | 400–928 | 2.52x | 963 | 2.33x | 4 | yes |
| phone-rotation-hub | 20 | plain | 300 | 100–349 | 1.00x | 509 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 806 | 403–1207 | 2.69x | 779 | 1.53x | 35 | yes |
| hud-composition-step-down | 20 | plain | 1705 | 400–2232 | 1.00x | 472 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 1324 | 691–1507 | 0.78x | 600 | 1.27x | 8 | yes |
| gamepad-grid-6x6 | 35 | plain | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | facet | failed | — | — | — | — | — | — |
| drag-reorder-100 | 20 | plain | 7074 | 6148–7363 | 1.00x | 478 | 1.00x | 14 | yes |
| drag-reorder-100 | 20 | facet | 150513 | 143675–156487 | 21.28x | 6720 | 14.07x | 88 | yes |
| modal-on-modal | 20 | plain | 7370 | 7126–8045 | 1.00x | 450 | 1.00x | 5 | yes |
| modal-on-modal | 20 | facet | 56348 | 52900–59939 | 7.65x | 892 | 1.98x | 30 | yes |
| button-native-scale-50 | 20 | plain | 3252 | 2651–3541 | 1.00x | 437 | 1.00x | 1 | yes |
| button-native-scale-50 | 20 | facet | 3216 | 3091–3335 | 0.99x | 1371 | 3.14x | 33 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 29 | 1.00x | 29 | 1.00x |
| facet | 29 | 2.33x | 29 | 3.48x |
