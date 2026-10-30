# Headless results

Harness commit: `641a655a2c64225e868c9a69a6289605f8513619`. Workflow run: [Library comparison 41034898619](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41034898619). Runner: `ubuntu-latest`, six scene composition shards merged; summary regenerated from the same shard reports. Mode: `like-for-like`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **like-for-like**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

# Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Framework | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| update-leaf | 50 | plain | 22.367 | 1.00x | 2816.000 | 1.00x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | blend | 77.895 | 3.48x | 3500.000 | 1.24x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 83.555 | 3.74x | 2853.000 | 1.01x | 98.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 140.697 | 6.29x | 2835.000 | 1.01x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion-charm | 243.854 | 10.90x | 2837.000 | 1.01x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 94.932 | 4.24x | 3505.000 | 1.24x | 511.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 158.215 | 7.07x | 3506.000 | 1.25x | 511.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | react-upstream | 95.258 | 4.26x | 3506.000 | 1.25x | 512.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 59.891 | 2.68x | 3719.000 | 1.32x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 144.529 | 6.46x | 2822.000 | 1.00x | 64.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 87.553 | 3.91x | 2842.000 | 1.01x | 72.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 74.012 | 3.31x | 2811.000 | 1.00x | 66.000 | 50 | 0 | 0 | 0 |
| update-batched | 20 | plain | 1251.716 | 1.00x | 1715.000 | 1.00x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 6557.719 | 5.24x | 2582.000 | 1.51x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 4533.310 | 3.62x | 2099.000 | 1.22x | 138.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 14011.276 | 11.19x | 2256.000 | 1.32x | 128.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion-charm | 22914.571 | 18.31x | 2833.000 | 1.65x | 136.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 3618.256 | 2.89x | 2788.000 | 1.63x | 691.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 69591.123 | 55.60x | 3086.000 | 1.80x | 707.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | react-upstream | 3768.713 | 3.01x | 2788.000 | 1.63x | 691.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 5163.697 | 4.13x | 2849.000 | 1.66x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 9042.946 | 7.22x | 3012.000 | 1.76x | 104.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 7314.190 | 5.84x | 2336.000 | 1.36x | 72.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 5757.575 | 4.60x | 2033.000 | 1.19x | 73.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 40.406 | 1.00x | 14.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 3821.570 | 94.58x | 21.000 | 1.50x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | compose | 776.701 | 19.22x | 19.000 | 1.36x | 2.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 22726.257 | 562.45x | 17.000 | 1.21x | 1.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | fusion-charm | 1233.504 | 30.53x | 20.000 | 1.43x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 9692.258 | 239.87x | 370.000 | 26.43x | 369.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | react-reflex | 984.820 | 24.37x | 221.000 | 15.79x | 205.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | react-upstream | 9446.328 | 233.79x | 370.000 | 26.43x | 370.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | roact | 2807.225 | 69.48x | 19.000 | 1.36x | 1.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 2166.438 | 53.62x | 23.000 | 1.64x | 5.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 1195.794 | 29.59x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 580.584 | 14.37x | 17.000 | 1.21x | 2.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 2353.197 | 1.00x | 147.000 | 1.00x | 128.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 5826.890 | 2.48x | 165.000 | 1.12x | 128.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 3708.798 | 1.58x | 163.000 | 1.11x | 139.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 3887.337 | 1.65x | 151.000 | 1.03x | 129.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | fusion-charm | 3940.047 | 1.67x | 145.000 | 0.99x | 128.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react | 5228.505 | 2.22x | 366.000 | 2.49x | 337.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | react-reflex | 5489.750 | 2.33x | 367.000 | 2.50x | 338.000 | 1010 | 510 | 20 | 20 |
| branch-swap | 20 | react-upstream | 5409.299 | 2.30x | 366.000 | 2.49x | 338.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | roact | 4332.120 | 1.84x | 157.000 | 1.07x | 128.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 3069.951 | 1.30x | 159.000 | 1.08x | 149.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | signals | 2643.386 | 1.12x | 151.000 | 1.03x | 128.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | vide | 2950.822 | 1.25x | 160.000 | 1.09x | 129.000 | 3530 | 510 | 0 | 0 |
| keyed-prepend | 10 | plain | 2272.844 | 1.00x | 1763.000 | 1.00x | 64.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 5583.246 | 2.46x | 3132.000 | 1.78x | 64.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 4488.408 | 1.97x | 2300.000 | 1.30x | 138.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react | 20135.621 | 8.86x | 2728.000 | 1.55x | 332.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | react-reflex | 20479.442 | 9.01x | 2729.000 | 1.55x | 332.000 | 3150 | 50 | 10 | 10 |
| keyed-prepend | 10 | react-upstream | 20281.643 | 8.92x | 2729.000 | 1.55x | 333.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | roact | 9446.360 | 4.16x | 2044.000 | 1.16x | 64.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 16642.277 | 7.32x | 3545.000 | 2.01x | 141.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | 2240.303 | 0.99x | 1760.000 | 1.00x | 64.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | vide | 4897.335 | 2.15x | 2339.000 | 1.33x | 65.000 | 3400 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1968.879 | 1.00x | 1771.000 | 1.00x | 64.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 5079.422 | 2.58x | 3132.000 | 1.77x | 64.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 2968.276 | 1.51x | 2296.000 | 1.30x | 134.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react | 15786.550 | 8.02x | 2754.000 | 1.56x | 332.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | react-reflex | 16481.239 | 8.37x | 2755.000 | 1.56x | 332.000 | 1650 | 50 | 10 | 10 |
| keyed-insert | 10 | react-upstream | 15439.432 | 7.84x | 2755.000 | 1.56x | 333.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | roact | 7431.777 | 3.77x | 2052.000 | 1.16x | 64.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 14566.521 | 7.40x | 3544.000 | 2.00x | 141.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | 1966.255 | 1.00x | 1760.000 | 0.99x | 64.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | vide | 3322.578 | 1.69x | 2346.000 | 1.32x | 73.000 | 1900 | 50 | 0 | 0 |
| keyed-shuffle | 10 | plain | 839.680 | 1.00x | 1767.000 | 1.00x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 2028.577 | 2.42x | 3090.000 | 1.75x | 57.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 1928.166 | 2.30x | 2307.000 | 1.31x | 138.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 13231.763 | 15.76x | 3170.000 | 1.79x | 192.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion-charm | 13236.741 | 15.76x | 3172.000 | 1.80x | 192.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 18696.132 | 22.27x | 2722.000 | 1.54x | 332.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | react-reflex | 20066.944 | 23.90x | 2723.000 | 1.54x | 332.000 | 2990 | 0 | 10 | 10 |
| keyed-shuffle | 10 | react-upstream | 19854.954 | 23.65x | 2723.000 | 1.54x | 333.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | roact | 5585.991 | 6.65x | 2052.000 | 1.16x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 8694.208 | 10.35x | 3552.000 | 2.01x | 149.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | 852.008 | 1.01x | 1760.000 | 1.00x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | vide | 1731.939 | 2.06x | 2330.000 | 1.32x | 65.000 | 2990 | 0 | 0 | 0 |
| events | 5 | plain | 14740.139 | 1.00x | 129.000 | 1.00x | 128.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | blend | 27142.011 | 1.84x | 137.000 | 1.06x | 136.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | compose | 17544.982 | 1.19x | 146.000 | 1.13x | 146.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | fusion | 18232.949 | 1.24x | 129.000 | 1.00x | 128.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | fusion-charm | 19283.511 | 1.31x | 129.000 | 1.00x | 128.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | react | 22698.691 | 1.54x | 461.000 | 3.57x | 461.000 | 2000 | 1005 | 1000 | 10 |
| events | 5 | react-reflex | 23190.730 | 1.57x | 461.000 | 3.57x | 461.000 | 2000 | 1005 | 1000 | 10 |
| events | 5 | react-upstream | 21965.646 | 1.49x | 462.000 | 3.58x | 462.000 | 2000 | 1005 | 1000 | 10 |
| events | 5 | roact | 22089.733 | 1.50x | 129.000 | 1.00x | 128.000 | 2005 | 1005 | 1000 | 0 |
| events | 5 | seam | 14537.530 | 0.99x | 129.000 | 1.00x | 128.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | signals | 13403.549 | 0.91x | 129.000 | 1.00x | 128.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | vide | 16150.448 | 1.10x | 130.000 | 1.01x | 129.000 | 8015 | 1005 | 1000 | 0 |
| animate-many | 1 | plain | 1874.695 | 1.00x | 1555.000 | 1.00x | 32.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | blend | 12246.709 | 6.53x | 2725.000 | 1.75x | 84.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | compose | 11387.246 | 6.07x | 2381.000 | 1.53x | 74.000 | 3800 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 133616.649 | 71.27x | 2769.000 | 1.78x | 172.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | fusion-charm | 189911.921 | 101.30x | 2771.000 | 1.78x | 172.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 26195.071 | 13.97x | 3569.000 | 2.30x | 68.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — | — | — |
| animate-many | 1 | vide | 7547.431 | 4.03x | 1977.000 | 1.27x | 53.000 | 6000 | 0 | 0 | 30 |
| status-panel | 20 | plain | 127.308 | 1.00x | 136.000 | 1.00x | 2.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | blend | 493.891 | 3.88x | 257.000 | 1.89x | 11.000 | 438 | 21 | 0 | 0 |
| status-panel | 20 | compose | 361.015 | 2.84x | 192.000 | 1.41x | 13.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | fusion | 1423.763 | 11.18x | 252.000 | 1.85x | 14.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | fusion-charm | 1601.883 | 12.58x | 259.000 | 1.90x | 14.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | react | 1719.686 | 13.51x | 414.000 | 3.04x | 214.000 | 103 | 21 | 0 | 20 |
| status-panel | 20 | react-reflex | 1760.693 | 13.83x | 417.000 | 3.07x | 215.000 | 103 | 21 | 20 | 20 |
| status-panel | 20 | react-upstream | 1737.843 | 13.65x | 422.000 | 3.10x | 215.000 | 103 | 21 | 0 | 20 |
| status-panel | 20 | roact | 498.694 | 3.92x | 177.000 | 1.30x | 10.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | seam | 1052.411 | 8.27x | 287.000 | 2.11x | 0.000 | 82 | 21 | 42 | 21 |
| status-panel | 20 | signals | 231.150 | 1.82x | 149.000 | 1.10x | 2.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | vide | 303.354 | 2.38x | 187.000 | 1.38x | 11.000 | 208 | 21 | 0 | 0 |
| scene-3d | 20 | plain | 4423.799 | 1.00x | 1075.000 | 1.00x | 32.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | blend | 9511.272 | 2.15x | 1603.000 | 1.49x | 32.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 7229.795 | 1.63x | 1332.000 | 1.24x | 97.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 79701.470 | 18.02x | 1670.000 | 1.55x | 96.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion-charm | 79573.006 | 17.99x | 1674.000 | 1.56x | 96.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 6330.551 | 1.43x | 1749.000 | 1.63x | 505.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 6961.606 | 1.57x | 1751.000 | 1.63x | 505.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | react-upstream | 7286.798 | 1.65x | 1749.000 | 1.63x | 506.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | 7394.955 | 1.67x | 1631.000 | 1.52x | 32.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | seam | 20190.337 | 4.56x | 2244.000 | 2.09x | 53.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 14267.638 | 3.23x | 1745.000 | 1.62x | 40.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 8681.577 | 1.96x | 1277.000 | 1.19x | 41.000 | 6000 | 0 | 0 | 0 |
| derived-diamond | 3 | plain | 7.985 | 1.00x | 17.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | blend | 81.912 | 10.26x | 41.000 | 2.41x | 0.000 | 3 | 0 | 0 | 12 |
| derived-diamond | 3 | compose | 39.223 | 4.91x | 16.000 | 0.94x | 2.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion | 63.518 | 7.95x | 22.000 | 1.29x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion-charm | 81.552 | 10.21x | 24.000 | 1.41x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | react | 264.242 | 33.09x | 224.000 | 13.18x | 223.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | react-reflex | 306.791 | 38.42x | 232.000 | 13.65x | 211.000 | 3 | 0 | 3 | 3 |
| derived-diamond | 3 | react-upstream | 282.586 | 35.39x | 224.000 | 13.18x | 224.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | roact | 53.650 | 6.72x | 23.000 | 1.35x | 4.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | seam | 40.956 | 5.13x | 32.000 | 1.88x | 19.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | signals | 25.668 | 3.21x | 22.000 | 1.29x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | vide | 20.507 | 2.57x | 28.000 | 1.65x | 9.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | plain | 68.784 | 1.00x | 82.000 | 1.00x | 1.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 260.794 | 3.79x | 165.000 | 2.01x | 2.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion | 729.904 | 10.61x | 152.000 | 1.85x | 13.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion-charm | 754.031 | 10.96x | 146.000 | 1.78x | 12.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | react | 325.873 | 4.74x | 224.000 | 2.73x | 224.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | react-reflex | 320.855 | 4.66x | 232.000 | 2.83x | 211.000 | 3 | 0 | 3 | 3 |
| derived-chain-100 | 3 | react-upstream | 344.251 | 5.00x | 224.000 | 2.73x | 224.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | roact | 139.801 | 2.03x | 31.000 | 0.38x | 4.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | seam | 811.969 | 11.80x | 284.000 | 3.46x | 238.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | signals | 163.567 | 2.38x | 190.000 | 2.32x | 1.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | vide | 114.173 | 1.66x | 108.000 | 1.32x | 3.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | plain | 179.445 | 1.00x | 603.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | blend | 430.975 | 2.40x | 1515.000 | 2.51x | 0.000 | 3 | 0 | 0 | 6 |
| derived-fan-in-1000 | 3 | compose | 721.578 | 4.02x | 693.000 | 1.15x | 2.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion | 2401.317 | 13.38x | 958.000 | 1.59x | 64.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion-charm | 2436.122 | 13.58x | 2818.000 | 4.67x | 65.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | react | 2362.524 | 13.17x | 1067.000 | 1.77x | 770.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | react-reflex | 7142.494 | 39.80x | 5220.000 | 8.66x | 243.000 | 3 | 0 | 3 | 3 |
| derived-fan-in-1000 | 3 | react-upstream | 2301.050 | 12.82x | 1067.000 | 1.77x | 770.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | roact | 1121.435 | 6.25x | 117.000 | 0.19x | 4.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | seam | 3350.950 | 18.67x | 2885.000 | 4.78x | 2580.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | signals | 903.517 | 5.04x | 1255.000 | 2.08x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | vide | 651.317 | 3.63x | 542.000 | 0.90x | 9.000 | 3 | 0 | 0 | 0 |
| filter-as-you-type | 1 | plain | 6203.519 | 1.00x | 2879.000 | 1.00x | 128.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | blend | 18232.702 | 2.94x | 5465.000 | 1.90x | 129.000 | 6131 | 437 | 0 | 27 |
| filter-as-you-type | 1 | compose | 10662.429 | 1.72x | 3678.000 | 1.28x | 201.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | react | 21580.966 | 3.48x | 3817.000 | 1.33x | 3792.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | react-reflex | 20008.098 | 3.23x | 3838.000 | 1.33x | 370.000 | 2505 | 437 | 9 | 9 |
| filter-as-you-type | 1 | react-upstream | 20327.332 | 3.28x | 3810.000 | 1.32x | 3793.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | roact | 11330.544 | 1.83x | 3338.000 | 1.16x | 131.000 | 2505 | 437 | 0 | 0 |
| filter-as-you-type | 1 | seam | 31527.553 | 5.08x | 5760.000 | 2.00x | 3749.000 | 2068 | 437 | 874 | 437 |
| filter-as-you-type | 1 | signals | 6952.784 | 1.12x | 2880.000 | 1.00x | 128.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | vide | 10055.741 | 1.62x | 3812.000 | 1.32x | 130.000 | 4690 | 437 | 0 | 0 |
| theme-propagation | 3 | plain | 1138.868 | 1.00x | 5732.000 | 1.00x | 128.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | blend | 2589.277 | 2.27x | 7547.000 | 1.32x | 128.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | compose | 1595.731 | 1.40x | 6192.000 | 1.08x | 257.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion | 5942.132 | 5.22x | 6393.000 | 1.12x | 192.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion-charm | 6090.469 | 5.35x | 6403.000 | 1.12x | 193.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | react | 33988.813 | 29.84x | 10740.000 | 1.87x | 10724.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | react-reflex | 34541.266 | 30.33x | 10756.000 | 1.88x | 402.000 | 3000 | 0 | 3 | 3 |
| theme-propagation | 3 | react-upstream | 35700.161 | 31.35x | 10749.000 | 1.88x | 10733.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | roact | 18447.065 | 16.20x | 8372.000 | 1.46x | 131.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | seam | 2408.450 | 2.11x | 7135.000 | 1.24x | 160.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | signals | 3020.964 | 2.65x | 6438.000 | 1.12x | 145.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | vide | 2620.285 | 2.30x | 6149.000 | 1.07x | 154.000 | 3000 | 0 | 0 | 0 |
| hud-per-frame | 1 | plain | 5760.450 | 1.00x | 149.000 | 1.00x | 10.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | blend | 14070.264 | 2.44x | 190.000 | 1.28x | 2.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | compose | 9949.957 | 1.73x | 158.000 | 1.06x | 15.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion | 70975.085 | 12.32x | 180.000 | 1.21x | 12.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion-charm | 93039.881 | 16.15x | 210.000 | 1.41x | 5.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | react | 7622.657 | 1.32x | 393.000 | 2.64x | 244.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | react-reflex | 17833.960 | 3.10x | 413.000 | 2.77x | 245.000 | 12000 | 0 | 600 | 0 |
| hud-per-frame | 1 | react-upstream | 7827.630 | 1.36x | 394.000 | 2.64x | 252.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | roact | 8711.171 | 1.51x | 208.000 | 1.40x | 2.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | seam | 43425.190 | 7.54x | 255.000 | 1.71x | 9.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | signals | 20688.387 | 3.59x | 193.000 | 1.30x | 11.000 | 12000 | 0 | 0 | 0 |
| hud-per-frame | 1 | vide | 11145.941 | 1.93x | 144.000 | 0.97x | 4.000 | 12000 | 0 | 0 | 600 |
| teardown-under-load | 1 | plain | 20861.628 | 1.00x | 274.000 | 1.00x | 256.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | blend | 53768.541 | 2.58x | 275.000 | 1.00x | 256.000 | 22003 | 2001 | 0 | 4 |
| teardown-under-load | 1 | compose | 29932.235 | 1.43x | 532.000 | 1.94x | 514.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion | 55804.061 | 2.67x | 401.000 | 1.46x | 384.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion-charm | 55481.239 | 2.66x | 403.000 | 1.47x | 384.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | react | 35184.123 | 1.69x | 1582.000 | 5.77x | 650.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | react-reflex | 33307.018 | 1.60x | 1584.000 | 5.78x | 650.000 | 10000 | 2001 | 6 | 2 |
| teardown-under-load | 1 | react-upstream | 36310.088 | 1.74x | 1583.000 | 5.78x | 651.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | roact | 40601.898 | 1.95x | 348.000 | 1.27x | 257.000 | 10001 | 2001 | 0 | 0 |
| teardown-under-load | 1 | seam | 48398.143 | 2.32x | 343.000 | 1.25x | 326.000 | 8000 | 2001 | 4000 | 2000 |
| teardown-under-load | 1 | signals | 25241.883 | 1.21x | 305.000 | 1.11x | 288.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | vide | 35277.286 | 1.69x | 307.000 | 1.12x | 290.000 | 20003 | 2001 | 0 | 6 |
| open-close-retention | 1 | plain | 261736.992 | 1.00x | 2076.000 | 1.00x | 2049.000 | 100000 | 25050 | 0 | 0 |
| open-close-retention | 1 | blend | 587032.634 | 2.24x | 1044.000 | 0.50x | 1025.000 | 275150 | 25050 | 0 | 200 |
| open-close-retention | 1 | compose | 382845.336 | 1.46x | 2142.000 | 1.03x | 2115.000 | 100000 | 25050 | 0 | 0 |
| open-close-retention | 1 | fusion | 576423.489 | 2.20x | 3091.000 | 1.49x | 3074.000 | 275150 | 25050 | 0 | 0 |
| open-close-retention | 1 | fusion-charm | 584020.458 | 2.23x | 3093.000 | 1.49x | 3074.000 | 275150 | 25050 | 0 | 0 |
| open-close-retention | 1 | react | 438732.998 | 1.68x | 2535.000 | 1.22x | 2285.000 | 125000 | 25050 | 0 | 100 |
| open-close-retention | 1 | react-reflex | 467235.984 | 1.79x | 2545.000 | 1.23x | 2293.000 | 125000 | 25050 | 300 | 100 |
| open-close-retention | 1 | react-upstream | 443329.843 | 1.69x | 2536.000 | 1.22x | 2293.000 | 125000 | 25050 | 0 | 100 |
| open-close-retention | 1 | roact | 468397.772 | 1.79x | 1069.000 | 0.51x | 1033.000 | 125050 | 25050 | 0 | 0 |
| open-close-retention | 1 | seam | 534269.530 | 2.04x | 2088.000 | 1.01x | 2072.000 | 100000 | 25050 | 50000 | 25000 |
| open-close-retention | 1 | signals | 354393.277 | 1.35x | 2075.000 | 1.00x | 2057.000 | 100000 | 25050 | 0 | 0 |
| open-close-retention | 1 | vide | 376084.760 | 1.44x | 2076.000 | 1.00x | 2059.000 | 250150 | 25050 | 0 | 300 |
| tree-expand-collapse | 1 | plain | 5646.402 | 1.00x | 225.000 | 1.00x | 128.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | blend | 22100.394 | 3.91x | 859.000 | 3.82x | 128.000 | 7040 | 630 | 0 | 21 |
| tree-expand-collapse | 1 | compose | 12998.600 | 2.30x | 361.000 | 1.60x | 197.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | react | 18311.232 | 3.24x | 1026.000 | 4.56x | 1016.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | react-reflex | 19452.417 | 3.45x | 1045.000 | 4.64x | 370.000 | 2389 | 630 | 7 | 7 |
| tree-expand-collapse | 1 | react-upstream | 18348.971 | 3.25x | 1027.000 | 4.56x | 1017.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | roact | 10353.505 | 1.83x | 240.000 | 1.07x | 139.000 | 2389 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | seam | 27449.583 | 4.86x | 338.000 | 1.50x | 264.000 | 1759 | 630 | 1260 | 630 |
| tree-expand-collapse | 1 | signals | 6533.133 | 1.16x | 219.000 | 0.97x | 128.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | vide | 10643.816 | 1.89x | 277.000 | 1.23x | 138.000 | 5539 | 630 | 0 | 0 |
| form-validation | 1 | plain | 2538.546 | 1.00x | 689.000 | 1.00x | 24.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | blend | 2166.313 | 0.85x | 1376.000 | 2.00x | 17.000 | 321 | 0 | 0 | 428 |
| form-validation | 1 | compose | 2630.677 | 1.04x | 830.000 | 1.20x | 36.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | fusion | 7643.279 | 3.01x | 883.000 | 1.28x | 48.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | fusion-charm | 8163.758 | 3.22x | 976.000 | 1.42x | 48.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | react | 53556.605 | 21.10x | 1170.000 | 1.70x | 257.000 | 314 | 0 | 0 | 110 |
| form-validation | 1 | react-reflex | 60359.906 | 23.78x | 1384.000 | 2.01x | 309.000 | 314 | 0 | 110 | 107 |
| form-validation | 1 | react-upstream | 54536.975 | 21.48x | 1178.000 | 1.71x | 258.000 | 314 | 0 | 0 | 110 |
| form-validation | 1 | roact | 34077.922 | 13.42x | 710.000 | 1.03x | 19.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | seam | 10198.597 | 4.02x | 1251.000 | 1.82x | 469.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | signals | 2507.969 | 0.99x | 948.000 | 1.38x | 16.000 | 314 | 0 | 0 | 0 |
| form-validation | 1 | vide | 1635.805 | 0.64x | 738.000 | 1.07x | 9.000 | 314 | 0 | 0 | 0 |
| table-sort-filter | 1 | plain | 19692.752 | 1.00x | 5755.000 | 1.00x | 264.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | blend | 47493.858 | 2.41x | 10945.000 | 1.90x | 256.000 | 12157 | 937 | 0 | 18 |
| table-sort-filter | 1 | compose | 33738.666 | 1.71x | 7347.000 | 1.28x | 401.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | react | 100326.329 | 5.09x | 7911.000 | 1.37x | 526.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | react-reflex | 102113.017 | 5.19x | 7918.000 | 1.38x | 530.000 | 5594 | 937 | 6 | 6 |
| table-sort-filter | 1 | react-upstream | 102541.727 | 5.21x | 7911.000 | 1.37x | 527.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | roact | 31286.296 | 1.59x | 6668.000 | 1.16x | 259.000 | 5594 | 937 | 0 | 0 |
| table-sort-filter | 1 | seam | 85109.736 | 4.32x | 11485.000 | 2.00x | 7481.000 | 4657 | 937 | 1874 | 937 |
| table-sort-filter | 1 | signals | 22302.405 | 1.13x | 5756.000 | 1.00x | 256.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | vide | 30995.753 | 1.57x | 7604.000 | 1.32x | 257.000 | 10279 | 937 | 0 | 0 |
| library-load | 1 | plain | 18.194 | 1.00x | 16.000 | 1.00x | 0.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | blend | 7728.821 | 424.80x | 380.000 | 23.75x | 370.000 | 3 | 1 | 0 | 0 |
| library-load | 1 | compose | 70674.233 | 3884.48x | 654.000 | 40.88x | 644.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | fusion | 37140.386 | 2041.35x | 182.000 | 11.38x | 182.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | fusion-charm | 36065.434 | 1982.27x | 222.000 | 13.88x | 206.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | react | 186400.279 | 10245.15x | 1420.000 | 88.75x | 1412.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | react-reflex | 189047.794 | 10390.67x | 1542.000 | 96.38x | 1533.000 | 0 | 3 | 0 | 1 |
| library-load | 1 | react-upstream | 212365.352 | 11672.27x | 1412.000 | 88.25x | 1403.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | roact | 17444.709 | 958.82x | 129.000 | 8.06x | 127.000 | 1 | 1 | 0 | 0 |
| library-load | 1 | seam | 28772.917 | 1581.45x | 197.000 | 12.31x | 180.000 | 0 | 3 | 0 | 0 |
| library-load | 1 | signals | 4270.778 | 234.74x | 42.000 | 2.62x | 34.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | vide | 9763.989 | 536.66x | 98.000 | 6.12x | 97.000 | 3 | 1 | 1 | 0 |
| rows-append-1000 | 1 | plain | 87776.576 | 1.00x | 74434.000 | 1.00x | 2057.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | blend | 131961.344 | 1.50x | 103590.000 | 1.39x | 2049.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | compose | 89959.595 | 1.02x | 76487.000 | 1.03x | 3276.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion | 593872.804 | 6.77x | 88364.000 | 1.19x | 4106.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion-charm | 636346.959 | 7.25x | 95866.000 | 1.29x | 4106.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | react | 169381.305 | 1.93x | 96685.000 | 1.30x | 10973.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | react-reflex | 183981.124 | 2.10x | 100422.000 | 1.35x | 12956.000 | 15000 | 5000 | 2001 | 1 |
| rows-append-1000 | 1 | react-upstream | 169655.771 | 1.93x | 96686.000 | 1.30x | 10982.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | roact | 127183.656 | 1.45x | 97459.000 | 1.31x | 2049.000 | 15000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | seam | 209385.506 | 2.39x | 100875.000 | 1.36x | 35524.000 | 11000 | 5000 | 8000 | 3000 |
| rows-append-1000 | 1 | signals | 125070.896 | 1.42x | 83451.000 | 1.12x | 2057.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | vide | 94684.616 | 1.08x | 77082.000 | 1.04x | 2058.000 | 39000 | 5000 | 2000 | 0 |
| rows-clear | 1 | plain | 27313.523 | 1.00x | 3231.000 | 1.00x | 1032.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | blend | 60526.585 | 2.22x | 4136.000 | 1.28x | 1025.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | compose | 40133.138 | 1.47x | 3344.000 | 1.03x | 1619.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion | 141219.939 | 5.17x | 5369.000 | 1.66x | 2049.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion-charm | 151019.126 | 5.53x | 9128.000 | 2.83x | 2049.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | react | 33695.590 | 1.23x | 6236.000 | 1.93x | 1878.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | react-reflex | 36995.094 | 1.35x | 8103.000 | 2.51x | 1947.000 | 0 | 0 | 1 | 1 |
| rows-clear | 1 | react-upstream | 33933.002 | 1.24x | 6237.000 | 1.93x | 1871.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | roact | 41962.525 | 1.54x | 5117.000 | 1.58x | 1025.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | seam | 102318.367 | 3.75x | 9563.000 | 2.96x | 1157.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | signals | 28781.032 | 1.05x | 5278.000 | 1.63x | 1025.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | vide | 30583.524 | 1.12x | 2629.000 | 0.81x | 1026.000 | 0 | 0 | 0 | 0 |
| rows-create-1000 | 1 | plain | 59713.440 | 1.00x | 37212.000 | 1.00x | 1032.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | blend | 141156.852 | 2.36x | 51821.000 | 1.39x | 1033.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | compose | 81797.621 | 1.37x | 38257.000 | 1.03x | 1643.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion | 240030.268 | 4.02x | 44171.000 | 1.19x | 2057.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion-charm | 246985.382 | 4.14x | 47923.000 | 1.29x | 2042.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | react | 133275.578 | 2.23x | 44748.000 | 1.20x | 5589.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | react-reflex | 147247.295 | 2.47x | 46616.000 | 1.25x | 6587.000 | 15000 | 5000 | 2001 | 1 |
| rows-create-1000 | 1 | react-upstream | 140138.339 | 2.35x | 44764.000 | 1.20x | 5598.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | roact | 106267.947 | 1.78x | 48730.000 | 1.31x | 1025.000 | 15000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | seam | 141990.626 | 2.38x | 50442.000 | 1.36x | 17765.000 | 11000 | 5000 | 8000 | 3000 |
| rows-create-1000 | 1 | signals | 70830.199 | 1.19x | 41737.000 | 1.12x | 1025.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | vide | 76811.610 | 1.29x | 38524.000 | 1.04x | 1026.000 | 39000 | 5000 | 2000 | 0 |
| rows-create-10000 | 1 | plain | 543741.863 | 1.00x | 371069.000 | 1.00x | 8196.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | blend | 1138505.681 | 2.09x | 516974.000 | 1.39x | 8204.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | compose | 730247.634 | 1.34x | 381349.000 | 1.03x | 13349.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion | 7108334.999 | 13.07x | 438765.000 | 1.18x | 16417.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion-charm | 7536997.298 | 13.86x | 476299.000 | 1.28x | 16416.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | react | 3478115.158 | 6.40x | 443505.000 | 1.20x | 51865.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | react-reflex | 3658001.586 | 6.73x | 462711.000 | 1.25x | 62127.000 | 150000 | 50000 | 20001 | 1 |
| rows-create-10000 | 1 | react-upstream | 3525267.587 | 6.48x | 443506.000 | 1.20x | 51874.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | roact | 901048.077 | 1.66x | 485702.000 | 1.31x | 8205.000 | 150000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | seam | 1143786.159 | 2.10x | 503966.000 | 1.36x | 176279.000 | 110000 | 50000 | 80000 | 30000 |
| rows-create-10000 | 1 | signals | 754199.594 | 1.39x | 415217.000 | 1.12x | 8204.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | vide | 723789.900 | 1.33x | 383882.000 | 1.03x | 8205.000 | 390000 | 50000 | 20000 | 0 |
| rows-remove-one | 1 | plain | 1484.303 | 1.00x | 37209.000 | 1.00x | 1025.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | blend | 2283.160 | 1.54x | 51806.000 | 1.39x | 1033.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | compose | 1494.902 | 1.01x | 38246.000 | 1.03x | 1619.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | fusion | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | fusion-charm | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | react | 39609.160 | 26.69x | 52141.000 | 1.40x | 5586.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | react-reflex | 45500.075 | 30.65x | 53991.000 | 1.45x | 6575.000 | 500 | 0 | 1 | 1 |
| rows-remove-one | 1 | react-upstream | 41391.028 | 27.89x | 52134.000 | 1.40x | 5595.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | roact | 39944.023 | 26.91x | 48727.000 | 1.31x | 1033.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | seam | 9234.061 | 6.22x | 50441.000 | 1.36x | 17749.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | signals | 2367.568 | 1.60x | 41740.000 | 1.12x | 1033.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | vide | 2012.687 | 1.36x | 38560.000 | 1.04x | 1034.000 | 500 | 0 | 0 | 0 |
| rows-replace-1000 | 1 | plain | 93102.314 | 1.00x | 40413.000 | 1.00x | 2041.000 | 10000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | blend | 180177.442 | 1.94x | 55929.000 | 1.38x | 2057.000 | 43000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | compose | 123138.488 | 1.32x | 41005.000 | 1.01x | 2708.000 | 10000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | fusion | 620562.955 | 6.67x | 48410.000 | 1.20x | 3074.000 | 43000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | fusion-charm | 711041.758 | 7.64x | 55936.000 | 1.38x | 3082.000 | 43000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | react | 165570.059 | 1.78x | 50748.000 | 1.26x | 7262.000 | 15000 | 5000 | 2000 | 1 |
| rows-replace-1000 | 1 | react-reflex | 174582.320 | 1.88x | 54484.000 | 1.35x | 8316.000 | 15000 | 5000 | 2001 | 1 |
| rows-replace-1000 | 1 | react-upstream | 162329.857 | 1.74x | 50749.000 | 1.26x | 7263.000 | 15000 | 5000 | 2000 | 1 |
| rows-replace-1000 | 1 | roact | 122801.609 | 1.32x | 53757.000 | 1.33x | 2041.000 | 15000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | seam | 224435.296 | 2.41x | 59817.000 | 1.48x | 18854.000 | 11000 | 5000 | 8000 | 3000 |
| rows-replace-1000 | 1 | signals | 89090.228 | 0.96x | 46999.000 | 1.16x | 2057.000 | 10000 | 5000 | 2000 | 0 |
| rows-replace-1000 | 1 | vide | 113115.513 | 1.21x | 41108.000 | 1.02x | 2051.000 | 39000 | 5000 | 2000 | 0 |
| rows-select | 1 | plain | 16.370 | 1.00x | 37219.000 | 1.00x | 1024.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | blend | 31.940 | 1.95x | 51813.000 | 1.39x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | compose | 26.639 | 1.63x | 38241.000 | 1.03x | 1636.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | fusion | 56.415 | 3.45x | 44171.000 | 1.19x | 2057.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | fusion-charm | 75.111 | 4.59x | 47922.000 | 1.29x | 2049.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | react | 24.265 | 1.48x | 44762.000 | 1.20x | 5597.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | react-reflex | 888.169 | 54.26x | 46628.000 | 1.25x | 6595.000 | 2 | 0 | 1 | 0 |
| rows-select | 1 | react-upstream | 23.264 | 1.42x | 44763.000 | 1.20x | 5598.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | roact | 17.603 | 1.08x | 48730.000 | 1.31x | 1017.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | seam | 1667.816 | 101.88x | 50444.000 | 1.36x | 1157.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | signals | 32.360 | 1.98x | 41737.000 | 1.12x | 1033.000 | 2 | 0 | 0 | 0 |
| rows-select | 1 | vide | 23.584 | 1.44x | 38524.000 | 1.04x | 1034.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | plain | 918.595 | 1.00x | 37236.000 | 1.00x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | blend | 1802.554 | 1.96x | 51837.000 | 1.39x | 1033.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | compose | 957.878 | 1.04x | 38265.000 | 1.03x | 1616.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion | 114360.701 | 124.50x | 44226.000 | 1.19x | 2057.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion-charm | 118809.303 | 129.34x | 47986.000 | 1.29x | 2049.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | react | 75568.735 | 82.27x | 52163.000 | 1.40x | 5597.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | react-reflex | 81557.617 | 88.79x | 54030.000 | 1.45x | 6587.000 | 2 | 0 | 1 | 1 |
| rows-swap | 1 | react-upstream | 75396.753 | 82.08x | 52163.000 | 1.40x | 5590.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | roact | 42434.092 | 46.19x | 48755.000 | 1.31x | 1033.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | seam | 9609.147 | 10.46x | 50450.000 | 1.35x | 17773.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | signals | 1118.445 | 1.22x | 41745.000 | 1.12x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | vide | 461.569 | 0.50x | 38540.000 | 1.04x | 1026.000 | 2 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | plain | 257.740 | 1.00x | 37221.000 | 1.00x | 1032.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | blend | 422.617 | 1.64x | 51828.000 | 1.39x | 1025.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | compose | 293.486 | 1.14x | 38252.000 | 1.03x | 1614.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion | 526.821 | 2.04x | 44180.000 | 1.19x | 2057.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion-charm | 810.881 | 3.15x | 47934.000 | 1.29x | 2059.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react | 312.121 | 1.21x | 44753.000 | 1.20x | 5597.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react-reflex | 1165.780 | 4.52x | 46620.000 | 1.25x | 6595.000 | 100 | 0 | 1 | 0 |
| rows-update-every-10th | 1 | react-upstream | 341.015 | 1.32x | 44754.000 | 1.20x | 5591.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | roact | 385.536 | 1.50x | 48732.000 | 1.31x | 1032.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | seam | 1519.961 | 5.90x | 50434.000 | 1.35x | 1158.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | signals | 390.357 | 1.51x | 41732.000 | 1.12x | 1027.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | vide | 339.302 | 1.32x | 38520.000 | 1.03x | 1028.000 | 100 | 0 | 0 | 0 |

