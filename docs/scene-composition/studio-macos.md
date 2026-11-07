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
| Roblox Studio | 0.746.0.7461269 |
| Studio device | hd_1080 |
| Context | client |
| Harness revision | `52fcdf8` |
| Date | 2026-11-07 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 100–400 | 1.00x | 57 | 1.00x | 1 | yes |
| update-leaf | 20 | blend | 831 | 700–1407 | 2.77x | 773 | 13.56x | 0 | yes |
| update-leaf | 20 | compose | 611 | 407–845 | 2.04x | 101 | 1.77x | 1 | yes |
| update-leaf | 20 | fusion | 1020 | 1005–1100 | 3.40x | 52 | 0.91x | 1 | yes |
| update-leaf | 20 | fusion-charm | 1098 | 823–1202 | 3.66x | 62 | 1.09x | 1 | yes |
| update-leaf | 20 | react | 600 | 513–1317 | 2.00x | 347 | 6.09x | 0 | yes |
| update-leaf | 20 | react-reflex | 1058 | 611–1217 | 3.53x | 301 | 5.28x | 8 | yes |
| update-leaf | 20 | react-upstream | 714 | 711–1013 | 2.38x | 292 | 5.12x | 0 | yes |
| update-leaf | 20 | roact | 692 | 531–1002 | 2.31x | 960 | 16.84x | 9 | yes |
| update-leaf | 20 | seam | 1200 | 917–1315 | 4.00x | 41 | 0.72x | 0 | yes |
| update-leaf | 20 | signals | 814 | 300–1209 | 2.71x | 51 | 0.89x | 1 | yes |
| update-leaf | 20 | vide | 922 | 700–1131 | 3.07x | 0 | 0.02x | 0 | yes |
| update-batched | 20 | plain | 4760 | 4204–5315 | 1.00x | 28 | 1.00x | 8 | yes |
| update-batched | 20 | blend | 10720 | 10602–11210 | 2.25x | 925 | 33.04x | 1 | yes |
| update-batched | 20 | compose | 7096 | 6720–7548 | 1.49x | 400 | 14.29x | 10 | yes |
| update-batched | 20 | fusion | 20857 | 20500–21155 | 4.38x | 501 | 17.89x | 0 | yes |
| update-batched | 20 | fusion-charm | 37105 | 36004–37845 | 7.79x | 1102 | 39.36x | 0 | yes |
| update-batched | 20 | react | 8276 | 7776–8527 | 1.74x | 541 | 19.32x | 0 | yes |
| update-batched | 20 | react-reflex | 53746 | 49921–60261 | 11.29x | 767 | 27.39x | 16 | yes |
| update-batched | 20 | react-upstream | 7844 | 7749–8103 | 1.65x | 477 | 17.04x | 1 | yes |
| update-batched | 20 | roact | 8078 | 7898–8113 | 1.70x | 1162 | 41.50x | 1 | yes |
| update-batched | 20 | seam | 12478 | 10543–13420 | 2.62x | 1833 | 65.46x | 1 | yes |
| update-batched | 20 | signals | 9409 | 9260–9688 | 1.98x | 605 | 21.61x | 0 | yes |
| update-batched | 20 | vide | 8619 | 8105–9102 | 1.81x | 324 | 11.57x | 0 | yes |
| update-repeated | 10 | plain | 50 | 44–56 | 1.00x | 9 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3410 | 3300–3631 | 68.75x | 0 | 0.11x | 0 | yes |
| update-repeated | 10 | compose | 206 | 106–458 | 4.14x | 6 | 0.67x | 2 | yes |
| update-repeated | 10 | fusion | 25474 | 24411–27161 | 513.58x | 4 | 0.44x | 1 | yes |
| update-repeated | 10 | fusion-charm | 1092 | 1061–1278 | 22.03x | 6 | 0.67x | 0 | yes |
| update-repeated | 10 | react | 7125 | 6708–7247 | 143.65x | 1 | 0.11x | 0 | yes |
| update-repeated | 10 | react-reflex | 676 | 550–853 | 13.64x | 12 | 1.33x | 0 | yes |
| update-repeated | 10 | react-upstream | 7261 | 7025–7672 | 146.39x | 0 | 0.11x | 0 | yes |
| update-repeated | 10 | roact | 5333 | 5145–5560 | 107.52x | 6 | 0.67x | 8 | yes |
| update-repeated | 10 | seam | 1507 | 1309–1600 | 30.38x | 11 | 1.22x | 9 | yes |
| update-repeated | 10 | signals | 801 | 670–1020 | 16.15x | 4 | 0.44x | 0 | yes |
| update-repeated | 10 | vide | 378 | 264–462 | 7.61x | 3 | 0.33x | 0 | yes |
| branch-swap | 20 | plain | 12605 | 12406–13710 | 1.00x | 2 | 1.00x | 8 | yes |
| branch-swap | 20 | blend | 16368 | 15281–17000 | 1.30x | 35 | 17.50x | 0 | yes |
| branch-swap | 20 | compose | 13599 | 13501–13902 | 1.08x | 7 | 3.50x | 2 | yes |
| branch-swap | 20 | fusion | 14520 | 13694–14974 | 1.15x | 6 | 3.00x | 1 | yes |
| branch-swap | 20 | fusion-charm | 13542 | 13083–13907 | 1.07x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | react | 16581 | 15426–17666 | 1.32x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 16251 | 15834–16886 | 1.29x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | react-upstream | 16566 | 15942–17391 | 1.31x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | roact | 14180 | 13642–14439 | 1.12x | 20 | 10.00x | 8 | yes |
| branch-swap | 20 | seam | 11818 | 11636–12310 | 0.94x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | signals | 13024 | 12639–14291 | 1.03x | 5 | 2.50x | 1 | yes |
| branch-swap | 20 | vide | 13637 | 13217–14230 | 1.08x | 6 | 3.00x | 1 | yes |
| keyed-prepend | 10 | plain | 2404 | 2267–2613 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4534 | 4324–5101 | 1.89x | 1482 | 23.16x | 0 | yes |
| keyed-prepend | 10 | compose | 4125 | 3958–4324 | 1.72x | 571 | 8.92x | 18 | yes |
| keyed-prepend | 10 | fusion (workaround) | 22466 | 21258–23339 | 9.35x | 1519 | 23.73x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 20544 | 19717–21719 | 8.55x | 1513 | 23.64x | 1 | yes |
| keyed-prepend | 10 | react | 15827 | 15121–16336 | 6.58x | 792 | 12.38x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16132 | 15514–16703 | 6.71x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16232 | 16047–16416 | 6.75x | 801 | 12.52x | 0 | yes |
| keyed-prepend | 10 | roact | 6871 | 6514–7183 | 2.86x | 370 | 5.78x | 1 | yes |
| keyed-prepend | 10 | seam | 11309 | 10812–11409 | 4.70x | 2439 | 38.11x | 0 | yes |
| keyed-prepend | 10 | signals | 2765 | 2628–2974 | 1.15x | 70 | 1.09x | 9 | yes |
| keyed-prepend | 10 | vide | 5168 | 5066–5414 | 2.15x | 638 | 9.97x | 0 | yes |
| keyed-insert | 10 | plain | 1730 | 1632–1801 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 3963 | 3893–4347 | 2.29x | 1505 | 23.52x | 0 | yes |
| keyed-insert | 10 | compose | 3000 | 2765–3088 | 1.73x | 562 | 8.78x | 6 | yes |
| keyed-insert | 10 | fusion (workaround) | 19126 | 18021–19630 | 11.06x | 1536 | 24.00x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 17202 | 16214–17914 | 9.94x | 1514 | 23.66x | 1 | yes |
| keyed-insert | 10 | react | 14208 | 13221–15224 | 8.21x | 803 | 12.55x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13323 | 13034–13957 | 7.70x | 866 | 13.53x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13627 | 13543–14101 | 7.88x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | roact | 5676 | 5320–5730 | 3.28x | 369 | 5.77x | 1 | yes |
| keyed-insert | 10 | seam | 10324 | 9660–10812 | 5.97x | 2463 | 38.48x | 0 | yes |
| keyed-insert | 10 | signals | 1808 | 1792–1914 | 1.04x | 61 | 0.95x | 0 | yes |
| keyed-insert | 10 | vide | 3574 | 3266–3672 | 2.07x | 638 | 9.97x | 0 | yes |
| keyed-shuffle | 10 | plain | 1833 | 1533–2000 | 1.00x | 61 | 1.00x | 1 | yes |
| keyed-shuffle | 10 | blend | 2986 | 2724–2990 | 1.63x | 1440 | 23.61x | 1 | yes |
| keyed-shuffle | 10 | compose | 3160 | 2700–3251 | 1.72x | 562 | 9.21x | 10 | yes |
| keyed-shuffle | 10 | fusion | 19423 | 18305–20526 | 10.59x | 1399 | 22.93x | 8 | yes |
| keyed-shuffle | 10 | fusion-charm | 18002 | 16633–18757 | 9.82x | 1392 | 22.82x | 0 | yes |
| keyed-shuffle | 10 | react | 27732 | 27234–29035 | 15.13x | 779 | 12.77x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27400 | 26730–28246 | 14.95x | 779 | 12.77x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 28794 | 28313–29130 | 15.71x | 779 | 12.77x | 1 | yes |
| keyed-shuffle | 10 | roact | 6008 | 5454–6436 | 3.28x | 360 | 5.90x | 0 | yes |
| keyed-shuffle | 10 | seam | 9552 | 9111–9860 | 5.21x | 2438 | 39.97x | 1 | yes |
| keyed-shuffle | 10 | signals | 2248 | 1916–2318 | 1.23x | 60 | 0.98x | 0 | yes |
| keyed-shuffle | 10 | vide | 3825 | 3616–3883 | 2.09x | 622 | 10.20x | 1 | yes |
| events | 1 | plain | 1223 | 739–1616 | 1.00x | 9 | 1.00x | 0 | yes |
| events | 1 | blend | 1215 | 1045–1490 | 0.99x | 9 | 1.00x | 1 | yes |
| events | 1 | compose | 1400 | 900–1434 | 1.14x | 11 | 1.22x | 2 | yes |
| events | 1 | fusion | 1216 | 811–1739 | 0.99x | 1 | 0.11x | 0 | yes |
| events | 1 | fusion-charm | 1129 | 1000–1333 | 0.92x | 2 | 0.22x | 1 | yes |
| events | 1 | react | 1313 | 1003–1848 | 1.07x | 1 | 0.11x | 0 | yes |
| events | 1 | react-reflex | 1421 | 1025–1500 | 1.16x | 1 | 0.11x | 0 | yes |
| events | 1 | react-upstream | 1300 | 1021–1715 | 1.06x | 9 | 1.00x | 0 | yes |
| events | 1 | roact | 1229 | 901–2000 | 1.00x | 8 | 0.89x | 0 | yes |
| events | 1 | seam | 900 | 400–1117 | 0.74x | 2 | 0.22x | 0 | yes |
| events | 1 | signals | 704 | 700–1110 | 0.58x | 2 | 0.22x | 0 | yes |
| events | 1 | vide | 1100 | 609–1363 | 0.90x | 9 | 1.00x | 0 | yes |
| animate-many | 1 | plain | 3201 | 2550–3463 | 1.00x | 74 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 10156 | 10000–10930 | 3.17x | 1778 | 24.03x | 0 | yes |
| animate-many | 1 | compose | 6224 | 5757–6661 | 1.94x | 745 | 10.07x | 4 | yes |
| animate-many | 1 | fusion | 107358 | 104968–108457 | 33.54x | 1137 | 15.36x | 1 | yes |
| animate-many | 1 | fusion-charm | 105282 | 104214–108045 | 32.89x | 1137 | 15.36x | 0 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20111 | 19630–21836 | 6.28x | 2898 | 39.16x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 8032 | 7200–9056 | 2.51x | 392 | 5.30x | 0 | yes |
| status-panel | 10 | plain | 552 | 511–642 | 1.00x | 11 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 1046 | 919–1154 | 1.89x | 69 | 6.27x | 0 | yes |
| status-panel | 10 | compose | 985 | 850–1203 | 1.78x | 32 | 2.91x | 2 | yes |
| status-panel | 10 | fusion | 1431 | 1204–1571 | 2.59x | 64 | 5.82x | 1 | yes |
| status-panel | 10 | fusion-charm | 1630 | 1374–1928 | 2.95x | 70 | 6.36x | 0 | yes |
| status-panel | 10 | react | 1758 | 1729–2077 | 3.18x | 35 | 3.18x | 0 | yes |
| status-panel | 10 | react-reflex | 1839 | 1770–2308 | 3.33x | 45 | 4.09x | 0 | yes |
| status-panel | 10 | react-upstream | 1952 | 1600–2165 | 3.54x | 43 | 3.91x | 0 | yes |
| status-panel | 10 | roact | 1072 | 951–1100 | 1.94x | 33 | 3.00x | 1 | yes |
| status-panel | 10 | seam | 1724 | 1400–2047 | 3.12x | 140 | 12.73x | 0 | yes |
| status-panel | 10 | signals | 852 | 707–1060 | 1.54x | 15 | 1.36x | 0 | yes |
| status-panel | 10 | vide | 1049 | 902–1226 | 1.90x | 32 | 2.91x | 1 | yes |
| scene-3d | 10 | plain | 2603 | 2503–3007 | 1.00x | 18 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4302 | 4223–4623 | 1.65x | 542 | 30.11x | 0 | yes |
| scene-3d | 10 | compose | 3071 | 2952–3246 | 1.18x | 187 | 10.39x | 2 | yes |
| scene-3d | 10 | fusion | 33652 | 32027–34048 | 12.93x | 512 | 28.44x | 1 | yes |
| scene-3d | 10 | fusion-charm | 30833 | 30625–32371 | 11.85x | 516 | 28.67x | 1 | yes |
| scene-3d | 10 | react | 3505 | 3000–3728 | 1.35x | 223 | 12.39x | 0 | yes |
| scene-3d | 10 | react-reflex | 3020 | 2914–3124 | 1.16x | 232 | 12.89x | 0 | yes |
| scene-3d | 10 | react-upstream | 3470 | 3314–3820 | 1.33x | 223 | 12.39x | 0 | yes |
| scene-3d | 10 | roact | 3224 | 3124–3518 | 1.24x | 574 | 31.89x | 1 | yes |
| scene-3d | 10 | seam | 8801 | 8206–9121 | 3.38x | 1755 | 97.50x | 0 | yes |
| scene-3d | 10 | signals | 5806 | 5600–5843 | 2.23x | 682 | 37.89x | 0 | yes |
| scene-3d | 10 | vide | 3912 | 3760–4108 | 1.50x | 211 | 11.72x | 1 | yes |
| derived-diamond | 3 | plain | 24 | 17–46 | 1.00x | 4 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 109 | 100–147 | 4.64x | 28 | 7.00x | 1 | yes |
| derived-diamond | 3 | compose | 125 | 100–126 | 5.32x | 1 | 0.25x | 1 | yes |
| derived-diamond | 3 | fusion | 125 | 100–181 | 5.32x | 8 | 2.00x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 150 | 125–175 | 6.38x | 11 | 2.75x | 0 | yes |
| derived-diamond | 3 | react | 300 | 203–367 | 12.76x | 6 | 1.50x | 4 | yes |
| derived-diamond | 3 | react-reflex | 302 | 267–436 | 12.86x | 10 | 2.50x | 0 | yes |
| derived-diamond | 3 | react-upstream | 303 | 267–346 | 12.90x | 0 | 0.25x | 0 | yes |
| derived-diamond | 3 | roact | 116 | 100–187 | 4.96x | 10 | 2.50x | 2 | yes |
| derived-diamond | 3 | seam | 150 | 100–203 | 6.38x | 21 | 5.25x | 0 | yes |
| derived-diamond | 3 | signals | 126 | 100–154 | 5.34x | 9 | 2.25x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 100–150 | 4.25x | 6 | 1.50x | 1 | yes |
| derived-chain-100 | 3 | plain | 53 | 46–76 | 1.00x | 65 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 150 | 100–262 | 2.85x | 131 | 2.02x | 10 | yes |
| derived-chain-100 | 3 | fusion | 979 | 876–1083 | 18.56x | 127 | 1.95x | 1 | yes |
| derived-chain-100 | 3 | fusion-charm | 935 | 876–1052 | 17.72x | 129 | 1.98x | 0 | yes |
| derived-chain-100 | 3 | react | 435 | 376–608 | 8.25x | 68 | 1.05x | 12 | yes |
| derived-chain-100 | 3 | react-reflex | 570 | 500–601 | 10.81x | 88 | 1.35x | 22 | yes |
| derived-chain-100 | 3 | react-upstream | 545 | 467–701 | 10.33x | 69 | 1.06x | 11 | yes |
| derived-chain-100 | 3 | roact | 164 | 125–206 | 3.11x | 10 | 0.15x | 3 | yes |
| derived-chain-100 | 3 | seam | 754 | 752–1004 | 14.29x | 272 | 4.18x | 1 | yes |
| derived-chain-100 | 3 | signals | 250 | 156–258 | 4.74x | 166 | 2.55x | 1 | yes |
| derived-chain-100 | 3 | vide | 152 | 126–200 | 2.88x | 92 | 1.42x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 100 | 100–100 | 1.00x | 497 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 228 | 225–300 | 2.27x | 1535 | 3.09x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 370 | 353–425 | 3.69x | 687 | 1.38x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion | 2091 | 2070–2143 | 20.91x | 889 | 1.79x | 1 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2143 | 1967–2240 | 21.43x | 2806 | 5.65x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 3104 | 2502–3410 | 31.04x | 671 | 1.35x | 60 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 7311 | 6906–7600 | 73.11x | 5621 | 11.31x | 78 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2461 | 2350–3101 | 24.61x | 655 | 1.32x | 28 | yes |
| derived-fan-in-1000 | 3 | roact | 528 | 500–559 | 5.28x | 105 | 0.21x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 2816 | 2650–3004 | 28.16x | 2938 | 5.91x | 8 | yes |
| derived-fan-in-1000 | 3 | signals | 756 | 680–836 | 7.56x | 1196 | 2.41x | 0 | yes |
| derived-fan-in-1000 | 3 | vide | 553 | 500–601 | 5.53x | 520 | 1.05x | 0 | yes |
| filter-as-you-type | 1 | plain | 9118 | 7109–9248 | 1.00x | 34 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16432 | 15621–18209 | 1.80x | 2662 | 78.29x | 0 | yes |
| filter-as-you-type | 1 | compose | 10823 | 9931–11150 | 1.19x | 825 | 24.26x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 27615 | 26708–31834 | 3.03x | 2457 | 72.26x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 27046 | 25911–27645 | 2.97x | 2459 | 72.32x | 1 | yes |
| filter-as-you-type | 1 | react | 21219 | 20251–21641 | 2.33x | 84 | 2.47x | 20 | yes |
| filter-as-you-type | 1 | react-reflex | 21489 | 20651–22293 | 2.36x | 830 | 24.41x | 15 | yes |
| filter-as-you-type | 1 | react-upstream | 21092 | 19446–21638 | 2.31x | 60 | 1.76x | 4 | yes |
| filter-as-you-type | 1 | roact | 11647 | 11530–11925 | 1.28x | 495 | 14.56x | 11 | yes |
| filter-as-you-type | 1 | seam | 26564 | 20236–29389 | 2.91x | 4013 | 118.03x | 1 | yes |
| filter-as-you-type | 1 | signals | 7519 | 7329–8133 | 0.82x | 37 | 1.09x | 0 | yes |
| filter-as-you-type | 1 | vide | 11145 | 10411–11788 | 1.22x | 967 | 28.44x | 0 | yes |
| theme-propagation | 3 | plain | 48477 | 47352–48982 | 1.00x | 205 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 47131 | 45357–47970 | 0.97x | 2077 | 10.13x | 0 | yes |
| theme-propagation | 3 | compose | 50536 | 50030–50659 | 1.04x | 576 | 2.81x | 2 | yes |
| theme-propagation | 3 | fusion | 52167 | 51265–53372 | 1.08x | 883 | 4.31x | 9 | yes |
| theme-propagation | 3 | fusion-charm | 52644 | 51051–53826 | 1.09x | 869 | 4.24x | 1 | yes |
| theme-propagation | 3 | react | 52547 | 52339–53226 | 1.08x | 2035 | 9.93x | 0 | yes |
| theme-propagation | 3 | react-reflex | 46994 | 45521–47501 | 0.97x | 2029 | 9.90x | 0 | yes |
| theme-propagation | 3 | react-upstream | 53034 | 52404–55639 | 1.09x | 2020 | 9.85x | 1 | yes |
| theme-propagation | 3 | roact | 49616 | 48120–50727 | 1.02x | 3278 | 15.99x | 0 | yes |
| theme-propagation | 3 | seam | 45968 | 45792–46154 | 0.95x | 3478 | 16.97x | 1 | yes |
| theme-propagation | 3 | signals | 51734 | 50664–52183 | 1.07x | 904 | 4.41x | 0 | yes |
| theme-propagation | 3 | vide | 50472 | 48627–51902 | 1.04x | 591 | 2.88x | 0 | yes |
| hud-per-frame | 1 | plain | 2544 | 1572–2828 | 1.00x | 23 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 4404 | 4035–5348 | 1.73x | 71 | 3.09x | 0 | yes |
| hud-per-frame | 1 | compose | 4457 | 4232–4603 | 1.75x | 27 | 1.17x | 0 | yes |
| hud-per-frame | 1 | fusion | 10558 | 10497–10689 | 4.15x | 47 | 2.04x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 12999 | 12981–13148 | 5.11x | 94 | 4.11x | 0 | yes |
| hud-per-frame | 1 | react | 4643 | 3628–5123 | 1.82x | 26 | 1.11x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 6785 | 6231–6848 | 2.67x | 53 | 2.30x | 4 | yes |
| hud-per-frame | 1 | react-upstream | 4537 | 3624–4663 | 1.78x | 34 | 1.48x | 0 | yes |
| hud-per-frame | 1 | roact | 4009 | 3581–4496 | 1.58x | 93 | 4.04x | 0 | yes |
| hud-per-frame | 1 | seam | 8100 | 7544–8769 | 3.18x | 169 | 7.35x | 0 | yes |
| hud-per-frame | 1 | signals | 4886 | 4711–4927 | 1.92x | 60 | 2.63x | 0 | yes |
| hud-per-frame | 1 | vide | 5188 | 4752–5224 | 2.04x | 18 | 0.80x | 0 | yes |
| teardown-under-load | 1 | plain | 46565 | 44048–52113 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 73351 | 66328–82620 | 1.58x | 14 | 2.80x | 1 | yes |
| teardown-under-load | 1 | compose | 56300 | 47277–59466 | 1.21x | 7 | 1.40x | 9 | yes |
| teardown-under-load | 1 | fusion | 77307 | 70986–83432 | 1.66x | 5 | 1.00x | 1 | yes |
| teardown-under-load | 1 | fusion-charm | 76714 | 74834–82942 | 1.65x | 6 | 1.20x | 0 | yes |
| teardown-under-load | 1 | react | 72690 | 70604–82334 | 1.56x | 1077 | 215.40x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 75567 | 73891–79585 | 1.62x | 1071 | 214.20x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 77398 | 75867–78602 | 1.66x | 1078 | 215.60x | 0 | yes |
| teardown-under-load | 1 | roact | 70412 | 57148–73125 | 1.51x | 71 | 14.20x | 0 | yes |
| teardown-under-load | 1 | seam | 64098 | 56726–71980 | 1.38x | 7 | 1.40x | 7 | yes |
| teardown-under-load | 1 | signals | 58390 | 52214–61616 | 1.25x | 13 | 2.60x | 8 | yes |
| teardown-under-load | 1 | vide | 58668 | 53359–61456 | 1.26x | 12 | 2.40x | 9 | yes |
| open-close-retention | 1 | plain | 65918 | 64608–68227 | 1.00x | 40 | 1.00x | 1 | yes |
| open-close-retention | 1 | blend | 118874 | 118343–120113 | 1.80x | 14 | 0.35x | 8 | yes |
| open-close-retention | 1 | compose | 82583 | 80638–83431 | 1.25x | 15 | 0.38x | 2 | yes |
| open-close-retention | 1 | fusion | 132338 | 130388–136274 | 2.01x | 13 | 0.33x | 8 | yes |
| open-close-retention | 1 | fusion-charm | 134394 | 132644–137565 | 2.04x | 15 | 0.38x | 1 | yes |
| open-close-retention | 1 | react | 118136 | 117379–118642 | 1.79x | 276 | 6.89x | 0 | yes |
| open-close-retention | 1 | react-reflex | 116491 | 116194–117524 | 1.77x | 292 | 7.30x | 0 | yes |
| open-close-retention | 1 | react-upstream | 116897 | 116827–117858 | 1.77x | 283 | 7.08x | 0 | yes |
| open-close-retention | 1 | roact | 108793 | 108742–109101 | 1.65x | 23 | 0.57x | 2 | yes |
| open-close-retention | 1 | seam | 112395 | 108979–112733 | 1.71x | 10 | 0.25x | 1 | yes |
| open-close-retention | 1 | signals | 83235 | 81587–83582 | 1.26x | 13 | 0.33x | 0 | yes |
| open-close-retention | 1 | vide | 87143 | 86352–88651 | 1.32x | 4 | 0.10x | 0 | yes |
| tree-expand-collapse | 1 | plain | 12113 | 11202–12310 | 1.00x | 12 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 19723 | 19021–20567 | 1.63x | 796 | 66.33x | 0 | yes |
| tree-expand-collapse | 1 | compose | 11618 | 11402–11915 | 0.96x | 63 | 5.25x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24140 | 23430–27551 | 1.99x | 156 | 13.00x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23441 | 21415–26323 | 1.94x | 279 | 23.25x | 0 | yes |
| tree-expand-collapse | 1 | react | 19208 | 18440–20394 | 1.59x | 78 | 6.50x | 28 | yes |
| tree-expand-collapse | 1 | react-reflex | 19752 | 18008–19951 | 1.63x | 673 | 56.08x | 30 | yes |
| tree-expand-collapse | 1 | react-upstream | 19212 | 17829–19648 | 1.59x | 69 | 5.75x | 19 | yes |
| tree-expand-collapse | 1 | roact | 10714 | 10315–11019 | 0.88x | 35 | 2.92x | 3 | yes |
| tree-expand-collapse | 1 | seam | 25242 | 23057–27568 | 2.08x | 149 | 12.42x | 1 | yes |
| tree-expand-collapse | 1 | signals | 8204 | 7915–8353 | 0.68x | 21 | 1.75x | 0 | yes |
| tree-expand-collapse | 1 | vide | 11844 | 11312–12208 | 0.98x | 71 | 5.92x | 1 | yes |
| form-validation | 1 | plain | 2601 | 2476–3179 | 1.00x | 54 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 3695 | 3315–3822 | 1.42x | 336 | 6.22x | 1 | yes |
| form-validation | 1 | compose | 3219 | 2909–3664 | 1.24x | 98 | 1.81x | 0 | yes |
| form-validation | 1 | fusion | 4584 | 4085–4890 | 1.76x | 119 | 2.20x | 1 | yes |
| form-validation | 1 | fusion-charm | 4836 | 4654–5335 | 1.86x | 155 | 2.87x | 0 | yes |
| form-validation | 1 | react | 4013 | 3949–4409 | 1.54x | 65 | 1.20x | 0 | yes |
| form-validation | 1 | react-reflex | 4987 | 4837–5172 | 1.92x | 75 | 1.39x | 1 | yes |
| form-validation | 1 | react-upstream | 4308 | 3818–4465 | 1.66x | 65 | 1.20x | 0 | yes |
| form-validation | 1 | roact | 4201 | 3680–4790 | 1.62x | 223 | 4.13x | 0 | yes |
| form-validation | 1 | seam | 5315 | 5155–5842 | 2.04x | 349 | 6.46x | 0 | yes |
| form-validation | 1 | signals | 3433 | 2942–3724 | 1.32x | 155 | 2.87x | 0 | yes |
| form-validation | 1 | vide | 3527 | 3038–3910 | 1.36x | 70 | 1.30x | 0 | yes |
| table-sort-filter | 1 | plain | 18018 | 16718–19262 | 1.00x | 74 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 38219 | 33535–43030 | 2.12x | 5371 | 72.58x | 1 | yes |
| table-sort-filter | 1 | compose | 24915 | 23906–25938 | 1.38x | 1616 | 21.84x | 18 | yes |
| table-sort-filter | 1 | fusion (workaround) | 56868 | 48832–58235 | 3.16x | 4695 | 63.45x | 0 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 53847 | 44757–60922 | 2.99x | 4713 | 63.69x | 2 | yes |
| table-sort-filter | 1 | react | 100784 | 98117–103485 | 5.59x | 2101 | 28.39x | 12 | yes |
| table-sort-filter | 1 | react-reflex | 99786 | 96267–102979 | 5.54x | 2115 | 28.58x | 15 | yes |
| table-sort-filter | 1 | react-upstream | 99574 | 91848–102265 | 5.53x | 2100 | 28.38x | 11 | yes |
| table-sort-filter | 1 | roact | 25842 | 24508–26110 | 1.43x | 1007 | 13.61x | 4 | yes |
| table-sort-filter | 1 | seam | 54480 | 50751–66581 | 3.02x | 7751 | 104.74x | 1 | yes |
| table-sort-filter | 1 | signals | 18058 | 17719–18906 | 1.00x | 67 | 0.91x | 0 | yes |
| table-sort-filter | 1 | vide | 25167 | 24141–25824 | 1.40x | 1914 | 25.86x | 0 | yes |
| library-load | 1 | plain | 35 | 32–40 | 1.00x | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 763 | 660–781 | 22.00x | 467 | 467.00x | 464 | yes |
| library-load | 1 | compose | 654 | 642–683 | 18.84x | 66 | 66.00x | 64 | yes |
| library-load | 1 | fusion | 1339 | 1254–1518 | 38.56x | 263 | 263.00x | 262 | yes |
| library-load | 1 | fusion-charm | 1590 | 1314–1686 | 45.80x | 326 | 326.00x | 324 | yes |
| library-load | 1 | react | 4702 | 4371–4901 | 135.47x | 1825 | 1825.00x | 1824 | yes |
| library-load | 1 | react-reflex | 5045 | 4736–5270 | 145.37x | 1981 | 1981.00x | 1980 | yes |
| library-load | 1 | react-upstream | 4824 | 4477–5086 | 138.98x | 2003 | 2003.00x | 2002 | yes |
| library-load | 1 | roact | 440 | 380–452 | 12.68x | 146 | 146.00x | 143 | yes |
| library-load | 1 | seam | 1174 | 1065–1268 | 33.82x | 243 | 243.00x | 240 | yes |
| library-load | 1 | signals | 252 | 237–347 | 7.27x | 50 | 50.00x | 40 | yes |
| library-load | 1 | vide | 351 | 338–357 | 10.11x | 146 | 146.00x | 146 | yes |
| rows-append-1000 | 1 | plain | 90937 | 90402–97518 | 1.00x | 6524 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 160911 | 149515–169950 | 1.77x | 38434 | 5.89x | 8 | yes |
| rows-append-1000 | 1 | compose | 116615 | 102799–120361 | 1.28x | 10975 | 1.68x | 2 | yes |
| rows-append-1000 | 1 | fusion | 357258 | 351625–361083 | 3.93x | 20793 | 3.19x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 362618 | 356836–365420 | 3.99x | 29002 | 4.45x | 0 | yes |
| rows-append-1000 | 1 | react | 191428 | 184205–209530 | 2.11x | 23281 | 3.57x | 48 | yes |
| rows-append-1000 | 1 | react-reflex | 212738 | 180640–224425 | 2.34x | 24903 | 3.82x | 12 | yes |
| rows-append-1000 | 1 | react-upstream | 193872 | 184133–242972 | 2.13x | 22904 | 3.51x | 0 | yes |
| rows-append-1000 | 1 | roact | 153339 | 143828–195845 | 1.69x | 33283 | 5.10x | 8 | yes |
| rows-append-1000 | 1 | seam | 171183 | 134868–177380 | 1.88x | 46927 | 7.19x | 1 | yes |
| rows-append-1000 | 1 | signals | 109583 | 100225–155396 | 1.21x | 17373 | 2.66x | 1 | yes |
| rows-append-1000 | 1 | vide | 116000 | 108144–151969 | 1.28x | 10415 | 1.60x | 1 | yes |
| rows-clear | 1 | plain | 18824 | 17725–18905 | 1.00x | 1229 | 1.00x | 8 | yes |
| rows-clear | 1 | blend | 35452 | 35282–36852 | 1.88x | 4090 | 3.33x | 1 | yes |
| rows-clear | 1 | compose | 25369 | 25116–25644 | 1.35x | 1877 | 1.53x | 10 | yes |
| rows-clear | 1 | fusion | 80935 | 74341–82153 | 4.30x | 3489 | 2.84x | 8 | yes |
| rows-clear | 1 | fusion-charm | 73783 | 71457–76348 | 3.92x | 7408 | 6.03x | 0 | yes |
| rows-clear | 1 | react | 25247 | 24513–26828 | 1.34x | 4504 | 3.66x | 1 | yes |
| rows-clear | 1 | react-reflex | 28509 | 26224–29144 | 1.51x | 6489 | 5.28x | 36 | yes |
| rows-clear | 1 | react-upstream | 25438 | 23126–26846 | 1.35x | 4487 | 3.65x | 0 | yes |
| rows-clear | 1 | roact | 24839 | 23614–27459 | 1.32x | 4214 | 3.43x | 1 | yes |
| rows-clear | 1 | seam | 36063 | 29440–45121 | 1.92x | 9128 | 7.43x | 0 | yes |
| rows-clear | 1 | signals | 21709 | 21513–23358 | 1.15x | 4458 | 3.63x | 0 | yes |
| rows-clear | 1 | vide | 20039 | 19838–21354 | 1.06x | 1605 | 1.31x | 0 | yes |
| rows-create-1000 | 1 | plain | 93073 | 91297–93995 | 1.00x | 3135 | 1.00x | 1 | yes |
| rows-create-1000 | 1 | blend | 149936 | 130692–162514 | 1.61x | 19713 | 6.29x | 0 | yes |
| rows-create-1000 | 1 | compose | 108988 | 106029–138542 | 1.17x | 5810 | 1.85x | 2 | yes |
| rows-create-1000 | 1 | fusion | 196822 | 180996–209690 | 2.11x | 10955 | 3.49x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 197206 | 182850–201085 | 2.12x | 14796 | 4.72x | 0 | yes |
| rows-create-1000 | 1 | react | 166909 | 161032–185342 | 1.79x | 8136 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 174714 | 168701–195085 | 1.88x | 9066 | 2.89x | 29 | yes |
| rows-create-1000 | 1 | react-upstream | 161446 | 158246–167883 | 1.73x | 8136 | 2.60x | 0 | yes |
| rows-create-1000 | 1 | roact | 126377 | 120167–137135 | 1.36x | 16930 | 5.40x | 1 | yes |
| rows-create-1000 | 1 | seam | 154729 | 125554–168684 | 1.66x | 23861 | 7.61x | 0 | yes |
| rows-create-1000 | 1 | signals | 103877 | 95887–107088 | 1.12x | 9106 | 2.90x | 1 | yes |
| rows-create-1000 | 1 | vide | 111351 | 104162–129289 | 1.20x | 4963 | 1.58x | 1 | yes |
| rows-create-10000 | 1 | plain | 1164698 | 1129377–1307175 | 1.00x | 29796 | 1.00x | 4 | yes |
| rows-create-10000 | 1 | blend | 1784581 | 1698621–1833438 | 1.53x | 187037 | 6.28x | 4 | yes |
| rows-create-10000 | 1 | compose | 1417810 | 1382109–1440464 | 1.22x | 55490 | 1.86x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6983580 | 6551585–7082174 | 6.00x | 101180 | 3.40x | 0 | yes |
| rows-create-10000 | 1 | fusion-charm | 6785887 | 6775072–6800001 | 5.83x | 145071 | 4.87x | 8 | yes |
| rows-create-10000 | 1 | react | 5069885 | 4722957–5087503 | 4.35x | 77531 | 2.60x | 600 | yes |
| rows-create-10000 | 1 | react-reflex | 5213151 | 5184617–5230574 | 4.48x | 87473 | 2.94x | 678 | yes |
| rows-create-10000 | 1 | react-upstream | 4892729 | 4863098–5089149 | 4.20x | 78078 | 2.62x | 76 | yes |
| rows-create-10000 | 1 | roact | 1537565 | 1458618–1566252 | 1.32x | 165722 | 5.56x | 0 | yes |
| rows-create-10000 | 1 | seam | 1755895 | 1714844–1767536 | 1.51x | 235019 | 7.89x | 16 | yes |
| rows-create-10000 | 1 | signals | 1298393 | 1262880–1440993 | 1.11x | 89217 | 2.99x | 8 | yes |
| rows-create-10000 | 1 | vide | 1338524 | 1280323–1450308 | 1.15x | 48448 | 1.63x | 0 | yes |
| rows-remove-one | 1 | plain | 800 | 602–936 | 1.00x | 2741 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1250 | 1200–1350 | 1.56x | 18300 | 6.68x | 0 | yes |
| rows-remove-one | 1 | compose | 900 | 807–1134 | 1.12x | 4924 | 1.80x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 64757 | 61989–70261 | 80.95x | 11121 | 4.06x | 0 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 58984 | 58579–60030 | 73.73x | 15050 | 5.49x | 1 | yes |
| rows-remove-one | 1 | react | 34374 | 23608–40526 | 42.97x | 15525 | 5.66x | 23 | yes |
| rows-remove-one | 1 | react-reflex | 32826 | 30625–45561 | 41.03x | 16430 | 5.99x | 37 | yes |
| rows-remove-one | 1 | react-upstream | 26547 | 23610–51840 | 33.18x | 15468 | 5.64x | 0 | yes |
| rows-remove-one | 1 | roact | 17410 | 15307–43107 | 21.76x | 16773 | 6.12x | 1 | yes |
| rows-remove-one | 1 | seam | 5710 | 4801–7016 | 7.14x | 23221 | 8.47x | 0 | yes |
| rows-remove-one | 1 | signals | 1573 | 1334–1634 | 1.97x | 8621 | 3.15x | 0 | yes |
| rows-remove-one | 1 | vide | 1304 | 1109–1400 | 1.63x | 4553 | 1.66x | 1 | yes |
| rows-swap | 1 | plain | 100 | 100–133 | 1.00x | 2687 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 752 | 650–800 | 7.51x | 18262 | 6.80x | 0 | yes |
| rows-swap | 1 | compose | 300 | 200–367 | 3.00x | 4895 | 1.82x | 3 | yes |
| rows-swap | 1 | fusion | 60263 | 59720–63777 | 602.63x | 9568 | 3.56x | 1 | yes |
| rows-swap | 1 | fusion-charm | 58282 | 55138–60299 | 582.82x | 14587 | 5.43x | 8 | yes |
| rows-swap | 1 | react | 61667 | 53400–68730 | 616.67x | 15433 | 5.74x | 0 | yes |
| rows-swap | 1 | react-reflex | 68560 | 65611–75597 | 685.60x | 16385 | 6.10x | 27 | yes |
| rows-swap | 1 | react-upstream | 59135 | 56729–78228 | 591.35x | 15089 | 5.62x | 8 | yes |
| rows-swap | 1 | roact | 17207 | 14750–34516 | 172.07x | 16308 | 6.07x | 0 | yes |
| rows-swap | 1 | seam | 5400 | 4503–5625 | 54.00x | 23219 | 8.64x | 0 | yes |
| rows-swap | 1 | signals | 635 | 467–801 | 6.35x | 8618 | 3.21x | 1 | yes |
| rows-swap | 1 | vide | 250 | 150–350 | 2.50x | 4516 | 1.68x | 0 | yes |
| rows-update-every-10th | 1 | plain | 2000 | 1869–2068 | 1.00x | 3191 | 1.00x | 8 | yes |
| rows-update-every-10th | 1 | blend | 1904 | 1850–2002 | 0.95x | 19272 | 6.04x | 0 | yes |
| rows-update-every-10th | 1 | compose | 2035 | 1968–2104 | 1.02x | 5448 | 1.71x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 2000 | 1800–2200 | 1.00x | 10560 | 3.31x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2306 | 2200–2627 | 1.15x | 14464 | 4.53x | 1 | yes |
| rows-update-every-10th | 1 | react | 2102 | 1900–2200 | 1.05x | 7837 | 2.46x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 4007 | 3502–4403 | 2.00x | 8822 | 2.76x | 13 | yes |
| rows-update-every-10th | 1 | react-upstream | 2001 | 1901–2152 | 1.00x | 7902 | 2.48x | 0 | yes |
| rows-update-every-10th | 1 | roact | 1952 | 1902–2150 | 0.98x | 16689 | 5.23x | 0 | yes |
| rows-update-every-10th | 1 | seam | 4584 | 4200–5034 | 2.29x | 24204 | 7.59x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2105 | 1968–2274 | 1.05x | 9362 | 2.93x | 0 | yes |
| rows-update-every-10th | 1 | vide | 1904 | 1834–2104 | 0.95x | 5124 | 1.61x | 0 | yes |

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
| blend | 29 | 2.31x | 9.16x | 2.28x | 8.85x |
| compose | 30 | 1.74x | 3.04x | 1.70x | 2.96x |
| fusion | 30 | 6.63x | 4.81x | 6.03x | 4.76x |
| fusion-charm | 30 | 6.11x | 6.41x | 5.54x | 6.48x |
| react | 29 | 4.92x | 4.95x | 4.83x | 5.23x |
| react-reflex | 29 | 5.41x | 7.72x | 5.28x | 8.21x |
| react-upstream | 29 | 4.92x | 5.01x | 4.79x | 5.29x |
| roact | 29 | 2.75x | 4.92x | 2.74x | 5.57x |
| seam | 30 | 3.86x | 9.92x | 3.62x | 9.75x |
| signals | 29 | 1.78x | 2.27x | 1.72x | 2.26x |
| vide | 30 | 1.85x | 2.50x | 1.80x | 2.49x |
