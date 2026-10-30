# Headless results

Harness commit: `7440d2e2378d498bc93ea7da2c9c2d5e70893be1`. Workflow run: [Library comparison 41054872733](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41054872733). Runner: `ubuntu-latest`, six scene composition shards merged. Mode: `like-for-like`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **like-for-like**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

# Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Framework | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| update-leaf | 50 | plain | 22.112 | 19.666–29.835 | 1.00x | 2816.000 | 1.00x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | blend | 84.444 | 75.852–116.057 | 3.82x | 3501.000 | 1.24x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 83.462 | 79.479–97.323 | 3.77x | 2852.000 | 1.01x | 97.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 133.215 | 127.960–155.431 | 6.02x | 2843.000 | 1.01x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion-charm | 233.853 | 224.591–257.112 | 10.58x | 2837.000 | 1.01x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 86.779 | 83.547–100.618 | 3.92x | 3505.000 | 1.24x | 511.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 147.392 | 139.111–192.131 | 6.67x | 3506.000 | 1.25x | 511.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | react-upstream | 87.229 | 81.112–112.692 | 3.94x | 3506.000 | 1.25x | 512.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 51.907 | 47.198–66.815 | 2.35x | 3727.000 | 1.32x | 65.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 136.496 | 130.275–187.412 | 6.17x | 2822.000 | 1.00x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 91.011 | 84.298–106.950 | 4.12x | 2834.000 | 1.01x | 57.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 72.676 | 67.115–88.155 | 3.29x | 2803.000 | 1.00x | 65.000 | 50 | 0 | 0 | 0 |
| update-batched | 20 | plain | 755.479 | 722.509–805.834 | 1.00x | 1715.000 | 1.00x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 5168.585 | 5043.809–5323.858 | 6.84x | 2582.000 | 1.51x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 3058.155 | 2974.660–3192.416 | 4.05x | 2099.000 | 1.22x | 137.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 12048.709 | 11654.080–12591.110 | 15.95x | 2256.000 | 1.32x | 128.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion-charm | 18661.308 | 18320.880–19053.373 | 24.70x | 2833.000 | 1.65x | 136.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 2412.484 | 2297.042–2574.205 | 3.19x | 2787.000 | 1.63x | 691.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 40616.936 | 35519.051–46456.440 | 53.76x | 3086.000 | 1.80x | 707.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | react-upstream | 2447.867 | 2248.259–3401.792 | 3.24x | 2787.000 | 1.63x | 692.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 3943.792 | 3856.642–4092.824 | 5.22x | 2842.000 | 1.66x | 65.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 7051.334 | 6949.832–7272.454 | 9.33x | 3011.000 | 1.76x | 104.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 5650.050 | 5543.912–5823.289 | 7.48x | 2319.000 | 1.35x | 72.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 3905.644 | 3762.601–4011.833 | 5.17x | 2032.000 | 1.18x | 65.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 35.794 | 34.121–40.791 | 1.00x | 14.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 3657.515 | 3610.445–3819.370 | 102.18x | 21.000 | 1.50x | 8.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | compose | 664.090 | 646.093–688.707 | 18.55x | 18.000 | 1.29x | 2.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 21712.964 | 21094.121–22996.771 | 606.61x | 18.000 | 1.29x | 1.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | fusion-charm | 1038.546 | 1011.796–1086.759 | 29.01x | 19.000 | 1.36x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 8744.477 | 8620.009–9402.520 | 244.30x | 370.000 | 26.43x | 370.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | react-reflex | 1140.009 | 1087.420–1198.737 | 31.85x | 221.000 | 15.79x | 205.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | react-upstream | 8955.306 | 8778.498–9103.599 | 250.19x | 371.000 | 26.50x | 370.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | roact | 2585.770 | 2513.290–2847.554 | 72.24x | 19.000 | 1.36x | 1.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 1985.875 | 1947.937–2058.604 | 55.48x | 24.000 | 1.71x | 5.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 939.126 | 925.486–1060.590 | 26.24x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 474.615 | 457.390–572.584 | 13.26x | 17.000 | 1.21x | 9.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 3555.785 | 3340.244–3966.852 | 1.00x | 147.000 | 1.00x | 128.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 8963.005 | 8677.092–9772.714 | 2.52x | 165.000 | 1.12x | 128.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 5373.118 | 5181.978–5794.129 | 1.51x | 155.000 | 1.05x | 131.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 5518.258 | 5227.655–6359.939 | 1.55x | 143.000 | 0.97x | 128.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | fusion-charm | 5743.598 | 5436.074–6469.032 | 1.62x | 153.000 | 1.04x | 128.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react | 7906.915 | 7505.676–9600.435 | 2.22x | 366.000 | 2.49x | 338.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | react-reflex | 8057.416 | 7402.954–8862.949 | 2.27x | 367.000 | 2.50x | 338.000 | 1010 | 510 | 20 | 20 |
| branch-swap | 20 | react-upstream | 7929.467 | 7147.478–8986.680 | 2.23x | 374.000 | 2.54x | 338.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | roact | 6912.710 | 6574.338–7464.098 | 1.94x | 158.000 | 1.07x | 128.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 4907.738 | 4584.976–5614.587 | 1.38x | 159.000 | 1.08x | 141.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | signals | 4102.014 | 3831.851–4790.880 | 1.15x | 151.000 | 1.03x | 128.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | vide | 4747.619 | 4538.980–5197.068 | 1.34x | 153.000 | 1.04x | 122.000 | 3530 | 510 | 0 | 0 |
| keyed-prepend | 10 | plain | 2156.837 | 2113.717–2206.680 | 1.00x | 1771.000 | 1.00x | 64.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 4902.573 | 4821.954–4979.628 | 2.27x | 3132.000 | 1.77x | 57.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 4088.193 | 4043.039–4221.155 | 1.90x | 2307.000 | 1.30x | 137.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react | 16630.251 | 16053.664–17425.746 | 7.71x | 2729.000 | 1.54x | 332.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | react-reflex | 16406.724 | 15865.804–20746.216 | 7.61x | 2730.000 | 1.54x | 333.000 | 3150 | 50 | 10 | 10 |
| keyed-prepend | 10 | react-upstream | 16594.284 | 16187.875–17387.696 | 7.69x | 2730.000 | 1.54x | 340.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | roact | 8011.129 | 7900.842–8431.313 | 3.71x | 2053.000 | 1.16x | 65.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 14464.858 | 14149.309–15100.315 | 6.71x | 3545.000 | 2.00x | 133.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | 2128.004 | 2085.584–2161.346 | 0.99x | 1761.000 | 0.99x | 64.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | vide | 4663.457 | 4601.411–4771.018 | 2.16x | 2346.000 | 1.32x | 65.000 | 3400 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1986.764 | 1931.412–2034.954 | 1.00x | 1763.000 | 1.00x | 64.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 5007.211 | 4874.083–5174.502 | 2.52x | 3140.000 | 1.78x | 72.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 3012.601 | 2970.334–3176.857 | 1.52x | 2295.000 | 1.30x | 133.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react | 15178.314 | 14374.806–16299.728 | 7.64x | 2754.000 | 1.56x | 332.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | react-reflex | 15252.833 | 14475.460–19018.441 | 7.68x | 2756.000 | 1.56x | 333.000 | 1650 | 50 | 10 | 10 |
| keyed-insert | 10 | react-upstream | 15145.542 | 14608.033–16958.264 | 7.62x | 2763.000 | 1.57x | 333.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | roact | 7478.216 | 7165.364–7952.037 | 3.76x | 2053.000 | 1.16x | 65.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 14342.550 | 13678.636–15462.151 | 7.22x | 3545.000 | 2.01x | 141.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | 2002.253 | 1911.995–2073.145 | 1.01x | 1768.000 | 1.00x | 64.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | vide | 3330.272 | 3254.011–3534.793 | 1.68x | 2347.000 | 1.33x | 66.000 | 1900 | 50 | 0 | 0 |
| keyed-shuffle | 10 | plain | 1532.425 | 1494.273–1604.289 | 1.00x | 1767.000 | 1.00x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 2897.547 | 2816.695–3017.110 | 1.89x | 3090.000 | 1.75x | 64.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 3170.107 | 3120.453–3289.269 | 2.07x | 2306.000 | 1.31x | 137.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 19442.527 | 18822.708–20796.358 | 12.69x | 3170.000 | 1.79x | 193.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion-charm | 19557.812 | 19025.146–21690.830 | 12.76x | 3171.000 | 1.79x | 192.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 27235.796 | 26786.545–28459.052 | 17.77x | 2723.000 | 1.54x | 332.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | react-reflex | 27384.773 | 26839.313–28504.076 | 17.87x | 2724.000 | 1.54x | 333.000 | 2990 | 0 | 10 | 10 |
| keyed-shuffle | 10 | react-upstream | 27612.419 | 26944.790–30468.859 | 18.02x | 2724.000 | 1.54x | 340.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | roact | 7371.971 | 7198.346–7587.154 | 4.81x | 2052.000 | 1.16x | 65.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 12412.534 | 11987.319–12898.563 | 8.10x | 3544.000 | 2.01x | 140.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | 1564.655 | 1498.211–1687.675 | 1.02x | 1760.000 | 1.00x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | vide | 3059.239 | 2985.822–3200.504 | 2.00x | 2322.000 | 1.31x | 65.000 | 2990 | 0 | 0 | 0 |
| events | 1 | plain | 215.906 | 204.228–307.594 | 1.00x | 10.000 | 1.00x | 1.000 | 30 | 11 | 10 | 0 |
| events | 1 | blend | 391.246 | 376.187–421.445 | 1.81x | 2.000 | 0.20x | 1.000 | 113 | 11 | 10 | 0 |
| events | 1 | compose | 465.457 | 326.343–913.518 | 2.16x | 4.000 | 0.40x | 3.000 | 30 | 11 | 10 | 0 |
| events | 1 | fusion | 328.876 | 284.019–368.987 | 1.52x | 2.000 | 0.20x | 1.000 | 113 | 11 | 10 | 0 |
| events | 1 | fusion-charm | 345.436 | 297.999–414.776 | 1.60x | 2.000 | 0.20x | 1.000 | 113 | 11 | 10 | 0 |
| events | 1 | react | 528.688 | 487.866–646.165 | 2.45x | 252.000 | 25.20x | 251.000 | 40 | 11 | 10 | 2 |
| events | 1 | react-reflex | 550.696 | 514.145–598.964 | 2.55x | 252.000 | 25.20x | 251.000 | 40 | 11 | 10 | 2 |
| events | 1 | react-upstream | 514.981 | 460.510–567.797 | 2.39x | 253.000 | 25.30x | 252.000 | 40 | 11 | 10 | 2 |
| events | 1 | roact | 350.358 | 277.854–520.694 | 1.62x | 2.000 | 0.20x | 1.000 | 41 | 11 | 10 | 0 |
| events | 1 | seam | 317.511 | 277.504–370.729 | 1.47x | 2.000 | 0.20x | 1.000 | 30 | 11 | 10 | 0 |
| events | 1 | signals | 280.814 | 246.976–295.873 | 1.30x | 2.000 | 0.20x | 1.000 | 30 | 11 | 10 | 0 |
| events | 1 | vide | 254.184 | 229.366–280.699 | 1.18x | 3.000 | 0.30x | 3.000 | 103 | 11 | 10 | 0 |
| animate-many | 1 | plain | 1381.658 | 1361.718–1399.846 | 1.00x | 1555.000 | 1.00x | 40.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | blend | 11249.602 | 10674.906–11779.552 | 8.14x | 2733.000 | 1.76x | 91.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | compose | 9168.811 | 8928.732–9603.411 | 6.64x | 2373.000 | 1.53x | 74.000 | 3800 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 127457.137 | 124109.697–132655.849 | 92.25x | 2762.000 | 1.78x | 164.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | fusion-charm | 130540.977 | 120600.030–144622.449 | 94.48x | 2771.000 | 1.78x | 164.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 24322.244 | 23214.811–26333.553 | 17.60x | 3569.000 | 2.30x | 69.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | vide | 5648.855 | 5455.895–5763.266 | 4.09x | 1976.000 | 1.27x | 61.000 | 6000 | 0 | 0 | 30 |
| status-panel | 20 | plain | 143.233 | 139.781–158.055 | 1.00x | 144.000 | 1.00x | 10.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | blend | 814.110 | 792.890–842.924 | 5.68x | 248.000 | 1.72x | 2.000 | 438 | 21 | 0 | 0 |
| status-panel | 20 | compose | 538.495 | 500.284–560.717 | 3.76x | 184.000 | 1.28x | 6.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | fusion | 2225.149 | 2194.517–2304.863 | 15.54x | 252.000 | 1.75x | 14.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | fusion-charm | 2449.093 | 2405.902–2559.987 | 17.10x | 258.000 | 1.79x | 14.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | react | 2405.352 | 2354.717–2515.026 | 16.79x | 414.000 | 2.88x | 222.000 | 103 | 21 | 0 | 20 |
| status-panel | 20 | react-reflex | 2508.814 | 2485.181–2579.987 | 17.52x | 417.000 | 2.90x | 215.000 | 103 | 21 | 20 | 20 |
| status-panel | 20 | react-upstream | 2427.794 | 2394.010–2468.430 | 16.95x | 414.000 | 2.88x | 222.000 | 103 | 21 | 0 | 20 |
| status-panel | 20 | roact | 697.989 | 679.428–751.694 | 4.87x | 177.000 | 1.23x | 2.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | seam | 1687.601 | 1654.228–1776.277 | 11.78x | 286.000 | 1.99x | 8.000 | 82 | 21 | 42 | 21 |
| status-panel | 20 | signals | 306.121 | 296.032–330.227 | 2.14x | 149.000 | 1.03x | 2.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | vide | 426.016 | 407.791–441.024 | 2.97x | 194.000 | 1.35x | 11.000 | 208 | 21 | 0 | 0 |
| scene-3d | 20 | plain | 5661.384 | 3994.936–6564.010 | 1.00x | 1076.000 | 1.00x | 32.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | blend | 9578.252 | 7508.528–11465.306 | 1.69x | 1603.000 | 1.49x | 24.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 8537.545 | 7041.437–9938.450 | 1.51x | 1333.000 | 1.24x | 98.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 73487.278 | 69156.350–77313.826 | 12.98x | 1670.000 | 1.55x | 96.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion-charm | 73677.232 | 70001.718–77037.556 | 13.01x | 1673.000 | 1.55x | 96.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 8075.249 | 5693.503–9779.728 | 1.43x | 1748.000 | 1.62x | 505.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 7760.696 | 6045.522–9073.185 | 1.37x | 1751.000 | 1.63x | 506.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | react-upstream | 7270.122 | 6029.941–8844.141 | 1.28x | 1750.000 | 1.63x | 506.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | 7569.518 | 5464.920–10077.481 | 1.34x | 1639.000 | 1.52x | 33.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | seam | 19500.896 | 17124.713–21163.199 | 3.44x | 2245.000 | 2.09x | 54.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 15148.372 | 13437.129–16686.691 | 2.68x | 1753.000 | 1.63x | 32.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 9621.444 | 8216.787–11152.660 | 1.70x | 1276.000 | 1.19x | 41.000 | 6000 | 0 | 0 | 0 |
| derived-diamond | 3 | plain | 6.470 | 6.179–7.291 | 1.00x | 17.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | blend | 65.788 | 42.915–76.895 | 10.17x | 41.000 | 2.41x | 0.000 | 3 | 0 | 0 | 12 |
| derived-diamond | 3 | compose | 30.206 | 28.973–32.108 | 4.67x | 24.000 | 1.41x | 2.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion | 53.630 | 44.847–63.806 | 8.29x | 21.000 | 1.24x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion-charm | 66.659 | 60.480–74.251 | 10.30x | 24.000 | 1.41x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | react | 238.947 | 223.934–257.664 | 36.93x | 224.000 | 13.18x | 224.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | react-reflex | 251.806 | 238.236–263.223 | 38.92x | 232.000 | 13.65x | 211.000 | 3 | 0 | 3 | 3 |
| derived-diamond | 3 | react-upstream | 245.627 | 237.585–295.461 | 37.96x | 225.000 | 13.24x | 224.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | roact | 45.227 | 35.223–55.512 | 6.99x | 23.000 | 1.35x | 11.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | seam | 35.212 | 32.528–49.393 | 5.44x | 40.000 | 2.35x | 18.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | signals | 19.358 | 18.868–22.264 | 2.99x | 22.000 | 1.29x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | vide | 17.466 | 16.174–18.808 | 2.70x | 28.000 | 1.65x | 2.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | plain | 66.064 | 58.319–79.669 | 1.00x | 82.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 373.909 | 362.688–395.659 | 5.66x | 165.000 | 2.01x | 2.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion | 1087.372 | 1067.294–1129.571 | 16.46x | 152.000 | 1.85x | 13.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion-charm | 1067.464 | 1057.977–1090.387 | 16.16x | 153.000 | 1.87x | 12.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | react | 359.742 | 352.689–374.570 | 5.45x | 223.000 | 2.72x | 223.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | react-reflex | 393.365 | 373.748–405.448 | 5.95x | 232.000 | 2.83x | 210.000 | 3 | 0 | 3 | 3 |
| derived-chain-100 | 3 | react-upstream | 365.683 | 348.371–544.037 | 5.54x | 225.000 | 2.74x | 224.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | roact | 139.812 | 137.838–151.643 | 2.12x | 23.000 | 0.28x | 4.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | seam | 869.725 | 851.531–911.073 | 13.16x | 284.000 | 3.46x | 238.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | signals | 280.434 | 271.778–303.597 | 4.24x | 189.000 | 2.30x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | vide | 180.126 | 159.679–198.591 | 2.73x | 101.000 | 1.23x | 3.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | plain | 196.287 | 183.544–207.198 | 1.00x | 603.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | blend | 447.198 | 418.194–459.200 | 2.28x | 1515.000 | 2.51x | 0.000 | 3 | 0 | 0 | 6 |
| derived-fan-in-1000 | 3 | compose | 745.316 | 688.900–815.889 | 3.80x | 693.000 | 1.15x | 2.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion | 2357.216 | 2285.351–2469.477 | 12.01x | 958.000 | 1.59x | 65.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion-charm | 2466.601 | 2333.191–2625.238 | 12.57x | 2818.000 | 4.67x | 64.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | react | 2522.595 | 2314.606–2699.366 | 12.85x | 1066.000 | 1.77x | 770.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | react-reflex | 9473.748 | 6771.425–12709.931 | 48.26x | 5220.000 | 8.66x | 243.000 | 3 | 0 | 3 | 3 |
| derived-fan-in-1000 | 3 | react-upstream | 2978.009 | 2765.681–3652.843 | 15.17x | 1067.000 | 1.77x | 770.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | roact | 1444.155 | 1378.042–2076.369 | 7.36x | 125.000 | 0.21x | 11.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | seam | 3489.527 | 3441.588–3804.006 | 17.78x | 2885.000 | 4.78x | 2581.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | signals | 895.227 | 846.696–944.520 | 4.56x | 1256.000 | 2.08x | 1.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | vide | 672.219 | 625.512–1011.245 | 3.42x | 542.000 | 0.90x | 10.000 | 3 | 0 | 0 | 0 |
| filter-as-you-type | 1 | plain | 7998.661 | 7732.407–8656.153 | 1.00x | 2887.000 | 1.00x | 136.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | blend | 18471.329 | 17619.265–22203.733 | 2.31x | 5458.000 | 1.89x | 128.000 | 6131 | 437 | 0 | 27 |
| filter-as-you-type | 1 | compose | 11926.847 | 11409.688–13961.359 | 1.49x | 3678.000 | 1.27x | 201.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | react | 22321.532 | 20500.849–24903.388 | 2.79x | 3817.000 | 1.32x | 3792.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | react-reflex | 20712.499 | 20424.136–23501.454 | 2.59x | 3838.000 | 1.33x | 370.000 | 2505 | 437 | 9 | 9 |
| filter-as-you-type | 1 | react-upstream | 21198.876 | 20385.955–23047.772 | 2.65x | 3810.000 | 1.32x | 3793.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | roact | 11937.058 | 11176.275–13962.652 | 1.49x | 3338.000 | 1.16x | 131.000 | 2505 | 437 | 0 | 0 |
| filter-as-you-type | 1 | seam | 29899.190 | 29044.774–32587.716 | 3.74x | 5752.000 | 1.99x | 3741.000 | 2068 | 437 | 874 | 437 |
| filter-as-you-type | 1 | signals | 7745.341 | 7587.247–8085.312 | 0.97x | 2880.000 | 1.00x | 128.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | vide | 11488.905 | 10341.644–12780.034 | 1.44x | 3804.000 | 1.32x | 129.000 | 4690 | 437 | 0 | 0 |
| theme-propagation | 3 | plain | 1147.846 | 1060.352–1446.695 | 1.00x | 5732.000 | 1.00x | 128.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | blend | 2430.744 | 2286.614–3221.973 | 2.12x | 7563.000 | 1.32x | 136.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | compose | 1606.393 | 1519.981–1949.584 | 1.40x | 6201.000 | 1.08x | 258.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion | 6011.277 | 5791.857–6528.735 | 5.24x | 6393.000 | 1.12x | 192.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion-charm | 6001.279 | 5849.325–6601.731 | 5.23x | 6394.000 | 1.12x | 192.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | react | 34614.196 | 31484.215–35960.894 | 30.16x | 10748.000 | 1.88x | 10732.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | react-reflex | 34505.363 | 31560.247–37465.757 | 30.06x | 10756.000 | 1.88x | 402.000 | 3000 | 0 | 3 | 3 |
| theme-propagation | 3 | react-upstream | 37118.187 | 32976.895–42026.713 | 32.34x | 10749.000 | 1.88x | 10733.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | roact | 18358.177 | 17138.097–19724.672 | 15.99x | 8372.000 | 1.46x | 139.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | seam | 2305.209 | 2277.547–3159.977 | 2.01x | 7143.000 | 1.25x | 160.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | signals | 2925.519 | 2894.441–3050.833 | 2.55x | 6437.000 | 1.12x | 144.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | vide | 2569.593 | 2531.311–2637.781 | 2.24x | 6148.000 | 1.07x | 153.000 | 3000 | 0 | 0 | 0 |
| hud-per-frame | 1 | plain | 606.417 | 575.590–657.572 | 1.00x | 149.000 | 1.00x | 10.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | blend | 1396.144 | 1361.991–1414.909 | 2.30x | 190.000 | 1.28x | 10.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | compose | 1014.204 | 989.077–1064.758 | 1.67x | 159.000 | 1.07x | 15.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion | 7022.839 | 6971.694–7118.757 | 11.58x | 173.000 | 1.16x | 12.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion-charm | 9176.711 | 9091.672–9260.436 | 15.13x | 210.000 | 1.41x | 5.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | react | 826.385 | 812.079–923.155 | 1.36x | 393.000 | 2.64x | 244.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | react-reflex | 1951.856 | 1876.767–1994.115 | 3.22x | 413.000 | 2.77x | 245.000 | 1200 | 0 | 60 | 0 |
| hud-per-frame | 1 | react-upstream | 840.872 | 827.407–884.453 | 1.39x | 394.000 | 2.64x | 253.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | roact | 877.701 | 852.845–901.736 | 1.45x | 216.000 | 1.45x | 2.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | seam | 4062.017 | 4020.711–4151.333 | 6.70x | 262.000 | 1.76x | 9.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | signals | 2053.195 | 2023.009–2147.600 | 3.39x | 193.000 | 1.30x | 2.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | vide | 1154.465 | 1115.884–1188.057 | 1.90x | 152.000 | 1.02x | 12.000 | 1200 | 0 | 0 | 60 |
| teardown-under-load | 1 | plain | 23268.602 | 20258.919–27843.070 | 1.00x | 274.000 | 1.00x | 256.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | blend | 55187.144 | 51965.509–56671.101 | 2.37x | 276.000 | 1.01x | 257.000 | 22003 | 2001 | 0 | 4 |
| teardown-under-load | 1 | compose | 32847.879 | 28791.834–35148.984 | 1.41x | 533.000 | 1.95x | 514.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion | 64673.018 | 55949.080–67987.827 | 2.78x | 402.000 | 1.47x | 384.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion-charm | 61197.591 | 59098.200–76252.472 | 2.63x | 404.000 | 1.47x | 384.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | react | 36412.402 | 35561.532–40004.616 | 1.56x | 1583.000 | 5.78x | 650.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | react-reflex | 35926.008 | 34705.191–37136.367 | 1.54x | 1583.000 | 5.78x | 658.000 | 10000 | 2001 | 6 | 2 |
| teardown-under-load | 1 | react-upstream | 37776.346 | 35485.369–42338.031 | 1.62x | 1584.000 | 5.78x | 660.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | roact | 48633.478 | 46685.418–55719.393 | 2.09x | 348.000 | 1.27x | 256.000 | 10001 | 2001 | 0 | 0 |
| teardown-under-load | 1 | seam | 68999.306 | 45244.652–91351.285 | 2.97x | 343.000 | 1.25x | 319.000 | 8000 | 2001 | 4000 | 2000 |
| teardown-under-load | 1 | signals | 29412.857 | 27386.372–32046.220 | 1.26x | 306.000 | 1.12x | 288.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | vide | 36148.712 | 33558.038–40868.401 | 1.55x | 315.000 | 1.15x | 289.000 | 20003 | 2001 | 0 | 6 |
| open-close-retention | 1 | plain | 55023.414 | 47862.259–64408.715 | 1.00x | 530.000 | 1.00x | 512.000 | 20000 | 5010 | 0 | 0 |
| open-close-retention | 1 | blend | 132792.376 | 124380.990–139644.603 | 2.41x | 532.000 | 1.00x | 513.000 | 55030 | 5010 | 0 | 40 |
| open-close-retention | 1 | compose | 86443.339 | 82373.073–90949.961 | 1.57x | 604.000 | 1.14x | 586.000 | 20000 | 5010 | 0 | 0 |
| open-close-retention | 1 | fusion | 127358.858 | 116823.020–136301.730 | 2.31x | 786.000 | 1.48x | 769.000 | 55030 | 5010 | 0 | 0 |
| open-close-retention | 1 | fusion-charm | 119916.875 | 115510.521–130125.510 | 2.18x | 788.000 | 1.49x | 769.000 | 55030 | 5010 | 0 | 0 |
| open-close-retention | 1 | react | 89379.719 | 83497.550–101001.591 | 1.62x | 1010.000 | 1.91x | 760.000 | 25000 | 5010 | 0 | 20 |
| open-close-retention | 1 | react-reflex | 96321.648 | 93647.920–101280.108 | 1.75x | 1020.000 | 1.92x | 768.000 | 25000 | 5010 | 60 | 20 |
| open-close-retention | 1 | react-upstream | 94701.041 | 89342.723–98420.719 | 1.72x | 1019.000 | 1.92x | 761.000 | 25000 | 5010 | 0 | 20 |
| open-close-retention | 1 | roact | 107959.267 | 101994.123–116586.348 | 1.96x | 556.000 | 1.05x | 512.000 | 25010 | 5010 | 0 | 0 |
| open-close-retention | 1 | seam | 116417.071 | 109139.840–122875.349 | 2.12x | 552.000 | 1.04x | 535.000 | 20000 | 5010 | 10000 | 5000 |
| open-close-retention | 1 | signals | 76983.351 | 68681.580–88505.716 | 1.40x | 530.000 | 1.00x | 513.000 | 20000 | 5010 | 0 | 0 |
| open-close-retention | 1 | vide | 79002.523 | 76233.166–82506.488 | 1.44x | 539.000 | 1.02x | 522.000 | 50030 | 5010 | 0 | 60 |
| tree-expand-collapse | 1 | plain | 5795.477 | 5574.724–6683.040 | 1.00x | 225.000 | 1.00x | 128.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | blend | 21415.269 | 19523.465–24145.132 | 3.70x | 858.000 | 3.81x | 128.000 | 7040 | 630 | 0 | 21 |
| tree-expand-collapse | 1 | compose | 13160.364 | 12594.525–14150.899 | 2.27x | 361.000 | 1.60x | 198.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | react | 19339.310 | 17825.193–20411.137 | 3.34x | 1025.000 | 4.56x | 1023.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | react-reflex | 18373.690 | 17774.408–19672.564 | 3.17x | 1046.000 | 4.65x | 370.000 | 2389 | 630 | 7 | 7 |
| tree-expand-collapse | 1 | react-upstream | 20445.917 | 17251.824–22685.764 | 3.53x | 1026.000 | 4.56x | 1024.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | roact | 9661.758 | 9031.217–10174.528 | 1.67x | 240.000 | 1.07x | 139.000 | 2389 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | seam | 25936.512 | 23259.287–29749.624 | 4.48x | 338.000 | 1.50x | 265.000 | 1759 | 630 | 1260 | 630 |
| tree-expand-collapse | 1 | signals | 6265.426 | 6009.236–6924.330 | 1.08x | 218.000 | 0.97x | 128.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | vide | 10641.967 | 9396.844–11543.024 | 1.84x | 269.000 | 1.20x | 129.000 | 5539 | 630 | 0 | 0 |
| form-validation | 1 | plain | 467.749 | 457.640–493.566 | 1.00x | 288.000 | 1.00x | 12.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | blend | 676.551 | 661.703–692.320 | 1.45x | 574.000 | 1.99x | 12.000 | 129 | 0 | 0 | 172 |
| form-validation | 1 | compose | 691.689 | 674.146–727.696 | 1.48x | 356.000 | 1.24x | 19.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | fusion | 1751.499 | 1729.537–1775.895 | 3.74x | 362.000 | 1.26x | 8.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | fusion-charm | 1905.698 | 1867.366–1927.259 | 4.07x | 399.000 | 1.39x | 16.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | react | 9656.292 | 9581.301–9776.858 | 20.64x | 608.000 | 2.11x | 233.000 | 126 | 0 | 0 | 44 |
| form-validation | 1 | react-reflex | 11201.854 | 11036.303–11561.820 | 23.95x | 696.000 | 2.42x | 256.000 | 126 | 0 | 44 | 43 |
| form-validation | 1 | react-upstream | 9716.586 | 9628.450–9791.055 | 20.77x | 601.000 | 2.09x | 226.000 | 126 | 0 | 0 | 44 |
| form-validation | 1 | roact | 5090.920 | 4961.056–5463.769 | 10.88x | 304.000 | 1.06x | 7.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | seam | 1961.053 | 1941.856–2000.546 | 4.19x | 511.000 | 1.77x | 191.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | signals | 604.275 | 584.297–648.037 | 1.29x | 399.000 | 1.39x | 12.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | vide | 434.566 | 420.750–442.702 | 0.93x | 311.000 | 1.08x | 13.000 | 126 | 0 | 0 | 0 |
| table-sort-filter | 1 | plain | 18151.267 | 14527.603–23412.406 | 1.00x | 5756.000 | 1.00x | 264.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | blend | 42706.647 | 35550.517–48124.691 | 2.35x | 10938.000 | 1.90x | 257.000 | 12157 | 937 | 0 | 18 |
| table-sort-filter | 1 | compose | 28155.118 | 27679.695–35078.068 | 1.55x | 7340.000 | 1.28x | 402.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | react | 88104.349 | 77347.999–91502.393 | 4.85x | 7903.000 | 1.37x | 526.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | react-reflex | 86252.131 | 78586.587–89750.928 | 4.75x | 7919.000 | 1.38x | 530.000 | 5594 | 937 | 6 | 6 |
| table-sort-filter | 1 | react-upstream | 83361.984 | 76474.097–87197.777 | 4.59x | 7911.000 | 1.37x | 526.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | roact | 26906.269 | 20875.885–29661.548 | 1.48x | 6661.000 | 1.16x | 260.000 | 5594 | 937 | 0 | 0 |
| table-sort-filter | 1 | seam | 70813.652 | 68441.816–77621.272 | 3.90x | 11485.000 | 2.00x | 7481.000 | 4657 | 937 | 1874 | 937 |
| table-sort-filter | 1 | signals | 18302.493 | 15565.520–21035.372 | 1.01x | 5757.000 | 1.00x | 264.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | vide | 25529.691 | 23836.922–29855.957 | 1.41x | 7604.000 | 1.32x | 265.000 | 10279 | 937 | 0 | 0 |
| library-load | 1 | plain | 15.793 | 9.995–31.777 | 1.00x | 16.000 | 1.00x | 0.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | blend | 6350.538 | 6250.858–6781.024 | 402.11x | 381.000 | 23.81x | 370.000 | 3 | 1 | 0 | 0 |
| library-load | 1 | compose | 49646.072 | 47704.336–61794.518 | 3143.55x | 662.000 | 41.38x | 644.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | fusion | 30538.244 | 28979.172–34484.101 | 1933.66x | 182.000 | 11.38x | 182.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | fusion-charm | 29972.554 | 29589.189–31349.543 | 1897.84x | 223.000 | 13.94x | 214.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | react | 158326.406 | 140509.632–181104.724 | 10025.10x | 1420.000 | 88.75x | 1403.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | react-reflex | 156169.791 | 145010.104–168115.888 | 9888.54x | 1542.000 | 96.38x | 1541.000 | 0 | 3 | 0 | 1 |
| library-load | 1 | react-upstream | 169835.054 | 160321.847–184824.889 | 10753.82x | 1412.000 | 88.25x | 1396.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | roact | 14434.105 | 14086.123–16971.085 | 913.96x | 129.000 | 8.06x | 127.000 | 1 | 1 | 0 | 0 |
| library-load | 1 | seam | 26040.935 | 23276.794–27791.258 | 1648.89x | 198.000 | 12.38x | 180.000 | 0 | 3 | 0 | 0 |
| library-load | 1 | signals | 3424.513 | 3345.334–3560.527 | 216.84x | 42.000 | 2.62x | 33.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | vide | 7855.928 | 7729.259–9349.241 | 497.43x | 106.000 | 6.62x | 97.000 | 3 | 1 | 1 | 0 |
| rows-append-1000 | 1 | plain | 81336.281 | 55358.398–143078.936 | 1.00x | 74442.000 | 1.00x | 2057.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | blend | 116993.065 | 100382.083–169592.156 | 1.44x | 103629.000 | 1.39x | 2065.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | compose | 106235.924 | 73322.827–128555.928 | 1.31x | 76487.000 | 1.03x | 3268.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion | 442195.076 | 433531.173–478343.870 | 5.44x | 88364.000 | 1.19x | 4107.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion-charm | 461720.464 | 445933.015–529068.382 | 5.68x | 95866.000 | 1.29x | 4107.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | react | 161736.569 | 147863.622–210064.589 | 1.99x | 96693.000 | 1.30x | 10981.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | react-reflex | 170534.839 | 151021.047–222971.031 | 2.10x | 100438.000 | 1.35x | 12956.000 | 15000 | 5000 | 2001 | 1 |
| rows-append-1000 | 1 | react-upstream | 157698.824 | 147675.687–208559.597 | 1.94x | 96694.000 | 1.30x | 10982.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | roact | 176270.963 | 104492.306–187750.447 | 2.17x | 97467.000 | 1.31x | 2050.000 | 15000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | seam | 204320.393 | 136701.874–220535.101 | 2.51x | 100835.000 | 1.35x | 35524.000 | 11000 | 5000 | 8000 | 3000 |
| rows-append-1000 | 1 | signals | 103040.801 | 67360.410–132698.347 | 1.27x | 83451.000 | 1.12x | 2049.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | vide | 77789.843 | 69702.152–129273.069 | 0.96x | 77067.000 | 1.04x | 2050.000 | 39000 | 5000 | 2000 | 0 |
| rows-clear | 1 | plain | 25305.332 | 20314.238–27665.561 | 1.00x | 3231.000 | 1.00x | 1033.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | blend | 55907.295 | 52140.208–62114.359 | 2.21x | 4135.000 | 1.28x | 1024.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | compose | 38357.580 | 35829.396–42120.875 | 1.52x | 3352.000 | 1.04x | 1627.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion | 138323.034 | 134520.764–144081.123 | 5.47x | 5376.000 | 1.66x | 2050.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion-charm | 138381.313 | 134155.024–141108.136 | 5.47x | 9129.000 | 2.83x | 2050.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | react | 29223.174 | 28538.163–30031.294 | 1.15x | 6237.000 | 1.93x | 1877.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | react-reflex | 30032.498 | 28252.296–31738.795 | 1.19x | 8111.000 | 2.51x | 1946.000 | 0 | 0 | 1 | 1 |
| rows-clear | 1 | react-upstream | 29650.126 | 28661.697–30614.711 | 1.17x | 6238.000 | 1.93x | 1879.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | roact | 37873.778 | 32758.600–42058.194 | 1.50x | 5108.000 | 1.58x | 1024.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | seam | 99969.882 | 92127.060–107537.108 | 3.95x | 9555.000 | 2.96x | 1158.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | signals | 29888.547 | 24207.779–33893.505 | 1.18x | 5285.000 | 1.64x | 1024.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | vide | 30329.919 | 28040.993–35813.824 | 1.20x | 2629.000 | 0.81x | 1026.000 | 0 | 0 | 0 | 0 |
| rows-create-1000 | 1 | plain | 56995.696 | 50030.425–61651.645 | 1.00x | 37220.000 | 1.00x | 1033.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | blend | 131817.348 | 120390.148–151598.473 | 2.31x | 51821.000 | 1.39x | 1032.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | compose | 77804.752 | 74008.098–83287.258 | 1.37x | 38242.000 | 1.03x | 1643.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion | 227264.080 | 212421.494–242251.193 | 3.99x | 44171.000 | 1.19x | 2058.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion-charm | 239524.640 | 220645.837–269020.902 | 4.20x | 47923.000 | 1.29x | 2049.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | react | 134568.565 | 119172.170–154692.281 | 2.36x | 44749.000 | 1.20x | 5590.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | react-reflex | 140017.426 | 130566.808–155211.855 | 2.46x | 46615.000 | 1.25x | 6587.000 | 15000 | 5000 | 2001 | 1 |
| rows-create-1000 | 1 | react-upstream | 131745.497 | 121214.154–156097.325 | 2.31x | 44749.000 | 1.20x | 5590.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | roact | 100816.002 | 90419.181–112000.333 | 1.77x | 48730.000 | 1.31x | 1033.000 | 15000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | seam | 138344.697 | 112177.372–166937.648 | 2.43x | 50450.000 | 1.36x | 17765.000 | 11000 | 5000 | 8000 | 3000 |
| rows-create-1000 | 1 | signals | 70135.157 | 64577.682–82475.072 | 1.23x | 41736.000 | 1.12x | 1032.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | vide | 72262.688 | 68423.446–81605.094 | 1.27x | 38525.000 | 1.04x | 1034.000 | 39000 | 5000 | 2000 | 0 |
| rows-create-10000 | 1 | plain | 600820.508 | 542573.135–657529.877 | 1.00x | 371166.000 | 1.00x | 8212.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | blend | 1413486.675 | 1409576.761–1462411.379 | 2.35x | 516926.000 | 1.39x | 8204.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | compose | 894528.737 | 804305.034–944735.568 | 1.49x | 381285.000 | 1.03x | 13401.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion | 12473371.834 | 11612073.525–13141836.497 | 20.76x | 438766.000 | 1.18x | 16417.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion-charm | 13023471.769 | 12387179.293–14415104.931 | 21.68x | 476292.000 | 1.28x | 16417.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | react | 4904649.287 | 4783676.453–4982939.818 | 8.16x | 443506.000 | 1.19x | 51881.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | react-reflex | 5061495.015 | 5031778.096–5164529.008 | 8.42x | 462711.000 | 1.25x | 62135.000 | 150000 | 50000 | 20001 | 1 |
| rows-create-10000 | 1 | react-upstream | 4887972.551 | 4823015.404–5029371.994 | 8.14x | 443506.000 | 1.19x | 51882.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | roact | 1052393.171 | 1046031.862–1136387.519 | 1.75x | 485846.000 | 1.31x | 8205.000 | 150000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | seam | 1384485.574 | 1334558.580–1586075.553 | 2.30x | 503839.000 | 1.36x | 176239.000 | 110000 | 50000 | 80000 | 30000 |
| rows-create-10000 | 1 | signals | 783746.656 | 728178.349–862489.779 | 1.30x | 415282.000 | 1.12x | 8212.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | vide | 797574.033 | 771003.990–860476.368 | 1.33x | 383938.000 | 1.03x | 8205.000 | 390000 | 50000 | 20000 | 0 |
| rows-remove-one | 1 | plain | 1598.179 | 1495.165–1873.112 | 1.00x | 37217.000 | 1.00x | 1033.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | blend | 2421.137 | 2265.576–2747.647 | 1.51x | 51805.000 | 1.39x | 1032.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | compose | 1619.859 | 1535.591–1783.394 | 1.01x | 38255.000 | 1.03x | 1627.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | fusion | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | fusion-charm | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | react | 40577.784 | 35814.608–42407.193 | 25.39x | 52150.000 | 1.40x | 5594.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | react-reflex | 45889.581 | 44094.414–48631.207 | 28.71x | 54024.000 | 1.45x | 6583.000 | 500 | 0 | 1 | 1 |
| rows-remove-one | 1 | react-upstream | 40834.654 | 36014.132–43351.660 | 25.55x | 52142.000 | 1.40x | 5594.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | roact | 40955.040 | 38137.315–42949.783 | 25.63x | 48727.000 | 1.31x | 1025.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | seam | 9386.109 | 8790.894–10335.067 | 5.87x | 50449.000 | 1.36x | 17749.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | signals | 2481.019 | 1827.096–2723.453 | 1.55x | 41732.000 | 1.12x | 1040.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | vide | 1884.774 | 1691.703–2051.426 | 1.18x | 38553.000 | 1.04x | 1034.000 | 500 | 0 | 0 | 0 |
| rows-swap | 1 | plain | 997.568 | 841.971–1044.559 | 1.00x | 37235.000 | 1.00x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | blend | 1511.062 | 1347.559–1690.036 | 1.51x | 51837.000 | 1.39x | 1040.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | compose | 958.949 | 858.176–1683.983 | 0.96x | 38273.000 | 1.03x | 1619.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion | 92707.656 | 91954.213–95147.951 | 92.93x | 44227.000 | 1.19x | 2057.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion-charm | 98562.483 | 97548.031–99943.479 | 98.80x | 47979.000 | 1.29x | 2049.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | react | 59938.138 | 57973.438–69086.006 | 60.08x | 52163.000 | 1.40x | 5590.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | react-reflex | 73067.550 | 70722.658–80851.321 | 73.25x | 54037.000 | 1.45x | 6588.000 | 2 | 0 | 1 | 1 |
| rows-swap | 1 | react-upstream | 60502.687 | 58572.290–68772.114 | 60.65x | 52156.000 | 1.40x | 5590.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | roact | 35541.691 | 32923.431–40429.053 | 35.63x | 48747.000 | 1.31x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | seam | 8689.668 | 7941.859–9088.705 | 8.71x | 50450.000 | 1.35x | 17773.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | signals | 1211.385 | 1146.386–1450.238 | 1.21x | 41744.000 | 1.12x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | vide | 394.851 | 328.510–814.190 | 0.40x | 38533.000 | 1.03x | 1034.000 | 2 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | plain | 226.375 | 202.880–263.604 | 1.00x | 37221.000 | 1.00x | 1033.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | blend | 414.155 | 387.647–461.796 | 1.83x | 51835.000 | 1.39x | 1032.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | compose | 302.888 | 273.863–327.563 | 1.34x | 38253.000 | 1.03x | 1645.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion | 541.955 | 505.707–603.501 | 2.39x | 44173.000 | 1.19x | 2058.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion-charm | 844.162 | 798.406–961.771 | 3.73x | 47935.000 | 1.29x | 2052.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react | 348.983 | 307.937–392.265 | 1.54x | 44754.000 | 1.20x | 5598.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react-reflex | 1297.671 | 1172.427–1456.037 | 5.73x | 46613.000 | 1.25x | 6587.000 | 100 | 0 | 1 | 0 |
| rows-update-every-10th | 1 | react-upstream | 359.073 | 342.101–415.459 | 1.59x | 44762.000 | 1.20x | 5606.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | roact | 386.815 | 347.020–425.808 | 1.71x | 48732.000 | 1.31x | 1025.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | seam | 1694.374 | 1381.368–2243.904 | 7.48x | 50451.000 | 1.36x | 1174.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | signals | 408.556 | 368.080–488.806 | 1.80x | 41748.000 | 1.12x | 1026.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | vide | 333.735 | 302.687–384.661 | 1.47x | 38513.000 | 1.03x | 1036.000 | 100 | 0 | 0 | 0 |

