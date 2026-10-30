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
| Harness revision | `c28b7f3` |
| Date | 2026-10-29 |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same tree as plain |
| --- | ---: | --- | ---: | ---: | --- |
| cold-mount-100 | 1 | plain | 2202 | 1.00x | yes |
| cold-mount-100 | 1 | blend | 2754 | 1.25x | yes |
| cold-mount-100 | 1 | compose | 2218 | 1.01x | yes |
| cold-mount-100 | 1 | fusion | 2400 | 1.09x | yes |
| cold-mount-100 | 1 | fusion-charm | 2404 | 1.09x | yes |
| cold-mount-100 | 1 | react | 2561 | 1.16x | yes |
| cold-mount-100 | 1 | react-reflex | 2550 | 1.16x | yes |
| cold-mount-100 | 1 | react-upstream | 2700 | 1.23x | yes |
| cold-mount-100 | 1 | roact | 2401 | 1.09x | yes |
| cold-mount-100 | 1 | seam | 2454 | 1.11x | yes |
| cold-mount-100 | 1 | signals | 2102 | 0.95x | yes |
| cold-mount-100 | 1 | vide | 2510 | 1.14x | yes |
| cold-mount-1000 | 1 | plain | 23720 | 1.00x | yes |
| cold-mount-1000 | 1 | blend | 30691 | 1.29x | yes |
| cold-mount-1000 | 1 | compose | 24196 | 1.02x | yes |
| cold-mount-1000 | 1 | fusion | 26136 | 1.10x | yes |
| cold-mount-1000 | 1 | fusion-charm | 25632 | 1.08x | yes |
| cold-mount-1000 | 1 | react | 26700 | 1.13x | yes |
| cold-mount-1000 | 1 | react-reflex | 27314 | 1.15x | yes |
| cold-mount-1000 | 1 | react-upstream | 26746 | 1.13x | yes |
| cold-mount-1000 | 1 | roact | 26586 | 1.12x | yes |
| cold-mount-1000 | 1 | seam | 23632 | 1.00x | yes |
| cold-mount-1000 | 1 | signals | 23190 | 0.98x | yes |
| cold-mount-1000 | 1 | vide | 25970 | 1.09x | yes |
| cold-mount-10000 | 1 | plain | 965964 | 1.00x | yes |
| cold-mount-10000 | 1 | blend | 1111989 | 1.15x | yes |
| cold-mount-10000 | 1 | compose | 1002584 | 1.04x | yes |
| cold-mount-10000 | 1 | fusion | 1082451 | 1.12x | yes |
| cold-mount-10000 | 1 | fusion-charm | 1082087 | 1.12x | yes |
| cold-mount-10000 | 1 | react | 1058067 | 1.10x | yes |
| cold-mount-10000 | 1 | react-reflex | 1057445 | 1.09x | yes |
| cold-mount-10000 | 1 | react-upstream | 1062514 | 1.10x | yes |
| cold-mount-10000 | 1 | roact | 1067708 | 1.11x | yes |
| cold-mount-10000 | 1 | seam | 1029366 | 1.07x | yes |
| cold-mount-10000 | 1 | signals | 1008401 | 1.04x | yes |
| cold-mount-10000 | 1 | vide | 1025546 | 1.06x | yes |
| mount-dispose | 5 | plain | 22539 | 1.00x | yes |
| mount-dispose | 5 | blend | 35860 | 1.59x | yes |
| mount-dispose | 5 | compose | 26606 | 1.18x | yes |
| mount-dispose | 5 | fusion | 27454 | 1.22x | yes |
| mount-dispose | 5 | fusion-charm | 27672 | 1.23x | yes |
| mount-dispose | 5 | react | 28276 | 1.25x | yes |
| mount-dispose | 5 | react-reflex | 28364 | 1.26x | yes |
| mount-dispose | 5 | react-upstream | 28285 | 1.25x | yes |
| mount-dispose | 5 | roact | 26184 | 1.16x | yes |
| mount-dispose | 5 | seam | 23477 | 1.04x | yes |
| mount-dispose | 5 | signals | 24635 | 1.09x | yes |
| mount-dispose | 5 | vide | 26033 | 1.16x | yes |
| update-leaf | 50 | plain | 716 | 1.00x | yes |
| update-leaf | 50 | blend | 4006 | 5.60x | yes |
| update-leaf | 50 | compose | 3884 | 5.43x | yes |
| update-leaf | 50 | fusion | 4484 | 6.27x | yes |
| update-leaf | 50 | fusion-charm | 2167 | 3.03x | yes |
| update-leaf | 50 | react | 3740 | 5.23x | yes |
| update-leaf | 50 | react-reflex | 4252 | 5.94x | yes |
| update-leaf | 50 | react-upstream | 3969 | 5.55x | yes |
| update-leaf | 50 | roact | 3544 | 4.95x | yes |
| update-leaf | 50 | seam | 5214 | 7.29x | yes |
| update-leaf | 50 | signals | 2983 | 4.17x | yes |
| update-leaf | 50 | vide | 3299 | 4.61x | yes |
| update-fanout | 20 | plain | 91710 | 1.00x | yes |
| update-fanout | 20 | blend | 96810 | 1.06x | yes |
| update-fanout | 20 | compose | 102648 | 1.12x | yes |
| update-fanout | 20 | fusion | 104509 | 1.14x | yes |
| update-fanout | 20 | fusion-charm | 105138 | 1.15x | yes |
| update-fanout | 20 | react | 101468 | 1.11x | yes |
| update-fanout | 20 | react-reflex | 93580 | 1.02x | yes |
| update-fanout | 20 | react-upstream | 101758 | 1.11x | yes |
| update-fanout | 20 | roact | 101142 | 1.10x | yes |
| update-fanout | 20 | seam | 100038 | 1.09x | yes |
| update-fanout | 20 | signals | 104064 | 1.13x | yes |
| update-fanout | 20 | vide | 102086 | 1.11x | yes |
| update-batched | 20 | plain | 4506 | 1.00x | yes |
| update-batched | 20 | blend | 12124 | 2.69x | yes |
| update-batched | 20 | compose | 9230 | 2.05x | yes |
| update-batched | 20 | fusion | 22999 | 5.10x | yes |
| update-batched | 20 | fusion-charm | 43244 | 9.60x | yes |
| update-batched | 20 | react | 9515 | 2.11x | yes |
| update-batched | 20 | react-reflex | 65295 | 14.49x | yes |
| update-batched | 20 | react-upstream | 9732 | 2.16x | yes |
| update-batched | 20 | roact | 9700 | 2.15x | yes |
| update-batched | 20 | seam | 16185 | 3.59x | yes |
| update-batched | 20 | signals | 10931 | 2.43x | yes |
| update-batched | 20 | vide | 11344 | 2.52x | yes |
| update-repeated | 10 | plain | 0 | plain below resolution | yes |
| update-repeated | 10 | blend | 3618 | plain below resolution | yes |
| update-repeated | 10 | compose | 612 | plain below resolution | yes |
| update-repeated | 10 | fusion | 26162 | plain below resolution | yes |
| update-repeated | 10 | fusion-charm | 1315 | plain below resolution | yes |
| update-repeated | 10 | react | 6117 | plain below resolution | yes |
| update-repeated | 10 | react-reflex | 812 | plain below resolution | yes |
| update-repeated | 10 | react-upstream | 5868 | plain below resolution | yes |
| update-repeated | 10 | roact | 5366 | plain below resolution | yes |
| update-repeated | 10 | seam | 1744 | plain below resolution | yes |
| update-repeated | 10 | signals | 1004 | plain below resolution | yes |
| update-repeated | 10 | vide | 602 | plain below resolution | yes |
| branch-swap | 20 | plain | 13582 | 1.00x | yes |
| branch-swap | 20 | blend | 17726 | 1.31x | yes |
| branch-swap | 20 | compose | 15247 | 1.12x | yes |
| branch-swap | 20 | fusion | 15066 | 1.11x | yes |
| branch-swap | 20 | fusion-charm | 15232 | 1.12x | yes |
| branch-swap | 20 | react | 16792 | 1.24x | yes |
| branch-swap | 20 | react-reflex | 17200 | 1.27x | yes |
| branch-swap | 20 | react-upstream | 17270 | 1.27x | yes |
| branch-swap | 20 | roact | 15484 | 1.14x | yes |
| branch-swap | 20 | seam | 13926 | 1.03x | yes |
| branch-swap | 20 | signals | unsupported: Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures. | — | — |
| branch-swap | 20 | vide | 15416 | 1.14x | yes |
| keyed-append | 10 | plain | 1000 | 1.00x | yes |
| keyed-append | 10 | blend | 4474 | 4.47x | yes |
| keyed-append | 10 | compose | 2050 | 2.05x | yes |
| keyed-append | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-append | 10 | react | 10460 | 10.46x | yes |
| keyed-append | 10 | react-reflex | 10891 | 10.89x | yes |
| keyed-append | 10 | react-upstream | 10903 | 10.90x | yes |
| keyed-append | 10 | roact | 4872 | 4.87x | yes |
| keyed-append | 10 | seam | 10764 | 10.76x | yes |
| keyed-append | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-append | 10 | vide | 2948 | 2.95x | yes |
| keyed-prepend | 10 | plain | 2280 | 1.00x | yes |
| keyed-prepend | 10 | blend | 5564 | 2.44x | yes |
| keyed-prepend | 10 | compose | 5449 | 2.39x | yes |
| keyed-prepend | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-prepend | 10 | react | 16702 | 7.32x | yes |
| keyed-prepend | 10 | react-reflex | 16784 | 7.36x | yes |
| keyed-prepend | 10 | react-upstream | 17056 | 7.48x | yes |
| keyed-prepend | 10 | roact | 7694 | 3.37x | yes |
| keyed-prepend | 10 | seam | 13114 | 5.75x | yes |
| keyed-prepend | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-prepend | 10 | vide | 6116 | 2.68x | yes |
| keyed-insert | 10 | plain | 1714 | 1.00x | yes |
| keyed-insert | 10 | blend | 4974 | 2.90x | yes |
| keyed-insert | 10 | compose | 3731 | 2.18x | yes |
| keyed-insert | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-insert | 10 | react | 14410 | 8.41x | yes |
| keyed-insert | 10 | react-reflex | 14264 | 8.32x | yes |
| keyed-insert | 10 | react-upstream | 14383 | 8.39x | yes |
| keyed-insert | 10 | roact | 6516 | 3.80x | yes |
| keyed-insert | 10 | seam | 12732 | 7.43x | yes |
| keyed-insert | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-insert | 10 | vide | 4201 | 2.45x | yes |
| keyed-remove | 10 | plain | 1601 | 1.00x | yes |
| keyed-remove | 10 | blend | 5084 | 3.18x | yes |
| keyed-remove | 10 | compose | 3458 | 2.16x | yes |
| keyed-remove | 10 | fusion | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | fusion-charm | unsupported: At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity. | — | — |
| keyed-remove | 10 | react | 13904 | 8.68x | yes |
| keyed-remove | 10 | react-reflex | 13931 | 8.70x | yes |
| keyed-remove | 10 | react-upstream | 13551 | 8.46x | yes |
| keyed-remove | 10 | roact | 6678 | 4.17x | yes |
| keyed-remove | 10 | seam | 12110 | 7.56x | yes |
| keyed-remove | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-remove | 10 | vide | 4255 | 2.66x | yes |
| keyed-replace | 10 | plain | 30122 | 1.00x | yes |
| keyed-replace | 10 | blend | 99206 | 3.29x | yes |
| keyed-replace | 10 | compose | 53970 | 1.79x | yes |
| keyed-replace | 10 | fusion | 91880 | 3.05x | yes |
| keyed-replace | 10 | fusion-charm | 85646 | 2.84x | yes |
| keyed-replace | 10 | react | 81446 | 2.70x | yes |
| keyed-replace | 10 | react-reflex | 80818 | 2.68x | yes |
| keyed-replace | 10 | react-upstream | 82252 | 2.73x | yes |
| keyed-replace | 10 | roact | 43450 | 1.44x | yes |
| keyed-replace | 10 | seam | 116808 | 3.88x | yes |
| keyed-replace | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-replace | 10 | vide | 52075 | 1.73x | yes |
| keyed-reverse | 10 | plain | 1663 | 1.00x | yes |
| keyed-reverse | 10 | blend | 3537 | 2.13x | yes |
| keyed-reverse | 10 | compose | 3215 | 1.93x | yes |
| keyed-reverse | 10 | fusion | 19876 | 11.95x | yes |
| keyed-reverse | 10 | fusion-charm | 18883 | 11.35x | yes |
| keyed-reverse | 10 | react | 44550 | 26.79x | yes |
| keyed-reverse | 10 | react-reflex | 44504 | 26.76x | yes |
| keyed-reverse | 10 | react-upstream | 44666 | 26.86x | yes |
| keyed-reverse | 10 | roact | 6308 | 3.79x | yes |
| keyed-reverse | 10 | seam | 10758 | 6.47x | yes |
| keyed-reverse | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-reverse | 10 | vide | 4180 | 2.51x | yes |
| keyed-rotate | 10 | plain | 1504 | 1.00x | yes |
| keyed-rotate | 10 | blend | 3286 | 2.18x | yes |
| keyed-rotate | 10 | compose | 3702 | 2.46x | yes |
| keyed-rotate | 10 | fusion | 19225 | 12.78x | yes |
| keyed-rotate | 10 | fusion-charm | 19362 | 12.87x | yes |
| keyed-rotate | 10 | react | 30163 | 20.06x | yes |
| keyed-rotate | 10 | react-reflex | 30064 | 19.99x | yes |
| keyed-rotate | 10 | react-upstream | 30522 | 20.29x | yes |
| keyed-rotate | 10 | roact | 6188 | 4.11x | yes |
| keyed-rotate | 10 | seam | 11080 | 7.37x | yes |
| keyed-rotate | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-rotate | 10 | vide | 3918 | 2.61x | yes |
| keyed-shuffle | 10 | plain | 1642 | 1.00x | yes |
| keyed-shuffle | 10 | blend | 3350 | 2.04x | yes |
| keyed-shuffle | 10 | compose | 4066 | 2.48x | yes |
| keyed-shuffle | 10 | fusion | 19086 | 11.62x | yes |
| keyed-shuffle | 10 | fusion-charm | 19309 | 11.76x | yes |
| keyed-shuffle | 10 | react | 27228 | 16.58x | yes |
| keyed-shuffle | 10 | react-reflex | 27502 | 16.75x | yes |
| keyed-shuffle | 10 | react-upstream | 27662 | 16.85x | yes |
| keyed-shuffle | 10 | roact | 6433 | 3.92x | yes |
| keyed-shuffle | 10 | seam | 10906 | 6.64x | yes |
| keyed-shuffle | 10 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| keyed-shuffle | 10 | vide | 3954 | 2.41x | yes |
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
| animate-many | 1 | plain | 3489 | 1.00x | yes |
| animate-many | 1 | blend | 13966 | 4.00x | yes |
| animate-many | 1 | compose | 9690 | 2.78x | yes |
| animate-many | 1 | fusion | 111008 | 31.82x | yes |
| animate-many | 1 | fusion-charm | 109502 | 31.38x | yes |
| animate-many | 1 | react | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-reflex | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | react-upstream | unsupported: React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures. | — | — |
| animate-many | 1 | roact | unsupported: Roact does not include a spring. | — | — |
| animate-many | 1 | seam | 24046 | 6.89x | yes |
| animate-many | 1 | signals | unsupported: Signals is a state library. Springs are outside its scope. | — | — |
| animate-many | 1 | vide | 9429 | 2.70x | yes |
| status-panel | 20 | plain | 1000 | 1.00x | yes |
| status-panel | 20 | blend | 3245 | 3.24x | yes |
| status-panel | 20 | compose | 3854 | 3.85x | yes |
| status-panel | 20 | fusion | 5480 | 5.48x | yes |
| status-panel | 20 | fusion-charm | 5931 | 5.93x | yes |
| status-panel | 20 | react | 5879 | 5.88x | yes |
| status-panel | 20 | react-reflex | 5820 | 5.82x | yes |
| status-panel | 20 | react-upstream | 6278 | 6.28x | yes |
| status-panel | 20 | roact | 3648 | 3.65x | yes |
| status-panel | 20 | seam | 5665 | 5.66x | yes |
| status-panel | 20 | signals | unsupported: Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope. | — | — |
| status-panel | 20 | vide | 3736 | 3.73x | yes |
| mount-cycles | 1 | plain | 43818 | 1.00x | yes |
| mount-cycles | 1 | blend | 76725 | 1.75x | yes |
| mount-cycles | 1 | compose | 62440 | 1.42x | yes |
| mount-cycles | 1 | fusion | 67610 | 1.54x | yes |
| mount-cycles | 1 | fusion-charm | 62918 | 1.44x | yes |
| mount-cycles | 1 | react | 71291 | 1.63x | yes |
| mount-cycles | 1 | react-reflex | 71894 | 1.64x | yes |
| mount-cycles | 1 | react-upstream | 70354 | 1.61x | yes |
| mount-cycles | 1 | roact | 62268 | 1.42x | yes |
| mount-cycles | 1 | seam | 53278 | 1.22x | yes |
| mount-cycles | 1 | signals | 53814 | 1.23x | yes |
| mount-cycles | 1 | vide | 58477 | 1.33x | yes |
| scene-3d | 20 | plain | 4124 | 1.00x | yes |
| scene-3d | 20 | blend | 10573 | 2.56x | yes |
| scene-3d | 20 | compose | 7964 | 1.93x | yes |
| scene-3d | 20 | fusion | 68134 | 16.52x | yes |
| scene-3d | 20 | fusion-charm | 59324 | 14.38x | yes |
| scene-3d | 20 | react | 7976 | 1.93x | yes |
| scene-3d | 20 | react-reflex | 7731 | 1.87x | yes |
| scene-3d | 20 | react-upstream | 8144 | 1.97x | yes |
| scene-3d | 20 | roact | unsupported: Roact sets Instance.Name from reconciliation keys. Named children use dictionary keys, so their mounting order differs from the ordered named tree that this workload checks. | — | — |
| scene-3d | 20 | seam | 22344 | 5.42x | yes |
| scene-3d | 20 | signals | 16654 | 4.04x | yes |
| scene-3d | 20 | vide | 10378 | 2.52x | yes |

## Summary

The geometric mean divides each measured median Luau time by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain median below that reads 0. Such a workload has no ratio and is not in the geometric mean; its times still compare the libraries.

The shared column uses only the 8 workloads that every lane measured: `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000`, `mount-dispose`, `update-leaf`, `update-fanout`, `update-batched`, `mount-cycles`.

| Lane | Measured | Geometric mean time / plain | Shared workloads, geometric mean / plain |
| --- | ---: | ---: | ---: |
| plain | 20 | 1.00x | 1.00x |
| blend | 20 | 2.25x | 1.74x |
| compose | 20 | 1.86x | 1.47x |
| fusion | 16 | 3.76x | 1.76x |
| fusion-charm | 16 | 3.68x | 1.72x |
| react | 19 | 3.72x | 1.56x |
| react-reflex | 19 | 4.13x | 2.01x |
| react-upstream | 19 | 3.78x | 1.59x |
| roact | 18 | 2.27x | 1.50x |
| seam | 20 | 3.39x | 1.60x |
| signals | 9 | 1.58x | 1.40x |
| vide | 20 | 2.00x | 1.51x |
