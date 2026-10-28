--!strict

local process = require "@std/process"
local Policy = require "./checks-policy"
local Repository = require "../.lute/dependencies/verify/src/checks/repository"
local Clone = require "../.lute/dependencies/verify/src/checks/clean-clone"
local Comments = require "../.lute/dependencies/verify/src/checks/comments"
local Manifest = require "../.lute/dependencies/verify/src/checks/manifest"
local Provenance = require "../.lute/dependencies/verify/src/checks/provenance"

local config: {
	leakage: Repository.Scan,
	provenance: Provenance.Config,
	comments: Comments.Config,
	manifest: Manifest.Config,
	cleanClone: Clone.Config,
	noAny: Repository.Selection,
	specStyle: Repository.Selection,
} =
	{
		leakage = {
			suffixes = { ".luau", ".lua", ".md", ".json", ".toml", ".txt", ".yml", ".yaml" },
			exclude = { [Policy.selfPath] = true, LICENSE = true },
			rules = Policy.leakage,
			allowedLiterals = {},
		},
		provenance = {
			forbiddenPaths = {
				"vendor",
				"third_party",
				"third-party",
				"node_modules",
				"Packages",
				"DevPackages",
			},
			license = "LICENSE",
			licensePrefix = "MIT License\n",
			licenseFragments = {
				"Copyright (c) 2026 voidmeld",
				"Permission is hereby granted, free of charge, to any person obtaining a copy",
			},
			lock = "dependencies.lock.luau",
			dependencyCommand = { "lute", "run", "tools/sync-dependencies.luau", "--check" },
			root = ".",
			skip = { ".git/", "build/", ".lute/" },
			suffixes = { ".luau", ".lua", ".md", ".toml", ".json", ".yml", ".yaml", ".sh", ".py" },
			descriptors = {
				"manifest.json",
				"package.json",
				"package-lock.json",
				"wally.toml",
				"wally.lock",
				"rotriever.toml",
			},
			noticeNames = { "LICENSE", "LICENCE", "LICENSE.md", "LICENCE.md", "COPYING", "NOTICE", "NOTICE.md" },
			expectedNotices = { LICENSE = "the harness's MIT license grant" },
			scriptExceptions = {},
			forbiddenSuffixes = { ".py" },
			justifiedSuffixes = { ".sh" },
		},
		comments = {
			roots = { "comparisons", "tests", "tools" },
			files = { "dependencies.lock.luau", "lint.config.luau" },
			configFiles = { ".styluaignore", "rokit.toml", "stylua.toml" },
			allowed = { "^%-%-![A-Za-z]+", "^%-%-# selene" },
			lineDirectives = true,
		},
		manifest = { path = "tests/manifest.luau", rules = { { root = "tests", pattern = "%.verify%.luau$" } } },
		cleanClone = {
			prefix = "benchmarks-clean-clone",
			command = { "lute", "run", "tools/gate.luau", "--tier", "fast" },
			env = { BENCHMARK_DEPENDENCY_SOURCE_ROOT = tostring(process.cwd()) .. "/.lute/dependencies" },
			requiredPaths = { ".lute/dependencies" },
		},
		noAny = { untracked = true },
		specStyle = {
			untracked = true,
			exclude = { ["tests/tools/framework-comparison.lute.verify.luau"] = true },
		},
	}

return config
