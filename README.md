# Luau library benchmarks

This repository compares the performance of Luau libraries. It measures each library as the library ships. Each comparison checks that all libraries produce the same result before it measures time and memory, and it treats time and retained heap alike.

These benchmarks are intended to help Roblox developers make informed architectural decisions and help library maintainers identify performance opportunities. They are not intended to rank the quality of the libraries themselves. We welcome corrections, additional workloads, and optimizations from maintainers of every library tested.

Each workload models one task from a Roblox game or app, such as a leaderboard, a shop search, a settings form or a per-frame HUD, and each asks a different question about cost. In each comparison, a `plain` lane does the same work with no library, and each ratio divides by the `plain` value.

## Comparisons

| | Scene composition | UI components |
| --- | --- | --- |
| Measures | Roblox scene composition libraries | A Roblox UI control library |
| Lanes | Blend, Compose, Fusion, Fusion with Charm, React Lua, React with Reflex, Roblox React Lua, Roact, Roblox signals, Seam and Vide | [Facet](https://github.com/josha/Facet) |
| Workloads | 30 | 30 |
| Method | [Method](docs/scene-composition/method.md) | [Method](docs/ui-components/method.md) |
| Headless results | [Headless](docs/scene-composition/headless-results.md) | [Headless](docs/ui-components/headless-results.md) |
| Studio client results | [Windows](docs/scene-composition/studio-windows.md), [macOS](docs/scene-composition/studio-macos.md) | [Windows](docs/ui-components/studio-windows.md), [macOS](docs/ui-components/studio-macos.md) |

Each lane runs every workload that its library supports. Each method lists the unsupported workloads with a reason, and each lane workaround with what its result measures.

## Disclosure

The maintainers of Facet wrote both lanes of the UI components comparison. Review its `plain` lane as strictly as its Facet lane.

The maintainer of this repository also maintains Compose. Hold the Compose lane to the same review as the other lanes. If an adapter does not use a library the way that its documentation recommends, open an issue or a pull request. A maintainer of that library can review or replace its adapter.

## Help improve these benchmarks

If you maintain one of these libraries, we would love your help. Open an issue or a pull request to:

- improve your library's adapter, or write it yourself the way you would use the library;
- suggest a workload that shows how your library is really used;
- tell us if an unsupported reason or a check looks wrong;
- share an optimization, and we will run both result sets again;
- run the Studio comparison on your own machine, especially on Windows, and share the `studio.md` it writes.

Changes to an adapter or a workload need to pass the same checks for every lane, so the comparison stays fair for everyone.

## Charter

These rules apply to every comparison in this repository.

1. **Measure each library as it ships, compiled the same way.** Load the published source at a pinned commit. Compile every library through the same loader at optimization level 2, the level of live Roblox experiences, without native code. The loader sets the level with a compiler directive line. It does not change a library statement.
2. **Do not modify the source of a library.** If a harness technique does not fit a file, use the fallback for that file. Disclose each fallback in the results.
3. **Check parity before timing.** Each lane must produce the same observable result, the same intermediate states, the same retained identity and the same teardown. A lane that fails parity gets no timing.
4. **Warm each library.** Load the library one time per worker for ordinary workloads. Run an unmeasured sample and the warmup samples before the measured samples. The `library-load` workload uses a fresh module cache for each sample, including warmup samples.
5. **Collect garbage before each sample.** Run two full collection cycles after the setup and before the timer starts.
6. **Rotate the lane order.** Each workload starts with a different lane. Each lane runs first in some workloads and last in others.
7. **Use one driver for all lanes.** Each lane goes through the same comparison driver. Each adapter uses the public API of its library in the way that the library documents. Review each adapter against the documentation of its library.
8. **Give a reason for each unsupported workload.** An unsupported lane has no timing. A missing implementation without a reason fails parity.
9. **Do not publish numbers that a run did not produce.** Each published number comes from a recorded run with its source identities.

## What the results are

Each comparison has two result sets:

- Studio client results on Windows and macOS: each library runs unchanged against real Roblox Instances in a Roblox Studio play client, on a named machine. These are the main results.
- Headless results: each library runs in a Luau cost model of the engine, in CI. This run checks that every lane builds the same tree, and counts engine work.

A ratio describes one workload on one host. A library can make design choices, such as safety checks, scheduling or developer tools, that cost time in a workload and help in a game. Read the method before you compare two lanes.

The headless results run all lanes against the same Luau cost model of the Roblox engine. The Studio client results run against the real engine. Both sets report time and retained Luau heap for every workload. Neither set measures rendering, layout or input time. Each describes its workload, host, runtime and machine.

## Run the comparisons

You need [Rokit](https://github.com/rojo-rbx/rokit) and Git. Rokit installs the pinned tools in `rokit.toml`: Lute, luau-lsp, StyLua and Rojo. Then run these commands from the repository root:

```bash
rokit install --no-trust-check
lute setup
lute pkg install --vendor
lute run tools/sync-dependencies.luau
lute run comparisons/scene-composition/compare.luau --verify --out build/scene-composition-parity
lute run comparisons/scene-composition/compare.luau --out build/scene-composition-comparison
lute run comparisons/ui-components/compare.luau --verify --out build/ui-components-parity
lute run comparisons/ui-components/compare.luau --out build/ui-components-comparison
```

`lute pkg install --vendor` installs Compose, Facet and Verify into `.lpm`. `tools/sync-dependencies.luau` clones the third-party libraries into `.lute/dependencies`. Set `GITHUB_TOKEN` to avoid GitHub API rate limits during the package install.

For each comparison, `--verify` runs only the parity checks. The run without it runs parity, timing and heap measurement. Use `--filter text` to select workload ids. Each method describes its other options.

To check a change, run `lute run tools/gate.luau`. The gate runs format, lint, both type solvers, the specifications, parity in both modes, the provenance and license checks and a clean-clone check. [AGENTS.md](AGENTS.md) describes the focused checks.

## Run in Roblox Studio

On a machine with Roblox Studio installed and signed in, run:

```bash
lute run comparisons/scene-composition/studio/run.luau
lute run comparisons/ui-components/studio/run.luau
```

Each command opens Studio play clients, runs every case and writes `studio.md` and `report.json` to `build/scene-composition-studio` or `build/ui-components-studio`. Each method describes its Studio client run.

## Result format

Each headless comparison writes these files to its output directory:

- `comparison.md`: one table row for each workload and lane, the lane workarounds, the summary, the source identities and the loader fallbacks.
- `report.json`: the full Verify report, with raw samples, calibration attempts, parity results and heap readings. The UI components report uses the `ui-components/1` schema, with the harness revision, the Facet commit, the environment, the measurements and the table rows.
- `context.json` (scene composition): the harness commit and tree, the dirty state, the runtime, the machine, the command, the mode and the identity of each library source.
- `gate/`: the Verify gate evidence.

Each table row gives the median time of one complete workload sample in microseconds, the retained Luau heap with the workload mounted in KiB, and each value divided by the `plain` value. A lower ratio means a smaller measurement. A ratio describes one workload on one host.

A Studio run writes `studio.md` and `report.json`. `studio.md` adds the machine, the Roblox Studio version, the time range of each case and the teardown heap.

## Results

Each comparison folder in `docs` holds `headless-results.md` from the manual **Library comparison** workflow, and `studio-windows.md` or `studio-macos.md` for each operating system that has a recorded Studio run. A maintainer runs the Studio command on that operating system and copies `studio.md` to its file. Each result file names the library commits that it measured. Those commits can be older than the current pins.

## Documents

- Scene composition: [method](docs/scene-composition/method.md), [headless results](docs/scene-composition/headless-results.md), Studio client results on [Windows](docs/scene-composition/studio-windows.md) and [macOS](docs/scene-composition/studio-macos.md).
- UI components: [method](docs/ui-components/method.md), [headless results](docs/ui-components/headless-results.md), Studio client results on [Windows](docs/ui-components/studio-windows.md) and [macOS](docs/ui-components/studio-macos.md).
- [Maintainer rules](AGENTS.md): rules for changes to this repository.

## Libraries and licenses

The harness uses the [MIT license](LICENSE). This repository contains no library source. Each measured library keeps its own license and copyright, and each install keeps the library's license notice next to its source.

Compose, Facet and Verify are [`lute pkg`](https://github.com/luau-lang/lute) packages. [`pkg.luau`](pkg.luau) pins each one at a full commit, and [`pkg.lock.luau`](pkg.lock.luau) locks it:

| Package | Repository | License |
| --- | --- | --- |
| Verify | [voidmeld/verify](https://github.com/voidmeld/verify) | MIT |
| Compose | [voidmeld/compose](https://github.com/voidmeld/compose) | MIT |
| Facet | [josha/Facet](https://github.com/josha/Facet) | MIT |

The other libraries have no `pkg.luau`, and `lute pkg` does not install a GitHub dependency without one. [`dependencies.lock.luau`](dependencies.lock.luau) pins each of them with its commit, tree, license status, license notice paths and measured roots. `tools/sync-dependencies.luau` checks out only the measured roots and the notices, and fails when a notice is absent:

| Library | Repository | Version | License notice |
| --- | --- | --- | --- |
| fusion | [dphfox/Fusion](https://github.com/dphfox/Fusion) | 0.3 | LICENSE (MIT) |
| vide | [centau/vide](https://github.com/centau/vide) | 0.4.1 | LICENSE.md (MIT) |
| react | [jsdotlua/react-lua](https://github.com/jsdotlua/react-lua) | 17.2.1 | LICENSE (MIT) |
| luau-polyfill | [jsdotlua/luau-polyfill](https://github.com/jsdotlua/luau-polyfill) | 1.2.6 | LICENSE (MIT) |
| symbol | [jsdotlua/symbol-luau](https://github.com/jsdotlua/symbol-luau) | 1.0.1 | LICENSE.txt (MIT) |
| react-promise | [jsdotlua/roblox-lua-promise](https://github.com/jsdotlua/roblox-lua-promise) | 3.5.0 | LICENSE (MIT) |
| blend | [Quenty/NevermoreEngine](https://github.com/Quenty/NevermoreEngine) | 12.51.1 | LICENSE.md (MIT) |
| roact | [Roblox/roact](https://github.com/Roblox/roact) | v1.4.4 | LICENSE.txt (MIT) |
| seam | [MiaGobble/Seam](https://github.com/MiaGobble/Seam) | v1.1.0 | LICENSE (MIT) |
| signals | [Roblox/signals](https://github.com/Roblox/signals) | 0.9.0-unreleased | LICENSE (MIT) |
| reflex | [littensy/reflex](https://github.com/littensy/reflex) | v4.3.1 | LICENSE.md (MIT) |
| charm | [littensy/charm](https://github.com/littensy/charm) | charm-v0.11.1 | LICENSE (MIT) |
| react-upstream | [Roblox/react-lua](https://github.com/Roblox/react-lua) | v17.1.3 | LICENSE (MIT) |
| polyfill-upstream | [Roblox/luau-polyfill](https://github.com/Roblox/luau-polyfill) | v1.2.3 | LICENSE (MIT) |
| promise-upstream | [Roblox/roblox-lua-promise](https://github.com/Roblox/roblox-lua-promise) | v3.3.0 | LICENSE (MIT) |
| symbol-upstream | [Roblox/symbol-luau](https://github.com/Roblox/symbol-luau) | v1.0.0 | LICENSE.txt (MIT) |
| reflex-promise | [evaera/roblox-lua-promise](https://github.com/evaera/roblox-lua-promise) | v4.0.0 | LICENSE (MIT) |
