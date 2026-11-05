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
| Roblox Studio | 0.746.0.7461264 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `36cfbf9` |
| Date | 2026-11-05 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 200–400 | 1.00x | 57 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 1108 | 1003–1718 | 3.69x | 773 | 13.56x | 1 | yes |
| update-leaf | 20 | compose | 1141 | 833–1521 | 3.80x | 62 | 1.09x | 2 | yes |
| update-leaf | 20 | fusion | 1432 | 1172–1557 | 4.77x | 52 | 0.91x | 1 | yes |
| update-leaf | 20 | fusion-charm | 1736 | 1511–1928 | 5.79x | 53 | 0.93x | 1 | yes |
| update-leaf | 20 | react | 1246 | 1146–1427 | 4.15x | 347 | 6.09x | 0 | yes |
| update-leaf | 20 | react-reflex | 1424 | 1360–1876 | 4.75x | 301 | 5.28x | 9 | yes |
| update-leaf | 20 | react-upstream | 1304 | 1017–2270 | 4.35x | 291 | 5.11x | 0 | yes |
| update-leaf | 20 | roact | 1231 | 713–1444 | 4.10x | 960 | 16.84x | 1 | yes |
| update-leaf | 20 | seam | 1806 | 1600–2477 | 6.02x | 41 | 0.72x | 0 | yes |
| update-leaf | 20 | signals | 1323 | 1211–1507 | 4.41x | 50 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 1622 | 1205–1905 | 5.41x | 0 | 0.02x | 0 | yes |
| update-batched | 20 | plain | 3955 | 3950–4100 | 1.00x | 21 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 11962 | 11422–12194 | 3.02x | 925 | 44.05x | 0 | yes |
| update-batched | 20 | compose | 7942 | 7309–8022 | 2.01x | 377 | 17.95x | 10 | yes |
| update-batched | 20 | fusion | 21932 | 21513–22751 | 5.55x | 516 | 24.57x | 0 | yes |
| update-batched | 20 | fusion-charm | 39726 | 38341–41507 | 10.04x | 1093 | 52.05x | 0 | yes |
| update-batched | 20 | react | 9193 | 8507–9385 | 2.32x | 469 | 22.33x | 0 | yes |
| update-batched | 20 | react-reflex | 57481 | 54410–63516 | 14.53x | 775 | 36.90x | 16 | yes |
| update-batched | 20 | react-upstream | 8994 | 8740–9228 | 2.27x | 469 | 22.33x | 0 | yes |
| update-batched | 20 | roact | 9871 | 9618–10468 | 2.50x | 1162 | 55.33x | 0 | yes |
| update-batched | 20 | seam | 16866 | 14112–17516 | 4.26x | 1832 | 87.24x | 0 | yes |
| update-batched | 20 | signals | 10508 | 10138–10637 | 2.66x | 597 | 28.43x | 0 | yes |
| update-batched | 20 | vide | 9790 | 9142–10246 | 2.48x | 332 | 15.81x | 0 | yes |
| update-repeated | 10 | plain | 46 | 38–54 | 1.00x | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3415 | 3250–3771 | 74.22x | 8 | 4.00x | 1 | yes |
| update-repeated | 10 | compose | 608 | 358–704 | 13.20x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | fusion | 26371 | 25831–26976 | 573.17x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion-charm | 1480 | 1318–1660 | 32.17x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 7300 | 7016–7715 | 158.66x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 1040 | 855–1060 | 22.59x | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7286 | 7101–8142 | 158.36x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5534 | 5304–6146 | 120.28x | 0 | 0.50x | 1 | yes |
| update-repeated | 10 | seam | 2117 | 1729–2261 | 46.01x | 11 | 5.50x | 1 | yes |
| update-repeated | 10 | signals | 1176 | 825–1383 | 25.56x | 4 | 2.00x | 1 | yes |
| update-repeated | 10 | vide | 750 | 550–976 | 16.30x | 3 | 1.50x | 1 | yes |
| branch-swap | 20 | plain | 11219 | 11116–12601 | 1.00x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 17968 | 15069–18640 | 1.60x | 27 | 13.50x | 0 | yes |
| branch-swap | 20 | compose | 15425 | 13411–15751 | 1.37x | 0 | 0.50x | 2 | yes |
| branch-swap | 20 | fusion | 15210 | 14614–15620 | 1.36x | 5 | 2.50x | 1 | yes |
| branch-swap | 20 | fusion-charm | 14846 | 14509–15838 | 1.32x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 17025 | 16817–18390 | 1.52x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 17621 | 16562–17891 | 1.57x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 17819 | 15474–19566 | 1.59x | 19 | 9.50x | 9 | yes |
| branch-swap | 20 | roact | 15664 | 14753–17028 | 1.40x | 20 | 10.00x | 9 | yes |
| branch-swap | 20 | seam | 12977 | 11721–13636 | 1.16x | 11 | 5.50x | 8 | yes |
| branch-swap | 20 | signals | 14148 | 12619–15891 | 1.26x | 6 | 3.00x | 8 | yes |
| branch-swap | 20 | vide | 14604 | 14011–15638 | 1.30x | 6 | 3.00x | 1 | yes |
| keyed-prepend | 10 | plain | 2170 | 2070–2236 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 5625 | 5405–5798 | 2.59x | 1482 | 23.16x | 0 | yes |
| keyed-prepend | 10 | compose | 4801 | 3959–5441 | 2.21x | 539 | 8.42x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 24433 | 23776–25502 | 11.26x | 1512 | 23.62x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 21954 | 20571–23908 | 10.12x | 1504 | 23.50x | 0 | yes |
| keyed-prepend | 10 | react | 16294 | 15559–16548 | 7.51x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16095 | 12816–16907 | 7.42x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16833 | 16200–17639 | 7.76x | 784 | 12.25x | 1 | yes |
| keyed-prepend | 10 | roact | 6982 | 6834–7692 | 3.22x | 369 | 5.77x | 1 | yes |
| keyed-prepend | 10 | seam | 12293 | 11030–13570 | 5.66x | 2456 | 38.38x | 8 | yes |
| keyed-prepend | 10 | signals | 3066 | 2876–3268 | 1.41x | 61 | 0.95x | 1 | yes |
| keyed-prepend | 10 | vide | 6327 | 5606–6538 | 2.92x | 638 | 9.97x | 1 | yes |
| keyed-insert | 10 | plain | 1425 | 1326–1504 | 1.00x | 64 | 1.00x | 1 | yes |
| keyed-insert | 10 | blend | 4720 | 4659–4810 | 3.31x | 1498 | 23.41x | 0 | yes |
| keyed-insert | 10 | compose | 3760 | 3328–3905 | 2.64x | 523 | 8.17x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 21572 | 21218–22143 | 15.14x | 1535 | 23.98x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 19602 | 19030–20150 | 13.76x | 1537 | 24.02x | 1 | yes |
| keyed-insert | 10 | react | 13516 | 13242–14364 | 9.48x | 803 | 12.55x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13641 | 13441–13926 | 9.57x | 867 | 13.55x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13538 | 13507–14168 | 9.50x | 819 | 12.80x | 8 | yes |
| keyed-insert | 10 | roact | 6000 | 5626–6257 | 4.21x | 369 | 5.77x | 0 | yes |
| keyed-insert | 10 | seam | 11744 | 11028–12886 | 8.24x | 2455 | 38.36x | 0 | yes |
| keyed-insert | 10 | signals | 2263 | 2150–2374 | 1.59x | 62 | 0.97x | 1 | yes |
| keyed-insert | 10 | vide | 3750 | 3592–4155 | 2.63x | 646 | 10.09x | 1 | yes |
| keyed-shuffle | 10 | plain | 1471 | 1402–1535 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3515 | 3050–3708 | 2.39x | 1440 | 24.00x | 0 | yes |
| keyed-shuffle | 10 | compose | 3570 | 3412–3830 | 2.43x | 530 | 8.83x | 10 | yes |
| keyed-shuffle | 10 | fusion | 20001 | 19323–21901 | 13.60x | 1382 | 23.03x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 19011 | 16504–19311 | 12.93x | 1392 | 23.20x | 1 | yes |
| keyed-shuffle | 10 | react | 28043 | 27936–28331 | 19.07x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27929 | 27316–28311 | 18.99x | 780 | 13.00x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 28105 | 27747–28626 | 19.11x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | roact | 6317 | 5900–6719 | 4.30x | 361 | 6.02x | 0 | yes |
| keyed-shuffle | 10 | seam | 11100 | 10711–12506 | 7.55x | 2430 | 40.50x | 0 | yes |
| keyed-shuffle | 10 | signals | 2564 | 2460–2766 | 1.74x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | vide | 4215 | 4050–4338 | 2.87x | 622 | 10.37x | 1 | yes |
| events | 1 | plain | 1454 | 1000–1601 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 1800 | 1202–1918 | 1.24x | 1 | 0.50x | 1 | yes |
| events | 1 | compose | 1324 | 1100–2127 | 0.91x | 2 | 1.00x | 2 | yes |
| events | 1 | fusion | 1700 | 1407–2248 | 1.17x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion-charm | 1802 | 1506–2376 | 1.24x | 1 | 0.50x | 1 | yes |
| events | 1 | react | 2222 | 1971–2918 | 1.53x | 0 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 2108 | 1505–2320 | 1.45x | 1 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 1500 | 1100–2015 | 1.03x | 8 | 4.00x | 0 | yes |
| events | 1 | roact | 1421 | 1321–1818 | 0.98x | 2 | 1.00x | 1 | yes |
| events | 1 | seam | 1207 | 900–1300 | 0.83x | 2 | 1.00x | 1 | yes |
| events | 1 | signals | 1103 | 911–1420 | 0.76x | 2 | 1.00x | 1 | yes |
| events | 1 | vide | 1227 | 1028–1409 | 0.84x | 0 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 3718 | 3675–3957 | 1.00x | 73 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 12609 | 11625–13205 | 3.39x | 1770 | 24.25x | 0 | yes |
| animate-many | 1 | compose | 5966 | 5219–7116 | 1.60x | 729 | 9.99x | 12 | yes |
| animate-many | 1 | fusion | 119337 | 110517–119528 | 32.10x | 1136 | 15.56x | 0 | yes |
| animate-many | 1 | fusion-charm | 115727 | 115423–117101 | 31.13x | 1138 | 15.59x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 24416 | 22397–26009 | 6.57x | 2898 | 39.70x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 7572 | 7154–8267 | 2.04x | 384 | 5.26x | 0 | yes |
| status-panel | 10 | plain | 456 | 389–478 | 1.00x | 0 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1700 | 1402–1879 | 3.73x | 70 | 70.00x | 0 | yes |
| status-panel | 10 | compose | 1558 | 1456–1604 | 3.42x | 32 | 32.00x | 1 | yes |
| status-panel | 10 | fusion | 2005 | 1820–2269 | 4.40x | 64 | 64.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 2276 | 2205–2469 | 5.00x | 70 | 70.00x | 0 | yes |
| status-panel | 10 | react | 3103 | 2798–3237 | 6.81x | 35 | 35.00x | 0 | yes |
| status-panel | 10 | react-reflex | 2752 | 2720–3271 | 6.04x | 37 | 37.00x | 0 | yes |
| status-panel | 10 | react-upstream | 3000 | 2509–3422 | 6.59x | 43 | 43.00x | 0 | yes |
| status-panel | 10 | roact | 1404 | 1158–1469 | 3.08x | 33 | 33.00x | 8 | yes |
| status-panel | 10 | seam | 2805 | 2542–3110 | 6.16x | 141 | 141.00x | 1 | yes |
| status-panel | 10 | signals | 1406 | 1368–1613 | 3.09x | 15 | 15.00x | 0 | yes |
| status-panel | 10 | vide | 1394 | 1338–1714 | 3.06x | 32 | 32.00x | 1 | yes |
| scene-3d | 10 | plain | 2000 | 1946–2067 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4614 | 4341–4736 | 2.31x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 3320 | 3280–3412 | 1.66x | 171 | 15.55x | 2 | yes |
| scene-3d | 10 | fusion | 36433 | 35168–37196 | 18.22x | 512 | 46.55x | 0 | yes |
| scene-3d | 10 | fusion-charm | 33483 | 32543–34219 | 16.74x | 515 | 46.82x | 0 | yes |
| scene-3d | 10 | react | 3718 | 3588–3801 | 1.86x | 214 | 19.45x | 0 | yes |
| scene-3d | 10 | react-reflex | 3658 | 3287–4137 | 1.83x | 225 | 20.45x | 1 | yes |
| scene-3d | 10 | react-upstream | 3776 | 3508–4188 | 1.89x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 4068 | 3980–4550 | 2.03x | 574 | 52.18x | 0 | yes |
| scene-3d | 10 | seam | 10352 | 9586–11342 | 5.18x | 1755 | 159.55x | 0 | yes |
| scene-3d | 10 | signals | 6106 | 6103–6865 | 3.05x | 674 | 61.27x | 0 | yes |
| scene-3d | 10 | vide | 3964 | 3914–4368 | 1.98x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 32 | 22–35 | 1.00x | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 150 | 125–284 | 4.62x | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 150 | 105–200 | 4.62x | 10 | 2.00x | 10 | yes |
| derived-diamond | 3 | fusion | 125 | 125–228 | 3.86x | 8 | 1.60x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 202 | 125–250 | 6.22x | 10 | 2.00x | 0 | yes |
| derived-diamond | 3 | react | 370 | 334–468 | 11.38x | 6 | 1.20x | 4 | yes |
| derived-diamond | 3 | react-reflex | 467 | 405–597 | 14.37x | 18 | 3.60x | 0 | yes |
| derived-diamond | 3 | react-upstream | 398 | 267–444 | 12.24x | 7 | 1.40x | 4 | yes |
| derived-diamond | 3 | roact | 175 | 150–225 | 5.39x | 11 | 2.20x | 3 | yes |
| derived-diamond | 3 | seam | 300 | 200–302 | 9.24x | 21 | 4.20x | 1 | yes |
| derived-diamond | 3 | signals | 150 | 127–175 | 4.62x | 10 | 2.00x | 8 | yes |
| derived-diamond | 3 | vide | 150 | 150–202 | 4.62x | 6 | 1.20x | 0 | yes |
| derived-chain-100 | 3 | plain | 50 | 50–58 | 1.00x | 58 | 1.00x | 1 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 302 | 280–325 | 6.01x | 127 | 2.19x | 1 | yes |
| derived-chain-100 | 3 | fusion | 875 | 826–940 | 17.44x | 127 | 2.19x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 827 | 777–986 | 16.49x | 129 | 2.22x | 1 | yes |
| derived-chain-100 | 3 | react | 536 | 502–680 | 10.69x | 77 | 1.33x | 12 | yes |
| derived-chain-100 | 3 | react-reflex | 674 | 536–703 | 13.43x | 80 | 1.38x | 15 | yes |
| derived-chain-100 | 3 | react-upstream | 540 | 503–670 | 10.77x | 61 | 1.05x | 11 | yes |
| derived-chain-100 | 3 | roact | 225 | 125–252 | 4.49x | 11 | 0.19x | 3 | yes |
| derived-chain-100 | 3 | seam | 950 | 856–992 | 18.94x | 272 | 4.69x | 1 | yes |
| derived-chain-100 | 3 | signals | 432 | 232–475 | 8.62x | 173 | 2.98x | 0 | yes |
| derived-chain-100 | 3 | vide | 207 | 178–230 | 4.12x | 93 | 1.60x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 99–100 | 1.00x | 497 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 300 | 279–475 | 3.00x | 1527 | 3.07x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 432 | 400–450 | 4.33x | 688 | 1.38x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1973 | 1833–2035 | 19.73x | 890 | 1.79x | 8 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2106 | 1938–2370 | 21.06x | 2805 | 5.64x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2301 | 2100–2712 | 23.01x | 671 | 1.35x | 52 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8110 | 7401–9030 | 81.10x | 5638 | 11.34x | 87 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2218 | 2100–2368 | 22.18x | 663 | 1.33x | 44 | yes |
| derived-fan-in-1000 | 3 | roact | 525 | 500–607 | 5.25x | 112 | 0.23x | 10 | yes |
| derived-fan-in-1000 | 3 | seam | 2757 | 2650–3088 | 27.57x | 2956 | 5.95x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 850 | 725–910 | 8.50x | 1205 | 2.42x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 625 | 530–704 | 6.25x | 520 | 1.05x | 0 | yes |
| filter-as-you-type | 1 | plain | 7506 | 7329–7523 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 18499 | 16627–19182 | 2.46x | 2654 | 75.83x | 1 | yes |
| filter-as-you-type | 1 | compose | 11792 | 10908–12324 | 1.57x | 801 | 22.89x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28330 | 27446–30398 | 3.77x | 2465 | 70.43x | 8 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 28537 | 27662–29786 | 3.80x | 2451 | 70.03x | 1 | yes |
| filter-as-you-type | 1 | react | 21013 | 19777–21042 | 2.80x | 76 | 2.17x | 12 | yes |
| filter-as-you-type | 1 | react-reflex | 21498 | 13980–22643 | 2.86x | 830 | 23.71x | 14 | yes |
| filter-as-you-type | 1 | react-upstream | 21742 | 21124–22145 | 2.90x | 75 | 2.14x | 11 | yes |
| filter-as-you-type | 1 | roact | 12616 | 12101–13656 | 1.68x | 503 | 14.37x | 4 | yes |
| filter-as-you-type | 1 | seam | 26255 | 21512–28367 | 3.50x | 4005 | 114.43x | 1 | yes |
| filter-as-you-type | 1 | signals | 8524 | 8169–8645 | 1.14x | 28 | 0.80x | 0 | yes |
| filter-as-you-type | 1 | vide | 11478 | 11205–12029 | 1.53x | 959 | 27.40x | 1 | yes |
| theme-propagation | 3 | plain | 48635 | 48430–49200 | 1.00x | 199 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 47350 | 47266–47832 | 0.97x | 2070 | 10.40x | 0 | yes |
| theme-propagation | 3 | compose | 51247 | 50658–51993 | 1.05x | 516 | 2.59x | 0 | yes |
| theme-propagation | 3 | fusion | 52846 | 52787–54198 | 1.09x | 867 | 4.36x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 54334 | 53329–54841 | 1.12x | 868 | 4.36x | 0 | yes |
| theme-propagation | 3 | react | 54045 | 53189–55816 | 1.11x | 2027 | 10.19x | 8 | yes |
| theme-propagation | 3 | react-reflex | 47061 | 46356–47471 | 0.97x | 2021 | 10.16x | 0 | yes |
| theme-propagation | 3 | react-upstream | 53517 | 53385–58839 | 1.10x | 2019 | 10.15x | 0 | yes |
| theme-propagation | 3 | roact | 51451 | 50247–51786 | 1.06x | 3279 | 16.48x | 1 | yes |
| theme-propagation | 3 | seam | 47688 | 47346–48292 | 0.98x | 3469 | 17.43x | 0 | yes |
| theme-propagation | 3 | signals | 54152 | 51483–54698 | 1.11x | 903 | 4.54x | 0 | yes |
| theme-propagation | 3 | vide | 51287 | 50458–51631 | 1.05x | 606 | 3.05x | 8 | yes |
| hud-per-frame | 1 | plain | 4803 | 4471–5278 | 1.00x | 23 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 10842 | 10677–12076 | 2.26x | 66 | 2.89x | 4 | yes |
| hud-per-frame | 1 | compose | 8312 | 8100–9264 | 1.73x | 22 | 0.96x | 1 | yes |
| hud-per-frame | 1 | fusion | 16384 | 16241–18195 | 3.41x | 50 | 2.15x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 20049 | 18563–20071 | 4.17x | 94 | 4.11x | 8 | yes |
| hud-per-frame | 1 | react | 9231 | 8584–9403 | 1.92x | 39 | 1.70x | 1 | yes |
| hud-per-frame | 1 | react-reflex | 12369 | 12254–12706 | 2.58x | 50 | 2.15x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 9761 | 8040–10314 | 2.03x | 38 | 1.65x | 0 | yes |
| hud-per-frame | 1 | roact | 8496 | 8284–8821 | 1.77x | 76 | 3.30x | 0 | yes |
| hud-per-frame | 1 | seam | 17465 | 16791–18363 | 3.64x | 164 | 7.15x | 0 | yes |
| hud-per-frame | 1 | signals | 10584 | 10076–10613 | 2.20x | 64 | 2.80x | 4 | yes |
| hud-per-frame | 1 | vide | 9685 | 9136–10203 | 2.02x | 18 | 0.80x | 0 | yes |
| teardown-under-load | 1 | plain | 44052 | 42986–48119 | 1.00x | 4 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 65781 | 63609–73857 | 1.49x | 6 | 1.50x | 1 | yes |
| teardown-under-load | 1 | compose | 49668 | 49030–51661 | 1.13x | 7 | 1.75x | 9 | yes |
| teardown-under-load | 1 | fusion | 72329 | 64036–77269 | 1.64x | 4 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 72632 | 64041–78024 | 1.65x | 14 | 3.50x | 0 | yes |
| teardown-under-load | 1 | react | 65997 | 63333–67643 | 1.50x | 1077 | 269.25x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 65810 | 64660–68510 | 1.49x | 1070 | 267.50x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 66985 | 66347–72016 | 1.52x | 1086 | 271.50x | 0 | yes |
| teardown-under-load | 1 | roact | 63549 | 61383–67007 | 1.44x | 79 | 19.75x | 0 | yes |
| teardown-under-load | 1 | seam | 61397 | 59143–62557 | 1.39x | 8 | 2.00x | 7 | yes |
| teardown-under-load | 1 | signals | 52568 | 51460–53825 | 1.19x | 5 | 1.25x | 0 | yes |
| teardown-under-load | 1 | vide | 55401 | 53858–56125 | 1.26x | 5 | 1.25x | 1 | yes |
| open-close-retention | 1 | plain | 70226 | 69440–70544 | 1.00x | 31 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 122851 | 121754–124918 | 1.75x | 14 | 0.45x | 0 | yes |
| open-close-retention | 1 | compose | 86680 | 85779–87173 | 1.23x | 7 | 0.23x | 10 | yes |
| open-close-retention | 1 | fusion | 138506 | 137690–140051 | 1.97x | 5 | 0.16x | 9 | yes |
| open-close-retention | 1 | fusion-charm | 139839 | 135573–147754 | 1.99x | 6 | 0.19x | 0 | yes |
| open-close-retention | 1 | react | 119426 | 118087–120672 | 1.70x | 288 | 9.27x | 0 | yes |
| open-close-retention | 1 | react-reflex | 117783 | 116089–118306 | 1.68x | 289 | 9.32x | 0 | yes |
| open-close-retention | 1 | react-upstream | 120735 | 119574–121633 | 1.72x | 285 | 9.19x | 0 | yes |
| open-close-retention | 1 | roact | 113807 | 111890–116444 | 1.62x | 22 | 0.71x | 0 | yes |
| open-close-retention | 1 | seam | 118713 | 115862–119823 | 1.69x | 9 | 0.29x | 0 | yes |
| open-close-retention | 1 | signals | 88393 | 87312–88917 | 1.26x | 13 | 0.42x | 1 | yes |
| open-close-retention | 1 | vide | 91572 | 91176–92445 | 1.30x | 4 | 0.13x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7513 | 7251–8103 | 1.00x | 20 | 1.00x | 1 | yes |
| tree-expand-collapse | 1 | blend | 21540 | 20425–22542 | 2.87x | 811 | 40.55x | 8 | yes |
| tree-expand-collapse | 1 | compose | 12947 | 12530–13953 | 1.72x | 72 | 3.60x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 26619 | 25315–29776 | 3.54x | 173 | 8.65x | 9 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 24641 | 24168–27434 | 3.28x | 287 | 14.35x | 1 | yes |
| tree-expand-collapse | 1 | react | 20222 | 19239–20300 | 2.69x | 85 | 4.25x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 20350 | 19818–20807 | 2.71x | 673 | 33.65x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 19576 | 19105–19691 | 2.61x | 69 | 3.45x | 19 | yes |
| tree-expand-collapse | 1 | roact | 11766 | 11452–12680 | 1.57x | 43 | 2.15x | 11 | yes |
| tree-expand-collapse | 1 | seam | 27562 | 24722–30625 | 3.67x | 148 | 7.40x | 8 | yes |
| tree-expand-collapse | 1 | signals | 8716 | 8406–9005 | 1.16x | 21 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 13123 | 12327–13616 | 1.75x | 79 | 3.95x | 9 | yes |
| form-validation | 1 | plain | 1651 | 1571–1812 | 1.00x | 45 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 4959 | 4640–5353 | 3.00x | 328 | 7.29x | 0 | yes |
| form-validation | 1 | compose | 5419 | 5237–6309 | 3.28x | 94 | 2.09x | 2 | yes |
| form-validation | 1 | fusion | 6361 | 5834–7341 | 3.85x | 118 | 2.62x | 1 | yes |
| form-validation | 1 | fusion-charm | 6412 | 5911–6991 | 3.88x | 162 | 3.60x | 1 | yes |
| form-validation | 1 | react | 6658 | 6041–7249 | 4.03x | 73 | 1.62x | 1 | yes |
| form-validation | 1 | react-reflex | 6695 | 6463–7413 | 4.05x | 67 | 1.49x | 0 | yes |
| form-validation | 1 | react-upstream | 6617 | 5825–6780 | 4.01x | 65 | 1.44x | 1 | yes |
| form-validation | 1 | roact | 6464 | 5757–7006 | 3.91x | 215 | 4.78x | 8 | yes |
| form-validation | 1 | seam | 11772 | 10760–12043 | 7.13x | 356 | 7.91x | 1 | yes |
| form-validation | 1 | signals | 5877 | 5002–6757 | 3.56x | 155 | 3.44x | 0 | yes |
| form-validation | 1 | vide | 5118 | 4727–6383 | 3.10x | 78 | 1.73x | 0 | yes |
| table-sort-filter | 1 | plain | 17646 | 17423–17718 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 39549 | 36119–47358 | 2.24x | 5380 | 80.30x | 0 | yes |
| table-sort-filter | 1 | compose | 26714 | 26564–27272 | 1.51x | 1552 | 23.16x | 18 | yes |
| table-sort-filter | 1 | fusion (workaround) | 59682 | 53146–64207 | 3.38x | 4711 | 70.31x | 2 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 55256 | 50079–58381 | 3.13x | 4713 | 70.34x | 1 | yes |
| table-sort-filter | 1 | react | 96427 | 94532–100748 | 5.46x | 2108 | 31.46x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 97165 | 96858–100379 | 5.51x | 2123 | 31.69x | 15 | yes |
| table-sort-filter | 1 | react-upstream | 99262 | 96425–99658 | 5.63x | 2108 | 31.46x | 12 | yes |
| table-sort-filter | 1 | roact | 26463 | 25715–26729 | 1.50x | 1007 | 15.03x | 3 | yes |
| table-sort-filter | 1 | seam | 60530 | 55302–65598 | 3.43x | 7767 | 115.93x | 0 | yes |
| table-sort-filter | 1 | signals | 18833 | 17614–18975 | 1.07x | 68 | 1.01x | 7 | yes |
| table-sort-filter | 1 | vide | 26829 | 25935–27247 | 1.52x | 1913 | 28.55x | 0 | yes |
| library-load | 1 | plain | 38 | 32–41 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 759 | 745–778 | 20.11x | 467 | 467.00x | 456 | yes |
| library-load | 1 | compose | 625 | 593–681 | 16.56x | 66 | 66.00x | 62 | yes |
| library-load | 1 | fusion | 1366 | 1197–1505 | 36.19x | 262 | 262.00x | 261 | yes |
| library-load | 1 | fusion-charm | 1570 | 1299–1728 | 41.58x | 318 | 318.00x | 317 | yes |
| library-load | 1 | react | 4832 | 4707–4888 | 128.01x | 1825 | 1825.00x | 1824 | yes |
| library-load | 1 | react-reflex | 5236 | 5094–5357 | 138.70x | 1980 | 1980.00x | 1979 | yes |
| library-load | 1 | react-upstream | 4996 | 4781–5215 | 132.33x | 1995 | 1995.00x | 2002 | yes |
| library-load | 1 | roact | 430 | 408–446 | 11.40x | 146 | 146.00x | 143 | yes |
| library-load | 1 | seam | 1303 | 1220–1403 | 34.50x | 243 | 243.00x | 240 | yes |
| library-load | 1 | signals | 246 | 228–262 | 6.51x | 50 | 50.00x | 49 | yes |
| library-load | 1 | vide | 365 | 329–417 | 9.67x | 146 | 146.00x | 145 | yes |
| rows-append-1000 | 1 | plain | 96454 | 95239–97864 | 1.00x | 6532 | 1.00x | 1 | yes |
| rows-append-1000 | 1 | blend | 143383 | 137847–162526 | 1.49x | 38442 | 5.89x | 1 | yes |
| rows-append-1000 | 1 | compose | 116640 | 112196–152760 | 1.21x | 9775 | 1.50x | 2 | yes |
| rows-append-1000 | 1 | fusion | 371940 | 367001–400047 | 3.86x | 21386 | 3.27x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 374826 | 370873–385643 | 3.89x | 28810 | 4.41x | 1 | yes |
| rows-append-1000 | 1 | react | 195690 | 189601–220598 | 2.03x | 23409 | 3.58x | 208 | yes |
| rows-append-1000 | 1 | react-reflex | 212268 | 200534–237777 | 2.20x | 24926 | 3.82x | 44 | yes |
| rows-append-1000 | 1 | react-upstream | 191998 | 190682–234575 | 1.99x | 22889 | 3.50x | 0 | yes |
| rows-append-1000 | 1 | roact | 148977 | 145108–158303 | 1.54x | 33250 | 5.09x | 8 | yes |
| rows-append-1000 | 1 | seam | 146338 | 142609–152211 | 1.52x | 46783 | 7.16x | 9 | yes |
| rows-append-1000 | 1 | signals | 114641 | 104590–134084 | 1.19x | 17326 | 2.65x | 0 | yes |
| rows-append-1000 | 1 | vide | 116982 | 113269–147405 | 1.21x | 10431 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 18711 | 18631–19011 | 1.00x | 1229 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 35553 | 34871–36567 | 1.90x | 4185 | 3.41x | 0 | yes |
| rows-clear | 1 | compose | 25146 | 24657–26327 | 1.34x | 1821 | 1.48x | 10 | yes |
| rows-clear | 1 | fusion | 80519 | 80139–82934 | 4.30x | 3473 | 2.83x | 1 | yes |
| rows-clear | 1 | fusion-charm | 77397 | 76887–77657 | 4.14x | 7401 | 6.02x | 0 | yes |
| rows-clear | 1 | react | 25621 | 25409–26651 | 1.37x | 4491 | 3.65x | 0 | yes |
| rows-clear | 1 | react-reflex | 28360 | 26827–29642 | 1.52x | 6498 | 5.29x | 29 | yes |
| rows-clear | 1 | react-upstream | 26246 | 25741–26870 | 1.40x | 4479 | 3.64x | 0 | yes |
| rows-clear | 1 | roact | 25338 | 23748–26727 | 1.35x | 4206 | 3.42x | 1 | yes |
| rows-clear | 1 | seam | 33064 | 25067–39664 | 1.77x | 9183 | 7.47x | 0 | yes |
| rows-clear | 1 | signals | 22925 | 22807–23550 | 1.23x | 4458 | 3.63x | 1 | yes |
| rows-clear | 1 | vide | 21618 | 20623–22388 | 1.16x | 1605 | 1.31x | 1 | yes |
| rows-create-1000 | 1 | plain | 94831 | 93034–95117 | 1.00x | 3127 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 155367 | 144188–156668 | 1.64x | 19577 | 6.26x | 1 | yes |
| rows-create-1000 | 1 | compose | 110561 | 108614–134876 | 1.17x | 5196 | 1.66x | 3 | yes |
| rows-create-1000 | 1 | fusion | 197285 | 184101–206603 | 2.08x | 10923 | 3.49x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 197034 | 182775–200580 | 2.08x | 14764 | 4.72x | 1 | yes |
| rows-create-1000 | 1 | react | 166007 | 160974–176531 | 1.75x | 8152 | 2.61x | 1 | yes |
| rows-create-1000 | 1 | react-reflex | 178987 | 171642–198522 | 1.89x | 9090 | 2.91x | 37 | yes |
| rows-create-1000 | 1 | react-upstream | 164750 | 152962–186065 | 1.74x | 8144 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 130087 | 123781–143188 | 1.37x | 16906 | 5.41x | 0 | yes |
| rows-create-1000 | 1 | seam | 158970 | 137519–164767 | 1.68x | 23854 | 7.63x | 0 | yes |
| rows-create-1000 | 1 | signals | 109666 | 97852–110768 | 1.16x | 9114 | 2.91x | 0 | yes |
| rows-create-1000 | 1 | vide | 113860 | 109936–116226 | 1.20x | 4964 | 1.59x | 0 | yes |
| rows-create-10000 | 1 | plain | 1176248 | 1159785–1387647 | 1.00x | 29804 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1791905 | 1735501–1833253 | 1.52x | 188078 | 6.31x | 4 | yes |
| rows-create-10000 | 1 | compose | 1455858 | 1451355–1468420 | 1.24x | 49830 | 1.67x | 10 | yes |
| rows-create-10000 | 1 | fusion | 7153626 | 7089679–7384494 | 6.08x | 101860 | 3.42x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 7357354 | 7329536–7366434 | 6.25x | 141350 | 4.74x | 0 | yes |
| rows-create-10000 | 1 | react | 5544455 | 5373042–5566701 | 4.71x | 76618 | 2.57x | 208 | yes |
| rows-create-10000 | 1 | react-reflex | 5703693 | 5358098–5908192 | 4.85x | 86160 | 2.89x | 808 | yes |
| rows-create-10000 | 1 | react-upstream | 5674994 | 5491082–6030301 | 4.82x | 78302 | 2.63x | 636 | yes |
| rows-create-10000 | 1 | roact | 1612763 | 1589314–1664392 | 1.37x | 166190 | 5.58x | 0 | yes |
| rows-create-10000 | 1 | seam | 1813076 | 1723404–1823793 | 1.54x | 236652 | 7.94x | 4 | yes |
| rows-create-10000 | 1 | signals | 1340254 | 1316089–1421195 | 1.14x | 89578 | 3.01x | 0 | yes |
| rows-create-10000 | 1 | vide | 1365158 | 1299330–1481080 | 1.16x | 48472 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 867 | 703–936 | 1.00x | 2741 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1352 | 1300–1352 | 1.56x | 18284 | 6.67x | 0 | yes |
| rows-remove-one | 1 | compose | 1005 | 800–1055 | 1.16x | 4319 | 1.58x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 67822 | 64183–77704 | 78.26x | 11121 | 4.06x | 9 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 64547 | 64077–64764 | 74.48x | 15026 | 5.48x | 1 | yes |
| rows-remove-one | 1 | react | 26413 | 20628–41295 | 30.48x | 15508 | 5.66x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 31324 | 23757–33549 | 36.14x | 16406 | 5.99x | 28 | yes |
| rows-remove-one | 1 | react-upstream | 25748 | 19813–48463 | 29.71x | 15484 | 5.65x | 8 | yes |
| rows-remove-one | 1 | roact | 17230 | 14711–18415 | 19.88x | 16773 | 6.12x | 1 | yes |
| rows-remove-one | 1 | seam | 6506 | 5845–6808 | 7.51x | 23205 | 8.47x | 0 | yes |
| rows-remove-one | 1 | signals | 1735 | 1606–1870 | 2.00x | 8614 | 3.14x | 1 | yes |
| rows-remove-one | 1 | vide | 1300 | 1101–1336 | 1.50x | 4561 | 1.66x | 8 | yes |
| rows-swap | 1 | plain | 101 | 100–133 | 1.00x | 2679 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 868 | 719–1005 | 8.62x | 18278 | 6.82x | 1 | yes |
| rows-swap | 1 | compose | 300 | 250–400 | 2.98x | 4281 | 1.60x | 0 | yes |
| rows-swap | 1 | fusion | 60961 | 60630–62625 | 605.57x | 9559 | 3.57x | 8 | yes |
| rows-swap | 1 | fusion-charm | 60148 | 59035–64864 | 597.50x | 14546 | 5.43x | 8 | yes |
| rows-swap | 1 | react | 56887 | 56065–63048 | 565.10x | 15434 | 5.76x | 0 | yes |
| rows-swap | 1 | react-reflex | 69920 | 59452–82736 | 694.57x | 16395 | 6.12x | 37 | yes |
| rows-swap | 1 | react-upstream | 63296 | 59979–90118 | 628.77x | 15025 | 5.61x | 25 | yes |
| rows-swap | 1 | roact | 16675 | 15073–18131 | 165.65x | 16309 | 6.09x | 1 | yes |
| rows-swap | 1 | seam | 6428 | 5400–7450 | 63.85x | 23211 | 8.66x | 0 | yes |
| rows-swap | 1 | signals | 678 | 668–705 | 6.74x | 8617 | 3.22x | 0 | yes |
| rows-swap | 1 | vide | 202 | 200–352 | 2.01x | 4516 | 1.69x | 0 | yes |
| rows-update-every-10th | 1 | plain | 1971 | 1867–2033 | 1.00x | 3183 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1966 | 1907–2003 | 1.00x | 19272 | 6.05x | 9 | yes |
| rows-update-every-10th | 1 | compose | 1962 | 1950–2250 | 1.00x | 4827 | 1.52x | 0 | yes |
| rows-update-every-10th | 1 | fusion | 2203 | 2000–2512 | 1.12x | 10568 | 3.32x | 9 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2303 | 2300–2502 | 1.17x | 14472 | 4.55x | 1 | yes |
| rows-update-every-10th | 1 | react | 2101 | 2001–2250 | 1.07x | 7885 | 2.48x | 16 | yes |
| rows-update-every-10th | 1 | react-reflex | 3809 | 3001–5604 | 1.93x | 8806 | 2.77x | 0 | yes |
| rows-update-every-10th | 1 | react-upstream | 2103 | 2050–2300 | 1.07x | 7902 | 2.48x | 0 | yes |
| rows-update-every-10th | 1 | roact | 2000 | 1950–2151 | 1.01x | 16689 | 5.24x | 0 | yes |
| rows-update-every-10th | 1 | seam | 4501 | 4001–4600 | 2.28x | 24180 | 7.60x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2139 | 2043–2200 | 1.09x | 9306 | 2.92x | 0 | yes |
| rows-update-every-10th | 1 | vide | 2069 | 1967–2200 | 1.05x | 5124 | 1.61x | 0 | yes |

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
| blend | 29 | 2.77x | 10.87x | 2.75x | 10.56x |
| compose | 30 | 2.15x | 3.10x | 2.09x | 3.01x |
| fusion | 30 | 7.47x | 5.97x | 6.88x | 5.98x |
| fusion-charm | 30 | 7.09x | 7.66x | 6.52x | 7.81x |
| react | 29 | 5.70x | 6.27x | 5.57x | 6.63x |
| react-reflex | 29 | 6.34x | 9.34x | 6.17x | 10.00x |
| react-upstream | 29 | 5.69x | 6.81x | 5.57x | 7.28x |
| roact | 29 | 3.26x | 5.55x | 3.23x | 6.26x |
| seam | 30 | 4.80x | 12.08x | 4.52x | 11.98x |
| signals | 29 | 2.23x | 2.73x | 2.12x | 2.72x |
| vide | 30 | 2.21x | 2.82x | 2.16x | 2.81x |
