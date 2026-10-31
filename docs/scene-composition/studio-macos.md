# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, in KiB. Teardown is the median retained heap after release. Both use the Verify `gc-witness-low-water/2` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | Apple M2 Max |
| Cores | 12 |
| Memory | 32 GiB |
| Model | Mac14,13 |
| Operating system | macOS 27.0 |
| Roblox Studio | 0.745.0.7451137 |
| Context | client |
| Harness revision | `ee9f86b` |
| Date | 2026-10-31 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 300 | 208–304 | 1.00x | 17 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 805 | 700–907 | 2.68x | 741 | 43.59x | 0 | yes |
| update-leaf | 20 | compose | 1000 | 800–1100 | 3.33x | 93 | 5.47x | 1 | yes |
| update-leaf | 20 | fusion | 1012 | 700–2502 | 3.37x | 116 | 6.82x | 0 | yes |
| update-leaf | 20 | fusion-charm | 1000 | 500–1400 | 3.33x | 117 | 6.88x | 0 | yes |
| update-leaf | 20 | react | 801 | 500–1200 | 2.67x | 292 | 17.18x | 0 | yes |
| update-leaf | 20 | react-reflex | 1020 | 800–1428 | 3.40x | 293 | 17.24x | 0 | yes |
| update-leaf | 20 | react-upstream | 900 | 400–1200 | 3.00x | 292 | 17.18x | 0 | yes |
| update-leaf | 20 | roact | 600 | 509–1000 | 2.00x | 960 | 56.47x | 0 | yes |
| update-leaf | 20 | seam | 1200 | 1000–1700 | 4.00x | 33 | 1.94x | 0 | yes |
| update-leaf | 20 | signals | 903 | 700–1000 | 3.01x | 51 | 3.00x | 0 | yes |
| update-leaf | 20 | vide | 1000 | 600–1000 | 3.33x | 11 | 0.65x | 0 | yes |
| update-batched | 20 | plain | 4608 | 4406–4800 | 1.00x | 20 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 10812 | 10506–10930 | 2.35x | 916 | 45.80x | 0 | yes |
| update-batched | 20 | compose | 7114 | 6704–7608 | 1.54x | 336 | 16.80x | 9 | yes |
| update-batched | 20 | fusion | 21420 | 20842–23007 | 4.65x | 524 | 26.20x | 0 | yes |
| update-batched | 20 | fusion-charm | 38643 | 37241–39868 | 8.39x | 1118 | 55.90x | 0 | yes |
| update-batched | 20 | react | 8007 | 7763–9005 | 1.74x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | react-reflex | 58265 | 57360–60967 | 12.64x | 784 | 39.20x | 16 | yes |
| update-batched | 20 | react-upstream | 8006 | 7101–9066 | 1.74x | 469 | 23.45x | 0 | yes |
| update-batched | 20 | roact | 8344 | 7717–10205 | 1.81x | 1178 | 58.90x | 1 | yes |
| update-batched | 20 | seam | 13008 | 11706–13945 | 2.82x | 1848 | 92.40x | 0 | yes |
| update-batched | 20 | signals | 10016 | 9731–11330 | 2.17x | 597 | 29.85x | 0 | yes |
| update-batched | 20 | vide | 9357 | 8613–10200 | 2.03x | 332 | 16.60x | 0 | yes |
| update-repeated | 10 | plain | 0 | 0–0 | plain below resolution | 2 | 1.00x | 0 | yes |
| update-repeated | 10 | blend | 3400 | 3200–3506 | plain below resolution | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 400 | 400–707 | plain below resolution | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 26522 | 25914–29611 | plain below resolution | 12 | 6.00x | 8 | yes |
| update-repeated | 10 | fusion-charm | 1100 | 1002–1404 | plain below resolution | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 7405 | 6821–7805 | plain below resolution | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 900 | 700–1318 | plain below resolution | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 7613 | 7316–9315 | plain below resolution | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 5429 | 5019–5704 | plain below resolution | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1800 | 1410–1900 | plain below resolution | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | signals | 800 | 700–1008 | plain below resolution | 13 | 6.50x | 9 | yes |
| update-repeated | 10 | vide | 526 | 400–603 | plain below resolution | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 13105 | 10903–14821 | 1.00x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 16353 | 15606–18719 | 1.25x | 43 | 21.50x | 1 | yes |
| branch-swap | 20 | compose | 13930 | 13257–15281 | 1.06x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | fusion | 14210 | 13701–17207 | 1.08x | 5 | 2.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 14167 | 13529–14829 | 1.08x | 7 | 3.50x | 0 | yes |
| branch-swap | 20 | react | 16055 | 15827–20737 | 1.23x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 16504 | 16259–20658 | 1.26x | 19 | 9.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 16280 | 15815–19471 | 1.24x | 18 | 9.00x | 0 | yes |
| branch-swap | 20 | roact | 14839 | 14515–17849 | 1.13x | 12 | 6.00x | 0 | yes |
| branch-swap | 20 | seam | 12063 | 11530–14231 | 0.92x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | signals | 13081 | 11979–14108 | 1.00x | 5 | 2.50x | 8 | yes |
| branch-swap | 20 | vide | 13886 | 13605–17407 | 1.06x | 5 | 2.50x | 0 | yes |
| keyed-prepend | 10 | plain | 2302 | 2200–2505 | 1.00x | 56 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4745 | 4500–5501 | 2.06x | 1514 | 27.04x | 0 | yes |
| keyed-prepend | 10 | compose | 4220 | 3904–4738 | 1.83x | 546 | 9.75x | 9 | yes |
| keyed-prepend | 10 | fusion (workaround) | 23808 | 22133–24248 | 10.34x | 1551 | 27.70x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 23104 | 20637–23518 | 10.04x | 1553 | 27.73x | 9 | yes |
| keyed-prepend | 10 | react | 16714 | 15709–18030 | 7.26x | 793 | 14.16x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 16216 | 15806–18624 | 7.04x | 785 | 14.02x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 16002 | 15622–18423 | 6.95x | 793 | 14.16x | 8 | yes |
| keyed-prepend | 10 | roact | 7206 | 6800–8127 | 3.13x | 369 | 6.59x | 0 | yes |
| keyed-prepend | 10 | seam | 12213 | 11411–12814 | 5.31x | 2471 | 44.12x | 0 | yes |
| keyed-prepend | 10 | signals | 2921 | 2700–3200 | 1.27x | 62 | 1.11x | 0 | yes |
| keyed-prepend | 10 | vide | 5407 | 5117–6210 | 2.35x | 654 | 11.68x | 8 | yes |
| keyed-insert | 10 | plain | 1504 | 1400–1715 | 1.00x | 65 | 1.00x | 1 | yes |
| keyed-insert | 10 | blend | 4620 | 4209–4714 | 3.07x | 1514 | 23.29x | 0 | yes |
| keyed-insert | 10 | compose | 2779 | 2263–3204 | 1.85x | 527 | 8.11x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 18673 | 18013–19333 | 12.42x | 1543 | 23.74x | 0 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 18109 | 17273–19437 | 12.04x | 1529 | 23.52x | 1 | yes |
| keyed-insert | 10 | react | 13651 | 13311–16621 | 9.08x | 819 | 12.60x | 0 | yes |
| keyed-insert | 10 | react-reflex | 13608 | 13458–14873 | 9.05x | 811 | 12.48x | 0 | yes |
| keyed-insert | 10 | react-upstream | 13816 | 13713–14059 | 9.19x | 810 | 12.46x | 0 | yes |
| keyed-insert | 10 | roact | 5778 | 5390–6282 | 3.84x | 369 | 5.68x | 0 | yes |
| keyed-insert | 10 | seam | 10393 | 9520–11233 | 6.91x | 2480 | 38.15x | 1 | yes |
| keyed-insert | 10 | signals | 2117 | 2020–2433 | 1.41x | 61 | 0.94x | 0 | yes |
| keyed-insert | 10 | vide | 3831 | 3418–3934 | 2.55x | 654 | 10.06x | 8 | yes |
| keyed-shuffle | 10 | plain | 1800 | 1600–2000 | 1.00x | 68 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3100 | 2900–3414 | 1.72x | 1456 | 21.41x | 0 | yes |
| keyed-shuffle | 10 | compose | 2712 | 2700–3236 | 1.51x | 538 | 7.91x | 9 | yes |
| keyed-shuffle | 10 | fusion | 18922 | 17319–20922 | 10.51x | 1406 | 20.68x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 18468 | 17921–20076 | 10.26x | 1408 | 20.71x | 0 | yes |
| keyed-shuffle | 10 | react | 27539 | 25543–29070 | 15.30x | 787 | 11.57x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 27735 | 26225–28959 | 15.41x | 788 | 11.59x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 27864 | 27291–29855 | 15.48x | 779 | 11.46x | 0 | yes |
| keyed-shuffle | 10 | roact | 5759 | 5705–6605 | 3.20x | 369 | 5.43x | 1 | yes |
| keyed-shuffle | 10 | seam | 9406 | 8472–9895 | 5.23x | 2463 | 36.22x | 0 | yes |
| keyed-shuffle | 10 | signals | 2051 | 1951–2302 | 1.14x | 60 | 0.88x | 0 | yes |
| keyed-shuffle | 10 | vide | 3917 | 3600–4175 | 2.18x | 637 | 9.37x | 0 | yes |
| events | 1 | plain | 1205 | 600–1500 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | blend | 1106 | 900–1200 | 0.92x | 1 | 1.00x | 0 | yes |
| events | 1 | compose | 1000 | 800–1500 | 0.83x | 3 | 3.00x | 2 | yes |
| events | 1 | fusion | 1001 | 700–1430 | 0.83x | 1 | 1.00x | 0 | yes |
| events | 1 | fusion-charm | 1100 | 600–1400 | 0.91x | 1 | 1.00x | 0 | yes |
| events | 1 | react | 1200 | 1100–1600 | 1.00x | 1 | 1.00x | 8 | yes |
| events | 1 | react-reflex | 1200 | 903–1800 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | react-upstream | 1300 | 900–2009 | 1.08x | 1 | 1.00x | 0 | yes |
| events | 1 | roact | 1201 | 804–1600 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | seam | 805 | 700–1000 | 0.67x | 1 | 1.00x | 8 | yes |
| events | 1 | signals | 900 | 700–1700 | 0.75x | 1 | 1.00x | 0 | yes |
| events | 1 | vide | 1500 | 1300–1600 | 1.24x | 2 | 2.00x | 0 | yes |
| animate-many | 1 | plain | 2902 | 2604–3517 | 1.00x | 49 | 1.00x | 1 | yes |
| animate-many | 1 | blend | 11724 | 11224–13848 | 4.04x | 1795 | 36.63x | 0 | yes |
| animate-many | 1 | compose | 7215 | 6675–7403 | 2.49x | 872 | 17.80x | 10 | yes |
| animate-many | 1 | fusion | 117623 | 116629–121865 | 40.53x | 1144 | 23.35x | 0 | yes |
| animate-many | 1 | fusion-charm | 107871 | 105287–111215 | 37.17x | 1147 | 23.41x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 19727 | 18368–21342 | 6.80x | 2922 | 59.63x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 7865 | 7301–9454 | 2.71x | 392 | 8.00x | 0 | yes |
| status-panel | 10 | plain | 613 | 600–700 | 1.00x | 2 | 1.00x | 0 | yes |
| status-panel | 10 | blend | 1110 | 1016–1721 | 1.81x | 69 | 34.50x | 0 | yes |
| status-panel | 10 | compose | 900 | 700–1000 | 1.47x | 33 | 16.50x | 1 | yes |
| status-panel | 10 | fusion | 1600 | 1400–1806 | 2.61x | 72 | 36.00x | 1 | yes |
| status-panel | 10 | fusion-charm | 1600 | 1500–1808 | 2.61x | 69 | 34.50x | 2 | yes |
| status-panel | 10 | react | 1802 | 1605–2701 | 2.94x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | react-reflex | 1906 | 1800–2900 | 3.11x | 43 | 21.50x | 0 | yes |
| status-panel | 10 | react-upstream | 2000 | 1800–2700 | 3.26x | 42 | 21.00x | 0 | yes |
| status-panel | 10 | roact | 805 | 500–1100 | 1.31x | 34 | 17.00x | 7 | yes |
| status-panel | 10 | seam | 1600 | 1200–2105 | 2.61x | 140 | 70.00x | 0 | yes |
| status-panel | 10 | signals | 800 | 600–1303 | 1.31x | 15 | 7.50x | 1 | yes |
| status-panel | 10 | vide | 1004 | 900–1400 | 1.64x | 24 | 12.00x | 0 | yes |
| scene-3d | 10 | plain | 2200 | 2100–2303 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4300 | 4216–4803 | 1.95x | 566 | 51.45x | 0 | yes |
| scene-3d | 10 | compose | 3300 | 3113–3700 | 1.50x | 212 | 19.27x | 1 | yes |
| scene-3d | 10 | fusion | 30232 | 29676–33062 | 13.74x | 528 | 48.00x | 1 | yes |
| scene-3d | 10 | fusion-charm | 30652 | 29419–31733 | 13.93x | 540 | 49.09x | 1 | yes |
| scene-3d | 10 | react | 3407 | 3102–4323 | 1.55x | 223 | 20.27x | 0 | yes |
| scene-3d | 10 | react-reflex | 3122 | 2901–3937 | 1.42x | 233 | 21.18x | 0 | yes |
| scene-3d | 10 | react-upstream | 3507 | 3307–4827 | 1.59x | 230 | 20.91x | 8 | yes |
| scene-3d | 10 | roact | 3312 | 2909–4017 | 1.51x | 590 | 53.64x | 0 | yes |
| scene-3d | 10 | seam | 9126 | 8827–11402 | 4.15x | 1787 | 162.45x | 0 | yes |
| scene-3d | 10 | signals | 6214 | 5607–6802 | 2.82x | 682 | 62.00x | 0 | yes |
| scene-3d | 10 | vide | 3810 | 3700–4231 | 1.73x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 0 | 0–0 | plain below resolution | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 0 | 0–100 | plain below resolution | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 0 | 0–100 | plain below resolution | 10 | 2.00x | 2 | yes |
| derived-diamond | 3 | fusion | 0 | 0–368 | plain below resolution | 8 | 1.60x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 0 | 0–300 | plain below resolution | 11 | 2.20x | 0 | yes |
| derived-diamond | 3 | react | 200 | 100–500 | plain below resolution | 3 | 0.60x | 2 | yes |
| derived-diamond | 3 | react-reflex | 310 | 200–500 | plain below resolution | 13 | 2.60x | 5 | yes |
| derived-diamond | 3 | react-upstream | 300 | 100–300 | plain below resolution | 2 | 0.40x | 1 | yes |
| derived-diamond | 3 | roact | 0 | 0–100 | plain below resolution | 10 | 2.00x | 3 | yes |
| derived-diamond | 3 | seam | 100 | 0–601 | plain below resolution | 13 | 2.60x | 1 | yes |
| derived-diamond | 3 | signals | 0 | 0–100 | plain below resolution | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | vide | 0 | 0–503 | plain below resolution | 7 | 1.40x | 1 | yes |
| derived-chain-100 | 3 | plain | 0 | 0–0 | plain below resolution | 62 | 1.00x | 8 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 200 | 100–410 | plain below resolution | 127 | 2.05x | 2 | yes |
| derived-chain-100 | 3 | fusion | 900 | 700–2318 | plain below resolution | 127 | 2.05x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 800 | 700–1000 | plain below resolution | 129 | 2.08x | 0 | yes |
| derived-chain-100 | 3 | react | 400 | 300–507 | plain below resolution | 2 | 0.03x | 0 | yes |
| derived-chain-100 | 3 | react-reflex | 300 | 200–400 | plain below resolution | 13 | 0.21x | 5 | yes |
| derived-chain-100 | 3 | react-upstream | 300 | 200–407 | plain below resolution | 2 | 0.03x | 1 | yes |
| derived-chain-100 | 3 | roact | 100 | 0–200 | plain below resolution | 3 | 0.05x | 3 | yes |
| derived-chain-100 | 3 | seam | 800 | 500–802 | plain below resolution | 271 | 4.37x | 0 | yes |
| derived-chain-100 | 3 | signals | 200 | 100–600 | plain below resolution | 174 | 2.81x | 0 | yes |
| derived-chain-100 | 3 | vide | 200 | 0–300 | plain below resolution | 93 | 1.50x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 0 | 0–0 | plain below resolution | 599 | 1.00x | 1 | yes |
| derived-fan-in-1000 | 3 | blend | 200 | 100–301 | plain below resolution | 1543 | 2.58x | 1 | yes |
| derived-fan-in-1000 | 3 | compose | 300 | 200–400 | plain below resolution | 695 | 1.16x | 2 | yes |
| derived-fan-in-1000 | 3 | fusion | 2200 | 2000–3712 | plain below resolution | 889 | 1.48x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 2200 | 2115–2474 | plain below resolution | 2813 | 4.70x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 2200 | 1648–5201 | plain below resolution | 323 | 0.54x | 2 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 6601 | 6305–8500 | plain below resolution | 5266 | 8.79x | 37 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 2148 | 2100–2801 | plain below resolution | 331 | 0.55x | 2 | yes |
| derived-fan-in-1000 | 3 | roact | 400 | 300–600 | plain below resolution | 113 | 0.19x | 4 | yes |
| derived-fan-in-1000 | 3 | seam | 2864 | 2600–3104 | plain below resolution | 2963 | 4.95x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 800 | 600–1011 | plain below resolution | 1221 | 2.04x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 500 | 400–900 | plain below resolution | 528 | 0.88x | 0 | yes |
| filter-as-you-type | 1 | plain | 9015 | 7920–10625 | 1.00x | 155 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 16777 | 15723–17727 | 1.86x | 2987 | 19.27x | 0 | yes |
| filter-as-you-type | 1 | compose | 11338 | 10815–11579 | 1.26x | 953 | 6.15x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 27449 | 25180–28750 | 3.04x | 2601 | 16.78x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 26929 | 26347–28458 | 2.99x | 2595 | 16.74x | 0 | yes |
| filter-as-you-type | 1 | react | 21796 | 20831–23361 | 2.42x | 10 | 0.06x | 1 | yes |
| filter-as-you-type | 1 | react-reflex | 21853 | 20773–24191 | 2.42x | 765 | 4.94x | 4 | yes |
| filter-as-you-type | 1 | react-upstream | 22776 | 20871–24824 | 2.53x | 19 | 0.12x | 9 | yes |
| filter-as-you-type | 1 | roact | 11411 | 11222–12167 | 1.27x | 503 | 3.25x | 0 | yes |
| filter-as-you-type | 1 | seam | 23038 | 20272–24215 | 2.56x | 4013 | 25.89x | 0 | yes |
| filter-as-you-type | 1 | signals | 8216 | 7730–8317 | 0.91x | 37 | 0.24x | 0 | yes |
| filter-as-you-type | 1 | vide | 10851 | 10634–11941 | 1.20x | 967 | 6.24x | 0 | yes |
| theme-propagation | 3 | plain | 47216 | 44813–48139 | 1.00x | 207 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 48181 | 47650–49323 | 1.02x | 1997 | 9.65x | 0 | yes |
| theme-propagation | 3 | compose | 52181 | 50629–53233 | 1.11x | 538 | 2.60x | 1 | yes |
| theme-propagation | 3 | fusion | 53238 | 50434–54987 | 1.13x | 803 | 3.88x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 54385 | 49767–60391 | 1.15x | 821 | 3.97x | 1 | yes |
| theme-propagation | 3 | react | 83163 | 78934–88990 | 1.76x | 2 | 0.01x | 2 | yes |
| theme-propagation | 3 | react-reflex | 85801 | 74772–89275 | 1.82x | 4976 | 24.04x | 4 | yes |
| theme-propagation | 3 | react-upstream | 81586 | 80131–87687 | 1.73x | 3 | 0.01x | 2 | yes |
| theme-propagation | 3 | roact | 68365 | 67387–69435 | 1.45x | 2819 | 13.62x | 3 | yes |
| theme-propagation | 3 | seam | 46798 | 45045–48792 | 0.99x | 3422 | 16.53x | 0 | yes |
| theme-propagation | 3 | signals | 51851 | 48861–52360 | 1.10x | 880 | 4.25x | 1 | yes |
| theme-propagation | 3 | vide | 51179 | 50287–52651 | 1.08x | 598 | 2.89x | 0 | yes |
| hud-per-frame | 1 | plain | 1936 | 1417–2173 | 1.00x | 25 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 3987 | 3594–4831 | 2.06x | 71 | 2.84x | 1 | yes |
| hud-per-frame | 1 | compose | 3170 | 2387–3341 | 1.64x | 31 | 1.24x | 2 | yes |
| hud-per-frame | 1 | fusion | 9423 | 8927–10034 | 4.87x | 54 | 2.16x | 0 | yes |
| hud-per-frame | 1 | fusion-charm | 12955 | 12262–13370 | 6.69x | 82 | 3.28x | 0 | yes |
| hud-per-frame | 1 | react | 3505 | 3068–3723 | 1.81x | 34 | 1.36x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 6192 | 5902–6944 | 3.20x | 53 | 2.12x | 0 | yes |
| hud-per-frame | 1 | react-upstream | 3228 | 2555–3485 | 1.67x | 42 | 1.68x | 8 | yes |
| hud-per-frame | 1 | roact | 3328 | 3060–3652 | 1.72x | 90 | 3.60x | 0 | yes |
| hud-per-frame | 1 | seam | 7918 | 6280–8199 | 4.09x | 168 | 6.72x | 0 | yes |
| hud-per-frame | 1 | signals | 4254 | 3928–4863 | 2.20x | 66 | 2.64x | 1 | yes |
| hud-per-frame | 1 | vide | 3436 | 2438–3460 | 1.77x | 25 | 1.00x | 8 | yes |
| teardown-under-load | 1 | plain | 75355 | 68572–80543 | 1.00x | 5 | 1.00x | 8 | yes |
| teardown-under-load | 1 | blend | 71927 | 65493–78619 | 0.95x | 14 | 2.80x | 0 | yes |
| teardown-under-load | 1 | compose | 81550 | 76254–88824 | 1.08x | 6 | 1.20x | 9 | yes |
| teardown-under-load | 1 | fusion | 75286 | 70242–82364 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 72449 | 64223–89627 | 0.96x | 14 | 2.80x | 0 | yes |
| teardown-under-load | 1 | react | 93789 | 90970–109226 | 1.24x | 951 | 190.20x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 92327 | 88068–97820 | 1.23x | 952 | 190.40x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 93564 | 84603–100681 | 1.24x | 959 | 191.80x | 0 | yes |
| teardown-under-load | 1 | roact | 86568 | 80305–97127 | 1.15x | 71 | 14.20x | 0 | yes |
| teardown-under-load | 1 | seam | 93747 | 83328–97966 | 1.24x | 16 | 3.20x | 6 | yes |
| teardown-under-load | 1 | signals | 79757 | 78391–90372 | 1.06x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | vide | 57615 | 55953–64352 | 0.76x | 5 | 1.00x | 8 | yes |
| open-close-retention | 1 | plain | 137318 | 135908–138504 | 1.00x | 6 | 1.00x | 8 | yes |
| open-close-retention | 1 | blend | 122070 | 119698–130754 | 0.89x | 6 | 1.00x | 1 | yes |
| open-close-retention | 1 | compose | 152068 | 151808–162243 | 1.11x | 6 | 1.00x | 1 | yes |
| open-close-retention | 1 | fusion | 136814 | 133735–143321 | 1.00x | 5 | 0.83x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 139258 | 134384–141751 | 1.01x | 0 | 0.00x | 0 | yes |
| open-close-retention | 1 | react | 174371 | 172718–179984 | 1.27x | 251 | 41.83x | 0 | yes |
| open-close-retention | 1 | react-reflex | 174192 | 171866–185340 | 1.27x | 252 | 42.00x | 0 | yes |
| open-close-retention | 1 | react-upstream | 174926 | 172696–178508 | 1.27x | 251 | 41.83x | 0 | yes |
| open-close-retention | 1 | roact | 165547 | 162138–174587 | 1.21x | 23 | 3.83x | 0 | yes |
| open-close-retention | 1 | seam | 176031 | 174663–188382 | 1.28x | 9 | 1.50x | 0 | yes |
| open-close-retention | 1 | signals | 154107 | 151975–159563 | 1.12x | 5 | 0.83x | 0 | yes |
| open-close-retention | 1 | vide | 91536 | 90556–98210 | 0.67x | 5 | 0.83x | 0 | yes |
| tree-expand-collapse | 1 | plain | 11901 | 9133–12416 | 1.00x | 20 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 19513 | 19212–22785 | 1.64x | 821 | 41.05x | 8 | yes |
| tree-expand-collapse | 1 | compose | 12924 | 12610–13241 | 1.09x | 76 | 3.80x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 26544 | 23226–28731 | 2.23x | 173 | 8.65x | 9 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23648 | 20133–24919 | 1.99x | 167 | 8.35x | 1 | yes |
| tree-expand-collapse | 1 | react | 19413 | 18806–20931 | 1.63x | 3 | 0.15x | 2 | yes |
| tree-expand-collapse | 1 | react-reflex | 19603 | 19006–20057 | 1.65x | 615 | 30.75x | 5 | yes |
| tree-expand-collapse | 1 | react-upstream | 19322 | 18751–21822 | 1.62x | 4 | 0.20x | 2 | yes |
| tree-expand-collapse | 1 | roact | 11207 | 10910–11507 | 0.94x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 25703 | 21326–30128 | 2.16x | 148 | 7.40x | 0 | yes |
| tree-expand-collapse | 1 | signals | 8411 | 8309–8541 | 0.71x | 30 | 1.50x | 8 | yes |
| tree-expand-collapse | 1 | vide | 11915 | 11501–12108 | 1.00x | 71 | 3.55x | 1 | yes |
| form-validation | 1 | plain | 2507 | 2229–2704 | 1.00x | 48 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 3757 | 3289–4067 | 1.50x | 328 | 6.83x | 0 | yes |
| form-validation | 1 | compose | 3520 | 3411–3861 | 1.40x | 93 | 1.94x | 10 | yes |
| form-validation | 1 | fusion | 4389 | 4235–5154 | 1.75x | 118 | 2.46x | 1 | yes |
| form-validation | 1 | fusion-charm | 4899 | 4693–5677 | 1.95x | 155 | 3.23x | 0 | yes |
| form-validation | 1 | react | 11615 | 11375–13054 | 4.63x | 189 | 3.94x | 1 | yes |
| form-validation | 1 | react-reflex | 13272 | 12919–14362 | 5.29x | 258 | 5.38x | 6 | yes |
| form-validation | 1 | react-upstream | 12303 | 11655–12986 | 4.91x | 188 | 3.92x | 2 | yes |
| form-validation | 1 | roact | 6579 | 6192–7052 | 2.62x | 71 | 1.48x | 4 | yes |
| form-validation | 1 | seam | 5177 | 4296–6331 | 2.07x | 349 | 7.27x | 0 | yes |
| form-validation | 1 | signals | 3120 | 3037–3416 | 1.24x | 155 | 3.23x | 0 | yes |
| form-validation | 1 | vide | 3378 | 3121–3666 | 1.35x | 78 | 1.62x | 0 | yes |
| table-sort-filter | 1 | plain | 18651 | 17422–19415 | 1.00x | 83 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 38931 | 36243–45149 | 2.09x | 5810 | 70.00x | 0 | yes |
| table-sort-filter | 1 | compose | 27321 | 25948–27864 | 1.46x | 1695 | 20.42x | 17 | yes |
| table-sort-filter | 1 | fusion (workaround) | 55454 | 52868–57989 | 2.97x | 4943 | 59.55x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 53646 | 52810–55087 | 2.88x | 4945 | 59.58x | 1 | yes |
| table-sort-filter | 1 | react | 92547 | 89535–93935 | 4.96x | 2044 | 24.63x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 93717 | 91911–94409 | 5.02x | 2050 | 24.70x | 5 | yes |
| table-sort-filter | 1 | react-upstream | 93871 | 92265–94395 | 5.03x | 2044 | 24.63x | 2 | yes |
| table-sort-filter | 1 | roact | 26005 | 25534–26523 | 1.39x | 1046 | 12.60x | 3 | yes |
| table-sort-filter | 1 | seam | 57633 | 56061–61086 | 3.09x | 7784 | 93.78x | 1 | yes |
| table-sort-filter | 1 | signals | 18634 | 18001–18766 | 1.00x | 68 | 0.82x | 0 | yes |
| table-sort-filter | 1 | vide | 26653 | 25812–28360 | 1.43x | 1914 | 23.06x | 2 | yes |
| library-load | 1 | plain | 0 | 0–0 | plain below resolution | 1 | 1.00x | 8 | yes |
| library-load | 1 | blend | 100 | 100–200 | plain below resolution | 413 | 413.00x | 402 | yes |
| library-load | 1 | compose | 0 | 0–100 | plain below resolution | 463 | 463.00x | 460 | yes |
| library-load | 1 | fusion | 0 | 0–200 | plain below resolution | 194 | 194.00x | 192 | yes |
| library-load | 1 | fusion-charm | 0 | 0–100 | plain below resolution | 230 | 230.00x | 228 | yes |
| library-load | 1 | react | 200 | 100–200 | plain below resolution | 1321 | 1321.00x | 1328 | yes |
| library-load | 1 | react-reflex | 200 | 200–300 | plain below resolution | 1453 | 1453.00x | 1452 | yes |
| library-load | 1 | react-upstream | 100 | 0–105 | plain below resolution | 1426 | 1426.00x | 1431 | yes |
| library-load | 1 | roact | 100 | 0–100 | plain below resolution | 119 | 119.00x | 115 | yes |
| library-load | 1 | seam | 100 | 0–200 | plain below resolution | 187 | 187.00x | 184 | yes |
| library-load | 1 | signals | 100 | 100–200 | plain below resolution | 26 | 26.00x | 25 | yes |
| library-load | 1 | vide | 0 | 0–200 | plain below resolution | 105 | 105.00x | 105 | yes |
| rows-append-1000 | 1 | plain | 92815 | 90737–117686 | 1.00x | 9755 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 146885 | 138537–155560 | 1.58x | 38562 | 3.95x | 0 | yes |
| rows-append-1000 | 1 | compose | 113633 | 110071–151512 | 1.22x | 10542 | 1.08x | 32 | yes |
| rows-append-1000 | 1 | fusion | 327197 | 314707–336474 | 3.53x | 20953 | 2.15x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 317640 | 303001–340793 | 3.42x | 28882 | 2.96x | 8 | yes |
| rows-append-1000 | 1 | react | 187783 | 181731–212157 | 2.02x | 23234 | 2.38x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 206614 | 183145–220203 | 2.23x | 25060 | 2.57x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 175346 | 173244–184545 | 1.89x | 23386 | 2.40x | 257 | yes |
| rows-append-1000 | 1 | roact | 141379 | 128044–173577 | 1.52x | 33362 | 3.42x | 0 | yes |
| rows-append-1000 | 1 | seam | 147897 | 125529–167057 | 1.59x | 46791 | 4.80x | 0 | yes |
| rows-append-1000 | 1 | signals | 104176 | 98173–152043 | 1.12x | 17821 | 1.83x | 0 | yes |
| rows-append-1000 | 1 | vide | 107567 | 103501–108751 | 1.16x | 9515 | 0.98x | 8 | yes |
| rows-clear | 1 | plain | 61718 | 57860–64864 | 1.00x | 2472 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 70828 | 70291–75523 | 1.15x | 4041 | 1.63x | 0 | yes |
| rows-clear | 1 | compose | 32727 | 28844–32856 | 0.53x | 1759 | 0.71x | 16 | yes |
| rows-clear | 1 | fusion | 98604 | 94665–101571 | 1.60x | 3480 | 1.41x | 0 | yes |
| rows-clear | 1 | fusion-charm | 95177 | 91269–95825 | 1.54x | 7424 | 3.00x | 0 | yes |
| rows-clear | 1 | react | 70227 | 66999–72105 | 1.14x | 4504 | 1.82x | 8 | yes |
| rows-clear | 1 | react-reflex | 74770 | 72689–76941 | 1.21x | 6467 | 2.62x | 35 | yes |
| rows-clear | 1 | react-upstream | 69731 | 65451–73517 | 1.13x | 4496 | 1.82x | 8 | yes |
| rows-clear | 1 | roact | 57774 | 52053–58451 | 0.94x | 4214 | 1.70x | 0 | yes |
| rows-clear | 1 | seam | 31029 | 19922–33447 | 0.50x | 9135 | 3.70x | 0 | yes |
| rows-clear | 1 | signals | 59739 | 58838–66281 | 0.97x | 4466 | 1.81x | 0 | yes |
| rows-clear | 1 | vide | 61003 | 57054–64895 | 0.99x | 1613 | 0.65x | 0 | yes |
| rows-create-1000 | 1 | plain | 89945 | 82444–91247 | 1.00x | 5194 | 1.00x | 2 | yes |
| rows-create-1000 | 1 | blend | 148781 | 130170–151669 | 1.65x | 19785 | 3.81x | 1 | yes |
| rows-create-1000 | 1 | compose | 106586 | 99677–112931 | 1.19x | 5582 | 1.07x | 4 | yes |
| rows-create-1000 | 1 | fusion | 175981 | 172601–180014 | 1.96x | 10995 | 2.12x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 180707 | 173743–192617 | 2.01x | 14941 | 2.88x | 2 | yes |
| rows-create-1000 | 1 | react | 152530 | 144729–168922 | 1.70x | 8160 | 1.57x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 169771 | 160613–196207 | 1.89x | 9073 | 1.75x | 35 | yes |
| rows-create-1000 | 1 | react-upstream | 147351 | 146034–155323 | 1.64x | 7896 | 1.52x | 0 | yes |
| rows-create-1000 | 1 | roact | 124782 | 117328–134075 | 1.39x | 16689 | 3.21x | 0 | yes |
| rows-create-1000 | 1 | seam | 143321 | 132687–145673 | 1.59x | 23653 | 4.55x | 0 | yes |
| rows-create-1000 | 1 | signals | 96552 | 94891–111426 | 1.07x | 9058 | 1.74x | 1 | yes |
| rows-create-1000 | 1 | vide | 111791 | 108756–130222 | 1.24x | 4964 | 0.96x | 2 | yes |
| rows-create-10000 | 1 | plain | 1202715 | 1194625–1328398 | 1.00x | 49485 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 1784495 | 1764505–1850529 | 1.48x | 193151 | 3.90x | 0 | yes |
| rows-create-10000 | 1 | compose | 1420278 | 1324544–1462791 | 1.18x | 51774 | 1.05x | 10 | yes |
| rows-create-10000 | 1 | fusion | 6371132 | 6164111–6470780 | 5.30x | 105266 | 2.13x | 5 | yes |
| rows-create-10000 | 1 | fusion-charm | 6285484 | 6220981–6577199 | 5.23x | 144876 | 2.93x | 10 | yes |
| rows-create-10000 | 1 | react | 4902551 | 4657512–5541437 | 4.08x | 77346 | 1.56x | 324 | yes |
| rows-create-10000 | 1 | react-reflex | 4944313 | 4927059–4957232 | 4.11x | 86008 | 1.74x | 932 | yes |
| rows-create-10000 | 1 | react-upstream | 4751700 | 4730138–4912277 | 3.95x | 78514 | 1.59x | 636 | yes |
| rows-create-10000 | 1 | roact | 1503399 | 1442993–1547211 | 1.25x | 166030 | 3.36x | 0 | yes |
| rows-create-10000 | 1 | seam | 1726540 | 1693810–1907919 | 1.44x | 237402 | 4.80x | 4 | yes |
| rows-create-10000 | 1 | signals | 1293986 | 1282045–1329866 | 1.08x | 89720 | 1.81x | 8 | yes |
| rows-create-10000 | 1 | vide | 1312046 | 1310282–1454597 | 1.09x | 48500 | 0.98x | 9 | yes |
| rows-remove-one | 1 | plain | 902 | 812–1202 | 1.00x | 5239 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1100 | 1100–1200 | 1.22x | 19808 | 3.78x | 1 | yes |
| rows-remove-one | 1 | compose | 800 | 700–1001 | 0.89x | 5633 | 1.08x | 12 | yes |
| rows-remove-one | 1 | fusion (workaround) | 61966 | 60884–65134 | 68.70x | 11434 | 2.18x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 60426 | 56616–61860 | 66.99x | 15362 | 2.93x | 0 | yes |
| rows-remove-one | 1 | react | 37839 | 23821–40758 | 41.95x | 15741 | 3.00x | 7 | yes |
| rows-remove-one | 1 | react-reflex | 35339 | 29684–48232 | 39.18x | 16654 | 3.18x | 36 | yes |
| rows-remove-one | 1 | react-upstream | 24321 | 23335–40819 | 26.96x | 15501 | 2.96x | 16 | yes |
| rows-remove-one | 1 | roact | 17005 | 15704–18315 | 18.85x | 16773 | 3.20x | 0 | yes |
| rows-remove-one | 1 | seam | 6004 | 4818–6416 | 6.66x | 23677 | 4.52x | 0 | yes |
| rows-remove-one | 1 | signals | 1400 | 1200–1500 | 1.55x | 9093 | 1.74x | 0 | yes |
| rows-remove-one | 1 | vide | 1100 | 1100–1200 | 1.22x | 5017 | 0.96x | 1 | yes |
| rows-swap | 1 | plain | 400 | 300–405 | 1.00x | 4607 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 700 | 600–803 | 1.75x | 18760 | 4.07x | 1 | yes |
| rows-swap | 1 | compose | 200 | 100–200 | 0.50x | 5026 | 1.09x | 26 | yes |
| rows-swap | 1 | fusion | 58758 | 57362–60586 | 146.90x | 10008 | 2.17x | 0 | yes |
| rows-swap | 1 | fusion-charm | 57988 | 56268–58857 | 144.97x | 13935 | 3.02x | 0 | yes |
| rows-swap | 1 | react | 58341 | 51777–60852 | 145.85x | 15111 | 3.28x | 0 | yes |
| rows-swap | 1 | react-reflex | 69730 | 63230–86524 | 174.32x | 16287 | 3.54x | 67 | yes |
| rows-swap | 1 | react-upstream | 58880 | 53341–70780 | 147.20x | 15399 | 3.34x | 0 | yes |
| rows-swap | 1 | roact | 15816 | 13106–34339 | 39.54x | 16754 | 3.64x | 0 | yes |
| rows-swap | 1 | seam | 4903 | 4500–5801 | 12.26x | 23228 | 5.04x | 0 | yes |
| rows-swap | 1 | signals | 600 | 500–800 | 1.50x | 8610 | 1.87x | 0 | yes |
| rows-swap | 1 | vide | 100 | 100–300 | 0.25x | 4516 | 0.98x | 0 | yes |
| rows-update-every-10th | 1 | plain | 1903 | 1800–2002 | 1.00x | 4251 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 1908 | 1800–2112 | 1.00x | 18831 | 4.43x | 0 | yes |
| rows-update-every-10th | 1 | compose | 2000 | 1800–2205 | 1.05x | 4664 | 1.10x | 7 | yes |
| rows-update-every-10th | 1 | fusion | 2004 | 1904–2306 | 1.05x | 10060 | 2.37x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 2305 | 2119–2405 | 1.21x | 13988 | 3.29x | 0 | yes |
| rows-update-every-10th | 1 | react | 1900 | 1800–2203 | 1.00x | 7464 | 1.76x | 24 | yes |
| rows-update-every-10th | 1 | react-reflex | 4515 | 3110–6917 | 2.37x | 8392 | 1.97x | 67 | yes |
| rows-update-every-10th | 1 | react-upstream | 2000 | 1805–2009 | 1.05x | 7471 | 1.76x | 39 | yes |
| rows-update-every-10th | 1 | roact | 1900 | 1900–2112 | 1.00x | 16196 | 3.81x | 0 | yes |
| rows-update-every-10th | 1 | seam | 5462 | 5212–5707 | 2.87x | 23764 | 5.59x | 0 | yes |
| rows-update-every-10th | 1 | signals | 2000 | 1909–2100 | 1.05x | 8866 | 2.09x | 8 | yes |
| rows-update-every-10th | 1 | vide | 2000 | 1800–2048 | 1.05x | 4652 | 1.09x | 0 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.

The shared columns use only the workloads that every lane measured: 24 for time (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`) and 27 for heap (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 1.62x | 10.19x | 1.56x | 10.59x |
| compose | 30 | 1.26x | 3.67x | 1.23x | 3.72x |
| fusion | 30 | 4.18x | 5.62x | 3.80x | 5.94x |
| fusion-charm | 30 | 4.32x | 7.49x | 3.95x | 7.53x |
| react | 29 | 3.18x | 3.13x | 3.18x | 3.37x |
| react-reflex | 29 | 3.79x | 8.19x | 3.79x | 8.83x |
| react-upstream | 29 | 3.16x | 3.33x | 3.16x | 3.60x |
| roact | 29 | 1.95x | 4.62x | 1.95x | 5.51x |
| seam | 30 | 2.51x | 10.72x | 2.41x | 11.19x |
| signals | 29 | 1.26x | 2.40x | 1.26x | 2.48x |
| vide | 30 | 1.32x | 2.84x | 1.28x | 2.93x |
