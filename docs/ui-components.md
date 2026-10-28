# UI components comparison

This comparison measures [Facet](https://github.com/josha/Facet), a library of Roblox UI controls, against a `plain` lane. Each workload is a complete player task, such as a settings screen, a leaderboard or a chat log. The `plain` lane does the same task with Instances, native layout objects and plain Luau state, without a library.

## Disclosure

The maintainers of Facet wrote both lanes. Review the `plain` lane as strictly as the Facet lane. If a `plain` lane does work that a careful Roblox developer would not do, or skips work that the task needs, open an issue or a pull request.

## What the lanes match

Both lanes link the same theme StyleSheet. `plain` Instances carry the same style tags, automatic size and auto-localization setting as the Facet controls. `plain` readouts hold their widest same-length width, as Facet text does. `plain` state changes toggle the same state tags. `plain` keeps references to the Instances that it updates.

Facet keeps its extra policy: measurement, accessibility, focus, modal behavior, selection and cancellation. The `plain` lane includes only the controls and state that the task needs. The extra Facet policy is part of the Facet cost.

Parity is weaker than in the scene composition comparison. Facet adds wrappers and control chrome, so the two trees are not equal. Each workload declares the observations that both lanes must match: text, fill fractions, tags, selection traps, input contexts and similar state. The parity check compares these observations after every iteration, then checks that no Instance or connection leaks.

## Motion

The `plain` lane animates with `TweenService`. The engine interpolates a tween natively, so a tween costs almost no Luau time. Facet runs its motion in Luau and writes each frame. This is a design difference between the two approaches, not a handicap of one lane. The dialog, toast, radial, navigation and transfer workloads show it.

## Headless run

The headless run uses the Verify reflection engine double, not the scene composition cost model, because the controls need text services, StyleSheets, input contexts and drag detectors. Facet loads through the same like-for-like loader as the scene composition libraries: optimization level 2 and no native code. Its source has no change. The loader gives Facet the Lute globals and a `getfenv` that returns them, so Facet sees no `game` and takes its headless paths.

The run checks parity for every workload, then collects nine time samples after two warm-up samples, three retained-heap measurements and one instrumented pass that counts property writes and created Instances.

```bash
lute run comparisons/ui-components/compare.luau --verify
lute run comparisons/ui-components/compare.luau --out build/ui-components-comparison
```

## Studio client run

The Studio run uses the same workloads against real Instances in a Roblox Studio play client. It loads Facet from a fresh copy of its module tree for each case, and times Luau work with the client script profiler, as the scene composition Studio run does. Each sample ends with a real frame.

```bash
lute run comparisons/ui-components/studio/run.luau
```

Some workloads cannot run in Studio:

- A script cannot fire `GuiButton.Activated` or set `GuiState`. The inventory, button feedback, dialog, tabs, radial and tile transfer workloads need this input.
- The toast workload waits for 50 toasts to expire in each sample. That is about five minutes of real time for each sample.

A `TextBox` gets focus through `CaptureFocus`. A pinned size becomes a real pixel size.

## Results

- [Headless results](ui-components-results.md)
- [Studio client results on Windows](ui-components-studio-windows.md)
- [Studio client results on macOS](ui-components-studio-macos.md)
