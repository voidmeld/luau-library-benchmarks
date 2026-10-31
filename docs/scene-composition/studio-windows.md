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
| Harness revision | `8eba504` |
| Date | 2026-10-31 |

## Results

| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| update-leaf | 20 | plain | 600 | 500–710 | 1.00x | 25 | 1.00x | 0 | yes |
| update-leaf | 20 | blend | 2600 | 2100–2900 | 4.33x | 750 | 30.00x | 1 | yes |
| update-leaf | 20 | compose | 2500 | 2500–2801 | 4.17x | 101 | 4.04x | 1 | yes |
| update-leaf | 20 | fusion | 2500 | 2400–2900 | 4.17x | 115 | 4.60x | 0 | yes |
| update-leaf | 20 | fusion-charm | 3204 | 2900–4000 | 5.34x | 110 | 4.40x | 0 | yes |
| update-leaf | 20 | react | 2600 | 2500–2800 | 4.33x | 292 | 11.68x | 0 | yes |
| update-leaf | 20 | react-reflex | 3300 | 3200–4700 | 5.50x | 299 | 11.96x | 6 | yes |
| update-leaf | 20 | react-upstream | 2600 | 2000–3100 | 4.33x | 300 | 12.00x | 0 | yes |
| update-leaf | 20 | roact | 2400 | 1900–2700 | 4.00x | 960 | 38.40x | 0 | yes |
| update-leaf | 20 | seam | 2100 | 1800–2400 | 3.50x | 41 | 1.64x | 1 | yes |
| update-leaf | 20 | signals | 2900 | 2500–3200 | 4.83x | 51 | 2.04x | 0 | yes |
| update-leaf | 20 | vide | 2500 | 2300–2900 | 4.17x | 3 | 0.12x | 0 | yes |
| update-batched | 20 | plain | 4100 | 4000–4201 | 1.00x | 20 | 1.00x | 1 | yes |
| update-batched | 20 | blend | 12215 | 11500–13500 | 2.98x | 916 | 45.80x | 0 | yes |
| update-batched | 20 | compose | 8700 | 7900–8913 | 2.12x | 343 | 17.15x | 9 | yes |
| update-batched | 20 | fusion | 19600 | 18600–20400 | 4.78x | 517 | 25.85x | 0 | yes |
| update-batched | 20 | fusion-charm | 41025 | 39800–43506 | 10.01x | 1118 | 55.90x | 0 | yes |
| update-batched | 20 | react | 8453 | 8300–8800 | 2.06x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | react-reflex | 69600 | 68113–79303 | 16.98x | 775 | 38.75x | 16 | yes |
| update-batched | 20 | react-upstream | 8200 | 7900–9100 | 2.00x | 477 | 23.85x | 0 | yes |
| update-batched | 20 | roact | 8600 | 7700–9000 | 2.10x | 1170 | 58.50x | 0 | yes |
| update-batched | 20 | seam | 12901 | 12200–13401 | 3.15x | 1849 | 92.45x | 0 | yes |
| update-batched | 20 | signals | 9900 | 8842–11143 | 2.41x | 605 | 30.25x | 0 | yes |
| update-batched | 20 | vide | 8900 | 8300–9700 | 2.17x | 332 | 16.60x | 0 | yes |
| update-repeated | 10 | plain | 0 | 0–0 | plain below resolution | 2 | 1.00x | 1 | yes |
| update-repeated | 10 | blend | 2801 | 2500–3300 | plain below resolution | 8 | 4.00x | 1 | yes |
| update-repeated | 10 | compose | 300 | 200–600 | plain below resolution | 5 | 2.50x | 1 | yes |
| update-repeated | 10 | fusion | 23000 | 21901–23300 | plain below resolution | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | fusion-charm | 1300 | 1100–1400 | plain below resolution | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | react | 5300 | 5100–6100 | plain below resolution | 1 | 0.50x | 0 | yes |
| update-repeated | 10 | react-reflex | 900 | 400–1000 | plain below resolution | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | react-upstream | 5200 | 4900–6500 | plain below resolution | 0 | 0.00x | 0 | yes |
| update-repeated | 10 | roact | 6300 | 5800–6400 | plain below resolution | 6 | 3.00x | 0 | yes |
| update-repeated | 10 | seam | 1700 | 1500–1900 | plain below resolution | 10 | 5.00x | 0 | yes |
| update-repeated | 10 | signals | 1000 | 800–1400 | plain below resolution | 4 | 2.00x | 0 | yes |
| update-repeated | 10 | vide | 500 | 400–600 | plain below resolution | 3 | 1.50x | 0 | yes |
| branch-swap | 20 | plain | 19900 | 18671–22300 | 1.00x | 2 | 1.00x | 0 | yes |
| branch-swap | 20 | blend | 27700 | 27100–30806 | 1.39x | 43 | 21.50x | 0 | yes |
| branch-swap | 20 | compose | 25300 | 24408–26500 | 1.27x | 8 | 4.00x | 9 | yes |
| branch-swap | 20 | fusion | 25600 | 24954–27200 | 1.29x | 5 | 2.50x | 0 | yes |
| branch-swap | 20 | fusion-charm | 25500 | 24600–27520 | 1.28x | 7 | 3.50x | 0 | yes |
| branch-swap | 20 | react | 29702 | 27106–30900 | 1.49x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | react-reflex | 27500 | 26000–28506 | 1.38x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | react-upstream | 28400 | 28000–32003 | 1.43x | 10 | 5.00x | 0 | yes |
| branch-swap | 20 | roact | 26500 | 25902–28100 | 1.33x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | seam | 24201 | 23700–26400 | 1.22x | 11 | 5.50x | 0 | yes |
| branch-swap | 20 | signals | 24501 | 22900–26404 | 1.23x | 5 | 2.50x | 1 | yes |
| branch-swap | 20 | vide | 25000 | 24700–29669 | 1.26x | 13 | 6.50x | 8 | yes |
| keyed-prepend | 10 | plain | 1769 | 1600–2200 | 1.00x | 64 | 1.00x | 0 | yes |
| keyed-prepend | 10 | blend | 5200 | 4900–5300 | 2.94x | 1514 | 23.66x | 0 | yes |
| keyed-prepend | 10 | compose | 3800 | 3600–5100 | 2.15x | 547 | 8.55x | 17 | yes |
| keyed-prepend | 10 | fusion (workaround) | 19805 | 16318–22901 | 11.20x | 1543 | 24.11x | 1 | yes |
| keyed-prepend | 10 | fusion-charm (workaround) | 19153 | 17200–23688 | 10.83x | 1546 | 24.16x | 1 | yes |
| keyed-prepend | 10 | react | 11700 | 10200–13200 | 6.61x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | react-reflex | 10953 | 10545–12200 | 6.19x | 793 | 12.39x | 0 | yes |
| keyed-prepend | 10 | react-upstream | 11200 | 9800–11708 | 6.33x | 785 | 12.27x | 0 | yes |
| keyed-prepend | 10 | roact | 6200 | 5400–7200 | 3.50x | 369 | 5.77x | 8 | yes |
| keyed-prepend | 10 | seam | 10925 | 10500–11100 | 6.18x | 2479 | 38.73x | 0 | yes |
| keyed-prepend | 10 | signals | 3000 | 2500–3500 | 1.70x | 61 | 0.95x | 8 | yes |
| keyed-prepend | 10 | vide | 5100 | 4400–5300 | 2.88x | 647 | 10.11x | 1 | yes |
| keyed-insert | 10 | plain | 1000 | 1000–1000 | 1.00x | 56 | 1.00x | 0 | yes |
| keyed-insert | 10 | blend | 4500 | 3700–4703 | 4.50x | 1515 | 27.05x | 1 | yes |
| keyed-insert | 10 | compose | 3000 | 2900–3800 | 3.00x | 527 | 9.41x | 5 | yes |
| keyed-insert | 10 | fusion (workaround) | 15900 | 14700–19630 | 15.90x | 1543 | 27.55x | 1 | yes |
| keyed-insert | 10 | fusion-charm (workaround) | 16311 | 14400–16500 | 16.31x | 1601 | 28.59x | 1 | yes |
| keyed-insert | 10 | react | 8800 | 7900–9400 | 8.80x | 819 | 14.62x | 0 | yes |
| keyed-insert | 10 | react-reflex | 9400 | 9101–10000 | 9.40x | 819 | 14.62x | 0 | yes |
| keyed-insert | 10 | react-upstream | 9100 | 8600–10300 | 9.10x | 811 | 14.48x | 0 | yes |
| keyed-insert | 10 | roact | 6000 | 5200–6400 | 6.00x | 362 | 6.46x | 0 | yes |
| keyed-insert | 10 | seam | 9600 | 8700–9700 | 9.60x | 2487 | 44.41x | 0 | yes |
| keyed-insert | 10 | signals | 2200 | 1600–2500 | 2.20x | 61 | 1.09x | 8 | yes |
| keyed-insert | 10 | vide | 3400 | 3300–4700 | 3.40x | 654 | 11.68x | 1 | yes |
| keyed-shuffle | 10 | plain | 1000 | 1000–1000 | 1.00x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | blend | 3100 | 2400–4000 | 3.10x | 1456 | 24.27x | 0 | yes |
| keyed-shuffle | 10 | compose | 2600 | 2400–3600 | 2.60x | 538 | 8.97x | 10 | yes |
| keyed-shuffle | 10 | fusion | 16400 | 15100–17551 | 16.40x | 1399 | 23.32x | 1 | yes |
| keyed-shuffle | 10 | fusion-charm | 15623 | 15000–16703 | 15.62x | 1409 | 23.48x | 1 | yes |
| keyed-shuffle | 10 | react | 14800 | 14700–16508 | 14.80x | 786 | 13.10x | 0 | yes |
| keyed-shuffle | 10 | react-reflex | 15100 | 14604–15742 | 15.10x | 780 | 13.00x | 0 | yes |
| keyed-shuffle | 10 | react-upstream | 15000 | 13900–16100 | 15.00x | 778 | 12.97x | 0 | yes |
| keyed-shuffle | 10 | roact | 4600 | 4300–5000 | 4.60x | 369 | 6.15x | 1 | yes |
| keyed-shuffle | 10 | seam | 8800 | 8200–9700 | 8.80x | 2471 | 41.18x | 0 | yes |
| keyed-shuffle | 10 | signals | 2100 | 1900–2300 | 2.10x | 60 | 1.00x | 0 | yes |
| keyed-shuffle | 10 | vide | 3900 | 3400–4600 | 3.90x | 636 | 10.60x | 0 | yes |
| events | 1 | plain | 2501 | 1800–2800 | 1.00x | 1 | 1.00x | 0 | yes |
| events | 1 | blend | 2200 | 1900–3100 | 0.88x | 1 | 1.00x | 0 | yes |
| events | 1 | compose | 2100 | 1800–2800 | 0.84x | 2 | 2.00x | 1 | yes |
| events | 1 | fusion | 2500 | 2100–2700 | 1.00x | 0 | 0.00x | 0 | yes |
| events | 1 | fusion-charm | 2600 | 2000–2900 | 1.04x | 1 | 1.00x | 0 | yes |
| events | 1 | react | 3200 | 2700–3400 | 1.28x | 1 | 1.00x | 0 | yes |
| events | 1 | react-reflex | 2800 | 2200–3200 | 1.12x | 1 | 1.00x | 8 | yes |
| events | 1 | react-upstream | 3000 | 2900–4212 | 1.20x | 1 | 1.00x | 0 | yes |
| events | 1 | roact | 2800 | 2502–3000 | 1.12x | 1 | 1.00x | 0 | yes |
| events | 1 | seam | 2100 | 1900–2800 | 0.84x | 1 | 1.00x | 0 | yes |
| events | 1 | signals | 2600 | 2500–3400 | 1.04x | 1 | 1.00x | 0 | yes |
| events | 1 | vide | 2700 | 2600–3200 | 1.08x | 2 | 2.00x | 0 | yes |
| animate-many | 1 | plain | 2600 | 2100–2900 | 1.00x | 48 | 1.00x | 0 | yes |
| animate-many | 1 | blend | 10400 | 9700–11306 | 4.00x | 1795 | 37.40x | 0 | yes |
| animate-many | 1 | compose | 8400 | 8100–9100 | 3.23x | 873 | 18.19x | 11 | yes |
| animate-many | 1 | fusion | 69401 | 68601–69901 | 26.69x | 1130 | 23.54x | 1 | yes |
| animate-many | 1 | fusion-charm | 73409 | 70923–74401 | 28.23x | 1153 | 24.02x | 1 | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — |
| animate-many | 1 | seam | 20204 | 19800–21700 | 7.77x | 2922 | 60.88x | 1 | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — |
| animate-many | 1 | vide | 10802 | 9900–11700 | 4.15x | 392 | 8.17x | 0 | yes |
| status-panel | 10 | plain | 800 | 700–1200 | 1.00x | 2 | 1.00x | 1 | yes |
| status-panel | 10 | blend | 2900 | 2700–3100 | 3.62x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | compose | 2900 | 2500–3000 | 3.62x | 25 | 12.50x | 1 | yes |
| status-panel | 10 | fusion | 3300 | 2600–3400 | 4.12x | 56 | 28.00x | 0 | yes |
| status-panel | 10 | fusion-charm | 3000 | 2900–3200 | 3.75x | 70 | 35.00x | 0 | yes |
| status-panel | 10 | react | 3400 | 3301–3800 | 4.25x | 41 | 20.50x | 0 | yes |
| status-panel | 10 | react-reflex | 3200 | 3100–4300 | 4.00x | 36 | 18.00x | 0 | yes |
| status-panel | 10 | react-upstream | 3500 | 3000–3800 | 4.38x | 41 | 20.50x | 0 | yes |
| status-panel | 10 | roact | 2400 | 1800–2500 | 3.00x | 32 | 16.00x | 0 | yes |
| status-panel | 10 | seam | 3100 | 2700–3700 | 3.88x | 140 | 70.00x | 0 | yes |
| status-panel | 10 | signals | 2500 | 2000–3000 | 3.12x | 7 | 3.50x | 0 | yes |
| status-panel | 10 | vide | 2500 | 2300–2601 | 3.12x | 32 | 16.00x | 0 | yes |
| scene-3d | 10 | plain | 2000 | 1900–2200 | 1.00x | 11 | 1.00x | 0 | yes |
| scene-3d | 10 | blend | 4800 | 4501–5300 | 2.40x | 566 | 51.45x | 0 | yes |
| scene-3d | 10 | compose | 3800 | 2900–4600 | 1.90x | 198 | 18.00x | 1 | yes |
| scene-3d | 10 | fusion | 22601 | 21501–25400 | 11.30x | 527 | 47.91x | 0 | yes |
| scene-3d | 10 | fusion-charm | 20700 | 20000–23700 | 10.35x | 531 | 48.27x | 0 | yes |
| scene-3d | 10 | react | 4200 | 3500–4700 | 2.10x | 231 | 21.00x | 0 | yes |
| scene-3d | 10 | react-reflex | 3400 | 3100–4600 | 1.70x | 232 | 21.09x | 0 | yes |
| scene-3d | 10 | react-upstream | 3800 | 3700–4600 | 1.90x | 229 | 20.82x | 0 | yes |
| scene-3d | 10 | roact | 4200 | 3900–4700 | 2.10x | 590 | 53.64x | 0 | yes |
| scene-3d | 10 | seam | 8702 | 8100–10000 | 4.35x | 1787 | 162.45x | 0 | yes |
| scene-3d | 10 | signals | 5609 | 5100–6000 | 2.80x | 698 | 63.45x | 0 | yes |
| scene-3d | 10 | vide | 4100 | 3600–4900 | 2.05x | 219 | 19.91x | 8 | yes |
| derived-diamond | 3 | plain | 0 | 0–100 | plain below resolution | 5 | 1.00x | 8 | yes |
| derived-diamond | 3 | blend | 100 | 0–200 | plain below resolution | 28 | 5.60x | 0 | yes |
| derived-diamond | 3 | compose | 200 | 100–200 | plain below resolution | 11 | 2.20x | 1 | yes |
| derived-diamond | 3 | fusion | 100 | 0–200 | plain below resolution | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | fusion-charm | 200 | 0–300 | plain below resolution | 11 | 2.20x | 1 | yes |
| derived-diamond | 3 | react | 200 | 100–500 | plain below resolution | 1 | 0.20x | 0 | yes |
| derived-diamond | 3 | react-reflex | 400 | 200–500 | plain below resolution | 13 | 2.60x | 4 | yes |
| derived-diamond | 3 | react-upstream | 300 | 200–600 | plain below resolution | 2 | 0.40x | 1 | yes |
| derived-diamond | 3 | roact | 100 | 100–200 | plain below resolution | 10 | 2.00x | 3 | yes |
| derived-diamond | 3 | seam | 100 | 0–400 | plain below resolution | 21 | 4.20x | 0 | yes |
| derived-diamond | 3 | signals | 100 | 0–200 | plain below resolution | 9 | 1.80x | 0 | yes |
| derived-diamond | 3 | vide | 100 | 0–300 | plain below resolution | 6 | 1.20x | 0 | yes |
| derived-chain-100 | 3 | plain | 0 | 0–100 | plain below resolution | 61 | 1.00x | 0 | yes |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 200 | 100–200 | plain below resolution | 152 | 2.49x | 2 | yes |
| derived-chain-100 | 3 | fusion | 600 | 300–700 | plain below resolution | 127 | 2.08x | 0 | yes |
| derived-chain-100 | 3 | fusion-charm | 600 | 400–1000 | plain below resolution | 137 | 2.25x | 1 | yes |
| derived-chain-100 | 3 | react | 500 | 300–500 | plain below resolution | 2 | 0.03x | 2 | yes |
| derived-chain-100 | 3 | react-reflex | 400 | 300–400 | plain below resolution | 20 | 0.33x | 12 | yes |
| derived-chain-100 | 3 | react-upstream | 300 | 300–600 | plain below resolution | 9 | 0.15x | 9 | yes |
| derived-chain-100 | 3 | roact | 100 | 100–300 | plain below resolution | 10 | 0.16x | 3 | yes |
| derived-chain-100 | 3 | seam | 800 | 400–900 | plain below resolution | 279 | 4.57x | 0 | yes |
| derived-chain-100 | 3 | signals | 300 | 100–500 | plain below resolution | 174 | 2.85x | 0 | yes |
| derived-chain-100 | 3 | vide | 100 | 100–200 | plain below resolution | 93 | 1.52x | 0 | yes |
| derived-fan-in-1000 | 3 | plain | 0 | 0–0 | plain below resolution | 599 | 1.00x | 0 | yes |
| derived-fan-in-1000 | 3 | blend | 200 | 100–300 | plain below resolution | 1543 | 2.58x | 1 | yes |
| derived-fan-in-1000 | 3 | compose | 300 | 300–400 | plain below resolution | 696 | 1.16x | 0 | yes |
| derived-fan-in-1000 | 3 | fusion | 1000 | 800–1200 | plain below resolution | 906 | 1.51x | 8 | yes |
| derived-fan-in-1000 | 3 | fusion-charm | 1300 | 1100–1600 | plain below resolution | 2837 | 4.74x | 0 | yes |
| derived-fan-in-1000 | 3 | react | 1400 | 1300–1700 | plain below resolution | 322 | 0.54x | 1 | yes |
| derived-fan-in-1000 | 3 | react-reflex | 9653 | 8016–10046 | plain below resolution | 5257 | 8.78x | 36 | yes |
| derived-fan-in-1000 | 3 | react-upstream | 1800 | 1200–2300 | plain below resolution | 323 | 0.54x | 1 | yes |
| derived-fan-in-1000 | 3 | roact | 600 | 500–700 | plain below resolution | 105 | 0.18x | 4 | yes |
| derived-fan-in-1000 | 3 | seam | 1700 | 1500–2600 | plain below resolution | 2963 | 4.95x | 0 | yes |
| derived-fan-in-1000 | 3 | signals | 600 | 600–1100 | plain below resolution | 1221 | 2.04x | 1 | yes |
| derived-fan-in-1000 | 3 | vide | 400 | 200–600 | plain below resolution | 529 | 0.88x | 0 | yes |
| filter-as-you-type | 1 | plain | 6300 | 6200–6411 | 1.00x | 155 | 1.00x | 1 | yes |
| filter-as-you-type | 1 | blend | 15100 | 14900–16700 | 2.40x | 2980 | 19.23x | 0 | yes |
| filter-as-you-type | 1 | compose | 10100 | 9300–10781 | 1.60x | 953 | 6.15x | 9 | yes |
| filter-as-you-type | 1 | fusion (workaround) | 26430 | 25036–28452 | 4.20x | 2601 | 16.78x | 1 | yes |
| filter-as-you-type | 1 | fusion-charm (workaround) | 24901 | 21600–25551 | 3.95x | 2603 | 16.79x | 1 | yes |
| filter-as-you-type | 1 | react | 16100 | 14400–16817 | 2.56x | 17 | 0.11x | 8 | yes |
| filter-as-you-type | 1 | react-reflex | 15603 | 14509–15900 | 2.48x | 765 | 4.94x | 4 | yes |
| filter-as-you-type | 1 | react-upstream | 16000 | 15100–16900 | 2.54x | 11 | 0.07x | 2 | yes |
| filter-as-you-type | 1 | roact | 10800 | 10300–10903 | 1.71x | 511 | 3.30x | 3 | yes |
| filter-as-you-type | 1 | seam | 25263 | 20400–32402 | 4.01x | 3996 | 25.78x | 0 | yes |
| filter-as-you-type | 1 | signals | 7600 | 6600–8000 | 1.21x | 37 | 0.24x | 0 | yes |
| filter-as-you-type | 1 | vide | 10201 | 9600–10700 | 1.62x | 967 | 6.24x | 0 | yes |
| theme-propagation | 3 | plain | 95105 | 94501–97313 | 1.00x | 207 | 1.00x | 0 | yes |
| theme-propagation | 3 | blend | 95804 | 95200–104400 | 1.01x | 1998 | 9.65x | 1 | yes |
| theme-propagation | 3 | compose | 98203 | 97519–100101 | 1.03x | 547 | 2.64x | 2 | yes |
| theme-propagation | 3 | fusion | 101012 | 98638–103825 | 1.06x | 811 | 3.92x | 1 | yes |
| theme-propagation | 3 | fusion-charm | 105056 | 98145–118601 | 1.10x | 820 | 3.96x | 1 | yes |
| theme-propagation | 3 | react | 133932 | 124849–157504 | 1.41x | 10 | 0.05x | 10 | yes |
| theme-propagation | 3 | react-reflex | 126524 | 121901–132304 | 1.33x | 4976 | 24.04x | 4 | yes |
| theme-propagation | 3 | react-upstream | 127615 | 124403–151608 | 1.34x | 3 | 0.01x | 2 | yes |
| theme-propagation | 3 | roact | 117737 | 115801–121903 | 1.24x | 2819 | 13.62x | 3 | yes |
| theme-propagation | 3 | seam | 92101 | 91070–94904 | 0.97x | 3429 | 16.57x | 0 | yes |
| theme-propagation | 3 | signals | 100100 | 98590–110447 | 1.05x | 880 | 4.25x | 0 | yes |
| theme-propagation | 3 | vide | 99704 | 97519–139012 | 1.05x | 597 | 2.88x | 1 | yes |
| hud-per-frame | 1 | plain | 3000 | 2400–3500 | 1.00x | 25 | 1.00x | 0 | yes |
| hud-per-frame | 1 | blend | 5300 | 5100–5700 | 1.77x | 63 | 2.52x | 0 | yes |
| hud-per-frame | 1 | compose | 4500 | 4100–5001 | 1.50x | 29 | 1.16x | 2 | yes |
| hud-per-frame | 1 | fusion | 12001 | 11600–12900 | 4.00x | 56 | 2.24x | 3 | yes |
| hud-per-frame | 1 | fusion-charm | 16300 | 15500–17100 | 5.43x | 91 | 3.64x | 1 | yes |
| hud-per-frame | 1 | react | 3900 | 3600–4900 | 1.30x | 41 | 1.64x | 0 | yes |
| hud-per-frame | 1 | react-reflex | 8600 | 7600–9400 | 2.87x | 53 | 2.12x | 9 | yes |
| hud-per-frame | 1 | react-upstream | 4800 | 3800–4800 | 1.60x | 34 | 1.36x | 0 | yes |
| hud-per-frame | 1 | roact | 4400 | 3982–4801 | 1.47x | 90 | 3.60x | 0 | yes |
| hud-per-frame | 1 | seam | 8800 | 7800–9001 | 2.93x | 169 | 6.76x | 0 | yes |
| hud-per-frame | 1 | signals | 6700 | 6200–7000 | 2.23x | 73 | 2.92x | 0 | yes |
| hud-per-frame | 1 | vide | 5672 | 5400–5702 | 1.89x | 26 | 1.04x | 0 | yes |
| teardown-under-load | 1 | plain | 111704 | 110207–132301 | 1.00x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | blend | 63803 | 60805–68601 | 0.57x | 6 | 1.20x | 0 | yes |
| teardown-under-load | 1 | compose | 117402 | 116336–137311 | 1.05x | 7 | 1.40x | 1 | yes |
| teardown-under-load | 1 | fusion | 79273 | 70401–81769 | 0.71x | 5 | 1.00x | 0 | yes |
| teardown-under-load | 1 | fusion-charm | 74705 | 73200–90675 | 0.67x | 7 | 1.40x | 0 | yes |
| teardown-under-load | 1 | react | 125706 | 122102–136902 | 1.13x | 959 | 191.80x | 0 | yes |
| teardown-under-load | 1 | react-reflex | 125704 | 123200–128010 | 1.13x | 952 | 190.40x | 0 | yes |
| teardown-under-load | 1 | react-upstream | 123001 | 119602–263620 | 1.10x | 943 | 188.60x | 0 | yes |
| teardown-under-load | 1 | roact | 114901 | 113000–116502 | 1.03x | 78 | 15.60x | 1 | yes |
| teardown-under-load | 1 | seam | 124435 | 122504–140211 | 1.11x | 8 | 1.60x | 6 | yes |
| teardown-under-load | 1 | signals | 120414 | 118374–199220 | 1.08x | 13 | 2.60x | 0 | yes |
| teardown-under-load | 1 | vide | 60400 | 58636–61300 | 0.54x | 5 | 1.00x | 1 | yes |
| open-close-retention | 1 | plain | 219686 | 217002–225936 | 1.00x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | blend | 112711 | 109418–114302 | 0.51x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | compose | 234290 | 230312–235830 | 1.07x | 7 | 1.40x | 2 | yes |
| open-close-retention | 1 | fusion | 139609 | 134484–145660 | 0.64x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | fusion-charm | 133945 | 132704–136204 | 0.61x | 7 | 1.40x | 0 | yes |
| open-close-retention | 1 | react | 256252 | 246521–294860 | 1.17x | 251 | 50.20x | 0 | yes |
| open-close-retention | 1 | react-reflex | 251708 | 245310–259379 | 1.15x | 252 | 50.40x | 0 | yes |
| open-close-retention | 1 | react-upstream | 254511 | 247204–276921 | 1.16x | 251 | 50.20x | 0 | yes |
| open-close-retention | 1 | roact | 248315 | 245558–251127 | 1.13x | 22 | 4.40x | 0 | yes |
| open-close-retention | 1 | seam | 284210 | 270058–288531 | 1.29x | 9 | 1.80x | 0 | yes |
| open-close-retention | 1 | signals | 245903 | 239611–256508 | 1.12x | 5 | 1.00x | 0 | yes |
| open-close-retention | 1 | vide | 90100 | 89501–91203 | 0.41x | 5 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | plain | 8203 | 7300–8500 | 1.00x | 21 | 1.00x | 0 | yes |
| tree-expand-collapse | 1 | blend | 18500 | 17801–21103 | 2.26x | 829 | 39.48x | 8 | yes |
| tree-expand-collapse | 1 | compose | 12900 | 12500–13801 | 1.57x | 68 | 3.24x | 5 | yes |
| tree-expand-collapse | 1 | fusion (workaround) | 24600 | 23301–30600 | 3.00x | 173 | 8.24x | 1 | yes |
| tree-expand-collapse | 1 | fusion-charm (workaround) | 23600 | 20400–25400 | 2.88x | 167 | 7.95x | 1 | yes |
| tree-expand-collapse | 1 | react | 14700 | 14500–17202 | 1.79x | 3 | 0.14x | 2 | yes |
| tree-expand-collapse | 1 | react-reflex | 14800 | 14302–15500 | 1.80x | 616 | 29.33x | 4 | yes |
| tree-expand-collapse | 1 | react-upstream | 15700 | 15300–16000 | 1.91x | 2 | 0.10x | 8 | yes |
| tree-expand-collapse | 1 | roact | 11100 | 10700–11600 | 1.35x | 35 | 1.67x | 3 | yes |
| tree-expand-collapse | 1 | seam | 28200 | 24802–34605 | 3.44x | 148 | 7.05x | 1 | yes |
| tree-expand-collapse | 1 | signals | 9200 | 8400–10900 | 1.12x | 22 | 1.05x | 1 | yes |
| tree-expand-collapse | 1 | vide | 13000 | 11700–13048 | 1.58x | 71 | 3.38x | 0 | yes |
| form-validation | 1 | plain | 2816 | 2600–3100 | 1.00x | 49 | 1.00x | 0 | yes |
| form-validation | 1 | blend | 9000 | 8001–10200 | 3.20x | 336 | 6.86x | 0 | yes |
| form-validation | 1 | compose | 8700 | 8400–9100 | 3.09x | 102 | 2.08x | 1 | yes |
| form-validation | 1 | fusion | 10500 | 9400–11404 | 3.73x | 118 | 2.41x | 1 | yes |
| form-validation | 1 | fusion-charm | 10300 | 9200–11100 | 3.66x | 155 | 3.16x | 0 | yes |
| form-validation | 1 | react | 17600 | 17200–19800 | 6.25x | 181 | 3.69x | 0 | yes |
| form-validation | 1 | react-reflex | 20000 | 17500–21500 | 7.10x | 265 | 5.41x | 6 | yes |
| form-validation | 1 | react-upstream | 17900 | 17000–19900 | 6.36x | 181 | 3.69x | 1 | yes |
| form-validation | 1 | roact | 11700 | 11400–11900 | 4.15x | 71 | 1.45x | 4 | yes |
| form-validation | 1 | seam | 8900 | 8500–9600 | 3.16x | 349 | 7.12x | 1 | yes |
| form-validation | 1 | signals | 9900 | 8000–10100 | 3.52x | 154 | 3.14x | 0 | yes |
| form-validation | 1 | vide | 9000 | 8400–9601 | 3.20x | 70 | 1.43x | 0 | yes |
| table-sort-filter | 1 | plain | 15202 | 14501–15407 | 1.00x | 85 | 1.00x | 0 | yes |
| table-sort-filter | 1 | blend | 34100 | 33300–35937 | 2.24x | 5812 | 68.38x | 1 | yes |
| table-sort-filter | 1 | compose | 24243 | 23100–24900 | 1.59x | 1671 | 19.66x | 25 | yes |
| table-sort-filter | 1 | fusion (workaround) | 56403 | 55300–64001 | 3.71x | 4927 | 57.96x | 1 | yes |
| table-sort-filter | 1 | fusion-charm (workaround) | 54248 | 50500–57401 | 3.57x | 4930 | 58.00x | 0 | yes |
| table-sort-filter | 1 | react | 52917 | 51228–57600 | 3.48x | 2052 | 24.14x | 2 | yes |
| table-sort-filter | 1 | react-reflex | 58278 | 57331–60028 | 3.83x | 2058 | 24.21x | 12 | yes |
| table-sort-filter | 1 | react-upstream | 56207 | 54600–60113 | 3.70x | 2052 | 24.14x | 2 | yes |
| table-sort-filter | 1 | roact | 25000 | 23700–25429 | 1.64x | 1062 | 12.49x | 11 | yes |
| table-sort-filter | 1 | seam | 57700 | 46035–60215 | 3.80x | 8056 | 94.78x | 0 | yes |
| table-sort-filter | 1 | signals | 17400 | 16900–17816 | 1.14x | 76 | 0.89x | 0 | yes |
| table-sort-filter | 1 | vide | 31111 | 30603–31616 | 2.05x | 1922 | 22.61x | 0 | yes |
| library-load | 1 | plain | 0 | 0–100 | plain below resolution | 1 | 1.00x | 0 | yes |
| library-load | 1 | blend | 100 | 100–100 | plain below resolution | 414 | 414.00x | 418 | yes |
| library-load | 1 | compose | 100 | 100–100 | plain below resolution | 472 | 472.00x | 468 | yes |
| library-load | 1 | fusion | 100 | 100–200 | plain below resolution | 185 | 185.00x | 184 | yes |
| library-load | 1 | fusion-charm | 100 | 0–200 | plain below resolution | 229 | 229.00x | 228 | yes |
| library-load | 1 | react | 200 | 100–200 | plain below resolution | 1327 | 1327.00x | 1319 | yes |
| library-load | 1 | react-reflex | 200 | 100–300 | plain below resolution | 1459 | 1459.00x | 1457 | yes |
| library-load | 1 | react-upstream | 300 | 100–300 | plain below resolution | 1433 | 1433.00x | 1433 | yes |
| library-load | 1 | roact | 100 | 100–200 | plain below resolution | 121 | 121.00x | 116 | yes |
| library-load | 1 | seam | 0 | 0–0 | plain below resolution | 187 | 187.00x | 185 | yes |
| library-load | 1 | signals | 0 | 0–100 | plain below resolution | 26 | 26.00x | 25 | yes |
| library-load | 1 | vide | 100 | 0–200 | plain below resolution | 105 | 105.00x | 105 | yes |
| rows-append-1000 | 1 | plain | 156300 | 154703–166646 | 1.00x | 9763 | 1.00x | 0 | yes |
| rows-append-1000 | 1 | blend | 215401 | 198300–238780 | 1.38x | 38569 | 3.95x | 0 | yes |
| rows-append-1000 | 1 | compose | 172000 | 164205–241785 | 1.10x | 10435 | 1.07x | 10 | yes |
| rows-append-1000 | 1 | fusion | 319255 | 311614–326834 | 2.04x | 21082 | 2.16x | 0 | yes |
| rows-append-1000 | 1 | fusion-charm | 330020 | 319654–334409 | 2.11x | 28786 | 2.95x | 2 | yes |
| rows-append-1000 | 1 | react | 229014 | 217307–257964 | 1.47x | 23409 | 2.40x | 232 | yes |
| rows-append-1000 | 1 | react-reflex | 246364 | 242682–279721 | 1.58x | 25014 | 2.56x | 0 | yes |
| rows-append-1000 | 1 | react-upstream | 224861 | 221001–266717 | 1.44x | 23146 | 2.37x | 0 | yes |
| rows-append-1000 | 1 | roact | 221321 | 187933–260721 | 1.42x | 33403 | 3.42x | 0 | yes |
| rows-append-1000 | 1 | seam | 249206 | 199666–274767 | 1.59x | 46711 | 4.78x | 1 | yes |
| rows-append-1000 | 1 | signals | 182021 | 172714–198205 | 1.16x | 17806 | 1.82x | 0 | yes |
| rows-append-1000 | 1 | vide | 168400 | 161035–228910 | 1.08x | 9507 | 0.97x | 8 | yes |
| rows-clear | 1 | plain | 23404 | 22200–25108 | 1.00x | 2472 | 1.00x | 0 | yes |
| rows-clear | 1 | blend | 40415 | 39206–44400 | 1.73x | 4034 | 1.63x | 0 | yes |
| rows-clear | 1 | compose | 27500 | 27000–28407 | 1.18x | 1776 | 0.72x | 0 | yes |
| rows-clear | 1 | fusion | 55100 | 53408–56200 | 2.35x | 3281 | 1.33x | 0 | yes |
| rows-clear | 1 | fusion-charm | 53303 | 52501–56856 | 2.28x | 7441 | 3.01x | 0 | yes |
| rows-clear | 1 | react | 27050 | 26801–28700 | 1.16x | 4512 | 1.83x | 0 | yes |
| rows-clear | 1 | react-reflex | 32239 | 31295–56312 | 1.38x | 6490 | 2.63x | 44 | yes |
| rows-clear | 1 | react-upstream | 27500 | 26200–28700 | 1.18x | 4720 | 1.91x | 216 | yes |
| rows-clear | 1 | roact | 29331 | 28319–31500 | 1.25x | 4230 | 1.71x | 8 | yes |
| rows-clear | 1 | seam | 34700 | 23403–35700 | 1.48x | 9135 | 3.70x | 0 | yes |
| rows-clear | 1 | signals | 24484 | 24300–25642 | 1.05x | 4482 | 1.81x | 0 | yes |
| rows-clear | 1 | vide | 23230 | 22904–23754 | 0.99x | 1620 | 0.66x | 8 | yes |
| rows-create-1000 | 1 | plain | 143260 | 141380–147452 | 1.00x | 5186 | 1.00x | 0 | yes |
| rows-create-1000 | 1 | blend | 200705 | 189634–221614 | 1.40x | 19785 | 3.82x | 0 | yes |
| rows-create-1000 | 1 | compose | 161848 | 156859–186734 | 1.13x | 5541 | 1.07x | 34 | yes |
| rows-create-1000 | 1 | fusion | 229467 | 213353–236614 | 1.60x | 11011 | 2.12x | 0 | yes |
| rows-create-1000 | 1 | fusion-charm | 223946 | 221561–234050 | 1.56x | 14941 | 2.88x | 1 | yes |
| rows-create-1000 | 1 | react | 196411 | 185229–255651 | 1.37x | 8144 | 1.57x | 0 | yes |
| rows-create-1000 | 1 | react-reflex | 203255 | 191404–225942 | 1.42x | 9081 | 1.75x | 28 | yes |
| rows-create-1000 | 1 | react-upstream | 196639 | 190707–248744 | 1.37x | 7903 | 1.52x | 0 | yes |
| rows-create-1000 | 1 | roact | 188771 | 182108–207626 | 1.32x | 16682 | 3.22x | 0 | yes |
| rows-create-1000 | 1 | seam | 220483 | 185911–242053 | 1.54x | 23661 | 4.56x | 0 | yes |
| rows-create-1000 | 1 | signals | 161304 | 150716–184751 | 1.13x | 9050 | 1.75x | 2 | yes |
| rows-create-1000 | 1 | vide | 162721 | 156217–164586 | 1.14x | 4957 | 0.96x | 9 | yes |
| rows-create-10000 | 1 | plain | 1807998 | 1764100–1884940 | 1.00x | 49594 | 1.00x | 2 | yes |
| rows-create-10000 | 1 | blend | 2453736 | 2424676–2498218 | 1.36x | 193410 | 3.90x | 0 | yes |
| rows-create-10000 | 1 | compose | 2006769 | 1944011–2026177 | 1.11x | 51041 | 1.03x | 0 | yes |
| rows-create-10000 | 1 | fusion | 6275414 | 5842574–6473179 | 3.47x | 105706 | 2.13x | 10 | yes |
| rows-create-10000 | 1 | fusion-charm | 6173209 | 6141483–6194564 | 3.41x | 144868 | 2.92x | 1 | yes |
| rows-create-10000 | 1 | react | 4307639 | 4272634–4412929 | 2.38x | 76962 | 1.55x | 676 | yes |
| rows-create-10000 | 1 | react-reflex | 4417706 | 4207198–4548773 | 2.44x | 85836 | 1.73x | 912 | yes |
| rows-create-10000 | 1 | react-upstream | 4360084 | 4277656–4671418 | 2.41x | 77978 | 1.57x | 104 | yes |
| rows-create-10000 | 1 | roact | 2278368 | 2268114–2585639 | 1.26x | 166038 | 3.35x | 0 | yes |
| rows-create-10000 | 1 | seam | 2631088 | 2463074–2637882 | 1.46x | 236705 | 4.77x | 12 | yes |
| rows-create-10000 | 1 | signals | 2154377 | 1958300–2228588 | 1.19x | 89665 | 1.81x | 8 | yes |
| rows-create-10000 | 1 | vide | 1963264 | 1912515–2224523 | 1.09x | 48483 | 0.98x | 20 | yes |
| rows-remove-one | 1 | plain | 800 | 800–1200 | 1.00x | 5231 | 1.00x | 0 | yes |
| rows-remove-one | 1 | blend | 1300 | 1200–1500 | 1.62x | 19801 | 3.79x | 9 | yes |
| rows-remove-one | 1 | compose | 500 | 500–900 | 0.62x | 5539 | 1.06x | 10 | yes |
| rows-remove-one | 1 | fusion (workaround) | 34582 | 33300–48110 | 43.23x | 11426 | 2.18x | 1 | yes |
| rows-remove-one | 1 | fusion-charm (workaround) | 32400 | 31900–33000 | 40.50x | 15362 | 2.94x | 0 | yes |
| rows-remove-one | 1 | react | 24717 | 16000–46022 | 30.90x | 15724 | 3.01x | 7 | yes |
| rows-remove-one | 1 | react-reflex | 34501 | 33200–57805 | 43.13x | 16645 | 3.18x | 50 | yes |
| rows-remove-one | 1 | react-upstream | 24700 | 16800–39207 | 30.88x | 15461 | 2.96x | 0 | yes |
| rows-remove-one | 1 | roact | 18947 | 17000–19911 | 23.68x | 16782 | 3.21x | 1 | yes |
| rows-remove-one | 1 | seam | 7000 | 6700–7200 | 8.75x | 23685 | 4.53x | 0 | yes |
| rows-remove-one | 1 | signals | 1614 | 1425–2038 | 2.02x | 9078 | 1.74x | 8 | yes |
| rows-remove-one | 1 | vide | 1100 | 900–1200 | 1.38x | 5018 | 0.96x | 0 | yes |
| rows-swap | 1 | plain | 200 | 200–300 | 1.00x | 4606 | 1.00x | 1 | yes |
| rows-swap | 1 | blend | 738 | 600–800 | 3.69x | 18764 | 4.07x | 1 | yes |
| rows-swap | 1 | compose | 100 | 0–100 | 0.50x | 5028 | 1.09x | 0 | yes |
| rows-swap | 1 | fusion | 30400 | 29900–32103 | 152.00x | 10032 | 2.18x | 0 | yes |
| rows-swap | 1 | fusion-charm | 29823 | 29312–31129 | 149.12x | 13959 | 3.03x | 1 | yes |
| rows-swap | 1 | react | 31835 | 26900–38100 | 159.18x | 15142 | 3.29x | 16 | yes |
| rows-swap | 1 | react-reflex | 44702 | 33706–106913 | 223.51x | 16303 | 3.54x | 75 | yes |
| rows-swap | 1 | react-upstream | 42500 | 29900–98614 | 212.50x | 15479 | 3.36x | 32 | yes |
| rows-swap | 1 | roact | 13900 | 12904–17909 | 69.50x | 16737 | 3.63x | 0 | yes |
| rows-swap | 1 | seam | 5283 | 4800–5700 | 26.41x | 23203 | 5.04x | 8 | yes |
| rows-swap | 1 | signals | 600 | 522–700 | 3.00x | 8609 | 1.87x | 8 | yes |
| rows-swap | 1 | vide | 0 | 0–100 | 0.00x | 4508 | 0.98x | 0 | yes |
| rows-update-every-10th | 1 | plain | 3600 | 3500–3700 | 1.00x | 4235 | 1.00x | 0 | yes |
| rows-update-every-10th | 1 | blend | 3617 | 3600–4086 | 1.00x | 18839 | 4.45x | 1 | yes |
| rows-update-every-10th | 1 | compose | 3600 | 3300–4131 | 1.00x | 4609 | 1.09x | 4 | yes |
| rows-update-every-10th | 1 | fusion | 3700 | 3600–3829 | 1.03x | 10052 | 2.37x | 1 | yes |
| rows-update-every-10th | 1 | fusion-charm | 4100 | 3700–4400 | 1.14x | 13988 | 3.30x | 0 | yes |
| rows-update-every-10th | 1 | react | 4027 | 3734–4769 | 1.12x | 7398 | 1.75x | 0 | yes |
| rows-update-every-10th | 1 | react-reflex | 5822 | 5000–7952 | 1.62x | 8360 | 1.97x | 51 | yes |
| rows-update-every-10th | 1 | react-upstream | 3918 | 3800–6100 | 1.09x | 7464 | 1.76x | 40 | yes |
| rows-update-every-10th | 1 | roact | 3900 | 3602–4700 | 1.08x | 16188 | 3.82x | 1 | yes |
| rows-update-every-10th | 1 | seam | 5263 | 4593–5429 | 1.46x | 23764 | 5.61x | 0 | yes |
| rows-update-every-10th | 1 | signals | 3700 | 3671–4405 | 1.03x | 8858 | 2.09x | 0 | yes |
| rows-update-every-10th | 1 | vide | 3800 | 3700–3922 | 1.06x | 4652 | 1.10x | 0 | yes |

