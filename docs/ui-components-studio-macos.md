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
| Harness revision | `47be4e3` |
| Date | 2026-10-29 |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same final state as plain |
| --- | ---: | --- | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 7103 | 1.00x | yes |
| main-menu-cold | 1 | facet | 7864 | 1.11x | yes |
| hud-600-frames | 600 | plain | 23006 | 1.00x | yes |
| hud-600-frames | 600 | facet | 56961 | 2.48x | yes |
| progress-20-120-frames | 120 | plain | 4443 | 1.00x | yes |
| progress-20-120-frames | 120 | facet | 20467 | 4.61x | yes |
| badges-30-300-updates | 300 | plain | 22248 | 1.00x | yes |
| badges-30-300-updates | 300 | facet | 47480 | 2.13x | yes |
| world-markers-50 | 100 | plain | 14760 | 1.00x | yes |
| world-markers-50 | 100 | facet | 31552 | 2.14x | yes |
| inventory-100 | 200 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-100 | 200 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-500 | 200 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-500 | 200 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| shop-filter-200 | 10 | plain | 1705 | 1.00x | yes |
| shop-filter-200 | 10 | facet | 4360 | 2.56x | yes |
| virtual-scroll-2000 | 100 | plain | 10142 | 1.00x | yes |
| virtual-scroll-2000 | 100 | facet | 54815 | 5.40x | yes |
| chat-append-500 | 500 | plain | 16876 | 1.00x | yes |
| chat-append-500 | 500 | facet | 42490 | 2.52x | yes |
| card-collection-60 | 1 | plain | 14382 | 1.00x | yes |
| card-collection-60 | 1 | facet | 45633 | 3.17x | yes |
| mixed-scroll-300 | 100 | plain | 1810 | 1.00x | yes |
| mixed-scroll-300 | 100 | facet | 9272 | 5.12x | yes |
| settings-17-values | 17 | plain | 604 | 1.00x | yes |
| settings-17-values | 17 | facet | 2202 | 3.65x | yes |
| text-input-200 | 200 | plain | 600 | 1.00x | yes |
| text-input-200 | 200 | facet | 1106 | 1.84x | yes |
| button-feedback-50 | 3 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| button-feedback-50 | 3 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| stepper-segments-100 | 100 | plain | 800 | 1.00x | yes |
| stepper-segments-100 | 100 | facet | 5216 | 6.52x | yes |
| dialog-50-cycles | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| dialog-50-cycles | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| toast-stream-100 | 200 | plain | unsupported: Each sample waits about five minutes of real time for 50 toasts to expire. | — | — |
| toast-stream-100 | 200 | facet | unsupported: Each sample waits about five minutes of real time for 50 toasts to expire. | — | — |
| tabs-5-100-switches | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| tabs-5-100-switches | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| radial-50-cycles | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| radial-50-cycles | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| navigation-5-20-cycles | 200 | plain | 59016 | 1.00x | yes |
| navigation-5-20-cycles | 200 | facet | 131370 | 2.23x | yes |
| leaderboard-100 | 6 | plain | 2400 | 1.00x | yes |
| leaderboard-100 | 6 | facet | 13026 | 5.43x | yes |
| theme-swap-200 | 10 | plain | 0 | plain below resolution | yes |
| theme-swap-200 | 10 | facet | 101 | plain below resolution | yes |
| heavy-screen-20-cycles | 20 | plain | 488124 | 1.00x | yes |
| heavy-screen-20-cycles | 20 | facet | 740694 | 1.52x | yes |
| tile-transfer-20 | 20 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| tile-transfer-20 | 20 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |

## Summary

The geometric mean divides each measured Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain median below that reads 0 and has no ratio.

| Lane | Measured | Geometric mean time / plain |
| --- | ---: | ---: |
| plain | 16 | 1.00x |
| facet | 16 | 2.91x |
