# Claude Reference

Lookup tables for Claude Code. Read on demand — `CLAUDE.md` points here.

This folder holds **facts**, not procedures. How to *build* a feature lives in the
`flutter-clean-arch` skill (`.claude/skills/flutter-clean-arch/SKILL.md`). Nothing here
should re-explain the layer structure; if it does, delete it — duplicated docs drift.

| File | Holds | Read before |
|---|---|---|
| [api-contract.md](api-contract.md) | Response envelope, error shapes, endpoint inventory | Adding or changing any API call |
| [di-checklist.md](di-checklist.md) | Annotate, generate, resolve — how `injectable` registration works here | Adding a usecase, repo, datasource, or cubit |
| [codebase-map.md](codebase-map.md) | Where things live in `lib/core/` | Reaching for anything shared |
| [commands.md](commands.md) | Run, build, codegen, analyzer baseline | Running or generating anything |
| [gotchas.md](gotchas.md) | Traps that have bitten before | Anytime; append when something bites twice |
| [self-review.md](self-review.md) | What to check on your own diff | Finishing — before reporting a task done |

## Writing here: rules vs. snapshots

The trap when documenting a codebase is describing **the mess you found** instead of **the
rule to follow**. A survey of current inconsistencies reads as authoritative, tells an
implementer nothing about what to do, and goes stale the moment someone cleans up.

Keep the two separate:

- **Rules** — `api-contract.md`, `di-checklist.md`, `codebase-map.md`, `commands.md`.
  Prescriptive and durable. Say "do X", not "some files do X and others do Y". If old code
  disagrees with the rule, one line is enough: don't copy it.
- **Snapshots** — `gotchas.md` only. Present-tense oddities that will expire. Date them and
  include the command to regenerate the finding, so staleness is detectable.
- **Mechanism walkthroughs** — add one file per cross-cutting flow whose ordering and
  ownership are expensive to rediscover (a payment redirect, a deep-link chain). Cite
  `file:line` for every claim, and mark anything not observed as unverified rather than
  asserting it.

If you're about to write an inventory of current defects into a rules file, it belongs in
`gotchas.md` or an issue instead.

## Maintaining this

Keep each file short enough that updating it is cheap. A stale file here is worse than no
file, because it will be trusted over the code.

Volatile detail belongs in the code, not here. These files should record things that are
**expensive to rediscover** — conventions, invariants, and cross-file coupling — not
things a single `grep` would answer.

Entries marked **[unverified]** were inferred rather than confirmed against a spec.
Correct or delete them; don't let them harden into assumed truth.
