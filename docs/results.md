# Results

Harness commit: `e1ecb1e3d4758d216e08b1f3837f54ceebfb21ea`. Workflow run: [Library comparison 40642075808](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40642075808). Runner: `ubuntu-latest`. Mode: `as-shipped`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **as-shipped**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

## Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Ratios divide by the Compose lane, the reference lane; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance.

| Workload | Iterations | Framework | Median time (us) | / Compose | Median heap (KiB) | / Compose | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| cold-mount-100 | 1 | plain | 744.529 | 0.78x | 548.000 | 0.98x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | compose | 959.973 | 1.00x | 558.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | compose-direct | 866.738 | 0.90x | 558.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion | 1035.351 | 1.08x | 564.000 | 1.01x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | vide | 825.988 | 0.86x | 555.000 | 0.99x | 0.000 | 703 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react | 1493.079 | 1.56x | 607.000 | 1.09x | 9.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | blend | 1403.584 | 1.46x | 697.000 | 1.25x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | roact | 1338.029 | 1.39x | 654.000 | 1.17x | 0.000 | 201 | 101 | 0 | 0 |
| cold-mount-100 | 1 | seam | 1150.278 | 1.20x | 569.000 | 1.02x | 0.000 | 100 | 101 | 1 | 0 |
| cold-mount-100 | 1 | signals | 1165.581 | 1.21x | 559.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-reflex | 1424.043 | 1.48x | 606.000 | 1.09x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion-charm | 1089.663 | 1.14x | 564.000 | 1.01x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-upstream | 1437.571 | 1.50x | 606.000 | 1.09x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-1000 | 1 | plain | 7450.418 | 0.94x | 5478.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | compose | 7949.284 | 1.00x | 5480.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | compose-direct | 7635.117 | 0.96x | 5480.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion | 8743.851 | 1.10x | 5535.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | vide | 8527.165 | 1.07x | 5471.000 | 1.00x | 0.000 | 7003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react | 11418.311 | 1.44x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | blend | 12304.923 | 1.55x | 6864.000 | 1.25x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | roact | 9653.032 | 1.21x | 6452.000 | 1.18x | 0.000 | 2001 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | seam | 8234.980 | 1.04x | 5554.000 | 1.01x | 8.000 | 1000 | 1001 | 1 | 0 |
| cold-mount-1000 | 1 | signals | 7651.813 | 0.96x | 5509.000 | 1.01x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-reflex | 12029.587 | 1.51x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion-charm | 9641.488 | 1.21x | 5528.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-upstream | 11790.594 | 1.48x | 5986.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-10000 | 1 | plain | 77288.202 | 0.82x | 54980.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | compose | 94739.619 | 1.00x | 55075.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | compose-direct | 88753.152 | 0.94x | 55082.000 | 1.00x | 8.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion | 101142.153 | 1.07x | 55842.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | vide | 95128.896 | 1.00x | 54825.000 | 1.00x | 1.000 | 70003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react | 127374.698 | 1.34x | 59852.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | blend | 139117.665 | 1.47x | 68849.000 | 1.25x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | roact | 102117.907 | 1.08x | 64839.000 | 1.18x | 0.000 | 20001 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | seam | 90821.980 | 0.96x | 56116.000 | 1.02x | 1.000 | 10000 | 10001 | 1 | 0 |
| cold-mount-10000 | 1 | signals | 85577.984 | 0.90x | 55285.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-reflex | 129547.991 | 1.37x | 59836.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion-charm | 103161.287 | 1.09x | 55842.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-upstream | 128210.687 | 1.35x | 59844.000 | 1.09x | 1.000 | 20000 | 10001 | 0 | 0 |
| mount-dispose | 5 | plain | 8667.619 | 0.93x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | compose | 9329.006 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | compose-direct | 10003.366 | 1.07x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion | 11781.708 | 1.26x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | vide | 8167.283 | 0.88x | 1.000 | 1.00x | 0.000 | 7015 | 1005 | 0 | 0 |
| mount-dispose | 5 | react | 13620.305 | 1.46x | 4.000 | 4.00x | 0.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | blend | 18499.378 | 1.98x | 0.000 | 0.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | roact | 11022.833 | 1.18x | 0.000 | 0.00x | 0.000 | 2005 | 1005 | 0 | 0 |
| mount-dispose | 5 | seam | 9395.006 | 1.01x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 5 | 0 |
| mount-dispose | 5 | signals | 8085.826 | 0.87x | 1.000 | 1.00x | 1.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-reflex | 14303.805 | 1.53x | 5.000 | 5.00x | 4.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion-charm | 12988.807 | 1.39x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-upstream | 13444.474 | 1.44x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 0 | 0 |
| update-leaf | 50 | plain | 28.862 | 0.34x | 2745.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 84.600 | 1.00x | 2755.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose-direct | 58.233 | 0.69x | 2755.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 153.481 | 1.81x | 2772.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 81.568 | 0.96x | 2738.000 | 0.99x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 66.146 | 0.78x | 2986.000 | 1.08x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | blend | 79.929 | 0.94x | 3436.000 | 1.25x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 57.650 | 0.68x | 3238.000 | 1.18x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 137.816 | 1.63x | 2785.000 | 1.01x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 90.241 | 1.07x | 2762.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 131.869 | 1.56x | 2996.000 | 1.09x | 1.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | fusion-charm | 245.793 | 2.91x | 2774.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-upstream | 71.193 | 0.84x | 3002.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-fanout | 20 | plain | 869.521 | 0.58x | 1643.000 | 0.91x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | compose | 1494.592 | 1.00x | 1804.000 | 1.00x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | compose-direct | 1504.504 | 1.01x | 1804.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion | 8310.326 | 5.56x | 1894.000 | 1.05x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | vide | 4164.823 | 2.79x | 1815.000 | 1.01x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react | 1471.304 | 0.98x | 1925.000 | 1.07x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | blend | 3241.734 | 2.17x | 2233.000 | 1.24x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | roact | 1786.275 | 1.20x | 2071.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | seam | 3282.042 | 2.20x | 2144.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | signals | 4172.247 | 2.79x | 1920.000 | 1.06x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-reflex | 1509.710 | 1.01x | 1926.000 | 1.07x | 1.000 | 6000 | 0 | 20 | 0 |
| update-fanout | 20 | fusion-charm | 8759.272 | 5.86x | 1895.000 | 1.05x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-upstream | 1529.756 | 1.02x | 1925.000 | 1.07x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | plain | 866.490 | 0.32x | 1651.000 | 0.84x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 2735.396 | 1.00x | 1962.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose-direct | 2436.752 | 0.89x | 1860.000 | 0.95x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 13495.502 | 4.93x | 2129.000 | 1.09x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 5287.701 | 1.93x | 1960.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 2509.094 | 0.92x | 2096.000 | 1.07x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 5277.952 | 1.93x | 2518.000 | 1.28x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 3662.825 | 1.34x | 2522.000 | 1.29x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 7996.435 | 2.92x | 2935.000 | 1.50x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 6973.265 | 2.55x | 2270.000 | 1.16x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 38836.267 | 14.20x | 2384.000 | 1.22x | 1.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | fusion-charm | 23651.035 | 8.65x | 2710.000 | 1.38x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-upstream | 2449.397 | 0.90x | 2096.000 | 1.07x | 0.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 41.550 | 0.08x | 15.000 | 0.88x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | compose | 543.556 | 1.00x | 17.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | compose-direct | 270.093 | 0.50x | 18.000 | 1.06x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 21730.012 | 39.98x | 18.000 | 1.06x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 621.282 | 1.14x | 15.000 | 0.88x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 7479.674 | 13.76x | 5.000 | 0.29x | 5.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 4075.428 | 7.50x | 21.000 | 1.24x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | roact | 2695.603 | 4.96x | 18.000 | 1.06x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 2221.875 | 4.09x | 33.000 | 1.94x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 1264.267 | 2.33x | 17.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react-reflex | 1085.861 | 2.00x | 16.000 | 0.94x | 1.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | fusion-charm | 1385.395 | 2.55x | 20.000 | 1.18x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react-upstream | 8024.844 | 14.76x | 4.000 | 0.24x | 4.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 4172.075 | 0.75x | 27.000 | 0.84x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 5528.831 | 1.00x | 32.000 | 1.00x | 1.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | compose-direct | 5373.757 | 0.97x | 32.000 | 1.00x | 1.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 5789.572 | 1.05x | 31.000 | 0.97x | 1.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | vide | 5131.488 | 0.93x | 32.000 | 1.00x | 1.000 | 3530 | 510 | 0 | 0 |
| branch-swap | 20 | react | 8166.156 | 1.48x | 372.000 | 11.62x | 17.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 9215.971 | 1.67x | 46.000 | 1.44x | 1.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | roact | 6352.228 | 1.15x | 35.000 | 1.09x | 1.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 4720.640 | 0.85x | 38.000 | 1.19x | 0.000 | 500 | 510 | 10 | 0 |
| branch-swap | 20 | signals | unsupported: Signals has no native conditional Instance ownership primitive; adding a scene reconciler would change this state-only lane. | — | — | — | — | — | — | — | — |
| branch-swap | 20 | react-reflex | 8396.230 | 1.52x | 367.000 | 11.47x | 3.000 | 1010 | 510 | 20 | 0 |
| branch-swap | 20 | fusion-charm | 6231.732 | 1.13x | 26.000 | 0.81x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react-upstream | 8483.030 | 1.53x | 359.000 | 11.22x | 3.000 | 1010 | 510 | 0 | 0 |
| keyed-append | 10 | plain | 1206.159 | 0.78x | 1700.000 | 0.79x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | compose | 1552.275 | 1.00x | 2145.000 | 1.00x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | compose-direct | 1579.434 | 1.02x | 2189.000 | 1.02x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | vide | 1491.699 | 0.96x | 2274.000 | 1.06x | 0.000 | 400 | 50 | 0 | 0 |
| keyed-append | 10 | react | 12260.429 | 7.90x | 2510.000 | 1.17x | 6.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | blend | 4693.295 | 3.02x | 3049.000 | 1.42x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-append | 10 | roact | 6303.297 | 4.06x | 1988.000 | 0.93x | 0.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | seam | 13116.202 | 8.45x | 3492.000 | 1.63x | 0.000 | 100 | 50 | 100 | 50 |
| keyed-append | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | react-reflex | 12748.357 | 8.21x | 2510.000 | 1.17x | 7.000 | 150 | 50 | 10 | 0 |
| keyed-append | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | react-upstream | 12589.947 | 8.11x | 2510.000 | 1.17x | 5.000 | 150 | 50 | 0 | 0 |
| keyed-prepend | 10 | plain | 1570.319 | 0.47x | 1699.000 | 0.79x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 3358.941 | 1.00x | 2145.000 | 1.00x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose-direct | 4661.163 | 1.39x | 2189.000 | 1.02x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | vide | 4602.596 | 1.37x | 2282.000 | 1.06x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-prepend | 10 | react | 16844.878 | 5.01x | 2458.000 | 1.15x | 0.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 4961.975 | 1.48x | 3049.000 | 1.42x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | roact | 8598.093 | 2.56x | 1995.000 | 0.93x | 0.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 14620.986 | 4.35x | 3492.000 | 1.63x | 8.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react-reflex | 16482.671 | 4.91x | 2458.000 | 1.15x | 6.000 | 3150 | 50 | 10 | 0 |
| keyed-prepend | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react-upstream | 17144.787 | 5.10x | 2458.000 | 1.15x | 6.000 | 3150 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1336.975 | 0.60x | 1700.000 | 0.80x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 2210.917 | 1.00x | 2138.000 | 1.00x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | compose-direct | 2777.169 | 1.26x | 2190.000 | 1.02x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | vide | 2699.772 | 1.22x | 2281.000 | 1.07x | 0.000 | 1900 | 50 | 0 | 0 |
| keyed-insert | 10 | react | 14599.969 | 6.60x | 2483.000 | 1.16x | 6.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 4927.698 | 2.23x | 3041.000 | 1.42x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | roact | 7540.602 | 3.41x | 1988.000 | 0.93x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 13894.204 | 6.28x | 3500.000 | 1.64x | 0.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react-reflex | 15338.894 | 6.94x | 2491.000 | 1.17x | 6.000 | 1650 | 50 | 10 | 0 |
| keyed-insert | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react-upstream | 15109.209 | 6.83x | 2484.000 | 1.16x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-remove | 10 | plain | 1297.220 | 0.57x | 1696.000 | 0.79x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | compose | 2267.428 | 1.00x | 2145.000 | 1.00x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | compose-direct | 2842.549 | 1.25x | 2185.000 | 1.02x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | vide | 2681.498 | 1.18x | 2281.000 | 1.06x | 0.000 | 1810 | 50 | 0 | 0 |
| keyed-remove | 10 | react | 14559.723 | 6.42x | 2409.000 | 1.12x | 6.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | blend | 4849.915 | 2.14x | 3048.000 | 1.42x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-remove | 10 | roact | 7301.210 | 3.22x | 1987.000 | 0.93x | 0.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | seam | 13594.081 | 6.00x | 3499.000 | 1.63x | 0.000 | 1510 | 50 | 100 | 50 |
| keyed-remove | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | react-reflex | 14607.243 | 6.44x | 2409.000 | 1.12x | 6.000 | 1560 | 50 | 10 | 0 |
| keyed-remove | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | react-upstream | 14653.938 | 6.46x | 2409.000 | 1.12x | 13.000 | 1560 | 50 | 0 | 0 |
| keyed-replace | 10 | plain | 30089.389 | 0.53x | 1719.000 | 0.79x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | compose | 56711.982 | 1.00x | 2168.000 | 1.00x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | compose-direct | 59601.495 | 1.05x | 2209.000 | 1.02x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion | 94172.595 | 1.66x | 3010.000 | 1.39x | 0.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | vide | 50965.105 | 0.90x | 2320.000 | 1.07x | 0.000 | 24000 | 3000 | 0 | 0 |
| keyed-replace | 10 | react | 77591.934 | 1.37x | 3938.000 | 1.82x | 14.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | blend | 93036.335 | 1.64x | 5683.000 | 2.62x | 8.000 | 30000 | 3000 | 0 | 0 |
| keyed-replace | 10 | roact | 37463.946 | 0.66x | 2019.000 | 0.93x | 1.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | seam | 101299.552 | 1.79x | 3531.000 | 1.63x | 0.000 | 6000 | 3000 | 6000 | 3000 |
| keyed-replace | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-replace | 10 | react-reflex | 83229.938 | 1.47x | 3931.000 | 1.81x | 7.000 | 9000 | 3000 | 10 | 0 |
| keyed-replace | 10 | fusion-charm | 106283.044 | 1.87x | 3004.000 | 1.39x | 0.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | react-upstream | 85387.154 | 1.51x | 3932.000 | 1.81x | 8.000 | 9000 | 3000 | 0 | 0 |
| keyed-reverse | 10 | plain | 1148.983 | 0.59x | 1696.000 | 0.79x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | compose | 1949.919 | 1.00x | 2145.000 | 1.00x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | compose-direct | 3076.371 | 1.58x | 2177.000 | 1.01x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion | 19178.459 | 9.84x | 2979.000 | 1.39x | 8.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | vide | 2785.978 | 1.43x | 2257.000 | 1.05x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react | 40049.663 | 20.54x | 2402.000 | 1.12x | 12.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | blend | 2099.756 | 1.08x | 3007.000 | 1.40x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | roact | 6972.197 | 3.58x | 1987.000 | 0.93x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | seam | 11698.139 | 6.00x | 3499.000 | 1.63x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-reverse | 10 | react-reflex | 40623.163 | 20.83x | 2386.000 | 1.11x | 3.000 | 3000 | 0 | 10 | 0 |
| keyed-reverse | 10 | fusion-charm | 19529.275 | 10.02x | 2981.000 | 1.39x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react-upstream | 41047.477 | 21.05x | 2387.000 | 1.11x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | plain | 1065.670 | 0.51x | 1696.000 | 0.79x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | compose | 2091.373 | 1.00x | 2152.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | compose-direct | 3128.646 | 1.50x | 2186.000 | 1.02x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion | 18722.644 | 8.95x | 2979.000 | 1.38x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | vide | 2804.858 | 1.34x | 2265.000 | 1.05x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react | 28216.229 | 13.49x | 2394.000 | 1.11x | 3.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | blend | 2036.733 | 0.97x | 3007.000 | 1.40x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | roact | 6990.550 | 3.34x | 1987.000 | 0.92x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | seam | 11549.245 | 5.52x | 3491.000 | 1.62x | 8.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-rotate | 10 | react-reflex | 28447.208 | 13.60x | 2394.000 | 1.11x | 3.000 | 3000 | 0 | 10 | 0 |
| keyed-rotate | 10 | fusion-charm | 19418.574 | 9.29x | 2989.000 | 1.39x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react-upstream | 28632.189 | 13.69x | 2394.000 | 1.11x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | plain | 1175.146 | 0.57x | 1696.000 | 0.79x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 2075.290 | 1.00x | 2145.000 | 1.00x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose-direct | 3257.360 | 1.57x | 2185.000 | 1.02x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 19855.638 | 9.57x | 2979.000 | 1.39x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | vide | 2848.817 | 1.37x | 2265.000 | 1.06x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 26868.554 | 12.95x | 2394.000 | 1.12x | 3.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 2191.113 | 1.06x | 2999.000 | 1.40x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | roact | 6776.754 | 3.27x | 1995.000 | 0.93x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 10676.570 | 5.14x | 3491.000 | 1.63x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-shuffle | 10 | react-reflex | 26957.060 | 12.99x | 2395.000 | 1.12x | 4.000 | 2990 | 0 | 10 | 0 |
| keyed-shuffle | 10 | fusion-charm | 19913.631 | 9.60x | 2989.000 | 1.39x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react-upstream | 26882.474 | 12.95x | 2394.000 | 1.12x | 4.000 | 2990 | 0 | 0 | 0 |
| events | 5 | plain | 11172.052 | 0.77x | 0.000 | n/a (zero baseline) | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | compose | 14498.766 | 1.00x | 0.000 | n/a (zero baseline) | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | compose-direct | 14538.503 | 1.00x | 0.000 | n/a (zero baseline) | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | fusion | 15122.543 | 1.04x | 1.000 | n/a (zero baseline) | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | vide | 14714.675 | 1.01x | 0.000 | n/a (zero baseline) | 0.000 | 8015 | 1005 | 1000 | 0 |
| events | 5 | react | 19986.609 | 1.38x | 12.000 | n/a (zero baseline) | 4.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | blend | 25441.559 | 1.75x | 1.000 | n/a (zero baseline) | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | roact | 17391.188 | 1.20x | 1.000 | n/a (zero baseline) | 0.000 | 2005 | 1005 | 1000 | 0 |
| events | 5 | seam | 14816.064 | 1.02x | 9.000 | n/a (zero baseline) | 0.000 | 1000 | 1005 | 1005 | 0 |
| events | 5 | signals | 11137.531 | 0.77x | 1.000 | n/a (zero baseline) | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | react-reflex | 20787.976 | 1.43x | 13.000 | n/a (zero baseline) | 4.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | fusion-charm | 18410.035 | 1.27x | 1.000 | n/a (zero baseline) | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | react-upstream | 19945.094 | 1.38x | 4.000 | n/a (zero baseline) | 3.000 | 2000 | 1005 | 1000 | 0 |
| animate-many | 1 | plain | 1488.152 | 0.26x | 1516.000 | 0.67x | 0.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | compose | 5832.575 | 1.00x | 2275.000 | 1.00x | 0.000 | 6000 | 0 | 1 | 0 |
| animate-many | 1 | compose-direct | 5881.068 | 1.01x | 2275.000 | 1.00x | 1.000 | 6000 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 126882.513 | 21.75x | 2598.000 | 1.14x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | vide | 7504.316 | 1.29x | 1924.000 | 0.85x | 0.000 | 6000 | 0 | 0 | 30 |
| animate-many | 1 | react | unsupported: React and ReactRoblox have no native spring primitive. Adding another animation library would change the comparison. | — | — | — | — | — | — | — | — |
| animate-many | 1 | blend | 10087.874 | 1.73x | 2645.000 | 1.16x | 0.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | roact | unsupported: Roact has no native spring primitive. | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 24907.401 | 4.27x | 3556.000 | 1.56x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals has no native spring primitive. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox have no native spring primitive. Adding another animation library would change the comparison. | — | — | — | — | — | — | — | — |
| animate-many | 1 | fusion-charm | 126198.780 | 21.64x | 2600.000 | 1.14x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox have no native spring primitive. Adding another animation library would change the comparison. | — | — | — | — | — | — | — | — |
| status-panel | 20 | plain | 243.219 | 0.35x | 142.000 | 0.80x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | compose | 699.006 | 1.00x | 178.000 | 1.00x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | compose-direct | 583.017 | 0.83x | 175.000 | 0.98x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | fusion | 2698.205 | 3.86x | 240.000 | 1.35x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | vide | 648.676 | 0.93x | 184.000 | 1.03x | 0.000 | 208 | 21 | 0 | 0 |
| status-panel | 20 | react | 2826.192 | 4.04x | 207.000 | 1.16x | 8.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | blend | 953.536 | 1.36x | 246.000 | 1.38x | 0.000 | 438 | 21 | 0 | 0 |
| status-panel | 20 | roact | 850.170 | 1.22x | 172.000 | 0.97x | 0.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | seam | 1908.800 | 2.73x | 300.000 | 1.69x | 1.000 | 82 | 21 | 42 | 21 |
| status-panel | 20 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| status-panel | 20 | react-reflex | 2581.586 | 3.69x | 209.000 | 1.17x | 7.000 | 103 | 21 | 20 | 0 |
| status-panel | 20 | fusion-charm | 2657.597 | 3.80x | 245.000 | 1.38x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | react-upstream | 2776.553 | 3.97x | 207.000 | 1.16x | 8.000 | 103 | 21 | 0 | 0 |
| mount-cycles | 1 | plain | 22257.046 | 0.79x | 1.000 | n/a (zero baseline) | 1.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | compose | 28194.506 | 1.00x | 0.000 | n/a (zero baseline) | 1.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | compose-direct | 28618.681 | 1.02x | 1.000 | n/a (zero baseline) | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion | 27572.017 | 0.98x | 1.000 | n/a (zero baseline) | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | vide | 28109.664 | 1.00x | 1.000 | n/a (zero baseline) | 0.000 | 14490 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react | 42775.809 | 1.52x | 23.000 | n/a (zero baseline) | 14.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | blend | 49266.086 | 1.75x | 0.000 | n/a (zero baseline) | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | roact | 29925.903 | 1.06x | 1.000 | n/a (zero baseline) | 0.000 | 3630 | 1830 | 1800 | 0 |
| mount-cycles | 1 | seam | 26488.357 | 0.94x | 1.000 | n/a (zero baseline) | 0.000 | 1800 | 1830 | 1830 | 0 |
| mount-cycles | 1 | signals | 19617.136 | 0.70x | 0.000 | n/a (zero baseline) | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-reflex | 34746.473 | 1.23x | 13.000 | n/a (zero baseline) | 12.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion-charm | 29582.872 | 1.05x | 1.000 | n/a (zero baseline) | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-upstream | 36641.050 | 1.30x | 20.000 | n/a (zero baseline) | 20.000 | 3600 | 1830 | 1800 | 0 |
| scene-3d | 20 | plain | 5491.539 | 0.79x | 1036.000 | 0.86x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 6952.598 | 1.00x | 1209.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose-direct | 9545.948 | 1.37x | 1241.000 | 1.03x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 78219.703 | 11.25x | 1575.000 | 1.30x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 10524.222 | 1.51x | 1236.000 | 1.02x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 7876.910 | 1.13x | 1243.000 | 1.03x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | blend | 10732.245 | 1.54x | 1563.000 | 1.29x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | unsupported: Roact assigns Instance.Name from reconciliation keys. Named children use dictionary keys, whose mounting order cannot satisfy this workload's ordered named-tree contract. | — | — | — | — | — | — | — | — |
| scene-3d | 20 | seam | 21413.726 | 3.08x | 2238.000 | 1.85x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 14712.933 | 2.12x | 1759.000 | 1.45x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 6818.518 | 0.98x | 1253.000 | 1.04x | 9.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | fusion-charm | 81467.886 | 11.72x | 1579.000 | 1.31x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-upstream | 7044.475 | 1.01x | 1243.000 | 1.03x | 9.000 | 6000 | 0 | 0 | 0 |

