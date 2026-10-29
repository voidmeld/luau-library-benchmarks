# Headless results

Harness commit: `3ea569c166b26cd4dcc66e7d72c766f6d5e865ff`. Workflow run: [Library comparison 40844851286](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40844851286). Runner: `ubuntu-latest`. Mode: `like-for-like`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **like-for-like**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

# Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Framework | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| cold-mount-100 | 1 | plain | 678.335 | 1.00x | 555.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | blend | 1141.227 | 1.68x | 696.000 | 1.25x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | compose | 852.406 | 1.26x | 558.000 | 1.01x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion | 895.550 | 1.32x | 564.000 | 1.02x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion-charm | 918.052 | 1.35x | 564.000 | 1.02x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react | 1075.368 | 1.59x | 606.000 | 1.09x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-reflex | 1087.836 | 1.60x | 606.000 | 1.09x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-upstream | 1126.981 | 1.66x | 606.000 | 1.09x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | roact | 926.621 | 1.37x | 654.000 | 1.18x | 0.000 | 201 | 101 | 0 | 0 |
| cold-mount-100 | 1 | seam | 828.107 | 1.22x | 569.000 | 1.03x | 0.000 | 100 | 101 | 1 | 0 |
| cold-mount-100 | 1 | signals | 720.861 | 1.06x | 567.000 | 1.02x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | vide | 842.669 | 1.24x | 555.000 | 1.00x | 0.000 | 703 | 101 | 0 | 0 |
| cold-mount-1000 | 1 | plain | 4600.532 | 1.00x | 5478.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | blend | 10177.882 | 2.21x | 6864.000 | 1.25x | 8.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | compose | 6169.925 | 1.34x | 5480.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion | 6210.244 | 1.35x | 5536.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion-charm | 6593.534 | 1.43x | 5535.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react | 9007.031 | 1.96x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-reflex | 8432.163 | 1.83x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-upstream | 8888.148 | 1.93x | 5978.000 | 1.09x | 0.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | roact | 7078.744 | 1.54x | 6444.000 | 1.18x | 0.000 | 2001 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | seam | 5925.157 | 1.29x | 5554.000 | 1.01x | 0.000 | 1000 | 1001 | 1 | 0 |
| cold-mount-1000 | 1 | signals | 4990.305 | 1.08x | 5516.000 | 1.01x | 8.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | vide | 6063.489 | 1.32x | 5463.000 | 1.00x | 0.000 | 7003 | 1001 | 0 | 0 |
| cold-mount-10000 | 1 | plain | 52234.943 | 1.00x | 54981.000 | 1.00x | 1.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | blend | 95850.376 | 1.83x | 68713.000 | 1.25x | 1.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | compose | 60253.582 | 1.15x | 55082.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion | 70686.575 | 1.35x | 55722.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion-charm | 70164.705 | 1.34x | 55714.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react | 82433.987 | 1.58x | 59851.000 | 1.09x | 8.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-reflex | 83342.571 | 1.60x | 59852.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-upstream | 98895.925 | 1.89x | 59844.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | roact | 66350.491 | 1.27x | 64846.000 | 1.18x | 0.000 | 20001 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | seam | 65491.773 | 1.25x | 56109.000 | 1.02x | 1.000 | 10000 | 10001 | 1 | 0 |
| cold-mount-10000 | 1 | signals | 51792.464 | 0.99x | 55277.000 | 1.01x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | vide | 62270.157 | 1.19x | 54825.000 | 1.00x | 0.000 | 70003 | 10001 | 0 | 0 |
| mount-dispose | 5 | plain | 7101.005 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | blend | 14397.446 | 2.03x | 1.000 | 1.00x | 1.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | compose | 7928.293 | 1.12x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion | 9938.348 | 1.40x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion-charm | 9663.427 | 1.36x | 1.000 | 1.00x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | react | 11209.095 | 1.58x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-reflex | 11361.749 | 1.60x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-upstream | 11536.467 | 1.62x | 0.000 | 0.00x | 4.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | roact | 9780.661 | 1.38x | 1.000 | 1.00x | 0.000 | 2005 | 1005 | 0 | 0 |
| mount-dispose | 5 | seam | 7780.747 | 1.10x | 2.000 | 2.00x | 0.000 | 1000 | 1005 | 5 | 0 |
| mount-dispose | 5 | signals | 6130.630 | 0.86x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | vide | 7003.319 | 0.99x | 0.000 | 0.00x | 0.000 | 7015 | 1005 | 0 | 0 |
| update-leaf | 50 | plain | 20.115 | 1.00x | 2745.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | blend | 62.876 | 3.13x | 3437.000 | 1.25x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 68.809 | 3.42x | 2764.000 | 1.01x | 8.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 110.873 | 5.51x | 2779.000 | 1.01x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion-charm | 187.854 | 9.34x | 2774.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 54.327 | 2.70x | 2995.000 | 1.09x | 9.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 107.866 | 5.36x | 3003.000 | 1.09x | 8.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | react-upstream | 53.709 | 2.67x | 3002.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 43.616 | 2.17x | 3223.000 | 1.17x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 112.159 | 5.58x | 2793.000 | 1.02x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 76.994 | 3.83x | 2762.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 60.828 | 3.02x | 2730.000 | 0.99x | 0.000 | 50 | 0 | 0 | 0 |
| update-fanout | 20 | plain | 730.265 | 1.00x | 1651.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | blend | 2585.467 | 3.54x | 2241.000 | 1.36x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | compose | 1550.505 | 2.12x | 1804.000 | 1.09x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion | 6856.205 | 9.39x | 1894.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion-charm | 7067.090 | 9.68x | 1896.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react | 1244.231 | 1.70x | 1925.000 | 1.17x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-reflex | 1285.695 | 1.76x | 1926.000 | 1.17x | 1.000 | 6000 | 0 | 20 | 0 |
| update-fanout | 20 | react-upstream | 1265.414 | 1.73x | 1933.000 | 1.17x | 9.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | roact | 1499.581 | 2.05x | 2062.000 | 1.25x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | seam | 2765.965 | 3.79x | 2153.000 | 1.30x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | signals | 3262.549 | 4.47x | 1901.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | vide | 2834.586 | 3.88x | 1815.000 | 1.10x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | plain | 746.132 | 1.00x | 1651.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 4199.811 | 5.63x | 2518.000 | 1.53x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 2806.074 | 3.76x | 1962.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 10207.276 | 13.68x | 2129.000 | 1.29x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion-charm | 19524.105 | 26.17x | 2698.000 | 1.63x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 2018.263 | 2.70x | 2096.000 | 1.27x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 34809.356 | 46.65x | 2371.000 | 1.44x | 1.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | react-upstream | 1974.976 | 2.65x | 2096.000 | 1.27x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 2590.012 | 3.47x | 2522.000 | 1.53x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 5903.988 | 7.91x | 2935.000 | 1.78x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 4598.427 | 6.16x | 2223.000 | 1.35x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 3353.323 | 4.49x | 1960.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 36.201 | 1.00x | 14.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 3002.673 | 82.94x | 21.000 | 1.50x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | compose | 611.735 | 16.90x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 17542.050 | 484.57x | 18.000 | 1.29x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | fusion-charm | 998.789 | 27.59x | 20.000 | 1.43x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 6150.530 | 169.90x | 0.000 | 0.00x | 4.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react-reflex | 1129.212 | 31.19x | 17.000 | 1.21x | 1.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | react-upstream | 6106.657 | 168.69x | 4.000 | 0.29x | 4.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | roact | 2192.915 | 60.58x | 10.000 | 0.71x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 1779.571 | 49.16x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 882.047 | 24.37x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 456.674 | 12.61x | 15.000 | 1.07x | 0.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 2702.091 | 1.00x | 28.000 | 1.00x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 6891.891 | 2.55x | 46.000 | 1.64x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 4145.144 | 1.53x | 24.000 | 0.86x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 4183.203 | 1.55x | 32.000 | 1.14x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | fusion-charm | 4274.758 | 1.58x | 34.000 | 1.21x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react | 5974.898 | 2.21x | 365.000 | 13.04x | 12.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | react-reflex | 6261.428 | 2.32x | 375.000 | 13.39x | 20.000 | 1010 | 510 | 20 | 0 |
| branch-swap | 20 | react-upstream | 6409.451 | 2.37x | 365.000 | 13.04x | 18.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | roact | 4387.138 | 1.62x | 27.000 | 0.96x | 0.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 3691.348 | 1.37x | 38.000 | 1.36x | 1.000 | 500 | 510 | 10 | 0 |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — | — | — | — | — | — | — |
| branch-swap | 20 | vide | 3420.203 | 1.27x | 23.000 | 0.82x | 0.000 | 3530 | 510 | 0 | 0 |
| keyed-append | 10 | plain | 1055.637 | 1.00x | 1708.000 | 1.00x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | blend | 3722.893 | 3.53x | 3068.000 | 1.80x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-append | 10 | compose | 1165.987 | 1.10x | 2162.000 | 1.27x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | react | 9185.734 | 8.70x | 2510.000 | 1.47x | 5.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | react-reflex | 9153.494 | 8.67x | 2511.000 | 1.47x | 6.000 | 150 | 50 | 10 | 0 |
| keyed-append | 10 | react-upstream | 9182.722 | 8.70x | 2509.000 | 1.47x | 13.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | roact | 4637.187 | 4.39x | 1980.000 | 1.16x | 0.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | seam | 11258.682 | 10.67x | 3464.000 | 2.03x | 0.000 | 100 | 50 | 100 | 50 |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | vide | 1431.754 | 1.36x | 2266.000 | 1.33x | 0.000 | 400 | 50 | 0 | 0 |
| keyed-prepend | 10 | plain | 1314.947 | 1.00x | 1708.000 | 1.00x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 3870.899 | 2.94x | 3068.000 | 1.80x | 8.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 2719.152 | 2.07x | 2163.000 | 1.27x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react | 13038.157 | 9.92x | 2465.000 | 1.44x | 6.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | react-reflex | 13093.268 | 9.96x | 2457.000 | 1.44x | 5.000 | 3150 | 50 | 10 | 0 |
| keyed-prepend | 10 | react-upstream | 13036.756 | 9.91x | 2449.000 | 1.43x | 6.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | roact | 6403.892 | 4.87x | 1980.000 | 1.16x | 0.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 12490.523 | 9.50x | 3464.000 | 2.03x | 0.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | vide | 3433.177 | 2.61x | 2266.000 | 1.33x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1190.374 | 1.00x | 1708.000 | 1.00x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 3884.284 | 3.26x | 3069.000 | 1.80x | 1.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 1979.238 | 1.66x | 2162.000 | 1.27x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react | 11674.604 | 9.81x | 2491.000 | 1.46x | 13.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | react-reflex | 11489.092 | 9.65x | 2484.000 | 1.45x | 7.000 | 1650 | 50 | 10 | 0 |
| keyed-insert | 10 | react-upstream | 11542.961 | 9.70x | 2491.000 | 1.46x | 6.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | roact | 5617.877 | 4.72x | 1980.000 | 1.16x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 11791.057 | 9.91x | 3463.000 | 2.03x | 0.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | vide | 2352.180 | 1.98x | 2266.000 | 1.33x | 0.000 | 1900 | 50 | 0 | 0 |
| keyed-remove | 10 | plain | 1219.381 | 1.00x | 1688.000 | 1.00x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | blend | 3660.402 | 3.00x | 3068.000 | 1.82x | 9.000 | 3400 | 50 | 0 | 0 |
| keyed-remove | 10 | compose | 1906.093 | 1.56x | 2162.000 | 1.28x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | react | 11232.600 | 9.21x | 2409.000 | 1.43x | 5.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | react-reflex | 11745.725 | 9.63x | 2409.000 | 1.43x | 6.000 | 1560 | 50 | 10 | 0 |
| keyed-remove | 10 | react-upstream | 11138.698 | 9.13x | 2409.000 | 1.43x | 5.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | roact | 5354.367 | 4.39x | 1979.000 | 1.17x | 0.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | seam | 11503.284 | 9.43x | 3462.000 | 2.05x | 0.000 | 1510 | 50 | 100 | 50 |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | vide | 2071.579 | 1.70x | 2265.000 | 1.34x | 0.000 | 1810 | 50 | 0 | 0 |
| keyed-replace | 10 | plain | 20962.485 | 1.00x | 1719.000 | 1.00x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | blend | 67613.635 | 3.23x | 5702.000 | 3.32x | 9.000 | 30000 | 3000 | 0 | 0 |
| keyed-replace | 10 | compose | 44822.296 | 2.14x | 2185.000 | 1.27x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion | 72587.910 | 3.46x | 3002.000 | 1.75x | 0.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion-charm | 63124.576 | 3.01x | 3005.000 | 1.75x | 1.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | react | 57811.172 | 2.76x | 3932.000 | 2.29x | 8.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | react-reflex | 62442.774 | 2.98x | 3932.000 | 2.29x | 0.000 | 9000 | 3000 | 10 | 0 |
| keyed-replace | 10 | react-upstream | 62446.886 | 2.98x | 3924.000 | 2.28x | 8.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | roact | 26333.094 | 1.26x | 2003.000 | 1.17x | 0.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | seam | 75599.973 | 3.61x | 3510.000 | 2.04x | 1.000 | 6000 | 3000 | 6000 | 3000 |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-replace | 10 | vide | 36328.023 | 1.73x | 2328.000 | 1.35x | 0.000 | 24000 | 3000 | 0 | 0 |
| keyed-reverse | 10 | plain | 1001.558 | 1.00x | 1695.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | blend | 1717.141 | 1.71x | 3034.000 | 1.79x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | compose | 1970.934 | 1.97x | 2162.000 | 1.28x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion | 16273.882 | 16.25x | 2978.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion-charm | 16067.340 | 16.04x | 2989.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react | 34396.353 | 34.34x | 2386.000 | 1.41x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react-reflex | 34520.475 | 34.47x | 2395.000 | 1.41x | 12.000 | 3000 | 0 | 10 | 0 |
| keyed-reverse | 10 | react-upstream | 34717.101 | 34.66x | 2402.000 | 1.42x | 12.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | roact | 5001.451 | 4.99x | 1987.000 | 1.17x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | seam | 9583.671 | 9.57x | 3470.000 | 2.05x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-reverse | 10 | vide | 1975.936 | 1.97x | 2257.000 | 1.33x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | plain | 919.224 | 1.00x | 1695.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | blend | 1593.575 | 1.73x | 3026.000 | 1.79x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | compose | 2053.372 | 2.23x | 2162.000 | 1.28x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion | 15877.391 | 17.27x | 2979.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion-charm | 16022.082 | 17.43x | 2989.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react | 23338.486 | 25.39x | 2394.000 | 1.41x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react-reflex | 23483.111 | 25.55x | 2394.000 | 1.41x | 4.000 | 3000 | 0 | 10 | 0 |
| keyed-rotate | 10 | react-upstream | 23558.435 | 25.63x | 2402.000 | 1.42x | 12.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | roact | 5119.095 | 5.57x | 1987.000 | 1.17x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | seam | 9575.498 | 10.42x | 3462.000 | 2.04x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-rotate | 10 | vide | 2018.847 | 2.20x | 2257.000 | 1.33x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | plain | 1011.331 | 1.00x | 1696.000 | 1.00x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 1703.685 | 1.68x | 3026.000 | 1.78x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 2091.215 | 2.07x | 2162.000 | 1.27x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 16556.380 | 16.37x | 2978.000 | 1.76x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion-charm | 15830.650 | 15.65x | 2989.000 | 1.76x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 21679.821 | 21.44x | 2394.000 | 1.41x | 4.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react-reflex | 21777.767 | 21.53x | 2395.000 | 1.41x | 4.000 | 2990 | 0 | 10 | 0 |
| keyed-shuffle | 10 | react-upstream | 21851.899 | 21.61x | 2395.000 | 1.41x | 12.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | roact | 5316.413 | 5.26x | 1980.000 | 1.17x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 10040.658 | 9.93x | 3462.000 | 2.04x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-shuffle | 10 | vide | 2021.018 | 2.00x | 2249.000 | 1.33x | 0.000 | 2990 | 0 | 0 | 0 |
| events | 5 | plain | 9761.779 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | blend | 20245.505 | 2.07x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | compose | 11595.458 | 1.19x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | fusion | 12810.959 | 1.31x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | fusion-charm | 12971.955 | 1.33x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | react | 15696.303 | 1.61x | 4.000 | 4.00x | 0.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | react-reflex | 15894.477 | 1.63x | 5.000 | 5.00x | 4.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | react-upstream | 15429.966 | 1.58x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | roact | 12918.113 | 1.32x | 1.000 | 1.00x | 0.000 | 2005 | 1005 | 1000 | 0 |
| events | 5 | seam | 12284.868 | 1.26x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1005 | 0 |
| events | 5 | signals | 9717.520 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | vide | 10784.762 | 1.10x | 1.000 | 1.00x | 1.000 | 8015 | 1005 | 1000 | 0 |
| animate-many | 1 | plain | 1319.939 | 1.00x | 1524.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | blend | 7958.494 | 6.03x | 2642.000 | 1.73x | 0.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | compose | 7062.140 | 5.35x | 2283.000 | 1.50x | 0.000 | 6000 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 118826.568 | 90.02x | 2598.000 | 1.70x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | fusion-charm | 119300.364 | 90.38x | 2600.000 | 1.71x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 20606.221 | 15.61x | 3518.000 | 2.31x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — | — | — |
| animate-many | 1 | vide | 4997.328 | 3.79x | 1924.000 | 1.26x | 0.000 | 6000 | 0 | 0 | 30 |
| status-panel | 20 | plain | 223.528 | 1.00x | 135.000 | 1.00x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | blend | 819.726 | 3.67x | 247.000 | 1.83x | 0.000 | 438 | 21 | 0 | 0 |
| status-panel | 20 | compose | 705.810 | 3.16x | 178.000 | 1.32x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | fusion | 2111.243 | 9.45x | 240.000 | 1.78x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | fusion-charm | 2318.870 | 10.37x | 245.000 | 1.81x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | react | 2340.570 | 10.47x | 207.000 | 1.53x | 8.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | react-reflex | 2350.269 | 10.51x | 209.000 | 1.55x | 8.000 | 103 | 21 | 20 | 0 |
| status-panel | 20 | react-upstream | 2041.095 | 9.13x | 207.000 | 1.53x | 7.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | roact | 634.982 | 2.84x | 165.000 | 1.22x | 0.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | seam | 1475.062 | 6.60x | 282.000 | 2.09x | 0.000 | 82 | 21 | 42 | 21 |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| status-panel | 20 | vide | 453.773 | 2.03x | 176.000 | 1.30x | 1.000 | 208 | 21 | 0 | 0 |
| mount-cycles | 1 | plain | 15333.886 | 1.00x | 1.000 | 1.00x | 1.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | blend | 29548.979 | 1.93x | 1.000 | 1.00x | 1.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | compose | 17408.549 | 1.14x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion | 18555.143 | 1.21x | 0.000 | 0.00x | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion-charm | 21339.194 | 1.39x | 1.000 | 1.00x | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react | 24536.672 | 1.60x | 23.000 | 23.00x | 20.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-reflex | 28336.144 | 1.85x | 21.000 | 21.00x | 18.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-upstream | 28851.463 | 1.88x | 21.000 | 21.00x | 18.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | roact | 20853.108 | 1.36x | 1.000 | 1.00x | 0.000 | 3630 | 1830 | 1800 | 0 |
| mount-cycles | 1 | seam | 18827.926 | 1.23x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1830 | 0 |
| mount-cycles | 1 | signals | 14383.642 | 0.94x | 1.000 | 1.00x | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | vide | 15592.663 | 1.02x | 9.000 | 9.00x | 1.000 | 14490 | 1830 | 1800 | 0 |
| scene-3d | 20 | plain | 3043.314 | 1.00x | 1036.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | blend | 6509.166 | 2.14x | 1571.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 4534.255 | 1.49x | 1210.000 | 1.17x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 69370.520 | 22.79x | 1575.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion-charm | 68745.697 | 22.59x | 1579.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 4253.335 | 1.40x | 1244.000 | 1.20x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 4507.906 | 1.48x | 1245.000 | 1.20x | 0.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | react-upstream | 4667.652 | 1.53x | 1243.000 | 1.20x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — | — | — | — | — | — | — |
| scene-3d | 20 | seam | 16522.924 | 5.43x | 2210.000 | 2.13x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 10552.845 | 3.47x | 1689.000 | 1.63x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 5980.298 | 1.97x | 1228.000 | 1.19x | 1.000 | 6000 | 0 | 0 | 0 |

