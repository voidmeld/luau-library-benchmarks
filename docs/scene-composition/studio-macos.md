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
| Harness revision | `a360b90` |
| Date | 2026-11-13 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 200–400 | 1.00x | 49 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 900 | 500–911 | 3.00x | 765 | 15.61x | 1 | yes |
| update-leaf | 20 | compose | 700 | 500–1206 | 2.33x | 93 | 1.90x | 2 | yes |
| update-leaf | 20 | fusion | 804 | 509–1023 | 2.68x | 52 | 1.06x | 1 | yes |
| update-leaf | 20 | fusion-charm | 1278 | 916–1476 | 4.26x | 61 | 1.24x | 1 | yes |
| update-leaf | 20 | react | 923 | 600–1135 | 3.08x | 348 | 7.10x | 0 | yes |
| update-leaf | 20 | react-reflex | 923 | 512–1185 | 3.08x | 293 | 5.98x | 1 | yes |
| update-leaf | 20 | react-upstream | 1028 | 795–1239 | 3.43x | 292 | 5.96x | 0 | yes |
| update-leaf | 20 | roact | 1018 | 604–1380 | 3.39x | 459 | 9.37x | 1 | yes |
| update-leaf | 20 | seam | 1038 | 401–1362 | 3.46x | 40 | 0.82x | 0 | yes |
| update-leaf | 20 | signals | 796 | 514–922 | 2.65x | 50 | 1.02x | 0 | yes |
| update-leaf | 20 | vide | 1208 | 1008–1551 | 4.03x | 0 | 0.02x | 0 | yes |
| update-batched | 20 | plain | 4701 | 4567–5154 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 10919 | 10670–11157 | 2.32x | 916 | 43.62x | 1 | yes |
| update-batched | 20 | compose | 6885 | 6427–7042 | 1.46x | 408 | 19.43x | 2 | yes |
| update-batched | 20 | fusion | 20766 | 20033–21235 | 4.42x | 501 | 23.86x | 0 | yes |
| update-batched | 20 | fusion-charm | 36676 | 35129–37674 | 7.80x | 1101 | 52.43x | 0 | yes |
| update-batched | 20 | react | 7911 | 7300–7952 | 1.68x | 533 | 25.38x | 1 | yes |
| update-batched | 20 | react-reflex | 21224 | 20054–21814 | 4.51x | 803 | 38.24x | 9 | yes |
| update-batched | 20 | react-upstream | 7953 | 7338–8228 | 1.69x | 478 | 22.76x | 1 | yes |
| update-batched | 20 | roact | 7909 | 7710–8148 | 1.68x | 875 | 41.67x | 8 | yes |
| update-batched | 20 | seam | 12725 | 12185–13137 | 2.71x | 1849 | 88.05x | 1 | yes |
| update-batched | 20 | signals | 9344 | 9072–9512 | 1.99x | 597 | 28.43x | 0 | yes |
| update-batched | 20 | vide | 8654 | 8210–9068 | 1.84x | 331 | 15.76x | 0 | yes |
| update-repeated | 10 | plain | 47 | 42–53 | 1.00x | 1 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3388 | 3258–3600 | 71.91x | 7 | 7.00x | 0 | yes |
| update-repeated | 10 | compose | 200 | 100–403 | 4.25x | 6 | 6.00x | 2 | yes |
| update-repeated | 10 | fusion | 24514 | 24003–25012 | 520.40x | 12 | 12.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1227 | 1039–1378 | 26.05x | 7 | 7.00x | 1 | yes |
| update-repeated | 10 | react | 7114 | 6751–7420 | 151.02x | 1 | 1.00x | 0 | yes |
| update-repeated | 10 | react-reflex | 286 | 111–820 | 6.07x | 4 | 4.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7100 | 6900–7457 | 150.72x | 1 | 1.00x | 0 | yes |
| update-repeated | 10 | roact | 4716 | 4701–4918 | 100.11x | 5 | 5.00x | 0 | yes |
| update-repeated | 10 | seam | 1587 | 1344–1630 | 33.69x | 11 | 11.00x | 0 | yes |
| update-repeated | 10 | signals | 772 | 732–914 | 16.40x | 4 | 4.00x | 0 | yes |
| update-repeated | 10 | vide | 463 | 350–596 | 9.83x | 3 | 3.00x | 0 | yes |
| branch-swap | 20 | plain | 14708 | 12806–15752 | 1.00x | 10 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 16780 | 16511–17104 | 1.14x | 35 | 3.50x | 8 | yes |
| branch-swap | 20 | compose | 13252 | 12985–14143 | 0.90x | 15 | 1.50x | 10 | yes |
| branch-swap | 20 | fusion | 14471 | 13695–14643 | 0.98x | 13 | 1.30x | 0 | yes |
| branch-swap | 20 | fusion-charm | 14407 | 14050–14785 | 0.98x | 7 | 0.70x | 8 | yes |
| branch-swap | 20 | react | 16168 | 16120–16649 | 1.10x | 11 | 1.10x | 1 | yes |
| branch-swap | 20 | react-reflex | 16588 | 15974–19261 | 1.13x | 11 | 1.10x | 1 | yes |
| branch-swap | 20 | react-upstream | 16177 | 15559–16663 | 1.10x | 11 | 1.10x | 0 | yes |
| branch-swap | 20 | roact | 13844 | 13432–14364 | 0.94x | 23 | 2.30x | 14 | yes |
| branch-swap | 20 | seam | 13547 | 13241–14052 | 0.92x | 20 | 2.00x | 1 | yes |
| branch-swap | 20 | signals | 12540 | 12400–13369 | 0.85x | 5 | 0.50x | 1 | yes |
| branch-swap | 20 | vide | 14145 | 13371–15123 | 0.96x | 6 | 0.60x | 0 | yes |
| keyed-prepend | 10 | plain | 2380 | 2040–2628 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 5000 | 4628–5105 | 2.10x | 1694 | 26.47x | 9 | yes |
| keyed-prepend | 10 | compose | 4362 | 4162–4596 | 1.83x | 576 | 9.00x | 18 | yes |
| keyed-prepend | 10 | fusion (workaround) | 22749 | 21620–23323 | 9.56x | 1525 | 23.83x | 2 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 22047 | 21324–22764 | 9.26x | 1510 | 23.59x | 1 | yes |
| keyed-prepend | 10 | react | 15659 | 15611–16260 | 6.58x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 15958 | 15705–16413 | 6.70x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16412 | 15916–16575 | 6.89x | 784 | 12.25x | 0 | yes |
| keyed-prepend | 10 | roact | 6997 | 6700–7100 | 2.94x | 357 | 5.58x | 1 | yes |
| keyed-prepend | 10 | seam | 11305 | 10569–12672 | 4.75x | 2428 | 37.94x | 0 | yes |
| keyed-prepend | 10 | signals | 2662 | 2572–2812 | 1.12x | 66 | 1.03x | 1 | yes |
| keyed-prepend | 10 | vide | 4928 | 4600–5602 | 2.07x | 635 | 9.92x | 7 | yes |
| keyed-insert | 10 | plain | 1502 | 1376–1630 | 1.00x | 56 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4057 | 3903–4164 | 2.70x | 1694 | 30.25x | 0 | yes |
| keyed-insert | 10 | compose | 3016 | 2915–3160 | 2.01x | 560 | 10.00x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 19324 | 17914–20023 | 12.87x | 1524 | 27.21x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 17723 | 16637–18645 | 11.80x | 1527 | 27.27x | 0 | yes |
| keyed-insert | 10 | react | 13418 | 12347–13801 | 8.93x | 811 | 14.48x | 1 | yes |
| keyed-insert | 10 | react-reflex | 13901 | 13252–14219 | 9.26x | 811 | 14.48x | 0 | yes |
| keyed-insert | 10 | react-upstream | 14006 | 13167–14119 | 9.33x | 810 | 14.46x | 0 | yes |
| keyed-insert | 10 | roact | 5544 | 5230–5810 | 3.69x | 365 | 6.52x | 0 | yes |
| keyed-insert | 10 | seam | 10203 | 9805–10967 | 6.79x | 2420 | 43.21x | 8 | yes |
| keyed-insert | 10 | signals | 1720 | 1662–2108 | 1.15x | 66 | 1.18x | 0 | yes |
| keyed-insert | 10 | vide | 3622 | 3302–3632 | 2.41x | 643 | 11.48x | 8 | yes |
| keyed-shuffle | 10 | plain | 1554 | 1526–1776 | 1.00x | 117 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3003 | 2758–3316 | 1.93x | 1640 | 14.02x | 0 | yes |
| keyed-shuffle | 10 | compose | 3030 | 2689–3110 | 1.95x | 570 | 4.87x | 10 | yes |
| keyed-shuffle | 10 | fusion | 18626 | 17914–19215 | 11.99x | 1392 | 11.90x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 17024 | 16037–18345 | 10.96x | 1386 | 11.85x | 0 | yes |
| keyed-shuffle | 10 | react | 27610 | 26935–28329 | 17.77x | 783 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 28589 | 27823–30307 | 18.40x | 776 | 6.63x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 26919 | 26330–28064 | 17.33x | 840 | 7.18x | 0 | yes |
| keyed-shuffle | 10 | roact | 5407 | 5310–5901 | 3.48x | 361 | 3.09x | 1 | yes |
| keyed-shuffle | 10 | seam | 9237 | 8630–9902 | 5.94x | 2423 | 20.71x | 1 | yes |
| keyed-shuffle | 10 | signals | 1866 | 1809–2204 | 1.20x | 118 | 1.01x | 0 | yes |
| keyed-shuffle | 10 | vide | 3471 | 3402–3758 | 2.23x | 678 | 5.79x | 0 | yes |
| events | 1 | plain | 1100 | 900–1500 | 1.00x | 9 | 1.00x | 0 | yes |
| events | 1 | blend | 1400 | 1206–1755 | 1.27x | 2 | 0.22x | 1 | yes |
| events | 1 | compose | 1273 | 1039–1668 | 1.16x | 3 | 0.33x | 2 | yes |
| events | 1 | fusion | 1393 | 1206–1714 | 1.27x | 2 | 0.22x | 1 | yes |
| events | 1 | fusion-charm | 1240 | 1035–1642 | 1.13x | 9 | 1.00x | 1 | yes |
| events | 1 | react | 1528 | 1278–1661 | 1.39x | 0 | 0.11x | 0 | yes |
| events | 1 | react-reflex | 1814 | 1254–2205 | 1.65x | 1 | 0.11x | 0 | yes |
| events | 1 | react-upstream | 1608 | 1406–1821 | 1.46x | 0 | 0.11x | 0 | yes |
| events | 1 | roact | 1300 | 800–1441 | 1.18x | 2 | 0.22x | 0 | yes |
| events | 1 | seam | 1202 | 1156–1744 | 1.09x | 9 | 1.00x | 8 | yes |
| events | 1 | signals | 1402 | 1175–1589 | 1.27x | 2 | 0.22x | 1 | yes |
| events | 1 | vide | 1653 | 1001–2182 | 1.50x | 2 | 0.22x | 1 | yes |
| animate-many | 1 | plain | 2534 | 2303–2785 | 1.00x | 72 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 10771 | 10690–10841 | 4.25x | 1763 | 24.49x | 0 | yes |
| animate-many | 1 | compose | 6365 | 6039–6951 | 2.51x | 647 | 8.99x | 12 | yes |
| animate-many | 1 | fusion | 108765 | 107903–110017 | 42.92x | 1119 | 15.54x | 0 | yes |
| animate-many | 1 | fusion-charm | 109340 | 108789–111308 | 43.15x | 1122 | 15.58x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 19374 | 18201–20543 | 7.65x | 2898 | 40.25x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 7762 | 7612–8314 | 3.06x | 393 | 5.46x | 0 | yes |
| status-panel | 10 | plain | 651 | 560–660 | 1.00x | 22 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 1268 | 1200–1506 | 1.95x | 92 | 4.18x | 0 | yes |
| status-panel | 10 | compose | 1096 | 750–1201 | 1.68x | 40 | 1.82x | 0 | yes |
| status-panel | 10 | fusion | 1505 | 1418–1578 | 2.31x | 71 | 3.23x | 0 | yes |
| status-panel | 10 | fusion-charm | 1650 | 1500–1956 | 2.53x | 76 | 3.45x | 0 | yes |
| status-panel | 10 | react | 2145 | 2086–2404 | 3.30x | 57 | 2.59x | 0 | yes |
| status-panel | 10 | react-reflex | 2128 | 2043–2200 | 3.27x | 60 | 2.73x | 0 | yes |
| status-panel | 10 | react-upstream | 2200 | 1807–2414 | 3.38x | 49 | 2.23x | 0 | yes |
| status-panel | 10 | roact | 1138 | 950–1300 | 1.75x | 45 | 2.05x | 0 | yes |
| status-panel | 10 | seam | 1967 | 1400–2302 | 3.02x | 155 | 7.05x | 1 | yes |
| status-panel | 10 | signals | 1014 | 728–1096 | 1.56x | 37 | 1.68x | 0 | yes |
| status-panel | 10 | vide | 1173 | 948–1456 | 1.80x | 46 | 2.09x | 0 | yes |
| scene-3d | 10 | plain | 2677 | 2583–3103 | 1.00x | 11 | 1.00x | 1 | yes |
| scene-3d | 10 | blend | 4756 | 4502–4887 | 1.78x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 3079 | 2954–3648 | 1.15x | 187 | 17.00x | 0 | yes |
| scene-3d | 10 | fusion | 36094 | 35942–37799 | 13.48x | 512 | 46.55x | 0 | yes |
| scene-3d | 10 | fusion-charm | 33919 | 33065–34537 | 12.67x | 524 | 47.64x | 1 | yes |
| scene-3d | 10 | react | 3638 | 3345–4094 | 1.36x | 222 | 20.18x | 0 | yes |
| scene-3d | 10 | react-reflex | 3207 | 3000–3486 | 1.20x | 225 | 20.45x | 0 | yes |
| scene-3d | 10 | react-upstream | 3914 | 3712–4250 | 1.46x | 215 | 19.55x | 0 | yes |
| scene-3d | 10 | roact | 3504 | 3282–3898 | 1.31x | 567 | 51.55x | 0 | yes |
| scene-3d | 10 | seam | 8803 | 8218–9467 | 3.29x | 1755 | 159.55x | 0 | yes |
| scene-3d | 10 | signals | 6138 | 5701–6504 | 2.29x | 674 | 61.27x | 9 | yes |
| scene-3d | 10 | vide | 3850 | 3754–4044 | 1.44x | 219 | 19.91x | 0 | yes |
| derived-diamond | 3 | plain | 13 | 13–28 | 1.00x | 2 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 150 | 100–212 | 11.41x | 19 | 9.50x | 0 | yes |
| derived-diamond | 3 | compose | 103 | 100–150 | 7.83x | 10 | 5.00x | 2 | yes |
| derived-diamond | 3 | fusion | 128 | 100–179 | 9.72x | 9 | 4.50x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 125 | 100–156 | 9.51x | 10 | 5.00x | 0 | yes |
| derived-diamond | 3 | react | 296 | 203–433 | 22.49x | 5 | 2.50x | 2 | yes |
| derived-diamond | 3 | react-reflex | 429 | 200–458 | 32.63x | 23 | 11.50x | 5 | yes |
| derived-diamond | 3 | react-upstream | 281 | 245–367 | 21.40x | 0 | 0.50x | 2 | yes |
| derived-diamond | 3 | roact | 100 | 100–125 | 7.61x | 0 | 0.50x | 0 | yes |
| derived-diamond | 3 | seam | 177 | 100–200 | 13.46x | 18 | 9.00x | 0 | yes |
| derived-diamond | 3 | signals | 126 | 100–215 | 9.56x | 10 | 5.00x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 100–139 | 7.61x | 6 | 3.00x | 1 | yes |
| derived-chain-100 | 3 | plain | 22 | 16–22 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | 181 | 175–225 | 8.38x | 361 | 90.25x | 8 | yes |
| derived-chain-100 | 3 | compose | 150 | 100–200 | 6.94x | 132 | 33.00x | 0 | yes |
| derived-chain-100 | 3 | fusion | 875 | 775–982 | 40.46x | 129 | 32.25x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 826 | 707–836 | 38.19x | 131 | 32.75x | 1 | yes |
| derived-chain-100 | 3 | react | 600 | 568–633 | 27.75x | 114 | 28.50x | 0 | yes |
| derived-chain-100 | 3 | react-reflex | 747 | 602–768 | 34.56x | 323 | 80.75x | 11 | yes |
| derived-chain-100 | 3 | react-upstream | 735 | 667–769 | 33.97x | 106 | 26.50x | 8 | yes |
| derived-chain-100 | 3 | roact | 125 | 100–139 | 5.78x | 0 | 0.25x | 0 | yes |
| derived-chain-100 | 3 | seam | 600 | 514–700 | 27.75x | 281 | 70.25x | 0 | yes |
| derived-chain-100 | 3 | signals | 233 | 150–374 | 10.76x | 183 | 45.75x | 8 | yes |
| derived-chain-100 | 3 | vide | 152 | 125–168 | 7.02x | 86 | 21.50x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 33 | 25–50 | 1.00x | 17 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 275 | 150–426 | 8.35x | 1521 | 89.47x | 8 | yes |
| derived-fan-in-1000 | 3 | compose | 300 | 277–312 | 9.10x | 687 | 40.41x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 2267 | 2133–2412 | 68.79x | 890 | 52.35x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2273 | 1903–2373 | 68.97x | 2814 | 165.53x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2812 | 2110–3252 | 85.35x | 645 | 37.94x | 43 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 13216 | 10120–15413 | 401.06x | 5700 | 335.29x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2606 | 2204–3105 | 79.08x | 629 | 37.00x | 26 | yes |
| derived-fan-in-1000 | 3 | roact | 500 | 352–668 | 15.17x | 102 | 6.00x | 1 | yes |
| derived-fan-in-1000 | 3 | seam | 2807 | 2726–3004 | 85.18x | 2955 | 173.82x | 8 | yes |
| derived-fan-in-1000 | 3 | signals | 775 | 625–853 | 23.52x | 1205 | 70.88x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 451 | 425–676 | 13.69x | 528 | 31.06x | 0 | yes |
| filter-as-you-type | 1 | plain | 7656 | 7320–8500 | 1.00x | 42 | 1.00x | 8 | yes |
| filter-as-you-type | 1 | blend | 16337 | 15806–16931 | 2.13x | 3008 | 71.62x | 0 | yes |
| filter-as-you-type | 1 | compose | 10400 | 9703–10952 | 1.36x | 841 | 20.02x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28564 | 27424–32174 | 3.73x | 2465 | 58.69x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 25927 | 25232–27354 | 3.39x | 2451 | 58.36x | 0 | yes |
| filter-as-you-type | 1 | react | 30325 | 29044–31221 | 3.96x | 19 | 0.45x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 31223 | 27938–33782 | 4.08x | 1159 | 27.60x | 6 | yes |
| filter-as-you-type | 1 | react-upstream | 31871 | 29548–33131 | 4.16x | 3 | 0.07x | 0 | yes |
| filter-as-you-type | 1 | roact | 11213 | 10711–11631 | 1.46x | 492 | 11.71x | 1 | yes |
| filter-as-you-type | 1 | seam | 23579 | 20738–24306 | 3.08x | 3901 | 92.88x | 0 | yes |
| filter-as-you-type | 1 | signals | 6940 | 6805–7301 | 0.91x | 45 | 1.07x | 0 | yes |
| filter-as-you-type | 1 | vide | 10605 | 9919–10835 | 1.39x | 960 | 22.86x | 0 | yes |
| theme-propagation | 3 | plain | 46958 | 44751–47356 | 1.00x | 49 | 1.00x | 9 | yes |
| theme-propagation | 3 | blend | 46245 | 44849–47576 | 0.98x | 2070 | 42.24x | 1 | yes |
| theme-propagation | 3 | compose | 50546 | 49744–50830 | 1.08x | 576 | 11.76x | 2 | yes |
| theme-propagation | 3 | fusion | 53135 | 51454–57133 | 1.13x | 875 | 17.86x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 52154 | 49744–57198 | 1.11x | 885 | 18.06x | 0 | yes |
| theme-propagation | 3 | react | 52684 | 52284–55846 | 1.12x | 2028 | 41.39x | 0 | yes |
| theme-propagation | 3 | react-reflex | 46856 | 46057–49246 | 1.00x | 2030 | 41.43x | 1 | yes |
| theme-propagation | 3 | react-upstream | 52991 | 52408–53642 | 1.13x | 2028 | 41.39x | 0 | yes |
| theme-propagation | 3 | roact | 50793 | 50187–52161 | 1.08x | 3294 | 67.22x | 8 | yes |
| theme-propagation | 3 | seam | 45145 | 45058–46192 | 0.96x | 3478 | 70.98x | 0 | yes |
| theme-propagation | 3 | signals | 51826 | 51440–52639 | 1.10x | 897 | 18.31x | 1 | yes |
| theme-propagation | 3 | vide | 50777 | 48967–51790 | 1.08x | 606 | 12.37x | 1 | yes |
| hud-per-frame | 1 | plain | 2384 | 2168–3125 | 1.00x | 3 | 1.00x | 1 | yes |
| hud-per-frame | 1 | blend | 4613 | 3532–5292 | 1.93x | 72 | 23.83x | 0 | yes |
| hud-per-frame | 1 | compose | 3672 | 3506–4249 | 1.54x | 26 | 8.50x | 0 | yes |
| hud-per-frame | 1 | fusion | 9400 | 8716–10445 | 3.94x | 50 | 16.83x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 11623 | 11340–11661 | 4.88x | 98 | 32.50x | 5 | yes |
| hud-per-frame | 1 | react | 3439 | 3081–3505 | 1.44x | 34 | 11.33x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 5357 | 5177–6460 | 2.25x | 56 | 18.50x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 4244 | 4070–4873 | 1.78x | 30 | 10.17x | 0 | yes |
| hud-per-frame | 1 | roact | 3213 | 2979–4118 | 1.35x | 70 | 23.33x | 0 | yes |
| hud-per-frame | 1 | seam | 8178 | 7583–8455 | 3.43x | 173 | 57.67x | 0 | yes |
| hud-per-frame | 1 | signals | 4653 | 4315–5011 | 1.95x | 66 | 22.00x | 0 | yes |
| hud-per-frame | 1 | vide | 4862 | 3427–5373 | 2.04x | 22 | 7.17x | 0 | yes |
| teardown-under-load | 1 | plain | 46377 | 39521–48689 | 1.00x | 11 | 1.00x | 8 | yes |
| teardown-under-load | 1 | blend | 70840 | 66128–76186 | 1.53x | 15 | 1.36x | 0 | yes |
| teardown-under-load | 1 | compose | 53058 | 49449–54296 | 1.14x | 8 | 0.73x | 2 | yes |
| teardown-under-load | 1 | fusion | 76836 | 72867–83544 | 1.66x | 5 | 0.45x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 76686 | 66242–83865 | 1.65x | 8 | 0.73x | 0 | yes |
| teardown-under-load | 1 | react | 73406 | 69528–77561 | 1.58x | 1078 | 98.00x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 78930 | 74670–83869 | 1.70x | 1080 | 98.18x | 1 | yes |
| teardown-under-load | 1 | react-upstream | 72884 | 69281–77322 | 1.57x | 1078 | 98.00x | 0 | yes |
| teardown-under-load | 1 | roact | 63107 | 55462–68347 | 1.36x | 71 | 6.45x | 0 | yes |
| teardown-under-load | 1 | seam | 71117 | 62442–76427 | 1.53x | 16 | 1.45x | 7 | yes |
| teardown-under-load | 1 | signals | 55070 | 49443–56720 | 1.19x | 13 | 1.18x | 8 | yes |
| teardown-under-load | 1 | vide | 59477 | 50715–61296 | 1.28x | 5 | 0.45x | 0 | yes |
| open-close-retention | 1 | plain | 63360 | 62643–64433 | 1.00x | 11 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 124582 | 123307–124605 | 1.97x | 14 | 1.27x | 8 | yes |
| open-close-retention | 1 | compose | 83783 | 82781–84474 | 1.32x | 8 | 0.73x | 2 | yes |
| open-close-retention | 1 | fusion | 136144 | 132023–137620 | 2.15x | 13 | 1.18x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 133606 | 132312–137466 | 2.11x | 15 | 1.36x | 1 | yes |
| open-close-retention | 1 | react | 116186 | 114255–117555 | 1.83x | 272 | 24.68x | 2 | yes |
| open-close-retention | 1 | react-reflex | 122432 | 122426–123498 | 1.93x | 273 | 24.82x | 0 | yes |
| open-close-retention | 1 | react-upstream | 117200 | 116173–119414 | 1.85x | 264 | 24.00x | 0 | yes |
| open-close-retention | 1 | roact | 99324 | 97388–101663 | 1.57x | 23 | 2.09x | 1 | yes |
| open-close-retention | 1 | seam | 121361 | 121258–130424 | 1.92x | 10 | 0.91x | 1 | yes |
| open-close-retention | 1 | signals | 84220 | 83901–84377 | 1.33x | 6 | 0.55x | 1 | yes |
| open-close-retention | 1 | vide | 90525 | 90158–90668 | 1.43x | 5 | 0.45x | 0 | yes |
| tree-expand-collapse | 1 | plain | 11461 | 10433–11829 | 1.00x | 43 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 21641 | 19837–23370 | 1.89x | 809 | 18.81x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12316 | 11438–12675 | 1.07x | 72 | 1.67x | 0 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25650 | 22613–26033 | 2.24x | 158 | 3.67x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23956 | 22068–27220 | 2.09x | 167 | 3.88x | 1 | yes |
| tree-expand-collapse | 1 | react | 24818 | 24475–26302 | 2.17x | 3 | 0.07x | 2 | yes |
| tree-expand-collapse | 1 | react-reflex | 26639 | 25672–27149 | 2.32x | 620 | 14.42x | 5 | yes |
| tree-expand-collapse | 1 | react-upstream | 26561 | 25532–26933 | 2.32x | 3 | 0.07x | 2 | yes |
| tree-expand-collapse | 1 | roact | 11105 | 10904–11464 | 0.97x | 41 | 0.95x | 1 | yes |
| tree-expand-collapse | 1 | seam | 28600 | 25732–30466 | 2.50x | 141 | 3.28x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8305 | 8207–8341 | 0.72x | 38 | 0.88x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11913 | 11630–12130 | 1.04x | 71 | 1.65x | 0 | yes |
| form-validation | 1 | plain | 2102 | 1536–2370 | 1.00x | 5 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 3375 | 3036–4272 | 1.61x | 202 | 40.40x | 0 | yes |
| form-validation | 1 | compose | 3220 | 2678–3509 | 1.53x | 92 | 18.40x | 1 | yes |
| form-validation | 1 | fusion | 4889 | 4678–5193 | 2.33x | 120 | 24.00x | 0 | yes |
| form-validation | 1 | fusion-charm | 4973 | 4511–5479 | 2.37x | 156 | 31.20x | 0 | yes |
| form-validation | 1 | react | 3535 | 3148–3771 | 1.68x | 62 | 12.40x | 0 | yes |
| form-validation | 1 | react-reflex | 4774 | 4423–5048 | 2.27x | 79 | 15.80x | 1 | yes |
| form-validation | 1 | react-upstream | 4027 | 3716–4834 | 1.92x | 62 | 12.40x | 0 | yes |
| form-validation | 1 | roact | 3916 | 3303–4573 | 1.86x | 158 | 31.60x | 1 | yes |
| form-validation | 1 | seam | 5899 | 5295–5924 | 2.81x | 350 | 70.00x | 0 | yes |
| form-validation | 1 | signals | 3423 | 2934–4539 | 1.63x | 163 | 32.60x | 8 | yes |
| form-validation | 1 | vide | 3304 | 2602–3753 | 1.57x | 60 | 12.00x | 0 | yes |
| table-sort-filter | 1 | plain | 15905 | 15310–18131 | 1.00x | 89 | 1.00x | 8 | yes |
| table-sort-filter | 1 | blend | 37333 | 35428–37911 | 2.35x | 6106 | 68.61x | 0 | yes |
| table-sort-filter | 1 | compose | 24817 | 24129–25531 | 1.56x | 1625 | 18.26x | 18 | yes |
| table-sort-filter | 1 | fusion (workaround) | 56357 | 54994–59451 | 3.54x | 4528 | 50.88x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 55238 | 51226–57448 | 3.47x | 4642 | 52.16x | 1 | yes |
| table-sort-filter | 1 | react | 138790 | 135858–142759 | 8.73x | 2993 | 33.63x | 0 | yes |
| table-sort-filter | 1 | react-reflex | 141000 | 133816–142917 | 8.87x | 3000 | 33.71x | 13 | yes |
| table-sort-filter | 1 | react-upstream | 140249 | 134507–145687 | 8.82x | 2993 | 33.63x | 2 | yes |
| table-sort-filter | 1 | roact | 24264 | 23424–25500 | 1.53x | 1004 | 11.28x | 0 | yes |
| table-sort-filter | 1 | seam | 56159 | 51289–64894 | 3.53x | 7744 | 87.01x | 1 | yes |
| table-sort-filter | 1 | signals | 16722 | 16160–17424 | 1.05x | 84 | 0.94x | 0 | yes |
| table-sort-filter | 1 | vide | 23192 | 22671–24931 | 1.46x | 1922 | 21.60x | 0 | yes |
| library-load | 1 | plain | 34 | 32–55 | 1.00x | 2 | 1.00x | 1 | yes |
| library-load | 1 | blend | 711 | 672–796 | 20.99x | 459 | 229.50x | 457 | yes |
| library-load | 1 | compose | 660 | 597–762 | 19.49x | 67 | 33.50x | 64 | yes |
| library-load | 1 | fusion | 1265 | 1224–1672 | 37.33x | 264 | 132.00x | 263 | yes |
| library-load | 1 | fusion-charm | 1405 | 1288–1523 | 41.49x | 318 | 159.00x | 317 | yes |
| library-load | 1 | react | 4852 | 4650–4879 | 143.23x | 1825 | 912.50x | 1832 | yes |
| library-load | 1 | react-reflex | 5837 | 5386–8325 | 172.31x | 1975 | 987.50x | 1971 | yes |
| library-load | 1 | react-upstream | 4738 | 4615–4979 | 139.88x | 2002 | 1001.00x | 2001 | yes |
| library-load | 1 | roact | 406 | 346–441 | 11.97x | 153 | 76.50x | 151 | yes |
| library-load | 1 | seam | 1313 | 1243–1504 | 38.76x | 235 | 117.50x | 240 | yes |
| library-load | 1 | signals | 243 | 176–275 | 7.17x | 26 | 13.00x | 25 | yes |
| library-load | 1 | vide | 325 | 262–341 | 9.61x | 147 | 73.50x | 146 | yes |
| rows-append-1000 | 1 | plain | 91058 | 88480–102296 | 1.00x | 3657 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 161793 | 146664–171758 | 1.78x | 38474 | 10.52x | 1 | yes |
| rows-append-1000 | 1 | compose | 115603 | 110470–147459 | 1.27x | 11039 | 3.02x | 3 | yes |
| rows-append-1000 | 1 | fusion | 351359 | 326361–357307 | 3.86x | 20745 | 5.67x | 8 | yes |
| rows-append-1000 | 1 | fusion-charm | 340812 | 329819–350365 | 3.74x | 28602 | 7.82x | 1 | yes |
| rows-append-1000 | 1 | react | 182844 | 176148–228688 | 2.01x | 18315 | 5.01x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 189185 | 178339–215489 | 2.08x | 20036 | 5.48x | 103 | yes |
| rows-append-1000 | 1 | react-upstream | 193044 | 191320–227484 | 2.12x | 18059 | 4.94x | 0 | yes |
| rows-append-1000 | 1 | roact | 124724 | 116190–134630 | 1.37x | 26960 | 7.37x | 8367 | yes |
| rows-append-1000 | 1 | seam | 167469 | 129976–195806 | 1.84x | 46198 | 12.63x | 0 | yes |
| rows-append-1000 | 1 | signals | 109129 | 98515–123488 | 1.20x | 17278 | 4.72x | 9 | yes |
| rows-append-1000 | 1 | vide | 116315 | 102069–118490 | 1.28x | 10432 | 2.85x | 1 | yes |
| rows-clear | 1 | plain | 16701 | 15779–17320 | 1.00x | 1259 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 36273 | 33713–36976 | 2.17x | 4177 | 3.32x | 8 | yes |
| rows-clear | 1 | compose | 24434 | 22818–27310 | 1.46x | 1878 | 1.49x | 11 | yes |
| rows-clear | 1 | fusion | 76424 | 74854–77765 | 4.58x | 3426 | 2.72x | 8 | yes |
| rows-clear | 1 | fusion-charm | 73084 | 66291–73863 | 4.38x | 7328 | 5.82x | 0 | yes |
| rows-clear | 1 | react | 25059 | 23912–26133 | 1.50x | 4488 | 3.56x | 0 | yes |
| rows-clear | 1 | react-reflex | 29227 | 25444–31372 | 1.75x | 6666 | 5.29x | 64 | yes |
| rows-clear | 1 | react-upstream | 26016 | 23905–27576 | 1.56x | 4472 | 3.55x | 0 | yes |
| rows-clear | 1 | roact | 20534 | 20015–25422 | 1.23x | 4189 | 3.33x | 0 | yes |
| rows-clear | 1 | seam | 48291 | 37618–57357 | 2.89x | 9163 | 7.28x | 9 | yes |
| rows-clear | 1 | signals | 21763 | 20921–23167 | 1.30x | 4402 | 3.50x | 8 | yes |
| rows-clear | 1 | vide | 20000 | 19237–21318 | 1.20x | 1613 | 1.28x | 1 | yes |
| rows-create-1000 | 1 | plain | 87962 | 85386–97152 | 1.00x | 1837 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 147168 | 139850–157991 | 1.67x | 19504 | 10.62x | 1 | yes |
| rows-create-1000 | 1 | compose | 107766 | 104155–118430 | 1.23x | 5610 | 3.05x | 3 | yes |
| rows-create-1000 | 1 | fusion | 186556 | 164186–196323 | 2.12x | 10642 | 5.79x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 178823 | 163099–193096 | 2.03x | 14564 | 7.93x | 0 | yes |
| rows-create-1000 | 1 | react | 190201 | 177002–190888 | 2.16x | 8654 | 4.71x | 8 | yes |
| rows-create-1000 | 1 | react-reflex | 194907 | 191003–210555 | 2.22x | 9581 | 5.22x | 79 | yes |
| rows-create-1000 | 1 | react-upstream | 182442 | 176097–188538 | 2.07x | 8631 | 4.70x | 0 | yes |
| rows-create-1000 | 1 | roact | 119307 | 110766–150202 | 1.36x | 13596 | 7.40x | 4182 | yes |
| rows-create-1000 | 1 | seam | 147001 | 120899–160836 | 1.67x | 23529 | 12.81x | 0 | yes |
| rows-create-1000 | 1 | signals | 103126 | 89643–131781 | 1.17x | 9074 | 4.94x | 1 | yes |
| rows-create-1000 | 1 | vide | 115670 | 103666–134708 | 1.31x | 4949 | 2.69x | 1 | yes |
| rows-create-10000 | 1 | plain | 1017597 | 994905–1068520 | 1.00x | 17014 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1678876 | 1566899–1704683 | 1.65x | 189212 | 11.12x | 0 | yes |
| rows-create-10000 | 1 | compose | 1349163 | 1345314–1352701 | 1.33x | 55479 | 3.26x | 11 | yes |
| rows-create-10000 | 1 | fusion | 6491034 | 6455484–6600098 | 6.38x | 104693 | 6.15x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6026310 | 5950676–6368103 | 5.92x | 144415 | 8.49x | 4 | yes |
| rows-create-10000 | 1 | react | 6721580 | 6582754–6900683 | 6.61x | 84404 | 4.96x | 384 | yes |
| rows-create-10000 | 1 | react-reflex | 6841338 | 6793874–7035886 | 6.72x | 93144 | 5.47x | 957 | yes |
| rows-create-10000 | 1 | react-upstream | 6639438 | 6572098–6801804 | 6.52x | 85554 | 5.03x | 132 | yes |
| rows-create-10000 | 1 | roact | 1366188 | 1363093–1380077 | 1.34x | 133287 | 7.83x | 40512 | yes |
| rows-create-10000 | 1 | seam | 1781982 | 1709655–1791953 | 1.75x | 235726 | 13.85x | 0 | yes |
| rows-create-10000 | 1 | signals | 1179616 | 1150547–1221691 | 1.16x | 89450 | 5.26x | 1 | yes |
| rows-create-10000 | 1 | vide | 1321971 | 1257150–1445241 | 1.30x | 48522 | 2.85x | 8 | yes |
| rows-remove-one | 1 | plain | 433 | 267–568 | 1.00x | 1419 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1152 | 1100–1304 | 2.66x | 18349 | 12.93x | 1 | yes |
| rows-remove-one | 1 | compose | 903 | 800–1033 | 2.08x | 4949 | 3.49x | 18 | yes |
| rows-remove-one | 1 | fusion (workaround) | 62569 | 60271–65474 | 144.39x | 10978 | 7.74x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 59563 | 57754–61181 | 137.45x | 14946 | 10.53x | 9 | yes |
| rows-remove-one | 1 | react | 16834 | 12742–40731 | 38.85x | 13160 | 9.27x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 25219 | 20509–34233 | 58.20x | 14094 | 9.93x | 56 | yes |
| rows-remove-one | 1 | react-upstream | 17432 | 13809–18215 | 40.23x | 13169 | 9.28x | 0 | yes |
| rows-remove-one | 1 | roact | 6401 | 6221–6612 | 14.77x | 13799 | 9.72x | 4177 | yes |
| rows-remove-one | 1 | seam | 5507 | 5305–6018 | 12.71x | 23105 | 16.28x | 0 | yes |
| rows-remove-one | 1 | signals | 1403 | 1236–1568 | 3.24x | 8646 | 6.09x | 0 | yes |
| rows-remove-one | 1 | vide | 1070 | 936–1235 | 2.47x | 4561 | 3.21x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–133 | 1.00x | 1861 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 700 | 550–703 | 7.00x | 18818 | 10.11x | 0 | yes |
| rows-swap | 1 | compose | 302 | 200–360 | 3.02x | 5376 | 2.89x | 3 | yes |
| rows-swap | 1 | fusion | 60775 | 59568–61220 | 607.75x | 10007 | 5.38x | 0 | yes |
| rows-swap | 1 | fusion-charm | 59668 | 59430–60190 | 596.68x | 14235 | 7.65x | 1 | yes |
| rows-swap | 1 | react | 58129 | 57464–59338 | 581.29x | 9846 | 5.29x | 0 | yes |
| rows-swap | 1 | react-reflex | 62605 | 59960–64319 | 626.05x | 10834 | 5.82x | 64 | yes |
| rows-swap | 1 | react-upstream | 58153 | 56638–60037 | 581.53x | 9902 | 5.32x | 0 | yes |
| rows-swap | 1 | roact | 1906 | 1502–1957 | 19.05x | 13891 | 7.46x | 4197 | yes |
| rows-swap | 1 | seam | 5103 | 4620–5314 | 51.03x | 23559 | 12.66x | 0 | yes |
| rows-swap | 1 | signals | 472 | 402–602 | 4.72x | 9098 | 4.89x | 0 | yes |
| rows-swap | 1 | vide | 206 | 150–304 | 2.06x | 4972 | 2.67x | 0 | yes |
| rows-update-every-10th | 1 | plain | 1902 | 1700–2001 | 1.00x | 1405 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 2001 | 1750–2056 | 1.05x | 18787 | 13.37x | 1 | yes |
| rows-update-every-10th | 1 | compose | 2100 | 1936–2142 | 1.10x | 5000 | 3.56x | 0 | yes |
| rows-update-every-10th | 1 | fusion | 1900 | 1800–2104 | 1.00x | 9991 | 7.11x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2400 | 2200–2509 | 1.26x | 13896 | 9.89x | 0 | yes |
| rows-update-every-10th | 1 | react | 2000 | 1950–2050 | 1.05x | 8615 | 6.13x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 4054 | 3762–4369 | 2.13x | 9532 | 6.78x | 56 | yes |
| rows-update-every-10th | 1 | react-upstream | 2052 | 1904–2156 | 1.08x | 8150 | 5.80x | 0 | yes |
| rows-update-every-10th | 1 | roact | 2057 | 1904–2103 | 1.08x | 13398 | 9.54x | 8 | yes |
| rows-update-every-10th | 1 | seam | 4305 | 4000–5951 | 2.26x | 23576 | 16.78x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2004 | 1860–2069 | 1.05x | 8818 | 6.28x | 1 | yes |
| rows-update-every-10th | 1 | vide | 1939 | 1913–1968 | 1.02x | 4661 | 3.32x | 1 | yes |

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
| blend | 30 | 2.83x | 14.95x | 2.79x | 14.70x |
| compose | 30 | 1.99x | 5.19x | 1.97x | 5.09x |
| fusion | 30 | 7.67x | 8.60x | 7.23x | 8.43x |
| fusion-charm | 30 | 7.12x | 10.92x | 6.69x | 10.79x |
| react | 29 | 5.93x | 7.17x | 5.93x | 7.17x |
| react-reflex | 29 | 6.47x | 13.17x | 6.47x | 13.17x |
| react-upstream | 29 | 6.12x | 6.23x | 6.12x | 6.23x |
| roact | 29 | 2.74x | 6.09x | 2.74x | 6.09x |
| seam | 30 | 4.64x | 17.44x | 4.56x | 16.95x |
| signals | 29 | 2.05x | 3.96x | 2.05x | 3.96x |
| vide | 30 | 2.17x | 3.86x | 2.14x | 3.82x |
