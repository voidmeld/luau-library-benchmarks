# Luau library benchmarks

This repository compares the performance of Luau libraries. It measures each library as the library ships. Each comparison checks that all libraries produce the same result before it measures time.

These benchmarks are intended to help Roblox developers make informed architectural decisions and help library maintainers identify performance opportunities. They are not intended to rank the quality of the libraries themselves. We welcome corrections, additional workloads, and optimizations from maintainers of every library tested.

The first comparison measures Roblox scene composition libraries:

- Blend (`blend`)
- Compose (`compose`)
- Fusion (`fusion`)
- Fusion with Charm (`fusion-charm`)
- React Lua (`react`)
- React with Reflex (`react-reflex`)
- Roblox React Lua (`react-upstream`)
- Roact (`roact`)
- Roblox signals (`signals`)
- Seam (`seam`)
- Vide (`vide`)

Each lane runs the same 22 workloads. The `plain` lane does the same work in plain Luau with no library. Each ratio in the results divides by the `plain` value.

## Disclosure

The maintainer of this repository also maintains Compose. The harness started in the Compose repository. Hold the Compose lane to the same review as the other lanes. If an adapter does not use a library the way that its documentation recommends, open an issue or a pull request. A maintainer of that library can review or replace its adapter.

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
4. **Warm each library.** Load the library one time per worker. Run an unmeasured sample and the warmup samples before the measured samples.
5. **Collect garbage before each sample.** Run two full collection cycles after the setup and before the timer starts.
6. **Rotate the lane order.** Each workload starts with a different lane. Each lane runs first in some workloads and last in others.
7. **Use one driver for all lanes.** Each lane goes through the same comparison driver. Each adapter uses the public API of its library in the way that the library documents. Review each adapter against the documentation of its library.
8. **Give a reason for each unsupported workload.** An unsupported lane has no timing. A missing implementation without a reason fails parity.
9. **Do not publish numbers that a run did not produce.** Each published number comes from a recorded run with its source identities.

## What the results are

There are two result sets:

- [Studio client results](docs/studio-results.md): each library runs unchanged against real Roblox Instances in a Roblox Studio play client, on a named machine. These are the main results.
- [Headless results](docs/results.md): each library runs in a Luau cost model of the engine, in CI. This run checks that every lane builds the same tree, and counts engine work.

A ratio describes one workload on one host. A library can make design choices, such as safety checks, scheduling or developer tools, that cost time in a workload and help in a game. Read the method before you compare two lanes.

The headless results run all lanes against the same Luau cost model of the Roblox engine. The Studio client results run against the real engine. Neither set measures rendering, layout or input time. Each describes its workload, host, runtime and machine.

## Run the comparison

Install the pinned tools with [Rokit](https://github.com/rojo-rbx/rokit). Then run these commands:

```bash
rokit install --no-trust-check
lute setup
lute run tools/sync-dependencies.luau
lute run comparisons/scene-composition/compare.luau --verify --out build/parity
lute run comparisons/scene-composition/compare.luau --out build/scene-composition-comparison
```

The first comparison command runs only the parity checks. The second command runs parity, timing and heap measurement. It writes `comparison.md`, `report.json`, `stored.json` and `context.json` to the output directory.

Use `--filter text` to select workload ids. The default mode is `like-for-like`: all lanes load through the same loader at optimization level 2. Use `--mode as-shipped` to load Compose through Lute `require` with its own `--!native` directives and the other libraries at the default level 1. The published results use `like-for-like`.

## Run in Roblox Studio

On a machine with Roblox Studio installed and signed in, run:

```bash
lute run comparisons/scene-composition/studio/run.luau
```

It opens a Studio play client, runs every case and writes `studio.md` and `report.json` to `build/scene-composition-studio`. The [method](docs/method.md#studio-client-run) describes the run.

## Results

[docs/studio-results.md](docs/studio-results.md) holds the Studio client results. A maintainer runs the command above and copies `studio.md` there. [docs/results.md](docs/results.md) holds the headless results. The manual **Library comparison** workflow produces them.

## Documents

- [Method](docs/method.md): compilation modes, support, measurement and fairness.
- [Studio client results](docs/studio-results.md): the published Studio client run.
- [Headless results](docs/results.md): the published headless run.
- [Maintainer rules](AGENTS.md): rules for changes to this repository.

## License

The harness uses the MIT license. Each measured library keeps its own license. The [lock file](dependencies.lock.luau) records the license status and notice paths of each library. The library sources stay in the ignored `.lute/dependencies` directory.
