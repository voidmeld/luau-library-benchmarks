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
| Roblox Studio | 0.744.0.7441077 |
| Context | client |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same tree as plain |
| --- | ---: | --- | ---: | ---: | --- |
| cold-mount-100 | 1 | plain | 2416 | 1.00x | yes |
| cold-mount-100 | 1 | blend | 3132 | 1.30x | yes |
| cold-mount-100 | 1 | compose | 2260 | 0.94x | yes |
| cold-mount-100 | 1 | fusion | 2702 | 1.12x | yes |
| cold-mount-100 | 1 | fusion-charm | 2506 | 1.04x | yes |
| cold-mount-100 | 1 | react | 2555 | 1.06x | yes |
| cold-mount-100 | 1 | react-reflex | 2805 | 1.16x | yes |
| cold-mount-100 | 1 | react-upstream | 2854 | 1.18x | yes |
| cold-mount-100 | 1 | roact | 2463 | 1.02x | yes |
| cold-mount-100 | 1 | seam | 2406 | 1.00x | yes |
| cold-mount-100 | 1 | signals | 2414 | 1.00x | yes |
| cold-mount-100 | 1 | vide | 2705 | 1.12x | yes |
| cold-mount-1000 | 1 | plain | 24116 | 1.00x | yes |
| cold-mount-1000 | 1 | blend | 33078 | 1.37x | yes |
| cold-mount-1000 | 1 | compose | 24807 | 1.03x | yes |
| cold-mount-1000 | 1 | fusion | 27254 | 1.13x | yes |
| cold-mount-1000 | 1 | fusion-charm | 27524 | 1.14x | yes |
| cold-mount-1000 | 1 | react | 28156 | 1.17x | yes |
| cold-mount-1000 | 1 | react-reflex | 28490 | 1.18x | yes |
| cold-mount-1000 | 1 | react-upstream | 28670 | 1.19x | yes |
| cold-mount-1000 | 1 | roact | 27210 | 1.13x | yes |
| cold-mount-1000 | 1 | seam | 25139 | 1.04x | yes |
| cold-mount-1000 | 1 | signals | 24872 | 1.03x | yes |
| cold-mount-1000 | 1 | vide | 27725 | 1.15x | yes |
| cold-mount-10000 | 1 | plain | 960910 | 1.00x | yes |
| cold-mount-10000 | 1 | blend | 1136254 | 1.18x | yes |
| cold-mount-10000 | 1 | compose | 989416 | 1.03x | yes |
| cold-mount-10000 | 1 | fusion | 1016696 | 1.06x | yes |
| cold-mount-10000 | 1 | fusion-charm | 1030092 | 1.07x | yes |
| cold-mount-10000 | 1 | react | 1054107 | 1.10x | yes |
| cold-mount-10000 | 1 | react-reflex | 1031048 | 1.07x | yes |
| cold-mount-10000 | 1 | react-upstream | 1028702 | 1.07x | yes |
| cold-mount-10000 | 1 | roact | 1044388 | 1.09x | yes |
| cold-mount-10000 | 1 | seam | 975682 | 1.02x | yes |
| cold-mount-10000 | 1 | signals | 953578 | 0.99x | yes |
| cold-mount-10000 | 1 | vide | 993406 | 1.03x | yes |
| mount-dispose | 5 | plain | 23664 | 1.00x | yes |
| mount-dispose | 5 | blend | 34114 | 1.44x | yes |
| mount-dispose | 5 | compose | 26352 | 1.11x | yes |
| mount-dispose | 5 | fusion | 27596 | 1.17x | yes |
| mount-dispose | 5 | fusion-charm | 27700 | 1.17x | yes |
| mount-dispose | 5 | react | 29400 | 1.24x | yes |
| mount-dispose | 5 | react-reflex | 29228 | 1.24x | yes |
| mount-dispose | 5 | react-upstream | 29268 | 1.24x | yes |
| mount-dispose | 5 | roact | 27045 | 1.14x | yes |
| mount-dispose | 5 | seam | 24326 | 1.03x | yes |
| mount-dispose | 5 | signals | 25026 | 1.06x | yes |
| mount-dispose | 5 | vide | 27276 | 1.15x | yes |
| update-leaf | 50 | plain | 800 | 1.00x | yes |
| update-leaf | 50 | blend | 2786 | 3.48x | yes |
| update-leaf | 50 | compose | 2908 | 3.64x | yes |
| update-leaf | 50 | fusion | 2914 | 3.64x | yes |
| update-leaf | 50 | fusion-charm | 994 | 1.24x | yes |
| update-leaf | 50 | react | 2812 | 3.51x | yes |
| update-leaf | 50 | react-reflex | 3156 | 3.94x | yes |
| update-leaf | 50 | react-upstream | 2450 | 3.06x | yes |
| update-leaf | 50 | roact | 2671 | 3.34x | yes |
| update-leaf | 50 | seam | 3511 | 4.39x | yes |
| update-leaf | 50 | signals | 2608 | 3.26x | yes |
| update-leaf | 50 | vide | 2804 | 3.50x | yes |
| update-fanout | 20 | plain | 93962 | 1.00x | yes |
| update-fanout | 20 | blend | 96851 | 1.03x | yes |
| update-fanout | 20 | compose | 103250 | 1.10x | yes |
| update-fanout | 20 | fusion | 105750 | 1.13x | yes |
| update-fanout | 20 | fusion-charm | 105356 | 1.12x | yes |
| update-fanout | 20 | react | 103652 | 1.10x | yes |
| update-fanout | 20 | react-reflex | 95527 | 1.02x | yes |
| update-fanout | 20 | react-upstream | 103952 | 1.11x | yes |
| update-fanout | 20 | roact | 103598 | 1.10x | yes |
| update-fanout | 20 | seam | 95122 | 1.01x | yes |
| update-fanout | 20 | signals | 105214 | 1.12x | yes |
| update-fanout | 20 | vide | 103575 | 1.10x | yes |
| update-batched | 20 | plain | 4610 | 1.00x | yes |
| update-batched | 20 | blend | 12114 | 2.63x | yes |
| update-batched | 20 | compose | 8358 | 1.81x | yes |
| update-batched | 20 | fusion | 22685 | 4.92x | yes |
| update-batched | 20 | fusion-charm | 40410 | 8.77x | yes |
| update-batched | 20 | react | 9896 | 2.15x | yes |
| update-batched | 20 | react-reflex | 59914 | 13.00x | yes |
| update-batched | 20 | react-upstream | 9816 | 2.13x | yes |
| update-batched | 20 | roact | 9508 | 2.06x | yes |
| update-batched | 20 | seam | 14466 | 3.14x | yes |
| update-batched | 20 | signals | 10918 | 2.37x | yes |
| update-batched | 20 | vide | 9816 | 2.13x | yes |
| update-repeated | 10 | plain | 0 | plain below resolution | yes |
| update-repeated | 10 | blend | 3700 | plain below resolution | yes |
| update-repeated | 10 | compose | 600 | plain below resolution | yes |
| update-repeated | 10 | fusion | 26717 | plain below resolution | yes |
| update-repeated | 10 | fusion-charm | 1306 | plain below resolution | yes |
| update-repeated | 10 | react | 5563 | plain below resolution | yes |
| update-repeated | 10 | react-reflex | 602 | plain below resolution | yes |
| update-repeated | 10 | react-upstream | 6069 | plain below resolution | yes |
| update-repeated | 10 | roact | 5220 | plain below resolution | yes |
| update-repeated | 10 | seam | 1664 | plain below resolution | yes |
| update-repeated | 10 | signals | 908 | plain below resolution | yes |
| update-repeated | 10 | vide | 500 | plain below resolution | yes |
| branch-swap | 20 | plain | 14194 | 1.00x | yes |
| branch-swap | 20 | blend | 17310 | 1.22x | yes |
| branch-swap | 20 | compose | 14626 | 1.03x | yes |
| branch-swap | 20 | fusion | 15051 | 1.06x | yes |
| branch-swap | 20 | fusion-charm | 5640 | 0.40x | yes |
| branch-swap | 20 | react | 16460 | 1.16x | yes |
| branch-swap | 20 | react-reflex | 15774 | 1.11x | yes |
| branch-swap | 20 | react-upstream | 16775 | 1.18x | yes |
| branch-swap | 20 | roact | 14519 | 1.02x | yes |
| branch-swap | 20 | seam | 13210 | 0.93x | yes |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — |
| branch-swap | 20 | vide | 14551 | 1.03x | yes |
| keyed-append | 10 | plain | 1053 | 1.00x | yes |
| keyed-append | 10 | blend | 3858 | 3.66x | yes |
| keyed-append | 10 | compose | 1902 | 1.81x | yes |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | react | 10278 | 9.76x | yes |
| keyed-append | 10 | react-reflex | 10230 | 9.72x | yes |
| keyed-append | 10 | react-upstream | 10359 | 9.84x | yes |
| keyed-append | 10 | roact | 4758 | 4.52x | yes |
| keyed-append | 10 | seam | 10314 | 9.79x | yes |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-append | 10 | vide | 2511 | 2.38x | yes |
| keyed-prepend | 10 | plain | 2452 | 1.00x | yes |
| keyed-prepend | 10 | blend | 5251 | 2.14x | yes |
| keyed-prepend | 10 | compose | 5011 | 2.04x | yes |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | react | 16063 | 6.55x | yes |
| keyed-prepend | 10 | react-reflex | 15924 | 6.49x | yes |
| keyed-prepend | 10 | react-upstream | 16223 | 6.62x | yes |
| keyed-prepend | 10 | roact | 7061 | 2.88x | yes |
| keyed-prepend | 10 | seam | 12400 | 5.06x | yes |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-prepend | 10 | vide | 5450 | 2.22x | yes |
| keyed-insert | 10 | plain | 1754 | 1.00x | yes |
| keyed-insert | 10 | blend | 4727 | 2.69x | yes |
| keyed-insert | 10 | compose | 3454 | 1.97x | yes |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | react | 13975 | 7.97x | yes |
| keyed-insert | 10 | react-reflex | 13906 | 7.93x | yes |
| keyed-insert | 10 | react-upstream | 14059 | 8.02x | yes |
| keyed-insert | 10 | roact | 6204 | 3.54x | yes |
| keyed-insert | 10 | seam | 11106 | 6.33x | yes |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-insert | 10 | vide | 4012 | 2.29x | yes |
| keyed-remove | 10 | plain | 1701 | 1.00x | yes |
| keyed-remove | 10 | blend | 4459 | 2.62x | yes |
| keyed-remove | 10 | compose | 3251 | 1.91x | yes |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | react | 13054 | 7.67x | yes |
| keyed-remove | 10 | react-reflex | 13058 | 7.68x | yes |
| keyed-remove | 10 | react-upstream | 13616 | 8.00x | yes |
| keyed-remove | 10 | roact | 5858 | 3.44x | yes |
| keyed-remove | 10 | seam | 11055 | 6.50x | yes |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-remove | 10 | vide | 3902 | 2.29x | yes |
| keyed-replace | 10 | plain | 31145 | 1.00x | yes |
| keyed-replace | 10 | blend | 99315 | 3.19x | yes |
| keyed-replace | 10 | compose | 53840 | 1.73x | yes |
| keyed-replace | 10 | fusion | 88920 | 2.86x | yes |
| keyed-replace | 10 | fusion-charm | 84176 | 2.70x | yes |
| keyed-replace | 10 | react | 83128 | 2.67x | yes |
| keyed-replace | 10 | react-reflex | 83894 | 2.69x | yes |
| keyed-replace | 10 | react-upstream | 83185 | 2.67x | yes |
| keyed-replace | 10 | roact | 43267 | 1.39x | yes |
| keyed-replace | 10 | seam | 118318 | 3.80x | yes |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-replace | 10 | vide | 51058 | 1.64x | yes |
| keyed-reverse | 10 | plain | 1655 | 1.00x | yes |
| keyed-reverse | 10 | blend | 3400 | 2.05x | yes |
| keyed-reverse | 10 | compose | 3354 | 2.03x | yes |
| keyed-reverse | 10 | fusion | 18282 | 11.05x | yes |
| keyed-reverse | 10 | fusion-charm | 18358 | 11.09x | yes |
| keyed-reverse | 10 | react | 47053 | 28.43x | yes |
| keyed-reverse | 10 | react-reflex | 47272 | 28.56x | yes |
| keyed-reverse | 10 | react-upstream | 47958 | 28.98x | yes |
| keyed-reverse | 10 | roact | 6472 | 3.91x | yes |
| keyed-reverse | 10 | seam | 11608 | 7.01x | yes |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-reverse | 10 | vide | 3870 | 2.34x | yes |
| keyed-rotate | 10 | plain | 1601 | 1.00x | yes |
| keyed-rotate | 10 | blend | 3152 | 1.97x | yes |
| keyed-rotate | 10 | compose | 3275 | 2.05x | yes |
| keyed-rotate | 10 | fusion | 19512 | 12.19x | yes |
| keyed-rotate | 10 | fusion-charm | 18486 | 11.55x | yes |
| keyed-rotate | 10 | react | 30858 | 19.27x | yes |
| keyed-rotate | 10 | react-reflex | 31034 | 19.38x | yes |
| keyed-rotate | 10 | react-upstream | 31509 | 19.68x | yes |
| keyed-rotate | 10 | roact | 6003 | 3.75x | yes |
| keyed-rotate | 10 | seam | 10660 | 6.66x | yes |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-rotate | 10 | vide | 4050 | 2.53x | yes |
| keyed-shuffle | 10 | plain | 1834 | 1.00x | yes |
| keyed-shuffle | 10 | blend | 3304 | 1.80x | yes |
| keyed-shuffle | 10 | compose | 3576 | 1.95x | yes |
| keyed-shuffle | 10 | fusion | 20369 | 11.11x | yes |
| keyed-shuffle | 10 | fusion-charm | 19320 | 10.54x | yes |
| keyed-shuffle | 10 | react | 27554 | 15.03x | yes |
| keyed-shuffle | 10 | react-reflex | 27644 | 15.08x | yes |
| keyed-shuffle | 10 | react-upstream | 28364 | 15.47x | yes |
| keyed-shuffle | 10 | roact | 5901 | 3.22x | yes |
| keyed-shuffle | 10 | seam | 10572 | 5.77x | yes |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-shuffle | 10 | vide | 4328 | 2.36x | yes |
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
| animate-many | 1 | plain | 2900 | 1.00x | yes |
| animate-many | 1 | blend | 12024 | 4.15x | yes |
| animate-many | 1 | compose | 7814 | 2.69x | yes |
| animate-many | 1 | fusion | 106743 | 36.81x | yes |
| animate-many | 1 | fusion-charm | 107520 | 37.08x | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — |
| animate-many | 1 | seam | 22945 | 7.91x | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — |
| animate-many | 1 | vide | 8810 | 3.04x | yes |
| status-panel | 20 | plain | 1114 | 1.00x | yes |
| status-panel | 20 | blend | 2537 | 2.28x | yes |
| status-panel | 20 | compose | 2774 | 2.49x | yes |
| status-panel | 20 | fusion | 3973 | 3.56x | yes |
| status-panel | 20 | fusion-charm | 4106 | 3.68x | yes |
| status-panel | 20 | react | 4605 | 4.13x | yes |
| status-panel | 20 | react-reflex | 4305 | 3.86x | yes |
| status-panel | 20 | react-upstream | 4380 | 3.93x | yes |
| status-panel | 20 | roact | 2512 | 2.25x | yes |
| status-panel | 20 | seam | 4660 | 4.18x | yes |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| status-panel | 20 | vide | 2754 | 2.47x | yes |
| mount-cycles | 1 | plain | 45271 | 1.00x | yes |
| mount-cycles | 1 | blend | 70337 | 1.55x | yes |
| mount-cycles | 1 | compose | 53746 | 1.19x | yes |
| mount-cycles | 1 | fusion | 56765 | 1.25x | yes |
| mount-cycles | 1 | fusion-charm | 57510 | 1.27x | yes |
| mount-cycles | 1 | react | 60926 | 1.35x | yes |
| mount-cycles | 1 | react-reflex | 61154 | 1.35x | yes |
| mount-cycles | 1 | react-upstream | 61498 | 1.36x | yes |
| mount-cycles | 1 | roact | 54732 | 1.21x | yes |
| mount-cycles | 1 | seam | 49484 | 1.09x | yes |
| mount-cycles | 1 | signals | 49722 | 1.10x | yes |
| mount-cycles | 1 | vide | 52995 | 1.17x | yes |
| scene-3d | 20 | plain | 5407 | 1.00x | yes |
| scene-3d | 20 | blend | 8902 | 1.65x | yes |
| scene-3d | 20 | compose | 7263 | 1.34x | yes |
| scene-3d | 20 | fusion | 59598 | 11.02x | yes |
| scene-3d | 20 | fusion-charm | 57097 | 10.56x | yes |
| scene-3d | 20 | react | 6608 | 1.22x | yes |
| scene-3d | 20 | react-reflex | 6548 | 1.21x | yes |
| scene-3d | 20 | react-upstream | 6764 | 1.25x | yes |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — |
| scene-3d | 20 | seam | 18629 | 3.45x | yes |
| scene-3d | 20 | signals | 12779 | 2.36x | yes |
| scene-3d | 20 | vide | 8082 | 1.49x | yes |

## Summary

The geometric mean divides each measured median Luau time by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain median below that reads 0. Such a workload has no ratio and is not in the geometric mean; its times still compare the libraries.

| Lane | Measured | Geometric mean time / plain |
| --- | ---: | ---: |
| plain | 20 | 1.00x |
| blend | 20 | 2.00x |
| compose | 20 | 1.63x |
| fusion | 16 | 3.36x |
| fusion-charm | 16 | 3.02x |
| react | 19 | 3.35x |
| react-reflex | 19 | 3.68x |
| react-upstream | 19 | 3.37x |
| roact | 18 | 2.02x |
| seam | 20 | 3.01x |
| signals | 9 | 1.43x |
| vide | 20 | 1.79x |
