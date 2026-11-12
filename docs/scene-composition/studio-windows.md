# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D 16-Core Processor           |
| Cores | 32 |
| Memory | 62 GiB |
| Model | Micro-Star International Co., Ltd. MS-7E47 |
| Operating system | Microsoft Windows 11 Pro 10.0.26200 |
| Roblox Studio | 0.747.0.7471481 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `fa39de9` |
| Date | 2026-11-12 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 1100 | 600–1700 | 1.00x | 57 | 1.00x | 8 | yes |
| update-leaf | 20 | blend | 2450 | 2250–2650 | 2.23x | 765 | 13.42x | 0 | yes |
| update-leaf | 20 | compose | 2600 | 2500–2873 | 2.36x | 101 | 1.77x | 2 | yes |
| update-leaf | 20 | fusion | 3100 | 2751–3500 | 2.82x | 51 | 0.89x | 1 | yes |
| update-leaf | 20 | fusion-charm | 2650 | 2600–2900 | 2.41x | 62 | 1.09x | 1 | yes |
| update-leaf | 20 | react | 2500 | 2150–2550 | 2.27x | 347 | 6.09x | 0 | yes |
| update-leaf | 20 | react-reflex | 2800 | 2450–2900 | 2.55x | 292 | 5.12x | 8 | yes |
| update-leaf | 20 | react-upstream | 2550 | 2200–2800 | 2.32x | 292 | 5.12x | 0 | yes |
| update-leaf | 20 | roact | 2500 | 2354–2750 | 2.27x | 960 | 16.84x | 1 | yes |
| update-leaf | 20 | seam | 2450 | 2050–2701 | 2.23x | 41 | 0.72x | 0 | yes |
| update-leaf | 20 | signals | 2400 | 2350–2553 | 2.18x | 50 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 2450 | 2200–2500 | 2.23x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4100 | 3950–4150 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 11300 | 11000–11920 | 2.76x | 909 | 43.29x | 1 | yes |
| update-batched | 20 | compose | 7700 | 7200–7803 | 1.88x | 408 | 19.43x | 10 | yes |
| update-batched | 20 | fusion | 21601 | 20200–23410 | 5.27x | 500 | 23.81x | 0 | yes |
| update-batched | 20 | fusion-charm | 38001 | 36109–38706 | 9.27x | 1078 | 51.33x | 0 | yes |
| update-batched | 20 | react | 8600 | 8000–8700 | 2.10x | 533 | 25.38x | 1 | yes |
| update-batched | 20 | react-reflex | 68603 | 62229–75826 | 16.73x | 783 | 37.29x | 17 | yes |
| update-batched | 20 | react-upstream | 8000 | 7700–8600 | 1.95x | 476 | 22.67x | 0 | yes |
| update-batched | 20 | roact | 8300 | 8000–8700 | 2.02x | 1162 | 55.33x | 1 | yes |
| update-batched | 20 | seam | 13600 | 13300–15100 | 3.32x | 1841 | 87.67x | 0 | yes |
| update-batched | 20 | signals | 9600 | 9100–9800 | 2.34x | 604 | 28.76x | 0 | yes |
| update-batched | 20 | vide | 8202 | 7900–8800 | 2.00x | 324 | 15.43x | 0 | yes |
| update-repeated | 10 | plain | 40 | 36–45 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 2900 | 2700–3050 | 73.29x | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 467 | 389–500 | 11.79x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 24403 | 23318–25922 | 616.74x | 12 | 6.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 980 | 940–1080 | 24.77x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react | 5300 | 4700–5500 | 133.95x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 817 | 683–983 | 20.64x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 4400 | 4300–5300 | 111.20x | 8 | 4.00x | 1 | yes |
| update-repeated | 10 | roact | 5900 | 5600–6400 | 149.11x | 7 | 3.50x | 0 | yes |
| update-repeated | 10 | seam | 1500 | 1375–1500 | 37.91x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 880 | 800–920 | 22.24x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | vide | 550 | 438–625 | 13.90x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 21502 | 20600–26501 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 31500 | 30200–35105 | 1.46x | 35 | 17.50x | 0 | yes |
| branch-swap | 20 | compose | 27900 | 27117–30003 | 1.30x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | fusion | 34018 | 30600–34886 | 1.58x | 29 | 14.50x | 1 | yes |
| branch-swap | 20 | fusion-charm | 29800 | 28200–33000 | 1.39x | 7 | 3.50x | 9 | yes |
| branch-swap | 20 | react | 32019 | 28533–35947 | 1.49x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 30600 | 28700–32905 | 1.42x | 19 | 9.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 31320 | 28902–33100 | 1.46x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | roact | 29500 | 29300–31303 | 1.37x | 12 | 6.00x | 0 | yes |
| branch-swap | 20 | seam | 28300 | 24800–30000 | 1.32x | 11 | 5.50x | 8 | yes |
| branch-swap | 20 | signals | 26700 | 25700–32900 | 1.24x | 14 | 7.00x | 1 | yes |
| branch-swap | 20 | vide | 29000 | 27511–31706 | 1.35x | 5 | 2.50x | 0 | yes |
| keyed-prepend | 10 | plain | 1733 | 1575–1804 | 1.00x | 65 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 5000 | 4500–5301 | 2.88x | 1491 | 22.94x | 0 | yes |
| keyed-prepend | 10 | compose | 4400 | 4200–4650 | 2.54x | 578 | 8.89x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 20607 | 20222–24802 | 11.89x | 1519 | 23.37x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 21800 | 18304–28638 | 12.58x | 1521 | 23.40x | 2 | yes |
| keyed-prepend | 10 | react | 12100 | 10842–13401 | 6.98x | 793 | 12.20x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 11902 | 10800–12409 | 6.87x | 785 | 12.08x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 11800 | 10603–12700 | 6.81x | 793 | 12.20x | 1 | yes |
| keyed-prepend | 10 | roact | 6300 | 6000–6600 | 3.63x | 362 | 5.57x | 0 | yes |
| keyed-prepend | 10 | seam | 12000 | 10938–14403 | 6.92x | 2455 | 37.77x | 1 | yes |
| keyed-prepend | 10 | signals | 2600 | 2450–2750 | 1.50x | 69 | 1.06x | 0 | yes |
| keyed-prepend | 10 | vide | 4900 | 4500–5100 | 2.83x | 646 | 9.94x | 0 | yes |
| keyed-insert | 10 | plain | 1200 | 1150–1250 | 1.00x | 66 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4260 | 3751–4500 | 3.55x | 1498 | 22.70x | 0 | yes |
| keyed-insert | 10 | compose | 3008 | 2950–3400 | 2.51x | 571 | 8.65x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 18400 | 17336–18700 | 15.33x | 1527 | 23.14x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 16073 | 15900–18209 | 13.39x | 1529 | 23.17x | 1 | yes |
| keyed-insert | 10 | react | 9600 | 8600–9900 | 8.00x | 811 | 12.29x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9300 | 9000–9700 | 7.75x | 867 | 13.14x | 0 | yes |
| keyed-insert | 10 | react-upstream | 10104 | 8900–10214 | 8.42x | 819 | 12.41x | 0 | yes |
| keyed-insert | 10 | roact | 5000 | 4900–5300 | 4.17x | 369 | 5.59x | 1 | yes |
| keyed-insert | 10 | seam | 10500 | 9800–10900 | 8.75x | 2447 | 37.08x | 1 | yes |
| keyed-insert | 10 | signals | 1934 | 1800–2100 | 1.61x | 69 | 1.05x | 0 | yes |
| keyed-insert | 10 | vide | 3450 | 2900–3552 | 2.88x | 638 | 9.67x | 0 | yes |
| keyed-shuffle | 10 | plain | 1080 | 1040–1186 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2650 | 2400–3050 | 2.45x | 1440 | 24.00x | 1 | yes |
| keyed-shuffle | 10 | compose | 2650 | 2600–2850 | 2.45x | 570 | 9.50x | 17 | yes |
| keyed-shuffle | 10 | fusion | 16500 | 14833–19007 | 15.28x | 1398 | 23.30x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 15626 | 13300–17400 | 14.47x | 1393 | 23.22x | 1 | yes |
| keyed-shuffle | 10 | react | 15100 | 14300–16900 | 13.98x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 15300 | 14704–15821 | 14.17x | 787 | 13.12x | 7 | yes |
| keyed-shuffle | 10 | react-upstream | 14604 | 13930–15101 | 13.52x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | roact | 4500 | 4000–4800 | 4.17x | 367 | 6.12x | 0 | yes |
| keyed-shuffle | 10 | seam | 8600 | 8090–9800 | 7.96x | 2438 | 40.63x | 0 | yes |
| keyed-shuffle | 10 | signals | 1725 | 1550–1825 | 1.60x | 61 | 1.02x | 1 | yes |
| keyed-shuffle | 10 | vide | 2976 | 2800–3900 | 2.76x | 630 | 10.50x | 0 | yes |
| events | 1 | plain | 3000 | 2400–3400 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 2800 | 2700–2800 | 0.93x | 2 | 1.00x | 1 | yes |
| events | 1 | compose | 3700 | 2300–4100 | 1.23x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 3700 | 3300–4970 | 1.23x | 1 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 3400 | 2600–4200 | 1.13x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 3617 | 2800–4800 | 1.21x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 3700 | 3303–4300 | 1.23x | 8 | 4.00x | 0 | yes |
| events | 1 | react-upstream | 3400 | 3400–3700 | 1.13x | 2 | 1.00x | 1 | yes |
| events | 1 | roact | 2700 | 2200–3100 | 0.90x | 1 | 0.50x | 0 | yes |
| events | 1 | seam | 2100 | 2000–2500 | 0.70x | 1 | 0.50x | 0 | yes |
| events | 1 | signals | 2400 | 2100–2900 | 0.80x | 1 | 0.50x | 0 | yes |
| events | 1 | vide | 3200 | 3000–4500 | 1.07x | 1 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 2850 | 2500–3050 | 1.00x | 73 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 11704 | 11319–12100 | 4.11x | 1778 | 24.36x | 0 | yes |
| animate-many | 1 | compose | 7400 | 7100–8700 | 2.60x | 655 | 8.97x | 12 | yes |
| animate-many | 1 | fusion | 76214 | 75612–77742 | 26.74x | 1128 | 15.45x | 0 | yes |
| animate-many | 1 | fusion-charm | 76456 | 76113–78346 | 26.83x | 1129 | 15.47x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 23300 | 22700–25208 | 8.18x | 2898 | 39.70x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 10200 | 9300–10702 | 3.58x | 385 | 5.27x | 0 | yes |
| status-panel | 10 | plain | 900 | 853–1056 | 1.00x | 0 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 2500 | 2450–2850 | 2.78x | 62 | 62.00x | 0 | yes |
| status-panel | 10 | compose | 2600 | 2400–2700 | 2.89x | 32 | 32.00x | 1 | yes |
| status-panel | 10 | fusion | 3000 | 2750–3300 | 3.33x | 64 | 64.00x | 1 | yes |
| status-panel | 10 | fusion-charm | 3400 | 3100–3650 | 3.78x | 70 | 70.00x | 0 | yes |
| status-panel | 10 | react | 3700 | 3600–3850 | 4.11x | 43 | 43.00x | 0 | yes |
| status-panel | 10 | react-reflex | 3650 | 3300–3800 | 4.06x | 37 | 37.00x | 0 | yes |
| status-panel | 10 | react-upstream | 3500 | 3400–3800 | 3.89x | 42 | 42.00x | 0 | yes |
| status-panel | 10 | roact | 2800 | 2000–3400 | 3.11x | 33 | 33.00x | 0 | yes |
| status-panel | 10 | seam | 3400 | 3100–3600 | 3.78x | 141 | 141.00x | 1 | yes |
| status-panel | 10 | signals | 2450 | 2350–3050 | 2.72x | 15 | 15.00x | 0 | yes |
| status-panel | 10 | vide | 2500 | 2433–2733 | 2.78x | 33 | 33.00x | 0 | yes |
| scene-3d | 10 | plain | 2133 | 1967–2200 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4800 | 4600–5000 | 2.25x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 3400 | 3000–5638 | 1.59x | 195 | 17.73x | 1 | yes |
| scene-3d | 10 | fusion | 22906 | 21100–23700 | 10.74x | 519 | 47.18x | 0 | yes |
| scene-3d | 10 | fusion-charm | 22700 | 21346–23720 | 10.64x | 524 | 47.64x | 9 | yes |
| scene-3d | 10 | react | 3750 | 3550–3950 | 1.76x | 231 | 21.00x | 7 | yes |
| scene-3d | 10 | react-reflex | 3900 | 3350–5084 | 1.83x | 224 | 20.36x | 0 | yes |
| scene-3d | 10 | react-upstream | 3550 | 3450–3800 | 1.66x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 3500 | 3300–3551 | 1.64x | 574 | 52.18x | 0 | yes |
| scene-3d | 10 | seam | 8900 | 8218–9300 | 4.17x | 1755 | 159.55x | 0 | yes |
| scene-3d | 10 | signals | 5400 | 5000–6200 | 2.53x | 681 | 61.91x | 0 | yes |
| scene-3d | 10 | vide | 4000 | 3801–4150 | 1.87x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 28 | 27–29 | 1.00x | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 163 | 150–188 | 5.84x | 20 | 4.00x | 1 | yes |
| derived-diamond | 3 | compose | 154 | 146–185 | 5.52x | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | fusion | 153 | 135–176 | 5.49x | 8 | 1.60x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 169 | 146–254 | 6.07x | 3 | 0.60x | 0 | yes |
| derived-diamond | 3 | react | 360 | 300–380 | 12.92x | 14 | 2.80x | 11 | yes |
| derived-diamond | 3 | react-reflex | 400 | 350–475 | 14.36x | 9 | 1.80x | 6 | yes |
| derived-diamond | 3 | react-upstream | 373 | 273–391 | 13.38x | 6 | 1.20x | 4 | yes |
| derived-diamond | 3 | roact | 146 | 131–177 | 5.25x | 11 | 2.20x | 3 | yes |
| derived-diamond | 3 | seam | 245 | 209–300 | 8.81x | 21 | 4.20x | 0 | yes |
| derived-diamond | 3 | signals | 169 | 112–200 | 6.06x | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | vide | 141 | 129–171 | 5.07x | 14 | 2.80x | 0 | yes |
| derived-chain-100 | 3 | plain | 38 | 36–39 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 231 | 225–269 | 6.13x | 131 | 2.30x | 2 | yes |
| derived-chain-100 | 3 | fusion | 617 | 567–650 | 16.36x | 127 | 2.23x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 575 | 488–612 | 15.25x | 129 | 2.26x | 1 | yes |
| derived-chain-100 | 3 | react | 538 | 488–562 | 14.26x | 69 | 1.21x | 4 | yes |
| derived-chain-100 | 3 | react-reflex | 520 | 480–541 | 13.79x | 72 | 1.26x | 7 | yes |
| derived-chain-100 | 3 | react-upstream | 500 | 438–638 | 13.26x | 69 | 1.21x | 11 | yes |
| derived-chain-100 | 3 | roact | 182 | 153–218 | 4.84x | 10 | 0.18x | 3 | yes |
| derived-chain-100 | 3 | seam | 940 | 880–1020 | 24.93x | 272 | 4.77x | 1 | yes |
| derived-chain-100 | 3 | signals | 260 | 240–330 | 6.90x | 174 | 3.05x | 0 | yes |
| derived-chain-100 | 3 | vide | 206 | 150–239 | 5.45x | 92 | 1.61x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 92 | 90–96 | 1.00x | 497 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 265 | 229–288 | 2.87x | 1535 | 3.09x | 1 | yes |
| derived-fan-in-1000 | 3 | compose | 362 | 338–408 | 3.92x | 688 | 1.38x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1180 | 1040–1201 | 12.78x | 881 | 1.77x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1440 | 1300–1680 | 15.60x | 2813 | 5.66x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1667 | 1467–2938 | 18.05x | 671 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 10556 | 9500–11200 | 114.34x | 5626 | 11.32x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1650 | 1600–2100 | 17.87x | 663 | 1.33x | 51 | yes |
| derived-fan-in-1000 | 3 | roact | 569 | 500–600 | 6.17x | 104 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2200 | 1900–2401 | 23.83x | 2939 | 5.91x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 826 | 762–876 | 8.94x | 1197 | 2.41x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 420 | 380–480 | 4.55x | 528 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | plain | 6308 | 6105–6500 | 1.00x | 34 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16300 | 14400–17000 | 2.58x | 2686 | 79.00x | 0 | yes |
| filter-as-you-type | 1 | compose | 10000 | 9212–10103 | 1.59x | 841 | 24.74x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 27100 | 23400–32737 | 4.30x | 2449 | 72.03x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26402 | 22300–28000 | 4.19x | 2459 | 72.32x | 2 | yes |
| filter-as-you-type | 1 | react | 15300 | 15000–16000 | 2.43x | 76 | 2.24x | 20 | yes |
| filter-as-you-type | 1 | react-reflex | 15200 | 14700–16049 | 2.41x | 830 | 24.41x | 15 | yes |
| filter-as-you-type | 1 | react-upstream | 15637 | 14800–16800 | 2.48x | 76 | 2.24x | 19 | yes |
| filter-as-you-type | 1 | roact | 11013 | 10603–11231 | 1.75x | 503 | 14.79x | 10 | yes |
| filter-as-you-type | 1 | seam | 26600 | 20201–28700 | 4.22x | 4037 | 118.74x | 1 | yes |
| filter-as-you-type | 1 | signals | 7300 | 6900–8100 | 1.16x | 36 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | vide | 10874 | 10600–13040 | 1.72x | 959 | 28.21x | 0 | yes |
| theme-propagation | 3 | plain | 106301 | 105403–122771 | 1.00x | 199 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 106000 | 105114–120083 | 1.00x | 2070 | 10.40x | 1 | yes |
| theme-propagation | 3 | compose | 120900 | 109957–133715 | 1.14x | 572 | 2.87x | 0 | yes |
| theme-propagation | 3 | fusion | 111204 | 108702–116442 | 1.05x | 867 | 4.36x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 119007 | 111520–138305 | 1.12x | 869 | 4.37x | 0 | yes |
| theme-propagation | 3 | react | 117318 | 111900–123503 | 1.10x | 2028 | 10.19x | 0 | yes |
| theme-propagation | 3 | react-reflex | 125667 | 118209–128409 | 1.18x | 2020 | 10.15x | 0 | yes |
| theme-propagation | 3 | react-upstream | 112652 | 112310–118542 | 1.06x | 2028 | 10.19x | 0 | yes |
| theme-propagation | 3 | roact | 113255 | 112409–157173 | 1.07x | 3263 | 16.40x | 1 | yes |
| theme-propagation | 3 | seam | 103223 | 102852–105139 | 0.97x | 3469 | 17.43x | 0 | yes |
| theme-propagation | 3 | signals | 112109 | 109651–134420 | 1.05x | 896 | 4.50x | 1 | yes |
| theme-propagation | 3 | vide | 122502 | 115235–127800 | 1.15x | 599 | 3.01x | 0 | yes |
| hud-per-frame | 1 | plain | 4500 | 3900–5300 | 1.00x | 23 | 1.00x | 1 | yes |
| hud-per-frame | 1 | blend | 6900 | 6000–7500 | 1.53x | 72 | 3.13x | 1 | yes |
| hud-per-frame | 1 | compose | 7000 | 6000–7600 | 1.56x | 29 | 1.26x | 0 | yes |
| hud-per-frame | 1 | fusion | 12300 | 11800–12900 | 2.73x | 54 | 2.35x | 1 | yes |
| hud-per-frame | 1 | fusion-charm | 16100 | 15600–17100 | 3.58x | 99 | 4.30x | 1 | yes |
| hud-per-frame | 1 | react | 6000 | 5600–7101 | 1.33x | 34 | 1.48x | 1 | yes |
| hud-per-frame | 1 | react-reflex | 10300 | 9100–10600 | 2.29x | 53 | 2.30x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 6200 | 5400–7700 | 1.38x | 34 | 1.48x | 0 | yes |
| hud-per-frame | 1 | roact | 6401 | 6300–6800 | 1.42x | 90 | 3.91x | 1 | yes |
| hud-per-frame | 1 | seam | 12801 | 11500–14000 | 2.84x | 169 | 7.35x | 1 | yes |
| hud-per-frame | 1 | signals | 7000 | 6000–7904 | 1.56x | 65 | 2.83x | 0 | yes |
| hud-per-frame | 1 | vide | 7400 | 6200–8601 | 1.64x | 33 | 1.43x | 8 | yes |
| teardown-under-load | 1 | plain | 41644 | 40800–42338 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 59900 | 56713–74414 | 1.44x | 6 | 1.20x | 8 | yes |
| teardown-under-load | 1 | compose | 47703 | 45400–48552 | 1.15x | 7 | 1.40x | 10 | yes |
| teardown-under-load | 1 | fusion | 75087 | 66651–80108 | 1.80x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 70628 | 69513–81212 | 1.70x | 6 | 1.20x | 0 | yes |
| teardown-under-load | 1 | react | 62546 | 58233–64800 | 1.50x | 1062 | 212.40x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 62239 | 58500–64170 | 1.49x | 1078 | 215.60x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 62701 | 58620–73628 | 1.51x | 1070 | 214.00x | 0 | yes |
| teardown-under-load | 1 | roact | 59611 | 55031–68944 | 1.43x | 78 | 15.60x | 0 | yes |
| teardown-under-load | 1 | seam | 67203 | 57219–74829 | 1.61x | 16 | 3.20x | 15 | yes |
| teardown-under-load | 1 | signals | 49800 | 47610–50985 | 1.20x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | vide | 49700 | 48906–50910 | 1.19x | 13 | 2.60x | 8 | yes |
| open-close-retention | 1 | plain | 71127 | 69139–71708 | 1.00x | 32 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 120044 | 117786–123906 | 1.69x | 13 | 0.41x | 1 | yes |
| open-close-retention | 1 | compose | 85504 | 82904–87735 | 1.20x | 15 | 0.47x | 1 | yes |
| open-close-retention | 1 | fusion | 137134 | 134757–141923 | 1.93x | 0 | 0.03x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 139429 | 138313–151477 | 1.96x | 14 | 0.44x | 8 | yes |
| open-close-retention | 1 | react | 116458 | 115390–120221 | 1.64x | 283 | 8.84x | 0 | yes |
| open-close-retention | 1 | react-reflex | 118930 | 114202–126170 | 1.67x | 284 | 8.88x | 0 | yes |
| open-close-retention | 1 | react-upstream | 117495 | 115974–118704 | 1.65x | 284 | 8.88x | 0 | yes |
| open-close-retention | 1 | roact | 110904 | 109617–114475 | 1.56x | 23 | 0.72x | 0 | yes |
| open-close-retention | 1 | seam | 134228 | 132712–138001 | 1.89x | 10 | 0.31x | 1 | yes |
| open-close-retention | 1 | signals | 84810 | 82527–87522 | 1.19x | 12 | 0.38x | 1 | yes |
| open-close-retention | 1 | vide | 90412 | 88852–92224 | 1.27x | 13 | 0.41x | 9 | yes |
| tree-expand-collapse | 1 | plain | 7400 | 7200–7600 | 1.00x | 12 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 19300 | 18400–20700 | 2.61x | 788 | 65.67x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12100 | 11501–12721 | 1.64x | 72 | 6.00x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 26400 | 24400–27900 | 3.57x | 166 | 13.83x | 2 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 24712 | 23608–28301 | 3.34x | 151 | 12.58x | 1 | yes |
| tree-expand-collapse | 1 | react | 15811 | 14900–18301 | 2.14x | 69 | 5.75x | 20 | yes |
| tree-expand-collapse | 1 | react-reflex | 15600 | 15200–15821 | 2.11x | 673 | 56.08x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 15800 | 15200–18901 | 2.14x | 61 | 5.08x | 20 | yes |
| tree-expand-collapse | 1 | roact | 11800 | 10500–13700 | 1.59x | 35 | 2.92x | 3 | yes |
| tree-expand-collapse | 1 | seam | 29316 | 27500–31367 | 3.96x | 140 | 11.67x | 0 | yes |
| tree-expand-collapse | 1 | signals | 9100 | 8813–10001 | 1.23x | 21 | 1.75x | 1 | yes |
| tree-expand-collapse | 1 | vide | 12702 | 12500–13500 | 1.72x | 71 | 5.92x | 0 | yes |
| form-validation | 1 | plain | 3550 | 3150–4550 | 1.00x | 45 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 9801 | 9500–11400 | 2.76x | 328 | 7.29x | 0 | yes |
| form-validation | 1 | compose | 10300 | 9900–14102 | 2.90x | 107 | 2.38x | 2 | yes |
| form-validation | 1 | fusion | 11600 | 10003–13603 | 3.27x | 118 | 2.62x | 0 | yes |
| form-validation | 1 | fusion-charm | 11100 | 10400–11700 | 3.13x | 155 | 3.44x | 0 | yes |
| form-validation | 1 | react | 10500 | 10000–11200 | 2.96x | 65 | 1.44x | 0 | yes |
| form-validation | 1 | react-reflex | 10900 | 10105–11300 | 3.07x | 75 | 1.67x | 1 | yes |
| form-validation | 1 | react-upstream | 9900 | 9402–10400 | 2.79x | 65 | 1.44x | 0 | yes |
| form-validation | 1 | roact | 10300 | 10102–11300 | 2.90x | 223 | 4.96x | 0 | yes |
| form-validation | 1 | seam | 10800 | 9701–12700 | 3.04x | 357 | 7.93x | 0 | yes |
| form-validation | 1 | signals | 9200 | 8700–9400 | 2.59x | 154 | 3.42x | 0 | yes |
| form-validation | 1 | vide | 8800 | 8500–9700 | 2.48x | 70 | 1.56x | 0 | yes |
| table-sort-filter | 1 | plain | 14600 | 14500–15206 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 33923 | 32821–37119 | 2.32x | 5388 | 80.42x | 8 | yes |
| table-sort-filter | 1 | compose | 25600 | 23329–26900 | 1.75x | 1640 | 24.48x | 25 | yes |
| table-sort-filter | 1 | fusion (workaround) | 58600 | 56404–68545 | 4.01x | 4695 | 70.07x | 9 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 54747 | 48914–58501 | 3.75x | 4713 | 70.34x | 1 | yes |
| table-sort-filter | 1 | react | 57924 | 54900–60801 | 3.97x | 2108 | 31.46x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 57607 | 56610–60400 | 3.95x | 2123 | 31.69x | 30 | yes |
| table-sort-filter | 1 | react-upstream | 58202 | 55810–62935 | 3.99x | 2100 | 31.34x | 19 | yes |
| table-sort-filter | 1 | roact | 23903 | 22100–26004 | 1.64x | 1015 | 15.15x | 11 | yes |
| table-sort-filter | 1 | seam | 58101 | 52207–64753 | 3.98x | 7759 | 115.81x | 1 | yes |
| table-sort-filter | 1 | signals | 17200 | 16563–20019 | 1.18x | 76 | 1.13x | 1 | yes |
| table-sort-filter | 1 | vide | 25405 | 24800–26900 | 1.74x | 1922 | 28.69x | 1 | yes |
| library-load | 1 | plain | 76 | 70–86 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 845 | 824–871 | 11.12x | 467 | 467.00x | 464 | yes |
| library-load | 1 | compose | 783 | 753–897 | 10.31x | 59 | 59.00x | 56 | yes |
| library-load | 1 | fusion | 2513 | 2240–2593 | 33.06x | 255 | 255.00x | 253 | yes |
| library-load | 1 | fusion-charm | 3037 | 2250–3420 | 39.96x | 318 | 318.00x | 316 | yes |
| library-load | 1 | react | 5932 | 5646–6341 | 78.05x | 1817 | 1817.00x | 1816 | yes |
| library-load | 1 | react-reflex | 6289 | 5875–7199 | 82.75x | 1981 | 1981.00x | 1980 | yes |
| library-load | 1 | react-upstream | 6246 | 5914–6610 | 82.18x | 1995 | 1995.00x | 1994 | yes |
| library-load | 1 | roact | 541 | 525–544 | 7.12x | 146 | 146.00x | 150 | yes |
| library-load | 1 | seam | 2128 | 1993–2284 | 28.00x | 235 | 235.00x | 232 | yes |
| library-load | 1 | signals | 302 | 281–391 | 3.97x | 33 | 33.00x | 32 | yes |
| library-load | 1 | vide | 476 | 447–495 | 6.27x | 146 | 146.00x | 138 | yes |
| rows-append-1000 | 1 | plain | 164408 | 158985–169352 | 1.00x | 6508 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 237761 | 232620–243078 | 1.45x | 38852 | 5.97x | 1 | yes |
| rows-append-1000 | 1 | compose | 184453 | 180188–190961 | 1.12x | 11016 | 1.69x | 2 | yes |
| rows-append-1000 | 1 | fusion | 333900 | 331015–364783 | 2.03x | 21002 | 3.23x | 8 | yes |
| rows-append-1000 | 1 | fusion-charm | 329945 | 325391–343638 | 2.01x | 28898 | 4.44x | 1 | yes |
| rows-append-1000 | 1 | react | 238539 | 222520–263780 | 1.45x | 23258 | 3.57x | 24 | yes |
| rows-append-1000 | 1 | react-reflex | 268814 | 245705–295309 | 1.64x | 24806 | 3.81x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 242603 | 226325–330869 | 1.48x | 22977 | 3.53x | 128 | yes |
| rows-append-1000 | 1 | roact | 231128 | 210306–270769 | 1.41x | 33134 | 5.09x | 8 | yes |
| rows-append-1000 | 1 | seam | 259005 | 207889–268444 | 1.58x | 46286 | 7.11x | 0 | yes |
| rows-append-1000 | 1 | signals | 189523 | 175271–225160 | 1.15x | 17181 | 2.64x | 8 | yes |
| rows-append-1000 | 1 | vide | 178416 | 165705–186696 | 1.09x | 10415 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 20300 | 20001–21300 | 1.00x | 1213 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 40710 | 39205–41800 | 2.01x | 4178 | 3.44x | 1 | yes |
| rows-clear | 1 | compose | 26219 | 25306–27100 | 1.29x | 1894 | 1.56x | 11 | yes |
| rows-clear | 1 | fusion | 55051 | 54500–55300 | 2.71x | 3497 | 2.88x | 0 | yes |
| rows-clear | 1 | fusion-charm | 52511 | 52101–54400 | 2.59x | 7393 | 6.09x | 1 | yes |
| rows-clear | 1 | react | 26400 | 25700–27500 | 1.30x | 4496 | 3.71x | 0 | yes |
| rows-clear | 1 | react-reflex | 29122 | 28101–30303 | 1.43x | 6497 | 5.36x | 37 | yes |
| rows-clear | 1 | react-upstream | 26900 | 26300–27902 | 1.33x | 4487 | 3.70x | 0 | yes |
| rows-clear | 1 | roact | 28402 | 28103–30704 | 1.40x | 4214 | 3.47x | 9 | yes |
| rows-clear | 1 | seam | 38326 | 34922–40507 | 1.89x | 9199 | 7.58x | 1 | yes |
| rows-clear | 1 | signals | 24606 | 22617–25500 | 1.21x | 4467 | 3.68x | 1 | yes |
| rows-clear | 1 | vide | 23100 | 22335–23903 | 1.14x | 1613 | 1.33x | 0 | yes |
| rows-create-1000 | 1 | plain | 195583 | 159831–208838 | 1.00x | 3126 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 217919 | 208303–243345 | 1.11x | 19721 | 6.31x | 0 | yes |
| rows-create-1000 | 1 | compose | 180971 | 174268–209221 | 0.93x | 5819 | 1.86x | 11 | yes |
| rows-create-1000 | 1 | fusion | 238442 | 219104–257617 | 1.22x | 10963 | 3.51x | 9 | yes |
| rows-create-1000 | 1 | fusion-charm | 240006 | 227434–257227 | 1.23x | 14805 | 4.74x | 9 | yes |
| rows-create-1000 | 1 | react | 214726 | 197800–247909 | 1.10x | 8176 | 2.62x | 23 | yes |
| rows-create-1000 | 1 | react-reflex | 221614 | 218043–268126 | 1.13x | 9074 | 2.90x | 37 | yes |
| rows-create-1000 | 1 | react-upstream | 202688 | 196500–248809 | 1.04x | 8136 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 195866 | 190012–234310 | 1.00x | 16921 | 5.41x | 0 | yes |
| rows-create-1000 | 1 | seam | 238810 | 206010–248011 | 1.22x | 23870 | 7.64x | 1 | yes |
| rows-create-1000 | 1 | signals | 179073 | 169805–193306 | 0.92x | 9106 | 2.91x | 1 | yes |
| rows-create-1000 | 1 | vide | 175213 | 164311–198314 | 0.90x | 4965 | 1.59x | 0 | yes |
| rows-create-10000 | 1 | plain | 1814140 | 1767670–1826238 | 1.00x | 29797 | 1.00x | 12 | yes |
| rows-create-10000 | 1 | blend | 2490086 | 2354333–2596032 | 1.37x | 187218 | 6.28x | 4 | yes |
| rows-create-10000 | 1 | compose | 2148498 | 2128005–2160967 | 1.18x | 55771 | 1.87x | 15 | yes |
| rows-create-10000 | 1 | fusion | 5839745 | 5593383–5885282 | 3.22x | 105034 | 3.53x | 121 | yes |
| rows-create-10000 | 1 | fusion-charm | 5897810 | 5596462–5950118 | 3.25x | 146241 | 4.91x | 926 | yes |
| rows-create-10000 | 1 | react | 3979135 | 3958312–4008397 | 2.19x | 77007 | 2.58x | 88 | yes |
| rows-create-10000 | 1 | react-reflex | 4308166 | 4176803–4319897 | 2.37x | 87386 | 2.93x | 864 | yes |
| rows-create-10000 | 1 | react-upstream | 4008170 | 3864426–4459179 | 2.21x | 78630 | 2.64x | 444 | yes |
| rows-create-10000 | 1 | roact | 2349110 | 2146748–2380903 | 1.29x | 166406 | 5.58x | 4 | yes |
| rows-create-10000 | 1 | seam | 2611256 | 2488278–2739429 | 1.44x | 235251 | 7.90x | 12 | yes |
| rows-create-10000 | 1 | signals | 2001799 | 1946616–2187576 | 1.10x | 89274 | 3.00x | 9 | yes |
| rows-create-10000 | 1 | vide | 1941758 | 1862084–2081558 | 1.07x | 48468 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 1100 | 900–1400 | 1.00x | 2740 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1600 | 1100–1600 | 1.45x | 18268 | 6.67x | 0 | yes |
| rows-remove-one | 1 | compose | 1000 | 900–1150 | 0.91x | 4941 | 1.80x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 34700 | 34059–42000 | 31.55x | 11114 | 4.06x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 34200 | 32902–47106 | 31.09x | 15050 | 5.49x | 9 | yes |
| rows-remove-one | 1 | react | 26206 | 20301–38903 | 23.82x | 15492 | 5.65x | 16 | yes |
| rows-remove-one | 1 | react-reflex | 32015 | 19913–60425 | 29.10x | 16422 | 5.99x | 44 | yes |
| rows-remove-one | 1 | react-upstream | 25200 | 20600–59419 | 22.91x | 15469 | 5.65x | 0 | yes |
| rows-remove-one | 1 | roact | 20203 | 14300–21315 | 18.37x | 16781 | 6.12x | 8 | yes |
| rows-remove-one | 1 | seam | 8543 | 8072–10157 | 7.77x | 23214 | 8.47x | 1 | yes |
| rows-remove-one | 1 | signals | 2050 | 1852–2150 | 1.86x | 8598 | 3.14x | 1 | yes |
| rows-remove-one | 1 | vide | 1250 | 1200–1400 | 1.14x | 4553 | 1.66x | 8 | yes |
| rows-swap | 1 | plain | 100 | 100–150 | 1.00x | 2687 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 800 | 600–900 | 8.00x | 18262 | 6.80x | 1 | yes |
| rows-swap | 1 | compose | 200 | 100–300 | 2.00x | 4919 | 1.83x | 10 | yes |
| rows-swap | 1 | fusion | 31905 | 31412–32407 | 319.05x | 9566 | 3.56x | 0 | yes |
| rows-swap | 1 | fusion-charm | 31805 | 31230–34470 | 318.05x | 14627 | 5.44x | 1 | yes |
| rows-swap | 1 | react | 32000 | 29501–35800 | 320.00x | 15474 | 5.76x | 9 | yes |
| rows-swap | 1 | react-reflex | 49200 | 32235–50416 | 492.00x | 16402 | 6.10x | 44 | yes |
| rows-swap | 1 | react-upstream | 39637 | 33133–61008 | 396.37x | 15089 | 5.62x | 95 | yes |
| rows-swap | 1 | roact | 18408 | 14700–20300 | 184.08x | 16308 | 6.07x | 1 | yes |
| rows-swap | 1 | seam | 6317 | 5701–7625 | 63.17x | 23212 | 8.64x | 1 | yes |
| rows-swap | 1 | signals | 750 | 750–850 | 7.50x | 8593 | 3.20x | 0 | yes |
| rows-swap | 1 | vide | 100 | 100–150 | 1.00x | 4508 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 4150 | 4050–4700 | 1.00x | 3183 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 4203 | 4102–4304 | 1.01x | 19264 | 6.05x | 8 | yes |
| rows-update-every-10th | 1 | compose | 4200 | 3900–4503 | 1.01x | 5457 | 1.71x | 12 | yes |
| rows-update-every-10th | 1 | fusion | 4400 | 4000–5600 | 1.06x | 10536 | 3.31x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4500 | 4500–5900 | 1.08x | 14439 | 4.54x | 0 | yes |
| rows-update-every-10th | 1 | react | 4300 | 4100–4400 | 1.04x | 7822 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 8300 | 5806–13901 | 2.00x | 8854 | 2.78x | 53 | yes |
| rows-update-every-10th | 1 | react-upstream | 4300 | 4200–6700 | 1.04x | 7942 | 2.50x | 33 | yes |
| rows-update-every-10th | 1 | roact | 4400 | 4300–5800 | 1.06x | 16666 | 5.24x | 1 | yes |
| rows-update-every-10th | 1 | seam | 7908 | 6903–9106 | 1.91x | 24212 | 7.61x | 1 | yes |
| rows-update-every-10th | 1 | signals | 4904 | 4500–6200 | 1.18x | 9346 | 2.94x | 1 | yes |
| rows-update-every-10th | 1 | vide | 5108 | 4400–7700 | 1.23x | 5101 | 1.60x | 8 | yes |

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
| blend | 29 | 2.55x | 11.15x | 2.51x | 10.84x |
| compose | 30 | 2.04x | 3.95x | 1.95x | 3.91x |
| fusion | 30 | 6.27x | 6.05x | 5.75x | 6.06x |
| fusion-charm | 30 | 5.76x | 6.90x | 5.26x | 6.97x |
| react | 29 | 4.56x | 6.47x | 4.38x | 6.87x |
| react-reflex | 29 | 5.33x | 9.86x | 5.16x | 10.61x |
| react-upstream | 29 | 4.52x | 6.83x | 4.35x | 7.26x |
| roact | 29 | 3.06x | 5.72x | 3.01x | 6.48x |
| seam | 30 | 4.40x | 12.21x | 4.04x | 12.10x |
| signals | 29 | 2.05x | 2.65x | 1.96x | 2.64x |
| vide | 30 | 2.03x | 3.28x | 1.92x | 3.31x |
