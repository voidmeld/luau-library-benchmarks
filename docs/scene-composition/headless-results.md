# Headless results

Harness commit: `425258bc2602725c302265cc41a92b3e503f8c23`. Workflow run: [Library comparison 41002131734](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41002131734). Runner: `ubuntu-latest`, six scene composition shards merged; summary regenerated from the same shard reports. Mode: `like-for-like`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **like-for-like**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

# Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Framework | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| update-leaf | 50 | plain | 13.646 | 1.00x | 2744.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | blend | 45.784 | 3.36x | 3436.000 | 1.25x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 48.949 | 3.59x | 2755.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 78.323 | 5.74x | 2771.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion-charm | 132.525 | 9.71x | 2765.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 48.027 | 3.52x | 2994.000 | 1.09x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 85.243 | 6.25x | 2995.000 | 1.09x | 0.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | react-upstream | 48.854 | 3.58x | 2994.000 | 1.09x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 30.872 | 2.26x | 3654.000 | 1.33x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 76.010 | 5.57x | 2758.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 51.282 | 3.76x | 2770.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 42.724 | 3.13x | 2738.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-batched | 20 | plain | 1304.450 | 1.00x | 1644.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 6679.635 | 5.12x | 2518.000 | 1.53x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 4591.334 | 3.52x | 1962.000 | 1.19x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 14837.607 | 11.37x | 2128.000 | 1.29x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion-charm | 23888.961 | 18.31x | 2698.000 | 1.64x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 3792.079 | 2.91x | 2097.000 | 1.28x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 72118.907 | 55.29x | 2379.000 | 1.45x | 0.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | react-upstream | 3688.601 | 2.83x | 2097.000 | 1.28x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 5072.648 | 3.89x | 2778.000 | 1.69x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 8970.768 | 6.88x | 2908.000 | 1.77x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 7257.487 | 5.56x | 2256.000 | 1.37x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 5667.256 | 4.34x | 1967.000 | 1.20x | 1.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 39.714 | 1.00x | 14.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 3764.742 | 94.80x | 21.000 | 1.50x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | compose | 774.495 | 19.50x | 16.000 | 1.14x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 22410.065 | 564.29x | 17.000 | 1.21x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | fusion-charm | 1228.078 | 30.92x | 19.000 | 1.36x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 9071.716 | 228.43x | 1.000 | 0.07x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | react-reflex | 942.776 | 23.74x | 16.000 | 1.14x | 0.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | react-upstream | 9207.709 | 231.85x | 1.000 | 0.07x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | roact | 2703.456 | 68.07x | 19.000 | 1.36x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 1981.701 | 49.90x | 22.000 | 1.57x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 1140.284 | 28.71x | 17.000 | 1.21x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 573.348 | 14.44x | 16.000 | 1.14x | 0.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 3577.006 | 1.00x | 20.000 | 1.00x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 8877.103 | 2.48x | 45.000 | 2.25x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 5489.824 | 1.53x | 24.000 | 1.20x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 5676.970 | 1.59x | 23.000 | 1.15x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | fusion-charm | 5730.079 | 1.60x | 33.000 | 1.65x | 1.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react | 7896.186 | 2.21x | 28.000 | 1.40x | 0.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | react-reflex | 7986.614 | 2.23x | 28.000 | 1.40x | 0.000 | 1010 | 510 | 20 | 20 |
| branch-swap | 20 | react-upstream | 8081.741 | 2.26x | 28.000 | 1.40x | 0.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | roact | 6992.241 | 1.95x | 29.000 | 1.45x | 0.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 4801.739 | 1.34x | 29.000 | 1.45x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | signals | 4176.664 | 1.17x | 23.000 | 1.15x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | vide | 4758.728 | 1.33x | 23.000 | 1.15x | 0.000 | 3530 | 510 | 0 | 0 |
| keyed-prepend | 10 | plain | 2216.042 | 1.00x | 1707.000 | 1.00x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 5287.715 | 2.39x | 3068.000 | 1.80x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 4381.730 | 1.98x | 2162.000 | 1.27x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react | 17923.156 | 8.09x | 2397.000 | 1.40x | 0.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | react-reflex | 18540.945 | 8.37x | 2397.000 | 1.40x | 0.000 | 3150 | 50 | 10 | 10 |
| keyed-prepend | 10 | react-upstream | 18302.622 | 8.26x | 2397.000 | 1.40x | 0.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | roact | 8898.850 | 4.02x | 1988.000 | 1.16x | 0.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 16156.796 | 7.29x | 3471.000 | 2.03x | 0.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | 2243.223 | 1.01x | 1696.000 | 0.99x | 8.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | vide | 4897.950 | 2.21x | 2274.000 | 1.33x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1582.407 | 1.00x | 1700.000 | 1.00x | 1.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 4199.327 | 2.65x | 3068.000 | 1.80x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 2441.320 | 1.54x | 2162.000 | 1.27x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react | 12739.945 | 8.05x | 2422.000 | 1.42x | 0.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | react-reflex | 12706.706 | 8.03x | 2423.000 | 1.43x | 0.000 | 1650 | 50 | 10 | 10 |
| keyed-insert | 10 | react-upstream | 13255.148 | 8.38x | 2422.000 | 1.42x | 0.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | roact | 6245.579 | 3.95x | 1988.000 | 1.17x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 12493.634 | 7.90x | 3471.000 | 2.04x | 0.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | 1602.205 | 1.01x | 1697.000 | 1.00x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | vide | 2751.751 | 1.74x | 2274.000 | 1.34x | 0.000 | 1900 | 50 | 0 | 0 |
| keyed-shuffle | 10 | plain | 1520.811 | 1.00x | 1695.000 | 1.00x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 2841.147 | 1.87x | 3025.000 | 1.78x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 3131.990 | 2.06x | 2161.000 | 1.27x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 19189.647 | 12.62x | 2978.000 | 1.76x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion-charm | 19404.929 | 12.76x | 2980.000 | 1.76x | 1.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 27148.333 | 17.85x | 2390.000 | 1.41x | 0.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | react-reflex | 27181.737 | 17.87x | 2391.000 | 1.41x | 0.000 | 2990 | 0 | 10 | 10 |
| keyed-shuffle | 10 | react-upstream | 28026.805 | 18.43x | 2390.000 | 1.41x | 0.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | roact | 7247.287 | 4.77x | 1988.000 | 1.17x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 12272.127 | 8.07x | 3463.000 | 2.04x | 1.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | 1508.478 | 0.99x | 1703.000 | 1.00x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | vide | 2958.987 | 1.95x | 2257.000 | 1.33x | 0.000 | 2990 | 0 | 0 | 0 |
| events | 5 | plain | 12063.948 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | blend | 29056.129 | 2.41x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | compose | 17571.632 | 1.46x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | fusion | 17078.623 | 1.42x | 1.000 | 1.00x | 1.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | fusion-charm | 16437.940 | 1.36x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | react | 19818.168 | 1.64x | 0.000 | 0.00x | 0.000 | 2000 | 1005 | 1000 | 10 |
| events | 5 | react-reflex | 20329.483 | 1.69x | 0.000 | 0.00x | 0.000 | 2000 | 1005 | 1000 | 10 |
| events | 5 | react-upstream | 19926.183 | 1.65x | 0.000 | 0.00x | 0.000 | 2000 | 1005 | 1000 | 10 |
| events | 5 | roact | 20723.915 | 1.72x | 1.000 | 1.00x | 0.000 | 2005 | 1005 | 1000 | 0 |
| events | 5 | seam | 13729.484 | 1.14x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | signals | 11690.028 | 0.97x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | vide | 12786.218 | 1.06x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 1000 | 0 |
| animate-many | 1 | plain | 1363.590 | 1.00x | 1516.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | blend | 10001.293 | 7.33x | 2642.000 | 1.74x | 0.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | compose | 8617.142 | 6.32x | 2300.000 | 1.52x | 0.000 | 3800 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 116646.743 | 85.54x | 2597.000 | 1.71x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | fusion-charm | 117584.691 | 86.23x | 2599.000 | 1.71x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 22119.379 | 16.22x | 3504.000 | 2.31x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — | — | — |
| animate-many | 1 | vide | 5560.666 | 4.08x | 1916.000 | 1.26x | 0.000 | 6000 | 0 | 0 | 30 |
| status-panel | 20 | plain | 149.710 | 1.00x | 135.000 | 1.00x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | blend | 855.214 | 5.71x | 247.000 | 1.83x | 0.000 | 438 | 21 | 0 | 0 |
| status-panel | 20 | compose | 553.731 | 3.70x | 179.000 | 1.33x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | fusion | 2304.772 | 15.39x | 238.000 | 1.76x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | fusion-charm | 2536.596 | 16.94x | 245.000 | 1.81x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | react | 2512.569 | 16.78x | 200.000 | 1.48x | 0.000 | 103 | 21 | 0 | 20 |
| status-panel | 20 | react-reflex | 2607.027 | 17.41x | 203.000 | 1.50x | 0.000 | 103 | 21 | 20 | 20 |
| status-panel | 20 | react-upstream | 2518.305 | 16.82x | 200.000 | 1.48x | 0.000 | 103 | 21 | 0 | 20 |
| status-panel | 20 | roact | 759.726 | 5.07x | 175.000 | 1.30x | 0.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | seam | 1769.009 | 11.82x | 289.000 | 2.14x | 0.000 | 82 | 21 | 42 | 21 |
| status-panel | 20 | signals | 344.930 | 2.30x | 147.000 | 1.09x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | vide | 444.671 | 2.97x | 184.000 | 1.36x | 0.000 | 208 | 21 | 0 | 0 |
| scene-3d | 20 | plain | 4268.463 | 1.00x | 1035.000 | 1.00x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | blend | 8736.351 | 2.05x | 1572.000 | 1.52x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 7255.530 | 1.70x | 1235.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 79318.109 | 18.58x | 1566.000 | 1.51x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion-charm | 81878.643 | 19.18x | 1578.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 6585.472 | 1.54x | 1243.000 | 1.20x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 6325.157 | 1.48x | 1245.000 | 1.20x | 0.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | react-upstream | 6240.409 | 1.46x | 1243.000 | 1.20x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | 6644.516 | 1.56x | 1599.000 | 1.54x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | seam | 19680.743 | 4.61x | 2194.000 | 2.12x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 13498.865 | 3.16x | 1713.000 | 1.66x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 8468.246 | 1.98x | 1236.000 | 1.19x | 8.000 | 6000 | 0 | 0 | 0 |
| derived-diamond | 3 | plain | 6.740 | 1.00x | 17.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | blend | 56.344 | 8.36x | 33.000 | 1.94x | 0.000 | 3 | 0 | 0 | 12 |
| derived-diamond | 3 | compose | 32.358 | 4.80x | 23.000 | 1.35x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion | 48.683 | 7.22x | 21.000 | 1.24x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion-charm | 63.405 | 9.41x | 23.000 | 1.35x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | react | 220.788 | 32.76x | 8.000 | 0.47x | 8.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | react-reflex | 242.781 | 36.02x | 22.000 | 1.29x | 0.000 | 3 | 0 | 3 | 3 |
| derived-diamond | 3 | react-upstream | 232.495 | 34.49x | 0.000 | 0.00x | 0.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | roact | 42.494 | 6.30x | 20.000 | 1.18x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | seam | 32.338 | 4.80x | 30.000 | 1.76x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | signals | 19.388 | 2.88x | 22.000 | 1.29x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | vide | 16.484 | 2.45x | 19.000 | 1.12x | 1.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | plain | 93.926 | 1.00x | 75.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | blend | 731.024 | 7.78x | 525.000 | 7.00x | 1.000 | 3 | 0 | 0 | 303 |
| derived-chain-100 | 3 | compose | 380.991 | 4.06x | 163.000 | 2.17x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion | 1091.727 | 11.62x | 140.000 | 1.87x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion-charm | 1080.576 | 11.50x | 142.000 | 1.89x | 1.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | react | 386.411 | 4.11x | 1.000 | 0.01x | 1.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | react-reflex | 405.286 | 4.31x | 22.000 | 0.29x | 0.000 | 3 | 0 | 3 | 3 |
| derived-chain-100 | 3 | react-upstream | 392.323 | 4.18x | 1.000 | 0.01x | 0.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | roact | 165.989 | 1.77x | 20.000 | 0.27x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | seam | 1029.100 | 10.96x | 282.000 | 3.76x | 1.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | signals | 302.575 | 3.22x | 189.000 | 2.52x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | vide | 186.579 | 1.99x | 105.000 | 1.40x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | plain | 180.076 | 1.00x | 603.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | blend | 472.181 | 2.62x | 1516.000 | 2.51x | 0.000 | 3 | 0 | 0 | 6 |
| derived-fan-in-1000 | 3 | compose | 772.902 | 4.29x | 692.000 | 1.15x | 1.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion | 2360.885 | 13.11x | 894.000 | 1.48x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion-charm | 2642.580 | 14.67x | 2754.000 | 4.57x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | react | 2577.209 | 14.31x | 297.000 | 0.49x | 0.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | react-reflex | 8220.378 | 45.65x | 4978.000 | 8.26x | 1.000 | 3 | 0 | 3 | 3 |
| derived-fan-in-1000 | 3 | react-upstream | 2570.847 | 14.28x | 297.000 | 0.49x | 0.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | roact | 1235.525 | 6.86x | 114.000 | 0.19x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | seam | 3553.341 | 19.73x | 2884.000 | 4.78x | 1.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | signals | 931.628 | 5.17x | 1248.000 | 2.07x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | vide | 646.596 | 3.59x | 533.000 | 0.88x | 1.000 | 3 | 0 | 0 | 0 |
| filter-as-you-type | 1 | plain | 7143.422 | 1.00x | 2751.000 | 1.00x | 0.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | blend | 20030.842 | 2.80x | 5329.000 | 1.94x | 0.000 | 6131 | 437 | 0 | 27 |
| filter-as-you-type | 1 | compose | 10948.162 | 1.53x | 3477.000 | 1.26x | 0.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | react | 20394.100 | 2.85x | 17.000 | 0.01x | 0.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | react-reflex | 20676.537 | 2.89x | 3460.000 | 1.26x | 0.000 | 2505 | 437 | 9 | 9 |
| filter-as-you-type | 1 | react-upstream | 21630.148 | 3.03x | 17.000 | 0.01x | 0.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | roact | 11123.208 | 1.56x | 3207.000 | 1.17x | 0.000 | 2505 | 437 | 0 | 0 |
| filter-as-you-type | 1 | seam | 29274.864 | 4.10x | 5606.000 | 2.04x | 0.000 | 2068 | 437 | 874 | 437 |
| filter-as-you-type | 1 | signals | 7053.674 | 0.99x | 2760.000 | 1.00x | 8.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | vide | 10337.231 | 1.45x | 3675.000 | 1.34x | 0.000 | 4690 | 437 | 0 | 0 |
| theme-propagation | 3 | plain | 1212.923 | 1.00x | 5605.000 | 1.00x | 8.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | blend | 2952.707 | 2.43x | 7419.000 | 1.32x | 0.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | compose | 1981.325 | 1.63x | 5935.000 | 1.06x | 0.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion | 6464.199 | 5.33x | 6209.000 | 1.11x | 8.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion-charm | 7080.235 | 5.84x | 6210.000 | 1.11x | 8.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | react | 36733.602 | 30.29x | 16.000 | 0.00x | 8.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | react-reflex | 39711.447 | 32.74x | 10346.000 | 1.85x | 0.000 | 3000 | 0 | 3 | 3 |
| theme-propagation | 3 | react-upstream | 39728.238 | 32.75x | 8.000 | 0.00x | 0.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | roact | 21593.625 | 17.80x | 8240.000 | 1.47x | 8.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | seam | 3004.624 | 2.48x | 6983.000 | 1.25x | 8.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | signals | 3625.221 | 2.99x | 6301.000 | 1.12x | 0.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | vide | 2971.041 | 2.45x | 5995.000 | 1.07x | 0.000 | 3000 | 0 | 0 | 0 |
| hud-per-frame | 1 | plain | 5328.484 | 1.00x | 140.000 | 1.00x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | blend | 13184.238 | 2.47x | 188.000 | 1.34x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | compose | 9367.053 | 1.76x | 144.000 | 1.03x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion | 66412.847 | 12.46x | 169.000 | 1.21x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion-charm | 86577.749 | 16.25x | 206.000 | 1.47x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | react | 7538.334 | 1.41x | 150.000 | 1.07x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | react-reflex | 16119.202 | 3.03x | 168.000 | 1.20x | 0.000 | 12000 | 0 | 600 | 0 |
| hud-per-frame | 1 | react-upstream | 7474.605 | 1.40x | 150.000 | 1.07x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | roact | 8173.327 | 1.53x | 206.000 | 1.47x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | seam | 40669.100 | 7.63x | 249.000 | 1.78x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | signals | 19781.178 | 3.71x | 183.000 | 1.31x | 0.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | vide | 10871.578 | 2.04x | 141.000 | 1.01x | 0.000 | 12000 | 0 | 0 | 600 |
| teardown-under-load | 1 | plain | 17028.915 | 1.00x | 18.000 | 1.00x | 0.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | blend | 48144.256 | 2.83x | 19.000 | 1.06x | 0.000 | 22003 | 2001 | 0 | 4 |
| teardown-under-load | 1 | compose | 29529.035 | 1.73x | 19.000 | 1.06x | 0.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion | 51083.563 | 3.00x | 18.000 | 1.00x | 1.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion-charm | 50992.187 | 2.99x | 19.000 | 1.06x | 0.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | react | 28086.553 | 1.65x | 931.000 | 51.72x | 0.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | react-reflex | 28456.463 | 1.67x | 932.000 | 51.78x | 0.000 | 10000 | 2001 | 6 | 2 |
| teardown-under-load | 1 | react-upstream | 27294.035 | 1.60x | 932.000 | 51.78x | 0.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | roact | 37046.331 | 2.18x | 84.000 | 4.67x | 0.000 | 10001 | 2001 | 0 | 0 |
| teardown-under-load | 1 | seam | 40318.672 | 2.37x | 13.000 | 0.72x | 0.000 | 8000 | 2001 | 4000 | 2000 |
| teardown-under-load | 1 | signals | 21920.542 | 1.29x | 18.000 | 1.00x | 0.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | vide | 30790.298 | 1.81x | 17.000 | 0.94x | 0.000 | 20003 | 2001 | 0 | 6 |
| open-close-retention | 1 | plain | 276401.011 | 1.00x | 19.000 | 1.00x | 0.000 | 100000 | 25050 | 0 | 0 |
| open-close-retention | 1 | blend | 650549.758 | 2.35x | 27.000 | 1.42x | 0.000 | 275150 | 25050 | 0 | 200 |
| open-close-retention | 1 | compose | 414970.570 | 1.50x | 19.000 | 1.00x | 0.000 | 100000 | 25050 | 0 | 0 |
| open-close-retention | 1 | fusion | 599068.409 | 2.17x | 18.000 | 0.95x | 1.000 | 275150 | 25050 | 0 | 0 |
| open-close-retention | 1 | fusion-charm | 608538.144 | 2.20x | 0.000 | 0.00x | 0.000 | 275150 | 25050 | 0 | 0 |
| open-close-retention | 1 | react | 456997.654 | 1.65x | 236.000 | 12.42x | 0.000 | 125000 | 25050 | 0 | 100 |
| open-close-retention | 1 | react-reflex | 466348.651 | 1.69x | 245.000 | 12.89x | 0.000 | 125000 | 25050 | 300 | 100 |
| open-close-retention | 1 | react-upstream | 471954.351 | 1.71x | 236.000 | 12.42x | 0.000 | 125000 | 25050 | 0 | 100 |
| open-close-retention | 1 | roact | 510189.492 | 1.85x | 0.000 | 0.00x | 0.000 | 125050 | 25050 | 0 | 0 |
| open-close-retention | 1 | seam | 578362.133 | 2.09x | 21.000 | 1.11x | 0.000 | 100000 | 25050 | 50000 | 25000 |
| open-close-retention | 1 | signals | 362337.913 | 1.31x | 26.000 | 1.37x | 9.000 | 100000 | 25050 | 0 | 0 |
| open-close-retention | 1 | vide | 403488.673 | 1.46x | 17.000 | 0.89x | 0.000 | 250150 | 25050 | 0 | 300 |
| tree-expand-collapse | 1 | plain | 5919.985 | 1.00x | 89.000 | 1.00x | 8.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | blend | 24530.763 | 4.14x | 722.000 | 8.11x | 0.000 | 7040 | 630 | 0 | 21 |
| tree-expand-collapse | 1 | compose | 14147.351 | 2.39x | 164.000 | 1.84x | 0.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | react | 20885.569 | 3.53x | 9.000 | 0.10x | 0.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | react-reflex | 21985.923 | 3.71x | 675.000 | 7.58x | 0.000 | 2389 | 630 | 7 | 7 |
| tree-expand-collapse | 1 | react-upstream | 20788.166 | 3.51x | 9.000 | 0.10x | 0.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | roact | 9951.452 | 1.68x | 101.000 | 1.13x | 0.000 | 2389 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | seam | 30564.641 | 5.16x | 193.000 | 2.17x | 8.000 | 1759 | 630 | 1260 | 630 |
| tree-expand-collapse | 1 | signals | 7612.232 | 1.29x | 90.000 | 1.01x | 0.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | vide | 11532.226 | 1.95x | 139.000 | 1.56x | 0.000 | 5539 | 630 | 0 | 0 |
| form-validation | 1 | plain | 1603.573 | 1.00x | 666.000 | 1.00x | 0.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | blend | 1104.709 | 0.69x | 1360.000 | 2.04x | 0.000 | 321 | 0 | 0 | 428 |
| form-validation | 1 | compose | 1759.889 | 1.10x | 795.000 | 1.19x | 0.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | fusion | 4314.769 | 2.69x | 835.000 | 1.25x | 0.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | fusion-charm | 4716.506 | 2.94x | 920.000 | 1.38x | 0.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | react | 29558.338 | 18.43x | 912.000 | 1.37x | 0.000 | 314 | 0 | 0 | 110 |
| form-validation | 1 | react-reflex | 34717.563 | 21.65x | 1075.000 | 1.61x | 0.000 | 314 | 0 | 110 | 107 |
| form-validation | 1 | react-upstream | 29467.100 | 18.38x | 912.000 | 1.37x | 0.000 | 314 | 0 | 0 | 110 |
| form-validation | 1 | roact | 16758.579 | 10.45x | 692.000 | 1.04x | 0.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | seam | 5520.827 | 3.44x | 1229.000 | 1.85x | 1.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | signals | 1495.191 | 0.93x | 932.000 | 1.40x | 0.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | vide | 1011.820 | 0.63x | 712.000 | 1.07x | 0.000 | 314 | 0 | 0 | 0 |
| table-sort-filter | 1 | plain | 10448.949 | 1.00x | 5492.000 | 1.00x | 0.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | blend | 24062.441 | 2.30x | 10689.000 | 1.95x | 0.000 | 12157 | 937 | 0 | 18 |
| table-sort-filter | 1 | compose | 17515.387 | 1.68x | 6938.000 | 1.26x | 0.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | react | 56179.301 | 5.38x | 7384.000 | 1.34x | 0.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | react-reflex | 54685.454 | 5.23x | 7388.000 | 1.35x | 0.000 | 5594 | 937 | 6 | 6 |
| table-sort-filter | 1 | react-upstream | 53793.048 | 5.15x | 7384.000 | 1.34x | 0.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | roact | 15142.341 | 1.45x | 6393.000 | 1.16x | 0.000 | 5594 | 937 | 0 | 0 |
| table-sort-filter | 1 | seam | 48419.616 | 4.63x | 11196.000 | 2.04x | 0.000 | 4657 | 937 | 1874 | 937 |
| table-sort-filter | 1 | signals | 10901.262 | 1.04x | 5501.000 | 1.00x | 0.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | vide | 14211.364 | 1.36x | 7339.000 | 1.34x | 0.000 | 10279 | 937 | 0 | 0 |
| library-load | 1 | plain | 11.237 | 1.00x | 0.000 | n/a (zero baseline) | 0.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | blend | 6097.607 | 542.64x | 373.000 | n/a (zero baseline) | 378.000 | 3 | 1 | 0 | 0 |
| library-load | 1 | compose | 48408.360 | 4307.94x | 655.000 | n/a (zero baseline) | 645.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | fusion | 29403.252 | 2616.65x | 182.000 | n/a (zero baseline) | 166.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | fusion-charm | 29390.693 | 2615.53x | 207.000 | n/a (zero baseline) | 214.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | react | 144836.243 | 12889.23x | 1412.000 | n/a (zero baseline) | 1412.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | react-reflex | 151145.610 | 13450.71x | 1549.000 | n/a (zero baseline) | 1541.000 | 0 | 3 | 0 | 1 |
| library-load | 1 | react-upstream | 174658.871 | 15543.19x | 1404.000 | n/a (zero baseline) | 1404.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | roact | 14497.706 | 1290.18x | 129.000 | n/a (zero baseline) | 119.000 | 1 | 1 | 0 | 0 |
| library-load | 1 | seam | 23732.644 | 2112.01x | 182.000 | n/a (zero baseline) | 180.000 | 0 | 3 | 0 | 0 |
| library-load | 1 | signals | 3309.706 | 294.54x | 34.000 | n/a (zero baseline) | 26.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | vide | 7591.926 | 675.62x | 98.000 | n/a (zero baseline) | 97.000 | 3 | 1 | 1 | 0 |
| rows-append-1000 | 1 | plain | 82963.509 | 1.00x | 72385.000 | 1.00x | 1.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | blend | 136272.552 | 1.64x | 101548.000 | 1.40x | 8.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | compose | 139153.575 | 1.68x | 73268.000 | 1.01x | 9.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion | 572741.222 | 6.90x | 84266.000 | 1.16x | 1.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion-charm | 599091.398 | 7.22x | 91775.000 | 1.27x | 8.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | react | 167185.392 | 2.02x | 85704.000 | 1.18x | 8.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | react-reflex | 181370.417 | 2.19x | 87465.000 | 1.21x | 16.000 | 15000 | 5000 | 2001 | 1 |
| rows-append-1000 | 1 | react-upstream | 166497.270 | 2.01x | 85704.000 | 1.18x | 8.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | roact | 149010.588 | 1.80x | 95410.000 | 1.32x | 0.000 | 15000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | seam | 151977.922 | 1.83x | 98568.000 | 1.36x | 16.000 | 11000 | 5000 | 8000 | 3000 |
| rows-append-1000 | 1 | signals | 71222.544 | 0.86x | 81426.000 | 1.12x | 0.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | vide | 80873.861 | 0.97x | 75008.000 | 1.04x | 0.000 | 39000 | 5000 | 2000 | 0 |
| rows-clear | 1 | plain | 24852.908 | 1.00x | 2199.000 | 1.00x | 0.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | blend | 50101.276 | 2.02x | 3103.000 | 1.41x | 0.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | compose | 35175.958 | 1.42x | 1701.000 | 0.77x | 0.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion | 94573.376 | 3.81x | 3311.000 | 1.51x | 0.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion-charm | 93956.325 | 3.78x | 7071.000 | 3.22x | 0.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | react | 26283.081 | 1.06x | 4358.000 | 1.98x | 0.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | react-reflex | 27786.213 | 1.12x | 6172.000 | 2.81x | 0.000 | 0 | 0 | 1 | 1 |
| rows-clear | 1 | react-upstream | 28091.778 | 1.13x | 4366.000 | 1.99x | 0.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | roact | 33036.684 | 1.33x | 4084.000 | 1.86x | 0.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | seam | 84159.870 | 3.39x | 8401.000 | 3.82x | 1.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | signals | 32288.021 | 1.30x | 4245.000 | 1.93x | 1.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | vide | 32718.214 | 1.32x | 1596.000 | 0.73x | 0.000 | 0 | 0 | 0 | 0 |
| rows-create-1000 | 1 | plain | 51825.250 | 1.00x | 36187.000 | 1.00x | 1.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | blend | 123770.609 | 2.39x | 50788.000 | 1.40x | 0.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | compose | 72128.569 | 1.39x | 36638.000 | 1.01x | 8.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion | 220136.538 | 4.25x | 42130.000 | 1.16x | 8.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion-charm | 228807.440 | 4.41x | 45882.000 | 1.27x | 8.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | react | 127659.447 | 2.46x | 39158.000 | 1.08x | 0.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | react-reflex | 130190.041 | 2.51x | 40052.000 | 1.11x | 8.000 | 15000 | 5000 | 2001 | 1 |
| rows-create-1000 | 1 | react-upstream | 134205.730 | 2.59x | 39174.000 | 1.08x | 8.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | roact | 91467.241 | 1.76x | 47713.000 | 1.32x | 1.000 | 15000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | seam | 124304.587 | 2.40x | 49280.000 | 1.36x | 0.000 | 11000 | 5000 | 8000 | 3000 |
| rows-create-1000 | 1 | signals | 59120.586 | 1.14x | 40704.000 | 1.12x | 8.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | vide | 66267.378 | 1.28x | 37491.000 | 1.04x | 1.000 | 39000 | 5000 | 2000 | 0 |
| rows-create-10000 | 1 | plain | 575100.259 | 1.00x | 362993.000 | 1.00x | 0.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | blend | 1381126.169 | 2.40x | 508819.000 | 1.40x | 0.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | compose | 939388.307 | 1.63x | 365884.000 | 1.01x | 0.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion | 12472954.384 | 21.69x | 422398.000 | 1.16x | 0.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion-charm | 12976537.669 | 22.56x | 459907.000 | 1.27x | 8.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | react | 4868364.622 | 8.47x | 391608.000 | 1.08x | 0.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | react-reflex | 4942767.606 | 8.59x | 400599.000 | 1.10x | 64.000 | 150000 | 50000 | 20001 | 1 |
| rows-create-10000 | 1 | react-upstream | 4899707.346 | 8.52x | 391608.000 | 1.08x | 0.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | roact | 1046692.986 | 1.82x | 477497.000 | 1.32x | 0.000 | 150000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | seam | 1342455.148 | 2.33x | 494801.000 | 1.36x | 64.000 | 110000 | 50000 | 80000 | 30000 |
| rows-create-10000 | 1 | signals | 755222.871 | 1.31x | 407013.000 | 1.12x | 0.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | vide | 706183.046 | 1.23x | 375749.000 | 1.04x | 0.000 | 390000 | 50000 | 20000 | 0 |
| rows-remove-one | 1 | plain | 2002.649 | 1.00x | 36186.000 | 1.00x | 1.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | blend | 2635.317 | 1.32x | 50773.000 | 1.40x | 0.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | compose | 1784.589 | 0.89x | 36635.000 | 1.01x | 9.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | fusion | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | fusion-charm | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | react | 41015.303 | 20.48x | 46548.000 | 1.29x | 0.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | react-reflex | 46607.679 | 23.27x | 47441.000 | 1.31x | 0.000 | 500 | 0 | 1 | 1 |
| rows-remove-one | 1 | react-upstream | 41179.078 | 20.56x | 46555.000 | 1.29x | 8.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | roact | 41323.472 | 20.63x | 47694.000 | 1.32x | 0.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | seam | 9275.308 | 4.63x | 49287.000 | 1.36x | 0.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | signals | 2410.775 | 1.20x | 40692.000 | 1.12x | 0.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | vide | 2377.812 | 1.19x | 37512.000 | 1.04x | 0.000 | 500 | 0 | 0 | 0 |
| rows-replace-1000 | 1 | plain | 96251.168 | 1.00x | 38373.000 | 1.00x | 1.000 | 10000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | blend | 159495.336 | 1.66x | 53880.000 | 1.40x | 0.000 | 43000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | compose | 98846.555 | 1.03x | 38306.000 | 1.00x | 0.000 | 10000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | fusion | 491169.043 | 5.10x | 45344.000 | 1.18x | 8.000 | 43000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | fusion-charm | 490717.115 | 5.10x | 52846.000 | 1.38x | 0.000 | 43000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | react | 148467.505 | 1.54x | 43502.000 | 1.13x | 8.000 | 15000 | 5000 | 2000 | 1 |
| rows-replace-1000 | 1 | react-reflex | 159515.492 | 1.66x | 46184.000 | 1.20x | 8.000 | 15000 | 5000 | 2001 | 1 |
| rows-replace-1000 | 1 | react-upstream | 151570.486 | 1.57x | 43478.000 | 1.13x | 0.000 | 15000 | 5000 | 2000 | 1 |
| rows-replace-1000 | 1 | roact | 117476.686 | 1.22x | 51724.000 | 1.35x | 0.000 | 15000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | seam | 211844.541 | 2.20x | 57638.000 | 1.50x | 0.000 | 11000 | 5000 | 8000 | 3000 |
| rows-replace-1000 | 1 | signals | 105085.778 | 1.09x | 44942.000 | 1.17x | 0.000 | 10000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | vide | 118213.804 | 1.23x | 39058.000 | 1.02x | 0.000 | 39000 | 5000 | 2000 | 0 |
| rows-select | 1 | plain | 13.946 | 1.00x | 36195.000 | 1.00x | 1.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | blend | 29.585 | 2.12x | 50789.000 | 1.40x | 0.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | compose | 23.253 | 1.67x | 36622.000 | 1.01x | 0.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | fusion | 52.398 | 3.76x | 42130.000 | 1.16x | 8.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | fusion-charm | 69.299 | 4.97x | 45881.000 | 1.27x | 8.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | react | 23.574 | 1.69x | 39157.000 | 1.08x | 8.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | react-reflex | 965.993 | 69.27x | 40048.000 | 1.11x | 8.000 | 2 | 0 | 1 | 0 |
| rows-select | 1 | react-upstream | 23.914 | 1.71x | 39157.000 | 1.08x | 8.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | roact | 18.624 | 1.34x | 47714.000 | 1.32x | 0.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | seam | 1787.676 | 128.19x | 49283.000 | 1.36x | 0.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | signals | 32.701 | 2.34x | 40704.000 | 1.12x | 1.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | vide | 20.939 | 1.50x | 37483.000 | 1.04x | 1.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | plain | 963.789 | 1.00x | 36211.000 | 1.00x | 1.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | blend | 1720.550 | 1.79x | 50813.000 | 1.40x | 1.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | compose | 947.729 | 0.98x | 36638.000 | 1.01x | 0.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion | 112156.274 | 116.37x | 42186.000 | 1.17x | 8.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion-charm | 118962.691 | 123.43x | 45929.000 | 1.27x | 8.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | react | 74738.509 | 77.55x | 46573.000 | 1.29x | 8.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | react-reflex | 78669.541 | 81.63x | 47458.000 | 1.31x | 8.000 | 2 | 0 | 1 | 1 |
| rows-swap | 1 | react-upstream | 73206.510 | 75.96x | 46573.000 | 1.29x | 0.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | roact | 39700.101 | 41.19x | 47722.000 | 1.32x | 1.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | seam | 8776.793 | 9.11x | 49304.000 | 1.36x | 0.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | signals | 834.116 | 0.87x | 40720.000 | 1.12x | 1.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | vide | 405.131 | 0.42x | 37507.000 | 1.04x | 1.000 | 2 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | plain | 242.928 | 1.00x | 36180.000 | 1.00x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | blend | 383.750 | 1.58x | 50803.000 | 1.40x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | compose | 270.569 | 1.11x | 36639.000 | 1.01x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion | 431.003 | 1.77x | 42124.000 | 1.16x | 1.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion-charm | 674.055 | 2.77x | 45875.000 | 1.27x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react | 270.439 | 1.11x | 39156.000 | 1.08x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react-reflex | 1039.163 | 4.28x | 40033.000 | 1.11x | 8.000 | 100 | 0 | 1 | 0 |
| rows-update-every-10th | 1 | react-upstream | 296.199 | 1.22x | 39156.000 | 1.08x | 8.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | roact | 352.454 | 1.45x | 47723.000 | 1.32x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | seam | 1627.706 | 6.70x | 49284.000 | 1.36x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | signals | 327.635 | 1.35x | 40714.000 | 1.13x | 0.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | vide | 304.231 | 1.25x | 37484.000 | 1.04x | 0.000 | 100 | 0 | 0 | 0 |

