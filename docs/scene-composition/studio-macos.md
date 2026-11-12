# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Date | 2026-11-12 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 200–300 | 1.00x | 57 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 900 | 400–1200 | 3.00x | 749 | 13.14x | 0 | yes |
| update-leaf | 20 | compose | 700 | 612–962 | 2.33x | 101 | 1.77x | 2 | yes |
| update-leaf | 20 | fusion | 814 | 603–1419 | 2.71x | 51 | 0.89x | 8 | yes |
| update-leaf | 20 | fusion-charm | 1323 | 1012–1466 | 4.41x | 61 | 1.07x | 8 | yes |
| update-leaf | 20 | react | 745 | 512–1001 | 2.48x | 348 | 6.11x | 0 | yes |
| update-leaf | 20 | react-reflex | 900 | 709–1013 | 3.00x | 300 | 5.26x | 8 | yes |
| update-leaf | 20 | react-upstream | 800 | 400–1134 | 2.67x | 292 | 5.12x | 0 | yes |
| update-leaf | 20 | roact | 918 | 800–1170 | 3.06x | 960 | 16.84x | 0 | yes |
| update-leaf | 20 | seam | 1303 | 900–1613 | 4.34x | 41 | 0.72x | 9 | yes |
| update-leaf | 20 | signals | 605 | 300–900 | 2.02x | 51 | 0.89x | 1 | yes |
| update-leaf | 20 | vide | 1010 | 602–1100 | 3.37x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4567 | 4256–5058 | 1.00x | 21 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 10610 | 9900–10809 | 2.32x | 908 | 43.24x | 1 | yes |
| update-batched | 20 | compose | 6602 | 6513–6839 | 1.45x | 408 | 19.43x | 10 | yes |
| update-batched | 20 | fusion | 20022 | 19949–20932 | 4.38x | 500 | 23.81x | 0 | yes |
| update-batched | 20 | fusion-charm | 35535 | 33831–36943 | 7.78x | 1093 | 52.05x | 0 | yes |
| update-batched | 20 | react | 7726 | 7108–8156 | 1.69x | 535 | 25.48x | 2 | yes |
| update-batched | 20 | react-reflex | 59173 | 47294–60155 | 12.96x | 775 | 36.90x | 16 | yes |
| update-batched | 20 | react-upstream | 7471 | 7129–7846 | 1.64x | 469 | 22.33x | 0 | yes |
| update-batched | 20 | roact | 8003 | 7719–8619 | 1.75x | 1169 | 55.67x | 0 | yes |
| update-batched | 20 | seam | 13439 | 12014–13978 | 2.94x | 1849 | 88.05x | 0 | yes |
| update-batched | 20 | signals | 9252 | 8828–9649 | 2.03x | 597 | 28.43x | 0 | yes |
| update-batched | 20 | vide | 8443 | 8015–9442 | 1.85x | 332 | 15.81x | 0 | yes |
| update-repeated | 10 | plain | 49 | 46–60 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3366 | 3315–3570 | 68.62x | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 407 | 256–440 | 8.30x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | fusion | 25824 | 24316–26432 | 526.50x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1155 | 1062–1298 | 23.55x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react | 7148 | 7000–7610 | 145.73x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 754 | 546–1008 | 15.38x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7380 | 7056–7582 | 150.46x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5114 | 4872–5302 | 104.26x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1548 | 1354–1924 | 31.56x | 11 | 5.50x | 1 | yes |
| update-repeated | 10 | signals | 702 | 650–752 | 14.32x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 506 | 350–612 | 10.31x | 0 | 0.50x | 0 | yes |
| branch-swap | 20 | plain | 14026 | 12226–14529 | 1.00x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 16410 | 16140–17227 | 1.17x | 35 | 17.50x | 1 | yes |
| branch-swap | 20 | compose | 13942 | 13513–14362 | 0.99x | 8 | 4.00x | 2 | yes |
| branch-swap | 20 | fusion | 14513 | 14448–14905 | 1.03x | 13 | 6.50x | 8 | yes |
| branch-swap | 20 | fusion-charm | 14038 | 13716–14426 | 1.00x | 7 | 3.50x | 0 | yes |
| branch-swap | 20 | react | 16555 | 16342–18330 | 1.18x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-reflex | 16835 | 16502–16919 | 1.20x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 17005 | 16644–18142 | 1.21x | 19 | 9.50x | 1 | yes |
| branch-swap | 20 | roact | 14767 | 13968–15334 | 1.05x | 19 | 9.50x | 0 | yes |
| branch-swap | 20 | seam | 11908 | 11466–12930 | 0.85x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | signals | 12928 | 12124–13969 | 0.92x | 12 | 6.00x | 1 | yes |
| branch-swap | 20 | vide | 13821 | 13795–14373 | 0.99x | 5 | 2.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2438 | 2336–2702 | 1.00x | 64 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 4771 | 4400–4863 | 1.96x | 1490 | 23.28x | 1 | yes |
| keyed-prepend | 10 | compose | 4330 | 4110–4476 | 1.78x | 578 | 9.03x | 17 | yes |
| keyed-prepend | 10 | fusion (workaround) | 22812 | 21512–23620 | 9.36x | 1519 | 23.73x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 20521 | 19710–21940 | 8.42x | 1529 | 23.89x | 1 | yes |
| keyed-prepend | 10 | react | 16314 | 16074–16608 | 6.69x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 15815 | 15258–15940 | 6.49x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 15538 | 15026–17112 | 6.37x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | roact | 6834 | 6212–6933 | 2.80x | 362 | 5.66x | 1 | yes |
| keyed-prepend | 10 | seam | 10950 | 10406–11404 | 4.49x | 2436 | 38.06x | 1 | yes |
| keyed-prepend | 10 | signals | 2762 | 2700–2972 | 1.13x | 62 | 0.97x | 1 | yes |
| keyed-prepend | 10 | vide | 4849 | 4602–5219 | 1.99x | 645 | 10.08x | 1 | yes |
| keyed-insert | 10 | plain | 1701 | 1576–1851 | 1.00x | 64 | 1.00x | 9 | yes |
| keyed-insert | 10 | blend | 3868 | 3760–3977 | 2.27x | 1490 | 23.28x | 1 | yes |
| keyed-insert | 10 | compose | 2962 | 2910–3240 | 1.74x | 563 | 8.80x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 19214 | 18512–19447 | 11.29x | 1520 | 23.75x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 17526 | 17233–18414 | 10.30x | 1521 | 23.77x | 9 | yes |
| keyed-insert | 10 | react | 13843 | 12828–15041 | 8.14x | 803 | 12.55x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13306 | 12912–13618 | 7.82x | 875 | 13.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13500 | 13315–14071 | 7.94x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 5432 | 5300–5762 | 3.19x | 369 | 5.77x | 1 | yes |
| keyed-insert | 10 | seam | 10942 | 10338–11158 | 6.43x | 2455 | 38.36x | 8 | yes |
| keyed-insert | 10 | signals | 1798 | 1712–2252 | 1.06x | 62 | 0.97x | 1 | yes |
| keyed-insert | 10 | vide | 3466 | 3209–3584 | 2.04x | 646 | 10.09x | 8 | yes |
| keyed-shuffle | 10 | plain | 1951 | 1829–2101 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3008 | 2703–3310 | 1.54x | 1432 | 23.87x | 0 | yes |
| keyed-shuffle | 10 | compose | 3182 | 2918–3322 | 1.63x | 570 | 9.50x | 10 | yes |
| keyed-shuffle | 10 | fusion | 18859 | 17721–19824 | 9.67x | 1390 | 23.17x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 17823 | 16931–18102 | 9.14x | 1400 | 23.33x | 0 | yes |
| keyed-shuffle | 10 | react | 27137 | 26743–28620 | 13.91x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27741 | 26542–28542 | 14.22x | 780 | 13.00x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27115 | 26136–27963 | 13.90x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | roact | 5601 | 5414–5900 | 2.87x | 361 | 6.02x | 0 | yes |
| keyed-shuffle | 10 | seam | 9728 | 9229–10125 | 4.99x | 2439 | 40.65x | 1 | yes |
| keyed-shuffle | 10 | signals | 2221 | 1964–2300 | 1.14x | 53 | 0.88x | 0 | yes |
| keyed-shuffle | 10 | vide | 3703 | 3564–3983 | 1.90x | 622 | 10.37x | 1 | yes |
| events | 1 | plain | 1100 | 602–1407 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 1833 | 1527–1930 | 1.67x | 2 | 1.00x | 0 | yes |
| events | 1 | compose | 1202 | 902–1547 | 1.09x | 2 | 1.00x | 1 | yes |
| events | 1 | fusion | 1519 | 1105–1632 | 1.38x | 1 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 1456 | 912–1725 | 1.32x | 0 | 0.50x | 0 | yes |
| events | 1 | react | 1703 | 1539–1841 | 1.55x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 1405 | 1300–1926 | 1.28x | 1 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 1400 | 1200–1703 | 1.27x | 1 | 0.50x | 0 | yes |
| events | 1 | roact | 907 | 709–1524 | 0.82x | 1 | 0.50x | 0 | yes |
| events | 1 | seam | 1000 | 600–1414 | 0.91x | 2 | 1.00x | 1 | yes |
| events | 1 | signals | 1114 | 925–1496 | 1.01x | 1 | 0.50x | 0 | yes |
| events | 1 | vide | 1104 | 1007–1804 | 1.00x | 1 | 0.50x | 1 | yes |
| animate-many | 1 | plain | 3214 | 2347–3306 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 9855 | 9227–11630 | 3.07x | 1778 | 24.03x | 0 | yes |
| animate-many | 1 | compose | 6354 | 6175–6895 | 1.98x | 655 | 8.85x | 12 | yes |
| animate-many | 1 | fusion | 105383 | 104769–106493 | 32.79x | 1128 | 15.24x | 0 | yes |
| animate-many | 1 | fusion-charm | 105640 | 105269–106460 | 32.87x | 1130 | 15.27x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20212 | 18413–21605 | 6.29x | 2898 | 39.16x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 7851 | 7692–8130 | 2.44x | 392 | 5.30x | 0 | yes |
| status-panel | 10 | plain | 580 | 510–630 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1301 | 1056–1461 | 2.24x | 62 | 31.00x | 0 | yes |
| status-panel | 10 | compose | 1128 | 1006–1260 | 1.95x | 33 | 16.50x | 2 | yes |
| status-panel | 10 | fusion | 1608 | 1502–1912 | 2.77x | 64 | 32.00x | 1 | yes |
| status-panel | 10 | fusion-charm | 1718 | 1612–1764 | 2.96x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | react | 2191 | 2183–2340 | 3.78x | 47 | 23.50x | 0 | yes |
| status-panel | 10 | react-reflex | 2119 | 1710–2316 | 3.65x | 45 | 22.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2278 | 1900–2565 | 3.93x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | roact | 1019 | 988–1150 | 1.76x | 33 | 16.50x | 0 | yes |
| status-panel | 10 | seam | 1907 | 1800–2218 | 3.29x | 140 | 70.00x | 0 | yes |
| status-panel | 10 | signals | 1014 | 997–1060 | 1.75x | 14 | 7.00x | 0 | yes |
| status-panel | 10 | vide | 1162 | 1002–1230 | 2.00x | 25 | 12.50x | 0 | yes |
| scene-3d | 10 | plain | 2776 | 2567–3034 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4701 | 4504–5052 | 1.69x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 3160 | 3016–3254 | 1.14x | 194 | 17.64x | 2 | yes |
| scene-3d | 10 | fusion | 33926 | 32831–35302 | 12.22x | 520 | 47.27x | 8 | yes |
| scene-3d | 10 | fusion-charm | 31820 | 30840–32120 | 11.46x | 523 | 47.55x | 1 | yes |
| scene-3d | 10 | react | 3406 | 3202–3512 | 1.23x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | react-reflex | 3012 | 2934–3225 | 1.08x | 216 | 19.64x | 0 | yes |
| scene-3d | 10 | react-upstream | 3516 | 3330–3682 | 1.27x | 215 | 19.55x | 0 | yes |
| scene-3d | 10 | roact | 3450 | 2960–3777 | 1.24x | 575 | 52.27x | 1 | yes |
| scene-3d | 10 | seam | 8807 | 8500–9710 | 3.17x | 1754 | 159.45x | 0 | yes |
| scene-3d | 10 | signals | 6009 | 5600–6205 | 2.16x | 682 | 62.00x | 0 | yes |
| scene-3d | 10 | vide | 3700 | 3631–4108 | 1.33x | 211 | 19.18x | 1 | yes |
| derived-diamond | 3 | plain | 24 | 23–32 | 1.00x | 3 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 150 | 100–179 | 6.27x | 29 | 9.67x | 1 | yes |
| derived-diamond | 3 | compose | 125 | 100–154 | 5.23x | 10 | 3.33x | 0 | yes |
| derived-diamond | 3 | fusion | 150 | 100–156 | 6.27x | 9 | 3.00x | 1 | yes |
| derived-diamond | 3 | fusion-charm | 151 | 125–157 | 6.30x | 11 | 3.67x | 9 | yes |
| derived-diamond | 3 | react | 333 | 237–434 | 13.93x | 7 | 2.33x | 4 | yes |
| derived-diamond | 3 | react-reflex | 400 | 336–440 | 16.72x | 18 | 6.00x | 7 | yes |
| derived-diamond | 3 | react-upstream | 267 | 169–498 | 11.15x | 6 | 2.00x | 4 | yes |
| derived-diamond | 3 | roact | 125 | 100–175 | 5.23x | 3 | 1.00x | 3 | yes |
| derived-diamond | 3 | seam | 150 | 150–204 | 6.27x | 13 | 4.33x | 1 | yes |
| derived-diamond | 3 | signals | 125 | 100–127 | 5.23x | 9 | 3.00x | 0 | yes |
| derived-diamond | 3 | vide | 129 | 101–175 | 5.39x | 6 | 2.00x | 1 | yes |
| derived-chain-100 | 3 | plain | 50 | 44–54 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 175 | 150–241 | 3.52x | 139 | 2.44x | 2 | yes |
| derived-chain-100 | 3 | fusion | 962 | 850–1004 | 19.34x | 127 | 2.23x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 926 | 854–972 | 18.61x | 129 | 2.26x | 1 | yes |
| derived-chain-100 | 3 | react | 536 | 511–710 | 10.78x | 69 | 1.21x | 12 | yes |
| derived-chain-100 | 3 | react-reflex | 601 | 500–636 | 12.08x | 88 | 1.54x | 15 | yes |
| derived-chain-100 | 3 | react-upstream | 577 | 500–685 | 11.59x | 69 | 1.21x | 12 | yes |
| derived-chain-100 | 3 | roact | 150 | 125–175 | 3.02x | 11 | 0.19x | 3 | yes |
| derived-chain-100 | 3 | seam | 700 | 626–854 | 14.07x | 280 | 4.91x | 1 | yes |
| derived-chain-100 | 3 | signals | 252 | 200–325 | 5.08x | 173 | 3.04x | 0 | yes |
| derived-chain-100 | 3 | vide | 201 | 100–258 | 4.04x | 85 | 1.49x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 99–100 | 1.00x | 497 | 1.00x | 7 | yes |
| derived-fan-in-1000 | 3 | blend | 265 | 203–450 | 2.65x | 1534 | 3.09x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 375 | 275–481 | 3.75x | 687 | 1.38x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 2052 | 1900–2252 | 20.52x | 889 | 1.79x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2302 | 2067–2338 | 23.02x | 2814 | 5.66x | 1 | yes |
| derived-fan-in-1000 | 3 | react | 2711 | 2354–3672 | 27.11x | 671 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8505 | 6506–9404 | 85.05x | 5630 | 11.33x | 78 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2563 | 2000–3306 | 25.63x | 663 | 1.33x | 44 | yes |
| derived-fan-in-1000 | 3 | roact | 500 | 450–534 | 5.00x | 104 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2856 | 2702–3057 | 28.56x | 2955 | 5.95x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 727 | 650–750 | 7.27x | 1212 | 2.44x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 550 | 475–606 | 5.50x | 520 | 1.05x | 1 | yes |
| filter-as-you-type | 1 | plain | 8525 | 7518–9335 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 17117 | 15625–17725 | 2.01x | 2662 | 76.06x | 8 | yes |
| filter-as-you-type | 1 | compose | 10402 | 10203–11023 | 1.22x | 834 | 23.83x | 2 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 27620 | 25329–31745 | 3.24x | 2457 | 70.20x | 2 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 24830 | 22944–27615 | 2.91x | 2459 | 70.26x | 1 | yes |
| filter-as-you-type | 1 | react | 21406 | 20446–22555 | 2.51x | 76 | 2.17x | 12 | yes |
| filter-as-you-type | 1 | react-reflex | 22042 | 20716–22135 | 2.59x | 838 | 23.94x | 22 | yes |
| filter-as-you-type | 1 | react-upstream | 21831 | 21570–22211 | 2.56x | 68 | 1.94x | 11 | yes |
| filter-as-you-type | 1 | roact | 11710 | 11304–11936 | 1.37x | 503 | 14.37x | 4 | yes |
| filter-as-you-type | 1 | seam | 24031 | 20607–26615 | 2.82x | 3997 | 114.20x | 0 | yes |
| filter-as-you-type | 1 | signals | 7851 | 7748–8125 | 0.92x | 36 | 1.03x | 0 | yes |
| filter-as-you-type | 1 | vide | 10640 | 10408–10910 | 1.25x | 959 | 27.40x | 0 | yes |
| theme-propagation | 3 | plain | 48588 | 45962–49479 | 1.00x | 206 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 47058 | 46379–49148 | 0.97x | 2070 | 10.05x | 0 | yes |
| theme-propagation | 3 | compose | 50897 | 49667–52176 | 1.05x | 579 | 2.81x | 10 | yes |
| theme-propagation | 3 | fusion | 52597 | 50153–53529 | 1.08x | 867 | 4.21x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 52162 | 51342–54765 | 1.07x | 877 | 4.26x | 1 | yes |
| theme-propagation | 3 | react | 52665 | 51941–54360 | 1.08x | 2027 | 9.84x | 0 | yes |
| theme-propagation | 3 | react-reflex | 46959 | 46589–47668 | 0.97x | 2028 | 9.84x | 0 | yes |
| theme-propagation | 3 | react-upstream | 53368 | 51474–54282 | 1.10x | 2027 | 9.84x | 0 | yes |
| theme-propagation | 3 | roact | 52197 | 48848–53341 | 1.07x | 3286 | 15.95x | 0 | yes |
| theme-propagation | 3 | seam | 45940 | 45173–46536 | 0.95x | 3477 | 16.88x | 0 | yes |
| theme-propagation | 3 | signals | 51574 | 51430–52035 | 1.06x | 895 | 4.34x | 0 | yes |
| theme-propagation | 3 | vide | 50537 | 49681–52438 | 1.04x | 598 | 2.90x | 0 | yes |
| hud-per-frame | 1 | plain | 3209 | 3072–3725 | 1.00x | 22 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 6116 | 4296–6556 | 1.91x | 72 | 3.25x | 0 | yes |
| hud-per-frame | 1 | compose | 4843 | 4247–5668 | 1.51x | 28 | 1.27x | 2 | yes |
| hud-per-frame | 1 | fusion | 10862 | 9770–10872 | 3.38x | 51 | 2.32x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13698 | 13077–13703 | 4.27x | 90 | 4.11x | 0 | yes |
| hud-per-frame | 1 | react | 4227 | 4029–4412 | 1.32x | 38 | 1.70x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7251 | 6884–7254 | 2.26x | 50 | 2.27x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 4816 | 4559–5436 | 1.50x | 34 | 1.55x | 0 | yes |
| hud-per-frame | 1 | roact | 4419 | 4044–5335 | 1.38x | 93 | 4.23x | 0 | yes |
| hud-per-frame | 1 | seam | 8517 | 7416–8981 | 2.65x | 176 | 8.00x | 0 | yes |
| hud-per-frame | 1 | signals | 5179 | 5130–5335 | 1.61x | 66 | 2.98x | 0 | yes |
| hud-per-frame | 1 | vide | 5006 | 4835–6124 | 1.56x | 18 | 0.84x | 0 | yes |
| teardown-under-load | 1 | plain | 45958 | 42138–48363 | 1.00x | 13 | 1.00x | 9 | yes |
| teardown-under-load | 1 | blend | 70843 | 62289–82087 | 1.54x | 14 | 1.08x | 1 | yes |
| teardown-under-load | 1 | compose | 52881 | 48663–55699 | 1.15x | 6 | 0.46x | 9 | yes |
| teardown-under-load | 1 | fusion | 72364 | 65609–77848 | 1.57x | 0 | 0.08x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 74463 | 68598–77303 | 1.62x | 0 | 0.08x | 0 | yes |
| teardown-under-load | 1 | react | 74436 | 71542–77610 | 1.62x | 1070 | 82.31x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 73500 | 68751–76468 | 1.60x | 1078 | 82.92x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 75531 | 71904–76618 | 1.64x | 1076 | 82.77x | 0 | yes |
| teardown-under-load | 1 | roact | 66135 | 58472–70759 | 1.44x | 70 | 5.38x | 0 | yes |
| teardown-under-load | 1 | seam | 61912 | 51767–72006 | 1.35x | 8 | 0.62x | 6 | yes |
| teardown-under-load | 1 | signals | 55273 | 48111–58477 | 1.20x | 5 | 0.38x | 0 | yes |
| teardown-under-load | 1 | vide | 57180 | 49476–58175 | 1.24x | 13 | 1.00x | 9 | yes |
| open-close-retention | 1 | plain | 65535 | 65256–67455 | 1.00x | 40 | 1.00x | 9 | yes |
| open-close-retention | 1 | blend | 119366 | 117754–119463 | 1.82x | 14 | 0.35x | 1 | yes |
| open-close-retention | 1 | compose | 81401 | 80057–82354 | 1.24x | 7 | 0.17x | 2 | yes |
| open-close-retention | 1 | fusion | 135380 | 134856–136419 | 2.07x | 13 | 0.33x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 135487 | 134298–137363 | 2.07x | 13 | 0.33x | 7 | yes |
| open-close-retention | 1 | react | 118450 | 115728–119563 | 1.81x | 279 | 6.97x | 0 | yes |
| open-close-retention | 1 | react-reflex | 114289 | 113670–115923 | 1.74x | 292 | 7.30x | 0 | yes |
| open-close-retention | 1 | react-upstream | 116916 | 114666–118902 | 1.78x | 283 | 7.08x | 0 | yes |
| open-close-retention | 1 | roact | 108426 | 106982–111016 | 1.65x | 24 | 0.60x | 9 | yes |
| open-close-retention | 1 | seam | 112916 | 112878–119234 | 1.72x | 8 | 0.20x | 0 | yes |
| open-close-retention | 1 | signals | 82641 | 82242–82901 | 1.26x | 13 | 0.33x | 0 | yes |
| open-close-retention | 1 | vide | 89271 | 89191–89909 | 1.36x | 4 | 0.10x | 0 | yes |
| tree-expand-collapse | 1 | plain | 11023 | 8509–12235 | 1.00x | 19 | 1.00x | 1 | yes |
| tree-expand-collapse | 1 | blend | 19756 | 19007–20834 | 1.79x | 788 | 41.47x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12014 | 11387–12400 | 1.09x | 79 | 4.16x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25233 | 23666–26344 | 2.29x | 165 | 8.68x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23340 | 22105–24740 | 2.12x | 167 | 8.79x | 1 | yes |
| tree-expand-collapse | 1 | react | 18743 | 18144–19111 | 1.70x | 69 | 3.63x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 19687 | 18120–20394 | 1.79x | 673 | 35.42x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 19517 | 18157–20211 | 1.77x | 77 | 4.05x | 20 | yes |
| tree-expand-collapse | 1 | roact | 10944 | 10410–11080 | 0.99x | 36 | 1.89x | 3 | yes |
| tree-expand-collapse | 1 | seam | 27075 | 26343–27720 | 2.46x | 148 | 7.79x | 8 | yes |
| tree-expand-collapse | 1 | signals | 8021 | 7602–8206 | 0.73x | 21 | 1.11x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11723 | 11419–11824 | 1.06x | 71 | 3.74x | 1 | yes |
| form-validation | 1 | plain | 2534 | 2310–3039 | 1.00x | 46 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 4062 | 3293–4261 | 1.60x | 328 | 7.13x | 1 | yes |
| form-validation | 1 | compose | 3969 | 3622–4600 | 1.57x | 107 | 2.33x | 2 | yes |
| form-validation | 1 | fusion | 4830 | 4437–4970 | 1.91x | 118 | 2.57x | 0 | yes |
| form-validation | 1 | fusion-charm | 5296 | 4337–5847 | 2.09x | 155 | 3.37x | 0 | yes |
| form-validation | 1 | react | 5134 | 4244–5555 | 2.03x | 65 | 1.41x | 0 | yes |
| form-validation | 1 | react-reflex | 5589 | 5157–5782 | 2.21x | 76 | 1.65x | 0 | yes |
| form-validation | 1 | react-upstream | 4837 | 4638–5397 | 1.91x | 58 | 1.26x | 0 | yes |
| form-validation | 1 | roact | 4317 | 3711–5039 | 1.70x | 215 | 4.67x | 0 | yes |
| form-validation | 1 | seam | 6065 | 6033–6230 | 2.39x | 356 | 7.74x | 1 | yes |
| form-validation | 1 | signals | 3547 | 3219–3900 | 1.40x | 155 | 3.37x | 0 | yes |
| form-validation | 1 | vide | 3738 | 3385–4352 | 1.48x | 78 | 1.70x | 0 | yes |
| table-sort-filter | 1 | plain | 17709 | 16011–19359 | 1.00x | 74 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 37635 | 34929–38554 | 2.13x | 5373 | 72.61x | 0 | yes |
| table-sort-filter | 1 | compose | 26012 | 24664–26332 | 1.47x | 1632 | 22.05x | 25 | yes |
| table-sort-filter | 1 | fusion (workaround) | 57133 | 50037–61534 | 3.23x | 4704 | 63.57x | 0 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 52062 | 47647–56276 | 2.94x | 4713 | 63.69x | 1 | yes |
| table-sort-filter | 1 | react | 96249 | 92222–98820 | 5.44x | 2108 | 28.49x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 97008 | 89318–100503 | 5.48x | 2115 | 28.58x | 15 | yes |
| table-sort-filter | 1 | react-upstream | 98479 | 93448–103445 | 5.56x | 2116 | 28.59x | 11 | yes |
| table-sort-filter | 1 | roact | 25940 | 25350–27131 | 1.46x | 1015 | 13.72x | 3 | yes |
| table-sort-filter | 1 | seam | 54634 | 51276–66453 | 3.09x | 7768 | 104.97x | 0 | yes |
| table-sort-filter | 1 | signals | 18231 | 17633–19255 | 1.03x | 75 | 1.01x | 0 | yes |
| table-sort-filter | 1 | vide | 25162 | 24559–26743 | 1.42x | 1922 | 25.97x | 0 | yes |
| library-load | 1 | plain | 44 | 27–53 | 1.00x | 0 | 1.00x | 0 | yes |
| library-load | 1 | blend | 746 | 673–803 | 16.86x | 459 | 459.00x | 456 | yes |
| library-load | 1 | compose | 575 | 555–684 | 13.00x | 59 | 59.00x | 56 | yes |
| library-load | 1 | fusion | 1354 | 1251–1390 | 30.60x | 264 | 264.00x | 262 | yes |
| library-load | 1 | fusion-charm | 1544 | 1460–1580 | 34.90x | 318 | 318.00x | 316 | yes |
| library-load | 1 | react | 4919 | 4605–5080 | 111.16x | 1825 | 1825.00x | 1824 | yes |
| library-load | 1 | react-reflex | 5084 | 4613–5192 | 114.89x | 1973 | 1973.00x | 1971 | yes |
| library-load | 1 | react-upstream | 4913 | 4741–5301 | 111.02x | 1995 | 1995.00x | 1994 | yes |
| library-load | 1 | roact | 450 | 373–465 | 10.17x | 153 | 153.00x | 150 | yes |
| library-load | 1 | seam | 1271 | 1125–1403 | 28.73x | 234 | 234.00x | 232 | yes |
| library-load | 1 | signals | 233 | 220–320 | 5.26x | 34 | 34.00x | 33 | yes |
| library-load | 1 | vide | 356 | 320–361 | 8.05x | 139 | 139.00x | 146 | yes |
| rows-append-1000 | 1 | plain | 92785 | 90066–96781 | 1.00x | 6541 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 154695 | 145059–159624 | 1.67x | 38449 | 5.88x | 1 | yes |
| rows-append-1000 | 1 | compose | 114893 | 108235–159969 | 1.24x | 11039 | 1.69x | 10 | yes |
| rows-append-1000 | 1 | fusion | 333186 | 324709–363213 | 3.59x | 21106 | 3.23x | 8 | yes |
| rows-append-1000 | 1 | fusion-charm | 337125 | 324733–357586 | 3.63x | 28697 | 4.39x | 9 | yes |
| rows-append-1000 | 1 | react | 197509 | 182890–204794 | 2.13x | 23250 | 3.55x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 211112 | 204670–221101 | 2.28x | 24831 | 3.80x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 194882 | 187062–245466 | 2.10x | 22929 | 3.51x | 0 | yes |
| rows-append-1000 | 1 | roact | 154480 | 140541–193873 | 1.66x | 33251 | 5.08x | 1 | yes |
| rows-append-1000 | 1 | seam | 169193 | 132172–174314 | 1.82x | 46904 | 7.17x | 8 | yes |
| rows-append-1000 | 1 | signals | 113398 | 105049–136127 | 1.22x | 17333 | 2.65x | 0 | yes |
| rows-append-1000 | 1 | vide | 109880 | 105801–118108 | 1.18x | 10439 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 18527 | 16907–18839 | 1.00x | 1229 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 36007 | 33409–38031 | 1.94x | 4169 | 3.39x | 0 | yes |
| rows-clear | 1 | compose | 24740 | 22627–26461 | 1.34x | 1886 | 1.53x | 10 | yes |
| rows-clear | 1 | fusion | 79705 | 73076–82516 | 4.30x | 3481 | 2.83x | 0 | yes |
| rows-clear | 1 | fusion-charm | 74539 | 70092–75763 | 4.02x | 7401 | 6.02x | 1 | yes |
| rows-clear | 1 | react | 25631 | 24651–25810 | 1.38x | 4495 | 3.66x | 0 | yes |
| rows-clear | 1 | react-reflex | 27457 | 26167–28205 | 1.48x | 6490 | 5.28x | 43 | yes |
| rows-clear | 1 | react-upstream | 24656 | 23627–26323 | 1.33x | 4484 | 3.65x | 0 | yes |
| rows-clear | 1 | roact | 25133 | 22507–26223 | 1.36x | 4214 | 3.43x | 1 | yes |
| rows-clear | 1 | seam | 32204 | 23919–34765 | 1.74x | 9079 | 7.39x | 1 | yes |
| rows-clear | 1 | signals | 21336 | 21127–22544 | 1.15x | 4450 | 3.62x | 0 | yes |
| rows-clear | 1 | vide | 19814 | 19114–22050 | 1.07x | 1613 | 1.31x | 1 | yes |
| rows-create-1000 | 1 | plain | 93933 | 90501–96926 | 1.00x | 3134 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 146497 | 142422–159294 | 1.56x | 19720 | 6.29x | 8 | yes |
| rows-create-1000 | 1 | compose | 110897 | 106714–125352 | 1.18x | 5819 | 1.86x | 0 | yes |
| rows-create-1000 | 1 | fusion | 191318 | 175346–198788 | 2.04x | 10843 | 3.46x | 9 | yes |
| rows-create-1000 | 1 | fusion-charm | 182242 | 176288–188729 | 1.94x | 14733 | 4.70x | 8 | yes |
| rows-create-1000 | 1 | react | 164681 | 157158–193240 | 1.75x | 8176 | 2.61x | 16 | yes |
| rows-create-1000 | 1 | react-reflex | 175277 | 159126–189950 | 1.87x | 9066 | 2.89x | 28 | yes |
| rows-create-1000 | 1 | react-upstream | 156942 | 151576–164119 | 1.67x | 8144 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 126142 | 118457–142251 | 1.34x | 16921 | 5.40x | 8 | yes |
| rows-create-1000 | 1 | seam | 139705 | 122961–152196 | 1.49x | 23870 | 7.62x | 1 | yes |
| rows-create-1000 | 1 | signals | 107711 | 97536–110599 | 1.15x | 9114 | 2.91x | 0 | yes |
| rows-create-1000 | 1 | vide | 113830 | 107907–127655 | 1.21x | 4964 | 1.58x | 0 | yes |
| rows-create-10000 | 1 | plain | 1112387 | 1104604–1232612 | 1.00x | 29784 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1744629 | 1643366–1766801 | 1.57x | 186570 | 6.26x | 4 | yes |
| rows-create-10000 | 1 | compose | 1363658 | 1344659–1364942 | 1.23x | 55703 | 1.87x | 11 | yes |
| rows-create-10000 | 1 | fusion | 6541659 | 6382761–6562609 | 5.88x | 105034 | 3.53x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6363825 | 6275736–6401325 | 5.72x | 141486 | 4.75x | 4 | yes |
| rows-create-10000 | 1 | react | 4995096 | 4902819–5083946 | 4.49x | 76254 | 2.56x | 600 | yes |
| rows-create-10000 | 1 | react-reflex | 5150956 | 5124105–5237929 | 4.63x | 86052 | 2.89x | 802 | yes |
| rows-create-10000 | 1 | react-upstream | 5073532 | 4911631–5103935 | 4.56x | 78030 | 2.62x | 521 | yes |
| rows-create-10000 | 1 | roact | 1464186 | 1462416–1548271 | 1.32x | 166034 | 5.57x | 0 | yes |
| rows-create-10000 | 1 | seam | 1707937 | 1670492–1751408 | 1.54x | 235112 | 7.89x | 32 | yes |
| rows-create-10000 | 1 | signals | 1284206 | 1264699–1376623 | 1.15x | 89169 | 2.99x | 4 | yes |
| rows-create-10000 | 1 | vide | 1325966 | 1314718–1392130 | 1.19x | 48452 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 767 | 700–935 | 1.00x | 2740 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1306 | 1150–1426 | 1.70x | 18276 | 6.67x | 0 | yes |
| rows-remove-one | 1 | compose | 973 | 870–1167 | 1.27x | 4941 | 1.80x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 64872 | 61878–71735 | 84.62x | 11113 | 4.06x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 60275 | 57341–60687 | 78.62x | 15025 | 5.48x | 1 | yes |
| rows-remove-one | 1 | react | 23364 | 19837–25921 | 30.47x | 15475 | 5.65x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 33724 | 30540–48389 | 43.99x | 16406 | 5.99x | 28 | yes |
| rows-remove-one | 1 | react-upstream | 27338 | 23515–47800 | 35.66x | 15468 | 5.65x | 0 | yes |
| rows-remove-one | 1 | roact | 17412 | 16104–43355 | 22.71x | 16789 | 6.13x | 1 | yes |
| rows-remove-one | 1 | seam | 6408 | 5400–6905 | 8.36x | 23205 | 8.47x | 0 | yes |
| rows-remove-one | 1 | signals | 1507 | 1470–1736 | 1.97x | 8613 | 3.14x | 0 | yes |
| rows-remove-one | 1 | vide | 1102 | 970–1306 | 1.44x | 4561 | 1.66x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–106 | 1.00x | 2695 | 1.00x | 16 | yes |
| rows-swap | 1 | blend | 705 | 700–750 | 7.05x | 18270 | 6.78x | 0 | yes |
| rows-swap | 1 | compose | 300 | 200–450 | 3.00x | 4920 | 1.83x | 10 | yes |
| rows-swap | 1 | fusion | 61626 | 60950–64234 | 616.26x | 9543 | 3.54x | 0 | yes |
| rows-swap | 1 | fusion-charm | 58370 | 57405–59334 | 583.70x | 14531 | 5.39x | 1 | yes |
| rows-swap | 1 | react | 53622 | 50130–60879 | 536.22x | 15449 | 5.73x | 0 | yes |
| rows-swap | 1 | react-reflex | 63804 | 53136–72352 | 638.04x | 16386 | 6.08x | 28 | yes |
| rows-swap | 1 | react-upstream | 58429 | 54552–64396 | 584.29x | 14993 | 5.56x | 0 | yes |
| rows-swap | 1 | roact | 15816 | 15015–40440 | 158.16x | 16291 | 6.04x | 0 | yes |
| rows-swap | 1 | seam | 5343 | 4600–7205 | 53.43x | 23219 | 8.62x | 1 | yes |
| rows-swap | 1 | signals | 607 | 472–668 | 6.07x | 8618 | 3.20x | 8 | yes |
| rows-swap | 1 | vide | 150 | 150–250 | 1.50x | 4500 | 1.67x | 0 | yes |
| rows-update-every-10th | 1 | plain | 1900 | 1803–1945 | 1.00x | 3183 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1962 | 1900–2000 | 1.03x | 19272 | 6.05x | 0 | yes |
| rows-update-every-10th | 1 | compose | 1936 | 1767–2004 | 1.02x | 5458 | 1.71x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 2102 | 1803–2215 | 1.11x | 10552 | 3.32x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2603 | 2401–2900 | 1.37x | 14472 | 4.55x | 1 | yes |
| rows-update-every-10th | 1 | react | 2106 | 2000–2200 | 1.11x | 7846 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 4200 | 3802–4464 | 2.21x | 8814 | 2.77x | 5 | yes |
| rows-update-every-10th | 1 | react-upstream | 2054 | 1902–2150 | 1.08x | 7845 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | roact | 1964 | 1902–2055 | 1.03x | 16682 | 5.24x | 0 | yes |
| rows-update-every-10th | 1 | seam | 4306 | 3700–5220 | 2.27x | 24220 | 7.61x | 8 | yes |
| rows-update-every-10th | 1 | signals | 2139 | 2073–2233 | 1.13x | 9353 | 2.94x | 1 | yes |
| rows-update-every-10th | 1 | vide | 1982 | 1907–2074 | 1.04x | 5125 | 1.61x | 1 | yes |

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
| blend | 29 | 2.42x | 10.87x | 2.40x | 10.56x |
| compose | 30 | 1.79x | 3.58x | 1.74x | 3.51x |
| fusion | 30 | 6.63x | 5.51x | 6.03x | 5.49x |
| fusion-charm | 30 | 6.18x | 6.33x | 5.59x | 6.37x |
| react | 29 | 4.96x | 5.96x | 4.82x | 6.31x |
| react-reflex | 29 | 5.51x | 8.88x | 5.36x | 9.45x |
| react-upstream | 29 | 4.96x | 5.92x | 4.81x | 6.27x |
| roact | 29 | 2.72x | 5.19x | 2.71x | 5.83x |
| seam | 30 | 3.88x | 11.22x | 3.64x | 11.05x |
| signals | 29 | 1.78x | 2.55x | 1.71x | 2.54x |
| vide | 30 | 1.85x | 2.69x | 1.78x | 2.68x |
