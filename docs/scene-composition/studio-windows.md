# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, in KiB. Teardown is the median retained heap after release. Both use the Verify `gc-witness-low-water/2` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D 16-Core Processor           |
| Cores | 32 |
| Memory | 62 GiB |
| Model | Micro-Star International Co., Ltd. MS-7E47 |
| Operating system | Microsoft Windows 11 Pro 10.0.26200 |
| Roblox Studio | 0.745.449.7450003 |
| Context | client |
| Harness revision | `731b061` |
| Date | 2026-11-03 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 800 | 700–1100 | 1.00x | 49 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 2036 | 1700–2295 | 2.54x | 772 | 15.76x | 1 | yes |
| update-leaf | 20 | compose | 2300 | 2100–2300 | 2.88x | 67 | 1.37x | 0 | yes |
| update-leaf | 20 | fusion | 2200 | 1900–2600 | 2.75x | 51 | 1.04x | 8 | yes |
| update-leaf | 20 | fusion-charm | 700 | 567–700 | 0.88x | 53 | 1.08x | 1 | yes |
| update-leaf | 20 | react | 2071 | 1600–2916 | 2.59x | 348 | 7.10x | 1 | yes |
| update-leaf | 20 | react-reflex | 2200 | 1800–2300 | 2.75x | 292 | 5.96x | 1 | yes |
| update-leaf | 20 | react-upstream | 2000 | 1800–2532 | 2.50x | 299 | 6.10x | 0 | yes |
| update-leaf | 20 | roact | 1900 | 1501–2100 | 2.38x | 959 | 19.57x | 0 | yes |
| update-leaf | 20 | seam | 1900 | 1500–2200 | 2.38x | 40 | 0.82x | 0 | yes |
| update-leaf | 20 | signals | 1800 | 1400–2217 | 2.25x | 50 | 1.02x | 1 | yes |
| update-leaf | 20 | vide | 2100 | 1800–2600 | 2.62x | 0 | 0.00x | 0 | yes |
| update-batched | 20 | plain | 4300 | 4200–4300 | 1.00x | 52 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 12617 | 9949–13300 | 2.93x | 940 | 18.08x | 8 | yes |
| update-batched | 20 | compose | 7046 | 6735–7700 | 1.64x | 374 | 7.19x | 10 | yes |
| update-batched | 20 | fusion | 19900 | 17142–20950 | 4.63x | 524 | 10.08x | 1 | yes |
| update-batched | 20 | fusion-charm | 21632 | 20334–22407 | 5.03x | 1117 | 21.48x | 0 | yes |
| update-batched | 20 | react | 7500 | 6401–8700 | 1.74x | 477 | 9.17x | 0 | yes |
| update-batched | 20 | react-reflex | 49709 | 44095–59622 | 11.56x | 766 | 14.73x | 25 | yes |
| update-batched | 20 | react-upstream | 7669 | 7000–8001 | 1.78x | 477 | 9.17x | 0 | yes |
| update-batched | 20 | roact | 7800 | 7305–8597 | 1.81x | 1169 | 22.48x | 0 | yes |
| update-batched | 20 | seam | 11801 | 11200–12101 | 2.74x | 1840 | 35.38x | 0 | yes |
| update-batched | 20 | signals | 8900 | 8500–10300 | 2.07x | 605 | 11.63x | 0 | yes |
| update-batched | 20 | vide | 7900 | 7602–9402 | 1.84x | 332 | 6.38x | 1 | yes |
| update-repeated | 10 | plain | 0 | 0–0 | plain below resolution | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 2907 | 2400–3640 | plain below resolution | 15 | 7.50x | 0 | yes |
| update-repeated | 10 | compose | 200 | 200–500 | plain below resolution | 4 | 2.00x | 2 | yes |
| update-repeated | 10 | fusion | 21691 | 21100–22120 | plain below resolution | 4 | 2.00x | 1 | yes |
| update-repeated | 10 | fusion-charm | 600 | 500–1200 | plain below resolution | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 4808 | 4564–5000 | plain below resolution | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 500 | 400–800 | plain below resolution | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 5000 | 4525–5100 | plain below resolution | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5900 | 5503–6185 | plain below resolution | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1100 | 1000–1400 | plain below resolution | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 700 | 400–800 | plain below resolution | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | vide | 334 | 300–500 | plain below resolution | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | plain | 22882 | 19504–28494 | 1.00x | 1 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 34049 | 27237–39975 | 1.49x | 34 | 34.00x | 1 | yes |
| branch-swap | 20 | compose | 26628 | 25329–27439 | 1.16x | 6 | 6.00x | 2 | yes |
| branch-swap | 20 | fusion | 27601 | 25613–29311 | 1.21x | 5 | 5.00x | 0 | yes |
| branch-swap | 20 | fusion-charm | 5900 | 5400–6485 | 0.26x | 7 | 7.00x | 0 | yes |
| branch-swap | 20 | react | 28425 | 27186–32242 | 1.24x | 19 | 19.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 29138 | 26300–31930 | 1.27x | 11 | 11.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 28971 | 27234–29666 | 1.27x | 10 | 10.00x | 0 | yes |
| branch-swap | 20 | roact | 25900 | 23887–27600 | 1.13x | 19 | 19.00x | 0 | yes |
| branch-swap | 20 | seam | 23707 | 22606–25307 | 1.04x | 11 | 11.00x | 1 | yes |
| branch-swap | 20 | signals | 24106 | 22502–24305 | 1.05x | 4 | 4.00x | 1 | yes |
| branch-swap | 20 | vide | 23790 | 23451–24147 | 1.04x | 5 | 5.00x | 0 | yes |
| keyed-prepend | 10 | plain | 1800 | 1700–2326 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4000 | 3870–4300 | 2.22x | 1506 | 23.53x | 0 | yes |
| keyed-prepend | 10 | compose | 3700 | 3400–4100 | 2.06x | 492 | 7.69x | 9 | yes |
| keyed-prepend | 10 | fusion (workaround) | 16511 | 15500–17300 | 9.17x | 1519 | 23.73x | 0 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 11300 | 10400–12187 | 6.28x | 1512 | 23.62x | 0 | yes |
| keyed-prepend | 10 | react | 10306 | 9743–10953 | 5.73x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 10100 | 9669–11058 | 5.61x | 794 | 12.41x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 10635 | 9900–10946 | 5.91x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | roact | 5500 | 5100–6600 | 3.06x | 361 | 5.64x | 0 | yes |
| keyed-prepend | 10 | seam | 9426 | 9100–9717 | 5.24x | 2463 | 38.48x | 0 | yes |
| keyed-prepend | 10 | signals | 2300 | 2100–2600 | 1.28x | 54 | 0.84x | 1 | yes |
| keyed-prepend | 10 | vide | 4400 | 4300–4500 | 2.44x | 654 | 10.22x | 0 | yes |
| keyed-insert | 10 | plain | 1300 | 1100–1402 | 1.00x | 97 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 3500 | 3400–3960 | 2.69x | 1546 | 15.94x | 1 | yes |
| keyed-insert | 10 | compose | 2600 | 2357–3037 | 2.00x | 519 | 5.35x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 13900 | 12900–15110 | 10.69x | 1534 | 15.81x | 2 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 11002 | 10000–13109 | 8.46x | 1528 | 15.75x | 0 | yes |
| keyed-insert | 10 | react | 9031 | 8826–10135 | 6.95x | 883 | 9.10x | 0 | yes |
| keyed-insert | 10 | react-reflex | 8902 | 8672–10103 | 6.85x | 812 | 8.37x | 0 | yes |
| keyed-insert | 10 | react-upstream | 8936 | 8475–9720 | 6.87x | 811 | 8.36x | 0 | yes |
| keyed-insert | 10 | roact | 4619 | 4300–5116 | 3.55x | 361 | 3.72x | 0 | yes |
| keyed-insert | 10 | seam | 8574 | 8028–9406 | 6.60x | 2471 | 25.47x | 0 | yes |
| keyed-insert | 10 | signals | 1800 | 1500–2300 | 1.38x | 61 | 0.63x | 0 | yes |
| keyed-insert | 10 | vide | 3200 | 2900–3300 | 2.46x | 646 | 6.66x | 1 | yes |
| keyed-shuffle | 10 | plain | 1100 | 1100–1351 | 1.00x | 60 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 2300 | 2000–2506 | 2.09x | 1448 | 24.13x | 0 | yes |
| keyed-shuffle | 10 | compose | 2200 | 2100–2309 | 2.00x | 491 | 8.18x | 9 | yes |
| keyed-shuffle | 10 | fusion | 13600 | 13232–15873 | 12.36x | 1398 | 23.30x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 9175 | 8400–11117 | 8.34x | 1399 | 23.32x | 1 | yes |
| keyed-shuffle | 10 | react | 14632 | 14112–15200 | 13.30x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 15100 | 14600–15509 | 13.73x | 788 | 13.13x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 14627 | 13700–16223 | 13.30x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | roact | 4227 | 4100–4500 | 3.84x | 368 | 6.13x | 0 | yes |
| keyed-shuffle | 10 | seam | 7800 | 7200–8700 | 7.09x | 2470 | 41.17x | 1 | yes |
| keyed-shuffle | 10 | signals | 1600 | 1300–1800 | 1.45x | 52 | 0.87x | 8 | yes |
| keyed-shuffle | 10 | vide | 2800 | 2400–3100 | 2.55x | 629 | 10.48x | 1 | yes |
| events | 1 | plain | 2100 | 900–2300 | 1.00x | 1 | 1.00x | 1 | yes |
| events | 1 | blend | 2200 | 1700–2500 | 1.05x | 1 | 1.00x | 1 | yes |
| events | 1 | compose | 2111 | 1600–2300 | 1.01x | 1 | 1.00x | 2 | yes |
| events | 1 | fusion | 1905 | 1600–2100 | 0.91x | 1 | 1.00x | 1 | yes |
| events | 1 | fusion-charm | 2000 | 1400–2600 | 0.95x | 2 | 2.00x | 0 | yes |
| events | 1 | react | 2200 | 1700–2400 | 1.05x | 1 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 1900 | 1300–2332 | 0.90x | 9 | 9.00x | 0 | yes |
| events | 1 | react-upstream | 1900 | 1800–2300 | 0.90x | 1 | 1.00x | 0 | yes |
| events | 1 | roact | 2100 | 1300–2500 | 1.00x | 2 | 2.00x | 0 | yes |
| events | 1 | seam | 1800 | 1700–2200 | 0.86x | 9 | 9.00x | 0 | yes |
| events | 1 | signals | 1600 | 900–1800 | 0.76x | 1 | 1.00x | 0 | yes |
| events | 1 | vide | 2500 | 1700–3000 | 1.19x | 8 | 8.00x | 0 | yes |
| animate-many | 1 | plain | 2400 | 2100–2832 | 1.00x | 48 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 9849 | 8329–10716 | 4.10x | 1779 | 37.06x | 0 | yes |
| animate-many | 1 | compose | 6198 | 5800–6669 | 2.58x | 645 | 13.44x | 12 | yes |
| animate-many | 1 | fusion | 64561 | 63000–65907 | 26.90x | 1136 | 23.67x | 1 | yes |
| animate-many | 1 | fusion-charm | 35851 | 35208–37565 | 14.94x | 1138 | 23.71x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20314 | 18200–20800 | 8.46x | 2913 | 60.69x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8200 | 7727–10190 | 3.42x | 392 | 8.17x | 0 | yes |
| status-panel | 10 | plain | 800 | 600–1019 | 1.00x | 0 | plain zero | 8 | yes |
| status-panel | 10 | blend | 2200 | 1900–2332 | 2.75x | 69 | plain zero | 1 | yes |
| status-panel | 10 | compose | 1900 | 1600–2500 | 2.38x | 29 | plain zero | 2 | yes |
| status-panel | 10 | fusion | 2703 | 2635–2802 | 3.38x | 56 | plain zero | 1 | yes |
| status-panel | 10 | fusion-charm | 986 | 845–1300 | 1.23x | 69 | plain zero | 1 | yes |
| status-panel | 10 | react | 2990 | 2700–3165 | 3.74x | 43 | plain zero | 0 | yes |
| status-panel | 10 | react-reflex | 2848 | 2400–2900 | 3.56x | 37 | plain zero | 0 | yes |
| status-panel | 10 | react-upstream | 2800 | 2500–3630 | 3.50x | 43 | plain zero | 0 | yes |
| status-panel | 10 | roact | 2000 | 1800–2100 | 2.50x | 33 | plain zero | 0 | yes |
| status-panel | 10 | seam | 2500 | 2400–2703 | 3.12x | 140 | plain zero | 1 | yes |
| status-panel | 10 | signals | 2000 | 1700–2100 | 2.50x | 15 | plain zero | 8 | yes |
| status-panel | 10 | vide | 2069 | 2000–2200 | 2.59x | 31 | plain zero | 1 | yes |
| scene-3d | 10 | plain | 2100 | 2100–3100 | 1.00x | 10 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4400 | 4100–5402 | 2.10x | 565 | 56.50x | 0 | yes |
| scene-3d | 10 | compose | 3300 | 3000–3400 | 1.57x | 177 | 17.70x | 2 | yes |
| scene-3d | 10 | fusion | 25100 | 23123–25595 | 11.95x | 536 | 53.60x | 1 | yes |
| scene-3d | 10 | fusion-charm | 15779 | 14318–16600 | 7.51x | 539 | 53.90x | 1 | yes |
| scene-3d | 10 | react | 3368 | 3100–4400 | 1.60x | 231 | 23.10x | 0 | yes |
| scene-3d | 10 | react-reflex | 3300 | 3000–4001 | 1.57x | 233 | 23.30x | 0 | yes |
| scene-3d | 10 | react-upstream | 3500 | 3200–3900 | 1.67x | 231 | 23.10x | 1 | yes |
| scene-3d | 10 | roact | 3304 | 3200–3900 | 1.57x | 590 | 59.00x | 0 | yes |
| scene-3d | 10 | seam | 8100 | 7530–8425 | 3.86x | 1786 | 178.60x | 0 | yes |
| scene-3d | 10 | signals | 5242 | 4700–5603 | 2.50x | 682 | 68.20x | 0 | yes |
| scene-3d | 10 | vide | 3826 | 3200–4483 | 1.82x | 211 | 21.10x | 0 | yes |
| derived-diamond | 3 | plain | 0 | 0–100 | plain below resolution | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 100 | 100–200 | plain below resolution | 20 | 4.00x | 9 | yes |
| derived-diamond | 3 | compose | 0 | 0–100 | plain below resolution | 8 | 1.60x | 9 | yes |
| derived-diamond | 3 | fusion | 100 | 0–200 | plain below resolution | 0 | 0.00x | 8 | yes |
| derived-diamond | 3 | fusion-charm | 100 | 0–300 | plain below resolution | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | react | 200 | 100–400 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-diamond | 3 | react-reflex | 200 | 0–300 | plain below resolution | 8 | 1.60x | 5 | yes |
| derived-diamond | 3 | react-upstream | 100 | 0–200 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-diamond | 3 | roact | 100 | 0–100 | plain below resolution | 7 | 1.40x | 3 | yes |
| derived-diamond | 3 | seam | 100 | 100–300 | plain below resolution | 20 | 4.00x | 0 | yes |
| derived-diamond | 3 | signals | 200 | 0–300 | plain below resolution | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 0–300 | plain below resolution | 5 | 1.00x | 1 | yes |
| derived-chain-100 | 3 | plain | 0 | 0–0 | plain below resolution | 61 | 1.00x | 1 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 100 | 0–200 | plain below resolution | 125 | 2.05x | 2 | yes |
| derived-chain-100 | 3 | fusion | 424 | 400–600 | plain below resolution | 127 | 2.08x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 600 | 300–829 | plain below resolution | 136 | 2.23x | 0 | yes |
| derived-chain-100 | 3 | react | 200 | 200–500 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-chain-100 | 3 | react-reflex | 300 | 200–400 | plain below resolution | 16 | 0.26x | 5 | yes |
| derived-chain-100 | 3 | react-upstream | 300 | 100–500 | plain below resolution | 0 | 0.00x | 2 | yes |
| derived-chain-100 | 3 | roact | 100 | 0–200 | plain below resolution | 7 | 0.11x | 3 | yes |
| derived-chain-100 | 3 | seam | 616 | 500–710 | plain below resolution | 279 | 4.57x | 0 | yes |
| derived-chain-100 | 3 | signals | 100 | 0–200 | plain below resolution | 173 | 2.84x | 1 | yes |
| derived-chain-100 | 3 | vide | 100 | 0–200 | plain below resolution | 93 | 1.52x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 0 | 0–0 | plain below resolution | 607 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 200 | 0–300 | plain below resolution | 1542 | 2.54x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 200 | 200–311 | plain below resolution | 694 | 1.14x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 1200 | 900–1298 | plain below resolution | 897 | 1.48x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1100 | 700–1700 | plain below resolution | 2829 | 4.66x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1000 | 800–2001 | plain below resolution | 321 | 0.53x | 2 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7200 | 6198–8007 | plain below resolution | 5206 | 8.58x | 45 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1100 | 900–2000 | plain below resolution | 313 | 0.52x | 10 | yes |
| derived-fan-in-1000 | 3 | roact | 400 | 200–700 | plain below resolution | 102 | 0.17x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 1470 | 1100–1884 | plain below resolution | 2954 | 4.87x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 500 | 300–600 | plain below resolution | 1220 | 2.01x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 300 | 300–500 | plain below resolution | 528 | 0.87x | 1 | yes |
| filter-as-you-type | 1 | plain | 6500 | 6100–6741 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 14766 | 14302–17600 | 2.27x | 2851 | 81.46x | 0 | yes |
| filter-as-you-type | 1 | compose | 9438 | 8849–10300 | 1.45x | 857 | 24.49x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 20351 | 19253–21302 | 3.13x | 2527 | 72.20x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 15700 | 15198–16059 | 2.42x | 2601 | 74.31x | 2 | yes |
| filter-as-you-type | 1 | react | 14100 | 13700–15700 | 2.17x | 9 | 0.26x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 14632 | 13701–15100 | 2.25x | 768 | 21.94x | 5 | yes |
| filter-as-you-type | 1 | react-upstream | 15015 | 14200–16241 | 2.31x | 9 | 0.26x | 2 | yes |
| filter-as-you-type | 1 | roact | 9509 | 9402–9900 | 1.46x | 508 | 14.51x | 0 | yes |
| filter-as-you-type | 1 | seam | 21108 | 20233–22098 | 3.25x | 3980 | 113.71x | 1 | yes |
| filter-as-you-type | 1 | signals | 7100 | 6900–7400 | 1.09x | 36 | 1.03x | 8 | yes |
| filter-as-you-type | 1 | vide | 9820 | 9141–10405 | 1.51x | 959 | 27.40x | 0 | yes |
| theme-propagation | 3 | plain | 100358 | 98089–108292 | 1.00x | 206 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 107418 | 99433–156228 | 1.07x | 1997 | 9.69x | 1 | yes |
| theme-propagation | 3 | compose | 121705 | 102391–138125 | 1.21x | 515 | 2.50x | 1 | yes |
| theme-propagation | 3 | fusion | 140316 | 118453–147152 | 1.40x | 818 | 3.97x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 2700 | 2200–3232 | 0.03x | 820 | 3.98x | 0 | yes |
| theme-propagation | 3 | react | 138209 | 132466–142725 | 1.38x | 0 | 0.00x | 10 | yes |
| theme-propagation | 3 | react-reflex | 148559 | 132218–159479 | 1.48x | 4988 | 24.21x | 0 | yes |
| theme-propagation | 3 | react-upstream | 149079 | 130146–230720 | 1.49x | 0 | 0.00x | 0 | yes |
| theme-propagation | 3 | roact | 123493 | 119857–137643 | 1.23x | 2807 | 13.63x | 4 | yes |
| theme-propagation | 3 | seam | 99950 | 95969–101329 | 1.00x | 3429 | 16.65x | 0 | yes |
| theme-propagation | 3 | signals | 109743 | 102070–127174 | 1.09x | 880 | 4.27x | 0 | yes |
| theme-propagation | 3 | vide | 107866 | 104138–117063 | 1.07x | 597 | 2.90x | 0 | yes |
| hud-per-frame | 1 | plain | 2300 | 1700–2900 | 1.00x | 32 | 1.00x | 1 | yes |
| hud-per-frame | 1 | blend | 3700 | 3200–4323 | 1.61x | 71 | 2.22x | 0 | yes |
| hud-per-frame | 1 | compose | 3115 | 2300–3700 | 1.35x | 26 | 0.81x | 2 | yes |
| hud-per-frame | 1 | fusion | 8800 | 8100–9600 | 3.83x | 53 | 1.66x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 9100 | 8900–9352 | 3.96x | 90 | 2.81x | 0 | yes |
| hud-per-frame | 1 | react | 3113 | 2600–3527 | 1.35x | 34 | 1.06x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 5500 | 5300–6400 | 2.39x | 52 | 1.62x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 2800 | 2700–3400 | 1.22x | 26 | 0.81x | 7 | yes |
| hud-per-frame | 1 | roact | 2700 | 2200–3300 | 1.17x | 90 | 2.81x | 1 | yes |
| hud-per-frame | 1 | seam | 6300 | 6200–7500 | 2.74x | 168 | 5.25x | 0 | yes |
| hud-per-frame | 1 | signals | 3900 | 3100–4100 | 1.70x | 65 | 2.03x | 0 | yes |
| hud-per-frame | 1 | vide | 3500 | 3200–4124 | 1.52x | 25 | 0.78x | 0 | yes |
| teardown-under-load | 1 | plain | 112769 | 111689–123457 | 1.00x | 4 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 61092 | 58273–66508 | 0.54x | 6 | 1.50x | 0 | yes |
| teardown-under-load | 1 | compose | 119889 | 116366–124871 | 1.06x | 5 | 1.25x | 1 | yes |
| teardown-under-load | 1 | fusion | 73925 | 71502–75569 | 0.66x | 4 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 56256 | 55602–58448 | 0.50x | 6 | 1.50x | 8 | yes |
| teardown-under-load | 1 | react | 130906 | 119102–166841 | 1.16x | 951 | 237.75x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 126444 | 119431–142273 | 1.12x | 960 | 240.00x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 124503 | 119787–130328 | 1.10x | 951 | 237.75x | 0 | yes |
| teardown-under-load | 1 | roact | 119216 | 113978–134232 | 1.06x | 70 | 17.50x | 1 | yes |
| teardown-under-load | 1 | seam | 127510 | 120284–152621 | 1.13x | 1 | 0.25x | 7 | yes |
| teardown-under-load | 1 | signals | 120957 | 117001–122494 | 1.07x | 4 | 1.00x | 0 | yes |
| teardown-under-load | 1 | vide | 59704 | 57589–60525 | 0.53x | 4 | 1.00x | 0 | yes |
| open-close-retention | 1 | plain | 221029 | 218420–246498 | 1.00x | 4 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 104183 | 101156–107575 | 0.47x | 5 | 1.25x | 8 | yes |
| open-close-retention | 1 | compose | 238744 | 230874–254633 | 1.08x | 0 | 0.00x | 2 | yes |
| open-close-retention | 1 | fusion | 128303 | 124119–135705 | 0.58x | 4 | 1.00x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 95427 | 88359–98486 | 0.43x | 6 | 1.50x | 1 | yes |
| open-close-retention | 1 | react | 258581 | 243978–281256 | 1.17x | 254 | 63.50x | 0 | yes |
| open-close-retention | 1 | react-reflex | 254101 | 245623–261090 | 1.15x | 255 | 63.75x | 0 | yes |
| open-close-retention | 1 | react-upstream | 251710 | 244191–258710 | 1.14x | 254 | 63.50x | 0 | yes |
| open-close-retention | 1 | roact | 244405 | 237034–244823 | 1.11x | 23 | 5.75x | 0 | yes |
| open-close-retention | 1 | seam | 263848 | 255291–271667 | 1.19x | 16 | 4.00x | 1 | yes |
| open-close-retention | 1 | signals | 236637 | 234624–243456 | 1.07x | 4 | 1.00x | 0 | yes |
| open-close-retention | 1 | vide | 85521 | 82600–87251 | 0.39x | 12 | 3.00x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7800 | 7619–8100 | 1.00x | 20 | 1.00x | 1 | yes |
| tree-expand-collapse | 1 | blend | 17561 | 15822–20304 | 2.25x | 812 | 40.60x | 0 | yes |
| tree-expand-collapse | 1 | compose | 11400 | 10631–11570 | 1.46x | 57 | 2.85x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 22000 | 20483–25000 | 2.82x | 165 | 8.25x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 16303 | 13400–19915 | 2.09x | 166 | 8.30x | 1 | yes |
| tree-expand-collapse | 1 | react | 14300 | 14060–15710 | 1.83x | 2 | 0.10x | 2 | yes |
| tree-expand-collapse | 1 | react-reflex | 14649 | 14400–15417 | 1.88x | 611 | 30.55x | 4 | yes |
| tree-expand-collapse | 1 | react-upstream | 14801 | 14355–16257 | 1.90x | 2 | 0.10x | 2 | yes |
| tree-expand-collapse | 1 | roact | 11000 | 10558–11156 | 1.41x | 32 | 1.60x | 3 | yes |
| tree-expand-collapse | 1 | seam | 23788 | 19278–27856 | 3.05x | 148 | 7.40x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8500 | 8300–8900 | 1.09x | 21 | 1.05x | 1 | yes |
| tree-expand-collapse | 1 | vide | 11541 | 11163–12200 | 1.48x | 71 | 3.55x | 8 | yes |
| form-validation | 1 | plain | 3004 | 3000–3518 | 1.00x | 56 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 6900 | 6400–7100 | 2.30x | 335 | 5.98x | 1 | yes |
| form-validation | 1 | compose | 6800 | 6400–7100 | 2.26x | 93 | 1.66x | 2 | yes |
| form-validation | 1 | fusion | 7200 | 6900–7700 | 2.40x | 118 | 2.11x | 0 | yes |
| form-validation | 1 | fusion-charm | 2500 | 1700–3131 | 0.83x | 155 | 2.77x | 1 | yes |
| form-validation | 1 | react | 14785 | 13498–15206 | 4.92x | 187 | 3.34x | 2 | yes |
| form-validation | 1 | react-reflex | 14805 | 13500–17200 | 4.93x | 259 | 4.62x | 6 | yes |
| form-validation | 1 | react-upstream | 14500 | 13800–14800 | 4.83x | 187 | 3.34x | 2 | yes |
| form-validation | 1 | roact | 9300 | 8900–9900 | 3.10x | 67 | 1.20x | 11 | yes |
| form-validation | 1 | seam | 7800 | 6900–13165 | 2.60x | 357 | 6.38x | 1 | yes |
| form-validation | 1 | signals | 6700 | 6000–7200 | 2.23x | 154 | 2.75x | 0 | yes |
| form-validation | 1 | vide | 7000 | 6400–7100 | 2.33x | 71 | 1.27x | 0 | yes |
| table-sort-filter | 1 | plain | 15002 | 14900–15500 | 1.00x | 82 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 33028 | 31207–37689 | 2.20x | 5796 | 70.68x | 0 | yes |
| table-sort-filter | 1 | compose | 20442 | 19819–21245 | 1.36x | 1482 | 18.07x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 49092 | 40830–54404 | 3.27x | 4927 | 60.09x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 35981 | 29630–36700 | 2.40x | 4920 | 60.00x | 1 | yes |
| table-sort-filter | 1 | react | 51859 | 49483–52236 | 3.46x | 2050 | 25.00x | 0 | yes |
| table-sort-filter | 1 | react-reflex | 51783 | 48132–54538 | 3.45x | 2045 | 24.94x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 49961 | 48702–52576 | 3.33x | 2034 | 24.80x | 1 | yes |
| table-sort-filter | 1 | roact | 20839 | 20256–22852 | 1.39x | 1050 | 12.80x | 3 | yes |
| table-sort-filter | 1 | seam | 49846 | 44858–50715 | 3.32x | 7927 | 96.67x | 1 | yes |
| table-sort-filter | 1 | signals | 16707 | 15211–19100 | 1.11x | 75 | 0.91x | 1 | yes |
| table-sort-filter | 1 | vide | 22528 | 20800–25517 | 1.50x | 1914 | 23.34x | 1 | yes |
| library-load | 1 | plain | 0 | 0–0 | plain below resolution | 1 | 1.00x | 1 | yes |
| library-load | 1 | blend | 100 | 100–8002 | plain below resolution | 3 | 3.00x | 458 | yes |
| library-load | 1 | compose | 100 | 0–200 | plain below resolution | 2 | 2.00x | 65 | yes |
| library-load | 1 | fusion | 100 | 0–6300 | plain below resolution | 1 | 1.00x | 268 | yes |
| library-load | 1 | fusion-charm | 100 | 100–8007 | plain below resolution | 1 | 1.00x | 315 | yes |
| library-load | 1 | react | 200 | 100–25708 | plain below resolution | 1 | 1.00x | 1813 | yes |
| library-load | 1 | react-reflex | 200 | 100–30600 | plain below resolution | 1 | 1.00x | 1966 | yes |
| library-load | 1 | react-upstream | 200 | 100–42988 | plain below resolution | 1 | 1.00x | 1989 | yes |
| library-load | 1 | roact | 100 | 100–100 | plain below resolution | 3 | 3.00x | 157 | yes |
| library-load | 1 | seam | 100 | 0–5800 | plain below resolution | 10 | 10.00x | 238 | yes |
| library-load | 1 | signals | 0 | 0–0 | plain below resolution | 1 | 1.00x | 48 | yes |
| library-load | 1 | vide | 0 | 0–100 | plain below resolution | 0 | 0.00x | 145 | yes |
| rows-append-1000 | 1 | plain | 172385 | 159084–211410 | 1.00x | 9746 | 1.00x | 1 | yes |
| rows-append-1000 | 1 | blend | 243337 | 227561–244731 | 1.41x | 38537 | 3.95x | 0 | yes |
| rows-append-1000 | 1 | compose | 198773 | 174133–230687 | 1.15x | 9543 | 0.98x | 2 | yes |
| rows-append-1000 | 1 | fusion | 320739 | 306030–355714 | 1.86x | 20873 | 2.14x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 205453 | 181761–217069 | 1.19x | 28769 | 2.95x | 0 | yes |
| rows-append-1000 | 1 | react | 262906 | 233383–266023 | 1.53x | 23185 | 2.38x | 265 | yes |
| rows-append-1000 | 1 | react-reflex | 276147 | 264716–304772 | 1.60x | 24962 | 2.56x | 116 | yes |
| rows-append-1000 | 1 | react-upstream | 257405 | 235559–289453 | 1.49x | 23202 | 2.38x | 32 | yes |
| rows-append-1000 | 1 | roact | 219380 | 196799–239476 | 1.27x | 33362 | 3.42x | 1 | yes |
| rows-append-1000 | 1 | seam | 247776 | 200362–279102 | 1.44x | 46686 | 4.79x | 0 | yes |
| rows-append-1000 | 1 | signals | 195681 | 165713–238006 | 1.14x | 17822 | 1.83x | 0 | yes |
| rows-append-1000 | 1 | vide | 181106 | 173531–247029 | 1.05x | 9499 | 0.97x | 9 | yes |
| rows-clear | 1 | plain | 20313 | 18413–26000 | 1.00x | 2464 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 38557 | 37400–39290 | 1.90x | 4057 | 1.65x | 0 | yes |
| rows-clear | 1 | compose | 26004 | 22003–26364 | 1.28x | 1835 | 0.74x | 10 | yes |
| rows-clear | 1 | fusion | 60778 | 47600–65919 | 2.99x | 3512 | 1.43x | 1 | yes |
| rows-clear | 1 | fusion-charm | 47400 | 46711–50101 | 2.33x | 7448 | 3.02x | 1 | yes |
| rows-clear | 1 | react | 20588 | 19604–23013 | 1.01x | 4528 | 1.84x | 1 | yes |
| rows-clear | 1 | react-reflex | 24149 | 21636–24482 | 1.19x | 6502 | 2.64x | 36 | yes |
| rows-clear | 1 | react-upstream | 20954 | 20714–23016 | 1.03x | 4512 | 1.83x | 0 | yes |
| rows-clear | 1 | roact | 26188 | 21903–30985 | 1.29x | 4230 | 1.72x | 0 | yes |
| rows-clear | 1 | seam | 37702 | 24895–41551 | 1.86x | 9135 | 3.71x | 1 | yes |
| rows-clear | 1 | signals | 21500 | 19711–25851 | 1.06x | 4489 | 1.82x | 0 | yes |
| rows-clear | 1 | vide | 18676 | 18200–22102 | 0.92x | 1620 | 0.66x | 0 | yes |
| rows-create-1000 | 1 | plain | 151696 | 145996–156720 | 1.00x | 5193 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 222478 | 213323–230750 | 1.47x | 19769 | 3.81x | 0 | yes |
| rows-create-1000 | 1 | compose | 174576 | 167951–188092 | 1.15x | 5085 | 0.98x | 2 | yes |
| rows-create-1000 | 1 | fusion | 232613 | 218954–242533 | 1.53x | 11003 | 2.12x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 103311 | 102661–119285 | 0.68x | 14940 | 2.88x | 0 | yes |
| rows-create-1000 | 1 | react | 208232 | 193120–217698 | 1.37x | 8152 | 1.57x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 225270 | 216215–238406 | 1.49x | 9038 | 1.74x | 51 | yes |
| rows-create-1000 | 1 | react-upstream | 218353 | 205777–257131 | 1.44x | 8136 | 1.57x | 16 | yes |
| rows-create-1000 | 1 | roact | 189555 | 187663–215880 | 1.25x | 16905 | 3.26x | 0 | yes |
| rows-create-1000 | 1 | seam | 208985 | 207974–257901 | 1.38x | 23662 | 4.56x | 0 | yes |
| rows-create-1000 | 1 | signals | 177614 | 156174–189978 | 1.17x | 9049 | 1.74x | 0 | yes |
| rows-create-1000 | 1 | vide | 165953 | 163476–195422 | 1.09x | 4948 | 0.95x | 8 | yes |
| rows-create-10000 | 1 | plain | 2006112 | 1931802–2171963 | 1.00x | 49587 | 1.00x | 1 | yes |
| rows-create-10000 | 1 | blend | 2724194 | 2602184–2728109 | 1.36x | 193276 | 3.90x | 1 | yes |
| rows-create-10000 | 1 | compose | 2294257 | 2217451–2412027 | 1.14x | 48486 | 0.98x | 2 | yes |
| rows-create-10000 | 1 | fusion | 6340373 | 5578272–6353536 | 3.16x | 104940 | 2.12x | 5 | yes |
| rows-create-10000 | 1 | fusion-charm | 5009617 | 4988235–5079931 | 2.50x | 145696 | 2.94x | 0 | yes |
| rows-create-10000 | 1 | react | 4395499 | 4372442–4402382 | 2.19x | 76647 | 1.55x | 8 | yes |
| rows-create-10000 | 1 | react-reflex | 4536779 | 4485465–4584860 | 2.26x | 86970 | 1.75x | 520 | yes |
| rows-create-10000 | 1 | react-upstream | 4402654 | 4164991–4928473 | 2.19x | 77902 | 1.57x | 637 | yes |
| rows-create-10000 | 1 | roact | 2450425 | 2353674–2666307 | 1.22x | 166310 | 3.35x | 4 | yes |
| rows-create-10000 | 1 | seam | 2719436 | 2453716–2791013 | 1.36x | 235712 | 4.75x | 12 | yes |
| rows-create-10000 | 1 | signals | 2148254 | 2102328–2353387 | 1.07x | 89233 | 1.80x | 0 | yes |
| rows-create-10000 | 1 | vide | 2031416 | 1859091–2237187 | 1.01x | 48459 | 0.98x | 21 | yes |
| rows-remove-one | 1 | plain | 600 | 400–800 | 1.00x | 5207 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 800 | 695–1151 | 1.33x | 19776 | 3.80x | 0 | yes |
| rows-remove-one | 1 | compose | 700 | 300–700 | 1.17x | 5115 | 0.98x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 33910 | 32901–36508 | 56.52x | 11400 | 2.19x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 31614 | 30943–32729 | 52.69x | 15345 | 2.95x | 0 | yes |
| rows-remove-one | 1 | react | 22605 | 14801–24325 | 37.67x | 15725 | 3.02x | 16 | yes |
| rows-remove-one | 1 | react-reflex | 29107 | 17218–37707 | 48.51x | 16610 | 3.19x | 36 | yes |
| rows-remove-one | 1 | react-upstream | 20887 | 17857–32408 | 34.81x | 15709 | 3.02x | 7 | yes |
| rows-remove-one | 1 | roact | 17300 | 14547–21500 | 28.83x | 16998 | 3.26x | 0 | yes |
| rows-remove-one | 1 | seam | 4202 | 3600–5400 | 7.00x | 23685 | 4.55x | 0 | yes |
| rows-remove-one | 1 | signals | 1500 | 1200–2208 | 2.50x | 9077 | 1.74x | 9 | yes |
| rows-remove-one | 1 | vide | 900 | 500–1400 | 1.50x | 5010 | 0.96x | 8 | yes |
| rows-swap | 1 | plain | 200 | 0–300 | 1.00x | 4598 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 600 | 300–700 | 3.00x | 18755 | 4.08x | 8 | yes |
| rows-swap | 1 | compose | 0 | 0–100 | 0.00x | 4618 | 1.00x | 3 | yes |
| rows-swap | 1 | fusion | 32986 | 30101–37530 | 164.93x | 10016 | 2.18x | 0 | yes |
| rows-swap | 1 | fusion-charm | 32000 | 29812–36901 | 160.00x | 13934 | 3.03x | 1 | yes |
| rows-swap | 1 | react | 35864 | 28074–38607 | 179.32x | 15118 | 3.29x | 0 | yes |
| rows-swap | 1 | react-reflex | 52206 | 47568–74217 | 261.03x | 16236 | 3.53x | 75 | yes |
| rows-swap | 1 | react-upstream | 40289 | 29926–78857 | 201.44x | 15454 | 3.36x | 0 | yes |
| rows-swap | 1 | roact | 16613 | 13200–23252 | 83.06x | 16761 | 3.65x | 9 | yes |
| rows-swap | 1 | seam | 3900 | 3700–5000 | 19.50x | 23235 | 5.05x | 0 | yes |
| rows-swap | 1 | signals | 400 | 300–700 | 2.00x | 8609 | 1.87x | 0 | yes |
| rows-swap | 1 | vide | 0 | 0–300 | 0.00x | 4516 | 0.98x | 8 | yes |
| rows-update-every-10th | 1 | plain | 3700 | 3568–4610 | 1.00x | 4218 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 3900 | 3765–4103 | 1.05x | 18799 | 4.46x | 0 | yes |
| rows-update-every-10th | 1 | compose | 3773 | 2800–4503 | 1.02x | 4174 | 0.99x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 3905 | 3300–4211 | 1.06x | 10035 | 2.38x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 500 | 100–800 | 0.14x | 13964 | 3.31x | 0 | yes |
| rows-update-every-10th | 1 | react | 3849 | 3424–4500 | 1.04x | 7448 | 1.77x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 7307 | 4779–36516 | 1.97x | 8333 | 1.98x | 51 | yes |
| rows-update-every-10th | 1 | react-upstream | 4103 | 3800–4600 | 1.11x | 7424 | 1.76x | 8 | yes |
| rows-update-every-10th | 1 | roact | 3611 | 3247–4100 | 0.98x | 16211 | 3.84x | 8 | yes |
| rows-update-every-10th | 1 | seam | 6000 | 5336–6201 | 1.62x | 23763 | 5.63x | 0 | yes |
| rows-update-every-10th | 1 | signals | 4000 | 3800–4500 | 1.08x | 8890 | 2.11x | 0 | yes |
| rows-update-every-10th | 1 | vide | 3924 | 3600–4400 | 1.06x | 4660 | 1.10x | 8 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.

The shared columns use only the workloads that every lane measured: 23 for time (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-update-every-10th`) and 22 for heap (`update-batched`, `update-repeated`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `scene-3d`, `derived-fan-in-1000`, `filter-as-you-type`, `hud-per-frame`, `teardown-under-load`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 1.73x | 7.94x | 1.63x | 8.34x |
| compose | 30 | 1.48x | 2.56x | 1.45x | 2.55x |
| fusion | 30 | 3.92x | 4.20x | 3.07x | 4.87x |
| fusion-charm | 30 | 2.07x | 5.35x | 1.58x | 6.77x |
| react | 29 | 2.88x | 3.58x | 2.40x | 3.23x |
| react-reflex | 29 | 3.40x | 6.36x | 2.81x | 7.24x |
| react-upstream | 29 | 2.87x | 3.42x | 2.39x | 3.08x |
| roact | 29 | 2.12x | 4.08x | 1.81x | 4.43x |
| seam | 30 | 2.68x | 9.34x | 2.34x | 10.38x |
| signals | 29 | 1.40x | 1.90x | 1.38x | 1.97x |
| vide | 30 | 1.44x | 2.71x | 1.39x | 2.75x |
