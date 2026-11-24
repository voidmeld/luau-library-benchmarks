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
| Harness revision | `e68a2ed` |
| Date | 2026-11-14 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 2200 | 1900–2300 | 1.00x | 57 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 2200 | 2000–2967 | 1.00x | 765 | 13.42x | 0 | yes |
| update-leaf | 20 | compose | 2200 | 2100–2450 | 1.00x | 93 | 1.63x | 1 | yes |
| update-leaf | 20 | fusion | 2400 | 2150–2450 | 1.09x | 51 | 0.89x | 0 | yes |
| update-leaf | 20 | fusion-charm | 2650 | 2150–2800 | 1.20x | 55 | 0.96x | 1 | yes |
| update-leaf | 20 | react | 2200 | 2100–2433 | 1.00x | 355 | 6.23x | 0 | yes |
| update-leaf | 20 | react-reflex | 2350 | 2300–2452 | 1.07x | 292 | 5.12x | 0 | yes |
| update-leaf | 20 | react-upstream | 2350 | 2250–2600 | 1.07x | 292 | 5.12x | 0 | yes |
| update-leaf | 20 | roact | 2100 | 1970–2367 | 0.95x | 451 | 7.91x | 0 | yes |
| update-leaf | 20 | seam | 2451 | 2052–2850 | 1.11x | 40 | 0.70x | 1 | yes |
| update-leaf | 20 | signals | 2300 | 2150–2400 | 1.05x | 50 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 2450 | 2350–2550 | 1.11x | 3 | 0.05x | 1 | yes |
| update-batched | 20 | plain | 5300 | 4900–5719 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 14305 | 14004–15371 | 2.70x | 917 | 43.67x | 1 | yes |
| update-batched | 20 | compose | 8304 | 8100–8500 | 1.57x | 407 | 19.38x | 9 | yes |
| update-batched | 20 | fusion | 20201 | 19714–24543 | 3.81x | 500 | 23.81x | 0 | yes |
| update-batched | 20 | fusion-charm | 36106 | 35629–38900 | 6.81x | 1102 | 52.48x | 0 | yes |
| update-batched | 20 | react | 8100 | 7814–10000 | 1.53x | 533 | 25.38x | 0 | yes |
| update-batched | 20 | react-reflex | 20900 | 19700–21909 | 3.94x | 794 | 37.81x | 16 | yes |
| update-batched | 20 | react-upstream | 8200 | 7600–8600 | 1.55x | 477 | 22.71x | 0 | yes |
| update-batched | 20 | roact | 8000 | 7700–8200 | 1.51x | 874 | 41.62x | 8 | yes |
| update-batched | 20 | seam | 12525 | 11302–12900 | 2.36x | 1841 | 87.67x | 1 | yes |
| update-batched | 20 | signals | 8800 | 8600–9400 | 1.66x | 597 | 28.43x | 1 | yes |
| update-batched | 20 | vide | 8400 | 7900–9500 | 1.58x | 324 | 15.43x | 0 | yes |
| update-repeated | 10 | plain | 189 | 122–222 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 2700 | 2400–3000 | 14.29x | 16 | 8.00x | 0 | yes |
| update-repeated | 10 | compose | 300 | 100–500 | 1.59x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 21905 | 21428–22836 | 115.97x | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1041 | 960–1120 | 5.51x | 14 | 7.00x | 1 | yes |
| update-repeated | 10 | react | 4802 | 4600–5006 | 25.42x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 443 | 386–529 | 2.34x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 4900 | 4700–5000 | 25.94x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6200 | 5800–6900 | 32.82x | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | seam | 1240 | 1180–1424 | 6.56x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 738 | 688–762 | 3.90x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | vide | 478 | 400–522 | 2.53x | 0 | 0.50x | 0 | yes |
| branch-swap | 20 | plain | 22900 | 22700–24000 | 1.00x | 0 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 27102 | 26100–28426 | 1.18x | 36 | 36.00x | 8 | yes |
| branch-swap | 20 | compose | 24400 | 24000–24900 | 1.07x | 8 | 8.00x | 2 | yes |
| branch-swap | 20 | fusion | 26502 | 25303–27310 | 1.16x | 5 | 5.00x | 0 | yes |
| branch-swap | 20 | fusion-charm | 26100 | 26001–28603 | 1.14x | 7 | 7.00x | 0 | yes |
| branch-swap | 20 | react | 26200 | 25700–28435 | 1.14x | 18 | 18.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 27304 | 26211–30705 | 1.19x | 19 | 19.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 27206 | 25800–29501 | 1.19x | 11 | 11.00x | 1 | yes |
| branch-swap | 20 | roact | 25700 | 23402–27100 | 1.12x | 23 | 23.00x | 15 | yes |
| branch-swap | 20 | seam | 25800 | 25202–26703 | 1.13x | 11 | 11.00x | 1 | yes |
| branch-swap | 20 | signals | 23528 | 22400–25807 | 1.03x | 5 | 5.00x | 1 | yes |
| branch-swap | 20 | vide | 24700 | 23324–25700 | 1.08x | 5 | 5.00x | 0 | yes |
| keyed-prepend | 10 | plain | 2200 | 2133–2233 | 1.00x | 64 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 4800 | 4550–5054 | 2.18x | 1702 | 26.59x | 0 | yes |
| keyed-prepend | 10 | compose | 3752 | 3600–3902 | 1.71x | 575 | 8.98x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 19811 | 19000–21606 | 9.01x | 1524 | 23.81x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 20704 | 20000–21226 | 9.41x | 1522 | 23.78x | 9 | yes |
| keyed-prepend | 10 | react | 10300 | 9900–11000 | 4.68x | 777 | 12.14x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 11007 | 10401–12300 | 5.00x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 10000 | 9900–11241 | 4.55x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | roact | 5900 | 5100–6712 | 2.68x | 357 | 5.58x | 0 | yes |
| keyed-prepend | 10 | seam | 10000 | 9209–10600 | 4.55x | 2412 | 37.69x | 0 | yes |
| keyed-prepend | 10 | signals | 2350 | 2251–2650 | 1.07x | 66 | 1.03x | 1 | yes |
| keyed-prepend | 10 | vide | 4600 | 4100–5100 | 2.09x | 635 | 9.92x | 0 | yes |
| keyed-insert | 10 | plain | 1667 | 1567–1733 | 1.00x | 57 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 3954 | 3700–4814 | 2.37x | 1694 | 29.72x | 1 | yes |
| keyed-insert | 10 | compose | 2850 | 2600–2950 | 1.71x | 559 | 9.81x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 16400 | 14100–17704 | 9.84x | 1516 | 26.60x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 15600 | 13704–17110 | 9.36x | 1519 | 26.65x | 2 | yes |
| keyed-insert | 10 | react | 9100 | 8400–9400 | 5.46x | 803 | 14.09x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9311 | 8800–9904 | 5.59x | 811 | 14.23x | 0 | yes |
| keyed-insert | 10 | react-upstream | 9200 | 8800–10000 | 5.52x | 811 | 14.23x | 0 | yes |
| keyed-insert | 10 | roact | 5100 | 4700–5200 | 3.06x | 357 | 6.26x | 0 | yes |
| keyed-insert | 10 | seam | 9701 | 9500–10800 | 5.82x | 2428 | 42.60x | 0 | yes |
| keyed-insert | 10 | signals | 1833 | 1733–2133 | 1.10x | 58 | 1.02x | 0 | yes |
| keyed-insert | 10 | vide | 3250 | 3200–3350 | 1.95x | 635 | 11.14x | 0 | yes |
| keyed-shuffle | 10 | plain | 2350 | 2050–2400 | 1.00x | 116 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3950 | 3700–4500 | 1.68x | 1657 | 14.28x | 1 | yes |
| keyed-shuffle | 10 | compose | 4000 | 3350–4150 | 1.70x | 563 | 4.85x | 10 | yes |
| keyed-shuffle | 10 | fusion | 16000 | 14700–16700 | 6.81x | 1392 | 12.00x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 15600 | 14501–16202 | 6.64x | 1394 | 12.02x | 1 | yes |
| keyed-shuffle | 10 | react | 16701 | 16000–18000 | 7.11x | 767 | 6.61x | 1 | yes |
| keyed-shuffle | 10 | react-reflex | 18100 | 15408–18701 | 7.70x | 777 | 6.70x | 1 | yes |
| keyed-shuffle | 10 | react-upstream | 16700 | 16100–17600 | 7.11x | 840 | 7.24x | 0 | yes |
| keyed-shuffle | 10 | roact | 5900 | 5500–6500 | 2.51x | 361 | 3.11x | 0 | yes |
| keyed-shuffle | 10 | seam | 8600 | 8200–10900 | 3.66x | 2431 | 20.96x | 1 | yes |
| keyed-shuffle | 10 | signals | 2367 | 1502–2534 | 1.01x | 118 | 1.02x | 0 | yes |
| keyed-shuffle | 10 | vide | 4700 | 4250–5150 | 2.00x | 679 | 5.85x | 0 | yes |
| events | 1 | plain | 2000 | 1600–2400 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 2200 | 1900–2400 | 1.10x | 9 | 4.50x | 0 | yes |
| events | 1 | compose | 1800 | 1500–1900 | 0.90x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 2400 | 1900–2500 | 1.20x | 2 | 1.00x | 0 | yes |
| events | 1 | fusion-charm | 1601 | 1400–2500 | 0.80x | 8 | 4.00x | 0 | yes |
| events | 1 | react | 2401 | 1800–2700 | 1.20x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 2200 | 1900–2500 | 1.10x | 9 | 4.50x | 0 | yes |
| events | 1 | react-upstream | 2300 | 1800–2700 | 1.15x | 2 | 1.00x | 0 | yes |
| events | 1 | roact | 2000 | 1700–2300 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | seam | 1900 | 1500–2000 | 0.95x | 1 | 0.50x | 0 | yes |
| events | 1 | signals | 1900 | 1700–2500 | 0.95x | 2 | 1.00x | 1 | yes |
| events | 1 | vide | 3000 | 2700–4101 | 1.50x | 2 | 1.00x | 1 | yes |
| animate-many | 1 | plain | 2900 | 2600–3252 | 1.00x | 72 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 10200 | 10100–11700 | 3.52x | 1771 | 24.60x | 0 | yes |
| animate-many | 1 | compose | 6400 | 5700–7100 | 2.21x | 654 | 9.08x | 12 | yes |
| animate-many | 1 | fusion | 72320 | 71523–75970 | 24.94x | 1127 | 15.65x | 0 | yes |
| animate-many | 1 | fusion-charm | 74516 | 71937–79007 | 25.70x | 1122 | 15.58x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 21300 | 20506–21769 | 7.34x | 2898 | 40.25x | 1 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 9600 | 8000–10100 | 3.31x | 393 | 5.46x | 1 | yes |
| status-panel | 10 | plain | 2750 | 2450–2900 | 1.00x | 22 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 3150 | 2950–3600 | 1.15x | 92 | 4.18x | 1 | yes |
| status-panel | 10 | compose | 3300 | 2950–3750 | 1.20x | 47 | 2.14x | 2 | yes |
| status-panel | 10 | fusion | 4000 | 3950–4800 | 1.45x | 79 | 3.59x | 0 | yes |
| status-panel | 10 | fusion-charm | 4000 | 3900–4300 | 1.45x | 84 | 3.82x | 1 | yes |
| status-panel | 10 | react | 4501 | 4000–4700 | 1.64x | 57 | 2.59x | 0 | yes |
| status-panel | 10 | react-reflex | 4300 | 3700–5300 | 1.56x | 59 | 2.68x | 0 | yes |
| status-panel | 10 | react-upstream | 5100 | 4700–5300 | 1.85x | 57 | 2.59x | 0 | yes |
| status-panel | 10 | roact | 3100 | 2800–3350 | 1.13x | 45 | 2.05x | 1 | yes |
| status-panel | 10 | seam | 4100 | 3700–4200 | 1.49x | 155 | 7.05x | 0 | yes |
| status-panel | 10 | signals | 2650 | 2450–3200 | 0.96x | 30 | 1.36x | 1 | yes |
| status-panel | 10 | vide | 3901 | 3450–4050 | 1.42x | 47 | 2.14x | 0 | yes |
| scene-3d | 10 | plain | 2400 | 2400–2900 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4800 | 4500–5000 | 2.00x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 3150 | 3000–3404 | 1.31x | 195 | 17.73x | 2 | yes |
| scene-3d | 10 | fusion | 22803 | 21703–23300 | 9.50x | 520 | 47.27x | 1 | yes |
| scene-3d | 10 | fusion-charm | 24608 | 23600–25135 | 10.25x | 524 | 47.64x | 0 | yes |
| scene-3d | 10 | react | 3450 | 3251–3856 | 1.44x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | react-reflex | 3600 | 3150–4000 | 1.50x | 232 | 21.09x | 0 | yes |
| scene-3d | 10 | react-upstream | 3650 | 3401–4000 | 1.52x | 231 | 21.00x | 8 | yes |
| scene-3d | 10 | roact | 3450 | 3100–3500 | 1.44x | 566 | 51.45x | 0 | yes |
| scene-3d | 10 | seam | 10802 | 10000–11300 | 4.50x | 1754 | 159.45x | 0 | yes |
| scene-3d | 10 | signals | 5400 | 5000–5700 | 2.25x | 675 | 61.36x | 1 | yes |
| scene-3d | 10 | vide | 4000 | 3400–4050 | 1.67x | 204 | 18.55x | 1 | yes |
| derived-diamond | 3 | plain | 100 | 100–112 | 1.00x | 2 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 124 | 100–129 | 1.24x | 20 | 10.00x | 1 | yes |
| derived-diamond | 3 | compose | 119 | 106–125 | 1.19x | 18 | 9.00x | 2 | yes |
| derived-diamond | 3 | fusion | 144 | 131–156 | 1.44x | 8 | 4.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 156 | 131–181 | 1.56x | 11 | 5.50x | 1 | yes |
| derived-diamond | 3 | react | 292 | 233–358 | 2.92x | 6 | 3.00x | 2 | yes |
| derived-diamond | 3 | react-reflex | 350 | 292–358 | 3.50x | 15 | 7.50x | 0 | yes |
| derived-diamond | 3 | react-upstream | 309 | 245–345 | 3.09x | 6 | 3.00x | 2 | yes |
| derived-diamond | 3 | roact | 112 | 112–129 | 1.12x | 8 | 4.00x | 0 | yes |
| derived-diamond | 3 | seam | 150 | 120–190 | 1.50x | 29 | 14.50x | 8 | yes |
| derived-diamond | 3 | signals | 112 | 100–118 | 1.12x | 10 | 5.00x | 0 | yes |
| derived-diamond | 3 | vide | 125 | 112–138 | 1.25x | 6 | 3.00x | 0 | yes |
| derived-chain-100 | 3 | plain | 100 | 100–200 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | 370 | 310–480 | 3.70x | 344 | 86.00x | 0 | yes |
| derived-chain-100 | 3 | compose | 288 | 256–312 | 2.88x | 140 | 35.00x | 2 | yes |
| derived-chain-100 | 3 | fusion | 633 | 600–667 | 6.33x | 129 | 32.25x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 522 | 489–589 | 5.22x | 131 | 32.75x | 0 | yes |
| derived-chain-100 | 3 | react | 575 | 538–707 | 5.75x | 122 | 30.50x | 8 | yes |
| derived-chain-100 | 3 | react-reflex | 600 | 575–700 | 6.00x | 332 | 83.00x | 11 | yes |
| derived-chain-100 | 3 | react-upstream | 580 | 550–670 | 5.80x | 115 | 28.75x | 0 | yes |
| derived-chain-100 | 3 | roact | 141 | 112–188 | 1.41x | 8 | 2.00x | 1 | yes |
| derived-chain-100 | 3 | seam | 633 | 633–717 | 6.33x | 274 | 68.50x | 0 | yes |
| derived-chain-100 | 3 | signals | 200 | 175–269 | 2.00x | 176 | 44.00x | 1 | yes |
| derived-chain-100 | 3 | vide | 169 | 131–194 | 1.69x | 94 | 23.50x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 106 | 106–118 | 1.00x | 18 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 206 | 188–247 | 1.94x | 1513 | 84.06x | 8 | yes |
| derived-fan-in-1000 | 3 | compose | 270 | 250–300 | 2.55x | 679 | 37.72x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1060 | 1040–1160 | 10.01x | 890 | 49.44x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1075 | 1050–1175 | 10.15x | 2814 | 156.33x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2100 | 1600–2168 | 19.84x | 645 | 35.83x | 50 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 11900 | 8006–13400 | 112.39x | 5700 | 316.67x | 85 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1700 | 1367–2433 | 16.06x | 645 | 35.83x | 42 | yes |
| derived-fan-in-1000 | 3 | roact | 490 | 420–640 | 4.63x | 102 | 5.67x | 1 | yes |
| derived-fan-in-1000 | 3 | seam | 2072 | 1967–2700 | 19.57x | 2956 | 164.22x | 8 | yes |
| derived-fan-in-1000 | 3 | signals | 667 | 600–717 | 6.30x | 1212 | 67.33x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 370 | 340–450 | 3.49x | 528 | 29.33x | 1 | yes |
| filter-as-you-type | 1 | plain | 6500 | 6000–7600 | 1.00x | 41 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 15200 | 14847–17604 | 2.34x | 3000 | 73.17x | 0 | yes |
| filter-as-you-type | 1 | compose | 9900 | 8837–10400 | 1.52x | 842 | 20.54x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28703 | 24605–30502 | 4.42x | 2458 | 59.95x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 24500 | 23000–28900 | 3.77x | 2468 | 60.20x | 2 | yes |
| filter-as-you-type | 1 | react | 19906 | 18800–21000 | 3.06x | 11 | 0.27x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 19912 | 19200–22011 | 3.06x | 1159 | 28.27x | 12 | yes |
| filter-as-you-type | 1 | react-upstream | 21103 | 19700–22400 | 3.25x | 12 | 0.29x | 3 | yes |
| filter-as-you-type | 1 | roact | 9800 | 9600–10100 | 1.51x | 492 | 12.00x | 1 | yes |
| filter-as-you-type | 1 | seam | 24252 | 20435–26109 | 3.73x | 3885 | 94.76x | 0 | yes |
| filter-as-you-type | 1 | signals | 6800 | 6600–8600 | 1.05x | 45 | 1.10x | 0 | yes |
| filter-as-you-type | 1 | vide | 10156 | 9500–10401 | 1.56x | 960 | 23.41x | 1 | yes |
| theme-propagation | 3 | plain | 94900 | 93110–99002 | 1.00x | 49 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 96017 | 94775–104307 | 1.01x | 2079 | 42.43x | 1 | yes |
| theme-propagation | 3 | compose | 104208 | 99100–137110 | 1.10x | 581 | 11.86x | 2 | yes |
| theme-propagation | 3 | fusion | 97907 | 96505–105503 | 1.03x | 875 | 17.86x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 97817 | 97200–103659 | 1.03x | 877 | 17.90x | 1 | yes |
| theme-propagation | 3 | react | 100205 | 99311–109300 | 1.06x | 2028 | 41.39x | 0 | yes |
| theme-propagation | 3 | react-reflex | 93406 | 92403–100708 | 0.98x | 2030 | 41.43x | 1 | yes |
| theme-propagation | 3 | react-upstream | 101009 | 100420–121411 | 1.06x | 2036 | 41.55x | 8 | yes |
| theme-propagation | 3 | roact | 100202 | 98903–116819 | 1.06x | 3287 | 67.08x | 8 | yes |
| theme-propagation | 3 | seam | 95010 | 94417–95411 | 1.00x | 3477 | 70.96x | 0 | yes |
| theme-propagation | 3 | signals | 99632 | 98500–101911 | 1.05x | 912 | 18.61x | 8 | yes |
| theme-propagation | 3 | vide | 108803 | 97522–117202 | 1.15x | 613 | 12.51x | 0 | yes |
| hud-per-frame | 1 | plain | 3000 | 2700–3200 | 1.00x | 3 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5100 | 4600–5900 | 1.70x | 72 | 24.00x | 0 | yes |
| hud-per-frame | 1 | compose | 3500 | 3100–3900 | 1.17x | 30 | 10.00x | 2 | yes |
| hud-per-frame | 1 | fusion | 8800 | 8200–10300 | 2.93x | 54 | 18.00x | 1 | yes |
| hud-per-frame | 1 | fusion-charm | 13300 | 12621–14601 | 4.43x | 90 | 30.00x | 0 | yes |
| hud-per-frame | 1 | react | 3900 | 2800–4901 | 1.30x | 34 | 11.33x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7200 | 6700–7500 | 2.40x | 55 | 18.33x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 3800 | 2800–4100 | 1.27x | 35 | 11.67x | 1 | yes |
| hud-per-frame | 1 | roact | 4000 | 3900–4800 | 1.33x | 69 | 23.00x | 0 | yes |
| hud-per-frame | 1 | seam | 8300 | 7100–8800 | 2.77x | 169 | 56.33x | 0 | yes |
| hud-per-frame | 1 | signals | 4300 | 3700–4600 | 1.43x | 66 | 22.00x | 0 | yes |
| hud-per-frame | 1 | vide | 4700 | 4300–4900 | 1.57x | 26 | 8.67x | 0 | yes |
| teardown-under-load | 1 | plain | 38704 | 38600–39310 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 54600 | 53800–60300 | 1.41x | 16 | 3.20x | 8 | yes |
| teardown-under-load | 1 | compose | 47100 | 45600–47600 | 1.22x | 10 | 2.00x | 10 | yes |
| teardown-under-load | 1 | fusion | 66302 | 61300–72405 | 1.71x | 0 | 0.20x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 66809 | 60003–69104 | 1.73x | 7 | 1.40x | 0 | yes |
| teardown-under-load | 1 | react | 58607 | 57633–62500 | 1.51x | 1079 | 215.80x | 8 | yes |
| teardown-under-load | 1 | react-reflex | 61402 | 60205–62802 | 1.59x | 1081 | 216.20x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 58923 | 57902–63701 | 1.52x | 1071 | 214.20x | 1 | yes |
| teardown-under-load | 1 | roact | 50206 | 49305–51701 | 1.30x | 80 | 16.00x | 1 | yes |
| teardown-under-load | 1 | seam | 67301 | 61003–74702 | 1.74x | 10 | 2.00x | 1 | yes |
| teardown-under-load | 1 | signals | 48603 | 47823–52001 | 1.26x | 14 | 2.80x | 0 | yes |
| teardown-under-load | 1 | vide | 48605 | 47901–50200 | 1.26x | 15 | 3.00x | 9 | yes |
| open-close-retention | 1 | plain | 64420 | 63600–67319 | 1.00x | 12 | 1.00x | 9 | yes |
| open-close-retention | 1 | blend | 112820 | 112407–113317 | 1.75x | 7 | 0.58x | 0 | yes |
| open-close-retention | 1 | compose | 80117 | 78715–86012 | 1.24x | 8 | 0.67x | 2 | yes |
| open-close-retention | 1 | fusion | 138287 | 132667–141333 | 2.15x | 6 | 0.50x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 141334 | 136501–143674 | 2.19x | 7 | 0.58x | 0 | yes |
| open-close-retention | 1 | react | 108908 | 106543–117819 | 1.69x | 267 | 22.25x | 5 | yes |
| open-close-retention | 1 | react-reflex | 115752 | 114551–120209 | 1.80x | 276 | 23.00x | 0 | yes |
| open-close-retention | 1 | react-upstream | 113402 | 107256–118418 | 1.76x | 267 | 22.25x | 0 | yes |
| open-close-retention | 1 | roact | 100523 | 98101–104146 | 1.56x | 23 | 1.92x | 0 | yes |
| open-close-retention | 1 | seam | 140854 | 135143–143221 | 2.19x | 9 | 0.75x | 0 | yes |
| open-close-retention | 1 | signals | 81000 | 80259–92513 | 1.26x | 13 | 1.08x | 8 | yes |
| open-close-retention | 1 | vide | 90591 | 85433–100119 | 1.41x | 5 | 0.42x | 1 | yes |
| tree-expand-collapse | 1 | plain | 8600 | 8200–8800 | 1.00x | 51 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 21000 | 19000–22325 | 2.44x | 809 | 15.86x | 1 | yes |
| tree-expand-collapse | 1 | compose | 11800 | 11400–13600 | 1.37x | 80 | 1.57x | 13 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25074 | 22702–25300 | 2.92x | 166 | 3.25x | 9 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23600 | 21230–25100 | 2.74x | 168 | 3.29x | 1 | yes |
| tree-expand-collapse | 1 | react | 19000 | 17504–19402 | 2.21x | 4 | 0.08x | 2 | yes |
| tree-expand-collapse | 1 | react-reflex | 21100 | 18659–23333 | 2.45x | 628 | 12.31x | 0 | yes |
| tree-expand-collapse | 1 | react-upstream | 19400 | 18000–20433 | 2.26x | 0 | 0.02x | 1 | yes |
| tree-expand-collapse | 1 | roact | 10601 | 10400–11100 | 1.23x | 33 | 0.65x | 1 | yes |
| tree-expand-collapse | 1 | seam | 29001 | 24550–33900 | 3.37x | 141 | 2.76x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8600 | 8300–10100 | 1.00x | 31 | 0.61x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12401 | 11700–13500 | 1.44x | 72 | 1.41x | 0 | yes |
| form-validation | 1 | plain | 7100 | 6500–7200 | 1.00x | 5 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 7900 | 7600–8002 | 1.11x | 202 | 40.40x | 0 | yes |
| form-validation | 1 | compose | 7900 | 7300–8800 | 1.11x | 91 | 18.20x | 10 | yes |
| form-validation | 1 | fusion | 9100 | 8303–9200 | 1.28x | 127 | 25.40x | 8 | yes |
| form-validation | 1 | fusion-charm | 9400 | 8500–10300 | 1.32x | 156 | 31.20x | 0 | yes |
| form-validation | 1 | react | 8400 | 8300–8700 | 1.18x | 61 | 12.20x | 0 | yes |
| form-validation | 1 | react-reflex | 9000 | 8700–14200 | 1.27x | 80 | 16.00x | 0 | yes |
| form-validation | 1 | react-upstream | 8200 | 7400–9200 | 1.15x | 54 | 10.80x | 0 | yes |
| form-validation | 1 | roact | 8300 | 7400–8600 | 1.17x | 166 | 33.20x | 9 | yes |
| form-validation | 1 | seam | 8806 | 8705–10200 | 1.24x | 357 | 71.40x | 0 | yes |
| form-validation | 1 | signals | 8000 | 7500–8400 | 1.13x | 155 | 31.00x | 0 | yes |
| form-validation | 1 | vide | 7900 | 7200–8701 | 1.11x | 60 | 12.00x | 0 | yes |
| table-sort-filter | 1 | plain | 14600 | 14000–15625 | 1.00x | 89 | 1.00x | 8 | yes |
| table-sort-filter | 1 | blend | 36908 | 32400–37757 | 2.53x | 6098 | 68.52x | 1 | yes |
| table-sort-filter | 1 | compose | 22605 | 21055–26203 | 1.55x | 1625 | 18.26x | 18 | yes |
| table-sort-filter | 1 | fusion (workaround) | 58916 | 55401–60000 | 4.04x | 4680 | 52.58x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 53811 | 50029–56254 | 3.69x | 4714 | 52.97x | 2 | yes |
| table-sort-filter | 1 | react | 78666 | 77010–91314 | 5.39x | 2993 | 33.63x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 77146 | 73441–81380 | 5.28x | 3000 | 33.71x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 75631 | 71502–82174 | 5.18x | 2993 | 33.63x | 2 | yes |
| table-sort-filter | 1 | roact | 21800 | 20821–23100 | 1.49x | 1004 | 11.28x | 1 | yes |
| table-sort-filter | 1 | seam | 57422 | 51716–65505 | 3.93x | 7728 | 86.83x | 1 | yes |
| table-sort-filter | 1 | signals | 14903 | 14507–15418 | 1.02x | 92 | 1.03x | 0 | yes |
| table-sort-filter | 1 | vide | 23103 | 22400–23803 | 1.58x | 1922 | 21.60x | 9 | yes |
| library-load | 1 | plain | 56 | 54–105 | 1.00x | 2 | 1.00x | 1 | yes |
| library-load | 1 | blend | 853 | 820–981 | 15.13x | 459 | 229.50x | 456 | yes |
| library-load | 1 | compose | 771 | 722–812 | 13.67x | 66 | 33.00x | 55 | yes |
| library-load | 1 | fusion | 2488 | 2342–2504 | 44.12x | 262 | 131.00x | 261 | yes |
| library-load | 1 | fusion-charm | 2276 | 2205–2350 | 40.36x | 310 | 155.00x | 317 | yes |
| library-load | 1 | react | 6067 | 5533–6289 | 107.57x | 1826 | 913.00x | 1824 | yes |
| library-load | 1 | react-reflex | 8154 | 7606–9609 | 144.57x | 1984 | 992.00x | 1980 | yes |
| library-load | 1 | react-upstream | 6030 | 5723–6864 | 106.92x | 1995 | 997.50x | 2001 | yes |
| library-load | 1 | roact | 539 | 532–561 | 9.55x | 152 | 76.00x | 150 | yes |
| library-load | 1 | seam | 2270 | 2264–2374 | 40.24x | 242 | 121.00x | 231 | yes |
| library-load | 1 | signals | 289 | 282–307 | 5.12x | 42 | 21.00x | 33 | yes |
| library-load | 1 | vide | 473 | 449–519 | 8.39x | 138 | 69.00x | 146 | yes |
| rows-append-1000 | 1 | plain | 159307 | 155978–172513 | 1.00x | 3656 | 1.00x | 8 | yes |
| rows-append-1000 | 1 | blend | 223133 | 220173–243516 | 1.40x | 38434 | 10.51x | 1 | yes |
| rows-append-1000 | 1 | compose | 177574 | 165863–218726 | 1.11x | 11007 | 3.01x | 11 | yes |
| rows-append-1000 | 1 | fusion | 312511 | 300623–332992 | 1.96x | 20673 | 5.65x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 326179 | 305364–337124 | 2.05x | 28553 | 7.81x | 1 | yes |
| rows-append-1000 | 1 | react | 212619 | 201893–215865 | 1.33x | 18515 | 5.06x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 239586 | 203697–277222 | 1.50x | 20109 | 5.50x | 288 | yes |
| rows-append-1000 | 1 | react-upstream | 217810 | 215885–363228 | 1.37x | 18140 | 4.96x | 32 | yes |
| rows-append-1000 | 1 | roact | 194179 | 187613–204255 | 1.22x | 26735 | 7.31x | 8218 | yes |
| rows-append-1000 | 1 | seam | 245675 | 242116–306503 | 1.54x | 46403 | 12.69x | 237 | yes |
| rows-append-1000 | 1 | signals | 172779 | 165030–191611 | 1.08x | 17489 | 4.78x | 228 | yes |
| rows-append-1000 | 1 | vide | 171087 | 161150–174161 | 1.07x | 10431 | 2.85x | 8 | yes |
| rows-clear | 1 | plain | 19008 | 18600–20002 | 1.00x | 1251 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 39500 | 38400–44501 | 2.08x | 4150 | 3.32x | 0 | yes |
| rows-clear | 1 | compose | 26501 | 25600–27202 | 1.39x | 1886 | 1.51x | 3 | yes |
| rows-clear | 1 | fusion | 54224 | 52935–58251 | 2.85x | 3433 | 2.74x | 9 | yes |
| rows-clear | 1 | fusion-charm | 52817 | 51610–67152 | 2.78x | 7345 | 5.87x | 0 | yes |
| rows-clear | 1 | react | 27100 | 26603–27921 | 1.43x | 4488 | 3.59x | 0 | yes |
| rows-clear | 1 | react-reflex | 30300 | 29703–33600 | 1.59x | 6682 | 5.34x | 64 | yes |
| rows-clear | 1 | react-upstream | 27539 | 26213–27759 | 1.45x | 4488 | 3.59x | 0 | yes |
| rows-clear | 1 | roact | 27300 | 25700–27648 | 1.44x | 4174 | 3.34x | 1 | yes |
| rows-clear | 1 | seam | 41001 | 39201–50305 | 2.16x | 9163 | 7.32x | 0 | yes |
| rows-clear | 1 | signals | 24702 | 23600–30902 | 1.30x | 4410 | 3.53x | 8 | yes |
| rows-clear | 1 | vide | 23022 | 22129–23500 | 1.21x | 1613 | 1.29x | 1 | yes |
| rows-create-1000 | 1 | plain | 137004 | 136510–137706 | 1.00x | 1844 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 197719 | 190201–204420 | 1.44x | 19417 | 10.53x | 0 | yes |
| rows-create-1000 | 1 | compose | 158165 | 154205–161100 | 1.15x | 5579 | 3.03x | 3 | yes |
| rows-create-1000 | 1 | fusion | 207211 | 203102–213805 | 1.51x | 10627 | 5.76x | 9 | yes |
| rows-create-1000 | 1 | fusion-charm | 212507 | 202815–221208 | 1.55x | 14468 | 7.85x | 0 | yes |
| rows-create-1000 | 1 | react | 195900 | 185442–252564 | 1.43x | 8638 | 4.68x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 202702 | 191714–276603 | 1.48x | 9565 | 5.19x | 65 | yes |
| rows-create-1000 | 1 | react-upstream | 194400 | 185215–195336 | 1.42x | 8630 | 4.68x | 0 | yes |
| rows-create-1000 | 1 | roact | 171209 | 161612–175452 | 1.25x | 13580 | 7.36x | 4189 | yes |
| rows-create-1000 | 1 | seam | 214016 | 200107–240511 | 1.56x | 23553 | 12.77x | 1 | yes |
| rows-create-1000 | 1 | signals | 150104 | 147409–158516 | 1.10x | 9083 | 4.93x | 8 | yes |
| rows-create-1000 | 1 | vide | 158602 | 155507–251062 | 1.16x | 4948 | 2.68x | 0 | yes |
| rows-create-10000 | 1 | plain | 1668770 | 1655969–1735791 | 1.00x | 17014 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 2413253 | 2379723–2540204 | 1.45x | 189287 | 11.13x | 0 | yes |
| rows-create-10000 | 1 | compose | 2135174 | 2120923–2255495 | 1.28x | 55706 | 3.27x | 14 | yes |
| rows-create-10000 | 1 | fusion | 5587460 | 5035107–5795234 | 3.35x | 105126 | 6.18x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 5643880 | 5522178–5771249 | 3.38x | 142082 | 8.35x | 909 | yes |
| rows-create-10000 | 1 | react | 4487233 | 4424905–4503747 | 2.69x | 84595 | 4.97x | 348 | yes |
| rows-create-10000 | 1 | react-reflex | 4568380 | 4491411–4610129 | 2.74x | 94080 | 5.53x | 1104 | yes |
| rows-create-10000 | 1 | react-upstream | 4974149 | 4463336–5444490 | 2.98x | 85650 | 5.03x | 633 | yes |
| rows-create-10000 | 1 | roact | 2085065 | 2074896–2159578 | 1.25x | 134689 | 7.92x | 41256 | yes |
| rows-create-10000 | 1 | seam | 2603755 | 2504842–2722509 | 1.56x | 236794 | 13.92x | 4 | yes |
| rows-create-10000 | 1 | signals | 1986509 | 1800884–2282671 | 1.19x | 89482 | 5.26x | 0 | yes |
| rows-create-10000 | 1 | vide | 1914786 | 1905734–2123703 | 1.15x | 48538 | 2.85x | 16 | yes |
| rows-remove-one | 1 | plain | 200 | 100–300 | 1.00x | 1420 | 1.00x | 8 | yes |
| rows-remove-one | 1 | blend | 1300 | 1100–1400 | 6.50x | 18569 | 13.08x | 229 | yes |
| rows-remove-one | 1 | compose | 700 | 600–1050 | 3.50x | 4957 | 3.49x | 19 | yes |
| rows-remove-one | 1 | fusion (workaround) | 33800 | 32502–33902 | 169.00x | 11001 | 7.75x | 9 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 32900 | 31285–34442 | 164.50x | 14930 | 10.51x | 1 | yes |
| rows-remove-one | 1 | react | 16137 | 11400–60971 | 80.69x | 13176 | 9.28x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 20139 | 13531–20786 | 100.69x | 14094 | 9.93x | 64 | yes |
| rows-remove-one | 1 | react-upstream | 16700 | 12400–19400 | 83.50x | 13169 | 9.27x | 8 | yes |
| rows-remove-one | 1 | roact | 8500 | 7400–10500 | 42.50x | 13792 | 9.71x | 4194 | yes |
| rows-remove-one | 1 | seam | 7738 | 7500–10300 | 38.69x | 23342 | 16.44x | 236 | yes |
| rows-remove-one | 1 | signals | 1200 | 1050–1450 | 6.00x | 8630 | 6.08x | 0 | yes |
| rows-remove-one | 1 | vide | 1207 | 1150–1254 | 6.04x | 4561 | 3.21x | 1 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 1868 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 600 | 500–700 | 6.00x | 18811 | 10.07x | 9 | yes |
| rows-swap | 1 | compose | 100 | 100–200 | 1.00x | 5383 | 2.88x | 2 | yes |
| rows-swap | 1 | fusion | 32014 | 31200–45125 | 320.14x | 10004 | 5.36x | 0 | yes |
| rows-swap | 1 | fusion-charm | 30327 | 30100–36218 | 303.27x | 14226 | 7.62x | 1 | yes |
| rows-swap | 1 | react | 23109 | 21600–23903 | 231.09x | 9837 | 5.27x | 0 | yes |
| rows-swap | 1 | react-reflex | 26400 | 24300–39803 | 264.00x | 10843 | 5.80x | 65 | yes |
| rows-swap | 1 | react-upstream | 23600 | 22005–29604 | 236.00x | 9917 | 5.31x | 16 | yes |
| rows-swap | 1 | roact | 1800 | 1600–2050 | 18.00x | 13892 | 7.44x | 4182 | yes |
| rows-swap | 1 | seam | 5000 | 4900–6500 | 50.00x | 23560 | 12.61x | 9 | yes |
| rows-swap | 1 | signals | 200 | 100–600 | 2.00x | 9082 | 4.86x | 1 | yes |
| rows-swap | 1 | vide | 100 | 100–150 | 1.00x | 4972 | 2.66x | 0 | yes |
| rows-update-every-10th | 1 | plain | 3551 | 3506–4050 | 1.00x | 1405 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 3703 | 3600–3800 | 1.04x | 18779 | 13.37x | 0 | yes |
| rows-update-every-10th | 1 | compose | 3801 | 3700–3950 | 1.07x | 5009 | 3.57x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 4000 | 3700–5000 | 1.13x | 10008 | 7.12x | 9 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4304 | 4300–5502 | 1.21x | 13912 | 9.90x | 9 | yes |
| rows-update-every-10th | 1 | react | 3700 | 3600–4800 | 1.04x | 8599 | 6.12x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 6800 | 5200–8602 | 1.91x | 9539 | 6.79x | 72 | yes |
| rows-update-every-10th | 1 | react-upstream | 3901 | 3500–4100 | 1.10x | 8166 | 5.81x | 8 | yes |
| rows-update-every-10th | 1 | roact | 4350 | 3654–5056 | 1.23x | 13382 | 9.52x | 1 | yes |
| rows-update-every-10th | 1 | seam | 7300 | 7200–7800 | 2.06x | 23575 | 16.78x | 0 | yes |
| rows-update-every-10th | 1 | signals | 3800 | 3700–3850 | 1.07x | 8810 | 6.27x | 1 | yes |
| rows-update-every-10th | 1 | vide | 3736 | 3600–3900 | 1.05x | 4661 | 3.32x | 1 | yes |

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
| blend | 30 | 2.14x | 17.78x | 2.10x | 17.59x |
| compose | 30 | 1.52x | 5.96x | 1.50x | 5.87x |
| fusion | 30 | 4.96x | 8.44x | 4.69x | 8.26x |
| fusion-charm | 30 | 4.53x | 12.12x | 4.27x | 12.02x |
| react | 29 | 3.63x | 8.20x | 3.63x | 8.20x |
| react-reflex | 29 | 4.04x | 15.94x | 4.04x | 15.94x |
| react-upstream | 29 | 3.68x | 7.81x | 3.68x | 7.81x |
| roact | 29 | 2.12x | 7.88x | 2.12x | 7.88x |
| seam | 30 | 3.45x | 17.78x | 3.36x | 17.28x |
| signals | 29 | 1.48x | 4.54x | 1.48x | 4.54x |
| vide | 30 | 1.66x | 4.49x | 1.62x | 4.46x |
