# Contributing to Luau library benchmarks

Thank you for helping improve Luau library benchmarks. This repository compares the performance of Luau libraries as they ship.

## Set up

Install [Rokit](https://github.com/rojo-rbx/rokit), then install the pinned tools from the repository root:

```console
rokit install --no-trust-check
```

## Rules

Read [AGENTS.md](AGENTS.md) before you change anything. It owns the code, documentation and integration rules.
Every maintained Luau file starts with `--!strict` and uses no explicit `any` and no type casts.
Measure each library as it ships. Do not modify or commit library source, run parity before timing, and write each adapter with the library's public API. The [charter rules](AGENTS.md#charter-rules) own the details.

## Check your change

During edits, run focused checks through the gate, for example `lute run tools/gate.luau --only tests`.
Commit the change, then run the full gate once on the clean HEAD with `lute run tools/gate.luau`.

## Pull requests

Open a pull request to `main` from a branch. Keep each pull request to one coherent change, and describe what
it changes and how you checked it. The required checks must pass. Do not push directly to `main` or bypass a
failing check.

## Reporting issues

Open a GitHub issue with the steps to reproduce, the result you expected and the result you saw.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
