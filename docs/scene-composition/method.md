# Method

This document describes the scene composition library comparison in `comparisons/scene-composition`. The [README](../../README.md) holds the charter.

The maintainer of this repository also maintains Compose. Corrections to any adapter are welcome.

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
The comparison covers 30 runtime workloads. The support tables below list each one.

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
| `update-leaf`, `update-batched`, `update-repeated` | Yes | Yes | Yes | Yes | Yes | Yes |
| `branch-swap` | Yes | Yes | Yes | Yes | Yes | Yes |
| `keyed-prepend`, `keyed-insert` | Yes | Yes | Yes | U | Yes | Yes |
| `keyed-shuffle` | Yes | Yes | Yes | Yes | Yes | Yes |
| `events` | Yes | Yes | Yes | Yes | Yes | Yes |
| `animate-many` | Yes | Yes | Yes | Yes | U | Yes |
| `status-panel`, `scene-3d` | Yes | Yes | Yes | Yes | Yes | Yes |
| `rows-create-1000`, `rows-update-every-10th` | Yes | Yes | Yes | Yes | Yes | Yes |
| `rows-swap`, `rows-create-10000` | Yes | Yes | Yes | Yes | Yes | Yes |
| `rows-remove-one` | Yes | Yes | Yes | U | Yes | Yes |
| `rows-append-1000`, `rows-clear`, `library-load` | Yes | Yes | Yes | Yes | Yes | Yes |

The unsupported reasons are:

- At the pinned Fusion release, `ForPairs` can give a removed key's scope to a retained key, so a retained row does not keep its Instance. The `keyed-prepend` and `keyed-insert` workloads check retained Instance identity. `ForValues` uses the same scope reuse code. The Fusion and Fusion + Charm lanes cannot retain all row Instances in `rows-remove-one` either.
- React and ReactRoblox do not include a spring. An added animation library would change what the lane measures.

For the 19 workloads in the table above, the other lanes have this support:

| Lane | Supported | Unsupported | Unsupported workload ids and reasons |
| --- | --- | --- | --- |
| Roact | 18 | 1 | `animate-many`: Roact does not include a spring. |
| Seam | 19 | 0 | None. |
| signals | 18 | 1 | `animate-many`: Signals does not include a spring or an animation solver. |
| React + Reflex | 18 | 1 | `animate-many`: the same as the React lane. |
| Fusion + Charm | 16 | 3 | The same two keyed workloads and `rows-remove-one` as Fusion. Charm batching supports `update-repeated`. |
| Roblox React | 18 | 1 | `animate-many`: the same as the React lane. |

`library-load` is also unsupported for Compose in `as-shipped` mode. Lute caches native `require` results for the worker. It cannot give this lane a fresh native module cache for each sample. The published `like-for-like` mode supports this workload for every lane.

## Large game lists


These workloads represent large Roblox game lists: leaderboards, inventory slots, server browsers and chat logs.
Each row is a Frame with two TextLabels and two TextButtons. The labels show its id and its own reactive label state. The buttons call its select and remove actions. Each row also has its own selection state. `BackgroundTransparency` is 0 for the selected row and 1 for other rows. `LayoutOrder` gives each row its list position. Each row has five Instances. The empty list root is prepared before each row workload.

Row labels combine a fixed adjective, color and game item name. An id determines each word, so every lane receives the same data. Sparse updates start at row 1 and change every tenth row.

