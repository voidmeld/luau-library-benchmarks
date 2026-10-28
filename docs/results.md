# Results

Harness commit: `4c034ad3b80235101eaf52c1592ed23e77d0fdd4`. Workflow run: [Library comparison 40629451261](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40629451261). Runner: `ubuntu-latest`. Mode: `as-shipped`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **as-shipped**. Comparison verdict: **release**. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

## Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Ratios divide by the Compose lane, the reference lane; lower is smaller. A workload marked (contract) measures a Compose contract; the summary leaves it out. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance.

| Workload | Iterations | Framework | Median time (us) | / Compose | Median heap (KiB) | / Compose | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| cold-mount-100 | 1 | bare | 827.619 | 0.75x | 556.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | compose | 1103.677 | 1.00x | 558.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | compose-direct | 1072.745 | 0.97x | 558.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion | 1089.228 | 0.99x | 564.000 | 1.01x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | vide | 1076.979 | 0.98x | 554.000 | 0.99x | 0.000 | 703 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react | 1532.613 | 1.39x | 606.000 | 1.09x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| cold-mount-100 | 1 | blend | 1641.187 | 1.49x | 696.000 | 1.25x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | roact | 1459.050 | 1.32x | 654.000 | 1.17x | 0.000 | 201 | 101 | 0 | 0 |
| cold-mount-100 | 1 | seam | 1106.969 | 1.00x | 569.000 | 1.02x | 0.000 | 100 | 101 | 1 | 0 |
| cold-mount-100 | 1 | signals | 1137.934 | 1.03x | 558.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-reflex | 1568.975 | 1.42x | 598.000 | 1.07x | 0.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion-charm | 1301.067 | 1.18x | 564.000 | 1.01x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-upstream | 1914.738 | 1.73x | 606.000 | 1.09x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-1000 | 1 | bare | 8474.757 | 0.90x | 5485.000 | 1.00x | 1.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | compose | 9436.708 | 1.00x | 5487.000 | 1.00x | 8.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | compose-direct | 8955.060 | 0.95x | 5488.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion | 10068.854 | 1.07x | 5535.000 | 1.01x | 8.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | vide | 9448.517 | 1.00x | 5470.000 | 1.00x | 1.000 | 7003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react | 12539.961 | 1.33x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| cold-mount-1000 | 1 | blend | 13674.101 | 1.45x | 6864.000 | 1.25x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | roact | 10434.034 | 1.11x | 6452.000 | 1.18x | 8.000 | 2001 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | seam | 9572.608 | 1.01x | 5554.000 | 1.01x | 0.000 | 1000 | 1001 | 1 | 0 |
| cold-mount-1000 | 1 | signals | 8060.471 | 0.85x | 5509.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-reflex | 13423.133 | 1.42x | 5986.000 | 1.09x | 8.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion-charm | 10264.312 | 1.09x | 5536.000 | 1.01x | 8.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-upstream | 13762.054 | 1.46x | 5985.000 | 1.09x | 0.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-10000 | 1 | bare | 83151.579 | 0.77x | 54980.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | compose | 108161.877 | 1.00x | 55082.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | compose-direct | 97102.042 | 0.90x | 55090.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion | 112962.414 | 1.04x | 55850.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | vide | 100801.312 | 0.93x | 54817.000 | 1.00x | 0.000 | 70003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react | 146460.604 | 1.35x | 59844.000 | 1.09x | 8.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| cold-mount-10000 | 1 | blend | 131077.800 | 1.21x | 68841.000 | 1.25x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | roact | 108956.930 | 1.01x | 64846.000 | 1.18x | 0.000 | 20001 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | seam | 98346.316 | 0.91x | 56109.000 | 1.02x | 0.000 | 10000 | 10001 | 1 | 0 |
| cold-mount-10000 | 1 | signals | 88874.684 | 0.82x | 55293.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-reflex | 145591.017 | 1.35x | 59852.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion-charm | 117819.423 | 1.09x | 55850.000 | 1.01x | 8.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-upstream | 156934.638 | 1.45x | 59852.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| mount-dispose | 5 | bare | 9735.787 | 0.84x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | compose | 11548.310 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | compose-direct | 11044.860 | 0.96x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion | 12100.143 | 1.05x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | vide | 8677.482 | 0.75x | 1.000 | 1.00x | 0.000 | 7015 | 1005 | 0 | 0 |
| mount-dispose | 5 | react | 15102.093 | 1.31x | 5.000 | 5.00x | 4.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| mount-dispose | 5 | blend | 22358.180 | 1.94x | 1.000 | 1.00x | 8.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | roact | 14636.551 | 1.27x | 1.000 | 1.00x | 0.000 | 2005 | 1005 | 0 | 0 |
| mount-dispose | 5 | seam | 10565.344 | 0.91x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 5 | 0 |
| mount-dispose | 5 | signals | 9540.832 | 0.83x | 2.000 | 2.00x | 1.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-reflex | 17269.790 | 1.50x | 5.000 | 5.00x | 12.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion-charm | 14619.974 | 1.27x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-upstream | 16388.055 | 1.42x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 0 | 0 |
| update-leaf | 50 | bare | 33.607 | 0.36x | 2745.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 93.545 | 1.00x | 2756.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose-direct | 62.211 | 0.67x | 2755.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 166.906 | 1.78x | 2772.000 | 1.01x | 8.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 90.701 | 0.97x | 2738.000 | 0.99x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 73.722 | 0.79x | 2994.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| update-leaf | 50 | blend | 89.383 | 0.96x | 3437.000 | 1.25x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 64.171 | 0.69x | 3231.000 | 1.17x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 156.538 | 1.67x | 2785.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 108.204 | 1.16x | 2762.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 162.492 | 1.74x | 3003.000 | 1.09x | 1.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | fusion-charm | 273.849 | 2.93x | 2774.000 | 1.01x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-upstream | 80.839 | 0.86x | 2994.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-fanout | 20 | bare | 890.924 | 0.60x | 1651.000 | 0.92x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | compose | 1491.026 | 1.00x | 1804.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | compose-direct | 1441.480 | 0.97x | 1804.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion | 8418.493 | 5.65x | 1894.000 | 1.05x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | vide | 4243.304 | 2.85x | 1815.000 | 1.01x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react | 1530.650 | 1.03x | 1917.000 | 1.06x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| update-fanout | 20 | blend | 3093.777 | 2.07x | 2241.000 | 1.24x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | roact | 1923.720 | 1.29x | 2070.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | seam | 3476.907 | 2.33x | 2152.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | signals | 4292.711 | 2.88x | 1920.000 | 1.06x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-reflex | 1587.562 | 1.06x | 1918.000 | 1.06x | 1.000 | 6000 | 0 | 20 | 0 |
| update-fanout | 20 | fusion-charm | 8364.584 | 5.61x | 1896.000 | 1.05x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-upstream | 1570.588 | 1.05x | 1925.000 | 1.07x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | bare | 914.226 | 0.36x | 1651.000 | 0.84x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 2519.720 | 1.00x | 1961.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose-direct | 2208.865 | 0.88x | 1860.000 | 0.95x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 13069.616 | 5.19x | 2129.000 | 1.09x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 4806.677 | 1.91x | 1960.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 2474.894 | 0.98x | 2104.000 | 1.07x | 9.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| update-batched | 20 | blend | 4920.155 | 1.95x | 2518.000 | 1.28x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 3189.088 | 1.27x | 2522.000 | 1.29x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 7442.259 | 2.95x | 2935.000 | 1.50x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 5879.537 | 2.33x | 2270.000 | 1.16x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 51820.538 | 20.57x | 2384.000 | 1.22x | 9.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | fusion-charm | 25330.312 | 10.05x | 2703.000 | 1.38x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-upstream | 2531.064 | 1.00x | 2097.000 | 1.07x | 1.000 | 6000 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | bare | 45.104 | 0.09x | 14.000 | 0.82x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | compose | 480.947 | 1.00x | 17.000 | 1.00x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | compose-direct | 250.975 | 0.52x | 18.000 | 1.06x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | fusion | 23531.633 | 48.93x | 18.000 | 1.06x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | vide | 659.901 | 1.37x | 16.000 | 0.94x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | react | 2394.837 | 4.98x | 15.000 | 0.88x | 1.000 | 5000 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | react-usestate | 8072.566 | 16.78x | 4.000 | 0.24x | 4.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | blend | 3631.750 | 7.55x | 21.000 | 1.24x | 1.000 | 10 | 0 | 0 | 10 |
| update-repeated (contract) | 10 | roact | 2810.371 | 5.84x | 18.000 | 1.06x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | seam | 2042.084 | 4.25x | 33.000 | 1.94x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | signals | 1230.666 | 2.56x | 17.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | react-reflex | 1343.653 | 2.79x | 24.000 | 1.41x | 9.000 | 10 | 0 | 10 | 0 |
| update-repeated (contract) | 10 | fusion-charm | 1315.215 | 2.73x | 20.000 | 1.18x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated (contract) | 10 | react-upstream | 2521.881 | 5.24x | 16.000 | 0.94x | 1.000 | 5000 | 0 | 0 | 0 |
| branch-swap | 20 | bare | 4071.588 | 0.72x | 28.000 | 0.88x | 1.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 5647.112 | 1.00x | 32.000 | 1.00x | 8.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | compose-direct | 5378.568 | 0.95x | 24.000 | 0.75x | 1.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 5896.750 | 1.04x | 16.000 | 0.50x | 1.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | vide | 4968.168 | 0.88x | 16.000 | 0.50x | 0.000 | 3530 | 510 | 0 | 0 |
| branch-swap | 20 | react | 8496.159 | 1.50x | 367.000 | 11.47x | 18.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| branch-swap | 20 | blend | 9213.110 | 1.63x | 46.000 | 1.44x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | roact | 5332.523 | 0.94x | 27.000 | 0.84x | 1.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 4911.489 | 0.87x | 30.000 | 0.94x | 1.000 | 500 | 510 | 10 | 0 |
| branch-swap | 20 | signals | unsupported: Signals has no native conditional Instance ownership primitive; adding a scene reconciler would change this state-only lane. | — | — | — | — | — | — | — | — |
| branch-swap | 20 | react-reflex | 8509.164 | 1.51x | 373.000 | 11.66x | 19.000 | 1010 | 510 | 20 | 0 |
| branch-swap | 20 | fusion-charm | 5929.615 | 1.05x | 26.000 | 0.81x | 1.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react-upstream | 8889.767 | 1.57x | 375.000 | 11.72x | 20.000 | 1010 | 510 | 0 | 0 |
| ordered-window-scroll (contract) | 50 | bare | unsupported: the workload measures a Compose primitive's idle scroll cost; there is no hand-written equivalent to compare | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | compose | 479.820 | 1.00x | 1120.000 | 1.00x | 0.000 | 0 | 0 | 0 | 0 |
| ordered-window-scroll (contract) | 50 | compose-direct | 495.410 | 1.03x | 1120.000 | 1.00x | 0.000 | 0 | 0 | 0 | 0 |
| ordered-window-scroll (contract) | 50 | fusion | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | vide | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | react | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | blend | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | roact | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | seam | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | signals | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | react-reflex | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | fusion-charm | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| ordered-window-scroll (contract) | 50 | react-upstream | unsupported: No native ordered window collection with the workload's retained range and geometry contract. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | bare | 1302.094 | 0.75x | 1700.000 | 0.79x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | compose | 1728.677 | 1.00x | 2146.000 | 1.00x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | compose-direct | 1696.524 | 0.98x | 2189.000 | 1.02x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | vide | 1629.575 | 0.94x | 2266.000 | 1.06x | 0.000 | 400 | 50 | 0 | 0 |
| keyed-append | 10 | react | 13380.078 | 7.74x | 2510.000 | 1.17x | 14.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | blend | 4738.602 | 2.74x | 3058.000 | 1.42x | 1.000 | 3500 | 50 | 0 | 0 |
| keyed-append | 10 | roact | 6309.342 | 3.65x | 1988.000 | 0.93x | 0.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | seam | 14390.942 | 8.32x | 3500.000 | 1.63x | 0.000 | 100 | 50 | 100 | 50 |
| keyed-append | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | react-reflex | 13416.653 | 7.76x | 2517.000 | 1.17x | 7.000 | 150 | 50 | 10 | 0 |
| keyed-append | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | react-upstream | 13457.241 | 7.78x | 2510.000 | 1.17x | 6.000 | 150 | 50 | 0 | 0 |
| keyed-prepend | 10 | bare | 1625.867 | 0.56x | 1700.000 | 0.79x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 2910.168 | 1.00x | 2146.000 | 1.00x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose-direct | 3933.650 | 1.35x | 2189.000 | 1.02x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | vide | 4418.344 | 1.52x | 2274.000 | 1.06x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-prepend | 10 | react | 17901.148 | 6.15x | 2458.000 | 1.15x | 7.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | blend | 4757.768 | 1.63x | 3042.000 | 1.42x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | roact | 8663.864 | 2.98x | 1996.000 | 0.93x | 0.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 16296.945 | 5.60x | 3500.000 | 1.63x | 0.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react-reflex | 17945.790 | 6.17x | 2459.000 | 1.15x | 6.000 | 3150 | 50 | 10 | 0 |
| keyed-prepend | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react-upstream | 17209.638 | 5.91x | 2458.000 | 1.15x | 14.000 | 3150 | 50 | 0 | 0 |
| keyed-insert | 10 | bare | 1501.758 | 0.64x | 1700.000 | 0.79x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 2350.692 | 1.00x | 2146.000 | 1.00x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | compose-direct | 2896.662 | 1.23x | 2189.000 | 1.02x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | vide | 2970.317 | 1.26x | 2266.000 | 1.06x | 0.000 | 1900 | 50 | 0 | 0 |
| keyed-insert | 10 | react | 16376.211 | 6.97x | 2484.000 | 1.16x | 7.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | blend | 5092.976 | 2.17x | 3058.000 | 1.42x | 1.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | roact | 7964.964 | 3.39x | 1988.000 | 0.93x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 15810.288 | 6.73x | 3500.000 | 1.63x | 1.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react-reflex | 16847.062 | 7.17x | 2484.000 | 1.16x | 6.000 | 1650 | 50 | 10 | 0 |
| keyed-insert | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react-upstream | 16542.934 | 7.04x | 2483.000 | 1.16x | 6.000 | 1650 | 50 | 0 | 0 |
| keyed-remove | 10 | bare | 1440.970 | 0.66x | 1696.000 | 0.79x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | compose | 2182.419 | 1.00x | 2145.000 | 1.00x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | compose-direct | 2682.654 | 1.23x | 2193.000 | 1.02x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | fusion | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | vide | 2870.228 | 1.32x | 2273.000 | 1.06x | 0.000 | 1810 | 50 | 0 | 0 |
| keyed-remove | 10 | react | 15778.937 | 7.23x | 2417.000 | 1.13x | 14.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | blend | 5001.940 | 2.29x | 3057.000 | 1.43x | 1.000 | 3400 | 50 | 0 | 0 |
| keyed-remove | 10 | roact | 7399.918 | 3.39x | 1995.000 | 0.93x | 0.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | seam | 15223.763 | 6.98x | 3492.000 | 1.63x | 1.000 | 1510 | 50 | 100 | 50 |
| keyed-remove | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | react-reflex | 15889.204 | 7.28x | 2410.000 | 1.12x | 7.000 | 1560 | 50 | 10 | 0 |
| keyed-remove | 10 | fusion-charm | unsupported: The pinned native ForPairs mapper can reassign a removed key's scope to a retained key. The shrink step fails retained-node identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | react-upstream | 16007.734 | 7.33x | 2409.000 | 1.12x | 6.000 | 1560 | 50 | 0 | 0 |
| keyed-replace | 10 | bare | 32035.737 | 0.48x | 1727.000 | 0.80x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | compose | 66725.739 | 1.00x | 2168.000 | 1.00x | 1.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | compose-direct | 69165.877 | 1.04x | 2209.000 | 1.02x | 1.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion | 115875.126 | 1.74x | 3003.000 | 1.39x | 0.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | vide | 67531.775 | 1.01x | 2320.000 | 1.07x | 0.000 | 24000 | 3000 | 0 | 0 |
| keyed-replace | 10 | react | 98202.827 | 1.47x | 3938.000 | 1.82x | 15.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-replace | 10 | blend | 120753.374 | 1.81x | 5683.000 | 2.62x | 1.000 | 30000 | 3000 | 0 | 0 |
| keyed-replace | 10 | roact | 43531.318 | 0.65x | 2011.000 | 0.93x | 8.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | seam | 112192.571 | 1.68x | 3539.000 | 1.63x | 0.000 | 6000 | 3000 | 6000 | 3000 |
| keyed-replace | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-replace | 10 | react-reflex | 99388.408 | 1.49x | 3932.000 | 1.81x | 8.000 | 9000 | 3000 | 10 | 0 |
| keyed-replace | 10 | fusion-charm | 119878.462 | 1.80x | 3004.000 | 1.39x | 0.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | react-upstream | 97668.846 | 1.46x | 3931.000 | 1.81x | 7.000 | 9000 | 3000 | 0 | 0 |
| keyed-reverse | 10 | bare | 1172.068 | 0.70x | 1696.000 | 0.79x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | compose | 1670.266 | 1.00x | 2144.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | compose-direct | 2435.568 | 1.46x | 2185.000 | 1.02x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion | 19094.933 | 11.43x | 2979.000 | 1.39x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | vide | 2735.814 | 1.64x | 2257.000 | 1.05x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react | 42517.965 | 25.46x | 2394.000 | 1.12x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-reverse | 10 | blend | 2007.760 | 1.20x | 3008.000 | 1.40x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | roact | 6012.253 | 3.60x | 1987.000 | 0.93x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | seam | 11876.484 | 7.11x | 3492.000 | 1.63x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-reverse | 10 | react-reflex | 43338.906 | 25.95x | 2402.000 | 1.12x | 12.000 | 3000 | 0 | 10 | 0 |
| keyed-reverse | 10 | fusion-charm | 20240.555 | 12.12x | 2981.000 | 1.39x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react-upstream | 43151.023 | 25.83x | 2394.000 | 1.12x | 5.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | bare | 1108.393 | 0.64x | 1696.000 | 0.79x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | compose | 1742.689 | 1.00x | 2144.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | compose-direct | 2707.982 | 1.55x | 2185.000 | 1.02x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion | 20992.032 | 12.05x | 2979.000 | 1.39x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | vide | 2582.025 | 1.48x | 2249.000 | 1.05x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react | 30242.233 | 17.35x | 2394.000 | 1.12x | 12.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-rotate | 10 | blend | 1847.300 | 1.06x | 3008.000 | 1.40x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | roact | 6247.945 | 3.59x | 1987.000 | 0.93x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | seam | 12800.160 | 7.35x | 3492.000 | 1.63x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-rotate | 10 | react-reflex | 30653.715 | 17.59x | 2395.000 | 1.12x | 4.000 | 3000 | 0 | 10 | 0 |
| keyed-rotate | 10 | fusion-charm | 20822.398 | 11.95x | 2973.000 | 1.39x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react-upstream | 30147.364 | 17.30x | 2394.000 | 1.12x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | bare | 1232.726 | 0.65x | 1696.000 | 0.79x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 1882.766 | 1.00x | 2145.000 | 1.00x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose-direct | 2834.481 | 1.51x | 2185.000 | 1.02x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 20289.422 | 10.78x | 2987.000 | 1.39x | 8.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | vide | 3046.516 | 1.62x | 2257.000 | 1.05x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 28678.661 | 15.23x | 2386.000 | 1.11x | 4.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| keyed-shuffle | 10 | blend | 2092.050 | 1.11x | 3008.000 | 1.40x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | roact | 6590.442 | 3.50x | 1987.000 | 0.93x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 12710.384 | 6.75x | 3491.000 | 1.63x | 1.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| keyed-shuffle | 10 | react-reflex | 29219.903 | 15.52x | 2394.000 | 1.12x | 4.000 | 2990 | 0 | 10 | 0 |
| keyed-shuffle | 10 | fusion-charm | 21228.492 | 11.28x | 2981.000 | 1.39x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react-upstream | 29092.170 | 15.45x | 2401.000 | 1.12x | 11.000 | 2990 | 0 | 0 | 0 |
| events | 5 | bare | 13751.228 | 0.76x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | compose | 18194.157 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | compose-direct | 18127.460 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | fusion | 17876.951 | 0.98x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | vide | 12473.858 | 0.69x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 1000 | 0 |
| events | 5 | react | 21058.887 | 1.16x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| events | 5 | blend | 29581.683 | 1.63x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | roact | 15920.827 | 0.88x | 1.000 | 1.00x | 0.000 | 2005 | 1005 | 1000 | 0 |
| events | 5 | seam | 18713.725 | 1.03x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1005 | 0 |
| events | 5 | signals | 13687.559 | 0.75x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | react-reflex | 23657.861 | 1.30x | 4.000 | 4.00x | 0.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | fusion-charm | 22170.591 | 1.22x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | react-upstream | 23182.515 | 1.27x | 12.000 | 12.00x | 11.000 | 2000 | 1005 | 1000 | 0 |
| animate-many | 1 | bare | 1554.349 | 0.28x | 1516.000 | 0.66x | 0.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | compose | 5516.030 | 1.00x | 2282.000 | 1.00x | 0.000 | 6000 | 0 | 1 | 0 |
| animate-many | 1 | compose-direct | 5629.067 | 1.02x | 2290.000 | 1.00x | 0.000 | 6000 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 142433.562 | 25.82x | 2598.000 | 1.14x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | vide | 7560.408 | 1.37x | 1917.000 | 0.84x | 0.000 | 6000 | 0 | 0 | 30 |
| animate-many | 1 | react | unsupported: React and ReactRoblox have no native spring primitive. Adding another animation library would change the comparison. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| animate-many | 1 | blend | 9865.745 | 1.79x | 2645.000 | 1.16x | 0.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | roact | unsupported: Roact has no native spring primitive. | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 24928.573 | 4.52x | 3556.000 | 1.56x | 8.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals has no native spring primitive. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox have no native spring primitive. Adding another animation library would change the comparison. | — | — | — | — | — | — | — | — |
| animate-many | 1 | fusion-charm | 143018.159 | 25.93x | 2600.000 | 1.14x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox have no native spring primitive. Adding another animation library would change the comparison. | — | — | — | — | — | — | — | — |
| status-panel (contract) | 20 | bare | 274.496 | 0.37x | 139.000 | 0.76x | 1.000 | 82 | 21 | 0 | 0 |
| status-panel (contract) | 20 | compose | 732.287 | 1.00x | 182.000 | 1.00x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel (contract) | 20 | compose-direct | 667.089 | 0.91x | 179.000 | 0.98x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel (contract) | 20 | fusion | 2573.924 | 3.51x | 244.000 | 1.34x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel (contract) | 20 | vide | 658.290 | 0.90x | 188.000 | 1.03x | 0.000 | 208 | 21 | 0 | 0 |
| status-panel (contract) | 20 | react | 2961.163 | 4.04x | 211.000 | 1.16x | 7.000 | 103 | 21 | 0 | 0 |
| status-panel (contract) | 20 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| status-panel (contract) | 20 | blend | 1002.448 | 1.37x | 250.000 | 1.37x | 0.000 | 438 | 21 | 0 | 0 |
| status-panel (contract) | 20 | roact | 827.204 | 1.13x | 176.000 | 0.97x | 1.000 | 103 | 21 | 0 | 0 |
| status-panel (contract) | 20 | seam | unsupported: Seam's native computed-property type guard rejects the workload's synthetic Frame.Text property, whose default type is nil. | — | — | — | — | — | — | — | — |
| status-panel (contract) | 20 | signals | unsupported: Signals supplies state and effects, with no native keyed Instance collection or row lifetime primitive. | — | — | — | — | — | — | — | — |
| status-panel (contract) | 20 | react-reflex | 2724.282 | 3.72x | 214.000 | 1.18x | 8.000 | 103 | 21 | 20 | 0 |
| status-panel (contract) | 20 | fusion-charm | 2661.631 | 3.63x | 249.000 | 1.37x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel (contract) | 20 | react-upstream | 2698.412 | 3.68x | 211.000 | 1.16x | 7.000 | 103 | 21 | 0 | 0 |
| mount-cycles | 1 | bare | 28141.577 | 1.13x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | compose | 24969.611 | 1.00x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | compose-direct | 33637.666 | 1.35x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion | 29982.237 | 1.20x | 0.000 | 0.00x | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | vide | 27089.839 | 1.08x | 0.000 | 0.00x | 0.000 | 14490 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react | 46926.385 | 1.88x | 21.000 | 21.00x | 20.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| mount-cycles | 1 | blend | 49450.761 | 1.98x | 1.000 | 1.00x | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | roact | 32077.921 | 1.28x | 1.000 | 1.00x | 0.000 | 3630 | 1830 | 1800 | 0 |
| mount-cycles | 1 | seam | 28843.559 | 1.16x | 0.000 | 0.00x | 0.000 | 1800 | 1830 | 1830 | 0 |
| mount-cycles | 1 | signals | 21588.701 | 0.86x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-reflex | 42175.238 | 1.69x | 27.000 | 27.00x | 26.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion-charm | 32426.087 | 1.30x | 0.000 | 0.00x | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-upstream | 38281.047 | 1.53x | 21.000 | 21.00x | 18.000 | 3600 | 1830 | 1800 | 0 |
| scene-3d | 20 | bare | 6071.256 | 0.79x | 1036.000 | 0.86x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 7671.593 | 1.00x | 1209.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose-direct | 9825.024 | 1.28x | 1233.000 | 1.02x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 89059.788 | 11.61x | 1575.000 | 1.30x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 10958.831 | 1.43x | 1236.000 | 1.02x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 8086.665 | 1.05x | 1243.000 | 1.03x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| scene-3d | 20 | blend | 11750.113 | 1.53x | 1571.000 | 1.30x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | unsupported: Roact assigns Instance.Name from reconciliation keys. Named children use dictionary keys, whose mounting order cannot satisfy this workload's ordered named-tree contract. | — | — | — | — | — | — | — | — |
| scene-3d | 20 | seam | 22788.718 | 2.97x | 2237.000 | 1.85x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 16163.277 | 2.11x | 1760.000 | 1.46x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 7353.821 | 0.96x | 1245.000 | 1.03x | 1.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | fusion-charm | 89366.307 | 11.65x | 1571.000 | 1.30x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-upstream | 7573.283 | 0.99x | 1251.000 | 1.03x | 9.000 | 6000 | 0 | 0 | 0 |
| unwind (contract) | 10 | bare | 3348.234 | 0.66x | 1.000 | 1.00x | 0.000 | 590 | 590 | 0 | 0 |
| unwind (contract) | 10 | compose | 5064.224 | 1.00x | 1.000 | 1.00x | 1.000 | 590 | 590 | 0 | 0 |
| unwind (contract) | 10 | compose-direct | 5035.907 | 0.99x | 9.000 | 9.00x | 0.000 | 590 | 590 | 0 | 0 |
| unwind (contract) | 10 | fusion | 5095.411 | 1.01x | 1.000 | 1.00x | 1.000 | 5310 | 590 | 0 | 0 |
| unwind (contract) | 10 | vide | unsupported: Vide releases Instances only through cleanup registrations. This lane registers cleanup on each owned root, so a build that fails before its root exists leaves the created parts without an owner. | — | — | — | — | — | — | — | — |
| unwind (contract) | 10 | react | unsupported: A failed native render, including an error boundary, leaves abandoned cost-model host nodes after root unmount. It does not satisfy the partial-build rollback contract. | — | — | — | — | — | — | — | — |
| unwind (contract) | 10 | react-usestate | unsupported: This variant differs from the react lane only in update-repeated, where it uses useState; the other workloads are the react lane. | — | — | — | — | — | — | — | — |
| unwind (contract) | 10 | blend | unsupported: An error during native observable subscription leaves the partially created cost-model nodes without a returned cleanup resource. It does not satisfy failed-build rollback. | — | — | — | — | — | — | — | — |
| unwind (contract) | 10 | roact | unsupported: Roact's public mount API returns its cleanup handle only after a successful mount; failed render rollback is not guaranteed. | — | — | — | — | — | — | — | — |
| unwind (contract) | 10 | seam | 4366.813 | 0.86x | 1.000 | 1.00x | 0.000 | 590 | 590 | 0 | 0 |
| unwind (contract) | 10 | signals | 3565.175 | 0.70x | 1.000 | 1.00x | 1.000 | 590 | 590 | 0 | 0 |
| unwind (contract) | 10 | react-reflex | unsupported: A failed native render, including an error boundary, leaves abandoned cost-model host nodes after root unmount. It does not satisfy the partial-build rollback contract. | — | — | — | — | — | — | — | — |
| unwind (contract) | 10 | fusion-charm | 5259.776 | 1.04x | 1.000 | 1.00x | 0.000 | 5310 | 590 | 0 | 0 |
| unwind (contract) | 10 | react-upstream | unsupported: A failed native render, including an error boundary, leaves abandoned cost-model host nodes after root unmount. It does not satisfy the partial-build rollback contract. | — | — | — | — | — | — | — | — |

