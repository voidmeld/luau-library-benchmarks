# Scene composition library comparison in a Roblox Studio client

Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. Time is the median Luau time of one workload sample, from the client script profiler at 10 kHz. When a sample is shorter than 5 ms, each reported sample is the mean of several complete samples, so profiler resolution adds less error; the profiler's own start and stop calls are not counted, and code that the task scheduler resumes is. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. Heap is the median retained Luau heap with the workload mounted, after its timed steps, less the heap before the workload was prepared, in KiB. Teardown is the median retained heap after release, less the same baseline. Both use the Verify `gc-witness-low-water/5` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. A ratio describes one workload on one machine. It does not rank the quality of a library.

## Machine

| Item | Value |
| --- | --- |
| CPU | AMD Ryzen 9 9950X3D |
| Threads | 32 |
| Memory | 62 GiB |
| Motherboard | MSI MS-7E47 |
| Operating system | Windows 11 Pro 10.0.26200 |
| Display scaling | 150% |
| Roblox Studio | 0.748.0.7481526 |
| Device | hd_1080 |
| Context | Client |
| Harness revision | `f245db2` |
| Facet commit | `4b4755f8` |
| Compose commit | `8defb058` (0.1.2) |
| Verify commit | `2e8cedeb` |
| Date | 2026-11-24 |

## Results

355/355 cases passed across 6 batches.

## Lane workarounds

The summary includes workloads that use lane workarounds.

- `fusion` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.
- `fusion-charm` on `keyed-prepend`, `keyed-insert`, `filter-as-you-type`, `tree-expand-collapse`, `table-sort-filter`, `rows-remove-one`: At the pinned release, ForPairs and ForValues can give a removed key's scope to a retained key (dphfox/Fusion#397). The lane keeps a map from each row to its Instance. It builds each row Instance in a row scope that the lane owns, and destroys that scope when the row leaves the list. ForPairs and ForValues only map a row to its cached Instance. This result measures Fusion plus the lane's identity cache, not the collection diffing of Fusion alone.

## Summary

Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean together with its measured count. The supplied run summary reports geometric means for each lane's measured workloads.

| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain |
| --- | ---: | ---: | ---: |
| blend | 30 | 2.16x | 16.34x |
| compose | 30 | 1.60x | 5.62x |
| fusion | 30 | 5.13x | 8.23x |
| fusion-charm | 30 | 4.78x | 11.86x |
| react | 29 | 3.86x | 7.54x |
| react-reflex | 29 | 4.26x | 13.91x |
| react-upstream | 29 | 3.86x | 7.88x |
| roact | 29 | 2.18x | 7.36x |
| seam | 30 | 3.93x | 17.18x |
| signals | 29 | 1.54x | 4.51x |
| vide | 30 | 1.80x | 4.64x |
