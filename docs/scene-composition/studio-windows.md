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
| Harness revision | `c9a1a50` |
| Date | 2026-11-11 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 500 | 500–600 | 1.00x | 50 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 1973 | 1870–2067 | 3.95x | 757 | 15.14x | 0 | yes |
| update-leaf | 20 | compose | 1910 | 1733–2036 | 3.82x | 102 | 2.04x | 2 | yes |
| update-leaf | 20 | fusion | 2163 | 1933–2167 | 4.33x | 52 | 1.04x | 1 | yes |
| update-leaf | 20 | fusion-charm | 2210 | 2117–2267 | 4.42x | 54 | 1.08x | 1 | yes |
| update-leaf | 20 | react | 2067 | 1818–2128 | 4.13x | 355 | 7.10x | 0 | yes |
| update-leaf | 20 | react-reflex | 2400 | 1937–2600 | 4.80x | 300 | 6.00x | 0 | yes |
| update-leaf | 20 | react-upstream | 2000 | 1841–2267 | 4.00x | 291 | 5.82x | 0 | yes |
| update-leaf | 20 | roact | 2059 | 1672–2133 | 4.12x | 951 | 19.02x | 0 | yes |
| update-leaf | 20 | seam | 2000 | 1750–2400 | 4.00x | 41 | 0.82x | 1 | yes |
| update-leaf | 20 | signals | 1900 | 1800–2200 | 3.80x | 50 | 1.00x | 0 | yes |
| update-leaf | 20 | vide | 2000 | 1900–2101 | 4.00x | 3 | 0.06x | 0 | yes |
| update-batched | 20 | plain | 4450 | 4300–4501 | 1.00x | 21 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 11200 | 10500–12005 | 2.52x | 908 | 43.24x | 0 | yes |
| update-batched | 20 | compose | 7200 | 7041–7766 | 1.62x | 408 | 19.43x | 10 | yes |
| update-batched | 20 | fusion | 17911 | 17300–19000 | 4.02x | 500 | 23.81x | 0 | yes |
| update-batched | 20 | fusion-charm | 29956 | 28421–32317 | 6.73x | 1085 | 51.67x | 0 | yes |
| update-batched | 20 | react | 7600 | 7023–8700 | 1.71x | 541 | 25.76x | 8 | yes |
| update-batched | 20 | react-reflex | 50049 | 47702–58290 | 11.25x | 775 | 36.90x | 16 | yes |
| update-batched | 20 | react-upstream | 8421 | 7443–8506 | 1.89x | 480 | 22.86x | 9 | yes |
| update-batched | 20 | roact | 8409 | 7500–8700 | 1.89x | 1170 | 55.71x | 8 | yes |
| update-batched | 20 | seam | 11500 | 10900–11905 | 2.58x | 1833 | 87.29x | 1 | yes |
| update-batched | 20 | signals | 9000 | 8856–9900 | 2.02x | 605 | 28.81x | 1 | yes |
| update-batched | 20 | vide | 8120 | 7400–8390 | 1.82x | 332 | 15.81x | 0 | yes |
| update-repeated | 10 | plain | 40 | 38–40 | 1.00x | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3100 | 2850–3566 | 77.90x | 8 | 4.00x | 1 | yes |
| update-repeated | 10 | compose | 457 | 357–557 | 11.49x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 21601 | 20300–22600 | 542.81x | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | fusion-charm | 960 | 920–1040 | 24.12x | 11 | 5.50x | 1 | yes |
| update-repeated | 10 | react | 4752 | 4700–5200 | 119.40x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 724 | 612–857 | 18.19x | 12 | 6.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 5500 | 5011–6100 | 138.21x | 0 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6422 | 5904–7208 | 161.38x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1367 | 1157–1426 | 34.34x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 762 | 745–880 | 19.14x | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 567 | 467–589 | 14.24x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 21941 | 19268–22100 | 1.00x | 2 | 1.00x | 1 | yes |
| branch-swap | 20 | blend | 29809 | 26462–33940 | 1.36x | 35 | 17.50x | 0 | yes |
| branch-swap | 20 | compose | 24526 | 23830–25867 | 1.12x | 7 | 3.50x | 10 | yes |
| branch-swap | 20 | fusion | 30002 | 29205–88615 | 1.37x | 37 | 18.50x | 1 | yes |
| branch-swap | 20 | fusion-charm | 27402 | 25601–29320 | 1.25x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 27750 | 26782–29686 | 1.26x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-reflex | 28837 | 28710–30196 | 1.31x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 30107 | 28806–33513 | 1.37x | 19 | 9.50x | 8 | yes |
| branch-swap | 20 | roact | 31501 | 29421–31911 | 1.44x | 12 | 6.00x | 0 | yes |
| branch-swap | 20 | seam | 23705 | 23157–28491 | 1.08x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | signals | 25001 | 23100–26604 | 1.14x | 13 | 6.50x | 1 | yes |
| branch-swap | 20 | vide | 26210 | 24400–27200 | 1.19x | 5 | 2.50x | 1 | yes |
| keyed-prepend | 10 | plain | 1801 | 1767–1897 | 1.00x | 72 | 1.00x | 9 | yes |
| keyed-prepend | 10 | blend | 4250 | 4000–4350 | 2.36x | 1490 | 20.69x | 0 | yes |
| keyed-prepend | 10 | compose | 3750 | 3550–3800 | 2.08x | 570 | 7.92x | 17 | yes |
| keyed-prepend | 10 | fusion (workaround) | 17144 | 15900–18800 | 9.52x | 1527 | 21.21x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 16300 | 15409–17210 | 9.05x | 1513 | 21.01x | 1 | yes |
| keyed-prepend | 10 | react | 10000 | 9505–11510 | 5.55x | 793 | 11.01x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 11008 | 10363–11420 | 6.11x | 786 | 10.92x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 10353 | 10009–11200 | 5.75x | 793 | 11.01x | 0 | yes |
| keyed-prepend | 10 | roact | 6000 | 5400–6205 | 3.33x | 369 | 5.12x | 0 | yes |
| keyed-prepend | 10 | seam | 9900 | 9004–10900 | 5.50x | 2440 | 33.89x | 1 | yes |
| keyed-prepend | 10 | signals | 2578 | 2435–2633 | 1.43x | 70 | 0.97x | 9 | yes |
| keyed-prepend | 10 | vide | 4303 | 4100–4556 | 2.39x | 647 | 8.99x | 1 | yes |
| keyed-insert | 10 | plain | 1175 | 1150–1425 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 3550 | 3500–3900 | 3.02x | 1490 | 23.28x | 0 | yes |
| keyed-insert | 10 | compose | 2624 | 2486–2700 | 2.23x | 563 | 8.80x | 14 | yes |
| keyed-insert | 10 | fusion (workaround) | 14375 | 14003–15307 | 12.23x | 1527 | 23.86x | 0 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 13900 | 13300–14700 | 11.83x | 1529 | 23.89x | 1 | yes |
| keyed-insert | 10 | react | 9502 | 8200–12908 | 8.09x | 810 | 12.66x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9401 | 8487–9800 | 8.00x | 875 | 13.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 9013 | 8709–9300 | 7.67x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 4350 | 4040–4610 | 3.70x | 369 | 5.77x | 1 | yes |
| keyed-insert | 10 | seam | 8800 | 8400–9000 | 7.49x | 2455 | 38.36x | 0 | yes |
| keyed-insert | 10 | signals | 1700 | 1644–1890 | 1.45x | 62 | 0.97x | 1 | yes |
| keyed-insert | 10 | vide | 3050 | 2900–3150 | 2.60x | 639 | 9.98x | 1 | yes |
| keyed-shuffle | 10 | plain | 1217 | 1180–1240 | 1.00x | 53 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2456 | 2250–2650 | 2.02x | 1440 | 27.17x | 0 | yes |
| keyed-shuffle | 10 | compose | 2398 | 2150–2600 | 1.97x | 570 | 10.75x | 10 | yes |
| keyed-shuffle | 10 | fusion | 15000 | 14375–15351 | 12.32x | 1399 | 26.40x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 14322 | 13801–15002 | 11.77x | 1400 | 26.42x | 0 | yes |
| keyed-shuffle | 10 | react | 14608 | 13700–16809 | 12.00x | 779 | 14.70x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 14408 | 14200–15980 | 11.84x | 779 | 14.70x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 14682 | 14011–17613 | 12.06x | 779 | 14.70x | 0 | yes |
| keyed-shuffle | 10 | roact | 4650 | 4346–4702 | 3.82x | 367 | 6.92x | 0 | yes |
| keyed-shuffle | 10 | seam | 7910 | 7400–8500 | 6.50x | 2455 | 46.32x | 9 | yes |
| keyed-shuffle | 10 | signals | 1633 | 1600–1700 | 1.34x | 53 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | vide | 2700 | 2600–2950 | 2.22x | 636 | 12.00x | 0 | yes |
| events | 1 | plain | 2900 | 2600–3100 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 3000 | 2300–4000 | 1.03x | 0 | 0.50x | 0 | yes |
| events | 1 | compose | 2700 | 2309–3800 | 0.93x | 10 | 5.00x | 2 | yes |
| events | 1 | fusion | 3600 | 2900–3800 | 1.24x | 1 | 0.50x | 0 | yes |
| events | 1 | fusion-charm | 3200 | 3100–4400 | 1.10x | 1 | 0.50x | 0 | yes |
| events | 1 | react | 4200 | 3300–4500 | 1.45x | 0 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 3900 | 2909–4001 | 1.34x | 9 | 4.50x | 0 | yes |
| events | 1 | react-upstream | 2600 | 1700–3600 | 0.90x | 0 | 0.50x | 0 | yes |
| events | 1 | roact | 2100 | 1800–3100 | 0.72x | 1 | 0.50x | 1 | yes |
| events | 1 | seam | 2100 | 1700–2300 | 0.72x | 1 | 0.50x | 1 | yes |
| events | 1 | signals | 2500 | 2400–2900 | 0.86x | 1 | 0.50x | 0 | yes |
| events | 1 | vide | 3200 | 2866–3800 | 1.10x | 1 | 0.50x | 0 | yes |
| animate-many | 1 | plain | 2550 | 2394–3400 | 1.00x | 73 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 11202 | 10230–11316 | 4.39x | 1746 | 23.92x | 0 | yes |
| animate-many | 1 | compose | 7400 | 6541–7491 | 2.90x | 752 | 10.30x | 12 | yes |
| animate-many | 1 | fusion | 74933 | 70953–76774 | 29.39x | 1128 | 15.45x | 0 | yes |
| animate-many | 1 | fusion-charm | 74013 | 71260–76559 | 29.02x | 1130 | 15.48x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20715 | 19001–21402 | 8.12x | 2906 | 39.81x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8500 | 7300–10402 | 3.33x | 392 | 5.37x | 0 | yes |
| status-panel | 10 | plain | 848 | 800–937 | 1.00x | 3 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 2252 | 2050–2350 | 2.65x | 70 | 23.33x | 0 | yes |
| status-panel | 10 | compose | 2300 | 2052–2367 | 2.71x | 33 | 11.00x | 2 | yes |
| status-panel | 10 | fusion | 2550 | 2200–2650 | 3.01x | 68 | 22.67x | 1 | yes |
| status-panel | 10 | fusion-charm | 2700 | 2500–2900 | 3.18x | 77 | 25.67x | 1 | yes |
| status-panel | 10 | react | 2950 | 2700–3100 | 3.48x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | react-reflex | 2950 | 2650–3250 | 3.48x | 45 | 15.00x | 0 | yes |
| status-panel | 10 | react-upstream | 2950 | 2750–3400 | 3.48x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | roact | 2067 | 1867–2267 | 2.44x | 33 | 11.00x | 0 | yes |
| status-panel | 10 | seam | 2752 | 2550–3400 | 3.24x | 140 | 46.67x | 0 | yes |
| status-panel | 10 | signals | 1954 | 1876–2194 | 2.30x | 15 | 5.00x | 0 | yes |
| status-panel | 10 | vide | 1967 | 1933–2067 | 2.32x | 32 | 10.67x | 1 | yes |
| scene-3d | 10 | plain | 2250 | 2150–2295 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 5000 | 4850–5250 | 2.22x | 542 | 49.27x | 0 | yes |
| scene-3d | 10 | compose | 3518 | 3200–3600 | 1.56x | 194 | 17.64x | 10 | yes |
| scene-3d | 10 | fusion | 22404 | 20200–23700 | 9.96x | 528 | 48.00x | 0 | yes |
| scene-3d | 10 | fusion-charm | 20800 | 19000–22200 | 9.24x | 516 | 46.91x | 0 | yes |
| scene-3d | 10 | react | 4150 | 3550–4450 | 1.84x | 222 | 20.18x | 0 | yes |
| scene-3d | 10 | react-reflex | 3350 | 3150–3578 | 1.49x | 225 | 20.45x | 0 | yes |
| scene-3d | 10 | react-upstream | 3650 | 3450–3750 | 1.62x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | roact | 3333 | 3200–3650 | 1.48x | 575 | 52.27x | 0 | yes |
| scene-3d | 10 | seam | 8178 | 8100–8388 | 3.63x | 1755 | 159.55x | 0 | yes |
| scene-3d | 10 | signals | 5300 | 4900–5900 | 2.36x | 683 | 62.09x | 1 | yes |
| scene-3d | 10 | vide | 4000 | 3750–4300 | 1.78x | 219 | 19.91x | 0 | yes |
| derived-diamond | 3 | plain | 25 | 17–29 | 1.00x | 5 | 1.00x | 1 | yes |
| derived-diamond | 3 | blend | 147 | 129–165 | 5.90x | 28 | 5.60x | 1 | yes |
| derived-diamond | 3 | compose | 147 | 124–156 | 5.90x | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | fusion | 156 | 129–182 | 6.24x | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 160 | 141–201 | 6.42x | 11 | 2.20x | 1 | yes |
| derived-diamond | 3 | react | 267 | 256–322 | 10.69x | 7 | 1.40x | 11 | yes |
| derived-diamond | 3 | react-reflex | 270 | 240–320 | 10.83x | 18 | 3.60x | 7 | yes |
| derived-diamond | 3 | react-upstream | 283 | 242–317 | 11.36x | 6 | 1.20x | 4 | yes |
| derived-diamond | 3 | roact | 162 | 144–175 | 6.52x | 3 | 0.60x | 3 | yes |
| derived-diamond | 3 | seam | 200 | 145–227 | 8.02x | 21 | 4.20x | 1 | yes |
| derived-diamond | 3 | signals | 131 | 119–150 | 5.26x | 17 | 3.40x | 0 | yes |
| derived-diamond | 3 | vide | 129 | 118–135 | 5.19x | 6 | 1.20x | 0 | yes |
| derived-chain-100 | 3 | plain | 32 | 30–34 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 194 | 181–200 | 6.01x | 139 | 2.44x | 2 | yes |
| derived-chain-100 | 3 | fusion | 525 | 475–638 | 16.24x | 128 | 2.25x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 570 | 500–581 | 17.63x | 129 | 2.26x | 1 | yes |
| derived-chain-100 | 3 | react | 444 | 357–540 | 13.74x | 69 | 1.21x | 4 | yes |
| derived-chain-100 | 3 | react-reflex | 407 | 390–470 | 12.59x | 80 | 1.40x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 450 | 400–501 | 13.92x | 61 | 1.07x | 12 | yes |
| derived-chain-100 | 3 | roact | 165 | 135–194 | 5.10x | 11 | 0.19x | 3 | yes |
| derived-chain-100 | 3 | seam | 793 | 686–829 | 24.52x | 271 | 4.75x | 0 | yes |
| derived-chain-100 | 3 | signals | 231 | 194–238 | 7.15x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 182 | 153–200 | 5.64x | 93 | 1.63x | 1 | yes |
| derived-fan-in-1000 | 3 | plain | 87 | 87–88 | 1.00x | 497 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 253 | 224–324 | 2.90x | 1535 | 3.09x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 300 | 254–338 | 3.44x | 688 | 1.38x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 1075 | 1050–1125 | 12.32x | 889 | 1.79x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1125 | 1032–1225 | 12.89x | 2813 | 5.66x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1600 | 1498–2467 | 18.33x | 664 | 1.34x | 44 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8456 | 7740–9100 | 96.90x | 5622 | 11.31x | 86 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1707 | 1633–2135 | 19.56x | 662 | 1.33x | 43 | yes |
| derived-fan-in-1000 | 3 | roact | 514 | 428–600 | 5.89x | 105 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 1601 | 1550–1725 | 18.34x | 2939 | 5.91x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 575 | 562–620 | 6.59x | 1205 | 2.42x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 380 | 360–420 | 4.35x | 528 | 1.06x | 0 | yes |
| filter-as-you-type | 1 | plain | 6800 | 6500–7200 | 1.00x | 41 | 1.00x | 7 | yes |
| filter-as-you-type | 1 | blend | 13849 | 13242–15789 | 2.04x | 2694 | 65.71x | 1 | yes |
| filter-as-you-type | 1 | compose | 9500 | 9000–10100 | 1.40x | 833 | 20.32x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 24000 | 20643–24800 | 3.53x | 2448 | 59.71x | 0 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 22201 | 19754–25248 | 3.26x | 2452 | 59.80x | 1 | yes |
| filter-as-you-type | 1 | react | 13936 | 13568–14295 | 2.05x | 76 | 1.85x | 11 | yes |
| filter-as-you-type | 1 | react-reflex | 14242 | 14100–15500 | 2.09x | 830 | 20.24x | 15 | yes |
| filter-as-you-type | 1 | react-upstream | 14212 | 13400–15600 | 2.09x | 84 | 2.05x | 20 | yes |
| filter-as-you-type | 1 | roact | 9500 | 9211–9804 | 1.40x | 503 | 12.27x | 3 | yes |
| filter-as-you-type | 1 | seam | 23000 | 17943–30301 | 3.38x | 4021 | 98.07x | 0 | yes |
| filter-as-you-type | 1 | signals | 7079 | 7000–7598 | 1.04x | 36 | 0.88x | 0 | yes |
| filter-as-you-type | 1 | vide | 9500 | 9000–11100 | 1.40x | 959 | 23.39x | 0 | yes |
| theme-propagation | 3 | plain | 103219 | 97584–114452 | 1.00x | 207 | 1.00x | 1 | yes |
| theme-propagation | 3 | blend | 101009 | 98459–205556 | 0.98x | 2069 | 10.00x | 0 | yes |
| theme-propagation | 3 | compose | 109529 | 102451–183351 | 1.06x | 572 | 2.76x | 2 | yes |
| theme-propagation | 3 | fusion | 105732 | 99680–114201 | 1.02x | 867 | 4.19x | 8 | yes |
| theme-propagation | 3 | fusion-charm | 108124 | 105500–113831 | 1.05x | 868 | 4.19x | 0 | yes |
| theme-propagation | 3 | react | 112230 | 105205–133774 | 1.09x | 2035 | 9.83x | 0 | yes |
| theme-propagation | 3 | react-reflex | 117183 | 99048–125168 | 1.14x | 2020 | 9.76x | 0 | yes |
| theme-propagation | 3 | react-upstream | 112216 | 103075–135509 | 1.09x | 2027 | 9.79x | 0 | yes |
| theme-propagation | 3 | roact | 107452 | 101304–110763 | 1.04x | 3271 | 15.80x | 1 | yes |
| theme-propagation | 3 | seam | 98314 | 94779–101842 | 0.95x | 3478 | 16.80x | 9 | yes |
| theme-propagation | 3 | signals | 113209 | 107410–293562 | 1.10x | 903 | 4.36x | 0 | yes |
| theme-propagation | 3 | vide | 108540 | 100869–157401 | 1.05x | 598 | 2.89x | 0 | yes |
| hud-per-frame | 1 | plain | 3400 | 3100–4000 | 1.00x | 23 | 1.00x | 1 | yes |
| hud-per-frame | 1 | blend | 5900 | 4800–6900 | 1.74x | 71 | 3.09x | 0 | yes |
| hud-per-frame | 1 | compose | 5600 | 5400–6301 | 1.65x | 37 | 1.61x | 2 | yes |
| hud-per-frame | 1 | fusion | 9700 | 9400–10803 | 2.85x | 54 | 2.35x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 14517 | 13711–15040 | 4.27x | 98 | 4.26x | 8 | yes |
| hud-per-frame | 1 | react | 5200 | 4100–6100 | 1.53x | 34 | 1.48x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 8200 | 7700–8700 | 2.41x | 53 | 2.30x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 5400 | 5100–6203 | 1.59x | 34 | 1.48x | 0 | yes |
| hud-per-frame | 1 | roact | 5271 | 5100–6467 | 1.55x | 90 | 3.91x | 0 | yes |
| hud-per-frame | 1 | seam | 9832 | 9400–11000 | 2.89x | 169 | 7.35x | 0 | yes |
| hud-per-frame | 1 | signals | 6500 | 5100–7900 | 1.91x | 65 | 2.83x | 0 | yes |
| hud-per-frame | 1 | vide | 5100 | 4700–5800 | 1.50x | 25 | 1.09x | 8 | yes |
| teardown-under-load | 1 | plain | 41859 | 40159–42805 | 1.00x | 13 | 1.00x | 1 | yes |
| teardown-under-load | 1 | blend | 57817 | 56011–59226 | 1.38x | 6 | 0.46x | 1 | yes |
| teardown-under-load | 1 | compose | 49433 | 47820–50733 | 1.18x | 7 | 0.54x | 2 | yes |
| teardown-under-load | 1 | fusion | 72165 | 64539–76801 | 1.72x | 5 | 0.38x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 73232 | 63014–78360 | 1.75x | 6 | 0.46x | 0 | yes |
| teardown-under-load | 1 | react | 59018 | 54703–65551 | 1.41x | 1077 | 82.85x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 58146 | 53930–60745 | 1.39x | 1079 | 83.00x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 57750 | 53915–59807 | 1.38x | 1069 | 82.23x | 0 | yes |
| teardown-under-load | 1 | roact | 59969 | 52120–83061 | 1.43x | 79 | 6.08x | 8 | yes |
| teardown-under-load | 1 | seam | 63264 | 60101–66407 | 1.51x | 8 | 0.62x | 7 | yes |
| teardown-under-load | 1 | signals | 46357 | 43967–49800 | 1.11x | 5 | 0.38x | 8 | yes |
| teardown-under-load | 1 | vide | 50156 | 49440–51360 | 1.20x | 4 | 0.31x | 8 | yes |
| open-close-retention | 1 | plain | 66524 | 65644–68219 | 1.00x | 32 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 109197 | 102831–112521 | 1.64x | 6 | 0.19x | 1 | yes |
| open-close-retention | 1 | compose | 79472 | 78168–84126 | 1.19x | 7 | 0.22x | 2 | yes |
| open-close-retention | 1 | fusion | 124012 | 122154–131255 | 1.86x | 5 | 0.16x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 128609 | 124759–132963 | 1.93x | 7 | 0.22x | 1 | yes |
| open-close-retention | 1 | react | 103761 | 101296–113330 | 1.56x | 282 | 8.81x | 0 | yes |
| open-close-retention | 1 | react-reflex | 103094 | 100623–104788 | 1.55x | 292 | 9.12x | 0 | yes |
| open-close-retention | 1 | react-upstream | 103435 | 103134–104519 | 1.55x | 283 | 8.84x | 0 | yes |
| open-close-retention | 1 | roact | 102525 | 100166–105554 | 1.54x | 31 | 0.97x | 8 | yes |
| open-close-retention | 1 | seam | 117088 | 109787–122970 | 1.76x | 10 | 0.31x | 1 | yes |
| open-close-retention | 1 | signals | 79936 | 79198–80680 | 1.20x | 13 | 0.41x | 1 | yes |
| open-close-retention | 1 | vide | 85061 | 82150–86848 | 1.28x | 13 | 0.41x | 0 | yes |
| tree-expand-collapse | 1 | plain | 7660 | 7251–7905 | 1.00x | 28 | 1.00x | 1 | yes |
| tree-expand-collapse | 1 | blend | 18120 | 15707–19500 | 2.37x | 796 | 28.43x | 8 | yes |
| tree-expand-collapse | 1 | compose | 11700 | 10700–12300 | 1.53x | 72 | 2.57x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24745 | 21851–28364 | 3.23x | 165 | 5.89x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 24218 | 21971–24977 | 3.16x | 152 | 5.43x | 1 | yes |
| tree-expand-collapse | 1 | react | 13890 | 13480–14411 | 1.81x | 78 | 2.79x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 15101 | 13933–19063 | 1.97x | 681 | 24.32x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 15000 | 13910–16006 | 1.96x | 70 | 2.50x | 20 | yes |
| tree-expand-collapse | 1 | roact | 10100 | 9937–11300 | 1.32x | 35 | 1.25x | 3 | yes |
| tree-expand-collapse | 1 | seam | 22935 | 20800–27131 | 2.99x | 149 | 5.32x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8000 | 7100–9400 | 1.04x | 29 | 1.04x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11400 | 10500–12550 | 1.49x | 71 | 2.54x | 0 | yes |
| form-validation | 1 | plain | 3552 | 3000–5064 | 1.00x | 46 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 8000 | 7100–8720 | 2.25x | 328 | 7.13x | 1 | yes |
| form-validation | 1 | compose | 7527 | 7034–8202 | 2.12x | 106 | 2.30x | 0 | yes |
| form-validation | 1 | fusion | 7400 | 7201–9000 | 2.08x | 118 | 2.57x | 0 | yes |
| form-validation | 1 | fusion-charm | 8700 | 8200–10403 | 2.45x | 155 | 3.37x | 1 | yes |
| form-validation | 1 | react | 8100 | 7800–8400 | 2.28x | 66 | 1.43x | 0 | yes |
| form-validation | 1 | react-reflex | 8939 | 8700–9900 | 2.52x | 75 | 1.63x | 0 | yes |
| form-validation | 1 | react-upstream | 9051 | 8100–9800 | 2.55x | 65 | 1.41x | 0 | yes |
| form-validation | 1 | roact | 8011 | 6900–8900 | 2.26x | 224 | 4.87x | 1 | yes |
| form-validation | 1 | seam | 9307 | 9057–9804 | 2.62x | 357 | 7.76x | 9 | yes |
| form-validation | 1 | signals | 7968 | 7278–8683 | 2.24x | 163 | 3.54x | 0 | yes |
| form-validation | 1 | vide | 7442 | 6802–7808 | 2.10x | 70 | 1.52x | 0 | yes |
| table-sort-filter | 1 | plain | 15003 | 14636–15800 | 1.00x | 67 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 30108 | 28908–35000 | 2.01x | 5389 | 80.43x | 1 | yes |
| table-sort-filter | 1 | compose | 20502 | 19502–22705 | 1.37x | 1624 | 24.24x | 25 | yes |
| table-sort-filter | 1 | fusion (workaround) | 48777 | 43109–51691 | 3.25x | 4695 | 70.07x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 45464 | 41104–48861 | 3.03x | 4698 | 70.12x | 1 | yes |
| table-sort-filter | 1 | react | 52546 | 50505–54736 | 3.50x | 2108 | 31.46x | 19 | yes |
| table-sort-filter | 1 | react-reflex | 53124 | 49314–57105 | 3.54x | 2107 | 31.45x | 23 | yes |
| table-sort-filter | 1 | react-upstream | 51324 | 50069–56000 | 3.42x | 2108 | 31.46x | 20 | yes |
| table-sort-filter | 1 | roact | 20840 | 19300–22502 | 1.39x | 1006 | 15.01x | 3 | yes |
| table-sort-filter | 1 | seam | 50404 | 44816–59281 | 3.36x | 7680 | 114.63x | 0 | yes |
| table-sort-filter | 1 | signals | 15431 | 15188–17519 | 1.03x | 68 | 1.01x | 1 | yes |
| table-sort-filter | 1 | vide | 22100 | 20855–24400 | 1.47x | 1914 | 28.57x | 0 | yes |
| library-load | 1 | plain | 42 | 41–46 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 746 | 731–773 | 17.81x | 458 | 458.00x | 456 | yes |
| library-load | 1 | compose | 678 | 627–812 | 16.19x | 59 | 59.00x | 63 | yes |
| library-load | 1 | fusion | 1593 | 1360–1991 | 38.01x | 263 | 263.00x | 262 | yes |
| library-load | 1 | fusion-charm | 1654 | 1643–1765 | 39.48x | 310 | 310.00x | 309 | yes |
| library-load | 1 | react | 7267 | 6395–7985 | 173.44x | 1825 | 1825.00x | 1824 | yes |
| library-load | 1 | react-reflex | 5551 | 5010–6603 | 132.49x | 1973 | 1973.00x | 1980 | yes |
| library-load | 1 | react-upstream | 5384 | 4837–6012 | 128.50x | 2002 | 2002.00x | 2001 | yes |
| library-load | 1 | roact | 465 | 437–735 | 11.11x | 154 | 154.00x | 157 | yes |
| library-load | 1 | seam | 1583 | 1467–1721 | 37.78x | 243 | 243.00x | 240 | yes |
| library-load | 1 | signals | 226 | 202–885 | 5.39x | 33 | 33.00x | 32 | yes |
| library-load | 1 | vide | 393 | 339–461 | 9.37x | 146 | 146.00x | 138 | yes |
| rows-append-1000 | 1 | plain | 161083 | 157106–170096 | 1.00x | 6524 | 1.00x | 1 | yes |
| rows-append-1000 | 1 | blend | 233178 | 226622–247584 | 1.45x | 38842 | 5.95x | 0 | yes |
| rows-append-1000 | 1 | compose | 184701 | 178987–259021 | 1.15x | 10983 | 1.68x | 11 | yes |
| rows-append-1000 | 1 | fusion | 312204 | 303568–320659 | 1.94x | 21290 | 3.26x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 342637 | 323995–400302 | 2.13x | 29226 | 4.48x | 0 | yes |
| rows-append-1000 | 1 | react | 237480 | 225716–294660 | 1.47x | 23226 | 3.56x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 252129 | 226311–322046 | 1.57x | 24862 | 3.81x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 241081 | 236729–321703 | 1.50x | 22945 | 3.52x | 0 | yes |
| rows-append-1000 | 1 | roact | 218504 | 212110–232013 | 1.36x | 33235 | 5.09x | 1 | yes |
| rows-append-1000 | 1 | seam | 243912 | 236181–291995 | 1.51x | 46403 | 7.11x | 13 | yes |
| rows-append-1000 | 1 | signals | 186459 | 163338–206552 | 1.16x | 17189 | 2.63x | 4 | yes |
| rows-append-1000 | 1 | vide | 185036 | 177509–245312 | 1.15x | 10416 | 1.60x | 0 | yes |
| rows-clear | 1 | plain | 17290 | 15707–21900 | 1.00x | 1221 | 1.00x | 1 | yes |
| rows-clear | 1 | blend | 36006 | 33616–39811 | 2.08x | 4178 | 3.42x | 1 | yes |
| rows-clear | 1 | compose | 24204 | 20200–28300 | 1.40x | 1870 | 1.53x | 10 | yes |
| rows-clear | 1 | fusion | 50811 | 49419–54118 | 2.94x | 3489 | 2.86x | 0 | yes |
| rows-clear | 1 | fusion-charm | 48835 | 47943–54115 | 2.82x | 7393 | 6.05x | 0 | yes |
| rows-clear | 1 | react | 20216 | 19244–26051 | 1.17x | 4495 | 3.68x | 0 | yes |
| rows-clear | 1 | react-reflex | 28736 | 23451–39779 | 1.66x | 6497 | 5.32x | 36 | yes |
| rows-clear | 1 | react-upstream | 23402 | 21716–24000 | 1.35x | 4487 | 3.67x | 0 | yes |
| rows-clear | 1 | roact | 23801 | 21977–26110 | 1.38x | 4214 | 3.45x | 1 | yes |
| rows-clear | 1 | seam | 32323 | 24620–33200 | 1.87x | 9270 | 7.59x | 0 | yes |
| rows-clear | 1 | signals | 19508 | 18506–21601 | 1.13x | 4458 | 3.65x | 1 | yes |
| rows-clear | 1 | vide | 18705 | 15700–22217 | 1.08x | 1613 | 1.32x | 1 | yes |
| rows-create-1000 | 1 | plain | 157214 | 153322–167991 | 1.00x | 3120 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 323768 | 286984–382666 | 2.06x | 19704 | 6.32x | 0 | yes |
| rows-create-1000 | 1 | compose | 228006 | 196808–339739 | 1.45x | 5802 | 1.86x | 3 | yes |
| rows-create-1000 | 1 | fusion | 244725 | 227768–369765 | 1.56x | 10923 | 3.50x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 251417 | 221332–380676 | 1.60x | 14829 | 4.75x | 0 | yes |
| rows-create-1000 | 1 | react | 220636 | 210471–250268 | 1.40x | 8144 | 2.61x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 236518 | 204815–314787 | 1.50x | 9081 | 2.91x | 44 | yes |
| rows-create-1000 | 1 | react-upstream | 208839 | 195151–221405 | 1.33x | 8136 | 2.61x | 0 | yes |
| rows-create-1000 | 1 | roact | 191082 | 176894–225344 | 1.22x | 16913 | 5.42x | 0 | yes |
| rows-create-1000 | 1 | seam | 228896 | 212446–250021 | 1.46x | 23909 | 7.66x | 0 | yes |
| rows-create-1000 | 1 | signals | 187657 | 158768–200398 | 1.19x | 9122 | 2.92x | 1 | yes |
| rows-create-1000 | 1 | vide | 170819 | 166626–179586 | 1.09x | 4956 | 1.59x | 8 | yes |
| rows-create-10000 | 1 | plain | 1751059 | 1703350–1771241 | 1.00x | 29784 | 1.00x | 16 | yes |
| rows-create-10000 | 1 | blend | 2449137 | 2344861–2637859 | 1.40x | 187522 | 6.30x | 4 | yes |
| rows-create-10000 | 1 | compose | 2275351 | 2266279–2325649 | 1.30x | 55402 | 1.86x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6695372 | 6648486–7082343 | 3.82x | 104817 | 3.52x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 5802767 | 5532373–5823645 | 3.31x | 145524 | 4.89x | 0 | yes |
| rows-create-10000 | 1 | react | 4071922 | 3961796–4115670 | 2.33x | 77482 | 2.60x | 556 | yes |
| rows-create-10000 | 1 | react-reflex | 4149650 | 4106705–4164441 | 2.37x | 84246 | 2.83x | 394 | yes |
| rows-create-10000 | 1 | react-upstream | 3951156 | 3893379–3966320 | 2.26x | 78514 | 2.64x | 292 | yes |
| rows-create-10000 | 1 | roact | 2317380 | 2253026–2344968 | 1.32x | 165730 | 5.56x | 0 | yes |
| rows-create-10000 | 1 | seam | 2495966 | 2494252–2642050 | 1.43x | 235047 | 7.89x | 20 | yes |
| rows-create-10000 | 1 | signals | 2026022 | 1975589–2078960 | 1.16x | 89208 | 3.00x | 0 | yes |
| rows-create-10000 | 1 | vide | 1876712 | 1817278–2097997 | 1.07x | 48456 | 1.63x | 4 | yes |
| rows-remove-one | 1 | plain | 703 | 500–1050 | 1.00x | 2733 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1300 | 1200–1300 | 1.85x | 18283 | 6.69x | 8 | yes |
| rows-remove-one | 1 | compose | 650 | 500–700 | 0.92x | 4924 | 1.80x | 18 | yes |
| rows-remove-one | 1 | fusion (workaround) | 36001 | 34212–42177 | 51.21x | 11114 | 4.07x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 33222 | 31309–34909 | 47.26x | 15026 | 5.50x | 1 | yes |
| rows-remove-one | 1 | react | 20900 | 13206–37934 | 29.73x | 15500 | 5.67x | 23 | yes |
| rows-remove-one | 1 | react-reflex | 34300 | 19705–54229 | 48.79x | 16430 | 6.01x | 52 | yes |
| rows-remove-one | 1 | react-upstream | 24702 | 15702–40802 | 35.14x | 15460 | 5.66x | 0 | yes |
| rows-remove-one | 1 | roact | 20002 | 13601–43510 | 28.45x | 16765 | 6.13x | 0 | yes |
| rows-remove-one | 1 | seam | 4900 | 4500–5903 | 6.97x | 23205 | 8.49x | 0 | yes |
| rows-remove-one | 1 | signals | 1527 | 1500–1602 | 2.17x | 8605 | 3.15x | 0 | yes |
| rows-remove-one | 1 | vide | 850 | 800–950 | 1.21x | 4553 | 1.67x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 2687 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 800 | 400–1000 | 8.00x | 18262 | 6.80x | 1 | yes |
| rows-swap | 1 | compose | 100 | 100–200 | 1.00x | 4895 | 1.82x | 11 | yes |
| rows-swap | 1 | fusion | 33030 | 31416–34737 | 330.30x | 9551 | 3.55x | 0 | yes |
| rows-swap | 1 | fusion-charm | 32204 | 31459–35105 | 322.04x | 14619 | 5.44x | 0 | yes |
| rows-swap | 1 | react | 32800 | 28201–34480 | 328.00x | 15449 | 5.75x | 0 | yes |
| rows-swap | 1 | react-reflex | 41553 | 36307–56577 | 415.53x | 16387 | 6.10x | 37 | yes |
| rows-swap | 1 | react-upstream | 39518 | 27573–80922 | 395.18x | 14985 | 5.58x | 0 | yes |
| rows-swap | 1 | roact | 17241 | 12567–20800 | 172.41x | 16301 | 6.07x | 8 | yes |
| rows-swap | 1 | seam | 4100 | 3900–4505 | 41.00x | 23212 | 8.64x | 0 | yes |
| rows-swap | 1 | signals | 550 | 450–768 | 5.50x | 8602 | 3.20x | 0 | yes |
| rows-swap | 1 | vide | 100 | 100–161 | 1.00x | 4509 | 1.68x | 9 | yes |
| rows-update-every-10th | 1 | plain | 3700 | 3639–4396 | 1.00x | 3190 | 1.00x | 1 | yes |
| rows-update-every-10th | 1 | blend | 3700 | 3621–4300 | 1.00x | 19265 | 6.04x | 1 | yes |
| rows-update-every-10th | 1 | compose | 3851 | 3464–4400 | 1.04x | 5449 | 1.71x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 3800 | 3672–4327 | 1.03x | 10559 | 3.31x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4099 | 4000–4800 | 1.11x | 14472 | 4.54x | 8 | yes |
| rows-update-every-10th | 1 | react | 4100 | 3516–4400 | 1.11x | 7837 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 7000 | 5359–39344 | 1.89x | 8878 | 2.78x | 76 | yes |
| rows-update-every-10th | 1 | react-upstream | 3906 | 3659–4700 | 1.06x | 7862 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | roact | 4000 | 3480–4921 | 1.08x | 16682 | 5.23x | 1 | yes |
| rows-update-every-10th | 1 | seam | 5911 | 5613–6300 | 1.60x | 24204 | 7.59x | 1 | yes |
| rows-update-every-10th | 1 | signals | 4000 | 3726–4123 | 1.08x | 9346 | 2.93x | 0 | yes |
| rows-update-every-10th | 1 | vide | 3562 | 3321–4402 | 0.96x | 5124 | 1.61x | 0 | yes |

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
| blend | 29 | 2.62x | 9.70x | 2.57x | 9.39x |
| compose | 30 | 1.97x | 3.68x | 1.87x | 3.60x |
| fusion | 30 | 6.13x | 5.71x | 5.59x | 5.70x |
| fusion-charm | 30 | 5.66x | 6.89x | 5.13x | 6.96x |
| react | 29 | 4.60x | 5.75x | 4.42x | 6.08x |
| react-reflex | 29 | 5.23x | 9.43x | 5.07x | 10.09x |
| react-upstream | 29 | 4.61x | 5.75x | 4.43x | 6.10x |
| roact | 29 | 3.09x | 4.99x | 3.03x | 5.61x |
| seam | 30 | 4.05x | 11.01x | 3.71x | 10.84x |
| signals | 29 | 1.99x | 2.56x | 1.90x | 2.55x |
| vide | 30 | 1.98x | 2.76x | 1.87x | 2.74x |
