# Headless results

Harness commit: `c77fc4151c8459e6f6e922913b9d71805b16c776`. Workflow run: [Library comparison 41107250479](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/41107250479). Runner: `ubuntu-latest`, six scene composition shards merged. Mode: `like-for-like`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **like-for-like**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

# Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Framework | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| update-leaf | 20 | plain | 13.440 | 11.601–26.209 | 1.00x | 2808.000 | 1.00x | 64.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | blend | 44.723 | 40.916–68.096 | 3.33x | 3500.000 | 1.25x | 64.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | compose | 43.326 | 40.786–56.245 | 3.22x | 2845.000 | 1.01x | 97.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | fusion | 67.456 | 63.549–85.439 | 5.02x | 2835.000 | 1.01x | 64.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | fusion-charm | 118.315 | 111.597–152.303 | 8.80x | 2837.000 | 1.01x | 64.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | react | 46.151 | 42.499–57.216 | 3.43x | 3505.000 | 1.25x | 511.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | react-reflex | 83.480 | 76.342–100.788 | 6.21x | 3513.000 | 1.25x | 518.000 | 20 | 0 | 20 | 0 |
| update-leaf | 20 | react-upstream | 47.612 | 42.272–62.380 | 3.54x | 3506.000 | 1.25x | 519.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | roact | 29.371 | 26.118–32.162 | 2.19x | 3719.000 | 1.32x | 64.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | seam | 69.654 | 64.501–94.225 | 5.18x | 2822.000 | 1.00x | 64.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | signals | 44.528 | 41.527–55.603 | 3.31x | 2834.000 | 1.01x | 64.000 | 20 | 0 | 0 | 0 |
| update-leaf | 20 | vide | 37.529 | 34.494–51.626 | 2.79x | 2803.000 | 1.00x | 66.000 | 20 | 0 | 0 | 0 |
| update-batched | 20 | plain | 1352.812 | 1304.861–1491.551 | 1.00x | 1715.000 | 1.00x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 6662.022 | 6454.293–6850.575 | 4.92x | 2582.000 | 1.51x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 4804.958 | 4696.956–5256.920 | 3.55x | 2099.000 | 1.22x | 138.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 16086.942 | 14841.172–16836.183 | 11.89x | 2256.000 | 1.32x | 128.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion-charm | 25916.178 | 25015.342–28349.829 | 19.16x | 2833.000 | 1.65x | 136.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 3753.263 | 3578.924–3932.107 | 2.77x | 2787.000 | 1.63x | 691.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 58819.760 | 52901.696–65611.038 | 43.48x | 3085.000 | 1.80x | 707.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | react-upstream | 3858.290 | 3645.892–4282.754 | 2.85x | 2795.000 | 1.63x | 699.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 6076.390 | 5169.092–6451.081 | 4.49x | 2842.000 | 1.66x | 64.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 9503.202 | 9146.634–10099.768 | 7.02x | 3011.000 | 1.76x | 104.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 7349.942 | 7208.648–7572.519 | 5.43x | 2327.000 | 1.36x | 72.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 5841.079 | 5732.396–6217.744 | 4.32x | 2033.000 | 1.19x | 73.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 24.837 | 23.836–36.355 | 1.00x | 14.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 2068.268 | 1950.840–2366.306 | 83.27x | 21.000 | 1.50x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | compose | 466.553 | 455.046–681.427 | 18.78x | 19.000 | 1.36x | 2.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 12251.916 | 11795.137–12642.023 | 493.29x | 18.000 | 1.29x | 1.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | fusion-charm | 732.234 | 715.909–775.779 | 29.48x | 20.000 | 1.43x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 5568.653 | 5439.408–12422.112 | 224.21x | 370.000 | 26.43x | 377.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | react-reflex | 631.472 | 608.097–1760.333 | 25.42x | 221.000 | 15.79x | 205.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | react-upstream | 6391.654 | 6196.589–6606.287 | 257.34x | 371.000 | 26.50x | 378.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | roact | 1583.267 | 1538.839–1627.463 | 63.75x | 19.000 | 1.36x | 1.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 1326.889 | 1232.588–1398.778 | 53.42x | 23.000 | 1.64x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 689.369 | 664.271–712.554 | 27.76x | 17.000 | 1.21x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 327.283 | 323.367–350.137 | 13.18x | 16.000 | 1.14x | 1.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 2848.004 | 2639.359–2976.626 | 1.00x | 148.000 | 1.00x | 128.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 7096.993 | 6706.818–8764.310 | 2.49x | 166.000 | 1.12x | 129.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 4480.801 | 4108.531–5005.506 | 1.57x | 167.000 | 1.13x | 144.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 4497.951 | 4054.339–5771.803 | 1.58x | 151.000 | 1.02x | 128.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | fusion-charm | 4269.782 | 4021.964–4674.630 | 1.50x | 153.000 | 1.03x | 128.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react | 6726.243 | 6108.486–9204.144 | 2.36x | 366.000 | 2.47x | 345.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | react-reflex | 6438.870 | 6144.920–6924.621 | 2.26x | 367.000 | 2.48x | 338.000 | 1010 | 510 | 20 | 20 |
| branch-swap | 20 | react-upstream | 6560.430 | 6204.786–6915.161 | 2.30x | 367.000 | 2.48x | 346.000 | 1010 | 510 | 0 | 20 |
| branch-swap | 20 | roact | 5176.951 | 4771.061–5628.446 | 1.82x | 158.000 | 1.07x | 128.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 3858.933 | 3658.756–4002.405 | 1.35x | 159.000 | 1.07x | 149.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | signals | 3209.844 | 2996.879–3420.054 | 1.13x | 151.000 | 1.02x | 128.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | vide | 3696.688 | 3411.203–3851.132 | 1.30x | 153.000 | 1.03x | 130.000 | 3530 | 510 | 0 | 0 |
| keyed-prepend | 10 | plain | 1591.039 | 1541.097–1652.093 | 1.00x | 1763.000 | 1.00x | 64.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 4447.369 | 4289.004–4647.616 | 2.80x | 3132.000 | 1.78x | 64.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 3200.986 | 3164.805–3543.393 | 2.01x | 2327.000 | 1.32x | 171.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react | 12937.687 | 12787.484–13994.447 | 8.13x | 2729.000 | 1.55x | 340.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | react-reflex | 12924.764 | 12862.969–13288.678 | 8.12x | 2737.000 | 1.55x | 340.000 | 3150 | 50 | 10 | 10 |
| keyed-prepend | 10 | react-upstream | 12975.339 | 12898.593–13149.747 | 8.16x | 2729.000 | 1.55x | 340.000 | 3150 | 50 | 0 | 10 |
| keyed-prepend | 10 | roact | 6801.446 | 6714.995–6933.582 | 4.27x | 2053.000 | 1.16x | 64.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 12525.844 | 12301.508–12877.126 | 7.87x | 3544.000 | 2.01x | 141.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | 1597.883 | 1555.163–1694.320 | 1.00x | 1760.000 | 1.00x | 64.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | vide | 3741.759 | 3666.820–3891.272 | 2.35x | 2339.000 | 1.33x | 65.000 | 3400 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1434.914 | 1414.952–1493.176 | 1.00x | 1764.000 | 1.00x | 64.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 4172.233 | 4100.241–4312.510 | 2.91x | 3132.000 | 1.78x | 64.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 2289.295 | 2182.907–2341.279 | 1.60x | 2323.000 | 1.32x | 174.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react | 11279.913 | 11085.993–11433.187 | 7.86x | 2754.000 | 1.56x | 332.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | react-reflex | 11837.922 | 11467.249–11987.360 | 8.25x | 2755.000 | 1.56x | 332.000 | 1650 | 50 | 10 | 10 |
| keyed-insert | 10 | react-upstream | 11435.362 | 11151.258–11663.882 | 7.97x | 2755.000 | 1.56x | 340.000 | 1650 | 50 | 0 | 10 |
| keyed-insert | 10 | roact | 6037.343 | 5933.578–6531.704 | 4.21x | 2053.000 | 1.16x | 64.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 11750.242 | 11562.869–17670.317 | 8.19x | 3545.000 | 2.01x | 141.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | 1432.140 | 1401.790–1835.241 | 1.00x | 1760.000 | 1.00x | 64.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | vide | 2545.607 | 2498.636–2616.427 | 1.77x | 2339.000 | 1.33x | 66.000 | 1900 | 50 | 0 | 0 |
| keyed-shuffle | 10 | plain | 1325.903 | 1103.033–1652.357 | 1.00x | 1759.000 | 1.00x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 2424.243 | 2297.538–2530.931 | 1.83x | 3090.000 | 1.76x | 64.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 2111.830 | 2032.682–2225.712 | 1.59x | 2326.000 | 1.32x | 178.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 17485.261 | 16778.351–18223.983 | 13.19x | 3170.000 | 1.80x | 192.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion-charm | 17786.436 | 16673.404–18559.280 | 13.41x | 3172.000 | 1.80x | 193.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 25342.507 | 24049.943–32797.770 | 19.11x | 2723.000 | 1.55x | 340.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | react-reflex | 25100.596 | 24564.368–26176.648 | 18.93x | 2723.000 | 1.55x | 332.000 | 2990 | 0 | 10 | 10 |
| keyed-shuffle | 10 | react-upstream | 24793.409 | 23686.889–26812.897 | 18.70x | 2723.000 | 1.55x | 340.000 | 2990 | 0 | 0 | 10 |
| keyed-shuffle | 10 | roact | 6993.134 | 6564.320–7186.882 | 5.27x | 2052.000 | 1.17x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 11920.532 | 11303.412–13581.502 | 8.99x | 3544.000 | 2.01x | 140.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | 1351.483 | 1193.687–1495.340 | 1.02x | 1760.000 | 1.00x | 64.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | vide | 2218.283 | 2023.212–2355.546 | 1.67x | 2322.000 | 1.32x | 65.000 | 2990 | 0 | 0 | 0 |
| events | 1 | plain | 277.525 | 254.624–310.344 | 1.00x | 2.000 | 1.00x | 1.000 | 30 | 11 | 10 | 0 |
| events | 1 | blend | 441.293 | 408.203–470.983 | 1.59x | 2.000 | 1.00x | 1.000 | 113 | 11 | 10 | 0 |
| events | 1 | compose | 362.266 | 330.060–393.172 | 1.31x | 4.000 | 2.00x | 3.000 | 30 | 11 | 10 | 0 |
| events | 1 | fusion | 331.535 | 307.427–381.896 | 1.19x | 2.000 | 1.00x | 1.000 | 113 | 11 | 10 | 0 |
| events | 1 | fusion-charm | 333.105 | 309.689–357.813 | 1.20x | 2.000 | 1.00x | 2.000 | 113 | 11 | 10 | 0 |
| events | 1 | react | 505.239 | 462.533–532.538 | 1.82x | 260.000 | 130.00x | 259.000 | 40 | 11 | 10 | 2 |
| events | 1 | react-reflex | 501.122 | 472.386–545.825 | 1.81x | 252.000 | 126.00x | 251.000 | 40 | 11 | 10 | 2 |
| events | 1 | react-upstream | 517.220 | 473.679–556.419 | 1.86x | 260.000 | 130.00x | 260.000 | 40 | 11 | 10 | 2 |
| events | 1 | roact | 377.203 | 363.462–412.656 | 1.36x | 2.000 | 1.00x | 2.000 | 41 | 11 | 10 | 0 |
| events | 1 | seam | 323.393 | 301.902–352.739 | 1.17x | 2.000 | 1.00x | 1.000 | 30 | 11 | 10 | 0 |
| events | 1 | signals | 287.222 | 266.300–301.766 | 1.03x | 2.000 | 1.00x | 1.000 | 30 | 11 | 10 | 0 |
| events | 1 | vide | 320.257 | 300.252–829.687 | 1.15x | 3.000 | 1.50x | 10.000 | 103 | 11 | 10 | 0 |
| animate-many | 1 | plain | 1940.242 | 1878.246–1990.506 | 1.00x | 1548.000 | 1.00x | 32.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | blend | 12785.123 | 12397.979–13212.533 | 6.59x | 2725.000 | 1.76x | 84.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | compose | 11528.191 | 11230.743–11694.872 | 5.94x | 2391.000 | 1.54x | 92.000 | 3800 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 137460.595 | 136454.322–140344.860 | 70.85x | 2761.000 | 1.78x | 164.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | fusion-charm | 135841.673 | 134878.516–137696.307 | 70.01x | 2763.000 | 1.78x | 164.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 27850.485 | 26638.516–30187.640 | 14.35x | 3569.000 | 2.31x | 69.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — | — | — | — |
| animate-many | 1 | vide | 7703.210 | 7622.909–7832.602 | 3.97x | 1969.000 | 1.27x | 53.000 | 6000 | 0 | 0 | 30 |
| status-panel | 10 | plain | 177.135 | 169.095–211.591 | 1.00x | 81.000 | 1.00x | 1.000 | 42 | 11 | 0 | 0 |
| status-panel | 10 | blend | 476.887 | 456.304–539.292 | 2.69x | 149.000 | 1.84x | 1.000 | 173 | 11 | 0 | 0 |
| status-panel | 10 | compose | 406.222 | 357.564–556.632 | 2.29x | 154.000 | 1.90x | 45.000 | 42 | 11 | 0 | 0 |
| status-panel | 10 | fusion | 874.095 | 825.529–942.210 | 4.93x | 155.000 | 1.91x | 14.000 | 119 | 11 | 0 | 0 |
| status-panel | 10 | fusion-charm | 988.644 | 953.603–1143.389 | 5.58x | 153.000 | 1.89x | 6.000 | 119 | 11 | 0 | 0 |
| status-panel | 10 | react | 1093.578 | 1048.886–1192.023 | 6.17x | 331.000 | 4.09x | 211.000 | 53 | 11 | 0 | 10 |
| status-panel | 10 | react-reflex | 1141.099 | 1104.119–1252.416 | 6.44x | 343.000 | 4.23x | 213.000 | 53 | 11 | 10 | 10 |
| status-panel | 10 | react-upstream | 1137.936 | 1086.219–1374.555 | 6.42x | 340.000 | 4.20x | 220.000 | 53 | 11 | 0 | 10 |
| status-panel | 10 | roact | 375.175 | 344.104–409.088 | 2.12x | 111.000 | 1.37x | 9.000 | 53 | 11 | 0 | 0 |
| status-panel | 10 | seam | 795.368 | 728.157–888.345 | 4.49x | 180.000 | 2.22x | 7.000 | 42 | 11 | 22 | 11 |
| status-panel | 10 | signals | 247.269 | 235.678–279.752 | 1.40x | 94.000 | 1.16x | 9.000 | 42 | 11 | 0 | 0 |
| status-panel | 10 | vide | 299.271 | 290.364–329.984 | 1.69x | 112.000 | 1.38x | 3.000 | 108 | 11 | 0 | 0 |
| scene-3d | 10 | plain | 2105.465 | 1984.448–2279.599 | 1.00x | 1067.000 | 1.00x | 32.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | blend | 4246.918 | 3952.313–4404.379 | 2.02x | 1603.000 | 1.50x | 32.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | compose | 3185.101 | 2970.816–3312.091 | 1.51x | 1333.000 | 1.25x | 98.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | fusion | 37675.103 | 36394.933–38775.718 | 17.89x | 1670.000 | 1.57x | 96.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | fusion-charm | 37963.018 | 36890.784–39554.763 | 18.03x | 1674.000 | 1.57x | 96.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | react | 2913.203 | 2839.749–3121.595 | 1.38x | 1756.000 | 1.65x | 513.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | react-reflex | 3005.305 | 2784.215–3145.398 | 1.43x | 1750.000 | 1.64x | 513.000 | 3000 | 0 | 10 | 0 |
| scene-3d | 10 | react-upstream | 2868.380 | 2700.163–3060.081 | 1.36x | 1749.000 | 1.64x | 506.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | roact | 3151.689 | 2917.466–3296.680 | 1.50x | 1631.000 | 1.53x | 32.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | seam | 8909.419 | 8573.865–9247.617 | 4.23x | 2244.000 | 2.10x | 54.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | signals | 6647.948 | 6235.199–6886.342 | 3.16x | 1753.000 | 1.64x | 40.000 | 3000 | 0 | 0 | 0 |
| scene-3d | 10 | vide | 3898.330 | 3642.326–4109.092 | 1.85x | 1277.000 | 1.20x | 41.000 | 3000 | 0 | 0 | 0 |
| derived-diamond | 3 | plain | 10.142 | 9.503–10.391 | 1.00x | 17.000 | 1.00x | 1.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | blend | 85.085 | 71.970–103.983 | 8.39x | 41.000 | 2.41x | 8.000 | 3 | 0 | 0 | 12 |
| derived-diamond | 3 | compose | 35.520 | 34.596–51.092 | 3.50x | 23.000 | 1.35x | 2.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion | 58.761 | 57.446–74.220 | 5.79x | 13.000 | 0.76x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | fusion-charm | 85.265 | 73.270–104.909 | 8.41x | 23.000 | 1.35x | 9.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | react | 296.841 | 266.095–313.923 | 29.27x | 224.000 | 13.18x | 223.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | react-reflex | 341.117 | 324.714–357.089 | 33.63x | 232.000 | 13.65x | 211.000 | 3 | 0 | 3 | 3 |
| derived-diamond | 3 | react-upstream | 281.952 | 269.151–330.410 | 27.80x | 233.000 | 13.71x | 232.000 | 3 | 0 | 0 | 3 |
| derived-diamond | 3 | roact | 63.807 | 47.091–73.104 | 6.29x | 23.000 | 1.35x | 3.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | seam | 45.649 | 44.318–60.758 | 4.50x | 32.000 | 1.88x | 11.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | signals | 27.372 | 26.548–28.230 | 2.70x | 22.000 | 1.29x | 0.000 | 3 | 0 | 0 | 0 |
| derived-diamond | 3 | vide | 24.110 | 22.264–25.205 | 2.38x | 20.000 | 1.18x | 1.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | plain | 55.073 | 48.333–65.548 | 1.00x | 74.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | blend | unsupported: Blend propagates each derived step through a nested task.defer. Roblox limits task.defer re-entrancy to 80 levels, so a 100-step chain raises an engine error. | — | — | — | — | — | — | — | — | — |
| derived-chain-100 | 3 | compose | 180.502 | 172.279–190.587 | 3.28x | 147.000 | 1.99x | 15.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion | 727.867 | 720.205–743.550 | 13.22x | 152.000 | 2.05x | 4.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | fusion-charm | 761.688 | 750.602–813.746 | 13.83x | 154.000 | 2.08x | 13.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | react | 317.498 | 276.897–354.084 | 5.77x | 224.000 | 3.03x | 231.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | react-reflex | 321.925 | 291.048–338.329 | 5.85x | 232.000 | 3.14x | 211.000 | 3 | 0 | 3 | 3 |
| derived-chain-100 | 3 | react-upstream | 300.693 | 275.205–309.336 | 5.46x | 233.000 | 3.15x | 232.000 | 3 | 0 | 0 | 3 |
| derived-chain-100 | 3 | roact | 128.073 | 123.917–135.174 | 2.33x | 23.000 | 0.31x | 3.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | seam | 815.729 | 666.885–2546.237 | 14.81x | 292.000 | 3.95x | 238.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | signals | 176.966 | 170.287–211.138 | 3.21x | 190.000 | 2.57x | 1.000 | 3 | 0 | 0 | 0 |
| derived-chain-100 | 3 | vide | 117.868 | 99.339–129.125 | 2.14x | 108.000 | 1.46x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | plain | 137.702 | 126.013–154.330 | 1.00x | 603.000 | 1.00x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | blend | 465.626 | 421.876–489.015 | 3.38x | 1516.000 | 2.51x | 1.000 | 3 | 0 | 0 | 6 |
| derived-fan-in-1000 | 3 | compose | 530.042 | 488.042–597.480 | 3.85x | 692.000 | 1.15x | 2.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion | 1982.179 | 1786.152–2101.447 | 14.39x | 959.000 | 1.59x | 65.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | fusion-charm | 2097.828 | 1819.407–2130.764 | 15.23x | 2819.000 | 4.67x | 65.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | react | 2266.690 | 2139.898–2408.310 | 16.46x | 1067.000 | 1.77x | 770.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | react-reflex | 6381.490 | 5902.338–6569.424 | 46.34x | 5220.000 | 8.66x | 250.000 | 3 | 0 | 3 | 3 |
| derived-fan-in-1000 | 3 | react-upstream | 2353.480 | 2189.984–2401.390 | 17.09x | 1075.000 | 1.78x | 778.000 | 3 | 0 | 0 | 3 |
| derived-fan-in-1000 | 3 | roact | 1069.132 | 982.278–1093.343 | 7.76x | 117.000 | 0.19x | 3.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | seam | 3140.946 | 2836.544–3207.602 | 22.81x | 2893.000 | 4.80x | 2572.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | signals | 751.265 | 661.432–829.503 | 5.46x | 1255.000 | 2.08x | 0.000 | 3 | 0 | 0 | 0 |
| derived-fan-in-1000 | 3 | vide | 535.084 | 517.604–562.708 | 3.89x | 534.000 | 0.89x | 1.000 | 3 | 0 | 0 | 0 |
| filter-as-you-type | 1 | plain | 5170.765 | 5039.753–5260.896 | 1.00x | 2879.000 | 1.00x | 128.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | blend | 14109.149 | 14082.702–14245.089 | 2.73x | 5465.000 | 1.90x | 128.000 | 6131 | 437 | 0 | 27 |
| filter-as-you-type | 1 | compose | 8572.698 | 8392.242–8682.656 | 1.66x | 3734.000 | 1.30x | 235.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| filter-as-you-type | 1 | react | 15665.621 | 15575.370–15770.279 | 3.03x | 3801.000 | 1.32x | 3792.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | react-reflex | 15647.180 | 15512.339–15714.301 | 3.03x | 3831.000 | 1.33x | 370.000 | 2505 | 437 | 9 | 9 |
| filter-as-you-type | 1 | react-upstream | 15660.108 | 15586.385–15875.728 | 3.03x | 3810.000 | 1.32x | 3801.000 | 2505 | 437 | 0 | 9 |
| filter-as-you-type | 1 | roact | 9066.601 | 8949.415–9099.551 | 1.75x | 3338.000 | 1.16x | 131.000 | 2505 | 437 | 0 | 0 |
| filter-as-you-type | 1 | seam | 20692.654 | 20370.572–20812.950 | 4.00x | 5752.000 | 2.00x | 3757.000 | 2068 | 437 | 874 | 437 |
| filter-as-you-type | 1 | signals | 5138.457 | 5047.539–5230.484 | 0.99x | 2881.000 | 1.00x | 129.000 | 2068 | 437 | 0 | 0 |
| filter-as-you-type | 1 | vide | 8080.700 | 8015.808–8182.555 | 1.56x | 3805.000 | 1.32x | 130.000 | 4690 | 437 | 0 | 0 |
| theme-propagation | 3 | plain | 879.300 | 832.997–945.992 | 1.00x | 5725.000 | 1.00x | 129.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | blend | 2210.430 | 2181.905–2250.188 | 2.51x | 7555.000 | 1.32x | 128.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | compose | 1309.346 | 1285.057–1360.248 | 1.49x | 6200.000 | 1.08x | 257.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion | 4639.094 | 4565.972–4688.334 | 5.28x | 6393.000 | 1.12x | 192.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | fusion-charm | 4735.881 | 4663.623–4788.964 | 5.39x | 6394.000 | 1.12x | 192.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | react | 25099.018 | 24800.381–25622.623 | 28.54x | 10741.000 | 1.88x | 10732.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | react-reflex | 25049.687 | 24198.676–25306.064 | 28.49x | 10757.000 | 1.88x | 402.000 | 3000 | 0 | 3 | 3 |
| theme-propagation | 3 | react-upstream | 25122.450 | 24983.698–25256.310 | 28.57x | 10741.000 | 1.88x | 10732.000 | 3000 | 0 | 0 | 3 |
| theme-propagation | 3 | roact | 13167.274 | 13018.459–13341.381 | 14.97x | 8372.000 | 1.46x | 131.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | seam | 2120.887 | 2062.732–2207.664 | 2.41x | 7143.000 | 1.25x | 160.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | signals | 2504.573 | 2465.963–4646.485 | 2.85x | 6437.000 | 1.12x | 144.000 | 3000 | 0 | 0 | 0 |
| theme-propagation | 3 | vide | 2110.908 | 2082.338–2196.421 | 2.40x | 6148.000 | 1.07x | 145.000 | 3000 | 0 | 0 | 0 |
| hud-per-frame | 1 | plain | 398.914 | 390.741–411.253 | 1.00x | 142.000 | 1.00x | 2.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | blend | 836.646 | 827.632–847.633 | 2.10x | 190.000 | 1.34x | 2.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | compose | 628.041 | 607.530–642.442 | 1.57x | 159.000 | 1.12x | 15.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion | 3922.867 | 3883.779–3938.351 | 9.83x | 181.000 | 1.27x | 12.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | fusion-charm | 5241.103 | 5059.948–5301.795 | 13.14x | 210.000 | 1.48x | 4.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | react | 494.349 | 483.662–517.914 | 1.24x | 401.000 | 2.82x | 251.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | react-reflex | 1468.453 | 1374.681–1479.720 | 3.68x | 421.000 | 2.96x | 253.000 | 1200 | 0 | 60 | 0 |
| hud-per-frame | 1 | react-upstream | 550.664 | 534.008–578.556 | 1.38x | 401.000 | 2.82x | 252.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | roact | 564.966 | 557.905–575.852 | 1.42x | 208.000 | 1.46x | 2.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | seam | 2367.033 | 2334.914–2402.687 | 5.93x | 263.000 | 1.85x | 17.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | signals | 1252.676 | 1216.811–1304.394 | 3.14x | 185.000 | 1.30x | 3.000 | 1200 | 0 | 0 | 0 |
| hud-per-frame | 1 | vide | 740.120 | 723.765–753.791 | 1.86x | 144.000 | 1.01x | 0.000 | 1200 | 0 | 0 | 60 |
| teardown-under-load | 1 | plain | 14233.432 | 13237.079–15346.270 | 1.00x | 274.000 | 1.00x | 256.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | blend | 35331.687 | 34523.899–39816.786 | 2.48x | 275.000 | 1.00x | 256.000 | 22003 | 2001 | 0 | 4 |
| teardown-under-load | 1 | compose | 22857.342 | 21977.877–23501.292 | 1.61x | 533.000 | 1.95x | 514.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion | 47677.582 | 45845.986–49712.299 | 3.35x | 401.000 | 1.46x | 384.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | fusion-charm | 48296.026 | 45976.152–50621.326 | 3.39x | 404.000 | 1.47x | 385.000 | 22003 | 2001 | 0 | 0 |
| teardown-under-load | 1 | react | 26255.229 | 24295.041–28077.541 | 1.84x | 1583.000 | 5.78x | 651.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | react-reflex | 25976.121 | 24256.423–29030.968 | 1.83x | 1591.000 | 5.81x | 658.000 | 10000 | 2001 | 6 | 2 |
| teardown-under-load | 1 | react-upstream | 25977.616 | 24877.155–28960.474 | 1.83x | 1592.000 | 5.81x | 660.000 | 10000 | 2001 | 0 | 2 |
| teardown-under-load | 1 | roact | 27863.857 | 25881.179–29852.934 | 1.96x | 340.000 | 1.24x | 256.000 | 10001 | 2001 | 0 | 0 |
| teardown-under-load | 1 | seam | 70825.442 | 32348.403–78187.903 | 4.98x | 343.000 | 1.25x | 327.000 | 8000 | 2001 | 4000 | 2000 |
| teardown-under-load | 1 | signals | 20852.609 | 19666.063–21637.074 | 1.47x | 306.000 | 1.12x | 288.000 | 8000 | 2001 | 0 | 0 |
| teardown-under-load | 1 | vide | 25043.913 | 23272.272–27269.195 | 1.76x | 306.000 | 1.12x | 289.000 | 20003 | 2001 | 0 | 6 |
| open-close-retention | 1 | plain | 30229.982 | 29663.331–33253.248 | 1.00x | 1042.000 | 1.00x | 1024.000 | 20000 | 5010 | 0 | 0 |
| open-close-retention | 1 | blend | 76659.406 | 73818.866–78564.179 | 2.54x | 531.000 | 0.51x | 512.000 | 55030 | 5010 | 0 | 40 |
| open-close-retention | 1 | compose | 50068.816 | 47740.421–54964.223 | 1.66x | 1108.000 | 1.06x | 1098.000 | 20000 | 5010 | 0 | 0 |
| open-close-retention | 1 | fusion | 80637.824 | 79773.255–82404.834 | 2.67x | 658.000 | 0.63x | 640.000 | 55030 | 5010 | 0 | 0 |
| open-close-retention | 1 | fusion-charm | 80834.616 | 80433.001–81088.660 | 2.67x | 787.000 | 0.76x | 769.000 | 55030 | 5010 | 0 | 0 |
| open-close-retention | 1 | react | 57978.057 | 57053.893–59273.617 | 1.92x | 1011.000 | 0.97x | 752.000 | 25000 | 5010 | 0 | 20 |
| open-close-retention | 1 | react-reflex | 57764.239 | 56592.707–59099.822 | 1.91x | 763.000 | 0.73x | 512.000 | 25000 | 5010 | 60 | 20 |
| open-close-retention | 1 | react-upstream | 57896.504 | 57103.289–58753.946 | 1.92x | 764.000 | 0.73x | 513.000 | 25000 | 5010 | 0 | 20 |
| open-close-retention | 1 | roact | 59314.894 | 58324.845–59728.548 | 1.96x | 548.000 | 0.53x | 513.000 | 25010 | 5010 | 0 | 0 |
| open-close-retention | 1 | seam | 71754.501 | 67072.384–76114.188 | 2.37x | 551.000 | 0.53x | 535.000 | 20000 | 5010 | 10000 | 5000 |
| open-close-retention | 1 | signals | 43688.140 | 42339.767–48705.429 | 1.45x | 282.000 | 0.27x | 265.000 | 20000 | 5010 | 0 | 0 |
| open-close-retention | 1 | vide | 47371.137 | 46385.987–50394.812 | 1.57x | 539.000 | 0.52x | 521.000 | 50030 | 5010 | 0 | 60 |
| tree-expand-collapse | 1 | plain | 4837.988 | 4756.587–4962.372 | 1.00x | 217.000 | 1.00x | 128.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | blend | 15970.166 | 15850.649–16085.875 | 3.30x | 858.000 | 3.95x | 128.000 | 7040 | 630 | 0 | 21 |
| tree-expand-collapse | 1 | compose | 9074.654 | 9004.643–9129.887 | 1.88x | 354.000 | 1.63x | 230.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| tree-expand-collapse | 1 | react | 13491.782 | 13415.656–13622.483 | 2.79x | 1026.000 | 4.73x | 1016.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | react-reflex | 13527.391 | 13461.498–13712.921 | 2.80x | 1046.000 | 4.82x | 370.000 | 2389 | 630 | 7 | 7 |
| tree-expand-collapse | 1 | react-upstream | 13472.305 | 13425.395–13615.501 | 2.78x | 1026.000 | 4.73x | 1032.000 | 2389 | 630 | 0 | 7 |
| tree-expand-collapse | 1 | roact | 7010.190 | 6982.254–7104.413 | 1.45x | 232.000 | 1.07x | 131.000 | 2389 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | seam | 19179.244 | 19019.361–21218.661 | 3.96x | 339.000 | 1.56x | 265.000 | 1759 | 630 | 1260 | 630 |
| tree-expand-collapse | 1 | signals | 4722.967 | 4686.560–5046.884 | 0.98x | 219.000 | 1.01x | 128.000 | 1759 | 630 | 0 | 0 |
| tree-expand-collapse | 1 | vide | 7567.580 | 7484.138–7687.690 | 1.56x | 269.000 | 1.24x | 130.000 | 5539 | 630 | 0 | 0 |
| form-validation | 1 | plain | 487.803 | 475.370–504.985 | 1.00x | 289.000 | 1.00x | 4.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | blend | 814.725 | 797.022–852.275 | 1.67x | 574.000 | 1.99x | 4.000 | 129 | 0 | 0 | 172 |
| form-validation | 1 | compose | 611.174 | 587.650–626.542 | 1.25x | 340.000 | 1.18x | 21.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | fusion | 1859.722 | 1836.568–1882.434 | 3.81x | 363.000 | 1.26x | 16.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | fusion-charm | 2064.605 | 2029.990–2108.757 | 4.23x | 399.000 | 1.38x | 16.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | react | 10464.179 | 10403.596–10882.493 | 21.45x | 600.000 | 2.08x | 224.000 | 126 | 0 | 0 | 44 |
| form-validation | 1 | react-reflex | 11632.728 | 11535.545–11711.165 | 23.85x | 696.000 | 2.41x | 255.000 | 126 | 0 | 44 | 43 |
| form-validation | 1 | react-upstream | 11086.916 | 10550.691–11360.468 | 22.73x | 608.000 | 2.10x | 226.000 | 126 | 0 | 0 | 44 |
| form-validation | 1 | roact | 5829.203 | 5630.320–5982.559 | 11.95x | 296.000 | 1.02x | 7.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | seam | 2166.696 | 2096.395–2230.726 | 4.44x | 519.000 | 1.80x | 199.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | signals | 698.167 | 667.680–720.008 | 1.43x | 399.000 | 1.38x | 12.000 | 126 | 0 | 0 | 0 |
| form-validation | 1 | vide | 513.731 | 487.022–552.885 | 1.05x | 312.000 | 1.08x | 13.000 | 126 | 0 | 0 | 0 |
| table-sort-filter | 1 | plain | 13320.290 | 13080.198–13478.247 | 1.00x | 5748.000 | 1.00x | 256.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | blend | 28501.178 | 27731.649–33395.830 | 2.14x | 10946.000 | 1.90x | 257.000 | 12157 | 937 | 0 | 18 |
| table-sort-filter | 1 | compose | 21656.076 | 21325.634–23734.279 | 1.63x | 7425.000 | 1.29x | 435.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — | — |
| table-sort-filter | 1 | react | 66656.461 | 66462.690–66845.311 | 5.00x | 7911.000 | 1.38x | 526.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | react-reflex | 66738.738 | 66343.035–67154.736 | 5.01x | 7911.000 | 1.38x | 531.000 | 5594 | 937 | 6 | 6 |
| table-sort-filter | 1 | react-upstream | 67010.997 | 66630.208–67485.509 | 5.03x | 7912.000 | 1.38x | 535.000 | 5594 | 937 | 0 | 6 |
| table-sort-filter | 1 | roact | 19191.870 | 19112.720–19823.369 | 1.44x | 6669.000 | 1.16x | 259.000 | 5594 | 937 | 0 | 0 |
| table-sort-filter | 1 | seam | 51299.554 | 49057.367–55722.947 | 3.85x | 11485.000 | 2.00x | 7481.000 | 4657 | 937 | 1874 | 937 |
| table-sort-filter | 1 | signals | 13174.489 | 12980.258–14108.074 | 0.99x | 5757.000 | 1.00x | 257.000 | 4657 | 937 | 0 | 0 |
| table-sort-filter | 1 | vide | 18425.337 | 17694.435–20091.976 | 1.38x | 7604.000 | 1.32x | 257.000 | 10279 | 937 | 0 | 0 |
| library-load | 1 | plain | 17.267 | 15.125–38.379 | 1.00x | 8.000 | 1.00x | 0.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | blend | 1459.858 | 1350.679–1536.412 | 84.55x | 380.000 | 47.50x | 370.000 | 3 | 1 | 0 | 0 |
| library-load | 1 | compose | 1743.647 | 1396.724–1998.899 | 100.98x | 381.000 | 47.62x | 371.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | fusion | 2237.517 | 2093.856–2429.668 | 129.58x | 182.000 | 22.75x | 174.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | fusion-charm | 2333.851 | 2134.216–2615.103 | 135.16x | 222.000 | 27.75x | 214.000 | 3 | 2 | 0 | 0 |
| library-load | 1 | react | 8467.640 | 7434.372–9328.538 | 490.39x | 1420.000 | 177.50x | 1411.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | react-reflex | 8402.899 | 7649.221–11712.245 | 486.64x | 1542.000 | 192.75x | 1533.000 | 0 | 3 | 0 | 1 |
| library-load | 1 | react-upstream | 17005.526 | 15828.993–17899.135 | 984.86x | 1412.000 | 176.50x | 1403.000 | 0 | 1 | 0 | 1 |
| library-load | 1 | roact | 1689.421 | 1556.746–2709.573 | 97.84x | 129.000 | 16.12x | 119.000 | 1 | 1 | 0 | 0 |
| library-load | 1 | seam | 2934.940 | 2767.878–3164.076 | 169.97x | 189.000 | 23.62x | 180.000 | 0 | 3 | 0 | 0 |
| library-load | 1 | signals | 513.730 | 472.659–550.894 | 29.75x | 34.000 | 4.25x | 25.000 | 0 | 1 | 0 | 0 |
| library-load | 1 | vide | 665.079 | 617.172–714.030 | 38.52x | 106.000 | 13.25x | 97.000 | 3 | 1 | 1 | 0 |
| rows-append-1000 | 1 | plain | 62569.805 | 42294.385–74142.736 | 1.00x | 74434.000 | 1.00x | 2049.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | blend | 91353.484 | 86317.436–145341.297 | 1.46x | 103614.000 | 1.39x | 2057.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | compose | 98185.420 | 56519.606–169912.083 | 1.57x | 76714.000 | 1.03x | 3257.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion | 314284.378 | 294784.614–354924.614 | 5.02x | 88349.000 | 1.19x | 4098.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | fusion-charm | 320397.511 | 303428.165–371784.493 | 5.12x | 95858.000 | 1.29x | 4099.000 | 43000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | react | 130069.688 | 112998.983–163831.935 | 2.08x | 96685.000 | 1.30x | 10989.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | react-reflex | 164746.224 | 123895.782–259510.386 | 2.63x | 100406.000 | 1.35x | 12957.000 | 15000 | 5000 | 2001 | 1 |
| rows-append-1000 | 1 | react-upstream | 141765.508 | 106453.443–175898.630 | 2.27x | 96678.000 | 1.30x | 10990.000 | 15000 | 5000 | 2000 | 1 |
| rows-append-1000 | 1 | roact | 113968.046 | 91000.648–161854.096 | 1.82x | 97451.000 | 1.31x | 2057.000 | 15000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | seam | 122943.794 | 109851.582–272917.357 | 1.96x | 100851.000 | 1.35x | 35531.000 | 11000 | 5000 | 8000 | 3000 |
| rows-append-1000 | 1 | signals | 53827.313 | 46949.923–138555.276 | 0.86x | 83451.000 | 1.12x | 2057.000 | 10000 | 5000 | 2000 | 0 |
| rows-append-1000 | 1 | vide | 64137.344 | 53111.342–96697.380 | 1.03x | 77074.000 | 1.04x | 2058.000 | 39000 | 5000 | 2000 | 0 |
| rows-clear | 1 | plain | 13107.147 | 11404.944–14542.819 | 1.00x | 3223.000 | 1.00x | 1025.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | blend | 35468.161 | 33743.992–39455.237 | 2.71x | 4135.000 | 1.28x | 1025.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | compose | 24905.585 | 23175.661–25758.390 | 1.90x | 3345.000 | 1.04x | 1652.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion | 104103.921 | 100911.509–111348.275 | 7.94x | 5369.000 | 1.67x | 2050.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | fusion-charm | 102514.045 | 99565.485–107156.999 | 7.82x | 9128.000 | 2.83x | 2049.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | react | 17372.231 | 14723.085–18554.675 | 1.33x | 6236.000 | 1.93x | 1870.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | react-reflex | 18102.832 | 15999.412–19220.889 | 1.38x | 8095.000 | 2.51x | 1938.000 | 0 | 0 | 1 | 1 |
| rows-clear | 1 | react-upstream | 17234.406 | 14994.254–18883.988 | 1.31x | 6237.000 | 1.94x | 1871.000 | 0 | 0 | 0 | 1 |
| rows-clear | 1 | roact | 18821.756 | 16590.909–21187.543 | 1.44x | 5109.000 | 1.59x | 1025.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | seam | 74329.449 | 67038.580–77835.502 | 5.67x | 9571.000 | 2.97x | 1165.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | signals | 14626.371 | 12570.865–14959.261 | 1.12x | 5277.000 | 1.64x | 1025.000 | 0 | 0 | 0 | 0 |
| rows-clear | 1 | vide | 16877.733 | 15041.370–17551.130 | 1.29x | 2622.000 | 0.81x | 1026.000 | 0 | 0 | 0 | 0 |
| rows-create-1000 | 1 | plain | 54639.661 | 48482.951–67486.319 | 1.00x | 37219.000 | 1.00x | 1032.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | blend | 126553.576 | 119164.169–133527.527 | 2.32x | 51805.000 | 1.39x | 1032.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | compose | 87483.710 | 74613.017–100343.585 | 1.60x | 38375.000 | 1.03x | 1652.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion | 230894.370 | 222509.528–236995.031 | 4.23x | 44155.000 | 1.19x | 2049.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | fusion-charm | 226939.851 | 221432.094–231578.554 | 4.15x | 47907.000 | 1.29x | 2049.000 | 43000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | react | 134030.315 | 129699.688–138934.761 | 2.45x | 44732.000 | 1.20x | 5597.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | react-reflex | 148313.467 | 139578.706–152920.594 | 2.71x | 46600.000 | 1.25x | 6587.000 | 15000 | 5000 | 2001 | 1 |
| rows-create-1000 | 1 | react-upstream | 130754.526 | 120718.260–148438.462 | 2.39x | 44741.000 | 1.20x | 5598.000 | 15000 | 5000 | 2000 | 1 |
| rows-create-1000 | 1 | roact | 102457.943 | 99990.516–107860.662 | 1.88x | 48738.000 | 1.31x | 1025.000 | 15000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | seam | 135996.341 | 129753.209–149940.816 | 2.49x | 50418.000 | 1.35x | 17773.000 | 11000 | 5000 | 8000 | 3000 |
| rows-create-1000 | 1 | signals | 82823.566 | 78069.028–86598.330 | 1.52x | 41721.000 | 1.12x | 1033.000 | 10000 | 5000 | 2000 | 0 |
| rows-create-1000 | 1 | vide | 78153.725 | 63805.021–90753.797 | 1.43x | 38493.000 | 1.03x | 1026.000 | 39000 | 5000 | 2000 | 0 |
| rows-create-10000 | 1 | plain | 547077.024 | 525983.572–661946.654 | 1.00x | 371214.000 | 1.00x | 8204.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | blend | 1355595.988 | 1305816.685–1422956.055 | 2.48x | 516951.000 | 1.39x | 8205.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | compose | 889353.520 | 802562.362–947823.202 | 1.63x | 381984.000 | 1.03x | 15419.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion | 14168010.743 | 13637728.837–14275993.914 | 25.90x | 438758.000 | 1.18x | 16409.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | fusion-charm | 14432198.547 | 14182703.828–16253478.102 | 26.38x | 476283.000 | 1.28x | 16408.000 | 430000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | react | 6460409.180 | 5925839.936–6570748.975 | 11.81x | 443473.000 | 1.19x | 51937.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | react-reflex | 6956155.196 | 6352874.439–7619896.441 | 12.72x | 462696.000 | 1.25x | 62128.000 | 150000 | 50000 | 20001 | 1 |
| rows-create-10000 | 1 | react-upstream | 6511101.292 | 5998041.961–6914252.430 | 11.90x | 443474.000 | 1.19x | 51858.000 | 150000 | 50000 | 20000 | 1 |
| rows-create-10000 | 1 | roact | 1072072.497 | 1034899.385–1104080.085 | 1.96x | 485749.000 | 1.31x | 8212.000 | 150000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | seam | 1439558.941 | 1385571.060–1580606.984 | 2.63x | 503854.000 | 1.36x | 176287.000 | 110000 | 50000 | 80000 | 30000 |
| rows-create-10000 | 1 | signals | 756074.366 | 730422.349–832010.663 | 1.38x | 415337.000 | 1.12x | 8204.000 | 100000 | 50000 | 20000 | 0 |
| rows-create-10000 | 1 | vide | 840728.080 | 730728.660–876234.150 | 1.54x | 383890.000 | 1.03x | 8205.000 | 390000 | 50000 | 20000 | 0 |
| rows-remove-one | 1 | plain | 1771.506 | 1488.957–1976.780 | 1.00x | 37210.000 | 1.00x | 1032.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | blend | 2563.688 | 2410.842–2642.946 | 1.45x | 51782.000 | 1.39x | 1025.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | compose | 1935.402 | 1535.725–2063.391 | 1.09x | 38381.000 | 1.03x | 1670.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | fusion | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | fusion-charm | unsupported: At the pinned release, ForValues can give a removed row's scope to a retained row. The retained Frame and its children do not keep their Instance identity. | — | — | — | — | — | — | — | — | — |
| rows-remove-one | 1 | react | 43094.960 | 40892.157–45716.717 | 24.33x | 52125.000 | 1.40x | 5593.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | react-reflex | 47083.341 | 44041.084–52625.143 | 26.58x | 53983.000 | 1.45x | 6582.000 | 500 | 0 | 1 | 1 |
| rows-remove-one | 1 | react-upstream | 42425.674 | 39946.925–48594.098 | 23.95x | 52143.000 | 1.40x | 5602.000 | 500 | 0 | 0 | 1 |
| rows-remove-one | 1 | roact | 41844.076 | 38698.218–44583.895 | 23.62x | 48696.000 | 1.31x | 1025.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | seam | 9612.992 | 9143.103–10286.442 | 5.43x | 50425.000 | 1.36x | 17757.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | signals | 2565.461 | 1842.197–2999.103 | 1.45x | 41740.000 | 1.12x | 1033.000 | 500 | 0 | 0 | 0 |
| rows-remove-one | 1 | vide | 2073.110 | 1875.390–2341.633 | 1.17x | 38545.000 | 1.04x | 1034.000 | 500 | 0 | 0 | 0 |
| rows-swap | 1 | plain | 517.562 | 475.760–560.066 | 1.00x | 37227.000 | 1.00x | 1032.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | blend | 1131.987 | 1082.514–1179.830 | 2.19x | 51821.000 | 1.39x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | compose | 585.573 | 538.633–641.627 | 1.13x | 38391.000 | 1.03x | 1652.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion | 60847.207 | 60555.512–62217.744 | 117.57x | 44202.000 | 1.19x | 2049.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | fusion-charm | 60754.114 | 60388.099–62686.206 | 117.39x | 47955.000 | 1.29x | 2050.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | react | 46992.420 | 42234.847–50086.804 | 90.80x | 52163.000 | 1.40x | 5589.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | react-reflex | 56653.768 | 51715.874–58056.559 | 109.46x | 54053.000 | 1.45x | 6587.000 | 2 | 0 | 1 | 1 |
| rows-swap | 1 | react-upstream | 48322.754 | 42801.622–48992.303 | 93.37x | 52148.000 | 1.40x | 5598.000 | 2 | 0 | 0 | 1 |
| rows-swap | 1 | roact | 25340.966 | 24442.740–28309.105 | 48.96x | 48738.000 | 1.31x | 1017.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | seam | 5932.065 | 5589.815–6108.679 | 11.46x | 50435.000 | 1.35x | 17757.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | signals | 756.999 | 666.875–810.258 | 1.46x | 41744.000 | 1.12x | 1025.000 | 2 | 0 | 0 | 0 |
| rows-swap | 1 | vide | 254.239 | 223.213–275.621 | 0.49x | 38532.000 | 1.04x | 1026.000 | 2 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | plain | 194.541 | 162.967–244.384 | 1.00x | 37213.000 | 1.00x | 1032.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | blend | 385.178 | 322.821–449.038 | 1.98x | 51828.000 | 1.39x | 1025.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | compose | 287.004 | 244.036–341.914 | 1.48x | 38378.000 | 1.03x | 1678.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion | 510.858 | 403.294–797.944 | 2.63x | 44172.000 | 1.19x | 2049.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | fusion-charm | 749.594 | 605.414–814.966 | 3.85x | 47926.000 | 1.29x | 2051.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react | 231.476 | 186.497–265.652 | 1.19x | 44753.000 | 1.20x | 5598.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | react-reflex | 814.083 | 700.870–1038.702 | 4.18x | 46620.000 | 1.25x | 6587.000 | 100 | 0 | 1 | 0 |
| rows-update-every-10th | 1 | react-upstream | 244.558 | 174.336–284.498 | 1.26x | 44746.000 | 1.20x | 5598.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | roact | 322.431 | 248.769–385.455 | 1.66x | 48740.000 | 1.31x | 1032.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | seam | 1892.494 | 1643.517–2168.201 | 9.73x | 50442.000 | 1.36x | 1159.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | signals | 378.255 | 307.989–468.871 | 1.94x | 41740.000 | 1.12x | 1027.000 | 100 | 0 | 0 | 0 |
| rows-update-every-10th | 1 | vide | 284.345 | 260.122–348.672 | 1.46x | 38528.000 | 1.04x | 1035.000 | 100 | 0 | 0 | 0 |

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
| teardown-under-load | vide | 288.000 |
| open-close-retention | plain | 1024.000 |
| open-close-retention | blend | 512.000 |
| open-close-retention | compose | 1080.000 |
| open-close-retention | fusion | 640.000 |
| open-close-retention | fusion-charm | 768.000 |
| open-close-retention | react | 790.000 |
| open-close-retention | react-reflex | 534.000 |
| open-close-retention | react-upstream | 534.000 |
| open-close-retention | roact | 528.000 |
| open-close-retention | seam | 531.000 |
| open-close-retention | signals | 264.000 |
| open-close-retention | vide | 521.000 |