| Workload | Game task | One measured action | Required engine work |
| --- | --- | --- | --- |
| `rows-create-1000` | Open a 1,000-player leaderboard | Fill an empty keyed list with 1,000 rows. | Create 5,000 Instances. |
| `rows-update-every-10th` | Update every tenth leaderboard entry | Append ` · new best` to rows 1, 11, through 991. | Write exactly 100 Text properties. Create no Instances. |
| `rows-swap` | Exchange two inventory positions | Swap rows 2 and 999 of 1,000. | Write exactly two LayoutOrder properties. Create no Instances. |
| `rows-remove-one` | Remove one inventory item | Remove row 500 of 1,000. | Destroy five Instances. Write LayoutOrder for the 500 rows after it. Create no Instances. |
| `rows-create-10000` | Open a 10,000-row item catalog | Fill an empty keyed list with 10,000 rows. | Create 50,000 Instances. |
| `rows-append-1000` | Load another page of server entries | Append 1,000 rows to 1,000 existing rows. | Create 5,000 Instances. Do not write properties of existing rows. |
| `rows-clear` | Clear the chat log at round end | Remove all 1,000 rows. | Destroy 5,000 Instances. Write no properties. |
| `library-load` | Initialize the UI library for a game screen | Load the library module tree and mount one empty Frame. | Report module initialization work and root creation. |

Each workload has one action per sample. Data and reactive state for new rows are created inside that action. Existing rows are prepared outside it. Warmup samples use separate prepared state, as measured samples do. These actions do not alternate with an inverse action inside the measurement.
Row workloads take 25 measured samples after 5 warmup samples. `rows-create-10000` takes 5 measured samples after 1 warmup sample, because one sample takes 0.4 to 6 seconds; the median of 5 is stable at that size. The `rows-create-10000` workers have a 1,800-second deadline for parity, timing and retained heap checks, and the other row workers have a 900-second deadline. These limits are the same for every lane. Other workloads keep the default worker deadline of 300 seconds.

Parity checks each row id, label, selection and position. It checks the identity of each retained Frame and its four children. A write observer rejects a property assignment to any unchanged existing row property, including an assignment of the same value. Each changed existing property must be written exactly once. Exact creation and destruction counts are checked separately. Library defaults on new Instances remain part of the reported property write count. The observer is active only during parity.
Each parity pass closes a lane's module session and adapter caches after scene teardown. The timing driver retains its normal library load policy.

`library-load` prepares a fresh environment, loader and empty module cache for each sample. Library execution and empty root mounting occur inside the measured action. File discovery and environment construction occur before it. This measures module loading in the headless host; it does not measure a browser navigation, asset download or engine startup. Ordinary workloads still load the library before timing. Module initialization can retain scheduler connections for the life of the environment. The load workload records those resources before mounting and checks that scene teardown leaves only those resources. Its work counts include module initialization, so they need not equal the plain lane. Each retained heap measurement also uses a fresh environment. The Studio driver prepares a fresh cloned module tree for each load sample, outside its profiler interval.

### Game and app UI workloads

These eleven workloads cover UI state, search, themes, readouts, page lifetimes, trees, forms and tables. The last three model app tasks: an explorer or settings tree, a form with validation, and a sortable data table. Each uses the same driver, warmup, collection policy and rotated lane order as the other workloads.