## Summary

This summary uses the 22 selected workloads. The geometric mean divides each measured median time by the plain median time of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count.

The shared column uses only the 10 workloads that every lane measured: `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000`, `mount-dispose`, `update-leaf`, `update-fanout`, `update-batched`, `update-repeated`, `events`, `mount-cycles`.

| Framework | Supported | Measured | Geometric mean time / plain | Shared workloads, geometric mean / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 22 | 22 | 1.00x | 1.00x |
| blend | 22 | 22 | 3.08x | 3.51x |
| compose | 22 | 22 | 2.03x | 2.06x |
| fusion | 18 | 18 | 6.76x | 4.23x |
| fusion-charm | 18 | 18 | 6.21x | 3.66x |
| react | 21 | 21 | 5.03x | 2.90x |
| react-reflex | 21 | 21 | 5.60x | 3.54x |
| react-upstream | 21 | 21 | 5.15x | 3.01x |
| roact | 20 | 20 | 2.94x | 2.39x |
| seam | 22 | 22 | 4.73x | 2.78x |
| signals | 11 | 11 | 2.27x | 2.17x |
| vide | 22 | 22 | 2.01x | 2.07x |

## Source identities

Harness revision: `3ea569c166b26cd4dcc66e7d72c766f6d5e865ff`. Full source state, tools, environment and command are in `context.json`.

| Dependency | Version | Commit | Tree | Rights |
| --- | --- | --- | --- | --- |
| compose | unreleased | `5945400d3c5d134d92f778cf8628b821187f254e` | `cdb127fa24538e0f13e891aa3c8e688b7fed2d6f` | MIT |
| facet | 0.12.0 | `9c37177a24c3414c71c9456c2e6c14c5389f4916` | `f3f3b4ce82138a1ded6375b339d8a33a2748792f` | MIT |
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
