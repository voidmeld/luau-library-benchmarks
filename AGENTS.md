# Maintainer rules

This repository compares the performance of Luau libraries. The [README](README.md) holds the charter. The [method](docs/method.md) holds the measurement details. This file holds the rules for changes.

## Charter rules

- Measure each library as it ships. Pin each library in `dependencies.lock.luau` with its exact commit, tree, license status and notice paths.
- Do not modify the source of a library. Do not commit library source to this repository. The sync tool puts library source in the ignored `.lute/dependencies` directory.
- Publish only `like-for-like` results. In that mode every library loads through the loader in `comparisons/scene-composition/harness/upstream.luau` at optimization level 2. `as-shipped` mode is a diagnostic: it loads Compose through Lute `require` with its own directives.
- If a harness technique does not fit a library file, use the fallback for that file. The comparison output must disclose each fallback.
- Run parity before timing. Do not remove a parity check to make a lane pass. Give an unsupported workload a reason of more than 20 characters.
- Write each adapter with the public API of its library. Review the adapter against the documentation of that library. Name the documentation that you checked in the commit message.
- Treat every lane the same. Use the same driver, the same warmup, the same garbage collection and the same rotated order for each lane.
- Do not write numbers into `docs/results.md` by hand. Copy them only from a recorded run of the **Library comparison** workflow, with its run link and source identities.
- Do not write numbers into `docs/studio-results.md` by hand. Copy `studio.md` from one complete `comparisons/scene-composition/studio/run.luau` run on a clean committed HEAD. Keep the machine section. Do not run other heavy work on the machine during the run.

## Rules for code

- Write all automation in strict Luau and run it with Lute. Do not add Python, shell scripts or Lune.
- Do not use the `any` type. Use concrete types or narrow `unknown`. The `type-policy` producer checks this rule.
- Do not add explanatory comments. Keep tool directives and required license notices. The `comments` producer checks this rule.
- Write each test as a Verify case. Declare `local describe, it, expect = Test.describe, Test.it, Test.expect` one time per specification.
- After you add or remove a specification, run `lute run tools/check-test-manifest.luau --write`.
- Use the Verify dependency for registration, assertions, execution, gates and reports. Do not add a separate test harness.

## Validate

- During edits, run focused checks through the gate. For example: `lute run tools/gate.luau --only tests` or `lute run tools/gate.luau --file tests/tools/framework-comparison.lute.verify.luau`.
- Commit the change. Then run `lute run tools/gate.luau` one time on the clean HEAD. The full gate includes format, lint, both type solvers, the specifications, parity in both modes and the clean-clone check.
- Do not change verified bytes after the gate.

## Update a pinned library

1. Change the commit, tree and version of the library in `dependencies.lock.luau`.
2. Run `lute run tools/sync-dependencies.luau`.
3. Run `lute run comparisons/scene-composition/compare.luau --verify` in both modes.
4. If a lane now fails parity, fix the adapter or record an unsupported reason. Do not change the library.
5. Run the full gate.

## Repository

Changes use a pull request to `main` and the required `Gate` check. Do not push directly to `main`. Do not bypass a failing check.

Use Simplified Technical English for documentation. Keep API names and identifiers unchanged. Use one term for each concept.