## Page retention

Growth is the retained Luau heap after the page closes minus the retained heap with only its source owner and host mounted. Collection runs before both readings. The source owner stays alive during the run. Collection noise can make the difference negative; such a reading counts as 0, as in the Verify mounted and teardown readings.

| Workload | Framework | Median retained growth (KiB) |
| --- | --- | ---: |
| teardown-under-load | plain | 256.000 |
| teardown-under-load | blend | 256.000 |
| teardown-under-load | compose | 512.000 |
| teardown-under-load | fusion | 376.000 |
| teardown-under-load | fusion-charm | 384.000 |
| teardown-under-load | react | 1362.000 |
| teardown-under-load | react-reflex | 1362.000 |
| teardown-under-load | react-upstream | 1362.000 |
| teardown-under-load | roact | 320.000 |
| teardown-under-load | seam | 322.000 |
| teardown-under-load | signals | 288.000 |
| teardown-under-load | vide | 288.000 |
| open-close-retention | plain | 2058.000 |
| open-close-retention | blend | 1025.000 |
| open-close-retention | compose | 2114.000 |
| open-close-retention | fusion | 3073.000 |
| open-close-retention | fusion-charm | 3073.000 |
| open-close-retention | react | 2315.000 |
| open-close-retention | react-reflex | 2315.000 |
| open-close-retention | react-upstream | 2315.000 |
| open-close-retention | roact | 1041.000 |
| open-close-retention | seam | 2068.000 |
| open-close-retention | signals | 2057.000 |
| open-close-retention | vide | 2057.000 |