| Workload | Operation | Parity check | Use in a game |
| --- | --- | --- | --- |
| `derived-diamond` | One numeric source feeds a doubled value and a value plus ten. A third derived value adds both values. Write the source once per iteration. | The join reads matching source versions, recomputes once and commits one text write. Check three successive updates. | Health, equipment and bonuses can feed the same damage or status display through more than one path. A mixed value can show an invalid status. |
| `derived-chain-100` | Build 100 derived values. Each adds one to its predecessor. Write the source once per iteration. | Check the final value and exactly one text write after each of three updates. | Nested rules for stats, quests and UI state can form long dependency paths. |
| `derived-fan-in-1000` | Sum 1,000 independent numeric sources in one derived value. Change only the first source. | Check the total and exactly one text write after each of three updates. | A shop, inventory or team summary can depend on many separate records. |
| `filter-as-you-type` | Filter 500 stable records by a text query, then sort by record name. Type `crystal1` one character at a time, then clear. Render the result as a keyed list. | At all nine checkpoints, check the exact record count, ids, positions and order. Check exact node creation and destruction counts and the minimum required text and position writes. A record present in two adjacent results must keep its Instance. | Shop and friends searches must respond to input while keeping the rows that remain visible. |
| `theme-propagation` | Provide one theme to 1,000 text consumers. Alternate between `light` and `dark` for three updates. | Check all consumer values and exactly 1,000 text writes per swap. | A theme or accessibility setting can change every visible control. |
| `hud-per-frame` | Update 20 numeric readouts in a batch for each of 60 frames at a nominal 60 Hz. Each readout formats its value as text. | Check all values and exactly 20 text writes on every frame. | Health, time and speed displays update during play without a new page mount. |
| `teardown-under-load` | Mount a page with 2,000 bound nodes. A source owned outside the page fires on each heartbeat. Close the page after three pulses, then run three more pulses. | Each live pulse writes all 2,000 nodes once. After close, no pulse writes a property. Instance and connection counts return to the source-owner baseline. Released nodes must be unreachable after collection. | A player can close a page while game state continues to change. |
| `open-close-retention` | Open and close a page with 500 bound nodes 10 times. Run three source pulses before each close and three after it. | Check live values, write counts, released nodes and baseline counts for every cycle. After collection, no released node may remain reachable. | Repeated visits to an inventory or shop must not accumulate old pages or subscriptions. |
| `tree-expand-collapse` | Show a tree of 10 roots, 100 branches and 2,000 leaves as a keyed list of visible nodes. Expand a root, one branch, all its branches and a second root with its branches. Collapse and reopen the first root, then collapse all. | At all seven checkpoints, use the same list checks as `filter-as-you-type`. A reopened root shows the branches that were open before. | An explorer, quest log or settings tree keeps the visible nodes when a player opens or closes a branch. |
| `form-validation` | Show a form with 20 fields. Each field has a derived validation message, and one derived summary counts the fields to fix. Fill every field, make four fields invalid, then clear every field. | After each of the 44 edits, check every field, message and summary text. Check the minimum required text writes. An edit creates and destroys no nodes. | A trade, report or settings form validates each field and the whole form while the player types. |
| `table-sort-filter` | Show 1,000 records with eight columns as a keyed list. Sort by score, then level, filter by team, filter by minimum level and sort by wins, remove the team filter, then return to the name sort. | At all six checkpoints, use the same list checks as `filter-as-you-type`. Rows with equal keys sort by id. | A server browser, friends list or admin table reorders and filters rows that stay on screen. |

All lanes support these workloads except Fusion and Fusion + Charm on `filter-as-you-type`, `tree-expand-collapse` and `table-sort-filter`. The same pinned `ForPairs` retained-Instance limitation as the shrinking keyed workloads applies. The output records this reason. No parity check is removed.

The records use eight name prefixes and a numeric suffix. The query narrows several groups before it selects the `crystal1` group. The empty query restores all 500 records. Record tables stay stable across queries.

The reactive lanes use native derived values. Compose uses owned `formula` values. Fusion and Fusion + Charm use scoped `Computed` values. Vide uses `derive`. Signals uses `createComputed`; the search uses its existing keyed host bridge, which keeps rows by id and releases its effect with the page. Blend combines native observables, shares each result and applies `Throttled` before a derived callback. The adapter discovers its fixed inputs during setup. This avoids a mixed diamond result and repeated join callbacks in the defer lane.

React, Roblox React and React + Reflex calculate the derived graph in a function component render. The search uses `useMemo` with the query as its dependency. Roact calculates it in a class component render. The HUD and lifetime workloads use the existing property bindings in these lanes. React + Reflex keeps its producer and selector subscriptions. Fusion + Charm keeps its atom-to-Fusion subscriptions. These bridges remain part of the measured work.

For the diamond join, Seam uses its public `Rendered` state to read both completed `Computed` branches on the frame callback. Its eager `Computed` notification path can read one branch before the other branch updates. The normal adapter batch includes a zero-delta frame to flush the join. The chain and total use `Computed`. Each lifetime page owns a `Computed` bridge to the external source, so closing the page releases its bindings while the source stays live.

Theme consumers use Compose `createContext`, Fusion `Contextual`, Vide `context`, React `createContext` with `Provider` and `Consumer`, and Roact `createContext` with `Provider` and `Consumer`. Blend, Seam and signals use explicit shared-state injection: the component receives the same native state or getter and binds it to its text. These libraries have no context provider in the measured public surface. The plain lane passes the shared source through a constructor scope.