### Summary

This summary uses the 22 selected workloads. The geometric mean divides each measured median time by the Compose median time of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count.

| Framework | Supported | Measured | Geometric mean time / Compose |
| --- | ---: | ---: | ---: |
| plain | 22 | 22 | 0.53x |
| compose | 22 | 22 | 1.00x |
| compose-direct | 22 | 22 | 1.05x |
| fusion | 18 | 18 | 3.44x |
| vide | 22 | 22 | 1.18x |
| react | 21 | 21 | 2.90x |
| blend | 22 | 22 | 1.71x |
| roact | 20 | 20 | 1.73x |
| seam | 22 | 22 | 2.51x |
| signals | 11 | 11 | 1.30x |
| react-reflex | 21 | 21 | 3.09x |
| fusion-charm | 18 | 18 | 3.28x |
| react-upstream | 21 | 21 | 2.91x |

### Source identities

Harness revision: `e1ecb1e3d4758d216e08b1f3837f54ceebfb21ea`. Full source state, tools, environment and command are in `context.json`.

| Dependency | Version | Commit | Tree | Rights |
| --- | --- | --- | --- | --- |
| compose | unreleased | `0826d6581fc65cab6cbda5bc7c4d301cd297818f` | `d2a7a904adfa32d60a4bef1d2a003144c7dd21c3` | MIT |
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

### Loader fallbacks

The loader binds the cost-model globals of each library file on its first line. These files cannot take that binding. They load with their own copy of the cost-model global table as their environment, so their global reads do not use the Luau fast paths.

- `.lute/dependencies/react-upstream/modules/react-reconciler/src/ReactFiberBeginWork.new.lua`
- `.lute/dependencies/react/modules/react-reconciler/src/ReactFiberBeginWork.new.luau`
- `.lute/dependencies/seam/src/Modules/Types.luau`
