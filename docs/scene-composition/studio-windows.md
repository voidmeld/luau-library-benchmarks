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
| Harness revision | `a360b90` |
| Date | 2026-11-13 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 600 | 500–1100 | 1.00x | 58 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 3100 | 2800–3400 | 5.17x | 758 | 13.07x | 8 | yes |
| update-leaf | 20 | compose | 2800 | 2800–3600 | 4.67x | 101 | 1.74x | 2 | yes |
| update-leaf | 20 | fusion | 3100 | 2900–3200 | 5.17x | 60 | 1.03x | 9 | yes |
| update-leaf | 20 | fusion-charm | 3300 | 3200–3800 | 5.50x | 62 | 1.07x | 1 | yes |
| update-leaf | 20 | react | 3200 | 2700–4000 | 5.33x | 348 | 6.00x | 0 | yes |
| update-leaf | 20 | react-reflex | 3800 | 3500–4100 | 6.33x | 293 | 5.05x | 0 | yes |
| update-leaf | 20 | react-upstream | 3300 | 3100–3400 | 5.50x | 299 | 5.16x | 8 | yes |
| update-leaf | 20 | roact | 3100 | 2900–3200 | 5.17x | 466 | 8.03x | 1 | yes |
| update-leaf | 20 | seam | 3400 | 2901–3601 | 5.67x | 40 | 0.69x | 8 | yes |
| update-leaf | 20 | signals | 2900 | 2800–3600 | 4.83x | 51 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 3500 | 3000–4600 | 5.83x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4450 | 4200–4700 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 11125 | 10800–12033 | 2.50x | 916 | 45.80x | 8 | yes |
| update-batched | 20 | compose | 7400 | 7100–7519 | 1.66x | 408 | 20.40x | 9 | yes |
| update-batched | 20 | fusion | 21100 | 20100–23616 | 4.74x | 509 | 25.45x | 0 | yes |
| update-batched | 20 | fusion-charm | 36200 | 35467–39005 | 8.13x | 1093 | 54.65x | 0 | yes |
| update-batched | 20 | react | 8200 | 7400–8900 | 1.84x | 533 | 26.65x | 8 | yes |
| update-batched | 20 | react-reflex | 22002 | 21601–23301 | 4.94x | 794 | 39.70x | 16 | yes |
| update-batched | 20 | react-upstream | 7900 | 7800–8401 | 1.78x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | roact | 8500 | 7900–8900 | 1.91x | 867 | 43.35x | 8 | yes |
| update-batched | 20 | seam | 13600 | 12600–13800 | 3.06x | 1840 | 92.00x | 0 | yes |
| update-batched | 20 | signals | 9700 | 9500–10000 | 2.18x | 597 | 29.85x | 0 | yes |
| update-batched | 20 | vide | 8202 | 8000–8700 | 1.84x | 331 | 16.55x | 0 | yes |
| update-repeated | 10 | plain | 67 | 60–107 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 4050 | 3850–4200 | 60.05x | 7 | 3.50x | 0 | yes |
| update-repeated | 10 | compose | 700 | 200–900 | 10.38x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion | 22100 | 21300–22700 | 327.70x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1500 | 1350–1550 | 22.24x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 6200 | 5700–6302 | 91.93x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 1000 | 700–1200 | 14.83x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7000 | 5300–7300 | 103.80x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6700 | 6100–7400 | 99.35x | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | seam | 2100 | 1400–2400 | 31.14x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 1150 | 1002–1200 | 17.05x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 1000 | 900–1100 | 14.83x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 19200 | 18804–30900 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 30002 | 28402–36103 | 1.56x | 35 | 17.50x | 9 | yes |
| branch-swap | 20 | compose | 30000 | 26100–32100 | 1.56x | 15 | 7.50x | 10 | yes |
| branch-swap | 20 | fusion | 28007 | 26700–28701 | 1.46x | 5 | 2.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 28401 | 26900–31300 | 1.48x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 31502 | 31102–34601 | 1.64x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-reflex | 31200 | 31100–33804 | 1.62x | 19 | 9.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 32100 | 30000–33602 | 1.67x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | roact | 28002 | 27301–31016 | 1.46x | 31 | 15.50x | 15 | yes |
| branch-swap | 20 | seam | 29003 | 27501–34201 | 1.51x | 19 | 9.50x | 1 | yes |
| branch-swap | 20 | signals | 26802 | 25000–27900 | 1.40x | 5 | 2.50x | 1 | yes |
| branch-swap | 20 | vide | 28200 | 25800–29400 | 1.47x | 6 | 3.00x | 1 | yes |
| keyed-prepend | 10 | plain | 1633 | 1524–1834 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4612 | 4500–5000 | 2.82x | 1694 | 26.47x | 1 | yes |
| keyed-prepend | 10 | compose | 4550 | 3950–4655 | 2.79x | 568 | 8.88x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 20100 | 19000–21602 | 12.31x | 1524 | 23.81x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 18300 | 18104–19600 | 11.20x | 1494 | 23.34x | 1 | yes |
| keyed-prepend | 10 | react | 10600 | 10200–11900 | 6.49x | 790 | 12.34x | 1 | yes |
| keyed-prepend | 10 | react-reflex | 11408 | 10600–12603 | 6.98x | 786 | 12.28x | 1 | yes |
| keyed-prepend | 10 | react-upstream | 13222 | 10706–13800 | 8.10x | 784 | 12.25x | 0 | yes |
| keyed-prepend | 10 | roact | 6000 | 5500–6000 | 3.67x | 357 | 5.58x | 0 | yes |
| keyed-prepend | 10 | seam | 10308 | 10300–12700 | 6.31x | 2427 | 37.92x | 0 | yes |
| keyed-prepend | 10 | signals | 2650 | 2400–2950 | 1.62x | 66 | 1.03x | 0 | yes |
| keyed-prepend | 10 | vide | 4600 | 4500–5000 | 2.82x | 635 | 9.92x | 0 | yes |
| keyed-insert | 10 | plain | 1175 | 1050–1227 | 1.00x | 56 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 6000 | 5800–6800 | 5.11x | 1702 | 30.39x | 0 | yes |
| keyed-insert | 10 | compose | 4300 | 4100–4700 | 3.66x | 560 | 10.00x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 16407 | 16000–16600 | 13.96x | 1500 | 26.79x | 0 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 16400 | 15200–16800 | 13.96x | 1503 | 26.84x | 2 | yes |
| keyed-insert | 10 | react | 10500 | 10403–11200 | 8.94x | 803 | 14.34x | 0 | yes |
| keyed-insert | 10 | react-reflex | 12000 | 11500–12902 | 10.21x | 811 | 14.48x | 0 | yes |
| keyed-insert | 10 | react-upstream | 11201 | 10701–12400 | 9.53x | 819 | 14.62x | 8 | yes |
| keyed-insert | 10 | roact | 6700 | 6200–6900 | 5.70x | 364 | 6.50x | 0 | yes |
| keyed-insert | 10 | seam | 12702 | 11900–13200 | 10.81x | 2412 | 43.07x | 1 | yes |
| keyed-insert | 10 | signals | 3200 | 2650–3400 | 2.72x | 66 | 1.18x | 0 | yes |
| keyed-insert | 10 | vide | 5101 | 4400–5500 | 4.34x | 634 | 11.32x | 0 | yes |
| keyed-shuffle | 10 | plain | 1049 | 975–1075 | 1.00x | 116 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3000 | 2750–3048 | 2.86x | 1641 | 14.15x | 1 | yes |
| keyed-shuffle | 10 | compose | 2504 | 2350–2600 | 2.39x | 563 | 4.85x | 10 | yes |
| keyed-shuffle | 10 | fusion | 16301 | 15600–17523 | 15.54x | 1384 | 11.93x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 15400 | 14750–16405 | 14.68x | 1386 | 11.95x | 1 | yes |
| keyed-shuffle | 10 | react | 14803 | 14306–15804 | 14.11x | 776 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 17401 | 16424–18500 | 16.59x | 776 | 6.69x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 15786 | 14400–15806 | 15.05x | 832 | 7.17x | 0 | yes |
| keyed-shuffle | 10 | roact | 4704 | 4250–5000 | 4.48x | 360 | 3.10x | 0 | yes |
| keyed-shuffle | 10 | seam | 8600 | 8000–9600 | 8.20x | 2423 | 20.89x | 1 | yes |
| keyed-shuffle | 10 | signals | 1625 | 1550–2000 | 1.55x | 126 | 1.09x | 8 | yes |
| keyed-shuffle | 10 | vide | 2950 | 2900–3050 | 2.81x | 671 | 5.78x | 0 | yes |
| events | 1 | plain | 3700 | 3100–5000 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | blend | 4300 | 4100–4700 | 1.16x | 1 | 1.00x | 0 | yes |
| events | 1 | compose | 3900 | 3500–4400 | 1.05x | 0 | 1.00x | 1 | yes |
| events | 1 | fusion | 3300 | 2400–3900 | 0.89x | 0 | 1.00x | 0 | yes |
| events | 1 | fusion-charm | 3600 | 3100–4700 | 0.97x | 1 | 1.00x | 0 | yes |
| events | 1 | react | 4400 | 4100–4500 | 1.19x | 1 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 4300 | 3700–4433 | 1.16x | 1 | 1.00x | 0 | yes |
| events | 1 | react-upstream | 4000 | 3500–4300 | 1.08x | 0 | 1.00x | 0 | yes |
| events | 1 | roact | 3900 | 3200–4000 | 1.05x | 2 | 2.00x | 0 | yes |
| events | 1 | seam | 3200 | 3100–4500 | 0.86x | 1 | 1.00x | 0 | yes |
| events | 1 | signals | 2900 | 2300–3600 | 0.78x | 1 | 1.00x | 0 | yes |
| events | 1 | vide | 4100 | 3900–4200 | 1.11x | 9 | 9.00x | 0 | yes |
| animate-many | 1 | plain | 9500 | 9200–10500 | 1.00x | 80 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 14700 | 13800–14901 | 1.55x | 1779 | 22.24x | 1 | yes |
| animate-many | 1 | compose | 28500 | 27300–29301 | 3.00x | 655 | 8.19x | 12 | yes |
| animate-many | 1 | fusion | 73500 | 71403–74527 | 7.74x | 1129 | 14.11x | 1 | yes |
| animate-many | 1 | fusion-charm | 74903 | 73301–82705 | 7.88x | 1131 | 14.14x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 26900 | 23300–27200 | 2.83x | 2905 | 36.31x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 26202 | 24900–27101 | 2.76x | 392 | 4.90x | 0 | yes |
| status-panel | 10 | plain | 965 | 780–1000 | 1.00x | 22 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 2450 | 2100–2700 | 2.54x | 100 | 4.55x | 8 | yes |
| status-panel | 10 | compose | 2450 | 2300–2650 | 2.54x | 47 | 2.14x | 2 | yes |
| status-panel | 10 | fusion | 2950 | 2700–3201 | 3.06x | 78 | 3.55x | 0 | yes |
| status-panel | 10 | fusion-charm | 2950 | 2900–3150 | 3.06x | 92 | 4.18x | 8 | yes |
| status-panel | 10 | react | 3350 | 3000–3750 | 3.47x | 56 | 2.55x | 0 | yes |
| status-panel | 10 | react-reflex | 3350 | 3200–3750 | 3.47x | 60 | 2.73x | 0 | yes |
| status-panel | 10 | react-upstream | 3250 | 3150–3400 | 3.37x | 58 | 2.64x | 0 | yes |
| status-panel | 10 | roact | 2550 | 2350–3250 | 2.64x | 45 | 2.05x | 0 | yes |
| status-panel | 10 | seam | 2950 | 2900–3100 | 3.06x | 156 | 7.09x | 1 | yes |
| status-panel | 10 | signals | 2100 | 1900–2350 | 2.18x | 30 | 1.36x | 0 | yes |
| status-panel | 10 | vide | 2350 | 2150–2400 | 2.43x | 47 | 2.14x | 0 | yes |
| scene-3d | 10 | plain | 2167 | 2167–2300 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 6900 | 5800–7500 | 3.18x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 5500 | 4600–5900 | 2.54x | 195 | 17.73x | 1 | yes |
| scene-3d | 10 | fusion | 22400 | 21600–22700 | 10.34x | 520 | 47.27x | 1 | yes |
| scene-3d | 10 | fusion-charm | 21001 | 20802–21402 | 9.69x | 523 | 47.55x | 1 | yes |
| scene-3d | 10 | react | 6500 | 5000–6700 | 3.00x | 230 | 20.91x | 0 | yes |
| scene-3d | 10 | react-reflex | 5100 | 4800–5400 | 2.35x | 224 | 20.36x | 0 | yes |
| scene-3d | 10 | react-upstream | 5900 | 5000–6500 | 2.72x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 5601 | 5000–6000 | 2.59x | 567 | 51.55x | 0 | yes |
| scene-3d | 10 | seam | 11800 | 11300–11900 | 5.45x | 1763 | 160.27x | 0 | yes |
| scene-3d | 10 | signals | 7900 | 6900–8101 | 3.65x | 682 | 62.00x | 0 | yes |
| scene-3d | 10 | vide | 4900 | 4600–5200 | 2.26x | 210 | 19.09x | 0 | yes |
| derived-diamond | 3 | plain | 91 | 45–94 | 1.00x | 2 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 250 | 225–375 | 2.74x | 19 | 9.50x | 0 | yes |
| derived-diamond | 3 | compose | 350 | 125–400 | 3.84x | 10 | 5.00x | 2 | yes |
| derived-diamond | 3 | fusion | 500 | 450–525 | 5.48x | 1 | 0.50x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 500 | 400–525 | 5.48x | 11 | 5.50x | 0 | yes |
| derived-diamond | 3 | react | 800 | 500–933 | 8.77x | 6 | 3.00x | 2 | yes |
| derived-diamond | 3 | react-reflex | 733 | 667–900 | 8.04x | 31 | 15.50x | 5 | yes |
| derived-diamond | 3 | react-upstream | 733 | 500–833 | 8.04x | 6 | 3.00x | 3 | yes |
| derived-diamond | 3 | roact | 300 | 275–350 | 3.29x | 8 | 4.00x | 1 | yes |
| derived-diamond | 3 | seam | 650 | 600–850 | 7.13x | 21 | 10.50x | 0 | yes |
| derived-diamond | 3 | signals | 275 | 175–350 | 3.01x | 10 | 5.00x | 0 | yes |
| derived-diamond | 3 | vide | 350 | 250–400 | 3.84x | 6 | 3.00x | 0 | yes |
| derived-chain-100 | 3 | plain | 25 | 22–32 | 1.00x | 3 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | 293 | 200–353 | 11.78x | 352 | 117.33x | 1 | yes |
| derived-chain-100 | 3 | compose | 176 | 147–194 | 7.09x | 140 | 46.67x | 2 | yes |
| derived-chain-100 | 3 | fusion | 500 | 450–600 | 20.08x | 121 | 40.33x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 538 | 500–569 | 21.62x | 131 | 43.67x | 8 | yes |
| derived-chain-100 | 3 | react | 689 | 611–700 | 27.67x | 122 | 40.67x | 7 | yes |
| derived-chain-100 | 3 | react-reflex | 667 | 667–722 | 26.78x | 323 | 107.67x | 11 | yes |
| derived-chain-100 | 3 | react-upstream | 656 | 600–700 | 26.33x | 114 | 38.00x | 0 | yes |
| derived-chain-100 | 3 | roact | 135 | 129–171 | 5.43x | 0 | 0.33x | 0 | yes |
| derived-chain-100 | 3 | seam | 750 | 675–888 | 30.12x | 273 | 91.00x | 0 | yes |
| derived-chain-100 | 3 | signals | 200 | 146–216 | 8.03x | 176 | 58.67x | 0 | yes |
| derived-chain-100 | 3 | vide | 153 | 141–176 | 6.14x | 94 | 31.33x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 96 | 87–110 | 1.00x | 18 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 450 | 400–525 | 4.71x | 1513 | 84.06x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 650 | 500–775 | 6.81x | 688 | 38.22x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1800 | 1500–2104 | 18.85x | 890 | 49.44x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1767 | 1667–1900 | 18.50x | 2805 | 155.83x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1967 | 1600–3638 | 20.59x | 637 | 35.39x | 42 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 6800 | 6300–11002 | 71.19x | 5707 | 317.06x | 85 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2200 | 1950–2800 | 23.03x | 644 | 35.78x | 34 | yes |
| derived-fan-in-1000 | 3 | roact | 750 | 626–925 | 7.85x | 102 | 5.67x | 0 | yes |
| derived-fan-in-1000 | 3 | seam | 2850 | 2250–3300 | 29.84x | 2948 | 163.78x | 8 | yes |
| derived-fan-in-1000 | 3 | signals | 1275 | 1200–1450 | 13.35x | 1213 | 67.39x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 700 | 600–800 | 7.33x | 528 | 29.33x | 0 | yes |
| filter-as-you-type | 1 | plain | 5800 | 5303–6100 | 1.00x | 33 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 17500 | 17200–19503 | 3.02x | 3032 | 91.88x | 0 | yes |
| filter-as-you-type | 1 | compose | 11400 | 10602–12500 | 1.97x | 842 | 25.52x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 24000 | 23800–25600 | 4.14x | 2353 | 71.30x | 2 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 24000 | 23800–24505 | 4.14x | 2388 | 72.36x | 2 | yes |
| filter-as-you-type | 1 | react | 21300 | 20800–24207 | 3.67x | 11 | 0.33x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 22232 | 20907–23300 | 3.83x | 1151 | 34.88x | 5 | yes |
| filter-as-you-type | 1 | react-upstream | 22200 | 20706–22900 | 3.83x | 11 | 0.33x | 2 | yes |
| filter-as-you-type | 1 | roact | 11600 | 10800–12400 | 2.00x | 492 | 14.91x | 1 | yes |
| filter-as-you-type | 1 | seam | 25000 | 24102–25202 | 4.31x | 3877 | 117.48x | 1 | yes |
| filter-as-you-type | 1 | signals | 8101 | 7804–8900 | 1.40x | 49 | 1.48x | 0 | yes |
| filter-as-you-type | 1 | vide | 12000 | 10800–13200 | 2.07x | 960 | 29.09x | 7 | yes |
| theme-propagation | 3 | plain | 96705 | 93487–106918 | 1.00x | 49 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 103826 | 94760–109220 | 1.07x | 2079 | 42.43x | 0 | yes |
| theme-propagation | 3 | compose | 100426 | 99805–120307 | 1.04x | 573 | 11.69x | 2 | yes |
| theme-propagation | 3 | fusion | 101628 | 98742–133819 | 1.05x | 875 | 17.86x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 102605 | 98190–127215 | 1.06x | 877 | 17.90x | 1 | yes |
| theme-propagation | 3 | react | 103001 | 100335–157044 | 1.07x | 2020 | 41.22x | 0 | yes |
| theme-propagation | 3 | react-reflex | 94516 | 93203–124564 | 0.98x | 2037 | 41.57x | 9 | yes |
| theme-propagation | 3 | react-upstream | 103003 | 101144–127017 | 1.07x | 2036 | 41.55x | 8 | yes |
| theme-propagation | 3 | roact | 98608 | 98410–110071 | 1.02x | 3271 | 66.76x | 0 | yes |
| theme-propagation | 3 | seam | 94032 | 93318–94441 | 0.97x | 3478 | 70.98x | 0 | yes |
| theme-propagation | 3 | signals | 101300 | 99621–101813 | 1.05x | 912 | 18.61x | 8 | yes |
| theme-propagation | 3 | vide | 109709 | 99251–114517 | 1.13x | 598 | 12.20x | 0 | yes |
| hud-per-frame | 1 | plain | 2700 | 2400–3300 | 1.00x | 4 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 6801 | 6000–7100 | 2.52x | 80 | 20.00x | 1 | yes |
| hud-per-frame | 1 | compose | 5800 | 4500–6301 | 2.15x | 29 | 7.25x | 2 | yes |
| hud-per-frame | 1 | fusion | 10800 | 10300–11700 | 4.00x | 54 | 13.50x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13400 | 13200–14600 | 4.96x | 84 | 21.00x | 0 | yes |
| hud-per-frame | 1 | react | 5100 | 4800–6517 | 1.89x | 33 | 8.25x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 8400 | 7800–10100 | 3.11x | 63 | 15.75x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 5201 | 4200–6300 | 1.93x | 42 | 10.50x | 0 | yes |
| hud-per-frame | 1 | roact | 4800 | 4100–5300 | 1.78x | 70 | 17.50x | 1 | yes |
| hud-per-frame | 1 | seam | 10200 | 9336–11000 | 3.78x | 177 | 44.25x | 8 | yes |
| hud-per-frame | 1 | signals | 5700 | 5300–6400 | 2.11x | 66 | 16.50x | 1 | yes |
| hud-per-frame | 1 | vide | 5300 | 4500–6300 | 1.96x | 25 | 6.25x | 0 | yes |
| teardown-under-load | 1 | plain | 39419 | 38700–39738 | 1.00x | 4 | 1.00x | 8 | yes |
| teardown-under-load | 1 | blend | 55407 | 53903–57616 | 1.41x | 7 | 1.75x | 0 | yes |
| teardown-under-load | 1 | compose | 46402 | 46109–47103 | 1.18x | 8 | 2.00x | 10 | yes |
| teardown-under-load | 1 | fusion | 71600 | 68002–76997 | 1.82x | 6 | 1.50x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 68986 | 67407–76252 | 1.75x | 8 | 2.00x | 1 | yes |
| teardown-under-load | 1 | react | 60600 | 57192–64456 | 1.54x | 1070 | 267.50x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 62800 | 59643–66447 | 1.59x | 1071 | 267.75x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 60830 | 58648–67651 | 1.54x | 1086 | 271.50x | 7 | yes |
| teardown-under-load | 1 | roact | 51704 | 50200–62541 | 1.31x | 71 | 17.75x | 1 | yes |
| teardown-under-load | 1 | seam | 70403 | 58700–81704 | 1.79x | 17 | 4.25x | 15 | yes |
| teardown-under-load | 1 | signals | 47114 | 46201–49544 | 1.20x | 6 | 1.50x | 1 | yes |
| teardown-under-load | 1 | vide | 47521 | 46520–49173 | 1.21x | 5 | 1.25x | 1 | yes |
| open-close-retention | 1 | plain | 106801 | 105119–109303 | 1.00x | 4 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 123629 | 123105–125500 | 1.16x | 8 | 2.00x | 0 | yes |
| open-close-retention | 1 | compose | 93204 | 90926–93605 | 0.87x | 9 | 2.25x | 2 | yes |
| open-close-retention | 1 | fusion | 132901 | 132607–134411 | 1.24x | 14 | 3.50x | 8 | yes |
| open-close-retention | 1 | fusion-charm | 138801 | 138300–141113 | 1.30x | 8 | 2.00x | 0 | yes |
| open-close-retention | 1 | react | 126610 | 126203–129100 | 1.19x | 300 | 74.88x | 0 | yes |
| open-close-retention | 1 | react-reflex | 135063 | 129760–151043 | 1.26x | 290 | 72.62x | 0 | yes |
| open-close-retention | 1 | react-upstream | 127200 | 125202–130209 | 1.19x | 289 | 72.25x | 2 | yes |
| open-close-retention | 1 | roact | 112603 | 109003–114101 | 1.05x | 25 | 6.25x | 1 | yes |
| open-close-retention | 1 | seam | 129425 | 125203–130550 | 1.21x | 6 | 1.50x | 8 | yes |
| open-close-retention | 1 | signals | 96102 | 93000–96701 | 0.90x | 7 | 1.75x | 1 | yes |
| open-close-retention | 1 | vide | 95155 | 94500–96943 | 0.89x | 14 | 3.50x | 1 | yes |
| tree-expand-collapse | 1 | plain | 7100 | 6900–7317 | 1.00x | 51 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 20102 | 19506–21842 | 2.83x | 810 | 15.88x | 1 | yes |
| tree-expand-collapse | 1 | compose | 12500 | 11800–15309 | 1.76x | 80 | 1.57x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24700 | 23300–26383 | 3.48x | 166 | 3.25x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 25007 | 22002–27000 | 3.52x | 167 | 3.27x | 1 | yes |
| tree-expand-collapse | 1 | react | 18803 | 18503–20300 | 2.65x | 11 | 0.22x | 1 | yes |
| tree-expand-collapse | 1 | react-reflex | 19604 | 18800–20700 | 2.76x | 628 | 12.31x | 5 | yes |
| tree-expand-collapse | 1 | react-upstream | 19600 | 19228–21529 | 2.76x | 4 | 0.08x | 2 | yes |
| tree-expand-collapse | 1 | roact | 11300 | 10500–11600 | 1.59x | 40 | 0.78x | 8 | yes |
| tree-expand-collapse | 1 | seam | 27400 | 27200–32639 | 3.86x | 141 | 2.76x | 0 | yes |
| tree-expand-collapse | 1 | signals | 9700 | 9200–10200 | 1.37x | 38 | 0.75x | 0 | yes |
| tree-expand-collapse | 1 | vide | 13000 | 11905–13900 | 1.83x | 71 | 1.39x | 8 | yes |
| form-validation | 1 | plain | 2700 | 2700–3062 | 1.00x | 5 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 8500 | 8300–9900 | 3.15x | 202 | 40.40x | 1 | yes |
| form-validation | 1 | compose | 8600 | 7700–9100 | 3.19x | 92 | 18.40x | 2 | yes |
| form-validation | 1 | fusion | 9700 | 8900–9800 | 3.59x | 118 | 23.60x | 0 | yes |
| form-validation | 1 | fusion-charm | 9900 | 9500–11100 | 3.67x | 155 | 31.00x | 0 | yes |
| form-validation | 1 | react | 8600 | 8000–9400 | 3.19x | 61 | 12.20x | 0 | yes |
| form-validation | 1 | react-reflex | 9700 | 9400–10500 | 3.59x | 63 | 12.60x | 1 | yes |
| form-validation | 1 | react-upstream | 9500 | 8600–15600 | 3.52x | 70 | 14.00x | 0 | yes |
| form-validation | 1 | roact | 8200 | 7600–8500 | 3.04x | 158 | 31.60x | 0 | yes |
| form-validation | 1 | seam | 9402 | 7900–10202 | 3.48x | 350 | 70.00x | 0 | yes |
| form-validation | 1 | signals | 8600 | 7800–9200 | 3.19x | 156 | 31.20x | 1 | yes |
| form-validation | 1 | vide | 8400 | 7400–8801 | 3.11x | 68 | 13.60x | 1 | yes |
| table-sort-filter | 1 | plain | 13705 | 13206–14700 | 1.00x | 89 | 1.00x | 9 | yes |
| table-sort-filter | 1 | blend | 39714 | 36120–43700 | 2.90x | 6122 | 68.79x | 0 | yes |
| table-sort-filter | 1 | compose | 22200 | 21804–23300 | 1.62x | 1633 | 18.35x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 56724 | 56138–62466 | 4.14x | 4696 | 52.76x | 2 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 55443 | 50921–55950 | 4.05x | 4714 | 52.97x | 0 | yes |
| table-sort-filter | 1 | react | 76725 | 69705–88432 | 5.60x | 2985 | 33.54x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 79045 | 74259–90802 | 5.77x | 2992 | 33.62x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 75008 | 74502–83389 | 5.47x | 2993 | 33.63x | 3 | yes |
| table-sort-filter | 1 | roact | 22478 | 21602–23309 | 1.64x | 1011 | 11.36x | 0 | yes |
| table-sort-filter | 1 | seam | 57000 | 52103–63207 | 4.16x | 7736 | 86.92x | 1 | yes |
| table-sort-filter | 1 | signals | 15200 | 15000–15400 | 1.11x | 93 | 1.04x | 1 | yes |
| table-sort-filter | 1 | vide | 24900 | 23501–25702 | 1.82x | 1922 | 21.60x | 8 | yes |
| library-load | 1 | plain | 56 | 55–66 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 838 | 824–948 | 14.88x | 459 | 459.00x | 457 | yes |
| library-load | 1 | compose | 742 | 735–837 | 13.19x | 67 | 67.00x | 64 | yes |
| library-load | 1 | fusion | 2184 | 2131–2315 | 38.79x | 263 | 263.00x | 254 | yes |
| library-load | 1 | fusion-charm | 2543 | 2420–2558 | 45.17x | 318 | 318.00x | 317 | yes |
| library-load | 1 | react | 6061 | 5709–6185 | 107.66x | 1826 | 1826.00x | 1832 | yes |
| library-load | 1 | react-reflex | 9939 | 7975–11275 | 176.53x | 1976 | 1976.00x | 1980 | yes |
| library-load | 1 | react-upstream | 5879 | 5723–5956 | 104.42x | 1994 | 1994.00x | 1993 | yes |
| library-load | 1 | roact | 557 | 522–630 | 9.90x | 160 | 160.00x | 150 | yes |
| library-load | 1 | seam | 2194 | 2126–2361 | 38.97x | 234 | 234.00x | 240 | yes |
| library-load | 1 | signals | 281 | 279–319 | 4.99x | 50 | 50.00x | 49 | yes |
| library-load | 1 | vide | 464 | 441–514 | 8.25x | 146 | 146.00x | 146 | yes |
| rows-append-1000 | 1 | plain | 141004 | 139600–144900 | 1.00x | 3656 | 1.00x | 8 | yes |
| rows-append-1000 | 1 | blend | 214349 | 211105–217602 | 1.52x | 38513 | 10.53x | 1 | yes |
| rows-append-1000 | 1 | compose | 169100 | 165501–174621 | 1.20x | 11040 | 3.02x | 10 | yes |
| rows-append-1000 | 1 | fusion | 312016 | 296007–332204 | 2.21x | 20730 | 5.67x | 8 | yes |
| rows-append-1000 | 1 | fusion-charm | 301430 | 296917–303503 | 2.14x | 28601 | 7.82x | 8 | yes |
| rows-append-1000 | 1 | react | 209016 | 200332–259540 | 1.48x | 18379 | 5.03x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 219205 | 202627–244409 | 1.55x | 19996 | 5.47x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 213905 | 211003–246512 | 1.52x | 18156 | 4.97x | 80 | yes |
| rows-append-1000 | 1 | roact | 183806 | 165905–185504 | 1.30x | 26707 | 7.30x | 8198 | yes |
| rows-append-1000 | 1 | seam | 250224 | 232406–275822 | 1.77x | 46430 | 12.70x | 232 | yes |
| rows-append-1000 | 1 | signals | 164212 | 150914–175119 | 1.16x | 17494 | 4.78x | 228 | yes |
| rows-append-1000 | 1 | vide | 165616 | 153506–212618 | 1.17x | 10439 | 2.86x | 0 | yes |
| rows-clear | 1 | plain | 19500 | 19300–19821 | 1.00x | 1251 | 1.00x | 9 | yes |
| rows-clear | 1 | blend | 39602 | 39010–50514 | 2.03x | 4177 | 3.34x | 1 | yes |
| rows-clear | 1 | compose | 27110 | 25880–27801 | 1.39x | 1886 | 1.51x | 11 | yes |
| rows-clear | 1 | fusion | 55061 | 54151–55207 | 2.82x | 3433 | 2.74x | 0 | yes |
| rows-clear | 1 | fusion-charm | 51334 | 50600–52312 | 2.63x | 7345 | 5.87x | 1 | yes |
| rows-clear | 1 | react | 27500 | 26700–28300 | 1.41x | 4488 | 3.59x | 0 | yes |
| rows-clear | 1 | react-reflex | 31216 | 30600–50511 | 1.60x | 6674 | 5.33x | 57 | yes |
| rows-clear | 1 | react-upstream | 28409 | 27305–30703 | 1.46x | 4480 | 3.58x | 1 | yes |
| rows-clear | 1 | roact | 26623 | 25925–31306 | 1.37x | 4197 | 3.35x | 0 | yes |
| rows-clear | 1 | seam | 35800 | 34095–51308 | 1.84x | 9179 | 7.34x | 0 | yes |
| rows-clear | 1 | signals | 24703 | 24127–26000 | 1.27x | 4419 | 3.53x | 1 | yes |
| rows-clear | 1 | vide | 23506 | 23000–26000 | 1.21x | 1597 | 1.28x | 0 | yes |
| rows-create-1000 | 1 | plain | 141802 | 140989–144215 | 1.00x | 1837 | 1.00x | 1 | yes |
| rows-create-1000 | 1 | blend | 209059 | 188435–226319 | 1.47x | 19484 | 10.61x | 0 | yes |
| rows-create-1000 | 1 | compose | 164904 | 159859–176172 | 1.16x | 5594 | 3.05x | 3 | yes |
| rows-create-1000 | 1 | fusion | 224793 | 194804–277628 | 1.59x | 10619 | 5.78x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 229747 | 214428–245964 | 1.62x | 14565 | 7.93x | 1 | yes |
| rows-create-1000 | 1 | react | 203862 | 196123–228771 | 1.44x | 8655 | 4.71x | 8 | yes |
| rows-create-1000 | 1 | react-reflex | 248326 | 194408–339769 | 1.75x | 9580 | 5.22x | 80 | yes |
| rows-create-1000 | 1 | react-upstream | 203189 | 190034–247794 | 1.43x | 8630 | 4.70x | 8 | yes |
| rows-create-1000 | 1 | roact | 181627 | 172910–184729 | 1.28x | 13587 | 7.40x | 4197 | yes |
| rows-create-1000 | 1 | seam | 222540 | 209175–234127 | 1.57x | 23534 | 12.81x | 4 | yes |
| rows-create-1000 | 1 | signals | 164813 | 152508–188444 | 1.16x | 9082 | 4.94x | 1 | yes |
| rows-create-1000 | 1 | vide | 170884 | 163315–197919 | 1.21x | 4949 | 2.69x | 0 | yes |
| rows-create-10000 | 1 | plain | 1662322 | 1655008–1751837 | 1.00x | 17005 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 2481393 | 2362263–2500056 | 1.49x | 187669 | 11.04x | 0 | yes |
| rows-create-10000 | 1 | compose | 2122862 | 2070680–2143986 | 1.28x | 55706 | 3.28x | 10 | yes |
| rows-create-10000 | 1 | fusion | 5611951 | 5189332–5699201 | 3.38x | 104950 | 6.17x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 5891020 | 5756381–5957611 | 3.54x | 144872 | 8.52x | 8 | yes |
| rows-create-10000 | 1 | react | 4661828 | 4516547–4708903 | 2.80x | 84356 | 4.96x | 428 | yes |
| rows-create-10000 | 1 | react-reflex | 4536413 | 4522208–4550308 | 2.73x | 93328 | 5.49x | 828 | yes |
| rows-create-10000 | 1 | react-upstream | 4393842 | 4288732–4543549 | 2.64x | 85510 | 5.03x | 176 | yes |
| rows-create-10000 | 1 | roact | 2147773 | 2092055–2152904 | 1.29x | 134146 | 7.89x | 41272 | yes |
| rows-create-10000 | 1 | seam | 2534444 | 2448344–3129530 | 1.52x | 235490 | 13.85x | 0 | yes |
| rows-create-10000 | 1 | signals | 1944198 | 1829820–1966387 | 1.17x | 89214 | 5.25x | 0 | yes |
| rows-create-10000 | 1 | vide | 1893347 | 1855076–2227624 | 1.14x | 48530 | 2.85x | 16 | yes |
| rows-remove-one | 1 | plain | 300 | 200–350 | 1.00x | 1421 | 1.00x | 9 | yes |
| rows-remove-one | 1 | blend | 1400 | 1300–1500 | 4.67x | 18577 | 13.07x | 232 | yes |
| rows-remove-one | 1 | compose | 950 | 700–1300 | 3.17x | 4956 | 3.49x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 33900 | 32200–36100 | 113.00x | 11002 | 7.74x | 9 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 33313 | 31800–51129 | 111.04x | 14930 | 10.51x | 2 | yes |
| rows-remove-one | 1 | react | 15906 | 11500–64109 | 53.02x | 13168 | 9.27x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 20225 | 16300–50506 | 67.42x | 14094 | 9.92x | 56 | yes |
| rows-remove-one | 1 | react-upstream | 16300 | 13308–18200 | 54.33x | 13161 | 9.26x | 0 | yes |
| rows-remove-one | 1 | roact | 7300 | 7100–9106 | 24.33x | 13791 | 9.71x | 4177 | yes |
| rows-remove-one | 1 | seam | 7700 | 6700–8200 | 25.67x | 23101 | 16.26x | 0 | yes |
| rows-remove-one | 1 | signals | 1600 | 1511–1803 | 5.33x | 8638 | 6.08x | 0 | yes |
| rows-remove-one | 1 | vide | 1350 | 1100–1650 | 4.50x | 4561 | 3.21x | 1 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 1861 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 700 | 500–900 | 7.00x | 18811 | 10.11x | 1 | yes |
| rows-swap | 1 | compose | 150 | 100–350 | 1.50x | 5375 | 2.89x | 2 | yes |
| rows-swap | 1 | fusion | 32100 | 30801–32706 | 321.00x | 9999 | 5.37x | 0 | yes |
| rows-swap | 1 | fusion-charm | 30600 | 30000–37405 | 306.00x | 14227 | 7.64x | 1 | yes |
| rows-swap | 1 | react | 23000 | 22500–27633 | 230.00x | 9846 | 5.29x | 0 | yes |
| rows-swap | 1 | react-reflex | 26002 | 23933–28912 | 260.02x | 10834 | 5.82x | 64 | yes |
| rows-swap | 1 | react-upstream | 22800 | 22306–23800 | 228.00x | 9893 | 5.32x | 0 | yes |
| rows-swap | 1 | roact | 1950 | 1700–1950 | 19.50x | 13355 | 7.18x | 4004 | yes |
| rows-swap | 1 | seam | 6100 | 5700–6600 | 61.00x | 23560 | 12.66x | 0 | yes |
| rows-swap | 1 | signals | 350 | 200–550 | 3.50x | 9098 | 4.89x | 1 | yes |
| rows-swap | 1 | vide | 100 | 100–100 | 1.00x | 4973 | 2.67x | 0 | yes |
| rows-update-every-10th | 1 | plain | 3700 | 3500–4300 | 1.00x | 1412 | 1.00x | 8 | yes |
| rows-update-every-10th | 1 | blend | 4000 | 3700–4500 | 1.08x | 18771 | 13.29x | 8 | yes |
| rows-update-every-10th | 1 | compose | 3800 | 3600–4300 | 1.03x | 5001 | 3.54x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 4005 | 4000–4300 | 1.08x | 9999 | 7.08x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4300 | 3900–5000 | 1.16x | 13895 | 9.84x | 0 | yes |
| rows-update-every-10th | 1 | react | 4100 | 3900–4200 | 1.11x | 8622 | 6.11x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 5400 | 5000–5701 | 1.46x | 9555 | 6.77x | 71 | yes |
| rows-update-every-10th | 1 | react-upstream | 4000 | 3800–4100 | 1.08x | 8279 | 5.86x | 80 | yes |
| rows-update-every-10th | 1 | roact | 3900 | 3800–4700 | 1.05x | 13398 | 9.49x | 0 | yes |
| rows-update-every-10th | 1 | seam | 9100 | 7500–10000 | 2.46x | 23568 | 16.69x | 8 | yes |
| rows-update-every-10th | 1 | signals | 3900 | 3605–5000 | 1.05x | 8802 | 6.23x | 1 | yes |
| rows-update-every-10th | 1 | vide | 4200 | 3800–5100 | 1.14x | 4653 | 3.30x | 1 | yes |

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
| blend | 30 | 2.96x | 16.97x | 3.03x | 16.81x |
| compose | 30 | 2.30x | 6.14x | 2.28x | 6.08x |
| fusion | 30 | 6.39x | 8.96x | 6.35x | 8.82x |
| fusion-charm | 30 | 6.03x | 11.97x | 5.97x | 11.90x |
| react | 29 | 5.20x | 9.05x | 5.20x | 9.05x |
| react-reflex | 29 | 5.72x | 16.49x | 5.72x | 16.49x |
| react-upstream | 29 | 5.27x | 8.77x | 5.27x | 8.77x |
| roact | 29 | 3.01x | 8.07x | 3.01x | 8.07x |
| seam | 30 | 4.80x | 19.33x | 4.88x | 18.91x |
| signals | 29 | 2.22x | 4.72x | 2.22x | 4.72x |
| vide | 30 | 2.32x | 5.31x | 2.31x | 5.33x |
