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
| Roblox Studio | 0.745.0.7451137 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `83e7221` |
| Date | 2026-11-04 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 700 | 500–800 | 1.00x | 58 | 1.00x | 9 | yes |
| update-leaf | 20 | blend | 2134 | 1851–2400 | 3.05x | 765 | 13.19x | 1 | yes |
| update-leaf | 20 | compose | 1868 | 1851–2169 | 2.67x | 69 | 1.19x | 1 | yes |
| update-leaf | 20 | fusion | 2050 | 1950–2450 | 2.93x | 52 | 0.90x | 1 | yes |
| update-leaf | 20 | fusion-charm | 2400 | 2200–2655 | 3.43x | 61 | 1.05x | 0 | yes |
| update-leaf | 20 | react | 2103 | 2067–2369 | 3.00x | 355 | 6.12x | 0 | yes |
| update-leaf | 20 | react-reflex | 2200 | 1950–2550 | 3.14x | 292 | 5.03x | 0 | yes |
| update-leaf | 20 | react-upstream | 2300 | 2116–2400 | 3.29x | 291 | 5.02x | 0 | yes |
| update-leaf | 20 | roact | 2067 | 1900–2267 | 2.95x | 968 | 16.69x | 1 | yes |
| update-leaf | 20 | seam | 2300 | 1744–2465 | 3.29x | 40 | 0.69x | 1 | yes |
| update-leaf | 20 | signals | 2067 | 1733–2233 | 2.95x | 50 | 0.86x | 0 | yes |
| update-leaf | 20 | vide | 2294 | 1823–2350 | 3.28x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4350 | 4250–4500 | 1.00x | 21 | 1.00x | 8 | yes |
| update-batched | 20 | blend | 10539 | 9690–12271 | 2.42x | 916 | 43.62x | 0 | yes |
| update-batched | 20 | compose | 7568 | 7100–8555 | 1.74x | 384 | 18.29x | 10 | yes |
| update-batched | 20 | fusion | 19034 | 18417–21000 | 4.38x | 509 | 24.24x | 1 | yes |
| update-batched | 20 | fusion-charm | 32201 | 31395–34810 | 7.40x | 1109 | 52.81x | 8 | yes |
| update-batched | 20 | react | 7700 | 7489–8821 | 1.77x | 485 | 23.10x | 0 | yes |
| update-batched | 20 | react-reflex | 55494 | 45252–68663 | 12.76x | 783 | 37.29x | 17 | yes |
| update-batched | 20 | react-upstream | 8406 | 7700–9200 | 1.93x | 484 | 23.05x | 7 | yes |
| update-batched | 20 | roact | 9500 | 8200–12245 | 2.18x | 1162 | 55.33x | 1 | yes |
| update-batched | 20 | seam | 11013 | 10790–13200 | 2.53x | 1840 | 87.62x | 0 | yes |
| update-batched | 20 | signals | 9500 | 9000–9870 | 2.18x | 597 | 28.43x | 0 | yes |
| update-batched | 20 | vide | 8400 | 7900–9386 | 1.93x | 332 | 15.81x | 1 | yes |
| update-repeated | 10 | plain | 40 | 36–42 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 2872 | 2604–3101 | 72.23x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | compose | 400 | 200–500 | 10.06x | 13 | 6.50x | 9 | yes |
| update-repeated | 10 | fusion | 22600 | 20893–24097 | 568.41x | 13 | 6.50x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1040 | 960–1179 | 26.16x | 0 | 0.50x | 1 | yes |
| update-repeated | 10 | react | 5265 | 5100–5700 | 132.42x | 9 | 4.50x | 1 | yes |
| update-repeated | 10 | react-reflex | 757 | 657–857 | 19.04x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 5094 | 4528–5993 | 128.12x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6174 | 5535–7026 | 155.28x | 6 | 3.00x | 1 | yes |
| update-repeated | 10 | seam | 1375 | 1225–1650 | 34.58x | 11 | 5.50x | 1 | yes |
| update-repeated | 10 | signals | 716 | 614–824 | 18.01x | 4 | 2.00x | 8 | yes |
| update-repeated | 10 | vide | 511 | 483–544 | 12.85x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | plain | 26306 | 20073–29818 | 1.00x | 0 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 28177 | 26035–29200 | 1.07x | 27 | 27.00x | 0 | yes |
| branch-swap | 20 | compose | 27078 | 25105–27574 | 1.03x | 7 | 7.00x | 2 | yes |
| branch-swap | 20 | fusion | 26133 | 25005–30330 | 0.99x | 5 | 5.00x | 1 | yes |
| branch-swap | 20 | fusion-charm | 25195 | 24257–26682 | 0.96x | 7 | 7.00x | 0 | yes |
| branch-swap | 20 | react | 29102 | 28183–33641 | 1.11x | 10 | 10.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 28000 | 27400–29711 | 1.06x | 19 | 19.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 26601 | 25903–28791 | 1.01x | 10 | 10.00x | 0 | yes |
| branch-swap | 20 | roact | 24703 | 23616–25137 | 0.94x | 20 | 20.00x | 1 | yes |
| branch-swap | 20 | seam | 23852 | 22878–26164 | 0.91x | 11 | 11.00x | 0 | yes |
| branch-swap | 20 | signals | 24324 | 23509–26420 | 0.92x | 12 | 12.00x | 1 | yes |
| branch-swap | 20 | vide | 26848 | 24827–27807 | 1.02x | 6 | 6.00x | 1 | yes |
| keyed-prepend | 10 | plain | 1900 | 1834–2052 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4300 | 3900–4900 | 2.26x | 1490 | 23.28x | 0 | yes |
| keyed-prepend | 10 | compose | 3950 | 3600–4140 | 2.08x | 501 | 7.83x | 18 | yes |
| keyed-prepend | 10 | fusion (workaround) | 18101 | 17485–21171 | 9.53x | 1520 | 23.75x | 0 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 20319 | 18875–31845 | 10.69x | 1505 | 23.52x | 1 | yes |
| keyed-prepend | 10 | react | 11839 | 10923–14409 | 6.23x | 778 | 12.16x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 12522 | 10729–12904 | 6.59x | 793 | 12.39x | 8 | yes |
| keyed-prepend | 10 | react-upstream | 12110 | 11018–14505 | 6.37x | 784 | 12.25x | 0 | yes |
| keyed-prepend | 10 | roact | 6290 | 5362–7859 | 3.31x | 361 | 5.64x | 0 | yes |
| keyed-prepend | 10 | seam | 9600 | 9000–11000 | 5.05x | 2455 | 38.36x | 1 | yes |
| keyed-prepend | 10 | signals | 2650 | 2433–3334 | 1.39x | 61 | 0.95x | 1 | yes |
| keyed-prepend | 10 | vide | 4600 | 4242–4886 | 2.42x | 646 | 10.09x | 1 | yes |
| keyed-insert | 10 | plain | 1250 | 1200–1426 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4038 | 3752–4294 | 3.23x | 1490 | 23.28x | 0 | yes |
| keyed-insert | 10 | compose | 2850 | 2700–3402 | 2.28x | 485 | 7.58x | 0 | yes |
| keyed-insert | 10 | fusion (workaround) | 14784 | 13401–16884 | 11.83x | 1519 | 23.73x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 14202 | 12626–15600 | 11.36x | 1529 | 23.89x | 0 | yes |
| keyed-insert | 10 | react | 10200 | 9030–12662 | 8.16x | 803 | 12.55x | 0 | yes |
| keyed-insert | 10 | react-reflex | 10939 | 8500–12512 | 8.75x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 10000 | 9100–10800 | 8.00x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 5250 | 4750–5413 | 4.20x | 369 | 5.77x | 8 | yes |
| keyed-insert | 10 | seam | 9500 | 9111–10800 | 7.60x | 2440 | 38.12x | 1 | yes |
| keyed-insert | 10 | signals | 2034 | 1867–2200 | 1.63x | 61 | 0.95x | 0 | yes |
| keyed-insert | 10 | vide | 4100 | 3522–7022 | 3.28x | 646 | 10.09x | 1 | yes |
| keyed-shuffle | 10 | plain | 1304 | 1217–1327 | 1.00x | 117 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 2505 | 2300–3000 | 1.92x | 1496 | 12.79x | 0 | yes |
| keyed-shuffle | 10 | compose | 2752 | 2600–2952 | 2.11x | 500 | 4.27x | 10 | yes |
| keyed-shuffle | 10 | fusion | 16937 | 16086–18115 | 12.99x | 1390 | 11.88x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 16709 | 15909–17806 | 12.82x | 1391 | 11.89x | 0 | yes |
| keyed-shuffle | 10 | react | 18059 | 16390–19107 | 13.85x | 787 | 6.73x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 17025 | 15500–19103 | 13.06x | 780 | 6.67x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 16529 | 15500–18597 | 12.68x | 843 | 7.21x | 0 | yes |
| keyed-shuffle | 10 | roact | 5050 | 4500–5154 | 3.87x | 369 | 3.15x | 0 | yes |
| keyed-shuffle | 10 | seam | 8400 | 8100–9304 | 6.44x | 2446 | 20.91x | 0 | yes |
| keyed-shuffle | 10 | signals | 1900 | 1828–2014 | 1.46x | 60 | 0.51x | 0 | yes |
| keyed-shuffle | 10 | vide | 2800 | 2580–3200 | 2.15x | 678 | 5.79x | 1 | yes |
| events | 1 | plain | 3502 | 2900–4301 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | blend | 4400 | 4100–4600 | 1.26x | 2 | 1.00x | 0 | yes |
| events | 1 | compose | 4100 | 3205–5300 | 1.17x | 10 | 5.00x | 1 | yes |
| events | 1 | fusion | 3900 | 3805–4500 | 1.11x | 9 | 4.50x | 0 | yes |
| events | 1 | fusion-charm | 4600 | 3652–4800 | 1.31x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 3987 | 3900–4934 | 1.14x | 9 | 4.50x | 7 | yes |
| events | 1 | react-reflex | 3500 | 2900–4000 | 1.00x | 10 | 5.00x | 0 | yes |
| events | 1 | react-upstream | 3906 | 3700–4200 | 1.12x | 1 | 0.50x | 0 | yes |
| events | 1 | roact | 3500 | 3100–3896 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | seam | 4030 | 3024–4700 | 1.15x | 9 | 4.50x | 0 | yes |
| events | 1 | signals | 3209 | 3089–4200 | 0.92x | 10 | 5.00x | 1 | yes |
| events | 1 | vide | 3500 | 2900–4000 | 1.00x | 2 | 1.00x | 0 | yes |
| animate-many | 1 | plain | 2900 | 2650–3112 | 1.00x | 74 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 11300 | 10200–13410 | 3.90x | 1771 | 23.93x | 1 | yes |
| animate-many | 1 | compose | 7402 | 7286–8501 | 2.55x | 642 | 8.68x | 20 | yes |
| animate-many | 1 | fusion | 70081 | 67721–82423 | 24.17x | 1137 | 15.36x | 0 | yes |
| animate-many | 1 | fusion-charm | 70716 | 70313–73429 | 24.38x | 1145 | 15.47x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 23033 | 21166–23125 | 7.94x | 2906 | 39.27x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 10726 | 9200–11800 | 3.70x | 384 | 5.19x | 0 | yes |
| status-panel | 10 | plain | 950 | 900–1404 | 1.00x | 3 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 2600 | 2050–2602 | 2.74x | 70 | 23.33x | 9 | yes |
| status-panel | 10 | compose | 2300 | 2250–2600 | 2.42x | 30 | 10.00x | 1 | yes |
| status-panel | 10 | fusion | 2920 | 2500–3250 | 3.07x | 64 | 21.33x | 1 | yes |
| status-panel | 10 | fusion-charm | 3150 | 2950–3600 | 3.32x | 69 | 23.00x | 0 | yes |
| status-panel | 10 | react | 3966 | 3208–5088 | 4.17x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | react-reflex | 3200 | 2950–4450 | 3.37x | 45 | 15.00x | 0 | yes |
| status-panel | 10 | react-upstream | 3419 | 3005–3750 | 3.60x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | roact | 2501 | 2320–2846 | 2.63x | 33 | 11.00x | 0 | yes |
| status-panel | 10 | seam | 4100 | 2300–4234 | 4.32x | 141 | 47.00x | 1 | yes |
| status-panel | 10 | signals | 2100 | 2016–2618 | 2.21x | 15 | 5.00x | 1 | yes |
| status-panel | 10 | vide | 2300 | 2154–2334 | 2.42x | 26 | 8.67x | 1 | yes |
| scene-3d | 10 | plain | 2250 | 2200–2372 | 1.00x | 12 | 1.00x | 1 | yes |
| scene-3d | 10 | blend | 4800 | 4600–5200 | 2.13x | 550 | 45.83x | 0 | yes |
| scene-3d | 10 | compose | 3450 | 3226–4050 | 1.53x | 171 | 14.25x | 1 | yes |
| scene-3d | 10 | fusion | 24093 | 21388–24383 | 10.71x | 520 | 43.33x | 1 | yes |
| scene-3d | 10 | fusion-charm | 21913 | 21031–22212 | 9.74x | 515 | 42.92x | 0 | yes |
| scene-3d | 10 | react | 3500 | 3250–3950 | 1.56x | 223 | 18.58x | 0 | yes |
| scene-3d | 10 | react-reflex | 3416 | 3200–3700 | 1.52x | 225 | 18.75x | 0 | yes |
| scene-3d | 10 | react-upstream | 3728 | 3400–4594 | 1.66x | 223 | 18.58x | 0 | yes |
| scene-3d | 10 | roact | 3708 | 3200–4258 | 1.65x | 575 | 47.92x | 1 | yes |
| scene-3d | 10 | seam | 8000 | 7513–8887 | 3.56x | 1754 | 146.17x | 0 | yes |
| scene-3d | 10 | signals | 5200 | 4947–5824 | 2.31x | 683 | 56.92x | 0 | yes |
| scene-3d | 10 | vide | 4100 | 3700–4604 | 1.82x | 211 | 17.58x | 0 | yes |
| derived-diamond | 3 | plain | 24 | 21–33 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 156 | 138–193 | 6.46x | 27 | 6.75x | 0 | yes |
| derived-diamond | 3 | compose | 147 | 135–153 | 6.08x | 2 | 0.50x | 2 | yes |
| derived-diamond | 3 | fusion | 176 | 153–208 | 7.29x | 9 | 2.25x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 183 | 150–203 | 7.58x | 10 | 2.50x | 0 | yes |
| derived-diamond | 3 | react | 333 | 264–418 | 13.76x | 7 | 1.75x | 4 | yes |
| derived-diamond | 3 | react-reflex | 346 | 250–350 | 14.32x | 18 | 4.50x | 6 | yes |
| derived-diamond | 3 | react-upstream | 360 | 260–381 | 14.88x | 14 | 3.50x | 4 | yes |
| derived-diamond | 3 | roact | 156 | 125–169 | 6.46x | 10 | 2.50x | 3 | yes |
| derived-diamond | 3 | seam | 219 | 197–250 | 9.06x | 13 | 3.25x | 0 | yes |
| derived-diamond | 3 | signals | 124 | 112–142 | 5.10x | 10 | 2.50x | 1 | yes |
| derived-diamond | 3 | vide | 129 | 124–165 | 5.35x | 6 | 1.50x | 0 | yes |
| derived-chain-100 | 3 | plain | 32 | 31–35 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 163 | 156–212 | 5.06x | 126 | 2.21x | 1 | yes |
| derived-chain-100 | 3 | fusion | 529 | 500–712 | 16.48x | 128 | 2.25x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 517 | 500–667 | 16.09x | 129 | 2.26x | 0 | yes |
| derived-chain-100 | 3 | react | 350 | 290–410 | 10.90x | 69 | 1.21x | 3 | yes |
| derived-chain-100 | 3 | react-reflex | 400 | 346–412 | 12.45x | 80 | 1.40x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 347 | 340–400 | 10.82x | 69 | 1.21x | 12 | yes |
| derived-chain-100 | 3 | roact | 141 | 128–153 | 4.39x | 11 | 0.19x | 3 | yes |
| derived-chain-100 | 3 | seam | 634 | 600–784 | 19.74x | 272 | 4.77x | 0 | yes |
| derived-chain-100 | 3 | signals | 194 | 169–212 | 6.05x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 150 | 132–183 | 4.67x | 89 | 1.56x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 85 | 84–86 | 1.00x | 489 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 251 | 218–299 | 2.94x | 1534 | 3.14x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 369 | 299–377 | 4.33x | 688 | 1.41x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1183 | 1133–1489 | 13.86x | 897 | 1.83x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1160 | 1040–1220 | 13.59x | 2829 | 5.79x | 8 | yes |
| derived-fan-in-1000 | 3 | react | 1988 | 1533–2567 | 23.29x | 663 | 1.36x | 52 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8013 | 7900–9140 | 93.87x | 5646 | 11.55x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1695 | 1410–2902 | 19.86x | 663 | 1.36x | 44 | yes |
| derived-fan-in-1000 | 3 | roact | 490 | 436–539 | 5.74x | 105 | 0.21x | 0 | yes |
| derived-fan-in-1000 | 3 | seam | 1655 | 1550–2050 | 19.39x | 2956 | 6.04x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 550 | 502–691 | 6.44x | 1212 | 2.48x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 375 | 319–406 | 4.39x | 529 | 1.08x | 1 | yes |
| filter-as-you-type | 1 | plain | 7000 | 6900–9112 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16210 | 13151–17152 | 2.32x | 2678 | 76.51x | 0 | yes |
| filter-as-you-type | 1 | compose | 10000 | 9200–11147 | 1.43x | 738 | 21.09x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 24200 | 22898–26136 | 3.46x | 2449 | 69.97x | 2 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 21832 | 19742–25101 | 3.12x | 2459 | 70.26x | 1 | yes |
| filter-as-you-type | 1 | react | 15300 | 14479–17309 | 2.19x | 75 | 2.14x | 12 | yes |
| filter-as-you-type | 1 | react-reflex | 15800 | 13868–17000 | 2.26x | 831 | 23.74x | 15 | yes |
| filter-as-you-type | 1 | react-upstream | 15106 | 14200–17738 | 2.16x | 76 | 2.17x | 12 | yes |
| filter-as-you-type | 1 | roact | 10815 | 10600–12417 | 1.54x | 503 | 14.37x | 3 | yes |
| filter-as-you-type | 1 | seam | 21681 | 16718–26475 | 3.10x | 4013 | 114.66x | 9 | yes |
| filter-as-you-type | 1 | signals | 9400 | 8068–9968 | 1.34x | 37 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | vide | 13105 | 10100–18467 | 1.87x | 960 | 27.43x | 0 | yes |
| theme-propagation | 3 | plain | 130457 | 108646–134855 | 1.00x | 198 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 114073 | 108190–126554 | 0.87x | 2078 | 10.49x | 8 | yes |
| theme-propagation | 3 | compose | 121894 | 107488–123901 | 0.93x | 516 | 2.61x | 0 | yes |
| theme-propagation | 3 | fusion | 105894 | 100976–111620 | 0.81x | 866 | 4.37x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 108757 | 103590–124271 | 0.83x | 876 | 4.42x | 8 | yes |
| theme-propagation | 3 | react | 107402 | 106218–109978 | 0.82x | 2020 | 10.20x | 0 | yes |
| theme-propagation | 3 | react-reflex | 113640 | 97406–118806 | 0.87x | 2029 | 10.25x | 0 | yes |
| theme-propagation | 3 | react-upstream | 130487 | 111845–190920 | 1.00x | 2027 | 10.24x | 1 | yes |
| theme-propagation | 3 | roact | 122157 | 106404–129972 | 0.94x | 3278 | 16.56x | 0 | yes |
| theme-propagation | 3 | seam | 100050 | 97056–103422 | 0.77x | 3477 | 17.56x | 0 | yes |
| theme-propagation | 3 | signals | 111698 | 110984–173306 | 0.86x | 904 | 4.57x | 0 | yes |
| theme-propagation | 3 | vide | 114967 | 104423–139362 | 0.88x | 596 | 3.01x | 0 | yes |
| hud-per-frame | 1 | plain | 3000 | 2800–3500 | 1.00x | 30 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5600 | 5400–6700 | 1.87x | 71 | 2.37x | 0 | yes |
| hud-per-frame | 1 | compose | 4700 | 4400–5100 | 1.57x | 28 | 0.93x | 2 | yes |
| hud-per-frame | 1 | fusion | 10600 | 10292–10937 | 3.53x | 62 | 2.07x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13500 | 12801–15300 | 4.50x | 98 | 3.27x | 0 | yes |
| hud-per-frame | 1 | react | 6100 | 4974–9488 | 2.03x | 34 | 1.13x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7153 | 6869–8187 | 2.38x | 54 | 1.80x | 2 | yes |
| hud-per-frame | 1 | react-upstream | 4722 | 4400–5236 | 1.57x | 34 | 1.13x | 0 | yes |
| hud-per-frame | 1 | roact | 5175 | 3500–5276 | 1.73x | 90 | 3.00x | 0 | yes |
| hud-per-frame | 1 | seam | 10300 | 9600–11721 | 3.43x | 177 | 5.90x | 1 | yes |
| hud-per-frame | 1 | signals | 6000 | 5500–7100 | 2.00x | 65 | 2.17x | 0 | yes |
| hud-per-frame | 1 | vide | 5800 | 4600–6000 | 1.93x | 25 | 0.83x | 0 | yes |
| teardown-under-load | 1 | plain | 52963 | 50952–56211 | 1.00x | 6 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 67081 | 65229–67609 | 1.27x | 14 | 2.33x | 0 | yes |
| teardown-under-load | 1 | compose | 58790 | 57718–61902 | 1.11x | 7 | 1.17x | 2 | yes |
| teardown-under-load | 1 | fusion | 78831 | 67962–80070 | 1.49x | 5 | 0.83x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 75039 | 69772–92406 | 1.42x | 6 | 1.00x | 0 | yes |
| teardown-under-load | 1 | react | 71664 | 70189–81811 | 1.35x | 1077 | 179.50x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 74516 | 66044–80585 | 1.41x | 1086 | 181.00x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 74470 | 68368–81047 | 1.41x | 1077 | 179.50x | 0 | yes |
| teardown-under-load | 1 | roact | 64691 | 60874–69470 | 1.22x | 71 | 11.83x | 0 | yes |
| teardown-under-load | 1 | seam | 73768 | 63382–76082 | 1.39x | 7 | 1.17x | 6 | yes |
| teardown-under-load | 1 | signals | 62740 | 59704–65022 | 1.18x | 4 | 0.67x | 0 | yes |
| teardown-under-load | 1 | vide | 64506 | 63659–67236 | 1.22x | 5 | 0.83x | 1 | yes |
| open-close-retention | 1 | plain | 72126 | 69203–75223 | 1.00x | 40 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 119375 | 111906–121448 | 1.66x | 14 | 0.35x | 1 | yes |
| open-close-retention | 1 | compose | 89232 | 84419–90712 | 1.24x | 6 | 0.15x | 1 | yes |
| open-close-retention | 1 | fusion | 136030 | 135409–136569 | 1.89x | 5 | 0.12x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 149899 | 138043–233943 | 2.08x | 0 | 0.03x | 0 | yes |
| open-close-retention | 1 | react | 124735 | 117925–126811 | 1.73x | 292 | 7.30x | 0 | yes |
| open-close-retention | 1 | react-reflex | 116914 | 103671–130350 | 1.62x | 285 | 7.12x | 5 | yes |
| open-close-retention | 1 | react-upstream | 127019 | 118179–130548 | 1.76x | 284 | 7.10x | 0 | yes |
| open-close-retention | 1 | roact | 117966 | 112213–122881 | 1.64x | 23 | 0.57x | 0 | yes |
| open-close-retention | 1 | seam | 131532 | 122868–135691 | 1.82x | 18 | 0.45x | 1 | yes |
| open-close-retention | 1 | signals | 91907 | 89139–96794 | 1.27x | 13 | 0.33x | 9 | yes |
| open-close-retention | 1 | vide | 96022 | 94351–103783 | 1.33x | 13 | 0.33x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7871 | 7449–8059 | 1.00x | 21 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 19039 | 17335–19707 | 2.42x | 788 | 37.52x | 0 | yes |
| tree-expand-collapse | 1 | compose | 12900 | 12601–13806 | 1.64x | 66 | 3.14x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 25200 | 18508–25600 | 3.20x | 150 | 7.14x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 21768 | 20609–25737 | 2.77x | 167 | 7.95x | 0 | yes |
| tree-expand-collapse | 1 | react | 14829 | 14586–17600 | 1.88x | 61 | 2.90x | 12 | yes |
| tree-expand-collapse | 1 | react-reflex | 16042 | 15906–18202 | 2.04x | 680 | 32.38x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 17223 | 16881–21004 | 2.19x | 69 | 3.29x | 20 | yes |
| tree-expand-collapse | 1 | roact | 10431 | 9810–11669 | 1.33x | 35 | 1.67x | 3 | yes |
| tree-expand-collapse | 1 | seam | 28202 | 23809–29494 | 3.58x | 149 | 7.10x | 0 | yes |
| tree-expand-collapse | 1 | signals | 9114 | 8100–9300 | 1.16x | 21 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12200 | 11200–13601 | 1.55x | 71 | 3.38x | 0 | yes |
| form-validation | 1 | plain | 3200 | 3039–3600 | 1.00x | 53 | 1.00x | 7 | yes |
| form-validation | 1 | blend | 9100 | 7702–10000 | 2.84x | 335 | 6.32x | 0 | yes |
| form-validation | 1 | compose | 9001 | 8893–9780 | 2.81x | 98 | 1.85x | 2 | yes |
| form-validation | 1 | fusion | 9007 | 8500–9986 | 2.81x | 118 | 2.23x | 1 | yes |
| form-validation | 1 | fusion-charm | 8878 | 8000–10100 | 2.77x | 155 | 2.92x | 0 | yes |
| form-validation | 1 | react | 10000 | 8385–11106 | 3.12x | 66 | 1.25x | 0 | yes |
| form-validation | 1 | react-reflex | 9455 | 8798–11330 | 2.95x | 75 | 1.42x | 1 | yes |
| form-validation | 1 | react-upstream | 9200 | 8455–10260 | 2.88x | 66 | 1.25x | 0 | yes |
| form-validation | 1 | roact | 10200 | 9700–10358 | 3.19x | 216 | 4.08x | 0 | yes |
| form-validation | 1 | seam | 9846 | 9100–10793 | 3.08x | 356 | 6.72x | 1 | yes |
| form-validation | 1 | signals | 9036 | 8136–9858 | 2.82x | 155 | 2.92x | 0 | yes |
| form-validation | 1 | vide | 8775 | 7610–9961 | 2.74x | 69 | 1.30x | 0 | yes |
| table-sort-filter | 1 | plain | 14938 | 14693–15906 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 30407 | 28935–33827 | 2.04x | 5509 | 82.22x | 1 | yes |
| table-sort-filter | 1 | compose | 21979 | 20037–22100 | 1.47x | 1435 | 21.42x | 26 | yes |
| table-sort-filter | 1 | fusion (workaround) | 46442 | 44143–49009 | 3.11x | 4728 | 70.57x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 46902 | 42857–52079 | 3.14x | 4737 | 70.70x | 1 | yes |
| table-sort-filter | 1 | react | 57919 | 54815–67464 | 3.88x | 2100 | 31.34x | 11 | yes |
| table-sort-filter | 1 | react-reflex | 61576 | 56195–63569 | 4.12x | 2115 | 31.57x | 22 | yes |
| table-sort-filter | 1 | react-upstream | 55228 | 51462–62358 | 3.70x | 2117 | 31.60x | 20 | yes |
| table-sort-filter | 1 | roact | 20913 | 20823–22607 | 1.40x | 1007 | 15.03x | 3 | yes |
| table-sort-filter | 1 | seam | 48728 | 45414–51740 | 3.26x | 7944 | 118.57x | 0 | yes |
| table-sort-filter | 1 | signals | 15400 | 15200–19539 | 1.03x | 68 | 1.01x | 0 | yes |
| table-sort-filter | 1 | vide | 23061 | 20701–25217 | 1.54x | 1914 | 28.57x | 1 | yes |
| library-load | 1 | plain | 57 | 48–59 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 837 | 721–932 | 14.77x | 453 | 453.00x | 458 | yes |
| library-load | 1 | compose | 689 | 674–782 | 12.16x | 67 | 67.00x | 56 | yes |
| library-load | 1 | fusion | 1647 | 1474–1988 | 29.05x | 262 | 262.00x | 252 | yes |
| library-load | 1 | fusion-charm | 2218 | 1722–2408 | 39.12x | 316 | 316.00x | 314 | yes |
| library-load | 1 | react | 5391 | 4788–5667 | 95.07x | 1805 | 1805.00x | 1804 | yes |
| library-load | 1 | react-reflex | 5550 | 5074–6430 | 97.88x | 1960 | 1960.00x | 1965 | yes |
| library-load | 1 | react-upstream | 6101 | 5485–6245 | 107.61x | 1982 | 1982.00x | 1980 | yes |
| library-load | 1 | roact | 525 | 484–627 | 9.26x | 144 | 144.00x | 140 | yes |
| library-load | 1 | seam | 1966 | 1565–2421 | 34.67x | 240 | 240.00x | 237 | yes |
| library-load | 1 | signals | 238 | 222–249 | 4.19x | 49 | 49.00x | 47 | yes |
| library-load | 1 | vide | 363 | 349–422 | 6.41x | 145 | 145.00x | 136 | yes |
| rows-append-1000 | 1 | plain | 164640 | 161458–220475 | 1.00x | 6316 | 1.00x | 9 | yes |
| rows-append-1000 | 1 | blend | 265221 | 239826–286600 | 1.61x | 38241 | 6.05x | 1 | yes |
| rows-append-1000 | 1 | compose | 198884 | 186382–265323 | 1.21x | 9273 | 1.47x | 3 | yes |
| rows-append-1000 | 1 | fusion | 344816 | 313329–357978 | 2.09x | 20706 | 3.28x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 336217 | 321929–352266 | 2.04x | 28529 | 4.52x | 0 | yes |
| rows-append-1000 | 1 | react | 255870 | 226640–294678 | 1.55x | 22937 | 3.63x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 265026 | 262511–346690 | 1.61x | 24813 | 3.93x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 254577 | 232563–321106 | 1.55x | 22921 | 3.63x | 0 | yes |
| rows-append-1000 | 1 | roact | 227908 | 218979–250565 | 1.38x | 33259 | 5.27x | 1 | yes |
| rows-append-1000 | 1 | seam | 219140 | 197745–252708 | 1.33x | 48064 | 7.61x | 232 | yes |
| rows-append-1000 | 1 | signals | 195392 | 169257–227773 | 1.19x | 18658 | 2.95x | 4 | yes |
| rows-append-1000 | 1 | vide | 195141 | 164199–258640 | 1.19x | 10215 | 1.62x | 0 | yes |
| rows-clear | 1 | plain | 20560 | 16300–23100 | 1.00x | 1229 | 1.00x | 8 | yes |
| rows-clear | 1 | blend | 44418 | 41500–48706 | 2.16x | 4169 | 3.39x | 1 | yes |
| rows-clear | 1 | compose | 26898 | 25716–31579 | 1.31x | 1805 | 1.47x | 10 | yes |
| rows-clear | 1 | fusion | 60173 | 57570–61139 | 2.93x | 3473 | 2.83x | 0 | yes |
| rows-clear | 1 | fusion-charm | 60062 | 54500–60334 | 2.92x | 7161 | 5.83x | 0 | yes |
| rows-clear | 1 | react | 28206 | 25732–29322 | 1.37x | 4479 | 3.64x | 0 | yes |
| rows-clear | 1 | react-reflex | 32374 | 29282–50698 | 1.57x | 6490 | 5.28x | 37 | yes |
| rows-clear | 1 | react-upstream | 27306 | 25137–31702 | 1.33x | 4487 | 3.65x | 8 | yes |
| rows-clear | 1 | roact | 28505 | 22817–33207 | 1.39x | 4206 | 3.42x | 0 | yes |
| rows-clear | 1 | seam | 34999 | 19164–45216 | 1.70x | 9230 | 7.51x | 0 | yes |
| rows-clear | 1 | signals | 21532 | 20694–26756 | 1.05x | 4442 | 3.61x | 0 | yes |
| rows-clear | 1 | vide | 23812 | 18338–25904 | 1.16x | 1605 | 1.31x | 1 | yes |
| rows-create-1000 | 1 | plain | 155516 | 152953–172269 | 1.00x | 3127 | 1.00x | 8 | yes |
| rows-create-1000 | 1 | blend | 230126 | 207664–262421 | 1.48x | 19511 | 6.24x | 8 | yes |
| rows-create-1000 | 1 | compose | 179844 | 170344–247814 | 1.16x | 4703 | 1.50x | 2 | yes |
| rows-create-1000 | 1 | fusion | 230107 | 216751–257280 | 1.48x | 10555 | 3.38x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 227676 | 215837–268286 | 1.46x | 14477 | 4.63x | 7 | yes |
| rows-create-1000 | 1 | react | 208416 | 204161–242752 | 1.34x | 7882 | 2.52x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 243546 | 220929–261083 | 1.57x | 8829 | 2.82x | 36 | yes |
| rows-create-1000 | 1 | react-upstream | 219025 | 198966–241364 | 1.41x | 7891 | 2.52x | 0 | yes |
| rows-create-1000 | 1 | roact | 202178 | 186365–211916 | 1.30x | 16669 | 5.33x | 1 | yes |
| rows-create-1000 | 1 | seam | 227243 | 208918–240475 | 1.46x | 23862 | 7.63x | 0 | yes |
| rows-create-1000 | 1 | signals | 175759 | 158196–184761 | 1.13x | 9104 | 2.91x | 0 | yes |
| rows-create-1000 | 1 | vide | 183576 | 173027–197180 | 1.18x | 4961 | 1.59x | 0 | yes |
| rows-create-10000 | 1 | plain | 1915177 | 1892406–1953190 | 1.00x | 29792 | 1.00x | 12 | yes |
| rows-create-10000 | 1 | blend | 2712120 | 2462317–2807207 | 1.42x | 182312 | 6.12x | 8 | yes |
| rows-create-10000 | 1 | compose | 2354081 | 2231211–2384887 | 1.23x | 48604 | 1.63x | 14 | yes |
| rows-create-10000 | 1 | fusion | 6727693 | 5850192–6887099 | 3.51x | 101328 | 3.40x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 7049318 | 6631521–7366982 | 3.68x | 145140 | 4.87x | 4 | yes |
| rows-create-10000 | 1 | react | 4622437 | 4590046–4885739 | 2.41x | 76732 | 2.58x | 200 | yes |
| rows-create-10000 | 1 | react-reflex | 4698683 | 4655529–4911725 | 2.45x | 85976 | 2.89x | 554 | yes |
| rows-create-10000 | 1 | react-upstream | 4515560 | 4491154–4694325 | 2.36x | 78334 | 2.63x | 124 | yes |
| rows-create-10000 | 1 | roact | 2456594 | 2325326–2470386 | 1.28x | 166215 | 5.58x | 0 | yes |
| rows-create-10000 | 1 | seam | 2646139 | 2498891–2758497 | 1.38x | 235288 | 7.90x | 4 | yes |
| rows-create-10000 | 1 | signals | 2108761 | 2081844–2265553 | 1.10x | 89181 | 2.99x | 4 | yes |
| rows-create-10000 | 1 | vide | 2091284 | 2022613–2378897 | 1.09x | 48460 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 650 | 400–1244 | 1.00x | 2741 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1000 | 898–1100 | 1.54x | 18279 | 6.67x | 1 | yes |
| rows-remove-one | 1 | compose | 600 | 400–600 | 0.92x | 4186 | 1.53x | 13 | yes |
| rows-remove-one | 1 | fusion (workaround) | 35515 | 34202–37301 | 54.64x | 10110 | 3.69x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 33509 | 32800–34300 | 51.55x | 14030 | 5.12x | 2 | yes |
| rows-remove-one | 1 | react | 20611 | 16183–32603 | 31.71x | 14831 | 5.41x | 32 | yes |
| rows-remove-one | 1 | react-reflex | 40724 | 23908–62064 | 62.65x | 15889 | 5.80x | 4 | yes |
| rows-remove-one | 1 | react-upstream | 25409 | 16801–83716 | 39.09x | 14991 | 5.47x | 15 | yes |
| rows-remove-one | 1 | roact | 18514 | 13807–21500 | 28.48x | 16289 | 5.94x | 1 | yes |
| rows-remove-one | 1 | seam | 4611 | 4500–4900 | 7.09x | 23230 | 8.47x | 4 | yes |
| rows-remove-one | 1 | signals | 1556 | 1450–2011 | 2.39x | 8614 | 3.14x | 1 | yes |
| rows-remove-one | 1 | vide | 1250 | 750–1358 | 1.92x | 4570 | 1.67x | 1 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 3152 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 500 | 300–905 | 5.00x | 18739 | 5.95x | 1 | yes |
| rows-swap | 1 | compose | 150 | 100–400 | 1.50x | 4628 | 1.47x | 2 | yes |
| rows-swap | 1 | fusion | 40500 | 31215–42654 | 405.00x | 10023 | 3.18x | 8 | yes |
| rows-swap | 1 | fusion-charm | 32144 | 31158–36509 | 321.44x | 14683 | 4.66x | 0 | yes |
| rows-swap | 1 | react | 34812 | 27515–36659 | 348.12x | 15494 | 4.92x | 24 | yes |
| rows-swap | 1 | react-reflex | 45112 | 43301–80020 | 451.12x | 16423 | 5.21x | 60 | yes |
| rows-swap | 1 | react-upstream | 35300 | 34461–82445 | 353.00x | 15462 | 4.91x | 1 | yes |
| rows-swap | 1 | roact | 19100 | 15800–22032 | 191.00x | 16761 | 5.32x | 1 | yes |
| rows-swap | 1 | seam | 4500 | 3600–5102 | 45.00x | 23684 | 7.51x | 0 | yes |
| rows-swap | 1 | signals | 600 | 400–1200 | 6.00x | 9066 | 2.88x | 1 | yes |
| rows-swap | 1 | vide | 100 | 100–200 | 1.00x | 4980 | 1.58x | 7 | yes |
| rows-update-every-10th | 1 | plain | 4000 | 3621–4200 | 1.00x | 3183 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 4300 | 3945–5900 | 1.07x | 19256 | 6.05x | 1 | yes |
| rows-update-every-10th | 1 | compose | 3995 | 3600–4516 | 1.00x | 4701 | 1.48x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 4400 | 3891–4851 | 1.10x | 10544 | 3.31x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 5323 | 4122–5606 | 1.33x | 14456 | 4.54x | 1 | yes |
| rows-update-every-10th | 1 | react | 3905 | 3784–4507 | 0.98x | 7958 | 2.50x | 40 | yes |
| rows-update-every-10th | 1 | react-reflex | 6300 | 5524–22278 | 1.57x | 8822 | 2.77x | 20 | yes |
| rows-update-every-10th | 1 | react-upstream | 4150 | 3900–4792 | 1.04x | 7885 | 2.48x | 0 | yes |
| rows-update-every-10th | 1 | roact | 4008 | 3615–4548 | 1.00x | 16698 | 5.25x | 1 | yes |
| rows-update-every-10th | 1 | seam | 6338 | 5400–6605 | 1.58x | 24212 | 7.61x | 0 | yes |
| rows-update-every-10th | 1 | signals | 4254 | 3960–4856 | 1.06x | 9330 | 2.93x | 0 | yes |
| rows-update-every-10th | 1 | vide | 4100 | 3800–5859 | 1.02x | 5116 | 1.61x | 9 | yes |

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
| blend | 29 | 2.52x | 9.90x | 2.48x | 9.60x |
| compose | 30 | 1.95x | 3.29x | 1.87x | 3.22x |
| fusion | 30 | 6.04x | 6.00x | 5.55x | 6.01x |
| fusion-charm | 30 | 5.66x | 6.04x | 5.18x | 6.05x |
| react | 29 | 4.63x | 6.69x | 4.49x | 7.11x |
| react-reflex | 29 | 5.20x | 9.32x | 5.04x | 9.97x |
| react-upstream | 29 | 4.65x | 5.91x | 4.52x | 6.25x |
| roact | 29 | 3.10x | 5.42x | 3.06x | 6.11x |
| seam | 30 | 4.07x | 11.89x | 3.75x | 11.77x |
| signals | 29 | 1.98x | 2.76x | 1.90x | 2.75x |
| vide | 30 | 2.04x | 2.85x | 1.94x | 2.85x |
