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
| Harness revision | `82fbc16` |
| Date | 2026-11-13 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 500 | 400–800 | 1.00x | 49 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 2200 | 2200–2533 | 4.40x | 757 | 15.45x | 1 | yes |
| update-leaf | 20 | compose | 2200 | 2100–2550 | 4.40x | 94 | 1.92x | 2 | yes |
| update-leaf | 20 | fusion | 2550 | 2100–2600 | 5.10x | 51 | 1.04x | 0 | yes |
| update-leaf | 20 | fusion-charm | 2650 | 2350–2800 | 5.30x | 54 | 1.10x | 0 | yes |
| update-leaf | 20 | react | 2150 | 1900–2250 | 4.30x | 348 | 7.10x | 0 | yes |
| update-leaf | 20 | react-reflex | 2600 | 2400–2700 | 5.20x | 292 | 5.96x | 0 | yes |
| update-leaf | 20 | react-upstream | 2350 | 2200–2500 | 4.70x | 291 | 5.94x | 1 | yes |
| update-leaf | 20 | roact | 2267 | 2167–2433 | 4.53x | 959 | 19.57x | 8 | yes |
| update-leaf | 20 | seam | 2350 | 2050–2850 | 4.70x | 40 | 0.82x | 0 | yes |
| update-leaf | 20 | signals | 2400 | 2350–2550 | 4.80x | 50 | 1.02x | 0 | yes |
| update-leaf | 20 | vide | 2650 | 2300–2800 | 5.30x | 2 | 0.04x | 0 | yes |
| update-batched | 20 | plain | 4100 | 4000–4252 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 10900 | 10300–11700 | 2.66x | 917 | 43.67x | 1 | yes |
| update-batched | 20 | compose | 7400 | 6900–8203 | 1.80x | 407 | 19.38x | 10 | yes |
| update-batched | 20 | fusion | 21000 | 20600–21601 | 5.12x | 500 | 23.81x | 0 | yes |
| update-batched | 20 | fusion-charm | 37001 | 34800–39200 | 9.02x | 1093 | 52.05x | 0 | yes |
| update-batched | 20 | react | 8300 | 8100–8600 | 2.02x | 533 | 25.38x | 0 | yes |
| update-batched | 20 | react-reflex | 63338 | 56458–74228 | 15.45x | 775 | 36.90x | 9 | yes |
| update-batched | 20 | react-upstream | 8100 | 7500–8900 | 1.98x | 476 | 22.67x | 0 | yes |
| update-batched | 20 | roact | 9917 | 8100–11400 | 2.42x | 1170 | 55.71x | 9 | yes |
| update-batched | 20 | seam | 14303 | 12800–16212 | 3.49x | 1833 | 87.29x | 1 | yes |
| update-batched | 20 | signals | 9200 | 8600–9801 | 2.24x | 604 | 28.76x | 0 | yes |
| update-batched | 20 | vide | 8000 | 7600–8900 | 1.95x | 332 | 15.81x | 0 | yes |
| update-repeated | 10 | plain | 40 | 38–45 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3000 | 2650–3066 | 74.52x | 8 | 4.00x | 1 | yes |
| update-repeated | 10 | compose | 433 | 356–467 | 10.76x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 23600 | 22803–24014 | 586.23x | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion-charm | 1050 | 900–1150 | 26.08x | 7 | 3.50x | 1 | yes |
| update-repeated | 10 | react | 5500 | 4900–6000 | 136.62x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 800 | 729–871 | 19.88x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 5000 | 4600–5401 | 124.20x | 1 | 0.50x | 1 | yes |
| update-repeated | 10 | roact | 5602 | 5400–6200 | 139.15x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1333 | 1200–1567 | 33.12x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 786 | 700–886 | 19.52x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 578 | 400–611 | 14.35x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 20011 | 19500–23800 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 29100 | 28300–29202 | 1.45x | 27 | 13.50x | 0 | yes |
| branch-swap | 20 | compose | 26400 | 25100–27002 | 1.32x | 7 | 3.50x | 2 | yes |
| branch-swap | 20 | fusion | 32714 | 25902–43808 | 1.63x | 29 | 14.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 26414 | 24500–28835 | 1.32x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 28100 | 25900–31608 | 1.40x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 26703 | 25700–27848 | 1.33x | 11 | 5.50x | 1 | yes |
| branch-swap | 20 | react-upstream | 27100 | 26406–29100 | 1.35x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | roact | 27747 | 26708–31600 | 1.39x | 12 | 6.00x | 1 | yes |
| branch-swap | 20 | seam | 23301 | 22306–27745 | 1.16x | 11 | 5.50x | 1 | yes |
| branch-swap | 20 | signals | 24900 | 23900–26100 | 1.24x | 13 | 6.50x | 9 | yes |
| branch-swap | 20 | vide | 26005 | 25200–27900 | 1.30x | 5 | 2.50x | 0 | yes |
| keyed-prepend | 10 | plain | 1700 | 1667–1734 | 1.00x | 64 | 1.00x | 8 | yes |
| keyed-prepend | 10 | blend | 4504 | 4450–4800 | 2.65x | 1483 | 23.17x | 0 | yes |
| keyed-prepend | 10 | compose | 4050 | 4000–4500 | 2.38x | 571 | 8.92x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 18800 | 18500–21502 | 11.06x | 1520 | 23.75x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 19200 | 18500–19801 | 11.29x | 1514 | 23.66x | 1 | yes |
| keyed-prepend | 10 | react | 10700 | 10100–11000 | 6.29x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 11700 | 10600–12506 | 6.88x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 11000 | 9702–12702 | 6.47x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | roact | 5701 | 5600–6400 | 3.35x | 361 | 5.64x | 0 | yes |
| keyed-prepend | 10 | seam | 11300 | 10200–12002 | 6.65x | 2447 | 38.23x | 1 | yes |
| keyed-prepend | 10 | signals | 2450 | 2400–2650 | 1.44x | 62 | 0.97x | 1 | yes |
| keyed-prepend | 10 | vide | 4750 | 4600–5904 | 2.79x | 647 | 10.11x | 9 | yes |
| keyed-insert | 10 | plain | 1150 | 1078–1250 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4458 | 3900–4660 | 3.88x | 1498 | 23.41x | 0 | yes |
| keyed-insert | 10 | compose | 3050 | 2750–3250 | 2.65x | 563 | 8.80x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 17600 | 17201–17906 | 15.30x | 1535 | 23.98x | 9 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 16006 | 15600–17900 | 13.92x | 1529 | 23.89x | 9 | yes |
| keyed-insert | 10 | react | 12523 | 9800–13204 | 10.89x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9800 | 9200–9901 | 8.52x | 867 | 13.55x | 0 | yes |
| keyed-insert | 10 | react-upstream | 10400 | 9244–11845 | 9.04x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 5200 | 4700–5300 | 4.52x | 369 | 5.77x | 1 | yes |
| keyed-insert | 10 | seam | 11200 | 10500–11803 | 9.74x | 2456 | 38.38x | 1 | yes |
| keyed-insert | 10 | signals | 1933 | 1767–2133 | 1.68x | 62 | 0.97x | 1 | yes |
| keyed-insert | 10 | vide | 3450 | 3300–3600 | 3.00x | 646 | 10.09x | 0 | yes |
| keyed-shuffle | 10 | plain | 1108 | 1042–1160 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2650 | 2500–2800 | 2.39x | 1432 | 23.87x | 1 | yes |
| keyed-shuffle | 10 | compose | 3650 | 2400–4750 | 3.29x | 578 | 9.63x | 10 | yes |
| keyed-shuffle | 10 | fusion | 16306 | 15500–18911 | 14.72x | 1399 | 23.32x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 17418 | 13800–20107 | 15.72x | 1393 | 23.22x | 0 | yes |
| keyed-shuffle | 10 | react | 16021 | 14701–19502 | 14.46x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 15300 | 14903–16100 | 13.81x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 15300 | 14100–15602 | 13.81x | 778 | 12.97x | 0 | yes |
| keyed-shuffle | 10 | roact | 4803 | 4550–4900 | 4.34x | 361 | 6.02x | 0 | yes |
| keyed-shuffle | 10 | seam | 9000 | 8600–10200 | 8.12x | 2438 | 40.63x | 0 | yes |
| keyed-shuffle | 10 | signals | 1700 | 1675–1800 | 1.53x | 61 | 1.02x | 1 | yes |
| keyed-shuffle | 10 | vide | 3000 | 2700–3100 | 2.71x | 629 | 10.48x | 1 | yes |
| events | 1 | plain | 2800 | 2600–3500 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 3200 | 2600–3500 | 1.14x | 0 | 0.50x | 0 | yes |
| events | 1 | compose | 3600 | 2800–4101 | 1.29x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 3600 | 3500–4200 | 1.29x | 0 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 2800 | 2400–3901 | 1.00x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 3900 | 2500–4300 | 1.39x | 1 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 3700 | 3500–4000 | 1.32x | 9 | 4.50x | 8 | yes |
| events | 1 | react-upstream | 2500 | 2000–3300 | 0.89x | 1 | 0.50x | 1 | yes |
| events | 1 | roact | 2400 | 2000–3000 | 0.86x | 2 | 1.00x | 1 | yes |
| events | 1 | seam | 2100 | 1700–2600 | 0.75x | 1 | 0.50x | 0 | yes |
| events | 1 | signals | 2400 | 2023–2500 | 0.86x | 2 | 1.00x | 1 | yes |
| events | 1 | vide | 3100 | 2200–3400 | 1.11x | 2 | 1.00x | 1 | yes |
| animate-many | 1 | plain | 2850 | 2250–3000 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 10705 | 10300–12600 | 3.76x | 1770 | 23.92x | 0 | yes |
| animate-many | 1 | compose | 7900 | 7200–12900 | 2.77x | 655 | 8.85x | 12 | yes |
| animate-many | 1 | fusion | 73278 | 72925–74406 | 25.71x | 1120 | 15.14x | 0 | yes |
| animate-many | 1 | fusion-charm | 73706 | 72722–76060 | 25.86x | 1130 | 15.27x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 22913 | 21800–26509 | 8.04x | 2889 | 39.04x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 10800 | 9200–11200 | 3.79x | 384 | 5.19x | 0 | yes |
| status-panel | 10 | plain | 1000 | 800–1150 | 1.00x | 2 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 2500 | 2400–2700 | 2.50x | 78 | 39.00x | 0 | yes |
| status-panel | 10 | compose | 2450 | 2350–2650 | 2.45x | 33 | 16.50x | 2 | yes |
| status-panel | 10 | fusion | 2950 | 2650–3100 | 2.95x | 64 | 32.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 2904 | 2850–3150 | 2.90x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | react | 3400 | 3150–3900 | 3.40x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | react-reflex | 3400 | 3200–3650 | 3.40x | 45 | 22.50x | 1 | yes |
| status-panel | 10 | react-upstream | 3400 | 3150–3650 | 3.40x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | roact | 2300 | 2200–2400 | 2.30x | 25 | 12.50x | 0 | yes |
| status-panel | 10 | seam | 3152 | 2850–3300 | 3.15x | 141 | 70.50x | 0 | yes |
| status-panel | 10 | signals | 2233 | 2067–2267 | 2.23x | 14 | 7.00x | 0 | yes |
| status-panel | 10 | vide | 2450 | 2100–2600 | 2.45x | 32 | 16.00x | 1 | yes |
| scene-3d | 10 | plain | 2069 | 2033–2368 | 1.00x | 10 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4700 | 4550–5100 | 2.27x | 550 | 55.00x | 1 | yes |
| scene-3d | 10 | compose | 3250 | 3200–3350 | 1.57x | 195 | 19.50x | 2 | yes |
| scene-3d | 10 | fusion | 22200 | 20000–24458 | 10.73x | 520 | 52.00x | 8 | yes |
| scene-3d | 10 | fusion-charm | 21801 | 20200–22701 | 10.54x | 516 | 51.60x | 0 | yes |
| scene-3d | 10 | react | 3700 | 3500–3800 | 1.79x | 223 | 22.30x | 0 | yes |
| scene-3d | 10 | react-reflex | 4500 | 3150–4650 | 2.18x | 224 | 22.40x | 0 | yes |
| scene-3d | 10 | react-upstream | 3550 | 3400–3701 | 1.72x | 223 | 22.30x | 0 | yes |
| scene-3d | 10 | roact | 3600 | 3200–3800 | 1.74x | 574 | 57.40x | 0 | yes |
| scene-3d | 10 | seam | 8900 | 8002–9700 | 4.30x | 1762 | 176.20x | 0 | yes |
| scene-3d | 10 | signals | 5812 | 5700–6000 | 2.81x | 682 | 68.20x | 0 | yes |
| scene-3d | 10 | vide | 3900 | 3750–4150 | 1.89x | 210 | 21.00x | 0 | yes |
| derived-diamond | 3 | plain | 28 | 24–32 | 1.00x | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 165 | 159–200 | 5.86x | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 162 | 131–194 | 5.79x | 10 | 2.00x | 2 | yes |
| derived-diamond | 3 | fusion | 200 | 156–275 | 7.12x | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 169 | 146–200 | 6.02x | 10 | 2.00x | 0 | yes |
| derived-diamond | 3 | react | 375 | 317–392 | 13.35x | 6 | 1.20x | 4 | yes |
| derived-diamond | 3 | react-reflex | 350 | 320–390 | 12.46x | 18 | 3.60x | 6 | yes |
| derived-diamond | 3 | react-upstream | 363 | 330–410 | 12.93x | 6 | 1.20x | 4 | yes |
| derived-diamond | 3 | roact | 156 | 150–181 | 5.56x | 10 | 2.00x | 11 | yes |
| derived-diamond | 3 | seam | 260 | 190–420 | 9.26x | 21 | 4.20x | 0 | yes |
| derived-diamond | 3 | signals | 156 | 119–162 | 5.56x | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | vide | 150 | 144–168 | 5.34x | 6 | 1.20x | 1 | yes |
| derived-chain-100 | 3 | plain | 34 | 32–37 | 1.00x | 65 | 1.00x | 1 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 244 | 212–244 | 7.18x | 130 | 2.00x | 1 | yes |
| derived-chain-100 | 3 | fusion | 543 | 529–657 | 16.00x | 127 | 1.95x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 588 | 550–826 | 17.31x | 129 | 1.98x | 9 | yes |
| derived-chain-100 | 3 | react | 520 | 470–572 | 15.32x | 68 | 1.05x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 475 | 438–512 | 14.00x | 80 | 1.23x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 467 | 450–508 | 13.75x | 68 | 1.05x | 4 | yes |
| derived-chain-100 | 3 | roact | 182 | 159–230 | 5.37x | 11 | 0.17x | 4 | yes |
| derived-chain-100 | 3 | seam | 1020 | 740–1240 | 30.06x | 270 | 4.15x | 0 | yes |
| derived-chain-100 | 3 | signals | 212 | 194–238 | 6.26x | 174 | 2.68x | 1 | yes |
| derived-chain-100 | 3 | vide | 246 | 185–262 | 7.26x | 93 | 1.43x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 89 | 89–90 | 1.00x | 497 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 262 | 212–288 | 2.94x | 1535 | 3.09x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 338 | 306–362 | 3.77x | 688 | 1.38x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1140 | 980–1160 | 12.75x | 890 | 1.79x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1180 | 1100–1360 | 13.20x | 2821 | 5.68x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1633 | 1400–2233 | 18.27x | 671 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 9602 | 7700–11900 | 107.38x | 5626 | 11.32x | 74 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1950 | 1400–2050 | 21.81x | 670 | 1.35x | 43 | yes |
| derived-fan-in-1000 | 3 | roact | 460 | 450–560 | 5.14x | 104 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2150 | 2050–2302 | 24.05x | 2923 | 5.88x | 8 | yes |
| derived-fan-in-1000 | 3 | signals | 739 | 650–875 | 8.26x | 1213 | 2.44x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 415 | 400–431 | 4.65x | 528 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | plain | 6500 | 6200–8400 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 15800 | 14100–16400 | 2.43x | 2685 | 76.71x | 0 | yes |
| filter-as-you-type | 1 | compose | 9952 | 9005–10100 | 1.53x | 842 | 24.06x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 26000 | 23700–28202 | 4.00x | 2456 | 70.17x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26802 | 22812–28812 | 4.12x | 2459 | 70.26x | 1 | yes |
| filter-as-you-type | 1 | react | 15005 | 14701–17400 | 2.31x | 83 | 2.37x | 12 | yes |
| filter-as-you-type | 1 | react-reflex | 15715 | 15409–18625 | 2.42x | 830 | 23.71x | 23 | yes |
| filter-as-you-type | 1 | react-upstream | 15400 | 14800–18200 | 2.37x | 76 | 2.17x | 12 | yes |
| filter-as-you-type | 1 | roact | 10600 | 10426–11500 | 1.63x | 503 | 14.37x | 3 | yes |
| filter-as-you-type | 1 | seam | 22935 | 20205–30479 | 3.53x | 4028 | 115.09x | 8 | yes |
| filter-as-you-type | 1 | signals | 7500 | 6928–8200 | 1.15x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | vide | 11000 | 10603–11800 | 1.69x | 951 | 27.17x | 0 | yes |
| theme-propagation | 3 | plain | 95485 | 94307–99012 | 1.00x | 199 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 117442 | 95306–124509 | 1.23x | 2070 | 10.40x | 0 | yes |
| theme-propagation | 3 | compose | 111724 | 100200–150912 | 1.17x | 572 | 2.87x | 0 | yes |
| theme-propagation | 3 | fusion | 101479 | 100361–103621 | 1.06x | 867 | 4.36x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 102801 | 96600–141630 | 1.08x | 868 | 4.36x | 0 | yes |
| theme-propagation | 3 | react | 117731 | 99800–124114 | 1.23x | 2035 | 10.23x | 0 | yes |
| theme-propagation | 3 | react-reflex | 101812 | 92859–111614 | 1.07x | 2029 | 10.20x | 0 | yes |
| theme-propagation | 3 | react-upstream | 147601 | 101800–216915 | 1.55x | 2027 | 10.19x | 0 | yes |
| theme-propagation | 3 | roact | 114864 | 99703–125084 | 1.20x | 3278 | 16.47x | 8 | yes |
| theme-propagation | 3 | seam | 97112 | 94987–98509 | 1.02x | 3478 | 17.48x | 1 | yes |
| theme-propagation | 3 | signals | 104235 | 99366–108004 | 1.09x | 903 | 4.54x | 0 | yes |
| theme-propagation | 3 | vide | 109108 | 98600–140735 | 1.14x | 605 | 3.04x | 0 | yes |
| hud-per-frame | 1 | plain | 4200 | 2900–4200 | 1.00x | 22 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 7300 | 6800–8000 | 1.74x | 71 | 3.23x | 0 | yes |
| hud-per-frame | 1 | compose | 6500 | 5900–7100 | 1.55x | 29 | 1.32x | 2 | yes |
| hud-per-frame | 1 | fusion | 12300 | 11700–12801 | 2.93x | 54 | 2.45x | 1 | yes |
| hud-per-frame | 1 | fusion-charm | 15600 | 15400–17000 | 3.71x | 99 | 4.50x | 0 | yes |
| hud-per-frame | 1 | react | 5500 | 4603–11000 | 1.31x | 34 | 1.55x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 9900 | 9400–10700 | 2.36x | 54 | 2.45x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 6900 | 5700–7300 | 1.64x | 42 | 1.91x | 8 | yes |
| hud-per-frame | 1 | roact | 6800 | 6100–7000 | 1.62x | 90 | 4.09x | 0 | yes |
| hud-per-frame | 1 | seam | 12401 | 12100–12900 | 2.95x | 177 | 8.05x | 9 | yes |
| hud-per-frame | 1 | signals | 6800 | 6500–8500 | 1.62x | 74 | 3.36x | 0 | yes |
| hud-per-frame | 1 | vide | 8000 | 7300–8800 | 1.90x | 33 | 1.50x | 0 | yes |
| teardown-under-load | 1 | plain | 41004 | 39301–41103 | 1.00x | 6 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 57400 | 54115–62303 | 1.40x | 6 | 1.00x | 0 | yes |
| teardown-under-load | 1 | compose | 46803 | 46302–48022 | 1.14x | 7 | 1.17x | 1 | yes |
| teardown-under-load | 1 | fusion | 75878 | 67509–80394 | 1.85x | 13 | 2.17x | 9 | yes |
| teardown-under-load | 1 | fusion-charm | 71534 | 67614–77005 | 1.74x | 6 | 1.00x | 0 | yes |
| teardown-under-load | 1 | react | 60340 | 58909–68301 | 1.47x | 1078 | 179.67x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 61087 | 58343–63300 | 1.49x | 1079 | 179.83x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 59751 | 57514–65024 | 1.46x | 1069 | 178.17x | 0 | yes |
| teardown-under-load | 1 | roact | 61300 | 54608–71509 | 1.49x | 70 | 11.67x | 0 | yes |
| teardown-under-load | 1 | seam | 67007 | 59872–68200 | 1.63x | 8 | 1.33x | 6 | yes |
| teardown-under-load | 1 | signals | 48351 | 47376–50016 | 1.18x | 13 | 2.17x | 1 | yes |
| teardown-under-load | 1 | vide | 49111 | 48903–53017 | 1.20x | 4 | 0.67x | 0 | yes |
| open-close-retention | 1 | plain | 68801 | 66804–71713 | 1.00x | 23 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 116022 | 114458–120727 | 1.69x | 6 | 0.26x | 1 | yes |
| open-close-retention | 1 | compose | 83655 | 83336–86814 | 1.22x | 15 | 0.65x | 1 | yes |
| open-close-retention | 1 | fusion | 141588 | 137585–143545 | 2.06x | 5 | 0.22x | 1 | yes |
| open-close-retention | 1 | fusion-charm | 142345 | 140124–144642 | 2.07x | 7 | 0.30x | 0 | yes |
| open-close-retention | 1 | react | 116565 | 115331–130101 | 1.69x | 284 | 12.35x | 0 | yes |
| open-close-retention | 1 | react-reflex | 118038 | 115068–120740 | 1.72x | 292 | 12.70x | 0 | yes |
| open-close-retention | 1 | react-upstream | 115226 | 113227–117050 | 1.67x | 291 | 12.65x | 0 | yes |
| open-close-retention | 1 | roact | 113647 | 112517–128049 | 1.65x | 30 | 1.30x | 8 | yes |
| open-close-retention | 1 | seam | 125425 | 122288–137230 | 1.82x | 17 | 0.74x | 1 | yes |
| open-close-retention | 1 | signals | 82802 | 82225–83814 | 1.20x | 12 | 0.52x | 8 | yes |
| open-close-retention | 1 | vide | 87050 | 84100–88229 | 1.27x | 5 | 0.22x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7800 | 7300–8001 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 19700 | 18000–21063 | 2.53x | 796 | 39.80x | 8 | yes |
| tree-expand-collapse | 1 | compose | 11700 | 11400–14000 | 1.50x | 72 | 3.60x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 29324 | 23400–35205 | 3.76x | 165 | 8.25x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 25935 | 21939–29200 | 3.33x | 167 | 8.35x | 0 | yes |
| tree-expand-collapse | 1 | react | 15740 | 14800–19019 | 2.02x | 77 | 3.85x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 15904 | 14503–22100 | 2.04x | 681 | 34.05x | 31 | yes |
| tree-expand-collapse | 1 | react-upstream | 15900 | 15000–20100 | 2.04x | 69 | 3.45x | 20 | yes |
| tree-expand-collapse | 1 | roact | 11600 | 11300–14329 | 1.49x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 28100 | 26000–30601 | 3.60x | 148 | 7.40x | 0 | yes |
| tree-expand-collapse | 1 | signals | 9100 | 8300–9902 | 1.17x | 21 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12200 | 11800–12818 | 1.56x | 62 | 3.10x | 0 | yes |
| form-validation | 1 | plain | 2900 | 2750–3204 | 1.00x | 54 | 1.00x | 8 | yes |
| form-validation | 1 | blend | 8800 | 8200–9300 | 3.03x | 331 | 6.13x | 0 | yes |
| form-validation | 1 | compose | 8900 | 8400–9700 | 3.07x | 98 | 1.81x | 2 | yes |
| form-validation | 1 | fusion | 9700 | 9103–10000 | 3.34x | 118 | 2.19x | 1 | yes |
| form-validation | 1 | fusion-charm | 10400 | 9200–10800 | 3.59x | 155 | 2.87x | 0 | yes |
| form-validation | 1 | react | 9100 | 8501–9501 | 3.14x | 65 | 1.20x | 0 | yes |
| form-validation | 1 | react-reflex | 9900 | 9800–10300 | 3.41x | 75 | 1.39x | 1 | yes |
| form-validation | 1 | react-upstream | 9000 | 8601–9800 | 3.10x | 66 | 1.22x | 0 | yes |
| form-validation | 1 | roact | 9300 | 8900–10400 | 3.21x | 224 | 4.15x | 0 | yes |
| form-validation | 1 | seam | 10500 | 10200–11800 | 3.62x | 356 | 6.59x | 0 | yes |
| form-validation | 1 | signals | 10000 | 8300–12400 | 3.45x | 155 | 2.87x | 1 | yes |
| form-validation | 1 | vide | 8400 | 8200–8800 | 2.90x | 71 | 1.31x | 0 | yes |
| table-sort-filter | 1 | plain | 15200 | 14700–15602 | 1.00x | 81 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 34015 | 32993–39408 | 2.24x | 5372 | 66.32x | 0 | yes |
| table-sort-filter | 1 | compose | 23600 | 22400–25031 | 1.55x | 1632 | 20.15x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 60601 | 51217–64612 | 3.99x | 4695 | 57.96x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 57701 | 49700–65731 | 3.80x | 4705 | 58.09x | 1 | yes |
| table-sort-filter | 1 | react | 55203 | 53840–75853 | 3.63x | 2108 | 26.02x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 58721 | 56277–60544 | 3.86x | 2115 | 26.11x | 15 | yes |
| table-sort-filter | 1 | react-upstream | 57066 | 54964–63756 | 3.75x | 2108 | 26.02x | 27 | yes |
| table-sort-filter | 1 | roact | 23200 | 22607–24361 | 1.53x | 1014 | 12.52x | 3 | yes |
| table-sort-filter | 1 | seam | 62344 | 56992–70474 | 4.10x | 7751 | 95.69x | 1 | yes |
| table-sort-filter | 1 | signals | 16805 | 16311–18700 | 1.11x | 75 | 0.93x | 1 | yes |
| table-sort-filter | 1 | vide | 27800 | 24409–30900 | 1.83x | 1922 | 23.73x | 0 | yes |
| library-load | 1 | plain | 61 | 60–64 | 1.00x | 1 | 1.00x | 8 | yes |
| library-load | 1 | blend | 833 | 817–923 | 13.61x | 460 | 460.00x | 456 | yes |
| library-load | 1 | compose | 763 | 724–794 | 12.46x | 66 | 66.00x | 64 | yes |
| library-load | 1 | fusion | 2325 | 2245–2489 | 38.00x | 263 | 263.00x | 253 | yes |
| library-load | 1 | fusion-charm | 2245 | 2097–2931 | 36.68x | 310 | 310.00x | 308 | yes |
| library-load | 1 | react | 5763 | 5610–6315 | 94.16x | 1825 | 1825.00x | 1823 | yes |
| library-load | 1 | react-reflex | 6129 | 5902–6231 | 100.15x | 1973 | 1973.00x | 1972 | yes |
| library-load | 1 | react-upstream | 6049 | 5780–6418 | 98.85x | 1995 | 1995.00x | 1994 | yes |
| library-load | 1 | roact | 536 | 525–578 | 8.76x | 162 | 162.00x | 159 | yes |
| library-load | 1 | seam | 2114 | 1957–2288 | 34.55x | 242 | 242.00x | 232 | yes |
| library-load | 1 | signals | 272 | 267–290 | 4.44x | 42 | 42.00x | 41 | yes |
| library-load | 1 | vide | 429 | 424–451 | 7.01x | 146 | 146.00x | 145 | yes |
| rows-append-1000 | 1 | plain | 154421 | 151571–157273 | 1.00x | 6524 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 223596 | 222020–228079 | 1.45x | 38770 | 5.94x | 0 | yes |
| rows-append-1000 | 1 | compose | 175195 | 167506–249067 | 1.13x | 11031 | 1.69x | 10 | yes |
| rows-append-1000 | 1 | fusion | 317596 | 288722–353025 | 2.06x | 21370 | 3.28x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 308959 | 299045–327217 | 2.00x | 29186 | 4.47x | 0 | yes |
| rows-append-1000 | 1 | react | 229613 | 219215–272410 | 1.49x | 23290 | 3.57x | 105 | yes |
| rows-append-1000 | 1 | react-reflex | 244994 | 223324–286229 | 1.59x | 24702 | 3.79x | 13 | yes |
| rows-append-1000 | 1 | react-upstream | 238789 | 227849–315659 | 1.55x | 22854 | 3.50x | 20 | yes |
| rows-append-1000 | 1 | roact | 219185 | 213596–314629 | 1.42x | 33143 | 5.08x | 5 | yes |
| rows-append-1000 | 1 | seam | 248974 | 200049–260613 | 1.61x | 46282 | 7.09x | 0 | yes |
| rows-append-1000 | 1 | signals | 174017 | 163696–210213 | 1.13x | 17196 | 2.64x | 8 | yes |
| rows-append-1000 | 1 | vide | 165108 | 160311–179913 | 1.07x | 10423 | 1.60x | 8 | yes |
| rows-clear | 1 | plain | 20600 | 20100–28114 | 1.00x | 1229 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 41205 | 38712–41500 | 2.00x | 4178 | 3.40x | 1 | yes |
| rows-clear | 1 | compose | 26700 | 25400–26916 | 1.30x | 1894 | 1.54x | 11 | yes |
| rows-clear | 1 | fusion | 55003 | 54607–83415 | 2.67x | 3481 | 2.83x | 1 | yes |
| rows-clear | 1 | fusion-charm | 53581 | 52002–54100 | 2.60x | 7393 | 6.02x | 0 | yes |
| rows-clear | 1 | react | 27700 | 26110–43900 | 1.34x | 4487 | 3.65x | 0 | yes |
| rows-clear | 1 | react-reflex | 30106 | 29008–44230 | 1.46x | 6498 | 5.29x | 36 | yes |
| rows-clear | 1 | react-upstream | 27002 | 26500–27729 | 1.31x | 4487 | 3.65x | 0 | yes |
| rows-clear | 1 | roact | 29300 | 27900–30004 | 1.42x | 4214 | 3.43x | 1 | yes |
| rows-clear | 1 | seam | 32902 | 22916–38747 | 1.60x | 9287 | 7.56x | 0 | yes |
| rows-clear | 1 | signals | 24828 | 23300–27716 | 1.21x | 4449 | 3.62x | 0 | yes |
| rows-clear | 1 | vide | 22800 | 22000–23404 | 1.11x | 1605 | 1.31x | 0 | yes |
| rows-create-1000 | 1 | plain | 150502 | 148795–155445 | 1.00x | 3119 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 207742 | 198219–249535 | 1.38x | 19728 | 6.33x | 0 | yes |
| rows-create-1000 | 1 | compose | 176946 | 165406–205535 | 1.18x | 5818 | 1.87x | 10 | yes |
| rows-create-1000 | 1 | fusion | 226422 | 207392–233472 | 1.50x | 10875 | 3.49x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 224769 | 208418–266959 | 1.49x | 14877 | 4.77x | 1 | yes |
| rows-create-1000 | 1 | react | 197465 | 185883–233326 | 1.31x | 8152 | 2.61x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 211946 | 193539–246257 | 1.41x | 9082 | 2.91x | 45 | yes |
| rows-create-1000 | 1 | react-upstream | 191761 | 181523–226932 | 1.27x | 8072 | 2.59x | 0 | yes |
| rows-create-1000 | 1 | roact | 189040 | 171421–208716 | 1.26x | 16914 | 5.42x | 1 | yes |
| rows-create-1000 | 1 | seam | 218986 | 213178–249348 | 1.46x | 23902 | 7.66x | 1 | yes |
| rows-create-1000 | 1 | signals | 167725 | 151521–207576 | 1.11x | 9130 | 2.93x | 0 | yes |
| rows-create-1000 | 1 | vide | 165325 | 153219–225420 | 1.10x | 4964 | 1.59x | 0 | yes |
| rows-create-10000 | 1 | plain | 1741752 | 1709703–1927974 | 1.00x | 29792 | 1.00x | 16 | yes |
| rows-create-10000 | 1 | blend | 2390807 | 2284186–2466863 | 1.37x | 186557 | 6.26x | 0 | yes |
| rows-create-10000 | 1 | compose | 2130226 | 2110181–2219239 | 1.22x | 55707 | 1.87x | 11 | yes |
| rows-create-10000 | 1 | fusion | 5787776 | 5728464–6247198 | 3.32x | 104986 | 3.52x | 113 | yes |
| rows-create-10000 | 1 | fusion-charm | 5814983 | 5506750–5910650 | 3.34x | 142158 | 4.77x | 933 | yes |
| rows-create-10000 | 1 | react | 3984502 | 3882217–4033678 | 2.29x | 77535 | 2.60x | 561 | yes |
| rows-create-10000 | 1 | react-reflex | 4108786 | 4083609–4237068 | 2.36x | 87538 | 2.94x | 1221 | yes |
| rows-create-10000 | 1 | react-upstream | 3889339 | 3716256–3978517 | 2.23x | 78338 | 2.63x | 376 | yes |
| rows-create-10000 | 1 | roact | 2258302 | 2144900–2261664 | 1.30x | 165946 | 5.57x | 0 | yes |
| rows-create-10000 | 1 | seam | 2600081 | 2395651–2881199 | 1.49x | 234771 | 7.88x | 0 | yes |
| rows-create-10000 | 1 | signals | 1931279 | 1912520–2144673 | 1.11x | 89170 | 2.99x | 4 | yes |
| rows-create-10000 | 1 | vide | 1840947 | 1741254–2004375 | 1.06x | 48452 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 1050 | 750–1150 | 1.00x | 2748 | 1.00x | 8 | yes |
| rows-remove-one | 1 | blend | 1400 | 1400–1800 | 1.33x | 18300 | 6.66x | 0 | yes |
| rows-remove-one | 1 | compose | 1200 | 800–1340 | 1.14x | 4949 | 1.80x | 19 | yes |
| rows-remove-one | 1 | fusion (workaround) | 34200 | 32439–51892 | 32.57x | 11090 | 4.04x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 34439 | 32800–36817 | 32.80x | 15042 | 5.47x | 1 | yes |
| rows-remove-one | 1 | react | 25000 | 16515–43011 | 23.81x | 15524 | 5.65x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 34110 | 22100–35501 | 32.49x | 16398 | 5.97x | 12 | yes |
| rows-remove-one | 1 | react-upstream | 28142 | 18506–51426 | 26.80x | 15468 | 5.63x | 0 | yes |
| rows-remove-one | 1 | roact | 19400 | 15300–20033 | 18.48x | 16773 | 6.10x | 0 | yes |
| rows-remove-one | 1 | seam | 8200 | 7200–9700 | 7.81x | 23213 | 8.45x | 0 | yes |
| rows-remove-one | 1 | signals | 2000 | 1750–2050 | 1.90x | 8614 | 3.13x | 0 | yes |
| rows-remove-one | 1 | vide | 1250 | 1200–2100 | 1.19x | 4561 | 1.66x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–150 | 1.00x | 2679 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 700 | 600–900 | 7.00x | 18262 | 6.82x | 1 | yes |
| rows-swap | 1 | compose | 150 | 100–250 | 1.50x | 4911 | 1.83x | 3 | yes |
| rows-swap | 1 | fusion | 32212 | 31303–39100 | 322.12x | 9559 | 3.57x | 8 | yes |
| rows-swap | 1 | fusion-charm | 32000 | 31100–32200 | 320.00x | 14619 | 5.46x | 1 | yes |
| rows-swap | 1 | react | 29300 | 27900–36820 | 293.00x | 15434 | 5.76x | 0 | yes |
| rows-swap | 1 | react-reflex | 47618 | 34707–69304 | 476.18x | 16394 | 6.12x | 35 | yes |
| rows-swap | 1 | react-upstream | 38200 | 29600–66306 | 382.00x | 15001 | 5.60x | 0 | yes |
| rows-swap | 1 | roact | 18600 | 13100–21104 | 186.00x | 16307 | 6.09x | 0 | yes |
| rows-swap | 1 | seam | 6500 | 5500–7700 | 65.00x | 23212 | 8.66x | 1 | yes |
| rows-swap | 1 | signals | 700 | 550–800 | 7.00x | 8601 | 3.21x | 8 | yes |
| rows-swap | 1 | vide | 150 | 100–250 | 1.50x | 4508 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 3650 | 3550–4100 | 1.00x | 3183 | 1.00x | 9 | yes |
| rows-update-every-10th | 1 | blend | 3900 | 3600–4800 | 1.07x | 19264 | 6.05x | 1 | yes |
| rows-update-every-10th | 1 | compose | 3700 | 3601–4006 | 1.01x | 5465 | 1.72x | 5 | yes |
| rows-update-every-10th | 1 | fusion | 5000 | 4100–5800 | 1.37x | 10560 | 3.32x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 5300 | 4501–6810 | 1.45x | 14464 | 4.54x | 1 | yes |
| rows-update-every-10th | 1 | react | 4200 | 3600–4300 | 1.15x | 7829 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 7100 | 5206–8306 | 1.95x | 8798 | 2.76x | 0 | yes |
| rows-update-every-10th | 1 | react-upstream | 3900 | 3800–4100 | 1.07x | 7917 | 2.49x | 7 | yes |
| rows-update-every-10th | 1 | roact | 3951 | 3950–4050 | 1.08x | 16681 | 5.24x | 0 | yes |
| rows-update-every-10th | 1 | seam | 7102 | 7000–7600 | 1.95x | 24205 | 7.60x | 8 | yes |
| rows-update-every-10th | 1 | signals | 4050 | 3801–4150 | 1.11x | 9346 | 2.94x | 8 | yes |
| rows-update-every-10th | 1 | vide | 4000 | 3700–5800 | 1.10x | 5116 | 1.61x | 0 | yes |

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
| blend | 29 | 2.66x | 10.29x | 2.63x | 9.99x |
| compose | 30 | 2.12x | 3.78x | 2.01x | 3.75x |
| fusion | 30 | 6.57x | 6.17x | 6.06x | 6.22x |
| fusion-charm | 30 | 5.95x | 7.15x | 5.44x | 7.29x |
| react | 29 | 4.78x | 5.73x | 4.59x | 6.09x |
| react-reflex | 29 | 5.51x | 9.64x | 5.33x | 10.37x |
| react-upstream | 29 | 4.80x | 6.01x | 4.62x | 6.39x |
| roact | 29 | 3.20x | 5.57x | 3.14x | 6.31x |
| seam | 30 | 4.56x | 11.67x | 4.18x | 11.60x |
| signals | 29 | 2.10x | 2.81x | 2.02x | 2.81x |
| vide | 30 | 2.18x | 2.86x | 2.04x | 2.87x |
