# Headless results

Harness commit: `51e35f0012f34f3ce70724836a7a916a276fdb16`. Workflow run: [Library comparison 40721549960](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40721549960). Runner: `ubuntu-latest`. Mode: `like-for-like`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **like-for-like**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

# Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Framework | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| cold-mount-100 | 1 | plain | 1049.875 | 1.00x | 548.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | blend | 1217.331 | 1.16x | 689.000 | 1.26x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | compose | 1095.904 | 1.04x | 558.000 | 1.02x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion | 1198.648 | 1.14x | 556.000 | 1.01x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion-charm | 1206.875 | 1.15x | 564.000 | 1.03x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react | 1349.984 | 1.29x | 606.000 | 1.11x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-reflex | 1506.153 | 1.43x | 607.000 | 1.11x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-upstream | 1434.936 | 1.37x | 606.000 | 1.11x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | roact | 1249.845 | 1.19x | 654.000 | 1.19x | 0.000 | 201 | 101 | 0 | 0 |
| cold-mount-100 | 1 | seam | 1128.518 | 1.07x | 561.000 | 1.02x | 0.000 | 100 | 101 | 1 | 0 |
| cold-mount-100 | 1 | signals | 982.124 | 0.94x | 559.000 | 1.02x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | vide | 1166.424 | 1.11x | 554.000 | 1.01x | 0.000 | 703 | 101 | 0 | 0 |
| cold-mount-1000 | 1 | plain | 8246.932 | 1.00x | 5478.000 | 1.00x | 1.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | blend | 14955.849 | 1.81x | 6856.000 | 1.25x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | compose | 10373.640 | 1.26x | 5480.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion | 11488.377 | 1.39x | 5528.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion-charm | 11420.617 | 1.38x | 5528.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react | 13164.740 | 1.60x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-reflex | 14061.390 | 1.71x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-upstream | 13171.660 | 1.60x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | roact | 11608.077 | 1.41x | 6444.000 | 1.18x | 0.000 | 2001 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | seam | 10149.162 | 1.23x | 5547.000 | 1.01x | 8.000 | 1000 | 1001 | 1 | 0 |
| cold-mount-1000 | 1 | signals | 8786.794 | 1.07x | 5509.000 | 1.01x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | vide | 9542.545 | 1.16x | 5463.000 | 1.00x | 0.000 | 7003 | 1001 | 0 | 0 |
| cold-mount-10000 | 1 | plain | 70334.599 | 1.00x | 54973.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | blend | 147570.280 | 2.10x | 68689.000 | 1.25x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | compose | 109406.304 | 1.56x | 55074.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion | 109987.829 | 1.56x | 55722.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion-charm | 111977.353 | 1.59x | 55714.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react | 145453.678 | 2.07x | 59836.000 | 1.09x | 0.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-reflex | 154915.476 | 2.20x | 59836.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-upstream | 157075.275 | 2.23x | 59844.000 | 1.09x | 8.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | roact | 112794.758 | 1.60x | 64830.000 | 1.18x | 0.000 | 20001 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | seam | 119945.922 | 1.71x | 56101.000 | 1.02x | 0.000 | 10000 | 10001 | 1 | 0 |
| cold-mount-10000 | 1 | signals | 102272.740 | 1.45x | 55293.000 | 1.01x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | vide | 99155.166 | 1.41x | 54809.000 | 1.00x | 1.000 | 70003 | 10001 | 0 | 0 |
| mount-dispose | 5 | plain | 9236.113 | 1.00x | 1.000 | 1.00x | 1.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | blend | 17340.176 | 1.88x | 1.000 | 1.00x | 1.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | compose | 10195.790 | 1.10x | 1.000 | 1.00x | 1.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion | 12409.003 | 1.34x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion-charm | 12129.052 | 1.31x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | react | 13711.381 | 1.48x | 5.000 | 5.00x | 4.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-reflex | 13254.761 | 1.44x | 4.000 | 4.00x | 4.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-upstream | 14173.202 | 1.53x | 0.000 | 0.00x | 3.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | roact | 12163.063 | 1.32x | 0.000 | 0.00x | 0.000 | 2005 | 1005 | 0 | 0 |
| mount-dispose | 5 | seam | 11011.239 | 1.19x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 5 | 0 |
| mount-dispose | 5 | signals | 9176.034 | 0.99x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | vide | 9175.329 | 0.99x | 1.000 | 1.00x | 0.000 | 7015 | 1005 | 0 | 0 |
| update-leaf | 50 | plain | 27.102 | 1.00x | 2744.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | blend | 60.639 | 2.24x | 3429.000 | 1.25x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 65.455 | 2.42x | 2756.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 110.489 | 4.08x | 2772.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion-charm | 174.335 | 6.43x | 2773.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 61.049 | 2.25x | 2995.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 103.851 | 3.83x | 2995.000 | 1.09x | 1.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | react-upstream | 52.221 | 1.93x | 3002.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 48.575 | 1.79x | 3230.000 | 1.18x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 112.238 | 4.14x | 2778.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 68.836 | 2.54x | 2762.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 63.248 | 2.33x | 2738.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-fanout | 20 | plain | 655.940 | 1.00x | 1651.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | blend | 2155.217 | 3.29x | 2233.000 | 1.35x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | compose | 1443.842 | 2.20x | 1804.000 | 1.09x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion | 5735.583 | 8.74x | 1886.000 | 1.14x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion-charm | 6030.576 | 9.19x | 1896.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react | 1057.499 | 1.61x | 1926.000 | 1.17x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-reflex | 1147.909 | 1.75x | 1926.000 | 1.17x | 1.000 | 6000 | 0 | 20 | 0 |
| update-fanout | 20 | react-upstream | 1128.428 | 1.72x | 1925.000 | 1.17x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | roact | 1300.824 | 1.98x | 2063.000 | 1.25x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | seam | 2290.218 | 3.49x | 2137.000 | 1.29x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | signals | 2755.955 | 4.20x | 1901.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | vide | 2484.167 | 3.79x | 1807.000 | 1.09x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | plain | 639.516 | 1.00x | 1651.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 3688.307 | 5.77x | 2511.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 2443.299 | 3.82x | 1961.000 | 1.19x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 8357.584 | 13.07x | 2121.000 | 1.28x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion-charm | 14232.921 | 22.26x | 2698.000 | 1.63x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 1892.484 | 2.96x | 2097.000 | 1.27x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 40036.456 | 62.60x | 2371.000 | 1.44x | 1.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | react-upstream | 1798.352 | 2.81x | 2097.000 | 1.27x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 2530.336 | 3.96x | 2522.000 | 1.53x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 5635.027 | 8.81x | 2934.000 | 1.78x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 4162.410 | 6.51x | 2231.000 | 1.35x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 2966.095 | 4.64x | 1952.000 | 1.18x | 0.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 25.488 | 1.00x | 14.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 2656.983 | 104.24x | 21.000 | 1.50x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | compose | 459.878 | 18.04x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 14832.465 | 581.94x | 18.000 | 1.29x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | fusion-charm | 769.178 | 30.18x | 20.000 | 1.43x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 5358.106 | 210.22x | 4.000 | 0.29x | 4.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react-reflex | 1285.258 | 50.43x | 8.000 | 0.57x | 0.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | react-upstream | 5105.880 | 200.32x | 4.000 | 0.29x | 4.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | roact | 1968.067 | 77.22x | 18.000 | 1.29x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 1743.086 | 68.39x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 695.055 | 27.27x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 328.428 | 12.89x | 16.000 | 1.14x | 0.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 3082.257 | 1.00x | 28.000 | 1.00x | 8.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 6958.867 | 2.26x | 38.000 | 1.36x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 4734.489 | 1.54x | 16.000 | 0.57x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 4564.942 | 1.48x | 24.000 | 0.86x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | fusion-charm | 4405.991 | 1.43x | 26.000 | 0.93x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react | 6441.593 | 2.09x | 357.000 | 12.75x | 10.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | react-reflex | 6432.660 | 2.09x | 365.000 | 13.04x | 1.000 | 1010 | 510 | 20 | 0 |
| branch-swap | 20 | react-upstream | 7039.720 | 2.28x | 359.000 | 12.82x | 12.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | roact | 4229.549 | 1.37x | 27.000 | 0.96x | 0.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 3743.356 | 1.21x | 30.000 | 1.07x | 1.000 | 500 | 510 | 10 | 0 |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — | — | — | — | — | — | — |
| branch-swap | 20 | vide | 3510.100 | 1.14x | 23.000 | 0.82x | 0.000 | 3530 | 510 | 0 | 0 |
| keyed-append | 10 | plain | 894.444 | 1.00x | 1692.000 | 1.00x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | blend | 3306.025 | 3.70x | 3068.000 | 1.81x | 1.000 | 3500 | 50 | 0 | 0 |
| keyed-append | 10 | compose | 987.787 | 1.10x | 2162.000 | 1.28x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | react | 8743.143 | 9.77x | 2510.000 | 1.48x | 6.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | react-reflex | 8999.965 | 10.06x | 2510.000 | 1.48x | 6.000 | 150 | 50 | 10 | 0 |
| keyed-append | 10 | react-upstream | 9258.199 | 10.35x | 2510.000 | 1.48x | 5.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | roact | 4323.235 | 4.83x | 1988.000 | 1.17x | 0.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | seam | 9535.027 | 10.66x | 3464.000 | 2.05x | 0.000 | 100 | 50 | 100 | 50 |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | vide | 1217.601 | 1.36x | 2266.000 | 1.34x | 0.000 | 400 | 50 | 0 | 0 |
| keyed-prepend | 10 | plain | 1152.185 | 1.00x | 1692.000 | 1.00x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 3606.418 | 3.13x | 3061.000 | 1.81x | 1.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 2773.433 | 2.41x | 2162.000 | 1.28x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react | 12884.039 | 11.18x | 2458.000 | 1.45x | 6.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | react-reflex | 12727.712 | 11.05x | 2458.000 | 1.45x | 6.000 | 3150 | 50 | 10 | 0 |
| keyed-prepend | 10 | react-upstream | 12940.235 | 11.23x | 2450.000 | 1.45x | 5.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | roact | 5771.150 | 5.01x | 1988.000 | 1.17x | 0.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 11123.381 | 9.65x | 3463.000 | 2.05x | 0.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | vide | 3115.677 | 2.70x | 2266.000 | 1.34x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1018.410 | 1.00x | 1692.000 | 1.00x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 3150.152 | 3.09x | 3068.000 | 1.81x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 1619.314 | 1.59x | 2162.000 | 1.28x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react | 10568.367 | 10.38x | 2484.000 | 1.47x | 6.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | react-reflex | 10771.904 | 10.58x | 2483.000 | 1.47x | 6.000 | 1650 | 50 | 10 | 0 |
| keyed-insert | 10 | react-upstream | 10511.107 | 10.32x | 2482.000 | 1.47x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | roact | 4538.635 | 4.46x | 1988.000 | 1.17x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 10428.281 | 10.24x | 3463.000 | 2.05x | 0.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | vide | 1920.221 | 1.89x | 2266.000 | 1.34x | 0.000 | 1900 | 50 | 0 | 0 |
| keyed-remove | 10 | plain | 947.007 | 1.00x | 1696.000 | 1.00x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | blend | 3142.546 | 3.32x | 3060.000 | 1.80x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-remove | 10 | compose | 1632.480 | 1.72x | 2161.000 | 1.27x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | react | 10822.512 | 11.43x | 2409.000 | 1.42x | 14.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | react-reflex | 11963.746 | 12.63x | 2409.000 | 1.42x | 6.000 | 1560 | 50 | 10 | 0 |
| keyed-remove | 10 | react-upstream | 12223.931 | 12.91x | 2410.000 | 1.42x | 6.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | roact | 4780.954 | 5.05x | 1987.000 | 1.17x | 0.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | seam | 10133.476 | 10.70x | 3455.000 | 2.04x | 0.000 | 1510 | 50 | 100 | 50 |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | vide | 1852.796 | 1.96x | 2265.000 | 1.34x | 0.000 | 1810 | 50 | 0 | 0 |
| keyed-replace | 10 | plain | 28678.976 | 1.00x | 1719.000 | 1.00x | 8.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | blend | 83705.810 | 2.92x | 5701.000 | 3.32x | 0.000 | 30000 | 3000 | 0 | 0 |
| keyed-replace | 10 | compose | 51708.147 | 1.80x | 2184.000 | 1.27x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion | 76705.994 | 2.67x | 3003.000 | 1.75x | 1.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion-charm | 72341.929 | 2.52x | 3005.000 | 1.75x | 1.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | react | 62847.205 | 2.19x | 3939.000 | 2.29x | 15.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | react-reflex | 66999.319 | 2.34x | 3939.000 | 2.29x | 15.000 | 9000 | 3000 | 10 | 0 |
| keyed-replace | 10 | react-upstream | 66556.393 | 2.32x | 3931.000 | 2.29x | 7.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | roact | 37375.632 | 1.30x | 2010.000 | 1.17x | 0.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | seam | 84617.565 | 2.95x | 3502.000 | 2.04x | 0.000 | 6000 | 3000 | 6000 | 3000 |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-replace | 10 | vide | 49940.084 | 1.74x | 2320.000 | 1.35x | 0.000 | 24000 | 3000 | 0 | 0 |
| keyed-reverse | 10 | plain | 796.404 | 1.00x | 1695.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | blend | 1603.746 | 2.01x | 3026.000 | 1.79x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | compose | 1671.049 | 2.10x | 2153.000 | 1.27x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion | 13217.327 | 16.60x | 2978.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion-charm | 13027.841 | 16.36x | 2973.000 | 1.75x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react | 28160.928 | 35.36x | 2394.000 | 1.41x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react-reflex | 29044.398 | 36.47x | 2395.000 | 1.41x | 4.000 | 3000 | 0 | 10 | 0 |
| keyed-reverse | 10 | react-upstream | 28766.614 | 36.12x | 2402.000 | 1.42x | 5.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | roact | 4430.220 | 5.56x | 1980.000 | 1.17x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | seam | 8019.689 | 10.07x | 3470.000 | 2.05x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-reverse | 10 | vide | 1874.915 | 2.35x | 2249.000 | 1.33x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | plain | 752.903 | 1.00x | 1695.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | blend | 1478.795 | 1.96x | 3026.000 | 1.79x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | compose | 1824.997 | 2.42x | 2146.000 | 1.27x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion | 12969.728 | 17.23x | 2979.000 | 1.76x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion-charm | 12548.001 | 16.67x | 2973.000 | 1.75x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react | 19547.357 | 25.96x | 2394.000 | 1.41x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react-reflex | 19600.616 | 26.03x | 2402.000 | 1.42x | 12.000 | 3000 | 0 | 10 | 0 |
| keyed-rotate | 10 | react-upstream | 19709.193 | 26.18x | 2394.000 | 1.41x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | roact | 4510.173 | 5.99x | 1987.000 | 1.17x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | seam | 7956.139 | 10.57x | 3454.000 | 2.04x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-rotate | 10 | vide | 1895.993 | 2.52x | 2249.000 | 1.33x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | plain | 811.741 | 1.00x | 1695.000 | 1.00x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 1555.550 | 1.92x | 3026.000 | 1.79x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 1860.607 | 2.29x | 2162.000 | 1.28x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 14206.757 | 17.50x | 2971.000 | 1.75x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion-charm | 13266.630 | 16.34x | 2980.000 | 1.76x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 18024.582 | 22.20x | 2394.000 | 1.41x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react-reflex | 18497.456 | 22.79x | 2394.000 | 1.41x | 4.000 | 2990 | 0 | 10 | 0 |
| keyed-shuffle | 10 | react-upstream | 18519.540 | 22.81x | 2394.000 | 1.41x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | roact | 4315.903 | 5.32x | 1987.000 | 1.17x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 8226.852 | 10.13x | 3463.000 | 2.04x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-shuffle | 10 | vide | 1744.383 | 2.15x | 2249.000 | 1.33x | 0.000 | 2990 | 0 | 0 | 0 |
| events | 5 | plain | 14182.044 | 1.00x | 1.000 | 1.00x | 1.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | blend | 23209.297 | 1.64x | 1.000 | 1.00x | 1.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | compose | 13409.856 | 0.95x | 8.000 | 8.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | fusion | 17052.879 | 1.20x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | fusion-charm | 16131.472 | 1.14x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | react | 18612.715 | 1.31x | 4.000 | 4.00x | 11.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | react-reflex | 19190.485 | 1.35x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | react-upstream | 18465.028 | 1.30x | 0.000 | 0.00x | 11.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | roact | 16927.189 | 1.19x | 1.000 | 1.00x | 0.000 | 2005 | 1005 | 1000 | 0 |
| events | 5 | seam | 15868.565 | 1.12x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1005 | 0 |
| events | 5 | signals | 12190.539 | 0.86x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | vide | 13027.024 | 0.92x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 1000 | 0 |
| animate-many | 1 | plain | 1027.347 | 1.00x | 1508.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | blend | 6338.324 | 6.17x | 2642.000 | 1.75x | 0.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | compose | 5660.347 | 5.51x | 2275.000 | 1.51x | 0.000 | 6000 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 94066.284 | 91.56x | 2591.000 | 1.72x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | fusion-charm | 95751.052 | 93.20x | 2600.000 | 1.72x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 15888.719 | 15.47x | 3519.000 | 2.33x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — | — | — |
| animate-many | 1 | vide | 3849.099 | 3.75x | 1916.000 | 1.27x | 0.000 | 6000 | 0 | 0 | 30 |
| status-panel | 20 | plain | 441.425 | 1.00x | 142.000 | 1.00x | 1.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | blend | 971.482 | 2.20x | 247.000 | 1.74x | 0.000 | 438 | 21 | 0 | 0 |
| status-panel | 20 | compose | 862.408 | 1.95x | 186.000 | 1.31x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | fusion | 2100.640 | 4.76x | 232.000 | 1.63x | 1.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | fusion-charm | 2245.483 | 5.09x | 237.000 | 1.67x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | react | 2569.946 | 5.82x | 198.000 | 1.39x | 7.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | react-reflex | 2060.510 | 4.67x | 208.000 | 1.46x | 6.000 | 103 | 21 | 20 | 0 |
| status-panel | 20 | react-upstream | 1799.913 | 4.08x | 199.000 | 1.40x | 7.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | roact | 745.241 | 1.69x | 172.000 | 1.21x | 0.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | seam | 1543.813 | 3.50x | 290.000 | 2.04x | 1.000 | 82 | 21 | 42 | 21 |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| status-panel | 20 | vide | 619.632 | 1.40x | 184.000 | 1.30x | 0.000 | 208 | 21 | 0 | 0 |
| mount-cycles | 1 | plain | 19565.580 | 1.00x | 1.000 | 1.00x | 1.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | blend | 32057.190 | 1.64x | 1.000 | 1.00x | 8.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | compose | 18580.697 | 0.95x | 0.000 | 0.00x | 1.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion | 21429.350 | 1.10x | 1.000 | 1.00x | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion-charm | 19518.361 | 1.00x | 1.000 | 1.00x | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react | 27483.737 | 1.40x | 13.000 | 13.00x | 28.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-reflex | 34444.010 | 1.76x | 13.000 | 13.00x | 20.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-upstream | 34404.966 | 1.76x | 13.000 | 13.00x | 20.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | roact | 22422.655 | 1.15x | 1.000 | 1.00x | 0.000 | 3630 | 1830 | 1800 | 0 |
| mount-cycles | 1 | seam | 20237.584 | 1.03x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1830 | 0 |
| mount-cycles | 1 | signals | 16698.334 | 0.85x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | vide | 17711.328 | 0.91x | 1.000 | 1.00x | 1.000 | 14490 | 1830 | 1800 | 0 |
| scene-3d | 20 | plain | 3484.681 | 1.00x | 1036.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | blend | 6086.430 | 1.75x | 1571.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 4753.119 | 1.36x | 1209.000 | 1.17x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 58318.937 | 16.74x | 1575.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion-charm | 57888.314 | 16.61x | 1579.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 5455.568 | 1.57x | 1236.000 | 1.19x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 5849.020 | 1.68x | 1246.000 | 1.20x | 1.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | react-upstream | 6591.372 | 1.89x | 1235.000 | 1.19x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — | — | — | — | — | — | — |
| scene-3d | 20 | seam | 14103.813 | 4.05x | 2210.000 | 2.13x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 9107.394 | 2.61x | 1697.000 | 1.64x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 5953.910 | 1.71x | 1228.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |

## Summary

This summary uses the 22 selected workloads. The geometric mean divides each measured median time by the plain median time of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count.

| Framework | Supported | Measured | Geometric mean time / plain |
| --- | ---: | ---: | ---: |
| plain | 22 | 22 | 1.00x |
| blend | 22 | 22 | 2.89x |
| compose | 22 | 22 | 1.96x |
| fusion | 18 | 18 | 6.18x |
| fusion-charm | 18 | 18 | 5.47x |
| react | 21 | 21 | 4.88x |
| react-reflex | 21 | 21 | 5.58x |
| react-upstream | 21 | 21 | 4.98x |
| roact | 20 | 20 | 2.88x |
| seam | 22 | 22 | 4.52x |
| signals | 11 | 11 | 2.18x |
| vide | 22 | 22 | 1.95x |

## Source identities

Harness revision: `51e35f0012f34f3ce70724836a7a916a276fdb16`. Full source state, tools, environment and command are in `context.json`.

| Dependency | Version | Commit | Tree | Rights |
| --- | --- | --- | --- | --- |
| compose | unreleased | `e4fcb69b238929d042726b16f44d2d25278bb7b4` | `2645909025150ba8e6b3ecfc22c397c26fa8ff35` | MIT |
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
