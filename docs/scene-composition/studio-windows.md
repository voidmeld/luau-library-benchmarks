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
| Harness revision | `df1056e` |
| Date | 2026-11-11 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 1100 | 600–3701 | 1.00x | 58 | 1.00x | 9 | yes |
| update-leaf | 20 | blend | 2133 | 1934–2233 | 1.94x | 773 | 13.33x | 9 | yes |
| update-leaf | 20 | compose | 2067 | 1800–2213 | 1.88x | 101 | 1.74x | 9 | yes |
| update-leaf | 20 | fusion | 2367 | 2267–2567 | 2.15x | 59 | 1.02x | 0 | yes |
| update-leaf | 20 | fusion-charm | 2500 | 2250–2650 | 2.27x | 54 | 0.93x | 0 | yes |
| update-leaf | 20 | react | 2100 | 2033–2167 | 1.91x | 347 | 5.98x | 0 | yes |
| update-leaf | 20 | react-reflex | 2100 | 2000–2500 | 1.91x | 293 | 5.05x | 1 | yes |
| update-leaf | 20 | react-upstream | 2035 | 1933–2200 | 1.85x | 291 | 5.02x | 0 | yes |
| update-leaf | 20 | roact | 2096 | 1767–2267 | 1.91x | 959 | 16.53x | 0 | yes |
| update-leaf | 20 | seam | 2100 | 1700–2250 | 1.91x | 41 | 0.71x | 1 | yes |
| update-leaf | 20 | signals | 2250 | 2000–2400 | 2.05x | 51 | 0.88x | 0 | yes |
| update-leaf | 20 | vide | 2541 | 2300–2854 | 2.31x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4401 | 4322–4700 | 1.00x | 21 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 10886 | 10211–12289 | 2.47x | 917 | 43.67x | 0 | yes |
| update-batched | 20 | compose | 7843 | 7400–8355 | 1.78x | 408 | 19.43x | 10 | yes |
| update-batched | 20 | fusion | 18700 | 17331–18900 | 4.25x | 492 | 23.43x | 0 | yes |
| update-batched | 20 | fusion-charm | 29700 | 29102–30400 | 6.75x | 1093 | 52.05x | 0 | yes |
| update-batched | 20 | react | 7790 | 7514–8094 | 1.77x | 526 | 25.05x | 0 | yes |
| update-batched | 20 | react-reflex | 46742 | 44447–48039 | 10.62x | 783 | 37.29x | 16 | yes |
| update-batched | 20 | react-upstream | 7800 | 6800–8300 | 1.77x | 477 | 22.71x | 0 | yes |
| update-batched | 20 | roact | 8100 | 7700–8500 | 1.84x | 1169 | 55.67x | 0 | yes |
| update-batched | 20 | seam | 12066 | 10422–12413 | 2.74x | 1840 | 87.62x | 0 | yes |
| update-batched | 20 | signals | 9149 | 8766–10081 | 2.08x | 597 | 28.43x | 0 | yes |
| update-batched | 20 | vide | 8200 | 7700–9300 | 1.86x | 340 | 16.19x | 1 | yes |
| update-repeated | 10 | plain | 39 | 37–43 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3302 | 2900–3650 | 84.19x | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 488 | 423–527 | 12.43x | 0 | 0.50x | 2 | yes |
| update-repeated | 10 | fusion | 30536 | 29614–32097 | 778.55x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1161 | 960–1227 | 29.61x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 5036 | 4500–5123 | 128.40x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 815 | 771–1014 | 20.79x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 5358 | 4800–5621 | 136.61x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6300 | 5800–6615 | 160.63x | 14 | 7.00x | 0 | yes |
| update-repeated | 10 | seam | 1275 | 1150–1425 | 32.51x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 833 | 767–861 | 21.25x | 4 | 2.00x | 1 | yes |
| update-repeated | 10 | vide | 567 | 435–589 | 14.45x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 22619 | 21926–32269 | 1.00x | 2 | 1.00x | 8 | yes |
| branch-swap | 20 | blend | 28990 | 26970–34810 | 1.28x | 35 | 17.50x | 1 | yes |
| branch-swap | 20 | compose | 27403 | 25300–30897 | 1.21x | 0 | 0.50x | 1 | yes |
| branch-swap | 20 | fusion | 30223 | 26776–40857 | 1.34x | 36 | 18.00x | 0 | yes |
| branch-swap | 20 | fusion-charm | 30415 | 27101–32127 | 1.34x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 34276 | 26917–35886 | 1.52x | 11 | 5.50x | 1 | yes |
| branch-swap | 20 | react-reflex | 28720 | 26500–33100 | 1.27x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 28004 | 27200–30206 | 1.24x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | roact | 26002 | 25231–27781 | 1.15x | 20 | 10.00x | 9 | yes |
| branch-swap | 20 | seam | 24256 | 23631–24412 | 1.07x | 12 | 6.00x | 2 | yes |
| branch-swap | 20 | signals | 25500 | 24503–28024 | 1.13x | 14 | 7.00x | 8 | yes |
| branch-swap | 20 | vide | 28103 | 27004–33216 | 1.24x | 5 | 2.50x | 0 | yes |
| keyed-prepend | 10 | plain | 1767 | 1733–1811 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4292 | 4008–4406 | 2.43x | 1491 | 23.30x | 0 | yes |
| keyed-prepend | 10 | compose | 3850 | 3749–3950 | 2.18x | 579 | 9.05x | 10 | yes |
| keyed-prepend | 10 | fusion (workaround) | 17639 | 16575–18852 | 9.98x | 1520 | 23.75x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 16812 | 16104–17704 | 9.52x | 1513 | 23.64x | 0 | yes |
| keyed-prepend | 10 | react | 10249 | 9801–10501 | 5.80x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 11500 | 10108–12277 | 6.51x | 794 | 12.41x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 10500 | 10401–11628 | 5.94x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | roact | 5700 | 5600–6200 | 3.23x | 369 | 5.77x | 0 | yes |
| keyed-prepend | 10 | seam | 9504 | 8800–10600 | 5.38x | 2464 | 38.50x | 0 | yes |
| keyed-prepend | 10 | signals | 2572 | 2250–2808 | 1.46x | 69 | 1.08x | 8 | yes |
| keyed-prepend | 10 | vide | 4541 | 4453–4640 | 2.57x | 646 | 10.09x | 0 | yes |
| keyed-insert | 10 | plain | 1220 | 1180–1240 | 1.00x | 74 | 1.00x | 10 | yes |
| keyed-insert | 10 | blend | 3500 | 3440–3900 | 2.87x | 1498 | 20.24x | 8 | yes |
| keyed-insert | 10 | compose | 2700 | 2400–2770 | 2.21x | 571 | 7.72x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 14400 | 13688–15630 | 11.80x | 1527 | 20.64x | 0 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 13968 | 12900–14100 | 11.45x | 1529 | 20.66x | 1 | yes |
| keyed-insert | 10 | react | 9300 | 8374–9668 | 7.62x | 811 | 10.96x | 0 | yes |
| keyed-insert | 10 | react-reflex | 8839 | 8672–9404 | 7.25x | 867 | 11.72x | 0 | yes |
| keyed-insert | 10 | react-upstream | 8932 | 8142–10300 | 7.32x | 811 | 10.96x | 0 | yes |
| keyed-insert | 10 | roact | 4700 | 4400–4938 | 3.85x | 369 | 4.99x | 9 | yes |
| keyed-insert | 10 | seam | 9009 | 8600–9300 | 7.38x | 2456 | 33.19x | 1 | yes |
| keyed-insert | 10 | signals | 1800 | 1633–1830 | 1.48x | 70 | 0.95x | 1 | yes |
| keyed-insert | 10 | vide | 3148 | 3050–3206 | 2.58x | 646 | 8.73x | 0 | yes |
| keyed-shuffle | 10 | plain | 1167 | 1100–1209 | 1.00x | 61 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 2479 | 2350–2640 | 2.12x | 1439 | 23.59x | 0 | yes |
| keyed-shuffle | 10 | compose | 2500 | 2406–2550 | 2.14x | 570 | 9.34x | 10 | yes |
| keyed-shuffle | 10 | fusion | 15737 | 14743–18581 | 13.49x | 1398 | 22.92x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 14368 | 11916–14900 | 12.32x | 1400 | 22.95x | 0 | yes |
| keyed-shuffle | 10 | react | 14526 | 13600–16000 | 12.45x | 786 | 12.89x | 1 | yes |
| keyed-shuffle | 10 | react-reflex | 15767 | 14488–16415 | 13.51x | 772 | 12.66x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 15461 | 14400–18743 | 13.25x | 779 | 12.77x | 0 | yes |
| keyed-shuffle | 10 | roact | 4700 | 4200–5102 | 4.03x | 368 | 6.03x | 1 | yes |
| keyed-shuffle | 10 | seam | 7300 | 6903–8300 | 6.26x | 2447 | 40.11x | 1 | yes |
| keyed-shuffle | 10 | signals | 1533 | 1400–1600 | 1.31x | 60 | 0.98x | 0 | yes |
| keyed-shuffle | 10 | vide | 3000 | 2650–3100 | 2.57x | 630 | 10.33x | 1 | yes |
| events | 1 | plain | 2900 | 2600–3590 | 1.00x | 2 | 1.00x | 0 | yes |
| events | 1 | blend | 3200 | 2600–3400 | 1.10x | 2 | 1.00x | 1 | yes |
| events | 1 | compose | 2700 | 2300–2901 | 0.93x | 3 | 1.50x | 2 | yes |
| events | 1 | fusion | 2700 | 2400–4200 | 0.93x | 9 | 4.50x | 0 | yes |
| events | 1 | fusion-charm | 3100 | 2200–3600 | 1.07x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 3171 | 2921–3964 | 1.09x | 1 | 0.50x | 1 | yes |
| events | 1 | react-reflex | 3693 | 2300–4000 | 1.27x | 8 | 4.00x | 0 | yes |
| events | 1 | react-upstream | 2200 | 1700–2601 | 0.76x | 0 | 0.50x | 1 | yes |
| events | 1 | roact | 2100 | 2000–2700 | 0.72x | 2 | 1.00x | 1 | yes |
| events | 1 | seam | 1900 | 1400–2400 | 0.66x | 2 | 1.00x | 0 | yes |
| events | 1 | signals | 1600 | 1400–1900 | 0.55x | 2 | 1.00x | 1 | yes |
| events | 1 | vide | 3000 | 2959–3809 | 1.03x | 2 | 1.00x | 1 | yes |
| animate-many | 1 | plain | 2650 | 2552–2750 | 1.00x | 66 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 9800 | 9200–10301 | 3.70x | 1771 | 26.83x | 1 | yes |
| animate-many | 1 | compose | 6954 | 6500–7100 | 2.62x | 655 | 9.92x | 12 | yes |
| animate-many | 1 | fusion | 75251 | 74960–79610 | 28.40x | 1128 | 17.09x | 0 | yes |
| animate-many | 1 | fusion-charm | 76154 | 75221–76935 | 28.74x | 1130 | 17.12x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 19762 | 18772–22884 | 7.46x | 2898 | 43.91x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 9500 | 8307–10000 | 3.58x | 392 | 5.94x | 0 | yes |
| status-panel | 10 | plain | 900 | 867–1217 | 1.00x | 0 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 2328 | 2233–2664 | 2.59x | 70 | 70.00x | 0 | yes |
| status-panel | 10 | compose | 2267 | 1967–2594 | 2.52x | 33 | 33.00x | 2 | yes |
| status-panel | 10 | fusion | 2650 | 2500–2750 | 2.94x | 64 | 64.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 2952 | 2800–3050 | 3.28x | 70 | 70.00x | 0 | yes |
| status-panel | 10 | react | 3150 | 2686–3650 | 3.50x | 43 | 43.00x | 0 | yes |
| status-panel | 10 | react-reflex | 3150 | 2701–3250 | 3.50x | 37 | 37.00x | 0 | yes |
| status-panel | 10 | react-upstream | 3050 | 2866–3200 | 3.39x | 43 | 43.00x | 0 | yes |
| status-panel | 10 | roact | 2221 | 2160–2550 | 2.47x | 33 | 33.00x | 0 | yes |
| status-panel | 10 | seam | 2850 | 2350–2950 | 3.17x | 141 | 141.00x | 1 | yes |
| status-panel | 10 | signals | 1910 | 1800–2033 | 2.12x | 15 | 15.00x | 0 | yes |
| status-panel | 10 | vide | 2152 | 2000–2500 | 2.39x | 32 | 32.00x | 1 | yes |
| scene-3d | 10 | plain | 2233 | 2167–2355 | 1.00x | 10 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 5011 | 4569–5362 | 2.24x | 548 | 54.80x | 0 | yes |
| scene-3d | 10 | compose | 3700 | 3502–3750 | 1.66x | 187 | 18.70x | 2 | yes |
| scene-3d | 10 | fusion | 22300 | 21100–23900 | 9.99x | 512 | 51.20x | 0 | yes |
| scene-3d | 10 | fusion-charm | 21302 | 20774–21865 | 9.54x | 524 | 52.40x | 1 | yes |
| scene-3d | 10 | react | 3750 | 3332–4209 | 1.68x | 223 | 22.30x | 0 | yes |
| scene-3d | 10 | react-reflex | 3750 | 3150–3800 | 1.68x | 224 | 22.40x | 0 | yes |
| scene-3d | 10 | react-upstream | 3678 | 3605–3750 | 1.65x | 223 | 22.30x | 8 | yes |
| scene-3d | 10 | roact | 3650 | 3300–3800 | 1.63x | 582 | 58.20x | 0 | yes |
| scene-3d | 10 | seam | 7800 | 7304–9101 | 3.49x | 1763 | 176.30x | 0 | yes |
| scene-3d | 10 | signals | 5555 | 5200–6123 | 2.49x | 682 | 68.20x | 1 | yes |
| scene-3d | 10 | vide | 3895 | 3558–3962 | 1.74x | 210 | 21.00x | 0 | yes |
| derived-diamond | 3 | plain | 23 | 21–26 | 1.00x | 5 | 1.00x | 1 | yes |
| derived-diamond | 3 | blend | 156 | 119–169 | 6.85x | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 153 | 129–171 | 6.70x | 10 | 2.00x | 2 | yes |
| derived-diamond | 3 | fusion | 141 | 135–159 | 6.19x | 8 | 1.60x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 153 | 135–171 | 6.70x | 11 | 2.20x | 0 | yes |
| derived-diamond | 3 | react | 284 | 228–367 | 12.43x | 6 | 1.20x | 4 | yes |
| derived-diamond | 3 | react-reflex | 300 | 267–339 | 13.15x | 18 | 3.60x | 7 | yes |
| derived-diamond | 3 | react-upstream | 300 | 261–363 | 13.15x | 7 | 1.40x | 3 | yes |
| derived-diamond | 3 | roact | 135 | 124–171 | 5.93x | 10 | 2.00x | 0 | yes |
| derived-diamond | 3 | seam | 220 | 190–254 | 9.64x | 22 | 4.40x | 0 | yes |
| derived-diamond | 3 | signals | 129 | 124–129 | 5.67x | 10 | 2.00x | 0 | yes |
| derived-diamond | 3 | vide | 135 | 112–146 | 5.93x | 6 | 1.20x | 1 | yes |
| derived-chain-100 | 3 | plain | 32 | 32–37 | 1.00x | 57 | 1.00x | 1 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 212 | 169–238 | 6.62x | 139 | 2.44x | 2 | yes |
| derived-chain-100 | 3 | fusion | 540 | 530–590 | 16.82x | 135 | 2.37x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 562 | 520–620 | 17.51x | 129 | 2.26x | 0 | yes |
| derived-chain-100 | 3 | react | 390 | 330–420 | 12.15x | 69 | 1.21x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 411 | 333–422 | 12.81x | 72 | 1.26x | 6 | yes |
| derived-chain-100 | 3 | react-upstream | 400 | 350–432 | 12.46x | 69 | 1.21x | 11 | yes |
| derived-chain-100 | 3 | roact | 171 | 147–206 | 5.31x | 11 | 0.19x | 3 | yes |
| derived-chain-100 | 3 | seam | 685 | 634–806 | 21.34x | 271 | 4.75x | 0 | yes |
| derived-chain-100 | 3 | signals | 190 | 160–251 | 5.92x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 171 | 147–201 | 5.31x | 85 | 1.49x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 85 | 82–89 | 1.00x | 497 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 238 | 219–262 | 2.78x | 1535 | 3.09x | 1 | yes |
| derived-fan-in-1000 | 3 | compose | 320 | 270–393 | 3.75x | 687 | 1.38x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 1120 | 1020–1220 | 13.12x | 881 | 1.77x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1020 | 996–1128 | 11.94x | 2813 | 5.66x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1850 | 1700–2200 | 21.66x | 662 | 1.33x | 51 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8204 | 7279–9600 | 96.06x | 5634 | 11.34x | 94 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1517 | 1467–1830 | 17.76x | 670 | 1.35x | 51 | yes |
| derived-fan-in-1000 | 3 | roact | 430 | 400–470 | 5.04x | 112 | 0.23x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 1700 | 1434–1833 | 19.91x | 2931 | 5.90x | 8 | yes |
| derived-fan-in-1000 | 3 | signals | 505 | 500–675 | 5.92x | 1204 | 2.42x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 363 | 340–379 | 4.25x | 529 | 1.06x | 1 | yes |
| filter-as-you-type | 1 | plain | 6400 | 6257–7000 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 13951 | 13207–15747 | 2.18x | 2695 | 77.00x | 0 | yes |
| filter-as-you-type | 1 | compose | 9303 | 9046–9412 | 1.45x | 841 | 24.03x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 23601 | 20542–27376 | 3.69x | 2449 | 69.97x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 22501 | 19855–23944 | 3.52x | 2451 | 70.03x | 1 | yes |
| filter-as-you-type | 1 | react | 14304 | 13500–14700 | 2.23x | 76 | 2.17x | 12 | yes |
| filter-as-you-type | 1 | react-reflex | 14701 | 13874–15130 | 2.30x | 839 | 23.97x | 23 | yes |
| filter-as-you-type | 1 | react-upstream | 13680 | 13379–14601 | 2.14x | 76 | 2.17x | 4 | yes |
| filter-as-you-type | 1 | roact | 10437 | 9634–11872 | 1.63x | 503 | 14.37x | 3 | yes |
| filter-as-you-type | 1 | seam | 23183 | 18121–28713 | 3.62x | 4029 | 115.11x | 0 | yes |
| filter-as-you-type | 1 | signals | 8900 | 7812–10510 | 1.39x | 37 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | vide | 9600 | 9240–10600 | 1.50x | 959 | 27.40x | 0 | yes |
| theme-propagation | 3 | plain | 108344 | 106597–117388 | 1.00x | 205 | 1.00x | 7 | yes |
| theme-propagation | 3 | blend | 108711 | 106898–114474 | 1.00x | 2069 | 10.09x | 0 | yes |
| theme-propagation | 3 | compose | 116373 | 111249–121360 | 1.07x | 580 | 2.83x | 1 | yes |
| theme-propagation | 3 | fusion | 118084 | 109005–141374 | 1.09x | 867 | 4.23x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 114126 | 109077–119031 | 1.05x | 876 | 4.27x | 0 | yes |
| theme-propagation | 3 | react | 119124 | 112900–148123 | 1.10x | 2027 | 9.89x | 0 | yes |
| theme-propagation | 3 | react-reflex | 107215 | 103654–115369 | 0.99x | 2029 | 9.90x | 0 | yes |
| theme-propagation | 3 | react-upstream | 123475 | 113348–208961 | 1.14x | 2020 | 9.85x | 0 | yes |
| theme-propagation | 3 | roact | 112613 | 108923–127728 | 1.04x | 3271 | 15.96x | 1 | yes |
| theme-propagation | 3 | seam | 109070 | 105225–112016 | 1.01x | 3470 | 16.93x | 1 | yes |
| theme-propagation | 3 | signals | 117567 | 109308–119944 | 1.09x | 903 | 4.40x | 0 | yes |
| theme-propagation | 3 | vide | 113341 | 111342–120321 | 1.05x | 597 | 2.91x | 0 | yes |
| hud-per-frame | 1 | plain | 3400 | 3000–4400 | 1.00x | 30 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 6702 | 5424–6994 | 1.97x | 79 | 2.63x | 9 | yes |
| hud-per-frame | 1 | compose | 6100 | 5500–6500 | 1.79x | 21 | 0.70x | 1 | yes |
| hud-per-frame | 1 | fusion | 10200 | 9206–10909 | 3.00x | 54 | 1.80x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 13500 | 12700–14000 | 3.97x | 99 | 3.30x | 1 | yes |
| hud-per-frame | 1 | react | 6000 | 4704–6500 | 1.76x | 33 | 1.10x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 8002 | 7421–9041 | 2.35x | 53 | 1.77x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 5100 | 4600–5600 | 1.50x | 34 | 1.13x | 0 | yes |
| hud-per-frame | 1 | roact | 5600 | 4300–6200 | 1.65x | 90 | 3.00x | 0 | yes |
| hud-per-frame | 1 | seam | 9700 | 9300–10200 | 2.85x | 169 | 5.63x | 0 | yes |
| hud-per-frame | 1 | signals | 6500 | 6000–7800 | 1.91x | 66 | 2.20x | 1 | yes |
| hud-per-frame | 1 | vide | 5800 | 5100–6800 | 1.71x | 25 | 0.83x | 0 | yes |
| teardown-under-load | 1 | plain | 41900 | 39754–45500 | 1.00x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 56417 | 56081–60233 | 1.35x | 14 | 2.80x | 0 | yes |
| teardown-under-load | 1 | compose | 48953 | 44156–52918 | 1.17x | 7 | 1.40x | 2 | yes |
| teardown-under-load | 1 | fusion | 64796 | 61852–74809 | 1.55x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 72313 | 60005–80716 | 1.73x | 15 | 3.00x | 9 | yes |
| teardown-under-load | 1 | react | 58202 | 53966–59852 | 1.39x | 1077 | 215.40x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 57788 | 54965–61317 | 1.38x | 1078 | 215.60x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 60424 | 56553–61629 | 1.44x | 1070 | 214.00x | 0 | yes |
| teardown-under-load | 1 | roact | 59110 | 52209–63722 | 1.41x | 71 | 14.20x | 1 | yes |
| teardown-under-load | 1 | seam | 60892 | 52097–68315 | 1.45x | 8 | 1.60x | 6 | yes |
| teardown-under-load | 1 | signals | 47116 | 44945–48694 | 1.12x | 13 | 2.60x | 1 | yes |
| teardown-under-load | 1 | vide | 48211 | 46328–50159 | 1.15x | 4 | 0.80x | 0 | yes |
| open-close-retention | 1 | plain | 67166 | 64289–68193 | 1.00x | 31 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 108867 | 107003–119166 | 1.62x | 6 | 0.19x | 1 | yes |
| open-close-retention | 1 | compose | 82336 | 79938–85972 | 1.23x | 7 | 0.23x | 0 | yes |
| open-close-retention | 1 | fusion | 161659 | 124674–187741 | 2.41x | 5 | 0.16x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 128756 | 123303–130195 | 1.92x | 6 | 0.19x | 1 | yes |
| open-close-retention | 1 | react | 105230 | 104056–106158 | 1.57x | 283 | 9.13x | 0 | yes |
| open-close-retention | 1 | react-reflex | 108425 | 107405–112190 | 1.61x | 292 | 9.42x | 0 | yes |
| open-close-retention | 1 | react-upstream | 103303 | 102186–106564 | 1.54x | 283 | 9.13x | 0 | yes |
| open-close-retention | 1 | roact | 102175 | 97638–104766 | 1.52x | 23 | 0.74x | 0 | yes |
| open-close-retention | 1 | seam | 117048 | 113982–129115 | 1.74x | 9 | 0.29x | 1 | yes |
| open-close-retention | 1 | signals | 80544 | 75944–82104 | 1.20x | 13 | 0.42x | 0 | yes |
| open-close-retention | 1 | vide | 85818 | 85313–88357 | 1.28x | 12 | 0.39x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7403 | 7100–7900 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 17204 | 16910–19200 | 2.32x | 788 | 39.40x | 0 | yes |
| tree-expand-collapse | 1 | compose | 11732 | 10800–13100 | 1.58x | 72 | 3.60x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 23413 | 19316–26846 | 3.16x | 166 | 8.30x | 2 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 19450 | 19031–23564 | 2.63x | 167 | 8.35x | 1 | yes |
| tree-expand-collapse | 1 | react | 15401 | 13500–18403 | 2.08x | 70 | 3.50x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 15300 | 14300–15975 | 2.07x | 672 | 33.60x | 15 | yes |
| tree-expand-collapse | 1 | react-upstream | 14204 | 13654–15200 | 1.92x | 70 | 3.50x | 20 | yes |
| tree-expand-collapse | 1 | roact | 10211 | 9300–10600 | 1.38x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 23939 | 23601–25530 | 3.23x | 141 | 7.05x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8357 | 7541–9700 | 1.13x | 21 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11200 | 10904–11522 | 1.51x | 71 | 3.55x | 1 | yes |
| form-validation | 1 | plain | 3204 | 3049–3372 | 1.00x | 45 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 7750 | 7600–8574 | 2.42x | 328 | 7.29x | 1 | yes |
| form-validation | 1 | compose | 8011 | 7434–9000 | 2.50x | 106 | 2.36x | 2 | yes |
| form-validation | 1 | fusion | 9600 | 8701–11200 | 3.00x | 118 | 2.62x | 0 | yes |
| form-validation | 1 | fusion-charm | 9200 | 8309–9200 | 2.87x | 155 | 3.44x | 0 | yes |
| form-validation | 1 | react | 8526 | 8080–9207 | 2.66x | 74 | 1.64x | 0 | yes |
| form-validation | 1 | react-reflex | 9826 | 8000–9900 | 3.07x | 83 | 1.84x | 9 | yes |
| form-validation | 1 | react-upstream | 8702 | 8600–9400 | 2.72x | 66 | 1.47x | 0 | yes |
| form-validation | 1 | roact | 8400 | 8227–8900 | 2.62x | 216 | 4.80x | 0 | yes |
| form-validation | 1 | seam | 8457 | 7600–9800 | 2.64x | 353 | 7.84x | 0 | yes |
| form-validation | 1 | signals | 7990 | 7700–8316 | 2.49x | 155 | 3.44x | 0 | yes |
| form-validation | 1 | vide | 8300 | 7728–8700 | 2.59x | 70 | 1.56x | 0 | yes |
| table-sort-filter | 1 | plain | 15459 | 14766–17349 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 31507 | 29860–35588 | 2.04x | 5373 | 80.19x | 1 | yes |
| table-sort-filter | 1 | compose | 21218 | 20500–22800 | 1.37x | 1632 | 24.36x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 50729 | 47608–53916 | 3.28x | 4695 | 70.07x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 48300 | 38792–53706 | 3.12x | 4690 | 70.00x | 1 | yes |
| table-sort-filter | 1 | react | 54107 | 52120–62069 | 3.50x | 2108 | 31.46x | 11 | yes |
| table-sort-filter | 1 | react-reflex | 51940 | 49328–54513 | 3.36x | 2120 | 31.64x | 23 | yes |
| table-sort-filter | 1 | react-upstream | 52508 | 50904–55500 | 3.40x | 2108 | 31.46x | 12 | yes |
| table-sort-filter | 1 | roact | 21525 | 21200–21700 | 1.39x | 1014 | 15.13x | 3 | yes |
| table-sort-filter | 1 | seam | 54534 | 47619–62998 | 3.53x | 7688 | 114.75x | 1 | yes |
| table-sort-filter | 1 | signals | 15410 | 14900–16400 | 1.00x | 68 | 1.01x | 0 | yes |
| table-sort-filter | 1 | vide | 22400 | 21412–23803 | 1.45x | 1922 | 28.69x | 0 | yes |
| library-load | 1 | plain | 42 | 40–48 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 751 | 676–818 | 17.72x | 459 | 459.00x | 456 | yes |
| library-load | 1 | compose | 636 | 619–903 | 15.00x | 67 | 67.00x | 64 | yes |
| library-load | 1 | fusion | 1797 | 1507–2017 | 42.38x | 263 | 263.00x | 262 | yes |
| library-load | 1 | fusion-charm | 1918 | 1615–2094 | 45.24x | 309 | 309.00x | 308 | yes |
| library-load | 1 | react | 5088 | 4726–5691 | 120.00x | 1818 | 1818.00x | 1817 | yes |
| library-load | 1 | react-reflex | 5522 | 5370–6684 | 130.23x | 1973 | 1973.00x | 1972 | yes |
| library-load | 1 | react-upstream | 5524 | 4856–6103 | 130.28x | 1995 | 1995.00x | 2001 | yes |
| library-load | 1 | roact | 450 | 415–573 | 10.62x | 146 | 146.00x | 150 | yes |
| library-load | 1 | seam | 1482 | 1404–1831 | 34.96x | 242 | 242.00x | 239 | yes |
| library-load | 1 | signals | 212 | 205–219 | 4.99x | 25 | 25.00x | 24 | yes |
| library-load | 1 | vide | 376 | 345–412 | 8.86x | 138 | 138.00x | 138 | yes |
| rows-append-1000 | 1 | plain | 179848 | 164985–188340 | 1.00x | 6523 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 257992 | 233651–266310 | 1.43x | 38857 | 5.96x | 0 | yes |
| rows-append-1000 | 1 | compose | 193944 | 181061–216919 | 1.08x | 11022 | 1.69x | 3 | yes |
| rows-append-1000 | 1 | fusion | 327231 | 318158–388222 | 1.82x | 21370 | 3.28x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 329969 | 328686–363791 | 1.83x | 29235 | 4.48x | 1 | yes |
| rows-append-1000 | 1 | react | 243635 | 221346–262581 | 1.35x | 23161 | 3.55x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 282667 | 270726–299385 | 1.57x | 24863 | 3.81x | 75 | yes |
| rows-append-1000 | 1 | react-upstream | 255315 | 241443–327379 | 1.42x | 22905 | 3.51x | 0 | yes |
| rows-append-1000 | 1 | roact | 249488 | 229924–329318 | 1.39x | 33126 | 5.08x | 0 | yes |
| rows-append-1000 | 1 | seam | 274957 | 248356–353114 | 1.53x | 46670 | 7.15x | 224 | yes |
| rows-append-1000 | 1 | signals | 198775 | 177017–244740 | 1.11x | 17441 | 2.67x | 232 | yes |
| rows-append-1000 | 1 | vide | 179645 | 169227–195853 | 1.00x | 10423 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 17600 | 17106–18807 | 1.00x | 1221 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 35101 | 32881–37801 | 1.99x | 4177 | 3.42x | 1 | yes |
| rows-clear | 1 | compose | 22308 | 21525–22700 | 1.27x | 1885 | 1.54x | 10 | yes |
| rows-clear | 1 | fusion | 50949 | 47090–56398 | 2.89x | 3481 | 2.85x | 0 | yes |
| rows-clear | 1 | fusion-charm | 49951 | 47648–50601 | 2.84x | 7393 | 6.05x | 1 | yes |
| rows-clear | 1 | react | 20500 | 19890–24703 | 1.16x | 4487 | 3.67x | 0 | yes |
| rows-clear | 1 | react-reflex | 26500 | 25201–28806 | 1.51x | 6481 | 5.31x | 36 | yes |
| rows-clear | 1 | react-upstream | 21901 | 21300–26900 | 1.24x | 4479 | 3.67x | 0 | yes |
| rows-clear | 1 | roact | 25244 | 22914–28343 | 1.43x | 4206 | 3.44x | 1 | yes |
| rows-clear | 1 | seam | 29805 | 21112–39409 | 1.69x | 9286 | 7.61x | 0 | yes |
| rows-clear | 1 | signals | 19706 | 19001–21603 | 1.12x | 4450 | 3.64x | 0 | yes |
| rows-clear | 1 | vide | 19407 | 16510–21118 | 1.10x | 1605 | 1.31x | 1 | yes |
| rows-create-1000 | 1 | plain | 163318 | 159923–165907 | 1.00x | 3126 | 1.00x | 1 | yes |
| rows-create-1000 | 1 | blend | 220268 | 206383–260386 | 1.35x | 19721 | 6.31x | 0 | yes |
| rows-create-1000 | 1 | compose | 194232 | 177904–219129 | 1.19x | 5819 | 1.86x | 3 | yes |
| rows-create-1000 | 1 | fusion | 242677 | 233360–325958 | 1.49x | 10946 | 3.50x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 254862 | 245460–283899 | 1.56x | 14884 | 4.76x | 0 | yes |
| rows-create-1000 | 1 | react | 220070 | 207512–254061 | 1.35x | 8176 | 2.62x | 24 | yes |
| rows-create-1000 | 1 | react-reflex | 251077 | 228116–257416 | 1.54x | 9081 | 2.90x | 44 | yes |
| rows-create-1000 | 1 | react-upstream | 222938 | 204645–282752 | 1.37x | 8128 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 210692 | 186708–217334 | 1.29x | 16913 | 5.41x | 8 | yes |
| rows-create-1000 | 1 | seam | 240309 | 217931–269751 | 1.47x | 23869 | 7.64x | 0 | yes |
| rows-create-1000 | 1 | signals | 191353 | 170494–208462 | 1.17x | 9122 | 2.92x | 0 | yes |
| rows-create-1000 | 1 | vide | 181751 | 167307–193735 | 1.11x | 4964 | 1.59x | 8 | yes |
| rows-create-10000 | 1 | plain | 1969085 | 1934350–2429020 | 1.00x | 29836 | 1.00x | 16 | yes |
| rows-create-10000 | 1 | blend | 2756163 | 2606930–2797184 | 1.40x | 188182 | 6.31x | 4 | yes |
| rows-create-10000 | 1 | compose | 2369023 | 2244466–2399465 | 1.20x | 55666 | 1.87x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6749781 | 6413615–7052551 | 3.43x | 104653 | 3.51x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 6536714 | 6154410–6715153 | 3.32x | 144948 | 4.86x | 8 | yes |
| rows-create-10000 | 1 | react | 4335785 | 4287607–4582521 | 2.20x | 77696 | 2.60x | 884 | yes |
| rows-create-10000 | 1 | react-reflex | 4524178 | 4430764–4843438 | 2.30x | 85183 | 2.86x | 698 | yes |
| rows-create-10000 | 1 | react-upstream | 4606854 | 4497910–4676510 | 2.34x | 78086 | 2.62x | 624 | yes |
| rows-create-10000 | 1 | roact | 2489329 | 2335481–2524587 | 1.26x | 165946 | 5.56x | 4 | yes |
| rows-create-10000 | 1 | seam | 2800543 | 2797063–2896631 | 1.42x | 235764 | 7.90x | 12 | yes |
| rows-create-10000 | 1 | signals | 2196097 | 2147696–2343692 | 1.12x | 89466 | 3.00x | 20 | yes |
| rows-create-10000 | 1 | vide | 2051786 | 2024809–2334462 | 1.04x | 48508 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 800 | 750–850 | 1.00x | 2741 | 1.00x | 9 | yes |
| rows-remove-one | 1 | blend | 1400 | 1003–1400 | 1.75x | 18284 | 6.67x | 0 | yes |
| rows-remove-one | 1 | compose | 700 | 573–1000 | 0.88x | 4949 | 1.81x | 11 | yes |
| rows-remove-one | 1 | fusion (workaround) | 34424 | 32381–41925 | 43.03x | 11113 | 4.05x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 36100 | 31849–48127 | 45.12x | 15042 | 5.49x | 1 | yes |
| rows-remove-one | 1 | react | 21300 | 15105–23100 | 26.62x | 15492 | 5.65x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 30463 | 18145–54826 | 38.08x | 16430 | 5.99x | 53 | yes |
| rows-remove-one | 1 | react-upstream | 21000 | 20802–57756 | 26.25x | 15461 | 5.64x | 0 | yes |
| rows-remove-one | 1 | roact | 20081 | 14757–35224 | 25.10x | 16773 | 6.12x | 0 | yes |
| rows-remove-one | 1 | seam | 4800 | 3750–5406 | 6.00x | 23222 | 8.47x | 1 | yes |
| rows-remove-one | 1 | signals | 1553 | 1300–1756 | 1.94x | 8621 | 3.15x | 9 | yes |
| rows-remove-one | 1 | vide | 822 | 500–1100 | 1.03x | 4561 | 1.66x | 9 | yes |
| rows-swap | 1 | plain | 100 | 100–195 | 1.00x | 2687 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 547 | 400–800 | 5.44x | 18278 | 6.80x | 1 | yes |
| rows-swap | 1 | compose | 104 | 100–300 | 1.04x | 4919 | 1.83x | 10 | yes |
| rows-swap | 1 | fusion | 32910 | 32004–37715 | 327.46x | 9551 | 3.55x | 0 | yes |
| rows-swap | 1 | fusion-charm | 32407 | 31509–34109 | 322.46x | 14618 | 5.44x | 0 | yes |
| rows-swap | 1 | react | 29191 | 26824–37821 | 290.46x | 15450 | 5.75x | 0 | yes |
| rows-swap | 1 | react-reflex | 47268 | 31480–70124 | 470.33x | 16386 | 6.10x | 28 | yes |
| rows-swap | 1 | react-upstream | 40151 | 28339–44942 | 399.51x | 15121 | 5.63x | 128 | yes |
| rows-swap | 1 | roact | 17560 | 12800–19500 | 174.73x | 16308 | 6.07x | 0 | yes |
| rows-swap | 1 | seam | 4400 | 3900–5571 | 43.78x | 23211 | 8.64x | 0 | yes |
| rows-swap | 1 | signals | 650 | 500–812 | 6.47x | 8601 | 3.20x | 0 | yes |
| rows-swap | 1 | vide | 100 | 100–150 | 1.00x | 4515 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 3906 | 3600–5301 | 1.00x | 3166 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 4100 | 3900–4609 | 1.05x | 19264 | 6.08x | 1 | yes |
| rows-update-every-10th | 1 | compose | 3912 | 3409–4110 | 1.00x | 5457 | 1.72x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 4000 | 3574–4700 | 1.02x | 10544 | 3.33x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4500 | 4200–5200 | 1.15x | 14472 | 4.57x | 8 | yes |
| rows-update-every-10th | 1 | react | 4100 | 3735–4700 | 1.05x | 7830 | 2.47x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 6980 | 5600–7800 | 1.79x | 8870 | 2.80x | 76 | yes |
| rows-update-every-10th | 1 | react-upstream | 4100 | 3900–5006 | 1.05x | 7901 | 2.50x | 8 | yes |
| rows-update-every-10th | 1 | roact | 4105 | 3900–4500 | 1.05x | 16682 | 5.27x | 1 | yes |
| rows-update-every-10th | 1 | seam | 6000 | 5100–6500 | 1.54x | 24213 | 7.65x | 0 | yes |
| rows-update-every-10th | 1 | signals | 4100 | 3823–4900 | 1.05x | 9354 | 2.95x | 0 | yes |
| rows-update-every-10th | 1 | vide | 4000 | 3800–4300 | 1.02x | 5116 | 1.62x | 8 | yes |

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
| blend | 29 | 2.50x | 11.11x | 2.47x | 10.77x |
| compose | 30 | 1.95x | 3.30x | 1.85x | 3.21x |
| fusion | 30 | 6.10x | 6.55x | 5.57x | 6.57x |
| fusion-charm | 30 | 5.59x | 7.46x | 5.06x | 7.56x |
| react | 29 | 4.45x | 6.14x | 4.29x | 6.51x |
| react-reflex | 29 | 5.12x | 9.57x | 4.95x | 10.28x |
| react-upstream | 29 | 4.40x | 6.22x | 4.24x | 6.59x |
| roact | 29 | 3.00x | 5.93x | 2.94x | 6.70x |
| seam | 30 | 3.92x | 11.94x | 3.60x | 11.78x |
| signals | 29 | 1.93x | 2.84x | 1.85x | 2.83x |
| vide | 30 | 1.97x | 3.02x | 1.87x | 3.02x |
