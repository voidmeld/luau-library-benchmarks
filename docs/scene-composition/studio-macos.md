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
| Roblox Studio | 0.745.0.7451137 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `a07c78b` |
| Date | 2026-11-03 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 400 | 300–500 | 1.00x | 57 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 711 | 500–1220 | 1.78x | 773 | 13.56x | 1 | yes |
| update-leaf | 20 | compose | 907 | 500–1431 | 2.27x | 61 | 1.07x | 2 | yes |
| update-leaf | 20 | fusion | 904 | 712–1201 | 2.26x | 51 | 0.89x | 0 | yes |
| update-leaf | 20 | fusion-charm | 1000 | 600–1318 | 2.50x | 62 | 1.09x | 1 | yes |
| update-leaf | 20 | react | 820 | 713–1209 | 2.05x | 348 | 6.11x | 0 | yes |
| update-leaf | 20 | react-reflex | 1011 | 726–1314 | 2.53x | 301 | 5.28x | 8 | yes |
| update-leaf | 20 | react-upstream | 636 | 500–1054 | 1.59x | 300 | 5.26x | 0 | yes |
| update-leaf | 20 | roact | 920 | 600–925 | 2.30x | 944 | 16.56x | 0 | yes |
| update-leaf | 20 | seam | 1370 | 865–2967 | 3.42x | 41 | 0.72x | 1 | yes |
| update-leaf | 20 | signals | 925 | 806–1015 | 2.31x | 50 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 748 | 605–1383 | 1.87x | 0 | 0.02x | 0 | yes |
| update-batched | 20 | plain | 4702 | 4160–5106 | 1.00x | 28 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 11132 | 10693–11518 | 2.37x | 901 | 32.18x | 0 | yes |
| update-batched | 20 | compose | 7142 | 6719–7629 | 1.52x | 383 | 13.68x | 9 | yes |
| update-batched | 20 | fusion | 20925 | 20514–22201 | 4.45x | 508 | 18.14x | 0 | yes |
| update-batched | 20 | fusion-charm | 37921 | 37266–38603 | 8.06x | 1077 | 38.46x | 0 | yes |
| update-batched | 20 | react | 8031 | 7710–8613 | 1.71x | 534 | 19.07x | 1 | yes |
| update-batched | 20 | react-reflex | 55447 | 50603–58772 | 11.79x | 783 | 27.96x | 16 | yes |
| update-batched | 20 | react-upstream | 8071 | 7631–8355 | 1.72x | 477 | 17.04x | 0 | yes |
| update-batched | 20 | roact | 8129 | 7824–8799 | 1.73x | 1169 | 41.75x | 0 | yes |
| update-batched | 20 | seam | 13002 | 12441–13497 | 2.77x | 1833 | 65.46x | 1 | yes |
| update-batched | 20 | signals | 9623 | 9597–9736 | 2.05x | 604 | 21.57x | 8 | yes |
| update-batched | 20 | vide | 8893 | 8470–9381 | 1.89x | 331 | 11.82x | 0 | yes |
| update-repeated | 10 | plain | 48 | 47–51 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3415 | 3374–3510 | 71.48x | 8 | 4.00x | 1 | yes |
| update-repeated | 10 | compose | 312 | 300–603 | 6.53x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion | 25293 | 24753–26331 | 529.38x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1152 | 1108–1314 | 24.12x | 7 | 3.50x | 0 | yes |
| update-repeated | 10 | react | 7307 | 7054–9588 | 152.93x | 1 | 0.50x | 1 | yes |
| update-repeated | 10 | react-reflex | 854 | 705–970 | 17.88x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7120 | 7109–7728 | 149.02x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5125 | 4937–5450 | 107.27x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1703 | 1509–2663 | 35.64x | 10 | 5.00x | 1 | yes |
| update-repeated | 10 | signals | 896 | 603–945 | 18.75x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | vide | 432 | 356–514 | 9.03x | 0 | 0.50x | 0 | yes |
| branch-swap | 20 | plain | 15584 | 14201–16530 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 18081 | 17638–18418 | 1.16x | 35 | 17.50x | 0 | yes |
| branch-swap | 20 | compose | 15147 | 14917–16883 | 0.97x | 0 | 0.50x | 2 | yes |
| branch-swap | 20 | fusion | 15840 | 15538–21441 | 1.02x | 5 | 2.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 15965 | 15411–19212 | 1.02x | 7 | 3.50x | 0 | yes |
| branch-swap | 20 | react | 17829 | 17330–18758 | 1.14x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 18126 | 17528–18855 | 1.16x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 18441 | 17877–19622 | 1.18x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | roact | 15935 | 15718–16313 | 1.02x | 12 | 6.00x | 1 | yes |
| branch-swap | 20 | seam | 13942 | 12725–14949 | 0.89x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | signals | 14241 | 14118–14680 | 0.91x | 4 | 2.00x | 9 | yes |
| branch-swap | 20 | vide | 14950 | 14806–17054 | 0.96x | 13 | 6.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2403 | 2335–2768 | 1.00x | 65 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4437 | 4223–5228 | 1.85x | 1498 | 23.05x | 8 | yes |
| keyed-prepend | 10 | compose | 4084 | 3917–4502 | 1.70x | 501 | 7.71x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 21844 | 21716–23922 | 9.09x | 1527 | 23.49x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 21711 | 20717–21954 | 9.03x | 1513 | 23.28x | 1 | yes |
| keyed-prepend | 10 | react | 16023 | 15668–16343 | 6.67x | 786 | 12.09x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16220 | 15255–16536 | 6.75x | 786 | 12.09x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16131 | 15313–17121 | 6.71x | 792 | 12.18x | 0 | yes |
| keyed-prepend | 10 | roact | 6907 | 6510–7267 | 2.87x | 369 | 5.68x | 0 | yes |
| keyed-prepend | 10 | seam | 11409 | 11074–12225 | 4.75x | 2448 | 37.66x | 8 | yes |
| keyed-prepend | 10 | signals | 2816 | 2720–2968 | 1.17x | 61 | 0.94x | 0 | yes |
| keyed-prepend | 10 | vide | 5031 | 4812–5418 | 2.09x | 639 | 9.83x | 0 | yes |
| keyed-insert | 10 | plain | 1750 | 1654–1827 | 1.00x | 71 | 1.00x | 1 | yes |
| keyed-insert | 10 | blend | 3911 | 3702–3959 | 2.23x | 1490 | 20.99x | 0 | yes |
| keyed-insert | 10 | compose | 2926 | 2755–3118 | 1.67x | 493 | 6.94x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 19623 | 19024–20912 | 11.21x | 1511 | 21.28x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 18506 | 17707–18956 | 10.57x | 1521 | 21.42x | 0 | yes |
| keyed-insert | 10 | react | 13704 | 13316–15704 | 7.83x | 811 | 11.42x | 1 | yes |
| keyed-insert | 10 | react-reflex | 13242 | 12736–13997 | 7.56x | 867 | 12.21x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13769 | 12300–13906 | 7.87x | 811 | 11.42x | 0 | yes |
| keyed-insert | 10 | roact | 5610 | 5451–5801 | 3.20x | 369 | 5.20x | 1 | yes |
| keyed-insert | 10 | seam | 10515 | 10375–11108 | 6.01x | 2455 | 34.58x | 1 | yes |
| keyed-insert | 10 | signals | 2032 | 1797–2118 | 1.16x | 62 | 0.87x | 1 | yes |
| keyed-insert | 10 | vide | 3471 | 3364–3856 | 1.98x | 638 | 8.99x | 0 | yes |
| keyed-shuffle | 10 | plain | 1875 | 1676–2001 | 1.00x | 61 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3082 | 2906–3107 | 1.64x | 1424 | 23.34x | 1 | yes |
| keyed-shuffle | 10 | compose | 3066 | 2862–3970 | 1.63x | 493 | 8.08x | 9 | yes |
| keyed-shuffle | 10 | fusion | 18379 | 18214–19943 | 9.80x | 1391 | 22.80x | 9 | yes |
| keyed-shuffle | 10 | fusion-charm | 18075 | 17146–18426 | 9.64x | 1384 | 22.69x | 0 | yes |
| keyed-shuffle | 10 | react | 27929 | 26465–29730 | 14.90x | 787 | 12.90x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 28241 | 27631–28866 | 15.06x | 780 | 12.79x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27628 | 26640–28886 | 14.73x | 779 | 12.77x | 0 | yes |
| keyed-shuffle | 10 | roact | 5800 | 5672–6427 | 3.09x | 368 | 6.03x | 1 | yes |
| keyed-shuffle | 10 | seam | 10808 | 10023–10927 | 5.76x | 2446 | 40.10x | 8 | yes |
| keyed-shuffle | 10 | signals | 2302 | 2076–2526 | 1.23x | 61 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | vide | 3676 | 3559–4332 | 1.96x | 621 | 10.18x | 0 | yes |
| events | 1 | plain | 1109 | 800–1402 | 1.00x | 10 | 1.00x | 1 | yes |
| events | 1 | blend | 1623 | 1403–1909 | 1.46x | 2 | 0.20x | 0 | yes |
| events | 1 | compose | 1308 | 1098–1505 | 1.18x | 10 | 1.00x | 10 | yes |
| events | 1 | fusion | 1408 | 1149–1701 | 1.27x | 2 | 0.20x | 1 | yes |
| events | 1 | fusion-charm | 1505 | 1102–1908 | 1.36x | 1 | 0.10x | 0 | yes |
| events | 1 | react | 1613 | 1416–2104 | 1.45x | 0 | 0.10x | 0 | yes |
| events | 1 | react-reflex | 1501 | 1100–1705 | 1.35x | 1 | 0.10x | 0 | yes |
| events | 1 | react-upstream | 1554 | 1000–2015 | 1.40x | 1 | 0.10x | 0 | yes |
| events | 1 | roact | 1201 | 907–1841 | 1.08x | 1 | 0.10x | 0 | yes |
| events | 1 | seam | 1100 | 713–1323 | 0.99x | 2 | 0.20x | 0 | yes |
| events | 1 | signals | 1116 | 811–1694 | 1.01x | 1 | 0.10x | 0 | yes |
| events | 1 | vide | 1500 | 1113–1550 | 1.35x | 9 | 0.90x | 1 | yes |
| animate-many | 1 | plain | 2834 | 2700–3400 | 1.00x | 66 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 11454 | 10713–12223 | 4.04x | 1771 | 26.83x | 0 | yes |
| animate-many | 1 | compose | 6555 | 5958–6859 | 2.31x | 642 | 9.73x | 12 | yes |
| animate-many | 1 | fusion | 105294 | 104507–107175 | 37.15x | 1128 | 17.09x | 0 | yes |
| animate-many | 1 | fusion-charm | 106170 | 105416–107524 | 37.46x | 1130 | 17.12x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 21951 | 21327–24045 | 7.75x | 2898 | 43.91x | 1 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8099 | 7569–8661 | 2.86x | 392 | 5.94x | 0 | yes |
| status-panel | 10 | plain | 636 | 601–713 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1377 | 1262–1527 | 2.16x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | compose | 1204 | 1013–1433 | 1.89x | 34 | 17.00x | 0 | yes |
| status-panel | 10 | fusion | 1748 | 1554–1805 | 2.75x | 72 | 36.00x | 8 | yes |
| status-panel | 10 | fusion-charm | 1823 | 1570–1934 | 2.86x | 70 | 35.00x | 1 | yes |
| status-panel | 10 | react | 2210 | 1954–2418 | 3.47x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | react-reflex | 2256 | 2200–2349 | 3.55x | 45 | 22.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2319 | 2127–2972 | 3.64x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | roact | 1373 | 1118–1432 | 2.16x | 24 | 12.00x | 0 | yes |
| status-panel | 10 | seam | 2225 | 1812–2504 | 3.50x | 141 | 70.50x | 1 | yes |
| status-panel | 10 | signals | 1114 | 910–1174 | 1.75x | 15 | 7.50x | 0 | yes |
| status-panel | 10 | vide | 1311 | 1157–1521 | 2.06x | 32 | 16.00x | 0 | yes |
| scene-3d | 10 | plain | 2500 | 2139–2534 | 1.00x | 10 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4340 | 4268–4644 | 1.74x | 582 | 58.20x | 0 | yes |
| scene-3d | 10 | compose | 3216 | 3124–3346 | 1.29x | 178 | 17.80x | 10 | yes |
| scene-3d | 10 | fusion | 31078 | 30839–32268 | 12.43x | 527 | 52.70x | 0 | yes |
| scene-3d | 10 | fusion-charm | 28549 | 28239–29657 | 11.42x | 516 | 51.60x | 1 | yes |
| scene-3d | 10 | react | 3308 | 3128–3611 | 1.32x | 223 | 22.30x | 0 | yes |
| scene-3d | 10 | react-reflex | 3384 | 3058–3447 | 1.35x | 225 | 22.50x | 0 | yes |
| scene-3d | 10 | react-upstream | 3832 | 3664–3928 | 1.53x | 222 | 22.20x | 0 | yes |
| scene-3d | 10 | roact | 3678 | 3507–3863 | 1.47x | 574 | 57.40x | 0 | yes |
| scene-3d | 10 | seam | 9413 | 9314–9646 | 3.76x | 1763 | 176.30x | 1 | yes |
| scene-3d | 10 | signals | 6017 | 5509–6616 | 2.41x | 682 | 68.20x | 0 | yes |
| scene-3d | 10 | vide | 3927 | 3700–4026 | 1.57x | 219 | 21.90x | 1 | yes |
| derived-diamond | 3 | plain | 20 | 17–47 | 1.00x | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 126 | 100–153 | 6.42x | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 125 | 100–129 | 6.36x | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | fusion | 152 | 100–252 | 7.71x | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 129 | 101–226 | 6.56x | 10 | 2.00x | 0 | yes |
| derived-diamond | 3 | react | 375 | 301–534 | 19.01x | 7 | 1.40x | 4 | yes |
| derived-diamond | 3 | react-reflex | 343 | 305–407 | 17.40x | 18 | 3.60x | 7 | yes |
| derived-diamond | 3 | react-upstream | 311 | 267–505 | 15.80x | 6 | 1.20x | 4 | yes |
| derived-diamond | 3 | roact | 129 | 104–201 | 6.55x | 2 | 0.40x | 3 | yes |
| derived-diamond | 3 | seam | 213 | 100–251 | 10.81x | 13 | 2.60x | 0 | yes |
| derived-diamond | 3 | signals | 103 | 101–155 | 5.24x | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 100–128 | 5.07x | 0 | 0.20x | 1 | yes |
| derived-chain-100 | 3 | plain | 55 | 48–69 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 228 | 150–307 | 4.16x | 135 | 2.37x | 2 | yes |
| derived-chain-100 | 3 | fusion | 980 | 952–1025 | 17.92x | 127 | 2.23x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 896 | 784–1056 | 16.39x | 129 | 2.26x | 0 | yes |
| derived-chain-100 | 3 | react | 572 | 567–700 | 10.46x | 76 | 1.33x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 670 | 567–840 | 12.25x | 79 | 1.39x | 13 | yes |
| derived-chain-100 | 3 | react-upstream | 700 | 606–835 | 12.80x | 69 | 1.21x | 4 | yes |
| derived-chain-100 | 3 | roact | 100 | 100–175 | 1.84x | 10 | 0.18x | 3 | yes |
| derived-chain-100 | 3 | seam | 813 | 750–1092 | 14.87x | 280 | 4.91x | 1 | yes |
| derived-chain-100 | 3 | signals | 250 | 200–350 | 4.57x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 151 | 100–236 | 2.76x | 93 | 1.63x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–114 | 1.00x | 497 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 226 | 200–325 | 2.26x | 1527 | 3.07x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 302 | 278–378 | 3.02x | 688 | 1.38x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 2058 | 1968–2372 | 20.58x | 898 | 1.81x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2067 | 1970–2373 | 20.67x | 2822 | 5.68x | 9 | yes |
| derived-fan-in-1000 | 3 | react | 2804 | 2162–3154 | 28.04x | 670 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7200 | 6817–11432 | 72.00x | 5654 | 11.38x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2410 | 2264–2754 | 24.09x | 655 | 1.32x | 43 | yes |
| derived-fan-in-1000 | 3 | roact | 529 | 425–614 | 5.29x | 113 | 0.23x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2600 | 2529–2954 | 26.00x | 2954 | 5.94x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 728 | 652–780 | 7.28x | 1221 | 2.46x | 9 | yes |
| derived-fan-in-1000 | 3 | vide | 500 | 458–507 | 5.00x | 528 | 1.06x | 1 | yes |
| filter-as-you-type | 1 | plain | 8714 | 7805–9202 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 15832 | 15502–17100 | 1.82x | 2654 | 75.83x | 0 | yes |
| filter-as-you-type | 1 | compose | 10632 | 9713–11232 | 1.22x | 747 | 21.34x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 27820 | 25739–28153 | 3.19x | 2505 | 71.57x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26541 | 25243–27442 | 3.05x | 2555 | 73.00x | 1 | yes |
| filter-as-you-type | 1 | react | 21429 | 20284–21987 | 2.46x | 68 | 1.94x | 0 | yes |
| filter-as-you-type | 1 | react-reflex | 20944 | 20366–22042 | 2.40x | 838 | 23.94x | 14 | yes |
| filter-as-you-type | 1 | react-upstream | 22114 | 20828–22268 | 2.54x | 76 | 2.17x | 12 | yes |
| filter-as-you-type | 1 | roact | 11320 | 11114–12133 | 1.30x | 510 | 14.57x | 3 | yes |
| filter-as-you-type | 1 | seam | 20729 | 20220–21721 | 2.38x | 3853 | 110.09x | 0 | yes |
| filter-as-you-type | 1 | signals | 7505 | 7337–8141 | 0.86x | 36 | 1.03x | 1 | yes |
| filter-as-you-type | 1 | vide | 11026 | 10016–11246 | 1.27x | 959 | 27.40x | 0 | yes |
| theme-propagation | 3 | plain | 59339 | 58547–60042 | 1.00x | 199 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 57844 | 57576–59532 | 0.97x | 1998 | 10.04x | 1 | yes |
| theme-propagation | 3 | compose | 63668 | 61435–64603 | 1.07x | 516 | 2.59x | 2 | yes |
| theme-propagation | 3 | fusion | 64388 | 64299–67247 | 1.09x | 811 | 4.08x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 64102 | 62769–64441 | 1.08x | 804 | 4.04x | 0 | yes |
| theme-propagation | 3 | react | 65766 | 65338–66662 | 1.11x | 1971 | 9.90x | 8 | yes |
| theme-propagation | 3 | react-reflex | 57483 | 56379–59775 | 0.97x | 1973 | 9.91x | 0 | yes |
| theme-propagation | 3 | react-upstream | 65602 | 64830–67885 | 1.11x | 1963 | 9.86x | 0 | yes |
| theme-propagation | 3 | roact | 64020 | 62917–64615 | 1.08x | 3199 | 16.08x | 1 | yes |
| theme-propagation | 3 | seam | 55758 | 55405–56089 | 0.94x | 3429 | 17.23x | 8 | yes |
| theme-propagation | 3 | signals | 64914 | 62589–65584 | 1.09x | 879 | 4.42x | 0 | yes |
| theme-propagation | 3 | vide | 63491 | 61149–66239 | 1.07x | 597 | 3.00x | 0 | yes |
| hud-per-frame | 1 | plain | 2636 | 2147–3779 | 1.00x | 30 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5797 | 5345–6255 | 2.20x | 68 | 2.27x | 0 | yes |
| hud-per-frame | 1 | compose | 4135 | 3828–5333 | 1.57x | 32 | 1.05x | 6 | yes |
| hud-per-frame | 1 | fusion | 10729 | 10043–11114 | 4.07x | 52 | 1.72x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 12806 | 12589–13166 | 4.86x | 90 | 3.02x | 0 | yes |
| hud-per-frame | 1 | react | 4384 | 2876–4538 | 1.66x | 34 | 1.12x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 6407 | 6400–6828 | 2.43x | 42 | 1.38x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 4383 | 4133–4595 | 1.66x | 30 | 1.00x | 0 | yes |
| hud-per-frame | 1 | roact | 4474 | 4098–4713 | 1.70x | 94 | 3.13x | 4 | yes |
| hud-per-frame | 1 | seam | 8913 | 7314–9494 | 3.38x | 169 | 5.63x | 0 | yes |
| hud-per-frame | 1 | signals | 5425 | 5202–5461 | 2.06x | 62 | 2.05x | 0 | yes |
| hud-per-frame | 1 | vide | 4648 | 4412–4761 | 1.76x | 25 | 0.83x | 5 | yes |
| teardown-under-load | 1 | plain | 48170 | 41860–50246 | 1.00x | 0 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 71620 | 62523–75236 | 1.49x | 6 | 6.00x | 1 | yes |
| teardown-under-load | 1 | compose | 55573 | 47372–56002 | 1.15x | 7 | 7.00x | 2 | yes |
| teardown-under-load | 1 | fusion | 74743 | 69284–80624 | 1.55x | 5 | 5.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 74976 | 69525–82922 | 1.56x | 6 | 6.00x | 0 | yes |
| teardown-under-load | 1 | react | 72471 | 69713–79057 | 1.50x | 1077 | 1077.00x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 71719 | 64456–83395 | 1.49x | 1078 | 1078.00x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 76340 | 65173–77235 | 1.58x | 1078 | 1078.00x | 0 | yes |
| teardown-under-load | 1 | roact | 69248 | 56558–79178 | 1.44x | 71 | 71.00x | 0 | yes |
| teardown-under-load | 1 | seam | 65200 | 58278–69685 | 1.35x | 8 | 8.00x | 7 | yes |
| teardown-under-load | 1 | signals | 53302 | 48895–57187 | 1.11x | 5 | 5.00x | 1 | yes |
| teardown-under-load | 1 | vide | 58168 | 54242–62527 | 1.21x | 5 | 5.00x | 0 | yes |
| open-close-retention | 1 | plain | 68389 | 68144–68519 | 1.00x | 40 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 121956 | 120760–123352 | 1.78x | 6 | 0.15x | 9 | yes |
| open-close-retention | 1 | compose | 85168 | 83079–86232 | 1.25x | 7 | 0.17x | 1 | yes |
| open-close-retention | 1 | fusion | 137285 | 134145–138276 | 2.01x | 5 | 0.12x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 135806 | 134446–136863 | 1.99x | 7 | 0.17x | 1 | yes |
| open-close-retention | 1 | react | 117825 | 116440–119399 | 1.72x | 292 | 7.30x | 0 | yes |
| open-close-retention | 1 | react-reflex | 117655 | 117142–119140 | 1.72x | 292 | 7.30x | 0 | yes |
| open-close-retention | 1 | react-upstream | 121525 | 118877–123221 | 1.78x | 284 | 7.10x | 0 | yes |
| open-close-retention | 1 | roact | 114446 | 112799–115955 | 1.67x | 31 | 0.78x | 1 | yes |
| open-close-retention | 1 | seam | 114917 | 112442–117878 | 1.68x | 8 | 0.20x | 0 | yes |
| open-close-retention | 1 | signals | 86078 | 83219–88010 | 1.26x | 5 | 0.12x | 0 | yes |
| open-close-retention | 1 | vide | 89090 | 88617–90133 | 1.30x | 0 | 0.03x | 0 | yes |
| tree-expand-collapse | 1 | plain | 9235 | 7537–11232 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 20210 | 20101–20404 | 2.19x | 780 | 39.00x | 0 | yes |
| tree-expand-collapse | 1 | compose | 11815 | 11709–12542 | 1.28x | 63 | 3.15x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 23643 | 22250–25556 | 2.56x | 165 | 8.25x | 9 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23123 | 20820–24916 | 2.50x | 159 | 7.95x | 1 | yes |
| tree-expand-collapse | 1 | react | 19743 | 18649–20276 | 2.14x | 69 | 3.45x | 27 | yes |
| tree-expand-collapse | 1 | react-reflex | 19339 | 19034–20757 | 2.09x | 672 | 33.60x | 22 | yes |
| tree-expand-collapse | 1 | react-upstream | 19916 | 18947–20335 | 2.16x | 69 | 3.45x | 20 | yes |
| tree-expand-collapse | 1 | roact | 11439 | 10828–11733 | 1.24x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 25242 | 24262–30472 | 2.73x | 148 | 7.40x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8212 | 8037–8318 | 0.89x | 21 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11610 | 11539–12033 | 1.26x | 71 | 3.55x | 0 | yes |
| form-validation | 1 | plain | 2734 | 2606–3405 | 1.00x | 44 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 4486 | 4189–5044 | 1.64x | 336 | 7.64x | 0 | yes |
| form-validation | 1 | compose | 4149 | 3969–4579 | 1.52x | 94 | 2.14x | 2 | yes |
| form-validation | 1 | fusion | 5349 | 5033–5603 | 1.96x | 126 | 2.86x | 0 | yes |
| form-validation | 1 | fusion-charm | 5902 | 5605–6313 | 2.16x | 155 | 3.52x | 1 | yes |
| form-validation | 1 | react | 5860 | 5078–6532 | 2.14x | 66 | 1.50x | 0 | yes |
| form-validation | 1 | react-reflex | 5660 | 5298–5985 | 2.07x | 83 | 1.89x | 1 | yes |
| form-validation | 1 | react-upstream | 5337 | 4861–6286 | 1.95x | 65 | 1.48x | 0 | yes |
| form-validation | 1 | roact | 5450 | 5133–5656 | 1.99x | 223 | 5.07x | 0 | yes |
| form-validation | 1 | seam | 6935 | 6823–7475 | 2.54x | 349 | 7.93x | 0 | yes |
| form-validation | 1 | signals | 4055 | 3535–4592 | 1.48x | 155 | 3.52x | 0 | yes |
| form-validation | 1 | vide | 4241 | 3844–4332 | 1.55x | 70 | 1.59x | 0 | yes |
| table-sort-filter | 1 | plain | 19197 | 15606–19513 | 1.00x | 67 | 1.00x | 7 | yes |
| table-sort-filter | 1 | blend | 36820 | 35780–43323 | 1.92x | 5387 | 80.40x | 0 | yes |
| table-sort-filter | 1 | compose | 25199 | 24127–26038 | 1.31x | 1428 | 21.31x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 58332 | 49238–62785 | 3.04x | 4695 | 70.07x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 54663 | 46995–58872 | 2.85x | 4713 | 70.34x | 0 | yes |
| table-sort-filter | 1 | react | 99026 | 92800–100056 | 5.16x | 2108 | 31.46x | 12 | yes |
| table-sort-filter | 1 | react-reflex | 99198 | 95229–103486 | 5.17x | 2122 | 31.67x | 23 | yes |
| table-sort-filter | 1 | react-upstream | 100013 | 92681–102657 | 5.21x | 2115 | 31.57x | 19 | yes |
| table-sort-filter | 1 | roact | 25274 | 25117–26581 | 1.32x | 1013 | 15.12x | 2 | yes |
| table-sort-filter | 1 | seam | 59157 | 50137–64732 | 3.08x | 7784 | 116.18x | 0 | yes |
| table-sort-filter | 1 | signals | 18791 | 18327–18902 | 0.98x | 77 | 1.15x | 1 | yes |
| table-sort-filter | 1 | vide | 25326 | 24955–26258 | 1.32x | 1914 | 28.57x | 0 | yes |
| library-load | 1 | plain | 30 | 21–37 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 678 | 649–8157 | 22.57x | 461 | 461.00x | 458 | yes |
| library-load | 1 | compose | 614 | 573–661 | 20.45x | 67 | 67.00x | 72 | yes |
| library-load | 1 | fusion | 1643 | 1117–6394 | 54.69x | 259 | 259.00x | 252 | yes |
| library-load | 1 | fusion-charm | 1446 | 1393–7335 | 48.12x | 316 | 316.00x | 314 | yes |
| library-load | 1 | react | 4304 | 4053–39174 | 143.26x | 1814 | 1814.00x | 1813 | yes |
| library-load | 1 | react-reflex | 4775 | 4562–41068 | 158.94x | 1967 | 1967.00x | 1965 | yes |
| library-load | 1 | react-upstream | 4734 | 4258–40302 | 157.60x | 1982 | 1982.00x | 1988 | yes |
| library-load | 1 | roact | 338 | 306–366 | 11.26x | 144 | 144.00x | 141 | yes |
| library-load | 1 | seam | 1205 | 1068–6643 | 40.11x | 232 | 232.00x | 229 | yes |
| library-load | 1 | signals | 217 | 176–1126 | 7.22x | 41 | 41.00x | 48 | yes |
| library-load | 1 | vide | 342 | 263–3436 | 11.37x | 145 | 145.00x | 145 | yes |
| rows-append-1000 | 1 | plain | 108973 | 108356–112694 | 1.00x | 6533 | 1.00x | 1 | yes |
| rows-append-1000 | 1 | blend | 169310 | 149082–184520 | 1.55x | 38543 | 5.90x | 0 | yes |
| rows-append-1000 | 1 | compose | 126262 | 118912–153093 | 1.16x | 9529 | 1.46x | 10 | yes |
| rows-append-1000 | 1 | fusion | 349205 | 327424–352349 | 3.20x | 20954 | 3.21x | 8 | yes |
| rows-append-1000 | 1 | fusion-charm | 331290 | 321068–335211 | 3.04x | 28817 | 4.41x | 8 | yes |
| rows-append-1000 | 1 | react | 217821 | 192797–220424 | 2.00x | 23249 | 3.56x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 217734 | 207707–228728 | 2.00x | 24806 | 3.80x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 219338 | 199427–234232 | 2.01x | 23153 | 3.54x | 0 | yes |
| rows-append-1000 | 1 | roact | 165120 | 139960–177845 | 1.52x | 33483 | 5.13x | 0 | yes |
| rows-append-1000 | 1 | seam | 165574 | 144541–179559 | 1.52x | 47327 | 7.24x | 0 | yes |
| rows-append-1000 | 1 | signals | 121794 | 109138–140586 | 1.12x | 17813 | 2.73x | 0 | yes |
| rows-append-1000 | 1 | vide | 125392 | 116637–146799 | 1.15x | 10431 | 1.60x | 1 | yes |
| rows-clear | 1 | plain | 17549 | 17115–18123 | 1.00x | 1237 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 36987 | 35825–37618 | 2.11x | 4066 | 3.29x | 1 | yes |
| rows-clear | 1 | compose | 26108 | 24327–29890 | 1.49x | 1830 | 1.48x | 3 | yes |
| rows-clear | 1 | fusion | 74182 | 69151–82457 | 4.23x | 3504 | 2.83x | 0 | yes |
| rows-clear | 1 | fusion-charm | 72359 | 68747–74295 | 4.12x | 7432 | 6.01x | 0 | yes |
| rows-clear | 1 | react | 25929 | 24868–28134 | 1.48x | 4512 | 3.65x | 0 | yes |
| rows-clear | 1 | react-reflex | 28152 | 27337–29825 | 1.60x | 6530 | 5.28x | 44 | yes |
| rows-clear | 1 | react-upstream | 25829 | 25115–27745 | 1.47x | 4495 | 3.63x | 0 | yes |
| rows-clear | 1 | roact | 25056 | 22926–27723 | 1.43x | 4213 | 3.41x | 8 | yes |
| rows-clear | 1 | seam | 32039 | 31116–35729 | 1.83x | 9142 | 7.39x | 1 | yes |
| rows-clear | 1 | signals | 22609 | 21705–23201 | 1.29x | 4474 | 3.62x | 0 | yes |
| rows-clear | 1 | vide | 19836 | 19447–21237 | 1.13x | 1613 | 1.30x | 1 | yes |
| rows-create-1000 | 1 | plain | 100705 | 97571–105654 | 1.00x | 3126 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 164972 | 147127–168448 | 1.64x | 19753 | 6.32x | 1 | yes |
| rows-create-1000 | 1 | compose | 114011 | 109787–127010 | 1.13x | 5088 | 1.63x | 11 | yes |
| rows-create-1000 | 1 | fusion | 196725 | 188821–208667 | 1.95x | 10971 | 3.51x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 188409 | 184908–191800 | 1.87x | 14916 | 4.77x | 8 | yes |
| rows-create-1000 | 1 | react | 167855 | 158120–187898 | 1.67x | 8152 | 2.61x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 180682 | 168245–188475 | 1.79x | 9074 | 2.90x | 28 | yes |
| rows-create-1000 | 1 | react-upstream | 165407 | 158771–175014 | 1.64x | 8136 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 134706 | 122199–147477 | 1.34x | 16906 | 5.41x | 0 | yes |
| rows-create-1000 | 1 | seam | 152297 | 144671–158610 | 1.51x | 23670 | 7.57x | 0 | yes |
| rows-create-1000 | 1 | signals | 116489 | 104290–117685 | 1.16x | 9065 | 2.90x | 8 | yes |
| rows-create-1000 | 1 | vide | 123845 | 112494–145076 | 1.23x | 4957 | 1.59x | 0 | yes |
| rows-create-10000 | 1 | plain | 1224458 | 1209925–1293421 | 1.00x | 29792 | 1.00x | 4 | yes |
| rows-create-10000 | 1 | blend | 1871035 | 1821820–1910598 | 1.53x | 187473 | 6.29x | 8 | yes |
| rows-create-10000 | 1 | compose | 1466960 | 1456861–1470286 | 1.20x | 48516 | 1.63x | 2 | yes |
| rows-create-10000 | 1 | fusion | 6215573 | 6033739–6536478 | 5.08x | 101460 | 3.41x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6105867 | 5952672–6276407 | 4.99x | 144691 | 4.86x | 4 | yes |
| rows-create-10000 | 1 | react | 5096585 | 4915047–5188819 | 4.16x | 76874 | 2.58x | 152 | yes |
| rows-create-10000 | 1 | react-reflex | 5183820 | 5148619–5205327 | 4.23x | 86748 | 2.91x | 564 | yes |
| rows-create-10000 | 1 | react-upstream | 5068306 | 4901099–5108695 | 4.14x | 77938 | 2.62x | 628 | yes |
| rows-create-10000 | 1 | roact | 1646790 | 1606974–1815586 | 1.34x | 165522 | 5.56x | 0 | yes |
| rows-create-10000 | 1 | seam | 1860346 | 1806114–1911262 | 1.52x | 235176 | 7.89x | 24 | yes |
| rows-create-10000 | 1 | signals | 1403868 | 1384113–1526529 | 1.15x | 89230 | 3.00x | 5 | yes |
| rows-create-10000 | 1 | vide | 1445130 | 1402990–1546370 | 1.18x | 47996 | 1.61x | 0 | yes |
| rows-remove-one | 1 | plain | 669 | 636–768 | 1.00x | 3189 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1154 | 1050–1202 | 1.73x | 18757 | 5.88x | 1 | yes |
| rows-remove-one | 1 | compose | 903 | 737–1003 | 1.35x | 4658 | 1.46x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 63546 | 60577–65960 | 95.03x | 11201 | 3.51x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 61373 | 56213–61412 | 91.78x | 15066 | 4.72x | 2 | yes |
| rows-remove-one | 1 | react | 23506 | 18910–25020 | 35.15x | 15717 | 4.93x | 8 | yes |
| rows-remove-one | 1 | react-reflex | 41715 | 24505–46345 | 62.39x | 16654 | 5.22x | 27 | yes |
| rows-remove-one | 1 | react-upstream | 25119 | 19306–48458 | 37.57x | 15693 | 4.92x | 0 | yes |
| rows-remove-one | 1 | roact | 19839 | 16759–26627 | 29.67x | 17006 | 5.33x | 0 | yes |
| rows-remove-one | 1 | seam | 6012 | 5411–6309 | 8.99x | 23678 | 7.42x | 1 | yes |
| rows-remove-one | 1 | signals | 1569 | 1367–1705 | 2.35x | 9085 | 2.85x | 0 | yes |
| rows-remove-one | 1 | vide | 1100 | 964–1200 | 1.65x | 5018 | 1.57x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–133 | 1.00x | 2695 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 750 | 651–800 | 7.50x | 18275 | 6.78x | 8 | yes |
| rows-swap | 1 | compose | 250 | 152–402 | 2.50x | 4164 | 1.55x | 2 | yes |
| rows-swap | 1 | fusion | 60290 | 56118–61064 | 602.90x | 9559 | 3.55x | 0 | yes |
| rows-swap | 1 | fusion-charm | 58146 | 57270–59539 | 581.46x | 13928 | 5.17x | 0 | yes |
| rows-swap | 1 | react | 55994 | 51239–56356 | 559.94x | 15094 | 5.60x | 0 | yes |
| rows-swap | 1 | react-reflex | 63316 | 54585–65599 | 633.16x | 16247 | 6.03x | 20 | yes |
| rows-swap | 1 | react-upstream | 54580 | 52958–58255 | 545.80x | 15439 | 5.73x | 0 | yes |
| rows-swap | 1 | roact | 17007 | 13818–29209 | 170.07x | 16761 | 6.22x | 1 | yes |
| rows-swap | 1 | seam | 5200 | 4626–5400 | 52.00x | 23219 | 8.62x | 1 | yes |
| rows-swap | 1 | signals | 654 | 550–700 | 6.54x | 8618 | 3.20x | 1 | yes |
| rows-swap | 1 | vide | 152 | 100–308 | 1.51x | 4517 | 1.68x | 1 | yes |
| rows-update-every-10th | 1 | plain | 2370 | 2274–2440 | 1.00x | 3191 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 2353 | 2253–2504 | 0.99x | 19251 | 6.03x | 0 | yes |
| rows-update-every-10th | 1 | compose | 2261 | 2162–2350 | 0.95x | 4726 | 1.48x | 12 | yes |
| rows-update-every-10th | 1 | fusion | 2300 | 2200–2805 | 0.97x | 10552 | 3.31x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2603 | 2410–2909 | 1.10x | 14479 | 4.54x | 0 | yes |
| rows-update-every-10th | 1 | react | 2505 | 2350–2704 | 1.06x | 7936 | 2.49x | 32 | yes |
| rows-update-every-10th | 1 | react-reflex | 4610 | 3700–5000 | 1.95x | 8785 | 2.75x | 0 | yes |
| rows-update-every-10th | 1 | react-upstream | 2450 | 2350–2602 | 1.03x | 7888 | 2.47x | 0 | yes |
| rows-update-every-10th | 1 | roact | 2354 | 2316–2602 | 0.99x | 16676 | 5.23x | 0 | yes |
| rows-update-every-10th | 1 | seam | 4829 | 4118–5510 | 2.04x | 24212 | 7.59x | 1 | yes |
| rows-update-every-10th | 1 | signals | 2500 | 2436–2656 | 1.05x | 9345 | 2.93x | 1 | yes |
| rows-update-every-10th | 1 | vide | 2351 | 2252–2508 | 0.99x | 5124 | 1.61x | 8 | yes |

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
| blend | 29 | 2.42x | 10.25x | 2.37x | 9.91x |
| compose | 30 | 1.82x | 3.24x | 1.75x | 3.15x |
| fusion | 30 | 6.72x | 5.59x | 6.11x | 5.55x |
| fusion-charm | 30 | 6.13x | 6.95x | 5.55x | 7.01x |
| react | 29 | 5.08x | 5.54x | 4.95x | 5.83x |
| react-reflex | 29 | 5.58x | 8.61x | 5.43x | 9.19x |
| react-upstream | 29 | 5.07x | 5.53x | 4.90x | 5.84x |
| roact | 29 | 2.82x | 4.99x | 2.86x | 5.62x |
| seam | 30 | 4.07x | 11.11x | 3.79x | 10.89x |
| signals | 29 | 1.87x | 2.28x | 1.81x | 2.26x |
| vide | 30 | 1.85x | 2.56x | 1.80x | 2.52x |
