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
| Harness revision | `b0303f5` |
| Date | 2026-11-13 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 1000 | 600–1501 | 1.00x | 49 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 2401 | 2367–2500 | 2.40x | 765 | 15.61x | 1 | yes |
| update-leaf | 20 | compose | 2350 | 2150–2600 | 2.35x | 101 | 2.06x | 2 | yes |
| update-leaf | 20 | fusion | 2600 | 2350–2700 | 2.60x | 51 | 1.04x | 0 | yes |
| update-leaf | 20 | fusion-charm | 2600 | 2550–3000 | 2.60x | 54 | 1.10x | 1 | yes |
| update-leaf | 20 | react | 2650 | 2300–2900 | 2.65x | 355 | 7.24x | 0 | yes |
| update-leaf | 20 | react-reflex | 2650 | 2600–3100 | 2.65x | 292 | 5.96x | 0 | yes |
| update-leaf | 20 | react-upstream | 3050 | 2700–3100 | 3.05x | 291 | 5.94x | 0 | yes |
| update-leaf | 20 | roact | 2333 | 2133–2467 | 2.33x | 466 | 9.51x | 9 | yes |
| update-leaf | 20 | seam | 2450 | 2302–2550 | 2.45x | 40 | 0.82x | 8 | yes |
| update-leaf | 20 | signals | 2433 | 2300–2767 | 2.43x | 50 | 1.02x | 0 | yes |
| update-leaf | 20 | vide | 2500 | 2100–2850 | 2.50x | 3 | 0.06x | 0 | yes |
| update-batched | 20 | plain | 4083 | 4050–4210 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 14309 | 13900–15603 | 3.50x | 925 | 46.25x | 8 | yes |
| update-batched | 20 | compose | 9601 | 9102–10000 | 2.35x | 408 | 20.40x | 9 | yes |
| update-batched | 20 | fusion | 23802 | 22300–28248 | 5.83x | 501 | 25.05x | 0 | yes |
| update-batched | 20 | fusion-charm | 45287 | 41746–45902 | 11.09x | 1094 | 54.70x | 1 | yes |
| update-batched | 20 | react | 7900 | 7600–8201 | 1.93x | 533 | 26.65x | 0 | yes |
| update-batched | 20 | react-reflex | 22101 | 21302–22720 | 5.41x | 802 | 40.10x | 17 | yes |
| update-batched | 20 | react-upstream | 9800 | 7700–10202 | 2.40x | 485 | 24.25x | 8 | yes |
| update-batched | 20 | roact | 11200 | 10600–12500 | 2.74x | 875 | 43.75x | 1 | yes |
| update-batched | 20 | seam | 13000 | 12020–17000 | 3.18x | 1833 | 91.65x | 0 | yes |
| update-batched | 20 | signals | 9400 | 8900–9501 | 2.30x | 605 | 30.25x | 0 | yes |
| update-batched | 20 | vide | 8400 | 7900–8701 | 2.06x | 332 | 16.60x | 0 | yes |
| update-repeated | 10 | plain | 53 | 52–54 | 1.00x | 2 | 1.00x | 8 | yes |
| update-repeated | 10 | blend | 3050 | 2700–3250 | 57.94x | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 400 | 300–500 | 7.60x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 23300 | 22800–24400 | 442.60x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion-charm | 980 | 900–1020 | 18.62x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 4800 | 4500–5350 | 91.18x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 500 | 400–529 | 9.50x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 5710 | 5400–6501 | 108.47x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5803 | 5600–6100 | 110.23x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1167 | 1167–1400 | 22.16x | 11 | 5.50x | 1 | yes |
| update-repeated | 10 | signals | 686 | 643–771 | 13.03x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | vide | 471 | 414–529 | 8.96x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 21700 | 21201–23700 | 1.00x | 9 | 1.00x | 9 | yes |
| branch-swap | 20 | blend | 31823 | 31207–33701 | 1.47x | 35 | 3.89x | 9 | yes |
| branch-swap | 20 | compose | 27501 | 27141–29300 | 1.27x | 7 | 0.78x | 2 | yes |
| branch-swap | 20 | fusion | 27704 | 26632–30200 | 1.28x | 5 | 0.56x | 1 | yes |
| branch-swap | 20 | fusion-charm | 30608 | 28600–32002 | 1.41x | 7 | 0.78x | 0 | yes |
| branch-swap | 20 | react | 30200 | 27600–31000 | 1.39x | 18 | 2.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 30206 | 29107–33101 | 1.39x | 19 | 2.11x | 1 | yes |
| branch-swap | 20 | react-upstream | 29200 | 26600–30835 | 1.35x | 11 | 1.22x | 1 | yes |
| branch-swap | 20 | roact | 27403 | 26600–29307 | 1.26x | 23 | 2.56x | 14 | yes |
| branch-swap | 20 | seam | 26400 | 25600–28800 | 1.22x | 20 | 2.22x | 1 | yes |
| branch-swap | 20 | signals | 26400 | 25408–27326 | 1.22x | 5 | 0.56x | 0 | yes |
| branch-swap | 20 | vide | 27758 | 25817–28700 | 1.28x | 5 | 0.56x | 0 | yes |
| keyed-prepend | 10 | plain | 1600 | 1533–1667 | 1.00x | 56 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4906 | 4751–5350 | 3.07x | 1702 | 30.39x | 1 | yes |
| keyed-prepend | 10 | compose | 3900 | 3800–4200 | 2.44x | 568 | 10.14x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 20801 | 19502–22202 | 13.00x | 1524 | 27.21x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 18820 | 17907–21100 | 11.76x | 1494 | 26.68x | 0 | yes |
| keyed-prepend | 10 | react | 10500 | 10203–11606 | 6.56x | 785 | 14.02x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 10602 | 10400–12300 | 6.63x | 786 | 14.04x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 11000 | 10300–12100 | 6.88x | 785 | 14.02x | 0 | yes |
| keyed-prepend | 10 | roact | 6594 | 5403–7800 | 4.12x | 365 | 6.52x | 1 | yes |
| keyed-prepend | 10 | seam | 13305 | 10802–13912 | 8.32x | 2428 | 43.36x | 1 | yes |
| keyed-prepend | 10 | signals | 3000 | 2400–3250 | 1.88x | 67 | 1.20x | 1 | yes |
| keyed-prepend | 10 | vide | 4300 | 4100–4600 | 2.69x | 643 | 11.48x | 0 | yes |
| keyed-insert | 10 | plain | 1111 | 1040–1300 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4006 | 3900–4252 | 3.61x | 1694 | 26.47x | 0 | yes |
| keyed-insert | 10 | compose | 2950 | 2800–3050 | 2.66x | 560 | 8.75x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 17210 | 13800–19900 | 15.50x | 1524 | 23.81x | 2 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 16000 | 14300–16606 | 14.41x | 1518 | 23.72x | 2 | yes |
| keyed-insert | 10 | react | 10300 | 9200–11800 | 9.27x | 819 | 12.80x | 0 | yes |
| keyed-insert | 10 | react-reflex | 12204 | 11126–12748 | 10.99x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 9004 | 8400–9518 | 8.11x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 4900 | 4700–5308 | 4.41x | 365 | 5.70x | 8 | yes |
| keyed-insert | 10 | seam | 9700 | 9300–10400 | 8.73x | 2420 | 37.81x | 0 | yes |
| keyed-insert | 10 | signals | 1767 | 1700–2000 | 1.59x | 66 | 1.03x | 1 | yes |
| keyed-insert | 10 | vide | 3300 | 3250–3650 | 2.97x | 635 | 9.92x | 0 | yes |
| keyed-shuffle | 10 | plain | 960 | 840–1060 | 1.00x | 116 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2952 | 2650–3150 | 3.08x | 1640 | 14.14x | 0 | yes |
| keyed-shuffle | 10 | compose | 2600 | 2550–2660 | 2.71x | 571 | 4.92x | 10 | yes |
| keyed-shuffle | 10 | fusion | 16022 | 14401–16600 | 16.69x | 1391 | 11.99x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 16038 | 15304–17200 | 16.71x | 1394 | 12.02x | 0 | yes |
| keyed-shuffle | 10 | react | 15500 | 14900–17800 | 16.15x | 776 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 15104 | 14702–16100 | 15.73x | 776 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 15405 | 14701–17201 | 16.05x | 839 | 7.23x | 0 | yes |
| keyed-shuffle | 10 | roact | 4800 | 4100–5200 | 5.00x | 353 | 3.04x | 0 | yes |
| keyed-shuffle | 10 | seam | 8301 | 7600–9202 | 8.65x | 2424 | 20.90x | 0 | yes |
| keyed-shuffle | 10 | signals | 1625 | 1425–2400 | 1.69x | 118 | 1.02x | 1 | yes |
| keyed-shuffle | 10 | vide | 4602 | 4250–5050 | 4.79x | 671 | 5.78x | 1 | yes |
| events | 1 | plain | 4000 | 3800–4600 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | blend | 3500 | 3000–4300 | 0.88x | 2 | 1.00x | 0 | yes |
| events | 1 | compose | 4100 | 3100–5100 | 1.02x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 3600 | 3000–4900 | 0.90x | 1 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 4100 | 2400–4700 | 1.02x | 9 | 4.50x | 8 | yes |
| events | 1 | react | 4900 | 4000–5400 | 1.23x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 4506 | 4300–5000 | 1.13x | 1 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 3800 | 3500–4600 | 0.95x | 0 | 0.50x | 1 | yes |
| events | 1 | roact | 3900 | 3100–4400 | 0.97x | 1 | 0.50x | 8 | yes |
| events | 1 | seam | 3000 | 2700–4200 | 0.75x | 1 | 0.50x | 0 | yes |
| events | 1 | signals | 4301 | 3300–5301 | 1.08x | 1 | 0.50x | 1 | yes |
| events | 1 | vide | 3700 | 3000–4600 | 0.93x | 1 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 3100 | 3050–3650 | 1.00x | 71 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 16700 | 9900–18609 | 5.39x | 1771 | 24.94x | 1 | yes |
| animate-many | 1 | compose | 7100 | 7000–7400 | 2.29x | 655 | 9.23x | 12 | yes |
| animate-many | 1 | fusion | 74497 | 73735–77606 | 24.03x | 1120 | 15.77x | 0 | yes |
| animate-many | 1 | fusion-charm | 75110 | 74112–76900 | 24.23x | 1115 | 15.70x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 22203 | 21100–26179 | 7.16x | 2898 | 40.82x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 9100 | 7700–10300 | 2.94x | 392 | 5.52x | 0 | yes |
| status-panel | 10 | plain | 1100 | 950–1175 | 1.00x | 21 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 2400 | 2300–2750 | 2.18x | 92 | 4.38x | 1 | yes |
| status-panel | 10 | compose | 2600 | 2500–2900 | 2.36x | 48 | 2.29x | 2 | yes |
| status-panel | 10 | fusion | 2950 | 2850–3150 | 2.68x | 71 | 3.38x | 0 | yes |
| status-panel | 10 | fusion-charm | 3150 | 2750–3200 | 2.86x | 83 | 3.95x | 8 | yes |
| status-panel | 10 | react | 3450 | 3250–3700 | 3.14x | 49 | 2.33x | 0 | yes |
| status-panel | 10 | react-reflex | 3400 | 3101–3751 | 3.09x | 60 | 2.86x | 0 | yes |
| status-panel | 10 | react-upstream | 4112 | 3450–4250 | 3.74x | 56 | 2.67x | 0 | yes |
| status-panel | 10 | roact | 3400 | 3000–3600 | 3.09x | 44 | 2.10x | 0 | yes |
| status-panel | 10 | seam | 3150 | 3000–3350 | 2.86x | 156 | 7.43x | 0 | yes |
| status-panel | 10 | signals | 2450 | 2200–2700 | 2.23x | 38 | 1.81x | 0 | yes |
| status-panel | 10 | vide | 3250 | 3150–3350 | 2.95x | 39 | 1.86x | 0 | yes |
| scene-3d | 10 | plain | 2100 | 2037–2133 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4707 | 4600–5000 | 2.24x | 533 | 48.45x | 0 | yes |
| scene-3d | 10 | compose | 3450 | 3150–3600 | 1.64x | 195 | 17.73x | 2 | yes |
| scene-3d | 10 | fusion | 22900 | 21700–24107 | 10.90x | 512 | 46.55x | 1 | yes |
| scene-3d | 10 | fusion-charm | 21000 | 20400–22701 | 10.00x | 516 | 46.91x | 0 | yes |
| scene-3d | 10 | react | 3800 | 3470–4150 | 1.81x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | react-reflex | 3500 | 3100–3700 | 1.67x | 224 | 20.36x | 0 | yes |
| scene-3d | 10 | react-upstream | 3600 | 3300–3800 | 1.71x | 223 | 20.27x | 1 | yes |
| scene-3d | 10 | roact | 4350 | 4050–4750 | 2.07x | 567 | 51.55x | 0 | yes |
| scene-3d | 10 | seam | 8800 | 8200–9500 | 4.19x | 1755 | 159.55x | 1 | yes |
| scene-3d | 10 | signals | 6400 | 6200–6900 | 3.05x | 683 | 62.09x | 1 | yes |
| scene-3d | 10 | vide | 4600 | 4150–5200 | 2.19x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 17 | 14–23 | 1.00x | 0 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 138 | 125–175 | 8.21x | 20 | 20.00x | 0 | yes |
| derived-diamond | 3 | compose | 138 | 125–175 | 8.21x | 10 | 10.00x | 2 | yes |
| derived-diamond | 3 | fusion | 200 | 135–329 | 11.95x | 9 | 9.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 169 | 146–200 | 10.11x | 11 | 11.00x | 8 | yes |
| derived-diamond | 3 | react | 390 | 310–460 | 23.30x | 6 | 6.00x | 2 | yes |
| derived-diamond | 3 | react-reflex | 383 | 308–467 | 22.90x | 30 | 30.00x | 12 | yes |
| derived-diamond | 3 | react-upstream | 350 | 330–410 | 20.91x | 6 | 6.00x | 2 | yes |
| derived-diamond | 3 | roact | 212 | 159–265 | 12.65x | 7 | 7.00x | 0 | yes |
| derived-diamond | 3 | seam | 220 | 190–260 | 13.14x | 14 | 14.00x | 0 | yes |
| derived-diamond | 3 | signals | 147 | 129–159 | 8.79x | 10 | 10.00x | 1 | yes |
| derived-diamond | 3 | vide | 144 | 131–162 | 8.59x | 6 | 6.00x | 0 | yes |
| derived-chain-100 | 3 | plain | 33 | 27–34 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | 567 | 500–683 | 17.33x | 344 | 86.00x | 9 | yes |
| derived-chain-100 | 3 | compose | 300 | 285–354 | 9.17x | 132 | 33.00x | 0 | yes |
| derived-chain-100 | 3 | fusion | 625 | 600–675 | 19.11x | 129 | 32.25x | 8 | yes |
| derived-chain-100 | 3 | fusion-charm | 611 | 578–622 | 18.69x | 131 | 32.75x | 0 | yes |
| derived-chain-100 | 3 | react | 767 | 667–867 | 23.45x | 114 | 28.50x | 7 | yes |
| derived-chain-100 | 3 | react-reflex | 860 | 820–920 | 26.30x | 332 | 83.00x | 11 | yes |
| derived-chain-100 | 3 | react-upstream | 814 | 543–957 | 24.90x | 122 | 30.50x | 8 | yes |
| derived-chain-100 | 3 | roact | 135 | 124–159 | 4.14x | 7 | 1.75x | 0 | yes |
| derived-chain-100 | 3 | seam | 740 | 640–920 | 22.63x | 273 | 68.25x | 0 | yes |
| derived-chain-100 | 3 | signals | 375 | 188–406 | 11.47x | 175 | 43.75x | 0 | yes |
| derived-chain-100 | 3 | vide | 169 | 150–212 | 5.16x | 94 | 23.50x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 26 | 24–29 | 1.00x | 18 | 1.00x | 9 | yes |
| derived-fan-in-1000 | 3 | blend | 231 | 215–277 | 8.74x | 1506 | 83.67x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 331 | 300–362 | 12.53x | 687 | 38.17x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 1080 | 1040–1120 | 40.85x | 889 | 49.39x | 8 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1160 | 1100–1200 | 43.88x | 2814 | 156.33x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2333 | 1933–3669 | 88.26x | 653 | 36.28x | 58 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 12100 | 9900–13100 | 457.71x | 5716 | 317.56x | 85 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1850 | 1550–2750 | 69.98x | 644 | 35.78x | 42 | yes |
| derived-fan-in-1000 | 3 | roact | 586 | 543–957 | 22.16x | 102 | 5.67x | 0 | yes |
| derived-fan-in-1000 | 3 | seam | 2064 | 1950–2150 | 78.06x | 2955 | 164.17x | 9 | yes |
| derived-fan-in-1000 | 3 | signals | 712 | 625–988 | 26.95x | 1197 | 66.50x | 8 | yes |
| derived-fan-in-1000 | 3 | vide | 415 | 377–462 | 15.72x | 520 | 28.89x | 0 | yes |
| filter-as-you-type | 1 | plain | 6200 | 5700–6500 | 1.00x | 41 | 1.00x | 6 | yes |
| filter-as-you-type | 1 | blend | 17104 | 14900–18235 | 2.76x | 3016 | 73.56x | 8 | yes |
| filter-as-you-type | 1 | compose | 9600 | 9400–10100 | 1.55x | 842 | 20.54x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 25800 | 23700–30566 | 4.16x | 2458 | 59.95x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 25939 | 25412–29008 | 4.18x | 2460 | 60.00x | 2 | yes |
| filter-as-you-type | 1 | react | 24824 | 21600–27912 | 4.00x | 11 | 0.27x | 0 | yes |
| filter-as-you-type | 1 | react-reflex | 21107 | 20100–25803 | 3.40x | 1143 | 27.88x | 6 | yes |
| filter-as-you-type | 1 | react-upstream | 19905 | 19705–22800 | 3.21x | 11 | 0.27x | 2 | yes |
| filter-as-you-type | 1 | roact | 10532 | 9700–11967 | 1.70x | 500 | 12.20x | 1 | yes |
| filter-as-you-type | 1 | seam | 22801 | 19900–27616 | 3.68x | 3909 | 95.34x | 0 | yes |
| filter-as-you-type | 1 | signals | 6915 | 6800–7500 | 1.12x | 44 | 1.07x | 1 | yes |
| filter-as-you-type | 1 | vide | 10400 | 10200–10800 | 1.68x | 967 | 23.59x | 8 | yes |
| theme-propagation | 3 | plain | 106457 | 105521–142909 | 1.00x | 49 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 132091 | 104070–174429 | 1.24x | 2077 | 42.39x | 8 | yes |
| theme-propagation | 3 | compose | 111409 | 110725–126003 | 1.05x | 573 | 11.69x | 1 | yes |
| theme-propagation | 3 | fusion | 120202 | 108339–131605 | 1.13x | 874 | 17.84x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 111413 | 109205–138125 | 1.05x | 876 | 17.88x | 0 | yes |
| theme-propagation | 3 | react | 114100 | 112632–134231 | 1.07x | 2029 | 41.41x | 0 | yes |
| theme-propagation | 3 | react-reflex | 104701 | 104310–149304 | 0.98x | 2021 | 41.24x | 1 | yes |
| theme-propagation | 3 | react-upstream | 131468 | 111498–180668 | 1.23x | 2020 | 41.22x | 9 | yes |
| theme-propagation | 3 | roact | 123045 | 112816–146595 | 1.16x | 3278 | 66.90x | 8 | yes |
| theme-propagation | 3 | seam | 106902 | 104364–110702 | 1.00x | 3478 | 70.98x | 0 | yes |
| theme-propagation | 3 | signals | 118735 | 110396–129812 | 1.12x | 896 | 18.29x | 8 | yes |
| theme-propagation | 3 | vide | 134008 | 111030–147807 | 1.26x | 597 | 12.18x | 0 | yes |
| hud-per-frame | 1 | plain | 3000 | 2900–3201 | 1.00x | 11 | 1.00x | 8 | yes |
| hud-per-frame | 1 | blend | 7600 | 5100–10300 | 2.53x | 71 | 6.45x | 0 | yes |
| hud-per-frame | 1 | compose | 4700 | 4500–5100 | 1.57x | 29 | 2.64x | 2 | yes |
| hud-per-frame | 1 | fusion | 10300 | 10000–10500 | 3.43x | 61 | 5.55x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13600 | 13300–13900 | 4.53x | 91 | 8.27x | 8 | yes |
| hud-per-frame | 1 | react | 4400 | 3500–6801 | 1.47x | 26 | 2.36x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7900 | 7002–8400 | 2.63x | 55 | 5.00x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 4600 | 4000–5200 | 1.53x | 34 | 3.09x | 0 | yes |
| hud-per-frame | 1 | roact | 7400 | 4200–8700 | 2.47x | 71 | 6.45x | 0 | yes |
| hud-per-frame | 1 | seam | 10100 | 9300–10900 | 3.37x | 170 | 15.45x | 1 | yes |
| hud-per-frame | 1 | signals | 7900 | 6400–9900 | 2.63x | 65 | 5.91x | 0 | yes |
| hud-per-frame | 1 | vide | 5200 | 4600–5600 | 1.73x | 26 | 2.36x | 0 | yes |
| teardown-under-load | 1 | plain | 39800 | 39036–44921 | 1.00x | 3 | 1.00x | 8 | yes |
| teardown-under-load | 1 | blend | 56147 | 55800–59006 | 1.41x | 7 | 2.33x | 1 | yes |
| teardown-under-load | 1 | compose | 46504 | 45800–47990 | 1.17x | 8 | 2.67x | 1 | yes |
| teardown-under-load | 1 | fusion | 71682 | 69437–80822 | 1.80x | 5 | 1.67x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 70401 | 64018–79324 | 1.77x | 7 | 2.33x | 0 | yes |
| teardown-under-load | 1 | react | 62903 | 60014–71120 | 1.58x | 1078 | 359.33x | 8 | yes |
| teardown-under-load | 1 | react-reflex | 64414 | 60200–71206 | 1.62x | 1087 | 362.33x | 16 | yes |
| teardown-under-load | 1 | react-upstream | 61207 | 57811–77113 | 1.54x | 1078 | 359.33x | 0 | yes |
| teardown-under-load | 1 | roact | 54002 | 50607–62328 | 1.36x | 71 | 23.67x | 0 | yes |
| teardown-under-load | 1 | seam | 60725 | 51311–84907 | 1.53x | 8 | 2.67x | 7 | yes |
| teardown-under-load | 1 | signals | 49700 | 48559–52509 | 1.25x | 5 | 1.67x | 1 | yes |
| teardown-under-load | 1 | vide | 48724 | 47223–53650 | 1.22x | 13 | 4.33x | 8 | yes |
| open-close-retention | 1 | plain | 64233 | 62077–64450 | 1.00x | 11 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 133872 | 117551–135322 | 2.08x | 7 | 0.64x | 1 | yes |
| open-close-retention | 1 | compose | 83213 | 80720–84283 | 1.30x | 8 | 0.73x | 2 | yes |
| open-close-retention | 1 | fusion | 136680 | 133053–145407 | 2.13x | 5 | 0.45x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 137917 | 133933–139024 | 2.15x | 8 | 0.73x | 0 | yes |
| open-close-retention | 1 | react | 112081 | 111544–113364 | 1.74x | 268 | 24.36x | 0 | yes |
| open-close-retention | 1 | react-reflex | 117619 | 115804–121549 | 1.83x | 277 | 25.18x | 0 | yes |
| open-close-retention | 1 | react-upstream | 113132 | 109600–121950 | 1.76x | 267 | 24.27x | 0 | yes |
| open-close-retention | 1 | roact | 99701 | 97343–103462 | 1.55x | 23 | 2.09x | 1 | yes |
| open-close-retention | 1 | seam | 127327 | 120007–135814 | 1.98x | 9 | 0.82x | 0 | yes |
| open-close-retention | 1 | signals | 96658 | 93305–100767 | 1.50x | 12 | 1.09x | 8 | yes |
| open-close-retention | 1 | vide | 87822 | 84332–89609 | 1.37x | 13 | 1.18x | 0 | yes |
| tree-expand-collapse | 1 | plain | 6900 | 6700–7400 | 1.00x | 51 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 21602 | 19200–22701 | 3.13x | 809 | 15.86x | 8 | yes |
| tree-expand-collapse | 1 | compose | 12005 | 11500–12204 | 1.74x | 72 | 1.41x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24900 | 23500–27606 | 3.61x | 158 | 3.10x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 25200 | 20701–26948 | 3.65x | 168 | 3.29x | 1 | yes |
| tree-expand-collapse | 1 | react | 19401 | 18700–23668 | 2.81x | 4 | 0.08x | 2 | yes |
| tree-expand-collapse | 1 | react-reflex | 22607 | 22100–24708 | 3.28x | 628 | 12.31x | 5 | yes |
| tree-expand-collapse | 1 | react-upstream | 20314 | 19506–20640 | 2.94x | 12 | 0.24x | 10 | yes |
| tree-expand-collapse | 1 | roact | 13560 | 12600–14272 | 1.97x | 24 | 0.47x | 0 | yes |
| tree-expand-collapse | 1 | seam | 30606 | 23200–30910 | 4.44x | 148 | 2.90x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8600 | 8409–9000 | 1.25x | 38 | 0.75x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12900 | 11401–13900 | 1.87x | 71 | 1.39x | 0 | yes |
| form-validation | 1 | plain | 3001 | 2900–3850 | 1.00x | 0 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 9100 | 8700–10700 | 3.03x | 202 | 202.00x | 0 | yes |
| form-validation | 1 | compose | 9601 | 9000–10900 | 3.20x | 91 | 91.00x | 1 | yes |
| form-validation | 1 | fusion | 12900 | 10300–14600 | 4.30x | 119 | 119.00x | 8 | yes |
| form-validation | 1 | fusion-charm | 10600 | 10300–11900 | 3.53x | 155 | 155.00x | 0 | yes |
| form-validation | 1 | react | 9800 | 8400–9900 | 3.27x | 69 | 69.00x | 0 | yes |
| form-validation | 1 | react-reflex | 10600 | 10000–11100 | 3.53x | 79 | 79.00x | 1 | yes |
| form-validation | 1 | react-upstream | 10000 | 9500–10501 | 3.33x | 62 | 62.00x | 1 | yes |
| form-validation | 1 | roact | 9500 | 8800–10200 | 3.17x | 157 | 157.00x | 0 | yes |
| form-validation | 1 | seam | 10900 | 10300–16600 | 3.63x | 358 | 358.00x | 0 | yes |
| form-validation | 1 | signals | 9000 | 8700–10100 | 3.00x | 155 | 155.00x | 0 | yes |
| form-validation | 1 | vide | 8500 | 8301–8900 | 2.83x | 60 | 60.00x | 0 | yes |
| table-sort-filter | 1 | plain | 13600 | 13402–13703 | 1.00x | 81 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 40302 | 35000–47001 | 2.96x | 6130 | 75.68x | 0 | yes |
| table-sort-filter | 1 | compose | 23103 | 21900–25900 | 1.70x | 1624 | 20.05x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 68113 | 63140–78162 | 5.01x | 4696 | 57.98x | 0 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 56611 | 53900–58232 | 4.16x | 4706 | 58.10x | 1 | yes |
| table-sort-filter | 1 | react | 78036 | 73201–82679 | 5.74x | 2993 | 36.95x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 77223 | 74193–80310 | 5.68x | 2992 | 36.94x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 80712 | 73102–88670 | 5.93x | 2993 | 36.95x | 2 | yes |
| table-sort-filter | 1 | roact | 27175 | 25200–28825 | 2.00x | 1019 | 12.58x | 0 | yes |
| table-sort-filter | 1 | seam | 55505 | 51108–67110 | 4.08x | 7751 | 95.69x | 1 | yes |
| table-sort-filter | 1 | signals | 15348 | 15200–15416 | 1.13x | 92 | 1.14x | 0 | yes |
| table-sort-filter | 1 | vide | 24800 | 23700–25700 | 1.82x | 1915 | 23.64x | 1 | yes |
| library-load | 1 | plain | 52 | 50–56 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 816 | 811–904 | 15.67x | 459 | 459.00x | 457 | yes |
| library-load | 1 | compose | 732 | 719–748 | 14.06x | 58 | 58.00x | 64 | yes |
| library-load | 1 | fusion | 2421 | 2313–2549 | 46.47x | 264 | 264.00x | 255 | yes |
| library-load | 1 | fusion-charm | 2338 | 2215–2384 | 44.87x | 312 | 312.00x | 309 | yes |
| library-load | 1 | react | 5993 | 5709–6425 | 115.03x | 1818 | 1818.00x | 1824 | yes |
| library-load | 1 | react-reflex | 9312 | 8407–12305 | 178.74x | 1975 | 1975.00x | 1971 | yes |
| library-load | 1 | react-upstream | 5907 | 5684–6335 | 113.39x | 1994 | 1994.00x | 1993 | yes |
| library-load | 1 | roact | 512 | 506–539 | 9.83x | 160 | 160.00x | 158 | yes |
| library-load | 1 | seam | 2067 | 2004–2153 | 39.67x | 227 | 227.00x | 232 | yes |
| library-load | 1 | signals | 324 | 301–342 | 6.21x | 50 | 50.00x | 49 | yes |
| library-load | 1 | vide | 439 | 436–478 | 8.42x | 146 | 146.00x | 138 | yes |
| rows-append-1000 | 1 | plain | 163220 | 159209–169813 | 1.00x | 3656 | 1.00x | 8 | yes |
| rows-append-1000 | 1 | blend | 243130 | 236003–258906 | 1.49x | 38505 | 10.53x | 0 | yes |
| rows-append-1000 | 1 | compose | 197408 | 189451–256221 | 1.21x | 11039 | 3.02x | 2 | yes |
| rows-append-1000 | 1 | fusion | 335308 | 323254–356438 | 2.05x | 20681 | 5.66x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 345110 | 329252–363739 | 2.11x | 28586 | 7.82x | 1 | yes |
| rows-append-1000 | 1 | react | 229126 | 209266–284459 | 1.40x | 18412 | 5.04x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 235815 | 224864–302291 | 1.44x | 20109 | 5.50x | 297 | yes |
| rows-append-1000 | 1 | react-upstream | 238504 | 234673–339953 | 1.46x | 18075 | 4.94x | 32 | yes |
| rows-append-1000 | 1 | roact | 205032 | 186867–211352 | 1.26x | 26031 | 7.12x | 7994 | yes |
| rows-append-1000 | 1 | seam | 274661 | 219128–316877 | 1.68x | 46206 | 12.64x | 8 | yes |
| rows-append-1000 | 1 | signals | 187016 | 171269–245383 | 1.15x | 17498 | 4.79x | 236 | yes |
| rows-append-1000 | 1 | vide | 186209 | 167917–215812 | 1.14x | 10431 | 2.85x | 1 | yes |
| rows-clear | 1 | plain | 19100 | 18601–19900 | 1.00x | 1251 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 41000 | 39400–43804 | 2.15x | 4169 | 3.33x | 1 | yes |
| rows-clear | 1 | compose | 26301 | 26205–27200 | 1.38x | 1886 | 1.51x | 11 | yes |
| rows-clear | 1 | fusion | 54808 | 54207–65132 | 2.87x | 3425 | 2.74x | 0 | yes |
| rows-clear | 1 | fusion-charm | 56760 | 50331–62440 | 2.97x | 7329 | 5.86x | 0 | yes |
| rows-clear | 1 | react | 27600 | 26900–30000 | 1.45x | 4488 | 3.59x | 0 | yes |
| rows-clear | 1 | react-reflex | 31241 | 30800–33012 | 1.64x | 6680 | 5.34x | 63 | yes |
| rows-clear | 1 | react-upstream | 27313 | 26904–28421 | 1.43x | 4463 | 3.57x | 0 | yes |
| rows-clear | 1 | roact | 26817 | 25634–27500 | 1.40x | 4189 | 3.35x | 0 | yes |
| rows-clear | 1 | seam | 34694 | 25020–37000 | 1.82x | 9114 | 7.29x | 1 | yes |
| rows-clear | 1 | signals | 24314 | 23967–24602 | 1.27x | 4401 | 3.52x | 8 | yes |
| rows-clear | 1 | vide | 25400 | 23817–27983 | 1.33x | 1589 | 1.27x | 1 | yes |
| rows-create-1000 | 1 | plain | 153010 | 151805–154514 | 1.00x | 1836 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 222517 | 207701–225639 | 1.45x | 19489 | 10.61x | 1 | yes |
| rows-create-1000 | 1 | compose | 180101 | 171909–202142 | 1.18x | 5603 | 3.05x | 11 | yes |
| rows-create-1000 | 1 | fusion | 238542 | 205070–246604 | 1.56x | 10635 | 5.79x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 243108 | 207958–278826 | 1.59x | 14573 | 7.94x | 0 | yes |
| rows-create-1000 | 1 | react | 215438 | 207320–233994 | 1.41x | 8639 | 4.71x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 222228 | 210951–244734 | 1.45x | 9597 | 5.23x | 65 | yes |
| rows-create-1000 | 1 | react-upstream | 232262 | 226381–241224 | 1.52x | 8630 | 4.70x | 0 | yes |
| rows-create-1000 | 1 | roact | 189525 | 186498–196306 | 1.24x | 13588 | 7.40x | 4190 | yes |
| rows-create-1000 | 1 | seam | 226291 | 205623–260973 | 1.48x | 23518 | 12.81x | 0 | yes |
| rows-create-1000 | 1 | signals | 175727 | 160303–194129 | 1.15x | 9074 | 4.94x | 8 | yes |
| rows-create-1000 | 1 | vide | 176710 | 172042–283367 | 1.15x | 4948 | 2.69x | 0 | yes |
| rows-create-10000 | 1 | plain | 1772654 | 1753048–1829098 | 1.00x | 17026 | 1.00x | 20 | yes |
| rows-create-10000 | 1 | blend | 2580782 | 2468053–2691508 | 1.46x | 189418 | 11.13x | 0 | yes |
| rows-create-10000 | 1 | compose | 2183352 | 2178011–2198501 | 1.23x | 55674 | 3.27x | 10 | yes |
| rows-create-10000 | 1 | fusion | 5616275 | 5243927–5733735 | 3.17x | 105174 | 6.18x | 8 | yes |
| rows-create-10000 | 1 | fusion-charm | 5954964 | 5558746–6050984 | 3.36x | 144551 | 8.49x | 4 | yes |
| rows-create-10000 | 1 | react | 4635548 | 4409396–4777716 | 2.62x | 84734 | 4.98x | 849 | yes |
| rows-create-10000 | 1 | react-reflex | 4749886 | 4714008–4946509 | 2.68x | 94156 | 5.53x | 1072 | yes |
| rows-create-10000 | 1 | react-upstream | 4600042 | 4434124–5052052 | 2.60x | 84761 | 4.98x | 625 | yes |
| rows-create-10000 | 1 | roact | 2345057 | 2140361–2669363 | 1.32x | 130897 | 7.69x | 40096 | yes |
| rows-create-10000 | 1 | seam | 2630182 | 2543217–2951485 | 1.48x | 236150 | 13.87x | 0 | yes |
| rows-create-10000 | 1 | signals | 2071669 | 1929772–2114567 | 1.17x | 89514 | 5.26x | 0 | yes |
| rows-create-10000 | 1 | vide | 2053418 | 2004092–2292324 | 1.16x | 48540 | 2.85x | 16 | yes |
| rows-remove-one | 1 | plain | 600 | 350–650 | 1.00x | 1428 | 1.00x | 8 | yes |
| rows-remove-one | 1 | blend | 1401 | 1400–1600 | 2.33x | 18348 | 12.85x | 8 | yes |
| rows-remove-one | 1 | compose | 800 | 800–1000 | 1.33x | 4937 | 3.46x | 15 | yes |
| rows-remove-one | 1 | fusion (workaround) | 34442 | 33505–47359 | 57.40x | 10993 | 7.70x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 33100 | 33000–39200 | 55.17x | 14938 | 10.46x | 10 | yes |
| rows-remove-one | 1 | react | 18004 | 13406–37704 | 30.01x | 13152 | 9.21x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 22810 | 19300–39614 | 38.02x | 14102 | 9.88x | 56 | yes |
| rows-remove-one | 1 | react-upstream | 17201 | 12100–20303 | 28.67x | 13169 | 9.22x | 9 | yes |
| rows-remove-one | 1 | roact | 8063 | 7500–8500 | 13.44x | 13792 | 9.66x | 4186 | yes |
| rows-remove-one | 1 | seam | 7500 | 5500–8003 | 12.50x | 23105 | 16.18x | 4 | yes |
| rows-remove-one | 1 | signals | 2100 | 1700–2300 | 3.50x | 8646 | 6.05x | 9 | yes |
| rows-remove-one | 1 | vide | 1300 | 1050–1362 | 2.17x | 4562 | 3.19x | 8 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 1852 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 700 | 600–1500 | 7.00x | 18810 | 10.16x | 0 | yes |
| rows-swap | 1 | compose | 100 | 100–350 | 1.00x | 5375 | 2.90x | 3 | yes |
| rows-swap | 1 | fusion | 31500 | 30800–33702 | 315.00x | 9999 | 5.40x | 0 | yes |
| rows-swap | 1 | fusion-charm | 30803 | 29809–44910 | 308.03x | 14243 | 7.69x | 1 | yes |
| rows-swap | 1 | react | 23203 | 22119–24100 | 232.03x | 9854 | 5.32x | 0 | yes |
| rows-swap | 1 | react-reflex | 29501 | 25100–30101 | 295.01x | 10835 | 5.85x | 57 | yes |
| rows-swap | 1 | react-upstream | 25302 | 24814–27316 | 253.02x | 9894 | 5.34x | 1 | yes |
| rows-swap | 1 | roact | 2072 | 1900–2301 | 20.72x | 13900 | 7.51x | 4190 | yes |
| rows-swap | 1 | seam | 6200 | 4800–8091 | 62.00x | 23552 | 12.72x | 4 | yes |
| rows-swap | 1 | signals | 750 | 650–800 | 7.50x | 9098 | 4.91x | 8 | yes |
| rows-swap | 1 | vide | 100 | 100–100 | 1.00x | 4972 | 2.68x | 8 | yes |
| rows-update-every-10th | 1 | plain | 3737 | 3600–4000 | 1.00x | 1404 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 5300 | 3800–5601 | 1.42x | 18787 | 13.38x | 1 | yes |
| rows-update-every-10th | 1 | compose | 4109 | 4000–5100 | 1.10x | 5009 | 3.57x | 13 | yes |
| rows-update-every-10th | 1 | fusion | 4400 | 4100–4405 | 1.18x | 10007 | 7.13x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4700 | 4400–6200 | 1.26x | 13920 | 9.91x | 1 | yes |
| rows-update-every-10th | 1 | react | 4600 | 4301–4700 | 1.23x | 8607 | 6.13x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 7717 | 5925–8300 | 2.07x | 9531 | 6.79x | 64 | yes |
| rows-update-every-10th | 1 | react-upstream | 4502 | 4054–4570 | 1.20x | 8151 | 5.81x | 0 | yes |
| rows-update-every-10th | 1 | roact | 5301 | 4000–6100 | 1.42x | 13405 | 9.55x | 1 | yes |
| rows-update-every-10th | 1 | seam | 8000 | 7400–16500 | 2.14x | 23575 | 16.79x | 0 | yes |
| rows-update-every-10th | 1 | signals | 4404 | 4253–4600 | 1.18x | 8802 | 6.27x | 0 | yes |
| rows-update-every-10th | 1 | vide | 4561 | 4252–4950 | 1.22x | 4652 | 3.31x | 9 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. Every measured workload enters the geometric means. A ratio counts a time below 1 us as 1 us and a heap below 1 KiB as 1 KiB.

The shared columns use only the workloads that every lane measured: 29 for time (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-chain-100`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`) and 29 for heap (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-chain-100`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 30 | 3.18x | 16.31x | 3.13x | 16.07x |
| compose | 30 | 2.18x | 5.82x | 2.18x | 5.73x |
| fusion | 30 | 7.01x | 8.79x | 6.72x | 8.61x |
| fusion-charm | 30 | 6.42x | 12.05x | 6.13x | 11.94x |
| react | 29 | 5.37x | 8.24x | 5.37x | 8.24x |
| react-reflex | 29 | 5.90x | 15.37x | 5.90x | 15.37x |
| react-upstream | 29 | 5.39x | 8.45x | 5.39x | 8.45x |
| roact | 29 | 3.27x | 7.69x | 3.27x | 7.69x |
| seam | 30 | 4.76x | 17.84x | 4.70x | 17.33x |
| signals | 29 | 2.38x | 4.28x | 2.38x | 4.28x |
| vide | 30 | 2.30x | 4.73x | 2.28x | 4.71x |