## Page retention

Growth is the retained Luau heap after the page closes minus the retained heap with only its source owner and host mounted. Collection runs before both readings. The source owner stays alive during the run. Collection noise can make the difference negative; such a reading counts as 0, as in the Verify mounted and teardown readings.

| Workload | Framework | Median retained growth (KiB) |
| --- | --- | ---: |
| teardown-under-load | plain | 256.000 |
| teardown-under-load | blend | 256.000 |
| teardown-under-load | compose | 513.000 |
| teardown-under-load | fusion | 384.000 |
| teardown-under-load | fusion-charm | 384.000 |
| teardown-under-load | react | 1362.000 |
| teardown-under-load | react-reflex | 1362.000 |
| teardown-under-load | react-upstream | 1362.000 |
| teardown-under-load | roact | 320.000 |
| teardown-under-load | seam | 322.000 |
| teardown-under-load | signals | 288.000 |
| teardown-under-load | vide | 289.000 |
| open-close-retention | plain | 512.000 |
| open-close-retention | blend | 512.000 |
| open-close-retention | compose | 584.000 |
| open-close-retention | fusion | 768.000 |
| open-close-retention | fusion-charm | 768.000 |
| open-close-retention | react | 790.000 |
| open-close-retention | react-reflex | 798.000 |
| open-close-retention | react-upstream | 790.000 |
| open-close-retention | roact | 528.000 |
| open-close-retention | seam | 531.000 |
| open-close-retention | signals | 512.000 |
| open-close-retention | vide | 520.000 |

