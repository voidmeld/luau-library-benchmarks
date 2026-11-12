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
| Harness revision | `fa39de9` |
| Facet commit | `0dd87be5b647e52ec8f9f186a2d970e1796c1355` |
| Facet tree | `3e3696c40918ea29d7d15d4fbfc1b5808351bbf1` |
| Date | 2026-11-12 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 4900 | 4600–5600 | 1.00x | 511 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 5107 | 5000–6100 | 1.04x | 602 | 1.18x | 27 | yes |
| hud-60-frames | 60 | plain | 1700 | 1300–1800 | 1.00x | 501 | 1.00x | 2 | yes |
| hud-60-frames | 60 | facet | 3700 | 3000–4800 | 2.18x | 490 | 0.98x | 0 | yes |
| world-markers-50 | 100 | plain | 8725 | 8700–9100 | 1.00x | 649 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 27203 | 25000–31503 | 3.12x | 1213 | 1.87x | 0 | yes |
| inventory-500 | 40 | plain | 9600 | 8800–9700 | 1.00x | 738 | 1.00x | 6 | yes |
| inventory-500 | 40 | facet | 11600 | 11500–14100 | 1.21x | 8150 | 11.04x | 77 | yes |
| shop-filter-200 | 10 | plain | 1350 | 1000–1500 | 1.00x | 517 | 1.00x | 0 | yes |
| shop-filter-200 | 10 | facet | 3150 | 2900–3300 | 2.33x | 1518 | 2.94x | 61 | yes |
| virtual-scroll-2000 | 15 | plain | 1350 | 1150–1401 | 1.00x | 640 | 1.00x | 3 | yes |
| virtual-scroll-2000 | 15 | facet | 4200 | 3950–4350 | 3.11x | 1154 | 1.80x | 18 | yes |
| chat-append-250 | 250 | plain | 8511 | 8000–8902 | 1.00x | 793 | 1.00x | 0 | yes |
| chat-append-250 | 250 | facet | 11000 | 10803–14500 | 1.29x | 1390 | 1.75x | 32 | yes |
| card-collection-60 | 1 | plain | 14127 | 13100–15310 | 1.00x | 519 | 1.00x | 10 | yes |
| card-collection-60 | 1 | facet | 48911 | 46230–51210 | 3.46x | 3751 | 7.23x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 800 | 600–1000 | 1.00x | 534 | 1.00x | 10 | yes |
| mixed-scroll-300 | 50 | facet | 3100 | 2100–3900 | 3.88x | 6239 | 11.68x | 83 | yes |
| settings-17-values | 17 | plain | 450 | 450–650 | 1.00x | 564 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1600 | 1200–1900 | 3.56x | 1340 | 2.38x | 63 | yes |
| text-input-200 | 200 | plain | 500 | 400–668 | 1.00x | 484 | 1.00x | 0 | yes |
| text-input-200 | 200 | facet | 767 | 700–834 | 1.53x | 580 | 1.20x | 13 | yes |
| button-feedback-50 | 15 | plain | 4000 | 2000–4600 | 1.00x | 527 | 1.00x | 3 | yes |
| button-feedback-50 | 15 | facet | 4200 | 4100–4900 | 1.05x | 736 | 1.40x | 28 | yes |
| stepper-segments-100 | 100 | plain | 400 | 400–467 | 1.00x | 515 | 1.00x | 3 | yes |
| stepper-segments-100 | 100 | facet | 3200 | 3050–3479 | 8.00x | 677 | 1.31x | 0 | yes |
| toast-stream-4 | 8 | plain | 4600 | 4500–4800 | 1.00x | 502 | 1.00x | 1 | yes |
| toast-stream-4 | 8 | facet | 24300 | 21800–25608 | 5.28x | 602 | 1.20x | 26 | yes |
| tabs-5-5-switches | 5 | plain | 2100 | 1900–2100 | 1.00x | 535 | 1.00x | 3 | yes |
| tabs-5-5-switches | 5 | facet | 3700 | 3400–4400 | 1.76x | 1205 | 2.25x | 45 | yes |
| radial-15-cycles | 30 | plain | 35805 | 35118–38800 | 1.00x | 570 | 1.00x | 2 | yes |
| radial-15-cycles | 30 | facet | 241526 | 237269–243056 | 6.75x | 1214 | 2.13x | 68 | yes |
| navigation-5-6-cycles | 60 | plain | 19201 | 18500–20000 | 1.00x | 519 | 1.00x | 3 | yes |
| navigation-5-6-cycles | 60 | facet | 37356 | 36903–40600 | 1.95x | 679 | 1.31x | 37 | yes |
| leaderboard-100 | 3 | plain | 700 | 650–900 | 1.00x | 1488 | 1.00x | 2 | yes |
| leaderboard-100 | 3 | facet | 1900 | 1600–2800 | 2.71x | 7600 | 5.11x | 0 | yes |
| theme-swap-200 | 2 | plain | 450 | 400–1100 | 1.00x | 772 | 1.00x | 746 | yes |
| theme-swap-200 | 2 | facet | 900 | 900–1200 | 2.00x | 2054 | 2.66x | 187 | yes |
| heavy-screen-20-cycles | 20 | plain | 581213 | 561843–607097 | 1.00x | 3 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 761398 | 728856–797438 | 1.31x | 491 | 163.67x | 490 | yes |
| tile-transfer-20 | 20 | plain | 18802 | 18700–19200 | 1.00x | 540 | 1.00x | 0 | yes |
| tile-transfer-20 | 20 | facet | 90100 | 88303–92740 | 4.79x | 1642 | 3.04x | 34 | yes |
| input-type-switch-20 | 20 | plain | 1000 | 900–1200 | 1.00x | 569 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 10000 | 9500–11800 | 10.00x | 1053 | 1.85x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2100 | 2050–3100 | 1.00x | 575 | 1.00x | 1 | yes |
| localized-text-swap-50 | 10 | facet | 4400 | 3600–4900 | 2.10x | 1125 | 1.96x | 0 | yes |
| text-size-preference-50 | 8 | plain | 150 | 100–300 | 1.00x | 433 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 9900 | 8100–12425 | 66.00x | 1208 | 2.79x | 0 | yes |
| phone-rotation-hub | 20 | plain | 300 | 300–400 | 1.00x | 533 | 1.00x | 2 | yes |
| phone-rotation-hub | 20 | facet | 800 | 600–2200 | 2.67x | 742 | 1.39x | 43 | yes |
| hud-composition-step-down | 20 | plain | 3200 | 2700–4403 | 1.00x | 506 | 1.00x | 3 | yes |
| hud-composition-step-down | 20 | facet | 16400 | 14900–16600 | 5.12x | 618 | 1.22x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | 2700 | 2700–3300 | 1.00x | 502 | 1.00x | 4 | yes |
| gamepad-grid-6x6 | 35 | facet | 15300 | 14800–16101 | 5.67x | 1206 | 2.40x | 25 | yes |
| drag-reorder-100 | 20 | plain | 16200 | 15400–16900 | 1.00x | 498 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 148943 | 147821–154133 | 9.19x | 2528 | 5.08x | 32 | yes |
| modal-on-modal | 20 | plain | 16000 | 14920–16200 | 1.00x | 471 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 91212 | 89851–95725 | 5.70x | 956 | 2.03x | 24 | yes |
| button-native-scale-50 | 6 | plain | 1900 | 1500–2300 | 1.00x | 522 | 1.00x | 2 | yes |
| button-native-scale-50 | 6 | facet | 7200 | 7000–7300 | 3.79x | 978 | 1.87x | 40 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.32x | 30 | 2.63x |