## Page retention

Growth is the retained Luau heap after the page closes minus the retained heap with only its source owner and host mounted. Collection runs before both readings. The source owner stays alive during the run. Collection noise can make the difference negative; such a reading counts as 0, as in the Verify mounted and teardown readings.

| Workload | Framework | Median retained growth (KiB) |
| --- | --- | ---: |
| teardown-under-load | plain | 1.000 |
| teardown-under-load | blend | 0.000 |
| teardown-under-load | compose | 0.000 |
| teardown-under-load | fusion | 0.000 |
| teardown-under-load | fusion-charm | 0.000 |
| teardown-under-load | react | 914.000 |
| teardown-under-load | react-reflex | 914.000 |
| teardown-under-load | react-upstream | 914.000 |
| teardown-under-load | roact | 64.000 |
| teardown-under-load | seam | 1.000 |
| teardown-under-load | signals | 0.000 |
| teardown-under-load | vide | 0.000 |
| open-close-retention | plain | 1.000 |
| open-close-retention | blend | 8.000 |
| open-close-retention | compose | 0.000 |
| open-close-retention | fusion | 0.000 |
| open-close-retention | fusion-charm | 0.000 |
| open-close-retention | react | 218.000 |
| open-close-retention | react-reflex | 226.000 |
| open-close-retention | react-upstream | 218.000 |
| open-close-retention | roact | 0.000 |
| open-close-retention | seam | 0.000 |
| open-close-retention | signals | 0.000 |
| open-close-retention | vide | 0.000 |

