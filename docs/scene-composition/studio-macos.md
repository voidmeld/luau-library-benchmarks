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
| Harness revision | `82fbc16` |
| Date | 2026-11-13 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 300–304 | 1.00x | 49 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 800 | 707–1300 | 2.67x | 765 | 15.61x | 1 | yes |
| update-leaf | 20 | compose | 800 | 700–1307 | 2.67x | 93 | 1.90x | 1 | yes |
| update-leaf | 20 | fusion | 812 | 700–1233 | 2.71x | 52 | 1.06x | 1 | yes |
| update-leaf | 20 | fusion-charm | 1200 | 1044–1317 | 4.00x | 53 | 1.08x | 0 | yes |
| update-leaf | 20 | react | 950 | 900–1270 | 3.17x | 355 | 7.24x | 0 | yes |
| update-leaf | 20 | react-reflex | 738 | 500–1259 | 2.46x | 293 | 5.98x | 1 | yes |
| update-leaf | 20 | react-upstream | 963 | 527–1324 | 3.21x | 291 | 5.94x | 0 | yes |
| update-leaf | 20 | roact | 800 | 600–922 | 2.67x | 959 | 19.57x | 1 | yes |
| update-leaf | 20 | seam | 1049 | 908–1439 | 3.50x | 40 | 0.82x | 0 | yes |
| update-leaf | 20 | signals | 700 | 501–1150 | 2.33x | 51 | 1.04x | 1 | yes |
| update-leaf | 20 | vide | 1004 | 685–1331 | 3.35x | 11 | 0.22x | 0 | yes |
| update-batched | 20 | plain | 4562 | 4172–4912 | 1.00x | 20 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 10512 | 10022–10824 | 2.30x | 932 | 46.60x | 0 | yes |
| update-batched | 20 | compose | 6948 | 6517–7207 | 1.52x | 408 | 20.40x | 9 | yes |
| update-batched | 20 | fusion | 20352 | 19966–21278 | 4.46x | 517 | 25.85x | 1 | yes |
| update-batched | 20 | fusion-charm | 35823 | 34854–37086 | 7.85x | 1110 | 55.50x | 1 | yes |
| update-batched | 20 | react | 8026 | 7723–8141 | 1.76x | 533 | 26.65x | 1 | yes |
| update-batched | 20 | react-reflex | 53885 | 49969–61196 | 11.81x | 775 | 38.75x | 16 | yes |
| update-batched | 20 | react-upstream | 7549 | 7097–8116 | 1.65x | 477 | 23.85x | 8 | yes |
| update-batched | 20 | roact | 8324 | 7903–8469 | 1.82x | 1162 | 58.10x | 0 | yes |
| update-batched | 20 | seam | 13433 | 11980–13725 | 2.94x | 1848 | 92.40x | 1 | yes |
| update-batched | 20 | signals | 9357 | 8945–9492 | 2.05x | 596 | 29.80x | 0 | yes |
| update-batched | 20 | vide | 8416 | 8136–9179 | 1.84x | 332 | 16.60x | 0 | yes |
| update-repeated | 10 | plain | 52 | 44–60 | 1.00x | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3612 | 3382–3619 | 69.41x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | compose | 227 | 206–439 | 4.36x | 5 | 2.50x | 2 | yes |
| update-repeated | 10 | fusion | 25828 | 24672–26407 | 496.33x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1166 | 1084–1238 | 22.41x | 6 | 3.00x | 1 | yes |
| update-repeated | 10 | react | 7263 | 7000–7636 | 139.57x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 706 | 400–993 | 13.57x | 12 | 6.00x | 8 | yes |
| update-repeated | 10 | react-upstream | 7443 | 6733–7709 | 143.03x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5258 | 5101–5353 | 101.04x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | seam | 1542 | 1300–1815 | 29.63x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 921 | 800–988 | 17.70x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 596 | 362–650 | 11.44x | 3 | 1.50x | 1 | yes |
| branch-swap | 20 | plain | 14111 | 13137–14506 | 1.00x | 2 | 1.00x | 8 | yes |
| branch-swap | 20 | blend | 16762 | 15606–16917 | 1.19x | 35 | 17.50x | 1 | yes |
| branch-swap | 20 | compose | 13570 | 13414–13800 | 0.96x | 8 | 4.00x | 2 | yes |
| branch-swap | 20 | fusion | 14167 | 14107–14807 | 1.00x | 5 | 2.50x | 1 | yes |
| branch-swap | 20 | fusion-charm | 14216 | 13770–14264 | 1.01x | 7 | 3.50x | 0 | yes |
| branch-swap | 20 | react | 16455 | 15553–17858 | 1.17x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 16847 | 15411–17069 | 1.19x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 16444 | 16201–17240 | 1.17x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | roact | 14547 | 13908–14691 | 1.03x | 12 | 6.00x | 0 | yes |
| branch-swap | 20 | seam | 11906 | 11601–12210 | 0.84x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | signals | 12821 | 12550–14116 | 0.91x | 13 | 6.50x | 8 | yes |
| branch-swap | 20 | vide | 13899 | 13685–14458 | 0.98x | 5 | 2.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2401 | 2235–2636 | 1.00x | 64 | 1.00x | 8 | yes |
| keyed-prepend | 10 | blend | 4662 | 4602–5480 | 1.94x | 1490 | 23.28x | 1 | yes |
| keyed-prepend | 10 | compose | 4258 | 4054–4378 | 1.77x | 571 | 8.92x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 23030 | 20833–24176 | 9.59x | 1520 | 23.75x | 2 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 21038 | 19955–22847 | 8.76x | 1513 | 23.64x | 1 | yes |
| keyed-prepend | 10 | react | 15820 | 15529–16724 | 6.59x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16228 | 14943–16801 | 6.76x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16511 | 15632–16620 | 6.88x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | roact | 6700 | 6401–7066 | 2.79x | 361 | 5.64x | 0 | yes |
| keyed-prepend | 10 | seam | 11312 | 10709–12884 | 4.71x | 2455 | 38.36x | 0 | yes |
| keyed-prepend | 10 | signals | 2704 | 2586–2904 | 1.13x | 62 | 0.97x | 0 | yes |
| keyed-prepend | 10 | vide | 4864 | 4708–5174 | 2.03x | 639 | 9.98x | 1 | yes |
| keyed-insert | 10 | plain | 1801 | 1676–1951 | 1.00x | 65 | 1.00x | 1 | yes |
| keyed-insert | 10 | blend | 3908 | 3704–4010 | 2.17x | 1490 | 22.92x | 0 | yes |
| keyed-insert | 10 | compose | 3106 | 2866–3620 | 1.72x | 563 | 8.66x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 19863 | 19021–20336 | 11.03x | 1535 | 23.62x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 17613 | 16535–18041 | 9.78x | 1521 | 23.40x | 1 | yes |
| keyed-insert | 10 | react | 13533 | 13158–15549 | 7.51x | 811 | 12.48x | 1 | yes |
| keyed-insert | 10 | react-reflex | 13227 | 13026–13991 | 7.34x | 866 | 13.32x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13343 | 13014–13992 | 7.41x | 811 | 12.48x | 0 | yes |
| keyed-insert | 10 | roact | 5507 | 5438–5736 | 3.06x | 369 | 5.68x | 1 | yes |
| keyed-insert | 10 | seam | 10314 | 9800–10901 | 5.73x | 2455 | 37.77x | 0 | yes |
| keyed-insert | 10 | signals | 1854 | 1768–1987 | 1.03x | 62 | 0.95x | 9 | yes |
| keyed-insert | 10 | vide | 3454 | 3296–3690 | 1.92x | 646 | 9.94x | 0 | yes |
| keyed-shuffle | 10 | plain | 1927 | 1751–2002 | 1.00x | 52 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 2900 | 2503–3335 | 1.51x | 1440 | 27.69x | 1 | yes |
| keyed-shuffle | 10 | compose | 3057 | 2950–3225 | 1.59x | 578 | 11.12x | 17 | yes |
| keyed-shuffle | 10 | fusion | 18710 | 16443–19318 | 9.71x | 1390 | 26.73x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 17665 | 16303–18347 | 9.17x | 1392 | 26.77x | 0 | yes |
| keyed-shuffle | 10 | react | 26828 | 25943–27622 | 13.92x | 779 | 14.98x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27487 | 26514–27721 | 14.27x | 779 | 14.98x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27688 | 26633–28738 | 14.37x | 787 | 15.13x | 0 | yes |
| keyed-shuffle | 10 | roact | 5800 | 5201–6488 | 3.01x | 360 | 6.92x | 0 | yes |
| keyed-shuffle | 10 | seam | 9724 | 8817–9875 | 5.05x | 2439 | 46.90x | 0 | yes |
| keyed-shuffle | 10 | signals | 2087 | 2001–2182 | 1.08x | 60 | 1.15x | 1 | yes |
| keyed-shuffle | 10 | vide | 3813 | 3400–3909 | 1.98x | 622 | 11.96x | 0 | yes |
| events | 1 | plain | 1040 | 930–1200 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | blend | 1209 | 1100–1611 | 1.16x | 2 | 1.00x | 1 | yes |
| events | 1 | compose | 1414 | 1205–1903 | 1.36x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 1253 | 961–1715 | 1.20x | 0 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 1240 | 1000–1407 | 1.19x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 1553 | 1200–1731 | 1.49x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 1301 | 1007–2037 | 1.25x | 0 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 1700 | 1265–2024 | 1.63x | 0 | 0.50x | 0 | yes |
| events | 1 | roact | 1010 | 906–1218 | 0.97x | 1 | 0.50x | 0 | yes |
| events | 1 | seam | 500 | 444–1215 | 0.48x | 9 | 4.50x | 0 | yes |
| events | 1 | signals | 1106 | 612–1118 | 1.06x | 9 | 4.50x | 0 | yes |
| events | 1 | vide | 1328 | 1062–1703 | 1.28x | 1 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 2793 | 2504–3909 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 10924 | 10728–12008 | 3.91x | 1763 | 23.82x | 0 | yes |
| animate-many | 1 | compose | 6625 | 5758–6828 | 2.37x | 655 | 8.85x | 12 | yes |
| animate-many | 1 | fusion | 103603 | 103243–105548 | 37.09x | 1112 | 15.03x | 0 | yes |
| animate-many | 1 | fusion-charm | 104827 | 104242–107763 | 37.53x | 1122 | 15.16x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20915 | 18804–23107 | 7.49x | 2890 | 39.05x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 7736 | 7622–8326 | 2.77x | 392 | 5.30x | 0 | yes |
| status-panel | 10 | plain | 576 | 502–592 | 1.00x | 3 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1251 | 1058–1306 | 2.17x | 70 | 23.33x | 0 | yes |
| status-panel | 10 | compose | 1176 | 804–1378 | 2.04x | 33 | 11.00x | 2 | yes |
| status-panel | 10 | fusion | 1606 | 1500–1992 | 2.79x | 69 | 23.00x | 1 | yes |
| status-panel | 10 | fusion-charm | 1625 | 1597–1855 | 2.82x | 70 | 23.33x | 0 | yes |
| status-panel | 10 | react | 2033 | 1949–2216 | 3.53x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | react-reflex | 2014 | 1866–2273 | 3.50x | 45 | 15.00x | 0 | yes |
| status-panel | 10 | react-upstream | 2208 | 2010–2328 | 3.84x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | roact | 1107 | 900–1268 | 1.92x | 33 | 11.00x | 0 | yes |
| status-panel | 10 | seam | 1815 | 1417–2363 | 3.15x | 133 | 44.33x | 0 | yes |
| status-panel | 10 | signals | 1015 | 826–1145 | 1.76x | 14 | 4.67x | 0 | yes |
| status-panel | 10 | vide | 1092 | 824–1320 | 1.90x | 32 | 10.67x | 0 | yes |
| scene-3d | 10 | plain | 2676 | 2550–3100 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4458 | 4312–4598 | 1.67x | 550 | 50.00x | 1 | yes |
| scene-3d | 10 | compose | 3238 | 3092–3405 | 1.21x | 187 | 17.00x | 2 | yes |
| scene-3d | 10 | fusion | 34144 | 33324–35264 | 12.76x | 519 | 47.18x | 0 | yes |
| scene-3d | 10 | fusion-charm | 31528 | 30816–32373 | 11.78x | 523 | 47.55x | 0 | yes |
| scene-3d | 10 | react | 3624 | 3444–3845 | 1.35x | 223 | 20.27x | 1 | yes |
| scene-3d | 10 | react-reflex | 3175 | 2900–3287 | 1.19x | 224 | 20.36x | 0 | yes |
| scene-3d | 10 | react-upstream | 3288 | 3000–3727 | 1.23x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 3306 | 3235–3606 | 1.24x | 582 | 52.91x | 1 | yes |
| scene-3d | 10 | seam | 8432 | 8357–9056 | 3.15x | 1755 | 159.55x | 0 | yes |
| scene-3d | 10 | signals | 5923 | 5400–6200 | 2.21x | 690 | 62.73x | 0 | yes |
| scene-3d | 10 | vide | 3810 | 3662–3862 | 1.42x | 203 | 18.45x | 0 | yes |
| derived-diamond | 3 | plain | 24 | 19–48 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 100 | 100–204 | 4.21x | 28 | 7.00x | 0 | yes |
| derived-diamond | 3 | compose | 125 | 100–143 | 5.25x | 11 | 2.75x | 2 | yes |
| derived-diamond | 3 | fusion | 102 | 100–156 | 4.26x | 8 | 2.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 150 | 126–180 | 6.31x | 11 | 2.75x | 1 | yes |
| derived-diamond | 3 | react | 318 | 267–344 | 13.34x | 7 | 1.75x | 3 | yes |
| derived-diamond | 3 | react-reflex | 301 | 233–403 | 12.66x | 10 | 2.50x | 0 | yes |
| derived-diamond | 3 | react-upstream | 290 | 167–400 | 12.17x | 7 | 1.75x | 4 | yes |
| derived-diamond | 3 | roact | 153 | 100–234 | 6.42x | 2 | 0.50x | 0 | yes |
| derived-diamond | 3 | seam | 200 | 100–215 | 8.40x | 14 | 3.50x | 1 | yes |
| derived-diamond | 3 | signals | 125 | 100–150 | 5.25x | 8 | 2.00x | 0 | yes |
| derived-diamond | 3 | vide | 101 | 100–150 | 4.23x | 6 | 1.50x | 0 | yes |
| derived-chain-100 | 3 | plain | 51 | 38–78 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 204 | 175–250 | 4.01x | 131 | 2.30x | 2 | yes |
| derived-chain-100 | 3 | fusion | 980 | 900–1100 | 19.28x | 127 | 2.23x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 900 | 850–926 | 17.71x | 121 | 2.12x | 1 | yes |
| derived-chain-100 | 3 | react | 585 | 480–733 | 11.51x | 76 | 1.33x | 12 | yes |
| derived-chain-100 | 3 | react-reflex | 534 | 438–636 | 10.50x | 80 | 1.40x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 503 | 400–568 | 9.89x | 69 | 1.21x | 11 | yes |
| derived-chain-100 | 3 | roact | 125 | 100–228 | 2.46x | 10 | 0.18x | 4 | yes |
| derived-chain-100 | 3 | seam | 650 | 501–800 | 12.79x | 271 | 4.75x | 1 | yes |
| derived-chain-100 | 3 | signals | 275 | 200–325 | 5.41x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 156 | 127–234 | 3.07x | 93 | 1.63x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–100 | 1.00x | 498 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 225 | 125–306 | 2.25x | 1527 | 3.07x | 1 | yes |
| derived-fan-in-1000 | 3 | compose | 325 | 300–400 | 3.25x | 695 | 1.40x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 2129 | 1936–2203 | 21.29x | 889 | 1.79x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2100 | 1934–2204 | 21.00x | 2813 | 5.65x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2671 | 2202–3308 | 26.71x | 671 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7507 | 6900–9408 | 75.07x | 5622 | 11.29x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2562 | 2150–2762 | 25.61x | 663 | 1.33x | 35 | yes |
| derived-fan-in-1000 | 3 | roact | 554 | 528–654 | 5.54x | 105 | 0.21x | 11 | yes |
| derived-fan-in-1000 | 3 | seam | 2802 | 2708–2900 | 28.02x | 2955 | 5.93x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 778 | 675–800 | 7.79x | 1213 | 2.44x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 550 | 475–583 | 5.50x | 521 | 1.05x | 1 | yes |
| filter-as-you-type | 1 | plain | 8514 | 7600–9415 | 1.00x | 34 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16634 | 15501–17836 | 1.95x | 2646 | 77.82x | 0 | yes |
| filter-as-you-type | 1 | compose | 11145 | 10511–11563 | 1.31x | 841 | 24.74x | 2 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28753 | 26825–29837 | 3.38x | 2465 | 72.50x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 27502 | 26001–27636 | 3.23x | 2467 | 72.56x | 0 | yes |
| filter-as-you-type | 1 | react | 21448 | 20341–21917 | 2.52x | 84 | 2.47x | 20 | yes |
| filter-as-you-type | 1 | react-reflex | 20334 | 19933–20612 | 2.39x | 830 | 24.41x | 15 | yes |
| filter-as-you-type | 1 | react-upstream | 21503 | 21152–21906 | 2.53x | 60 | 1.76x | 4 | yes |
| filter-as-you-type | 1 | roact | 11809 | 10926–11912 | 1.39x | 503 | 14.79x | 11 | yes |
| filter-as-you-type | 1 | seam | 25107 | 20414–28448 | 2.95x | 3989 | 117.32x | 1 | yes |
| filter-as-you-type | 1 | signals | 7768 | 7316–8047 | 0.91x | 37 | 1.09x | 1 | yes |
| filter-as-you-type | 1 | vide | 10900 | 10508–11520 | 1.28x | 959 | 28.21x | 0 | yes |
| theme-propagation | 3 | plain | 47454 | 45548–57076 | 1.00x | 198 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 47076 | 45944–48078 | 0.99x | 2070 | 10.45x | 0 | yes |
| theme-propagation | 3 | compose | 50648 | 50259–51652 | 1.07x | 572 | 2.89x | 1 | yes |
| theme-propagation | 3 | fusion | 52286 | 50849–53152 | 1.10x | 874 | 4.41x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 52868 | 52057–55826 | 1.11x | 877 | 4.43x | 1 | yes |
| theme-propagation | 3 | react | 54070 | 52502–58280 | 1.14x | 2035 | 10.28x | 0 | yes |
| theme-propagation | 3 | react-reflex | 46738 | 45939–49329 | 0.98x | 2028 | 10.24x | 0 | yes |
| theme-propagation | 3 | react-upstream | 54996 | 53953–61448 | 1.16x | 2035 | 10.28x | 9 | yes |
| theme-propagation | 3 | roact | 51275 | 50346–54318 | 1.08x | 3278 | 16.56x | 0 | yes |
| theme-propagation | 3 | seam | 46056 | 45321–46948 | 0.97x | 3469 | 17.52x | 0 | yes |
| theme-propagation | 3 | signals | 52238 | 49722–53282 | 1.10x | 903 | 4.56x | 0 | yes |
| theme-propagation | 3 | vide | 51139 | 50247–51467 | 1.08x | 592 | 2.99x | 0 | yes |
| hud-per-frame | 1 | plain | 2980 | 2557–3805 | 1.00x | 22 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 6144 | 4969–6367 | 2.06x | 70 | 3.20x | 0 | yes |
| hud-per-frame | 1 | compose | 4872 | 4592–5162 | 1.63x | 23 | 1.05x | 0 | yes |
| hud-per-frame | 1 | fusion | 10593 | 9579–11154 | 3.55x | 50 | 2.27x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13455 | 13048–13938 | 4.51x | 91 | 4.14x | 4 | yes |
| hud-per-frame | 1 | react | 4968 | 4370–5704 | 1.67x | 26 | 1.16x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7423 | 6937–8100 | 2.49x | 58 | 2.64x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 3945 | 3408–4224 | 1.32x | 34 | 1.55x | 4 | yes |
| hud-per-frame | 1 | roact | 4511 | 4460–4624 | 1.51x | 85 | 3.86x | 0 | yes |
| hud-per-frame | 1 | seam | 9181 | 7604–9491 | 3.08x | 160 | 7.30x | 0 | yes |
| hud-per-frame | 1 | signals | 5250 | 5083–6101 | 1.76x | 70 | 3.18x | 5 | yes |
| hud-per-frame | 1 | vide | 4927 | 4082–5995 | 1.65x | 18 | 0.84x | 0 | yes |
| teardown-under-load | 1 | plain | 47249 | 45177–49763 | 1.00x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 70951 | 63436–81813 | 1.50x | 14 | 2.80x | 0 | yes |
| teardown-under-load | 1 | compose | 54259 | 48047–57859 | 1.15x | 7 | 1.40x | 2 | yes |
| teardown-under-load | 1 | fusion | 75288 | 71488–79423 | 1.59x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 74673 | 73893–78157 | 1.58x | 7 | 1.40x | 0 | yes |
| teardown-under-load | 1 | react | 73396 | 67120–77399 | 1.55x | 1077 | 215.40x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 73356 | 68656–76241 | 1.55x | 1078 | 215.60x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 71997 | 70288–74774 | 1.52x | 1070 | 214.00x | 0 | yes |
| teardown-under-load | 1 | roact | 69355 | 56909–77614 | 1.47x | 78 | 15.60x | 1 | yes |
| teardown-under-load | 1 | seam | 66611 | 63341–68071 | 1.41x | 8 | 1.60x | 14 | yes |
| teardown-under-load | 1 | signals | 55161 | 47654–57495 | 1.17x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | vide | 56375 | 50379–59079 | 1.19x | 13 | 2.60x | 1 | yes |
| open-close-retention | 1 | plain | 66419 | 65657–66995 | 1.00x | 16 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 120495 | 119877–121187 | 1.81x | 6 | 0.38x | 0 | yes |
| open-close-retention | 1 | compose | 81495 | 80896–82122 | 1.23x | 7 | 0.44x | 2 | yes |
| open-close-retention | 1 | fusion | 132205 | 130521–135311 | 1.99x | 13 | 0.81x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 133964 | 133588–135256 | 2.02x | 6 | 0.38x | 0 | yes |
| open-close-retention | 1 | react | 117320 | 115960–119368 | 1.77x | 284 | 17.72x | 3 | yes |
| open-close-retention | 1 | react-reflex | 114490 | 112159–116098 | 1.72x | 291 | 18.19x | 0 | yes |
| open-close-retention | 1 | react-upstream | 117539 | 115226–118580 | 1.77x | 284 | 17.75x | 0 | yes |
| open-close-retention | 1 | roact | 108284 | 107120–111042 | 1.63x | 23 | 1.44x | 1 | yes |
| open-close-retention | 1 | seam | 112101 | 107584–116491 | 1.69x | 17 | 1.06x | 1 | yes |
| open-close-retention | 1 | signals | 83894 | 83460–84068 | 1.26x | 13 | 0.81x | 1 | yes |
| open-close-retention | 1 | vide | 88870 | 87707–89371 | 1.34x | 12 | 0.75x | 0 | yes |
| tree-expand-collapse | 1 | plain | 11422 | 9611–11814 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 20154 | 18611–20807 | 1.76x | 789 | 39.45x | 1 | yes |
| tree-expand-collapse | 1 | compose | 12242 | 11504–12742 | 1.07x | 79 | 3.95x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24881 | 24712–25821 | 2.18x | 165 | 8.25x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23515 | 23209–26245 | 2.06x | 175 | 8.75x | 2 | yes |
| tree-expand-collapse | 1 | react | 19103 | 18624–20232 | 1.67x | 69 | 3.45x | 20 | yes |
| tree-expand-collapse | 1 | react-reflex | 19196 | 18277–19750 | 1.68x | 672 | 33.60x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 19747 | 18361–20591 | 1.73x | 70 | 3.50x | 20 | yes |
| tree-expand-collapse | 1 | roact | 11226 | 10622–11704 | 0.98x | 35 | 1.75x | 4 | yes |
| tree-expand-collapse | 1 | seam | 26741 | 25069–28722 | 2.34x | 148 | 7.40x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8039 | 7802–8261 | 0.70x | 22 | 1.10x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11784 | 11035–12019 | 1.03x | 71 | 3.55x | 1 | yes |
| form-validation | 1 | plain | 2472 | 2346–2673 | 1.00x | 46 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 3732 | 3148–4482 | 1.51x | 335 | 7.28x | 0 | yes |
| form-validation | 1 | compose | 3643 | 3422–3844 | 1.47x | 106 | 2.30x | 1 | yes |
| form-validation | 1 | fusion | 4876 | 4722–4977 | 1.97x | 118 | 2.57x | 0 | yes |
| form-validation | 1 | fusion-charm | 4970 | 4921–5476 | 2.01x | 155 | 3.37x | 0 | yes |
| form-validation | 1 | react | 4906 | 4620–5265 | 1.98x | 66 | 1.43x | 0 | yes |
| form-validation | 1 | react-reflex | 5565 | 4903–5857 | 2.25x | 83 | 1.80x | 0 | yes |
| form-validation | 1 | react-upstream | 4892 | 4721–5345 | 1.98x | 66 | 1.43x | 0 | yes |
| form-validation | 1 | roact | 4379 | 4097–5151 | 1.77x | 216 | 4.70x | 0 | yes |
| form-validation | 1 | seam | 6455 | 4072–6510 | 2.61x | 356 | 7.74x | 0 | yes |
| form-validation | 1 | signals | 3566 | 3242–3677 | 1.44x | 155 | 3.37x | 1 | yes |
| form-validation | 1 | vide | 3671 | 3273–4346 | 1.49x | 70 | 1.52x | 0 | yes |
| table-sort-filter | 1 | plain | 17407 | 16715–18957 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 36620 | 35775–39666 | 2.10x | 5388 | 80.42x | 0 | yes |
| table-sort-filter | 1 | compose | 26259 | 25534–26757 | 1.51x | 1632 | 24.36x | 18 | yes |
| table-sort-filter | 1 | fusion (workaround) | 57934 | 53373–61464 | 3.33x | 4695 | 70.07x | 9 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 52950 | 49526–56387 | 3.04x | 4714 | 70.36x | 2 | yes |
| table-sort-filter | 1 | react | 97943 | 93340–99254 | 5.63x | 2109 | 31.48x | 11 | yes |
| table-sort-filter | 1 | react-reflex | 94654 | 91634–100407 | 5.44x | 2115 | 31.57x | 15 | yes |
| table-sort-filter | 1 | react-upstream | 97200 | 96695–100464 | 5.58x | 2116 | 31.58x | 19 | yes |
| table-sort-filter | 1 | roact | 25315 | 25141–27462 | 1.45x | 1014 | 15.13x | 3 | yes |
| table-sort-filter | 1 | seam | 56263 | 50942–62344 | 3.23x | 7760 | 115.82x | 0 | yes |
| table-sort-filter | 1 | signals | 18264 | 17621–18754 | 1.05x | 68 | 1.01x | 0 | yes |
| table-sort-filter | 1 | vide | 25749 | 24825–26944 | 1.48x | 1922 | 28.69x | 8 | yes |
| library-load | 1 | plain | 48 | 35–75 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 720 | 671–885 | 15.00x | 467 | 467.00x | 464 | yes |
| library-load | 1 | compose | 661 | 604–676 | 13.77x | 67 | 67.00x | 64 | yes |
| library-load | 1 | fusion | 1303 | 1281–1428 | 27.14x | 256 | 256.00x | 255 | yes |
| library-load | 1 | fusion-charm | 1486 | 1283–1825 | 30.96x | 310 | 310.00x | 317 | yes |
| library-load | 1 | react | 4886 | 4658–5155 | 101.79x | 1825 | 1825.00x | 1824 | yes |
| library-load | 1 | react-reflex | 5202 | 5075–5638 | 108.38x | 1965 | 1965.00x | 1964 | yes |
| library-load | 1 | react-upstream | 5090 | 4626–5398 | 106.04x | 1995 | 1995.00x | 1993 | yes |
| library-load | 1 | roact | 452 | 379–458 | 9.41x | 161 | 161.00x | 158 | yes |
| library-load | 1 | seam | 1442 | 1326–2002 | 30.05x | 234 | 234.00x | 239 | yes |
| library-load | 1 | signals | 239 | 219–328 | 4.97x | 42 | 42.00x | 49 | yes |
| library-load | 1 | vide | 331 | 308–347 | 6.89x | 138 | 138.00x | 138 | yes |
| rows-append-1000 | 1 | plain | 95033 | 94290–97719 | 1.00x | 6541 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 153297 | 146428–164450 | 1.61x | 38449 | 5.88x | 0 | yes |
| rows-append-1000 | 1 | compose | 114360 | 111741–152917 | 1.20x | 11043 | 1.69x | 10 | yes |
| rows-append-1000 | 1 | fusion | 341203 | 335905–376800 | 3.59x | 21387 | 3.27x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 348701 | 342020–353862 | 3.67x | 28722 | 4.39x | 9 | yes |
| rows-append-1000 | 1 | react | 190983 | 179810–204106 | 2.01x | 23394 | 3.58x | 192 | yes |
| rows-append-1000 | 1 | react-reflex | 210156 | 202526–238253 | 2.21x | 24870 | 3.80x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 213662 | 189303–233817 | 2.25x | 22985 | 3.51x | 16 | yes |
| rows-append-1000 | 1 | roact | 156416 | 150619–160909 | 1.65x | 33154 | 5.07x | 1 | yes |
| rows-append-1000 | 1 | seam | 174922 | 161401–204269 | 1.84x | 46768 | 7.15x | 9 | yes |
| rows-append-1000 | 1 | signals | 112125 | 102515–139736 | 1.18x | 17365 | 2.65x | 1 | yes |
| rows-append-1000 | 1 | vide | 114611 | 109868–145648 | 1.21x | 10440 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 18323 | 18114–18918 | 1.00x | 1229 | 1.00x | 8 | yes |
| rows-clear | 1 | blend | 35363 | 34226–36015 | 1.93x | 4177 | 3.40x | 8 | yes |
| rows-clear | 1 | compose | 25028 | 22922–26322 | 1.37x | 1893 | 1.54x | 10 | yes |
| rows-clear | 1 | fusion | 78216 | 74285–80692 | 4.27x | 3480 | 2.83x | 0 | yes |
| rows-clear | 1 | fusion-charm | 74688 | 72334–77373 | 4.08x | 7393 | 6.02x | 1 | yes |
| rows-clear | 1 | react | 25739 | 24417–26429 | 1.40x | 4495 | 3.66x | 0 | yes |
| rows-clear | 1 | react-reflex | 27952 | 27199–28879 | 1.53x | 6490 | 5.28x | 29 | yes |
| rows-clear | 1 | react-upstream | 24205 | 23425–25441 | 1.32x | 4487 | 3.65x | 0 | yes |
| rows-clear | 1 | roact | 25332 | 23520–26139 | 1.38x | 4206 | 3.42x | 1 | yes |
| rows-clear | 1 | seam | 35619 | 33076–41465 | 1.94x | 9279 | 7.55x | 1 | yes |
| rows-clear | 1 | signals | 22113 | 21610–23245 | 1.21x | 4450 | 3.62x | 8 | yes |
| rows-clear | 1 | vide | 19347 | 19212–20595 | 1.06x | 1613 | 1.31x | 0 | yes |
| rows-create-1000 | 1 | plain | 95242 | 88798–97040 | 1.00x | 3135 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 150455 | 140628–154119 | 1.58x | 19601 | 6.25x | 0 | yes |
| rows-create-1000 | 1 | compose | 113116 | 108467–122752 | 1.19x | 5819 | 1.86x | 2 | yes |
| rows-create-1000 | 1 | fusion | 190055 | 180446–200163 | 2.00x | 10883 | 3.47x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 187999 | 176492–194245 | 1.97x | 14749 | 4.70x | 1 | yes |
| rows-create-1000 | 1 | react | 165567 | 156284–192346 | 1.74x | 8152 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 184687 | 167452–197495 | 1.94x | 9074 | 2.89x | 44 | yes |
| rows-create-1000 | 1 | react-upstream | 164985 | 159792–173357 | 1.73x | 8127 | 2.59x | 0 | yes |
| rows-create-1000 | 1 | roact | 127563 | 120604–137126 | 1.34x | 16922 | 5.40x | 1 | yes |
| rows-create-1000 | 1 | seam | 156021 | 125814–171038 | 1.64x | 23878 | 7.62x | 0 | yes |
| rows-create-1000 | 1 | signals | 105926 | 98089–114495 | 1.11x | 9114 | 2.91x | 0 | yes |
| rows-create-1000 | 1 | vide | 112690 | 100187–127464 | 1.18x | 4965 | 1.58x | 1 | yes |
| rows-create-10000 | 1 | plain | 1100814 | 1096859–1218222 | 1.00x | 29780 | 1.00x | 4 | yes |
| rows-create-10000 | 1 | blend | 1684554 | 1648312–1838047 | 1.53x | 186498 | 6.26x | 4 | yes |
| rows-create-10000 | 1 | compose | 1372217 | 1362067–1372289 | 1.25x | 55552 | 1.87x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6318398 | 6142352–6419206 | 5.74x | 104730 | 3.52x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6419358 | 6415943–6448163 | 5.83x | 145075 | 4.87x | 0 | yes |
| rows-create-10000 | 1 | react | 5186260 | 4996750–5222638 | 4.71x | 76170 | 2.56x | 717 | yes |
| rows-create-10000 | 1 | react-reflex | 5259785 | 5251577–5273129 | 4.78x | 86136 | 2.89x | 802 | yes |
| rows-create-10000 | 1 | react-upstream | 5138334 | 4903191–5348476 | 4.67x | 78308 | 2.63x | 634 | yes |
| rows-create-10000 | 1 | roact | 1523297 | 1436620–1554830 | 1.38x | 166178 | 5.58x | 0 | yes |
| rows-create-10000 | 1 | seam | 1662724 | 1649629–1727587 | 1.51x | 234960 | 7.89x | 20 | yes |
| rows-create-10000 | 1 | signals | 1247182 | 1183599–1280017 | 1.13x | 89165 | 2.99x | 0 | yes |
| rows-create-10000 | 1 | vide | 1271380 | 1257251–1344213 | 1.15x | 48444 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 804 | 685–835 | 1.00x | 2740 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1250 | 1159–1300 | 1.56x | 18284 | 6.67x | 1 | yes |
| rows-remove-one | 1 | compose | 950 | 863–1103 | 1.18x | 4949 | 1.81x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 64072 | 61950–70473 | 79.72x | 11122 | 4.06x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 59807 | 59351–61779 | 74.42x | 15042 | 5.49x | 1 | yes |
| rows-remove-one | 1 | react | 35131 | 24023–41922 | 43.71x | 15541 | 5.67x | 25 | yes |
| rows-remove-one | 1 | react-reflex | 32489 | 30150–43683 | 40.43x | 16406 | 5.99x | 36 | yes |
| rows-remove-one | 1 | react-upstream | 25122 | 23311–54595 | 31.26x | 15476 | 5.65x | 0 | yes |
| rows-remove-one | 1 | roact | 16631 | 15500–16814 | 20.69x | 16773 | 6.12x | 8 | yes |
| rows-remove-one | 1 | seam | 6410 | 4700–6607 | 7.98x | 23213 | 8.47x | 0 | yes |
| rows-remove-one | 1 | signals | 1557 | 1468–1634 | 1.94x | 8614 | 3.14x | 0 | yes |
| rows-remove-one | 1 | vide | 1200 | 1000–1252 | 1.49x | 4553 | 1.66x | 1 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 2688 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 704 | 651–802 | 7.04x | 18270 | 6.80x | 9 | yes |
| rows-swap | 1 | compose | 300 | 267–333 | 3.00x | 4927 | 1.83x | 11 | yes |
| rows-swap | 1 | fusion | 61283 | 57364–62109 | 612.83x | 9559 | 3.56x | 0 | yes |
| rows-swap | 1 | fusion-charm | 59501 | 59032–59782 | 595.01x | 14571 | 5.42x | 1 | yes |
| rows-swap | 1 | react | 52738 | 52061–58007 | 527.38x | 15433 | 5.74x | 0 | yes |
| rows-swap | 1 | react-reflex | 66826 | 65282–74310 | 668.26x | 16378 | 6.09x | 19 | yes |
| rows-swap | 1 | react-upstream | 61400 | 55345–78428 | 614.00x | 15121 | 5.63x | 120 | yes |
| rows-swap | 1 | roact | 16411 | 14905–17420 | 164.11x | 16292 | 6.06x | 0 | yes |
| rows-swap | 1 | seam | 5801 | 4738–6023 | 58.01x | 23212 | 8.64x | 1 | yes |
| rows-swap | 1 | signals | 575 | 533–668 | 5.75x | 8610 | 3.20x | 1 | yes |
| rows-swap | 1 | vide | 200 | 169–233 | 2.00x | 4516 | 1.68x | 8 | yes |
| rows-update-every-10th | 1 | plain | 1968 | 1836–2100 | 1.00x | 3183 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1903 | 1865–2100 | 0.97x | 19264 | 6.05x | 0 | yes |
| rows-update-every-10th | 1 | compose | 2001 | 1871–2137 | 1.02x | 5465 | 1.72x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 2004 | 1900–2200 | 1.02x | 10551 | 3.31x | 7 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2308 | 2100–2403 | 1.17x | 14463 | 4.54x | 8 | yes |
| rows-update-every-10th | 1 | react | 2104 | 2052–2173 | 1.07x | 7821 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 4365 | 2900–4902 | 2.22x | 8814 | 2.77x | 4 | yes |
| rows-update-every-10th | 1 | react-upstream | 2050 | 1950–2100 | 1.04x | 7853 | 2.47x | 0 | yes |
| rows-update-every-10th | 1 | roact | 1954 | 1908–2054 | 0.99x | 16689 | 5.24x | 0 | yes |
| rows-update-every-10th | 1 | seam | 4800 | 4100–5104 | 2.44x | 24171 | 7.59x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2022 | 2008–2175 | 1.03x | 9322 | 2.93x | 0 | yes |
| rows-update-every-10th | 1 | vide | 1979 | 1933–2089 | 1.01x | 5124 | 1.61x | 0 | yes |

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
| blend | 29 | 2.31x | 10.45x | 2.27x | 10.14x |
| compose | 30 | 1.79x | 3.80x | 1.73x | 3.76x |
| fusion | 30 | 6.50x | 5.94x | 5.88x | 5.95x |
| fusion-charm | 30 | 6.09x | 7.34x | 5.50x | 7.48x |
| react | 29 | 5.06x | 6.24x | 4.91x | 6.59x |
| react-reflex | 29 | 5.32x | 9.60x | 5.19x | 10.28x |
| react-upstream | 29 | 4.97x | 6.16x | 4.85x | 6.52x |
| roact | 29 | 2.74x | 4.99x | 2.75x | 5.62x |
| seam | 30 | 3.88x | 12.72x | 3.63x | 12.66x |
| signals | 29 | 1.80x | 2.95x | 1.73x | 2.95x |
| vide | 30 | 1.85x | 3.21x | 1.79x | 3.23x |
