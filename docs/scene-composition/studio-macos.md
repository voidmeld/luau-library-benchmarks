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
| Harness revision | `3995ec1` |
| Date | 2026-11-11 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 200–312 | 1.00x | 57 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 800 | 400–1000 | 2.67x | 774 | 13.58x | 9 | yes |
| update-leaf | 20 | compose | 571 | 100–800 | 1.90x | 93 | 1.63x | 1 | yes |
| update-leaf | 20 | fusion | 700 | 400–935 | 2.33x | 52 | 0.91x | 1 | yes |
| update-leaf | 20 | fusion-charm | 710 | 407–1257 | 2.37x | 61 | 1.07x | 0 | yes |
| update-leaf | 20 | react | 910 | 301–1016 | 3.03x | 355 | 6.23x | 1 | yes |
| update-leaf | 20 | react-reflex | 993 | 544–1161 | 3.31x | 301 | 5.28x | 8 | yes |
| update-leaf | 20 | react-upstream | 707 | 431–1059 | 2.36x | 291 | 5.11x | 0 | yes |
| update-leaf | 20 | roact | 701 | 500–835 | 2.34x | 951 | 16.68x | 0 | yes |
| update-leaf | 20 | seam | 1035 | 820–1488 | 3.45x | 40 | 0.70x | 0 | yes |
| update-leaf | 20 | signals | 502 | 400–1140 | 1.67x | 50 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 826 | 600–1131 | 2.75x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4550 | 4352–5268 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 10537 | 10212–10982 | 2.32x | 933 | 44.43x | 1 | yes |
| update-batched | 20 | compose | 6944 | 6848–7474 | 1.53x | 400 | 19.05x | 9 | yes |
| update-batched | 20 | fusion | 20113 | 20003–20612 | 4.42x | 509 | 24.24x | 0 | yes |
| update-batched | 20 | fusion-charm | 35044 | 34290–36987 | 7.70x | 1101 | 52.43x | 0 | yes |
| update-batched | 20 | react | 7544 | 7248–8017 | 1.66x | 541 | 25.76x | 0 | yes |
| update-batched | 20 | react-reflex | 52129 | 49174–54401 | 11.46x | 775 | 36.90x | 8 | yes |
| update-batched | 20 | react-upstream | 7860 | 7507–8082 | 1.73x | 469 | 22.33x | 0 | yes |
| update-batched | 20 | roact | 7601 | 7300–7983 | 1.67x | 1169 | 55.67x | 1 | yes |
| update-batched | 20 | seam | 12193 | 11900–12860 | 2.68x | 1825 | 86.90x | 0 | yes |
| update-batched | 20 | signals | 9003 | 8754–9236 | 1.98x | 597 | 28.43x | 1 | yes |
| update-batched | 20 | vide | 8462 | 8059–8725 | 1.86x | 332 | 15.81x | 0 | yes |
| update-repeated | 10 | plain | 46 | 43–51 | 1.00x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3518 | 3426–3550 | 77.25x | 7 | 7.00x | 1 | yes |
| update-repeated | 10 | compose | 276 | 155–416 | 6.05x | 6 | 6.00x | 1 | yes |
| update-repeated | 10 | fusion | 26031 | 24311–26892 | 571.63x | 5 | 5.00x | 1 | yes |
| update-repeated | 10 | fusion-charm | 1216 | 900–1368 | 26.70x | 7 | 7.00x | 1 | yes |
| update-repeated | 10 | react | 7301 | 7104–7508 | 160.33x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | react-reflex | 801 | 600–911 | 17.59x | 4 | 4.00x | 8 | yes |
| update-repeated | 10 | react-upstream | 7348 | 7279–7741 | 161.36x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | roact | 5103 | 4603–5214 | 112.06x | 7 | 7.00x | 1 | yes |
| update-repeated | 10 | seam | 1431 | 1317–1627 | 31.42x | 11 | 11.00x | 0 | yes |
| update-repeated | 10 | signals | 800 | 700–860 | 17.57x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | vide | 556 | 508–702 | 12.22x | 3 | 3.00x | 1 | yes |
| branch-swap | 20 | plain | 14306 | 12911–14608 | 1.00x | 10 | 1.00x | 8 | yes |
| branch-swap | 20 | blend | 16478 | 15852–17507 | 1.15x | 35 | 3.50x | 0 | yes |
| branch-swap | 20 | compose | 13700 | 12617–13994 | 0.96x | 0 | 0.10x | 2 | yes |
| branch-swap | 20 | fusion | 14745 | 13817–15213 | 1.03x | 5 | 0.50x | 1 | yes |
| branch-swap | 20 | fusion-charm | 14399 | 13826–14559 | 1.01x | 6 | 0.60x | 0 | yes |
| branch-swap | 20 | react | 16635 | 16247–17874 | 1.16x | 2 | 0.20x | 0 | yes |
| branch-swap | 20 | react-reflex | 16651 | 16438–17178 | 1.16x | 20 | 2.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 17069 | 16635–17260 | 1.19x | 18 | 1.80x | 0 | yes |
| branch-swap | 20 | roact | 15029 | 14961–15353 | 1.05x | 20 | 2.00x | 0 | yes |
| branch-swap | 20 | seam | 12017 | 11807–12644 | 0.84x | 19 | 1.90x | 0 | yes |
| branch-swap | 20 | signals | 13379 | 12808–14421 | 0.94x | 12 | 1.20x | 1 | yes |
| branch-swap | 20 | vide | 14113 | 13985–14681 | 0.99x | 5 | 0.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2500 | 2272–2779 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4600 | 4301–4704 | 1.84x | 1498 | 23.41x | 9 | yes |
| keyed-prepend | 10 | compose | 4233 | 4202–4371 | 1.69x | 571 | 8.92x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 21541 | 20561–23596 | 8.62x | 1528 | 23.88x | 2 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 20820 | 20135–21671 | 8.33x | 1513 | 23.64x | 1 | yes |
| keyed-prepend | 10 | react | 16325 | 15326–16953 | 6.53x | 792 | 12.38x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16131 | 15512–16215 | 6.45x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16234 | 15907–17010 | 6.49x | 785 | 12.27x | 1 | yes |
| keyed-prepend | 10 | roact | 6804 | 6311–7358 | 2.72x | 369 | 5.77x | 0 | yes |
| keyed-prepend | 10 | seam | 11012 | 10933–12081 | 4.40x | 2447 | 38.23x | 1 | yes |
| keyed-prepend | 10 | signals | 2810 | 2529–3109 | 1.12x | 70 | 1.09x | 1 | yes |
| keyed-prepend | 10 | vide | 5013 | 4817–5437 | 2.01x | 638 | 9.97x | 0 | yes |
| keyed-insert | 10 | plain | 1828 | 1754–2028 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 3979 | 3750–4320 | 2.18x | 1498 | 23.41x | 8 | yes |
| keyed-insert | 10 | compose | 2970 | 2816–3226 | 1.63x | 563 | 8.80x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 18833 | 17815–19737 | 10.31x | 1520 | 23.75x | 2 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 17426 | 16506–17904 | 9.54x | 1514 | 23.66x | 1 | yes |
| keyed-insert | 10 | react | 13339 | 13003–14621 | 7.30x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13226 | 12614–13702 | 7.24x | 867 | 13.55x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13576 | 13277–13792 | 7.43x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 5419 | 5204–5767 | 2.97x | 370 | 5.78x | 1 | yes |
| keyed-insert | 10 | seam | 10209 | 9618–10720 | 5.59x | 2455 | 38.36x | 0 | yes |
| keyed-insert | 10 | signals | 1939 | 1879–2119 | 1.06x | 61 | 0.95x | 0 | yes |
| keyed-insert | 10 | vide | 3520 | 3352–3566 | 1.93x | 646 | 10.09x | 0 | yes |
| keyed-shuffle | 10 | plain | 1975 | 1825–2100 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2897 | 2400–3213 | 1.47x | 1440 | 24.00x | 0 | yes |
| keyed-shuffle | 10 | compose | 2910 | 2604–3008 | 1.47x | 570 | 9.50x | 9 | yes |
| keyed-shuffle | 10 | fusion | 18932 | 16732–19839 | 9.59x | 1390 | 23.17x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 17816 | 16614–18709 | 9.02x | 1392 | 23.20x | 0 | yes |
| keyed-shuffle | 10 | react | 28609 | 27453–29030 | 14.49x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27762 | 26664–28993 | 14.06x | 780 | 13.00x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 28536 | 27442–29739 | 14.45x | 778 | 12.97x | 0 | yes |
| keyed-shuffle | 10 | roact | 5663 | 5308–5805 | 2.87x | 361 | 6.02x | 0 | yes |
| keyed-shuffle | 10 | seam | 9492 | 8702–9833 | 4.81x | 2438 | 40.63x | 0 | yes |
| keyed-shuffle | 10 | signals | 2054 | 1806–2354 | 1.04x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | vide | 3718 | 3550–3954 | 1.88x | 621 | 10.35x | 0 | yes |
| events | 1 | plain | 1012 | 910–1231 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 1314 | 1134–1704 | 1.30x | 2 | 1.00x | 0 | yes |
| events | 1 | compose | 1003 | 805–1263 | 0.99x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 995 | 900–1488 | 0.98x | 1 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 1571 | 938–1915 | 1.55x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 1167 | 900–1400 | 1.15x | 0 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 1597 | 1213–2060 | 1.58x | 1 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 1204 | 914–1505 | 1.19x | 1 | 0.50x | 1 | yes |
| events | 1 | roact | 801 | 500–1200 | 0.79x | 9 | 4.50x | 8 | yes |
| events | 1 | seam | 709 | 612–813 | 0.70x | 9 | 4.50x | 0 | yes |
| events | 1 | signals | 800 | 784–1021 | 0.79x | 8 | 4.00x | 0 | yes |
| events | 1 | vide | 1008 | 400–1227 | 1.00x | 1 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 3035 | 2509–3109 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 10763 | 10185–11542 | 3.55x | 1770 | 23.92x | 0 | yes |
| animate-many | 1 | compose | 6257 | 5858–7012 | 2.06x | 745 | 10.07x | 12 | yes |
| animate-many | 1 | fusion | 102615 | 102444–103591 | 33.81x | 1136 | 15.35x | 0 | yes |
| animate-many | 1 | fusion-charm | 103009 | 101320–104421 | 33.94x | 1122 | 15.16x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 19100 | 17806–20319 | 6.29x | 2882 | 38.95x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 7489 | 7401–8018 | 2.47x | 392 | 5.30x | 0 | yes |
| status-panel | 10 | plain | 581 | 540–650 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1004 | 900–1203 | 1.73x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | compose | 912 | 802–1369 | 1.57x | 33 | 16.50x | 2 | yes |
| status-panel | 10 | fusion | 1353 | 1304–1722 | 2.33x | 64 | 32.00x | 1 | yes |
| status-panel | 10 | fusion-charm | 1511 | 1256–1934 | 2.60x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | react | 1884 | 1601–2188 | 3.24x | 35 | 17.50x | 0 | yes |
| status-panel | 10 | react-reflex | 1853 | 1678–2062 | 3.19x | 38 | 19.00x | 1 | yes |
| status-panel | 10 | react-upstream | 1876 | 1863–2109 | 3.23x | 43 | 21.50x | 1 | yes |
| status-panel | 10 | roact | 1002 | 868–1082 | 1.72x | 32 | 16.00x | 0 | yes |
| status-panel | 10 | seam | 1534 | 1371–2015 | 2.64x | 149 | 74.50x | 9 | yes |
| status-panel | 10 | signals | 718 | 460–1010 | 1.23x | 15 | 7.50x | 0 | yes |
| status-panel | 10 | vide | 968 | 800–1068 | 1.67x | 32 | 16.00x | 0 | yes |
| scene-3d | 10 | plain | 2635 | 2371–3005 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4565 | 4400–4704 | 1.73x | 550 | 50.00x | 0 | yes |
| scene-3d | 10 | compose | 3128 | 2919–3250 | 1.19x | 186 | 16.91x | 1 | yes |
| scene-3d | 10 | fusion | 30942 | 24391–34491 | 11.74x | 520 | 47.27x | 0 | yes |
| scene-3d | 10 | fusion-charm | 31779 | 30524–32275 | 12.06x | 523 | 47.55x | 0 | yes |
| scene-3d | 10 | react | 3200 | 2800–3843 | 1.21x | 221 | 20.09x | 0 | yes |
| scene-3d | 10 | react-reflex | 3208 | 2800–3418 | 1.22x | 233 | 21.18x | 0 | yes |
| scene-3d | 10 | react-upstream | 3400 | 3296–4052 | 1.29x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 3228 | 3106–3442 | 1.23x | 574 | 52.18x | 0 | yes |
| scene-3d | 10 | seam | 8801 | 8548–9307 | 3.34x | 1755 | 159.55x | 0 | yes |
| scene-3d | 10 | signals | 5900 | 5502–6265 | 2.24x | 690 | 62.73x | 0 | yes |
| scene-3d | 10 | vide | 3817 | 3601–4315 | 1.45x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 20 | 15–32 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 125 | 100–150 | 6.29x | 28 | 7.00x | 0 | yes |
| derived-diamond | 3 | compose | 104 | 100–125 | 5.24x | 2 | 0.50x | 0 | yes |
| derived-diamond | 3 | fusion | 105 | 100–157 | 5.27x | 8 | 2.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 100 | 100–125 | 5.03x | 10 | 2.50x | 0 | yes |
| derived-diamond | 3 | react | 241 | 233–308 | 12.12x | 6 | 1.50x | 3 | yes |
| derived-diamond | 3 | react-reflex | 300 | 200–367 | 15.09x | 10 | 2.50x | 7 | yes |
| derived-diamond | 3 | react-upstream | 267 | 202–345 | 13.41x | 7 | 1.75x | 4 | yes |
| derived-diamond | 3 | roact | 100 | 100–150 | 5.03x | 10 | 2.50x | 3 | yes |
| derived-diamond | 3 | seam | 199 | 145–204 | 10.01x | 21 | 5.25x | 0 | yes |
| derived-diamond | 3 | signals | 100 | 100–125 | 5.03x | 9 | 2.25x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 100–125 | 5.03x | 14 | 3.50x | 8 | yes |
| derived-chain-100 | 3 | plain | 47 | 45–60 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 202 | 175–242 | 4.25x | 131 | 2.30x | 0 | yes |
| derived-chain-100 | 3 | fusion | 1000 | 832–1025 | 21.08x | 127 | 2.23x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 929 | 878–1053 | 19.58x | 129 | 2.26x | 1 | yes |
| derived-chain-100 | 3 | react | 542 | 467–570 | 11.43x | 69 | 1.21x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 600 | 514–710 | 12.64x | 88 | 1.54x | 22 | yes |
| derived-chain-100 | 3 | react-upstream | 476 | 433–570 | 10.03x | 69 | 1.21x | 12 | yes |
| derived-chain-100 | 3 | roact | 128 | 125–218 | 2.70x | 11 | 0.19x | 10 | yes |
| derived-chain-100 | 3 | seam | 802 | 612–951 | 16.89x | 279 | 4.89x | 0 | yes |
| derived-chain-100 | 3 | signals | 225 | 152–281 | 4.75x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 230 | 150–301 | 4.85x | 93 | 1.63x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–105 | 1.00x | 497 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 284 | 275–350 | 2.84x | 1542 | 3.10x | 1 | yes |
| derived-fan-in-1000 | 3 | compose | 326 | 277–375 | 3.26x | 688 | 1.38x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 2200 | 2070–2235 | 22.00x | 890 | 1.79x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2218 | 2071–2435 | 22.18x | 2814 | 5.66x | 1 | yes |
| derived-fan-in-1000 | 3 | react | 2831 | 2450–3400 | 28.31x | 671 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7802 | 7300–9000 | 78.02x | 5629 | 11.33x | 78 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2524 | 2435–2805 | 25.24x | 663 | 1.33x | 43 | yes |
| derived-fan-in-1000 | 3 | roact | 516 | 446–550 | 5.16x | 105 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2911 | 2620–2952 | 29.11x | 2947 | 5.93x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 696 | 626–725 | 6.96x | 1212 | 2.44x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 500 | 425–550 | 5.00x | 521 | 1.05x | 1 | yes |
| filter-as-you-type | 1 | plain | 9033 | 8109–10000 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 17627 | 15918–17755 | 1.95x | 2653 | 75.80x | 0 | yes |
| filter-as-you-type | 1 | compose | 10912 | 10861–11823 | 1.21x | 841 | 24.03x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28226 | 25418–29724 | 3.12x | 2457 | 70.20x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26813 | 24628–27535 | 2.97x | 2451 | 70.03x | 0 | yes |
| filter-as-you-type | 1 | react | 19052 | 8176–21742 | 2.11x | 76 | 2.17x | 20 | yes |
| filter-as-you-type | 1 | react-reflex | 20616 | 20270–21784 | 2.28x | 831 | 23.74x | 15 | yes |
| filter-as-you-type | 1 | react-upstream | 20995 | 19803–21216 | 2.32x | 75 | 2.14x | 11 | yes |
| filter-as-you-type | 1 | roact | 11301 | 10613–11717 | 1.25x | 502 | 14.34x | 3 | yes |
| filter-as-you-type | 1 | seam | 24342 | 20219–27224 | 2.69x | 3989 | 113.97x | 0 | yes |
| filter-as-you-type | 1 | signals | 7902 | 7668–8522 | 0.87x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | vide | 11107 | 10106–11300 | 1.23x | 960 | 27.43x | 1 | yes |
| theme-propagation | 3 | plain | 47621 | 47456–49841 | 1.00x | 198 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 46864 | 46378–47989 | 0.98x | 2078 | 10.49x | 0 | yes |
| theme-propagation | 3 | compose | 50944 | 49934–52996 | 1.07x | 580 | 2.93x | 2 | yes |
| theme-propagation | 3 | fusion | 52115 | 50660–55139 | 1.09x | 866 | 4.37x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 52837 | 51612–54148 | 1.11x | 877 | 4.43x | 1 | yes |
| theme-propagation | 3 | react | 53319 | 52942–56643 | 1.12x | 2027 | 10.24x | 0 | yes |
| theme-propagation | 3 | react-reflex | 46456 | 45918–47971 | 0.98x | 2028 | 10.24x | 0 | yes |
| theme-propagation | 3 | react-upstream | 53313 | 52953–54866 | 1.12x | 2027 | 10.24x | 0 | yes |
| theme-propagation | 3 | roact | 50848 | 50168–51765 | 1.07x | 3287 | 16.60x | 8 | yes |
| theme-propagation | 3 | seam | 46078 | 45758–46566 | 0.97x | 3470 | 17.53x | 1 | yes |
| theme-propagation | 3 | signals | 51839 | 51001–52041 | 1.09x | 904 | 4.57x | 0 | yes |
| theme-propagation | 3 | vide | 50315 | 49515–52363 | 1.06x | 605 | 3.06x | 0 | yes |
| hud-per-frame | 1 | plain | 2807 | 2171–3017 | 1.00x | 23 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5332 | 4970–5733 | 1.90x | 68 | 2.93x | 4 | yes |
| hud-per-frame | 1 | compose | 5069 | 4224–5095 | 1.81x | 24 | 1.02x | 1 | yes |
| hud-per-frame | 1 | fusion | 10155 | 9880–11054 | 3.62x | 42 | 1.85x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13353 | 12729–13531 | 4.76x | 87 | 3.78x | 0 | yes |
| hud-per-frame | 1 | react | 4896 | 4279–5711 | 1.74x | 38 | 1.63x | 4 | yes |
| hud-per-frame | 1 | react-reflex | 5774 | 5304–6296 | 2.06x | 50 | 2.15x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 4778 | 3290–5015 | 1.70x | 34 | 1.46x | 0 | yes |
| hud-per-frame | 1 | roact | 3940 | 3381–5211 | 1.40x | 93 | 4.04x | 0 | yes |
| hud-per-frame | 1 | seam | 8387 | 7655–9309 | 2.99x | 176 | 7.67x | 4 | yes |
| hud-per-frame | 1 | signals | 5230 | 3886–6507 | 1.86x | 65 | 2.83x | 4 | yes |
| hud-per-frame | 1 | vide | 4850 | 4485–4913 | 1.73x | 26 | 1.13x | 0 | yes |
| teardown-under-load | 1 | plain | 47645 | 42765–52332 | 1.00x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 73040 | 65404–80951 | 1.53x | 14 | 2.80x | 1 | yes |
| teardown-under-load | 1 | compose | 55018 | 51272–57248 | 1.15x | 15 | 3.00x | 10 | yes |
| teardown-under-load | 1 | fusion | 76886 | 70263–80150 | 1.61x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 76944 | 73047–78395 | 1.61x | 14 | 2.80x | 0 | yes |
| teardown-under-load | 1 | react | 75892 | 72838–78778 | 1.59x | 1077 | 215.40x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 74312 | 71670–75455 | 1.56x | 1086 | 217.20x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 75108 | 73193–79118 | 1.58x | 1085 | 217.00x | 7 | yes |
| teardown-under-load | 1 | roact | 69559 | 57887–76187 | 1.46x | 79 | 15.80x | 0 | yes |
| teardown-under-load | 1 | seam | 64171 | 53732–72165 | 1.35x | 15 | 3.00x | 7 | yes |
| teardown-under-load | 1 | signals | 54952 | 50138–59424 | 1.15x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | vide | 55729 | 52484–60993 | 1.17x | 12 | 2.40x | 0 | yes |
| open-close-retention | 1 | plain | 66355 | 66003–67706 | 1.00x | 32 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 118932 | 118635–120335 | 1.79x | 15 | 0.47x | 1 | yes |
| open-close-retention | 1 | compose | 81932 | 81918–83461 | 1.23x | 15 | 0.47x | 2 | yes |
| open-close-retention | 1 | fusion | 132469 | 131891–138231 | 2.00x | 5 | 0.16x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 132948 | 132928–135833 | 2.00x | 6 | 0.19x | 0 | yes |
| open-close-retention | 1 | react | 116712 | 114708–117196 | 1.76x | 284 | 8.86x | 0 | yes |
| open-close-retention | 1 | react-reflex | 114634 | 112187–115301 | 1.73x | 285 | 8.91x | 0 | yes |
| open-close-retention | 1 | react-upstream | 113453 | 112949–116261 | 1.71x | 283 | 8.84x | 0 | yes |
| open-close-retention | 1 | roact | 106889 | 106105–108543 | 1.61x | 23 | 0.72x | 0 | yes |
| open-close-retention | 1 | seam | 111036 | 108730–111086 | 1.67x | 9 | 0.28x | 1 | yes |
| open-close-retention | 1 | signals | 84115 | 83769–85705 | 1.27x | 12 | 0.38x | 8 | yes |
| open-close-retention | 1 | vide | 88652 | 87457–89565 | 1.34x | 12 | 0.38x | 0 | yes |
| tree-expand-collapse | 1 | plain | 12249 | 10631–13623 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 20129 | 18629–20713 | 1.64x | 789 | 39.45x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12112 | 11372–12740 | 0.99x | 80 | 4.00x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25336 | 23619–26161 | 2.07x | 165 | 8.25x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23337 | 21614–24668 | 1.91x | 168 | 8.40x | 1 | yes |
| tree-expand-collapse | 1 | react | 18932 | 17840–20037 | 1.55x | 77 | 3.85x | 27 | yes |
| tree-expand-collapse | 1 | react-reflex | 19435 | 18708–20123 | 1.59x | 672 | 33.60x | 22 | yes |
| tree-expand-collapse | 1 | react-upstream | 19021 | 18883–21017 | 1.55x | 70 | 3.50x | 20 | yes |
| tree-expand-collapse | 1 | roact | 10983 | 10781–11338 | 0.90x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 26412 | 25108–28125 | 2.16x | 141 | 7.05x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8028 | 7732–8121 | 0.66x | 22 | 1.10x | 1 | yes |
| tree-expand-collapse | 1 | vide | 12008 | 11111–12234 | 0.98x | 70 | 3.50x | 0 | yes |
| form-validation | 1 | plain | 2642 | 2553–3142 | 1.00x | 46 | 1.00x | 1 | yes |
| form-validation | 1 | blend | 3724 | 2927–4073 | 1.41x | 328 | 7.13x | 0 | yes |
| form-validation | 1 | compose | 3653 | 2570–3904 | 1.38x | 106 | 2.30x | 2 | yes |
| form-validation | 1 | fusion | 4371 | 4185–5092 | 1.65x | 126 | 2.74x | 8 | yes |
| form-validation | 1 | fusion-charm | 4747 | 4553–5204 | 1.80x | 155 | 3.37x | 0 | yes |
| form-validation | 1 | react | 4581 | 4217–4940 | 1.73x | 65 | 1.41x | 0 | yes |
| form-validation | 1 | react-reflex | 5107 | 4562–5422 | 1.93x | 76 | 1.65x | 0 | yes |
| form-validation | 1 | react-upstream | 4531 | 4263–4987 | 1.72x | 58 | 1.26x | 0 | yes |
| form-validation | 1 | roact | 4753 | 4100–5023 | 1.80x | 216 | 4.70x | 1 | yes |
| form-validation | 1 | seam | 6062 | 4338–7392 | 2.29x | 357 | 7.76x | 0 | yes |
| form-validation | 1 | signals | 3248 | 3033–3831 | 1.23x | 154 | 3.35x | 0 | yes |
| form-validation | 1 | vide | 3413 | 3056–3612 | 1.29x | 70 | 1.52x | 0 | yes |
| table-sort-filter | 1 | plain | 17465 | 16712–18715 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 36634 | 35756–43927 | 2.10x | 5381 | 80.31x | 0 | yes |
| table-sort-filter | 1 | compose | 26201 | 24857–26344 | 1.50x | 1632 | 24.36x | 18 | yes |
| table-sort-filter | 1 | fusion (workaround) | 57775 | 49035–60007 | 3.31x | 4704 | 70.21x | 2 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 50939 | 50514–54653 | 2.92x | 4705 | 70.22x | 1 | yes |
| table-sort-filter | 1 | react | 98869 | 92854–102339 | 5.66x | 2116 | 31.58x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 97437 | 92502–101410 | 5.58x | 2115 | 31.57x | 22 | yes |
| table-sort-filter | 1 | react-upstream | 97115 | 92813–103862 | 5.56x | 2109 | 31.48x | 12 | yes |
| table-sort-filter | 1 | roact | 25808 | 23574–26636 | 1.48x | 1014 | 15.13x | 3 | yes |
| table-sort-filter | 1 | seam | 59204 | 50956–62678 | 3.39x | 7783 | 116.16x | 0 | yes |
| table-sort-filter | 1 | signals | 18000 | 17417–18629 | 1.03x | 68 | 1.01x | 0 | yes |
| table-sort-filter | 1 | vide | 25284 | 24944–25919 | 1.45x | 1922 | 28.69x | 8 | yes |
| library-load | 1 | plain | 37 | 36–40 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 743 | 715–830 | 19.93x | 459 | 459.00x | 457 | yes |
| library-load | 1 | compose | 694 | 587–736 | 18.60x | 67 | 67.00x | 64 | yes |
| library-load | 1 | fusion | 1254 | 1202–1474 | 33.62x | 264 | 264.00x | 261 | yes |
| library-load | 1 | fusion-charm | 1484 | 1367–2112 | 39.81x | 310 | 310.00x | 309 | yes |
| library-load | 1 | react | 4834 | 4670–4915 | 129.61x | 1825 | 1825.00x | 1824 | yes |
| library-load | 1 | react-reflex | 4959 | 4908–5144 | 132.98x | 1981 | 1981.00x | 1980 | yes |
| library-load | 1 | react-upstream | 4871 | 4500–5281 | 130.63x | 1994 | 1994.00x | 2001 | yes |
| library-load | 1 | roact | 380 | 376–393 | 10.18x | 153 | 153.00x | 150 | yes |
| library-load | 1 | seam | 1275 | 1047–1643 | 34.18x | 235 | 235.00x | 232 | yes |
| library-load | 1 | signals | 239 | 225–249 | 6.42x | 42 | 42.00x | 48 | yes |
| library-load | 1 | vide | 357 | 332–382 | 9.56x | 138 | 138.00x | 137 | yes |
| rows-append-1000 | 1 | plain | 96750 | 95836–98010 | 1.00x | 6533 | 1.00x | 1 | yes |
| rows-append-1000 | 1 | blend | 163462 | 152075–165135 | 1.69x | 38746 | 5.93x | 1 | yes |
| rows-append-1000 | 1 | compose | 116353 | 113519–150987 | 1.20x | 11031 | 1.69x | 10 | yes |
| rows-append-1000 | 1 | fusion | 333904 | 311653–338963 | 3.45x | 20993 | 3.21x | 7 | yes |
| rows-append-1000 | 1 | fusion-charm | 326678 | 318070–348225 | 3.38x | 29042 | 4.45x | 1 | yes |
| rows-append-1000 | 1 | react | 192371 | 173303–226913 | 1.99x | 23326 | 3.57x | 113 | yes |
| rows-append-1000 | 1 | react-reflex | 225611 | 209850–233761 | 2.33x | 24870 | 3.81x | 148 | yes |
| rows-append-1000 | 1 | react-upstream | 196451 | 171035–216454 | 2.03x | 22946 | 3.51x | 0 | yes |
| rows-append-1000 | 1 | roact | 151599 | 139335–199166 | 1.57x | 33146 | 5.07x | 0 | yes |
| rows-append-1000 | 1 | seam | 170292 | 131019–188161 | 1.76x | 46254 | 7.08x | 16 | yes |
| rows-append-1000 | 1 | signals | 114119 | 104289–129270 | 1.18x | 17213 | 2.63x | 1 | yes |
| rows-append-1000 | 1 | vide | 115819 | 110468–141898 | 1.20x | 10432 | 1.60x | 1 | yes |
| rows-clear | 1 | plain | 18011 | 17934–19331 | 1.00x | 1221 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 34918 | 34285–35528 | 1.94x | 4089 | 3.35x | 1 | yes |
| rows-clear | 1 | compose | 23440 | 23216–24036 | 1.30x | 1886 | 1.54x | 2 | yes |
| rows-clear | 1 | fusion | 77576 | 74339–79718 | 4.31x | 3481 | 2.85x | 0 | yes |
| rows-clear | 1 | fusion-charm | 74549 | 72207–75845 | 4.14x | 7392 | 6.05x | 0 | yes |
| rows-clear | 1 | react | 25021 | 24428–26118 | 1.39x | 4488 | 3.68x | 1 | yes |
| rows-clear | 1 | react-reflex | 28127 | 27827–35936 | 1.56x | 6489 | 5.31x | 36 | yes |
| rows-clear | 1 | react-upstream | 25323 | 24333–25422 | 1.41x | 4480 | 3.67x | 0 | yes |
| rows-clear | 1 | roact | 23635 | 23310–25930 | 1.31x | 4206 | 3.44x | 1 | yes |
| rows-clear | 1 | seam | 36146 | 29629–41243 | 2.01x | 9095 | 7.45x | 0 | yes |
| rows-clear | 1 | signals | 22321 | 21239–22811 | 1.24x | 4450 | 3.64x | 1 | yes |
| rows-clear | 1 | vide | 19440 | 18740–21421 | 1.08x | 1605 | 1.31x | 0 | yes |
| rows-create-1000 | 1 | plain | 92923 | 88983–99478 | 1.00x | 3127 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 155761 | 145749–156543 | 1.68x | 19601 | 6.27x | 1 | yes |
| rows-create-1000 | 1 | compose | 112386 | 106897–137992 | 1.21x | 5827 | 1.86x | 3 | yes |
| rows-create-1000 | 1 | fusion | 191829 | 181482–197685 | 2.06x | 10867 | 3.48x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 183828 | 172917–196231 | 1.98x | 14893 | 4.76x | 0 | yes |
| rows-create-1000 | 1 | react | 163149 | 153752–191203 | 1.76x | 8152 | 2.61x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 175814 | 172597–186254 | 1.89x | 9066 | 2.90x | 29 | yes |
| rows-create-1000 | 1 | react-upstream | 165315 | 160228–171522 | 1.78x | 8136 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 125546 | 119594–139304 | 1.35x | 16914 | 5.41x | 0 | yes |
| rows-create-1000 | 1 | seam | 148489 | 139427–160401 | 1.60x | 23885 | 7.64x | 0 | yes |
| rows-create-1000 | 1 | signals | 107344 | 99077–128312 | 1.16x | 9114 | 2.91x | 0 | yes |
| rows-create-1000 | 1 | vide | 111418 | 108709–117449 | 1.20x | 4957 | 1.59x | 8 | yes |
| rows-create-10000 | 1 | plain | 1102716 | 1086053–1237381 | 1.00x | 29792 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1644569 | 1630303–1723963 | 1.49x | 186668 | 6.27x | 8 | yes |
| rows-create-10000 | 1 | compose | 1330542 | 1308470–1336890 | 1.21x | 55727 | 1.87x | 11 | yes |
| rows-create-10000 | 1 | fusion | 6296188 | 6225222–6317861 | 5.71x | 104853 | 3.52x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6124618 | 5967966–6197127 | 5.55x | 145100 | 4.87x | 4 | yes |
| rows-create-10000 | 1 | react | 5074883 | 5047475–5266849 | 4.60x | 76934 | 2.58x | 272 | yes |
| rows-create-10000 | 1 | react-reflex | 5333037 | 5138256–5409578 | 4.84x | 87202 | 2.93x | 646 | yes |
| rows-create-10000 | 1 | react-upstream | 4967159 | 4954715–5010982 | 4.50x | 78278 | 2.63x | 180 | yes |
| rows-create-10000 | 1 | roact | 1456714 | 1421050–1565908 | 1.32x | 166658 | 5.59x | 0 | yes |
| rows-create-10000 | 1 | seam | 1650238 | 1630565–1686440 | 1.50x | 234772 | 7.88x | 12 | yes |
| rows-create-10000 | 1 | signals | 1254764 | 1241758–1294516 | 1.14x | 89218 | 2.99x | 4 | yes |
| rows-create-10000 | 1 | vide | 1284859 | 1239135–1399550 | 1.17x | 48456 | 1.63x | 8 | yes |
| rows-remove-one | 1 | plain | 736 | 700–833 | 1.00x | 2733 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1154 | 1102–1203 | 1.57x | 18284 | 6.69x | 0 | yes |
| rows-remove-one | 1 | compose | 968 | 872–1033 | 1.31x | 4949 | 1.81x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 64372 | 61885–78989 | 87.46x | 11114 | 4.07x | 0 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 61568 | 61454–61852 | 83.65x | 15034 | 5.50x | 2 | yes |
| rows-remove-one | 1 | react | 35738 | 23416–41865 | 48.56x | 15531 | 5.68x | 23 | yes |
| rows-remove-one | 1 | react-reflex | 30213 | 21928–31734 | 41.05x | 16430 | 6.01x | 44 | yes |
| rows-remove-one | 1 | react-upstream | 25207 | 20008–40617 | 34.25x | 15469 | 5.66x | 0 | yes |
| rows-remove-one | 1 | roact | 17126 | 15221–17708 | 23.27x | 16781 | 6.14x | 1 | yes |
| rows-remove-one | 1 | seam | 5715 | 5410–6201 | 7.76x | 23222 | 8.50x | 8 | yes |
| rows-remove-one | 1 | signals | 1467 | 1400–1674 | 1.99x | 8613 | 3.15x | 0 | yes |
| rows-remove-one | 1 | vide | 1109 | 1000–1168 | 1.51x | 4554 | 1.67x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 2679 | 1.00x | 8 | yes |
| rows-swap | 1 | blend | 750 | 650–808 | 7.50x | 18262 | 6.82x | 1 | yes |
| rows-swap | 1 | compose | 300 | 250–300 | 3.00x | 4911 | 1.83x | 0 | yes |
| rows-swap | 1 | fusion | 63712 | 58111–64521 | 637.12x | 9543 | 3.56x | 0 | yes |
| rows-swap | 1 | fusion-charm | 55926 | 54462–58427 | 559.26x | 14483 | 5.41x | 1 | yes |
| rows-swap | 1 | react | 53176 | 51960–58846 | 531.76x | 15433 | 5.76x | 0 | yes |
| rows-swap | 1 | react-reflex | 61878 | 57979–66388 | 618.78x | 16387 | 6.12x | 36 | yes |
| rows-swap | 1 | react-upstream | 60274 | 53767–86655 | 602.74x | 15000 | 5.60x | 1 | yes |
| rows-swap | 1 | roact | 15424 | 14111–18802 | 154.24x | 16300 | 6.08x | 0 | yes |
| rows-swap | 1 | seam | 5315 | 3903–6008 | 53.15x | 23212 | 8.66x | 1 | yes |
| rows-swap | 1 | signals | 600 | 435–735 | 6.00x | 8602 | 3.21x | 0 | yes |
| rows-swap | 1 | vide | 200 | 100–300 | 2.00x | 4516 | 1.69x | 1 | yes |
| rows-update-every-10th | 1 | plain | 1902 | 1867–1974 | 1.00x | 3191 | 1.00x | 8 | yes |
| rows-update-every-10th | 1 | blend | 2000 | 1901–2102 | 1.05x | 19264 | 6.04x | 0 | yes |
| rows-update-every-10th | 1 | compose | 1970 | 1840–2071 | 1.04x | 5465 | 1.71x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 2004 | 1909–2300 | 1.05x | 10552 | 3.31x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2508 | 2150–2700 | 1.32x | 14464 | 4.53x | 0 | yes |
| rows-update-every-10th | 1 | react | 1954 | 1902–2050 | 1.03x | 7877 | 2.47x | 16 | yes |
| rows-update-every-10th | 1 | react-reflex | 3902 | 3453–4418 | 2.05x | 8814 | 2.76x | 12 | yes |
| rows-update-every-10th | 1 | react-upstream | 2100 | 2002–2200 | 1.10x | 7861 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | roact | 2056 | 1908–2150 | 1.08x | 16690 | 5.23x | 0 | yes |
| rows-update-every-10th | 1 | seam | 4807 | 4002–5303 | 2.53x | 24203 | 7.58x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2135 | 2105–2171 | 1.12x | 9354 | 2.93x | 9 | yes |
| rows-update-every-10th | 1 | vide | 1972 | 1934–2047 | 1.04x | 5124 | 1.61x | 0 | yes |

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
| blend | 29 | 2.37x | 10.90x | 2.34x | 10.59x |
| compose | 30 | 1.76x | 3.38x | 1.69x | 3.30x |
| fusion | 30 | 6.43x | 5.46x | 5.81x | 5.44x |
| fusion-charm | 30 | 6.02x | 7.13x | 5.42x | 7.23x |
| react | 29 | 4.97x | 5.57x | 4.82x | 5.89x |
| react-reflex | 29 | 5.45x | 8.71x | 5.29x | 9.26x |
| react-upstream | 29 | 4.91x | 5.96x | 4.79x | 6.30x |
| roact | 29 | 2.65x | 5.89x | 2.65x | 6.65x |
| seam | 30 | 3.89x | 12.51x | 3.63x | 12.42x |
| signals | 29 | 1.74x | 2.65x | 1.67x | 2.64x |
| vide | 30 | 1.86x | 3.03x | 1.77x | 3.04x |
