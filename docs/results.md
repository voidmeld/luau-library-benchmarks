# Headless results

Harness commit: `688d482bab458186b251625ccad29a686747cf5c`. Workflow run: [Library comparison 40921659782](https://github.com/voidmeld/luau-library-benchmarks/actions/runs/40921659782). Runner: `ubuntu-latest`. Mode: `like-for-like`.

The content below is the `comparison.md` file of the `scene-composition-comparison` artifact of that run. Read the [method](method.md) before you compare two lanes.

Comparison mode: **like-for-like**. All parity and measurement checks passed. Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.

# Scene composition library comparison

Headless cost-model samples. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.

| Workload | Iterations | Framework | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| cold-mount-100 | 1 | plain | 1145.472 | 1.00x | 548.000 | 1.00x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | blend | 1658.558 | 1.45x | 697.000 | 1.27x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | compose | 1206.357 | 1.05x | 558.000 | 1.02x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion | 1283.361 | 1.12x | 564.000 | 1.03x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | fusion-charm | 1241.002 | 1.08x | 564.000 | 1.03x | 0.000 | 803 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react | 1442.835 | 1.26x | 606.000 | 1.11x | 9.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-reflex | 1698.747 | 1.48x | 614.000 | 1.12x | 9.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | react-upstream | 1529.055 | 1.33x | 614.000 | 1.12x | 1.000 | 200 | 101 | 0 | 0 |
| cold-mount-100 | 1 | roact | 1191.003 | 1.04x | 654.000 | 1.19x | 0.000 | 201 | 101 | 0 | 0 |
| cold-mount-100 | 1 | seam | 964.809 | 0.84x | 569.000 | 1.04x | 0.000 | 100 | 101 | 1 | 0 |
| cold-mount-100 | 1 | signals | 874.345 | 0.76x | 567.000 | 1.03x | 0.000 | 100 | 101 | 0 | 0 |
| cold-mount-100 | 1 | vide | 1189.515 | 1.04x | 555.000 | 1.01x | 0.000 | 703 | 101 | 0 | 0 |
| cold-mount-1000 | 1 | plain | 8247.727 | 1.00x | 5478.000 | 1.00x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | blend | 15556.031 | 1.89x | 6856.000 | 1.25x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | compose | 9770.425 | 1.18x | 5488.000 | 1.00x | 8.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion | 9785.344 | 1.19x | 5528.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | fusion-charm | 10844.464 | 1.31x | 5528.000 | 1.01x | 0.000 | 8003 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react | 12608.787 | 1.53x | 5986.000 | 1.09x | 9.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-reflex | 13784.715 | 1.67x | 5978.000 | 1.09x | 1.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | react-upstream | 14120.248 | 1.71x | 5986.000 | 1.09x | 9.000 | 2000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | roact | 12062.601 | 1.46x | 6452.000 | 1.18x | 0.000 | 2001 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | seam | 9870.493 | 1.20x | 5554.000 | 1.01x | 0.000 | 1000 | 1001 | 1 | 0 |
| cold-mount-1000 | 1 | signals | 9388.414 | 1.14x | 5508.000 | 1.01x | 0.000 | 1000 | 1001 | 0 | 0 |
| cold-mount-1000 | 1 | vide | 10576.963 | 1.28x | 5462.000 | 1.00x | 0.000 | 7003 | 1001 | 0 | 0 |
| cold-mount-10000 | 1 | plain | 83528.840 | 1.00x | 54980.000 | 1.00x | 1.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | blend | 169346.597 | 2.03x | 68713.000 | 1.25x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | compose | 106642.913 | 1.28x | 55082.000 | 1.00x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion | 104889.819 | 1.26x | 55714.000 | 1.01x | 0.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | fusion-charm | 107688.171 | 1.29x | 55722.000 | 1.01x | 8.000 | 80003 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react | 154948.616 | 1.86x | 59844.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-reflex | 136960.173 | 1.64x | 59845.000 | 1.09x | 9.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | react-upstream | 163652.171 | 1.96x | 59836.000 | 1.09x | 1.000 | 20000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | roact | 113714.737 | 1.36x | 64847.000 | 1.18x | 0.000 | 20001 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | seam | 97315.480 | 1.17x | 56108.000 | 1.02x | 0.000 | 10000 | 10001 | 1 | 0 |
| cold-mount-10000 | 1 | signals | 107930.484 | 1.29x | 55293.000 | 1.01x | 0.000 | 10000 | 10001 | 0 | 0 |
| cold-mount-10000 | 1 | vide | 101047.461 | 1.21x | 54824.000 | 1.00x | 0.000 | 70003 | 10001 | 0 | 0 |
| mount-dispose | 5 | plain | 11496.010 | 1.00x | 9.000 | 1.00x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | blend | 21959.685 | 1.91x | 1.000 | 0.11x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | compose | 12405.133 | 1.08x | 1.000 | 0.11x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion | 14681.019 | 1.28x | 1.000 | 0.11x | 1.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | fusion-charm | 15426.443 | 1.34x | 1.000 | 0.11x | 0.000 | 8015 | 1005 | 0 | 0 |
| mount-dispose | 5 | react | 16170.192 | 1.41x | 0.000 | 0.00x | 0.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-reflex | 16615.089 | 1.45x | 5.000 | 0.56x | 4.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | react-upstream | 16435.921 | 1.43x | 4.000 | 0.44x | 3.000 | 2000 | 1005 | 0 | 0 |
| mount-dispose | 5 | roact | 14689.231 | 1.28x | 1.000 | 0.11x | 0.000 | 2005 | 1005 | 0 | 0 |
| mount-dispose | 5 | seam | 12077.006 | 1.05x | 1.000 | 0.11x | 0.000 | 1000 | 1005 | 5 | 0 |
| mount-dispose | 5 | signals | 9859.637 | 0.86x | 1.000 | 0.11x | 0.000 | 1000 | 1005 | 0 | 0 |
| mount-dispose | 5 | vide | 11538.574 | 1.00x | 0.000 | 0.00x | 0.000 | 7015 | 1005 | 0 | 0 |
| update-leaf | 50 | plain | 29.225 | 1.00x | 2745.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | blend | 86.536 | 2.96x | 3436.000 | 1.25x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | compose | 95.774 | 3.28x | 2755.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion | 155.977 | 5.34x | 2764.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | fusion-charm | 250.779 | 8.58x | 2774.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react | 72.381 | 2.48x | 2994.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | react-reflex | 144.961 | 4.96x | 3003.000 | 1.09x | 1.000 | 50 | 0 | 50 | 0 |
| update-leaf | 50 | react-upstream | 74.865 | 2.56x | 2994.000 | 1.09x | 1.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | roact | 62.698 | 2.15x | 3230.000 | 1.18x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | seam | 152.179 | 5.21x | 2777.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | signals | 98.023 | 3.35x | 2770.000 | 1.01x | 0.000 | 50 | 0 | 0 | 0 |
| update-leaf | 50 | vide | 84.198 | 2.88x | 2738.000 | 1.00x | 0.000 | 50 | 0 | 0 | 0 |
| update-fanout | 20 | plain | 1344.932 | 1.00x | 1651.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | blend | 4551.423 | 3.38x | 2241.000 | 1.36x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | compose | 2797.817 | 2.08x | 1804.000 | 1.09x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion | 10750.715 | 7.99x | 1893.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | fusion-charm | 10936.262 | 8.13x | 1895.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react | 2242.130 | 1.67x | 1925.000 | 1.17x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | react-reflex | 2345.232 | 1.74x | 1918.000 | 1.16x | 0.000 | 6000 | 0 | 20 | 0 |
| update-fanout | 20 | react-upstream | 2296.370 | 1.71x | 1925.000 | 1.17x | 1.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | roact | 2891.774 | 2.15x | 2062.000 | 1.25x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | seam | 4556.063 | 3.39x | 2152.000 | 1.30x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | signals | 5520.644 | 4.10x | 1901.000 | 1.15x | 0.000 | 6000 | 0 | 0 | 0 |
| update-fanout | 20 | vide | 4697.295 | 3.49x | 1814.000 | 1.10x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | plain | 1354.801 | 1.00x | 1651.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | blend | 6951.898 | 5.13x | 2518.000 | 1.53x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | compose | 4802.412 | 3.54x | 1962.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion | 14400.292 | 10.63x | 2129.000 | 1.29x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | fusion-charm | 25035.510 | 18.48x | 2698.000 | 1.63x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react | 3956.661 | 2.92x | 2096.000 | 1.27x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | react-reflex | 71866.987 | 53.05x | 2379.000 | 1.44x | 1.000 | 6000 | 0 | 20 | 0 |
| update-batched | 20 | react-upstream | 4009.711 | 2.96x | 2105.000 | 1.27x | 1.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | roact | 5006.473 | 3.70x | 2522.000 | 1.53x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | seam | 9202.413 | 6.79x | 2935.000 | 1.78x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | signals | 7657.967 | 5.65x | 2223.000 | 1.35x | 0.000 | 6000 | 0 | 0 | 0 |
| update-batched | 20 | vide | 6103.022 | 4.50x | 1952.000 | 1.18x | 0.000 | 6000 | 0 | 0 | 0 |
| update-repeated | 10 | plain | 48.541 | 1.00x | 14.000 | 1.00x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | blend | 4417.252 | 91.00x | 21.000 | 1.50x | 0.000 | 10 | 0 | 0 | 10 |
| update-repeated | 10 | compose | 781.641 | 16.10x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | fusion | 24435.793 | 503.41x | 17.000 | 1.21x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | fusion-charm | 1228.425 | 25.31x | 20.000 | 1.43x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react | 9041.962 | 186.27x | 5.000 | 0.36x | 5.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | react-reflex | 1841.480 | 37.94x | 17.000 | 1.21x | 2.000 | 10 | 0 | 10 | 0 |
| update-repeated | 10 | react-upstream | 8411.836 | 173.29x | 4.000 | 0.29x | 4.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | roact | 3071.789 | 63.28x | 10.000 | 0.71x | 0.000 | 5000 | 0 | 0 | 0 |
| update-repeated | 10 | seam | 2589.899 | 53.35x | 25.000 | 1.79x | 1.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | signals | 1160.158 | 23.90x | 17.000 | 1.21x | 0.000 | 10 | 0 | 0 | 0 |
| update-repeated | 10 | vide | 560.768 | 11.55x | 15.000 | 1.07x | 0.000 | 10 | 0 | 0 | 0 |
| branch-swap | 20 | plain | 3978.763 | 1.00x | 28.000 | 1.00x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | blend | 10277.791 | 2.58x | 38.000 | 1.36x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | compose | 6359.299 | 1.60x | 24.000 | 0.86x | 0.000 | 500 | 510 | 0 | 0 |
| branch-swap | 20 | fusion | 6346.756 | 1.60x | 23.000 | 0.82x | 1.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | fusion-charm | 6578.529 | 1.65x | 18.000 | 0.64x | 0.000 | 4030 | 510 | 0 | 0 |
| branch-swap | 20 | react | 8697.898 | 2.19x | 373.000 | 13.32x | 19.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | react-reflex | 9594.653 | 2.41x | 366.000 | 13.07x | 19.000 | 1010 | 510 | 20 | 0 |
| branch-swap | 20 | react-upstream | 9717.242 | 2.44x | 373.000 | 13.32x | 11.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | roact | 5994.499 | 1.51x | 35.000 | 1.25x | 1.000 | 1010 | 510 | 0 | 0 |
| branch-swap | 20 | seam | 5320.691 | 1.34x | 29.000 | 1.04x | 0.000 | 500 | 510 | 10 | 0 |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — | — | — | — | — | — | — |
| branch-swap | 20 | vide | 4954.246 | 1.25x | 23.000 | 0.82x | 0.000 | 3530 | 510 | 0 | 0 |
| keyed-append | 10 | plain | 1572.036 | 1.00x | 1700.000 | 1.00x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | blend | 4880.707 | 3.10x | 3069.000 | 1.81x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-append | 10 | compose | 1546.189 | 0.98x | 2170.000 | 1.28x | 0.000 | 100 | 50 | 0 | 0 |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | react | 12819.200 | 8.15x | 2517.000 | 1.48x | 13.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | react-reflex | 12722.890 | 8.09x | 2511.000 | 1.48x | 6.000 | 150 | 50 | 10 | 0 |
| keyed-append | 10 | react-upstream | 12936.616 | 8.23x | 2509.000 | 1.48x | 5.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | roact | 6617.127 | 4.21x | 1980.000 | 1.16x | 0.000 | 150 | 50 | 0 | 0 |
| keyed-append | 10 | seam | 14270.261 | 9.08x | 3471.000 | 2.04x | 1.000 | 100 | 50 | 100 | 50 |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-append | 10 | vide | 1902.427 | 1.21x | 2266.000 | 1.33x | 0.000 | 400 | 50 | 0 | 0 |
| keyed-prepend | 10 | plain | 2029.027 | 1.00x | 1700.000 | 1.00x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | blend | 5056.794 | 2.49x | 3060.000 | 1.80x | 0.000 | 3500 | 50 | 0 | 0 |
| keyed-prepend | 10 | compose | 4219.407 | 2.08x | 2163.000 | 1.27x | 0.000 | 3100 | 50 | 0 | 0 |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | react | 18303.435 | 9.02x | 2457.000 | 1.45x | 5.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | react-reflex | 17652.793 | 8.70x | 2457.000 | 1.45x | 6.000 | 3150 | 50 | 10 | 0 |
| keyed-prepend | 10 | react-upstream | 17884.769 | 8.81x | 2465.000 | 1.45x | 13.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | roact | 8778.814 | 4.33x | 1988.000 | 1.17x | 0.000 | 3150 | 50 | 0 | 0 |
| keyed-prepend | 10 | seam | 16404.947 | 8.09x | 3472.000 | 2.04x | 1.000 | 3100 | 50 | 100 | 50 |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-prepend | 10 | vide | 4916.672 | 2.42x | 2266.000 | 1.33x | 0.000 | 3400 | 50 | 0 | 0 |
| keyed-insert | 10 | plain | 1803.069 | 1.00x | 1708.000 | 1.00x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | blend | 5093.627 | 2.82x | 3069.000 | 1.80x | 1.000 | 3500 | 50 | 0 | 0 |
| keyed-insert | 10 | compose | 3012.236 | 1.67x | 2163.000 | 1.27x | 0.000 | 1600 | 50 | 0 | 0 |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | react | 16056.964 | 8.91x | 2483.000 | 1.45x | 5.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | react-reflex | 15918.825 | 8.83x | 2484.000 | 1.45x | 6.000 | 1650 | 50 | 10 | 0 |
| keyed-insert | 10 | react-upstream | 15947.589 | 8.84x | 2483.000 | 1.45x | 13.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | roact | 7665.350 | 4.25x | 1980.000 | 1.16x | 0.000 | 1650 | 50 | 0 | 0 |
| keyed-insert | 10 | seam | 15498.773 | 8.60x | 3472.000 | 2.03x | 1.000 | 1600 | 50 | 100 | 50 |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-insert | 10 | vide | 3621.620 | 2.01x | 2274.000 | 1.33x | 0.000 | 1900 | 50 | 0 | 0 |
| keyed-remove | 10 | plain | 1897.184 | 1.00x | 1695.000 | 1.00x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | blend | 5047.496 | 2.66x | 3076.000 | 1.81x | 1.000 | 3400 | 50 | 0 | 0 |
| keyed-remove | 10 | compose | 2906.495 | 1.53x | 2162.000 | 1.28x | 0.000 | 1510 | 50 | 0 | 0 |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | react | 15074.841 | 7.95x | 2409.000 | 1.42x | 5.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | react-reflex | 15226.100 | 8.03x | 2409.000 | 1.42x | 5.000 | 1560 | 50 | 10 | 0 |
| keyed-remove | 10 | react-upstream | 15313.935 | 8.07x | 2401.000 | 1.42x | 6.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | roact | 7584.506 | 4.00x | 1979.000 | 1.17x | 0.000 | 1560 | 50 | 0 | 0 |
| keyed-remove | 10 | seam | 15027.238 | 7.92x | 3470.000 | 2.05x | 0.000 | 1510 | 50 | 100 | 50 |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-remove | 10 | vide | 3303.249 | 1.74x | 2273.000 | 1.34x | 0.000 | 1810 | 50 | 0 | 0 |
| keyed-replace | 10 | plain | 33336.986 | 1.00x | 1719.000 | 1.00x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | blend | 116708.013 | 3.50x | 5702.000 | 3.32x | 9.000 | 30000 | 3000 | 0 | 0 |
| keyed-replace | 10 | compose | 67768.253 | 2.03x | 2185.000 | 1.27x | 0.000 | 6000 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion | 107588.722 | 3.23x | 3002.000 | 1.75x | 0.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | fusion-charm | 111391.622 | 3.34x | 3012.000 | 1.75x | 8.000 | 27300 | 3000 | 0 | 0 |
| keyed-replace | 10 | react | 90845.510 | 2.73x | 3932.000 | 2.29x | 8.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | react-reflex | 93196.020 | 2.80x | 3932.000 | 2.29x | 7.000 | 9000 | 3000 | 10 | 0 |
| keyed-replace | 10 | react-upstream | 91330.035 | 2.74x | 3939.000 | 2.29x | 8.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | roact | 41376.606 | 1.24x | 2011.000 | 1.17x | 0.000 | 9000 | 3000 | 0 | 0 |
| keyed-replace | 10 | seam | 112637.005 | 3.38x | 3502.000 | 2.04x | 0.000 | 6000 | 3000 | 6000 | 3000 |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-replace | 10 | vide | 62986.307 | 1.89x | 2313.000 | 1.35x | 1.000 | 24000 | 3000 | 0 | 0 |
| keyed-reverse | 10 | plain | 1514.344 | 1.00x | 1696.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | blend | 2961.708 | 1.96x | 3026.000 | 1.78x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | compose | 3220.158 | 2.13x | 2162.000 | 1.27x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion | 21670.036 | 14.31x | 2979.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | fusion-charm | 21310.052 | 14.07x | 2980.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react | 43395.736 | 28.66x | 2386.000 | 1.41x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | react-reflex | 43717.750 | 28.87x | 2395.000 | 1.41x | 5.000 | 3000 | 0 | 10 | 0 |
| keyed-reverse | 10 | react-upstream | 43501.515 | 28.73x | 2387.000 | 1.41x | 5.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | roact | 7790.873 | 5.14x | 1987.000 | 1.17x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | seam | 13037.113 | 8.61x | 3463.000 | 2.04x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-reverse | 10 | vide | 3264.892 | 2.16x | 2249.000 | 1.33x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | plain | 1521.246 | 1.00x | 1696.000 | 1.00x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | blend | 2782.606 | 1.83x | 3026.000 | 1.78x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | compose | 3592.923 | 2.36x | 2161.000 | 1.27x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion | 21422.224 | 14.08x | 2979.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | fusion-charm | 21180.942 | 13.92x | 2989.000 | 1.76x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react | 29699.873 | 19.52x | 2386.000 | 1.41x | 4.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | react-reflex | 30110.511 | 19.79x | 2402.000 | 1.42x | 12.000 | 3000 | 0 | 10 | 0 |
| keyed-rotate | 10 | react-upstream | 29992.480 | 19.72x | 2394.000 | 1.41x | 12.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | roact | 7634.455 | 5.02x | 1987.000 | 1.17x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | seam | 12869.901 | 8.46x | 3470.000 | 2.05x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-rotate | 10 | vide | 3479.601 | 2.29x | 2257.000 | 1.33x | 0.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | plain | 1602.259 | 1.00x | 1696.000 | 1.00x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | blend | 2731.060 | 1.70x | 3026.000 | 1.78x | 1.000 | 3000 | 0 | 0 | 0 |
| keyed-shuffle | 10 | compose | 3487.677 | 2.18x | 2162.000 | 1.27x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion | 21563.286 | 13.46x | 2979.000 | 1.76x | 1.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | fusion-charm | 20908.290 | 13.05x | 2989.000 | 1.76x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react | 28040.473 | 17.50x | 2402.000 | 1.42x | 12.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | react-reflex | 28038.046 | 17.50x | 2394.000 | 1.41x | 4.000 | 2990 | 0 | 10 | 0 |
| keyed-shuffle | 10 | react-upstream | 28052.972 | 17.51x | 2394.000 | 1.41x | 5.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | roact | 7631.102 | 4.76x | 1987.000 | 1.17x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | seam | 12901.132 | 8.05x | 3471.000 | 2.05x | 0.000 | 2990 | 0 | 0 | 0 |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| keyed-shuffle | 10 | vide | 3208.976 | 2.00x | 2257.000 | 1.33x | 0.000 | 2990 | 0 | 0 | 0 |
| events | 5 | plain | 17811.619 | 1.00x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | blend | 30531.197 | 1.71x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | compose | 18287.859 | 1.03x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | fusion | 20118.880 | 1.13x | 0.000 | 0.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | fusion-charm | 21186.167 | 1.19x | 1.000 | 1.00x | 0.000 | 9015 | 1005 | 1000 | 0 |
| events | 5 | react | 22641.556 | 1.27x | 4.000 | 4.00x | 4.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | react-reflex | 25377.429 | 1.42x | 4.000 | 4.00x | 3.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | react-upstream | 24274.420 | 1.36x | 4.000 | 4.00x | 0.000 | 2000 | 1005 | 1000 | 0 |
| events | 5 | roact | 21797.381 | 1.22x | 1.000 | 1.00x | 0.000 | 2005 | 1005 | 1000 | 0 |
| events | 5 | seam | 20914.961 | 1.17x | 1.000 | 1.00x | 0.000 | 1000 | 1005 | 1005 | 0 |
| events | 5 | signals | 16644.416 | 0.93x | 0.000 | 0.00x | 0.000 | 1000 | 1005 | 1000 | 0 |
| events | 5 | vide | 17982.083 | 1.01x | 0.000 | 0.00x | 0.000 | 8015 | 1005 | 1000 | 0 |
| animate-many | 1 | plain | 1898.998 | 1.00x | 1516.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| animate-many | 1 | blend | 11539.900 | 6.08x | 2642.000 | 1.74x | 0.000 | 6200 | 0 | 200 | 0 |
| animate-many | 1 | compose | 11190.335 | 5.89x | 2282.000 | 1.51x | 0.000 | 6000 | 0 | 1 | 0 |
| animate-many | 1 | fusion | 136756.909 | 72.02x | 2590.000 | 1.71x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | fusion-charm | 135945.120 | 71.59x | 2600.000 | 1.72x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — | — | — | — | — | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — | — | — | — | — | — | — |
| animate-many | 1 | seam | 27001.807 | 14.22x | 3518.000 | 2.32x | 0.000 | 3600 | 0 | 0 | 0 |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — | — | — | — | — | — | — |
| animate-many | 1 | vide | 7564.473 | 3.98x | 1916.000 | 1.26x | 0.000 | 6000 | 0 | 0 | 30 |
| status-panel | 20 | plain | 452.602 | 1.00x | 135.000 | 1.00x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | blend | 1280.034 | 2.83x | 247.000 | 1.83x | 0.000 | 438 | 21 | 0 | 0 |
| status-panel | 20 | compose | 1233.167 | 2.72x | 178.000 | 1.32x | 0.000 | 82 | 21 | 0 | 0 |
| status-panel | 20 | fusion | 3095.450 | 6.84x | 240.000 | 1.78x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | fusion-charm | 3407.834 | 7.53x | 245.000 | 1.81x | 0.000 | 229 | 21 | 0 | 0 |
| status-panel | 20 | react | 3518.742 | 7.77x | 207.000 | 1.53x | 8.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | react-reflex | 3024.953 | 6.68x | 209.000 | 1.55x | 7.000 | 103 | 21 | 20 | 0 |
| status-panel | 20 | react-upstream | 2480.484 | 5.48x | 207.000 | 1.53x | 7.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | roact | 941.691 | 2.08x | 165.000 | 1.22x | 0.000 | 103 | 21 | 0 | 0 |
| status-panel | 20 | seam | 2145.187 | 4.74x | 290.000 | 2.15x | 0.000 | 82 | 21 | 42 | 21 |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — | — | — | — | — | — | — |
| status-panel | 20 | vide | 751.611 | 1.66x | 176.000 | 1.30x | 0.000 | 208 | 21 | 0 | 0 |
| mount-cycles | 1 | plain | 25479.401 | 1.00x | 0.000 | n/a (zero baseline) | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | blend | 49073.056 | 1.93x | 0.000 | n/a (zero baseline) | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | compose | 28275.494 | 1.11x | 1.000 | n/a (zero baseline) | 1.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion | 29461.948 | 1.16x | 0.000 | n/a (zero baseline) | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | fusion-charm | 30389.202 | 1.19x | 0.000 | n/a (zero baseline) | 0.000 | 16290 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react | 41394.578 | 1.62x | 26.000 | n/a (zero baseline) | 26.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-reflex | 43797.040 | 1.72x | 21.000 | n/a (zero baseline) | 12.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | react-upstream | 43788.048 | 1.72x | 20.000 | n/a (zero baseline) | 12.000 | 3600 | 1830 | 1800 | 0 |
| mount-cycles | 1 | roact | 31229.303 | 1.23x | 0.000 | n/a (zero baseline) | 0.000 | 3630 | 1830 | 1800 | 0 |
| mount-cycles | 1 | seam | 30801.328 | 1.21x | 1.000 | n/a (zero baseline) | 0.000 | 1800 | 1830 | 1830 | 0 |
| mount-cycles | 1 | signals | 20795.496 | 0.82x | 0.000 | n/a (zero baseline) | 0.000 | 1800 | 1830 | 1800 | 0 |
| mount-cycles | 1 | vide | 25046.020 | 0.98x | 1.000 | n/a (zero baseline) | 1.000 | 14490 | 1830 | 1800 | 0 |
| scene-3d | 20 | plain | 4948.304 | 1.00x | 1036.000 | 1.00x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | blend | 9988.139 | 2.02x | 1572.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | compose | 7749.331 | 1.57x | 1209.000 | 1.17x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion | 82377.473 | 16.65x | 1575.000 | 1.52x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | fusion-charm | 82913.793 | 16.76x | 1571.000 | 1.52x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react | 8103.052 | 1.64x | 1243.000 | 1.20x | 1.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | react-reflex | 8276.947 | 1.67x | 1245.000 | 1.20x | 1.000 | 6000 | 0 | 20 | 0 |
| scene-3d | 20 | react-upstream | 8541.196 | 1.73x | 1243.000 | 1.20x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — | — | — | — | — | — | — |
| scene-3d | 20 | seam | 23051.415 | 4.66x | 2209.000 | 2.13x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | signals | 14899.043 | 3.01x | 1689.000 | 1.63x | 0.000 | 6000 | 0 | 0 | 0 |
| scene-3d | 20 | vide | 9544.310 | 1.93x | 1236.000 | 1.19x | 0.000 | 6000 | 0 | 0 | 0 |

## Summary

This summary uses the 22 selected workloads. The geometric mean divides each measured median time by the plain median time of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count.

The shared column uses only the 10 workloads that every lane measured: `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000`, `mount-dispose`, `update-leaf`, `update-fanout`, `update-batched`, `update-repeated`, `events`, `mount-cycles`.

| Framework | Supported | Measured | Geometric mean time / plain | Shared workloads, geometric mean / plain |
| --- | ---: | ---: | ---: | ---: |
| plain | 22 | 22 | 1.00x | 1.00x |
| blend | 22 | 22 | 2.93x | 3.32x |
| compose | 22 | 22 | 1.99x | 1.94x |
| fusion | 18 | 18 | 5.89x | 3.80x |
| fusion-charm | 18 | 18 | 5.39x | 3.20x |
| react | 21 | 21 | 4.62x | 2.73x |
| react-reflex | 21 | 21 | 5.16x | 3.47x |
| react-upstream | 21 | 21 | 4.66x | 2.84x |
| roact | 20 | 20 | 2.75x | 2.31x |
| seam | 22 | 22 | 4.18x | 2.54x |
| signals | 11 | 11 | 2.13x | 2.06x |
| vide | 22 | 22 | 1.96x | 1.96x |

## Source identities

Harness revision: `688d482bab458186b251625ccad29a686747cf5c`. Full source state, tools, environment and command are in `context.json`.

| Dependency | Version | Commit | Tree | Rights |
| --- | --- | --- | --- | --- |
| compose | unreleased | `5945400d3c5d134d92f778cf8628b821187f254e` | `cdb127fa24538e0f13e891aa3c8e688b7fed2d6f` | MIT |
| facet | 0.12.0 | `8a319b615f42e338878c7a69b4495542545b0c31` | `bf55a600ce21759d131a6184e5f9b71b4da8e938` | MIT |
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
