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
| Harness revision | `9648ba3` |
| Facet commit | `0dd87be5b647e52ec8f9f186a2d970e1796c1355` |
| Facet tree | `3e3696c40918ea29d7d15d4fbfc1b5808351bbf1` |
| Date | 2026-11-12 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 10052 | 7125–16443 | 1.00x | 518 | 1.00x | 0 | yes |
| main-menu-cold | 1 | facet | 15302 | 9542–16002 | 1.52x | 596 | 1.15x | 28 | yes |
| hud-60-frames | 60 | plain | 1166 | 1071–1289 | 1.00x | 501 | 1.00x | 3 | yes |
| hud-60-frames | 60 | facet | 3770 | 3336–4117 | 3.23x | 513 | 1.02x | 0 | yes |
| world-markers-50 | 100 | plain | 20810 | 14304–22817 | 1.00x | 649 | 1.00x | 10 | yes |
| world-markers-50 | 100 | facet | 42877 | 31673–53765 | 2.06x | 1221 | 1.88x | 0 | yes |
| inventory-500 | 40 | plain | 3606 | 3494–3708 | 1.00x | 740 | 1.00x | 1 | yes |
| inventory-500 | 40 | facet | 5828 | 5637–5869 | 1.62x | 8174 | 11.05x | 82 | yes |
| shop-filter-200 | 10 | plain | 1600 | 1400–2300 | 1.00x | 532 | 1.00x | 3 | yes |
| shop-filter-200 | 10 | facet | 5336 | 3800–6017 | 3.33x | 1502 | 2.82x | 61 | yes |
| virtual-scroll-2000 | 15 | plain | 1000 | 849–1143 | 1.00x | 648 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 15 | facet | 5961 | 3803–6127 | 5.96x | 1147 | 1.77x | 19 | yes |
| chat-append-250 | 250 | plain | 19722 | 13721–23662 | 1.00x | 786 | 1.00x | 3 | yes |
| chat-append-250 | 250 | facet | 24634 | 22427–27482 | 1.25x | 1381 | 1.76x | 32 | yes |
| card-collection-60 | 1 | plain | 29070 | 18437–30304 | 1.00x | 512 | 1.00x | 3 | yes |
| card-collection-60 | 1 | facet | 71913 | 60653–75992 | 2.47x | 3751 | 7.33x | 0 | yes |
| mixed-scroll-300 | 50 | plain | 205 | 107–300 | 1.00x | 535 | 1.00x | 3 | yes |
| mixed-scroll-300 | 50 | facet | 2510 | 2200–2605 | 12.24x | 6152 | 11.50x | 84 | yes |
| settings-17-values | 17 | plain | 313 | 300–436 | 1.00x | 564 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1300 | 1120–1600 | 4.15x | 1340 | 2.38x | 64 | yes |
| text-input-200 | 200 | plain | 1502 | 1000–2112 | 1.00x | 491 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 2423 | 1700–2779 | 1.61x | 588 | 1.20x | 13 | yes |
| button-feedback-50 | 15 | plain | 1900 | 1400–2072 | 1.00x | 529 | 1.00x | 2 | yes |
| button-feedback-50 | 15 | facet | 2256 | 2166–2561 | 1.19x | 736 | 1.39x | 30 | yes |
| stepper-segments-100 | 100 | plain | 1704 | 1106–2200 | 1.00x | 515 | 1.00x | 3 | yes |
| stepper-segments-100 | 100 | facet | 10421 | 6617–12131 | 6.12x | 685 | 1.33x | 0 | yes |
| toast-stream-4 | 8 | plain | 3445 | 2716–3908 | 1.00x | 506 | 1.00x | 2 | yes |
| toast-stream-4 | 8 | facet | 15690 | 14259–15914 | 4.55x | 588 | 1.16x | 22 | yes |
| tabs-5-5-switches | 5 | plain | 1006 | 500–1106 | 1.00x | 527 | 1.00x | 2 | yes |
| tabs-5-5-switches | 5 | facet | 2196 | 1804–2417 | 2.18x | 1214 | 2.30x | 45 | yes |
| radial-15-cycles | 30 | plain | 23273 | 23210–26023 | 1.00x | 583 | 1.00x | 18 | yes |
| radial-15-cycles | 30 | facet | 120329 | 109723–123991 | 5.17x | 1185 | 2.03x | 60 | yes |
| navigation-5-6-cycles | 60 | plain | 12078 | 11706–13716 | 1.00x | 511 | 1.00x | 2 | yes |
| navigation-5-6-cycles | 60 | facet | 35340 | 33678–36000 | 2.93x | 687 | 1.34x | 45 | yes |
| leaderboard-100 | 3 | plain | 1000 | 737–1130 | 1.00x | 1480 | 1.00x | 3 | yes |
| leaderboard-100 | 3 | facet | 3673 | 3127–3819 | 3.67x | 7656 | 5.17x | 0 | yes |
| theme-swap-200 | 2 | plain | 100 | 100–100 | 1.00x | 770 | 1.00x | 752 | yes |
| theme-swap-200 | 2 | facet | 112 | 100–300 | 1.12x | 2046 | 2.66x | 179 | yes |
| heavy-screen-20-cycles | 20 | plain | 414427 | 406924–427292 | 1.00x | 11 | 1.00x | 3 | yes |
| heavy-screen-20-cycles | 20 | facet | 573488 | 562569–585889 | 1.38x | 506 | 46.00x | 497 | yes |
| tile-transfer-20 | 20 | plain | 9450 | 9144–9691 | 1.00x | 540 | 1.00x | 0 | yes |
| tile-transfer-20 | 20 | facet | 42751 | 42118–43104 | 4.52x | 1597 | 2.95x | 38 | yes |
| input-type-switch-20 | 20 | plain | 1003 | 802–1229 | 1.00x | 569 | 1.00x | 0 | yes |
| input-type-switch-20 | 20 | facet | 12685 | 10883–13798 | 12.65x | 1069 | 1.88x | 0 | yes |
| localized-text-swap-50 | 10 | plain | 2556 | 2038–2810 | 1.00x | 585 | 1.00x | 10 | yes |
| localized-text-swap-50 | 10 | facet | 6090 | 4335–6450 | 2.38x | 1129 | 1.93x | 0 | yes |
| text-size-preference-50 | 8 | plain | 202 | 100–300 | 1.00x | 434 | 1.00x | 3 | yes |
| text-size-preference-50 | 8 | facet | 10152 | 9812–12041 | 50.26x | 1208 | 2.78x | 0 | yes |
| phone-rotation-hub | 20 | plain | 252 | 100–307 | 1.00x | 526 | 1.00x | 3 | yes |
| phone-rotation-hub | 20 | facet | 1310 | 800–1911 | 5.21x | 742 | 1.41x | 48 | yes |
| hud-composition-step-down | 20 | plain | 1699 | 1233–1914 | 1.00x | 494 | 1.00x | 2 | yes |
| hud-composition-step-down | 20 | facet | 17771 | 16386–18447 | 10.46x | 614 | 1.25x | 10 | yes |
| gamepad-grid-6x6 | 35 | plain | 1000 | 403–1205 | 1.00x | 506 | 1.00x | 2 | yes |
| gamepad-grid-6x6 | 35 | facet | 10566 | 10505–11914 | 10.57x | 1191 | 2.36x | 24 | yes |
| drag-reorder-100 | 20 | plain | 7052 | 6595–7406 | 1.00x | 494 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 75650 | 73861–80189 | 10.73x | 2522 | 5.11x | 36 | yes |
| modal-on-modal | 20 | plain | 10022 | 9066–10369 | 1.00x | 450 | 1.00x | 1 | yes |
| modal-on-modal | 20 | facet | 52667 | 48757–52890 | 5.26x | 954 | 2.12x | 18 | yes |
| button-native-scale-50 | 6 | plain | 805 | 400–1001 | 1.00x | 523 | 1.00x | 3 | yes |
| button-native-scale-50 | 6 | facet | 2403 | 1800–3001 | 2.99x | 971 | 1.86x | 41 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload and includes every measured workload. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 30 | 1.00x |
| facet | 30 | 3.84x | 30 | 2.52x |