## Summary

This summary uses the 30 selected workloads and treats time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. A workload whose plain heap is zero has no heap ratio. Lanes support different workloads, so compare a geometric mean only together with its measured count.

The shared columns use only the workloads that every lane measured: 22 for time (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-swap`, `rows-update-every-10th`) and 22 for heap (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-swap`, `rows-update-every-10th`).

| Framework | Supported | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 29 | 3.49x | 1.61x | 3.74x | 1.51x |
| compose | 30 | 30 | 2.74x | 1.33x | 2.96x | 1.31x |
| fusion | 24 | 24 | 12.02x | 1.36x | 10.80x | 1.33x |
| fusion-charm | 24 | 24 | 11.66x | 1.55x | 10.45x | 1.52x |
| react | 29 | 29 | 7.91x | 2.68x | 8.52x | 3.01x |
| react-reflex | 29 | 29 | 9.57x | 2.88x | 10.93x | 3.30x |
| react-upstream | 29 | 29 | 8.00x | 2.69x | 8.68x | 3.02x |
| roact | 29 | 29 | 4.47x | 1.14x | 5.02x | 1.20x |
| seam | 30 | 30 | 6.44x | 1.73x | 6.34x | 1.64x |
| signals | 29 | 29 | 2.24x | 1.16x | 2.66x | 1.16x |
| vide | 30 | 30 | 2.23x | 1.15x | 2.36x | 1.12x |