Each retained heap sample runs in a fresh environment: the library is loaded and nothing is mounted when the baseline is read. Memory that a library keeps from an earlier mount therefore counts as its own, and memory it keeps after release appears in the Teardown column. The React lanes keep most of a game page tree after unmount while the process lives, because the reconciler holds its last committed root; their Teardown values show this.

For the two lifetime workloads, the memory worker also records `memory/growth` and the report adds a page-retention table. It collects before a reading with only the source owner and host mounted, then collects after the complete workload with those same objects still mounted. Growth is the second heap reading minus the first. Three samples are reported after an unmeasured memory run. Collection noise can make the difference negative; such a reading counts as 0, as in the Verify mounted and teardown readings. The normal teardown measurement then releases the source owner and host. These heap estimates report retained growth; parity separately requires exact resource counts and checks weak references to released nodes. A retained-heap estimate cannot prove exact byte equality with a baseline.

The adapter review uses the pinned sources and these public references:

| Library | Reference and pattern |
| --- | --- |
| Blend | [Blend API](https://quenty.github.io/NevermoreEngine/api/Blend/), and the pinned `Blend.lua` examples for `Computed`, `Shared`, `Throttled` and state injection; subscriptions belong to a Maid. |
| Compose | Pinned `src/core/init.luau`, `reactive/formula.luau` and `context.luau`: owned formulas, `use`, `createContext`, `provide` and `read`. |
| Fusion | Pinned `src/State/Computed.luau` and `src/Utility/Contextual.luau`: scoped computation, `use`, `now` and `is(...):during(...)`. |
| Charm | Pinned `packages/charm/src/init.luau`: atoms, subscription cleanup and native batches, bridged through Fusion. |
| React Lua and Roblox React | [React Lua API reference](https://github.com/jsdotlua/react-lua/blob/main/docs/api-reference/react.md), plus the pinned `ReactHooks` and context modules: render-time values, `useMemo`, context consumers and effect cleanup. |
| Reflex | Pinned producer implementation: immutable actions, selector subscriptions, `flush` and unsubscribe, bridged to React state. |
| Roact | [Context](https://roblox.github.io/roact/advanced/context/), and pinned `createContext.lua`: class state, render functions and provider consumers. |
| Seam | Pinned `Constructors/States/Computed.luau`, `Rendered.luau`, `Value.luau` and `Constructors/Memory/Scope.luau`: explicit state injection and page-owned cleanup. |
| signals | Pinned `modules/signals/src/Signals.lua` and its specifications: pass the computation scope to each getter; release effects when their host page closes. |
| Vide | Pinned `src/derive.luau`, `context.luau`, `values.luau` and `cleanup.luau`: cached derived values, scoped context and owned row cleanup. |

## Adapters

The adapters use the public construction and state APIs of each library.
Compose uses the same comparison driver as the other libraries: cells, formula properties, `keyed`, `show`, `event`, runtime springs and `batch`.
Fusion uses scopes and `ForPairs`. The mount sets the root's `Parent` and leaves the container outside the Fusion scope. Fusion owns only the tree that it creates.
Vide uses sources, `values`, `show` and cleanup on each owned root: the mounted tree, each shown branch and each keyed row.
The public `defaults` flag of Vide keeps its library default (true), so Vide writes its default properties on each created Instance.
The public `strict` runtime flag of Vide is false, so its development check does not evaluate each effect twice.
React uses production settings, `ReactRoblox.createRoot`, property bindings and keyed function components. The root API follows the ReactRoblox recommendation for new work. The adapter uses public `flushSync` at mount and batch boundaries to meet the synchronous `Driver` contract. It measures completed commits, including the cost of this boundary. It does not measure concurrent scheduling across frames.
Property-only updates use bindings. Both React and Roact document bindings for external property sources and updates that avoid reconciliation. These workloads do not change the component tree, so the adapters keep that fast path. React uses batched `useState` for the repeated-write workload, which merges the writes before text conversion. Branches and keyed lists use component state and reconciliation. Each React branch releases its state subscriptions when it unmounts. Each mount has its own subscription list.
The repeated-write workload measures many writes to one value inside one batch. Each lane uses the normal batching of its library. A library that merges the writes commits one host write; a library without a transaction writes every value.
The repeated-write lanes use numeric sources. They convert the final value to text after coalescing.
The repeated-write lane of Blend uses its public `Throttled` operator to emit the last value at the end of the defer lane.
Blend uses states, computed properties and `ComputedPairs` with native subscriptions and Maids. Each branch uses the inner Maid supplied by `ComputedPairs`, so closing it releases its states and subscriptions.
Its row-position map uses the public `Shared` operator, so it is computed one time per list update.
Fusion, Blend and Seam keep row identity separate from row order. Each uses a stable row map and a computed `LayoutOrder` that reads a shared position map. A list update recomputes all row order bindings. The pinned collection callbacks do not supply a reactive index. Passing the index as a mapped value would rebuild moved rows. Fusion `ForValues` preserves values across moves but does not supply their indices; it also uses the same greedy sub-object reuse as `ForPairs`. These adapters keep their native collection APIs and disclose this order cost.
Fusion and Blend apply independent writes immediately. The batched workload has one independent source per node, so it does not require those libraries to merge writes to the same sink.
Roact uses public bindings, class components, fragments and mount handles. Its structural subscriptions update component state. Each node uses a single-entry named fragment. The outer child array preserves sibling order, and the fragment key supplies the Instance name. This supports the named 3D tree without writing `Name` as a host property.
Seam uses public scopes, values, computeds, `ForPairs`, `Batch` and springs. Static children use plain arrays. Only reactive child collections need a computed. Each shown branch and each keyed row has an inner scope. The adapter destroys that scope when the branch closes or the row leaves the list. Its property bindings flush on a native frame callback, so each batch includes a zero-delta cost-model frame.
The cost-model host provides ancestry notifications, including when destruction removes a tree, native vector defaults and the pre-render callback that these bindings need. Mount completion drains deferred attachment tasks. The host also drains tasks whose delay has expired, without advancing future timers.
Signals uses its public signals, computeds, effects and batch scheduler. Its host bridge uses effects to assign properties, reconcile rows by `id` and replace conditional trees. Retained rows keep their Instances. Only moved rows receive a new `LayoutOrder`. Removed rows are destroyed. Each mount and branch owns its effects, connections and Instances. The bridge retains each effect disposer as the Signals documentation requires, and disposes effects before it destroys their nodes. The collection and branch code belong to the adapter; Signals does not supply a scene renderer.
React + Reflex keeps all values in one producer. Each value has a key in the producer state, a `set` action and a selector subscription. The adapter flushes the producer within the React batch. Its repeated-write workload converts the flushed numeric state to text one time.
Fusion + Charm subscribes Fusion values to native atoms, releases each subscription with its Fusion scope, and uses the public batch transaction of Charm.
These combined lanes keep the native collection and animation behavior of their rendering library. Their measurements include the bridge and subscription costs.

The adapter review uses documentation and source from the revisions in the lock. The references below name the public patterns used by each lane. Source paths are relative to the pinned dependency.

| Lane | Reviewed documentation and source | Pattern |
| --- | --- | --- |
| Blend | [Blend API](https://quenty.github.io/NevermoreEngine/api/Blend/), `src/blend/src/Shared/Blend/Blend.lua` | `State`, `ComputedPairs` inner Maid, `Shared`, `Throttled` and `Spring`. |
| Compose | `docs/api.md`, `docs/ownership.md`, `examples/collections.luau`, `src/core` and `src/roblox` | Cells, mapped properties, keyed rows, owned branches, runtime batching and springs. |
| Fusion | [ForPairs](https://elttob.uk/Fusion/0.3/tutorials/tables/forpairs/), [ForValues](https://elttob.uk/Fusion/0.3/tutorials/tables/forvalues/), `src/State/For/Disassembly.luau`, `src/Instances/Hydrate.luau` | Scoped Instances and collection outputs. `Hydrate` owns its target, so it is not used on the borrowed mount container. |
| Fusion + Charm | Fusion references above, Charm `README.md` and `packages/charm/src` | Atoms, `subscribe` disposers and `batch`; Fusion scopes own subscriptions. |
| React, React + Reflex, Roblox React | [ReactRoblox API](https://react-luau.dev/api-reference/react-roblox/), [React API](https://react-luau.dev/api-reference/react/), `docs/api-reference/react-roblox.md`, `modules/react-roblox/src/client/ReactRoblox.luau` or `.lua` | Recommended roots, public synchronous commit boundary, bindings, hooks and keyed children. |
| React + Reflex | Reflex `docs/docs/reference/reflex/producer.md` and `src/createProducer.lua` | Immutable producer actions, selector subscriptions, explicit flush and unsubscribe. Released cells are removed from the producer. |
| Roact | [Bindings and Refs](https://roblox.github.io/roact/advanced/bindings-and-refs/), `docs/advanced/fragments.md`, `src/RobloxRenderer.lua` | Binding properties, state subscriptions, named fragments and mount teardown. |
| Seam | `website/docs/API/states/ForPairs.md`, `website/docs/API/states/Computed.md`, `website/docs/Tutorials/using-scopes.md`, `src/Modules/StateManager.luau` | Cached collection outputs, inner scopes, batching and deferred property attachment cleanup. |
| Signals | [Signals README](https://github.com/Roblox/signals#usage), `modules/signals/src/Signals.lua` and its tests | Tracked effects, retained disposers, batch scheduling and explicit host cleanup. |
| Vide | `docs/tut/crash-course/10-cleanup.md`, `src/values.luau`, `src/show.luau`, `src/cleanup.luau` | Native reactive indices and branch scopes; explicit Instance destruction also disconnects events. |

The shared `state.luau` defines only the bridge contract. Charm and Reflex supply its value, release and batch operations. It adds no scheduler or state implementation.
No separate spring package is pinned for React, Roact or Signals. Those lanes keep `animate-many` unsupported. An external spring package would need a separate dependency review and lane.

The `rows-*` adapters are separate from the `keyed-*` adapters. Compose uses explicit id keys. Fusion and Fusion + Charm use `ForValues` with stable row records and computed positions. Each row's state has its own Fusion scope, owned by the sample root. Blend uses `ComputedPairs`, a shared position map and the public `Rx.distinct` operator to suppress unchanged positions. React and Roact keep the row property bindings stable during list reconciliation. Vide uses `values` and native row cleanup. Seam owns each rendered row with an inner scope. Signals uses a signal effect, an explicit id map and per-row effect cleanup in its host bridge. React + Reflex uses one producer, selector subscriptions and one bulk patch action per row transaction; source registration does not flush all selectors for each row value.

Fusion and Blend use their native analytic springs. Vide uses its native solver. The target, damping and nominal period match the workload.
The solvers can produce different intermediate numbers. This lane does not prove equal trajectories, equal numerical error or equal animation quality.

Default properties and native cleanup costs stay in each lane.
All lanes use the same cost-model host, which adds dispatch and counter costs.
The adapters add small Luau call and table costs. The results include those costs.
These results describe this workload, host, runtime and machine. They do not establish native rendering, played quality or a general speedup.
Hosted-runner noise and garbage collection can affect the results. Read the raw samples and calibration records before you draw a conclusion.

## Studio client run

`lute run comparisons/scene-composition/studio/run.luau` runs the same lanes and workloads in a Roblox Studio play client, against real Roblox Instances. Use `--case workload/lane` to select cases and `--out directory` to select the output directory. It writes `studio.md` and `report.json`, and `progress.jsonl` with one line for each case step while the run goes.

A full run splits the workloads into 6 batches by their recorded wall time and runs the batches one after another, each in a new Studio. `--batches N` sets the count. Each batch writes its own `report.json` before the next batch starts, and a run skips a batch that already has a report, so a stopped run keeps its finished batches. A new Studio for each batch also clears the modules that earlier batches loaded. Roblox keeps every required module for the rest of the session, so one long session grows its heap and slows each memory collection.

Use `--shards N` to run the cases in N Studio play clients at the same time. Each client runs whole workloads, so all lanes of a workload run in the same client. The run assigns workloads to clients by their recorded wall time in `comparisons/scene-composition/studio-weights.json`, then merges the client reports with Verify's report merge. `--weights path` selects another weights file and `--record-weights path` writes the wall time of each passed case. Studio renders an unfocused window at a reduced frame rate, and each update waits for a real frame, so parallel clients shorten the wall time of the run. They do not change the profiler time of a sample, which excludes idle frame time. On macOS, Studio renders an unfocused play client at 15 frames per second, and virtual input reaches only the focused client. Frame-bound workloads such as `hud-per-frame` can then exceed the case deadline, and input workloads fail. Publish from one Studio until each client renders at full rate and receives input.

Each library runs without a change to its code:

- The run mounts the pinned source of each library as `ModuleScript` instances in the same layout as its repository. Roblox resolves its requires natively, both instance requires and relative string requires.
- A library that a package manager installs gets the link modules that the package manager would generate, at the paths that its code requires. A Nevermore library gets a `loader` module that maps a module name to its module. The headless loader records these paths when it loads each lane.
- React Lua (`react`, and the React part of `react-reflex`) loads from its published Roblox release model, `react-lua.rbxm` of release `v17.2.1`, pinned by its SHA-256 hash. That release is what Roblox developers install. Its build converts the `@pkg` requires of the source to instance requires. Roblox does not resolve `@pkg` aliases.
- Roblox compiles each module with its own Studio settings. It applies each module's own directives, such as the Compose `--!native` directives, under its rules for a Studio client. The run adds no directive.

Each sample runs the iterations of the workload. Each update ends with a real frame, so deferred tasks and frame callbacks run as they do in a game. The client script profiler (`ScriptProfilerService`, 10 kHz) records the sample. The time of a sample is the Luau time of the call stacks that enter benchmark or library modules. It excludes idle frame time, Studio plugins, default player scripts and Verify. It includes the engine calls that Luau code makes, such as property writes. It does not include rendering or layout that the engine does later in the frame.

Each case loads its library once. Each sample then runs in a fresh environment with that library. Each case runs up to 2 warmup samples and then up to 5 measured samples. After 3 measured samples, a case stops when its measured samples have taken more than 10 seconds. The report gives the sample count of each case. The table gives the median. Each ratio divides by the plain lane. The run compares the settled tree of each lane with the plain lane.

After the timed samples, each case measures memory with the Verify method that the headless run uses (`gc-witness-low-water/2`). Each lifecycle runs in a fresh environment with the library that the case loaded. One unmeasured lifecycle runs first, so module state that a library creates on first use is not in the measured lifecycles. Then up to three lifecycles each read the heap before mount, with the workload mounted after its steps, and after release. `comparisons/memory-settings.luau` holds the collection cycles of each reading, the Studio sample counts and the 10-second budget, and both runs use it. After 2 measured lifecycles, a case stops when they have taken more than 10 seconds. The table gives the median retained heap and the median heap left after teardown, in KiB. A Roblox script cannot start a collection, so allocation pressure drives full collection cycles and a weak witness detects each cycle. The reading is the lowest heap after the cycles. `gcinfo` reports the whole client Luau heap, so other client scripts can add noise. Heap counts Luau memory only, not engine Instance memory.

`events` clicks each of its 10 buttons with `UserInputService:CreateVirtualInput()`: a mouse move, press and release at the button centre, each followed by a real frame. The client must be the focused window, because Studio delivers virtual input only to it. The time includes each lane's `Activated` handlers and excludes native input routing. Time range is the lowest and highest measured sample.

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

## Results

- [Headless results](headless-results.md)
- [Studio client results on Windows](studio-windows.md)
- [Studio client results on macOS](studio-macos.md)