## Summary

This summary uses the 32 selected workloads and treats time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. A workload whose plain heap is zero has no heap ratio. Lanes support different workloads, so compare a geometric mean only together with its measured count.

The shared columns use only the workloads that every lane measured: 25 for time (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-chain-100`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-replace-1000`, `rows-select`, `rows-swap`, `rows-update-every-10th`) and 21 for heap (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `status-panel`, `scene-3d`, `derived-chain-100`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `form-validation`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-replace-1000`, `rows-select`, `rows-swap`, `rows-update-every-10th`).

| Framework | Supported | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain | 32 | 32 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 32 | 32 | 3.45x | 1.72x | 3.63x | 1.64x |
| compose | 32 | 32 | 2.61x | 1.16x | 2.84x | 1.11x |
| fusion | 26 | 26 | 10.84x | 1.26x | 9.98x | 1.28x |
| fusion-charm | 26 | 26 | 10.82x | 1.50x | 9.96x | 1.52x |
| react | 31 | 31 | 6.99x | 0.70x | 7.13x | 0.75x |
| react-reflex | 31 | 31 | 9.41x | 1.76x | 10.22x | 1.61x |
| react-upstream | 31 | 31 | 7.14x | 0.69x | 7.29x | 0.72x |
| roact | 31 | 31 | 4.07x | 1.21x | 4.29x | 1.23x |
| seam | 32 | 32 | 6.67x | 1.71x | 6.75x | 1.70x |
| signals | 31 | 31 | 2.10x | 1.21x | 2.46x | 1.28x |
| vide | 32 | 32 | 2.15x | 1.11x | 2.25x | 1.07x |

## Source identities

Harness revision: `c5bc3f049c0778723c91a1a054a1bd4a63410432`. Full source state, tools, environment and command are in `context.json`.

| Dependency | Version | Commit | Tree | Rights |
| --- | --- | --- | --- | --- |
| compose | unreleased | `ad5fe3a8d8d34c092c0f2b3ba2857b4856df069d` | `b9cbb3799141500fb50c1492454597599c0ffcc4` | MIT |
| facet | 0.12.0 | `6215e6c7defca48f1451c333683ce357d365868f` | `d435df7d6c66ae7c18d7758a4d65d79e0d582798` | MIT |
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