### Summary of neutral workloads

This summary uses the 20 selected workloads that do not measure a Compose contract. The geometric mean divides each measured median time by the Compose median time of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count.

| Framework | Supported | Measured | Geometric mean time / Compose |
| --- | ---: | ---: | ---: |
| bare | 20 | 20 | 0.64x |
| compose | 20 | 20 | 1.00x |
| compose-direct | 20 | 20 | 1.09x |
| fusion | 16 | 16 | 3.05x |
| vide | 20 | 20 | 1.21x |
| react | 19 | 19 | 2.74x |
| react-usestate | 0 | 0 | — |
| blend | 20 | 20 | 1.62x |
| roact | 18 | 18 | 1.65x |
| seam | 20 | 20 | 2.58x |
| signals | 10 | 10 | 1.20x |
| react-reflex | 19 | 19 | 3.41x |
| fusion-charm | 16 | 16 | 3.46x |
| react-upstream | 19 | 19 | 2.82x |

### Workloads with Compose contracts

The summary leaves out these workloads:

- `update-repeated`: measures merging 500 writes into one host write, which Compose does by design.
- `ordered-window-scroll`: measures a Compose collection primitive that only Compose has.
- `status-panel`: writes a synthetic Frame.Text property that the Seam type guard rejects.
- `unwind`: measures the Compose partial-build rollback contract, which most public APIs do not satisfy.

### Source identities

Harness revision: `4c034ad3b80235101eaf52c1592ed23e77d0fdd4`. Full source state, tools, environment and command are in `context.json`.

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
