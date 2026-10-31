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
| Harness revision | `ee9f86b` |
| Facet commit | `265536b907f76f9fd8f4c7fdcb7a958c2c44a8f4` |
| Facet tree | `522b89fbe56830ffcac8d5e364157d95941e5696` |
| Date | 2026-10-30 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 13359 | 8936–14673 | 1.00x | 483 | 1.00x | 2 | yes |
| main-menu-cold | 1 | facet | 8501 | 6809–19750 | 0.64x | 618 | 1.28x | 32 | yes |
| hud-120-frames | 120 | plain | 2803 | 2330–3020 | 1.00x | 479 | 1.00x | 1 | yes |
| hud-120-frames | 120 | facet | 2806 | 2103–3365 | 1.00x | 580 | 1.21x | 17 | yes |
| world-markers-50 | 100 | plain | 28061 | 22439–34091 | 1.00x | 612 | 1.00x | 3 | yes |
| world-markers-50 | 100 | facet | 47450 | 40620–49493 | 1.69x | 1327 | 2.17x | 14 | yes |
| inventory-500 | 40 | plain | 3241 | 2709–3932 | 1.00x | 807 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 9665 | 9055–10351 | 2.98x | 22329 | 27.67x | 224 | yes |
| shop-filter-200 | 10 | plain | 1900 | 1700–2368 | 1.00x | 496 | 1.00x | 1 | yes |
| shop-filter-200 | 10 | facet | 6418 | 5103–8200 | 3.38x | 2644 | 5.33x | 73 | yes |
| virtual-scroll-2000 | 50 | plain | 4038 | 3676–4554 | 1.00x | 617 | 1.00x | 9 | yes |
| virtual-scroll-2000 | 50 | facet | 19452 | 17317–20723 | 4.82x | 1942 | 3.15x | 31 | yes |
| chat-append-500 | 500 | plain | 31642 | 25308–36389 | 1.00x | 758 | 1.00x | 3 | yes |
| chat-append-500 | 500 | facet | 45459 | 41320–49279 | 1.44x | 1792 | 2.36x | 48 | yes |
| card-collection-60 | 1 | plain | 27208 | 18059–28358 | 1.00x | 508 | 1.00x | 9 | yes |
| card-collection-60 | 1 | facet | 60199 | 50381–61600 | 2.21x | 6887 | 13.56x | 88 | yes |
| mixed-scroll-300 | 100 | plain | 2732 | 2613–3058 | 1.00x | 504 | 1.00x | 2 | yes |
| mixed-scroll-300 | 100 | facet | 6324 | 5301–6913 | 2.31x | 9856 | 19.56x | 163 | yes |
| settings-17-values | 17 | plain | 300 | 200–415 | 1.00x | 534 | 1.00x | 9 | yes |
| settings-17-values | 17 | facet | 800 | 700–1004 | 2.67x | 1609 | 3.01x | 62 | yes |
| text-input-200 | 200 | plain | 1400 | 1008–1900 | 1.00x | 463 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 2700 | 1212–4714 | 1.93x | 562 | 1.21x | 11 | yes |
| button-feedback-50 | 50 | plain | 4938 | 4269–5069 | 1.00x | 549 | 1.00x | 2 | yes |
| button-feedback-50 | 50 | facet | 4021 | 3116–5040 | 0.81x | 1050 | 1.91x | 37 | yes |
| stepper-segments-100 | 100 | plain | 2923 | 1800–3983 | 1.00x | 494 | 1.00x | 3 | yes |
| stepper-segments-100 | 100 | facet | 11609 | 8807–13609 | 3.97x | 820 | 1.66x | 50 | yes |
| toast-stream-20 | 40 | plain | 9134 | 8268–11433 | 1.00x | 470 | 1.00x | 0 | yes |
| toast-stream-20 | 40 | facet | 30786 | 28104–31494 | 3.37x | 580 | 1.23x | 29 | yes |
| tabs-5-20-switches | 20 | plain | 1913 | 1758–2211 | 1.00x | 501 | 1.00x | 4 | yes |
| tabs-5-20-switches | 20 | facet | 5694 | 5558–6613 | 2.98x | 1197 | 2.39x | 48 | yes |
| radial-50-cycles | 100 | plain | failed | — | — | — | — | — | — |
| radial-50-cycles | 100 | facet | failed | — | — | — | — | — | — |
| navigation-5-20-cycles | 200 | plain | 39630 | 37684–41316 | 1.00x | 474 | 1.00x | 0 | yes |
| navigation-5-20-cycles | 200 | facet | 101666 | 100384–107812 | 2.57x | 666 | 1.41x | 51 | yes |
| leaderboard-100 | 6 | plain | 3300 | 2813–3521 | 1.00x | 1337 | 1.00x | 2 | yes |
| leaderboard-100 | 6 | facet | 12933 | 10522–14336 | 3.92x | 17899 | 13.39x | 236 | yes |
| theme-swap-200 | 5 | plain | 234 | 0–306 | 1.00x | 732 | 1.00x | 721 | yes |
| theme-swap-200 | 5 | facet | 500 | 100–594 | 2.14x | 4223 | 5.77x | 365 | yes |
| heavy-screen-20-cycles | 20 | plain | 390747 | 375317–397566 | 1.00x | 10 | 1.00x | 2 | yes |
| heavy-screen-20-cycles | 20 | facet | 621806 | 619114–654851 | 1.59x | 504 | 50.40x | 504 | yes |
| tile-transfer-20 | 20 | plain | failed | — | — | — | — | — | — |
| tile-transfer-20 | 20 | facet | failed | — | — | — | — | — | — |
| input-type-switch-20 | 20 | plain | 2400 | 2231–2700 | 1.00x | 545 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 1100 | 1000–1500 | 0.46x | 1146 | 2.10x | 8 | yes |
| localized-text-swap-50 | 10 | plain | 3919 | 3440–4251 | 1.00x | 548 | 1.00x | 2 | yes |
| localized-text-swap-50 | 10 | facet | 6847 | 6822–7256 | 1.75x | 1232 | 2.25x | 19 | yes |
| text-size-preference-50 | 8 | plain | 100 | 0–200 | 1.00x | 412 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 14328 | 13525–14953 | 143.28x | 938 | 2.28x | 4 | yes |
| phone-rotation-hub | 20 | plain | failed | — | — | — | — | — | — |
| phone-rotation-hub | 20 | facet | failed | — | — | — | — | — | — |
| hud-composition-step-down | 20 | plain | failed | — | — | — | — | — | — |
| hud-composition-step-down | 20 | facet | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | plain | failed | — | — | — | — | — | — |
| gamepad-grid-6x6 | 35 | facet | failed | — | — | — | — | — | — |
| drag-reorder-100 | 20 | plain | failed | — | — | — | — | — | — |
| drag-reorder-100 | 20 | facet | failed | — | — | — | — | — | — |
| modal-on-modal | 20 | plain | failed | — | — | — | — | — | — |
| modal-on-modal | 20 | facet | failed | — | — | — | — | — | — |
| button-native-scale-50 | 20 | plain | 2932 | 2637–3402 | 1.00x | 444 | 1.00x | 10 | yes |
| button-native-scale-50 | 20 | facet | 2917 | 2523–3349 | 0.99x | 1358 | 3.06x | 31 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 23 | 1.00x | 23 | 1.00x |
| facet | 23 | 2.32x | 23 | 3.59x |