## Source identities

Harness revision: `7440d2e2378d498bc93ea7da2c9c2d5e70893be1`. Full source state, tools, environment and command are in `context.json`.

| Dependency | Version | Commit | Tree | Rights |
| --- | --- | --- | --- | --- |
| compose | unreleased | `2d9b8d355e258fbc10c31fff93197a40881e9a9c` | `5b2f88a3a16d0362fcd8b998a245fb9cf4437e18` | MIT |
| facet | 0.12.0 | `09512b286ee26ff9910b9a3115b3401fd0837fe1` | `773d9e7f88fb7112469472b0992caee1d90610dd` | MIT |
| fusion | 0.3 | `77e603534ff4013f4049611826ff0309d6000b15` | `715bdf3acd2205f106fc78f5171a56b056323bd0` | MIT |
| vide | 0.4.1 | `5ed4c01940e6bd578fb83253cfbeda0a6c05177c` | `8890f5044158a71592249e2d91646715b98ca4aa` | MIT |
| react | 17.2.1 | `2e652e7ecf269b2611f5b58642c6740fc616f858` | `4aee0834a5e16530171de5ada97126de47cf9c22` | MIT |
| luau-polyfill | 1.2.6 | `cff549d58f24c25f47188459cb24b545cc804830` | `a460ce6c6d9ed0a1ead2100ef8a8f4918df9b2b3` | MIT |
| symbol | 1.0.1 | `15781517cf5df85a8dd0b2181b0c3f86bcc7b6c0` | `69b5eb96fd7f36dadd3c3845afeca585f86dff87` | MIT |
| react-promise | 3.5.0 | `22ee6a02ad333d8182e72fc0d02e43f9d82b8109` | `e2f1f8eb417ae562cc4d53b8f20c534193c0b985` | MIT |
| blend | 12.51.1 | `75c7ed8f4f6a1b04c6885b7980451153b17222b4` | `2009d55e28e2b20153bba3d986db4d8e7eb5df18` | MIT |
| roact | v1.4.4 | `956891b70fdc5410e44e9664719cd0a9f7e6fabd` | `e2b1b9bdf99349d27b8f43b92b3b684a921edc8a` | MIT |
| seam | v1.1.0 | `bc45faa36e2f059ca6fe25f7f7896c16a163abf6` | `44606c00e1f0301f9574b437c322d12042aa9b33` | MIT |
| signals | 0.9.0-unreleased | `25b9a8335e1d5da7b917576356b9ae4c890bcb17` | `2b883aca6fac60b2af44c5deffd739e510e9619a` | MIT |
| reflex | v4.3.1 | `fa0cc3c1ebaafdc70ced5bfc0fa8b2300b8694b2` | `7bec758e4cb240c4e13a8b788de876e7b58f5f01` | MIT |
| charm | charm-v0.11.1 | `af4eb5262d640cf89c56217ab7feb403e939cbd2` | `c1383c7832d8ba663eb68b21b9b7341c874a7007` | MIT |
| react-upstream | v17.1.3 | `7455fb005c68ec63326fcfb6b311da99800980b6` | `096ed4ad4c787f62fa5044ecfb41ed1008619619` | MIT |
| polyfill-upstream | v1.2.3 | `8100f5c609c78d8e0876e502aa3e1f59472b00b7` | `ac7e8886467f0b316614c2c839c883566bec8ad3` | MIT |
| promise-upstream | v3.3.0 | `4508fc738f73c555ceebeb89e7dff1427b8f1e8b` | `427bec669c31bb81aae57dea74d7d9d30308901a` | MIT |
| symbol-upstream | v1.0.0 | `ec62c72f79d94829af867223fc7297912e54deca` | `950e084e0e501b8ce955c6fd2b5b6b509ebef1e9` | MIT |
| reflex-promise | v4.0.0 | `2c6f433903275e689ba1d48402d4a9d6fdc605a5` | `a71184ef76af30ec1270a70b523f352057410942` | MIT |

Raw samples, calibration attempts, parity results and heap readings are in the evidence artifact. Unsupported rows are omissions with reasons, not performance results. Missing evidence does not qualify as a complete comparison.

## Loader fallbacks

The loader binds the cost-model globals of each library file on its first line. These files cannot take that binding. They load with their own copy of the cost-model global table as their environment, so their global reads do not use the Luau fast paths.

- `.lute/dependencies/react-upstream/modules/react-reconciler/src/ReactFiberBeginWork.new.lua`
- `.lute/dependencies/react/modules/react-reconciler/src/ReactFiberBeginWork.new.luau`
- `.lute/dependencies/seam/src/Modules/Types.luau`
