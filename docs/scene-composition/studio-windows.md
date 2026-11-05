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
| Roblox Studio | 0.746.0.7461264 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `36cfbf9` |
| Date | 2026-11-05 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 1100 | 500–1600 | 1.00x | 57 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 2900 | 2500–3450 | 2.64x | 773 | 13.56x | 0 | yes |
| update-leaf | 20 | compose | 2950 | 2700–3050 | 2.68x | 69 | 1.21x | 2 | yes |
| update-leaf | 20 | fusion | 2900 | 2850–3650 | 2.64x | 51 | 0.89x | 0 | yes |
| update-leaf | 20 | fusion-charm | 3500 | 3000–4801 | 3.18x | 62 | 1.09x | 1 | yes |
| update-leaf | 20 | react | 3000 | 2200–3500 | 2.73x | 347 | 6.09x | 0 | yes |
| update-leaf | 20 | react-reflex | 3250 | 3100–3451 | 2.95x | 285 | 5.00x | 0 | yes |
| update-leaf | 20 | react-upstream | 3150 | 2950–4100 | 2.86x | 291 | 5.11x | 0 | yes |
| update-leaf | 20 | roact | 2900 | 2600–3450 | 2.64x | 968 | 16.98x | 0 | yes |
| update-leaf | 20 | seam | 3000 | 2850–3100 | 2.73x | 40 | 0.70x | 0 | yes |
| update-leaf | 20 | signals | 3351 | 2950–3800 | 3.05x | 51 | 0.89x | 1 | yes |
| update-leaf | 20 | vide | 3100 | 2586–3200 | 2.82x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4102 | 4069–4500 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 15800 | 15400–17600 | 3.85x | 909 | 45.45x | 1 | yes |
| update-batched | 20 | compose | 9201 | 8600–10800 | 2.24x | 384 | 19.20x | 9 | yes |
| update-batched | 20 | fusion | 26900 | 24500–27800 | 6.56x | 500 | 25.00x | 0 | yes |
| update-batched | 20 | fusion-charm | 49732 | 41400–51913 | 12.12x | 1101 | 55.05x | 0 | yes |
| update-batched | 20 | react | 10200 | 8800–11700 | 2.49x | 485 | 24.25x | 0 | yes |
| update-batched | 20 | react-reflex | 85925 | 75301–89200 | 20.95x | 783 | 39.15x | 17 | yes |
| update-batched | 20 | react-upstream | 12300 | 10503–15504 | 3.00x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | roact | 13502 | 11800–16400 | 3.29x | 1170 | 58.50x | 1 | yes |
| update-batched | 20 | seam | 20800 | 19301–22300 | 5.07x | 1833 | 91.65x | 1 | yes |
| update-batched | 20 | signals | 12212 | 10900–14300 | 2.98x | 597 | 29.85x | 0 | yes |
| update-batched | 20 | vide | 12300 | 10500–14102 | 3.00x | 332 | 16.60x | 1 | yes |
| update-repeated | 10 | plain | 58 | 53–74 | 1.00x | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3502 | 3500–4365 | 60.71x | 8 | 4.00x | 1 | yes |
| update-repeated | 10 | compose | 614 | 500–643 | 10.65x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 25502 | 24613–27800 | 442.10x | 4 | 2.00x | 1 | yes |
| update-repeated | 10 | fusion-charm | 1500 | 1267–1700 | 26.00x | 7 | 3.50x | 0 | yes |
| update-repeated | 10 | react | 6000 | 5300–7702 | 104.02x | 1 | 0.50x | 1 | yes |
| update-repeated | 10 | react-reflex | 1200 | 1020–1400 | 20.80x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 5900 | 4600–6500 | 102.28x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6400 | 6000–6621 | 110.95x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1950 | 1625–2350 | 33.80x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 1133 | 1000–1267 | 19.65x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | vide | 743 | 557–914 | 12.88x | 0 | 0.50x | 0 | yes |
| branch-swap | 20 | plain | 22705 | 21674–23798 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 38152 | 32902–39798 | 1.68x | 35 | 17.50x | 0 | yes |
| branch-swap | 20 | compose | 34113 | 33422–36591 | 1.50x | 7 | 3.50x | 2 | yes |
| branch-swap | 20 | fusion | 38826 | 30530–112974 | 1.71x | 5 | 2.50x | 8 | yes |
| branch-swap | 20 | fusion-charm | 30202 | 28811–33879 | 1.33x | 15 | 7.50x | 9 | yes |
| branch-swap | 20 | react | 32412 | 30100–43168 | 1.43x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-reflex | 35217 | 33104–40617 | 1.55x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 35115 | 33747–39538 | 1.55x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | roact | 33933 | 30809–35422 | 1.49x | 12 | 6.00x | 0 | yes |
| branch-swap | 20 | seam | 29005 | 26702–31020 | 1.28x | 12 | 6.00x | 1 | yes |
| branch-swap | 20 | signals | 30030 | 25611–31212 | 1.32x | 5 | 2.50x | 1 | yes |
| branch-swap | 20 | vide | 29428 | 28000–31561 | 1.30x | 5 | 2.50x | 1 | yes |
| keyed-prepend | 10 | plain | 2119 | 2067–2433 | 1.00x | 64 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 6400 | 6000–7400 | 3.02x | 1482 | 23.16x | 0 | yes |
| keyed-prepend | 10 | compose | 5405 | 4400–6403 | 2.55x | 531 | 8.30x | 9 | yes |
| keyed-prepend | 10 | fusion (workaround) | 30309 | 25905–32803 | 14.31x | 1519 | 23.73x | 0 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 29606 | 28809–34308 | 13.97x | 1513 | 23.64x | 1 | yes |
| keyed-prepend | 10 | react | 18124 | 16308–19625 | 8.55x | 777 | 12.14x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 15120 | 13000–16407 | 7.14x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 15900 | 10907–17085 | 7.50x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | roact | 9201 | 7207–10600 | 4.34x | 362 | 5.66x | 1 | yes |
| keyed-prepend | 10 | seam | 18488 | 17723–18700 | 8.73x | 2455 | 38.36x | 1 | yes |
| keyed-prepend | 10 | signals | 3901 | 3356–4400 | 1.84x | 62 | 0.97x | 0 | yes |
| keyed-prepend | 10 | vide | 8000 | 6800–8400 | 3.78x | 646 | 10.09x | 8 | yes |
| keyed-insert | 10 | plain | 1375 | 1325–1702 | 1.00x | 65 | 1.00x | 8 | yes |
| keyed-insert | 10 | blend | 4900 | 3400–5100 | 3.56x | 1482 | 22.80x | 0 | yes |
| keyed-insert | 10 | compose | 4400 | 3550–4601 | 3.20x | 531 | 8.17x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 27107 | 23307–30023 | 19.71x | 1527 | 23.49x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 23517 | 22277–34008 | 17.10x | 1522 | 23.42x | 2 | yes |
| keyed-insert | 10 | react | 14100 | 13012–19996 | 10.25x | 803 | 12.35x | 0 | yes |
| keyed-insert | 10 | react-reflex | 11700 | 10600–13112 | 8.51x | 860 | 13.23x | 0 | yes |
| keyed-insert | 10 | react-upstream | 11900 | 10302–12800 | 8.65x | 811 | 12.48x | 0 | yes |
| keyed-insert | 10 | roact | 8002 | 6002–8205 | 5.82x | 362 | 5.57x | 0 | yes |
| keyed-insert | 10 | seam | 16664 | 15506–17005 | 12.12x | 2456 | 37.78x | 1 | yes |
| keyed-insert | 10 | signals | 3151 | 2500–3851 | 2.29x | 61 | 0.94x | 0 | yes |
| keyed-insert | 10 | vide | 4350 | 3900–5751 | 3.16x | 638 | 9.82x | 0 | yes |
| keyed-shuffle | 10 | plain | 1180 | 1140–1533 | 1.00x | 60 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 4300 | 3500–5500 | 3.64x | 1440 | 24.00x | 1 | yes |
| keyed-shuffle | 10 | compose | 4450 | 3700–5550 | 3.77x | 530 | 8.83x | 10 | yes |
| keyed-shuffle | 10 | fusion | 23000 | 21900–27394 | 19.49x | 1390 | 23.17x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 20300 | 17203–20800 | 17.20x | 1392 | 23.20x | 0 | yes |
| keyed-shuffle | 10 | react | 19400 | 17700–20302 | 16.44x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 18800 | 17500–20300 | 15.93x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 19302 | 16800–22101 | 16.36x | 778 | 12.97x | 0 | yes |
| keyed-shuffle | 10 | roact | 6100 | 5900–6900 | 5.17x | 368 | 6.13x | 0 | yes |
| keyed-shuffle | 10 | seam | 11900 | 11000–14200 | 10.08x | 2439 | 40.65x | 8 | yes |
| keyed-shuffle | 10 | signals | 2950 | 2350–3550 | 2.50x | 61 | 1.02x | 1 | yes |
| keyed-shuffle | 10 | vide | 4900 | 4050–5050 | 4.15x | 629 | 10.48x | 1 | yes |
| events | 1 | plain | 4300 | 2500–5000 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | blend | 4100 | 3603–5303 | 0.95x | 2 | 1.00x | 8 | yes |
| events | 1 | compose | 4400 | 3000–5900 | 1.02x | 0 | 0.50x | 0 | yes |
| events | 1 | fusion | 4700 | 4306–6345 | 1.09x | 1 | 0.50x | 1 | yes |
| events | 1 | fusion-charm | 5400 | 4303–6100 | 1.26x | 2 | 1.00x | 0 | yes |
| events | 1 | react | 6901 | 5300–7615 | 1.60x | 2 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 6201 | 5800–6600 | 1.44x | 8 | 4.00x | 1 | yes |
| events | 1 | react-upstream | 4118 | 3700–5832 | 0.96x | 0 | 0.50x | 0 | yes |
| events | 1 | roact | 3500 | 2200–4523 | 0.81x | 2 | 1.00x | 1 | yes |
| events | 1 | seam | 2700 | 2500–3200 | 0.63x | 2 | 1.00x | 1 | yes |
| events | 1 | signals | 2600 | 2100–3600 | 0.60x | 2 | 1.00x | 1 | yes |
| events | 1 | vide | 4114 | 3300–5400 | 0.96x | 2 | 1.00x | 1 | yes |
| animate-many | 1 | plain | 3851 | 3500–4457 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 24002 | 21203–24900 | 6.23x | 1771 | 23.93x | 1 | yes |
| animate-many | 1 | compose | 10800 | 8500–13913 | 2.80x | 728 | 9.84x | 12 | yes |
| animate-many | 1 | fusion | 94916 | 92981–95336 | 24.65x | 1136 | 15.35x | 0 | yes |
| animate-many | 1 | fusion-charm | 94014 | 91236–99000 | 24.41x | 1130 | 15.27x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 44417 | 42114–46044 | 11.53x | 2882 | 38.95x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 19586 | 17307–22649 | 5.09x | 385 | 5.20x | 0 | yes |
| status-panel | 10 | plain | 960 | 900–1060 | 1.00x | 3 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 3200 | 2900–3450 | 3.33x | 70 | 23.33x | 0 | yes |
| status-panel | 10 | compose | 3610 | 3200–4202 | 3.76x | 32 | 10.67x | 0 | yes |
| status-panel | 10 | fusion | 4700 | 4000–5452 | 4.90x | 64 | 21.33x | 1 | yes |
| status-panel | 10 | fusion-charm | 5450 | 3700–6515 | 5.68x | 70 | 23.33x | 0 | yes |
| status-panel | 10 | react | 4751 | 4600–5506 | 4.95x | 34 | 11.33x | 0 | yes |
| status-panel | 10 | react-reflex | 4938 | 3800–5700 | 5.14x | 45 | 15.00x | 1 | yes |
| status-panel | 10 | react-upstream | 4300 | 3700–5011 | 4.48x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | roact | 4000 | 3150–4500 | 4.17x | 33 | 11.00x | 0 | yes |
| status-panel | 10 | seam | 5203 | 4700–5700 | 5.42x | 140 | 46.67x | 0 | yes |
| status-panel | 10 | signals | 3702 | 3150–4152 | 3.86x | 7 | 2.33x | 0 | yes |
| status-panel | 10 | vide | 3750 | 3050–4404 | 3.91x | 25 | 8.33x | 0 | yes |
| scene-3d | 10 | plain | 2133 | 2001–2300 | 1.00x | 10 | 1.00x | 1 | yes |
| scene-3d | 10 | blend | 6200 | 5400–7949 | 2.91x | 541 | 54.10x | 0 | yes |
| scene-3d | 10 | compose | 4300 | 3850–5200 | 2.02x | 171 | 17.10x | 2 | yes |
| scene-3d | 10 | fusion | 25819 | 24300–27700 | 12.10x | 512 | 51.20x | 0 | yes |
| scene-3d | 10 | fusion-charm | 25213 | 23000–27300 | 11.82x | 516 | 51.60x | 1 | yes |
| scene-3d | 10 | react | 5300 | 4502–6700 | 2.48x | 223 | 22.30x | 0 | yes |
| scene-3d | 10 | react-reflex | 4200 | 3600–5002 | 1.97x | 224 | 22.40x | 0 | yes |
| scene-3d | 10 | react-upstream | 3953 | 3744–5463 | 1.85x | 215 | 21.50x | 0 | yes |
| scene-3d | 10 | roact | 4154 | 3950–4711 | 1.95x | 575 | 57.50x | 1 | yes |
| scene-3d | 10 | seam | 10100 | 8700–12009 | 4.73x | 1763 | 176.30x | 8 | yes |
| scene-3d | 10 | signals | 7401 | 7400–8551 | 3.47x | 683 | 68.30x | 0 | yes |
| scene-3d | 10 | vide | 5050 | 4750–6309 | 2.37x | 211 | 21.10x | 1 | yes |
| derived-diamond | 3 | plain | 39 | 31–43 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 224 | 218–321 | 5.78x | 28 | 7.00x | 1 | yes |
| derived-diamond | 3 | compose | 215 | 177–238 | 5.57x | 18 | 4.50x | 9 | yes |
| derived-diamond | 3 | fusion | 238 | 215–349 | 6.17x | 8 | 2.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 243 | 214–457 | 6.28x | 18 | 4.50x | 1 | yes |
| derived-diamond | 3 | react | 601 | 500–721 | 15.54x | 6 | 1.50x | 3 | yes |
| derived-diamond | 3 | react-reflex | 578 | 544–633 | 14.94x | 17 | 4.25x | 6 | yes |
| derived-diamond | 3 | react-upstream | 575 | 513–688 | 14.87x | 6 | 1.50x | 4 | yes |
| derived-diamond | 3 | roact | 230 | 220–310 | 5.95x | 11 | 2.75x | 3 | yes |
| derived-diamond | 3 | seam | 390 | 310–400 | 10.08x | 21 | 5.25x | 0 | yes |
| derived-diamond | 3 | signals | 188 | 171–241 | 4.87x | 9 | 2.25x | 0 | yes |
| derived-diamond | 3 | vide | 212 | 159–218 | 5.48x | 0 | 0.25x | 0 | yes |
| derived-chain-100 | 3 | plain | 49 | 43–56 | 1.00x | 65 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 354 | 338–439 | 7.29x | 127 | 1.95x | 0 | yes |
| derived-chain-100 | 3 | fusion | 850 | 625–1000 | 17.52x | 120 | 1.85x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 700 | 667–967 | 14.43x | 129 | 1.98x | 0 | yes |
| derived-chain-100 | 3 | react | 720 | 701–880 | 14.84x | 69 | 1.06x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 723 | 640–832 | 14.91x | 80 | 1.23x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 757 | 571–800 | 15.61x | 69 | 1.06x | 11 | yes |
| derived-chain-100 | 3 | roact | 311 | 256–333 | 6.41x | 11 | 0.17x | 0 | yes |
| derived-chain-100 | 3 | seam | 1167 | 887–1267 | 24.05x | 279 | 4.29x | 8 | yes |
| derived-chain-100 | 3 | signals | 566 | 451–650 | 11.66x | 174 | 2.68x | 0 | yes |
| derived-chain-100 | 3 | vide | 347 | 306–406 | 7.16x | 85 | 1.31x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 98 | 93–104 | 1.00x | 497 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 375 | 342–412 | 3.82x | 1534 | 3.09x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 500 | 475–625 | 5.10x | 695 | 1.40x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 1580 | 1200–1783 | 16.11x | 889 | 1.79x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2050 | 1906–2225 | 20.91x | 2814 | 5.66x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2250 | 1800–4150 | 22.95x | 671 | 1.35x | 52 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 12062 | 10472–13000 | 123.02x | 5626 | 11.32x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1800 | 1634–2350 | 18.36x | 663 | 1.33x | 52 | yes |
| derived-fan-in-1000 | 3 | roact | 688 | 625–875 | 7.01x | 105 | 0.21x | 4 | yes |
| derived-fan-in-1000 | 3 | seam | 2650 | 2050–4290 | 27.03x | 2939 | 5.91x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 1150 | 950–1937 | 11.73x | 1205 | 2.42x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 520 | 440–780 | 5.30x | 529 | 1.06x | 1 | yes |
| filter-as-you-type | 1 | plain | 7206 | 6600–7400 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 17227 | 15734–21905 | 2.39x | 2678 | 76.51x | 0 | yes |
| filter-as-you-type | 1 | compose | 10302 | 9436–11791 | 1.43x | 801 | 22.89x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28318 | 24730–30109 | 3.93x | 2448 | 69.94x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26883 | 23945–28517 | 3.73x | 2458 | 70.23x | 1 | yes |
| filter-as-you-type | 1 | react | 16000 | 15900–18292 | 2.22x | 75 | 2.14x | 11 | yes |
| filter-as-you-type | 1 | react-reflex | 16147 | 15300–18802 | 2.24x | 838 | 23.94x | 23 | yes |
| filter-as-you-type | 1 | react-upstream | 16565 | 16074–19100 | 2.30x | 68 | 1.94x | 12 | yes |
| filter-as-you-type | 1 | roact | 12946 | 11006–13773 | 1.80x | 511 | 14.60x | 11 | yes |
| filter-as-you-type | 1 | seam | 28129 | 20000–33501 | 3.90x | 4013 | 114.66x | 1 | yes |
| filter-as-you-type | 1 | signals | 8400 | 7500–9401 | 1.17x | 36 | 1.03x | 0 | yes |
| filter-as-you-type | 1 | vide | 12600 | 10219–14400 | 1.75x | 959 | 27.40x | 0 | yes |
| theme-propagation | 3 | plain | 132246 | 119408–199373 | 1.00x | 199 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 119353 | 112226–147800 | 0.90x | 2070 | 10.40x | 8 | yes |
| theme-propagation | 3 | compose | 137845 | 118546–174960 | 1.04x | 524 | 2.63x | 9 | yes |
| theme-propagation | 3 | fusion | 139051 | 124392–141822 | 1.05x | 867 | 4.36x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 116816 | 115435–119333 | 0.88x | 876 | 4.40x | 0 | yes |
| theme-propagation | 3 | react | 128317 | 120924–171777 | 0.97x | 2027 | 10.19x | 8 | yes |
| theme-propagation | 3 | react-reflex | 114494 | 110951–127633 | 0.87x | 2020 | 10.15x | 0 | yes |
| theme-propagation | 3 | react-upstream | 123949 | 120338–172163 | 0.94x | 2020 | 10.15x | 0 | yes |
| theme-propagation | 3 | roact | 121715 | 116517–126210 | 0.92x | 3270 | 16.43x | 1 | yes |
| theme-propagation | 3 | seam | 123494 | 115481–126679 | 0.93x | 3477 | 17.47x | 0 | yes |
| theme-propagation | 3 | signals | 147682 | 127281–154054 | 1.12x | 896 | 4.50x | 0 | yes |
| theme-propagation | 3 | vide | 120961 | 115736–136154 | 0.91x | 598 | 3.01x | 1 | yes |
| hud-per-frame | 1 | plain | 4000 | 3700–4500 | 1.00x | 30 | 1.00x | 1 | yes |
| hud-per-frame | 1 | blend | 8000 | 6100–8772 | 2.00x | 71 | 2.37x | 0 | yes |
| hud-per-frame | 1 | compose | 6400 | 5504–6800 | 1.60x | 29 | 0.97x | 3 | yes |
| hud-per-frame | 1 | fusion | 12000 | 11400–12510 | 3.00x | 53 | 1.77x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 16499 | 15941–17600 | 4.12x | 91 | 3.03x | 0 | yes |
| hud-per-frame | 1 | react | 6400 | 5321–7500 | 1.60x | 34 | 1.13x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 9854 | 8799–10973 | 2.46x | 45 | 1.50x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 6497 | 5900–7328 | 1.62x | 34 | 1.13x | 0 | yes |
| hud-per-frame | 1 | roact | 6515 | 5200–7000 | 1.63x | 98 | 3.27x | 8 | yes |
| hud-per-frame | 1 | seam | 13000 | 12017–14586 | 3.25x | 169 | 5.63x | 1 | yes |
| hud-per-frame | 1 | signals | 7503 | 6902–8100 | 1.88x | 73 | 2.43x | 0 | yes |
| hud-per-frame | 1 | vide | 6300 | 6200–7028 | 1.57x | 25 | 0.83x | 1 | yes |
| teardown-under-load | 1 | plain | 63264 | 61458–69258 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 82509 | 79246–90303 | 1.30x | 14 | 2.80x | 1 | yes |
| teardown-under-load | 1 | compose | 76013 | 70657–78138 | 1.20x | 7 | 1.40x | 17 | yes |
| teardown-under-load | 1 | fusion | 100973 | 95151–105746 | 1.60x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 100311 | 99091–112760 | 1.59x | 14 | 2.80x | 7 | yes |
| teardown-under-load | 1 | react | 100230 | 95056–100474 | 1.58x | 1077 | 215.40x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 98183 | 89895–105237 | 1.55x | 1079 | 215.80x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 96034 | 88690–102111 | 1.52x | 1069 | 213.80x | 0 | yes |
| teardown-under-load | 1 | roact | 97235 | 87492–107380 | 1.54x | 71 | 14.20x | 0 | yes |
| teardown-under-load | 1 | seam | 100517 | 88525–117900 | 1.59x | 7 | 1.40x | 13 | yes |
| teardown-under-load | 1 | signals | 80631 | 76324–83165 | 1.27x | 13 | 2.60x | 1 | yes |
| teardown-under-load | 1 | vide | 81139 | 73114–91523 | 1.28x | 5 | 1.00x | 1 | yes |
| open-close-retention | 1 | plain | 83100 | 78102–86502 | 1.00x | 24 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 126311 | 121500–134175 | 1.52x | 6 | 0.25x | 0 | yes |
| open-close-retention | 1 | compose | 92330 | 91357–106000 | 1.11x | 0 | 0.04x | 1 | yes |
| open-close-retention | 1 | fusion | 148517 | 144001–156312 | 1.79x | 5 | 0.21x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 154201 | 147103–156308 | 1.86x | 14 | 0.58x | 1 | yes |
| open-close-retention | 1 | react | 128500 | 124530–138352 | 1.55x | 283 | 11.79x | 0 | yes |
| open-close-retention | 1 | react-reflex | 140206 | 133104–142585 | 1.69x | 285 | 11.88x | 0 | yes |
| open-close-retention | 1 | react-upstream | 135900 | 131200–145303 | 1.64x | 284 | 11.83x | 0 | yes |
| open-close-retention | 1 | roact | 133202 | 130467–136015 | 1.60x | 23 | 0.96x | 0 | yes |
| open-close-retention | 1 | seam | 155701 | 146592–160003 | 1.87x | 9 | 0.38x | 0 | yes |
| open-close-retention | 1 | signals | 104732 | 97403–107415 | 1.26x | 20 | 0.83x | 8 | yes |
| open-close-retention | 1 | vide | 103607 | 101752–105201 | 1.25x | 12 | 0.50x | 0 | yes |
| tree-expand-collapse | 1 | plain | 9400 | 9203–9500 | 1.00x | 19 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 24602 | 21619–27204 | 2.62x | 789 | 41.53x | 1 | yes |
| tree-expand-collapse | 1 | compose | 15000 | 14200–16210 | 1.60x | 71 | 3.74x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 35111 | 32205–39468 | 3.74x | 158 | 8.32x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 32602 | 30876–35722 | 3.47x | 272 | 14.32x | 0 | yes |
| tree-expand-collapse | 1 | react | 20506 | 19500–21325 | 2.18x | 69 | 3.63x | 20 | yes |
| tree-expand-collapse | 1 | react-reflex | 19900 | 19700–20703 | 2.12x | 681 | 35.84x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 19900 | 19600–20100 | 2.12x | 61 | 3.21x | 20 | yes |
| tree-expand-collapse | 1 | roact | 14410 | 13900–16650 | 1.53x | 35 | 1.84x | 2 | yes |
| tree-expand-collapse | 1 | seam | 37219 | 34873–40602 | 3.96x | 148 | 7.79x | 0 | yes |
| tree-expand-collapse | 1 | signals | 11202 | 11106–12603 | 1.19x | 22 | 1.16x | 1 | yes |
| tree-expand-collapse | 1 | vide | 16410 | 15018–18404 | 1.75x | 78 | 4.11x | 8 | yes |
| form-validation | 1 | plain | 3360 | 3300–3700 | 1.00x | 54 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 12007 | 11300–13652 | 3.57x | 327 | 6.06x | 0 | yes |
| form-validation | 1 | compose | 12375 | 11700–15180 | 3.68x | 102 | 1.89x | 2 | yes |
| form-validation | 1 | fusion | 12600 | 11500–14605 | 3.75x | 118 | 2.19x | 1 | yes |
| form-validation | 1 | fusion-charm | 12609 | 11800–15511 | 3.75x | 155 | 2.87x | 0 | yes |
| form-validation | 1 | react | 12718 | 12405–14001 | 3.78x | 65 | 1.20x | 0 | yes |
| form-validation | 1 | react-reflex | 14301 | 12800–15205 | 4.26x | 75 | 1.39x | 2 | yes |
| form-validation | 1 | react-upstream | 13100 | 12500–14300 | 3.90x | 66 | 1.22x | 0 | yes |
| form-validation | 1 | roact | 11500 | 10900–13702 | 3.42x | 216 | 4.00x | 0 | yes |
| form-validation | 1 | seam | 16206 | 15202–16903 | 4.82x | 349 | 6.46x | 0 | yes |
| form-validation | 1 | signals | 11805 | 11310–12800 | 3.51x | 155 | 2.87x | 0 | yes |
| form-validation | 1 | vide | 12102 | 10801–13200 | 3.60x | 71 | 1.31x | 1 | yes |
| table-sort-filter | 1 | plain | 18400 | 17800–19718 | 1.00x | 74 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 39818 | 36901–43677 | 2.16x | 5364 | 72.49x | 1 | yes |
| table-sort-filter | 1 | compose | 26600 | 25000–30451 | 1.45x | 1552 | 20.97x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 66702 | 65639–74200 | 3.63x | 4688 | 63.35x | 2 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 65633 | 57204–75105 | 3.57x | 4681 | 63.26x | 0 | yes |
| table-sort-filter | 1 | react | 61903 | 60209–64700 | 3.36x | 2117 | 28.61x | 20 | yes |
| table-sort-filter | 1 | react-reflex | 69466 | 66074–72064 | 3.78x | 2123 | 28.69x | 23 | yes |
| table-sort-filter | 1 | react-upstream | 61700 | 59769–62900 | 3.35x | 2108 | 28.49x | 20 | yes |
| table-sort-filter | 1 | roact | 27200 | 26200–27700 | 1.48x | 1007 | 13.61x | 3 | yes |
| table-sort-filter | 1 | seam | 63931 | 61300–76771 | 3.47x | 7847 | 106.04x | 0 | yes |
| table-sort-filter | 1 | signals | 18600 | 18200–19101 | 1.01x | 76 | 1.03x | 0 | yes |
| table-sort-filter | 1 | vide | 30216 | 29400–32401 | 1.64x | 1915 | 25.88x | 0 | yes |
| library-load | 1 | plain | 87 | 78–95 | 1.00x | 2 | 1.00x | 0 | yes |
| library-load | 1 | blend | 942 | 918–1158 | 10.77x | 459 | 229.50x | 455 | yes |
| library-load | 1 | compose | 814 | 781–1068 | 9.31x | 66 | 33.00x | 62 | yes |
| library-load | 1 | fusion | 2556 | 2311–2811 | 29.21x | 263 | 131.50x | 262 | yes |
| library-load | 1 | fusion-charm | 2844 | 2423–3132 | 32.51x | 318 | 159.00x | 325 | yes |
| library-load | 1 | react | 6647 | 6014–6854 | 75.96x | 1817 | 908.50x | 1815 | yes |
| library-load | 1 | react-reflex | 6867 | 6764–7709 | 78.48x | 1972 | 986.00x | 1971 | yes |
| library-load | 1 | react-upstream | 6771 | 6510–7052 | 77.38x | 1994 | 997.00x | 2001 | yes |
| library-load | 1 | roact | 609 | 590–851 | 6.96x | 153 | 76.50x | 142 | yes |
| library-load | 1 | seam | 2670 | 2198–3022 | 30.52x | 243 | 121.50x | 232 | yes |
| library-load | 1 | signals | 355 | 292–379 | 4.06x | 42 | 21.00x | 40 | yes |
| library-load | 1 | vide | 548 | 492–684 | 6.26x | 139 | 69.50x | 137 | yes |
| rows-append-1000 | 1 | plain | 200189 | 179809–213828 | 1.00x | 6524 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 295838 | 272233–310444 | 1.48x | 38793 | 5.95x | 0 | yes |
| rows-append-1000 | 1 | compose | 216911 | 202231–324635 | 1.08x | 9771 | 1.50x | 4 | yes |
| rows-append-1000 | 1 | fusion | 397051 | 373994–469811 | 1.98x | 20246 | 3.10x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 401384 | 366211–444593 | 2.01x | 29217 | 4.48x | 0 | yes |
| rows-append-1000 | 1 | react | 267573 | 251090–329667 | 1.34x | 23298 | 3.57x | 105 | yes |
| rows-append-1000 | 1 | react-reflex | 308090 | 268328–332179 | 1.54x | 24927 | 3.82x | 138 | yes |
| rows-append-1000 | 1 | react-upstream | 282634 | 270714–366891 | 1.41x | 22897 | 3.51x | 4 | yes |
| rows-append-1000 | 1 | roact | 284407 | 250966–360766 | 1.42x | 33135 | 5.08x | 8 | yes |
| rows-append-1000 | 1 | seam | 305453 | 242087–313197 | 1.53x | 46367 | 7.11x | 0 | yes |
| rows-append-1000 | 1 | signals | 225672 | 186770–238068 | 1.13x | 17408 | 2.67x | 232 | yes |
| rows-append-1000 | 1 | vide | 209189 | 200128–277660 | 1.04x | 10423 | 1.60x | 1 | yes |
| rows-clear | 1 | plain | 24800 | 24400–32107 | 1.00x | 1221 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 50967 | 49301–53839 | 2.06x | 4129 | 3.38x | 1 | yes |
| rows-clear | 1 | compose | 32000 | 31202–37161 | 1.29x | 1812 | 1.48x | 10 | yes |
| rows-clear | 1 | fusion | 67102 | 65818–72755 | 2.71x | 3480 | 2.85x | 0 | yes |
| rows-clear | 1 | fusion-charm | 65484 | 64302–76696 | 2.64x | 7401 | 6.06x | 0 | yes |
| rows-clear | 1 | react | 35518 | 34803–37265 | 1.43x | 4480 | 3.67x | 0 | yes |
| rows-clear | 1 | react-reflex | 39735 | 37094–57614 | 1.60x | 6489 | 5.31x | 35 | yes |
| rows-clear | 1 | react-upstream | 40730 | 36819–46225 | 1.64x | 4471 | 3.66x | 0 | yes |
| rows-clear | 1 | roact | 40363 | 38555–45017 | 1.63x | 4198 | 3.44x | 8 | yes |
| rows-clear | 1 | seam | 49923 | 39306–55050 | 2.01x | 9270 | 7.59x | 0 | yes |
| rows-clear | 1 | signals | 32223 | 30355–42387 | 1.30x | 4442 | 3.64x | 0 | yes |
| rows-clear | 1 | vide | 30700 | 28600–31600 | 1.24x | 1596 | 1.31x | 0 | yes |
| rows-create-1000 | 1 | plain | 190947 | 178850–222388 | 1.00x | 3127 | 1.00x | 1 | yes |
| rows-create-1000 | 1 | blend | 279921 | 254439–297537 | 1.47x | 19585 | 6.26x | 0 | yes |
| rows-create-1000 | 1 | compose | 207227 | 194924–256724 | 1.09x | 5196 | 1.66x | 3 | yes |
| rows-create-1000 | 1 | fusion | 263638 | 257412–300889 | 1.38x | 10946 | 3.50x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 295397 | 251231–299248 | 1.55x | 14772 | 4.72x | 0 | yes |
| rows-create-1000 | 1 | react | 260953 | 220623–290515 | 1.37x | 8184 | 2.62x | 40 | yes |
| rows-create-1000 | 1 | react-reflex | 260236 | 234068–291392 | 1.36x | 9074 | 2.90x | 36 | yes |
| rows-create-1000 | 1 | react-upstream | 253812 | 225810–373743 | 1.33x | 8136 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 235666 | 207338–266552 | 1.23x | 16921 | 5.41x | 0 | yes |
| rows-create-1000 | 1 | seam | 274072 | 268520–313162 | 1.44x | 23885 | 7.64x | 8 | yes |
| rows-create-1000 | 1 | signals | 207150 | 184997–271447 | 1.08x | 9097 | 2.91x | 1 | yes |
| rows-create-1000 | 1 | vide | 208056 | 197919–247083 | 1.09x | 4956 | 1.58x | 0 | yes |
| rows-create-10000 | 1 | plain | 1792752 | 1753383–1797119 | 1.00x | 29792 | 1.00x | 16 | yes |
| rows-create-10000 | 1 | blend | 2530039 | 2390466–2672141 | 1.41x | 186546 | 6.26x | 0 | yes |
| rows-create-10000 | 1 | compose | 2148251 | 2142384–2182637 | 1.20x | 49850 | 1.67x | 2 | yes |
| rows-create-10000 | 1 | fusion | 5751367 | 5219131–5834181 | 3.21x | 101612 | 3.41x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6176870 | 5900147–6218190 | 3.45x | 145704 | 4.89x | 12 | yes |
| rows-create-10000 | 1 | react | 4046327 | 3880862–4254311 | 2.26x | 78071 | 2.62x | 817 | yes |
| rows-create-10000 | 1 | react-reflex | 4179259 | 4164127–4181200 | 2.33x | 85536 | 2.87x | 594 | yes |
| rows-create-10000 | 1 | react-upstream | 4025471 | 3869564–4301386 | 2.25x | 78430 | 2.63x | 216 | yes |
| rows-create-10000 | 1 | roact | 2323179 | 2158951–2354798 | 1.30x | 165682 | 5.56x | 0 | yes |
| rows-create-10000 | 1 | seam | 2679239 | 2490273–2731086 | 1.49x | 236988 | 7.95x | 12 | yes |
| rows-create-10000 | 1 | signals | 2018314 | 2012349–2039716 | 1.13x | 89213 | 2.99x | 4 | yes |
| rows-create-10000 | 1 | vide | 1903219 | 1859068–2115359 | 1.06x | 48452 | 1.63x | 4 | yes |
| rows-remove-one | 1 | plain | 1000 | 900–1600 | 1.00x | 2740 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1800 | 1500–2011 | 1.80x | 18276 | 6.67x | 0 | yes |
| rows-remove-one | 1 | compose | 1300 | 800–1800 | 1.30x | 4318 | 1.58x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 41334 | 39411–55419 | 41.33x | 11113 | 4.06x | 2 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 39614 | 36436–40855 | 39.61x | 15034 | 5.49x | 1 | yes |
| rows-remove-one | 1 | react | 31201 | 23856–104097 | 31.20x | 15484 | 5.65x | 8 | yes |
| rows-remove-one | 1 | react-reflex | 40948 | 32807–42795 | 40.95x | 16398 | 5.98x | 20 | yes |
| rows-remove-one | 1 | react-upstream | 33700 | 28102–64004 | 33.70x | 15461 | 5.64x | 0 | yes |
| rows-remove-one | 1 | roact | 24400 | 18917–38810 | 24.40x | 16774 | 6.12x | 9 | yes |
| rows-remove-one | 1 | seam | 10903 | 10120–12500 | 10.90x | 23442 | 8.56x | 228 | yes |
| rows-remove-one | 1 | signals | 2203 | 2100–2600 | 2.20x | 8621 | 3.15x | 8 | yes |
| rows-remove-one | 1 | vide | 1600 | 1600–2100 | 1.60x | 4553 | 1.66x | 0 | yes |
| rows-swap | 1 | plain | 200 | 100–300 | 1.00x | 2686 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 900 | 700–1700 | 4.50x | 18382 | 6.84x | 1 | yes |
| rows-swap | 1 | compose | 400 | 100–400 | 2.00x | 4297 | 1.60x | 11 | yes |
| rows-swap | 1 | fusion | 32700 | 32400–33604 | 163.50x | 9671 | 3.60x | 1 | yes |
| rows-swap | 1 | fusion-charm | 32703 | 30801–42006 | 163.51x | 14611 | 5.44x | 4 | yes |
| rows-swap | 1 | react | 39604 | 38503–52805 | 198.02x | 15473 | 5.76x | 8 | yes |
| rows-swap | 1 | react-reflex | 47400 | 36700–50302 | 237.00x | 16387 | 6.10x | 37 | yes |
| rows-swap | 1 | react-upstream | 38700 | 32700–41000 | 193.50x | 14985 | 5.58x | 0 | yes |
| rows-swap | 1 | roact | 19000 | 14726–21878 | 95.00x | 16304 | 6.07x | 0 | yes |
| rows-swap | 1 | seam | 10800 | 9804–11200 | 54.00x | 23348 | 8.69x | 1 | yes |
| rows-swap | 1 | signals | 1100 | 700–1700 | 5.50x | 8626 | 3.21x | 1 | yes |
| rows-swap | 1 | vide | 200 | 100–500 | 1.00x | 4516 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 4000 | 3750–4450 | 1.00x | 3183 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 4300 | 3900–4400 | 1.07x | 19264 | 6.05x | 0 | yes |
| rows-update-every-10th | 1 | compose | 3978 | 3800–4300 | 0.99x | 4843 | 1.52x | 12 | yes |
| rows-update-every-10th | 1 | fusion | 4100 | 4000–6082 | 1.02x | 10559 | 3.32x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 5030 | 4600–5300 | 1.26x | 14463 | 4.54x | 8 | yes |
| rows-update-every-10th | 1 | react | 4300 | 3800–5400 | 1.07x | 7861 | 2.47x | 23 | yes |
| rows-update-every-10th | 1 | react-reflex | 8500 | 5700–15271 | 2.12x | 8877 | 2.79x | 69 | yes |
| rows-update-every-10th | 1 | react-upstream | 4000 | 3900–6200 | 1.00x | 7910 | 2.49x | 0 | yes |
| rows-update-every-10th | 1 | roact | 4200 | 4000–4600 | 1.05x | 16674 | 5.24x | 1 | yes |
| rows-update-every-10th | 1 | seam | 10700 | 10409–13800 | 2.67x | 24204 | 7.60x | 1 | yes |
| rows-update-every-10th | 1 | signals | 4100 | 4000–5200 | 1.02x | 9346 | 2.94x | 0 | yes |
| rows-update-every-10th | 1 | vide | 4200 | 3706–5200 | 1.05x | 5116 | 1.61x | 0 | yes |

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
| blend | 29 | 2.75x | 10.51x | 2.67x | 10.21x |
| compose | 30 | 2.19x | 3.11x | 2.08x | 3.04x |
| fusion | 30 | 6.43x | 5.35x | 5.91x | 5.35x |
| fusion-charm | 30 | 6.06x | 7.95x | 5.59x | 8.16x |
| react | 29 | 4.90x | 5.90x | 4.71x | 6.27x |
| react-reflex | 29 | 5.57x | 9.14x | 5.37x | 9.82x |
| react-upstream | 29 | 4.75x | 5.71x | 4.55x | 6.06x |
| roact | 29 | 3.30x | 5.41x | 3.22x | 6.12x |
| seam | 30 | 4.92x | 11.29x | 4.51x | 11.18x |
| signals | 29 | 2.27x | 2.63x | 2.14x | 2.63x |
| vide | 30 | 2.26x | 2.60x | 2.11x | 2.60x |
