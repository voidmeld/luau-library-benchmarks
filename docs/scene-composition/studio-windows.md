# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Harness revision | `985c2b6` |
| Date | 2026-11-11 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 900 | 200–1504 | 1.00x | 49 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 2067 | 1867–2422 | 2.30x | 758 | 15.47x | 1 | yes |
| update-leaf | 20 | compose | 2124 | 1867–2328 | 2.36x | 94 | 1.92x | 2 | yes |
| update-leaf | 20 | fusion | 2050 | 2000–2200 | 2.28x | 52 | 1.06x | 1 | yes |
| update-leaf | 20 | fusion-charm | 2600 | 2450–2664 | 2.89x | 61 | 1.24x | 1 | yes |
| update-leaf | 20 | react | 2050 | 1932–2450 | 2.28x | 348 | 7.10x | 1 | yes |
| update-leaf | 20 | react-reflex | 2200 | 2187–2300 | 2.44x | 301 | 6.14x | 9 | yes |
| update-leaf | 20 | react-upstream | 2082 | 1867–2348 | 2.31x | 291 | 5.94x | 0 | yes |
| update-leaf | 20 | roact | 2081 | 1888–2233 | 2.31x | 951 | 19.41x | 0 | yes |
| update-leaf | 20 | seam | 2150 | 1654–2676 | 2.39x | 41 | 0.84x | 1 | yes |
| update-leaf | 20 | signals | 2203 | 2034–2333 | 2.45x | 50 | 1.02x | 0 | yes |
| update-leaf | 20 | vide | 2100 | 2000–2242 | 2.33x | 2 | 0.04x | 0 | yes |
| update-batched | 20 | plain | 4400 | 4300–4450 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 10889 | 10600–11992 | 2.47x | 916 | 45.80x | 0 | yes |
| update-batched | 20 | compose | 7452 | 6905–7915 | 1.69x | 408 | 20.40x | 10 | yes |
| update-batched | 20 | fusion | 17402 | 16600–18000 | 3.96x | 508 | 25.40x | 0 | yes |
| update-batched | 20 | fusion-charm | 30838 | 29000–33073 | 7.01x | 1093 | 54.65x | 0 | yes |
| update-batched | 20 | react | 7511 | 7100–7900 | 1.71x | 533 | 26.65x | 0 | yes |
| update-batched | 20 | react-reflex | 53138 | 51686–65582 | 12.08x | 775 | 38.75x | 16 | yes |
| update-batched | 20 | react-upstream | 8308 | 7300–9056 | 1.89x | 476 | 23.80x | 0 | yes |
| update-batched | 20 | roact | 8100 | 7600–8600 | 1.84x | 1162 | 58.10x | 1 | yes |
| update-batched | 20 | seam | 11300 | 11000–12000 | 2.57x | 1832 | 91.60x | 0 | yes |
| update-batched | 20 | signals | 9312 | 8825–9878 | 2.12x | 597 | 29.85x | 1 | yes |
| update-batched | 20 | vide | 8600 | 8415–9504 | 1.95x | 332 | 16.60x | 0 | yes |
| update-repeated | 10 | plain | 39 | 38–42 | 1.00x | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 2996 | 2800–3132 | 77.36x | 7 | 3.50x | 0 | yes |
| update-repeated | 10 | compose | 478 | 422–489 | 12.34x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 20762 | 20200–25506 | 536.16x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1100 | 1041–1200 | 28.41x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 4900 | 4600–5344 | 126.54x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 742 | 683–966 | 19.15x | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 5100 | 4962–5586 | 131.70x | 1 | 0.50x | 1 | yes |
| update-repeated | 10 | roact | 6300 | 5800–7000 | 162.69x | 7 | 3.50x | 1 | yes |
| update-repeated | 10 | seam | 1272 | 1150–1579 | 32.85x | 11 | 5.50x | 1 | yes |
| update-repeated | 10 | signals | 805 | 720–900 | 20.78x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 500 | 396–634 | 12.91x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 24313 | 19901–28823 | 1.00x | 0 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 26564 | 26273–27657 | 1.09x | 27 | 27.00x | 0 | yes |
| branch-swap | 20 | compose | 25000 | 23778–25832 | 1.03x | 0 | 1.00x | 0 | yes |
| branch-swap | 20 | fusion | 28001 | 24101–36811 | 1.15x | 5 | 5.00x | 1 | yes |
| branch-swap | 20 | fusion-charm | 25289 | 24518–27740 | 1.04x | 14 | 14.00x | 8 | yes |
| branch-swap | 20 | react | 27800 | 25410–28127 | 1.14x | 10 | 10.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 27502 | 26005–30001 | 1.13x | 18 | 18.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 26198 | 25464–28392 | 1.08x | 18 | 18.00x | 0 | yes |
| branch-swap | 20 | roact | 27265 | 24909–30503 | 1.12x | 20 | 20.00x | 8 | yes |
| branch-swap | 20 | seam | 24874 | 21443–29200 | 1.02x | 11 | 11.00x | 0 | yes |
| branch-swap | 20 | signals | 24700 | 22600–25809 | 1.02x | 5 | 5.00x | 8 | yes |
| branch-swap | 20 | vide | 24476 | 23328–25865 | 1.01x | 13 | 13.00x | 0 | yes |
| keyed-prepend | 10 | plain | 1869 | 1642–1967 | 1.00x | 65 | 1.00x | 8 | yes |
| keyed-prepend | 10 | blend | 4367 | 4100–4450 | 2.34x | 1491 | 22.94x | 1 | yes |
| keyed-prepend | 10 | compose | 3978 | 3650–4101 | 2.13x | 579 | 8.91x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 17061 | 16290–17645 | 9.13x | 1527 | 23.49x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 16107 | 15628–16400 | 8.62x | 1506 | 23.17x | 1 | yes |
| keyed-prepend | 10 | react | 10300 | 10062–10721 | 5.51x | 785 | 12.08x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 10419 | 9300–12701 | 5.58x | 786 | 12.09x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 10000 | 9522–10804 | 5.35x | 784 | 12.06x | 0 | yes |
| keyed-prepend | 10 | roact | 6100 | 5800–6500 | 3.26x | 369 | 5.68x | 0 | yes |
| keyed-prepend | 10 | seam | 9100 | 8100–10700 | 4.87x | 2447 | 37.65x | 1 | yes |
| keyed-prepend | 10 | signals | 2556 | 2421–2633 | 1.37x | 61 | 0.94x | 0 | yes |
| keyed-prepend | 10 | vide | 4376 | 4154–4800 | 2.34x | 654 | 10.06x | 1 | yes |
| keyed-insert | 10 | plain | 1281 | 1200–1320 | 1.00x | 65 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 3516 | 3402–3750 | 2.75x | 1498 | 23.05x | 9 | yes |
| keyed-insert | 10 | compose | 2750 | 2500–2800 | 2.15x | 571 | 8.78x | 14 | yes |
| keyed-insert | 10 | fusion (workaround) | 14643 | 14016–15228 | 11.43x | 1527 | 23.49x | 0 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 16516 | 14604–17465 | 12.89x | 1513 | 23.28x | 1 | yes |
| keyed-insert | 10 | react | 10100 | 8293–18300 | 7.88x | 811 | 12.48x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9512 | 9154–10112 | 7.43x | 875 | 13.46x | 0 | yes |
| keyed-insert | 10 | react-upstream | 9200 | 8908–9400 | 7.18x | 811 | 12.48x | 0 | yes |
| keyed-insert | 10 | roact | 4750 | 4678–5104 | 3.71x | 369 | 5.68x | 1 | yes |
| keyed-insert | 10 | seam | 9520 | 8601–10324 | 7.43x | 2455 | 37.77x | 1 | yes |
| keyed-insert | 10 | signals | 1933 | 1667–2067 | 1.51x | 62 | 0.95x | 9 | yes |
| keyed-insert | 10 | vide | 3300 | 3006–3315 | 2.58x | 638 | 9.82x | 0 | yes |
| keyed-shuffle | 10 | plain | 1202 | 1170–1275 | 1.00x | 61 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2500 | 2451–2533 | 2.08x | 1432 | 23.48x | 1 | yes |
| keyed-shuffle | 10 | compose | 2408 | 2298–2566 | 2.00x | 578 | 9.48x | 10 | yes |
| keyed-shuffle | 10 | fusion | 15000 | 13402–16587 | 12.48x | 1391 | 22.80x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 14300 | 12200–14405 | 11.89x | 1392 | 22.82x | 1 | yes |
| keyed-shuffle | 10 | react | 14800 | 14200–15152 | 12.31x | 779 | 12.77x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 14100 | 14100–14705 | 11.73x | 779 | 12.77x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 14403 | 14262–15166 | 11.98x | 771 | 12.64x | 0 | yes |
| keyed-shuffle | 10 | roact | 4641 | 4526–4750 | 3.86x | 368 | 6.03x | 1 | yes |
| keyed-shuffle | 10 | seam | 8100 | 7024–8300 | 6.74x | 2438 | 39.97x | 0 | yes |
| keyed-shuffle | 10 | signals | 1665 | 1633–1800 | 1.39x | 60 | 0.98x | 0 | yes |
| keyed-shuffle | 10 | vide | 2750 | 2500–3266 | 2.29x | 621 | 10.18x | 0 | yes |
| events | 1 | plain | 2544 | 2000–2900 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | blend | 2700 | 1800–3200 | 1.06x | 1 | 0.50x | 0 | yes |
| events | 1 | compose | 2900 | 1900–3300 | 1.14x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 2600 | 2471–3873 | 1.02x | 0 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 3000 | 2500–3700 | 1.18x | 2 | 1.00x | 1 | yes |
| events | 1 | react | 3300 | 2776–4403 | 1.30x | 9 | 4.50x | 8 | yes |
| events | 1 | react-reflex | 4000 | 2900–4100 | 1.57x | 1 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 2275 | 1800–3700 | 0.89x | 9 | 4.50x | 8 | yes |
| events | 1 | roact | 1706 | 1400–2000 | 0.67x | 2 | 1.00x | 0 | yes |
| events | 1 | seam | 2400 | 1200–2500 | 0.94x | 2 | 1.00x | 1 | yes |
| events | 1 | signals | 2100 | 1600–2400 | 0.83x | 1 | 0.50x | 0 | yes |
| events | 1 | vide | 2900 | 2400–3168 | 1.14x | 1 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 2472 | 2367–2567 | 1.00x | 82 | 1.00x | 9 | yes |
| animate-many | 1 | blend | 10541 | 9609–11781 | 4.26x | 1778 | 21.68x | 0 | yes |
| animate-many | 1 | compose | 6901 | 6800–7300 | 2.79x | 744 | 9.07x | 12 | yes |
| animate-many | 1 | fusion | 70911 | 69137–73124 | 28.69x | 1137 | 13.87x | 1 | yes |
| animate-many | 1 | fusion-charm | 72915 | 71723–75050 | 29.50x | 1138 | 13.88x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20342 | 19154–21600 | 8.23x | 2890 | 35.24x | 1 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8700 | 7600–9800 | 3.52x | 392 | 4.78x | 0 | yes |
| status-panel | 10 | plain | 862 | 751–950 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 2350 | 2000–2500 | 2.73x | 70 | 35.00x | 1 | yes |
| status-panel | 10 | compose | 2372 | 2160–2434 | 2.75x | 33 | 16.50x | 1 | yes |
| status-panel | 10 | fusion | 2652 | 2600–2750 | 3.08x | 64 | 32.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 2800 | 2551–2950 | 3.25x | 69 | 34.50x | 0 | yes |
| status-panel | 10 | react | 2850 | 2750–3000 | 3.31x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | react-reflex | 2850 | 2600–3205 | 3.31x | 45 | 22.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2950 | 2756–3200 | 3.42x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | roact | 2034 | 1967–2233 | 2.36x | 34 | 17.00x | 8 | yes |
| status-panel | 10 | seam | 2792 | 2600–3070 | 3.24x | 140 | 70.00x | 0 | yes |
| status-panel | 10 | signals | 1967 | 1933–2123 | 2.28x | 14 | 7.00x | 0 | yes |
| status-panel | 10 | vide | 2120 | 2019–2367 | 2.46x | 25 | 12.50x | 0 | yes |
| scene-3d | 10 | plain | 2168 | 2165–2316 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 5000 | 4500–5400 | 2.31x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 3504 | 3250–3750 | 1.62x | 194 | 17.64x | 2 | yes |
| scene-3d | 10 | fusion | 23090 | 20701–24115 | 10.65x | 512 | 46.55x | 0 | yes |
| scene-3d | 10 | fusion-charm | 23101 | 20753–23610 | 10.66x | 516 | 46.91x | 0 | yes |
| scene-3d | 10 | react | 3550 | 3453–3713 | 1.64x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | react-reflex | 3451 | 3250–3550 | 1.59x | 225 | 20.45x | 0 | yes |
| scene-3d | 10 | react-upstream | 3700 | 3352–3752 | 1.71x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 3650 | 3500–3950 | 1.68x | 582 | 52.91x | 0 | yes |
| scene-3d | 10 | seam | 7701 | 7106–8260 | 3.55x | 1762 | 160.18x | 0 | yes |
| scene-3d | 10 | signals | 5400 | 4992–6412 | 2.49x | 674 | 61.27x | 0 | yes |
| scene-3d | 10 | vide | 3950 | 3750–4250 | 1.82x | 212 | 19.27x | 0 | yes |
| derived-diamond | 3 | plain | 25 | 21–34 | 1.00x | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 153 | 129–171 | 6.04x | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 135 | 124–159 | 5.34x | 10 | 2.00x | 2 | yes |
| derived-diamond | 3 | fusion | 150 | 131–156 | 5.92x | 8 | 1.60x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 165 | 141–176 | 6.51x | 11 | 2.20x | 1 | yes |
| derived-diamond | 3 | react | 292 | 218–427 | 11.51x | 6 | 1.20x | 3 | yes |
| derived-diamond | 3 | react-reflex | 324 | 258–353 | 12.78x | 18 | 3.60x | 7 | yes |
| derived-diamond | 3 | react-upstream | 300 | 257–347 | 11.85x | 7 | 1.40x | 4 | yes |
| derived-diamond | 3 | roact | 147 | 131–162 | 5.82x | 11 | 2.20x | 3 | yes |
| derived-diamond | 3 | seam | 230 | 211–278 | 9.08x | 28 | 5.60x | 8 | yes |
| derived-diamond | 3 | signals | 138 | 119–156 | 5.43x | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | vide | 138 | 131–140 | 5.43x | 6 | 1.20x | 0 | yes |
| derived-chain-100 | 3 | plain | 33 | 30–39 | 1.00x | 65 | 1.00x | 8 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 212 | 171–241 | 6.47x | 138 | 2.12x | 1 | yes |
| derived-chain-100 | 3 | fusion | 562 | 511–575 | 17.19x | 127 | 1.95x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 514 | 411–600 | 15.72x | 122 | 1.88x | 0 | yes |
| derived-chain-100 | 3 | react | 410 | 340–454 | 12.53x | 68 | 1.05x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 378 | 378–407 | 11.55x | 80 | 1.23x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 400 | 325–417 | 12.22x | 69 | 1.06x | 12 | yes |
| derived-chain-100 | 3 | roact | 171 | 142–206 | 5.21x | 10 | 0.15x | 3 | yes |
| derived-chain-100 | 3 | seam | 683 | 583–817 | 20.88x | 270 | 4.15x | 0 | yes |
| derived-chain-100 | 3 | signals | 241 | 176–259 | 7.37x | 174 | 2.68x | 0 | yes |
| derived-chain-100 | 3 | vide | 206 | 169–225 | 6.30x | 93 | 1.43x | 8 | yes |
| derived-fan-in-1000 | 3 | plain | 86 | 85–89 | 1.00x | 497 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 230 | 181–266 | 2.68x | 1535 | 3.09x | 8 | yes |
| derived-fan-in-1000 | 3 | compose | 322 | 292–338 | 3.76x | 696 | 1.40x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1180 | 1088–1240 | 13.77x | 889 | 1.79x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1160 | 1110–1240 | 13.54x | 2821 | 5.68x | 1 | yes |
| derived-fan-in-1000 | 3 | react | 1746 | 1400–1900 | 20.38x | 663 | 1.33x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8858 | 6900–12304 | 103.39x | 5642 | 11.35x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1826 | 1471–2695 | 21.31x | 663 | 1.33x | 43 | yes |
| derived-fan-in-1000 | 3 | roact | 446 | 409–531 | 5.21x | 112 | 0.23x | 11 | yes |
| derived-fan-in-1000 | 3 | seam | 1628 | 1575–1750 | 19.00x | 2947 | 5.93x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 612 | 450–668 | 7.15x | 1204 | 2.42x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 381 | 346–412 | 4.45x | 529 | 1.06x | 1 | yes |
| filter-as-you-type | 1 | plain | 6400 | 6200–8433 | 1.00x | 34 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 15238 | 13818–15808 | 2.38x | 2694 | 79.24x | 0 | yes |
| filter-as-you-type | 1 | compose | 10000 | 8895–10356 | 1.56x | 841 | 24.74x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 22701 | 20728–26557 | 3.55x | 2456 | 72.24x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 20900 | 20602–22700 | 3.27x | 2467 | 72.56x | 9 | yes |
| filter-as-you-type | 1 | react | 13900 | 13200–14430 | 2.17x | 76 | 2.24x | 12 | yes |
| filter-as-you-type | 1 | react-reflex | 15490 | 13680–16657 | 2.42x | 838 | 24.65x | 22 | yes |
| filter-as-you-type | 1 | react-upstream | 13963 | 13283–15770 | 2.18x | 72 | 2.12x | 4 | yes |
| filter-as-you-type | 1 | roact | 9607 | 9000–10212 | 1.50x | 503 | 14.79x | 3 | yes |
| filter-as-you-type | 1 | seam | 20900 | 19117–28200 | 3.27x | 4029 | 118.50x | 1 | yes |
| filter-as-you-type | 1 | signals | 7200 | 6800–7408 | 1.12x | 36 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | vide | 10307 | 9600–10900 | 1.61x | 959 | 28.21x | 0 | yes |
| theme-propagation | 3 | plain | 101799 | 98140–107247 | 1.00x | 206 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 99786 | 96066–114196 | 0.98x | 2078 | 10.09x | 0 | yes |
| theme-propagation | 3 | compose | 108360 | 103117–198300 | 1.06x | 572 | 2.78x | 2 | yes |
| theme-propagation | 3 | fusion | 105760 | 100600–157358 | 1.04x | 883 | 4.29x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 104507 | 98950–115548 | 1.03x | 869 | 4.22x | 0 | yes |
| theme-propagation | 3 | react | 107367 | 104181–111741 | 1.05x | 2027 | 9.84x | 0 | yes |
| theme-propagation | 3 | react-reflex | 100730 | 95614–111928 | 0.99x | 2021 | 9.81x | 0 | yes |
| theme-propagation | 3 | react-upstream | 109244 | 104605–111573 | 1.07x | 2027 | 9.84x | 0 | yes |
| theme-propagation | 3 | roact | 113160 | 100732–157298 | 1.11x | 3271 | 15.88x | 0 | yes |
| theme-propagation | 3 | seam | 97378 | 95608–97898 | 0.96x | 3478 | 16.88x | 1 | yes |
| theme-propagation | 3 | signals | 105570 | 102727–115792 | 1.04x | 903 | 4.38x | 0 | yes |
| theme-propagation | 3 | vide | 123954 | 104030–138869 | 1.22x | 613 | 2.98x | 0 | yes |
| hud-per-frame | 1 | plain | 3476 | 3100–4200 | 1.00x | 29 | 1.00x | 7 | yes |
| hud-per-frame | 1 | blend | 6200 | 5700–6900 | 1.78x | 72 | 2.48x | 1 | yes |
| hud-per-frame | 1 | compose | 6000 | 4900–6500 | 1.73x | 30 | 1.03x | 2 | yes |
| hud-per-frame | 1 | fusion | 10500 | 9100–10700 | 3.02x | 54 | 1.86x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 14500 | 12505–15400 | 4.17x | 91 | 3.14x | 1 | yes |
| hud-per-frame | 1 | react | 4778 | 3800–6100 | 1.37x | 42 | 1.45x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 8513 | 8200–8865 | 2.45x | 53 | 1.83x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 4600 | 3700–5600 | 1.32x | 34 | 1.17x | 0 | yes |
| hud-per-frame | 1 | roact | 5760 | 4400–6300 | 1.66x | 99 | 3.41x | 9 | yes |
| hud-per-frame | 1 | seam | 9800 | 9000–11518 | 2.82x | 169 | 5.83x | 0 | yes |
| hud-per-frame | 1 | signals | 6064 | 5400–6400 | 1.74x | 66 | 2.28x | 1 | yes |
| hud-per-frame | 1 | vide | 6100 | 4800–6500 | 1.75x | 25 | 0.86x | 0 | yes |
| teardown-under-load | 1 | plain | 41085 | 39366–42622 | 1.00x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 55442 | 51638–57719 | 1.35x | 6 | 1.20x | 1 | yes |
| teardown-under-load | 1 | compose | 46715 | 43655–47200 | 1.14x | 7 | 1.40x | 2 | yes |
| teardown-under-load | 1 | fusion | 68209 | 63027–74032 | 1.66x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 65331 | 54756–76232 | 1.59x | 15 | 3.00x | 0 | yes |
| teardown-under-load | 1 | react | 58972 | 56514–61172 | 1.44x | 1069 | 213.80x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 55709 | 53700–57184 | 1.36x | 1086 | 217.20x | 8 | yes |
| teardown-under-load | 1 | react-upstream | 56136 | 54907–59707 | 1.37x | 1078 | 215.60x | 0 | yes |
| teardown-under-load | 1 | roact | 56090 | 48667–56868 | 1.37x | 71 | 14.20x | 1 | yes |
| teardown-under-load | 1 | seam | 62009 | 54689–70183 | 1.51x | 16 | 3.20x | 14 | yes |
| teardown-under-load | 1 | signals | 45649 | 43500–51866 | 1.11x | 5 | 1.00x | 9 | yes |
| teardown-under-load | 1 | vide | 48119 | 46016–48438 | 1.17x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | plain | 66945 | 64139–67063 | 1.00x | 23 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 106303 | 104450–107158 | 1.59x | 6 | 0.26x | 0 | yes |
| open-close-retention | 1 | compose | 79709 | 77216–83265 | 1.19x | 8 | 0.35x | 0 | yes |
| open-close-retention | 1 | fusion | 126661 | 125391–134215 | 1.89x | 13 | 0.57x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 130540 | 126464–136205 | 1.95x | 7 | 0.30x | 1 | yes |
| open-close-retention | 1 | react | 104954 | 101135–111435 | 1.57x | 284 | 12.35x | 0 | yes |
| open-close-retention | 1 | react-reflex | 102081 | 101275–108233 | 1.52x | 284 | 12.35x | 0 | yes |
| open-close-retention | 1 | react-upstream | 103056 | 100712–112263 | 1.54x | 283 | 12.30x | 0 | yes |
| open-close-retention | 1 | roact | 100073 | 96912–106804 | 1.49x | 23 | 1.00x | 1 | yes |
| open-close-retention | 1 | seam | 118292 | 108553–122491 | 1.77x | 9 | 0.39x | 1 | yes |
| open-close-retention | 1 | signals | 79902 | 75243–80747 | 1.19x | 5 | 0.22x | 0 | yes |
| open-close-retention | 1 | vide | 84501 | 84016–85771 | 1.26x | 5 | 0.22x | 1 | yes |
| tree-expand-collapse | 1 | plain | 7500 | 7200–7600 | 1.00x | 28 | 1.00x | 8 | yes |
| tree-expand-collapse | 1 | blend | 19300 | 16526–19500 | 2.57x | 788 | 28.14x | 0 | yes |
| tree-expand-collapse | 1 | compose | 11993 | 10695–12601 | 1.60x | 72 | 2.57x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 23548 | 22301–27703 | 3.14x | 166 | 5.93x | 2 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 19979 | 19503–22250 | 2.66x | 160 | 5.71x | 1 | yes |
| tree-expand-collapse | 1 | react | 15100 | 13501–15208 | 2.01x | 78 | 2.79x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 14832 | 13137–15208 | 1.98x | 681 | 24.32x | 31 | yes |
| tree-expand-collapse | 1 | react-upstream | 15100 | 14360–16405 | 2.01x | 69 | 2.46x | 20 | yes |
| tree-expand-collapse | 1 | roact | 10100 | 8800–11300 | 1.35x | 35 | 1.25x | 4 | yes |
| tree-expand-collapse | 1 | seam | 25500 | 21377–29053 | 3.40x | 148 | 5.29x | 1 | yes |
| tree-expand-collapse | 1 | signals | 7900 | 7200–8400 | 1.05x | 21 | 0.75x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11100 | 10422–11300 | 1.48x | 71 | 2.54x | 1 | yes |
| form-validation | 1 | plain | 2934 | 2862–3277 | 1.00x | 54 | 1.00x | 8 | yes |
| form-validation | 1 | blend | 7734 | 7200–8792 | 2.64x | 336 | 6.22x | 1 | yes |
| form-validation | 1 | compose | 7500 | 6900–8500 | 2.56x | 106 | 1.96x | 2 | yes |
| form-validation | 1 | fusion | 8300 | 7300–8500 | 2.83x | 118 | 2.19x | 0 | yes |
| form-validation | 1 | fusion-charm | 9157 | 8558–10027 | 3.12x | 154 | 2.85x | 0 | yes |
| form-validation | 1 | react | 8647 | 8100–9332 | 2.95x | 65 | 1.20x | 0 | yes |
| form-validation | 1 | react-reflex | 8704 | 8600–9301 | 2.97x | 83 | 1.54x | 1 | yes |
| form-validation | 1 | react-upstream | 8700 | 7902–9601 | 2.97x | 65 | 1.20x | 0 | yes |
| form-validation | 1 | roact | 8001 | 7607–8600 | 2.73x | 223 | 4.13x | 0 | yes |
| form-validation | 1 | seam | 8800 | 7903–9306 | 3.00x | 349 | 6.46x | 1 | yes |
| form-validation | 1 | signals | 6900 | 6700–7300 | 2.35x | 154 | 2.85x | 0 | yes |
| form-validation | 1 | vide | 8110 | 7000–8606 | 2.76x | 70 | 1.30x | 0 | yes |
| table-sort-filter | 1 | plain | 14503 | 14203–14700 | 1.00x | 75 | 1.00x | 1 | yes |
| table-sort-filter | 1 | blend | 30202 | 28439–34358 | 2.08x | 5381 | 71.75x | 1 | yes |
| table-sort-filter | 1 | compose | 21412 | 19975–26064 | 1.48x | 1633 | 21.77x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 49306 | 45755–50700 | 3.40x | 4695 | 62.60x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 47111 | 40714–47523 | 3.25x | 4697 | 62.63x | 1 | yes |
| table-sort-filter | 1 | react | 54404 | 51605–57003 | 3.75x | 2108 | 28.11x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 54973 | 51173–55360 | 3.79x | 2115 | 28.20x | 23 | yes |
| table-sort-filter | 1 | react-upstream | 54007 | 52902–58002 | 3.72x | 2101 | 28.01x | 12 | yes |
| table-sort-filter | 1 | roact | 21518 | 19805–22781 | 1.48x | 1018 | 13.57x | 4 | yes |
| table-sort-filter | 1 | seam | 48091 | 43300–57325 | 3.32x | 7688 | 102.51x | 1 | yes |
| table-sort-filter | 1 | signals | 16754 | 16225–18060 | 1.16x | 76 | 1.01x | 1 | yes |
| table-sort-filter | 1 | vide | 21600 | 21410–22401 | 1.49x | 1914 | 25.52x | 0 | yes |
| library-load | 1 | plain | 44 | 41–235 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 754 | 716–868 | 17.22x | 459 | 459.00x | 448 | yes |
| library-load | 1 | compose | 646 | 631–657 | 14.75x | 67 | 67.00x | 64 | yes |
| library-load | 1 | fusion | 1727 | 1553–1993 | 39.42x | 262 | 262.00x | 261 | yes |
| library-load | 1 | fusion-charm | 1683 | 1610–2281 | 38.42x | 318 | 318.00x | 317 | yes |
| library-load | 1 | react | 5371 | 4863–6049 | 122.62x | 1817 | 1817.00x | 1824 | yes |
| library-load | 1 | react-reflex | 5493 | 5390–6696 | 125.41x | 1973 | 1973.00x | 1980 | yes |
| library-load | 1 | react-upstream | 5723 | 5206–5784 | 130.66x | 1986 | 1986.00x | 1993 | yes |
| library-load | 1 | roact | 463 | 443–625 | 10.57x | 162 | 162.00x | 159 | yes |
| library-load | 1 | seam | 1596 | 1411–1637 | 36.44x | 235 | 235.00x | 233 | yes |
| library-load | 1 | signals | 216 | 204–234 | 4.92x | 25 | 25.00x | 24 | yes |
| library-load | 1 | vide | 398 | 356–421 | 9.08x | 145 | 145.00x | 145 | yes |
| rows-append-1000 | 1 | plain | 169239 | 160552–179483 | 1.00x | 6533 | 1.00x | 9 | yes |
| rows-append-1000 | 1 | blend | 232965 | 225177–254557 | 1.38x | 38867 | 5.95x | 1 | yes |
| rows-append-1000 | 1 | compose | 189944 | 180220–227602 | 1.12x | 11023 | 1.69x | 10 | yes |
| rows-append-1000 | 1 | fusion | 320740 | 295813–377461 | 1.90x | 21386 | 3.27x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 349928 | 330271–368378 | 2.07x | 29194 | 4.47x | 1 | yes |
| rows-append-1000 | 1 | react | 236005 | 219707–296966 | 1.39x | 23234 | 3.56x | 32 | yes |
| rows-append-1000 | 1 | react-reflex | 242027 | 230707–317296 | 1.43x | 24831 | 3.80x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 238652 | 233916–328689 | 1.41x | 22913 | 3.51x | 0 | yes |
| rows-append-1000 | 1 | roact | 225099 | 204370–301417 | 1.33x | 33219 | 5.08x | 0 | yes |
| rows-append-1000 | 1 | seam | 248073 | 216354–264381 | 1.47x | 46595 | 7.13x | 240 | yes |
| rows-append-1000 | 1 | signals | 185825 | 166594–228602 | 1.10x | 17253 | 2.64x | 4 | yes |
| rows-append-1000 | 1 | vide | 170709 | 161509–197720 | 1.01x | 10431 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 16300 | 15600–20101 | 1.00x | 1221 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 33134 | 32880–37932 | 2.03x | 4177 | 3.42x | 1 | yes |
| rows-clear | 1 | compose | 21500 | 20555–22806 | 1.32x | 1885 | 1.54x | 3 | yes |
| rows-clear | 1 | fusion | 54113 | 50187–67910 | 3.32x | 3488 | 2.86x | 0 | yes |
| rows-clear | 1 | fusion-charm | 51314 | 46151–57004 | 3.15x | 7393 | 6.05x | 8 | yes |
| rows-clear | 1 | react | 22700 | 20215–30385 | 1.39x | 4479 | 3.67x | 0 | yes |
| rows-clear | 1 | react-reflex | 25012 | 21237–31321 | 1.53x | 6481 | 5.31x | 28 | yes |
| rows-clear | 1 | react-upstream | 22574 | 20401–27442 | 1.38x | 4487 | 3.67x | 0 | yes |
| rows-clear | 1 | roact | 22754 | 20988–25906 | 1.40x | 4206 | 3.44x | 1 | yes |
| rows-clear | 1 | seam | 32509 | 19341–38842 | 1.99x | 9231 | 7.56x | 0 | yes |
| rows-clear | 1 | signals | 19803 | 19629–23524 | 1.21x | 4458 | 3.65x | 0 | yes |
| rows-clear | 1 | vide | 17333 | 16863–19587 | 1.06x | 1612 | 1.32x | 0 | yes |
| rows-create-1000 | 1 | plain | 159160 | 153373–164783 | 1.00x | 3127 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 219846 | 196502–240403 | 1.38x | 19720 | 6.31x | 0 | yes |
| rows-create-1000 | 1 | compose | 187293 | 168448–228202 | 1.18x | 5818 | 1.86x | 2 | yes |
| rows-create-1000 | 1 | fusion | 251585 | 208177–273375 | 1.58x | 10947 | 3.50x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 235478 | 213816–263581 | 1.48x | 14892 | 4.76x | 0 | yes |
| rows-create-1000 | 1 | react | 201439 | 198824–232414 | 1.27x | 8176 | 2.61x | 24 | yes |
| rows-create-1000 | 1 | react-reflex | 223977 | 205918–281865 | 1.41x | 9074 | 2.90x | 45 | yes |
| rows-create-1000 | 1 | react-upstream | 211734 | 202424–234438 | 1.33x | 8144 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 193000 | 174037–224558 | 1.21x | 16921 | 5.41x | 1 | yes |
| rows-create-1000 | 1 | seam | 228030 | 221547–258567 | 1.43x | 23893 | 7.64x | 0 | yes |
| rows-create-1000 | 1 | signals | 175647 | 170801–194088 | 1.10x | 9098 | 2.91x | 8 | yes |
| rows-create-1000 | 1 | vide | 170082 | 158584–173826 | 1.07x | 4956 | 1.58x | 0 | yes |
| rows-create-10000 | 1 | plain | 1881694 | 1872486–2164586 | 1.00x | 29808 | 1.00x | 8 | yes |
| rows-create-10000 | 1 | blend | 2658049 | 2582907–2666562 | 1.41x | 188710 | 6.33x | 4 | yes |
| rows-create-10000 | 1 | compose | 2280323 | 2190814–2311844 | 1.21x | 55626 | 1.87x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6571171 | 6257272–6602937 | 3.49x | 105006 | 3.52x | 9 | yes |
| rows-create-10000 | 1 | fusion-charm | 6331366 | 6080411–6600740 | 3.36x | 145036 | 4.87x | 4 | yes |
| rows-create-10000 | 1 | react | 4509598 | 4240619–4516392 | 2.40x | 76939 | 2.58x | 308 | yes |
| rows-create-10000 | 1 | react-reflex | 4374803 | 4351966–4608796 | 2.32x | 87966 | 2.95x | 723 | yes |
| rows-create-10000 | 1 | react-upstream | 4400733 | 4252847–4601814 | 2.34x | 78258 | 2.63x | 272 | yes |
| rows-create-10000 | 1 | roact | 2433205 | 2349353–2460186 | 1.29x | 164254 | 5.51x | 0 | yes |
| rows-create-10000 | 1 | seam | 2602996 | 2545973–2709516 | 1.38x | 236196 | 7.92x | 4 | yes |
| rows-create-10000 | 1 | signals | 2144698 | 2057988–2171944 | 1.14x | 89618 | 3.01x | 0 | yes |
| rows-create-10000 | 1 | vide | 2143089 | 1901165–2264473 | 1.14x | 48484 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 750 | 550–950 | 1.00x | 2741 | 1.00x | 9 | yes |
| rows-remove-one | 1 | blend | 1200 | 1100–1600 | 1.60x | 18291 | 6.67x | 8 | yes |
| rows-remove-one | 1 | compose | 600 | 460–800 | 0.80x | 4949 | 1.81x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 36203 | 33839–59024 | 48.27x | 11097 | 4.05x | 0 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 33168 | 33087–36100 | 44.22x | 15034 | 5.48x | 1 | yes |
| rows-remove-one | 1 | react | 24412 | 22408–49711 | 32.55x | 15524 | 5.66x | 24 | yes |
| rows-remove-one | 1 | react-reflex | 27103 | 22502–61412 | 36.14x | 16422 | 5.99x | 44 | yes |
| rows-remove-one | 1 | react-upstream | 22985 | 15867–42433 | 30.65x | 15476 | 5.65x | 8 | yes |
| rows-remove-one | 1 | roact | 19100 | 13003–21087 | 25.47x | 16757 | 6.11x | 0 | yes |
| rows-remove-one | 1 | seam | 4600 | 4300–5102 | 6.13x | 23214 | 8.47x | 1 | yes |
| rows-remove-one | 1 | signals | 1570 | 1400–1750 | 2.09x | 8613 | 3.14x | 0 | yes |
| rows-remove-one | 1 | vide | 814 | 601–2200 | 1.09x | 4553 | 1.66x | 8 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 2687 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 700 | 600–800 | 7.00x | 18262 | 6.80x | 1 | yes |
| rows-swap | 1 | compose | 100 | 100–100 | 1.00x | 4912 | 1.83x | 10 | yes |
| rows-swap | 1 | fusion | 32579 | 31814–38336 | 325.79x | 9559 | 3.56x | 1 | yes |
| rows-swap | 1 | fusion-charm | 32359 | 31295–33305 | 323.59x | 14619 | 5.44x | 0 | yes |
| rows-swap | 1 | react | 33600 | 28901–35501 | 336.00x | 15441 | 5.75x | 0 | yes |
| rows-swap | 1 | react-reflex | 44702 | 32400–47371 | 447.02x | 16387 | 6.10x | 28 | yes |
| rows-swap | 1 | react-upstream | 35234 | 31778–92722 | 352.34x | 15001 | 5.58x | 8 | yes |
| rows-swap | 1 | roact | 15720 | 12117–21108 | 157.20x | 16293 | 6.06x | 9 | yes |
| rows-swap | 1 | seam | 4400 | 3902–5302 | 44.00x | 23220 | 8.64x | 9 | yes |
| rows-swap | 1 | signals | 650 | 400–850 | 6.50x | 8601 | 3.20x | 0 | yes |
| rows-swap | 1 | vide | 100 | 100–100 | 1.00x | 4516 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 3563 | 3300–4000 | 1.00x | 3183 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 3900 | 3600–5202 | 1.09x | 19264 | 6.05x | 0 | yes |
| rows-update-every-10th | 1 | compose | 4100 | 3998–5550 | 1.15x | 5465 | 1.72x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 4200 | 3700–5231 | 1.18x | 10536 | 3.31x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4300 | 4058–4800 | 1.21x | 14448 | 4.54x | 8 | yes |
| rows-update-every-10th | 1 | react | 3900 | 3586–4100 | 1.09x | 7846 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 6775 | 5500–7400 | 1.90x | 8862 | 2.78x | 60 | yes |
| rows-update-every-10th | 1 | react-upstream | 4000 | 3405–6500 | 1.12x | 7933 | 2.49x | 31 | yes |
| rows-update-every-10th | 1 | roact | 3800 | 3500–3810 | 1.07x | 16666 | 5.24x | 1 | yes |
| rows-update-every-10th | 1 | seam | 5600 | 4861–6327 | 1.57x | 24204 | 7.60x | 1 | yes |
| rows-update-every-10th | 1 | signals | 4300 | 3600–4500 | 1.21x | 9338 | 2.93x | 1 | yes |
| rows-update-every-10th | 1 | vide | 3900 | 3438–4601 | 1.09x | 5108 | 1.60x | 0 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. Every measured workload enters the geometric means. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

The shared columns use only the workloads that every lane measured: 28 for time (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`) and 28 for heap (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 2.52x | 10.27x | 2.47x | 10.00x |
| compose | 30 | 1.96x | 3.53x | 1.85x | 3.47x |
| fusion | 30 | 6.03x | 5.79x | 5.50x | 5.83x |
| fusion-charm | 30 | 5.63x | 7.73x | 5.12x | 7.97x |
| react | 29 | 4.49x | 6.61x | 4.33x | 7.06x |
| react-reflex | 29 | 5.08x | 9.27x | 4.93x | 9.97x |
| react-upstream | 29 | 4.45x | 6.64x | 4.29x | 7.09x |
| roact | 29 | 2.99x | 5.80x | 2.93x | 6.60x |
| seam | 30 | 4.00x | 12.11x | 3.67x | 12.11x |
| signals | 29 | 1.99x | 2.47x | 1.90x | 2.46x |
| vide | 30 | 1.99x | 2.89x | 1.88x | 2.91x |
