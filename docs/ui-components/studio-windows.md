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
| Harness revision | `8eba504` |
| Facet commit | `9cb4aecd2b02b877f161f9a1c617b5445bebe019` |
| Facet tree | `5800e47d72e81b37c17e48b64c491a6a39f4a55b` |
| Date | 2026-10-31 |

Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.

The batch with `gamepad-grid-6x6` ran with Test > Controller Emulator open. `drag-reorder-100` ran in a batch with the emulator closed. `tile-transfer-20` did not complete with the emulator open, so its row comes from a separate run with the emulator closed.

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same checkpoints as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 3800 | 3500–5400 | 1.00x | 493 | 1.00x | 1 | yes |
| main-menu-cold | 1 | facet | 4500 | 4400–4700 | 1.18x | 621 | 1.26x | 24 | yes |
| hud-120-frames | 120 | plain | 5700 | 5203–6700 | 1.00x | 490 | 1.00x | 7 | yes |
| hud-120-frames | 120 | facet | 5500 | 4900–6200 | 0.96x | 577 | 1.18x | 17 | yes |
| world-markers-50 | 100 | plain | 14800 | 14700–15300 | 1.00x | 623 | 1.00x | 2 | yes |
| world-markers-50 | 100 | facet | 28866 | 24100–35055 | 1.95x | 1331 | 2.14x | 20 | yes |
| inventory-500 | 40 | plain | 10000 | 9400–10402 | 1.00x | 896 | 1.00x | 2 | yes |
| inventory-500 | 40 | facet | 16800 | 15800–17200 | 1.68x | 23546 | 26.28x | 212 | yes |
| shop-filter-200 | 10 | plain | 1700 | 1600–2118 | 1.00x | 491 | 1.00x | 1 | yes |
| shop-filter-200 | 10 | facet | 5300 | 4900–5633 | 3.12x | 3287 | 6.69x | 83 | yes |
| virtual-scroll-2000 | 50 | plain | 6200 | 5400–6500 | 1.00x | 620 | 1.00x | 2 | yes |
| virtual-scroll-2000 | 50 | facet | 1300 | 800–1500 | 0.21x | 1965 | 3.17x | 30 | yes |
| chat-append-500 | 500 | plain | 16300 | 15536–17100 | 1.00x | 769 | 1.00x | 2 | yes |
| chat-append-500 | 500 | facet | 22900 | 22200–28100 | 1.40x | 1820 | 2.37x | 47 | yes |
| card-collection-60 | 1 | plain | 12717 | 12000–12800 | 1.00x | 502 | 1.00x | 2 | yes |
| card-collection-60 | 1 | facet | 34900 | 31653–36833 | 2.74x | 7183 | 14.31x | 89 | yes |
| mixed-scroll-300 | 100 | plain | 1600 | 1300–2500 | 1.00x | 509 | 1.00x | 2 | yes |
| mixed-scroll-300 | 100 | facet | 9187 | 8600–10200 | 5.74x | 10679 | 20.98x | 168 | yes |
| settings-17-values | 17 | plain | 900 | 300–1300 | 1.00x | 543 | 1.00x | 2 | yes |
| settings-17-values | 17 | facet | 1400 | 1200–1800 | 1.56x | 1684 | 3.10x | 72 | yes |
| text-input-200 | 200 | plain | 400 | 200–700 | 1.00x | 458 | 1.00x | 2 | yes |
| text-input-200 | 200 | facet | 700 | 700–1000 | 1.75x | 559 | 1.22x | 18 | yes |
| button-feedback-50 | 50 | plain | 13000 | 11700–13602 | 1.00x | 551 | 1.00x | 9 | yes |
| button-feedback-50 | 50 | facet | 13500 | 11600–14400 | 1.04x | 1057 | 1.92x | 28 | yes |
| stepper-segments-100 | 100 | plain | 800 | 800–900 | 1.00x | 496 | 1.00x | 2 | yes |
| stepper-segments-100 | 100 | facet | 3900 | 3700–4600 | 4.88x | 858 | 1.73x | 58 | yes |
| toast-stream-20 | 40 | plain | 17874 | 17000–18800 | 1.00x | 484 | 1.00x | 1 | yes |
| toast-stream-20 | 40 | facet | 41700 | 40318–43800 | 2.33x | 586 | 1.21x | 39 | yes |
| tabs-5-20-switches | 20 | plain | 5300 | 4500–5400 | 1.00x | 502 | 1.00x | 0 | yes |
| tabs-5-20-switches | 20 | facet | 13600 | 12000–15000 | 2.57x | 1232 | 2.45x | 49 | yes |
| radial-50-cycles | 100 | plain | 111506 | 110112–112817 | 1.00x | 668 | 1.00x | 2 | yes |
| radial-50-cycles | 100 | facet | 859566 | 853688–863399 | 7.71x | 741 | 1.11x | 83 | yes |
| navigation-5-20-cycles | 200 | plain | 76247 | 72720–78801 | 1.00x | 495 | 1.00x | 0 | yes |
| navigation-5-20-cycles | 200 | facet | 182218 | 178976–184816 | 2.39x | 735 | 1.48x | 80 | yes |
| leaderboard-100 | 6 | plain | 2800 | 2400–2800 | 1.00x | 1402 | 1.00x | 2 | yes |
| leaderboard-100 | 6 | facet | 12703 | 12000–13300 | 4.54x | 18190 | 12.97x | 237 | yes |
| theme-swap-200 | 5 | plain | 2100 | 1800–3000 | 1.00x | 731 | 1.00x | 718 | yes |
| theme-swap-200 | 5 | facet | 2800 | 1800–3300 | 1.33x | 4466 | 6.11x | 358 | yes |
| heavy-screen-20-cycles | 20 | plain | 504262 | 474309–528082 | 1.00x | 0 | plain zero | 0 | yes |
| heavy-screen-20-cycles | 20 | facet | 812432 | 785826–924945 | 1.61x | 512 | plain zero | 511 | yes |
| tile-transfer-20 | 20 | plain | 19100 | 19000–20700 | 1.00x | 523 | 1.00x | 9 | yes |
| tile-transfer-20 | 20 | facet | 96800 | 94453–103209 | 5.07x | 1831 | 3.50x | 46 | yes |
| input-type-switch-20 | 20 | plain | 3500 | 2800–3700 | 1.00x | 548 | 1.00x | 2 | yes |
| input-type-switch-20 | 20 | facet | 1800 | 1300–1900 | 0.51x | 1218 | 2.22x | 15 | yes |
| localized-text-swap-50 | 10 | plain | 4300 | 3900–4500 | 1.00x | 551 | 1.00x | 0 | yes |
| localized-text-swap-50 | 10 | facet | 6100 | 4100–6400 | 1.42x | 1240 | 2.25x | 18 | yes |
| text-size-preference-50 | 8 | plain | 100 | 0–200 | 1.00x | 415 | 1.00x | 2 | yes |
| text-size-preference-50 | 8 | facet | 9100 | 7100–9600 | 91.00x | 969 | 2.33x | 4 | yes |
| phone-rotation-hub | 20 | plain | 800 | 400–800 | 1.00x | 500 | 1.00x | 0 | yes |
| phone-rotation-hub | 20 | facet | 1700 | 1300–2100 | 2.12x | 796 | 1.59x | 36 | yes |
| hud-composition-step-down | 20 | plain | 4300 | 2900–5700 | 1.00x | 472 | 1.00x | 1 | yes |
| hud-composition-step-down | 20 | facet | 3501 | 2300–4100 | 0.81x | 658 | 1.39x | 16 | yes |
| gamepad-grid-6x6 | 35 | plain | 2900 | 2800–3400 | 1.00x | 483 | 1.00x | 1 | yes |
| gamepad-grid-6x6 | 35 | facet | 16703 | 15200–17500 | 5.76x | 2025 | 4.19x | 40 | yes |
| drag-reorder-100 | 20 | plain | 14300 | 14001–14800 | 1.00x | 482 | 1.00x | 2 | yes |
| drag-reorder-100 | 20 | facet | 229003 | 223117–232502 | 16.01x | 6700 | 13.89x | 88 | yes |
| modal-on-modal | 20 | plain | 16400 | 16008–18200 | 1.00x | 447 | 1.00x | 0 | yes |
| modal-on-modal | 20 | facet | 91400 | 88202–93300 | 5.57x | 896 | 2.01x | 26 | yes |
| button-native-scale-50 | 20 | plain | 7957 | 6400–8300 | 1.00x | 437 | 1.00x | 2 | yes |
| button-native-scale-50 | 20 | facet | 8300 | 7900–8900 | 1.04x | 1341 | 3.07x | 32 | yes |

## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean.

| Lane | Measured time | Geometric mean time / plain | Measured heap | Geometric mean heap / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 29 | 1.00x |
| facet | 30 | 2.40x | 29 | 3.11x |
