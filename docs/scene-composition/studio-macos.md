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
| Roblox Studio | 0.748.0.7481526 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `f245db2` |
| Date | 2026-11-25 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 1341 | 1080–1559 | 1.00x | 50 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 1200 | 700–1639 | 0.89x | 773 | 15.46x | 9 | yes |
| update-leaf | 20 | compose | 1100 | 1037–1700 | 0.82x | 100 | 2.00x | 2 | yes |
| update-leaf | 20 | fusion | 1622 | 1506–1718 | 1.21x | 51 | 1.02x | 1 | yes |
| update-leaf | 20 | fusion-charm | 1628 | 1550–2001 | 1.21x | 63 | 1.26x | 10 | yes |
| update-leaf | 20 | react | 1500 | 1300–1613 | 1.12x | 347 | 6.94x | 0 | yes |
| update-leaf | 20 | react-reflex | 2100 | 1718–2195 | 1.57x | 293 | 5.86x | 0 | yes |
| update-leaf | 20 | react-upstream | 1704 | 904–1739 | 1.27x | 291 | 5.82x | 0 | yes |
| update-leaf | 20 | roact | 1206 | 1005–1409 | 0.90x | 466 | 9.32x | 0 | yes |
| update-leaf | 20 | seam | 2100 | 1439–2304 | 1.57x | 40 | 0.80x | 0 | yes |
| update-leaf | 20 | signals | 1621 | 1408–1900 | 1.21x | 51 | 1.02x | 0 | yes |
| update-leaf | 20 | vide | 1500 | 1312–1660 | 1.12x | 0 | 0.02x | 0 | yes |
| update-batched | 20 | plain | 6041 | 5751–6118 | 1.00x | 20 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 11254 | 10614–11658 | 1.86x | 924 | 46.20x | 0 | yes |
| update-batched | 20 | compose | 7772 | 7521–8049 | 1.29x | 401 | 20.05x | 10 | yes |
| update-batched | 20 | fusion | 21468 | 20617–21835 | 3.55x | 508 | 25.40x | 0 | yes |
| update-batched | 20 | fusion-charm | 37945 | 35967–38719 | 6.28x | 1101 | 55.05x | 0 | yes |
| update-batched | 20 | react | 9023 | 7820–9401 | 1.49x | 525 | 26.25x | 0 | yes |
| update-batched | 20 | react-reflex | 24216 | 23404–24288 | 4.01x | 794 | 39.70x | 16 | yes |
| update-batched | 20 | react-upstream | 9130 | 8644–9157 | 1.51x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | roact | 9019 | 8744–9683 | 1.49x | 867 | 43.35x | 1 | yes |
| update-batched | 20 | seam | 15972 | 14353–17392 | 2.64x | 1848 | 92.40x | 1 | yes |
| update-batched | 20 | signals | 10549 | 10203–11037 | 1.75x | 597 | 29.85x | 0 | yes |
| update-batched | 20 | vide | 9576 | 9433–9998 | 1.59x | 336 | 16.80x | 0 | yes |
| update-repeated | 10 | plain | 152 | 103–404 | 1.00x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3406 | 3400–3555 | 22.48x | 8 | 8.00x | 1 | yes |
| update-repeated | 10 | compose | 400 | 300–500 | 2.64x | 6 | 6.00x | 1 | yes |
| update-repeated | 10 | fusion | 25029 | 24714–25435 | 165.21x | 5 | 5.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1200 | 1100–1400 | 7.92x | 15 | 15.00x | 9 | yes |
| update-repeated | 10 | react | 7402 | 7100–7410 | 48.86x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | react-reflex | 500 | 409–600 | 3.30x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7420 | 7200–7508 | 48.98x | 1 | 1.00x | 1 | yes |
| update-repeated | 10 | roact | 5307 | 5304–5428 | 35.03x | 5 | 5.00x | 0 | yes |
| update-repeated | 10 | seam | 1703 | 1402–1900 | 11.24x | 11 | 11.00x | 0 | yes |
| update-repeated | 10 | signals | 769 | 752–850 | 5.08x | 12 | 12.00x | 1 | yes |
| update-repeated | 10 | vide | 550 | 504–655 | 3.63x | 3 | 3.00x | 0 | yes |
| branch-swap | 20 | plain | 13806 | 13253–14198 | 1.00x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 18502 | 17869–18798 | 1.34x | 28 | 14.00x | 1 | yes |
| branch-swap | 20 | compose | 15435 | 15136–15644 | 1.12x | 16 | 8.00x | 2 | yes |
| branch-swap | 20 | fusion | 16717 | 16203–17120 | 1.21x | 13 | 6.50x | 1 | yes |
| branch-swap | 20 | fusion-charm | 16623 | 15917–16818 | 1.20x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 18420 | 14169–19147 | 1.33x | 19 | 9.50x | 0 | yes |
| branch-swap | 20 | react-reflex | 19366 | 18847–22114 | 1.40x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 18235 | 17726–18663 | 1.32x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | roact | 16088 | 15888–16252 | 1.17x | 23 | 11.50x | 6 | yes |
| branch-swap | 20 | seam | 16315 | 16058–16389 | 1.18x | 20 | 10.00x | 1 | yes |
| branch-swap | 20 | signals | 14339 | 14251–14458 | 1.04x | 0 | 0.50x | 0 | yes |
| branch-swap | 20 | vide | 16395 | 15995–17501 | 1.19x | 5 | 2.50x | 1 | yes |
| keyed-prepend | 10 | plain | 3130 | 2958–3212 | 1.00x | 64 | 1.00x | 8 | yes |
| keyed-prepend | 10 | blend | 6336 | 6139–6449 | 2.02x | 1695 | 26.48x | 1 | yes |
| keyed-prepend | 10 | compose | 5070 | 4876–5844 | 1.62x | 561 | 8.77x | 17 | yes |
| keyed-prepend | 10 | fusion (workaround) | 23519 | 21291–24532 | 7.51x | 1516 | 23.69x | 0 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 25054 | 23917–25788 | 8.00x | 1509 | 23.58x | 1 | yes |
| keyed-prepend | 10 | react | 16461 | 16303–17390 | 5.26x | 778 | 12.16x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16918 | 16001–17297 | 5.41x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 17215 | 16136–18030 | 5.50x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | roact | 7573 | 7467–7913 | 2.42x | 364 | 5.69x | 0 | yes |
| keyed-prepend | 10 | seam | 13021 | 12632–13627 | 4.16x | 2404 | 37.56x | 0 | yes |
| keyed-prepend | 10 | signals | 2874 | 2715–2980 | 0.92x | 66 | 1.03x | 1 | yes |
| keyed-prepend | 10 | vide | 5801 | 5406–6756 | 1.85x | 635 | 9.92x | 1 | yes |
| keyed-insert | 10 | plain | 1651 | 1650–1841 | 1.00x | 57 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4503 | 4320–4600 | 2.73x | 1694 | 29.72x | 0 | yes |
| keyed-insert | 10 | compose | 3135 | 3106–3402 | 1.90x | 545 | 9.56x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 19704 | 18505–20404 | 11.93x | 1524 | 26.74x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 18821 | 17601–19233 | 11.40x | 1526 | 26.77x | 1 | yes |
| keyed-insert | 10 | react | 13700 | 13310–14012 | 8.30x | 811 | 14.23x | 0 | yes |
| keyed-insert | 10 | react-reflex | 14004 | 13914–14507 | 8.48x | 812 | 14.25x | 1 | yes |
| keyed-insert | 10 | react-upstream | 14422 | 13800–14733 | 8.74x | 811 | 14.23x | 0 | yes |
| keyed-insert | 10 | roact | 5900 | 5700–5918 | 3.57x | 365 | 6.40x | 0 | yes |
| keyed-insert | 10 | seam | 10919 | 10501–11637 | 6.61x | 2412 | 42.32x | 0 | yes |
| keyed-insert | 10 | signals | 1862 | 1704–2178 | 1.13x | 59 | 1.04x | 0 | yes |
| keyed-insert | 10 | vide | 3824 | 3615–4006 | 2.32x | 643 | 11.28x | 1 | yes |
| keyed-shuffle | 10 | plain | 1968 | 1814–2222 | 1.00x | 116 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3414 | 3289–3470 | 1.74x | 1641 | 14.15x | 8 | yes |
| keyed-shuffle | 10 | compose | 3206 | 3170–3352 | 1.63x | 557 | 4.80x | 17 | yes |
| keyed-shuffle | 10 | fusion | 18661 | 18180–18779 | 9.48x | 1384 | 11.93x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 18366 | 18162–19277 | 9.33x | 1386 | 11.95x | 8 | yes |
| keyed-shuffle | 10 | react | 28418 | 28007–28780 | 14.44x | 776 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 28738 | 28066–31672 | 14.61x | 776 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 28256 | 27648–29271 | 14.36x | 840 | 7.24x | 0 | yes |
| keyed-shuffle | 10 | roact | 5802 | 5408–6006 | 2.95x | 361 | 3.11x | 9 | yes |
| keyed-shuffle | 10 | seam | 9209 | 8805–10439 | 4.68x | 2431 | 20.96x | 0 | yes |
| keyed-shuffle | 10 | signals | 2114 | 1950–2209 | 1.07x | 118 | 1.02x | 0 | yes |
| keyed-shuffle | 10 | vide | 3752 | 3550–3862 | 1.91x | 687 | 5.92x | 1 | yes |
| events | 1 | plain | 1108 | 900–1883 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | blend | 1500 | 900–1771 | 1.35x | 1 | 0.50x | 0 | yes |
| events | 1 | compose | 1002 | 902–1859 | 0.90x | 3 | 1.50x | 9 | yes |
| events | 1 | fusion | 1400 | 1018–1712 | 1.26x | 2 | 1.00x | 1 | yes |
| events | 1 | fusion-charm | 1521 | 1108–1612 | 1.37x | 2 | 1.00x | 1 | yes |
| events | 1 | react | 1547 | 1413–2000 | 1.40x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 1624 | 1201–1902 | 1.47x | 1 | 0.50x | 1 | yes |
| events | 1 | react-upstream | 1452 | 1220–1896 | 1.31x | 0 | 0.50x | 0 | yes |
| events | 1 | roact | 1210 | 900–1313 | 1.09x | 9 | 4.50x | 8 | yes |
| events | 1 | seam | 1415 | 1015–1634 | 1.28x | 2 | 1.00x | 0 | yes |
| events | 1 | signals | 1241 | 1213–1802 | 1.12x | 2 | 1.00x | 1 | yes |
| events | 1 | vide | 1409 | 1200–2304 | 1.27x | 1 | 0.50x | 8 | yes |
| animate-many | 1 | plain | 2504 | 2400–2600 | 1.00x | 72 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 13445 | 12923–14474 | 5.37x | 1771 | 24.60x | 1 | yes |
| animate-many | 1 | compose | 6934 | 6514–7716 | 2.77x | 655 | 9.10x | 12 | yes |
| animate-many | 1 | fusion | 103621 | 102898–104346 | 41.38x | 1128 | 15.67x | 0 | yes |
| animate-many | 1 | fusion-charm | 108752 | 107311–110384 | 43.43x | 1130 | 15.69x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 25822 | 24071–26393 | 10.31x | 2890 | 40.14x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8835 | 8748–9303 | 3.53x | 384 | 5.33x | 0 | yes |
| status-panel | 10 | plain | 956 | 906–1014 | 1.00x | 22 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1254 | 1160–1507 | 1.31x | 92 | 4.18x | 1 | yes |
| status-panel | 10 | compose | 1203 | 1002–1261 | 1.26x | 55 | 2.50x | 2 | yes |
| status-panel | 10 | fusion | 1610 | 1368–1853 | 1.68x | 78 | 3.55x | 0 | yes |
| status-panel | 10 | fusion-charm | 1887 | 1656–1955 | 1.97x | 84 | 3.82x | 1 | yes |
| status-panel | 10 | react | 2210 | 1900–2391 | 2.31x | 57 | 2.59x | 8 | yes |
| status-panel | 10 | react-reflex | 2403 | 2101–2710 | 2.51x | 59 | 2.68x | 0 | yes |
| status-panel | 10 | react-upstream | 2265 | 2005–2315 | 2.37x | 57 | 2.59x | 7 | yes |
| status-panel | 10 | roact | 1250 | 1200–1303 | 1.31x | 45 | 2.05x | 1 | yes |
| status-panel | 10 | seam | 1900 | 1642–2404 | 1.99x | 155 | 7.05x | 0 | yes |
| status-panel | 10 | signals | 1024 | 1004–1058 | 1.07x | 29 | 1.32x | 0 | yes |
| status-panel | 10 | vide | 1406 | 1157–1521 | 1.47x | 47 | 2.14x | 0 | yes |
| scene-3d | 10 | plain | 2463 | 2428–2680 | 1.00x | 12 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4555 | 4466–5034 | 1.85x | 542 | 45.17x | 1 | yes |
| scene-3d | 10 | compose | 3370 | 3157–3460 | 1.37x | 217 | 18.08x | 1 | yes |
| scene-3d | 10 | fusion | 35882 | 34439–36548 | 14.57x | 512 | 42.67x | 1 | yes |
| scene-3d | 10 | fusion-charm | 33164 | 31617–33255 | 13.46x | 524 | 43.67x | 0 | yes |
| scene-3d | 10 | react | 3629 | 3400–3704 | 1.47x | 230 | 19.17x | 0 | yes |
| scene-3d | 10 | react-reflex | 3138 | 2900–3314 | 1.27x | 227 | 18.92x | 2 | yes |
| scene-3d | 10 | react-upstream | 3602 | 3300–4128 | 1.46x | 223 | 18.58x | 0 | yes |
| scene-3d | 10 | roact | 3524 | 3253–4060 | 1.43x | 567 | 47.25x | 0 | yes |
| scene-3d | 10 | seam | 9720 | 9611–10012 | 3.95x | 1755 | 146.25x | 1 | yes |
| scene-3d | 10 | signals | 6724 | 6600–7010 | 2.73x | 674 | 56.17x | 0 | yes |
| scene-3d | 10 | vide | 4406 | 4351–4612 | 1.79x | 203 | 16.92x | 0 | yes |
| derived-diamond | 3 | plain | 100 | 100–100 | 1.00x | 2 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 125 | 100–155 | 1.25x | 20 | 10.00x | 0 | yes |
| derived-diamond | 3 | compose | 100 | 100–125 | 1.00x | 2 | 1.00x | 2 | yes |
| derived-diamond | 3 | fusion | 100 | 100–127 | 1.00x | 9 | 4.50x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 125 | 100–151 | 1.25x | 10 | 5.00x | 1 | yes |
| derived-diamond | 3 | react | 334 | 300–402 | 3.34x | 0 | 0.50x | 3 | yes |
| derived-diamond | 3 | react-reflex | 367 | 269–405 | 3.67x | 32 | 16.00x | 13 | yes |
| derived-diamond | 3 | react-upstream | 300 | 169–301 | 3.00x | 6 | 3.00x | 3 | yes |
| derived-diamond | 3 | roact | 100 | 100–125 | 1.00x | 7 | 3.50x | 0 | yes |
| derived-diamond | 3 | seam | 100 | 100–202 | 1.00x | 21 | 10.50x | 0 | yes |
| derived-diamond | 3 | signals | 100 | 100–125 | 1.00x | 10 | 5.00x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 100–125 | 1.00x | 6 | 3.00x | 0 | yes |
| derived-chain-100 | 3 | plain | 100 | 100–200 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | 175 | 125–226 | 1.75x | 337 | 84.25x | 1 | yes |
| derived-chain-100 | 3 | compose | 150 | 125–225 | 1.50x | 133 | 33.25x | 0 | yes |
| derived-chain-100 | 3 | fusion | 875 | 827–902 | 8.75x | 129 | 32.25x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 828 | 775–875 | 8.28x | 123 | 30.75x | 0 | yes |
| derived-chain-100 | 3 | react | 733 | 601–801 | 7.33x | 115 | 28.75x | 8 | yes |
| derived-chain-100 | 3 | react-reflex | 867 | 640–967 | 8.67x | 332 | 83.00x | 11 | yes |
| derived-chain-100 | 3 | react-upstream | 706 | 533–867 | 7.06x | 114 | 28.50x | 7 | yes |
| derived-chain-100 | 3 | roact | 131 | 125–150 | 1.31x | 8 | 2.00x | 0 | yes |
| derived-chain-100 | 3 | seam | 700 | 650–750 | 7.00x | 281 | 70.25x | 0 | yes |
| derived-chain-100 | 3 | signals | 200 | 150–300 | 2.00x | 175 | 43.75x | 0 | yes |
| derived-chain-100 | 3 | vide | 150 | 127–175 | 1.50x | 94 | 23.50x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 101 | 100–126 | 1.00x | 16 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 358 | 300–467 | 3.56x | 1513 | 94.56x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 331 | 250–392 | 3.29x | 688 | 43.00x | 10 | yes |
| derived-fan-in-1000 | 3 | fusion | 2100 | 1806–2287 | 20.84x | 889 | 55.56x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2401 | 2236–2606 | 23.83x | 2813 | 175.81x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2256 | 1808–2602 | 22.39x | 652 | 40.75x | 49 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 11277 | 10007–12030 | 111.93x | 5707 | 356.69x | 85 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2362 | 2056–2558 | 23.44x | 637 | 39.81x | 35 | yes |
| derived-fan-in-1000 | 3 | roact | 633 | 378–764 | 6.28x | 101 | 6.31x | 0 | yes |
| derived-fan-in-1000 | 3 | seam | 2720 | 2572–2806 | 27.00x | 2948 | 184.25x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 784 | 600–829 | 7.78x | 1205 | 75.31x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 600 | 529–728 | 5.96x | 528 | 33.00x | 0 | yes |
| filter-as-you-type | 1 | plain | 6806 | 6400–6915 | 1.00x | 41 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 17149 | 16315–18005 | 2.52x | 3000 | 73.17x | 0 | yes |
| filter-as-you-type | 1 | compose | 10808 | 10229–11753 | 1.59x | 810 | 19.76x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 29038 | 26133–29922 | 4.27x | 2449 | 59.73x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 25451 | 24889–30443 | 3.74x | 2459 | 59.98x | 1 | yes |
| filter-as-you-type | 1 | react | 30743 | 29261–30994 | 4.52x | 11 | 0.27x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 30453 | 29957–32912 | 4.47x | 1151 | 28.07x | 5 | yes |
| filter-as-you-type | 1 | react-upstream | 30549 | 29543–32532 | 4.49x | 19 | 0.46x | 9 | yes |
| filter-as-you-type | 1 | roact | 11500 | 10808–12045 | 1.69x | 492 | 12.00x | 1 | yes |
| filter-as-you-type | 1 | seam | 25128 | 21637–25724 | 3.69x | 3924 | 95.71x | 8 | yes |
| filter-as-you-type | 1 | signals | 7606 | 7106–8220 | 1.12x | 44 | 1.07x | 0 | yes |
| filter-as-you-type | 1 | vide | 10412 | 10212–10701 | 1.53x | 960 | 23.41x | 0 | yes |
| theme-propagation | 3 | plain | 47054 | 46188–51772 | 1.00x | 51 | 1.00x | 2 | yes |
| theme-propagation | 3 | blend | 48299 | 46866–49025 | 1.03x | 2078 | 40.75x | 0 | yes |
| theme-propagation | 3 | compose | 51159 | 50822–51859 | 1.09x | 542 | 10.63x | 10 | yes |
| theme-propagation | 3 | fusion | 53244 | 51846–60887 | 1.13x | 883 | 17.31x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 52491 | 51347–59943 | 1.12x | 877 | 17.20x | 1 | yes |
| theme-propagation | 3 | react | 54982 | 53148–56147 | 1.17x | 2028 | 39.76x | 0 | yes |
| theme-propagation | 3 | react-reflex | 49030 | 46213–50198 | 1.04x | 2021 | 39.63x | 0 | yes |
| theme-propagation | 3 | react-upstream | 54283 | 53311–55580 | 1.15x | 2020 | 39.61x | 9 | yes |
| theme-propagation | 3 | roact | 51969 | 50163–53290 | 1.10x | 3286 | 64.43x | 1 | yes |
| theme-propagation | 3 | seam | 46513 | 45142–48542 | 0.99x | 3485 | 68.33x | 0 | yes |
| theme-propagation | 3 | signals | 52450 | 50880–54091 | 1.11x | 906 | 17.76x | 8 | yes |
| theme-propagation | 3 | vide | 51138 | 50523–51853 | 1.09x | 605 | 11.86x | 0 | yes |
| hud-per-frame | 1 | plain | 2129 | 2123–2847 | 1.00x | 3 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 4323 | 3977–4746 | 2.03x | 72 | 23.83x | 0 | yes |
| hud-per-frame | 1 | compose | 3038 | 2533–4080 | 1.43x | 34 | 11.17x | 0 | yes |
| hud-per-frame | 1 | fusion | 10243 | 9830–11414 | 4.81x | 54 | 18.00x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 12367 | 11743–13410 | 5.81x | 95 | 31.67x | 4 | yes |
| hud-per-frame | 1 | react | 3512 | 3100–3607 | 1.65x | 34 | 11.33x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 6640 | 6253–6806 | 3.12x | 62 | 20.50x | 2 | yes |
| hud-per-frame | 1 | react-upstream | 3733 | 3691–3823 | 1.75x | 34 | 11.33x | 0 | yes |
| hud-per-frame | 1 | roact | 3115 | 2802–3996 | 1.46x | 74 | 24.50x | 0 | yes |
| hud-per-frame | 1 | seam | 7543 | 6831–8136 | 3.54x | 161 | 53.67x | 0 | yes |
| hud-per-frame | 1 | signals | 3934 | 3723–4119 | 1.85x | 70 | 23.33x | 4 | yes |
| hud-per-frame | 1 | vide | 4422 | 3736–4711 | 2.08x | 30 | 9.83x | 4 | yes |
| teardown-under-load | 1 | plain | 45363 | 44706–45546 | 1.00x | 12 | 1.00x | 9 | yes |
| teardown-under-load | 1 | blend | 70951 | 65214–74271 | 1.56x | 15 | 1.25x | 1 | yes |
| teardown-under-load | 1 | compose | 52488 | 51619–54606 | 1.16x | 6 | 0.50x | 1 | yes |
| teardown-under-load | 1 | fusion | 72907 | 68417–83818 | 1.61x | 5 | 0.42x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 73921 | 70366–82576 | 1.63x | 7 | 0.58x | 0 | yes |
| teardown-under-load | 1 | react | 71335 | 66517–82195 | 1.57x | 1078 | 89.83x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 78265 | 66326–82302 | 1.73x | 1079 | 89.92x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 73216 | 70854–76722 | 1.61x | 1078 | 89.83x | 0 | yes |
| teardown-under-load | 1 | roact | 63204 | 60605–65152 | 1.39x | 79 | 6.58x | 0 | yes |
| teardown-under-load | 1 | seam | 67692 | 63713–76724 | 1.49x | 16 | 1.33x | 7 | yes |
| teardown-under-load | 1 | signals | 53357 | 52024–54170 | 1.18x | 14 | 1.17x | 1 | yes |
| teardown-under-load | 1 | vide | 56677 | 54803–58143 | 1.25x | 13 | 1.08x | 9 | yes |
| open-close-retention | 1 | plain | 62689 | 62463–63771 | 1.00x | 4 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 122619 | 122283–124746 | 1.96x | 7 | 1.75x | 1 | yes |
| open-close-retention | 1 | compose | 81377 | 81228–82064 | 1.30x | 16 | 4.00x | 2 | yes |
| open-close-retention | 1 | fusion | 135397 | 133733–136238 | 2.16x | 5 | 1.25x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 135544 | 134131–135568 | 2.16x | 6 | 1.50x | 0 | yes |
| open-close-retention | 1 | react | 119458 | 114779–119733 | 1.91x | 264 | 66.00x | 0 | yes |
| open-close-retention | 1 | react-reflex | 121003 | 118661–123042 | 1.93x | 268 | 67.12x | 0 | yes |
| open-close-retention | 1 | react-upstream | 117285 | 115344–119006 | 1.87x | 268 | 67.00x | 0 | yes |
| open-close-retention | 1 | roact | 100103 | 99822–100754 | 1.60x | 23 | 5.75x | 0 | yes |
| open-close-retention | 1 | seam | 123875 | 117185–130069 | 1.98x | 10 | 2.50x | 1 | yes |
| open-close-retention | 1 | signals | 83409 | 83207–84593 | 1.33x | 6 | 1.50x | 1 | yes |
| open-close-retention | 1 | vide | 89821 | 88637–92119 | 1.43x | 5 | 1.25x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7718 | 7400–8114 | 1.00x | 44 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 20850 | 19758–21647 | 2.70x | 809 | 18.39x | 1 | yes |
| tree-expand-collapse | 1 | compose | 12002 | 11802–12613 | 1.56x | 79 | 1.80x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25839 | 22536–29320 | 3.35x | 173 | 3.93x | 9 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23600 | 21207–28073 | 3.06x | 168 | 3.82x | 1 | yes |
| tree-expand-collapse | 1 | react | 25900 | 24045–26053 | 3.36x | 4 | 0.09x | 3 | yes |
| tree-expand-collapse | 1 | react-reflex | 25926 | 24774–27234 | 3.36x | 628 | 14.27x | 5 | yes |
| tree-expand-collapse | 1 | react-upstream | 26139 | 25211–26834 | 3.39x | 4 | 0.09x | 2 | yes |
| tree-expand-collapse | 1 | roact | 11228 | 10608–11710 | 1.45x | 32 | 0.73x | 1 | yes |
| tree-expand-collapse | 1 | seam | 29138 | 23407–31721 | 3.78x | 149 | 3.39x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8413 | 7806–8507 | 1.09x | 38 | 0.86x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11914 | 11607–12104 | 1.54x | 71 | 1.61x | 0 | yes |
| form-validation | 1 | plain | 2925 | 2442–3647 | 1.00x | 6 | 1.00x | 1 | yes |
| form-validation | 1 | blend | 3712 | 2609–4339 | 1.27x | 202 | 33.67x | 0 | yes |
| form-validation | 1 | compose | 3518 | 3161–4150 | 1.20x | 90 | 15.00x | 2 | yes |
| form-validation | 1 | fusion | 4820 | 4466–5244 | 1.65x | 119 | 19.83x | 0 | yes |
| form-validation | 1 | fusion-charm | 5323 | 5158–5441 | 1.82x | 156 | 26.00x | 0 | yes |
| form-validation | 1 | react | 4087 | 3641–4560 | 1.40x | 61 | 10.17x | 0 | yes |
| form-validation | 1 | react-reflex | 4738 | 4353–5421 | 1.62x | 72 | 12.00x | 0 | yes |
| form-validation | 1 | react-upstream | 4227 | 3666–4329 | 1.45x | 62 | 10.33x | 0 | yes |
| form-validation | 1 | roact | 4054 | 3496–4626 | 1.39x | 157 | 26.17x | 0 | yes |
| form-validation | 1 | seam | 6331 | 5419–6760 | 2.16x | 350 | 58.33x | 1 | yes |
| form-validation | 1 | signals | 3715 | 3508–4166 | 1.27x | 155 | 25.83x | 0 | yes |
| form-validation | 1 | vide | 3807 | 3013–4345 | 1.30x | 59 | 9.83x | 0 | yes |
| table-sort-filter | 1 | plain | 15643 | 15224–16767 | 1.00x | 90 | 1.00x | 1 | yes |
| table-sort-filter | 1 | blend | 43108 | 36422–48208 | 2.76x | 6114 | 67.93x | 8 | yes |
| table-sort-filter | 1 | compose | 24723 | 23927–25182 | 1.58x | 1594 | 17.71x | 26 | yes |
| table-sort-filter | 1 | fusion (workaround) | 56473 | 55780–58422 | 3.61x | 4704 | 52.27x | 9 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 55138 | 52314–55932 | 3.52x | 4634 | 51.49x | 2 | yes |
| table-sort-filter | 1 | react | 140233 | 136212–142119 | 8.96x | 2984 | 33.16x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 140979 | 136169–143381 | 9.01x | 3004 | 33.38x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 137518 | 134362–146446 | 8.79x | 2993 | 33.26x | 3 | yes |
| table-sort-filter | 1 | roact | 23849 | 22650–24759 | 1.52x | 1012 | 11.24x | 1 | yes |
| table-sort-filter | 1 | seam | 59902 | 57397–66822 | 3.83x | 7768 | 86.31x | 0 | yes |
| table-sort-filter | 1 | signals | 16605 | 16436–17132 | 1.06x | 92 | 1.02x | 9 | yes |
| table-sort-filter | 1 | vide | 24553 | 23709–25352 | 1.57x | 1923 | 21.37x | 8 | yes |
| library-load | 1 | plain | 32 | 29–37 | 1.00x | 2 | 1.00x | 0 | yes |
| library-load | 1 | blend | 671 | 647–779 | 21.13x | 467 | 233.50x | 464 | yes |
| library-load | 1 | compose | 624 | 585–670 | 19.67x | 67 | 33.50x | 64 | yes |
| library-load | 1 | fusion | 1446 | 1243–12699 | 45.54x | 264 | 132.00x | 262 | yes |
| library-load | 1 | fusion-charm | 4566 | 1476–4849 | 143.82x | 311 | 155.50x | 316 | yes |
| library-load | 1 | react | 4838 | 4665–10348 | 152.37x | 1825 | 912.50x | 1823 | yes |
| library-load | 1 | react-reflex | 19847 | 18977–25931 | 625.09x | 1984 | 992.00x | 1980 | yes |
| library-load | 1 | react-upstream | 9898 | 4805–14520 | 311.75x | 1995 | 997.50x | 2001 | yes |
| library-load | 1 | roact | 390 | 335–433 | 12.29x | 160 | 80.00x | 150 | yes |
| library-load | 1 | seam | 1463 | 1221–10624 | 46.07x | 235 | 117.50x | 232 | yes |
| library-load | 1 | signals | 226 | 217–259 | 7.11x | 42 | 21.00x | 32 | yes |
| library-load | 1 | vide | 334 | 324–362 | 10.53x | 154 | 77.00x | 146 | yes |
| rows-append-1000 | 1 | plain | 91909 | 89760–109302 | 1.00x | 3664 | 1.00x | 9 | yes |
| rows-append-1000 | 1 | blend | 175029 | 159907–187812 | 1.90x | 38514 | 10.51x | 8 | yes |
| rows-append-1000 | 1 | compose | 122025 | 116611–151102 | 1.33x | 10742 | 2.93x | 11 | yes |
| rows-append-1000 | 1 | fusion | 360927 | 354322–391962 | 3.93x | 20682 | 5.64x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 346428 | 334019–352952 | 3.77x | 28585 | 7.80x | 8 | yes |
| rows-append-1000 | 1 | react | 206348 | 195851–229560 | 2.25x | 18476 | 5.04x | 7 | yes |
| rows-append-1000 | 1 | react-reflex | 219680 | 205409–242969 | 2.39x | 19972 | 5.45x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 202499 | 190977–227452 | 2.20x | 18027 | 4.92x | 0 | yes |
| rows-append-1000 | 1 | roact | 133024 | 120607–162848 | 1.45x | 26960 | 7.36x | 8359 | yes |
| rows-append-1000 | 1 | seam | 198158 | 169277–212290 | 2.16x | 46426 | 12.67x | 232 | yes |
| rows-append-1000 | 1 | signals | 111256 | 103358–147518 | 1.21x | 17253 | 4.71x | 2 | yes |
| rows-append-1000 | 1 | vide | 119401 | 111883–121991 | 1.30x | 10432 | 2.85x | 0 | yes |
| rows-clear | 1 | plain | 16191 | 15958–17427 | 1.00x | 1259 | 1.00x | 8 | yes |
| rows-clear | 1 | blend | 35191 | 33684–35636 | 2.17x | 4177 | 3.32x | 1 | yes |
| rows-clear | 1 | compose | 24822 | 23035–26985 | 1.53x | 1878 | 1.49x | 10 | yes |
| rows-clear | 1 | fusion | 76510 | 71979–76895 | 4.73x | 3433 | 2.73x | 1 | yes |
| rows-clear | 1 | fusion-charm | 70272 | 66033–71487 | 4.34x | 7329 | 5.82x | 0 | yes |
| rows-clear | 1 | react | 27479 | 25525–28568 | 1.70x | 4488 | 3.56x | 0 | yes |
| rows-clear | 1 | react-reflex | 31137 | 30743–33028 | 1.92x | 6673 | 5.30x | 64 | yes |
| rows-clear | 1 | react-upstream | 26011 | 25107–30130 | 1.61x | 4464 | 3.55x | 0 | yes |
| rows-clear | 1 | roact | 22914 | 22031–24227 | 1.42x | 4198 | 3.33x | 0 | yes |
| rows-clear | 1 | seam | 49699 | 39974–53592 | 3.07x | 9066 | 7.20x | 8 | yes |
| rows-clear | 1 | signals | 21449 | 20647–23210 | 1.32x | 4401 | 3.50x | 2 | yes |
| rows-clear | 1 | vide | 20526 | 19012–21931 | 1.27x | 1597 | 1.27x | 1 | yes |
| rows-create-1000 | 1 | plain | 89011 | 83743–91295 | 1.00x | 1846 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 151443 | 145611–160555 | 1.70x | 19505 | 10.57x | 1 | yes |
| rows-create-1000 | 1 | compose | 107049 | 104184–124114 | 1.20x | 5453 | 2.95x | 3 | yes |
| rows-create-1000 | 1 | fusion | 183335 | 171535–193813 | 2.06x | 10635 | 5.76x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 183312 | 172820–188425 | 2.06x | 14556 | 7.89x | 0 | yes |
| rows-create-1000 | 1 | react | 187772 | 176298–203235 | 2.11x | 8655 | 4.69x | 8 | yes |
| rows-create-1000 | 1 | react-reflex | 204392 | 184818–210307 | 2.30x | 9557 | 5.18x | 57 | yes |
| rows-create-1000 | 1 | react-upstream | 190743 | 189131–194129 | 2.14x | 8622 | 4.67x | 0 | yes |
| rows-create-1000 | 1 | roact | 119866 | 118939–123899 | 1.35x | 13587 | 7.36x | 4189 | yes |
| rows-create-1000 | 1 | seam | 153723 | 121267–157879 | 1.73x | 23546 | 12.76x | 0 | yes |
| rows-create-1000 | 1 | signals | 102774 | 96612–125684 | 1.15x | 9074 | 4.92x | 1 | yes |
| rows-create-1000 | 1 | vide | 116600 | 108775–134284 | 1.31x | 4956 | 2.68x | 0 | yes |
| rows-create-10000 | 1 | plain | 1045221 | 1040765–1133881 | 1.00x | 17006 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1777499 | 1654274–1913232 | 1.70x | 189256 | 11.13x | 0 | yes |
| rows-create-10000 | 1 | compose | 1365282 | 1363245–1370143 | 1.31x | 54177 | 3.19x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6430268 | 6394783–6456933 | 6.15x | 104473 | 6.14x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 6140449 | 6097460–6183558 | 5.87x | 145632 | 8.56x | 910 | yes |
| rows-create-10000 | 1 | react | 6971523 | 6892731–7021645 | 6.67x | 84260 | 4.95x | 376 | yes |
| rows-create-10000 | 1 | react-reflex | 6968843 | 6808046–7113334 | 6.67x | 93207 | 5.48x | 1260 | yes |
| rows-create-10000 | 1 | react-upstream | 7085146 | 6886824–7100963 | 6.78x | 83440 | 4.91x | 636 | yes |
| rows-create-10000 | 1 | roact | 1410822 | 1388783–1502096 | 1.35x | 133059 | 7.82x | 40360 | yes |
| rows-create-10000 | 1 | seam | 1756273 | 1601446–1783110 | 1.68x | 235710 | 13.86x | 4 | yes |
| rows-create-10000 | 1 | signals | 1276366 | 1233844–1329969 | 1.22x | 89466 | 5.26x | 4 | yes |
| rows-create-10000 | 1 | vide | 1354799 | 1316030–1509939 | 1.30x | 48526 | 2.85x | 0 | yes |
| rows-remove-one | 1 | plain | 352 | 350–400 | 1.00x | 1421 | 1.00x | 7 | yes |
| rows-remove-one | 1 | blend | 1200 | 1000–1300 | 3.41x | 18341 | 12.91x | 1 | yes |
| rows-remove-one | 1 | compose | 852 | 800–1000 | 2.43x | 4817 | 3.39x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 62444 | 59855–64001 | 177.65x | 10986 | 7.73x | 9 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 57661 | 55976–58375 | 164.04x | 14914 | 10.50x | 1 | yes |
| rows-remove-one | 1 | react | 17800 | 14915–18422 | 50.64x | 13192 | 9.28x | 24 | yes |
| rows-remove-one | 1 | react-reflex | 23710 | 20023–40343 | 67.45x | 14102 | 9.92x | 56 | yes |
| rows-remove-one | 1 | react-upstream | 18436 | 17123–28267 | 52.45x | 13176 | 9.27x | 0 | yes |
| rows-remove-one | 1 | roact | 6811 | 6221–7223 | 19.38x | 13808 | 9.72x | 4193 | yes |
| rows-remove-one | 1 | seam | 5712 | 5002–6708 | 16.25x | 23105 | 16.26x | 1 | yes |
| rows-remove-one | 1 | signals | 1354 | 1112–1551 | 3.85x | 8646 | 6.08x | 0 | yes |
| rows-remove-one | 1 | vide | 1050 | 950–1150 | 2.99x | 4561 | 3.21x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–102 | 1.00x | 1861 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 700 | 650–754 | 7.00x | 18810 | 10.11x | 0 | yes |
| rows-swap | 1 | compose | 300 | 200–352 | 3.00x | 5235 | 2.81x | 10 | yes |
| rows-swap | 1 | fusion | 60382 | 57142–62202 | 603.82x | 9999 | 5.37x | 0 | yes |
| rows-swap | 1 | fusion-charm | 56660 | 53833–57868 | 566.60x | 14250 | 7.66x | 0 | yes |
| rows-swap | 1 | react | 58406 | 57102–70755 | 584.06x | 9845 | 5.29x | 0 | yes |
| rows-swap | 1 | react-reflex | 61628 | 59193–63594 | 616.28x | 10843 | 5.83x | 73 | yes |
| rows-swap | 1 | react-upstream | 57824 | 55193–58593 | 578.24x | 9893 | 5.32x | 0 | yes |
| rows-swap | 1 | roact | 1954 | 1752–2050 | 19.54x | 13900 | 7.47x | 4198 | yes |
| rows-swap | 1 | seam | 5422 | 4700–5927 | 54.22x | 23559 | 12.66x | 1 | yes |
| rows-swap | 1 | signals | 450 | 356–600 | 4.50x | 9090 | 4.88x | 1 | yes |
| rows-swap | 1 | vide | 200 | 150–200 | 2.00x | 4972 | 2.67x | 0 | yes |
| rows-update-every-10th | 1 | plain | 1850 | 1700–1950 | 1.00x | 1396 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1800 | 1800–1900 | 0.97x | 18786 | 13.46x | 0 | yes |
| rows-update-every-10th | 1 | compose | 1950 | 1900–2109 | 1.05x | 4861 | 3.48x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 1900 | 1800–2000 | 1.03x | 10007 | 7.17x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2300 | 2100–2300 | 1.24x | 13920 | 9.97x | 1 | yes |
| rows-update-every-10th | 1 | react | 2150 | 2050–2400 | 1.16x | 8607 | 6.17x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 5810 | 4000–9616 | 3.14x | 9540 | 6.83x | 73 | yes |
| rows-update-every-10th | 1 | react-upstream | 2150 | 2050–2404 | 1.16x | 8174 | 5.86x | 23 | yes |
| rows-update-every-10th | 1 | roact | 2000 | 1800–2100 | 1.08x | 13398 | 9.60x | 9 | yes |
| rows-update-every-10th | 1 | seam | 3900 | 3500–4800 | 2.11x | 23584 | 16.89x | 1 | yes |
| rows-update-every-10th | 1 | signals | 2002 | 1908–2100 | 1.08x | 8810 | 6.31x | 0 | yes |
| rows-update-every-10th | 1 | vide | 1951 | 1904–2050 | 1.05x | 4660 | 3.34x | 0 | yes |

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
| blend | 30 | 2.29x | 16.17x | 2.22x | 15.93x |
| compose | 30 | 1.61x | 5.77x | 1.58x | 5.68x |
| fusion | 30 | 6.08x | 9.27x | 5.69x | 9.10x |
| fusion-charm | 30 | 5.90x | 11.69x | 5.51x | 11.57x |
| react | 29 | 4.79x | 7.80x | 4.79x | 7.80x |
| react-reflex | 29 | 5.58x | 14.47x | 5.58x | 14.47x |
| react-upstream | 29 | 4.94x | 8.23x | 4.94x | 8.23x |
| roact | 29 | 2.20x | 8.39x | 2.20x | 8.39x |
| seam | 30 | 3.81x | 18.91x | 3.68x | 18.43x |
| signals | 29 | 1.61x | 4.47x | 1.61x | 4.47x |
| vide | 30 | 1.76x | 4.45x | 1.72x | 4.42x |
