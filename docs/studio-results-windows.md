# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D 16-Core Processor           |
| Cores | 32 |
| Memory | 62 GiB |
| Model | Micro-Star International Co., Ltd. MS-7E47 |
| Operating system | Microsoft Windows 11 Pro 10.0.26200 |
| Roblox Studio | 0.745.0.7451137 |
| Context | client |
| Harness revision | `b6111d2` |
| Date | 2026-10-29 |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same tree as plain |
| --- | ---: | --- | ---: | ---: | --- |
| cold-mount-100 | 1 | plain | 5294 | 1.00x | yes |
| cold-mount-100 | 1 | blend | 4950 | 0.94x | yes |
| cold-mount-100 | 1 | compose | 4450 | 0.84x | yes |
| cold-mount-100 | 1 | fusion | 4400 | 0.83x | yes |
| cold-mount-100 | 1 | fusion-charm | 4557 | 0.86x | yes |
| cold-mount-100 | 1 | react | 4496 | 0.85x | yes |
| cold-mount-100 | 1 | react-reflex | 4594 | 0.87x | yes |
| cold-mount-100 | 1 | react-upstream | 4601 | 0.87x | yes |
| cold-mount-100 | 1 | roact | 4341 | 0.82x | yes |
| cold-mount-100 | 1 | seam | 4423 | 0.84x | yes |
| cold-mount-100 | 1 | signals | 4216 | 0.80x | yes |
| cold-mount-100 | 1 | vide | 4450 | 0.84x | yes |
| cold-mount-1000 | 1 | plain | 47840 | 1.00x | yes |
| cold-mount-1000 | 1 | blend | 52308 | 1.09x | yes |
| cold-mount-1000 | 1 | compose | 46183 | 0.97x | yes |
| cold-mount-1000 | 1 | fusion | 47112 | 0.98x | yes |
| cold-mount-1000 | 1 | fusion-charm | 48168 | 1.01x | yes |
| cold-mount-1000 | 1 | react | 47208 | 0.99x | yes |
| cold-mount-1000 | 1 | react-reflex | 49624 | 1.04x | yes |
| cold-mount-1000 | 1 | react-upstream | 49309 | 1.03x | yes |
| cold-mount-1000 | 1 | roact | 46906 | 0.98x | yes |
| cold-mount-1000 | 1 | seam | 45700 | 0.96x | yes |
| cold-mount-1000 | 1 | signals | 43901 | 0.92x | yes |
| cold-mount-1000 | 1 | vide | 47276 | 0.99x | yes |
| cold-mount-10000 | 1 | plain | 928408 | 1.00x | yes |
| cold-mount-10000 | 1 | blend | 1042533 | 1.12x | yes |
| cold-mount-10000 | 1 | compose | 929500 | 1.00x | yes |
| cold-mount-10000 | 1 | fusion | 981908 | 1.06x | yes |
| cold-mount-10000 | 1 | fusion-charm | 978207 | 1.05x | yes |
| cold-mount-10000 | 1 | react | 1011439 | 1.09x | yes |
| cold-mount-10000 | 1 | react-reflex | 996784 | 1.07x | yes |
| cold-mount-10000 | 1 | react-upstream | 1011296 | 1.09x | yes |
| cold-mount-10000 | 1 | roact | 989873 | 1.07x | yes |
| cold-mount-10000 | 1 | seam | 955468 | 1.03x | yes |
| cold-mount-10000 | 1 | signals | 929076 | 1.00x | yes |
| cold-mount-10000 | 1 | vide | 982583 | 1.06x | yes |
| mount-dispose | 5 | plain | 44476 | 1.00x | yes |
| mount-dispose | 5 | blend | 54538 | 1.23x | yes |
| mount-dispose | 5 | compose | 46481 | 1.05x | yes |
| mount-dispose | 5 | fusion | 47904 | 1.08x | yes |
| mount-dispose | 5 | fusion-charm | 47964 | 1.08x | yes |
| mount-dispose | 5 | react | 49646 | 1.12x | yes |
| mount-dispose | 5 | react-reflex | 47954 | 1.08x | yes |
| mount-dispose | 5 | react-upstream | 49657 | 1.12x | yes |
| mount-dispose | 5 | roact | 48063 | 1.08x | yes |
| mount-dispose | 5 | seam | 45902 | 1.03x | yes |
| mount-dispose | 5 | signals | 45161 | 1.02x | yes |
| mount-dispose | 5 | vide | 47258 | 1.06x | yes |
| update-leaf | 50 | plain | 1900 | 1.00x | yes |
| update-leaf | 50 | blend | 5202 | 2.74x | yes |
| update-leaf | 50 | compose | 5732 | 3.02x | yes |
| update-leaf | 50 | fusion | 5510 | 2.90x | yes |
| update-leaf | 50 | fusion-charm | 1200 | 0.63x | yes |
| update-leaf | 50 | react | 5150 | 2.71x | yes |
| update-leaf | 50 | react-reflex | 5718 | 3.01x | yes |
| update-leaf | 50 | react-upstream | 5600 | 2.95x | yes |
| update-leaf | 50 | roact | 5169 | 2.72x | yes |
| update-leaf | 50 | seam | 5085 | 2.68x | yes |
| update-leaf | 50 | signals | 5336 | 2.81x | yes |
| update-leaf | 50 | vide | 5200 | 2.74x | yes |
| update-fanout | 20 | plain | 227500 | 1.00x | yes |
| update-fanout | 20 | blend | 234736 | 1.03x | yes |
| update-fanout | 20 | compose | 246850 | 1.09x | yes |
| update-fanout | 20 | fusion | 234045 | 1.03x | yes |
| update-fanout | 20 | fusion-charm | 236054 | 1.04x | yes |
| update-fanout | 20 | react | 235296 | 1.03x | yes |
| update-fanout | 20 | react-reflex | 221938 | 0.98x | yes |
| update-fanout | 20 | react-upstream | 233888 | 1.03x | yes |
| update-fanout | 20 | roact | 231442 | 1.02x | yes |
| update-fanout | 20 | seam | 221136 | 0.97x | yes |
| update-fanout | 20 | signals | 236480 | 1.04x | yes |
| update-fanout | 20 | vide | 238554 | 1.05x | yes |
| update-batched | 20 | plain | 4300 | 1.00x | yes |
| update-batched | 20 | blend | 10532 | 2.45x | yes |
| update-batched | 20 | compose | 7064 | 1.64x | yes |
| update-batched | 20 | fusion | 18977 | 4.41x | yes |
| update-batched | 20 | fusion-charm | 38831 | 9.03x | yes |
| update-batched | 20 | react | 7350 | 1.71x | yes |
| update-batched | 20 | react-reflex | 74910 | 17.42x | yes |
| update-batched | 20 | react-upstream | 7326 | 1.70x | yes |
| update-batched | 20 | roact | 7659 | 1.78x | yes |
| update-batched | 20 | seam | 11250 | 2.62x | yes |
| update-batched | 20 | signals | 8750 | 2.03x | yes |
| update-batched | 20 | vide | 8216 | 1.91x | yes |
| update-repeated | 10 | plain | 0 | plain below resolution | yes |
| update-repeated | 10 | blend | 2550 | plain below resolution | yes |
| update-repeated | 10 | compose | 450 | plain below resolution | yes |
| update-repeated | 10 | fusion | 24100 | plain below resolution | yes |
| update-repeated | 10 | fusion-charm | 950 | plain below resolution | yes |
| update-repeated | 10 | react | 4000 | plain below resolution | yes |
| update-repeated | 10 | react-reflex | 700 | plain below resolution | yes |
| update-repeated | 10 | react-upstream | 4828 | plain below resolution | yes |
| update-repeated | 10 | roact | 5849 | plain below resolution | yes |
| update-repeated | 10 | seam | 1200 | plain below resolution | yes |
| update-repeated | 10 | signals | 700 | plain below resolution | yes |
| update-repeated | 10 | vide | 450 | plain below resolution | yes |
| branch-swap | 20 | plain | 22600 | 1.00x | yes |
| branch-swap | 20 | blend | 27559 | 1.22x | yes |
| branch-swap | 20 | compose | 25736 | 1.14x | yes |
| branch-swap | 20 | fusion | 26480 | 1.17x | yes |
| branch-swap | 20 | fusion-charm | 5750 | 0.25x | yes |
| branch-swap | 20 | react | 28476 | 1.26x | yes |
| branch-swap | 20 | react-reflex | 27250 | 1.21x | yes |
| branch-swap | 20 | react-upstream | 27452 | 1.21x | yes |
| branch-swap | 20 | roact | 25514 | 1.13x | yes |
| branch-swap | 20 | seam | 24965 | 1.10x | yes |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — |
| branch-swap | 20 | vide | 25909 | 1.15x | yes |
| keyed-append | 10 | plain | 604 | 1.00x | yes |
| keyed-append | 10 | blend | 3024 | 5.00x | yes |
| keyed-append | 10 | compose | 1600 | 2.65x | yes |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | react | 7690 | 12.72x | yes |
| keyed-append | 10 | react-reflex | 6714 | 11.11x | yes |
| keyed-append | 10 | react-upstream | 6818 | 11.28x | yes |
| keyed-append | 10 | roact | 3200 | 5.29x | yes |
| keyed-append | 10 | seam | 7949 | 13.15x | yes |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-append | 10 | vide | 1800 | 2.98x | yes |
| keyed-prepend | 10 | plain | 1800 | 1.00x | yes |
| keyed-prepend | 10 | blend | 4201 | 2.33x | yes |
| keyed-prepend | 10 | compose | 3705 | 2.06x | yes |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | react | 11264 | 6.26x | yes |
| keyed-prepend | 10 | react-reflex | 10502 | 5.83x | yes |
| keyed-prepend | 10 | react-upstream | 10616 | 5.90x | yes |
| keyed-prepend | 10 | roact | 5150 | 2.86x | yes |
| keyed-prepend | 10 | seam | 9300 | 5.17x | yes |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-prepend | 10 | vide | 4446 | 2.47x | yes |
| keyed-insert | 10 | plain | 1200 | 1.00x | yes |
| keyed-insert | 10 | blend | 3550 | 2.96x | yes |
| keyed-insert | 10 | compose | 2800 | 2.33x | yes |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | react | 9026 | 7.52x | yes |
| keyed-insert | 10 | react-reflex | 8850 | 7.38x | yes |
| keyed-insert | 10 | react-upstream | 9058 | 7.55x | yes |
| keyed-insert | 10 | roact | 4600 | 3.83x | yes |
| keyed-insert | 10 | seam | 8852 | 7.38x | yes |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-insert | 10 | vide | 2974 | 2.48x | yes |
| keyed-remove | 10 | plain | 1100 | 1.00x | yes |
| keyed-remove | 10 | blend | 3400 | 3.09x | yes |
| keyed-remove | 10 | compose | 2618 | 2.38x | yes |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | react | 9086 | 8.26x | yes |
| keyed-remove | 10 | react-reflex | 8454 | 7.69x | yes |
| keyed-remove | 10 | react-upstream | 8606 | 7.82x | yes |
| keyed-remove | 10 | roact | 4603 | 4.18x | yes |
| keyed-remove | 10 | seam | 8164 | 7.42x | yes |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-remove | 10 | vide | 3006 | 2.73x | yes |
| keyed-replace | 10 | plain | 28542 | 1.00x | yes |
| keyed-replace | 10 | blend | 90886 | 3.18x | yes |
| keyed-replace | 10 | compose | 51860 | 1.82x | yes |
| keyed-replace | 10 | fusion | 80575 | 2.82x | yes |
| keyed-replace | 10 | fusion-charm | 76376 | 2.68x | yes |
| keyed-replace | 10 | react | 56476 | 1.98x | yes |
| keyed-replace | 10 | react-reflex | 57920 | 2.03x | yes |
| keyed-replace | 10 | react-upstream | 56724 | 1.99x | yes |
| keyed-replace | 10 | roact | 37946 | 1.33x | yes |
| keyed-replace | 10 | seam | 116723 | 4.09x | yes |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-replace | 10 | vide | 51177 | 1.79x | yes |
| keyed-reverse | 10 | plain | 1204 | 1.00x | yes |
| keyed-reverse | 10 | blend | 2205 | 1.83x | yes |
| keyed-reverse | 10 | compose | 2181 | 1.81x | yes |
| keyed-reverse | 10 | fusion | 15750 | 13.09x | yes |
| keyed-reverse | 10 | fusion-charm | 14702 | 12.22x | yes |
| keyed-reverse | 10 | react | 21909 | 18.20x | yes |
| keyed-reverse | 10 | react-reflex | 21916 | 18.21x | yes |
| keyed-reverse | 10 | react-upstream | 23002 | 19.11x | yes |
| keyed-reverse | 10 | roact | 4484 | 3.73x | yes |
| keyed-reverse | 10 | seam | 7903 | 6.57x | yes |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-reverse | 10 | vide | 2650 | 2.20x | yes |
| keyed-rotate | 10 | plain | 1100 | 1.00x | yes |
| keyed-rotate | 10 | blend | 2151 | 1.96x | yes |
| keyed-rotate | 10 | compose | 2300 | 2.09x | yes |
| keyed-rotate | 10 | fusion | 15764 | 14.33x | yes |
| keyed-rotate | 10 | fusion-charm | 14763 | 13.42x | yes |
| keyed-rotate | 10 | react | 16154 | 14.69x | yes |
| keyed-rotate | 10 | react-reflex | 15746 | 14.31x | yes |
| keyed-rotate | 10 | react-upstream | 15632 | 14.21x | yes |
| keyed-rotate | 10 | roact | 4500 | 4.09x | yes |
| keyed-rotate | 10 | seam | 7601 | 6.91x | yes |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-rotate | 10 | vide | 2600 | 2.36x | yes |
| keyed-shuffle | 10 | plain | 1200 | 1.00x | yes |
| keyed-shuffle | 10 | blend | 2350 | 1.96x | yes |
| keyed-shuffle | 10 | compose | 2300 | 1.92x | yes |
| keyed-shuffle | 10 | fusion | 15251 | 12.71x | yes |
| keyed-shuffle | 10 | fusion-charm | 15069 | 12.56x | yes |
| keyed-shuffle | 10 | react | 15016 | 12.51x | yes |
| keyed-shuffle | 10 | react-reflex | 14782 | 12.32x | yes |
| keyed-shuffle | 10 | react-upstream | 14750 | 12.29x | yes |
| keyed-shuffle | 10 | roact | 4201 | 3.50x | yes |
| keyed-shuffle | 10 | seam | 7411 | 6.18x | yes |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-shuffle | 10 | vide | 2600 | 2.17x | yes |
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
| animate-many | 1 | plain | 2342 | 1.00x | yes |
| animate-many | 1 | blend | 10290 | 4.39x | yes |
| animate-many | 1 | compose | 6900 | 2.95x | yes |
| animate-many | 1 | fusion | 67632 | 28.88x | yes |
| animate-many | 1 | fusion-charm | 65890 | 28.14x | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — |
| animate-many | 1 | seam | 19750 | 8.43x | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — |
| animate-many | 1 | vide | 9148 | 3.91x | yes |
| status-panel | 20 | plain | 1750 | 1.00x | yes |
| status-panel | 20 | blend | 4300 | 2.46x | yes |
| status-panel | 20 | compose | 4450 | 2.54x | yes |
| status-panel | 20 | fusion | 5550 | 3.17x | yes |
| status-panel | 20 | fusion-charm | 2500 | 1.43x | yes |
| status-panel | 20 | react | 6000 | 3.43x | yes |
| status-panel | 20 | react-reflex | 5964 | 3.41x | yes |
| status-panel | 20 | react-upstream | 6048 | 3.46x | yes |
| status-panel | 20 | roact | 4400 | 2.51x | yes |
| status-panel | 20 | seam | 5282 | 3.02x | yes |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| status-panel | 20 | vide | 4171 | 2.38x | yes |
| mount-cycles | 1 | plain | 84104 | 1.00x | yes |
| mount-cycles | 1 | blend | 108914 | 1.29x | yes |
| mount-cycles | 1 | compose | 96782 | 1.15x | yes |
| mount-cycles | 1 | fusion | 101029 | 1.20x | yes |
| mount-cycles | 1 | fusion-charm | 98352 | 1.17x | yes |
| mount-cycles | 1 | react | 100450 | 1.19x | yes |
| mount-cycles | 1 | react-reflex | 101920 | 1.21x | yes |
| mount-cycles | 1 | react-upstream | 100726 | 1.20x | yes |
| mount-cycles | 1 | roact | 96854 | 1.15x | yes |
| mount-cycles | 1 | seam | 92028 | 1.09x | yes |
| mount-cycles | 1 | signals | 91536 | 1.09x | yes |
| mount-cycles | 1 | vide | 95770 | 1.14x | yes |
| scene-3d | 20 | plain | 4450 | 1.00x | yes |
| scene-3d | 20 | blend | 9400 | 2.11x | yes |
| scene-3d | 20 | compose | 6612 | 1.49x | yes |
| scene-3d | 20 | fusion | 42214 | 9.49x | yes |
| scene-3d | 20 | fusion-charm | 42486 | 9.55x | yes |
| scene-3d | 20 | react | 6574 | 1.48x | yes |
| scene-3d | 20 | react-reflex | 6398 | 1.44x | yes |
| scene-3d | 20 | react-upstream | 6501 | 1.46x | yes |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — |
| scene-3d | 20 | seam | 15100 | 3.39x | yes |
| scene-3d | 20 | signals | 10748 | 2.42x | yes |
| scene-3d | 20 | vide | 7841 | 1.76x | yes |

## Summary

The geometric mean divides each measured median Luau time by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain median below that reads 0. Such a workload has no ratio and is not in the geometric mean; its times still compare the libraries.

The shared column uses only the 8 workloads that every lane measured: `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000`, `mount-dispose`, `update-leaf`, `update-fanout`, `update-batched`, `mount-cycles`.

| Lane | Measured | Geometric mean time / plain | Shared workloads, geometric mean / plain |
| --- | ---: | ---: | ---: |
| plain | 20 | 1.00x | 1.00x |
| blend | 20 | 1.98x | 1.37x |
| compose | 20 | 1.66x | 1.23x |
| fusion | 16 | 3.16x | 1.40x |
| fusion-charm | 16 | 2.57x | 1.27x |
| react | 19 | 3.01x | 1.25x |
| react-reflex | 19 | 3.34x | 1.68x |
| react-upstream | 19 | 2.99x | 1.27x |
| roact | 18 | 2.00x | 1.23x |
| seam | 20 | 2.95x | 1.26x |
| signals | 9 | 1.31x | 1.22x |
| vide | 20 | 1.79x | 1.25x |
