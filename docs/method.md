# Method

This document describes the scene composition library comparison in `comparisons/scene-composition`. The [README](../README.md) holds the charter.

The harness started in [voidmeld/compose](https://github.com/voidmeld/compose), in `bench/compare.luau` and `docs/benchmarks.md`. This repository took it from Compose at commit `0826d65`.

## Run

```bash
lute run tools/sync-dependencies.luau
lute run comparisons/scene-composition/compare.luau --verify --out build/parity
lute run comparisons/scene-composition/compare.luau --out build/scene-composition-comparison
lute run comparisons/scene-composition/compare.luau --mode like-for-like --out build/scene-composition-like-for-like
```

Use `--filter text` to select workload ids. Use `--out directory` to select the output directory.
Use `--mode as-shipped` or `--mode like-for-like` to select the compilation mode. The default is `as-shipped`. The published results use `as-shipped`.
`--verify` runs only the parity cases.
The comparison covers 24 runtime workloads.

The **Library comparison** GitHub workflow runs the same command. It runs only on `workflow_dispatch`, on `ubuntu-latest`. It is separate from the required `Gate` check.

## Dependencies

The lock file `dependencies.lock.luau` is the source of exact versions, commits, trees, license status and notice paths.
Each measured library, Compose included, has the `benchmark` role. Verify has the `verification` role.
`tools/sync-dependencies.luau` checks each commit, tree, remote and clean checkout. It uses sparse checkouts for benchmark dependencies. Blend uses only its 29 listed modules and its license notice. Compose uses only `src/core`, `src/roblox` and its license notice.
The sources stay in the ignored `.lute/dependencies` directory. This repository contains no library source.

The loader reads only the benchmark surfaces in the lock. It runs library source without edits.
It resolves Roblox module paths (including `WaitForChild`), Nevermore module names, React package names and upstream Roblox package layouts against those surfaces.
It gives each loaded library a separate cost-model environment and module cache.

Fusion uses the latest GitHub release that GitHub marks as a non-prerelease. Its upstream tag contains `beta`; the upstream version table marks it as a release.
Vide uses its release tag. React and ReactRoblox use the same release.
React also needs the reconciler, scheduler, shared utilities, Luau polyfills, symbols and promises.
Blend uses one exact NevermoreEngine revision. Its package version is in the lock.
Roact and Seam use their latest release tags. Charm uses its latest package release tag. Reflex uses its latest release tag.
The second React lane uses the upstream Roblox tag with its own polyfill, symbol and promise dependencies.
Reflex uses its declared Promise dependency separately.
Roblox signals has no upstream release or tag. Its pin uses an exact default-branch commit and the package version marked `unreleased`.
Compose has no release. Its pin uses an exact `main` commit and the version `unreleased`.
The report prints the exact source identities of all these dependencies.

## Compilation modes

The comparison has two modes.

`as-shipped` is the default mode. The published results use this mode. It measures each library as it ships:

- Compose loads through Lute `require`, as a consumer gets it. Compose ships with `--!native` on its reactive core, so that code runs as native code. Lute `require` compiles at optimization level 2.
- The other libraries run as they ship. The loader adds no directive to their source. It compiles each file with `luau.compile` at its default level, optimization level 1, because `luau.compile` has no level option. A library that ships `--!optimize` or `--!native` keeps its directive, but `luau.load` generates no native code. No pinned library other than Compose ships `--!native`.
- Roblox uses optimization level 2 by default in live experiences and level 1 in Studio testing ([Roblox creator documentation, Luau comments](https://create.roblox.com/docs/luau/comments)). Thus the other libraries run at the Studio testing level, not the live level. The `like-for-like` mode shows the effect of this difference.
- The other libraries run in the Lute global environment, as Compose, the plain lane, the comparison driver and the workload code do. A chunk that runs with its own environment table loses the Luau fast paths for globals and builtin calls, so the loader does not use one. Instead it parses each file and binds, as one `local ... = ...;` statement on its first line, every global that the file reads with a cost-model value different from Lute's, every global that the file assigns, and `script` and `require`. Thus each file keeps its own cost-model globals and its own assigned globals, and builtins that it only reads keep their fast paths. Line numbers do not move, and no library statement changes.
- A file that cannot take the binding loads with its own copy of the cost-model global table as its environment. This is the fallback. Each parity case attaches the list of fallback files, and `comparison.md` discloses the list. At the pinned revisions, three of the 672 loaded files use the fallback: `ReactFiberBeginWork` in both React lanes, whose locals leave no room for the binding, and the Seam `Types` module, whose type functions read `print`.

`like-for-like` is an internal optimization target. It is not a published result. Every library lane, Compose included, loads through the same loader. The loader adds `--!optimize 2` before each source file, so all library lanes use optimization level 2, the interpreter and the same binding. The Compose `--!native` directives have no effect in this mode. The added directive line moves line numbers in loaded source by one.

## Support

`Yes` means that the lane has an implementation and must pass parity before timing.
`U` means unsupported. Each unsupported lane has a reason in the workload and in the output table.

| Workload ids | Plain | Compose | Fusion | Vide | React | Blend |
| --- | --- | --- | --- | --- | --- | --- |
| `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000` | Yes | Yes | Yes | Yes | Yes | Yes |
| `mount-dispose` | Yes | Yes | Yes | Yes | Yes | Yes |
| `update-leaf`, `update-fanout`, `update-batched`, `update-repeated` | Yes | Yes | Yes | Yes | Yes | Yes |
| `branch-swap` | Yes | Yes | Yes | Yes | Yes | Yes |
| `keyed-append`, `keyed-prepend`, `keyed-insert`, `keyed-remove` | Yes | Yes | U | Yes | Yes | Yes |
| `keyed-replace`, `keyed-reverse`, `keyed-rotate`, `keyed-shuffle` | Yes | Yes | Yes | Yes | Yes | Yes |
| `events` | Yes | Yes | Yes | Yes | Yes | Yes |
| `animate-many` | Yes | Yes | Yes | Yes | U | Yes |
| `status-panel`, `mount-cycles`, `scene-3d` | Yes | Yes | Yes | Yes | Yes | Yes |

The unsupported reasons are:

- At the pinned Fusion release, native `ForPairs` can assign a removed key's scope to a retained key. The four keyed workloads that shrink a list fail the retained-node identity check.
- React and ReactRoblox have no native spring. This comparison does not add an animation library to that lane.

The other lanes classify the same 22 workloads:

| Lane | Supported | Unsupported | Unsupported workload ids and reasons |
| --- | --- | --- | --- |
| Roact | 20 | 2 | `animate-many`: no spring. `scene-3d`: Roact sets names from reconciliation keys; named dictionary children do not keep the required mounting order. |
| Seam | 22 | 0 | None. |
| signals | 11 | 11 | All eight `keyed-*` workloads and `status-panel`: no native keyed Instance collection or row lifetime primitive. `branch-swap`: no conditional Instance ownership primitive. `animate-many`: no spring. |
| React + Reflex | 21 | 1 | `animate-many`: no spring, the same as the React lane. |
| Fusion + Charm | 18 | 4 | The same four shrinking keyed workloads as Fusion. Charm batching supports `update-repeated`. |
| Roblox React | 21 | 1 | `animate-many`: no spring, the same as the React lane. |

## Adapters

The adapters use the public construction and state APIs of each library.
Compose uses the same comparison driver as the other libraries: cells, formula properties, `keyed`, `show`, `event`, runtime springs and `batch`.
Fusion uses scopes and `ForPairs`. Vide uses sources, `values`, `show` and cleanup on each owned root: the mounted tree, each shown branch and each keyed row.
The public `defaults` flag of Vide keeps its library default (true), so Vide writes its default properties on each created Instance.
The public `strict` runtime flag of Vide is false, so its development check does not evaluate each effect twice.
React uses production settings, ReactRoblox legacy roots, property bindings and keyed function components. In the repeated-write workload it uses batched `useState`, which merges the writes.
The repeated-write workload measures many writes to one value inside one batch. Each lane uses the normal batching of its library. A library that merges the writes commits one host write; a library without a transaction writes every value.
The repeated-write lanes use numeric sources. They convert the final value to text after coalescing.
The repeated-write lane of Blend uses its public `Throttled` operator to emit the last value at the end of the defer lane.
Blend uses states, computed properties and `ComputedPairs` with native subscriptions and Maids.
Its row-position map uses the public `Shared` operator, so it is computed one time per list update.
Fusion and Blend apply independent writes immediately. The batched workload has one independent source per node, so it does not require those libraries to merge writes to the same sink.
Roact uses public bindings, class components, fragments and mount handles. Its structural subscriptions update component state.
Seam uses public scopes, values, computeds, `ForPairs`, `Batch` and springs. Each shown branch and each keyed row has an inner scope. The adapter destroys that scope when the branch closes or the row leaves the list. Its property bindings flush on a native frame callback, so each batch includes a zero-delta cost-model frame.
The cost-model host provides ancestry notifications, native vector defaults and the pre-render callback that these bindings need.
Signals uses its public signals, computeds, effects and batch scheduler. Its small host bridge assigns properties and owns node and effect cleanup. It adds no scene reconciler or keyed collection.
React + Reflex keeps all values in one producer. Each value has a key in the producer state, a `set` action and a selector subscription. The adapter flushes the producer within the React batch. Its repeated-write workload converts the flushed numeric state to text one time.
Fusion + Charm subscribes Fusion values to native atoms, releases each subscription with its Fusion scope, and uses the public batch transaction of Charm.
These combined lanes keep the native collection and animation behavior of their rendering library. Their measurements include the bridge and subscription costs.

Fusion and Blend use their native analytic springs. Vide uses its native solver. The target, damping and nominal period match the workload.
The solvers can produce different intermediate numbers. This lane does not prove equal trajectories, equal numerical error or equal animation quality.

Default properties and native cleanup costs stay in each lane.
All lanes use the same cost-model host, which adds dispatch and counter costs.
The adapters add small Luau call and table costs. The results include those costs.
These results describe this workload, host, runtime and machine. They do not establish native rendering, played quality or a general speedup.
Hosted-runner noise and garbage collection can affect the results. Read the raw samples and calibration records before you draw a conclusion.

## Output

The command writes these files to the output directory:

- `comparison.md`: the table, the summary, the source identities and the loader fallbacks.
- `report.json`: the full Verify report, with raw samples, parity results and attachments.
- `stored.json`: the passed measurements only.
- `context.json`: the harness commit and tree, the dirty state, the runtime, the machine, the command, the mode and the lock.
- `gate/`: the Verify gate evidence, with calibration attempts.

The table gives median time in microseconds, mounted retained heap in KiB, and each value divided by the plain value. The plain lane uses no library, so a ratio is the cost of a library over hand-written code. A lower ratio means a smaller measurement. A zero plain heap baseline has no ratio.
Time is per complete workload sample. Divide it by the iteration count of the table for a time per run.
The summary gives, for each lane, the supported and measured workloads and the geometric mean of its time ratios. Lanes support different workloads, so compare a geometric mean only together with its measured count.
Missing supported measurements fail the command. Failed and noisy attempts stay in the raw report and the gate evidence.
