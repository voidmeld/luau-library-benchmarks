# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, in KiB. Teardown is the median retained heap after release. Both use the Verify `gc-witness-low-water/2` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D 16-Core Processor           |
| Cores | 32 |
| Memory | 62 GiB |
| Model | Micro-Star International Co., Ltd. MS-7E47 |
| Operating system | Microsoft Windows 11 Pro 10.0.26200 |
| Roblox Studio | 0.745.449.7450003 |
| Context | client |
| Harness revision | `1a353e2` |
| Facet commit | `053b475d628f1a96abc5293247ecd46295688fb1` |
| Facet tree | `42054c606ee5f7d27365b94aa441664a311e9303` |
| Date | 2026-11-03 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 3800 | 3302–4400 | 1.00x | 508 | 1.00x | 10 | yes |
| main-menu-cold | 1 | facet | 7217 | 6956–8700 | 1.90x | 607 | 1.19x | 26 | yes |
| hud-60-frames | 60 | plain | 2100 | 1800–2700 | 1.00x | 502 | 1.00x | 10 | yes |
| hud-60-frames | 60 | facet | 1401 | 900–1711 | 0.67x | 575 | 1.15x | 19 | yes |
| world-markers-50 | 100 | plain | 14700 | 13800–15300 | 1.00x | 620 | 1.00x | 4 | yes |
| world-markers-50 | 100 | facet | 22804 | 21300–30204 | 1.55x | 1330 | 2.15x | 17 | yes |
| inventory-500 | 40 | plain | 5600 | 4800–6100 | 1.00x | 765 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 8900 | 8414–9724 | 1.59x | 18587 | 24.30x | 141 | yes |
| shop-filter-200 | 10 | plain | 808 | 800–1400 | 1.00x | 512 | 1.00x | 2 | yes |
| shop-filter-200 | 10 | facet | 2803 | 2700–6104 | 3.47x | 1890 | 3.69x | 59 | yes |
| virtual-scroll-2000 | 15 | plain | 1300 | 1200–1616 | 1.00x | 609 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 4700 | 4600–5600 | 3.62x | 1480 | 2.43x | 27 | yes |
| chat-append-250 | 250 | plain | 8254 | 6900–8832 | 1.00x | 741 | 1.00x | 2 | yes |
| chat-append-250 | 250 | facet | 13400 | 12400–15611 | 1.62x | 2355 | 3.18x | 46 | yes |
| card-collection-60 | 1 | plain | 11500 | 11200–12048 | 1.00x | 499 | 1.00x | 2 | yes |
| card-collection-60 | 1 | facet | 43882 | 42078–49442 | 3.82x | 5453 | 10.93x | 120 | yes |
| mixed-scroll-300 | 50 | plain | 600 | 400–800 | 1.00x | 525 | 1.00x | 2 | yes |
| mixed-scroll-300 | 50 | facet | 500 | 400–1200 | 0.83x | 7971 | 15.18x | 152 | yes |
| settings-17-values | 17 | plain | 500 | 300–700 | 1.00x | 548 | 1.00x | 3 | yes |
| settings-17-values | 17 | facet | 900 | 600–1100 | 1.80x | 1472 | 2.69x | 73 | yes |
| text-input-200 | 200 | plain | 600 | 200–701 | 1.00x | 469 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 1000 | 700–1300 | 1.67x | 552 | 1.18x | 13 | yes |
| button-feedback-50 | 15 | plain | 2115 | 1700–2890 | 1.00x | 521 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2300 | 2193–3000 | 1.09x | 796 | 1.53x | 33 | yes |
| stepper-segments-100 | 100 | plain | 800 | 600–800 | 1.00x | 486 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 3169 | 3100–3500 | 3.96x | 785 | 1.62x | 51 | yes |
| toast-stream-4 | 8 | plain | 7200 | 6964–7877 | 1.00x | 496 | 1.00x | 1 | yes |
| toast-stream-4 | 8 | facet | 10300 | 9245–11428 | 1.43x | 545 | 1.10x | 36 | yes |
| tabs-5-5-switches | 5 | plain | 1400 | 800–1800 | 1.00x | 516 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 2900 | 2200–3600 | 2.07x | 1200 | 2.33x | 53 | yes |
| radial-15-cycles | 30 | plain | 39283 | 35832–43510 | 1.00x | 628 | 1.00x | 2 | yes |
| radial-15-cycles | 30 | facet | 33805 | 32749–35854 | 0.86x | 1164 | 1.85x | 68 | yes |
| navigation-5-6-cycles | 60 | plain | 14887 | 14211–16317 | 1.00x | 488 | 1.00x | 2 | yes |
| navigation-5-6-cycles | 60 | facet | 35270 | 33205–37988 | 2.37x | 638 | 1.31x | 62 | yes |
| leaderboard-100 | 3 | plain | 800 | 600–1000 | 1.00x | 1424 | 1.00x | 2 | yes |
| leaderboard-100 | 3 | facet | 1305 | 1168–3601 | 1.63x | 13875 | 9.74x | 228 | yes |
| theme-swap-200 | 2 | plain | 700 | 300–1200 | 1.00x | 18 | 1.00x | 724 | yes |
| theme-swap-200 | 2 | facet | 900 | 800–1200 | 1.29x | 3396 | 188.67x | 180 | yes |
| heavy-screen-20-cycles | 20 | plain | 544096 | 540624–585642 | 1.00x | 8 | 1.00x | 7 | yes |
| heavy-screen-20-cycles | 20 | facet | 667525 | 636205–698443 | 1.23x | 1 | 0.12x | 506 | yes |
| tile-transfer-20 | 20 | plain | 13700 | 12100–15208 | 1.00x | 470 | 1.00x | 2 | yes |
| tile-transfer-20 | 20 | facet | 77174 | 73612–81916 | 5.63x | 1578 | 3.36x | 38 | yes |
| input-type-switch-20 | 20 | plain | 2700 | 2200–3116 | 1.00x | 502 | 1.00x | 3 | yes |
| input-type-switch-20 | 20 | facet | 800 | 500–1500 | 0.30x | 1019 | 2.03x | 9 | yes |
| localized-text-swap-50 | 10 | plain | 3200 | 2800–3400 | 1.00x | 554 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 5006 | 4200–6304 | 1.56x | 1246 | 2.25x | 21 | yes |
| text-size-preference-50 | 8 | plain | 100 | 0–200 | 1.00x | 418 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 8968 | 8100–10100 | 89.68x | 1382 | 3.31x | 6 | yes |
| phone-rotation-hub | 20 | plain | 200 | 100–800 | 1.00x | 451 | 1.00x | 9 | yes |
| phone-rotation-hub | 20 | facet | 1115 | 900–1500 | 5.58x | 653 | 1.45x | 40 | yes |
| hud-composition-step-down | 20 | plain | 2200 | 2100–2860 | 1.00x | 495 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 2400 | 1702–2800 | 1.09x | 636 | 1.28x | 0 | yes |
| gamepad-grid-6x6 | 35 | plain | 2700 | 2200–3000 | 1.00x | 481 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 4400 | 4073–5200 | 1.63x | 1968 | 4.09x | 59 | yes |
| drag-reorder-100 | 20 | plain | 11260 | 9500–12975 | 1.00x | 474 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 11148 | 10300–12549 | 0.99x | 3204 | 6.75x | 72 | yes |
| modal-on-modal | 20 | plain | 12507 | 11705–13568 | 1.00x | 525 | 1.00x | 2 | yes |
| modal-on-modal | 20 | facet | 77732 | 75909–80434 | 6.22x | 948 | 1.80x | 62 | yes |
| button-native-scale-50 | 6 | plain | 1700 | 1500–2147 | 1.00x | 511 | 1.00x | 0 | yes |
| button-native-scale-50 | 6 | facet | 1400 | 1200–2112 | 0.82x | 1574 | 3.08x | 42 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 1.95x | 30 | 2.87x |