## Summary

This summary uses the 32 selected workloads and treats time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. A workload whose plain heap is zero has no heap ratio. Lanes support different workloads, so compare a geometric mean only together with its measured count.

The shared columns use only the workloads that every lane measured: 24 for time (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-replace-1000`, `rows-select`, `rows-swap`, `rows-update-every-10th`) and 24 for heap (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-replace-1000`, `rows-select`, `rows-swap`, `rows-update-every-10th`).

| Framework | Supported | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain | 32 | 32 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 31 | 31 | 3.33x | 1.65x | 3.47x | 1.57x |
| compose | 32 | 32 | 2.52x | 1.33x | 2.65x | 1.32x |
| fusion | 26 | 26 | 10.65x | 1.44x | 9.84x | 1.42x |
| fusion-charm | 26 | 26 | 10.82x | 1.63x | 9.86x | 1.62x |
| react | 31 | 31 | 7.06x | 2.35x | 7.22x | 2.51x |
| react-reflex | 31 | 31 | 9.53x | 2.52x | 10.54x | 2.74x |
| react-upstream | 31 | 31 | 7.22x | 2.35x | 7.42x | 2.52x |
| roact | 31 | 31 | 4.13x | 1.19x | 4.40x | 1.25x |
| seam | 32 | 32 | 6.67x | 1.78x | 6.55x | 1.71x |
| signals | 31 | 31 | 2.11x | 1.22x | 2.44x | 1.24x |
| vide | 32 | 32 | 2.14x | 1.19x | 2.24x | 1.16x |

## Source identities

Harness revision: `641a655a2c64225e868c9a69a6289605f8513619`. Full source state, tools, environment and command are in `context.json`.

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
