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
| Harness revision | `b27a079` |
| Facet commit | `053b475d628f1a96abc5293247ecd46295688fb1` |
| Facet tree | `42054c606ee5f7d27365b94aa441664a311e9303` |
| Date | 2026-11-02 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

The rows for button-feedback-50, tabs-5-20-switches, tile-transfer-20 and drag-reorder-100 come from a rerun of those 8 lanes on the same machine, harness revision and Facet commit. In the first run, 7 of those lanes failed because a screen recording took input focus from the Studio client.

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 7110 | 5182–8871 | 1.00x | 500 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 14520 | 10078–17571 | 2.04x | 600 | 1.20x | 34 | yes |
| hud-120-frames | 120 | plain | 4220 | 2721–4518 | 1.00x | 493 | 1.00x | 2 | yes |
| hud-120-frames | 120 | facet | 6623 | 4526–10751 | 1.57x | 566 | 1.15x | 18 | yes |
| world-markers-50 | 100 | plain | 24188 | 20573–26092 | 1.00x | 619 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 30130 | 23370–36025 | 1.25x | 1338 | 2.16x | 1 | yes |
| inventory-500 | 40 | plain | 4184 | 4038–4914 | 1.00x | 821 | 1.00x | 3 | yes |
| inventory-500 | 40 | facet | 8763 | 8154–10004 | 2.09x | 18537 | 22.58x | 197 | yes |
| shop-filter-200 | 10 | plain | 1667 | 1146–2063 | 1.00x | 511 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 4202 | 3212–4906 | 2.52x | 2493 | 4.88x | 87 | yes |
| virtual-scroll-2000 | 50 | plain | 4590 | 3959–5064 | 1.00x | 632 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 50 | facet | 16742 | 15389–17066 | 3.65x | 1609 | 2.55x | 28 | yes |
| chat-append-500 | 500 | plain | 31821 | 24947–35050 | 1.00x | 788 | 1.00x | 2 | yes |
| chat-append-500 | 500 | facet | 47760 | 36805–50333 | 1.50x | 2379 | 3.02x | 54 | yes |
| card-collection-60 | 1 | plain | 27642 | 20826–31503 | 1.00x | 516 | 1.00x | 3 | yes |
| card-collection-60 | 1 | facet | 51302 | 43231–54698 | 1.86x | 5446 | 10.55x | 114 | yes |
| mixed-scroll-300 | 100 | plain | 1164 | 518–1608 | 1.00x | 508 | 1.00x | 2 | yes |
| mixed-scroll-300 | 100 | facet | 5903 | 5307–6324 | 5.07x | 8248 | 16.24x | 170 | yes |
| settings-17-values | 17 | plain | 335 | 300–600 | 1.00x | 548 | 1.00x | 3 | yes |
| settings-17-values | 17 | facet | 1513 | 1400–1616 | 4.52x | 1521 | 2.78x | 75 | yes |
| text-input-200 | 200 | plain | 1608 | 505–1804 | 1.00x | 477 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 1904 | 1001–2300 | 1.18x | 560 | 1.17x | 20 | yes |
| button-feedback-50 | 50 | plain | 6196 | 5528–6425 | 1.00x | 560 | 1.00x | 2 | yes |
| button-feedback-50 | 50 | facet | 7308 | 5923–7648 | 1.18x | 856 | 1.53x | 24 | yes |
| stepper-segments-100 | 100 | plain | 2101 | 1301–2409 | 1.00x | 486 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 7120 | 5646–8170 | 3.39x | 795 | 1.64x | 62 | yes |
| toast-stream-20 | 40 | plain | 16687 | 15565–17474 | 1.00x | 488 | 1.00x | 2 | yes |
| toast-stream-20 | 40 | facet | 60568 | 57008–62052 | 3.63x | 540 | 1.11x | 62 | yes |
| tabs-5-20-switches | 20 | plain | 3374 | 2950–3815 | 1.00x | 529 | 1.00x | 2 | yes |
| tabs-5-20-switches | 20 | facet | 5938 | 5218–6613 | 1.76x | 1201 | 2.27x | 54 | yes |
| radial-50-cycles | 100 | plain | 98009 | 96031–105238 | 1.00x | 735 | 1.00x | 6 | yes |
| radial-50-cycles | 100 | facet | 537330 | 531051–557238 | 5.48x | 1165 | 1.59x | 110 | yes |
| navigation-5-20-cycles | 200 | plain | 48728 | 48116–50425 | 1.00x | 499 | 1.00x | 3 | yes |
| navigation-5-20-cycles | 200 | facet | 163958 | 158429–167468 | 3.36x | 659 | 1.32x | 105 | yes |
| leaderboard-100 | 6 | plain | 2547 | 2409–2552 | 1.00x | 1455 | 1.00x | 3 | yes |
| leaderboard-100 | 6 | facet | 10760 | 10073–11606 | 4.22x | 14099 | 9.69x | 230 | yes |
| theme-swap-200 | 5 | plain | 236060 | 195024–277330 | 1.00x | 26 | 1.00x | 714 | yes |
| theme-swap-200 | 5 | facet | 1438798 | 1355074–1514064 | 6.10x | 3015 | 115.96x | 373 | yes |
| heavy-screen-20-cycles | 20 | plain | 13910735 | 12991379–14815993 | 1.00x | 1 | 1.00x | 0 | yes |
| heavy-screen-20-cycles | 20 | facet | 6622469 | 5349684–8105900 | 0.48x | 0 | 0.00x | 488 | yes |
| tile-transfer-20 | 20 | plain | 12938 | 12480–13932 | 1.00x | 533 | 1.00x | 2 | yes |
| tile-transfer-20 | 20 | facet | 52362 | 52049–55953 | 4.05x | 1580 | 2.96x | 50 | yes |
| input-type-switch-20 | 20 | plain | 2411 | 2214–2706 | 1.00x | 545 | 1.00x | 10 | yes |
| input-type-switch-20 | 20 | facet | 4969 | 4609–5149 | 2.06x | 1140 | 2.09x | 19 | yes |
| localized-text-swap-50 | 10 | plain | 17928141 | 17888946–17967821 | 1.00x | 574 | 1.00x | 0 | yes |
| localized-text-swap-50 | 10 | facet | 19240153 | 19190713–19289707 | 1.07x | 1220 | 2.13x | 20 | yes |
| text-size-preference-50 | 8 | plain | 22047009 | 22010286–22085931 | 1.00x | 423 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 20626451 | 20559933–20690100 | 0.94x | 1365 | 3.23x | 1 | yes |
| phone-rotation-hub | 20 | plain | 400 | 300–617 | 1.00x | 509 | 1.00x | 0 | yes |
| phone-rotation-hub | 20 | facet | 1202 | 800–1400 | 3.00x | 712 | 1.40x | 48 | yes |
| hud-composition-step-down | 20 | plain | 2101 | 1707–2348 | 1.00x | 471 | 1.00x | 6 | yes |
| hud-composition-step-down | 20 | facet | 1770 | 1606–2021 | 0.84x | 634 | 1.35x | 8 | yes |
| gamepad-grid-6x6 | 35 | plain | 1753 | 1388–2319 | 1.00x | 480 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 13133 | 12115–13220 | 7.49x | 1967 | 4.10x | 47 | yes |
| drag-reorder-100 | 20 | plain | 6474 | 4284–7540 | 1.00x | 553 | 1.00x | 6 | yes |
| drag-reorder-100 | 20 | facet | 88049 | 83622–95807 | 13.60x | 3338 | 6.04x | 76 | yes |
| modal-on-modal | 20 | plain | 23613101 | 23540730–23685659 | 1.00x | 443 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 24917409 | 24730769–25105039 | 1.06x | 846 | 1.91x | 32 | yes |
| button-native-scale-50 | 20 | plain | 27287973 | 27220151–27357949 | 1.00x | 434 | 1.00x | 0 | yes |
| button-native-scale-50 | 20 | facet | 26070866 | 25990254–26147395 | 0.96x | 1463 | 3.37x | 42 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 29 | 1.00x |
| facet | 30 | 2.30x | 29 | 3.14x |
