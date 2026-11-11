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
| Harness revision | `e058f99` |
| Date | 2026-11-11 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 304 | 200–500 | 1.00x | 57 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 800 | 500–1109 | 2.63x | 765 | 13.42x | 0 | yes |
| update-leaf | 20 | compose | 891 | 502–1122 | 2.93x | 93 | 1.63x | 2 | yes |
| update-leaf | 20 | fusion | 1030 | 711–1169 | 3.39x | 59 | 1.04x | 0 | yes |
| update-leaf | 20 | fusion-charm | 1002 | 640–1222 | 3.30x | 62 | 1.09x | 1 | yes |
| update-leaf | 20 | react | 624 | 400–1102 | 2.05x | 347 | 6.09x | 0 | yes |
| update-leaf | 20 | react-reflex | 1080 | 800–1159 | 3.55x | 301 | 5.28x | 1 | yes |
| update-leaf | 20 | react-upstream | 615 | 500–1152 | 2.02x | 292 | 5.12x | 0 | yes |
| update-leaf | 20 | roact | 700 | 389–840 | 2.30x | 960 | 16.84x | 1 | yes |
| update-leaf | 20 | seam | 814 | 700–1140 | 2.68x | 40 | 0.70x | 0 | yes |
| update-leaf | 20 | signals | 665 | 200–1272 | 2.19x | 43 | 0.75x | 1 | yes |
| update-leaf | 20 | vide | 717 | 300–771 | 2.36x | 3 | 0.05x | 0 | yes |
| update-batched | 20 | plain | 4600 | 4510–5000 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 10602 | 10163–11180 | 2.30x | 909 | 45.45x | 0 | yes |
| update-batched | 20 | compose | 6825 | 6611–7235 | 1.48x | 408 | 20.40x | 10 | yes |
| update-batched | 20 | fusion | 21227 | 20312–21904 | 4.61x | 501 | 25.05x | 0 | yes |
| update-batched | 20 | fusion-charm | 36846 | 34867–37617 | 8.01x | 1086 | 54.30x | 0 | yes |
| update-batched | 20 | react | 7309 | 7066–7556 | 1.59x | 541 | 27.05x | 0 | yes |
| update-batched | 20 | react-reflex | 52647 | 49284–53889 | 11.44x | 775 | 38.75x | 16 | yes |
| update-batched | 20 | react-upstream | 7971 | 7690–8207 | 1.73x | 477 | 23.85x | 1 | yes |
| update-batched | 20 | roact | 7972 | 7445–8407 | 1.73x | 1161 | 58.05x | 0 | yes |
| update-batched | 20 | seam | 12073 | 11015–13024 | 2.62x | 1825 | 91.25x | 0 | yes |
| update-batched | 20 | signals | 9369 | 8894–9844 | 2.04x | 597 | 29.85x | 1 | yes |
| update-batched | 20 | vide | 8352 | 7782–8487 | 1.82x | 331 | 16.55x | 0 | yes |
| update-repeated | 10 | plain | 49 | 45–54 | 1.00x | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 3394 | 3244–3559 | 69.66x | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 256 | 100–386 | 5.27x | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 25369 | 24570–26537 | 520.79x | 13 | 6.50x | 8 | yes |
| update-repeated | 10 | fusion-charm | 1122 | 950–1320 | 23.02x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 7094 | 6924–7471 | 145.63x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 728 | 544–916 | 14.95x | 3 | 1.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 7206 | 7000–7335 | 147.93x | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5070 | 4900–5162 | 104.08x | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1416 | 1200–1951 | 29.07x | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 897 | 766–946 | 18.41x | 12 | 6.00x | 0 | yes |
| update-repeated | 10 | vide | 412 | 358–527 | 8.47x | 3 | 1.50x | 1 | yes |
| branch-swap | 20 | plain | 12920 | 12313–13811 | 1.00x | 10 | 1.00x | 8 | yes |
| branch-swap | 20 | blend | 16635 | 16041–16765 | 1.29x | 27 | 2.70x | 1 | yes |
| branch-swap | 20 | compose | 13625 | 13328–14123 | 1.05x | 7 | 0.70x | 1 | yes |
| branch-swap | 20 | fusion | 14600 | 14313–14930 | 1.13x | 5 | 0.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 14227 | 13980–14646 | 1.10x | 6 | 0.60x | 1 | yes |
| branch-swap | 20 | react | 17120 | 16270–18160 | 1.33x | 10 | 1.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 16322 | 15988–16989 | 1.26x | 19 | 1.90x | 0 | yes |
| branch-swap | 20 | react-upstream | 16870 | 16045–17749 | 1.31x | 18 | 1.80x | 0 | yes |
| branch-swap | 20 | roact | 15008 | 14478–15454 | 1.16x | 19 | 1.90x | 1 | yes |
| branch-swap | 20 | seam | 12106 | 11837–12301 | 0.94x | 11 | 1.10x | 0 | yes |
| branch-swap | 20 | signals | 12802 | 12640–15020 | 0.99x | 5 | 0.50x | 0 | yes |
| branch-swap | 20 | vide | 14046 | 13704–14343 | 1.09x | 5 | 0.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2333 | 2301–2643 | 1.00x | 65 | 1.00x | 1 | yes |
| keyed-prepend | 10 | blend | 4776 | 4444–5005 | 2.05x | 1490 | 22.92x | 1 | yes |
| keyed-prepend | 10 | compose | 4574 | 4450–4783 | 1.96x | 571 | 8.78x | 18 | yes |
| keyed-prepend | 10 | fusion (workaround) | 23212 | 21336–25844 | 9.95x | 1528 | 23.51x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 20921 | 19652–21622 | 8.97x | 1513 | 23.28x | 1 | yes |
| keyed-prepend | 10 | react | 15900 | 15586–16807 | 6.81x | 785 | 12.08x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 15921 | 15709–16114 | 6.82x | 786 | 12.09x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 15927 | 15642–16830 | 6.83x | 792 | 12.18x | 7 | yes |
| keyed-prepend | 10 | roact | 7000 | 6608–7201 | 3.00x | 369 | 5.68x | 9 | yes |
| keyed-prepend | 10 | seam | 11100 | 10331–11710 | 4.76x | 2456 | 37.78x | 0 | yes |
| keyed-prepend | 10 | signals | 2968 | 2852–3208 | 1.27x | 61 | 0.94x | 1 | yes |
| keyed-prepend | 10 | vide | 4835 | 4712–5652 | 2.07x | 646 | 9.94x | 1 | yes |
| keyed-insert | 10 | plain | 1628 | 1604–1731 | 1.00x | 65 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4111 | 3708–4250 | 2.52x | 1489 | 22.91x | 1 | yes |
| keyed-insert | 10 | compose | 3109 | 2904–3650 | 1.91x | 555 | 8.54x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 19233 | 18414–19824 | 11.81x | 1526 | 23.48x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 18321 | 17010–19610 | 11.25x | 1513 | 23.28x | 0 | yes |
| keyed-insert | 10 | react | 13839 | 13341–14202 | 8.50x | 811 | 12.48x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13543 | 13326–14837 | 8.32x | 874 | 13.45x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13427 | 13137–13944 | 8.25x | 811 | 12.48x | 0 | yes |
| keyed-insert | 10 | roact | 5594 | 5200–6123 | 3.44x | 371 | 5.71x | 0 | yes |
| keyed-insert | 10 | seam | 10706 | 10378–11032 | 6.57x | 2440 | 37.54x | 1 | yes |
| keyed-insert | 10 | signals | 1826 | 1709–2062 | 1.12x | 69 | 1.06x | 8 | yes |
| keyed-insert | 10 | vide | 3518 | 3410–3950 | 2.16x | 647 | 9.95x | 0 | yes |
| keyed-shuffle | 10 | plain | 1902 | 1835–2104 | 1.00x | 60 | 1.00x | 8 | yes |
| keyed-shuffle | 10 | blend | 2900 | 2500–2976 | 1.52x | 1432 | 23.87x | 0 | yes |
| keyed-shuffle | 10 | compose | 3118 | 2850–3256 | 1.64x | 562 | 9.37x | 10 | yes |
| keyed-shuffle | 10 | fusion | 18520 | 17229–19109 | 9.74x | 1399 | 23.32x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 18209 | 16834–18930 | 9.57x | 1400 | 23.33x | 0 | yes |
| keyed-shuffle | 10 | react | 27916 | 26848–28520 | 14.68x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27763 | 26710–28703 | 14.60x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 28647 | 28154–28934 | 15.06x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | roact | 5663 | 5406–6207 | 2.98x | 361 | 6.02x | 0 | yes |
| keyed-shuffle | 10 | seam | 9443 | 9304–9926 | 4.96x | 2439 | 40.65x | 1 | yes |
| keyed-shuffle | 10 | signals | 2024 | 1914–2302 | 1.06x | 61 | 1.02x | 0 | yes |
| keyed-shuffle | 10 | vide | 3712 | 3656–3813 | 1.95x | 629 | 10.48x | 1 | yes |
| events | 1 | plain | 1104 | 704–1200 | 1.00x | 2 | 1.00x | 1 | yes |
| events | 1 | blend | 1500 | 1200–1829 | 1.36x | 1 | 0.50x | 0 | yes |
| events | 1 | compose | 1100 | 800–1730 | 1.00x | 3 | 1.50x | 1 | yes |
| events | 1 | fusion | 1617 | 700–1634 | 1.46x | 2 | 1.00x | 0 | yes |
| events | 1 | fusion-charm | 1300 | 1000–1614 | 1.18x | 2 | 1.00x | 1 | yes |
| events | 1 | react | 1710 | 1100–1808 | 1.55x | 0 | 0.50x | 0 | yes |
| events | 1 | react-reflex | 1400 | 1112–2064 | 1.27x | 1 | 0.50x | 0 | yes |
| events | 1 | react-upstream | 1400 | 1216–1702 | 1.27x | 1 | 0.50x | 0 | yes |
| events | 1 | roact | 1018 | 600–1681 | 0.92x | 1 | 0.50x | 0 | yes |
| events | 1 | seam | 1000 | 600–1200 | 0.91x | 9 | 4.50x | 0 | yes |
| events | 1 | signals | 1048 | 706–1300 | 0.95x | 9 | 4.50x | 8 | yes |
| events | 1 | vide | 905 | 702–1428 | 0.82x | 1 | 0.50x | 8 | yes |
| animate-many | 1 | plain | 3164 | 2483–3289 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 10492 | 9606–10738 | 3.32x | 1770 | 23.92x | 0 | yes |
| animate-many | 1 | compose | 6575 | 6269–7264 | 2.08x | 738 | 9.97x | 13 | yes |
| animate-many | 1 | fusion | 105016 | 103973–105644 | 33.19x | 1120 | 15.14x | 0 | yes |
| animate-many | 1 | fusion-charm | 104755 | 102812–104909 | 33.11x | 1121 | 15.15x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20507 | 18933–21788 | 6.48x | 2898 | 39.16x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8065 | 7680–8558 | 2.55x | 384 | 5.19x | 0 | yes |
| status-panel | 10 | plain | 641 | 570–670 | 1.00x | 3 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 1016 | 930–1156 | 1.59x | 70 | 23.33x | 8 | yes |
| status-panel | 10 | compose | 978 | 853–1014 | 1.53x | 32 | 10.67x | 2 | yes |
| status-panel | 10 | fusion | 1469 | 1410–1536 | 2.29x | 64 | 21.33x | 0 | yes |
| status-panel | 10 | fusion-charm | 1553 | 1450–1700 | 2.42x | 70 | 23.33x | 0 | yes |
| status-panel | 10 | react | 1998 | 1713–2347 | 3.12x | 43 | 14.33x | 8 | yes |
| status-panel | 10 | react-reflex | 2000 | 1729–2400 | 3.12x | 45 | 15.00x | 0 | yes |
| status-panel | 10 | react-upstream | 1908 | 1882–1967 | 2.98x | 35 | 11.67x | 0 | yes |
| status-panel | 10 | roact | 1060 | 870–1260 | 1.65x | 34 | 11.33x | 1 | yes |
| status-panel | 10 | seam | 1703 | 1209–2065 | 2.66x | 141 | 47.00x | 1 | yes |
| status-panel | 10 | signals | 888 | 818–988 | 1.39x | 14 | 4.67x | 0 | yes |
| status-panel | 10 | vide | 1026 | 884–1168 | 1.60x | 25 | 8.33x | 0 | yes |
| scene-3d | 10 | plain | 2780 | 2470–3138 | 1.00x | 12 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4405 | 4250–4658 | 1.58x | 542 | 45.17x | 1 | yes |
| scene-3d | 10 | compose | 2882 | 2798–3056 | 1.04x | 194 | 16.17x | 2 | yes |
| scene-3d | 10 | fusion | 34445 | 32881–35978 | 12.39x | 520 | 43.33x | 0 | yes |
| scene-3d | 10 | fusion-charm | 32214 | 31550–32840 | 11.59x | 516 | 43.00x | 0 | yes |
| scene-3d | 10 | react | 3397 | 3200–3987 | 1.22x | 231 | 19.25x | 0 | yes |
| scene-3d | 10 | react-reflex | 2865 | 2850–3036 | 1.03x | 216 | 18.00x | 0 | yes |
| scene-3d | 10 | react-upstream | 3414 | 3374–3569 | 1.23x | 223 | 18.58x | 0 | yes |
| scene-3d | 10 | roact | 3193 | 2906–3406 | 1.15x | 574 | 47.83x | 0 | yes |
| scene-3d | 10 | seam | 8400 | 7902–9102 | 3.02x | 1763 | 146.92x | 0 | yes |
| scene-3d | 10 | signals | 5602 | 5402–6000 | 2.02x | 690 | 57.50x | 0 | yes |
| scene-3d | 10 | vide | 3858 | 3427–3986 | 1.39x | 211 | 17.58x | 9 | yes |
| derived-diamond | 3 | plain | 20 | 16–31 | 1.00x | 4 | 1.00x | 8 | yes |
| derived-diamond | 3 | blend | 150 | 125–151 | 7.40x | 28 | 7.00x | 1 | yes |
| derived-diamond | 3 | compose | 125 | 100–175 | 6.17x | 10 | 2.50x | 1 | yes |
| derived-diamond | 3 | fusion | 130 | 101–155 | 6.39x | 8 | 2.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 100 | 100–151 | 4.93x | 11 | 2.75x | 1 | yes |
| derived-diamond | 3 | react | 302 | 233–403 | 14.90x | 6 | 1.50x | 3 | yes |
| derived-diamond | 3 | react-reflex | 349 | 300–400 | 17.21x | 18 | 4.50x | 7 | yes |
| derived-diamond | 3 | react-upstream | 339 | 236–402 | 16.74x | 7 | 1.75x | 4 | yes |
| derived-diamond | 3 | roact | 100 | 100–125 | 4.93x | 10 | 2.50x | 3 | yes |
| derived-diamond | 3 | seam | 150 | 100–250 | 7.40x | 21 | 5.25x | 8 | yes |
| derived-diamond | 3 | signals | 102 | 100–150 | 5.02x | 9 | 2.25x | 0 | yes |
| derived-diamond | 3 | vide | 126 | 100–155 | 6.20x | 6 | 1.50x | 0 | yes |
| derived-chain-100 | 3 | plain | 54 | 49–65 | 1.00x | 57 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 225 | 180–280 | 4.20x | 131 | 2.30x | 1 | yes |
| derived-chain-100 | 3 | fusion | 926 | 902–978 | 17.27x | 127 | 2.23x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 880 | 825–939 | 16.41x | 129 | 2.26x | 1 | yes |
| derived-chain-100 | 3 | react | 567 | 510–569 | 10.57x | 69 | 1.21x | 11 | yes |
| derived-chain-100 | 3 | react-reflex | 633 | 467–700 | 11.82x | 80 | 1.40x | 14 | yes |
| derived-chain-100 | 3 | react-upstream | 591 | 433–604 | 11.03x | 61 | 1.07x | 3 | yes |
| derived-chain-100 | 3 | roact | 150 | 125–152 | 2.80x | 19 | 0.33x | 3 | yes |
| derived-chain-100 | 3 | seam | 752 | 578–830 | 14.03x | 271 | 4.75x | 0 | yes |
| derived-chain-100 | 3 | signals | 250 | 164–328 | 4.66x | 174 | 3.05x | 1 | yes |
| derived-chain-100 | 3 | vide | 184 | 125–262 | 3.43x | 93 | 1.63x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–100 | 1.00x | 505 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 250 | 231–375 | 2.50x | 1535 | 3.04x | 1 | yes |
| derived-fan-in-1000 | 3 | compose | 396 | 325–501 | 3.96x | 687 | 1.36x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion | 2073 | 1933–2237 | 20.73x | 881 | 1.74x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2300 | 2252–2437 | 23.00x | 2806 | 5.56x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2552 | 2360–3202 | 25.52x | 671 | 1.33x | 52 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7707 | 6810–8900 | 77.07x | 5621 | 11.13x | 78 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2350 | 2250–2919 | 23.50x | 670 | 1.33x | 51 | yes |
| derived-fan-in-1000 | 3 | roact | 500 | 426–531 | 5.00x | 112 | 0.22x | 11 | yes |
| derived-fan-in-1000 | 3 | seam | 2802 | 2616–3210 | 28.02x | 2955 | 5.85x | 9 | yes |
| derived-fan-in-1000 | 3 | signals | 750 | 700–880 | 7.50x | 1205 | 2.39x | 8 | yes |
| derived-fan-in-1000 | 3 | vide | 588 | 450–708 | 5.88x | 528 | 1.05x | 0 | yes |
| filter-as-you-type | 1 | plain | 8926 | 8204–9507 | 1.00x | 35 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16416 | 15729–17244 | 1.84x | 2662 | 76.06x | 1 | yes |
| filter-as-you-type | 1 | compose | 10809 | 10209–11536 | 1.21x | 824 | 23.54x | 2 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 28120 | 24833–30236 | 3.15x | 2457 | 70.20x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26762 | 24972–27618 | 3.00x | 2475 | 70.71x | 9 | yes |
| filter-as-you-type | 1 | react | 20924 | 19205–22058 | 2.34x | 76 | 2.17x | 12 | yes |
| filter-as-you-type | 1 | react-reflex | 20937 | 20124–22422 | 2.35x | 830 | 23.71x | 15 | yes |
| filter-as-you-type | 1 | react-upstream | 21457 | 19937–21807 | 2.40x | 68 | 1.94x | 4 | yes |
| filter-as-you-type | 1 | roact | 11535 | 10806–12144 | 1.29x | 511 | 14.60x | 4 | yes |
| filter-as-you-type | 1 | seam | 24296 | 19811–25025 | 2.72x | 4013 | 114.66x | 0 | yes |
| filter-as-you-type | 1 | signals | 7901 | 7201–8100 | 0.89x | 36 | 1.03x | 8 | yes |
| filter-as-you-type | 1 | vide | 10910 | 10700–11037 | 1.22x | 959 | 27.40x | 0 | yes |
| theme-propagation | 3 | plain | 48656 | 45161–56686 | 1.00x | 199 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 46807 | 46159–49743 | 0.96x | 2070 | 10.40x | 0 | yes |
| theme-propagation | 3 | compose | 50891 | 50426–52392 | 1.05x | 571 | 2.87x | 1 | yes |
| theme-propagation | 3 | fusion | 52259 | 50555–52832 | 1.07x | 875 | 4.40x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 53608 | 52382–56574 | 1.10x | 877 | 4.41x | 1 | yes |
| theme-propagation | 3 | react | 53530 | 53145–53862 | 1.10x | 2028 | 10.19x | 0 | yes |
| theme-propagation | 3 | react-reflex | 46512 | 46031–48444 | 0.96x | 2029 | 10.20x | 0 | yes |
| theme-propagation | 3 | react-upstream | 53773 | 52443–54374 | 1.11x | 2028 | 10.19x | 0 | yes |
| theme-propagation | 3 | roact | 49865 | 49061–50477 | 1.02x | 3271 | 16.44x | 0 | yes |
| theme-propagation | 3 | seam | 46525 | 45022–47457 | 0.96x | 3470 | 17.44x | 0 | yes |
| theme-propagation | 3 | signals | 51845 | 50972–52638 | 1.07x | 902 | 4.53x | 0 | yes |
| theme-propagation | 3 | vide | 50363 | 50127–51488 | 1.04x | 592 | 2.97x | 0 | yes |
| hud-per-frame | 1 | plain | 2759 | 2128–3598 | 1.00x | 23 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5446 | 5435–5579 | 1.97x | 79 | 3.43x | 4 | yes |
| hud-per-frame | 1 | compose | 3843 | 3798–5325 | 1.39x | 24 | 1.02x | 2 | yes |
| hud-per-frame | 1 | fusion | 10340 | 10178–10463 | 3.75x | 43 | 1.87x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 12998 | 12997–13193 | 4.71x | 82 | 3.59x | 0 | yes |
| hud-per-frame | 1 | react | 4772 | 4598–4959 | 1.73x | 30 | 1.28x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7246 | 6840–7415 | 2.63x | 50 | 2.17x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 3632 | 3176–4302 | 1.32x | 34 | 1.48x | 0 | yes |
| hud-per-frame | 1 | roact | 4261 | 4178–4559 | 1.54x | 89 | 3.87x | 0 | yes |
| hud-per-frame | 1 | seam | 8129 | 7954–10233 | 2.95x | 172 | 7.50x | 4 | yes |
| hud-per-frame | 1 | signals | 4672 | 4325–5063 | 1.69x | 65 | 2.83x | 0 | yes |
| hud-per-frame | 1 | vide | 4472 | 2872–4765 | 1.62x | 22 | 0.98x | 0 | yes |
| teardown-under-load | 1 | plain | 50475 | 45473–50956 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 72706 | 68741–80063 | 1.44x | 14 | 2.80x | 1 | yes |
| teardown-under-load | 1 | compose | 54018 | 48629–55061 | 1.07x | 15 | 3.00x | 10 | yes |
| teardown-under-load | 1 | fusion | 76828 | 71030–78574 | 1.52x | 12 | 2.40x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 71940 | 70130–74960 | 1.43x | 6 | 1.20x | 0 | yes |
| teardown-under-load | 1 | react | 74904 | 73964–78118 | 1.48x | 1069 | 213.80x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 74489 | 70497–78771 | 1.48x | 1079 | 215.80x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 75244 | 63898–77128 | 1.49x | 1077 | 215.40x | 8 | yes |
| teardown-under-load | 1 | roact | 70465 | 57282–75835 | 1.40x | 71 | 14.20x | 1 | yes |
| teardown-under-load | 1 | seam | 62663 | 58554–72066 | 1.24x | 8 | 1.60x | 7 | yes |
| teardown-under-load | 1 | signals | 53278 | 48694–56541 | 1.06x | 13 | 2.60x | 8 | yes |
| teardown-under-load | 1 | vide | 58985 | 53955–59604 | 1.17x | 5 | 1.00x | 8 | yes |
| open-close-retention | 1 | plain | 66487 | 65793–67485 | 1.00x | 40 | 1.00x | 8 | yes |
| open-close-retention | 1 | blend | 118151 | 117012–119146 | 1.78x | 6 | 0.15x | 8 | yes |
| open-close-retention | 1 | compose | 81372 | 81063–82190 | 1.22x | 15 | 0.38x | 2 | yes |
| open-close-retention | 1 | fusion | 134651 | 134323–135838 | 2.03x | 13 | 0.33x | 9 | yes |
| open-close-retention | 1 | fusion-charm | 135467 | 134416–135787 | 2.04x | 14 | 0.35x | 1 | yes |
| open-close-retention | 1 | react | 113048 | 112971–115540 | 1.70x | 283 | 7.08x | 2 | yes |
| open-close-retention | 1 | react-reflex | 115275 | 113630–117926 | 1.73x | 284 | 7.10x | 0 | yes |
| open-close-retention | 1 | react-upstream | 116060 | 113270–117166 | 1.75x | 283 | 7.08x | 0 | yes |
| open-close-retention | 1 | roact | 107417 | 106606–108319 | 1.62x | 23 | 0.57x | 0 | yes |
| open-close-retention | 1 | seam | 111596 | 111340–114483 | 1.68x | 9 | 0.23x | 1 | yes |
| open-close-retention | 1 | signals | 82688 | 82301–83850 | 1.24x | 13 | 0.33x | 0 | yes |
| open-close-retention | 1 | vide | 88709 | 87532–89808 | 1.33x | 4 | 0.10x | 0 | yes |
| tree-expand-collapse | 1 | plain | 9254 | 7504–10808 | 1.00x | 21 | 1.00x | 1 | yes |
| tree-expand-collapse | 1 | blend | 20532 | 18522–21666 | 2.22x | 804 | 38.29x | 8 | yes |
| tree-expand-collapse | 1 | compose | 12108 | 11998–12540 | 1.31x | 72 | 3.43x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24241 | 23670–27376 | 2.62x | 166 | 7.90x | 10 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23636 | 21149–27258 | 2.55x | 272 | 12.95x | 0 | yes |
| tree-expand-collapse | 1 | react | 19234 | 18740–20723 | 2.08x | 62 | 2.95x | 20 | yes |
| tree-expand-collapse | 1 | react-reflex | 19001 | 18224–20006 | 2.05x | 665 | 31.67x | 23 | yes |
| tree-expand-collapse | 1 | react-upstream | 19921 | 18818–20679 | 2.15x | 69 | 3.29x | 20 | yes |
| tree-expand-collapse | 1 | roact | 11157 | 11014–11721 | 1.21x | 35 | 1.67x | 4 | yes |
| tree-expand-collapse | 1 | seam | 26497 | 24948–29929 | 2.86x | 149 | 7.10x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8214 | 7716–8409 | 0.89x | 22 | 1.05x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12000 | 11639–12235 | 1.30x | 71 | 3.38x | 0 | yes |
| form-validation | 1 | plain | 2333 | 2167–2475 | 1.00x | 45 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 4089 | 3521–4442 | 1.75x | 336 | 7.47x | 0 | yes |
| form-validation | 1 | compose | 3923 | 3774–4150 | 1.68x | 106 | 2.36x | 2 | yes |
| form-validation | 1 | fusion | 4966 | 4412–6089 | 2.13x | 119 | 2.64x | 1 | yes |
| form-validation | 1 | fusion-charm | 5701 | 5131–5818 | 2.44x | 155 | 3.44x | 0 | yes |
| form-validation | 1 | react | 5139 | 4811–5599 | 2.20x | 73 | 1.62x | 0 | yes |
| form-validation | 1 | react-reflex | 5985 | 5007–6131 | 2.56x | 83 | 1.84x | 1 | yes |
| form-validation | 1 | react-upstream | 4659 | 4430–5410 | 2.00x | 66 | 1.47x | 0 | yes |
| form-validation | 1 | roact | 4814 | 3908–5231 | 2.06x | 223 | 4.96x | 1 | yes |
| form-validation | 1 | seam | 6976 | 6393–7157 | 2.99x | 349 | 7.76x | 0 | yes |
| form-validation | 1 | signals | 3734 | 3398–4552 | 1.60x | 155 | 3.44x | 0 | yes |
| form-validation | 1 | vide | 3811 | 3643–4433 | 1.63x | 70 | 1.56x | 0 | yes |
| table-sort-filter | 1 | plain | 17603 | 17323–19327 | 1.00x | 66 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 37731 | 34232–44180 | 2.14x | 5396 | 81.76x | 0 | yes |
| table-sort-filter | 1 | compose | 24989 | 24128–26402 | 1.42x | 1617 | 24.50x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 57143 | 49480–58138 | 3.25x | 4695 | 71.14x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 52442 | 51292–53251 | 2.98x | 4697 | 71.17x | 0 | yes |
| table-sort-filter | 1 | react | 97412 | 92447–102381 | 5.53x | 2108 | 31.94x | 11 | yes |
| table-sort-filter | 1 | react-reflex | 96720 | 89647–97831 | 5.49x | 2123 | 32.17x | 23 | yes |
| table-sort-filter | 1 | react-upstream | 96442 | 92162–101331 | 5.48x | 2108 | 31.94x | 12 | yes |
| table-sort-filter | 1 | roact | 24927 | 23804–26479 | 1.42x | 1014 | 15.36x | 11 | yes |
| table-sort-filter | 1 | seam | 57582 | 53446–65666 | 3.27x | 7783 | 117.92x | 1 | yes |
| table-sort-filter | 1 | signals | 17924 | 16739–18639 | 1.02x | 76 | 1.15x | 1 | yes |
| table-sort-filter | 1 | vide | 25825 | 23708–27308 | 1.47x | 1923 | 29.14x | 8 | yes |
| library-load | 1 | plain | 35 | 26–51 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 759 | 672–880 | 21.69x | 459 | 459.00x | 457 | yes |
| library-load | 1 | compose | 659 | 617–743 | 18.83x | 59 | 59.00x | 64 | yes |
| library-load | 1 | fusion | 1318 | 1146–2575 | 37.66x | 271 | 271.00x | 270 | yes |
| library-load | 1 | fusion-charm | 1477 | 1338–1916 | 42.19x | 318 | 318.00x | 325 | yes |
| library-load | 1 | react | 4907 | 4689–5214 | 140.20x | 1810 | 1810.00x | 1808 | yes |
| library-load | 1 | react-reflex | 5136 | 4534–5383 | 146.74x | 1972 | 1972.00x | 1972 | yes |
| library-load | 1 | react-upstream | 5030 | 4470–5378 | 143.72x | 2002 | 2002.00x | 2001 | yes |
| library-load | 1 | roact | 445 | 382–454 | 12.72x | 153 | 153.00x | 150 | yes |
| library-load | 1 | seam | 1311 | 1145–3453 | 37.45x | 243 | 243.00x | 240 | yes |
| library-load | 1 | signals | 251 | 249–279 | 7.18x | 42 | 42.00x | 41 | yes |
| library-load | 1 | vide | 361 | 334–381 | 10.31x | 146 | 146.00x | 146 | yes |
| rows-append-1000 | 1 | plain | 98073 | 96786–98845 | 1.00x | 6531 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 152907 | 145752–169843 | 1.56x | 38489 | 5.89x | 9 | yes |
| rows-append-1000 | 1 | compose | 118112 | 112176–158475 | 1.20x | 10999 | 1.68x | 10 | yes |
| rows-append-1000 | 1 | fusion | 343894 | 333577–374217 | 3.51x | 21026 | 3.22x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 334334 | 319409–359816 | 3.41x | 29074 | 4.45x | 1 | yes |
| rows-append-1000 | 1 | react | 192998 | 169596–229116 | 1.97x | 23334 | 3.57x | 112 | yes |
| rows-append-1000 | 1 | react-reflex | 214371 | 204928–237224 | 2.19x | 24911 | 3.81x | 5 | yes |
| rows-append-1000 | 1 | react-upstream | 196741 | 177979–225882 | 2.01x | 22897 | 3.51x | 0 | yes |
| rows-append-1000 | 1 | roact | 155950 | 146509–202095 | 1.59x | 33275 | 5.09x | 0 | yes |
| rows-append-1000 | 1 | seam | 179831 | 158366–188165 | 1.83x | 46768 | 7.16x | 1 | yes |
| rows-append-1000 | 1 | signals | 112152 | 101667–145114 | 1.14x | 17357 | 2.66x | 0 | yes |
| rows-append-1000 | 1 | vide | 116754 | 113605–143289 | 1.19x | 10431 | 1.60x | 8 | yes |
| rows-clear | 1 | plain | 17627 | 16300–18045 | 1.00x | 1229 | 1.00x | 8 | yes |
| rows-clear | 1 | blend | 36294 | 35339–37934 | 2.06x | 4170 | 3.39x | 1 | yes |
| rows-clear | 1 | compose | 24576 | 23930–27142 | 1.39x | 1870 | 1.52x | 3 | yes |
| rows-clear | 1 | fusion | 80045 | 73846–80804 | 4.54x | 3480 | 2.83x | 0 | yes |
| rows-clear | 1 | fusion-charm | 73796 | 70408–75892 | 4.19x | 7393 | 6.02x | 1 | yes |
| rows-clear | 1 | react | 25664 | 23713–26023 | 1.46x | 4495 | 3.66x | 0 | yes |
| rows-clear | 1 | react-reflex | 28914 | 27229–30822 | 1.64x | 6490 | 5.28x | 37 | yes |
| rows-clear | 1 | react-upstream | 26051 | 24743–28235 | 1.48x | 4487 | 3.65x | 0 | yes |
| rows-clear | 1 | roact | 24730 | 21617–25926 | 1.40x | 4206 | 3.42x | 1 | yes |
| rows-clear | 1 | seam | 31515 | 23120–36904 | 1.79x | 9272 | 7.54x | 0 | yes |
| rows-clear | 1 | signals | 21656 | 21018–22711 | 1.23x | 4443 | 3.62x | 0 | yes |
| rows-clear | 1 | vide | 19776 | 18929–21343 | 1.12x | 1605 | 1.31x | 1 | yes |
| rows-create-1000 | 1 | plain | 95750 | 94155–97380 | 1.00x | 3127 | 1.00x | 1 | yes |
| rows-create-1000 | 1 | blend | 151938 | 132708–159812 | 1.59x | 19728 | 6.31x | 0 | yes |
| rows-create-1000 | 1 | compose | 108466 | 105138–136823 | 1.13x | 5810 | 1.86x | 3 | yes |
| rows-create-1000 | 1 | fusion | 188704 | 175106–197438 | 1.97x | 10955 | 3.50x | 8 | yes |
| rows-create-1000 | 1 | fusion-charm | 187655 | 176305–193513 | 1.96x | 14716 | 4.71x | 1 | yes |
| rows-create-1000 | 1 | react | 171008 | 161996–174235 | 1.79x | 8160 | 2.61x | 8 | yes |
| rows-create-1000 | 1 | react-reflex | 184741 | 169420–195231 | 1.93x | 9090 | 2.91x | 53 | yes |
| rows-create-1000 | 1 | react-upstream | 164971 | 159847–174079 | 1.72x | 8128 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 129432 | 119402–142283 | 1.35x | 16906 | 5.41x | 1 | yes |
| rows-create-1000 | 1 | seam | 157236 | 130972–162322 | 1.64x | 23886 | 7.64x | 1 | yes |
| rows-create-1000 | 1 | signals | 106057 | 99779–120727 | 1.11x | 9106 | 2.91x | 0 | yes |
| rows-create-1000 | 1 | vide | 115091 | 107741–129540 | 1.20x | 4964 | 1.59x | 8 | yes |
| rows-create-10000 | 1 | plain | 1132727 | 1108583–1265137 | 1.00x | 29836 | 1.00x | 4 | yes |
| rows-create-10000 | 1 | blend | 1697636 | 1542273–1786499 | 1.50x | 188030 | 6.30x | 4 | yes |
| rows-create-10000 | 1 | compose | 1305368 | 1287935–1308778 | 1.15x | 55487 | 1.86x | 15 | yes |
| rows-create-10000 | 1 | fusion | 6220805 | 5959189–6432963 | 5.49x | 104638 | 3.51x | 5 | yes |
| rows-create-10000 | 1 | fusion-charm | 6311072 | 6228175–6336798 | 5.57x | 140630 | 4.71x | 0 | yes |
| rows-create-10000 | 1 | react | 5229916 | 5002550–5253104 | 4.62x | 77536 | 2.60x | 848 | yes |
| rows-create-10000 | 1 | react-reflex | 5223754 | 4988431–5463170 | 4.61x | 87101 | 2.92x | 804 | yes |
| rows-create-10000 | 1 | react-upstream | 4849410 | 4750802–4943695 | 4.28x | 78382 | 2.63x | 640 | yes |
| rows-create-10000 | 1 | roact | 1442260 | 1433625–1609757 | 1.27x | 166002 | 5.56x | 0 | yes |
| rows-create-10000 | 1 | seam | 1689327 | 1584870–1727182 | 1.49x | 235772 | 7.90x | 12 | yes |
| rows-create-10000 | 1 | signals | 1186401 | 1186326–1345589 | 1.05x | 89429 | 3.00x | 0 | yes |
| rows-create-10000 | 1 | vide | 1294027 | 1282701–1403997 | 1.14x | 48512 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 767 | 633–880 | 1.00x | 2749 | 1.00x | 9 | yes |
| rows-remove-one | 1 | blend | 1200 | 1106–1300 | 1.57x | 18292 | 6.65x | 1 | yes |
| rows-remove-one | 1 | compose | 900 | 800–1006 | 1.17x | 4924 | 1.79x | 3 | yes |
| rows-remove-one | 1 | fusion (workaround) | 61467 | 59712–63130 | 80.17x | 11106 | 4.04x | 2 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 60756 | 59450–61716 | 79.25x | 15041 | 5.47x | 1 | yes |
| rows-remove-one | 1 | react | 33441 | 24530–41661 | 43.62x | 15532 | 5.65x | 25 | yes |
| rows-remove-one | 1 | react-reflex | 32152 | 25742–46183 | 41.94x | 16414 | 5.97x | 28 | yes |
| rows-remove-one | 1 | react-upstream | 25030 | 23348–37838 | 32.65x | 15469 | 5.63x | 0 | yes |
| rows-remove-one | 1 | roact | 17112 | 15438–49433 | 22.32x | 16781 | 6.10x | 0 | yes |
| rows-remove-one | 1 | seam | 5822 | 5204–6507 | 7.59x | 23229 | 8.45x | 0 | yes |
| rows-remove-one | 1 | signals | 1643 | 1336–1735 | 2.14x | 8622 | 3.14x | 1 | yes |
| rows-remove-one | 1 | vide | 1174 | 1073–1216 | 1.53x | 4561 | 1.66x | 0 | yes |
| rows-swap | 1 | plain | 100 | 100–100 | 1.00x | 2680 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 702 | 700–754 | 7.01x | 18278 | 6.82x | 1 | yes |
| rows-swap | 1 | compose | 267 | 200–333 | 2.67x | 4895 | 1.83x | 2 | yes |
| rows-swap | 1 | fusion | 61034 | 58048–64374 | 610.34x | 9567 | 3.57x | 0 | yes |
| rows-swap | 1 | fusion-charm | 58245 | 56965–60015 | 582.45x | 14515 | 5.42x | 8 | yes |
| rows-swap | 1 | react | 58723 | 52471–59444 | 587.23x | 15441 | 5.76x | 0 | yes |
| rows-swap | 1 | react-reflex | 66488 | 64658–74578 | 664.88x | 16387 | 6.11x | 28 | yes |
| rows-swap | 1 | react-upstream | 59348 | 53636–87302 | 593.48x | 15001 | 5.60x | 9 | yes |
| rows-swap | 1 | roact | 17430 | 15411–22810 | 174.30x | 16308 | 6.09x | 9 | yes |
| rows-swap | 1 | seam | 4902 | 4620–5550 | 49.02x | 23219 | 8.66x | 0 | yes |
| rows-swap | 1 | signals | 567 | 533–604 | 5.67x | 8601 | 3.21x | 0 | yes |
| rows-swap | 1 | vide | 200 | 167–268 | 2.00x | 4508 | 1.68x | 1 | yes |
| rows-update-every-10th | 1 | plain | 1933 | 1873–2039 | 1.00x | 3183 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1857 | 1802–2053 | 0.96x | 19265 | 6.05x | 0 | yes |
| rows-update-every-10th | 1 | compose | 1935 | 1801–2039 | 1.00x | 5449 | 1.71x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 2002 | 1900–2005 | 1.04x | 10544 | 3.31x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2306 | 2002–2602 | 1.19x | 14455 | 4.54x | 0 | yes |
| rows-update-every-10th | 1 | react | 2006 | 1801–2153 | 1.04x | 7838 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 4100 | 3950–4508 | 2.12x | 8822 | 2.77x | 21 | yes |
| rows-update-every-10th | 1 | react-upstream | 2006 | 1850–2104 | 1.04x | 7853 | 2.47x | 0 | yes |
| rows-update-every-10th | 1 | roact | 2070 | 2033–2150 | 1.07x | 16697 | 5.25x | 0 | yes |
| rows-update-every-10th | 1 | seam | 4310 | 4004–4602 | 2.23x | 24171 | 7.59x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2035 | 1969–2302 | 1.05x | 9306 | 2.92x | 1 | yes |
| rows-update-every-10th | 1 | vide | 2000 | 1954–2037 | 1.03x | 5124 | 1.61x | 0 | yes |

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
| blend | 29 | 2.41x | 9.82x | 2.38x | 9.51x |
| compose | 30 | 1.80x | 3.59x | 1.74x | 3.52x |
| fusion | 30 | 6.75x | 5.87x | 6.17x | 5.87x |
| fusion-charm | 30 | 6.12x | 7.04x | 5.56x | 7.13x |
| react | 29 | 5.09x | 5.58x | 4.96x | 5.90x |
| react-reflex | 29 | 5.60x | 8.39x | 5.45x | 8.94x |
| react-upstream | 29 | 4.97x | 5.62x | 4.83x | 5.96x |
| roact | 29 | 2.76x | 5.26x | 2.76x | 5.81x |
| seam | 30 | 3.88x | 11.47x | 3.64x | 11.33x |
| signals | 29 | 1.80x | 2.77x | 1.74x | 2.76x |
| vide | 30 | 1.86x | 2.60x | 1.80x | 2.58x |
