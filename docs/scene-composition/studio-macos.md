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
| Harness revision | `28ac21c` |
| Date | 2026-11-03 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 200–400 | 1.00x | 41 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 900 | 700–1000 | 3.00x | 772 | 18.83x | 1 | yes |
| update-leaf | 20 | compose | 811 | 610–1000 | 2.70x | 67 | 1.63x | 2 | yes |
| update-leaf | 20 | fusion | 1204 | 618–1325 | 4.01x | 51 | 1.24x | 0 | yes |
| update-leaf | 20 | fusion-charm | 404 | 100–702 | 1.35x | 61 | 1.49x | 0 | yes |
| update-leaf | 20 | react | 800 | 512–988 | 2.67x | 355 | 8.66x | 0 | yes |
| update-leaf | 20 | react-reflex | 1118 | 708–1186 | 3.73x | 300 | 7.32x | 0 | yes |
| update-leaf | 20 | react-upstream | 807 | 700–911 | 2.69x | 291 | 7.10x | 1 | yes |
| update-leaf | 20 | roact | 1100 | 432–1345 | 3.67x | 959 | 23.39x | 8 | yes |
| update-leaf | 20 | seam | 1401 | 1100–2304 | 4.67x | 40 | 0.98x | 1 | yes |
| update-leaf | 20 | signals | 1201 | 900–1331 | 4.00x | 50 | 1.22x | 1 | yes |
| update-leaf | 20 | vide | 1118 | 900–1415 | 3.73x | 10 | 0.24x | 0 | yes |
| update-batched | 20 | plain | 4317 | 4103–4805 | 1.00x | 44 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 11235 | 10200–11906 | 2.60x | 940 | 21.36x | 0 | yes |
| update-batched | 20 | compose | 7162 | 6811–7914 | 1.66x | 366 | 8.32x | 9 | yes |
| update-batched | 20 | fusion | 20114 | 19818–21906 | 4.66x | 524 | 11.91x | 0 | yes |
| update-batched | 20 | fusion-charm | 25932 | 22644–26367 | 6.01x | 1117 | 25.39x | 0 | yes |
| update-batched | 20 | react | 7735 | 7426–9445 | 1.79x | 485 | 11.02x | 0 | yes |
| update-batched | 20 | react-reflex | 53531 | 49418–59739 | 12.40x | 767 | 17.43x | 16 | yes |
| update-batched | 20 | react-upstream | 8089 | 7778–9685 | 1.87x | 478 | 10.86x | 7 | yes |
| update-batched | 20 | roact | 8610 | 7851–9925 | 1.99x | 1170 | 26.59x | 0 | yes |
| update-batched | 20 | seam | 12618 | 11631–14004 | 2.92x | 1840 | 41.82x | 0 | yes |
| update-batched | 20 | signals | 9516 | 9227–11302 | 2.20x | 596 | 13.55x | 0 | yes |
| update-batched | 20 | vide | 9025 | 8869–10265 | 2.09x | 331 | 7.52x | 1 | yes |
| update-repeated | 10 | plain | 0 | 0–0 | plain below resolution | 0 | plain zero | 0 | yes |
| update-repeated | 10 | blend | 3400 | 3200–3500 | plain below resolution | 8 | plain zero | 0 | yes |
| update-repeated | 10 | compose | 130 | 100–400 | plain below resolution | 4 | plain zero | 2 | yes |
| update-repeated | 10 | fusion | 25113 | 24729–25514 | plain below resolution | 4 | plain zero | 1 | yes |
| update-repeated | 10 | fusion-charm | 1109 | 1100–1309 | plain below resolution | 6 | plain zero | 1 | yes |
| update-repeated | 10 | react | 7324 | 6926–8129 | plain below resolution | 0 | plain zero | 1 | yes |
| update-repeated | 10 | react-reflex | 700 | 509–1006 | plain below resolution | 3 | plain zero | 0 | yes |
| update-repeated | 10 | react-upstream | 7414 | 6600–7516 | plain below resolution | 8 | plain zero | 0 | yes |
| update-repeated | 10 | roact | 5203 | 5001–5690 | plain below resolution | 6 | plain zero | 0 | yes |
| update-repeated | 10 | seam | 1472 | 1411–1653 | plain below resolution | 10 | plain zero | 0 | yes |
| update-repeated | 10 | signals | 903 | 727–1000 | plain below resolution | 3 | plain zero | 1 | yes |
| update-repeated | 10 | vide | 500 | 300–616 | plain below resolution | 2 | plain zero | 1 | yes |
| branch-swap | 20 | plain | 14159 | 11349–15104 | 1.00x | 10 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 16537 | 16236–18514 | 1.17x | 35 | 3.50x | 8 | yes |
| branch-swap | 20 | compose | 14120 | 13462–16682 | 1.00x | 6 | 0.60x | 2 | yes |
| branch-swap | 20 | fusion | 14996 | 14374–16775 | 1.06x | 4 | 0.40x | 1 | yes |
| branch-swap | 20 | fusion-charm | 5447 | 5355–5615 | 0.38x | 6 | 0.60x | 0 | yes |
| branch-swap | 20 | react | 17883 | 17105–20828 | 1.26x | 10 | 1.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 16764 | 16597–20262 | 1.18x | 10 | 1.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 17012 | 16316–18544 | 1.20x | 10 | 1.00x | 0 | yes |
| branch-swap | 20 | roact | 15863 | 14668–17191 | 1.12x | 19 | 1.90x | 0 | yes |
| branch-swap | 20 | seam | 12329 | 11329–15028 | 0.87x | 11 | 1.10x | 0 | yes |
| branch-swap | 20 | signals | 13561 | 13157–15046 | 0.96x | 5 | 0.50x | 0 | yes |
| branch-swap | 20 | vide | 14541 | 13648–15829 | 1.03x | 5 | 0.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2300 | 2112–2820 | 1.00x | 64 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 4924 | 4601–5847 | 2.14x | 1499 | 23.42x | 0 | yes |
| keyed-prepend | 10 | compose | 4500 | 4334–5274 | 1.96x | 492 | 7.69x | 9 | yes |
| keyed-prepend | 10 | fusion (workaround) | 22607 | 22519–23509 | 9.83x | 1519 | 23.73x | 0 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 16010 | 15306–16574 | 6.96x | 1520 | 23.75x | 2 | yes |
| keyed-prepend | 10 | react | 16307 | 15736–17109 | 7.09x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 15904 | 15521–16739 | 6.91x | 794 | 12.41x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16621 | 15542–17068 | 7.23x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | roact | 7020 | 6908–7595 | 3.05x | 369 | 5.77x | 0 | yes |
| keyed-prepend | 10 | seam | 12408 | 11610–14560 | 5.39x | 2463 | 38.48x | 0 | yes |
| keyed-prepend | 10 | signals | 2927 | 2822–3216 | 1.27x | 61 | 0.95x | 0 | yes |
| keyed-prepend | 10 | vide | 5116 | 5010–5412 | 2.22x | 654 | 10.22x | 0 | yes |
| keyed-insert | 10 | plain | 1502 | 1400–1800 | 1.00x | 97 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4601 | 3664–4846 | 3.06x | 1545 | 15.93x | 1 | yes |
| keyed-insert | 10 | compose | 3023 | 2725–3218 | 2.01x | 519 | 5.35x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 19530 | 18230–20152 | 13.00x | 1534 | 15.81x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 15050 | 14116–15922 | 10.02x | 1528 | 15.75x | 1 | yes |
| keyed-insert | 10 | react | 13737 | 13029–14964 | 9.15x | 875 | 9.02x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13335 | 12855–14115 | 8.88x | 811 | 8.36x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13989 | 13402–14363 | 9.31x | 811 | 8.36x | 0 | yes |
| keyed-insert | 10 | roact | 5900 | 5502–6639 | 3.93x | 369 | 3.80x | 0 | yes |
| keyed-insert | 10 | seam | 11037 | 10303–13404 | 7.35x | 2470 | 25.46x | 0 | yes |
| keyed-insert | 10 | signals | 2140 | 1630–2332 | 1.42x | 60 | 0.62x | 1 | yes |
| keyed-insert | 10 | vide | 3823 | 3773–4152 | 2.55x | 646 | 6.66x | 0 | yes |
| keyed-shuffle | 10 | plain | 1800 | 1700–1900 | 1.00x | 60 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 3200 | 2906–4096 | 1.78x | 1447 | 24.12x | 1 | yes |
| keyed-shuffle | 10 | compose | 3119 | 3030–3745 | 1.73x | 491 | 8.18x | 10 | yes |
| keyed-shuffle | 10 | fusion | 19598 | 18043–20123 | 10.89x | 1406 | 23.43x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 12810 | 11803–13623 | 7.12x | 1400 | 23.33x | 0 | yes |
| keyed-shuffle | 10 | react | 28241 | 26837–29656 | 15.69x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 28410 | 27467–28869 | 15.78x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 29047 | 28123–29315 | 16.14x | 786 | 13.10x | 0 | yes |
| keyed-shuffle | 10 | roact | 6203 | 5852–6631 | 3.45x | 368 | 6.13x | 0 | yes |
| keyed-shuffle | 10 | seam | 11130 | 10615–11384 | 6.18x | 2463 | 41.05x | 0 | yes |
| keyed-shuffle | 10 | signals | 2300 | 2212–2355 | 1.28x | 60 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | vide | 4208 | 3420–4226 | 2.34x | 636 | 10.60x | 1 | yes |
| events | 1 | plain | 700 | 600–800 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | blend | 1104 | 464–1416 | 1.58x | 1 | 1.00x | 1 | yes |
| events | 1 | compose | 1102 | 700–1439 | 1.57x | 1 | 1.00x | 9 | yes |
| events | 1 | fusion | 909 | 816–2000 | 1.30x | 1 | 1.00x | 0 | yes |
| events | 1 | fusion-charm | 1090 | 807–1304 | 1.56x | 1 | 1.00x | 0 | yes |
| events | 1 | react | 1100 | 1000–2014 | 1.57x | 9 | 9.00x | 0 | yes |
| events | 1 | react-reflex | 1383 | 716–2235 | 1.98x | 9 | 9.00x | 0 | yes |
| events | 1 | react-upstream | 1100 | 912–2035 | 1.57x | 2 | 2.00x | 0 | yes |
| events | 1 | roact | 1206 | 908–1510 | 1.72x | 1 | 1.00x | 0 | yes |
| events | 1 | seam | 1102 | 800–1700 | 1.57x | 8 | 8.00x | 1 | yes |
| events | 1 | signals | 1005 | 800–1901 | 1.44x | 2 | 2.00x | 0 | yes |
| events | 1 | vide | 1207 | 1000–2010 | 1.72x | 9 | 9.00x | 0 | yes |
| animate-many | 1 | plain | 3319 | 2668–3580 | 1.00x | 48 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 12419 | 10913–13025 | 3.74x | 1786 | 37.21x | 1 | yes |
| animate-many | 1 | compose | 6520 | 6220–8310 | 1.96x | 637 | 13.27x | 12 | yes |
| animate-many | 1 | fusion | 114987 | 113610–115439 | 34.65x | 1144 | 23.83x | 0 | yes |
| animate-many | 1 | fusion-charm | 78036 | 77606–81942 | 23.51x | 1145 | 23.85x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 21010 | 20153–23009 | 6.33x | 2905 | 60.52x | 1 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8240 | 7912–8809 | 2.48x | 392 | 8.17x | 0 | yes |
| status-panel | 10 | plain | 703 | 600–905 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1005 | 900–1213 | 1.43x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | compose | 1000 | 901–1004 | 1.42x | 30 | 15.00x | 1 | yes |
| status-panel | 10 | fusion | 1503 | 1306–1607 | 2.14x | 64 | 32.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 930 | 802–1205 | 1.32x | 69 | 34.50x | 0 | yes |
| status-panel | 10 | react | 1822 | 1607–2020 | 2.59x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | react-reflex | 1832 | 1719–2148 | 2.61x | 45 | 22.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2012 | 1803–2400 | 2.86x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | roact | 1010 | 901–1119 | 1.44x | 32 | 16.00x | 0 | yes |
| status-panel | 10 | seam | 1718 | 1232–2148 | 2.44x | 140 | 70.00x | 0 | yes |
| status-panel | 10 | signals | 900 | 603–1000 | 1.28x | 6 | 3.00x | 1 | yes |
| status-panel | 10 | vide | 1035 | 1000–1123 | 1.47x | 32 | 16.00x | 0 | yes |
| scene-3d | 10 | plain | 2200 | 1908–2533 | 1.00x | 3 | 1.00x | 8 | yes |
| scene-3d | 10 | blend | 4312 | 4204–4421 | 1.96x | 557 | 185.67x | 1 | yes |
| scene-3d | 10 | compose | 3203 | 2915–3362 | 1.46x | 201 | 67.00x | 2 | yes |
| scene-3d | 10 | fusion | 31964 | 30435–33165 | 14.53x | 528 | 176.00x | 0 | yes |
| scene-3d | 10 | fusion-charm | 23135 | 22364–23773 | 10.52x | 531 | 177.00x | 0 | yes |
| scene-3d | 10 | react | 3527 | 3401–3716 | 1.60x | 231 | 77.00x | 0 | yes |
| scene-3d | 10 | react-reflex | 3150 | 2913–3764 | 1.43x | 225 | 75.00x | 7 | yes |
| scene-3d | 10 | react-upstream | 3608 | 3352–3723 | 1.64x | 230 | 76.67x | 1 | yes |
| scene-3d | 10 | roact | 3420 | 3403–3708 | 1.55x | 589 | 196.33x | 0 | yes |
| scene-3d | 10 | seam | 9221 | 8415–9714 | 4.19x | 1786 | 595.33x | 0 | yes |
| scene-3d | 10 | signals | 6153 | 5420–7029 | 2.80x | 682 | 227.33x | 1 | yes |
| scene-3d | 10 | vide | 3937 | 3705–4618 | 1.79x | 218 | 72.67x | 1 | yes |
| derived-diamond | 3 | plain | 0 | 0–0 | plain below resolution | 4 | 1.00x | 1 | yes |
| derived-diamond | 3 | blend | 100 | 0–100 | plain below resolution | 28 | 7.00x | 8 | yes |
| derived-diamond | 3 | compose | 100 | 0–101 | plain below resolution | 9 | 2.25x | 0 | yes |
| derived-diamond | 3 | fusion | 200 | 0–200 | plain below resolution | 0 | 0.00x | 8 | yes |
| derived-diamond | 3 | fusion-charm | 0 | 0–200 | plain below resolution | 10 | 2.50x | 8 | yes |
| derived-diamond | 3 | react | 400 | 0–500 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-diamond | 3 | react-reflex | 300 | 200–304 | plain below resolution | 8 | 2.00x | 5 | yes |
| derived-diamond | 3 | react-upstream | 202 | 100–300 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-diamond | 3 | roact | 100 | 0–200 | plain below resolution | 7 | 1.75x | 4 | yes |
| derived-diamond | 3 | seam | 100 | 0–400 | plain below resolution | 21 | 5.25x | 0 | yes |
| derived-diamond | 3 | signals | 100 | 0–105 | plain below resolution | 17 | 4.25x | 1 | yes |
| derived-diamond | 3 | vide | 0 | 0–100 | plain below resolution | 0 | 0.00x | 0 | yes |
| derived-chain-100 | 3 | plain | 0 | 0–0 | plain below resolution | 69 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 100 | 0–300 | plain below resolution | 125 | 1.81x | 2 | yes |
| derived-chain-100 | 3 | fusion | 1100 | 900–2000 | plain below resolution | 127 | 1.84x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 800 | 605–1759 | plain below resolution | 129 | 1.87x | 1 | yes |
| derived-chain-100 | 3 | react | 400 | 200–800 | plain below resolution | 1 | 0.01x | 2 | yes |
| derived-chain-100 | 3 | react-reflex | 324 | 200–600 | plain below resolution | 8 | 0.12x | 5 | yes |
| derived-chain-100 | 3 | react-upstream | 300 | 100–600 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-chain-100 | 3 | roact | 0 | 0–200 | plain below resolution | 0 | 0.00x | 3 | yes |
| derived-chain-100 | 3 | seam | 700 | 600–1100 | plain below resolution | 271 | 3.93x | 8 | yes |
| derived-chain-100 | 3 | signals | 107 | 100–401 | plain below resolution | 173 | 2.51x | 0 | yes |
| derived-chain-100 | 3 | vide | 200 | 0–200 | plain below resolution | 93 | 1.35x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 0 | 0–0 | plain below resolution | 599 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 200 | 200–300 | plain below resolution | 1543 | 2.58x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 400 | 300–500 | plain below resolution | 694 | 1.16x | 9 | yes |
| derived-fan-in-1000 | 3 | fusion | 2251 | 1800–2845 | plain below resolution | 897 | 1.50x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2203 | 1938–2810 | plain below resolution | 2821 | 4.71x | 8 | yes |
| derived-fan-in-1000 | 3 | react | 2700 | 1800–3208 | plain below resolution | 320 | 0.53x | 1 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 6608 | 6513–7500 | plain below resolution | 5215 | 8.71x | 44 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2107 | 1800–5506 | plain below resolution | 320 | 0.53x | 2 | yes |
| derived-fan-in-1000 | 3 | roact | 407 | 400–525 | plain below resolution | 109 | 0.18x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2901 | 2709–4607 | plain below resolution | 2955 | 4.93x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 801 | 700–1300 | plain below resolution | 1221 | 2.04x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 500 | 400–801 | plain below resolution | 527 | 0.88x | 1 | yes |
| filter-as-you-type | 1 | plain | 8908 | 8700–10808 | 1.00x | 35 | 1.00x | 1 | yes |
| filter-as-you-type | 1 | blend | 16973 | 16222–17168 | 1.91x | 2859 | 81.69x | 1 | yes |
| filter-as-you-type | 1 | compose | 11317 | 10325–12127 | 1.27x | 857 | 24.49x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28857 | 26698–31033 | 3.24x | 2536 | 72.46x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 21230 | 19229–22685 | 2.38x | 2594 | 74.11x | 1 | yes |
| filter-as-you-type | 1 | react | 22989 | 21982–24355 | 2.58x | 2 | 0.06x | 9 | yes |
| filter-as-you-type | 1 | react-reflex | 21475 | 21293–23165 | 2.41x | 768 | 21.94x | 5 | yes |
| filter-as-you-type | 1 | react-upstream | 22919 | 21017–23256 | 2.57x | 9 | 0.26x | 2 | yes |
| filter-as-you-type | 1 | roact | 12643 | 11408–13005 | 1.42x | 507 | 14.49x | 4 | yes |
| filter-as-you-type | 1 | seam | 21920 | 21357–22523 | 2.46x | 3844 | 109.83x | 1 | yes |
| filter-as-you-type | 1 | signals | 7932 | 7388–8419 | 0.89x | 28 | 0.80x | 1 | yes |
| filter-as-you-type | 1 | vide | 11352 | 11100–11406 | 1.27x | 959 | 27.40x | 0 | yes |
| theme-propagation | 3 | plain | 48479 | 46026–50194 | 1.00x | 206 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 47002 | 46169–47252 | 0.97x | 1997 | 9.69x | 1 | yes |
| theme-propagation | 3 | compose | 51271 | 50760–53286 | 1.06x | 515 | 2.50x | 1 | yes |
| theme-propagation | 3 | fusion | 53176 | 51595–54527 | 1.10x | 811 | 3.94x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 4114 | 3502–4910 | 0.08x | 820 | 3.98x | 0 | yes |
| theme-propagation | 3 | react | 86272 | 82270–87347 | 1.78x | 0 | 0.00x | 10 | yes |
| theme-propagation | 3 | react-reflex | 86481 | 84766–92003 | 1.78x | 4980 | 24.17x | 5 | yes |
| theme-propagation | 3 | react-upstream | 84719 | 81567–87684 | 1.75x | 0 | 0.00x | 3 | yes |
| theme-propagation | 3 | roact | 69506 | 68109–71224 | 1.43x | 2815 | 13.67x | 4 | yes |
| theme-propagation | 3 | seam | 47507 | 46346–48294 | 0.98x | 3422 | 16.61x | 0 | yes |
| theme-propagation | 3 | signals | 52379 | 49349–57976 | 1.08x | 887 | 4.31x | 1 | yes |
| theme-propagation | 3 | vide | 50656 | 49790–51539 | 1.04x | 597 | 2.90x | 0 | yes |
| hud-per-frame | 1 | plain | 2507 | 1913–2867 | 1.00x | 32 | 1.00x | 8 | yes |
| hud-per-frame | 1 | blend | 4621 | 4122–5344 | 1.84x | 71 | 2.22x | 0 | yes |
| hud-per-frame | 1 | compose | 3333 | 2705–3975 | 1.33x | 26 | 0.81x | 2 | yes |
| hud-per-frame | 1 | fusion | 10053 | 9615–10986 | 4.01x | 45 | 1.41x | 8 | yes |
| hud-per-frame | 1 | fusion-charm | 10260 | 9677–11820 | 4.09x | 91 | 2.84x | 0 | yes |
| hud-per-frame | 1 | react | 3523 | 2943–4443 | 1.41x | 33 | 1.03x | 7 | yes |
| hud-per-frame | 1 | react-reflex | 6245 | 6106–6827 | 2.49x | 53 | 1.66x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 3038 | 2616–3436 | 1.21x | 33 | 1.03x | 0 | yes |
| hud-per-frame | 1 | roact | 3524 | 2924–4044 | 1.41x | 90 | 2.81x | 0 | yes |
| hud-per-frame | 1 | seam | 8724 | 7821–9727 | 3.48x | 168 | 5.25x | 1 | yes |
| hud-per-frame | 1 | signals | 4358 | 3459–4648 | 1.74x | 65 | 2.03x | 1 | yes |
| hud-per-frame | 1 | vide | 4123 | 2931–4286 | 1.64x | 24 | 0.75x | 1 | yes |
| teardown-under-load | 1 | plain | 77138 | 74418–78448 | 1.00x | 4 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 73927 | 63310–75168 | 0.96x | 14 | 3.50x | 0 | yes |
| teardown-under-load | 1 | compose | 80865 | 79809–86236 | 1.05x | 12 | 3.00x | 0 | yes |
| teardown-under-load | 1 | fusion | 75125 | 65864–82194 | 0.97x | 5 | 1.25x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 54836 | 52027–58301 | 0.71x | 6 | 1.50x | 0 | yes |
| teardown-under-load | 1 | react | 95288 | 91726–103509 | 1.24x | 959 | 239.75x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 93154 | 88500–102526 | 1.21x | 960 | 240.00x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 93990 | 93432–99872 | 1.22x | 951 | 237.75x | 0 | yes |
| teardown-under-load | 1 | roact | 84484 | 83282–96358 | 1.10x | 70 | 17.50x | 1 | yes |
| teardown-under-load | 1 | seam | 90590 | 85770–91762 | 1.17x | 2 | 0.50x | 6 | yes |
| teardown-under-load | 1 | signals | 79618 | 79086–84050 | 1.03x | 12 | 3.00x | 0 | yes |
| teardown-under-load | 1 | vide | 58592 | 57253–59973 | 0.76x | 4 | 1.00x | 0 | yes |
| open-close-retention | 1 | plain | 140453 | 134149–146665 | 1.00x | 5 | 1.00x | 8 | yes |
| open-close-retention | 1 | blend | 123517 | 121478–133096 | 0.88x | 13 | 2.60x | 1 | yes |
| open-close-retention | 1 | compose | 153051 | 152834–161759 | 1.09x | 5 | 1.00x | 1 | yes |
| open-close-retention | 1 | fusion | 136204 | 131199–145574 | 0.97x | 5 | 1.00x | 9 | yes |
| open-close-retention | 1 | fusion-charm | 101321 | 99518–106401 | 0.72x | 0 | 0.00x | 0 | yes |
| open-close-retention | 1 | react | 173054 | 171647–187936 | 1.23x | 253 | 50.60x | 0 | yes |
| open-close-retention | 1 | react-reflex | 175255 | 173162–187210 | 1.25x | 263 | 52.60x | 5 | yes |
| open-close-retention | 1 | react-upstream | 178873 | 173193–190856 | 1.27x | 254 | 50.80x | 0 | yes |
| open-close-retention | 1 | roact | 169512 | 167458–178123 | 1.21x | 23 | 4.60x | 0 | yes |
| open-close-retention | 1 | seam | 178617 | 176778–192821 | 1.27x | 8 | 1.60x | 1 | yes |
| open-close-retention | 1 | signals | 157935 | 154945–165546 | 1.12x | 4 | 0.80x | 8 | yes |
| open-close-retention | 1 | vide | 91418 | 90440–98636 | 0.65x | 12 | 2.40x | 1 | yes |
| tree-expand-collapse | 1 | plain | 11709 | 9909–12541 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 20745 | 20428–21321 | 1.77x | 812 | 40.60x | 1 | yes |
| tree-expand-collapse | 1 | compose | 12140 | 11946–13806 | 1.04x | 57 | 2.85x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 26855 | 24860–29140 | 2.29x | 173 | 8.65x | 0 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 20175 | 17028–21124 | 1.72x | 174 | 8.70x | 1 | yes |
| tree-expand-collapse | 1 | react | 20629 | 20126–21211 | 1.76x | 1 | 0.05x | 3 | yes |
| tree-expand-collapse | 1 | react-reflex | 20411 | 18963–21043 | 1.74x | 610 | 30.50x | 5 | yes |
| tree-expand-collapse | 1 | react-upstream | 20541 | 19689–20770 | 1.75x | 2 | 0.10x | 2 | yes |
| tree-expand-collapse | 1 | roact | 12246 | 11806–13111 | 1.05x | 32 | 1.60x | 4 | yes |
| tree-expand-collapse | 1 | seam | 26532 | 22046–27734 | 2.27x | 148 | 7.40x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8733 | 8431–9441 | 0.75x | 21 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12460 | 11709–14073 | 1.06x | 70 | 3.50x | 1 | yes |
| form-validation | 1 | plain | 2600 | 1800–2909 | 1.00x | 56 | 1.00x | 1 | yes |
| form-validation | 1 | blend | 3925 | 3749–4423 | 1.51x | 327 | 5.84x | 0 | yes |
| form-validation | 1 | compose | 4022 | 3814–4834 | 1.55x | 92 | 1.64x | 2 | yes |
| form-validation | 1 | fusion | 4957 | 4571–5919 | 1.91x | 118 | 2.11x | 0 | yes |
| form-validation | 1 | fusion-charm | 2744 | 2510–3855 | 1.06x | 162 | 2.89x | 0 | yes |
| form-validation | 1 | react | 13429 | 13015–15462 | 5.17x | 187 | 3.34x | 2 | yes |
| form-validation | 1 | react-reflex | 14598 | 13346–15910 | 5.61x | 260 | 4.64x | 6 | yes |
| form-validation | 1 | react-upstream | 14264 | 13254–14317 | 5.49x | 179 | 3.20x | 10 | yes |
| form-validation | 1 | roact | 7255 | 6624–7900 | 2.79x | 67 | 1.20x | 4 | yes |
| form-validation | 1 | seam | 6668 | 5825–7351 | 2.56x | 357 | 6.38x | 1 | yes |
| form-validation | 1 | signals | 4569 | 3925–5013 | 1.76x | 154 | 2.75x | 0 | yes |
| form-validation | 1 | vide | 4163 | 3422–4700 | 1.60x | 78 | 1.39x | 1 | yes |
| table-sort-filter | 1 | plain | 19776 | 17641–20856 | 1.00x | 74 | 1.00x | 9 | yes |
| table-sort-filter | 1 | blend | 38303 | 37175–40256 | 1.94x | 5796 | 78.32x | 0 | yes |
| table-sort-filter | 1 | compose | 27320 | 27072–27942 | 1.38x | 1490 | 20.14x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 57798 | 52975–59836 | 2.92x | 4790 | 64.73x | 2 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 43098 | 39171–44853 | 2.18x | 4928 | 66.59x | 1 | yes |
| table-sort-filter | 1 | react | 94677 | 93488–98166 | 4.79x | 2042 | 27.59x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 96733 | 91653–98935 | 4.89x | 2054 | 27.76x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 98796 | 94626–102985 | 5.00x | 2042 | 27.59x | 2 | yes |
| table-sort-filter | 1 | roact | 26307 | 25679–28044 | 1.33x | 1051 | 14.20x | 0 | yes |
| table-sort-filter | 1 | seam | 54144 | 48669–56664 | 2.74x | 7751 | 104.74x | 1 | yes |
| table-sort-filter | 1 | signals | 19571 | 18912–20743 | 0.99x | 68 | 0.92x | 0 | yes |
| table-sort-filter | 1 | vide | 28098 | 26624–28536 | 1.42x | 1922 | 25.97x | 0 | yes |
| library-load | 1 | plain | 0 | 0–0 | plain below resolution | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 100 | 0–7127 | plain below resolution | 3 | 3.00x | 458 | yes |
| library-load | 1 | compose | 100 | 100–230 | plain below resolution | 3 | 3.00x | 64 | yes |
| library-load | 1 | fusion | 100 | 100–5610 | plain below resolution | 1 | 1.00x | 269 | yes |
| library-load | 1 | fusion-charm | 0 | 0–7603 | plain below resolution | 2 | 2.00x | 322 | yes |
| library-load | 1 | react | 100 | 0–36021 | plain below resolution | 2 | 2.00x | 1821 | yes |
| library-load | 1 | react-reflex | 200 | 100–28464 | plain below resolution | 1 | 1.00x | 1966 | yes |
| library-load | 1 | react-upstream | 100 | 0–37925 | plain below resolution | 1 | 1.00x | 1988 | yes |
| library-load | 1 | roact | 0 | 0–100 | plain below resolution | 0 | 0.00x | 148 | yes |
| library-load | 1 | seam | 0 | 0–5500 | plain below resolution | 3 | 3.00x | 237 | yes |
| library-load | 1 | signals | 100 | 0–100 | plain below resolution | 1 | 1.00x | 48 | yes |
| library-load | 1 | vide | 0 | 0–100 | plain below resolution | 0 | 0.00x | 145 | yes |
| rows-append-1000 | 1 | plain | 93284 | 91551–127077 | 1.00x | 9754 | 1.00x | 1 | yes |
| rows-append-1000 | 1 | blend | 157254 | 146778–176102 | 1.69x | 38493 | 3.95x | 1 | yes |
| rows-append-1000 | 1 | compose | 119455 | 101318–133593 | 1.28x | 9543 | 0.98x | 10 | yes |
| rows-append-1000 | 1 | fusion | 346181 | 326971–356686 | 3.71x | 20897 | 2.14x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 259319 | 246152–272786 | 2.78x | 28921 | 2.97x | 0 | yes |
| rows-append-1000 | 1 | react | 207857 | 183123–213500 | 2.23x | 23337 | 2.39x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 206286 | 201180–218529 | 2.21x | 24770 | 2.54x | 179 | yes |
| rows-append-1000 | 1 | react-upstream | 192308 | 188622–212696 | 2.06x | 23209 | 2.38x | 0 | yes |
| rows-append-1000 | 1 | roact | 147738 | 137984–153361 | 1.58x | 33363 | 3.42x | 1 | yes |
| rows-append-1000 | 1 | seam | 161560 | 153086–173058 | 1.73x | 46150 | 4.73x | 0 | yes |
| rows-append-1000 | 1 | signals | 109333 | 105760–159907 | 1.17x | 17660 | 1.81x | 0 | yes |
| rows-append-1000 | 1 | vide | 113472 | 112226–118042 | 1.22x | 9500 | 0.97x | 1 | yes |
| rows-clear | 1 | plain | 63941 | 61899–65523 | 1.00x | 2464 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 76668 | 74667–78942 | 1.20x | 4097 | 1.66x | 0 | yes |
| rows-clear | 1 | compose | 69951 | 67775–71391 | 1.09x | 1835 | 0.74x | 3 | yes |
| rows-clear | 1 | fusion | 101415 | 98085–108373 | 1.59x | 3504 | 1.42x | 0 | yes |
| rows-clear | 1 | fusion-charm | 95853 | 92882–96964 | 1.50x | 7441 | 3.02x | 0 | yes |
| rows-clear | 1 | react | 74105 | 72738–74849 | 1.16x | 4521 | 1.83x | 0 | yes |
| rows-clear | 1 | react-reflex | 74096 | 70815–79686 | 1.16x | 6494 | 2.64x | 44 | yes |
| rows-clear | 1 | react-upstream | 71858 | 70780–74132 | 1.12x | 4512 | 1.83x | 1 | yes |
| rows-clear | 1 | roact | 59877 | 58862–60849 | 0.94x | 4238 | 1.72x | 0 | yes |
| rows-clear | 1 | seam | 35729 | 23234–42858 | 0.56x | 9159 | 3.72x | 8 | yes |
| rows-clear | 1 | signals | 64175 | 63258–67974 | 1.00x | 4489 | 1.82x | 1 | yes |
| rows-clear | 1 | vide | 65663 | 62837–66061 | 1.03x | 1629 | 0.66x | 0 | yes |
| rows-create-1000 | 1 | plain | 91083 | 87021–98171 | 1.00x | 5185 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 149109 | 137567–153039 | 1.64x | 19768 | 3.81x | 1 | yes |
| rows-create-1000 | 1 | compose | 106788 | 102588–111878 | 1.17x | 5085 | 0.98x | 2 | yes |
| rows-create-1000 | 1 | fusion | 184948 | 182277–199173 | 2.03x | 11003 | 2.12x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 117546 | 106949–126016 | 1.29x | 14933 | 2.88x | 0 | yes |
| rows-create-1000 | 1 | react | 162753 | 150308–174781 | 1.79x | 8153 | 1.57x | 24 | yes |
| rows-create-1000 | 1 | react-reflex | 167968 | 165681–174895 | 1.84x | 9038 | 1.74x | 43 | yes |
| rows-create-1000 | 1 | react-upstream | 159979 | 155431–165120 | 1.76x | 8151 | 1.57x | 8 | yes |
| rows-create-1000 | 1 | roact | 123339 | 120184–131435 | 1.35x | 16906 | 3.26x | 0 | yes |
| rows-create-1000 | 1 | seam | 143980 | 141029–151870 | 1.58x | 23661 | 4.56x | 1 | yes |
| rows-create-1000 | 1 | signals | 98032 | 95032–104932 | 1.08x | 9050 | 1.75x | 0 | yes |
| rows-create-1000 | 1 | vide | 110518 | 106688–129059 | 1.21x | 4955 | 0.96x | 0 | yes |
| rows-create-10000 | 1 | plain | 1250072 | 1186627–1275849 | 1.00x | 49669 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1809822 | 1806057–1831126 | 1.45x | 193327 | 3.89x | 0 | yes |
| rows-create-10000 | 1 | compose | 1409617 | 1357162–1414470 | 1.13x | 48719 | 0.98x | 2 | yes |
| rows-create-10000 | 1 | fusion | 6319815 | 6107203–6338216 | 5.06x | 105674 | 2.13x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 5496916 | 5440908–5510800 | 4.40x | 145504 | 2.93x | 0 | yes |
| rows-create-10000 | 1 | react | 5215851 | 5156046–5220440 | 4.17x | 77358 | 1.56x | 20 | yes |
| rows-create-10000 | 1 | react-reflex | 5309734 | 5309175–5484830 | 4.25x | 85936 | 1.73x | 500 | yes |
| rows-create-10000 | 1 | react-upstream | 5186738 | 5128342–5240140 | 4.15x | 77870 | 1.57x | 656 | yes |
| rows-create-10000 | 1 | roact | 1543616 | 1528909–1712637 | 1.23x | 165442 | 3.33x | 4 | yes |
| rows-create-10000 | 1 | seam | 1734465 | 1728436–1801255 | 1.39x | 235203 | 4.74x | 4 | yes |
| rows-create-10000 | 1 | signals | 1340128 | 1322565–1351316 | 1.07x | 89224 | 1.80x | 0 | yes |
| rows-create-10000 | 1 | vide | 1350520 | 1350280–1487534 | 1.08x | 48460 | 0.98x | 0 | yes |
| rows-remove-one | 1 | plain | 901 | 817–1000 | 1.00x | 5215 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1200 | 1018–1200 | 1.33x | 19632 | 3.76x | 0 | yes |
| rows-remove-one | 1 | compose | 900 | 602–914 | 1.00x | 5122 | 0.98x | 18 | yes |
| rows-remove-one | 1 | fusion (workaround) | 63254 | 60294–65865 | 70.20x | 11417 | 2.19x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 59098 | 55552–61565 | 65.59x | 15176 | 2.91x | 1 | yes |
| rows-remove-one | 1 | react | 23044 | 20081–24150 | 25.58x | 15725 | 3.02x | 16 | yes |
| rows-remove-one | 1 | react-reflex | 33555 | 22813–39428 | 37.24x | 16610 | 3.19x | 43 | yes |
| rows-remove-one | 1 | react-upstream | 23834 | 20230–35829 | 26.45x | 15709 | 3.01x | 17 | yes |
| rows-remove-one | 1 | roact | 17310 | 15339–17905 | 19.21x | 16997 | 3.26x | 8 | yes |
| rows-remove-one | 1 | seam | 6027 | 5500–7302 | 6.69x | 23678 | 4.54x | 1 | yes |
| rows-remove-one | 1 | signals | 1604 | 1300–1700 | 1.78x | 9085 | 1.74x | 0 | yes |
| rows-remove-one | 1 | vide | 901 | 900–1309 | 1.00x | 5017 | 0.96x | 0 | yes |
| rows-swap | 1 | plain | 406 | 309–500 | 1.00x | 4613 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 700 | 500–800 | 1.72x | 18752 | 4.07x | 0 | yes |
| rows-swap | 1 | compose | 200 | 200–300 | 0.49x | 4626 | 1.00x | 2 | yes |
| rows-swap | 1 | fusion | 63376 | 61242–64776 | 156.10x | 10014 | 2.17x | 0 | yes |
| rows-swap | 1 | fusion-charm | 58188 | 55679–59231 | 143.32x | 13935 | 3.02x | 0 | yes |
| rows-swap | 1 | react | 58402 | 54880–59798 | 143.85x | 15126 | 3.28x | 0 | yes |
| rows-swap | 1 | react-reflex | 67098 | 59868–79612 | 165.27x | 16228 | 3.52x | 60 | yes |
| rows-swap | 1 | react-upstream | 60748 | 56478–62957 | 149.63x | 15447 | 3.35x | 0 | yes |
| rows-swap | 1 | roact | 16719 | 15606–18708 | 41.18x | 16761 | 3.63x | 0 | yes |
| rows-swap | 1 | seam | 5612 | 4809–5914 | 13.82x | 23235 | 5.04x | 0 | yes |
| rows-swap | 1 | signals | 501 | 400–700 | 1.23x | 8617 | 1.87x | 1 | yes |
| rows-swap | 1 | vide | 200 | 107–300 | 0.49x | 4516 | 0.98x | 0 | yes |
| rows-update-every-10th | 1 | plain | 2000 | 1700–2015 | 1.00x | 4226 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1900 | 1701–2000 | 0.95x | 18799 | 4.45x | 0 | yes |
| rows-update-every-10th | 1 | compose | 2000 | 1901–2003 | 1.00x | 4182 | 0.99x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 2100 | 1900–2101 | 1.05x | 10035 | 2.37x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 400 | 100–600 | 0.20x | 13979 | 3.31x | 0 | yes |
| rows-update-every-10th | 1 | react | 2000 | 1909–2104 | 1.00x | 7447 | 1.76x | 32 | yes |
| rows-update-every-10th | 1 | react-reflex | 4104 | 3100–21094 | 2.05x | 8333 | 1.97x | 43 | yes |
| rows-update-every-10th | 1 | react-upstream | 1900 | 1800–2108 | 0.95x | 7432 | 1.76x | 8 | yes |
| rows-update-every-10th | 1 | roact | 2008 | 1900–2029 | 1.00x | 16203 | 3.83x | 1 | yes |
| rows-update-every-10th | 1 | seam | 5303 | 4501–5725 | 2.65x | 23763 | 5.62x | 1 | yes |
| rows-update-every-10th | 1 | signals | 2100 | 1806–2200 | 1.05x | 8881 | 2.10x | 0 | yes |
| rows-update-every-10th | 1 | vide | 2001 | 1810–2104 | 1.00x | 4652 | 1.10x | 2 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.

The shared columns use only the workloads that every lane measured: 24 for time (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`) and 23 for heap (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-fan-in-1000`, `filter-as-you-type`, `hud-per-frame`, `teardown-under-load`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 1.65x | 8.85x | 1.59x | 9.25x |
| compose | 30 | 1.31x | 2.74x | 1.28x | 2.75x |
| fusion | 30 | 4.23x | 4.48x | 3.88x | 4.97x |
| fusion-charm | 30 | 2.70x | 5.99x | 2.46x | 6.58x |
| react | 29 | 3.19x | 3.25x | 3.19x | 3.72x |
| react-reflex | 29 | 3.79x | 6.64x | 3.79x | 7.82x |
| react-upstream | 29 | 3.19x | 3.98x | 3.19x | 3.78x |
| roact | 29 | 2.07x | 4.82x | 2.07x | 4.82x |
| seam | 30 | 2.63x | 9.47x | 2.53x | 10.32x |
| signals | 29 | 1.32x | 2.04x | 1.32x | 2.03x |
| vide | 30 | 1.37x | 2.75x | 1.33x | 2.72x |
