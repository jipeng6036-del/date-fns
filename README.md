# parseISO exact decimal precision validation

Baseline: `a9739fb3e5384a810e90d7376446f6d84ecc5029`. Candidate: `2fad341430a4b045e07dad518c1964fd5c0cc385`, tree `f33c3d17040806a2c91c55bb28d0ae3d763fcdee` (2,070 files and modes).
Based on [Frédéric Bonnet's #3199](https://github.com/date-fns/date-fns/pull/3199), with a real `cherry-pick -x`, original author/date retained and old source paths ported to the current monorepo. The following commit replaces floating-point floor with exact decimal digit accumulation and extends the regressions.

## Reproduce with the actual project

```sh
git clone https://github.com/jipeng6036-del/date-fns.git
cd date-fns
git checkout 2fad341430a4b045e07dad518c1964fd5c0cc385
pnpm install --frozen-lockfile
mise //:types
mise //:lint
mise //pkgs/core:test/node
mise //pkgs/core:test/browser
mise //pkgs/core:test/tz
mise //pkgs/core:test/smoke
```

Raw commands, runtime versions and outputs are attached. The installed-package proof used a complete package build, `npm pack`, and clean installation outside the source tree. `package-proof.sh` and `installed-package-proof.mjs` record the actual runner commands and all assertions; their `/work`, `/consumer`, `/evidence` paths are isolated runner paths. `produce-dotnet.ps1` created the actual .NET10.0.11 TimeOnly.MaxValue/DateTimeOffset round-trip JSONL. The second JSONL is database-shaped issue input, not a real database service. All60 consumer assertions passed through ESM/CJS/root/subpath/FP/context entries. All5,136 built package files were byte-identical before/after canonical rebuild.

## Results and limits

- Node22.23.4,24.22.2,25.9.0,26.13.0: each253 files,3,180 passed,19 skipped; each real DST script passed.
- Real Chromium:253 files,3,181 passed,18 skipped. Full378-timezone suite passed. Types, lint, changed-file format, all10 smoke examples and full build passed.
- Same90 regression cases: baseline77 passed/13 failed; original floor78 passed/12 failed; final90 passed. Standard2014 `.001` values demonstrate the original floor regression; the epoch1970 case was already broken on baseline. The root's separate3,000 exact-rational source checks passed; this extra oracle is not a replacement for browser/package verification.
- Current locale CI passes `--test`, but its script only asserts snapshots for bare `test`. The configured command completed generation. All95 generated baseline/candidate outputs are byte-identical. The additional bare-test diagnostic fails on the same pre-existing ar-DZ mismatch; no snapshot-assertion pass is claimed. The19 generated files were restored and are absent from the PR;16 differ only in formatting,3 contain stale upstream Chinese parse values.
- Existing permissive fractional24.x hours validation remains out of scope (#4219). Extremely long24.999... now remains mathematically below25 instead of being rounded to25. No complete ISO-validation claim.
- Local results only; no real database account, paid service, human review, hosted CI, merge or release claimed. Upstream Actions/approvals are checked after PR creation.

`COMMIT_BINDING.json` and `CANONICAL_TREE.json` bind the tested complete tree to the final commit. SHA-256 allowlist: `manifest.json`.
