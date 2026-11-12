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
| Harness revision | `929dd0c` |
| Date | 2026-11-12 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 300–400 | 1.00x | 58 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 1200 | 500–1326 | 4.00x | 781 | 13.47x | 8 | yes |
| update-leaf | 20 | compose | 912 | 602–1178 | 3.04x | 93 | 1.60x | 2 | yes |
| update-leaf | 20 | fusion | 928 | 806–1136 | 3.09x | 59 | 1.02x | 8 | yes |
| update-leaf | 20 | fusion-charm | 1107 | 800–1400 | 3.69x | 62 | 1.07x | 8 | yes |
| update-leaf | 20 | react | 1124 | 1009–1301 | 3.75x | 348 | 6.00x | 0 | yes |
| update-leaf | 20 | react-reflex | 1002 | 806–1305 | 3.34x | 301 | 5.19x | 1 | yes |
| update-leaf | 20 | react-upstream | 1109 | 659–1305 | 3.70x | 292 | 5.03x | 0 | yes |
| update-leaf | 20 | roact | 922 | 514–1157 | 3.07x | 960 | 16.55x | 9 | yes |
| update-leaf | 20 | seam | 1441 | 1206–1503 | 4.80x | 40 | 0.69x | 0 | yes |
| update-leaf | 20 | signals | 1100 | 703–1473 | 3.67x | 51 | 0.88x | 1 | yes |
| update-leaf | 20 | vide | 800 | 602–1239 | 2.67x | 0 | 0.02x | 0 | yes |
| update-batched | 20 | plain | 4612 | 4174–5108 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 11242 | 10606–11322 | 2.44x | 940 | 44.76x | 8 | yes |
| update-batched | 20 | compose | 6918 | 6848–7100 | 1.50x | 407 | 19.38x | 10 | yes |
| update-batched | 20 | fusion | 20396 | 19813–20615 | 4.42x | 509 | 24.24x | 0 | yes |
| update-batched | 20 | fusion-charm | 34435 | 33523–36434 | 7.47x | 1109 | 52.81x | 0 | yes |
| update-batched | 20 | react | 7512 | 7341–7988 | 1.63x | 533 | 25.38x | 0 | yes |
| update-batched | 20 | react-reflex | 54013 | 52748–59049 | 11.71x | 775 | 36.90x | 8 | yes |
| update-batched | 20 | react-upstream | 7812 | 7405–8154 | 1.69x | 477 | 22.71x | 1 | yes |
| update-batched | 20 | roact | 8262 | 7951–8353 | 1.79x | 1162 | 55.33x | 0 | yes |
| update-batched | 20 | seam | 11939 | 11218–12828 | 2.59x | 1817 | 86.52x | 1 | yes |
| update-batched | 20 | signals | 9257 | 8912–9612 | 2.01x | 597 | 28.43x | 0 | yes |
| update-batched | 20 | vide | 8653 | 8026–9059 | 1.88x | 332 | 15.81x | 0 | yes |
| update-repeated | 10 | plain | 53 | 47–57 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3365 | 3266–3501 | 63.73x | 7 | 3.50x | 0 | yes |
| update-repeated | 10 | compose | 356 | 300–551 | 6.75x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 25841 | 24257–26821 | 489.42x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion-charm | 1108 | 1063–1308 | 20.99x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 6972 | 6747–7200 | 132.05x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 722 | 407–940 | 13.67x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 7364 | 7002–7431 | 139.47x | 9 | 4.50x | 8 | yes |
| update-repeated | 10 | roact | 5020 | 5000–5214 | 95.08x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1530 | 1207–1908 | 28.98x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 808 | 754–908 | 15.30x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | vide | 410 | 350–514 | 7.77x | 0 | 0.50x | 0 | yes |
| branch-swap | 20 | plain | 15227 | 13709–16742 | 1.00x | 1 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 18327 | 17860–18758 | 1.20x | 35 | 35.00x | 0 | yes |
| branch-swap | 20 | compose | 15597 | 14936–16015 | 1.02x | 7 | 7.00x | 0 | yes |
| branch-swap | 20 | fusion | 16088 | 15539–16713 | 1.06x | 5 | 5.00x | 0 | yes |
| branch-swap | 20 | fusion-charm | 15634 | 15142–18366 | 1.03x | 7 | 7.00x | 0 | yes |
| branch-swap | 20 | react | 17400 | 16467–18722 | 1.14x | 10 | 10.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 18607 | 17557–18973 | 1.22x | 11 | 11.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 18161 | 17810–18994 | 1.19x | 18 | 18.00x | 0 | yes |
| branch-swap | 20 | roact | 16159 | 16025–16583 | 1.06x | 19 | 19.00x | 0 | yes |
| branch-swap | 20 | seam | 13541 | 13000–15835 | 0.89x | 20 | 20.00x | 8 | yes |
| branch-swap | 20 | signals | 14472 | 14360–14827 | 0.95x | 13 | 13.00x | 1 | yes |
| branch-swap | 20 | vide | 15499 | 15418–17125 | 1.02x | 5 | 5.00x | 0 | yes |
| keyed-prepend | 10 | plain | 2436 | 2368–2708 | 1.00x | 64 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 4702 | 4572–5016 | 1.93x | 1482 | 23.16x | 0 | yes |
| keyed-prepend | 10 | compose | 4212 | 4100–4354 | 1.73x | 579 | 9.05x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 22663 | 21125–23241 | 9.30x | 1519 | 23.73x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 21435 | 20311–22810 | 8.80x | 1522 | 23.78x | 0 | yes |
| keyed-prepend | 10 | react | 15601 | 15218–16715 | 6.40x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16006 | 15102–16514 | 6.57x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16228 | 15774–16557 | 6.66x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | roact | 6927 | 6634–7210 | 2.84x | 369 | 5.77x | 8 | yes |
| keyed-prepend | 10 | seam | 11158 | 11034–11715 | 4.58x | 2439 | 38.11x | 0 | yes |
| keyed-prepend | 10 | signals | 2854 | 2734–3050 | 1.17x | 70 | 1.09x | 1 | yes |
| keyed-prepend | 10 | vide | 4936 | 4600–5077 | 2.03x | 638 | 9.97x | 0 | yes |
| keyed-insert | 10 | plain | 1775 | 1675–1900 | 1.00x | 57 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4206 | 3946–4209 | 2.37x | 1490 | 26.14x | 0 | yes |
| keyed-insert | 10 | compose | 3110 | 2950–3278 | 1.75x | 563 | 9.88x | 0 | yes |
| keyed-insert | 10 | fusion (workaround) | 19613 | 19307–20625 | 11.05x | 1528 | 26.81x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 17506 | 17013–17902 | 9.86x | 1521 | 26.68x | 1 | yes |
| keyed-insert | 10 | react | 14026 | 13100–14135 | 7.90x | 811 | 14.23x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13409 | 12278–14114 | 7.55x | 875 | 15.35x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13689 | 13439–14235 | 7.71x | 811 | 14.23x | 0 | yes |
| keyed-insert | 10 | roact | 5618 | 5501–6083 | 3.17x | 370 | 6.49x | 0 | yes |
| keyed-insert | 10 | seam | 10405 | 10022–10622 | 5.86x | 2456 | 43.09x | 8 | yes |
| keyed-insert | 10 | signals | 1854 | 1752–2228 | 1.04x | 62 | 1.09x | 1 | yes |
| keyed-insert | 10 | vide | 3452 | 3311–3720 | 1.94x | 638 | 11.19x | 1 | yes |
| keyed-shuffle | 10 | plain | 1754 | 1653–1900 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2958 | 2650–3227 | 1.69x | 1441 | 24.02x | 1 | yes |
| keyed-shuffle | 10 | compose | 2855 | 2804–3120 | 1.63x | 570 | 9.50x | 10 | yes |
| keyed-shuffle | 10 | fusion | 18955 | 16714–19806 | 10.81x | 1391 | 23.18x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 17933 | 17021–18733 | 10.23x | 1400 | 23.33x | 0 | yes |
| keyed-shuffle | 10 | react | 27240 | 26525–27445 | 15.53x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27420 | 26324–28304 | 15.64x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27329 | 27117–28718 | 15.58x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | roact | 5409 | 5300–5736 | 3.08x | 360 | 6.00x | 1 | yes |
| keyed-shuffle | 10 | seam | 9801 | 8901–10165 | 5.59x | 2438 | 40.63x | 0 | yes |
| keyed-shuffle | 10 | signals | 2113 | 1948–2369 | 1.20x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | vide | 3552 | 3306–3954 | 2.03x | 633 | 10.55x | 0 | yes |
| events | 1 | plain | 1174 | 1001–1793 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 1305 | 1000–1806 | 1.11x | 2 | 1.00x | 0 | yes |
| events | 1 | compose | 1239 | 900–1404 | 1.06x | 2 | 1.00x | 0 | yes |
| events | 1 | fusion | 1300 | 1184–1543 | 1.11x | 1 | 0.50x | 1 | yes |
| events | 1 | fusion-charm | 1411 | 1015–1616 | 1.20x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 1616 | 1111–1706 | 1.38x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 1516 | 1215–1930 | 1.29x | 0 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 1427 | 1200–2100 | 1.22x | 0 | 0.50x | 0 | yes |
| events | 1 | roact | 1102 | 857–1214 | 0.94x | 1 | 0.50x | 0 | yes |
| events | 1 | seam | 802 | 745–1400 | 0.68x | 0 | 0.50x | 0 | yes |
| events | 1 | signals | 1047 | 700–1318 | 0.89x | 1 | 0.50x | 1 | yes |
| events | 1 | vide | 1100 | 950–1110 | 0.94x | 1 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 3075 | 2423–3220 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 10738 | 10597–11810 | 3.49x | 1771 | 23.93x | 0 | yes |
| animate-many | 1 | compose | 6125 | 5722–6641 | 1.99x | 647 | 8.74x | 12 | yes |
| animate-many | 1 | fusion | 105706 | 104452–106576 | 34.38x | 1120 | 15.14x | 0 | yes |
| animate-many | 1 | fusion-charm | 106416 | 103708–106828 | 34.61x | 1130 | 15.27x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20558 | 19351–22064 | 6.69x | 2890 | 39.05x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8115 | 7725–8237 | 2.64x | 392 | 5.30x | 0 | yes |
| status-panel | 10 | plain | 670 | 612–750 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1280 | 1050–1414 | 1.91x | 62 | 31.00x | 0 | yes |
| status-panel | 10 | compose | 1162 | 1104–1370 | 1.73x | 33 | 16.50x | 2 | yes |
| status-panel | 10 | fusion | 1706 | 1352–1902 | 2.55x | 64 | 32.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 1682 | 1465–2158 | 2.51x | 69 | 34.50x | 0 | yes |
| status-panel | 10 | react | 2385 | 2016–2522 | 3.56x | 43 | 21.50x | 1 | yes |
| status-panel | 10 | react-reflex | 2288 | 1968–2396 | 3.42x | 45 | 22.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2110 | 2050–2412 | 3.15x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | roact | 1302 | 1200–1355 | 1.94x | 33 | 16.50x | 0 | yes |
| status-panel | 10 | seam | 2122 | 1943–2166 | 3.17x | 141 | 70.50x | 0 | yes |
| status-panel | 10 | signals | 1020 | 980–1164 | 1.52x | 15 | 7.50x | 0 | yes |
| status-panel | 10 | vide | 1250 | 954–1286 | 1.87x | 32 | 16.00x | 0 | yes |
| scene-3d | 10 | plain | 2703 | 2570–3003 | 1.00x | 3 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4576 | 4362–4713 | 1.69x | 542 | 180.67x | 1 | yes |
| scene-3d | 10 | compose | 3012 | 2962–3405 | 1.11x | 195 | 65.00x | 2 | yes |
| scene-3d | 10 | fusion | 34120 | 33254–35226 | 12.62x | 520 | 173.33x | 0 | yes |
| scene-3d | 10 | fusion-charm | 31225 | 30737–33524 | 11.55x | 515 | 171.67x | 0 | yes |
| scene-3d | 10 | react | 3455 | 3410–4002 | 1.28x | 223 | 74.33x | 0 | yes |
| scene-3d | 10 | react-reflex | 3184 | 3050–3352 | 1.18x | 225 | 75.00x | 1 | yes |
| scene-3d | 10 | react-upstream | 3524 | 3421–3722 | 1.30x | 222 | 74.00x | 0 | yes |
| scene-3d | 10 | roact | 3404 | 3050–3518 | 1.26x | 567 | 189.00x | 0 | yes |
| scene-3d | 10 | seam | 8722 | 8206–10035 | 3.23x | 1755 | 585.00x | 0 | yes |
| scene-3d | 10 | signals | 5930 | 5508–6212 | 2.19x | 682 | 227.33x | 8 | yes |
| scene-3d | 10 | vide | 3906 | 3722–4138 | 1.45x | 211 | 70.33x | 1 | yes |
| derived-diamond | 3 | plain | 22 | 22–47 | 1.00x | 3 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 125 | 125–175 | 5.58x | 20 | 6.67x | 0 | yes |
| derived-diamond | 3 | compose | 101 | 100–125 | 4.52x | 6 | 2.00x | 0 | yes |
| derived-diamond | 3 | fusion | 100 | 100–175 | 4.46x | 8 | 2.67x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 150 | 128–200 | 6.69x | 18 | 6.00x | 8 | yes |
| derived-diamond | 3 | react | 333 | 267–433 | 14.87x | 6 | 2.00x | 4 | yes |
| derived-diamond | 3 | react-reflex | 343 | 200–480 | 15.31x | 17 | 5.67x | 6 | yes |
| derived-diamond | 3 | react-upstream | 346 | 268–537 | 15.42x | 7 | 2.33x | 4 | yes |
| derived-diamond | 3 | roact | 125 | 103–134 | 5.58x | 11 | 3.67x | 0 | yes |
| derived-diamond | 3 | seam | 150 | 100–200 | 6.69x | 21 | 7.00x | 0 | yes |
| derived-diamond | 3 | signals | 150 | 125–179 | 6.69x | 10 | 3.33x | 0 | yes |
| derived-diamond | 3 | vide | 103 | 100–152 | 4.60x | 0 | 0.33x | 0 | yes |
| derived-chain-100 | 3 | plain | 61 | 55–72 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 151 | 130–300 | 2.47x | 131 | 2.30x | 0 | yes |
| derived-chain-100 | 3 | fusion | 950 | 900–1054 | 15.56x | 127 | 2.23x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 903 | 900–983 | 14.79x | 129 | 2.26x | 0 | yes |
| derived-chain-100 | 3 | react | 568 | 533–713 | 9.30x | 68 | 1.19x | 19 | yes |
| derived-chain-100 | 3 | react-reflex | 574 | 433–667 | 9.40x | 80 | 1.40x | 15 | yes |
| derived-chain-100 | 3 | react-upstream | 636 | 467–691 | 10.41x | 69 | 1.21x | 11 | yes |
| derived-chain-100 | 3 | roact | 150 | 125–213 | 2.46x | 10 | 0.18x | 3 | yes |
| derived-chain-100 | 3 | seam | 705 | 600–857 | 11.55x | 271 | 4.75x | 0 | yes |
| derived-chain-100 | 3 | signals | 305 | 176–458 | 4.99x | 174 | 3.05x | 0 | yes |
| derived-chain-100 | 3 | vide | 125 | 102–210 | 2.05x | 93 | 1.63x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–115 | 1.00x | 497 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 264 | 225–306 | 2.64x | 1535 | 3.09x | 8 | yes |
| derived-fan-in-1000 | 3 | compose | 304 | 250–375 | 3.04x | 688 | 1.38x | 9 | yes |
| derived-fan-in-1000 | 3 | fusion | 2080 | 1948–2139 | 20.80x | 897 | 1.80x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2335 | 2034–2473 | 23.35x | 2814 | 5.66x | 1 | yes |
| derived-fan-in-1000 | 3 | react | 2764 | 2502–3600 | 27.64x | 671 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7800 | 7205–7826 | 78.00x | 5629 | 11.33x | 78 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2600 | 2408–2879 | 26.00x | 663 | 1.33x | 43 | yes |
| derived-fan-in-1000 | 3 | roact | 476 | 409–639 | 4.76x | 105 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2950 | 2803–3122 | 29.50x | 2954 | 5.94x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 773 | 650–808 | 7.73x | 1213 | 2.44x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 550 | 475–590 | 5.50x | 520 | 1.05x | 0 | yes |
| filter-as-you-type | 1 | plain | 9605 | 8327–10042 | 1.00x | 35 | 1.00x | 1 | yes |
| filter-as-you-type | 1 | blend | 16925 | 16041–17403 | 1.76x | 2645 | 75.57x | 0 | yes |
| filter-as-you-type | 1 | compose | 10805 | 10633–11217 | 1.12x | 841 | 24.03x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 27429 | 26494–29937 | 2.86x | 2465 | 70.43x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26313 | 25617–27697 | 2.74x | 2451 | 70.03x | 1 | yes |
| filter-as-you-type | 1 | react | 21838 | 20639–22115 | 2.27x | 84 | 2.40x | 20 | yes |
| filter-as-you-type | 1 | react-reflex | 21510 | 19424–21910 | 2.24x | 822 | 23.49x | 14 | yes |
| filter-as-you-type | 1 | react-upstream | 20897 | 20513–22176 | 2.18x | 67 | 1.91x | 11 | yes |
| filter-as-you-type | 1 | roact | 11705 | 11208–12330 | 1.22x | 503 | 14.37x | 4 | yes |
| filter-as-you-type | 1 | seam | 24117 | 20733–26415 | 2.51x | 3980 | 113.71x | 1 | yes |
| filter-as-you-type | 1 | signals | 7703 | 7406–8204 | 0.80x | 36 | 1.03x | 1 | yes |
| filter-as-you-type | 1 | vide | 11018 | 10405–11401 | 1.15x | 960 | 27.43x | 1 | yes |
| theme-propagation | 3 | plain | 58257 | 56226–58671 | 1.00x | 205 | 1.00x | 7 | yes |
| theme-propagation | 3 | blend | 57845 | 56635–59399 | 0.99x | 2070 | 10.10x | 1 | yes |
| theme-propagation | 3 | compose | 62364 | 60482–62917 | 1.07x | 572 | 2.79x | 2 | yes |
| theme-propagation | 3 | fusion | 62611 | 62507–69889 | 1.07x | 875 | 4.27x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 61175 | 59866–64150 | 1.05x | 877 | 4.28x | 1 | yes |
| theme-propagation | 3 | react | 64114 | 63845–65600 | 1.10x | 2027 | 9.89x | 0 | yes |
| theme-propagation | 3 | react-reflex | 56356 | 55790–58440 | 0.97x | 2028 | 9.89x | 0 | yes |
| theme-propagation | 3 | react-upstream | 64017 | 63195–65671 | 1.10x | 2027 | 9.89x | 0 | yes |
| theme-propagation | 3 | roact | 62266 | 61970–64655 | 1.07x | 3287 | 16.03x | 8 | yes |
| theme-propagation | 3 | seam | 56663 | 56045–57333 | 0.97x | 3485 | 17.00x | 0 | yes |
| theme-propagation | 3 | signals | 64051 | 62298–64561 | 1.10x | 895 | 4.37x | 1 | yes |
| theme-propagation | 3 | vide | 62301 | 61784–65752 | 1.07x | 597 | 2.91x | 0 | yes |
| hud-per-frame | 1 | plain | 2659 | 2546–2942 | 1.00x | 22 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5384 | 5364–5965 | 2.02x | 68 | 3.07x | 0 | yes |
| hud-per-frame | 1 | compose | 4497 | 4387–4853 | 1.69x | 31 | 1.41x | 1 | yes |
| hud-per-frame | 1 | fusion | 11478 | 10527–12171 | 4.32x | 54 | 2.43x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 14141 | 13903–14375 | 5.32x | 95 | 4.32x | 0 | yes |
| hud-per-frame | 1 | react | 4838 | 3457–4852 | 1.82x | 26 | 1.16x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7555 | 7285–7950 | 2.84x | 50 | 2.25x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 4884 | 4242–5917 | 1.84x | 30 | 1.36x | 0 | yes |
| hud-per-frame | 1 | roact | 5062 | 4565–5356 | 1.90x | 93 | 4.23x | 0 | yes |
| hud-per-frame | 1 | seam | 9018 | 8448–10079 | 3.39x | 165 | 7.50x | 0 | yes |
| hud-per-frame | 1 | signals | 5791 | 4568–6337 | 2.18x | 68 | 3.11x | 4 | yes |
| hud-per-frame | 1 | vide | 4262 | 4246–4531 | 1.60x | 18 | 0.84x | 0 | yes |
| teardown-under-load | 1 | plain | 47416 | 42364–49397 | 1.00x | 4 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 71085 | 60766–77289 | 1.50x | 14 | 3.50x | 0 | yes |
| teardown-under-load | 1 | compose | 54854 | 47776–55190 | 1.16x | 7 | 1.75x | 2 | yes |
| teardown-under-load | 1 | fusion | 78085 | 71631–81537 | 1.65x | 4 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 73432 | 72387–80791 | 1.55x | 6 | 1.50x | 0 | yes |
| teardown-under-load | 1 | react | 76263 | 71804–78741 | 1.61x | 1077 | 269.25x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 71332 | 70487–75731 | 1.50x | 1063 | 265.75x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 75861 | 70569–76638 | 1.60x | 1077 | 269.25x | 0 | yes |
| teardown-under-load | 1 | roact | 67455 | 58120–71674 | 1.42x | 71 | 17.75x | 0 | yes |
| teardown-under-load | 1 | seam | 59174 | 55078–63541 | 1.25x | 15 | 3.75x | 14 | yes |
| teardown-under-load | 1 | signals | 55056 | 50039–55946 | 1.16x | 4 | 1.00x | 8 | yes |
| teardown-under-load | 1 | vide | 57806 | 49965–58879 | 1.22x | 12 | 3.00x | 0 | yes |
| open-close-retention | 1 | plain | 67030 | 66544–67576 | 1.00x | 23 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 120419 | 119487–121719 | 1.80x | 14 | 0.61x | 0 | yes |
| open-close-retention | 1 | compose | 82223 | 81478–84022 | 1.23x | 15 | 0.65x | 2 | yes |
| open-close-retention | 1 | fusion | 135598 | 134410–136264 | 2.02x | 13 | 0.57x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 135874 | 134164–139797 | 2.03x | 7 | 0.30x | 1 | yes |
| open-close-retention | 1 | react | 118163 | 118007–119565 | 1.76x | 300 | 13.02x | 5 | yes |
| open-close-retention | 1 | react-reflex | 115242 | 112553–116601 | 1.72x | 281 | 12.22x | 0 | yes |
| open-close-retention | 1 | react-upstream | 117692 | 117371–118849 | 1.76x | 291 | 12.65x | 0 | yes |
| open-close-retention | 1 | roact | 108747 | 108698–108903 | 1.62x | 31 | 1.35x | 8 | yes |
| open-close-retention | 1 | seam | 113337 | 109230–113344 | 1.69x | 9 | 0.39x | 1 | yes |
| open-close-retention | 1 | signals | 84549 | 81887–86522 | 1.26x | 12 | 0.52x | 0 | yes |
| open-close-retention | 1 | vide | 90091 | 88592–90278 | 1.34x | 9 | 0.39x | 1 | yes |
| tree-expand-collapse | 1 | plain | 11670 | 9524–13104 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 20828 | 18727–21262 | 1.78x | 788 | 39.40x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12123 | 11704–12610 | 1.04x | 80 | 4.00x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25064 | 24304–27048 | 2.15x | 157 | 7.85x | 0 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23234 | 22559–26924 | 1.99x | 175 | 8.75x | 1 | yes |
| tree-expand-collapse | 1 | react | 19622 | 18516–19949 | 1.68x | 77 | 3.85x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 19890 | 18951–20240 | 1.70x | 681 | 34.05x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 19231 | 18511–21309 | 1.65x | 69 | 3.45x | 19 | yes |
| tree-expand-collapse | 1 | roact | 11346 | 11200–11704 | 0.97x | 35 | 1.75x | 0 | yes |
| tree-expand-collapse | 1 | seam | 27159 | 24679–27925 | 2.33x | 141 | 7.05x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8225 | 7708–8620 | 0.70x | 21 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11459 | 11230–11840 | 0.98x | 71 | 3.55x | 1 | yes |
| form-validation | 1 | plain | 3105 | 2533–3208 | 1.00x | 54 | 1.00x | 1 | yes |
| form-validation | 1 | blend | 4327 | 4008–5479 | 1.39x | 336 | 6.22x | 0 | yes |
| form-validation | 1 | compose | 4247 | 4125–4816 | 1.37x | 106 | 1.96x | 2 | yes |
| form-validation | 1 | fusion | 5872 | 5250–6391 | 1.89x | 118 | 2.19x | 0 | yes |
| form-validation | 1 | fusion-charm | 5870 | 5636–6852 | 1.89x | 163 | 3.02x | 8 | yes |
| form-validation | 1 | react | 5727 | 5173–6163 | 1.84x | 57 | 1.06x | 0 | yes |
| form-validation | 1 | react-reflex | 5997 | 5864–6935 | 1.93x | 76 | 1.41x | 1 | yes |
| form-validation | 1 | react-upstream | 5801 | 5442–6092 | 1.87x | 66 | 1.22x | 0 | yes |
| form-validation | 1 | roact | 5245 | 4855–6255 | 1.69x | 216 | 4.00x | 0 | yes |
| form-validation | 1 | seam | 7006 | 6348–7352 | 2.26x | 357 | 6.61x | 1 | yes |
| form-validation | 1 | signals | 4537 | 4312–4805 | 1.46x | 155 | 2.87x | 0 | yes |
| form-validation | 1 | vide | 4569 | 3883–5306 | 1.47x | 70 | 1.30x | 0 | yes |
| table-sort-filter | 1 | plain | 17418 | 17122–20931 | 1.00x | 66 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 35728 | 34163–46494 | 2.05x | 5380 | 81.52x | 0 | yes |
| table-sort-filter | 1 | compose | 26628 | 24257–27848 | 1.53x | 1632 | 24.73x | 18 | yes |
| table-sort-filter | 1 | fusion (workaround) | 57238 | 51543–58073 | 3.29x | 4695 | 71.14x | 0 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 52927 | 51964–54387 | 3.04x | 4722 | 71.55x | 9 | yes |
| table-sort-filter | 1 | react | 97534 | 88215–100698 | 5.60x | 2109 | 31.95x | 11 | yes |
| table-sort-filter | 1 | react-reflex | 94000 | 90337–99867 | 5.40x | 2115 | 32.05x | 23 | yes |
| table-sort-filter | 1 | react-upstream | 97501 | 95063–98696 | 5.60x | 2108 | 31.94x | 19 | yes |
| table-sort-filter | 1 | roact | 25332 | 23320–26142 | 1.45x | 1007 | 15.26x | 4 | yes |
| table-sort-filter | 1 | seam | 57487 | 50553–63088 | 3.30x | 7960 | 120.61x | 1 | yes |
| table-sort-filter | 1 | signals | 18203 | 17331–18328 | 1.05x | 75 | 1.14x | 1 | yes |
| table-sort-filter | 1 | vide | 25832 | 25136–26629 | 1.48x | 1914 | 29.00x | 0 | yes |
| library-load | 1 | plain | 36 | 30–152 | 1.00x | 2 | 1.00x | 1 | yes |
| library-load | 1 | blend | 746 | 715–843 | 20.99x | 467 | 233.50x | 455 | yes |
| library-load | 1 | compose | 669 | 655–732 | 18.81x | 67 | 33.50x | 63 | yes |
| library-load | 1 | fusion | 1471 | 1155–1535 | 41.38x | 263 | 131.50x | 262 | yes |
| library-load | 1 | fusion-charm | 1447 | 1296–2000 | 40.72x | 318 | 159.00x | 309 | yes |
| library-load | 1 | react | 5025 | 4546–5062 | 141.39x | 1817 | 908.50x | 1816 | yes |
| library-load | 1 | react-reflex | 4997 | 4692–5669 | 140.58x | 1981 | 990.50x | 1980 | yes |
| library-load | 1 | react-upstream | 4886 | 4677–5415 | 137.48x | 1994 | 997.00x | 1993 | yes |
| library-load | 1 | roact | 431 | 354–505 | 12.13x | 153 | 76.50x | 158 | yes |
| library-load | 1 | seam | 1347 | 1239–1640 | 37.90x | 234 | 117.00x | 233 | yes |
| library-load | 1 | signals | 247 | 215–251 | 6.96x | 34 | 17.00x | 33 | yes |
| library-load | 1 | vide | 338 | 333–349 | 9.51x | 154 | 77.00x | 146 | yes |
| rows-append-1000 | 1 | plain | 104796 | 100483–106104 | 1.00x | 6548 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 175461 | 167381–178392 | 1.67x | 38442 | 5.87x | 0 | yes |
| rows-append-1000 | 1 | compose | 126728 | 120034–166667 | 1.21x | 11039 | 1.69x | 3 | yes |
| rows-append-1000 | 1 | fusion | 368136 | 339458–384318 | 3.51x | 21210 | 3.24x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 352940 | 340728–355736 | 3.37x | 28649 | 4.38x | 0 | yes |
| rows-append-1000 | 1 | react | 203415 | 194200–251684 | 1.94x | 23241 | 3.55x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 225159 | 202384–252614 | 2.15x | 24862 | 3.80x | 20 | yes |
| rows-append-1000 | 1 | react-upstream | 210438 | 203064–229116 | 2.01x | 23041 | 3.52x | 144 | yes |
| rows-append-1000 | 1 | roact | 164230 | 158677–206174 | 1.57x | 33131 | 5.06x | 0 | yes |
| rows-append-1000 | 1 | seam | 180469 | 164433–190114 | 1.72x | 46495 | 7.10x | 1 | yes |
| rows-append-1000 | 1 | signals | 122689 | 115782–152110 | 1.17x | 17286 | 2.64x | 1 | yes |
| rows-append-1000 | 1 | vide | 128084 | 125200–158395 | 1.22x | 10431 | 1.59x | 8 | yes |
| rows-clear | 1 | plain | 17332 | 16517–18122 | 1.00x | 1229 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 35433 | 33353–37733 | 2.04x | 4170 | 3.39x | 1 | yes |
| rows-clear | 1 | compose | 26249 | 23736–27027 | 1.51x | 1885 | 1.53x | 10 | yes |
| rows-clear | 1 | fusion | 79147 | 74775–82699 | 4.57x | 3489 | 2.84x | 0 | yes |
| rows-clear | 1 | fusion-charm | 76878 | 73073–77832 | 4.44x | 7400 | 6.02x | 8 | yes |
| rows-clear | 1 | react | 25601 | 23118–27436 | 1.48x | 4503 | 3.66x | 8 | yes |
| rows-clear | 1 | react-reflex | 28768 | 24925–34680 | 1.66x | 6506 | 5.29x | 29 | yes |
| rows-clear | 1 | react-upstream | 25915 | 23225–26122 | 1.50x | 4479 | 3.64x | 0 | yes |
| rows-clear | 1 | roact | 24334 | 23855–25851 | 1.40x | 4214 | 3.43x | 8 | yes |
| rows-clear | 1 | seam | 32843 | 20930–36769 | 1.89x | 9287 | 7.56x | 0 | yes |
| rows-clear | 1 | signals | 23112 | 21232–23131 | 1.33x | 4466 | 3.63x | 0 | yes |
| rows-clear | 1 | vide | 20130 | 18521–22038 | 1.16x | 1613 | 1.31x | 8 | yes |
| rows-create-1000 | 1 | plain | 107006 | 99277–109755 | 1.00x | 3120 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 166946 | 155323–169527 | 1.56x | 19577 | 6.27x | 1 | yes |
| rows-create-1000 | 1 | compose | 122004 | 111524–148226 | 1.14x | 5811 | 1.86x | 3 | yes |
| rows-create-1000 | 1 | fusion | 199635 | 181594–216055 | 1.87x | 10802 | 3.46x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 195921 | 183772–202258 | 1.83x | 14677 | 4.70x | 0 | yes |
| rows-create-1000 | 1 | react | 179279 | 163400–207528 | 1.68x | 8143 | 2.61x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 184065 | 179747–202860 | 1.72x | 9090 | 2.91x | 44 | yes |
| rows-create-1000 | 1 | react-upstream | 176162 | 168102–187904 | 1.65x | 8144 | 2.61x | 0 | yes |
| rows-create-1000 | 1 | roact | 141791 | 123599–157467 | 1.33x | 16914 | 5.42x | 1 | yes |
| rows-create-1000 | 1 | seam | 165595 | 141816–169094 | 1.55x | 23902 | 7.66x | 1 | yes |
| rows-create-1000 | 1 | signals | 114780 | 103318–130497 | 1.07x | 9122 | 2.92x | 0 | yes |
| rows-create-1000 | 1 | vide | 121554 | 117547–143173 | 1.14x | 4957 | 1.59x | 1 | yes |
| rows-create-10000 | 1 | plain | 1232203 | 1173141–1361779 | 1.00x | 29800 | 1.00x | 12 | yes |
| rows-create-10000 | 1 | blend | 1824502 | 1804311–1876222 | 1.48x | 186561 | 6.26x | 4 | yes |
| rows-create-10000 | 1 | compose | 1462631 | 1447019–1472962 | 1.19x | 55738 | 1.87x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6638334 | 6537700–6727729 | 5.39x | 100880 | 3.39x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6492967 | 6471138–6575601 | 5.27x | 145032 | 4.87x | 8 | yes |
| rows-create-10000 | 1 | react | 5135519 | 5049589–5351934 | 4.17x | 76683 | 2.57x | 120 | yes |
| rows-create-10000 | 1 | react-reflex | 5384128 | 5353934–5495888 | 4.37x | 85948 | 2.88x | 822 | yes |
| rows-create-10000 | 1 | react-upstream | 5272772 | 5103417–5274185 | 4.28x | 78030 | 2.62x | 464 | yes |
| rows-create-10000 | 1 | roact | 1621642 | 1582203–1668669 | 1.32x | 165882 | 5.57x | 0 | yes |
| rows-create-10000 | 1 | seam | 1771228 | 1710271–1877958 | 1.44x | 234866 | 7.88x | 20 | yes |
| rows-create-10000 | 1 | signals | 1378866 | 1329526–1477565 | 1.12x | 89200 | 2.99x | 4 | yes |
| rows-create-10000 | 1 | vide | 1409348 | 1347764–1554967 | 1.14x | 48452 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 767 | 700–803 | 1.00x | 2741 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1203 | 1174–1400 | 1.57x | 18292 | 6.67x | 9 | yes |
| rows-remove-one | 1 | compose | 1050 | 900–1066 | 1.37x | 4949 | 1.81x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 64649 | 63536–66270 | 84.32x | 11114 | 4.05x | 2 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 60784 | 57678–69039 | 79.28x | 15050 | 5.49x | 9 | yes |
| rows-remove-one | 1 | react | 24109 | 23117–41842 | 31.45x | 15524 | 5.66x | 17 | yes |
| rows-remove-one | 1 | react-reflex | 33619 | 30908–39832 | 43.85x | 16414 | 5.99x | 36 | yes |
| rows-remove-one | 1 | react-upstream | 26981 | 17906–37003 | 35.19x | 15468 | 5.64x | 0 | yes |
| rows-remove-one | 1 | roact | 16726 | 14200–17829 | 21.82x | 16781 | 6.12x | 0 | yes |
| rows-remove-one | 1 | seam | 6013 | 5710–6903 | 7.84x | 23237 | 8.48x | 0 | yes |
| rows-remove-one | 1 | signals | 1601 | 1367–1683 | 2.09x | 8622 | 3.15x | 1 | yes |
| rows-remove-one | 1 | vide | 1205 | 1154–1400 | 1.57x | 4561 | 1.66x | 8 | yes |
| rows-swap | 1 | plain | 100 | 100–133 | 1.00x | 2687 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 800 | 750–860 | 8.00x | 18262 | 6.80x | 0 | yes |
| rows-swap | 1 | compose | 300 | 200–464 | 3.00x | 4911 | 1.83x | 3 | yes |
| rows-swap | 1 | fusion | 60885 | 58651–62353 | 608.85x | 9559 | 3.56x | 8 | yes |
| rows-swap | 1 | fusion-charm | 55556 | 55319–59817 | 555.56x | 14563 | 5.42x | 1 | yes |
| rows-swap | 1 | react | 56140 | 55152–59106 | 561.40x | 15433 | 5.74x | 0 | yes |
| rows-swap | 1 | react-reflex | 63097 | 55334–75992 | 630.97x | 16435 | 6.12x | 36 | yes |
| rows-swap | 1 | react-upstream | 55534 | 54713–85613 | 555.34x | 14993 | 5.58x | 0 | yes |
| rows-swap | 1 | roact | 16021 | 14413–16725 | 160.21x | 16300 | 6.07x | 1 | yes |
| rows-swap | 1 | seam | 5604 | 5125–6406 | 56.04x | 23220 | 8.64x | 1 | yes |
| rows-swap | 1 | signals | 600 | 450–653 | 6.00x | 8609 | 3.20x | 8 | yes |
| rows-swap | 1 | vide | 200 | 100–250 | 2.00x | 4508 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 2200 | 2170–2268 | 1.00x | 3191 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 2302 | 2256–2354 | 1.05x | 19272 | 6.04x | 1 | yes |
| rows-update-every-10th | 1 | compose | 2314 | 2100–2400 | 1.05x | 5466 | 1.71x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 2302 | 2103–2400 | 1.05x | 10567 | 3.31x | 8 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2700 | 2500–2809 | 1.23x | 14480 | 4.54x | 1 | yes |
| rows-update-every-10th | 1 | react | 2400 | 2250–2502 | 1.09x | 7845 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 5010 | 2804–5606 | 2.28x | 8814 | 2.76x | 12 | yes |
| rows-update-every-10th | 1 | react-upstream | 2454 | 2450–2553 | 1.12x | 7854 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | roact | 2401 | 2252–2660 | 1.09x | 16681 | 5.23x | 1 | yes |
| rows-update-every-10th | 1 | seam | 4608 | 3705–5910 | 2.09x | 24172 | 7.58x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2516 | 2400–2600 | 1.14x | 9314 | 2.92x | 0 | yes |
| rows-update-every-10th | 1 | vide | 2454 | 2216–2558 | 1.12x | 5101 | 1.60x | 1 | yes |

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
| blend | 29 | 2.41x | 11.88x | 2.37x | 11.59x |
| compose | 30 | 1.77x | 4.00x | 1.74x | 3.97x |
| fusion | 30 | 6.54x | 6.23x | 5.98x | 6.27x |
| fusion-charm | 30 | 6.03x | 7.91x | 5.49x | 8.08x |
| react | 29 | 5.02x | 6.49x | 4.91x | 6.90x |
| react-reflex | 29 | 5.43x | 9.55x | 5.32x | 10.22x |
| react-upstream | 29 | 5.04x | 7.10x | 4.91x | 7.57x |
| roact | 29 | 2.75x | 6.06x | 2.76x | 6.87x |
| seam | 30 | 3.86x | 12.83x | 3.64x | 12.77x |
| signals | 29 | 1.86x | 2.88x | 1.80x | 2.88x |
| vide | 30 | 1.80x | 2.80x | 1.77x | 2.79x |