## Lane workarounds

These rows pass parity with a lane workaround in place of a library mechanism. The results table marks each one with `(workaround)`. Each note states what the row measures. The summary includes these rows.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.


## Summary

The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.

The shared columns use only the workloads that every lane measured: 23 for time (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-update-every-10th`) and 26 for heap (`update-leaf`, `update-batched`, `branch-swap`, `keyed-prepend`, `keyed-insert`, `keyed-shuffle`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `filter-as-you-type`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `tree-expand-collapse`, `form-validation`, `table-sort-filter`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-remove-one`, `rows-swap`, `rows-update-every-10th`).

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 1.92x | 9.77x | 1.81x | 10.48x |
| compose | 30 | 1.53x | 3.63x | 1.55x | 3.60x |
| fusion | 30 | 4.27x | 5.68x | 3.37x | 5.82x |
| fusion-charm | 30 | 4.42x | 6.89x | 3.50x | 7.62x |
| react | 29 | 3.16x | 3.24x | 2.66x | 4.35x |
| react-reflex | 29 | 3.75x | 8.08x | 3.14x | 10.46x |
| react-upstream | 29 | 3.20x | 3.47x | 2.67x | 4.11x |
| roact | 29 | 2.40x | 4.77x | 2.07x | 5.87x |
| seam | 30 | 3.01x | 10.67x | 2.63x | 11.63x |
| signals | 29 | 1.65x | 2.30x | 1.61x | 2.37x |
| vide | 30 | 1.65x | 2.80x | 1.59x | 2.86x |
