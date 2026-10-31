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
| Roblox Studio | 0.745.0.7451137 |
| Context | client |
| Harness revision | `a03aceb` |
| Facet commit | `265536b907f76f9fd8f4c7fdcb7a958c2c44a8f4` |
| Facet tree | `522b89fbe56830ffcac8d5e364157d95941e5696` |
| Date | 2026-10-31 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 3600 | 3500–4000 | 1.00x | 492 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 4800 | 4700–5002 | 1.33x | 619 | 1.26x | 25 | yes |
| hud-120-frames | 120 | plain | 6400 | 6100–6900 | 1.00x | 488 | 1.00x | 1 | yes |
| hud-120-frames | 120 | facet | 10301 | 8300–12201 | 1.61x | 580 | 1.19x | 25 | yes |
| world-markers-50 | 100 | plain | 15200 | 15006–15603 | 1.00x | 613 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 27303 | 25400–33505 | 1.80x | 1326 | 2.16x | 5 | yes |
| inventory-500 | 40 | plain | 9300 | 8600–10200 | 1.00x | 894 | 1.00x | 9 | yes |
| inventory-500 | 40 | facet | 17100 | 16100–18102 | 1.84x | 22377 | 25.03x | 217 | yes |
| shop-filter-200 | 10 | plain | 1800 | 1400–2100 | 1.00x | 497 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 4200 | 3900–5700 | 2.33x | 2652 | 5.34x | 73 | yes |
| virtual-scroll-2000 | 50 | plain | 6501 | 6100–6900 | 1.00x | 617 | 1.00x | 1 | yes |
| virtual-scroll-2000 | 50 | facet | 1400 | 900–1700 | 0.22x | 1931 | 3.13x | 23 | yes |
| chat-append-500 | 500 | plain | 16404 | 16004–16700 | 1.00x | 774 | 1.00x | 2 | yes |
| chat-append-500 | 500 | facet | 26203 | 25100–29600 | 1.60x | 1801 | 2.33x | 48 | yes |
| card-collection-60 | 1 | plain | 12700 | 12204–13401 | 1.00x | 499 | 1.00x | 1 | yes |
| card-collection-60 | 1 | facet | 32300 | 30630–35262 | 2.54x | 6926 | 13.88x | 94 | yes |
| mixed-scroll-300 | 100 | plain | 1200 | 1000–2000 | 1.00x | 512 | 1.00x | 2 | yes |
| mixed-scroll-300 | 100 | facet | 10700 | 8900–11501 | 8.92x | 10279 | 20.08x | 165 | yes |
| settings-17-values | 17 | plain | 900 | 400–1100 | 1.00x | 542 | 1.00x | 9 | yes |
| settings-17-values | 17 | facet | 1900 | 1500–2300 | 2.11x | 1663 | 3.07x | 72 | yes |
| text-input-200 | 200 | plain | 500 | 300–900 | 1.00x | 463 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 900 | 700–1200 | 1.80x | 555 | 1.20x | 9 | yes |
| button-feedback-50 | 50 | plain | 12900 | 11600–13808 | 1.00x | 549 | 1.00x | 3 | yes |
| button-feedback-50 | 50 | facet | 11500 | 10500–12600 | 0.89x | 1042 | 1.90x | 29 | yes |
| stepper-segments-100 | 100 | plain | 1000 | 800–1200 | 1.00x | 487 | 1.00x | 4 | yes |
| stepper-segments-100 | 100 | facet | 4400 | 3900–4500 | 4.40x | 836 | 1.72x | 51 | yes |
| toast-stream-20 | 40 | plain | 18602 | 16900–20100 | 1.00x | 474 | 1.00x | 2 | yes |
| toast-stream-20 | 40 | facet | 43900 | 41901–45400 | 2.36x | 592 | 1.25x | 42 | yes |
| tabs-5-20-switches | 20 | plain | 4400 | 4100–5600 | 1.00x | 500 | 1.00x | 4 | yes |
| tabs-5-20-switches | 20 | facet | 13200 | 12900–13600 | 3.00x | 1192 | 2.38x | 39 | yes |
| radial-50-cycles | 100 | plain | failed | — | — | — | — | — | — |
| radial-50-cycles | 100 | facet | failed | — | — | — | — | — | — |
| navigation-5-20-cycles | 200 | plain | 73402 | 70701–77949 | 1.00x | 482 | 1.00x | 2 | yes |
| navigation-5-20-cycles | 200 | facet | 182202 | 174800–190510 | 2.48x | 708 | 1.47x | 57 | yes |
| leaderboard-100 | 6 | plain | 3000 | 2800–3400 | 1.00x | 1336 | 1.00x | 1 | yes |
| leaderboard-100 | 6 | facet | 15302 | 13400–16800 | 5.10x | 17996 | 13.47x | 276 | yes |
| theme-swap-200 | 5 | plain | 2800 | 2301–3432 | 1.00x | 729 | 1.00x | 721 | yes |
| theme-swap-200 | 5 | facet | 3200 | 2800–3500 | 1.14x | 4316 | 5.92x | 350 | yes |
| heavy-screen-20-cycles | 20 | plain | 502889 | 478418–519597 | 1.00x | 3 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 824700 | 807255–847237 | 1.64x | 513 | 171.00x | 504 | yes |
| tile-transfer-20 | 20 | plain | failed | — | — | — | — | — | — |
| tile-transfer-20 | 20 | facet | failed | — | — | — | — | — | — |
| input-type-switch-20 | 20 | plain | 3800 | 3200–4000 | 1.00x | 536 | 1.00x | 1 | yes |
| input-type-switch-20 | 20 | facet | 1700 | 1000–2400 | 0.45x | 1198 | 2.24x | 9 | yes |
| localized-text-swap-50 | 10 | plain | 4300 | 3800–4500 | 1.00x | 555 | 1.00x | 3 | yes |
| localized-text-swap-50 | 10 | facet | 5500 | 5100–6400 | 1.28x | 1242 | 2.24x | 26 | yes |
| text-size-preference-50 | 8 | plain | 200 | 100–200 | 1.00x | 412 | 1.00x | 1 | yes |
| text-size-preference-50 | 8 | facet | 10000 | 9602–10920 | 50.00x | 938 | 2.28x | 5 | yes |
| phone-rotation-hub | 20 | plain | failed | — | — | — | — | — | — |
| phone-rotation-hub | 20 | facet | failed | — | — | — | — | — | — |
| hud-composition-step-down | 20 | plain | failed | — | — | — | — | — | — |
| hud-composition-step-down | 20 | facet | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | plain | 1900 | 1700–2500 | 1.00x | 439 | 1.00x | 0 | yes |
| gamepad-grid-6x6 | 35 | facet | 16800 | 14801–17701 | 8.84x | 1853 | 4.22x | 43 | yes |
| drag-reorder-100 | 20 | plain | failed | — | — | — | — | — | — |
| drag-reorder-100 | 20 | facet | failed | — | — | — | — | — | — |
| modal-on-modal | 20 | plain | failed | — | — | — | — | — | — |
| modal-on-modal | 20 | facet | failed | — | — | — | — | — | — |
| button-native-scale-50 | 20 | plain | 7800 | 6900–8400 | 1.00x | 436 | 1.00x | 2 | yes |
| button-native-scale-50 | 20 | facet | 8100 | 7800–8700 | 1.04x | 1334 | 3.06x | 33 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 24 | 1.00x | 24 | 1.00x |
| facet | 24 | 2.14x | 24 | 3.82x |
