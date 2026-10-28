# Results

This page holds no results yet. The **Library comparison** workflow has not run on this repository.

## How a run produces this page

1. A maintainer starts the **Library comparison** workflow on `main` with the mode `as-shipped`.
2. The workflow syncs the pinned dependencies and runs `lute run comparisons/scene-composition/compare.luau`.
3. The command runs parity for each workload. It then runs timing and heap measurement for each lane that passed parity.
4. The workflow writes `comparison.md` to the job summary. It keeps the output directory as the `scene-composition-comparison` artifact. The artifact holds `comparison.md`, `report.json`, `stored.json`, `context.json` and the gate evidence.
5. The maintainer replaces this page with the content of `comparison.md` from that artifact. The page must name the harness commit, the workflow run link, the runner and the mode.

Copy each number from the artifact. Do not type, round or edit a number by hand. Do not publish a run whose verdict is not `release`.

## What the results will mean

The results are headless cost-model measurements. They do not measure Roblox engine rendering. Read the [method](method.md) before you compare two lanes. The workloads `ordered-window-scroll`, `unwind`, `update-repeated` and `status-panel` measure Compose contracts. The summary leaves them out.
