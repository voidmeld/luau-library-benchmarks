# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Harness revision | `3ea569c` |
| Date | 2026-10-29 |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same final state as plain |
| --- | ---: | --- | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 14100 | 1.00x | yes |
| main-menu-cold | 1 | facet | 14676 | 1.04x | yes |
| hud-600-frames | 600 | plain | 19991 | 1.00x | yes |
| hud-600-frames | 600 | facet | 38749 | 1.94x | yes |
| progress-20-120-frames | 120 | plain | 3425 | 1.00x | yes |
| progress-20-120-frames | 120 | facet | 14240 | 4.16x | yes |
| badges-30-300-updates | 300 | plain | 34586 | 1.00x | yes |
| badges-30-300-updates | 300 | facet | 62505 | 1.81x | yes |
| world-markers-50 | 100 | plain | 25108 | 1.00x | yes |
| world-markers-50 | 100 | facet | 45846 | 1.83x | yes |
| inventory-100 | 200 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-100 | 200 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-500 | 200 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-500 | 200 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| shop-filter-200 | 10 | plain | 1810 | 1.00x | yes |
| shop-filter-200 | 10 | facet | 4428 | 2.45x | yes |
| virtual-scroll-2000 | 100 | plain | 9326 | 1.00x | yes |
| virtual-scroll-2000 | 100 | facet | 42809 | 4.59x | yes |
| chat-append-500 | 500 | plain | 28259 | 1.00x | yes |
| chat-append-500 | 500 | facet | 45442 | 1.61x | yes |
| card-collection-60 | 1 | plain | 26772 | 1.00x | yes |
| card-collection-60 | 1 | facet | 69706 | 2.60x | yes |
| mixed-scroll-300 | 100 | plain | 1154 | 1.00x | yes |
| mixed-scroll-300 | 100 | facet | 7215 | 6.25x | yes |
| settings-17-values | 17 | plain | 300 | 1.00x | yes |
| settings-17-values | 17 | facet | 1750 | 5.83x | yes |
| text-input-200 | 200 | plain | 1105 | 1.00x | yes |
| text-input-200 | 200 | facet | 1868 | 1.69x | yes |
| button-feedback-50 | 3 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| button-feedback-50 | 3 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| stepper-segments-100 | 100 | plain | 1702 | 1.00x | yes |
| stepper-segments-100 | 100 | facet | 9064 | 5.33x | yes |
| dialog-50-cycles | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| dialog-50-cycles | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| toast-stream-100 | 200 | plain | unsupported: Each sample waits about five minutes of real time for 50 toasts to expire. | — | — |
| toast-stream-100 | 200 | facet | unsupported: Each sample waits about five minutes of real time for 50 toasts to expire. | — | — |
| tabs-5-100-switches | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| tabs-5-100-switches | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| radial-50-cycles | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| radial-50-cycles | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| navigation-5-20-cycles | 200 | plain | 45136 | 1.00x | yes |
| navigation-5-20-cycles | 200 | facet | 119710 | 2.65x | yes |
| leaderboard-100 | 6 | plain | 2971 | 1.00x | yes |
| leaderboard-100 | 6 | facet | 13064 | 4.40x | yes |
| theme-swap-200 | 10 | plain | 0 | plain below resolution | yes |
| theme-swap-200 | 10 | facet | 0 | plain below resolution | yes |
| heavy-screen-20-cycles | 20 | plain | 487942 | 1.00x | yes |
| heavy-screen-20-cycles | 20 | facet | 777725 | 1.59x | yes |
| tile-transfer-20 | 20 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| tile-transfer-20 | 20 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |

## Summary

The geometric mean divides each measured Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain median below that reads 0 and has no ratio.

| Lane | Measured | Geometric mean time / plain |
| --- | ---: | ---: |
| plain | 16 | 1.00x |
| facet | 16 | 2.70x |
