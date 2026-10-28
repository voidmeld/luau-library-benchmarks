# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | Apple M2 Max |
| Cores | 12 |
| Memory | 32 GiB |
| Model | Mac14,13 |
| Operating system | macOS 27.0 |
| Roblox Studio | 0.745.0.7451137 |
| Context | client |
| Harness revision | `31716c4` |
| Date | 2026-10-28 |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same tree as plain |
| --- | ---: | --- | ---: | ---: | --- |
| cold-mount-100 | 1 | plain | 3002 | 1.00x | yes |
| cold-mount-100 | 1 | blend | 3454 | 1.15x | yes |
| cold-mount-100 | 1 | compose | 2854 | 0.95x | yes |
| cold-mount-100 | 1 | fusion | 3055 | 1.02x | yes |
| cold-mount-100 | 1 | fusion-charm | 3006 | 1.00x | yes |
| cold-mount-100 | 1 | react | 3301 | 1.10x | yes |
| cold-mount-100 | 1 | react-reflex | 3206 | 1.07x | yes |
| cold-mount-100 | 1 | react-upstream | 3202 | 1.07x | yes |
| cold-mount-100 | 1 | roact | 3102 | 1.03x | yes |
| cold-mount-100 | 1 | seam | 2806 | 0.93x | yes |
| cold-mount-100 | 1 | signals | 2754 | 0.92x | yes |
| cold-mount-100 | 1 | vide | 3154 | 1.05x | yes |
| cold-mount-1000 | 1 | plain | 25830 | 1.00x | yes |
| cold-mount-1000 | 1 | blend | 34014 | 1.32x | yes |
| cold-mount-1000 | 1 | compose | 27974 | 1.08x | yes |
| cold-mount-1000 | 1 | fusion | 29407 | 1.14x | yes |
| cold-mount-1000 | 1 | fusion-charm | 29324 | 1.14x | yes |
| cold-mount-1000 | 1 | react | 30572 | 1.18x | yes |
| cold-mount-1000 | 1 | react-reflex | 30265 | 1.17x | yes |
| cold-mount-1000 | 1 | react-upstream | 30568 | 1.18x | yes |
| cold-mount-1000 | 1 | roact | 29265 | 1.13x | yes |
| cold-mount-1000 | 1 | seam | 26680 | 1.03x | yes |
| cold-mount-1000 | 1 | signals | 26818 | 1.04x | yes |
| cold-mount-1000 | 1 | vide | 29122 | 1.13x | yes |
| cold-mount-10000 | 1 | plain | 964396 | 1.00x | yes |
| cold-mount-10000 | 1 | blend | 1108870 | 1.15x | yes |
| cold-mount-10000 | 1 | compose | 982258 | 1.02x | yes |
| cold-mount-10000 | 1 | fusion | 1004921 | 1.04x | yes |
| cold-mount-10000 | 1 | fusion-charm | 1017014 | 1.05x | yes |
| cold-mount-10000 | 1 | react | 1063060 | 1.10x | yes |
| cold-mount-10000 | 1 | react-reflex | 1038988 | 1.08x | yes |
| cold-mount-10000 | 1 | react-upstream | 1046008 | 1.08x | yes |
| cold-mount-10000 | 1 | roact | 1053616 | 1.09x | yes |
| cold-mount-10000 | 1 | seam | 1298738 | 1.35x | yes |
| cold-mount-10000 | 1 | signals | 1201014 | 1.25x | yes |
| cold-mount-10000 | 1 | vide | 986792 | 1.02x | yes |
| mount-dispose | 5 | plain | 26131 | 1.00x | yes |
| mount-dispose | 5 | blend | 37280 | 1.43x | yes |
| mount-dispose | 5 | compose | 28024 | 1.07x | yes |
| mount-dispose | 5 | fusion | 29659 | 1.14x | yes |
| mount-dispose | 5 | fusion-charm | 29584 | 1.13x | yes |
| mount-dispose | 5 | react | 30835 | 1.18x | yes |
| mount-dispose | 5 | react-reflex | 31032 | 1.19x | yes |
| mount-dispose | 5 | react-upstream | 30840 | 1.18x | yes |
| mount-dispose | 5 | roact | 28820 | 1.10x | yes |
| mount-dispose | 5 | seam | 26314 | 1.01x | yes |
| mount-dispose | 5 | signals | 27074 | 1.04x | yes |
| mount-dispose | 5 | vide | 29074 | 1.11x | yes |
| update-leaf | 50 | plain | 904 | 1.00x | yes |
| update-leaf | 50 | blend | 2350 | 2.60x | yes |
| update-leaf | 50 | compose | 2351 | 2.60x | yes |
| update-leaf | 50 | fusion | 2508 | 2.77x | yes |
| update-leaf | 50 | fusion-charm | 850 | 0.94x | yes |
| update-leaf | 50 | react | 2180 | 2.41x | yes |
| update-leaf | 50 | react-reflex | 2254 | 2.49x | yes |
| update-leaf | 50 | react-upstream | 2360 | 2.61x | yes |
| update-leaf | 50 | roact | 2152 | 2.38x | yes |
| update-leaf | 50 | seam | 2457 | 2.72x | yes |
| update-leaf | 50 | signals | 2175 | 2.41x | yes |
| update-leaf | 50 | vide | 2306 | 2.55x | yes |
| update-fanout | 20 | plain | 108853 | 1.00x | yes |
| update-fanout | 20 | blend | 112756 | 1.04x | yes |
| update-fanout | 20 | compose | 121310 | 1.11x | yes |
| update-fanout | 20 | fusion | 122026 | 1.12x | yes |
| update-fanout | 20 | fusion-charm | 121820 | 1.12x | yes |
| update-fanout | 20 | react | 120512 | 1.11x | yes |
| update-fanout | 20 | react-reflex | 110870 | 1.02x | yes |
| update-fanout | 20 | react-upstream | 120338 | 1.11x | yes |
| update-fanout | 20 | roact | 119209 | 1.10x | yes |
| update-fanout | 20 | seam | 118798 | 1.09x | yes |
| update-fanout | 20 | signals | 121697 | 1.12x | yes |
| update-fanout | 20 | vide | 118964 | 1.09x | yes |
| update-batched | 20 | plain | 5004 | 1.00x | yes |
| update-batched | 20 | blend | 10872 | 2.17x | yes |
| update-batched | 20 | compose | 7715 | 1.54x | yes |
| update-batched | 20 | fusion | 21028 | 4.20x | yes |
| update-batched | 20 | fusion-charm | 39190 | 7.83x | yes |
| update-batched | 20 | react | 8266 | 1.65x | yes |
| update-batched | 20 | react-reflex | 60100 | 12.01x | yes |
| update-batched | 20 | react-upstream | 8179 | 1.63x | yes |
| update-batched | 20 | roact | 8677 | 1.73x | yes |
| update-batched | 20 | seam | 13257 | 2.65x | yes |
| update-batched | 20 | signals | 10811 | 2.16x | yes |
| update-batched | 20 | vide | 9236 | 1.85x | yes |
| update-repeated | 10 | plain | 0 | plain below resolution | yes |
| update-repeated | 10 | blend | 3456 | plain below resolution | yes |
| update-repeated | 10 | compose | 500 | plain below resolution | yes |
| update-repeated | 10 | fusion | 25780 | plain below resolution | yes |
| update-repeated | 10 | fusion-charm | 1105 | plain below resolution | yes |
| update-repeated | 10 | react | 5511 | plain below resolution | yes |
| update-repeated | 10 | react-reflex | 800 | plain below resolution | yes |
| update-repeated | 10 | react-upstream | 5658 | plain below resolution | yes |
| update-repeated | 10 | roact | 5052 | plain below resolution | yes |
| update-repeated | 10 | seam | 1456 | plain below resolution | yes |
| update-repeated | 10 | signals | 803 | plain below resolution | yes |
| update-repeated | 10 | vide | 600 | plain below resolution | yes |
| branch-swap | 20 | plain | 15865 | 1.00x | yes |
| branch-swap | 20 | blend | 18020 | 1.14x | yes |
| branch-swap | 20 | compose | 15244 | 0.96x | yes |
| branch-swap | 20 | fusion | 15722 | 0.99x | yes |
| branch-swap | 20 | fusion-charm | 5000 | 0.32x | yes |
| branch-swap | 20 | react | 17520 | 1.10x | yes |
| branch-swap | 20 | react-reflex | 17424 | 1.10x | yes |
| branch-swap | 20 | react-upstream | 17622 | 1.11x | yes |
| branch-swap | 20 | roact | 15716 | 0.99x | yes |
| branch-swap | 20 | seam | 14354 | 0.90x | yes |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — |
| branch-swap | 20 | vide | 15273 | 0.96x | yes |
| keyed-append | 10 | plain | 1100 | 1.00x | yes |
| keyed-append | 10 | blend | 3406 | 3.10x | yes |
| keyed-append | 10 | compose | 1500 | 1.36x | yes |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | react | 9504 | 8.64x | yes |
| keyed-append | 10 | react-reflex | 9806 | 8.91x | yes |
| keyed-append | 10 | react-upstream | 9804 | 8.91x | yes |
| keyed-append | 10 | roact | 4310 | 3.92x | yes |
| keyed-append | 10 | seam | 9310 | 8.46x | yes |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-append | 10 | vide | 2001 | 1.82x | yes |
| keyed-prepend | 10 | plain | 2600 | 1.00x | yes |
| keyed-prepend | 10 | blend | 4612 | 1.77x | yes |
| keyed-prepend | 10 | compose | 4510 | 1.73x | yes |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | react | 15405 | 5.92x | yes |
| keyed-prepend | 10 | react-reflex | 15656 | 6.02x | yes |
| keyed-prepend | 10 | react-upstream | 15501 | 5.96x | yes |
| keyed-prepend | 10 | roact | 7056 | 2.71x | yes |
| keyed-prepend | 10 | seam | 11159 | 4.29x | yes |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-prepend | 10 | vide | 5472 | 2.10x | yes |
| keyed-insert | 10 | plain | 1902 | 1.00x | yes |
| keyed-insert | 10 | blend | 4158 | 2.19x | yes |
| keyed-insert | 10 | compose | 3058 | 1.61x | yes |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | react | 13126 | 6.90x | yes |
| keyed-insert | 10 | react-reflex | 13460 | 7.08x | yes |
| keyed-insert | 10 | react-upstream | 13071 | 6.87x | yes |
| keyed-insert | 10 | roact | 5822 | 3.06x | yes |
| keyed-insert | 10 | seam | 10754 | 5.65x | yes |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-insert | 10 | vide | 3805 | 2.00x | yes |
| keyed-remove | 10 | plain | 1757 | 1.00x | yes |
| keyed-remove | 10 | blend | 4052 | 2.31x | yes |
| keyed-remove | 10 | compose | 2807 | 1.60x | yes |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | react | 12904 | 7.34x | yes |
| keyed-remove | 10 | react-reflex | 12662 | 7.21x | yes |
| keyed-remove | 10 | react-upstream | 12913 | 7.35x | yes |
| keyed-remove | 10 | roact | 5700 | 3.24x | yes |
| keyed-remove | 10 | seam | 10257 | 5.84x | yes |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-remove | 10 | vide | 3500 | 1.99x | yes |
| keyed-replace | 10 | plain | 29714 | 1.00x | yes |
| keyed-replace | 10 | blend | 95883 | 3.23x | yes |
| keyed-replace | 10 | compose | 50868 | 1.71x | yes |
| keyed-replace | 10 | fusion | 86312 | 2.90x | yes |
| keyed-replace | 10 | fusion-charm | 81588 | 2.75x | yes |
| keyed-replace | 10 | react | 81258 | 2.73x | yes |
| keyed-replace | 10 | react-reflex | 81803 | 2.75x | yes |
| keyed-replace | 10 | react-upstream | 81594 | 2.75x | yes |
| keyed-replace | 10 | roact | 41602 | 1.40x | yes |
| keyed-replace | 10 | seam | 110290 | 3.71x | yes |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-replace | 10 | vide | 49566 | 1.67x | yes |
| keyed-reverse | 10 | plain | 1810 | 1.00x | yes |
| keyed-reverse | 10 | blend | 3200 | 1.77x | yes |
| keyed-reverse | 10 | compose | 2951 | 1.63x | yes |
| keyed-reverse | 10 | fusion | 19266 | 10.65x | yes |
| keyed-reverse | 10 | fusion-charm | 18406 | 10.17x | yes |
| keyed-reverse | 10 | react | 45074 | 24.91x | yes |
| keyed-reverse | 10 | react-reflex | 46345 | 25.61x | yes |
| keyed-reverse | 10 | react-upstream | 46165 | 25.51x | yes |
| keyed-reverse | 10 | roact | 5903 | 3.26x | yes |
| keyed-reverse | 10 | seam | 9669 | 5.34x | yes |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-reverse | 10 | vide | 3954 | 2.19x | yes |
| keyed-rotate | 10 | plain | 1654 | 1.00x | yes |
| keyed-rotate | 10 | blend | 2704 | 1.63x | yes |
| keyed-rotate | 10 | compose | 2850 | 1.72x | yes |
| keyed-rotate | 10 | fusion | 19585 | 11.84x | yes |
| keyed-rotate | 10 | fusion-charm | 18041 | 10.91x | yes |
| keyed-rotate | 10 | react | 30392 | 18.37x | yes |
| keyed-rotate | 10 | react-reflex | 30317 | 18.33x | yes |
| keyed-rotate | 10 | react-upstream | 30479 | 18.43x | yes |
| keyed-rotate | 10 | roact | 6112 | 3.70x | yes |
| keyed-rotate | 10 | seam | 9613 | 5.81x | yes |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-rotate | 10 | vide | 3290 | 1.99x | yes |
| keyed-shuffle | 10 | plain | 1861 | 1.00x | yes |
| keyed-shuffle | 10 | blend | 2901 | 1.56x | yes |
| keyed-shuffle | 10 | compose | 3355 | 1.80x | yes |
| keyed-shuffle | 10 | fusion | 19514 | 10.49x | yes |
| keyed-shuffle | 10 | fusion-charm | 17411 | 9.36x | yes |
| keyed-shuffle | 10 | react | 26358 | 14.16x | yes |
| keyed-shuffle | 10 | react-reflex | 27040 | 14.53x | yes |
| keyed-shuffle | 10 | react-upstream | 27109 | 14.57x | yes |
| keyed-shuffle | 10 | roact | 6006 | 3.23x | yes |
| keyed-shuffle | 10 | seam | 9570 | 5.14x | yes |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-shuffle | 10 | vide | 3757 | 2.02x | yes |
| events | 5 | plain | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | blend | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | compose | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | fusion | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | fusion-charm | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | react | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | react-reflex | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | react-upstream | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | roact | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | seam | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | signals | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| events | 5 | vide | unsupported: A script cannot fire GuiButton.Activated. Real input would measure the input pipeline, not the library. | — | — |
| animate-many | 1 | plain | 2956 | 1.00x | yes |
| animate-many | 1 | blend | 10758 | 3.64x | yes |
| animate-many | 1 | compose | 6758 | 2.29x | yes |
| animate-many | 1 | fusion | 106525 | 36.03x | yes |
| animate-many | 1 | fusion-charm | 106000 | 35.85x | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — |
| animate-many | 1 | seam | 20622 | 6.98x | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — |
| animate-many | 1 | vide | 8114 | 2.74x | yes |
| status-panel | 20 | plain | 1404 | 1.00x | yes |
| status-panel | 20 | blend | 2404 | 1.71x | yes |
| status-panel | 20 | compose | 2405 | 1.71x | yes |
| status-panel | 20 | fusion | 3605 | 2.57x | yes |
| status-panel | 20 | fusion-charm | 2156 | 1.54x | yes |
| status-panel | 20 | react | 4105 | 2.92x | yes |
| status-panel | 20 | react-reflex | 4000 | 2.85x | yes |
| status-panel | 20 | react-upstream | 4110 | 2.93x | yes |
| status-panel | 20 | roact | 2452 | 1.75x | yes |
| status-panel | 20 | seam | 3754 | 2.67x | yes |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| status-panel | 20 | vide | 2134 | 1.52x | yes |
| mount-cycles | 1 | plain | 47368 | 1.00x | yes |
| mount-cycles | 1 | blend | 73902 | 1.56x | yes |
| mount-cycles | 1 | compose | 57152 | 1.21x | yes |
| mount-cycles | 1 | fusion | 58740 | 1.24x | yes |
| mount-cycles | 1 | fusion-charm | 58532 | 1.24x | yes |
| mount-cycles | 1 | react | 64248 | 1.36x | yes |
| mount-cycles | 1 | react-reflex | 64142 | 1.35x | yes |
| mount-cycles | 1 | react-upstream | 64486 | 1.36x | yes |
| mount-cycles | 1 | roact | 58259 | 1.23x | yes |
| mount-cycles | 1 | seam | 54090 | 1.14x | yes |
| mount-cycles | 1 | signals | 54280 | 1.15x | yes |
| mount-cycles | 1 | vide | 57426 | 1.21x | yes |
| scene-3d | 20 | plain | 5750 | 1.00x | yes |
| scene-3d | 20 | blend | 9010 | 1.57x | yes |
| scene-3d | 20 | compose | 6202 | 1.08x | yes |
| scene-3d | 20 | fusion | 62596 | 10.89x | yes |
| scene-3d | 20 | fusion-charm | 58154 | 10.11x | yes |
| scene-3d | 20 | react | 6680 | 1.16x | yes |
| scene-3d | 20 | react-reflex | 6055 | 1.05x | yes |
| scene-3d | 20 | react-upstream | 6506 | 1.13x | yes |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — |
| scene-3d | 20 | seam | 17106 | 2.98x | yes |
| scene-3d | 20 | signals | 11812 | 2.05x | yes |
| scene-3d | 20 | vide | 7812 | 1.36x | yes |

## Summary

The geometric mean divides each measured median Luau time by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain median below that reads 0. Such a workload has no ratio and is not in the geometric mean; its times still compare the libraries.

The shared column uses only the 8 workloads that every lane measured: `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000`, `mount-dispose`, `update-leaf`, `update-fanout`, `update-batched`, `mount-cycles`.

| Lane | Measured | Geometric mean time / plain | Shared workloads, geometric mean / plain |
| --- | ---: | ---: | ---: |
| plain | 20 | 1.00x | 1.00x |
| blend | 20 | 1.78x | 1.48x |
| compose | 20 | 1.43x | 1.25x |
| fusion | 16 | 3.13x | 1.47x |
| fusion-charm | 16 | 2.68x | 1.39x |
| react | 19 | 3.07x | 1.34x |
| react-reflex | 19 | 3.38x | 1.69x |
| react-upstream | 19 | 3.08x | 1.34x |
| roact | 18 | 1.87x | 1.29x |
| seam | 20 | 2.70x | 1.36x |
| signals | 9 | 1.37x | 1.30x |
| vide | 20 | 1.59x | 1.30x |
