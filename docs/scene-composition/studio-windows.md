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
| Roblox Studio | 0.745.449.7450003 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `a07c78b` |
| Date | 2026-11-03 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 1600 | 1100–2900 | 1.00x | 57 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 2133 | 1967–2169 | 1.33x | 765 | 13.42x | 1 | yes |
| update-leaf | 20 | compose | 2100 | 1908–2400 | 1.31x | 61 | 1.07x | 0 | yes |
| update-leaf | 20 | fusion | 2450 | 2250–2850 | 1.53x | 52 | 0.91x | 0 | yes |
| update-leaf | 20 | fusion-charm | 2651 | 2350–3005 | 1.66x | 61 | 1.07x | 0 | yes |
| update-leaf | 20 | react | 2500 | 2050–2601 | 1.56x | 347 | 6.09x | 0 | yes |
| update-leaf | 20 | react-reflex | 2550 | 2150–2850 | 1.59x | 293 | 5.14x | 0 | yes |
| update-leaf | 20 | react-upstream | 2133 | 1948–2629 | 1.33x | 291 | 5.11x | 0 | yes |
| update-leaf | 20 | roact | 2150 | 1900–2188 | 1.34x | 951 | 16.68x | 0 | yes |
| update-leaf | 20 | seam | 2100 | 2010–2600 | 1.31x | 41 | 0.72x | 1 | yes |
| update-leaf | 20 | signals | 2089 | 2033–2223 | 1.31x | 59 | 1.04x | 1 | yes |
| update-leaf | 20 | vide | 2300 | 2068–2600 | 1.44x | 4 | 0.07x | 0 | yes |
| update-batched | 20 | plain | 4357 | 4227–4500 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 10700 | 10200–10761 | 2.46x | 925 | 46.25x | 1 | yes |
| update-batched | 20 | compose | 7314 | 6747–8130 | 1.68x | 376 | 18.80x | 10 | yes |
| update-batched | 20 | fusion | 18327 | 17605–18800 | 4.21x | 508 | 25.40x | 0 | yes |
| update-batched | 20 | fusion-charm | 33027 | 29400–36455 | 7.58x | 1109 | 55.45x | 0 | yes |
| update-batched | 20 | react | 7859 | 7533–8355 | 1.80x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | react-reflex | 51154 | 48262–58191 | 11.74x | 783 | 39.15x | 9 | yes |
| update-batched | 20 | react-upstream | 8005 | 7301–8280 | 1.84x | 484 | 24.20x | 0 | yes |
| update-batched | 20 | roact | 8000 | 7200–9500 | 1.84x | 1169 | 58.45x | 0 | yes |
| update-batched | 20 | seam | 11900 | 10900–12831 | 2.73x | 1832 | 91.60x | 1 | yes |
| update-batched | 20 | signals | 9256 | 9101–10434 | 2.12x | 597 | 29.85x | 0 | yes |
| update-batched | 20 | vide | 8357 | 8023–10246 | 1.92x | 332 | 16.60x | 0 | yes |
| update-repeated | 10 | plain | 47 | 43–51 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3650 | 2950–3900 | 78.33x | 7 | 3.50x | 1 | yes |
| update-repeated | 10 | compose | 500 | 300–800 | 10.73x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 24900 | 23916–25602 | 534.33x | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1325 | 1225–1425 | 28.44x | 7 | 3.50x | 1 | yes |
| update-repeated | 10 | react | 5200 | 5100–6100 | 111.59x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 1086 | 957–1229 | 23.30x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 5700 | 5200–6042 | 122.32x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6500 | 5600–7900 | 139.48x | 15 | 7.50x | 1 | yes |
| update-repeated | 10 | seam | 1933 | 1534–2133 | 41.49x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 920 | 860–1220 | 19.74x | 0 | 0.50x | 1 | yes |
| update-repeated | 10 | vide | 589 | 544–700 | 12.64x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 21500 | 21103–30620 | 1.00x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 29110 | 28209–34717 | 1.35x | 35 | 17.50x | 8 | yes |
| branch-swap | 20 | compose | 28903 | 27015–31836 | 1.34x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | fusion | 31800 | 27194–34290 | 1.48x | 0 | 0.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 28952 | 26205–36247 | 1.35x | 14 | 7.00x | 1 | yes |
| branch-swap | 20 | react | 29600 | 26603–31348 | 1.38x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 30801 | 27855–34937 | 1.43x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 29666 | 27908–35704 | 1.38x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | roact | 28900 | 27997–31409 | 1.34x | 12 | 6.00x | 1 | yes |
| branch-swap | 20 | seam | 27000 | 25715–30341 | 1.26x | 11 | 5.50x | 1 | yes |
| branch-swap | 20 | signals | 27100 | 23836–31419 | 1.26x | 6 | 3.00x | 1 | yes |
| branch-swap | 20 | vide | 28722 | 26919–35531 | 1.34x | 14 | 7.00x | 1 | yes |
| keyed-prepend | 10 | plain | 1833 | 1600–1944 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4270 | 4050–4982 | 2.33x | 1490 | 23.28x | 0 | yes |
| keyed-prepend | 10 | compose | 3692 | 3500–4145 | 2.01x | 501 | 7.83x | 18 | yes |
| keyed-prepend | 10 | fusion (workaround) | 17710 | 15800–18133 | 9.66x | 1527 | 23.86x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 15823 | 14542–16700 | 8.63x | 1513 | 23.64x | 2 | yes |
| keyed-prepend | 10 | react | 10165 | 9334–10859 | 5.54x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 10800 | 10300–13200 | 5.89x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 11200 | 10262–11500 | 6.11x | 785 | 12.27x | 1 | yes |
| keyed-prepend | 10 | roact | 5822 | 5200–6233 | 3.18x | 361 | 5.64x | 0 | yes |
| keyed-prepend | 10 | seam | 9541 | 8727–11353 | 5.20x | 2447 | 38.23x | 1 | yes |
| keyed-prepend | 10 | signals | 2550 | 2150–2901 | 1.39x | 61 | 0.95x | 0 | yes |
| keyed-prepend | 10 | vide | 4300 | 4000–5052 | 2.35x | 646 | 10.09x | 0 | yes |
| keyed-insert | 10 | plain | 1222 | 1092–1340 | 1.00x | 73 | 1.00x | 1 | yes |
| keyed-insert | 10 | blend | 3557 | 3437–3602 | 2.91x | 1498 | 20.52x | 10 | yes |
| keyed-insert | 10 | compose | 2950 | 2682–3400 | 2.41x | 502 | 6.88x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 13600 | 13300–14300 | 11.13x | 1527 | 20.92x | 9 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 14196 | 13700–15500 | 11.62x | 1528 | 20.93x | 0 | yes |
| keyed-insert | 10 | react | 9296 | 8200–13400 | 7.61x | 811 | 11.11x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9204 | 8600–11270 | 7.53x | 875 | 11.99x | 0 | yes |
| keyed-insert | 10 | react-upstream | 9200 | 9102–9600 | 7.53x | 811 | 11.11x | 8 | yes |
| keyed-insert | 10 | roact | 4961 | 4800–5700 | 4.06x | 361 | 4.95x | 0 | yes |
| keyed-insert | 10 | seam | 9000 | 8316–10214 | 7.36x | 2447 | 33.52x | 0 | yes |
| keyed-insert | 10 | signals | 1833 | 1600–1868 | 1.50x | 61 | 0.84x | 0 | yes |
| keyed-insert | 10 | vide | 3250 | 3200–3719 | 2.66x | 638 | 8.74x | 0 | yes |
| keyed-shuffle | 10 | plain | 1250 | 1200–1509 | 1.00x | 53 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 2576 | 2350–2752 | 2.06x | 1448 | 27.32x | 1 | yes |
| keyed-shuffle | 10 | compose | 2401 | 2250–2550 | 1.92x | 500 | 9.43x | 9 | yes |
| keyed-shuffle | 10 | fusion | 14121 | 13370–16255 | 11.30x | 1398 | 26.38x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 14480 | 13982–17023 | 11.58x | 1392 | 26.26x | 0 | yes |
| keyed-shuffle | 10 | react | 15797 | 14204–16500 | 12.64x | 779 | 14.70x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 15202 | 13987–16409 | 12.16x | 779 | 14.70x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 15767 | 15300–19001 | 12.61x | 779 | 14.70x | 0 | yes |
| keyed-shuffle | 10 | roact | 4700 | 4366–5514 | 3.76x | 368 | 6.94x | 0 | yes |
| keyed-shuffle | 10 | seam | 7700 | 6900–8710 | 6.16x | 2462 | 46.45x | 1 | yes |
| keyed-shuffle | 10 | signals | 1674 | 1572–1850 | 1.34x | 60 | 1.13x | 0 | yes |
| keyed-shuffle | 10 | vide | 2700 | 2455–3050 | 2.16x | 630 | 11.89x | 1 | yes |
| events | 1 | plain | 2900 | 2400–3000 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | blend | 3300 | 2900–4217 | 1.14x | 1 | 1.00x | 0 | yes |
| events | 1 | compose | 3100 | 2500–3600 | 1.07x | 3 | 3.00x | 2 | yes |
| events | 1 | fusion | 3700 | 2900–4300 | 1.28x | 9 | 9.00x | 1 | yes |
| events | 1 | fusion-charm | 3500 | 3500–4400 | 1.21x | 9 | 9.00x | 0 | yes |
| events | 1 | react | 3857 | 2805–4800 | 1.33x | 0 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 3700 | 3300–4100 | 1.28x | 1 | 1.00x | 0 | yes |
| events | 1 | react-upstream | 3000 | 2500–4000 | 1.03x | 9 | 9.00x | 0 | yes |
| events | 1 | roact | 3800 | 3307–4200 | 1.31x | 9 | 9.00x | 0 | yes |
| events | 1 | seam | 3100 | 3000–3300 | 1.07x | 9 | 9.00x | 1 | yes |
| events | 1 | signals | 2953 | 2201–3408 | 1.02x | 9 | 9.00x | 0 | yes |
| events | 1 | vide | 3500 | 2500–4500 | 1.21x | 2 | 2.00x | 1 | yes |
| animate-many | 1 | plain | 2400 | 2200–2766 | 1.00x | 65 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 9900 | 9348–11200 | 4.12x | 1771 | 27.25x | 0 | yes |
| animate-many | 1 | compose | 6400 | 6000–6600 | 2.67x | 634 | 9.75x | 12 | yes |
| animate-many | 1 | fusion | 62855 | 62603–63511 | 26.19x | 1128 | 17.35x | 0 | yes |
| animate-many | 1 | fusion-charm | 64984 | 63432–67978 | 27.08x | 1130 | 17.38x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20205 | 18902–20623 | 8.42x | 2898 | 44.58x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 9017 | 7903–9337 | 3.76x | 392 | 6.03x | 0 | yes |
| status-panel | 10 | plain | 920 | 864–980 | 1.00x | 0 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 2350 | 2000–2600 | 2.55x | 70 | 70.00x | 1 | yes |
| status-panel | 10 | compose | 2402 | 2186–2750 | 2.61x | 23 | 23.00x | 2 | yes |
| status-panel | 10 | fusion | 2800 | 2666–3050 | 3.04x | 64 | 64.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 3000 | 2600–3100 | 3.26x | 70 | 70.00x | 0 | yes |
| status-panel | 10 | react | 3150 | 2550–4100 | 3.42x | 42 | 42.00x | 0 | yes |
| status-panel | 10 | react-reflex | 3000 | 2650–3900 | 3.26x | 45 | 45.00x | 0 | yes |
| status-panel | 10 | react-upstream | 3004 | 2816–3329 | 3.26x | 42 | 42.00x | 0 | yes |
| status-panel | 10 | roact | 2300 | 2150–2564 | 2.50x | 33 | 33.00x | 0 | yes |
| status-panel | 10 | seam | 2900 | 2800–2900 | 3.15x | 141 | 141.00x | 0 | yes |
| status-panel | 10 | signals | 2171 | 2033–2216 | 2.36x | 15 | 15.00x | 0 | yes |
| status-panel | 10 | vide | 2350 | 2150–2501 | 2.55x | 33 | 33.00x | 1 | yes |
| scene-3d | 10 | plain | 2367 | 2214–2433 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4700 | 4385–4900 | 1.99x | 573 | 52.09x | 0 | yes |
| scene-3d | 10 | compose | 3300 | 3200–4050 | 1.39x | 178 | 16.18x | 10 | yes |
| scene-3d | 10 | fusion | 21501 | 20302–23614 | 9.08x | 512 | 46.55x | 0 | yes |
| scene-3d | 10 | fusion-charm | 21316 | 19485–23282 | 9.01x | 516 | 46.91x | 1 | yes |
| scene-3d | 10 | react | 4000 | 3250–4406 | 1.69x | 231 | 21.00x | 0 | yes |
| scene-3d | 10 | react-reflex | 3300 | 3150–3550 | 1.39x | 232 | 21.09x | 0 | yes |
| scene-3d | 10 | react-upstream | 3500 | 3300–4250 | 1.48x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 3400 | 3050–3550 | 1.44x | 574 | 52.18x | 0 | yes |
| scene-3d | 10 | seam | 8500 | 7800–8603 | 3.59x | 1763 | 160.27x | 0 | yes |
| scene-3d | 10 | signals | 5800 | 5300–7500 | 2.45x | 682 | 62.00x | 0 | yes |
| scene-3d | 10 | vide | 4008 | 3500–4200 | 1.69x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 19 | 17–23 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 159 | 129–182 | 8.19x | 28 | 7.00x | 1 | yes |
| derived-diamond | 3 | compose | 159 | 147–171 | 8.19x | 10 | 2.50x | 2 | yes |
| derived-diamond | 3 | fusion | 148 | 129–194 | 7.64x | 9 | 2.25x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 181 | 175–206 | 9.35x | 10 | 2.50x | 0 | yes |
| derived-diamond | 3 | react | 282 | 269–337 | 14.54x | 0 | 0.25x | 4 | yes |
| derived-diamond | 3 | react-reflex | 315 | 262–338 | 16.27x | 18 | 4.50x | 6 | yes |
| derived-diamond | 3 | react-upstream | 292 | 283–335 | 15.04x | 6 | 1.50x | 3 | yes |
| derived-diamond | 3 | roact | 147 | 129–171 | 7.59x | 19 | 4.75x | 4 | yes |
| derived-diamond | 3 | seam | 229 | 180–300 | 11.83x | 29 | 7.25x | 1 | yes |
| derived-diamond | 3 | signals | 129 | 118–148 | 6.68x | 9 | 2.25x | 1 | yes |
| derived-diamond | 3 | vide | 159 | 135–160 | 8.19x | 6 | 1.50x | 0 | yes |
| derived-chain-100 | 3 | plain | 34 | 29–36 | 1.00x | 58 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 181 | 153–194 | 5.34x | 126 | 2.17x | 2 | yes |
| derived-chain-100 | 3 | fusion | 522 | 469–594 | 15.41x | 127 | 2.19x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 576 | 550–619 | 17.01x | 129 | 2.22x | 1 | yes |
| derived-chain-100 | 3 | react | 392 | 342–408 | 11.56x | 61 | 1.05x | 4 | yes |
| derived-chain-100 | 3 | react-reflex | 400 | 367–433 | 11.81x | 80 | 1.38x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 345 | 336–463 | 10.20x | 69 | 1.19x | 12 | yes |
| derived-chain-100 | 3 | roact | 141 | 141–176 | 4.17x | 10 | 0.17x | 3 | yes |
| derived-chain-100 | 3 | seam | 675 | 612–912 | 19.92x | 271 | 4.67x | 0 | yes |
| derived-chain-100 | 3 | signals | 180 | 140–260 | 5.31x | 166 | 2.86x | 1 | yes |
| derived-chain-100 | 3 | vide | 144 | 138–169 | 4.24x | 93 | 1.60x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 93 | 85–101 | 1.00x | 497 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 200 | 177–285 | 2.16x | 1535 | 3.09x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 323 | 300–338 | 3.49x | 695 | 1.40x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 1100 | 1060–1320 | 11.89x | 897 | 1.80x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1126 | 1076–1163 | 12.16x | 2821 | 5.68x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1867 | 1300–2133 | 20.17x | 671 | 1.35x | 52 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8500 | 7287–9700 | 91.85x | 5646 | 11.36x | 82 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2000 | 1533–2267 | 21.61x | 656 | 1.32x | 43 | yes |
| derived-fan-in-1000 | 3 | roact | 425 | 300–475 | 4.59x | 112 | 0.23x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 1499 | 1433–1933 | 16.20x | 2955 | 5.95x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 489 | 456–611 | 5.28x | 1205 | 2.42x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 375 | 326–400 | 4.05x | 520 | 1.05x | 0 | yes |
| filter-as-you-type | 1 | plain | 6406 | 6100–6608 | 1.00x | 35 | 1.00x | 1 | yes |
| filter-as-you-type | 1 | blend | 14269 | 13703–14801 | 2.23x | 2654 | 75.83x | 0 | yes |
| filter-as-you-type | 1 | compose | 10300 | 9501–10506 | 1.61x | 746 | 21.31x | 17 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 21302 | 20400–22311 | 3.33x | 2520 | 72.00x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 21000 | 19200–22021 | 3.28x | 2586 | 73.89x | 1 | yes |
| filter-as-you-type | 1 | react | 13614 | 13189–14200 | 2.13x | 76 | 2.17x | 11 | yes |
| filter-as-you-type | 1 | react-reflex | 14600 | 13445–14784 | 2.28x | 831 | 23.74x | 14 | yes |
| filter-as-you-type | 1 | react-upstream | 14200 | 13550–17237 | 2.22x | 75 | 2.14x | 11 | yes |
| filter-as-you-type | 1 | roact | 9802 | 9500–10403 | 1.53x | 495 | 14.14x | 0 | yes |
| filter-as-you-type | 1 | seam | 20600 | 17000–23712 | 3.22x | 3869 | 110.54x | 1 | yes |
| filter-as-you-type | 1 | signals | 8000 | 6932–8468 | 1.25x | 36 | 1.03x | 8 | yes |
| filter-as-you-type | 1 | vide | 10300 | 9042–10672 | 1.61x | 967 | 27.63x | 8 | yes |
| theme-propagation | 3 | plain | 127019 | 111534–154643 | 1.00x | 206 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 126140 | 109659–126489 | 0.99x | 1997 | 9.69x | 8 | yes |
| theme-propagation | 3 | compose | 132314 | 115833–207021 | 1.04x | 516 | 2.50x | 0 | yes |
| theme-propagation | 3 | fusion | 124190 | 111324–153223 | 0.98x | 803 | 3.90x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 116156 | 114064–125139 | 0.91x | 813 | 3.95x | 1 | yes |
| theme-propagation | 3 | react | 125193 | 114850–189051 | 0.99x | 1972 | 9.57x | 1 | yes |
| theme-propagation | 3 | react-reflex | 113209 | 110731–134795 | 0.89x | 1965 | 9.54x | 1 | yes |
| theme-propagation | 3 | react-upstream | 116433 | 113606–131606 | 0.92x | 1963 | 9.53x | 0 | yes |
| theme-propagation | 3 | roact | 121523 | 111193–131675 | 0.96x | 3190 | 15.49x | 0 | yes |
| theme-propagation | 3 | seam | 103793 | 103284–116171 | 0.82x | 3422 | 16.61x | 1 | yes |
| theme-propagation | 3 | signals | 157046 | 128157–187148 | 1.24x | 880 | 4.27x | 0 | yes |
| theme-propagation | 3 | vide | 116800 | 111138–148222 | 0.92x | 596 | 2.89x | 0 | yes |
| hud-per-frame | 1 | plain | 3400 | 3100–3500 | 1.00x | 23 | 1.00x | 1 | yes |
| hud-per-frame | 1 | blend | 6183 | 5046–6733 | 1.82x | 71 | 3.09x | 0 | yes |
| hud-per-frame | 1 | compose | 5787 | 4891–6464 | 1.70x | 28 | 1.22x | 1 | yes |
| hud-per-frame | 1 | fusion | 11200 | 9700–11506 | 3.29x | 54 | 2.35x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13400 | 12700–14621 | 3.94x | 98 | 4.26x | 1 | yes |
| hud-per-frame | 1 | react | 4600 | 4300–5200 | 1.35x | 41 | 1.78x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7807 | 7387–8610 | 2.30x | 46 | 2.00x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 4100 | 4000–5800 | 1.21x | 26 | 1.13x | 0 | yes |
| hud-per-frame | 1 | roact | 4813 | 4400–6000 | 1.42x | 90 | 3.91x | 0 | yes |
| hud-per-frame | 1 | seam | 9021 | 8300–9270 | 2.65x | 177 | 7.70x | 0 | yes |
| hud-per-frame | 1 | signals | 5100 | 4900–6704 | 1.50x | 66 | 2.87x | 1 | yes |
| hud-per-frame | 1 | vide | 5200 | 4941–5700 | 1.53x | 25 | 1.09x | 0 | yes |
| teardown-under-load | 1 | plain | 52310 | 51510–54111 | 1.00x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 63920 | 58076–65603 | 1.22x | 6 | 1.20x | 0 | yes |
| teardown-under-load | 1 | compose | 57304 | 56128–61230 | 1.10x | 7 | 1.40x | 2 | yes |
| teardown-under-load | 1 | fusion | 76301 | 64288–84415 | 1.46x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 77072 | 63866–81943 | 1.47x | 7 | 1.40x | 0 | yes |
| teardown-under-load | 1 | react | 70208 | 67503–78127 | 1.34x | 1076 | 215.20x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 70215 | 67305–72473 | 1.34x | 1079 | 215.80x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 70807 | 68418–79573 | 1.35x | 1078 | 215.60x | 0 | yes |
| teardown-under-load | 1 | roact | 66710 | 59448–69506 | 1.28x | 79 | 15.80x | 8 | yes |
| teardown-under-load | 1 | seam | 65564 | 58800–77976 | 1.25x | 8 | 1.60x | 7 | yes |
| teardown-under-load | 1 | signals | 57764 | 57304–58558 | 1.10x | 13 | 2.60x | 1 | yes |
| teardown-under-load | 1 | vide | 61693 | 59855–63752 | 1.18x | 12 | 2.40x | 1 | yes |
| open-close-retention | 1 | plain | 68552 | 66812–73703 | 1.00x | 40 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 107602 | 102676–111012 | 1.57x | 6 | 0.15x | 1 | yes |
| open-close-retention | 1 | compose | 81230 | 80194–82151 | 1.18x | 14 | 0.35x | 2 | yes |
| open-close-retention | 1 | fusion | 127133 | 122832–129278 | 1.85x | 5 | 0.12x | 8 | yes |
| open-close-retention | 1 | fusion-charm | 124421 | 121483–126386 | 1.81x | 7 | 0.17x | 0 | yes |
| open-close-retention | 1 | react | 106228 | 104571–116306 | 1.55x | 299 | 7.47x | 5 | yes |
| open-close-retention | 1 | react-reflex | 103875 | 98655–104124 | 1.52x | 293 | 7.33x | 0 | yes |
| open-close-retention | 1 | react-upstream | 103304 | 101745–108845 | 1.51x | 291 | 7.28x | 0 | yes |
| open-close-retention | 1 | roact | 100162 | 97866–107189 | 1.46x | 23 | 0.57x | 1 | yes |
| open-close-retention | 1 | seam | 112870 | 104627–115876 | 1.65x | 8 | 0.20x | 0 | yes |
| open-close-retention | 1 | signals | 81418 | 79460–86626 | 1.19x | 4 | 0.10x | 1 | yes |
| open-close-retention | 1 | vide | 87226 | 85401–89114 | 1.27x | 4 | 0.10x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7924 | 7509–8509 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 18642 | 16400–19400 | 2.35x | 780 | 39.00x | 0 | yes |
| tree-expand-collapse | 1 | compose | 11685 | 10702–12131 | 1.47x | 58 | 2.90x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 20745 | 17761–24803 | 2.62x | 157 | 7.85x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 19500 | 17000–22700 | 2.46x | 167 | 8.35x | 1 | yes |
| tree-expand-collapse | 1 | react | 15747 | 14304–18040 | 1.99x | 69 | 3.45x | 20 | yes |
| tree-expand-collapse | 1 | react-reflex | 14714 | 13605–16933 | 1.86x | 680 | 34.00x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 14100 | 13300–17713 | 1.78x | 62 | 3.10x | 12 | yes |
| tree-expand-collapse | 1 | roact | 10400 | 10386–12714 | 1.31x | 35 | 1.75x | 2 | yes |
| tree-expand-collapse | 1 | seam | 24301 | 19604–27033 | 3.07x | 141 | 7.05x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8718 | 7900–9600 | 1.10x | 22 | 1.10x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11600 | 9700–12666 | 1.46x | 71 | 3.55x | 0 | yes |
| form-validation | 1 | plain | 3274 | 3186–3462 | 1.00x | 53 | 1.00x | 1 | yes |
| form-validation | 1 | blend | 7900 | 7400–8919 | 2.41x | 335 | 6.32x | 1 | yes |
| form-validation | 1 | compose | 7900 | 7000–8822 | 2.41x | 94 | 1.77x | 1 | yes |
| form-validation | 1 | fusion | 9500 | 8604–9500 | 2.90x | 118 | 2.23x | 0 | yes |
| form-validation | 1 | fusion-charm | 8960 | 8405–9519 | 2.74x | 163 | 3.08x | 0 | yes |
| form-validation | 1 | react | 9101 | 8200–9700 | 2.78x | 66 | 1.25x | 0 | yes |
| form-validation | 1 | react-reflex | 8768 | 7900–10062 | 2.68x | 83 | 1.57x | 2 | yes |
| form-validation | 1 | react-upstream | 8627 | 8000–8911 | 2.63x | 66 | 1.25x | 0 | yes |
| form-validation | 1 | roact | 8573 | 8300–9023 | 2.62x | 223 | 4.21x | 1 | yes |
| form-validation | 1 | seam | 9700 | 9500–10700 | 2.96x | 356 | 6.72x | 1 | yes |
| form-validation | 1 | signals | 8000 | 7200–8600 | 2.44x | 155 | 2.92x | 0 | yes |
| form-validation | 1 | vide | 7300 | 7081–7400 | 2.23x | 70 | 1.32x | 0 | yes |
| table-sort-filter | 1 | plain | 15900 | 14509–18178 | 1.00x | 74 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 32644 | 28261–34677 | 2.05x | 5388 | 72.81x | 1 | yes |
| table-sort-filter | 1 | compose | 21949 | 20888–22032 | 1.38x | 1435 | 19.39x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 50204 | 40500–55223 | 3.16x | 4703 | 63.55x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 48927 | 44400–54512 | 3.08x | 4706 | 63.59x | 0 | yes |
| table-sort-filter | 1 | react | 51558 | 50311–59624 | 3.24x | 2115 | 28.58x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 50829 | 48881–54415 | 3.20x | 2122 | 28.68x | 22 | yes |
| table-sort-filter | 1 | react-upstream | 54979 | 50802–61369 | 3.46x | 2107 | 28.47x | 19 | yes |
| table-sort-filter | 1 | roact | 21702 | 20000–22630 | 1.36x | 1014 | 13.70x | 12 | yes |
| table-sort-filter | 1 | seam | 54101 | 49236–61202 | 3.40x | 7687 | 103.88x | 1 | yes |
| table-sort-filter | 1 | signals | 16600 | 15488–19770 | 1.04x | 68 | 0.92x | 0 | yes |
| table-sort-filter | 1 | vide | 21400 | 20235–25132 | 1.35x | 1914 | 25.86x | 0 | yes |
| library-load | 1 | plain | 74 | 62–93 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 820 | 813–7415 | 11.14x | 461 | 461.00x | 459 | yes |
| library-load | 1 | compose | 721 | 714–802 | 9.80x | 66 | 66.00x | 57 | yes |
| library-load | 1 | fusion | 2686 | 2122–7575 | 36.50x | 269 | 269.00x | 268 | yes |
| library-load | 1 | fusion-charm | 2654 | 2145–9526 | 36.06x | 315 | 315.00x | 313 | yes |
| library-load | 1 | react | 6227 | 5457–38240 | 84.60x | 1812 | 1812.00x | 1811 | yes |
| library-load | 1 | react-reflex | 6330 | 6060–40292 | 86.01x | 1959 | 1959.00x | 1958 | yes |
| library-load | 1 | react-upstream | 6127 | 5217–44991 | 83.25x | 1982 | 1982.00x | 1981 | yes |
| library-load | 1 | roact | 596 | 547–917 | 8.10x | 144 | 144.00x | 141 | yes |
| library-load | 1 | seam | 2238 | 2110–7880 | 30.40x | 233 | 233.00x | 230 | yes |
| library-load | 1 | signals | 320 | 277–1254 | 4.35x | 49 | 49.00x | 48 | yes |
| library-load | 1 | vide | 451 | 434–3163 | 6.13x | 144 | 144.00x | 144 | yes |
| rows-append-1000 | 1 | plain | 188969 | 168075–189540 | 1.00x | 6548 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 242750 | 232005–258584 | 1.28x | 38522 | 5.88x | 1 | yes |
| rows-append-1000 | 1 | compose | 196923 | 188048–224060 | 1.04x | 9538 | 1.46x | 3 | yes |
| rows-append-1000 | 1 | fusion | 345085 | 334394–381171 | 1.83x | 20857 | 3.19x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 354916 | 321045–398996 | 1.88x | 28721 | 4.39x | 1 | yes |
| rows-append-1000 | 1 | react | 256854 | 248869–291681 | 1.36x | 23281 | 3.56x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 297512 | 262914–301992 | 1.57x | 25046 | 3.82x | 108 | yes |
| rows-append-1000 | 1 | react-upstream | 295050 | 249333–345488 | 1.56x | 23170 | 3.54x | 0 | yes |
| rows-append-1000 | 1 | roact | 234869 | 212700–256961 | 1.24x | 33371 | 5.10x | 0 | yes |
| rows-append-1000 | 1 | seam | 238372 | 229407–272468 | 1.26x | 46922 | 7.17x | 4 | yes |
| rows-append-1000 | 1 | signals | 198271 | 181990–237471 | 1.05x | 17806 | 2.72x | 0 | yes |
| rows-append-1000 | 1 | vide | 178268 | 173563–199567 | 0.94x | 10447 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 22300 | 21401–23140 | 1.00x | 1236 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 40700 | 39301–44800 | 1.83x | 4041 | 3.27x | 0 | yes |
| rows-clear | 1 | compose | 27908 | 27003–30200 | 1.25x | 1830 | 1.48x | 11 | yes |
| rows-clear | 1 | fusion | 56042 | 55271–59944 | 2.51x | 3505 | 2.84x | 0 | yes |
| rows-clear | 1 | fusion-charm | 57004 | 52851–63100 | 2.56x | 7417 | 6.00x | 1 | yes |
| rows-clear | 1 | react | 29067 | 27532–30200 | 1.30x | 4504 | 3.64x | 0 | yes |
| rows-clear | 1 | react-reflex | 33507 | 30213–41534 | 1.50x | 6522 | 5.28x | 36 | yes |
| rows-clear | 1 | react-upstream | 29400 | 28000–32825 | 1.32x | 4496 | 3.64x | 0 | yes |
| rows-clear | 1 | roact | 31305 | 29485–34503 | 1.40x | 4222 | 3.42x | 9 | yes |
| rows-clear | 1 | seam | 36129 | 27105–43722 | 1.62x | 9151 | 7.40x | 0 | yes |
| rows-clear | 1 | signals | 25704 | 25038–26735 | 1.15x | 4466 | 3.61x | 0 | yes |
| rows-clear | 1 | vide | 24700 | 24002–24858 | 1.11x | 1613 | 1.31x | 8 | yes |
| rows-create-1000 | 1 | plain | 162834 | 161881–236282 | 1.00x | 3127 | 1.00x | 7 | yes |
| rows-create-1000 | 1 | blend | 235563 | 219894–245435 | 1.45x | 19744 | 6.31x | 0 | yes |
| rows-create-1000 | 1 | compose | 185032 | 174642–196152 | 1.14x | 5080 | 1.62x | 3 | yes |
| rows-create-1000 | 1 | fusion | 247541 | 229019–249803 | 1.52x | 10963 | 3.51x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 243889 | 231891–272402 | 1.50x | 14910 | 4.77x | 9 | yes |
| rows-create-1000 | 1 | react | 209436 | 201843–228874 | 1.29x | 8160 | 2.61x | 8 | yes |
| rows-create-1000 | 1 | react-reflex | 235607 | 225164–457525 | 1.45x | 9082 | 2.90x | 44 | yes |
| rows-create-1000 | 1 | react-upstream | 210733 | 197283–236649 | 1.29x | 8080 | 2.58x | 0 | yes |
| rows-create-1000 | 1 | roact | 209921 | 198123–244779 | 1.29x | 16898 | 5.40x | 0 | yes |
| rows-create-1000 | 1 | seam | 235793 | 216894–262281 | 1.45x | 23670 | 7.57x | 0 | yes |
| rows-create-1000 | 1 | signals | 179136 | 168409–210324 | 1.10x | 9050 | 2.89x | 9 | yes |
| rows-create-1000 | 1 | vide | 182291 | 179377–208941 | 1.12x | 4956 | 1.58x | 0 | yes |
| rows-create-10000 | 1 | plain | 1807298 | 1804420–1832776 | 1.00x | 29820 | 1.00x | 4 | yes |
| rows-create-10000 | 1 | blend | 2553312 | 2398121–2563450 | 1.41x | 189271 | 6.35x | 4 | yes |
| rows-create-10000 | 1 | compose | 2145719 | 2072400–2151123 | 1.19x | 48320 | 1.62x | 10 | yes |
| rows-create-10000 | 1 | fusion | 5511320 | 5400327–5963938 | 3.05x | 105679 | 3.54x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 5928700 | 5773522–5976326 | 3.28x | 144964 | 4.86x | 8 | yes |
| rows-create-10000 | 1 | react | 4255615 | 4242704–4370638 | 2.35x | 78876 | 2.65x | 861 | yes |
| rows-create-10000 | 1 | react-reflex | 4243178 | 4066440–4635223 | 2.35x | 86388 | 2.90x | 714 | yes |
| rows-create-10000 | 1 | react-upstream | 4150884 | 3955529–4162776 | 2.30x | 77258 | 2.59x | 0 | yes |
| rows-create-10000 | 1 | roact | 2265989 | 2210988–2417209 | 1.25x | 166202 | 5.57x | 8 | yes |
| rows-create-10000 | 1 | seam | 2599639 | 2406709–2745084 | 1.44x | 236812 | 7.94x | 4 | yes |
| rows-create-10000 | 1 | signals | 2052440 | 1966599–2213236 | 1.14x | 89734 | 3.01x | 4 | yes |
| rows-create-10000 | 1 | vide | 1937396 | 1925592–2132854 | 1.07x | 48480 | 1.63x | 9 | yes |
| rows-remove-one | 1 | plain | 644 | 300–800 | 1.00x | 3205 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1300 | 911–1787 | 2.02x | 18749 | 5.85x | 0 | yes |
| rows-remove-one | 1 | compose | 700 | 500–1300 | 1.09x | 4658 | 1.45x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 34237 | 33096–42109 | 53.12x | 11401 | 3.56x | 8 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 32091 | 31046–33402 | 49.79x | 15242 | 4.76x | 1 | yes |
| rows-remove-one | 1 | react | 22226 | 15427–40368 | 34.49x | 15709 | 4.90x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 29243 | 26355–37714 | 45.37x | 16647 | 5.19x | 36 | yes |
| rows-remove-one | 1 | react-upstream | 26912 | 15434–32774 | 41.76x | 15701 | 4.90x | 0 | yes |
| rows-remove-one | 1 | roact | 16554 | 14524–18901 | 25.69x | 16990 | 5.30x | 0 | yes |
| rows-remove-one | 1 | seam | 4420 | 4300–5000 | 6.86x | 23677 | 7.39x | 0 | yes |
| rows-remove-one | 1 | signals | 1556 | 1255–1650 | 2.41x | 9078 | 2.83x | 0 | yes |
| rows-remove-one | 1 | vide | 900 | 600–1043 | 1.40x | 5017 | 1.57x | 1 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 2687 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 800 | 500–1000 | 8.00x | 18291 | 6.81x | 8 | yes |
| rows-swap | 1 | compose | 100 | 100–150 | 1.00x | 4156 | 1.55x | 3 | yes |
| rows-swap | 1 | fusion | 33557 | 31660–36050 | 335.57x | 9543 | 3.55x | 1 | yes |
| rows-swap | 1 | fusion-charm | 32710 | 30059–35498 | 327.10x | 13927 | 5.18x | 0 | yes |
| rows-swap | 1 | react | 35909 | 29801–45344 | 359.09x | 15102 | 5.62x | 0 | yes |
| rows-swap | 1 | react-reflex | 40803 | 37404–57313 | 408.03x | 16240 | 6.04x | 4 | yes |
| rows-swap | 1 | react-upstream | 40200 | 29427–82947 | 402.00x | 15454 | 5.75x | 0 | yes |
| rows-swap | 1 | roact | 16007 | 14550–17400 | 160.07x | 16762 | 6.24x | 1 | yes |
| rows-swap | 1 | seam | 4200 | 3903–4500 | 42.00x | 23211 | 8.64x | 1 | yes |
| rows-swap | 1 | signals | 500 | 200–700 | 5.00x | 8626 | 3.21x | 9 | yes |
| rows-swap | 1 | vide | 100 | 100–100 | 1.00x | 4508 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 4702 | 4250–5300 | 1.00x | 3183 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 4435 | 4110–4500 | 0.94x | 19251 | 6.05x | 1 | yes |
| rows-update-every-10th | 1 | compose | 4159 | 4056–4350 | 0.88x | 4702 | 1.48x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 4200 | 3710–4900 | 0.89x | 10559 | 3.32x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4800 | 4332–8100 | 1.02x | 14464 | 4.54x | 9 | yes |
| rows-update-every-10th | 1 | react | 4201 | 4100–4452 | 0.89x | 7920 | 2.49x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 7600 | 5728–27403 | 1.62x | 8833 | 2.78x | 52 | yes |
| rows-update-every-10th | 1 | react-upstream | 4006 | 3961–5700 | 0.85x | 7888 | 2.48x | 0 | yes |
| rows-update-every-10th | 1 | roact | 4400 | 4007–4700 | 0.94x | 16676 | 5.24x | 1 | yes |
| rows-update-every-10th | 1 | seam | 6000 | 4800–6224 | 1.28x | 24205 | 7.60x | 0 | yes |
| rows-update-every-10th | 1 | signals | 4070 | 3966–4354 | 0.87x | 9330 | 2.93x | 0 | yes |
| rows-update-every-10th | 1 | vide | 4400 | 4000–4708 | 0.94x | 5116 | 1.61x | 1 | yes |

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
| blend | 29 | 2.43x | 10.68x | 2.38x | 10.33x |
| compose | 30 | 1.87x | 3.56x | 1.78x | 3.50x |
| fusion | 30 | 5.77x | 5.96x | 5.28x | 5.95x |
| fusion-charm | 30 | 5.40x | 8.26x | 4.90x | 8.43x |
| react | 29 | 4.35x | 5.86x | 4.20x | 6.23x |
| react-reflex | 29 | 4.91x | 9.15x | 4.75x | 9.79x |
| react-upstream | 29 | 4.30x | 6.58x | 4.17x | 6.99x |
| roact | 29 | 2.89x | 6.41x | 2.86x | 7.29x |
| seam | 30 | 3.85x | 12.82x | 3.53x | 12.72x |
| signals | 29 | 1.90x | 2.76x | 1.83x | 2.75x |
| vide | 30 | 1.91x | 3.24x | 1.81x | 3.25x |