## Summary

This summary uses the 30 selected workloads and treats time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. A workload whose plain heap is zero has no heap ratio. Lanes support different workloads, so compare a geometric mean only together with its measured count.

The shared columns use only the workloads that every lane measured: 22 for time (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-swap`, `rows-update-every-10th`) and 22 for heap (`update-leaf`, `update-batched`, `update-repeated`, `branch-swap`, `keyed-shuffle`, `events`, `status-panel`, `scene-3d`, `derived-diamond`, `derived-fan-in-1000`, `theme-propagation`, `hud-per-frame`, `teardown-under-load`, `open-close-retention`, `form-validation`, `library-load`, `rows-append-1000`, `rows-clear`, `rows-create-1000`, `rows-create-10000`, `rows-swap`, `rows-update-every-10th`).

| Framework | Supported | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain | 30 | 30 | 1.00x | 1.00x | 1.00x | 1.00x |
| blend | 29 | 29 | 3.30x | 1.71x | 3.45x | 1.64x |
| compose | 30 | 30 | 2.34x | 1.43x | 2.44x | 1.44x |
| fusion | 24 | 24 | 10.19x | 1.44x | 9.22x | 1.40x |
| fusion-charm | 24 | 24 | 10.04x | 1.67x | 9.06x | 1.65x |
| react | 29 | 29 | 6.99x | 2.90x | 7.24x | 3.31x |
| react-reflex | 29 | 29 | 8.47x | 3.08x | 9.26x | 3.58x |
| react-upstream | 29 | 29 | 7.27x | 2.88x | 7.64x | 3.28x |
| roact | 29 | 29 | 4.02x | 1.21x | 4.32x | 1.29x |
| seam | 30 | 30 | 6.03x | 1.83x | 5.77x | 1.75x |
| signals | 29 | 29 | 2.03x | 1.20x | 2.37x | 1.21x |
| vide | 30 | 30 | 2.03x | 1.21x | 2.10x | 1.18x |

## Source identities

Harness revision: `c77fc4151c8459e6f6e922913b9d71805b16c776`. Full source state, tools, environment and command are in `context.json`.

| Dependency | Version | Commit | Tree | Rights |
| --- | --- | --- | --- | --- |
| compose | unreleased | `713ba9226e2157a0365ab52a209292fc53d4ae9c` | `7e99170bd964f019832aa4465e8df3b91b633c70` | MIT |
| facet | 0.12.0 | `265536b907f76f9fd8f4c7fdcb7a958c2c44a8f4` | `522b89fbe56830ffcac8d5e364157d95941e5696` | MIT |
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
