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
| Roblox Studio | 0.745.0.7451137 |
| Context | client |
| Harness revision | `ee9f86b`, with its `events` batch at `a03aceb` |
| Date | 2026-10-31 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 500 | 400–900 | 1.00x | 25 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 2300 | 2100–2700 | 4.60x | 749 | 29.96x | 1 | yes |
| update-leaf | 20 | compose | 2500 | 2500–2800 | 5.00x | 101 | 4.04x | 1 | yes |
| update-leaf | 20 | fusion | 2900 | 2300–3300 | 5.80x | 116 | 4.64x | 0 | yes |
| update-leaf | 20 | fusion-charm | 3000 | 3000–3300 | 6.00x | 117 | 4.68x | 8 | yes |
| update-leaf | 20 | react | 2600 | 2400–3000 | 5.20x | 298 | 11.92x | 0 | yes |
| update-leaf | 20 | react-reflex | 3100 | 2906–3300 | 6.20x | 293 | 11.72x | 8 | yes |
| update-leaf | 20 | react-upstream | 2400 | 2100–2600 | 4.80x | 291 | 11.64x | 0 | yes |
| update-leaf | 20 | roact | 2500 | 2300–2900 | 5.00x | 967 | 38.68x | 8 | yes |
| update-leaf | 20 | seam | 2304 | 2200–2600 | 4.61x | 41 | 1.64x | 1 | yes |
| update-leaf | 20 | signals | 2600 | 2300–2900 | 5.20x | 51 | 2.04x | 0 | yes |
| update-leaf | 20 | vide | 2400 | 2100–2500 | 4.80x | 3 | 0.12x | 0 | yes |
| update-batched | 20 | plain | 4000 | 3930–5600 | 1.00x | 21 | 1.00x | 0 | yes |
| update-batched | 20 | blend | 14000 | 12600–14300 | 3.50x | 917 | 43.67x | 1 | yes |
| update-batched | 20 | compose | 8400 | 7700–9100 | 2.10x | 343 | 16.33x | 9 | yes |
| update-batched | 20 | fusion | 22804 | 18704–25000 | 5.70x | 516 | 24.57x | 0 | yes |
| update-batched | 20 | fusion-charm | 40301 | 39637–49133 | 10.08x | 1118 | 53.24x | 0 | yes |
| update-batched | 20 | react | 8500 | 8400–9300 | 2.12x | 469 | 22.33x | 0 | yes |
| update-batched | 20 | react-reflex | 65009 | 60773–66804 | 16.25x | 775 | 36.90x | 16 | yes |
| update-batched | 20 | react-upstream | 9601 | 8700–10900 | 2.40x | 477 | 22.71x | 0 | yes |
| update-batched | 20 | roact | 8801 | 8100–10300 | 2.20x | 1178 | 56.10x | 1 | yes |
| update-batched | 20 | seam | 12700 | 11700–14700 | 3.17x | 1841 | 87.67x | 0 | yes |
| update-batched | 20 | signals | 10000 | 9100–10200 | 2.50x | 605 | 28.81x | 0 | yes |
| update-batched | 20 | vide | 9300 | 8302–9700 | 2.33x | 332 | 15.81x | 0 | yes |
| update-repeated | 10 | plain | 0 | 0–0 | plain below resolution | 2 | 1.00x | 8 | yes |
| update-repeated | 10 | blend | 3000 | 2200–3300 | plain below resolution | 8 | 4.00x | 0 | yes |
| update-repeated | 10 | compose | 500 | 0–700 | plain below resolution | 6 | 3.00x | 2 | yes |
| update-repeated | 10 | fusion | 23203 | 22000–24100 | plain below resolution | 5 | 2.50x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1000 | 800–1300 | plain below resolution | 6 | 3.00x | 8 | yes |
| update-repeated | 10 | react | 6200 | 4900–6701 | plain below resolution | 0 | 0.00x | 0 | yes |
| update-repeated | 10 | react-reflex | 1000 | 1000–1300 | plain below resolution | 11 | 5.50x | 0 | yes |
| update-repeated | 10 | react-upstream | 5102 | 4900–5800 | plain below resolution | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | roact | 6000 | 5500–6400 | plain below resolution | 14 | 7.00x | 1 | yes |
| update-repeated | 10 | seam | 1000 | 900–1700 | plain below resolution | 11 | 5.50x | 1 | yes |
| update-repeated | 10 | signals | 800 | 700–1100 | plain below resolution | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 500 | 300–900 | plain below resolution | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 25000 | 19468–76672 | 1.00x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 27403 | 26500–29002 | 1.10x | 43 | 21.50x | 0 | yes |
| branch-swap | 20 | compose | 25900 | 24400–26800 | 1.04x | 7 | 3.50x | 1 | yes |
| branch-swap | 20 | fusion | 26512 | 25801–28700 | 1.06x | 5 | 2.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 26800 | 25803–28800 | 1.07x | 7 | 3.50x | 8 | yes |
| branch-swap | 20 | react | 27800 | 25800–29945 | 1.11x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 27708 | 27002–28804 | 1.11x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 28001 | 26304–31200 | 1.12x | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | roact | 25971 | 25500–26700 | 1.04x | 12 | 6.00x | 0 | yes |
| branch-swap | 20 | seam | 23105 | 21700–24501 | 0.92x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | signals | 24601 | 23300–26579 | 0.98x | 0 | 0.00x | 0 | yes |
| branch-swap | 20 | vide | 24700 | 23800–25000 | 0.99x | 5 | 2.50x | 0 | yes |
| keyed-prepend | 10 | plain | 1700 | 1600–2000 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 4600 | 4300–5400 | 2.71x | 1506 | 23.53x | 0 | yes |
| keyed-prepend | 10 | compose | 4200 | 3600–4400 | 2.47x | 546 | 8.53x | 17 | yes |
| keyed-prepend | 10 | fusion (workaround) | 21500 | 17417–22004 | 12.65x | 1535 | 23.98x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 19302 | 18900–22005 | 11.35x | 1546 | 24.16x | 1 | yes |
| keyed-prepend | 10 | react | 10400 | 10200–12914 | 6.12x | 791 | 12.36x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 11300 | 10300–12200 | 6.65x | 786 | 12.28x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 10900 | 10600–11600 | 6.41x | 792 | 12.38x | 0 | yes |
| keyed-prepend | 10 | roact | 7100 | 6100–7300 | 4.18x | 361 | 5.64x | 0 | yes |
| keyed-prepend | 10 | seam | 10600 | 9502–11800 | 6.24x | 2472 | 38.62x | 0 | yes |
| keyed-prepend | 10 | signals | 2700 | 2400–2800 | 1.59x | 61 | 0.95x | 0 | yes |
| keyed-prepend | 10 | vide | 4500 | 4100–5400 | 2.65x | 654 | 10.22x | 8 | yes |
| keyed-insert | 10 | plain | 1200 | 945–1300 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4400 | 3600–4700 | 3.67x | 1514 | 23.66x | 8 | yes |
| keyed-insert | 10 | compose | 3000 | 2600–3800 | 2.50x | 534 | 8.34x | 13 | yes |
| keyed-insert | 10 | fusion (workaround) | 16342 | 15100–18500 | 13.62x | 1551 | 24.23x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 15807 | 12501–17400 | 13.17x | 1602 | 25.03x | 3 | yes |
| keyed-insert | 10 | react | 9500 | 9100–11700 | 7.92x | 818 | 12.78x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9001 | 7900–9743 | 7.50x | 811 | 12.67x | 0 | yes |
| keyed-insert | 10 | react-upstream | 9504 | 9100–10304 | 7.92x | 817 | 12.77x | 0 | yes |
| keyed-insert | 10 | roact | 5300 | 3800–6200 | 4.42x | 361 | 5.64x | 1 | yes |
| keyed-insert | 10 | seam | 9400 | 9000–9900 | 7.83x | 2487 | 38.86x | 1 | yes |
| keyed-insert | 10 | signals | 2100 | 1900–2700 | 1.75x | 61 | 0.95x | 0 | yes |
| keyed-insert | 10 | vide | 3800 | 3300–5200 | 3.17x | 654 | 10.22x | 0 | yes |
| keyed-shuffle | 10 | plain | 1100 | 1000–1100 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 2700 | 2400–3100 | 2.45x | 1456 | 24.27x | 1 | yes |
| keyed-shuffle | 10 | compose | 2900 | 2400–3000 | 2.64x | 537 | 8.95x | 1 | yes |
| keyed-shuffle | 10 | fusion | 16703 | 15800–18000 | 15.18x | 1406 | 23.43x | 0 | yes |
| keyed-shuffle | 10 | fusion-charm | 17000 | 15400–18600 | 15.45x | 1408 | 23.47x | 0 | yes |
| keyed-shuffle | 10 | react | 15500 | 14500–16600 | 14.09x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 14900 | 14410–15716 | 13.55x | 779 | 12.98x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 14500 | 14400–15700 | 13.18x | 787 | 13.12x | 0 | yes |
| keyed-shuffle | 10 | roact | 4800 | 4300–5200 | 4.36x | 360 | 6.00x | 0 | yes |
| keyed-shuffle | 10 | seam | 8700 | 7300–9200 | 7.91x | 2478 | 41.30x | 0 | yes |
| keyed-shuffle | 10 | signals | 1800 | 1500–2300 | 1.64x | 61 | 1.02x | 0 | yes |
| keyed-shuffle | 10 | vide | 3400 | 3100–4700 | 3.09x | 629 | 10.48x | 0 | yes |
| events | 1 | plain | 2600 | 2100–3300 | 1.00x | 1 | 1.00x | 1 | yes |
| events | 1 | blend | 2900 | 2100–3100 | 1.12x | 1 | 1.00x | 0 | yes |
| events | 1 | compose | 2500 | 2400–2700 | 0.96x | 2 | 2.00x | 1 | yes |
| events | 1 | fusion | 2600 | 2200–3000 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | fusion-charm | 2600 | 2100–3000 | 1.00x | 0 | 0.00x | 1 | yes |
| events | 1 | react | 2400 | 2000–3600 | 0.92x | 1 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 2800 | 2600–3200 | 1.08x | 1 | 1.00x | 0 | yes |
| events | 1 | react-upstream | 3100 | 2800–3200 | 1.19x | 1 | 1.00x | 0 | yes |
| events | 1 | roact | 2700 | 2200–2800 | 1.04x | 1 | 1.00x | 8 | yes |
| events | 1 | seam | 2800 | 1800–3000 | 1.08x | 1 | 1.00x | 0 | yes |
| events | 1 | signals | 2200 | 1600–2300 | 0.85x | 1 | 1.00x | 0 | yes |
| events | 1 | vide | 3600 | 2900–3700 | 1.38x | 1 | 1.00x | 0 | yes |
| animate-many | 1 | plain | 2700 | 1900–3000 | 1.00x | 48 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 10000 | 9500–13300 | 3.70x | 1794 | 37.38x | 1 | yes |
| animate-many | 1 | compose | 8800 | 8100–9300 | 3.26x | 866 | 18.04x | 10 | yes |
| animate-many | 1 | fusion | 63406 | 62628–64956 | 23.48x | 1121 | 23.35x | 0 | yes |
| animate-many | 1 | fusion-charm | 63845 | 62606–65904 | 23.65x | 1118 | 23.29x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20710 | 19831–22026 | 7.67x | 2914 | 60.71x | 0 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 11500 | 10100–12200 | 4.26x | 392 | 8.17x | 0 | yes |
| status-panel | 10 | plain | 800 | 600–900 | 1.00x | 3 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 2700 | 2600–2800 | 3.38x | 61 | 20.33x | 0 | yes |
| status-panel | 10 | compose | 2800 | 2400–2900 | 3.50x | 33 | 11.00x | 1 | yes |
| status-panel | 10 | fusion | 3200 | 2900–3700 | 4.00x | 64 | 21.33x | 0 | yes |
| status-panel | 10 | fusion-charm | 3300 | 3300–4300 | 4.12x | 69 | 23.00x | 8 | yes |
| status-panel | 10 | react | 3100 | 2800–3800 | 3.88x | 41 | 13.67x | 0 | yes |
| status-panel | 10 | react-reflex | 3800 | 3600–4300 | 4.75x | 44 | 14.67x | 0 | yes |
| status-panel | 10 | react-upstream | 3600 | 3200–4000 | 4.50x | 43 | 14.33x | 0 | yes |
| status-panel | 10 | roact | 3000 | 2100–3300 | 3.75x | 25 | 8.33x | 0 | yes |
| status-panel | 10 | seam | 2600 | 2400–3300 | 3.25x | 141 | 47.00x | 0 | yes |
| status-panel | 10 | signals | 2400 | 1700–2800 | 3.00x | 23 | 7.67x | 8 | yes |
| status-panel | 10 | vide | 2700 | 2400–2900 | 3.38x | 25 | 8.33x | 0 | yes |
| scene-3d | 10 | plain | 2000 | 2000–2200 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 5100 | 4700–6100 | 2.55x | 566 | 51.45x | 0 | yes |
| scene-3d | 10 | compose | 3500 | 2800–3900 | 1.75x | 212 | 19.27x | 2 | yes |
| scene-3d | 10 | fusion | 22811 | 21100–23503 | 11.41x | 528 | 48.00x | 0 | yes |
| scene-3d | 10 | fusion-charm | 21200 | 20207–21903 | 10.60x | 532 | 48.36x | 1 | yes |
| scene-3d | 10 | react | 3900 | 3500–5200 | 1.95x | 230 | 20.91x | 0 | yes |
| scene-3d | 10 | react-reflex | 4200 | 3700–4504 | 2.10x | 232 | 21.09x | 0 | yes |
| scene-3d | 10 | react-upstream | 4300 | 3502–4500 | 2.15x | 231 | 21.00x | 0 | yes |
| scene-3d | 10 | roact | 3700 | 3600–4900 | 1.85x | 590 | 53.64x | 0 | yes |
| scene-3d | 10 | seam | 8400 | 8000–9400 | 4.20x | 1779 | 161.73x | 0 | yes |
| scene-3d | 10 | signals | 5900 | 4600–6604 | 2.95x | 690 | 62.73x | 0 | yes |
| scene-3d | 10 | vide | 4800 | 3300–5026 | 2.40x | 211 | 19.18x | 0 | yes |
| derived-diamond | 3 | plain | 0 | 0–0 | plain below resolution | 5 | 1.00x | 0 | yes |
| derived-diamond | 3 | blend | 100 | 0–300 | plain below resolution | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 100 | 0–200 | plain below resolution | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | fusion | 100 | 0–100 | plain below resolution | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 200 | 0–300 | plain below resolution | 18 | 3.60x | 8 | yes |
| derived-diamond | 3 | react | 300 | 100–700 | plain below resolution | 0 | 0.00x | 1 | yes |
| derived-diamond | 3 | react-reflex | 300 | 100–600 | plain below resolution | 12 | 2.40x | 4 | yes |
| derived-diamond | 3 | react-upstream | 300 | 200–500 | plain below resolution | 0 | 0.00x | 0 | yes |
| derived-diamond | 3 | roact | 100 | 0–100 | plain below resolution | 11 | 2.20x | 3 | yes |
| derived-diamond | 3 | seam | 100 | 0–200 | plain below resolution | 21 | 4.20x | 0 | yes |
| derived-diamond | 3 | signals | 200 | 0–300 | plain below resolution | 10 | 2.00x | 1 | yes |
| derived-diamond | 3 | vide | 0 | 0–200 | plain below resolution | 6 | 1.20x | 0 | yes |
| derived-chain-100 | 3 | plain | 0 | 0–0 | plain below resolution | 69 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 200 | 100–400 | plain below resolution | 127 | 1.84x | 2 | yes |
| derived-chain-100 | 3 | fusion | 700 | 400–800 | plain below resolution | 127 | 1.84x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 700 | 400–900 | plain below resolution | 129 | 1.87x | 0 | yes |
| derived-chain-100 | 3 | react | 300 | 200–500 | plain below resolution | 2 | 0.03x | 2 | yes |
| derived-chain-100 | 3 | react-reflex | 300 | 100–700 | plain below resolution | 13 | 0.19x | 4 | yes |
| derived-chain-100 | 3 | react-upstream | 200 | 200–300 | plain below resolution | 2 | 0.03x | 1 | yes |
| derived-chain-100 | 3 | roact | 200 | 0–300 | plain below resolution | 11 | 0.16x | 3 | yes |
| derived-chain-100 | 3 | seam | 600 | 400–700 | plain below resolution | 272 | 3.94x | 1 | yes |
| derived-chain-100 | 3 | signals | 300 | 100–400 | plain below resolution | 174 | 2.52x | 1 | yes |
| derived-chain-100 | 3 | vide | 200 | 100–300 | plain below resolution | 93 | 1.35x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 0 | 0–0 | plain below resolution | 599 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 300 | 200–400 | plain below resolution | 1543 | 2.58x | 0 | yes |
| derived-fan-in-1000 | 3 | compose | 200 | 100–300 | plain below resolution | 687 | 1.15x | 9 | yes |
| derived-fan-in-1000 | 3 | fusion | 1000 | 800–1200 | plain below resolution | 890 | 1.49x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1300 | 1000–1900 | plain below resolution | 2814 | 4.70x | 1 | yes |
| derived-fan-in-1000 | 3 | react | 1700 | 1200–2800 | plain below resolution | 322 | 0.54x | 1 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 8000 | 7315–10600 | plain below resolution | 5265 | 8.79x | 37 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1500 | 1100–2300 | plain below resolution | 322 | 0.54x | 1 | yes |
| derived-fan-in-1000 | 3 | roact | 500 | 300–800 | plain below resolution | 105 | 0.18x | 3 | yes |
| derived-fan-in-1000 | 3 | seam | 1700 | 1500–2000 | plain below resolution | 2963 | 4.95x | 1 | yes |
| derived-fan-in-1000 | 3 | signals | 700 | 500–800 | plain below resolution | 1229 | 2.05x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 300 | 200–400 | plain below resolution | 536 | 0.89x | 0 | yes |
| filter-as-you-type | 1 | plain | 6400 | 6000–6700 | 1.00x | 155 | 1.00x | 0 | yes |
| filter-as-you-type | 1 | blend | 15400 | 14800–15900 | 2.41x | 2980 | 19.23x | 0 | yes |
| filter-as-you-type | 1 | compose | 10700 | 9800–11700 | 1.67x | 945 | 6.10x | 10 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 24200 | 22201–25800 | 3.78x | 2601 | 16.78x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 25700 | 23111–29100 | 4.02x | 2611 | 16.85x | 0 | yes |
| filter-as-you-type | 1 | react | 15200 | 14400–15600 | 2.38x | 10 | 0.06x | 2 | yes |
| filter-as-you-type | 1 | react-reflex | 15800 | 14610–16600 | 2.47x | 765 | 4.94x | 4 | yes |
| filter-as-you-type | 1 | react-upstream | 15801 | 14700–17163 | 2.47x | 11 | 0.07x | 10 | yes |
| filter-as-you-type | 1 | roact | 10800 | 9400–11500 | 1.69x | 510 | 3.29x | 3 | yes |
| filter-as-you-type | 1 | seam | 24200 | 18903–25100 | 3.78x | 3997 | 25.79x | 0 | yes |
| filter-as-you-type | 1 | signals | 8100 | 7000–8946 | 1.27x | 37 | 0.24x | 0 | yes |
| filter-as-you-type | 1 | vide | 10700 | 10000–11827 | 1.67x | 960 | 6.19x | 0 | yes |
| theme-propagation | 3 | plain | 94802 | 94607–102900 | 1.00x | 208 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 107306 | 94359–122423 | 1.13x | 1998 | 9.61x | 1 | yes |
| theme-propagation | 3 | compose | 106301 | 98102–166003 | 1.12x | 538 | 2.59x | 1 | yes |
| theme-propagation | 3 | fusion | 105308 | 99138–111811 | 1.11x | 819 | 3.94x | 0 | yes |
| theme-propagation | 3 | fusion-charm | 106703 | 102032–108800 | 1.13x | 813 | 3.91x | 1 | yes |
| theme-propagation | 3 | react | 132679 | 130003–133798 | 1.40x | 1 | 0.00x | 0 | yes |
| theme-propagation | 3 | react-reflex | 133429 | 126404–135700 | 1.41x | 4985 | 23.97x | 5 | yes |
| theme-propagation | 3 | react-upstream | 132913 | 123996–138438 | 1.40x | 3 | 0.01x | 9 | yes |
| theme-propagation | 3 | roact | 118424 | 116109–123009 | 1.25x | 2818 | 13.55x | 3 | yes |
| theme-propagation | 3 | seam | 95115 | 95100–95606 | 1.00x | 3429 | 16.49x | 0 | yes |
| theme-propagation | 3 | signals | 112700 | 100200–119378 | 1.19x | 880 | 4.23x | 8 | yes |
| theme-propagation | 3 | vide | 105510 | 98587–111372 | 1.11x | 597 | 2.87x | 0 | yes |
| hud-per-frame | 1 | plain | 3100 | 2900–3100 | 1.00x | 16 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5400 | 4500–5900 | 1.74x | 71 | 4.44x | 0 | yes |
| hud-per-frame | 1 | compose | 4700 | 3700–5400 | 1.52x | 22 | 1.38x | 0 | yes |
| hud-per-frame | 1 | fusion | 11800 | 10900–13302 | 3.81x | 53 | 3.31x | 8 | yes |
| hud-per-frame | 1 | fusion-charm | 16000 | 15300–17000 | 5.16x | 91 | 5.69x | 0 | yes |
| hud-per-frame | 1 | react | 4400 | 3700–5100 | 1.42x | 34 | 2.12x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 7900 | 7200–8900 | 2.55x | 54 | 3.38x | 1 | yes |
| hud-per-frame | 1 | react-upstream | 4800 | 3700–5000 | 1.55x | 41 | 2.56x | 0 | yes |
| hud-per-frame | 1 | roact | 4300 | 3900–4500 | 1.39x | 99 | 6.19x | 0 | yes |
| hud-per-frame | 1 | seam | 9200 | 8800–9700 | 2.97x | 169 | 10.56x | 1 | yes |
| hud-per-frame | 1 | signals | 6001 | 4700–6400 | 1.94x | 73 | 4.56x | 0 | yes |
| hud-per-frame | 1 | vide | 5500 | 4604–6300 | 1.77x | 25 | 1.56x | 1 | yes |
| teardown-under-load | 1 | plain | 110504 | 108801–113519 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 62921 | 60900–63810 | 0.57x | 6 | 1.20x | 0 | yes |
| teardown-under-load | 1 | compose | 117402 | 116308–118300 | 1.06x | 5 | 1.00x | 2 | yes |
| teardown-under-load | 1 | fusion | 80544 | 69767–83300 | 0.73x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 76200 | 68272–86319 | 0.69x | 6 | 1.20x | 1 | yes |
| teardown-under-load | 1 | react | 121818 | 120686–124299 | 1.10x | 959 | 191.80x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 123437 | 121947–125609 | 1.12x | 960 | 192.00x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 123510 | 121876–144106 | 1.12x | 959 | 191.80x | 6 | yes |
| teardown-under-load | 1 | roact | 115411 | 113607–116813 | 1.04x | 70 | 14.00x | 0 | yes |
| teardown-under-load | 1 | seam | 141401 | 123902–164370 | 1.28x | 8 | 1.60x | 6 | yes |
| teardown-under-load | 1 | signals | 137271 | 119902–180706 | 1.24x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | vide | 59106 | 58400–60100 | 0.53x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | plain | 233509 | 220202–235307 | 1.00x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 111340 | 110126–115511 | 0.48x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | compose | 238375 | 235305–254084 | 1.02x | 6 | 1.20x | 2 | yes |
| open-close-retention | 1 | fusion | 132110 | 127841–138701 | 0.57x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 135073 | 132345–136905 | 0.58x | 6 | 1.20x | 8 | yes |
| open-close-retention | 1 | react | 247515 | 242434–251008 | 1.06x | 251 | 50.20x | 0 | yes |
| open-close-retention | 1 | react-reflex | 247564 | 246863–273757 | 1.06x | 252 | 50.40x | 4 | yes |
| open-close-retention | 1 | react-upstream | 247415 | 245764–251506 | 1.06x | 251 | 50.20x | 0 | yes |
| open-close-retention | 1 | roact | 248016 | 245755–252663 | 1.06x | 15 | 3.00x | 0 | yes |
| open-close-retention | 1 | seam | 272704 | 267542–282727 | 1.17x | 9 | 1.80x | 0 | yes |
| open-close-retention | 1 | signals | 244910 | 238806–273180 | 1.05x | 12 | 2.40x | 0 | yes |
| open-close-retention | 1 | vide | 89227 | 85600–89748 | 0.38x | 5 | 1.00x | 9 | yes |
| tree-expand-collapse | 1 | plain | 7100 | 6906–7400 | 1.00x | 20 | 1.00x | 8 | yes |
| tree-expand-collapse | 1 | blend | 18400 | 17500–19000 | 2.59x | 829 | 41.45x | 0 | yes |
| tree-expand-collapse | 1 | compose | 13000 | 12780–13100 | 1.83x | 68 | 3.40x | 6 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 23600 | 22000–28100 | 3.32x | 165 | 8.25x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 24705 | 20686–25700 | 3.48x | 167 | 8.35x | 1 | yes |
| tree-expand-collapse | 1 | react | 14926 | 14600–15911 | 2.10x | 0 | 0.00x | 0 | yes |
| tree-expand-collapse | 1 | react-reflex | 15600 | 13900–16900 | 2.20x | 614 | 30.70x | 3 | yes |
| tree-expand-collapse | 1 | react-upstream | 15000 | 14300–15400 | 2.11x | 2 | 0.10x | 0 | yes |
| tree-expand-collapse | 1 | roact | 10800 | 10700–11300 | 1.52x | 35 | 1.75x | 3 | yes |
| tree-expand-collapse | 1 | seam | 26400 | 22602–33201 | 3.72x | 149 | 7.45x | 0 | yes |
| tree-expand-collapse | 1 | signals | 9017 | 8100–9300 | 1.27x | 22 | 1.10x | 0 | yes |
| tree-expand-collapse | 1 | vide | 12900 | 12701–13420 | 1.82x | 71 | 3.55x | 0 | yes |
| form-validation | 1 | plain | 2700 | 2700–3100 | 1.00x | 57 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 9602 | 8502–9900 | 3.56x | 329 | 5.77x | 0 | yes |
| form-validation | 1 | compose | 8900 | 8800–9700 | 3.30x | 92 | 1.61x | 2 | yes |
| form-validation | 1 | fusion | 10500 | 9600–10700 | 3.89x | 118 | 2.07x | 0 | yes |
| form-validation | 1 | fusion-charm | 11700 | 9300–12100 | 4.33x | 155 | 2.72x | 8 | yes |
| form-validation | 1 | react | 18201 | 17300–18600 | 6.74x | 180 | 3.16x | 1 | yes |
| form-validation | 1 | react-reflex | 20101 | 19500–20700 | 7.44x | 257 | 4.51x | 0 | yes |
| form-validation | 1 | react-upstream | 18701 | 17200–19704 | 6.93x | 187 | 3.28x | 1 | yes |
| form-validation | 1 | roact | 12100 | 11500–13100 | 4.48x | 63 | 1.11x | 4 | yes |
| form-validation | 1 | seam | 8801 | 8400–9500 | 3.26x | 357 | 6.26x | 8 | yes |
| form-validation | 1 | signals | 9300 | 8700–10000 | 3.44x | 155 | 2.72x | 0 | yes |
| form-validation | 1 | vide | 8800 | 8200–8900 | 3.26x | 70 | 1.23x | 0 | yes |
| table-sort-filter | 1 | plain | 14800 | 14501–14903 | 1.00x | 83 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 35550 | 31000–36500 | 2.40x | 5812 | 70.02x | 1 | yes |
| table-sort-filter | 1 | compose | 24500 | 22700–25903 | 1.66x | 1695 | 20.42x | 25 | yes |
| table-sort-filter | 1 | fusion (workaround) | 56650 | 50400–66101 | 3.83x | 4944 | 59.57x | 0 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 53527 | 49325–59512 | 3.62x | 4946 | 59.59x | 1 | yes |
| table-sort-filter | 1 | react | 54648 | 51300–62101 | 3.69x | 2050 | 24.70x | 0 | yes |
| table-sort-filter | 1 | react-reflex | 52900 | 49900–57802 | 3.57x | 2058 | 24.80x | 12 | yes |
| table-sort-filter | 1 | react-upstream | 51907 | 51100–55300 | 3.51x | 2050 | 24.70x | 2 | yes |
| table-sort-filter | 1 | roact | 23518 | 22300–24600 | 1.59x | 1062 | 12.80x | 11 | yes |
| table-sort-filter | 1 | seam | 59900 | 54002–68102 | 4.05x | 8016 | 96.58x | 0 | yes |
| table-sort-filter | 1 | signals | 16900 | 16101–17200 | 1.14x | 76 | 0.92x | 0 | yes |
| table-sort-filter | 1 | vide | 26763 | 24107–27218 | 1.81x | 1914 | 23.06x | 0 | yes |
| library-load | 1 | plain | 0 | 0–0 | plain below resolution | 2 | 1.00x | 2 | yes |
| library-load | 1 | blend | 100 | 100–200 | plain below resolution | 405 | 202.50x | 411 | yes |
| library-load | 1 | compose | 200 | 200–300 | plain below resolution | 456 | 228.00x | 460 | yes |
| library-load | 1 | fusion | 100 | 0–100 | plain below resolution | 185 | 92.50x | 184 | yes |
| library-load | 1 | fusion-charm | 100 | 0–200 | plain below resolution | 229 | 114.50x | 228 | yes |
| library-load | 1 | react | 300 | 100–300 | plain below resolution | 1328 | 664.00x | 1326 | yes |
| library-load | 1 | react-reflex | 200 | 100–300 | plain below resolution | 1452 | 726.00x | 1459 | yes |
| library-load | 1 | react-upstream | 200 | 100–300 | plain below resolution | 1441 | 720.50x | 1439 | yes |
| library-load | 1 | roact | 100 | 100–100 | plain below resolution | 119 | 59.50x | 116 | yes |
| library-load | 1 | seam | 0 | 0–200 | plain below resolution | 180 | 90.00x | 177 | yes |
| library-load | 1 | signals | 0 | 0–0 | plain below resolution | 26 | 13.00x | 25 | yes |
| library-load | 1 | vide | 100 | 100–100 | plain below resolution | 105 | 52.50x | 105 | yes |
| rows-append-1000 | 1 | plain | 156909 | 152800–186359 | 1.00x | 9755 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 233192 | 218742–239020 | 1.49x | 38554 | 3.95x | 0 | yes |
| rows-append-1000 | 1 | compose | 172974 | 163502–241723 | 1.10x | 10534 | 1.08x | 34 | yes |
| rows-append-1000 | 1 | fusion | 316807 | 312817–322516 | 2.02x | 21098 | 2.16x | 1 | yes |
| rows-append-1000 | 1 | fusion-charm | 319825 | 312547–338453 | 2.04x | 28762 | 2.95x | 2 | yes |
| rows-append-1000 | 1 | react | 221811 | 207113–266230 | 1.41x | 23216 | 2.38x | 0 | yes |
| rows-append-1000 | 1 | react-reflex | 247102 | 236305–272622 | 1.57x | 25062 | 2.57x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 226406 | 222502–270717 | 1.44x | 23250 | 2.38x | 16 | yes |
| rows-append-1000 | 1 | roact | 217316 | 185254–257016 | 1.38x | 33347 | 3.42x | 0 | yes |
| rows-append-1000 | 1 | seam | 274524 | 245560–281696 | 1.75x | 46711 | 4.79x | 0 | yes |
| rows-append-1000 | 1 | signals | 179384 | 162647–185970 | 1.14x | 17765 | 1.82x | 0 | yes |
| rows-append-1000 | 1 | vide | 178737 | 171443–252386 | 1.14x | 9508 | 0.97x | 1 | yes |
| rows-clear | 1 | plain | 23801 | 22503–24476 | 1.00x | 2472 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 40502 | 39458–42400 | 1.70x | 4025 | 1.63x | 0 | yes |
| rows-clear | 1 | compose | 27860 | 27101–29400 | 1.17x | 1760 | 0.71x | 10 | yes |
| rows-clear | 1 | fusion | 54318 | 53700–55171 | 2.28x | 3280 | 1.33x | 0 | yes |
| rows-clear | 1 | fusion-charm | 53073 | 51307–54202 | 2.23x | 7441 | 3.01x | 1 | yes |
| rows-clear | 1 | react | 27000 | 26046–29032 | 1.13x | 4520 | 1.83x | 0 | yes |
| rows-clear | 1 | react-reflex | 31302 | 30803–36036 | 1.32x | 6490 | 2.63x | 35 | yes |
| rows-clear | 1 | react-upstream | 26402 | 25731–29100 | 1.11x | 4504 | 1.82x | 0 | yes |
| rows-clear | 1 | roact | 29300 | 28824–31700 | 1.23x | 4230 | 1.71x | 1 | yes |
| rows-clear | 1 | seam | 39123 | 22600–40102 | 1.64x | 9175 | 3.71x | 0 | yes |
| rows-clear | 1 | signals | 24700 | 24068–24900 | 1.04x | 4490 | 1.82x | 8 | yes |
| rows-clear | 1 | vide | 23400 | 22502–24000 | 0.98x | 1613 | 0.65x | 0 | yes |
| rows-create-1000 | 1 | plain | 147502 | 141274–167645 | 1.00x | 5201 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 201036 | 195039–219432 | 1.36x | 19793 | 3.81x | 2 | yes |
| rows-create-1000 | 1 | compose | 164557 | 162208–180580 | 1.12x | 5590 | 1.07x | 26 | yes |
| rows-create-1000 | 1 | fusion | 212374 | 204682–242529 | 1.44x | 11019 | 2.12x | 1 | yes |
| rows-create-1000 | 1 | fusion-charm | 223704 | 215501–234303 | 1.52x | 14941 | 2.87x | 0 | yes |
| rows-create-1000 | 1 | react | 187204 | 185019–193717 | 1.27x | 8176 | 1.57x | 16 | yes |
| rows-create-1000 | 1 | react-reflex | 221649 | 188934–300634 | 1.50x | 9079 | 1.75x | 50 | yes |
| rows-create-1000 | 1 | react-upstream | 195885 | 182607–206298 | 1.33x | 7926 | 1.52x | 6 | yes |
| rows-create-1000 | 1 | roact | 186499 | 184131–216336 | 1.26x | 16698 | 3.21x | 0 | yes |
| rows-create-1000 | 1 | seam | 217389 | 208452–242106 | 1.47x | 23662 | 4.55x | 9 | yes |
| rows-create-1000 | 1 | signals | 160844 | 149478–182301 | 1.09x | 9050 | 1.74x | 0 | yes |
| rows-create-1000 | 1 | vide | 164244 | 153705–221710 | 1.11x | 4956 | 0.95x | 8 | yes |
| rows-create-10000 | 1 | plain | 1818831 | 1750619–1882687 | 1.00x | 49578 | 1.00x | 0 | yes |
| rows-create-10000 | 1 | blend | 2456352 | 2445429–2467656 | 1.35x | 193396 | 3.90x | 0 | yes |
| rows-create-10000 | 1 | compose | 2042870 | 1950774–2054010 | 1.12x | 52430 | 1.06x | 898 | yes |
| rows-create-10000 | 1 | fusion | 5209609 | 4846729–5423207 | 2.86x | 105462 | 2.13x | 4 | yes |
| rows-create-10000 | 1 | fusion-charm | 5652074 | 5384317–5788439 | 3.11x | 140854 | 2.84x | 5 | yes |
| rows-create-10000 | 1 | react | 3975326 | 3957230–4115149 | 2.19x | 77528 | 1.56x | 27 | yes |
| rows-create-10000 | 1 | react-reflex | 4134522 | 4084980–4324451 | 2.27x | 87104 | 1.76x | 1148 | yes |
| rows-create-10000 | 1 | react-upstream | 3923934 | 3907187–4037548 | 2.16x | 78514 | 1.58x | 640 | yes |
| rows-create-10000 | 1 | roact | 2157596 | 2100143–2326608 | 1.19x | 166051 | 3.35x | 0 | yes |
| rows-create-10000 | 1 | seam | 2508310 | 2462245–2595409 | 1.38x | 238342 | 4.81x | 0 | yes |
| rows-create-10000 | 1 | signals | 1949843 | 1869642–2062097 | 1.07x | 89738 | 1.81x | 16 | yes |
| rows-create-10000 | 1 | vide | 1947052 | 1767824–2226701 | 1.07x | 48491 | 0.98x | 8 | yes |
| rows-remove-one | 1 | plain | 900 | 800–1000 | 1.00x | 5239 | 1.00x | 1 | yes |
| rows-remove-one | 1 | blend | 1300 | 1221–1400 | 1.44x | 19801 | 3.78x | 8 | yes |
| rows-remove-one | 1 | compose | 600 | 500–700 | 0.67x | 5579 | 1.06x | 18 | yes |
| rows-remove-one | 1 | fusion (workaround) | 33065 | 32002–56170 | 36.74x | 11426 | 2.18x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 32600 | 30924–45226 | 36.22x | 15354 | 2.93x | 0 | yes |
| rows-remove-one | 1 | react | 26300 | 15420–53905 | 29.22x | 15708 | 3.00x | 0 | yes |
| rows-remove-one | 1 | react-reflex | 34800 | 26600–63912 | 38.67x | 16644 | 3.18x | 42 | yes |
| rows-remove-one | 1 | react-upstream | 25830 | 16800–26374 | 28.70x | 15501 | 2.96x | 16 | yes |
| rows-remove-one | 1 | roact | 18800 | 15600–20200 | 20.89x | 16766 | 3.20x | 0 | yes |
| rows-remove-one | 1 | seam | 7100 | 6700–9600 | 7.89x | 23678 | 4.52x | 0 | yes |
| rows-remove-one | 1 | signals | 1855 | 1600–2100 | 2.06x | 9085 | 1.73x | 8 | yes |
| rows-remove-one | 1 | vide | 1100 | 900–1200 | 1.22x | 5025 | 0.96x | 8 | yes |
| rows-swap | 1 | plain | 200 | 200–300 | 1.00x | 4606 | 1.00x | 0 | yes |
| rows-swap | 1 | blend | 700 | 600–800 | 3.50x | 18763 | 4.07x | 0 | yes |
| rows-swap | 1 | compose | 0 | 0–100 | 0.00x | 5047 | 1.10x | 22 | yes |
| rows-swap | 1 | fusion | 31200 | 29637–38904 | 156.00x | 10024 | 2.18x | 1 | yes |
| rows-swap | 1 | fusion-charm | 29840 | 28841–31400 | 149.20x | 13951 | 3.03x | 0 | yes |
| rows-swap | 1 | react | 34242 | 28600–41600 | 171.21x | 15118 | 3.28x | 0 | yes |
| rows-swap | 1 | react-reflex | 46409 | 36352–94504 | 232.04x | 16303 | 3.54x | 67 | yes |
| rows-swap | 1 | react-upstream | 39428 | 29200–79463 | 197.14x | 15431 | 3.35x | 0 | yes |
| rows-swap | 1 | roact | 20005 | 13403–30502 | 100.03x | 16761 | 3.64x | 0 | yes |
| rows-swap | 1 | seam | 5000 | 4532–5933 | 25.00x | 23227 | 5.04x | 0 | yes |
| rows-swap | 1 | signals | 600 | 600–650 | 3.00x | 8609 | 1.87x | 8 | yes |
| rows-swap | 1 | vide | 0 | 0–100 | 0.00x | 4508 | 0.98x | 0 | yes |
| rows-update-every-10th | 1 | plain | 3818 | 3300–9133 | 1.00x | 4234 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 3942 | 3600–4322 | 1.03x | 18824 | 4.45x | 1 | yes |
| rows-update-every-10th | 1 | compose | 3626 | 3400–3700 | 0.95x | 4657 | 1.10x | 12 | yes |
| rows-update-every-10th | 1 | fusion | 3844 | 3700–4000 | 1.01x | 10052 | 2.37x | 0 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4217 | 4000–4900 | 1.10x | 13980 | 3.30x | 0 | yes |
| rows-update-every-10th | 1 | react | 3900 | 3700–6300 | 1.02x | 7399 | 1.75x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 7100 | 4900–18232 | 1.86x | 8392 | 1.98x | 67 | yes |
| rows-update-every-10th | 1 | react-upstream | 3900 | 3800–4800 | 1.02x | 7472 | 1.76x | 48 | yes |
| rows-update-every-10th | 1 | roact | 3805 | 3400–5876 | 1.00x | 16188 | 3.82x | 0 | yes |
| rows-update-every-10th | 1 | seam | 6800 | 6000–8002 | 1.78x | 23764 | 5.61x | 1 | yes |
| rows-update-every-10th | 1 | signals | 4100 | 3800–6000 | 1.07x | 8866 | 2.09x | 8 | yes |
| rows-update-every-10th | 1 | vide | 4200 | 3727–4600 | 1.10x | 4660 | 1.10x | 8 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.

The shared columns use only the workloads that every lane measured: 23 for time (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-update-every-10th`) and 23 for heap (`update-leaf`, `update-batched`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `status-panel`, `scene-3d`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 1.91x | 9.44x | 1.81x | 9.42x |
| compose | 30 | 1.62x | 3.42x | 1.57x | 3.44x |
| fusion | 30 | 4.19x | 5.22x | 3.32x | 6.02x |
| fusion-charm | 30 | 4.37x | 7.13x | 3.48x | 7.86x |
| react | 29 | 3.04x | 3.73x | 2.55x | 4.82x |
| react-reflex | 29 | 3.75x | 7.98x | 3.13x | 10.55x |
| react-upstream | 29 | 3.14x | 3.09x | 2.62x | 5.15x |
| roact | 29 | 2.39x | 4.65x | 2.03x | 6.03x |
| seam | 30 | 3.02x | 10.33x | 2.65x | 12.30x |
| signals | 29 | 1.60x | 2.31x | 1.55x | 2.49x |
| vide | 30 | 1.65x | 2.54x | 1.59x | 2.69x |
