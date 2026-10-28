# Method

This document describes the scene composition library comparison in `comparisons/scene-composition`. The [README](../README.md) holds the charter.

The harness started in [voidmeld/compose](https://github.com/voidmeld/compose), in `bench/compare.luau` and `docs/benchmarks.md`. This repository took it from Compose at commit `0826d65`. The maintainer of this repository also maintains Compose. Corrections to any adapter are welcome.

## Run

```bash
lute run tools/sync-dependencies.luau
lute run comparisons/scene-composition/compare.luau --verify --out build/parity
lute run comparisons/scene-composition/compare.luau --out build/scene-composition-comparison
lute run comparisons/scene-composition/compare.luau --mode like-for-like --out build/scene-composition-like-for-like
```

Use `--filter text` to select workload ids. Use `--out directory` to select the output directory.
Use `--mode like-for-like` or `--mode as-shipped` to select the compilation mode. The default is `like-for-like`. The published results use `like-for-like`.
`--verify` runs only the parity cases.
The comparison covers 22 runtime workloads. The support table below lists each one.

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

`like-for-like` is the default mode. The published results use this mode. Every library lane, Compose included, loads through the same loader. The loader adds `--!optimize 2` before each source file, so all library lanes use optimization level 2, the interpreter and the same global binding. Roblox uses optimization level 2 by default in live experiences ([Roblox creator documentation, Luau comments](https://create.roblox.com/docs/luau/comments)). `luau.load` generates no native code, so the Compose `--!native` directives have no effect in this mode. The directive is a compiler setting: no library statement changes. The added line moves line numbers in loaded source by one.

The loader runs each library in the Lute global environment, as the plain lane, the comparison driver and the workload code do. A chunk that runs with its own environment table loses the Luau fast paths for globals and builtin calls, so the loader does not use one. Instead it parses each file and binds, as one `local ... = ...;` statement on its first line, every global that the file reads with a cost-model value different from Lute's, every global that the file assigns, and `script` and `require`. Thus each file keeps its own cost-model globals and its own assigned globals, and builtins that it only reads keep their fast paths. No library statement changes.

A file that cannot take the binding loads with its own copy of the cost-model global table as its environment. This is the fallback. Each parity case attaches the list of fallback files, and `comparison.md` discloses the list. At the pinned revisions, three of the 672 loaded files use the fallback: `ReactFiberBeginWork` in both React lanes, whose locals leave no room for the binding, and the Seam `Types` module, whose type functions read `print`.

`as-shipped` is a diagnostic mode. It is not a published result. Compose loads through Lute `require`, so its `--!native` directives produce native code at optimization level 2. The other libraries compile with `luau.compile` at its default level 1, the Roblox Studio testing level, because `luau.compile` has no level option. The difference between the two modes shows the effect of native code and optimization level, not of library design.

## Support

`Yes` means that the lane has an implementation and must pass parity before timing.
`U` means unsupported. Each unsupported lane has a reason in the workload and in the output table. An unsupported workload needs a feature outside the scope of the library, or a behavior that differs from the check of the workload. It is not a defect report.

| Workload ids | Plain | Blend | Compose | Fusion | React | Vide |
| --- | --- | --- | --- | --- | --- | --- |
| `cold-mount-100`, `cold-mount-1000`, `cold-mount-10000` | Yes | Yes | Yes | Yes | Yes | Yes |
| `mount-dispose` | Yes | Yes | Yes | Yes | Yes | Yes |
| `update-leaf`, `update-fanout`, `update-batched`, `update-repeated` | Yes | Yes | Yes | Yes | Yes | Yes |
| `branch-swap` | Yes | Yes | Yes | Yes | Yes | Yes |
| `keyed-append`, `keyed-prepend`, `keyed-insert`, `keyed-remove` | Yes | Yes | Yes | U | Yes | Yes |
| `keyed-replace`, `keyed-reverse`, `keyed-rotate`, `keyed-shuffle` | Yes | Yes | Yes | Yes | Yes | Yes |
| `events` | Yes | Yes | Yes | Yes | Yes | Yes |
| `animate-many` | Yes | Yes | Yes | Yes | U | Yes |
| `status-panel`, `mount-cycles`, `scene-3d` | Yes | Yes | Yes | Yes | Yes | Yes |

The unsupported reasons are:

- At the pinned Fusion release, `ForPairs` can give a removed key's scope to a retained key, so a retained row does not keep its Instance. The four keyed workloads that shrink a list check retained Instance identity.
- React and ReactRoblox do not include a spring. An added animation library would change what the lane measures.

The other lanes classify the same 22 workloads:

| Lane | Supported | Unsupported | Unsupported workload ids and reasons |
| --- | --- | --- | --- |
| Roact | 20 | 2 | `animate-many`: Roact does not include a spring. `scene-3d`: Roact sets names from reconciliation keys, so named dictionary children mount in a different order from the ordered named tree that this workload checks. |
| Seam | 22 | 0 | None. |
| signals | 11 | 11 | Roblox signals is a state library. Keyed Instance collections (all eight `keyed-*` workloads and `status-panel`), conditional Instance ownership (`branch-swap`) and springs (`animate-many`) are outside its scope. |
| React + Reflex | 21 | 1 | `animate-many`: the same as the React lane. |
| Fusion + Charm | 18 | 4 | The same four shrinking keyed workloads as Fusion. Charm batching supports `update-repeated`. |
| Roblox React | 21 | 1 | `animate-many`: the same as the React lane. |

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

## Studio client run

`lute run comparisons/scene-composition/studio/run.luau` runs the same lanes and workloads in a Roblox Studio play client, against real Roblox Instances. Use `--case workload/lane` to select cases and `--out directory` to select the output directory. It writes `studio.md` and `report.json`.

Each library runs without a change to its code:

- The run mounts the pinned source of each library as `ModuleScript` instances in the same layout as its repository. Roblox resolves its requires natively, both instance requires and relative string requires.
- A library that a package manager installs gets the link modules that the package manager would generate, at the paths that its code requires. A Nevermore library gets a `loader` module that maps a module name to its module. The headless loader records these paths when it loads each lane.
- React Lua (`react`, and the React part of `react-reflex`) loads from its published Roblox release model, `react-lua.rbxm` of release `v17.2.1`, pinned by its SHA-256 hash. That release is what Roblox developers install. Its build converts the `@pkg` requires of the source to instance requires. Roblox does not resolve `@pkg` aliases.
- Roblox compiles each module with its own Studio settings. It applies each module's own directives, such as the Compose `--!native` directives, under its rules for a Studio client. The run adds no directive.

Each sample runs the iterations of the workload. Each update ends with a real frame, so deferred tasks and frame callbacks run as they do in a game. The client script profiler (`ScriptProfilerService`, 10 kHz) records the sample. The time of a sample is the Luau time of the call stacks that enter benchmark or library modules. It excludes idle frame time, Studio plugins, default player scripts and Verify. It includes the engine calls that Luau code makes, such as property writes. It does not include rendering or layout that the engine does later in the frame.

Each case runs warmup samples and then 10 measured samples in a fresh environment. The table gives the median. Each ratio divides by the plain lane. The run compares the settled tree of each lane with the plain lane.

`events` is unsupported in this run: a script cannot fire `GuiButton.Activated`, and real input would measure the input pipeline, not the library.

The results describe one machine and one Studio version. `studio.md` names both.

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
