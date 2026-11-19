# Repository Exploration Rules

- Treat the checked-out repository as the source of truth.
- Start with the smallest relevant set of files; do not dump the whole repository.
- Inspect package manifests, workspace configuration, entry points, and nearby tests before drawing conclusions.
- Distinguish observed facts, inferences, and unknowns.
- Prefer targeted `rg`, `find`, `git diff`, and file reads over broad recursive output.
- Exclude generated folders and dependencies such as `node_modules`, `dist`, `build`, `.next`, `coverage`, `result`, and `.git`.
- Do not modify files when acting as an exploration-only agent.
- Summarize findings with file paths and explain what evidence supports each conclusion.
