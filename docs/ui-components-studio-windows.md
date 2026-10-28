# UI components comparison in a Roblox Studio client

Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. Facet loads from its pinned source with no change. Time is the median Luau time of one workload sample, from the client script profiler. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. Each ratio divides by the plain lane; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

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
| Harness revision | `046080c` |
| Date | 2026-10-28 |

## Results

| Workload | Iterations | Lane | Luau time (us) | / plain | Same final state as plain |
| --- | ---: | --- | ---: | ---: | --- |
| main-menu-cold | 1 | plain | 6574 | 1.00x | yes |
| main-menu-cold | 1 | facet | 7750 | 1.18x | yes |
| hud-600-frames | 600 | plain | 22431 | 1.00x | yes |
| hud-600-frames | 600 | facet | 41544 | 1.85x | yes |
| progress-20-120-frames | 120 | plain | 2900 | 1.00x | yes |
| progress-20-120-frames | 120 | facet | 20844 | 7.19x | yes |
| badges-30-300-updates | 300 | plain | 22978 | 1.00x | yes |
| badges-30-300-updates | 300 | facet | 44326 | 1.93x | yes |
| world-markers-50 | 100 | plain | 13566 | 1.00x | yes |
| world-markers-50 | 100 | facet | 28486 | 2.10x | yes |
| inventory-100 | 200 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-100 | 200 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-500 | 200 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| inventory-500 | 200 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| shop-filter-200 | 10 | plain | 984 | 1.00x | yes |
| shop-filter-200 | 10 | facet | 3872 | 3.93x | yes |
| virtual-scroll-2000 | 100 | plain | 9064 | 1.00x | yes |
| virtual-scroll-2000 | 100 | facet | 33805 | 3.73x | yes |
| chat-append-500 | 500 | plain | 15104 | 1.00x | yes |
| chat-append-500 | 500 | facet | 51577 | 3.41x | yes |
| card-collection-60 | 1 | plain | 14644 | 1.00x | yes |
| card-collection-60 | 1 | facet | 50345 | 3.44x | yes |
| mixed-scroll-300 | 100 | plain | 2056 | 1.00x | yes |
| mixed-scroll-300 | 100 | facet | 26255 | 12.77x | yes |
| settings-17-values | 17 | plain | 500 | 1.00x | yes |
| settings-17-values | 17 | facet | 2034 | 4.07x | yes |
| text-input-200 | 200 | plain | 400 | 1.00x | yes |
| text-input-200 | 200 | facet | 950 | 2.38x | yes |
| button-feedback-50 | 3 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| button-feedback-50 | 3 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| stepper-segments-100 | 100 | plain | 700 | 1.00x | yes |
| stepper-segments-100 | 100 | facet | 4300 | 6.14x | yes |
| dialog-50-cycles | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| dialog-50-cycles | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| toast-stream-100 | 200 | plain | unsupported: Each sample waits about five minutes of real time for 50 toasts to expire. | — | — |
| toast-stream-100 | 200 | facet | unsupported: Each sample waits about five minutes of real time for 50 toasts to expire. | — | — |
| tabs-5-100-switches | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| tabs-5-100-switches | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| radial-50-cycles | 100 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| radial-50-cycles | 100 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| navigation-5-20-cycles | 200 | plain | 52886 | 1.00x | yes |
| navigation-5-20-cycles | 200 | facet | 105348 | 1.99x | yes |
| leaderboard-100 | 6 | plain | 1700 | 1.00x | yes |
| leaderboard-100 | 6 | facet | 50384 | 29.63x | yes |
| theme-swap-200 | 10 | plain | 0 | plain below resolution | yes |
| theme-swap-200 | 10 | facet | 0 | plain below resolution | yes |
| heavy-screen-20-cycles | 20 | plain | 596106 | 1.00x | yes |
| heavy-screen-20-cycles | 20 | facet | 897082 | 1.50x | yes |
| tile-transfer-20 | 20 | plain | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |
| tile-transfer-20 | 20 | facet | unsupported: A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls. | — | — |

## Summary

The geometric mean divides each measured Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain median below that reads 0 and has no ratio.

| Lane | Measured | Geometric mean time / plain |
| --- | ---: | ---: |
| plain | 16 | 1.00x |
| facet | 16 | 3.58x |
