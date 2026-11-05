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
| Roblox Studio | 0.746.0.7461264 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `36cfbf9` |
| Facet commit | `e707bb3cfe904ed951bd3fe3c9eb4965b90484ff` |
| Facet tree | `63a303a26ff11f628d930cd99f809ea5f607fe17` |
| Date | 2026-11-05 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 4500 | 4100–4805 | 1.00x | 491 | 1.00x | 3 | yes |
| main-menu-cold | 1 | facet | 5400 | 5000–6100 | 1.20x | 615 | 1.25x | 28 | yes |
| hud-60-frames | 60 | plain | 2700 | 2700–3200 | 1.00x | 487 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 6600 | 6100–7200 | 2.44x | 588 | 1.21x | 19 | yes |
| world-markers-50 | 100 | plain | 11502 | 10500–13801 | 1.00x | 620 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 27200 | 24700–33334 | 2.36x | 1009 | 1.63x | 0 | yes |
| inventory-500 | 40 | plain | 11100 | 10700–13315 | 1.00x | 722 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 18907 | 16100–19206 | 1.70x | 15704 | 21.77x | 26 | yes |
| shop-filter-200 | 10 | plain | 1900 | 1400–2000 | 1.00x | 496 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 4946 | 4300–5700 | 2.60x | 1916 | 3.86x | 60 | yes |
| virtual-scroll-2000 | 15 | plain | 1500 | 1300–1804 | 1.00x | 611 | 1.00x | 3 | yes |
| virtual-scroll-2000 | 15 | facet | 8601 | 7500–9000 | 5.73x | 1275 | 2.09x | 0 | yes |
| chat-append-250 | 250 | plain | 10300 | 9600–13315 | 1.00x | 757 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 20000 | 19200–20713 | 1.94x | 1756 | 2.32x | 0 | yes |
| card-collection-60 | 1 | plain | 13627 | 12900–14000 | 1.00x | 484 | 1.00x | 3 | yes |
| card-collection-60 | 1 | facet | 44800 | 43400–49000 | 3.29x | 4607 | 9.52x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 1300 | 900–1600 | 1.00x | 515 | 1.00x | 3 | yes |
| mixed-scroll-300 | 50 | facet | 5604 | 5201–7601 | 4.31x | 8200 | 15.92x | 179 | yes |
| settings-17-values | 17 | plain | 700 | 400–900 | 1.00x | 539 | 1.00x | 0 | yes |
| settings-17-values | 17 | facet | 2700 | 2200–3155 | 3.86x | 1525 | 2.83x | 67 | yes |
| text-input-200 | 200 | plain | 600 | 400–1424 | 1.00x | 463 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 1100 | 300–1200 | 1.83x | 570 | 1.23x | 14 | yes |
| button-feedback-50 | 15 | plain | 3200 | 3100–6920 | 1.00x | 502 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 5200 | 4800–5500 | 1.62x | 820 | 1.64x | 27 | yes |
| stepper-segments-100 | 100 | plain | 500 | 433–567 | 1.00x | 494 | 1.00x | 0 | yes |
| stepper-segments-100 | 100 | facet | 3700 | 3700–5600 | 7.40x | 678 | 1.37x | 0 | yes |
| toast-stream-4 | 8 | plain | 6500 | 6470–7000 | 1.00x | 486 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 43839 | 41844–44765 | 6.74x | 574 | 1.18x | 28 | yes |
| tabs-5-5-switches | 5 | plain | 2250 | 2000–2484 | 1.00x | 507 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 6700 | 5500–8000 | 2.98x | 1082 | 2.13x | 0 | yes |
| radial-15-cycles | 30 | plain | 38335 | 34802–46528 | 1.00x | 542 | 1.00x | 6 | yes |
| radial-15-cycles | 30 | facet | 259213 | 255463–261229 | 6.76x | 1180 | 2.17x | 58 | yes |
| navigation-5-6-cycles | 60 | plain | 22908 | 20700–25305 | 1.00x | 491 | 1.00x | 11 | yes |
| navigation-5-6-cycles | 60 | facet | 51013 | 50063–53935 | 2.23x | 692 | 1.41x | 54 | yes |
| leaderboard-100 | 3 | plain | 900 | 800–2056 | 1.00x | 1441 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 4304 | 3800–5900 | 4.78x | 11955 | 8.30x | 0 | yes |
| theme-swap-200 | 2 | plain | 1222 | 800–1600 | 1.00x | 742 | 1.00x | 725 | yes |
| theme-swap-200 | 2 | facet | 1400 | 600–2106 | 1.15x | 2578 | 3.47x | 182 | yes |
| heavy-screen-20-cycles | 20 | plain | 659030 | 635169–689123 | 1.00x | 0 | 1.00x | 4 | yes |
| heavy-screen-20-cycles | 20 | facet | 909552 | 890929–917292 | 1.38x | 499 | 499.00x | 491 | yes |
| tile-transfer-20 | 20 | plain | 23602 | 21600–23759 | 1.00x | 523 | 1.00x | 0 | yes |
| tile-transfer-20 | 20 | facet | 100159 | 89981–100920 | 4.24x | 1558 | 2.98x | 44 | yes |
| input-type-switch-20 | 20 | plain | 1800 | 1800–1800 | 1.00x | 547 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 5500 | 4800–6600 | 3.06x | 1096 | 2.00x | 17 | yes |
| localized-text-swap-50 | 10 | plain | 3000 | 2800–4502 | 1.00x | 567 | 1.00x | 0 | yes |
| localized-text-swap-50 | 10 | facet | 6309 | 4400–7414 | 2.10x | 1269 | 2.24x | 20 | yes |
| text-size-preference-50 | 8 | plain | 350 | 150–400 | 1.00x | 418 | 1.00x | 0 | yes |
| text-size-preference-50 | 8 | facet | 12502 | 12200–13200 | 35.72x | 1425 | 3.41x | 9 | yes |
| phone-rotation-hub | 20 | plain | 1050 | 600–1600 | 1.00x | 505 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 2551 | 2100–3300 | 2.43x | 746 | 1.48x | 47 | yes |
| hud-composition-step-down | 20 | plain | 4802 | 4400–4861 | 1.00x | 472 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 73890 | 71547–80511 | 15.39x | 684 | 1.45x | 18 | yes |
| gamepad-grid-6x6 | 35 | plain | 3800 | 3602–4600 | 1.00x | 489 | 1.00x | 3 | yes |
| gamepad-grid-6x6 | 35 | facet | 18701 | 18500–20300 | 4.92x | 1572 | 3.21x | 0 | yes |
| drag-reorder-100 | 20 | plain | 23302 | 20471–24101 | 1.00x | 470 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 252218 | 250602–260156 | 10.82x | 2958 | 6.29x | 57 | yes |
| modal-on-modal | 20 | plain | 21238 | 20300–23797 | 1.00x | 454 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 167088 | 165979–172719 | 7.87x | 931 | 2.05x | 46 | yes |
| button-native-scale-50 | 6 | plain | 1300 | 1000–1500 | 1.00x | 502 | 1.00x | 3 | yes |
| button-native-scale-50 | 6 | facet | 6100 | 5314–6400 | 4.69x | 1610 | 3.21x | 44 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.64x | 30 | 3.22x |
