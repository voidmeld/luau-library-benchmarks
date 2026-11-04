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
| Harness revision | `83e7221` |
| Date | 2026-11-04 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 200–400 | 1.00x | 57 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 804 | 300–1622 | 2.68x | 773 | 13.56x | 1 | yes |
| update-leaf | 20 | compose | 1014 | 838–1182 | 3.38x | 61 | 1.07x | 2 | yes |
| update-leaf | 20 | fusion | 1088 | 739–1289 | 3.63x | 60 | 1.05x | 1 | yes |
| update-leaf | 20 | fusion-charm | 1401 | 1008–1745 | 4.67x | 61 | 1.07x | 8 | yes |
| update-leaf | 20 | react | 811 | 518–1218 | 2.70x | 355 | 6.23x | 8 | yes |
| update-leaf | 20 | react-reflex | 986 | 508–1506 | 3.29x | 301 | 5.28x | 8 | yes |
| update-leaf | 20 | react-upstream | 931 | 616–1322 | 3.10x | 291 | 5.11x | 0 | yes |
| update-leaf | 20 | roact | 721 | 427–1000 | 2.40x | 960 | 16.84x | 1 | yes |
| update-leaf | 20 | seam | 1107 | 602–1316 | 3.69x | 41 | 0.72x | 1 | yes |
| update-leaf | 20 | signals | 1081 | 615–1115 | 3.60x | 50 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 1071 | 527–1133 | 3.57x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4704 | 4350–5190 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 11109 | 10519–11921 | 2.36x | 917 | 45.85x | 0 | yes |
| update-batched | 20 | compose | 7510 | 7054–7709 | 1.60x | 376 | 18.80x | 10 | yes |
| update-batched | 20 | fusion | 21609 | 21102–21986 | 4.59x | 516 | 25.80x | 0 | yes |
| update-batched | 20 | fusion-charm | 39387 | 36773–40237 | 8.37x | 1110 | 55.50x | 0 | yes |
| update-batched | 20 | react | 8460 | 8138–8672 | 1.80x | 533 | 26.65x | 0 | yes |
| update-batched | 20 | react-reflex | 53156 | 51505–54551 | 11.30x | 783 | 39.15x | 16 | yes |
| update-batched | 20 | react-upstream | 8627 | 8537–9148 | 1.83x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | roact | 8831 | 8565–9234 | 1.88x | 1154 | 57.70x | 1 | yes |
| update-batched | 20 | seam | 14259 | 12741–15273 | 3.03x | 1825 | 91.25x | 1 | yes |
| update-batched | 20 | signals | 9720 | 9425–10528 | 2.07x | 597 | 29.85x | 0 | yes |
| update-batched | 20 | vide | 9214 | 9037–9632 | 1.96x | 332 | 16.60x | 0 | yes |
| update-repeated | 10 | plain | 50 | 49–57 | 1.00x | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3640 | 3324–3711 | 73.03x | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 400 | 300–500 | 8.02x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion | 25427 | 23931–26391 | 510.06x | 13 | 6.50x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1259 | 1108–1384 | 25.26x | 7 | 3.50x | 1 | yes |
| update-repeated | 10 | react | 7307 | 7301–7323 | 146.58x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 806 | 500–932 | 16.17x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7519 | 7208–7844 | 150.83x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5045 | 4923–5409 | 101.20x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | seam | 1500 | 1411–1927 | 30.09x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 758 | 655–840 | 15.22x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 456 | 400–560 | 9.14x | 3 | 1.50x | 1 | yes |
| branch-swap | 20 | plain | 12583 | 12125–14600 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 16877 | 16634–17528 | 1.34x | 27 | 13.50x | 0 | yes |
| branch-swap | 20 | compose | 13717 | 13178–14928 | 1.09x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | fusion | 14625 | 13700–15027 | 1.16x | 4 | 2.00x | 0 | yes |
| branch-swap | 20 | fusion-charm | 13916 | 13727–14514 | 1.11x | 15 | 7.50x | 9 | yes |
| branch-swap | 20 | react | 16680 | 15610–18018 | 1.33x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 16226 | 15688–16929 | 1.29x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 16509 | 16173–18452 | 1.31x | 19 | 9.50x | 0 | yes |
| branch-swap | 20 | roact | 15007 | 14726–15240 | 1.19x | 12 | 6.00x | 1 | yes |
| branch-swap | 20 | seam | 12283 | 12133–12904 | 0.98x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | signals | 13049 | 12624–15186 | 1.04x | 6 | 3.00x | 1 | yes |
| branch-swap | 20 | vide | 13813 | 13328–14149 | 1.10x | 6 | 3.00x | 0 | yes |
| keyed-prepend | 10 | plain | 2372 | 2212–2549 | 1.00x | 65 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 4600 | 4305–5112 | 1.94x | 1482 | 22.80x | 0 | yes |
| keyed-prepend | 10 | compose | 4406 | 4264–4563 | 1.86x | 502 | 7.72x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 23721 | 21843–24049 | 10.00x | 1519 | 23.37x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 21199 | 20761–21490 | 8.94x | 1505 | 23.15x | 1 | yes |
| keyed-prepend | 10 | react | 16232 | 15309–16663 | 6.84x | 785 | 12.08x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16024 | 15746–16436 | 6.75x | 785 | 12.08x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 15886 | 15707–16622 | 6.70x | 793 | 12.20x | 1 | yes |
| keyed-prepend | 10 | roact | 6971 | 6820–7214 | 2.94x | 361 | 5.55x | 0 | yes |
| keyed-prepend | 10 | seam | 12401 | 10829–13058 | 5.23x | 2455 | 37.77x | 1 | yes |
| keyed-prepend | 10 | signals | 2857 | 2768–2948 | 1.20x | 54 | 0.83x | 1 | yes |
| keyed-prepend | 10 | vide | 5678 | 5100–5910 | 2.39x | 647 | 9.95x | 0 | yes |
| keyed-insert | 10 | plain | 1858 | 1635–1876 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4375 | 4114–4460 | 2.35x | 1490 | 23.28x | 1 | yes |
| keyed-insert | 10 | compose | 3306 | 3014–3412 | 1.78x | 493 | 7.70x | 13 | yes |
| keyed-insert | 10 | fusion (workaround) | 19536 | 18383–21545 | 10.51x | 1527 | 23.86x | 0 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 18835 | 17028–19285 | 10.14x | 1529 | 23.89x | 1 | yes |
| keyed-insert | 10 | react | 13644 | 13157–13923 | 7.34x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13862 | 13076–14046 | 7.46x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13960 | 13114–14739 | 7.51x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 5801 | 5618–6102 | 3.12x | 361 | 5.64x | 0 | yes |
| keyed-insert | 10 | seam | 10606 | 10232–11628 | 5.71x | 2463 | 38.48x | 1 | yes |
| keyed-insert | 10 | signals | 2208 | 2100–2304 | 1.19x | 61 | 0.95x | 0 | yes |
| keyed-insert | 10 | vide | 3858 | 3622–4062 | 2.08x | 646 | 10.09x | 0 | yes |
| keyed-shuffle | 10 | plain | 1856 | 1644–1888 | 1.00x | 116 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3224 | 3147–4304 | 1.74x | 1440 | 12.41x | 1 | yes |
| keyed-shuffle | 10 | compose | 3332 | 3262–3476 | 1.80x | 500 | 4.31x | 18 | yes |
| keyed-shuffle | 10 | fusion | 19280 | 18558–19901 | 10.39x | 1399 | 12.06x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 18632 | 17256–19377 | 10.04x | 1401 | 12.08x | 1 | yes |
| keyed-shuffle | 10 | react | 27745 | 27563–29499 | 14.95x | 787 | 6.78x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 28142 | 27759–28926 | 15.17x | 779 | 6.72x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27669 | 26784–28480 | 14.91x | 836 | 7.21x | 0 | yes |
| keyed-shuffle | 10 | roact | 5980 | 5700–6236 | 3.22x | 368 | 3.17x | 0 | yes |
| keyed-shuffle | 10 | seam | 9900 | 9710–10521 | 5.34x | 2454 | 21.16x | 0 | yes |
| keyed-shuffle | 10 | signals | 2138 | 2078–2224 | 1.15x | 60 | 0.52x | 0 | yes |
| keyed-shuffle | 10 | vide | 3864 | 3388–4278 | 2.08x | 692 | 5.97x | 0 | yes |
| events | 1 | plain | 1819 | 700–1933 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 1905 | 1791–2629 | 1.05x | 1 | 0.50x | 1 | yes |
| events | 1 | compose | 1791 | 1527–2722 | 0.98x | 3 | 1.50x | 1 | yes |
| events | 1 | fusion | 1710 | 1213–2428 | 0.94x | 10 | 5.00x | 1 | yes |
| events | 1 | fusion-charm | 2010 | 1751–2063 | 1.11x | 9 | 4.50x | 1 | yes |
| events | 1 | react | 1942 | 1532–2272 | 1.07x | 2 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 2158 | 1627–2631 | 1.19x | 8 | 4.00x | 0 | yes |
| events | 1 | react-upstream | 1900 | 1655–3014 | 1.04x | 1 | 0.50x | 1 | yes |
| events | 1 | roact | 1804 | 1313–2101 | 0.99x | 2 | 1.00x | 1 | yes |
| events | 1 | seam | 1201 | 905–1945 | 0.66x | 9 | 4.50x | 1 | yes |
| events | 1 | signals | 1519 | 1202–1822 | 0.84x | 2 | 1.00x | 1 | yes |
| events | 1 | vide | 1706 | 1065–1814 | 0.94x | 2 | 1.00x | 0 | yes |
| animate-many | 1 | plain | 2761 | 2528–3380 | 1.00x | 73 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 12479 | 11014–13053 | 4.52x | 1778 | 24.36x | 1 | yes |
| animate-many | 1 | compose | 6485 | 6372–7280 | 2.35x | 641 | 8.78x | 12 | yes |
| animate-many | 1 | fusion | 108852 | 107583–108953 | 39.42x | 1128 | 15.45x | 0 | yes |
| animate-many | 1 | fusion-charm | 107544 | 107299–108511 | 38.95x | 1138 | 15.59x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 22519 | 20609–23856 | 8.16x | 2898 | 39.70x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8134 | 8006–8258 | 2.95x | 384 | 5.26x | 0 | yes |
| status-panel | 10 | plain | 580 | 520–636 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1416 | 1315–1423 | 2.44x | 70 | 35.00x | 1 | yes |
| status-panel | 10 | compose | 1369 | 1231–1417 | 2.36x | 30 | 15.00x | 0 | yes |
| status-panel | 10 | fusion | 1814 | 1618–1990 | 3.13x | 71 | 35.50x | 1 | yes |
| status-panel | 10 | fusion-charm | 1711 | 1421–2226 | 2.95x | 61 | 30.50x | 0 | yes |
| status-panel | 10 | react | 2430 | 2408–2564 | 4.19x | 43 | 21.50x | 1 | yes |
| status-panel | 10 | react-reflex | 2312 | 2134–2489 | 3.98x | 44 | 22.00x | 0 | yes |
| status-panel | 10 | react-upstream | 2280 | 1833–2620 | 3.93x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | roact | 1256 | 1202–1578 | 2.16x | 33 | 16.50x | 0 | yes |
| status-panel | 10 | seam | 2611 | 2036–2687 | 4.50x | 141 | 70.50x | 0 | yes |
| status-panel | 10 | signals | 1272 | 1076–1331 | 2.19x | 7 | 3.50x | 0 | yes |
| status-panel | 10 | vide | 1302 | 1050–1522 | 2.24x | 33 | 16.50x | 0 | yes |
| scene-3d | 10 | plain | 2634 | 2434–3102 | 1.00x | 19 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4409 | 4200–4523 | 1.67x | 550 | 28.95x | 0 | yes |
| scene-3d | 10 | compose | 3132 | 2958–3402 | 1.19x | 178 | 9.37x | 2 | yes |
| scene-3d | 10 | fusion | 30343 | 29554–31166 | 11.52x | 520 | 27.37x | 1 | yes |
| scene-3d | 10 | fusion-charm | 27716 | 26928–29207 | 10.52x | 524 | 27.58x | 1 | yes |
| scene-3d | 10 | react | 3646 | 3474–3852 | 1.38x | 231 | 12.16x | 0 | yes |
| scene-3d | 10 | react-reflex | 3292 | 3192–3478 | 1.25x | 233 | 12.26x | 0 | yes |
| scene-3d | 10 | react-upstream | 3676 | 3452–3968 | 1.40x | 222 | 11.68x | 0 | yes |
| scene-3d | 10 | roact | 3476 | 3250–3702 | 1.32x | 574 | 30.21x | 0 | yes |
| scene-3d | 10 | seam | 9202 | 9024–9950 | 3.49x | 1755 | 92.37x | 0 | yes |
| scene-3d | 10 | signals | 6207 | 5353–6929 | 2.36x | 683 | 35.95x | 1 | yes |
| scene-3d | 10 | vide | 3951 | 3757–4044 | 1.50x | 211 | 11.11x | 1 | yes |
| derived-diamond | 3 | plain | 31 | 20–39 | 1.00x | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 161 | 125–177 | 5.20x | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 150 | 100–220 | 4.84x | 10 | 2.00x | 2 | yes |
| derived-diamond | 3 | fusion | 104 | 101–154 | 3.36x | 16 | 3.20x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 163 | 152–204 | 5.26x | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | react | 333 | 300–504 | 10.75x | 7 | 1.40x | 4 | yes |
| derived-diamond | 3 | react-reflex | 411 | 308–473 | 13.24x | 18 | 3.60x | 6 | yes |
| derived-diamond | 3 | react-upstream | 233 | 172–498 | 7.52x | 14 | 2.80x | 12 | yes |
| derived-diamond | 3 | roact | 150 | 100–157 | 4.84x | 11 | 2.20x | 4 | yes |
| derived-diamond | 3 | seam | 160 | 100–326 | 5.14x | 21 | 4.20x | 0 | yes |
| derived-diamond | 3 | signals | 102 | 100–186 | 3.29x | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | vide | 122 | 100–150 | 3.93x | 6 | 1.20x | 0 | yes |
| derived-chain-100 | 3 | plain | 49 | 46–63 | 1.00x | 57 | 1.00x | 1 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 204 | 178–232 | 4.15x | 126 | 2.21x | 2 | yes |
| derived-chain-100 | 3 | fusion | 927 | 832–952 | 18.83x | 128 | 2.25x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 923 | 759–1048 | 18.76x | 129 | 2.26x | 1 | yes |
| derived-chain-100 | 3 | react | 575 | 500–590 | 11.68x | 68 | 1.19x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 567 | 503–600 | 11.51x | 80 | 1.40x | 6 | yes |
| derived-chain-100 | 3 | react-upstream | 609 | 436–700 | 12.38x | 69 | 1.21x | 12 | yes |
| derived-chain-100 | 3 | roact | 101 | 100–150 | 2.05x | 11 | 0.19x | 3 | yes |
| derived-chain-100 | 3 | seam | 650 | 600–1050 | 13.21x | 271 | 4.75x | 1 | yes |
| derived-chain-100 | 3 | signals | 219 | 104–350 | 4.45x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 150 | 100–152 | 3.05x | 85 | 1.49x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–129 | 1.00x | 498 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 285 | 200–350 | 2.85x | 1543 | 3.10x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 420 | 376–486 | 4.20x | 695 | 1.40x | 9 | yes |
| derived-fan-in-1000 | 3 | fusion | 2208 | 2100–2249 | 22.08x | 897 | 1.80x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2407 | 2135–2445 | 24.07x | 2830 | 5.68x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2854 | 2500–3558 | 28.54x | 663 | 1.33x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8802 | 7814–9825 | 88.02x | 5637 | 11.32x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2651 | 2556–3000 | 26.51x | 655 | 1.32x | 44 | yes |
| derived-fan-in-1000 | 3 | roact | 511 | 475–655 | 5.11x | 104 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2906 | 2700–3126 | 29.07x | 2948 | 5.92x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 783 | 700–880 | 7.83x | 1212 | 2.43x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 560 | 475–611 | 5.61x | 528 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | plain | 9134 | 8828–10004 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16725 | 16336–17648 | 1.83x | 2694 | 76.97x | 1 | yes |
| filter-as-you-type | 1 | compose | 11025 | 10914–11413 | 1.21x | 731 | 20.89x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 27817 | 26882–30127 | 3.05x | 2465 | 70.43x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 27498 | 25036–30248 | 3.01x | 2474 | 70.69x | 1 | yes |
| filter-as-you-type | 1 | react | 21328 | 21047–21878 | 2.34x | 60 | 1.71x | 3 | yes |
| filter-as-you-type | 1 | react-reflex | 21728 | 20612–22033 | 2.38x | 838 | 23.94x | 14 | yes |
| filter-as-you-type | 1 | react-upstream | 21158 | 20894–21934 | 2.32x | 76 | 2.17x | 11 | yes |
| filter-as-you-type | 1 | roact | 12211 | 10819–12711 | 1.34x | 503 | 14.37x | 3 | yes |
| filter-as-you-type | 1 | seam | 24415 | 23441–24822 | 2.67x | 3997 | 114.20x | 0 | yes |
| filter-as-you-type | 1 | signals | 8223 | 7718–8312 | 0.90x | 36 | 1.03x | 0 | yes |
| filter-as-you-type | 1 | vide | 11032 | 10368–11974 | 1.21x | 968 | 27.66x | 8 | yes |
| theme-propagation | 3 | plain | 47267 | 46658–48037 | 1.00x | 206 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 47591 | 47327–49428 | 1.01x | 2078 | 10.09x | 1 | yes |
| theme-propagation | 3 | compose | 51110 | 50482–52655 | 1.08x | 519 | 2.52x | 2 | yes |
| theme-propagation | 3 | fusion | 53079 | 52390–53730 | 1.12x | 867 | 4.21x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 53638 | 52208–55654 | 1.13x | 869 | 4.22x | 1 | yes |
| theme-propagation | 3 | react | 53296 | 52252–53455 | 1.13x | 2020 | 9.81x | 1 | yes |
| theme-propagation | 3 | react-reflex | 46264 | 45268–46765 | 0.98x | 2029 | 9.85x | 8 | yes |
| theme-propagation | 3 | react-upstream | 54987 | 53879–55178 | 1.16x | 2027 | 9.84x | 0 | yes |
| theme-propagation | 3 | roact | 50962 | 50187–52413 | 1.08x | 3287 | 15.96x | 1 | yes |
| theme-propagation | 3 | seam | 46777 | 45908–48535 | 0.99x | 3469 | 16.84x | 0 | yes |
| theme-propagation | 3 | signals | 52142 | 51481–52762 | 1.10x | 896 | 4.35x | 0 | yes |
| theme-propagation | 3 | vide | 50263 | 49880–51065 | 1.06x | 606 | 2.94x | 0 | yes |
| hud-per-frame | 1 | plain | 3326 | 2557–3465 | 1.00x | 22 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 6263 | 5934–7368 | 1.88x | 71 | 3.23x | 0 | yes |
| hud-per-frame | 1 | compose | 4169 | 4096–5777 | 1.25x | 32 | 1.43x | 1 | yes |
| hud-per-frame | 1 | fusion | 11409 | 10829–11521 | 3.43x | 66 | 2.98x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13728 | 13219–14243 | 4.13x | 86 | 3.91x | 0 | yes |
| hud-per-frame | 1 | react | 4956 | 3240–5247 | 1.49x | 30 | 1.36x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7631 | 6831–8104 | 2.29x | 54 | 2.43x | 2 | yes |
| hud-per-frame | 1 | react-upstream | 4757 | 3674–4788 | 1.43x | 38 | 1.73x | 0 | yes |
| hud-per-frame | 1 | roact | 4226 | 3895–4471 | 1.27x | 90 | 4.11x | 0 | yes |
| hud-per-frame | 1 | seam | 10257 | 8097–10781 | 3.08x | 168 | 7.66x | 0 | yes |
| hud-per-frame | 1 | signals | 6312 | 5413–6402 | 1.90x | 69 | 3.14x | 0 | yes |
| hud-per-frame | 1 | vide | 5883 | 4425–6075 | 1.77x | 26 | 1.16x | 0 | yes |
| teardown-under-load | 1 | plain | 49576 | 44537–54030 | 1.00x | 6 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 70908 | 66314–74776 | 1.43x | 13 | 2.17x | 0 | yes |
| teardown-under-load | 1 | compose | 54226 | 49089–55894 | 1.09x | 7 | 1.17x | 2 | yes |
| teardown-under-load | 1 | fusion | 78888 | 68848–80553 | 1.59x | 5 | 0.83x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 76497 | 71777–83887 | 1.54x | 7 | 1.17x | 1 | yes |
| teardown-under-load | 1 | react | 74685 | 71896–80664 | 1.51x | 1077 | 179.50x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 74284 | 64688–77824 | 1.50x | 1086 | 181.00x | 8 | yes |
| teardown-under-load | 1 | react-upstream | 75219 | 74081–79436 | 1.52x | 1077 | 179.50x | 0 | yes |
| teardown-under-load | 1 | roact | 67622 | 60700–75164 | 1.36x | 71 | 11.83x | 0 | yes |
| teardown-under-load | 1 | seam | 59784 | 58153–68460 | 1.21x | 8 | 1.33x | 6 | yes |
| teardown-under-load | 1 | signals | 56621 | 50676–57013 | 1.14x | 4 | 0.67x | 0 | yes |
| teardown-under-load | 1 | vide | 57461 | 56268–61383 | 1.16x | 5 | 0.83x | 1 | yes |
| open-close-retention | 1 | plain | 67826 | 67435–70015 | 1.00x | 23 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 121893 | 121130–125412 | 1.80x | 22 | 0.96x | 9 | yes |
| open-close-retention | 1 | compose | 81345 | 81136–82201 | 1.20x | 8 | 0.35x | 2 | yes |
| open-close-retention | 1 | fusion | 134648 | 132246–137058 | 1.99x | 12 | 0.52x | 8 | yes |
| open-close-retention | 1 | fusion-charm | 131989 | 131698–135687 | 1.95x | 7 | 0.30x | 0 | yes |
| open-close-retention | 1 | react | 118527 | 118359–120248 | 1.75x | 292 | 12.67x | 5 | yes |
| open-close-retention | 1 | react-reflex | 117192 | 116691–117196 | 1.73x | 288 | 12.54x | 0 | yes |
| open-close-retention | 1 | react-upstream | 117826 | 117645–119915 | 1.74x | 287 | 12.48x | 2 | yes |
| open-close-retention | 1 | roact | 111203 | 106806–113439 | 1.64x | 30 | 1.30x | 0 | yes |
| open-close-retention | 1 | seam | 110611 | 107015–111251 | 1.63x | 16 | 0.70x | 0 | yes |
| open-close-retention | 1 | signals | 85792 | 85589–88403 | 1.26x | 13 | 0.57x | 1 | yes |
| open-close-retention | 1 | vide | 90570 | 89760–91486 | 1.34x | 5 | 0.22x | 0 | yes |
| tree-expand-collapse | 1 | plain | 11128 | 8520–12813 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 19900 | 18832–20632 | 1.79x | 780 | 39.00x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12105 | 11518–12804 | 1.09x | 62 | 3.10x | 0 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24433 | 22133–26897 | 2.20x | 157 | 7.85x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23131 | 21367–24217 | 2.08x | 175 | 8.75x | 1 | yes |
| tree-expand-collapse | 1 | react | 19757 | 19231–20472 | 1.78x | 61 | 3.05x | 11 | yes |
| tree-expand-collapse | 1 | react-reflex | 20039 | 18357–21048 | 1.80x | 672 | 33.60x | 30 | yes |
| tree-expand-collapse | 1 | react-upstream | 19516 | 18560–20833 | 1.75x | 69 | 3.45x | 20 | yes |
| tree-expand-collapse | 1 | roact | 11417 | 11003–11848 | 1.03x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 27613 | 19912–30285 | 2.48x | 141 | 7.05x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8457 | 8102–8733 | 0.76x | 13 | 0.65x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12113 | 11534–12341 | 1.09x | 71 | 3.55x | 1 | yes |
| form-validation | 1 | plain | 2546 | 2212–2942 | 1.00x | 46 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 4187 | 3932–4642 | 1.64x | 336 | 7.30x | 1 | yes |
| form-validation | 1 | compose | 4438 | 3557–4765 | 1.74x | 99 | 2.15x | 6 | yes |
| form-validation | 1 | fusion | 5548 | 5379–5868 | 2.18x | 110 | 2.39x | 0 | yes |
| form-validation | 1 | fusion-charm | 5493 | 4942–5562 | 2.16x | 155 | 3.37x | 0 | yes |
| form-validation | 1 | react | 5626 | 5227–6135 | 2.21x | 66 | 1.43x | 0 | yes |
| form-validation | 1 | react-reflex | 6081 | 5630–6570 | 2.39x | 75 | 1.63x | 1 | yes |
| form-validation | 1 | react-upstream | 5591 | 5163–6204 | 2.20x | 66 | 1.43x | 1 | yes |
| form-validation | 1 | roact | 5473 | 4520–5981 | 2.15x | 215 | 4.67x | 0 | yes |
| form-validation | 1 | seam | 7972 | 7041–8191 | 3.13x | 349 | 7.59x | 0 | yes |
| form-validation | 1 | signals | 4057 | 3865–5227 | 1.59x | 154 | 3.35x | 0 | yes |
| form-validation | 1 | vide | 4514 | 3864–5018 | 1.77x | 75 | 1.63x | 0 | yes |
| table-sort-filter | 1 | plain | 18071 | 16007–19571 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 37163 | 34739–39185 | 2.06x | 5413 | 80.79x | 1 | yes |
| table-sort-filter | 1 | compose | 25752 | 24943–25847 | 1.43x | 1436 | 21.43x | 26 | yes |
| table-sort-filter | 1 | fusion (workaround) | 55849 | 53108–56641 | 3.09x | 4704 | 70.21x | 0 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 50287 | 46773–55590 | 2.78x | 4722 | 70.48x | 1 | yes |
| table-sort-filter | 1 | react | 93990 | 91369–100164 | 5.20x | 2116 | 31.58x | 27 | yes |
| table-sort-filter | 1 | react-reflex | 93467 | 86607–101499 | 5.17x | 2123 | 31.69x | 22 | yes |
| table-sort-filter | 1 | react-upstream | 94658 | 90082–102253 | 5.24x | 2109 | 31.48x | 11 | yes |
| table-sort-filter | 1 | roact | 24843 | 24117–26671 | 1.37x | 1015 | 15.15x | 4 | yes |
| table-sort-filter | 1 | seam | 58367 | 49471–60742 | 3.23x | 7840 | 117.01x | 0 | yes |
| table-sort-filter | 1 | signals | 18523 | 17496–19285 | 1.03x | 68 | 1.01x | 0 | yes |
| table-sort-filter | 1 | vide | 26849 | 25223–28033 | 1.49x | 1915 | 28.58x | 0 | yes |
| library-load | 1 | plain | 40 | 34–47 | 1.00x | 2 | 1.00x | 1 | yes |
| library-load | 1 | blend | 784 | 683–868 | 19.42x | 462 | 231.00x | 459 | yes |
| library-load | 1 | compose | 683 | 578–688 | 16.92x | 67 | 33.50x | 64 | yes |
| library-load | 1 | fusion | 1379 | 1258–1607 | 34.15x | 254 | 127.00x | 253 | yes |
| library-load | 1 | fusion-charm | 1445 | 1363–1540 | 35.78x | 316 | 158.00x | 315 | yes |
| library-load | 1 | react | 4802 | 4692–4855 | 118.93x | 1813 | 906.50x | 1812 | yes |
| library-load | 1 | react-reflex | 4963 | 4914–5229 | 122.92x | 1960 | 980.00x | 1959 | yes |
| library-load | 1 | react-upstream | 4872 | 4776–4982 | 120.67x | 1982 | 991.00x | 1981 | yes |
| library-load | 1 | roact | 426 | 407–447 | 10.55x | 144 | 72.00x | 141 | yes |
| library-load | 1 | seam | 1273 | 1252–1627 | 31.53x | 240 | 120.00x | 237 | yes |
| library-load | 1 | signals | 237 | 229–252 | 5.86x | 41 | 20.50x | 40 | yes |
| library-load | 1 | vide | 355 | 330–393 | 8.79x | 137 | 68.50x | 137 | yes |
| rows-append-1000 | 1 | plain | 96951 | 94107–122019 | 1.00x | 6301 | 1.00x | 1 | yes |
| rows-append-1000 | 1 | blend | 168251 | 147957–171499 | 1.74x | 38282 | 6.08x | 0 | yes |
| rows-append-1000 | 1 | compose | 107344 | 103140–141674 | 1.11x | 9289 | 1.47x | 10 | yes |
| rows-append-1000 | 1 | fusion | 337887 | 317403–342383 | 3.49x | 20602 | 3.27x | 9 | yes |
| rows-append-1000 | 1 | fusion-charm | 328055 | 326882–336811 | 3.38x | 28457 | 4.52x | 0 | yes |
| rows-append-1000 | 1 | react | 192250 | 182949–229697 | 1.98x | 23121 | 3.67x | 128 | yes |
| rows-append-1000 | 1 | react-reflex | 216458 | 207448–233007 | 2.23x | 24661 | 3.91x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 195994 | 195151–212474 | 2.02x | 22913 | 3.64x | 0 | yes |
| rows-append-1000 | 1 | roact | 148826 | 133174–190515 | 1.54x | 33242 | 5.28x | 0 | yes |
| rows-append-1000 | 1 | seam | 166087 | 145789–169304 | 1.71x | 47823 | 7.59x | 8 | yes |
| rows-append-1000 | 1 | signals | 111948 | 103057–153929 | 1.15x | 18750 | 2.98x | 1 | yes |
| rows-append-1000 | 1 | vide | 118929 | 112278–147811 | 1.23x | 10191 | 1.62x | 1 | yes |
| rows-clear | 1 | plain | 18365 | 17813–18818 | 1.00x | 1221 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 35623 | 34551–38332 | 1.94x | 4105 | 3.36x | 8 | yes |
| rows-clear | 1 | compose | 26350 | 23720–26966 | 1.43x | 1806 | 1.48x | 11 | yes |
| rows-clear | 1 | fusion | 78695 | 75808–81987 | 4.29x | 3473 | 2.84x | 0 | yes |
| rows-clear | 1 | fusion-charm | 74119 | 73390–75521 | 4.04x | 7152 | 5.86x | 0 | yes |
| rows-clear | 1 | react | 26056 | 25313–26260 | 1.42x | 4480 | 3.67x | 0 | yes |
| rows-clear | 1 | react-reflex | 27619 | 25249–29927 | 1.50x | 6498 | 5.32x | 37 | yes |
| rows-clear | 1 | react-upstream | 24815 | 24726–26650 | 1.35x | 4471 | 3.66x | 0 | yes |
| rows-clear | 1 | roact | 25332 | 24341–25546 | 1.38x | 4198 | 3.44x | 0 | yes |
| rows-clear | 1 | seam | 34185 | 31126–37145 | 1.86x | 9143 | 7.49x | 0 | yes |
| rows-clear | 1 | signals | 22012 | 21276–23144 | 1.20x | 4434 | 3.63x | 0 | yes |
| rows-clear | 1 | vide | 21232 | 19851–22126 | 1.16x | 1605 | 1.31x | 0 | yes |
| rows-create-1000 | 1 | plain | 92466 | 90817–93435 | 1.00x | 3119 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 154955 | 137325–161329 | 1.68x | 19383 | 6.21x | 0 | yes |
| rows-create-1000 | 1 | compose | 106031 | 102281–117601 | 1.15x | 4703 | 1.51x | 2 | yes |
| rows-create-1000 | 1 | fusion | 186084 | 174938–203873 | 2.01x | 10555 | 3.38x | 8 | yes |
| rows-create-1000 | 1 | fusion-charm | 184940 | 170101–197398 | 2.00x | 14484 | 4.64x | 1 | yes |
| rows-create-1000 | 1 | react | 163558 | 159393–172147 | 1.77x | 7874 | 2.52x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 175306 | 161348–179936 | 1.90x | 8835 | 2.83x | 36 | yes |
| rows-create-1000 | 1 | react-upstream | 161312 | 151528–170313 | 1.74x | 7890 | 2.53x | 0 | yes |
| rows-create-1000 | 1 | roact | 127677 | 114454–149321 | 1.38x | 16691 | 5.35x | 8 | yes |
| rows-create-1000 | 1 | seam | 153186 | 136284–161293 | 1.66x | 23886 | 7.66x | 0 | yes |
| rows-create-1000 | 1 | signals | 106921 | 97589–114057 | 1.16x | 9106 | 2.92x | 0 | yes |
| rows-create-1000 | 1 | vide | 112702 | 109941–122763 | 1.22x | 4956 | 1.59x | 0 | yes |
| rows-create-10000 | 1 | plain | 1181811 | 1137216–1192515 | 1.00x | 29800 | 1.00x | 12 | yes |
| rows-create-10000 | 1 | blend | 1693387 | 1692112–1806641 | 1.43x | 186536 | 6.26x | 0 | yes |
| rows-create-10000 | 1 | compose | 1410887 | 1395057–1413374 | 1.19x | 48533 | 1.63x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6538413 | 6289089–6655351 | 5.53x | 101144 | 3.39x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6285879 | 6212309–6472328 | 5.32x | 141642 | 4.75x | 0 | yes |
| rows-create-10000 | 1 | react | 5297755 | 5093562–5301372 | 4.48x | 77325 | 2.59x | 665 | yes |
| rows-create-10000 | 1 | react-reflex | 5401228 | 5354155–5415344 | 4.57x | 86669 | 2.91x | 834 | yes |
| rows-create-10000 | 1 | react-upstream | 5169480 | 5091834–5208343 | 4.37x | 78282 | 2.63x | 224 | yes |
| rows-create-10000 | 1 | roact | 1607522 | 1489505–1617837 | 1.36x | 166114 | 5.57x | 0 | yes |
| rows-create-10000 | 1 | seam | 1711276 | 1708157–1722782 | 1.45x | 235192 | 7.89x | 4 | yes |
| rows-create-10000 | 1 | signals | 1285077 | 1266230–1436073 | 1.09x | 89218 | 2.99x | 5 | yes |
| rows-create-10000 | 1 | vide | 1326224 | 1292687–1495068 | 1.12x | 48456 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 700 | 668–900 | 1.00x | 2741 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1302 | 1150–1350 | 1.86x | 18263 | 6.66x | 0 | yes |
| rows-remove-one | 1 | compose | 867 | 833–936 | 1.24x | 4202 | 1.53x | 27 | yes |
| rows-remove-one | 1 | fusion (workaround) | 63242 | 62513–69020 | 90.35x | 10135 | 3.70x | 9 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 62492 | 60952–64970 | 89.27x | 14022 | 5.12x | 0 | yes |
| rows-remove-one | 1 | react | 24604 | 20014–25214 | 35.15x | 14759 | 5.38x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 34725 | 32244–46551 | 49.61x | 15921 | 5.81x | 28 | yes |
| rows-remove-one | 1 | react-upstream | 23863 | 19958–26731 | 34.09x | 15088 | 5.50x | 96 | yes |
| rows-remove-one | 1 | roact | 17331 | 15025–18202 | 24.76x | 16281 | 5.94x | 1 | yes |
| rows-remove-one | 1 | seam | 6010 | 5406–7261 | 8.59x | 23205 | 8.47x | 0 | yes |
| rows-remove-one | 1 | signals | 1502 | 1439–1716 | 2.15x | 8621 | 3.15x | 0 | yes |
| rows-remove-one | 1 | vide | 1136 | 1000–1309 | 1.62x | 4561 | 1.66x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 3151 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 800 | 650–857 | 8.00x | 18747 | 5.95x | 1 | yes |
| rows-swap | 1 | compose | 300 | 233–367 | 3.00x | 4629 | 1.47x | 2 | yes |
| rows-swap | 1 | fusion | 60263 | 57079–61425 | 602.63x | 10039 | 3.19x | 9 | yes |
| rows-swap | 1 | fusion-charm | 57693 | 56971–58771 | 576.93x | 14667 | 4.65x | 1 | yes |
| rows-swap | 1 | react | 58578 | 53475–61556 | 585.78x | 15502 | 4.92x | 23 | yes |
| rows-swap | 1 | react-reflex | 68021 | 64121–81229 | 680.21x | 16399 | 5.20x | 37 | yes |
| rows-swap | 1 | react-upstream | 59351 | 54439–77687 | 593.51x | 15462 | 4.91x | 0 | yes |
| rows-swap | 1 | roact | 16043 | 14210–18542 | 160.43x | 16785 | 5.33x | 8 | yes |
| rows-swap | 1 | seam | 5415 | 5101–6200 | 54.15x | 23692 | 7.52x | 1 | yes |
| rows-swap | 1 | signals | 613 | 534–770 | 6.13x | 9066 | 2.88x | 0 | yes |
| rows-swap | 1 | vide | 205 | 100–300 | 2.05x | 4980 | 1.58x | 8 | yes |
| rows-update-every-10th | 1 | plain | 1971 | 1770–2118 | 1.00x | 3191 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1951 | 1799–2204 | 0.99x | 19272 | 6.04x | 0 | yes |
| rows-update-every-10th | 1 | compose | 1942 | 1868–2074 | 0.99x | 4710 | 1.48x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 2062 | 2050–2119 | 1.05x | 10551 | 3.31x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2208 | 2103–2400 | 1.12x | 14464 | 4.53x | 1 | yes |
| rows-update-every-10th | 1 | react | 2004 | 1900–2104 | 1.02x | 7862 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 4058 | 3756–8300 | 2.06x | 8838 | 2.77x | 36 | yes |
| rows-update-every-10th | 1 | react-upstream | 2000 | 1950–2102 | 1.01x | 7918 | 2.48x | 8 | yes |
| rows-update-every-10th | 1 | roact | 1968 | 1867–2074 | 1.00x | 16680 | 5.23x | 0 | yes |
| rows-update-every-10th | 1 | seam | 5201 | 4606–5936 | 2.64x | 24027 | 7.53x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2111 | 1968–2176 | 1.07x | 9346 | 2.93x | 0 | yes |
| rows-update-every-10th | 1 | vide | 1976 | 1905–2137 | 1.00x | 5125 | 1.61x | 1 | yes |

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
| blend | 29 | 2.44x | 10.32x | 2.39x | 10.01x |
| compose | 30 | 1.86x | 3.19x | 1.79x | 3.12x |
| fusion | 30 | 6.58x | 6.21x | 5.95x | 6.23x |
| fusion-charm | 30 | 6.17x | 7.43x | 5.55x | 7.55x |
| react | 29 | 5.00x | 5.42x | 4.85x | 5.72x |
| react-reflex | 29 | 5.54x | 8.96x | 5.39x | 9.58x |
| react-upstream | 29 | 4.93x | 5.94x | 4.77x | 6.29x |
| roact | 29 | 2.74x | 4.96x | 2.77x | 5.57x |
| seam | 30 | 3.99x | 11.80x | 3.72x | 11.67x |
| signals | 29 | 1.84x | 2.36x | 1.78x | 2.34x |
| vide | 30 | 1.91x | 2.77x | 1.85x | 2.77x |
