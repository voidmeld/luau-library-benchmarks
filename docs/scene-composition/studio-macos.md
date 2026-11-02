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
| Harness revision | `b27a079` |
| Date | 2026-11-02 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 500 | 409–800 | 1.00x | 25 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 1300 | 901–1475 | 2.60x | 740 | 29.60x | 9 | yes |
| update-leaf | 20 | compose | 1104 | 821–1834 | 2.21x | 35 | 1.40x | 2 | yes |
| update-leaf | 20 | fusion | 1408 | 1210–1508 | 2.82x | 115 | 4.60x | 1 | yes |
| update-leaf | 20 | fusion-charm | 1612 | 1038–1656 | 3.22x | 117 | 4.68x | 0 | yes |
| update-leaf | 20 | react | 1000 | 902–1600 | 2.00x | 291 | 11.64x | 0 | yes |
| update-leaf | 20 | react-reflex | 1412 | 1225–1621 | 2.82x | 293 | 11.72x | 8 | yes |
| update-leaf | 20 | react-upstream | 1302 | 631–1530 | 2.60x | 291 | 11.64x | 0 | yes |
| update-leaf | 20 | roact | 1220 | 800–1311 | 2.44x | 967 | 38.68x | 1 | yes |
| update-leaf | 20 | seam | 1601 | 1406–1900 | 3.20x | 40 | 1.60x | 1 | yes |
| update-leaf | 20 | signals | 1301 | 1008–1545 | 2.60x | 50 | 2.00x | 0 | yes |
| update-leaf | 20 | vide | 1413 | 1004–1622 | 2.83x | 3 | 0.12x | 0 | yes |
| update-batched | 20 | plain | 3911 | 3807–4007 | 1.00x | 20 | 1.00x | 8 | yes |
| update-batched | 20 | blend | 11171 | 10668–11814 | 2.86x | 916 | 45.80x | 0 | yes |
| update-batched | 20 | compose | 7584 | 7270–7993 | 1.94x | 342 | 17.10x | 9 | yes |
| update-batched | 20 | fusion | 23702 | 22683–23959 | 6.06x | 524 | 26.20x | 0 | yes |
| update-batched | 20 | fusion-charm | 42073 | 40940–42647 | 10.76x | 1117 | 55.85x | 0 | yes |
| update-batched | 20 | react | 8391 | 7609–9137 | 2.15x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | react-reflex | 66550 | 63441–71780 | 17.02x | 767 | 38.35x | 16 | yes |
| update-batched | 20 | react-upstream | 8471 | 8193–8960 | 2.17x | 485 | 24.25x | 0 | yes |
| update-batched | 20 | roact | 9167 | 8526–10314 | 2.34x | 1177 | 58.85x | 0 | yes |
| update-batched | 20 | seam | 13500 | 13174–13954 | 3.45x | 1848 | 92.40x | 0 | yes |
| update-batched | 20 | signals | 10282 | 9970–10687 | 2.63x | 605 | 30.25x | 0 | yes |
| update-batched | 20 | vide | 9697 | 9283–11233 | 2.48x | 340 | 17.00x | 0 | yes |
| update-repeated | 10 | plain | 0 | 0–100 | plain below resolution | 0 | plain zero | 0 | yes |
| update-repeated | 10 | blend | 3412 | 3313–3654 | plain below resolution | 8 | plain zero | 0 | yes |
| update-repeated | 10 | compose | 417 | 202–905 | plain below resolution | 4 | plain zero | 2 | yes |
| update-repeated | 10 | fusion | 26782 | 26187–26961 | plain below resolution | 5 | plain zero | 0 | yes |
| update-repeated | 10 | fusion-charm | 1415 | 1202–1506 | plain below resolution | 6 | plain zero | 0 | yes |
| update-repeated | 10 | react | 7363 | 6809–7751 | plain below resolution | 1 | plain zero | 0 | yes |
| update-repeated | 10 | react-reflex | 800 | 602–1005 | plain below resolution | 12 | plain zero | 0 | yes |
| update-repeated | 10 | react-upstream | 7147 | 6702–8262 | plain below resolution | 1 | plain zero | 0 | yes |
| update-repeated | 10 | roact | 5137 | 5104–5840 | plain below resolution | 6 | plain zero | 1 | yes |
| update-repeated | 10 | seam | 1721 | 1508–1853 | plain below resolution | 11 | plain zero | 0 | yes |
| update-repeated | 10 | signals | 814 | 802–904 | plain below resolution | 4 | plain zero | 0 | yes |
| update-repeated | 10 | vide | 706 | 480–911 | plain below resolution | 2 | plain zero | 1 | yes |
| branch-swap | 20 | plain | 14911 | 14259–15989 | 1.00x | 1 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 20772 | 20394–21555 | 1.39x | 42 | 42.00x | 8 | yes |
| branch-swap | 20 | compose | 17845 | 17257–19193 | 1.20x | 5 | 5.00x | 1 | yes |
| branch-swap | 20 | fusion | 18207 | 18076–20634 | 1.22x | 5 | 5.00x | 0 | yes |
| branch-swap | 20 | fusion-charm | 18423 | 17558–19258 | 1.24x | 6 | 6.00x | 0 | yes |
| branch-swap | 20 | react | 20758 | 20271–23233 | 1.39x | 10 | 10.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 20630 | 20374–22973 | 1.38x | 11 | 11.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 21483 | 20367–23379 | 1.44x | 18 | 18.00x | 0 | yes |
| branch-swap | 20 | roact | 18664 | 17621–21019 | 1.25x | 11 | 11.00x | 0 | yes |
| branch-swap | 20 | seam | 15842 | 15649–17728 | 1.06x | 11 | 11.00x | 0 | yes |
| branch-swap | 20 | signals | 16959 | 16816–18148 | 1.14x | 5 | 5.00x | 1 | yes |
| branch-swap | 20 | vide | 17660 | 17294–19671 | 1.18x | 5 | 5.00x | 1 | yes |
| keyed-prepend | 10 | plain | 2413 | 2300–2604 | 1.00x | 64 | 1.00x | 8 | yes |
| keyed-prepend | 10 | blend | 4803 | 4707–5154 | 1.99x | 1514 | 23.66x | 1 | yes |
| keyed-prepend | 10 | compose | 4307 | 3835–4761 | 1.78x | 499 | 7.80x | 9 | yes |
| keyed-prepend | 10 | fusion (workaround) | 25435 | 23165–26410 | 10.54x | 1542 | 24.09x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 23635 | 22074–26412 | 9.79x | 1545 | 24.14x | 1 | yes |
| keyed-prepend | 10 | react | 16551 | 14734–17511 | 6.86x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16256 | 15832–16753 | 6.74x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16526 | 16150–16728 | 6.85x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | roact | 7271 | 7039–7517 | 3.01x | 368 | 5.75x | 1 | yes |
| keyed-prepend | 10 | seam | 11678 | 11198–12890 | 4.84x | 2471 | 38.61x | 0 | yes |
| keyed-prepend | 10 | signals | 3211 | 2771–3453 | 1.33x | 61 | 0.95x | 1 | yes |
| keyed-prepend | 10 | vide | 5417 | 5219–5545 | 2.24x | 646 | 10.09x | 0 | yes |
| keyed-insert | 10 | plain | 1600 | 1500–1600 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4671 | 4435–5439 | 2.92x | 1514 | 23.66x | 1 | yes |
| keyed-insert | 10 | compose | 3713 | 3375–4155 | 2.32x | 488 | 7.62x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 21360 | 21158–24318 | 13.35x | 1534 | 23.97x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 20478 | 19412–21034 | 12.80x | 1528 | 23.88x | 1 | yes |
| keyed-insert | 10 | react | 14152 | 13931–15419 | 8.85x | 819 | 12.80x | 0 | yes |
| keyed-insert | 10 | react-reflex | 14025 | 6934–14427 | 8.77x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 14572 | 12857–15087 | 9.11x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 6371 | 5646–6773 | 3.98x | 369 | 5.77x | 0 | yes |
| keyed-insert | 10 | seam | 11920 | 11728–13163 | 7.45x | 2479 | 38.73x | 0 | yes |
| keyed-insert | 10 | signals | 2222 | 2018–2435 | 1.39x | 61 | 0.95x | 0 | yes |
| keyed-insert | 10 | vide | 4160 | 3614–4456 | 2.60x | 646 | 10.09x | 1 | yes |
| keyed-shuffle | 10 | plain | 1701 | 1700–1707 | 1.00x | 60 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 3220 | 3107–3501 | 1.89x | 1463 | 24.38x | 0 | yes |
| keyed-shuffle | 10 | compose | 3119 | 2900–3432 | 1.83x | 498 | 8.30x | 9 | yes |
| keyed-shuffle | 10 | fusion | 20892 | 20698–22163 | 12.28x | 1406 | 23.43x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 19223 | 19149–20979 | 11.30x | 1416 | 23.60x | 0 | yes |
| keyed-shuffle | 10 | react | 27895 | 27051–28242 | 16.40x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27832 | 27333–28366 | 16.36x | 780 | 13.00x | 1 | yes |
| keyed-shuffle | 10 | react-upstream | 27915 | 27005–29016 | 16.41x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | roact | 6104 | 5418–6682 | 3.59x | 360 | 6.00x | 1 | yes |
| keyed-shuffle | 10 | seam | 9916 | 9218–10060 | 5.83x | 2470 | 41.17x | 1 | yes |
| keyed-shuffle | 10 | signals | 2414 | 2144–2500 | 1.42x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | vide | 4019 | 3800–4119 | 2.36x | 637 | 10.62x | 0 | yes |
| events | 1 | plain | 1501 | 1106–2359 | 1.00x | 1 | 1.00x | 1 | yes |
| events | 1 | blend | 1537 | 1408–2003 | 1.02x | 1 | 1.00x | 0 | yes |
| events | 1 | compose | 1212 | 900–1500 | 0.81x | 1 | 1.00x | 1 | yes |
| events | 1 | fusion | 1322 | 1010–1606 | 0.88x | 9 | 9.00x | 0 | yes |
| events | 1 | fusion-charm | 1307 | 1100–2216 | 0.87x | 1 | 1.00x | 0 | yes |
| events | 1 | react | 1907 | 1500–2634 | 1.27x | 1 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 1714 | 1412–2110 | 1.14x | 1 | 1.00x | 0 | yes |
| events | 1 | react-upstream | 1709 | 1342–2591 | 1.14x | 1 | 1.00x | 0 | yes |
| events | 1 | roact | 1400 | 1103–1837 | 0.93x | 0 | 0.00x | 8 | yes |
| events | 1 | seam | 1007 | 900–2014 | 0.67x | 1 | 1.00x | 0 | yes |
| events | 1 | signals | 1532 | 913–2043 | 1.02x | 9 | 9.00x | 0 | yes |
| events | 1 | vide | 1500 | 1306–1820 | 1.00x | 1 | 1.00x | 0 | yes |
| animate-many | 1 | plain | 2846 | 2614–3140 | 1.00x | 40 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 11912 | 11446–12603 | 4.19x | 1786 | 44.65x | 0 | yes |
| animate-many | 1 | compose | 7262 | 6593–7422 | 2.55x | 638 | 15.95x | 11 | yes |
| animate-many | 1 | fusion | 109390 | 107394–110878 | 38.44x | 1143 | 28.57x | 0 | yes |
| animate-many | 1 | fusion-charm | 115943 | 114301–117054 | 40.74x | 1145 | 28.62x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 22011 | 21506–22622 | 7.73x | 2913 | 72.83x | 2 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8614 | 8259–8897 | 3.03x | 392 | 9.80x | 0 | yes |
| status-panel | 10 | plain | 724 | 641–809 | 1.00x | 2 | 1.00x | 2 | yes |
| status-panel | 10 | blend | 1620 | 1435–1720 | 2.24x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | compose | 1505 | 1342–1706 | 2.08x | 29 | 14.50x | 1 | yes |
| status-panel | 10 | fusion | 1910 | 1873–2289 | 2.64x | 72 | 36.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 2200 | 1800–2302 | 3.04x | 77 | 38.50x | 1 | yes |
| status-panel | 10 | react | 2517 | 2208–2913 | 3.48x | 35 | 17.50x | 0 | yes |
| status-panel | 10 | react-reflex | 2604 | 2416–2800 | 3.60x | 45 | 22.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2721 | 2608–2934 | 3.76x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | roact | 1524 | 1400–1929 | 2.10x | 25 | 12.50x | 1 | yes |
| status-panel | 10 | seam | 2531 | 1904–2605 | 3.50x | 140 | 70.00x | 0 | yes |
| status-panel | 10 | signals | 1315 | 1139–1513 | 1.82x | 15 | 7.50x | 0 | yes |
| status-panel | 10 | vide | 1600 | 918–1822 | 2.21x | 31 | 15.50x | 0 | yes |
| scene-3d | 10 | plain | 2103 | 2000–2303 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4208 | 4100–4828 | 2.00x | 566 | 51.45x | 0 | yes |
| scene-3d | 10 | compose | 3232 | 3101–3476 | 1.54x | 177 | 16.09x | 2 | yes |
| scene-3d | 10 | fusion | 32764 | 31986–33719 | 15.58x | 535 | 48.64x | 0 | yes |
| scene-3d | 10 | fusion-charm | 31681 | 31205–32310 | 15.06x | 540 | 49.09x | 0 | yes |
| scene-3d | 10 | react | 3517 | 3332–3804 | 1.67x | 222 | 20.18x | 7 | yes |
| scene-3d | 10 | react-reflex | 3418 | 3114–4628 | 1.63x | 224 | 20.36x | 1 | yes |
| scene-3d | 10 | react-upstream | 3625 | 3079–4007 | 1.72x | 231 | 21.00x | 0 | yes |
| scene-3d | 10 | roact | 3673 | 3235–3884 | 1.75x | 582 | 52.91x | 0 | yes |
| scene-3d | 10 | seam | 9110 | 8211–10410 | 4.33x | 1787 | 162.45x | 0 | yes |
| scene-3d | 10 | signals | 6498 | 5821–7015 | 3.09x | 682 | 62.00x | 0 | yes |
| scene-3d | 10 | vide | 4240 | 3529–4520 | 2.02x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 0 | 0–0 | plain below resolution | 4 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 100 | 0–100 | plain below resolution | 28 | 7.00x | 0 | yes |
| derived-diamond | 3 | compose | 100 | 0–100 | plain below resolution | 8 | 2.00x | 2 | yes |
| derived-diamond | 3 | fusion | 0 | 0–100 | plain below resolution | 8 | 2.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 100 | 100–200 | plain below resolution | 10 | 2.50x | 0 | yes |
| derived-diamond | 3 | react | 107 | 0–320 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-diamond | 3 | react-reflex | 200 | 100–410 | plain below resolution | 1 | 0.25x | 5 | yes |
| derived-diamond | 3 | react-upstream | 300 | 200–520 | plain below resolution | 8 | 2.00x | 2 | yes |
| derived-diamond | 3 | roact | 0 | 0–0 | plain below resolution | 7 | 1.75x | 3 | yes |
| derived-diamond | 3 | seam | 101 | 0–306 | plain below resolution | 20 | 5.00x | 1 | yes |
| derived-diamond | 3 | signals | 0 | 0–100 | plain below resolution | 9 | 2.25x | 8 | yes |
| derived-diamond | 3 | vide | 0 | 0–100 | plain below resolution | 6 | 1.50x | 0 | yes |
| derived-chain-100 | 3 | plain | 0 | 0–0 | plain below resolution | 69 | 1.00x | 1 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 200 | 100–300 | plain below resolution | 125 | 1.81x | 2 | yes |
| derived-chain-100 | 3 | fusion | 900 | 760–1300 | plain below resolution | 126 | 1.83x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 900 | 700–1207 | plain below resolution | 128 | 1.86x | 1 | yes |
| derived-chain-100 | 3 | react | 300 | 300–408 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-chain-100 | 3 | react-reflex | 400 | 300–526 | plain below resolution | 9 | 0.13x | 5 | yes |
| derived-chain-100 | 3 | react-upstream | 300 | 200–402 | plain below resolution | 0 | 0.00x | 0 | yes |
| derived-chain-100 | 3 | roact | 200 | 0–203 | plain below resolution | 8 | 0.12x | 3 | yes |
| derived-chain-100 | 3 | seam | 730 | 600–1029 | plain below resolution | 279 | 4.04x | 0 | yes |
| derived-chain-100 | 3 | signals | 200 | 0–400 | plain below resolution | 173 | 2.51x | 1 | yes |
| derived-chain-100 | 3 | vide | 100 | 100–200 | plain below resolution | 92 | 1.33x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 0 | 0–0 | plain below resolution | 598 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 200 | 200–302 | plain below resolution | 1542 | 2.58x | 8 | yes |
| derived-fan-in-1000 | 3 | compose | 300 | 300–407 | plain below resolution | 694 | 1.16x | 9 | yes |
| derived-fan-in-1000 | 3 | fusion | 2105 | 1810–2900 | plain below resolution | 897 | 1.50x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2407 | 2117–2901 | plain below resolution | 2829 | 4.73x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1815 | 1800–3718 | plain below resolution | 321 | 0.54x | 2 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7331 | 6808–7736 | plain below resolution | 5230 | 8.75x | 35 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2200 | 1803–2905 | plain below resolution | 321 | 0.54x | 2 | yes |
| derived-fan-in-1000 | 3 | roact | 400 | 300–800 | plain below resolution | 109 | 0.18x | 0 | yes |
| derived-fan-in-1000 | 3 | seam | 2813 | 2602–3443 | plain below resolution | 2963 | 4.95x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 600 | 600–800 | plain below resolution | 1220 | 2.04x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 500 | 300–500 | plain below resolution | 528 | 0.88x | 0 | yes |
| filter-as-you-type | 1 | plain | 8403 | 7102–8790 | 1.00x | 146 | 1.00x | 9 | yes |
| filter-as-you-type | 1 | blend | 17242 | 16346–17828 | 2.05x | 2979 | 20.40x | 0 | yes |
| filter-as-you-type | 1 | compose | 10635 | 10138–11109 | 1.27x | 865 | 5.92x | 2 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28452 | 26948–32126 | 3.39x | 2600 | 17.81x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 27321 | 25852–28784 | 3.25x | 2602 | 17.82x | 2 | yes |
| filter-as-you-type | 1 | react | 21947 | 21273–22556 | 2.61x | 9 | 0.06x | 1 | yes |
| filter-as-you-type | 1 | react-reflex | 22344 | 20434–22849 | 2.66x | 760 | 5.21x | 5 | yes |
| filter-as-you-type | 1 | react-upstream | 22256 | 21317–22865 | 2.65x | 9 | 0.06x | 9 | yes |
| filter-as-you-type | 1 | roact | 11539 | 10956–12008 | 1.37x | 508 | 3.48x | 3 | yes |
| filter-as-you-type | 1 | seam | 25440 | 20336–28342 | 3.03x | 4020 | 27.53x | 0 | yes |
| filter-as-you-type | 1 | signals | 7930 | 7710–8200 | 0.94x | 36 | 0.25x | 1 | yes |
| filter-as-you-type | 1 | vide | 11008 | 10654–11212 | 1.31x | 959 | 6.57x | 0 | yes |
| theme-propagation | 3 | plain | 70081 | 68641–70365 | 1.00x | 206 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 68802 | 67862–69311 | 0.98x | 1997 | 9.69x | 8 | yes |
| theme-propagation | 3 | compose | 75255 | 74533–77374 | 1.07x | 523 | 2.54x | 1 | yes |
| theme-propagation | 3 | fusion | 75492 | 72880–77364 | 1.08x | 818 | 3.97x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 73646 | 72424–76162 | 1.05x | 820 | 3.98x | 0 | yes |
| theme-propagation | 3 | react | 113008 | 109620–113844 | 1.61x | 0 | 0.00x | 2 | yes |
| theme-propagation | 3 | react-reflex | 112333 | 109656–118299 | 1.60x | 4980 | 24.17x | 5 | yes |
| theme-propagation | 3 | react-upstream | 112857 | 107478–113616 | 1.61x | 0 | 0.00x | 0 | yes |
| theme-propagation | 3 | roact | 94996 | 93166–96393 | 1.36x | 2808 | 13.63x | 4 | yes |
| theme-propagation | 3 | seam | 67379 | 66080–68229 | 0.96x | 3429 | 16.65x | 1 | yes |
| theme-propagation | 3 | signals | 74627 | 74366–77341 | 1.06x | 880 | 4.27x | 0 | yes |
| theme-propagation | 3 | vide | 72262 | 71554–73857 | 1.03x | 589 | 2.86x | 1 | yes |
| hud-per-frame | 1 | plain | 2409 | 1716–2908 | 1.00x | 25 | 1.00x | 1 | yes |
| hud-per-frame | 1 | blend | 4619 | 4521–5036 | 1.92x | 63 | 2.52x | 0 | yes |
| hud-per-frame | 1 | compose | 3413 | 2544–3711 | 1.42x | 26 | 1.04x | 2 | yes |
| hud-per-frame | 1 | fusion | 10181 | 9804–11040 | 4.23x | 54 | 2.16x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 14099 | 13706–14551 | 5.85x | 82 | 3.28x | 0 | yes |
| hud-per-frame | 1 | react | 3480 | 3094–3929 | 1.44x | 34 | 1.36x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 6558 | 5893–7408 | 2.72x | 52 | 2.08x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 3261 | 2834–3336 | 1.35x | 34 | 1.36x | 0 | yes |
| hud-per-frame | 1 | roact | 3749 | 2911–3820 | 1.56x | 90 | 3.60x | 0 | yes |
| hud-per-frame | 1 | seam | 8888 | 7968–9075 | 3.69x | 169 | 6.76x | 0 | yes |
| hud-per-frame | 1 | signals | 4740 | 4136–5591 | 1.97x | 73 | 2.92x | 0 | yes |
| hud-per-frame | 1 | vide | 4831 | 3521–4966 | 2.01x | 25 | 1.00x | 1 | yes |
| teardown-under-load | 1 | plain | 87871 | 86960–90891 | 1.00x | 12 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 70268 | 65494–70579 | 0.80x | 5 | 0.42x | 1 | yes |
| teardown-under-load | 1 | compose | 96241 | 93535–96500 | 1.10x | 6 | 0.50x | 1 | yes |
| teardown-under-load | 1 | fusion | 75670 | 65499–80001 | 0.86x | 4 | 0.33x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 74865 | 64365–85191 | 0.85x | 6 | 0.50x | 0 | yes |
| teardown-under-load | 1 | react | 106232 | 101733–112659 | 1.21x | 952 | 79.33x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 104582 | 100459–110601 | 1.19x | 952 | 79.33x | 6 | yes |
| teardown-under-load | 1 | react-upstream | 106302 | 102457–110706 | 1.21x | 952 | 79.33x | 0 | yes |
| teardown-under-load | 1 | roact | 101722 | 97475–102737 | 1.16x | 71 | 5.92x | 0 | yes |
| teardown-under-load | 1 | seam | 103065 | 94549–110253 | 1.17x | 2 | 0.17x | 14 | yes |
| teardown-under-load | 1 | signals | 95584 | 95370–99663 | 1.09x | 4 | 0.33x | 0 | yes |
| teardown-under-load | 1 | vide | 57857 | 54984–58975 | 0.66x | 5 | 0.42x | 0 | yes |
| open-close-retention | 1 | plain | 167311 | 164937–178194 | 1.00x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 120158 | 110679–125204 | 0.72x | 6 | 1.20x | 0 | yes |
| open-close-retention | 1 | compose | 183214 | 181108–189720 | 1.10x | 5 | 1.00x | 1 | yes |
| open-close-retention | 1 | fusion | 138113 | 135406–146252 | 0.83x | 4 | 0.80x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 139244 | 138259–146853 | 0.83x | 6 | 1.20x | 8 | yes |
| open-close-retention | 1 | react | 207639 | 204501–214426 | 1.24x | 254 | 50.80x | 0 | yes |
| open-close-retention | 1 | react-reflex | 205926 | 205241–215997 | 1.23x | 255 | 51.00x | 0 | yes |
| open-close-retention | 1 | react-upstream | 207941 | 204638–218192 | 1.24x | 254 | 50.80x | 0 | yes |
| open-close-retention | 1 | roact | 199060 | 197589–204356 | 1.19x | 22 | 4.40x | 0 | yes |
| open-close-retention | 1 | seam | 214654 | 211876–219966 | 1.28x | 9 | 1.80x | 0 | yes |
| open-close-retention | 1 | signals | 186461 | 185976–192108 | 1.11x | 4 | 0.80x | 8 | yes |
| open-close-retention | 1 | vide | 91235 | 89092–96447 | 0.55x | 4 | 0.80x | 0 | yes |
| tree-expand-collapse | 1 | plain | 10028 | 7631–10843 | 1.00x | 20 | 1.00x | 9 | yes |
| tree-expand-collapse | 1 | blend | 20050 | 18749–21727 | 2.00x | 820 | 41.00x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12417 | 12143–13046 | 1.24x | 65 | 3.25x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 23286 | 22972–26604 | 2.32x | 172 | 8.60x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23231 | 19834–27268 | 2.32x | 166 | 8.30x | 1 | yes |
| tree-expand-collapse | 1 | react | 18826 | 17690–20081 | 1.88x | 1 | 0.05x | 9 | yes |
| tree-expand-collapse | 1 | react-reflex | 19178 | 18577–19817 | 1.91x | 603 | 30.15x | 5 | yes |
| tree-expand-collapse | 1 | react-upstream | 19651 | 18923–21691 | 1.96x | 2 | 0.10x | 0 | yes |
| tree-expand-collapse | 1 | roact | 11819 | 11557–12454 | 1.18x | 32 | 1.60x | 3 | yes |
| tree-expand-collapse | 1 | seam | 26417 | 22453–30082 | 2.63x | 140 | 7.00x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8791 | 8544–9061 | 0.88x | 21 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12652 | 11883–12950 | 1.26x | 78 | 3.90x | 0 | yes |
| form-validation | 1 | plain | 3217 | 3140–3400 | 1.00x | 56 | 1.00x | 1 | yes |
| form-validation | 1 | blend | 5114 | 4754–5359 | 1.59x | 335 | 5.98x | 0 | yes |
| form-validation | 1 | compose | 5036 | 4707–5344 | 1.57x | 92 | 1.64x | 2 | yes |
| form-validation | 1 | fusion | 5862 | 5713–6303 | 1.82x | 117 | 2.09x | 1 | yes |
| form-validation | 1 | fusion-charm | 6750 | 6372–7023 | 2.10x | 154 | 2.75x | 1 | yes |
| form-validation | 1 | react | 13956 | 13727–14933 | 4.34x | 179 | 3.20x | 2 | yes |
| form-validation | 1 | react-reflex | 16180 | 15482–16628 | 5.03x | 244 | 4.36x | 14 | yes |
| form-validation | 1 | react-upstream | 15088 | 14786–15310 | 4.69x | 187 | 3.34x | 2 | yes |
| form-validation | 1 | roact | 8041 | 7907–8311 | 2.50x | 68 | 1.21x | 0 | yes |
| form-validation | 1 | seam | 7400 | 6230–7777 | 2.30x | 348 | 6.21x | 9 | yes |
| form-validation | 1 | signals | 5028 | 4748–5230 | 1.56x | 154 | 2.75x | 0 | yes |
| form-validation | 1 | vide | 5063 | 4926–5470 | 1.57x | 70 | 1.25x | 0 | yes |
| table-sort-filter | 1 | plain | 17969 | 17698–18970 | 1.00x | 75 | 1.00x | 8 | yes |
| table-sort-filter | 1 | blend | 38222 | 35230–45616 | 2.13x | 5804 | 77.39x | 0 | yes |
| table-sort-filter | 1 | compose | 26280 | 25153–26639 | 1.46x | 1498 | 19.97x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 58573 | 55439–61585 | 3.26x | 4950 | 66.00x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 54148 | 50997–55681 | 3.01x | 4944 | 65.92x | 1 | yes |
| table-sort-filter | 1 | react | 92767 | 92088–95578 | 5.16x | 2050 | 27.33x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 92030 | 91532–94505 | 5.12x | 2053 | 27.37x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 94354 | 92761–95273 | 5.25x | 2034 | 27.12x | 2 | yes |
| table-sort-filter | 1 | roact | 25866 | 24694–28232 | 1.44x | 1043 | 13.91x | 3 | yes |
| table-sort-filter | 1 | seam | 63789 | 62342–65179 | 3.55x | 7775 | 103.67x | 0 | yes |
| table-sort-filter | 1 | signals | 18146 | 17894–18275 | 1.01x | 75 | 1.00x | 9 | yes |
| table-sort-filter | 1 | vide | 27318 | 26232–28048 | 1.52x | 1922 | 25.63x | 1 | yes |
| library-load | 1 | plain | 0 | 0–0 | plain below resolution | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 0 | 0–100 | plain below resolution | 3 | 3.00x | 410 | yes |
| library-load | 1 | compose | 0 | 0–100 | plain below resolution | 3 | 3.00x | 364 | yes |
| library-load | 1 | fusion | 0 | 0–100 | plain below resolution | 2 | 2.00x | 184 | yes |
| library-load | 1 | fusion-charm | 100 | 0–100 | plain below resolution | 1 | 1.00x | 229 | yes |
| library-load | 1 | react | 100 | 100–202 | plain below resolution | 9 | 9.00x | 1320 | yes |
| library-load | 1 | react-reflex | 100 | 0–200 | plain below resolution | 1 | 1.00x | 1459 | yes |
| library-load | 1 | react-upstream | 200 | 100–300 | plain below resolution | 9 | 9.00x | 1432 | yes |
| library-load | 1 | roact | 100 | 0–100 | plain below resolution | 3 | 3.00x | 116 | yes |
| library-load | 1 | seam | 0 | 0–103 | plain below resolution | 2 | 2.00x | 177 | yes |
| library-load | 1 | signals | 100 | 0–200 | plain below resolution | 2 | 2.00x | 25 | yes |
| library-load | 1 | vide | 100 | 0–106 | plain below resolution | 0 | 0.00x | 105 | yes |
| rows-append-1000 | 1 | plain | 120864 | 117628–134338 | 1.00x | 9755 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 188150 | 168281–189819 | 1.56x | 38481 | 3.94x | 0 | yes |
| rows-append-1000 | 1 | compose | 138559 | 130448–141282 | 1.15x | 9543 | 0.98x | 2 | yes |
| rows-append-1000 | 1 | fusion | 370320 | 360721–383625 | 3.06x | 20938 | 2.15x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 361531 | 346147–364186 | 2.99x | 28801 | 2.95x | 0 | yes |
| rows-append-1000 | 1 | react | 210620 | 202899–245933 | 1.74x | 23370 | 2.40x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 232100 | 226001–247834 | 1.92x | 24962 | 2.56x | 212 | yes |
| rows-append-1000 | 1 | react-upstream | 220345 | 201219–237886 | 1.82x | 23209 | 2.38x | 0 | yes |
| rows-append-1000 | 1 | roact | 173263 | 160634–229542 | 1.43x | 33370 | 3.42x | 0 | yes |
| rows-append-1000 | 1 | seam | 157890 | 152262–197064 | 1.31x | 46646 | 4.78x | 0 | yes |
| rows-append-1000 | 1 | signals | 130159 | 124522–189367 | 1.08x | 17835 | 1.83x | 0 | yes |
| rows-append-1000 | 1 | vide | 138956 | 134215–178935 | 1.15x | 9508 | 0.97x | 0 | yes |
| rows-clear | 1 | plain | 21274 | 20254–21948 | 1.00x | 2463 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 37469 | 35696–37942 | 1.76x | 4201 | 1.71x | 9 | yes |
| rows-clear | 1 | compose | 25530 | 25001–27562 | 1.20x | 1835 | 0.75x | 2 | yes |
| rows-clear | 1 | fusion | 79008 | 74039–83493 | 3.71x | 3511 | 1.43x | 1 | yes |
| rows-clear | 1 | fusion-charm | 73818 | 73088–76166 | 3.47x | 7433 | 3.02x | 1 | yes |
| rows-clear | 1 | react | 26163 | 25461–26375 | 1.23x | 4520 | 1.84x | 0 | yes |
| rows-clear | 1 | react-reflex | 30247 | 29087–31914 | 1.42x | 6455 | 2.62x | 36 | yes |
| rows-clear | 1 | react-upstream | 25966 | 25193–26975 | 1.22x | 4504 | 1.83x | 224 | yes |
| rows-clear | 1 | roact | 26173 | 24934–26786 | 1.23x | 4229 | 1.72x | 0 | yes |
| rows-clear | 1 | seam | 39404 | 36032–42215 | 1.85x | 9142 | 3.71x | 1 | yes |
| rows-clear | 1 | signals | 23485 | 22040–23840 | 1.10x | 4482 | 1.82x | 0 | yes |
| rows-clear | 1 | vide | 21391 | 20265–22557 | 1.01x | 1621 | 0.66x | 0 | yes |
| rows-create-1000 | 1 | plain | 116741 | 111215–118324 | 1.00x | 5186 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 177122 | 171801–182287 | 1.52x | 19776 | 3.81x | 1 | yes |
| rows-create-1000 | 1 | compose | 130075 | 126505–132190 | 1.11x | 5093 | 0.98x | 2 | yes |
| rows-create-1000 | 1 | fusion | 201349 | 196811–212049 | 1.72x | 11017 | 2.12x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 207946 | 198668–212455 | 1.78x | 14949 | 2.88x | 0 | yes |
| rows-create-1000 | 1 | react | 181433 | 176590–194023 | 1.55x | 8160 | 1.57x | 112 | yes |
| rows-create-1000 | 1 | react-reflex | 190795 | 184196–193952 | 1.63x | 9037 | 1.74x | 35 | yes |
| rows-create-1000 | 1 | react-upstream | 177528 | 175200–182324 | 1.52x | 7919 | 1.53x | 0 | yes |
| rows-create-1000 | 1 | roact | 150292 | 142782–168553 | 1.29x | 16697 | 3.22x | 0 | yes |
| rows-create-1000 | 1 | seam | 161689 | 140716–171680 | 1.39x | 23677 | 4.57x | 0 | yes |
| rows-create-1000 | 1 | signals | 126163 | 115024–128707 | 1.08x | 9056 | 1.75x | 8 | yes |
| rows-create-1000 | 1 | vide | 136130 | 131671–154849 | 1.17x | 4956 | 0.96x | 0 | yes |
| rows-create-10000 | 1 | plain | 1400147 | 1363526–1496855 | 1.00x | 49704 | 1.00x | 1 | yes |
| rows-create-10000 | 1 | blend | 2023216 | 1992973–2037409 | 1.45x | 192955 | 3.88x | 1 | yes |
| rows-create-10000 | 1 | compose | 1589369 | 1516856–1672445 | 1.14x | 48590 | 0.98x | 0 | yes |
| rows-create-10000 | 1 | fusion | 6652958 | 6531484–6796707 | 4.75x | 105524 | 2.12x | 1 | yes |
| rows-create-10000 | 1 | fusion-charm | 6485985 | 6479755–6730598 | 4.63x | 144523 | 2.91x | 0 | yes |
| rows-create-10000 | 1 | react | 5425231 | 5343504–5508090 | 3.87x | 76977 | 1.55x | 88 | yes |
| rows-create-10000 | 1 | react-reflex | 5579976 | 5577884–5655600 | 3.99x | 85908 | 1.73x | 479 | yes |
| rows-create-10000 | 1 | react-upstream | 5454759 | 5447774–5542536 | 3.90x | 77870 | 1.57x | 584 | yes |
| rows-create-10000 | 1 | roact | 1734393 | 1624962–1863839 | 1.24x | 165618 | 3.33x | 1 | yes |
| rows-create-10000 | 1 | seam | 1858596 | 1843550–1938511 | 1.33x | 234850 | 4.72x | 12 | yes |
| rows-create-10000 | 1 | signals | 1458845 | 1437387–1596588 | 1.04x | 89236 | 1.80x | 4 | yes |
| rows-create-10000 | 1 | vide | 1489770 | 1475020–1681641 | 1.06x | 48475 | 0.98x | 0 | yes |
| rows-remove-one | 1 | plain | 1100 | 709–1212 | 1.00x | 5231 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1304 | 1111–1327 | 1.19x | 19816 | 3.79x | 1 | yes |
| rows-remove-one | 1 | compose | 900 | 700–1018 | 0.82x | 5139 | 0.98x | 18 | yes |
| rows-remove-one | 1 | fusion (workaround) | 63150 | 61994–65285 | 57.41x | 11441 | 2.19x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 61777 | 61221–65443 | 56.16x | 15369 | 2.94x | 1 | yes |
| rows-remove-one | 1 | react | 37361 | 25185–42694 | 33.96x | 15724 | 3.01x | 16 | yes |
| rows-remove-one | 1 | react-reflex | 31788 | 22931–44243 | 28.90x | 16595 | 3.17x | 27 | yes |
| rows-remove-one | 1 | react-upstream | 25459 | 19860–30818 | 23.14x | 15485 | 2.96x | 8 | yes |
| rows-remove-one | 1 | roact | 17062 | 16149–18232 | 15.51x | 16781 | 3.21x | 0 | yes |
| rows-remove-one | 1 | seam | 6523 | 6035–6800 | 5.93x | 23686 | 4.53x | 0 | yes |
| rows-remove-one | 1 | signals | 1500 | 1100–1606 | 1.36x | 9093 | 1.74x | 1 | yes |
| rows-remove-one | 1 | vide | 1000 | 900–1228 | 0.91x | 5017 | 0.96x | 1 | yes |
| rows-swap | 1 | plain | 439 | 300–513 | 1.00x | 4606 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 700 | 700–900 | 1.59x | 18759 | 4.07x | 1 | yes |
| rows-swap | 1 | compose | 200 | 200–304 | 0.46x | 4626 | 1.00x | 3 | yes |
| rows-swap | 1 | fusion | 59635 | 59438–63977 | 135.84x | 10023 | 2.18x | 0 | yes |
| rows-swap | 1 | fusion-charm | 59057 | 57996–59453 | 134.53x | 13950 | 3.03x | 1 | yes |
| rows-swap | 1 | react | 58920 | 53773–79091 | 134.21x | 15119 | 3.28x | 16 | yes |
| rows-swap | 1 | react-reflex | 67268 | 66601–84649 | 153.23x | 16220 | 3.52x | 74 | yes |
| rows-swap | 1 | react-upstream | 61810 | 55115–93579 | 140.80x | 15447 | 3.35x | 31 | yes |
| rows-swap | 1 | roact | 16439 | 14441–40448 | 37.45x | 16737 | 3.63x | 0 | yes |
| rows-swap | 1 | seam | 6107 | 4800–6451 | 13.91x | 23203 | 5.04x | 7 | yes |
| rows-swap | 1 | signals | 500 | 400–705 | 1.14x | 8617 | 1.87x | 0 | yes |
| rows-swap | 1 | vide | 100 | 0–300 | 0.23x | 4516 | 0.98x | 0 | yes |
| rows-update-every-10th | 1 | plain | 2715 | 2525–2811 | 1.00x | 4251 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 2700 | 2515–2711 | 0.99x | 18839 | 4.43x | 1 | yes |
| rows-update-every-10th | 1 | compose | 2624 | 2609–2719 | 0.97x | 4190 | 0.99x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 2700 | 2507–2802 | 0.99x | 10075 | 2.37x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 3023 | 2998–3804 | 1.11x | 14004 | 3.29x | 0 | yes |
| rows-update-every-10th | 1 | react | 2905 | 2700–3050 | 1.07x | 7440 | 1.75x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 5603 | 4108–5825 | 2.06x | 8324 | 1.96x | 68 | yes |
| rows-update-every-10th | 1 | react-upstream | 2807 | 2600–3000 | 1.03x | 7432 | 1.75x | 32 | yes |
| rows-update-every-10th | 1 | roact | 2800 | 2603–2808 | 1.03x | 16195 | 3.81x | 0 | yes |
| rows-update-every-10th | 1 | seam | 5617 | 5111–6415 | 2.07x | 23756 | 5.59x | 1 | yes |
| rows-update-every-10th | 1 | signals | 2922 | 2704–3110 | 1.08x | 8857 | 2.08x | 1 | yes |
| rows-update-every-10th | 1 | vide | 2700 | 2538–2701 | 0.99x | 4652 | 1.09x | 1 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.

The shared columns use only the workloads that every lane measured: 24 for time (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`) and 23 for heap (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `status-panel`, `scene-3d`, `derived-fan-in-1000`, `filter-as-you-type`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 1.67x | 8.51x | 1.61x | 9.12x |
| compose | 30 | 1.32x | 2.63x | 1.29x | 2.60x |
| fusion | 30 | 4.26x | 5.08x | 3.89x | 5.27x |
| fusion-charm | 30 | 4.43x | 5.77x | 4.04x | 6.93x |
| react | 29 | 3.17x | 4.14x | 3.17x | 4.26x |
| react-reflex | 29 | 3.75x | 5.79x | 3.75x | 8.56x |
| react-upstream | 29 | 3.18x | 4.27x | 3.18x | 4.55x |
| roact | 29 | 2.05x | 4.29x | 2.05x | 5.05x |
| seam | 30 | 2.68x | 8.90x | 2.57x | 9.84x |
| signals | 29 | 1.33x | 2.21x | 1.33x | 2.02x |
| vide | 30 | 1.33x | 2.36x | 1.29x | 2.39x |
