# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, in KiB. Teardown is the median retained heap after release. Both use the Verify `gc-witness-low-water/2` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Harness revision | `8eba504` |
| Date | 2026-10-31 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 311 | 300–400 | 1.00x | 25 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 903 | 700–1110 | 2.90x | 741 | 29.64x | 0 | yes |
| update-leaf | 20 | compose | 984 | 600–1019 | 3.16x | 93 | 3.72x | 1 | yes |
| update-leaf | 20 | fusion | 1010 | 938–1270 | 3.25x | 108 | 4.32x | 0 | yes |
| update-leaf | 20 | fusion-charm | 1100 | 708–1203 | 3.54x | 109 | 4.36x | 0 | yes |
| update-leaf | 20 | react | 1100 | 700–1248 | 3.54x | 299 | 11.96x | 0 | yes |
| update-leaf | 20 | react-reflex | 1230 | 600–1315 | 3.95x | 300 | 12.00x | 0 | yes |
| update-leaf | 20 | react-upstream | 709 | 526–960 | 2.28x | 292 | 11.68x | 0 | yes |
| update-leaf | 20 | roact | 709 | 606–1030 | 2.28x | 960 | 38.40x | 0 | yes |
| update-leaf | 20 | seam | 1100 | 921–1586 | 3.54x | 41 | 1.64x | 0 | yes |
| update-leaf | 20 | signals | 800 | 602–904 | 2.57x | 58 | 2.32x | 0 | yes |
| update-leaf | 20 | vide | 1124 | 1000–1442 | 3.61x | 11 | 0.44x | 0 | yes |
| update-batched | 20 | plain | 4300 | 4100–4814 | 1.00x | 29 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 10780 | 10367–11721 | 2.51x | 909 | 31.34x | 0 | yes |
| update-batched | 20 | compose | 7412 | 6857–7737 | 1.72x | 351 | 12.10x | 9 | yes |
| update-batched | 20 | fusion | 21413 | 20732–22544 | 4.98x | 517 | 17.83x | 0 | yes |
| update-batched | 20 | fusion-charm | 38741 | 38309–41600 | 9.01x | 1110 | 38.28x | 0 | yes |
| update-batched | 20 | react | 8050 | 7981–8502 | 1.87x | 477 | 16.45x | 0 | yes |
| update-batched | 20 | react-reflex | 59202 | 55893–61491 | 13.77x | 775 | 26.72x | 16 | yes |
| update-batched | 20 | react-upstream | 8688 | 8098–9343 | 2.02x | 469 | 16.17x | 0 | yes |
| update-batched | 20 | roact | 8485 | 8405–10898 | 1.97x | 1178 | 40.62x | 1 | yes |
| update-batched | 20 | seam | 13407 | 11696–14094 | 3.12x | 1840 | 63.45x | 0 | yes |
| update-batched | 20 | signals | 10194 | 9363–10649 | 2.37x | 605 | 20.86x | 0 | yes |
| update-batched | 20 | vide | 9181 | 8624–9969 | 2.14x | 332 | 11.45x | 0 | yes |
| update-repeated | 10 | plain | 0 | 0–0 | plain below resolution | 1 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3300 | 3100–4009 | plain below resolution | 7 | 7.00x | 0 | yes |
| update-repeated | 10 | compose | 400 | 201–406 | plain below resolution | 6 | 6.00x | 1 | yes |
| update-repeated | 10 | fusion | 27319 | 26836–27446 | plain below resolution | 12 | 12.00x | 8 | yes |
| update-repeated | 10 | fusion-charm | 1102 | 900–1404 | plain below resolution | 0 | 0.00x | 0 | yes |
| update-repeated | 10 | react | 7051 | 6700–7714 | plain below resolution | 1 | 1.00x | 0 | yes |
| update-repeated | 10 | react-reflex | 809 | 600–1159 | plain below resolution | 3 | 3.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7233 | 6317–8227 | plain below resolution | 0 | 0.00x | 0 | yes |
| update-repeated | 10 | roact | 5404 | 5023–6415 | plain below resolution | 7 | 7.00x | 0 | yes |
| update-repeated | 10 | seam | 1413 | 1367–1700 | plain below resolution | 11 | 11.00x | 0 | yes |
| update-repeated | 10 | signals | 804 | 705–1033 | plain below resolution | 4 | 4.00x | 0 | yes |
| update-repeated | 10 | vide | 510 | 400–708 | plain below resolution | 2 | 2.00x | 0 | yes |
| branch-swap | 20 | plain | 12007 | 11333–12420 | 1.00x | 10 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 16840 | 15656–17776 | 1.40x | 43 | 4.30x | 8 | yes |
| branch-swap | 20 | compose | 13604 | 12966–17092 | 1.13x | 8 | 0.80x | 1 | yes |
| branch-swap | 20 | fusion | 14377 | 14216–16391 | 1.20x | 5 | 0.50x | 1 | yes |
| branch-swap | 20 | fusion-charm | 13875 | 13650–16313 | 1.16x | 7 | 0.70x | 1 | yes |
| branch-swap | 20 | react | 16615 | 15852–20394 | 1.38x | 18 | 1.80x | 8 | yes |
| branch-swap | 20 | react-reflex | 16028 | 15512–18790 | 1.33x | 11 | 1.10x | 8 | yes |
| branch-swap | 20 | react-upstream | 17591 | 15981–19751 | 1.47x | 11 | 1.10x | 0 | yes |
| branch-swap | 20 | roact | 15320 | 14088–15617 | 1.28x | 4 | 0.40x | 0 | yes |
| branch-swap | 20 | seam | 11913 | 11535–12204 | 0.99x | 11 | 1.10x | 0 | yes |
| branch-swap | 20 | signals | 12334 | 11110–13647 | 1.03x | 5 | 0.50x | 0 | yes |
| branch-swap | 20 | vide | 13646 | 13569–17295 | 1.14x | 5 | 0.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2300 | 2100–2523 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4902 | 4403–5117 | 2.13x | 1514 | 23.66x | 1 | yes |
| keyed-prepend | 10 | compose | 4200 | 3911–4721 | 1.83x | 539 | 8.42x | 9 | yes |
| keyed-prepend | 10 | fusion (workaround) | 22877 | 22152–24406 | 9.95x | 1543 | 24.11x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 22355 | 20551–23317 | 9.72x | 1553 | 24.27x | 1 | yes |
| keyed-prepend | 10 | react | 16534 | 15580–17087 | 7.19x | 793 | 12.39x | 8 | yes |
| keyed-prepend | 10 | react-reflex | 16134 | 15305–16366 | 7.01x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16702 | 15699–17032 | 7.26x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | roact | 6841 | 6614–7511 | 2.97x | 369 | 5.77x | 8 | yes |
| keyed-prepend | 10 | seam | 11246 | 10423–12146 | 4.89x | 2471 | 38.61x | 8 | yes |
| keyed-prepend | 10 | signals | 3022 | 2704–3206 | 1.31x | 61 | 0.95x | 0 | yes |
| keyed-prepend | 10 | vide | 5133 | 5096–5314 | 2.23x | 654 | 10.22x | 0 | yes |
| keyed-insert | 10 | plain | 1609 | 1500–1700 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4015 | 3800–4331 | 2.50x | 1514 | 23.66x | 1 | yes |
| keyed-insert | 10 | compose | 2614 | 2513–2863 | 1.62x | 527 | 8.23x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 18731 | 17226–19926 | 11.64x | 1543 | 24.11x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 18410 | 17220–18470 | 11.44x | 1545 | 24.14x | 1 | yes |
| keyed-insert | 10 | react | 13381 | 12535–14132 | 8.32x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13581 | 13148–14106 | 8.44x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 14020 | 13414–14758 | 8.71x | 819 | 12.80x | 0 | yes |
| keyed-insert | 10 | roact | 5725 | 5520–5966 | 3.56x | 369 | 5.77x | 0 | yes |
| keyed-insert | 10 | seam | 10082 | 9900–11037 | 6.27x | 2479 | 38.73x | 0 | yes |
| keyed-insert | 10 | signals | 1907 | 1800–2305 | 1.19x | 61 | 0.95x | 0 | yes |
| keyed-insert | 10 | vide | 3883 | 3609–4157 | 2.41x | 654 | 10.22x | 0 | yes |
| keyed-shuffle | 10 | plain | 1700 | 1500–1805 | 1.00x | 68 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2900 | 2500–3512 | 1.71x | 1456 | 21.41x | 0 | yes |
| keyed-shuffle | 10 | compose | 3005 | 2410–3014 | 1.77x | 538 | 7.91x | 9 | yes |
| keyed-shuffle | 10 | fusion | 19700 | 18663–21626 | 11.59x | 1406 | 20.68x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 18447 | 17313–19639 | 10.85x | 1408 | 20.71x | 0 | yes |
| keyed-shuffle | 10 | react | 27053 | 25588–27612 | 15.91x | 787 | 11.57x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27564 | 27115–29255 | 16.21x | 787 | 11.57x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27462 | 25463–27948 | 16.15x | 779 | 11.46x | 8 | yes |
| keyed-shuffle | 10 | roact | 5606 | 5356–6405 | 3.30x | 368 | 5.41x | 0 | yes |
| keyed-shuffle | 10 | seam | 9157 | 9002–9868 | 5.39x | 2463 | 36.22x | 0 | yes |
| keyed-shuffle | 10 | signals | 2044 | 2003–2209 | 1.20x | 60 | 0.88x | 1 | yes |
| keyed-shuffle | 10 | vide | 3800 | 3612–4305 | 2.24x | 638 | 9.38x | 0 | yes |
| events | 1 | plain | 1000 | 900–1701 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | blend | 1200 | 1005–1905 | 1.20x | 0 | 0.00x | 0 | yes |
| events | 1 | compose | 1317 | 1061–1433 | 1.32x | 2 | 2.00x | 1 | yes |
| events | 1 | fusion | 1104 | 1003–1609 | 1.10x | 1 | 1.00x | 0 | yes |
| events | 1 | fusion-charm | 1310 | 900–1942 | 1.31x | 1 | 1.00x | 8 | yes |
| events | 1 | react | 1349 | 1104–2057 | 1.35x | 1 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 1601 | 1204–2047 | 1.60x | 1 | 1.00x | 0 | yes |
| events | 1 | react-upstream | 1300 | 904–1417 | 1.30x | 1 | 1.00x | 0 | yes |
| events | 1 | roact | 904 | 618–1600 | 0.90x | 1 | 1.00x | 0 | yes |
| events | 1 | seam | 1000 | 808–1113 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | signals | 1038 | 700–1256 | 1.04x | 1 | 1.00x | 0 | yes |
| events | 1 | vide | 1208 | 1200–2100 | 1.21x | 8 | 8.00x | 1 | yes |
| animate-many | 1 | plain | 2659 | 2245–3181 | 1.00x | 49 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 11418 | 10811–12621 | 4.29x | 1787 | 36.47x | 0 | yes |
| animate-many | 1 | compose | 7276 | 7015–7735 | 2.74x | 873 | 17.82x | 10 | yes |
| animate-many | 1 | fusion | 107697 | 106113–107996 | 40.50x | 1144 | 23.35x | 8 | yes |
| animate-many | 1 | fusion-charm | 105722 | 103531–107913 | 39.76x | 1139 | 23.24x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 21500 | 21023–22210 | 8.09x | 2914 | 59.47x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8136 | 7445–9220 | 3.06x | 392 | 8.00x | 0 | yes |
| status-panel | 10 | plain | 503 | 500–600 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1109 | 1009–1339 | 2.20x | 62 | 31.00x | 0 | yes |
| status-panel | 10 | compose | 1122 | 836–1300 | 2.23x | 33 | 16.50x | 2 | yes |
| status-panel | 10 | fusion | 1516 | 1507–1804 | 3.01x | 63 | 31.50x | 1 | yes |
| status-panel | 10 | fusion-charm | 1801 | 1424–1925 | 3.58x | 78 | 39.00x | 0 | yes |
| status-panel | 10 | react | 1934 | 1906–2312 | 3.84x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | react-reflex | 2017 | 2000–2145 | 4.01x | 45 | 22.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2100 | 1704–2313 | 4.17x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | roact | 1115 | 903–1306 | 2.22x | 25 | 12.50x | 0 | yes |
| status-panel | 10 | seam | 1637 | 1459–1917 | 3.25x | 140 | 70.00x | 0 | yes |
| status-panel | 10 | signals | 909 | 715–1102 | 1.81x | 15 | 7.50x | 0 | yes |
| status-panel | 10 | vide | 1111 | 807–1128 | 2.21x | 25 | 12.50x | 1 | yes |
| scene-3d | 10 | plain | 2410 | 2201–2708 | 1.00x | 3 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4518 | 4208–4935 | 1.87x | 566 | 188.67x | 0 | yes |
| scene-3d | 10 | compose | 3112 | 2906–3576 | 1.29x | 189 | 63.00x | 0 | yes |
| scene-3d | 10 | fusion | 29938 | 29302–30718 | 12.42x | 536 | 178.67x | 0 | yes |
| scene-3d | 10 | fusion-charm | 28820 | 26812–29632 | 11.96x | 531 | 177.00x | 0 | yes |
| scene-3d | 10 | react | 3417 | 3309–4206 | 1.42x | 231 | 77.00x | 0 | yes |
| scene-3d | 10 | react-reflex | 3216 | 2901–3366 | 1.33x | 225 | 75.00x | 0 | yes |
| scene-3d | 10 | react-upstream | 3310 | 3110–3929 | 1.37x | 230 | 76.67x | 0 | yes |
| scene-3d | 10 | roact | 3311 | 3100–3504 | 1.37x | 590 | 196.67x | 0 | yes |
| scene-3d | 10 | seam | 8707 | 8012–8889 | 3.61x | 1787 | 595.67x | 0 | yes |
| scene-3d | 10 | signals | 5610 | 5400–6271 | 2.33x | 682 | 227.33x | 0 | yes |
| scene-3d | 10 | vide | 3915 | 3703–4544 | 1.62x | 219 | 73.00x | 0 | yes |
| derived-diamond | 3 | plain | 0 | 0–0 | plain below resolution | 13 | 1.00x | 8 | yes |
| derived-diamond | 3 | blend | 200 | 0–200 | plain below resolution | 28 | 2.15x | 0 | yes |
| derived-diamond | 3 | compose | 0 | 0–0 | plain below resolution | 11 | 0.85x | 1 | yes |
| derived-diamond | 3 | fusion | 0 | 0–109 | plain below resolution | 16 | 1.23x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 100 | 100–204 | plain below resolution | 10 | 0.77x | 0 | yes |
| derived-diamond | 3 | react | 300 | 100–400 | plain below resolution | 0 | 0.00x | 0 | yes |
| derived-diamond | 3 | react-reflex | 300 | 200–300 | plain below resolution | 13 | 1.00x | 13 | yes |
| derived-diamond | 3 | react-upstream | 300 | 200–303 | plain below resolution | 2 | 0.15x | 1 | yes |
| derived-diamond | 3 | roact | 0 | 0–100 | plain below resolution | 11 | 0.85x | 3 | yes |
| derived-diamond | 3 | seam | 200 | 100–320 | plain below resolution | 21 | 1.62x | 0 | yes |
| derived-diamond | 3 | signals | 0 | 0–200 | plain below resolution | 9 | 0.69x | 0 | yes |
| derived-diamond | 3 | vide | 0 | 0–100 | plain below resolution | 0 | 0.00x | 0 | yes |
| derived-chain-100 | 3 | plain | 0 | 0–0 | plain below resolution | 69 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 103 | 0–300 | plain below resolution | 153 | 2.22x | 1 | yes |
| derived-chain-100 | 3 | fusion | 900 | 800–1500 | plain below resolution | 135 | 1.96x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 900 | 700–1025 | plain below resolution | 129 | 1.87x | 0 | yes |
| derived-chain-100 | 3 | react | 400 | 204–400 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-chain-100 | 3 | react-reflex | 400 | 200–602 | plain below resolution | 13 | 0.19x | 5 | yes |
| derived-chain-100 | 3 | react-upstream | 300 | 0–600 | plain below resolution | 2 | 0.03x | 2 | yes |
| derived-chain-100 | 3 | roact | 108 | 100–200 | plain below resolution | 11 | 0.16x | 3 | yes |
| derived-chain-100 | 3 | seam | 600 | 500–822 | plain below resolution | 280 | 4.06x | 1 | yes |
| derived-chain-100 | 3 | signals | 200 | 100–313 | plain below resolution | 174 | 2.52x | 0 | yes |
| derived-chain-100 | 3 | vide | 100 | 0–200 | plain below resolution | 101 | 1.46x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 0 | 0–0 | plain below resolution | 598 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 200 | 100–300 | plain below resolution | 1535 | 2.57x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 200 | 200–317 | plain below resolution | 704 | 1.18x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 2000 | 1900–2801 | plain below resolution | 898 | 1.50x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2300 | 2100–2526 | plain below resolution | 2830 | 4.73x | 1 | yes |
| derived-fan-in-1000 | 3 | react | 2110 | 1601–4501 | plain below resolution | 323 | 0.54x | 2 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 6904 | 6507–9221 | plain below resolution | 5257 | 8.79x | 35 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2400 | 1900–4046 | plain below resolution | 323 | 0.54x | 2 | yes |
| derived-fan-in-1000 | 3 | roact | 407 | 300–700 | plain below resolution | 112 | 0.19x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2823 | 2301–3202 | plain below resolution | 2955 | 4.94x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 700 | 600–1000 | plain below resolution | 1229 | 2.06x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 400 | 400–700 | plain below resolution | 528 | 0.88x | 0 | yes |
| filter-as-you-type | 1 | plain | 9721 | 8518–10812 | 1.00x | 155 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16927 | 16422–17849 | 1.74x | 2980 | 19.23x | 0 | yes |
| filter-as-you-type | 1 | compose | 10920 | 10588–11758 | 1.12x | 945 | 6.10x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28213 | 26269–29641 | 2.90x | 2609 | 16.83x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26716 | 25014–29653 | 2.75x | 2619 | 16.90x | 1 | yes |
| filter-as-you-type | 1 | react | 22475 | 22159–23424 | 2.31x | 11 | 0.07x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 21825 | 21701–23202 | 2.25x | 773 | 4.99x | 5 | yes |
| filter-as-you-type | 1 | react-upstream | 22365 | 21592–23320 | 2.30x | 10 | 0.06x | 2 | yes |
| filter-as-you-type | 1 | roact | 12114 | 11542–12355 | 1.25x | 511 | 3.30x | 11 | yes |
| filter-as-you-type | 1 | seam | 23461 | 18771–25727 | 2.41x | 4005 | 25.84x | 0 | yes |
| filter-as-you-type | 1 | signals | 8243 | 8018–8594 | 0.85x | 28 | 0.18x | 0 | yes |
| filter-as-you-type | 1 | vide | 11126 | 10520–11324 | 1.14x | 960 | 6.19x | 0 | yes |
| theme-propagation | 3 | plain | 47862 | 46505–48986 | 1.00x | 207 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 47361 | 47023–48361 | 0.99x | 1997 | 9.65x | 8 | yes |
| theme-propagation | 3 | compose | 49466 | 49122–50662 | 1.03x | 538 | 2.60x | 1 | yes |
| theme-propagation | 3 | fusion | 51700 | 50212–56083 | 1.08x | 818 | 3.95x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 52200 | 49016–54485 | 1.09x | 820 | 3.96x | 0 | yes |
| theme-propagation | 3 | react | 82079 | 80686–86636 | 1.71x | 11 | 0.05x | 10 | yes |
| theme-propagation | 3 | react-reflex | 82697 | 79187–88938 | 1.73x | 4977 | 24.04x | 5 | yes |
| theme-propagation | 3 | react-upstream | 82174 | 80134–86553 | 1.72x | 2 | 0.01x | 2 | yes |
| theme-propagation | 3 | roact | 68154 | 67642–69059 | 1.42x | 2819 | 13.62x | 11 | yes |
| theme-propagation | 3 | seam | 45763 | 44586–46954 | 0.96x | 3421 | 16.53x | 0 | yes |
| theme-propagation | 3 | signals | 50035 | 49472–51270 | 1.05x | 880 | 4.25x | 0 | yes |
| theme-propagation | 3 | vide | 50209 | 48645–52471 | 1.05x | 597 | 2.88x | 1 | yes |
| hud-per-frame | 1 | plain | 2214 | 1718–2650 | 1.00x | 32 | 1.00x | 8 | yes |
| hud-per-frame | 1 | blend | 4649 | 3840–5107 | 2.10x | 71 | 2.22x | 0 | yes |
| hud-per-frame | 1 | compose | 2840 | 2240–2951 | 1.28x | 30 | 0.94x | 2 | yes |
| hud-per-frame | 1 | fusion | 9913 | 9080–10242 | 4.48x | 48 | 1.50x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 12633 | 12374–13155 | 5.71x | 91 | 2.84x | 0 | yes |
| hud-per-frame | 1 | react | 3322 | 2652–4212 | 1.50x | 26 | 0.81x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 5716 | 4701–5908 | 2.58x | 46 | 1.44x | 9 | yes |
| hud-per-frame | 1 | react-upstream | 2971 | 2211–3049 | 1.34x | 34 | 1.06x | 8 | yes |
| hud-per-frame | 1 | roact | 2773 | 2139–3112 | 1.25x | 91 | 2.84x | 0 | yes |
| hud-per-frame | 1 | seam | 6188 | 5221–7082 | 2.79x | 169 | 5.28x | 0 | yes |
| hud-per-frame | 1 | signals | 3880 | 3590–4558 | 1.75x | 65 | 2.03x | 1 | yes |
| hud-per-frame | 1 | vide | 3239 | 3035–3733 | 1.46x | 17 | 0.53x | 0 | yes |
| teardown-under-load | 1 | plain | 76356 | 72648–77335 | 1.00x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 71315 | 67670–71833 | 0.93x | 6 | 1.20x | 0 | yes |
| teardown-under-load | 1 | compose | 79008 | 73671–86336 | 1.03x | 7 | 1.40x | 1 | yes |
| teardown-under-load | 1 | fusion | 74671 | 72943–81893 | 0.98x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 74291 | 71071–75284 | 0.97x | 7 | 1.40x | 0 | yes |
| teardown-under-load | 1 | react | 90317 | 87541–96021 | 1.18x | 951 | 190.20x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 92076 | 90539–103254 | 1.21x | 960 | 192.00x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 96353 | 88776–97726 | 1.26x | 951 | 190.20x | 0 | yes |
| teardown-under-load | 1 | roact | 85034 | 82661–96656 | 1.11x | 71 | 14.20x | 1 | yes |
| teardown-under-load | 1 | seam | 90192 | 77510–94973 | 1.18x | 16 | 3.20x | 6 | yes |
| teardown-under-load | 1 | signals | 82363 | 81401–84017 | 1.08x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | vide | 56466 | 52405–59860 | 0.74x | 13 | 2.60x | 8 | yes |
| open-close-retention | 1 | plain | 137712 | 134587–146466 | 1.00x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 121322 | 119070–127099 | 0.88x | 0 | 0.00x | 0 | yes |
| open-close-retention | 1 | compose | 148787 | 148123–160004 | 1.08x | 7 | 1.40x | 1 | yes |
| open-close-retention | 1 | fusion | 135490 | 131602–140793 | 0.98x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 138457 | 136817–149470 | 1.01x | 7 | 1.40x | 0 | yes |
| open-close-retention | 1 | react | 171577 | 169340–183990 | 1.25x | 251 | 50.20x | 0 | yes |
| open-close-retention | 1 | react-reflex | 170621 | 168970–177388 | 1.24x | 251 | 50.20x | 0 | yes |
| open-close-retention | 1 | react-upstream | 171860 | 170878–185531 | 1.25x | 249 | 49.80x | 0 | yes |
| open-close-retention | 1 | roact | 165559 | 164575–176677 | 1.20x | 22 | 4.40x | 0 | yes |
| open-close-retention | 1 | seam | 171528 | 168720–193970 | 1.25x | 9 | 1.80x | 1 | yes |
| open-close-retention | 1 | signals | 153705 | 149065–165115 | 1.12x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | vide | 90887 | 88165–97920 | 0.66x | 5 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | plain | 10733 | 9433–11810 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 19911 | 19257–21008 | 1.86x | 821 | 41.05x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12323 | 11513–12425 | 1.15x | 68 | 3.40x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25461 | 22546–26935 | 2.37x | 165 | 8.25x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 24120 | 21661–26135 | 2.25x | 167 | 8.35x | 1 | yes |
| tree-expand-collapse | 1 | react | 19470 | 19038–20207 | 1.81x | 4 | 0.20x | 2 | yes |
| tree-expand-collapse | 1 | react-reflex | 19133 | 18247–19830 | 1.78x | 615 | 30.75x | 4 | yes |
| tree-expand-collapse | 1 | react-upstream | 19327 | 18857–19703 | 1.80x | 3 | 0.15x | 2 | yes |
| tree-expand-collapse | 1 | roact | 11619 | 11407–12040 | 1.08x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 26305 | 22214–32060 | 2.45x | 141 | 7.05x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8739 | 8312–9417 | 0.81x | 13 | 0.65x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12465 | 12339–14022 | 1.16x | 71 | 3.55x | 0 | yes |
| form-validation | 1 | plain | 2614 | 1808–2930 | 1.00x | 56 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 3352 | 3127–4273 | 1.28x | 336 | 6.00x | 1 | yes |
| form-validation | 1 | compose | 2955 | 2853–3655 | 1.13x | 109 | 1.95x | 2 | yes |
| form-validation | 1 | fusion | 4497 | 3888–4830 | 1.72x | 118 | 2.11x | 0 | yes |
| form-validation | 1 | fusion-charm | 4790 | 4218–4969 | 1.83x | 155 | 2.77x | 0 | yes |
| form-validation | 1 | react | 11755 | 11519–13173 | 4.50x | 189 | 3.38x | 2 | yes |
| form-validation | 1 | react-reflex | 13113 | 12930–13168 | 5.02x | 258 | 4.61x | 5 | yes |
| form-validation | 1 | react-upstream | 12202 | 11780–13116 | 4.67x | 189 | 3.38x | 2 | yes |
| form-validation | 1 | roact | 6289 | 6052–7340 | 2.41x | 63 | 1.12x | 3 | yes |
| form-validation | 1 | seam | 5452 | 4527–6224 | 2.09x | 356 | 6.36x | 8 | yes |
| form-validation | 1 | signals | 3260 | 3023–3454 | 1.25x | 155 | 2.77x | 0 | yes |
| form-validation | 1 | vide | 3410 | 2526–3841 | 1.30x | 70 | 1.25x | 0 | yes |
| table-sort-filter | 1 | plain | 18151 | 16160–19015 | 1.00x | 83 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 37430 | 35927–43744 | 2.06x | 5795 | 69.82x | 0 | yes |
| table-sort-filter | 1 | compose | 26129 | 24930–27231 | 1.44x | 1663 | 20.04x | 25 | yes |
| table-sort-filter | 1 | fusion (workaround) | 58042 | 52012–62075 | 3.20x | 4928 | 59.37x | 0 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 52852 | 50370–61179 | 2.91x | 4930 | 59.40x | 1 | yes |
| table-sort-filter | 1 | react | 95568 | 92696–98558 | 5.27x | 2044 | 24.63x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 95520 | 93336–98510 | 5.26x | 2050 | 24.70x | 3 | yes |
| table-sort-filter | 1 | react-upstream | 94407 | 91624–99089 | 5.20x | 2044 | 24.63x | 2 | yes |
| table-sort-filter | 1 | roact | 26649 | 24833–26919 | 1.47x | 1054 | 12.70x | 3 | yes |
| table-sort-filter | 1 | seam | 58351 | 55982–61336 | 3.21x | 7776 | 93.69x | 1 | yes |
| table-sort-filter | 1 | signals | 18576 | 18237–19436 | 1.02x | 68 | 0.82x | 0 | yes |
| table-sort-filter | 1 | vide | 26531 | 24769–27027 | 1.46x | 1915 | 23.07x | 0 | yes |
| library-load | 1 | plain | 0 | 0–0 | plain below resolution | 2 | 1.00x | 0 | yes |
| library-load | 1 | blend | 100 | 0–100 | plain below resolution | 413 | 206.50x | 410 | yes |
| library-load | 1 | compose | 100 | 0–200 | plain below resolution | 463 | 231.50x | 459 | yes |
| library-load | 1 | fusion | 100 | 0–200 | plain below resolution | 186 | 93.00x | 192 | yes |
| library-load | 1 | fusion-charm | 100 | 100–103 | plain below resolution | 238 | 119.00x | 236 | yes |
| library-load | 1 | react | 200 | 0–200 | plain below resolution | 1321 | 660.50x | 1320 | yes |
| library-load | 1 | react-reflex | 100 | 100–300 | plain below resolution | 1452 | 726.00x | 1451 | yes |
| library-load | 1 | react-upstream | 100 | 100–100 | plain below resolution | 1434 | 717.00x | 1432 | yes |
| library-load | 1 | roact | 0 | 0–100 | plain below resolution | 119 | 59.50x | 115 | yes |
| library-load | 1 | seam | 100 | 0–200 | plain below resolution | 180 | 90.00x | 177 | yes |
| library-load | 1 | signals | 100 | 0–100 | plain below resolution | 27 | 13.50x | 25 | yes |
| library-load | 1 | vide | 100 | 0–100 | plain below resolution | 113 | 56.50x | 106 | yes |
| rows-append-1000 | 1 | plain | 98798 | 86658–123467 | 1.00x | 9763 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 146739 | 144307–161544 | 1.49x | 38481 | 3.94x | 0 | yes |
| rows-append-1000 | 1 | compose | 109878 | 99827–139793 | 1.11x | 10415 | 1.07x | 0 | yes |
| rows-append-1000 | 1 | fusion | 319086 | 315088–352108 | 3.23x | 21138 | 2.17x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 317038 | 311771–320537 | 3.21x | 28842 | 2.95x | 1 | yes |
| rows-append-1000 | 1 | react | 189542 | 167273–215162 | 1.92x | 23313 | 2.39x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 203363 | 187561–214886 | 2.06x | 24886 | 2.55x | 83 | yes |
| rows-append-1000 | 1 | react-upstream | 187885 | 175642–214329 | 1.90x | 23290 | 2.39x | 152 | yes |
| rows-append-1000 | 1 | roact | 142685 | 123509–151158 | 1.44x | 33378 | 3.42x | 1 | yes |
| rows-append-1000 | 1 | seam | 163599 | 134085–190448 | 1.66x | 47023 | 4.82x | 1 | yes |
| rows-append-1000 | 1 | signals | 100718 | 96763–155860 | 1.02x | 17821 | 1.83x | 0 | yes |
| rows-append-1000 | 1 | vide | 112267 | 105592–119058 | 1.14x | 9515 | 0.97x | 0 | yes |
| rows-clear | 1 | plain | 63047 | 62736–67110 | 1.00x | 2480 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 76301 | 75990–78375 | 1.21x | 4217 | 1.70x | 0 | yes |
| rows-clear | 1 | compose | 68911 | 67768–73740 | 1.09x | 1780 | 0.72x | 0 | yes |
| rows-clear | 1 | fusion | 102541 | 94883–106260 | 1.63x | 3505 | 1.41x | 0 | yes |
| rows-clear | 1 | fusion-charm | 95637 | 95271–104043 | 1.52x | 7432 | 3.00x | 0 | yes |
| rows-clear | 1 | react | 71585 | 69788–72334 | 1.14x | 4504 | 1.82x | 0 | yes |
| rows-clear | 1 | react-reflex | 75856 | 70493–82098 | 1.20x | 6490 | 2.62x | 43 | yes |
| rows-clear | 1 | react-upstream | 70891 | 68539–73682 | 1.12x | 4504 | 1.82x | 0 | yes |
| rows-clear | 1 | roact | 58457 | 55460–61088 | 0.93x | 4238 | 1.71x | 0 | yes |
| rows-clear | 1 | seam | 31632 | 24320–33940 | 0.50x | 9135 | 3.68x | 0 | yes |
| rows-clear | 1 | signals | 63017 | 62665–65818 | 1.00x | 4490 | 1.81x | 0 | yes |
| rows-clear | 1 | vide | 64089 | 61037–66077 | 1.02x | 1621 | 0.65x | 0 | yes |
| rows-create-1000 | 1 | plain | 90662 | 85467–91607 | 1.00x | 5201 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 150475 | 132042–157236 | 1.66x | 19780 | 3.80x | 0 | yes |
| rows-create-1000 | 1 | compose | 102730 | 96725–104595 | 1.13x | 5510 | 1.06x | 0 | yes |
| rows-create-1000 | 1 | fusion | 179338 | 177523–188410 | 1.98x | 10995 | 2.11x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 188006 | 168391–198750 | 2.07x | 14933 | 2.87x | 0 | yes |
| rows-create-1000 | 1 | react | 158698 | 148002–170601 | 1.75x | 8167 | 1.57x | 15 | yes |
| rows-create-1000 | 1 | react-reflex | 162583 | 160621–169369 | 1.79x | 9089 | 1.75x | 51 | yes |
| rows-create-1000 | 1 | react-upstream | 156113 | 148436–161509 | 1.72x | 7912 | 1.52x | 0 | yes |
| rows-create-1000 | 1 | roact | 124087 | 115012–142985 | 1.37x | 16689 | 3.21x | 0 | yes |
| rows-create-1000 | 1 | seam | 147727 | 125421–152584 | 1.63x | 23645 | 4.55x | 0 | yes |
| rows-create-1000 | 1 | signals | 102401 | 94228–103178 | 1.13x | 9057 | 1.74x | 2 | yes |
| rows-create-1000 | 1 | vide | 110667 | 103808–112686 | 1.22x | 4956 | 0.95x | 0 | yes |
| rows-create-10000 | 1 | plain | 1203469 | 1183293–1336791 | 1.00x | 49526 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1805587 | 1764364–1834814 | 1.50x | 193290 | 3.90x | 4 | yes |
| rows-create-10000 | 1 | compose | 1364156 | 1338814–1386719 | 1.13x | 52898 | 1.07x | 0 | yes |
| rows-create-10000 | 1 | fusion | 6203583 | 6141357–6257970 | 5.15x | 101556 | 2.05x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 6242442 | 6074279–6248619 | 5.19x | 144831 | 2.92x | 0 | yes |
| rows-create-10000 | 1 | react | 4727918 | 4628978–4862473 | 3.93x | 77273 | 1.56x | 95 | yes |
| rows-create-10000 | 1 | react-reflex | 4840210 | 4654712–4864295 | 4.02x | 87577 | 1.77x | 1032 | yes |
| rows-create-10000 | 1 | react-upstream | 4873353 | 4779634–4878481 | 4.05x | 78519 | 1.59x | 641 | yes |
| rows-create-10000 | 1 | roact | 1496040 | 1483111–1508028 | 1.24x | 165790 | 3.35x | 8 | yes |
| rows-create-10000 | 1 | seam | 1655386 | 1644068–1973629 | 1.38x | 235924 | 4.76x | 12 | yes |
| rows-create-10000 | 1 | signals | 1268281 | 1261813–1365394 | 1.05x | 89262 | 1.80x | 1 | yes |
| rows-create-10000 | 1 | vide | 1280948 | 1271756–1441805 | 1.06x | 48468 | 0.98x | 9 | yes |
| rows-remove-one | 1 | plain | 903 | 400–1300 | 1.00x | 5231 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1002 | 1000–1100 | 1.11x | 19808 | 3.79x | 8 | yes |
| rows-remove-one | 1 | compose | 900 | 700–909 | 1.00x | 5555 | 1.06x | 25 | yes |
| rows-remove-one | 1 | fusion (workaround) | 62042 | 59719–66937 | 68.71x | 11426 | 2.18x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 59817 | 58569–60744 | 66.24x | 15362 | 2.94x | 9 | yes |
| rows-remove-one | 1 | react | 23946 | 18304–43625 | 26.52x | 15732 | 3.01x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 31127 | 22250–32729 | 34.47x | 16662 | 3.19x | 59 | yes |
| rows-remove-one | 1 | react-upstream | 24209 | 19510–24815 | 26.81x | 15493 | 2.96x | 8 | yes |
| rows-remove-one | 1 | roact | 17233 | 15510–17631 | 19.08x | 16782 | 3.21x | 1 | yes |
| rows-remove-one | 1 | seam | 5711 | 4918–7006 | 6.32x | 23678 | 4.53x | 0 | yes |
| rows-remove-one | 1 | signals | 1506 | 1400–1600 | 1.67x | 9078 | 1.74x | 0 | yes |
| rows-remove-one | 1 | vide | 1005 | 904–1203 | 1.11x | 5018 | 0.96x | 1 | yes |
| rows-swap | 1 | plain | 400 | 200–500 | 1.00x | 4606 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 703 | 600–800 | 1.76x | 18760 | 4.07x | 8 | yes |
| rows-swap | 1 | compose | 300 | 200–300 | 0.75x | 5027 | 1.09x | 10 | yes |
| rows-swap | 1 | fusion | 59657 | 57514–61328 | 149.14x | 10024 | 2.18x | 1 | yes |
| rows-swap | 1 | fusion-charm | 58848 | 58163–60072 | 147.12x | 13944 | 3.03x | 0 | yes |
| rows-swap | 1 | react | 55178 | 49467–56943 | 137.94x | 15110 | 3.28x | 0 | yes |
| rows-swap | 1 | react-reflex | 62447 | 53718–79396 | 156.12x | 16302 | 3.54x | 66 | yes |
| rows-swap | 1 | react-upstream | 55702 | 50289–83891 | 139.25x | 15421 | 3.35x | 0 | yes |
| rows-swap | 1 | roact | 15505 | 13234–18044 | 38.76x | 16754 | 3.64x | 0 | yes |
| rows-swap | 1 | seam | 5106 | 4706–5812 | 12.77x | 23220 | 5.04x | 8 | yes |
| rows-swap | 1 | signals | 600 | 501–603 | 1.50x | 8609 | 1.87x | 0 | yes |
| rows-swap | 1 | vide | 100 | 0–200 | 0.25x | 4516 | 0.98x | 0 | yes |
| rows-update-every-10th | 1 | plain | 1705 | 1700–1900 | 1.00x | 4242 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 2000 | 1800–2325 | 1.17x | 18824 | 4.44x | 0 | yes |
| rows-update-every-10th | 1 | compose | 1900 | 1800–2008 | 1.11x | 4632 | 1.09x | 12 | yes |
| rows-update-every-10th | 1 | fusion | 2103 | 2000–2138 | 1.23x | 10060 | 2.37x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2206 | 2200–2417 | 1.29x | 13988 | 3.30x | 0 | yes |
| rows-update-every-10th | 1 | react | 1839 | 1800–2000 | 1.08x | 7480 | 1.76x | 40 | yes |
| rows-update-every-10th | 1 | react-reflex | 3925 | 2800–7805 | 2.30x | 8392 | 1.98x | 68 | yes |
| rows-update-every-10th | 1 | react-upstream | 1900 | 1800–2000 | 1.11x | 7472 | 1.76x | 48 | yes |
| rows-update-every-10th | 1 | roact | 1806 | 1708–1904 | 1.06x | 16196 | 3.82x | 0 | yes |
| rows-update-every-10th | 1 | seam | 5307 | 4700–5900 | 3.11x | 23772 | 5.60x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2001 | 1800–2100 | 1.17x | 8866 | 2.09x | 0 | yes |
| rows-update-every-10th | 1 | vide | 2004 | 1722–2213 | 1.18x | 4652 | 1.10x | 0 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.

The shared columns use only the workloads that every lane measured: 24 for time (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`) and 24 for heap (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `status-panel`, `scene-3d`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 1.65x | 10.59x | 1.59x | 10.94x |
| compose | 30 | 1.33x | 3.41x | 1.30x | 3.56x |
| fusion | 30 | 4.25x | 5.24x | 3.87x | 6.04x |
| fusion-charm | 30 | 4.41x | 6.37x | 4.03x | 7.98x |
| react | 29 | 3.21x | 4.09x | 3.21x | 4.15x |
| react-reflex | 29 | 3.82x | 7.29x | 3.82x | 9.59x |
| react-upstream | 29 | 3.18x | 2.95x | 3.18x | 3.77x |
| roact | 29 | 1.97x | 4.25x | 1.97x | 5.41x |
| seam | 30 | 2.53x | 10.09x | 2.42x | 12.39x |
| signals | 29 | 1.28x | 2.05x | 1.28x | 2.19x |
| vide | 30 | 1.33x | 2.92x | 1.29x | 2.94x |
