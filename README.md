# Luau library benchmarks

This repository compares the performance of Luau libraries. It measures each library as the library ships. Each comparison checks that all libraries produce the same result before it measures time and memory, and it treats time and retained heap alike.

These benchmarks are intended to help Roblox developers make informed architectural decisions and help library maintainers identify performance opportunities. They are not intended to rank the quality of the libraries themselves. We welcome corrections, additional workloads, and optimizations from maintainers of every library tested.

Each workload models one task from a Roblox game or app, such as a leaderboard, a shop search, a settings form or a per-frame HUD, and each asks a different question about cost. In each comparison, a `plain` lane does the same work with no library, and each ratio divides by the `plain` value.

## Comparisons

| | Scene composition | UI components |
| --- | --- | --- |
| Measures | Roblox scene composition libraries | A Roblox UI control library |
| Lanes | Blend, Compose, Fusion, Fusion with Charm, React Lua, React with Reflex, Roblox React Lua, Roact, Roblox signals, Seam and Vide | [Facet](https://github.com/josha/Facet) |
| Workloads | 32 | 34 |
| Method | [Method](docs/scene-composition/method.md) | [Method](docs/ui-components/method.md) |
| Headless results | [Headless](docs/scene-composition/headless-results.md) | [Headless](docs/ui-components/headless-results.md) |
| Studio client results | [Windows](docs/scene-composition/studio-windows.md), [macOS](docs/scene-composition/studio-macos.md) | [Windows](docs/ui-components/studio-windows.md), [macOS](docs/ui-components/studio-macos.md) |

Each lane runs every workload that its library supports. Each method lists the unsupported workloads with a reason.

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

Install the pinned tools with [Rokit](https://github.com/rojo-rbx/rokit). Then run these commands:

```bash
rokit install --no-trust-check
lute setup
lute run tools/sync-dependencies.luau
lute run comparisons/scene-composition/compare.luau --verify --out build/scene-composition-parity
lute run comparisons/scene-composition/compare.luau --out build/scene-composition-comparison
lute run comparisons/ui-components/compare.luau --verify --out build/ui-components-parity
lute run comparisons/ui-components/compare.luau --out build/ui-components-comparison
```

For each comparison, `--verify` runs only the parity checks, and the run without it runs parity, timing and heap measurement and writes `comparison.md` and `report.json` to the output directory. Use `--filter text` to select workload ids. Each method describes its other options.

## Run in Roblox Studio

On a machine with Roblox Studio installed and signed in, run:

```bash
lute run comparisons/scene-composition/studio/run.luau
lute run comparisons/ui-components/studio/run.luau
```

Each command opens Studio play clients, runs every case and writes `studio.md` and `report.json` to `build/scene-composition-studio` or `build/ui-components-studio`. Each method describes its Studio client run.

## Results

Each comparison folder in `docs` holds the same three result files: `headless-results.md` from the manual **Library comparison** workflow, and `studio-windows.md` and `studio-macos.md`. A maintainer runs the Studio command on that operating system and copies `studio.md` to its file.

## Documents

- Scene composition: [method](docs/scene-composition/method.md), [headless results](docs/scene-composition/headless-results.md), Studio client results on [Windows](docs/scene-composition/studio-windows.md) and [macOS](docs/scene-composition/studio-macos.md).
- UI components: [method](docs/ui-components/method.md), [headless results](docs/ui-components/headless-results.md), Studio client results on [Windows](docs/ui-components/studio-windows.md) and [macOS](docs/ui-components/studio-macos.md).
- [Maintainer rules](AGENTS.md): rules for changes to this repository.

## License

The harness uses the MIT license. Each measured library keeps its own license. The [lock file](dependencies.lock.luau) records the license status and notice paths of each library. The library sources stay in the ignored `.lute/dependencies` directory.
