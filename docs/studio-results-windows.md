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
| Harness revision | `d7c377b` |
| Date | 2026-10-28 |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same tree as plain |
| --- | ---: | --- | ---: | ---: | --- |
| cold-mount-100 | 1 | plain | 4650 | 1.00x | yes |
| cold-mount-100 | 1 | blend | 6100 | 1.31x | yes |
| cold-mount-100 | 1 | compose | 4550 | 0.98x | yes |
| cold-mount-100 | 1 | fusion | 4450 | 0.96x | yes |
| cold-mount-100 | 1 | fusion-charm | 4597 | 0.99x | yes |
| cold-mount-100 | 1 | react | 4708 | 1.01x | yes |
| cold-mount-100 | 1 | react-reflex | 4450 | 0.96x | yes |
| cold-mount-100 | 1 | react-upstream | 4500 | 0.97x | yes |
| cold-mount-100 | 1 | roact | 4250 | 0.91x | yes |
| cold-mount-100 | 1 | seam | 4400 | 0.95x | yes |
| cold-mount-100 | 1 | signals | 4400 | 0.95x | yes |
| cold-mount-100 | 1 | vide | 4550 | 0.98x | yes |
| cold-mount-1000 | 1 | plain | 45740 | 1.00x | yes |
| cold-mount-1000 | 1 | blend | 53202 | 1.16x | yes |
| cold-mount-1000 | 1 | compose | 45100 | 0.99x | yes |
| cold-mount-1000 | 1 | fusion | 47680 | 1.04x | yes |
| cold-mount-1000 | 1 | fusion-charm | 49403 | 1.08x | yes |
| cold-mount-1000 | 1 | react | 53984 | 1.18x | yes |
| cold-mount-1000 | 1 | react-reflex | 48896 | 1.07x | yes |
| cold-mount-1000 | 1 | react-upstream | 46290 | 1.01x | yes |
| cold-mount-1000 | 1 | roact | 46166 | 1.01x | yes |
| cold-mount-1000 | 1 | seam | 45980 | 1.01x | yes |
| cold-mount-1000 | 1 | signals | 45321 | 0.99x | yes |
| cold-mount-1000 | 1 | vide | 47072 | 1.03x | yes |
| cold-mount-10000 | 1 | plain | 932628 | 1.00x | yes |
| cold-mount-10000 | 1 | blend | 1055748 | 1.13x | yes |
| cold-mount-10000 | 1 | compose | 997748 | 1.07x | yes |
| cold-mount-10000 | 1 | fusion | 968206 | 1.04x | yes |
| cold-mount-10000 | 1 | fusion-charm | 963170 | 1.03x | yes |
| cold-mount-10000 | 1 | react | 1012646 | 1.09x | yes |
| cold-mount-10000 | 1 | react-reflex | 979916 | 1.05x | yes |
| cold-mount-10000 | 1 | react-upstream | 1020014 | 1.09x | yes |
| cold-mount-10000 | 1 | roact | 1004602 | 1.08x | yes |
| cold-mount-10000 | 1 | seam | 961482 | 1.03x | yes |
| cold-mount-10000 | 1 | signals | 938642 | 1.01x | yes |
| cold-mount-10000 | 1 | vide | 975494 | 1.05x | yes |
| mount-dispose | 5 | plain | 44360 | 1.00x | yes |
| mount-dispose | 5 | blend | 52786 | 1.19x | yes |
| mount-dispose | 5 | compose | 47714 | 1.08x | yes |
| mount-dispose | 5 | fusion | 49190 | 1.11x | yes |
| mount-dispose | 5 | fusion-charm | 50414 | 1.14x | yes |
| mount-dispose | 5 | react | 51202 | 1.15x | yes |
| mount-dispose | 5 | react-reflex | 48754 | 1.10x | yes |
| mount-dispose | 5 | react-upstream | 49300 | 1.11x | yes |
| mount-dispose | 5 | roact | 48104 | 1.08x | yes |
| mount-dispose | 5 | seam | 47637 | 1.07x | yes |
| mount-dispose | 5 | signals | 47844 | 1.08x | yes |
| mount-dispose | 5 | vide | 49072 | 1.11x | yes |
| update-leaf | 50 | plain | 1800 | 1.00x | yes |
| update-leaf | 50 | blend | 5400 | 3.00x | yes |
| update-leaf | 50 | compose | 5250 | 2.92x | yes |
| update-leaf | 50 | fusion | 5600 | 3.11x | yes |
| update-leaf | 50 | fusion-charm | 1150 | 0.64x | yes |
| update-leaf | 50 | react | 5000 | 2.78x | yes |
| update-leaf | 50 | react-reflex | 5952 | 3.31x | yes |
| update-leaf | 50 | react-upstream | 5338 | 2.97x | yes |
| update-leaf | 50 | roact | 5766 | 3.20x | yes |
| update-leaf | 50 | seam | 5250 | 2.92x | yes |
| update-leaf | 50 | signals | 5401 | 3.00x | yes |
| update-leaf | 50 | vide | 5650 | 3.14x | yes |
| update-fanout | 20 | plain | 225000 | 1.00x | yes |
| update-fanout | 20 | blend | 244202 | 1.09x | yes |
| update-fanout | 20 | compose | 259305 | 1.15x | yes |
| update-fanout | 20 | fusion | 239008 | 1.06x | yes |
| update-fanout | 20 | fusion-charm | 250284 | 1.11x | yes |
| update-fanout | 20 | react | 265596 | 1.18x | yes |
| update-fanout | 20 | react-reflex | 234174 | 1.04x | yes |
| update-fanout | 20 | react-upstream | 250145 | 1.11x | yes |
| update-fanout | 20 | roact | 250474 | 1.11x | yes |
| update-fanout | 20 | seam | 221594 | 0.98x | yes |
| update-fanout | 20 | signals | 240600 | 1.07x | yes |
| update-fanout | 20 | vide | 242418 | 1.08x | yes |
| update-batched | 20 | plain | 4250 | 1.00x | yes |
| update-batched | 20 | blend | 10700 | 2.52x | yes |
| update-batched | 20 | compose | 6973 | 1.64x | yes |
| update-batched | 20 | fusion | 19900 | 4.68x | yes |
| update-batched | 20 | fusion-charm | 37562 | 8.84x | yes |
| update-batched | 20 | react | 7550 | 1.78x | yes |
| update-batched | 20 | react-reflex | 63974 | 15.05x | yes |
| update-batched | 20 | react-upstream | 7500 | 1.76x | yes |
| update-batched | 20 | roact | 8102 | 1.91x | yes |
| update-batched | 20 | seam | 10971 | 2.58x | yes |
| update-batched | 20 | signals | 9207 | 2.17x | yes |
| update-batched | 20 | vide | 8752 | 2.06x | yes |
| update-repeated | 10 | plain | 0 | plain below resolution | yes |
| update-repeated | 10 | blend | 2808 | plain below resolution | yes |
| update-repeated | 10 | compose | 500 | plain below resolution | yes |
| update-repeated | 10 | fusion | 23450 | plain below resolution | yes |
| update-repeated | 10 | fusion-charm | 1050 | plain below resolution | yes |
| update-repeated | 10 | react | 4104 | plain below resolution | yes |
| update-repeated | 10 | react-reflex | 550 | plain below resolution | yes |
| update-repeated | 10 | react-upstream | 4708 | plain below resolution | yes |
| update-repeated | 10 | roact | 5790 | plain below resolution | yes |
| update-repeated | 10 | seam | 1250 | plain below resolution | yes |
| update-repeated | 10 | signals | 700 | plain below resolution | yes |
| update-repeated | 10 | vide | 500 | plain below resolution | yes |
| branch-swap | 20 | plain | 22676 | 1.00x | yes |
| branch-swap | 20 | blend | 28498 | 1.26x | yes |
| branch-swap | 20 | compose | 26782 | 1.18x | yes |
| branch-swap | 20 | fusion | 26954 | 1.19x | yes |
| branch-swap | 20 | fusion-charm | 5750 | 0.25x | yes |
| branch-swap | 20 | react | 27671 | 1.22x | yes |
| branch-swap | 20 | react-reflex | 27168 | 1.20x | yes |
| branch-swap | 20 | react-upstream | 27900 | 1.23x | yes |
| branch-swap | 20 | roact | 26224 | 1.16x | yes |
| branch-swap | 20 | seam | 25814 | 1.14x | yes |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — |
| branch-swap | 20 | vide | 26300 | 1.16x | yes |
| keyed-append | 10 | plain | 650 | 1.00x | yes |
| keyed-append | 10 | blend | 3200 | 4.92x | yes |
| keyed-append | 10 | compose | 1600 | 2.46x | yes |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | react | 6750 | 10.38x | yes |
| keyed-append | 10 | react-reflex | 6533 | 10.05x | yes |
| keyed-append | 10 | react-upstream | 6450 | 9.92x | yes |
| keyed-append | 10 | roact | 3650 | 5.62x | yes |
| keyed-append | 10 | seam | 8468 | 13.03x | yes |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-append | 10 | vide | 1750 | 2.69x | yes |
| keyed-prepend | 10 | plain | 1800 | 1.00x | yes |
| keyed-prepend | 10 | blend | 4340 | 2.41x | yes |
| keyed-prepend | 10 | compose | 3650 | 2.03x | yes |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | react | 10300 | 5.72x | yes |
| keyed-prepend | 10 | react-reflex | 10500 | 5.83x | yes |
| keyed-prepend | 10 | react-upstream | 10164 | 5.65x | yes |
| keyed-prepend | 10 | roact | 5450 | 3.03x | yes |
| keyed-prepend | 10 | seam | 9350 | 5.19x | yes |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-prepend | 10 | vide | 4264 | 2.37x | yes |
| keyed-insert | 10 | plain | 1168 | 1.00x | yes |
| keyed-insert | 10 | blend | 3800 | 3.25x | yes |
| keyed-insert | 10 | compose | 2650 | 2.27x | yes |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | react | 9844 | 8.43x | yes |
| keyed-insert | 10 | react-reflex | 8902 | 7.62x | yes |
| keyed-insert | 10 | react-upstream | 9329 | 7.99x | yes |
| keyed-insert | 10 | roact | 4800 | 4.11x | yes |
| keyed-insert | 10 | seam | 8950 | 7.67x | yes |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-insert | 10 | vide | 3096 | 2.65x | yes |
| keyed-remove | 10 | plain | 1150 | 1.00x | yes |
| keyed-remove | 10 | blend | 3601 | 3.13x | yes |
| keyed-remove | 10 | compose | 2600 | 2.26x | yes |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | react | 9333 | 8.12x | yes |
| keyed-remove | 10 | react-reflex | 8550 | 7.43x | yes |
| keyed-remove | 10 | react-upstream | 9000 | 7.83x | yes |
| keyed-remove | 10 | roact | 4550 | 3.96x | yes |
| keyed-remove | 10 | seam | 8665 | 7.53x | yes |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-remove | 10 | vide | 3050 | 2.65x | yes |
| keyed-replace | 10 | plain | 29300 | 1.00x | yes |
| keyed-replace | 10 | blend | 87585 | 2.99x | yes |
| keyed-replace | 10 | compose | 51370 | 1.75x | yes |
| keyed-replace | 10 | fusion | 82830 | 2.83x | yes |
| keyed-replace | 10 | fusion-charm | 76716 | 2.62x | yes |
| keyed-replace | 10 | react | 57705 | 1.97x | yes |
| keyed-replace | 10 | react-reflex | 57422 | 1.96x | yes |
| keyed-replace | 10 | react-upstream | 58091 | 1.98x | yes |
| keyed-replace | 10 | roact | 40009 | 1.37x | yes |
| keyed-replace | 10 | seam | 111073 | 3.79x | yes |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-replace | 10 | vide | 52052 | 1.78x | yes |
| keyed-reverse | 10 | plain | 1100 | 1.00x | yes |
| keyed-reverse | 10 | blend | 2400 | 2.18x | yes |
| keyed-reverse | 10 | compose | 2302 | 2.09x | yes |
| keyed-reverse | 10 | fusion | 16320 | 14.84x | yes |
| keyed-reverse | 10 | fusion-charm | 14450 | 13.14x | yes |
| keyed-reverse | 10 | react | 27366 | 24.88x | yes |
| keyed-reverse | 10 | react-reflex | 22814 | 20.74x | yes |
| keyed-reverse | 10 | react-upstream | 22352 | 20.32x | yes |
| keyed-reverse | 10 | roact | 4600 | 4.18x | yes |
| keyed-reverse | 10 | seam | 7916 | 7.20x | yes |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-reverse | 10 | vide | 2600 | 2.36x | yes |
| keyed-rotate | 10 | plain | 1150 | 1.00x | yes |
| keyed-rotate | 10 | blend | 2280 | 1.98x | yes |
| keyed-rotate | 10 | compose | 2300 | 2.00x | yes |
| keyed-rotate | 10 | fusion | 15100 | 13.13x | yes |
| keyed-rotate | 10 | fusion-charm | 15368 | 13.36x | yes |
| keyed-rotate | 10 | react | 16408 | 14.27x | yes |
| keyed-rotate | 10 | react-reflex | 15850 | 13.78x | yes |
| keyed-rotate | 10 | react-upstream | 15566 | 13.54x | yes |
| keyed-rotate | 10 | roact | 4574 | 3.98x | yes |
| keyed-rotate | 10 | seam | 7950 | 6.91x | yes |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-rotate | 10 | vide | 2700 | 2.35x | yes |
| keyed-shuffle | 10 | plain | 1200 | 1.00x | yes |
| keyed-shuffle | 10 | blend | 2500 | 2.08x | yes |
| keyed-shuffle | 10 | compose | 2500 | 2.08x | yes |
| keyed-shuffle | 10 | fusion | 14304 | 11.92x | yes |
| keyed-shuffle | 10 | fusion-charm | 14860 | 12.38x | yes |
| keyed-shuffle | 10 | react | 14700 | 12.25x | yes |
| keyed-shuffle | 10 | react-reflex | 14956 | 12.46x | yes |
| keyed-shuffle | 10 | react-upstream | 15376 | 12.81x | yes |
| keyed-shuffle | 10 | roact | 4450 | 3.71x | yes |
| keyed-shuffle | 10 | seam | 7502 | 6.25x | yes |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-shuffle | 10 | vide | 2800 | 2.33x | yes |
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
| animate-many | 1 | plain | 2500 | 1.00x | yes |
| animate-many | 1 | blend | 10076 | 4.03x | yes |
| animate-many | 1 | compose | 7090 | 2.84x | yes |
| animate-many | 1 | fusion | 67170 | 26.87x | yes |
| animate-many | 1 | fusion-charm | 68264 | 27.31x | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — |
| animate-many | 1 | seam | 20840 | 8.34x | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — |
| animate-many | 1 | vide | 9500 | 3.80x | yes |
| status-panel | 20 | plain | 1750 | 1.00x | yes |
| status-panel | 20 | blend | 4400 | 2.51x | yes |
| status-panel | 20 | compose | 4350 | 2.49x | yes |
| status-panel | 20 | fusion | 5450 | 3.11x | yes |
| status-panel | 20 | fusion-charm | 5950 | 3.40x | yes |
| status-panel | 20 | react | 5900 | 3.37x | yes |
| status-panel | 20 | react-reflex | 5900 | 3.37x | yes |
| status-panel | 20 | react-upstream | 5824 | 3.33x | yes |
| status-panel | 20 | roact | 4400 | 2.51x | yes |
| status-panel | 20 | seam | 5150 | 2.94x | yes |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| status-panel | 20 | vide | 4244 | 2.42x | yes |
| mount-cycles | 1 | plain | 89072 | 1.00x | yes |
| mount-cycles | 1 | blend | 108452 | 1.22x | yes |
| mount-cycles | 1 | compose | 101936 | 1.14x | yes |
| mount-cycles | 1 | fusion | 98570 | 1.11x | yes |
| mount-cycles | 1 | fusion-charm | 99636 | 1.12x | yes |
| mount-cycles | 1 | react | 105840 | 1.19x | yes |
| mount-cycles | 1 | react-reflex | 102433 | 1.15x | yes |
| mount-cycles | 1 | react-upstream | 102330 | 1.15x | yes |
| mount-cycles | 1 | roact | 96722 | 1.09x | yes |
| mount-cycles | 1 | seam | 91864 | 1.03x | yes |
| mount-cycles | 1 | signals | 93958 | 1.05x | yes |
| mount-cycles | 1 | vide | 98884 | 1.11x | yes |
| scene-3d | 20 | plain | 4400 | 1.00x | yes |
| scene-3d | 20 | blend | 9284 | 2.11x | yes |
| scene-3d | 20 | compose | 6952 | 1.58x | yes |
| scene-3d | 20 | fusion | 44169 | 10.04x | yes |
| scene-3d | 20 | fusion-charm | 43328 | 9.85x | yes |
| scene-3d | 20 | react | 6600 | 1.50x | yes |
| scene-3d | 20 | react-reflex | 6600 | 1.50x | yes |
| scene-3d | 20 | react-upstream | 6900 | 1.57x | yes |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — |
| scene-3d | 20 | seam | 15500 | 3.52x | yes |
| scene-3d | 20 | signals | 10733 | 2.44x | yes |
| scene-3d | 20 | vide | 8284 | 1.88x | yes |

## Summary

The geometric mean divides each measured median Luau time by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain median below that reads 0. Such a workload has no ratio and is not in the geometric mean; its times still compare the libraries.

The shared column uses only the 8 workloads that every lane measured: `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000`, `mount-dispose`, `update-leaf`, `update-fanout`, `update-batched`, `mount-cycles`.

| Lane | Measured | Geometric mean time / plain | Shared workloads, geometric mean / plain |
| --- | ---: | ---: | ---: |
| plain | 20 | 1.00x | 1.00x |
| blend | 20 | 2.05x | 1.46x |
| compose | 20 | 1.69x | 1.28x |
| fusion | 16 | 3.21x | 1.45x |
| fusion-charm | 16 | 2.76x | 1.31x |
| react | 19 | 3.10x | 1.34x |
| react-reflex | 19 | 3.36x | 1.70x |
| react-upstream | 19 | 3.01x | 1.30x |
| roact | 18 | 2.08x | 1.30x |
| seam | 20 | 3.01x | 1.30x |
| signals | 9 | 1.38x | 1.29x |
| vide | 20 | 1.83x | 1.32x |
