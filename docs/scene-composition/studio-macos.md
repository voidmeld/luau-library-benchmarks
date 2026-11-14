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
| Harness revision | `e68a2ed` |
| Date | 2026-11-14 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 601 | 500–716 | 1.00x | 49 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 721 | 601–932 | 1.20x | 765 | 15.61x | 0 | yes |
| update-leaf | 20 | compose | 1022 | 543–1220 | 1.70x | 93 | 1.90x | 1 | yes |
| update-leaf | 20 | fusion | 810 | 729–1316 | 1.35x | 60 | 1.22x | 9 | yes |
| update-leaf | 20 | fusion-charm | 927 | 600–1829 | 1.54x | 53 | 1.08x | 0 | yes |
| update-leaf | 20 | react | 607 | 414–869 | 1.01x | 347 | 7.08x | 0 | yes |
| update-leaf | 20 | react-reflex | 612 | 506–1281 | 1.02x | 293 | 5.98x | 0 | yes |
| update-leaf | 20 | react-upstream | 953 | 722–1669 | 1.59x | 292 | 5.96x | 0 | yes |
| update-leaf | 20 | roact | 827 | 628–1154 | 1.38x | 466 | 9.51x | 1 | yes |
| update-leaf | 20 | seam | 934 | 808–1517 | 1.55x | 33 | 0.67x | 0 | yes |
| update-leaf | 20 | signals | 1000 | 730–1132 | 1.66x | 50 | 1.02x | 0 | yes |
| update-leaf | 20 | vide | 707 | 473–1355 | 1.18x | 0 | 0.02x | 0 | yes |
| update-batched | 20 | plain | 5390 | 4988–5582 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 10776 | 10516–11213 | 2.00x | 916 | 43.62x | 0 | yes |
| update-batched | 20 | compose | 6921 | 6676–7099 | 1.28x | 408 | 19.43x | 10 | yes |
| update-batched | 20 | fusion | 20943 | 20228–21206 | 3.89x | 500 | 23.81x | 0 | yes |
| update-batched | 20 | fusion-charm | 36294 | 35021–38871 | 6.73x | 1101 | 52.43x | 0 | yes |
| update-batched | 20 | react | 8115 | 7787–8723 | 1.51x | 541 | 25.76x | 1 | yes |
| update-batched | 20 | react-reflex | 20335 | 18988–21048 | 3.77x | 802 | 38.19x | 25 | yes |
| update-batched | 20 | react-upstream | 8054 | 7709–8436 | 1.49x | 477 | 22.71x | 8 | yes |
| update-batched | 20 | roact | 8318 | 8011–8511 | 1.54x | 867 | 41.29x | 0 | yes |
| update-batched | 20 | seam | 13616 | 11123–13919 | 2.53x | 1841 | 87.67x | 8 | yes |
| update-batched | 20 | signals | 9438 | 9109–9820 | 1.75x | 597 | 28.43x | 0 | yes |
| update-batched | 20 | vide | 8743 | 7911–8927 | 1.62x | 336 | 16.00x | 0 | yes |
| update-repeated | 10 | plain | 100 | 100–150 | 1.00x | 1 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3368 | 3330–3514 | 33.67x | 8 | 8.00x | 1 | yes |
| update-repeated | 10 | compose | 400 | 100–400 | 4.00x | 6 | 6.00x | 2 | yes |
| update-repeated | 10 | fusion | 24908 | 24291–25530 | 249.08x | 5 | 5.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1264 | 1026–1343 | 12.64x | 7 | 7.00x | 1 | yes |
| update-repeated | 10 | react | 7101 | 6900–7510 | 71.01x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | react-reflex | 468 | 400–642 | 4.68x | 4 | 4.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7300 | 7120–7510 | 73.00x | 1 | 1.00x | 0 | yes |
| update-repeated | 10 | roact | 5099 | 4900–5335 | 50.99x | 0 | 1.00x | 0 | yes |
| update-repeated | 10 | seam | 1412 | 1317–1537 | 14.12x | 11 | 11.00x | 1 | yes |
| update-repeated | 10 | signals | 882 | 650–1016 | 8.81x | 4 | 4.00x | 0 | yes |
| update-repeated | 10 | vide | 352 | 310–834 | 3.52x | 11 | 11.00x | 8 | yes |
| branch-swap | 20 | plain | 11946 | 11775–12578 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 16528 | 15536–17085 | 1.38x | 35 | 17.50x | 8 | yes |
| branch-swap | 20 | compose | 13218 | 12959–13865 | 1.11x | 16 | 8.00x | 10 | yes |
| branch-swap | 20 | fusion | 14200 | 13533–14629 | 1.19x | 5 | 2.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 13777 | 13228–14342 | 1.15x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 16178 | 15416–16570 | 1.35x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 17072 | 16236–17224 | 1.43x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 16361 | 15792–16772 | 1.37x | 19 | 9.50x | 1 | yes |
| branch-swap | 20 | roact | 13740 | 13605–14157 | 1.15x | 23 | 11.50x | 14 | yes |
| branch-swap | 20 | seam | 13741 | 13328–14265 | 1.15x | 20 | 10.00x | 9 | yes |
| branch-swap | 20 | signals | 12262 | 12042–13003 | 1.03x | 5 | 2.50x | 8 | yes |
| branch-swap | 20 | vide | 13994 | 13122–14938 | 1.17x | 13 | 6.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2576 | 2254–2762 | 1.00x | 65 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4900 | 4711–5079 | 1.90x | 1694 | 26.06x | 0 | yes |
| keyed-prepend | 10 | compose | 4448 | 4301–4598 | 1.73x | 568 | 8.74x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 23212 | 22463–24258 | 9.01x | 1532 | 23.57x | 2 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 22767 | 22696–22833 | 8.84x | 1502 | 23.11x | 1 | yes |
| keyed-prepend | 10 | react | 16025 | 15459–16809 | 6.22x | 785 | 12.08x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16721 | 15745–17019 | 6.49x | 778 | 11.97x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16130 | 16116–16430 | 6.26x | 785 | 12.08x | 0 | yes |
| keyed-prepend | 10 | roact | 6802 | 6303–7207 | 2.64x | 357 | 5.49x | 0 | yes |
| keyed-prepend | 10 | seam | 11313 | 11184–11705 | 4.39x | 2412 | 37.11x | 0 | yes |
| keyed-prepend | 10 | signals | 2552 | 2305–2702 | 0.99x | 66 | 1.02x | 1 | yes |
| keyed-prepend | 10 | vide | 5020 | 4705–5292 | 1.95x | 643 | 9.89x | 0 | yes |
| keyed-insert | 10 | plain | 1754 | 1610–1847 | 1.00x | 64 | 1.00x | 1 | yes |
| keyed-insert | 10 | blend | 3800 | 3700–4214 | 2.17x | 1694 | 26.47x | 1 | yes |
| keyed-insert | 10 | compose | 2923 | 2768–3406 | 1.67x | 560 | 8.75x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 19714 | 17502–20724 | 11.24x | 1516 | 23.69x | 0 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 17710 | 16605–18530 | 10.09x | 1534 | 23.97x | 9 | yes |
| keyed-insert | 10 | react | 13715 | 13504–14009 | 7.82x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13615 | 13233–14024 | 7.76x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13770 | 12916–14938 | 7.85x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 5601 | 5510–5833 | 3.19x | 365 | 5.70x | 9 | yes |
| keyed-insert | 10 | seam | 10300 | 9556–11138 | 5.87x | 2420 | 37.81x | 0 | yes |
| keyed-insert | 10 | signals | 1664 | 1587–1812 | 0.95x | 66 | 1.03x | 1 | yes |
| keyed-insert | 10 | vide | 3524 | 3464–3820 | 2.01x | 635 | 9.92x | 0 | yes |
| keyed-shuffle | 10 | plain | 1800 | 1560–1944 | 1.00x | 116 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3020 | 2760–3371 | 1.68x | 1640 | 14.14x | 1 | yes |
| keyed-shuffle | 10 | compose | 2860 | 2853–3146 | 1.59x | 563 | 4.85x | 9 | yes |
| keyed-shuffle | 10 | fusion | 18512 | 17949–19268 | 10.28x | 1384 | 11.93x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 17542 | 16805–17620 | 9.75x | 1394 | 12.02x | 0 | yes |
| keyed-shuffle | 10 | react | 27204 | 24624–27820 | 15.11x | 784 | 6.76x | 1 | yes |
| keyed-shuffle | 10 | react-reflex | 28433 | 27469–28774 | 15.80x | 776 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27596 | 26316–27752 | 15.33x | 839 | 7.23x | 8 | yes |
| keyed-shuffle | 10 | roact | 5600 | 5462–6016 | 3.11x | 361 | 3.11x | 0 | yes |
| keyed-shuffle | 10 | seam | 9540 | 8918–10019 | 5.30x | 2423 | 20.89x | 0 | yes |
| keyed-shuffle | 10 | signals | 1904 | 1572–2138 | 1.06x | 118 | 1.02x | 0 | yes |
| keyed-shuffle | 10 | vide | 3708 | 3270–3900 | 2.06x | 670 | 5.78x | 0 | yes |
| events | 1 | plain | 998 | 409–1848 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | blend | 1484 | 928–1529 | 1.49x | 9 | 9.00x | 1 | yes |
| events | 1 | compose | 1131 | 1076–1275 | 1.13x | 3 | 3.00x | 2 | yes |
| events | 1 | fusion | 1209 | 900–1736 | 1.21x | 2 | 2.00x | 1 | yes |
| events | 1 | fusion-charm | 1227 | 982–1506 | 1.23x | 1 | 1.00x | 0 | yes |
| events | 1 | react | 1222 | 800–1952 | 1.22x | 1 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 1274 | 1010–1841 | 1.28x | 0 | 1.00x | 0 | yes |
| events | 1 | react-upstream | 1203 | 1057–1600 | 1.21x | 1 | 1.00x | 0 | yes |
| events | 1 | roact | 1036 | 896–1114 | 1.04x | 1 | 1.00x | 0 | yes |
| events | 1 | seam | 1099 | 883–1300 | 1.10x | 1 | 1.00x | 0 | yes |
| events | 1 | signals | 1008 | 842–1716 | 1.01x | 2 | 2.00x | 0 | yes |
| events | 1 | vide | 1292 | 762–1564 | 1.29x | 2 | 2.00x | 0 | yes |
| animate-many | 1 | plain | 2347 | 1600–2627 | 1.00x | 72 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 10803 | 9819–11051 | 4.60x | 1778 | 24.69x | 0 | yes |
| animate-many | 1 | compose | 5905 | 5377–6624 | 2.52x | 655 | 9.10x | 12 | yes |
| animate-many | 1 | fusion | 103763 | 102872–104577 | 44.21x | 1128 | 15.67x | 0 | yes |
| animate-many | 1 | fusion-charm | 104420 | 102779–105328 | 44.49x | 1129 | 15.68x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20100 | 19705–21108 | 8.56x | 2905 | 40.35x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 7453 | 7402–7907 | 3.18x | 392 | 5.44x | 0 | yes |
| status-panel | 10 | plain | 800 | 500–978 | 1.00x | 22 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1212 | 766–1565 | 1.51x | 92 | 4.18x | 1 | yes |
| status-panel | 10 | compose | 1158 | 1100–1342 | 1.45x | 55 | 2.50x | 2 | yes |
| status-panel | 10 | fusion | 1500 | 1350–1705 | 1.88x | 78 | 3.55x | 0 | yes |
| status-panel | 10 | fusion-charm | 1730 | 1534–1828 | 2.16x | 84 | 3.82x | 1 | yes |
| status-panel | 10 | react | 1900 | 1724–2468 | 2.38x | 49 | 2.23x | 0 | yes |
| status-panel | 10 | react-reflex | 2006 | 1919–2144 | 2.51x | 59 | 2.68x | 0 | yes |
| status-panel | 10 | react-upstream | 2100 | 1787–2224 | 2.62x | 57 | 2.59x | 0 | yes |
| status-panel | 10 | roact | 1061 | 962–1162 | 1.33x | 37 | 1.68x | 0 | yes |
| status-panel | 10 | seam | 1821 | 1598–2300 | 2.28x | 155 | 7.05x | 1 | yes |
| status-panel | 10 | signals | 809 | 600–1000 | 1.01x | 30 | 1.36x | 0 | yes |
| status-panel | 10 | vide | 1220 | 956–1414 | 1.53x | 47 | 2.14x | 0 | yes |
| scene-3d | 10 | plain | 2516 | 2350–2588 | 1.00x | 3 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4516 | 4441–4701 | 1.80x | 550 | 183.33x | 0 | yes |
| scene-3d | 10 | compose | 2900 | 2862–3208 | 1.15x | 195 | 65.00x | 9 | yes |
| scene-3d | 10 | fusion | 33969 | 32742–34755 | 13.50x | 520 | 173.33x | 1 | yes |
| scene-3d | 10 | fusion-charm | 31660 | 30285–32756 | 12.58x | 523 | 174.33x | 0 | yes |
| scene-3d | 10 | react | 3400 | 3201–3654 | 1.35x | 222 | 74.00x | 0 | yes |
| scene-3d | 10 | react-reflex | 3220 | 2835–3539 | 1.28x | 217 | 72.33x | 1 | yes |
| scene-3d | 10 | react-upstream | 3565 | 3200–4082 | 1.42x | 223 | 74.33x | 0 | yes |
| scene-3d | 10 | roact | 3330 | 3272–3424 | 1.32x | 574 | 191.33x | 8 | yes |
| scene-3d | 10 | seam | 9001 | 8007–9287 | 3.58x | 1755 | 585.00x | 1 | yes |
| scene-3d | 10 | signals | 5901 | 5603–6119 | 2.35x | 675 | 225.00x | 1 | yes |
| scene-3d | 10 | vide | 3856 | 3702–4132 | 1.53x | 211 | 70.33x | 0 | yes |
| derived-diamond | 3 | plain | 100 | 100–122 | 1.00x | 2 | 1.00x | 1 | yes |
| derived-diamond | 3 | blend | 100 | 100–125 | 1.00x | 20 | 10.00x | 0 | yes |
| derived-diamond | 3 | compose | 100 | 100–153 | 1.00x | 10 | 5.00x | 1 | yes |
| derived-diamond | 3 | fusion | 100 | 100–140 | 1.00x | 9 | 4.50x | 8 | yes |
| derived-diamond | 3 | fusion-charm | 132 | 100–152 | 1.32x | 11 | 5.50x | 0 | yes |
| derived-diamond | 3 | react | 303 | 200–466 | 3.03x | 6 | 3.00x | 2 | yes |
| derived-diamond | 3 | react-reflex | 350 | 200–353 | 3.50x | 20 | 10.00x | 0 | yes |
| derived-diamond | 3 | react-upstream | 267 | 200–387 | 2.67x | 0 | 0.50x | 0 | yes |
| derived-diamond | 3 | roact | 133 | 100–150 | 1.33x | 0 | 0.50x | 0 | yes |
| derived-diamond | 3 | seam | 100 | 100–150 | 1.00x | 21 | 10.50x | 1 | yes |
| derived-diamond | 3 | signals | 100 | 100–114 | 1.00x | 8 | 4.00x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 100–150 | 1.00x | 5 | 2.50x | 0 | yes |
| derived-chain-100 | 3 | plain | 100 | 100–100 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | 156 | 150–200 | 1.56x | 345 | 86.25x | 1 | yes |
| derived-chain-100 | 3 | compose | 184 | 150–204 | 1.84x | 132 | 33.00x | 2 | yes |
| derived-chain-100 | 3 | fusion | 925 | 850–971 | 9.25x | 129 | 32.25x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 825 | 802–875 | 8.25x | 139 | 34.75x | 1 | yes |
| derived-chain-100 | 3 | react | 605 | 567–733 | 6.05x | 122 | 30.50x | 8 | yes |
| derived-chain-100 | 3 | react-reflex | 747 | 734–833 | 7.47x | 332 | 83.00x | 12 | yes |
| derived-chain-100 | 3 | react-upstream | 633 | 568–702 | 6.33x | 106 | 26.50x | 0 | yes |
| derived-chain-100 | 3 | roact | 128 | 100–182 | 1.28x | 8 | 2.00x | 1 | yes |
| derived-chain-100 | 3 | seam | 624 | 550–650 | 6.25x | 281 | 70.25x | 0 | yes |
| derived-chain-100 | 3 | signals | 175 | 100–226 | 1.75x | 175 | 43.75x | 0 | yes |
| derived-chain-100 | 3 | vide | 152 | 125–226 | 1.51x | 94 | 23.50x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–159 | 1.00x | 26 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 176 | 125–225 | 1.75x | 1505 | 57.88x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 227 | 208–277 | 2.27x | 687 | 26.42x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 2034 | 1911–2107 | 20.34x | 890 | 34.23x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2300 | 2167–2322 | 23.00x | 2813 | 108.19x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2751 | 1900–3400 | 27.51x | 644 | 24.77x | 42 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 13112 | 10912–15833 | 131.12x | 5708 | 219.54x | 85 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2504 | 1852–2960 | 25.04x | 645 | 24.81x | 42 | yes |
| derived-fan-in-1000 | 3 | roact | 500 | 300–600 | 5.00x | 102 | 3.92x | 1 | yes |
| derived-fan-in-1000 | 3 | seam | 2554 | 2450–2803 | 25.54x | 2948 | 113.38x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 675 | 575–750 | 6.75x | 1213 | 46.65x | 7 | yes |
| derived-fan-in-1000 | 3 | vide | 500 | 427–605 | 5.00x | 526 | 20.23x | 0 | yes |
| filter-as-you-type | 1 | plain | 6823 | 6408–7542 | 1.00x | 40 | 1.00x | 1 | yes |
| filter-as-you-type | 1 | blend | 17215 | 16803–18132 | 2.52x | 3001 | 75.03x | 0 | yes |
| filter-as-you-type | 1 | compose | 10211 | 9836–10821 | 1.50x | 842 | 21.05x | 18 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 26812 | 25173–31168 | 3.93x | 2457 | 61.42x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26418 | 22837–29833 | 3.87x | 2451 | 61.27x | 1 | yes |
| filter-as-you-type | 1 | react | 30337 | 30094–31420 | 4.45x | 11 | 0.28x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 30185 | 29943–32675 | 4.42x | 1159 | 28.98x | 0 | yes |
| filter-as-you-type | 1 | react-upstream | 30510 | 28719–32116 | 4.47x | 3 | 0.07x | 0 | yes |
| filter-as-you-type | 1 | roact | 11421 | 11012–11620 | 1.67x | 492 | 12.30x | 1 | yes |
| filter-as-you-type | 1 | seam | 24250 | 21053–27813 | 3.55x | 3909 | 97.72x | 0 | yes |
| filter-as-you-type | 1 | signals | 7329 | 7102–7661 | 1.07x | 52 | 1.30x | 1 | yes |
| filter-as-you-type | 1 | vide | 10314 | 9715–10640 | 1.51x | 967 | 24.18x | 8 | yes |
| theme-propagation | 3 | plain | 46946 | 46550–49539 | 1.00x | 49 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 47118 | 46018–47542 | 1.00x | 2070 | 42.24x | 1 | yes |
| theme-propagation | 3 | compose | 50762 | 49650–52763 | 1.08x | 580 | 11.84x | 2 | yes |
| theme-propagation | 3 | fusion | 52373 | 51240–54468 | 1.12x | 875 | 17.86x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 53362 | 50227–53860 | 1.14x | 877 | 17.90x | 0 | yes |
| theme-propagation | 3 | react | 54054 | 52668–54853 | 1.15x | 2028 | 41.39x | 0 | yes |
| theme-propagation | 3 | react-reflex | 48616 | 45180–50057 | 1.04x | 2029 | 41.41x | 0 | yes |
| theme-propagation | 3 | react-upstream | 53352 | 52346–53747 | 1.14x | 2028 | 41.39x | 0 | yes |
| theme-propagation | 3 | roact | 49872 | 47315–51421 | 1.06x | 3278 | 66.90x | 0 | yes |
| theme-propagation | 3 | seam | 45541 | 45280–47855 | 0.97x | 3478 | 70.98x | 1 | yes |
| theme-propagation | 3 | signals | 51440 | 49929–51942 | 1.10x | 905 | 18.47x | 1 | yes |
| theme-propagation | 3 | vide | 51740 | 50627–54262 | 1.10x | 592 | 12.08x | 0 | yes |
| hud-per-frame | 1 | plain | 2014 | 1821–2601 | 1.00x | 7 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 3782 | 3399–4398 | 1.88x | 76 | 10.79x | 4 | yes |
| hud-per-frame | 1 | compose | 2602 | 2508–2676 | 1.29x | 30 | 4.29x | 2 | yes |
| hud-per-frame | 1 | fusion | 9192 | 8876–9241 | 4.56x | 50 | 7.21x | 1 | yes |
| hud-per-frame | 1 | fusion-charm | 11861 | 10903–11870 | 5.89x | 95 | 13.57x | 4 | yes |
| hud-per-frame | 1 | react | 3518 | 3241–3866 | 1.75x | 44 | 6.29x | 4 | yes |
| hud-per-frame | 1 | react-reflex | 5351 | 4603–5630 | 2.66x | 55 | 7.86x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 2796 | 2377–3005 | 1.39x | 30 | 4.29x | 0 | yes |
| hud-per-frame | 1 | roact | 2956 | 2281–4008 | 1.47x | 70 | 9.93x | 4 | yes |
| hud-per-frame | 1 | seam | 6112 | 5339–6258 | 3.03x | 170 | 24.21x | 0 | yes |
| hud-per-frame | 1 | signals | 3921 | 3776–4564 | 1.95x | 66 | 9.43x | 0 | yes |
| hud-per-frame | 1 | vide | 3989 | 3966–4223 | 1.98x | 26 | 3.71x | 1 | yes |
| teardown-under-load | 1 | plain | 45237 | 40746–47095 | 1.00x | 4 | 1.00x | 8 | yes |
| teardown-under-load | 1 | blend | 67950 | 65186–74032 | 1.50x | 7 | 1.75x | 0 | yes |
| teardown-under-load | 1 | compose | 49989 | 48456–54762 | 1.11x | 8 | 2.00x | 2 | yes |
| teardown-under-load | 1 | fusion | 74237 | 72800–78796 | 1.64x | 5 | 1.25x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 74434 | 71081–79667 | 1.65x | 7 | 1.75x | 0 | yes |
| teardown-under-load | 1 | react | 76342 | 72003–80423 | 1.69x | 1070 | 267.50x | 1 | yes |
| teardown-under-load | 1 | react-reflex | 75663 | 72667–79093 | 1.67x | 1087 | 271.75x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 72413 | 71416–74548 | 1.60x | 1077 | 269.25x | 0 | yes |
| teardown-under-load | 1 | roact | 61393 | 52734–61894 | 1.36x | 71 | 17.75x | 0 | yes |
| teardown-under-load | 1 | seam | 70401 | 59441–73179 | 1.56x | 8 | 2.00x | 6 | yes |
| teardown-under-load | 1 | signals | 54237 | 50665–56613 | 1.20x | 6 | 1.50x | 1 | yes |
| teardown-under-load | 1 | vide | 57837 | 51236–60699 | 1.28x | 13 | 3.25x | 0 | yes |
| open-close-retention | 1 | plain | 63319 | 63180–63952 | 1.00x | 12 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 119860 | 117039–120252 | 1.89x | 7 | 0.58x | 8 | yes |
| open-close-retention | 1 | compose | 82020 | 81954–83545 | 1.30x | 8 | 0.67x | 2 | yes |
| open-close-retention | 1 | fusion | 133100 | 132344–134174 | 2.10x | 12 | 1.00x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 135225 | 134066–137587 | 2.14x | 7 | 0.58x | 0 | yes |
| open-close-retention | 1 | react | 115878 | 114227–115903 | 1.83x | 268 | 22.38x | 3 | yes |
| open-close-retention | 1 | react-reflex | 120308 | 119652–120381 | 1.90x | 273 | 22.75x | 0 | yes |
| open-close-retention | 1 | react-upstream | 116262 | 114001–116603 | 1.84x | 268 | 22.33x | 0 | yes |
| open-close-retention | 1 | roact | 95850 | 95370–98551 | 1.51x | 23 | 1.92x | 0 | yes |
| open-close-retention | 1 | seam | 114822 | 113450–118146 | 1.81x | 9 | 0.75x | 8 | yes |
| open-close-retention | 1 | signals | 83217 | 81677–83629 | 1.31x | 6 | 0.50x | 0 | yes |
| open-close-retention | 1 | vide | 89466 | 88754–89981 | 1.41x | 5 | 0.42x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7609 | 7143–7712 | 1.00x | 51 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 21611 | 20066–22620 | 2.84x | 817 | 16.02x | 9 | yes |
| tree-expand-collapse | 1 | compose | 12092 | 11733–12312 | 1.59x | 72 | 1.41x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24549 | 23188–27024 | 3.23x | 166 | 3.25x | 2 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23653 | 21870–27035 | 3.11x | 160 | 3.14x | 1 | yes |
| tree-expand-collapse | 1 | react | 25934 | 23627–27040 | 3.41x | 0 | 0.02x | 1 | yes |
| tree-expand-collapse | 1 | react-reflex | 25808 | 24789–27110 | 3.39x | 636 | 12.47x | 0 | yes |
| tree-expand-collapse | 1 | react-upstream | 25656 | 24629–26715 | 3.37x | 4 | 0.08x | 2 | yes |
| tree-expand-collapse | 1 | roact | 10947 | 10616–11212 | 1.44x | 32 | 0.63x | 1 | yes |
| tree-expand-collapse | 1 | seam | 25643 | 23689–28207 | 3.37x | 149 | 2.92x | 8 | yes |
| tree-expand-collapse | 1 | signals | 8204 | 8029–8511 | 1.08x | 38 | 0.75x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11619 | 11417–11819 | 1.53x | 71 | 1.39x | 1 | yes |
| form-validation | 1 | plain | 2050 | 1728–2463 | 1.00x | 13 | 1.00x | 1 | yes |
| form-validation | 1 | blend | 2890 | 2589–3558 | 1.41x | 203 | 15.62x | 0 | yes |
| form-validation | 1 | compose | 3235 | 2819–3564 | 1.58x | 92 | 7.08x | 2 | yes |
| form-validation | 1 | fusion | 4654 | 3984–5476 | 2.27x | 119 | 9.15x | 0 | yes |
| form-validation | 1 | fusion-charm | 4508 | 4349–5817 | 2.20x | 156 | 12.00x | 1 | yes |
| form-validation | 1 | react | 3764 | 3329–3929 | 1.84x | 62 | 4.77x | 0 | yes |
| form-validation | 1 | react-reflex | 4476 | 3692–5100 | 2.18x | 72 | 5.54x | 1 | yes |
| form-validation | 1 | react-upstream | 3396 | 2912–4165 | 1.66x | 61 | 4.69x | 0 | yes |
| form-validation | 1 | roact | 3365 | 3087–3777 | 1.64x | 157 | 12.08x | 0 | yes |
| form-validation | 1 | seam | 5791 | 4444–6077 | 2.82x | 357 | 27.46x | 8 | yes |
| form-validation | 1 | signals | 3208 | 3023–3720 | 1.56x | 163 | 12.54x | 1 | yes |
| form-validation | 1 | vide | 2998 | 2714–4036 | 1.46x | 52 | 4.00x | 0 | yes |
| table-sort-filter | 1 | plain | 15521 | 14425–16045 | 1.00x | 81 | 1.00x | 1 | yes |
| table-sort-filter | 1 | blend | 38166 | 34814–38918 | 2.46x | 6098 | 75.28x | 1 | yes |
| table-sort-filter | 1 | compose | 23753 | 23247–24607 | 1.53x | 1625 | 20.06x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 55414 | 52360–56529 | 3.57x | 4696 | 57.98x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 52699 | 48774–54939 | 3.40x | 4651 | 57.42x | 2 | yes |
| table-sort-filter | 1 | react | 136947 | 136439–144271 | 8.82x | 2993 | 36.95x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 137342 | 132287–147875 | 8.85x | 3000 | 37.04x | 6 | yes |
| table-sort-filter | 1 | react-upstream | 137026 | 132389–144613 | 8.83x | 2985 | 36.85x | 2 | yes |
| table-sort-filter | 1 | roact | 24117 | 23535–24570 | 1.55x | 1003 | 12.38x | 0 | yes |
| table-sort-filter | 1 | seam | 53696 | 51666–61742 | 3.46x | 7760 | 95.80x | 1 | yes |
| table-sort-filter | 1 | signals | 15818 | 15610–16613 | 1.02x | 92 | 1.14x | 0 | yes |
| table-sort-filter | 1 | vide | 24250 | 23149–24349 | 1.56x | 1915 | 23.64x | 0 | yes |
| library-load | 1 | plain | 31 | 25–34 | 1.00x | 1 | 1.00x | 7 | yes |
| library-load | 1 | blend | 770 | 716–842 | 25.22x | 466 | 466.00x | 456 | yes |
| library-load | 1 | compose | 662 | 653–690 | 21.69x | 67 | 67.00x | 64 | yes |
| library-load | 1 | fusion | 1391 | 1258–1442 | 45.53x | 255 | 255.00x | 254 | yes |
| library-load | 1 | fusion-charm | 1468 | 1394–1582 | 48.05x | 318 | 318.00x | 309 | yes |
| library-load | 1 | react | 4854 | 4603–4999 | 158.93x | 1817 | 1817.00x | 1816 | yes |
| library-load | 1 | react-reflex | 8230 | 6906–9658 | 269.47x | 1975 | 1975.00x | 1971 | yes |
| library-load | 1 | react-upstream | 5055 | 4905–5545 | 165.53x | 2003 | 2003.00x | 2001 | yes |
| library-load | 1 | roact | 432 | 337–459 | 14.13x | 152 | 152.00x | 150 | yes |
| library-load | 1 | seam | 1270 | 1254–1339 | 41.58x | 234 | 234.00x | 231 | yes |
| library-load | 1 | signals | 238 | 232–252 | 7.80x | 49 | 49.00x | 48 | yes |
| library-load | 1 | vide | 353 | 302–364 | 11.56x | 138 | 138.00x | 138 | yes |
| rows-append-1000 | 1 | plain | 91703 | 90100–104793 | 1.00x | 3648 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 150249 | 135260–163768 | 1.64x | 38874 | 10.66x | 1 | yes |
| rows-append-1000 | 1 | compose | 114335 | 105456–139676 | 1.25x | 11039 | 3.03x | 10 | yes |
| rows-append-1000 | 1 | fusion | 335329 | 330876–359163 | 3.66x | 20681 | 5.67x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 334858 | 322015–337892 | 3.65x | 28602 | 7.84x | 1 | yes |
| rows-append-1000 | 1 | react | 189811 | 183274–214631 | 2.07x | 18436 | 5.05x | 40 | yes |
| rows-append-1000 | 1 | react-reflex | 199991 | 188841–210681 | 2.18x | 20012 | 5.49x | 23 | yes |
| rows-append-1000 | 1 | react-upstream | 197283 | 175494–233318 | 2.15x | 18051 | 4.95x | 0 | yes |
| rows-append-1000 | 1 | roact | 124640 | 117254–127022 | 1.36x | 26976 | 7.39x | 8367 | yes |
| rows-append-1000 | 1 | seam | 164636 | 127654–190979 | 1.80x | 46186 | 12.66x | 4 | yes |
| rows-append-1000 | 1 | signals | 108384 | 100254–142312 | 1.18x | 17269 | 4.73x | 0 | yes |
| rows-append-1000 | 1 | vide | 115814 | 104107–118458 | 1.26x | 10432 | 2.86x | 0 | yes |
| rows-clear | 1 | plain | 17318 | 16747–17324 | 1.00x | 1252 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 35438 | 34416–36667 | 2.05x | 4161 | 3.32x | 8 | yes |
| rows-clear | 1 | compose | 24519 | 23734–26724 | 1.42x | 1886 | 1.51x | 11 | yes |
| rows-clear | 1 | fusion | 77875 | 75850–80731 | 4.50x | 3432 | 2.74x | 1 | yes |
| rows-clear | 1 | fusion-charm | 69249 | 65839–73247 | 4.00x | 7329 | 5.85x | 9 | yes |
| rows-clear | 1 | react | 25816 | 22327–26235 | 1.49x | 4480 | 3.58x | 0 | yes |
| rows-clear | 1 | react-reflex | 29229 | 28343–29522 | 1.69x | 6674 | 5.33x | 65 | yes |
| rows-clear | 1 | react-upstream | 25928 | 24124–26749 | 1.50x | 4472 | 3.57x | 1 | yes |
| rows-clear | 1 | roact | 21627 | 21040–23420 | 1.25x | 4205 | 3.36x | 0 | yes |
| rows-clear | 1 | seam | 44959 | 38119–53077 | 2.60x | 9115 | 7.28x | 8 | yes |
| rows-clear | 1 | signals | 21541 | 20418–22233 | 1.24x | 4402 | 3.52x | 1 | yes |
| rows-clear | 1 | vide | 20317 | 20181–20424 | 1.17x | 1605 | 1.28x | 1 | yes |
| rows-create-1000 | 1 | plain | 86998 | 83488–94094 | 1.00x | 1837 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 146127 | 137954–154971 | 1.68x | 19480 | 10.60x | 0 | yes |
| rows-create-1000 | 1 | compose | 104736 | 103301–124313 | 1.20x | 5595 | 3.05x | 10 | yes |
| rows-create-1000 | 1 | fusion | 174686 | 167877–194543 | 2.01x | 10635 | 5.79x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 177826 | 169489–186898 | 2.04x | 14556 | 7.92x | 0 | yes |
| rows-create-1000 | 1 | react | 185722 | 168517–203891 | 2.13x | 8654 | 4.71x | 7 | yes |
| rows-create-1000 | 1 | react-reflex | 190660 | 188666–212228 | 2.19x | 9572 | 5.21x | 64 | yes |
| rows-create-1000 | 1 | react-upstream | 183693 | 176447–186071 | 2.11x | 8638 | 4.70x | 0 | yes |
| rows-create-1000 | 1 | roact | 118471 | 110329–121917 | 1.36x | 13587 | 7.40x | 4189 | yes |
| rows-create-1000 | 1 | seam | 142852 | 133331–168446 | 1.64x | 23529 | 12.81x | 0 | yes |
| rows-create-1000 | 1 | signals | 103037 | 89157–120942 | 1.18x | 9090 | 4.95x | 9 | yes |
| rows-create-1000 | 1 | vide | 110951 | 109096–115741 | 1.28x | 4957 | 2.70x | 0 | yes |
| rows-create-10000 | 1 | plain | 1019873 | 1008503–1058510 | 1.00x | 17002 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1589491 | 1553891–1672883 | 1.56x | 189208 | 11.13x | 4 | yes |
| rows-create-10000 | 1 | compose | 1346644 | 1345413–1357506 | 1.32x | 55759 | 3.28x | 7 | yes |
| rows-create-10000 | 1 | fusion | 6209885 | 6139207–6218951 | 6.09x | 104501 | 6.15x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 6235404 | 6126063–6252852 | 6.11x | 145023 | 8.53x | 8 | yes |
| rows-create-10000 | 1 | react | 6652875 | 6644080–7014145 | 6.52x | 84583 | 4.97x | 677 | yes |
| rows-create-10000 | 1 | react-reflex | 6720269 | 6536215–6888980 | 6.59x | 95277 | 5.60x | 2142 | yes |
| rows-create-10000 | 1 | react-upstream | 6528560 | 6191249–6614067 | 6.40x | 85558 | 5.03x | 108 | yes |
| rows-create-10000 | 1 | roact | 1313500 | 1270899–1396412 | 1.29x | 134688 | 7.92x | 41256 | yes |
| rows-create-10000 | 1 | seam | 1675375 | 1592138–1729251 | 1.64x | 236658 | 13.92x | 24 | yes |
| rows-create-10000 | 1 | signals | 1231937 | 1109293–1274988 | 1.21x | 89458 | 5.26x | 0 | yes |
| rows-create-10000 | 1 | vide | 1271757 | 1206414–1475197 | 1.25x | 48527 | 2.85x | 4 | yes |
| rows-remove-one | 1 | plain | 338 | 334–367 | 1.00x | 1413 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1101 | 1001–1154 | 3.25x | 18341 | 12.98x | 0 | yes |
| rows-remove-one | 1 | compose | 833 | 767–878 | 2.46x | 4948 | 3.50x | 18 | yes |
| rows-remove-one | 1 | fusion (workaround) | 63845 | 60182–66666 | 188.70x | 10994 | 7.78x | 9 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 59170 | 55849–60403 | 174.89x | 14930 | 10.57x | 0 | yes |
| rows-remove-one | 1 | react | 16135 | 12808–17923 | 47.69x | 13177 | 9.33x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 21223 | 15807–40246 | 62.73x | 14103 | 9.98x | 48 | yes |
| rows-remove-one | 1 | react-upstream | 16115 | 13330–17007 | 47.63x | 13176 | 9.32x | 0 | yes |
| rows-remove-one | 1 | roact | 6400 | 6008–7304 | 18.92x | 13808 | 9.77x | 4193 | yes |
| rows-remove-one | 1 | seam | 5210 | 4329–6206 | 15.40x | 23096 | 16.35x | 0 | yes |
| rows-remove-one | 1 | signals | 1345 | 1268–1435 | 3.98x | 8638 | 6.11x | 0 | yes |
| rows-remove-one | 1 | vide | 1105 | 1033–1207 | 3.27x | 4554 | 3.22x | 1 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 1859 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 650 | 600–700 | 6.50x | 18810 | 10.12x | 1 | yes |
| rows-swap | 1 | compose | 233 | 200–233 | 2.33x | 5376 | 2.89x | 3 | yes |
| rows-swap | 1 | fusion | 58859 | 57789–61148 | 588.59x | 10007 | 5.38x | 0 | yes |
| rows-swap | 1 | fusion-charm | 57926 | 57349–58550 | 579.26x | 14226 | 7.65x | 9 | yes |
| rows-swap | 1 | react | 57371 | 57240–61091 | 573.71x | 9845 | 5.30x | 0 | yes |
| rows-swap | 1 | react-reflex | 61072 | 58116–62985 | 610.72x | 10834 | 5.83x | 64 | yes |
| rows-swap | 1 | react-upstream | 56876 | 55786–67425 | 568.76x | 9893 | 5.32x | 0 | yes |
| rows-swap | 1 | roact | 1770 | 1705–1867 | 17.70x | 13668 | 7.35x | 4013 | yes |
| rows-swap | 1 | seam | 4608 | 4300–5113 | 46.08x | 23560 | 12.67x | 0 | yes |
| rows-swap | 1 | signals | 467 | 334–500 | 4.67x | 9098 | 4.89x | 8 | yes |
| rows-swap | 1 | vide | 167 | 100–267 | 1.67x | 4972 | 2.67x | 1 | yes |
| rows-update-every-10th | 1 | plain | 1733 | 1709–1804 | 1.00x | 1405 | 1.00x | 9 | yes |
| rows-update-every-10th | 1 | blend | 1910 | 1752–1960 | 1.10x | 18770 | 13.36x | 0 | yes |
| rows-update-every-10th | 1 | compose | 1867 | 1805–1970 | 1.08x | 5001 | 3.56x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 2100 | 1908–2204 | 1.21x | 9999 | 7.12x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2118 | 2001–2500 | 1.22x | 13911 | 9.90x | 1 | yes |
| rows-update-every-10th | 1 | react | 1968 | 1902–2200 | 1.14x | 8615 | 6.13x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 4005 | 3654–4358 | 2.31x | 9540 | 6.79x | 72 | yes |
| rows-update-every-10th | 1 | react-upstream | 1954 | 1900–2051 | 1.13x | 8143 | 5.80x | 0 | yes |
| rows-update-every-10th | 1 | roact | 2002 | 1902–2101 | 1.15x | 13398 | 9.54x | 0 | yes |
| rows-update-every-10th | 1 | seam | 3807 | 3529–4200 | 2.20x | 23560 | 16.77x | 0 | yes |
| rows-update-every-10th | 1 | signals | 1970 | 1836–2003 | 1.14x | 8794 | 6.26x | 1 | yes |
| rows-update-every-10th | 1 | vide | 1901 | 1834–2169 | 1.10x | 4652 | 3.31x | 0 | yes |

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
| blend | 30 | 2.23x | 17.44x | 2.17x | 17.24x |
| compose | 30 | 1.66x | 6.12x | 1.63x | 6.04x |
| fusion | 30 | 6.29x | 9.42x | 5.88x | 9.26x |
| fusion-charm | 30 | 5.87x | 11.41x | 5.47x | 11.28x |
| react | 29 | 4.83x | 8.10x | 4.83x | 8.10x |
| react-reflex | 29 | 5.28x | 15.17x | 5.28x | 15.17x |
| react-upstream | 29 | 4.85x | 7.50x | 4.85x | 7.50x |
| roact | 29 | 2.25x | 6.91x | 2.25x | 6.91x |
| seam | 30 | 3.67x | 18.25x | 3.56x | 17.75x |
| signals | 29 | 1.64x | 4.54x | 1.64x | 4.54x |
| vide | 30 | 1.74x | 4.91x | 1.70x | 4.90x |
