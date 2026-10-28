# Luau library benchmarks

This repository compares the performance of Luau libraries. It measures each library as the library ships. Each comparison checks that all libraries produce the same result before it measures time.

The first comparison measures Roblox scene composition libraries:

- Compose (`compose` and the control lane `compose-direct`)
- Fusion (`fusion`)
- Vide (`vide`)
- React Lua (`react`)
- Roblox React Lua (`react-upstream`)
- Blend (`blend`)
- Roact (`roact`)
- Seam (`seam`)
- Roblox signals (`signals`)
- React with Reflex (`react-reflex`)
- Fusion with Charm (`fusion-charm`)
- Plain Luau with no library (`plain`)

Each lane runs the same 22 workloads.

## Charter

These rules apply to every comparison in this repository.

1. **Measure each library as it ships.** Load the published source at a pinned commit. Do not change compiler settings that the library does not set.
2. **Do not modify the source of a library.** If a harness technique does not fit a file, use the fallback for that file. Disclose each fallback in the results.
3. **Check parity before timing.** Each lane must produce the same observable result, the same intermediate states, the same retained identity and the same teardown. A lane that fails parity gets no timing.
4. **Warm each library.** Load the library one time per worker. Run an unmeasured sample and the warmup samples before the measured samples.
5. **Collect garbage before each sample.** Run two full collection cycles after the setup and before the timer starts.
6. **Rotate the lane order.** Each workload starts with a different lane. Each lane runs first in some workloads and last in others.
7. **Use one driver for all lanes.** Each lane goes through the same comparison driver. Each adapter uses the public API of its library in the way that the library documents. Review each adapter against the documentation of its library.
8. **Give a reason for each unsupported workload.** An unsupported lane has no timing. A missing implementation without a reason fails parity.
9. **Do not publish numbers that a run did not produce.** Each published number comes from a recorded run with its source identities.

## What the results are

The results are headless measurements. All lanes run against the same Luau cost model of the Roblox engine. The results do not measure Roblox engine rendering, layout, input or frame time. They describe the workload, the cost-model host, the Luau runtime and the machine of the run.

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

Use `--filter text` to select workload ids. Use `--mode like-for-like` to load all lanes through the same loader at optimization level 2. The default mode is `as-shipped`.

## Results

[docs/results.md](docs/results.md) holds the published results. The manual **Library comparison** workflow produces them.

## Documents

- [Method](docs/method.md): compilation modes, support, measurement and fairness.
- [Results](docs/results.md): the published run.
- [Maintainer rules](AGENTS.md): rules for changes to this repository.

## License

The harness uses the MIT license. Each measured library keeps its own license. The [lock file](dependencies.lock.luau) records the license status and notice paths of each library. The library sources stay in the ignored `.lute/dependencies` directory.
