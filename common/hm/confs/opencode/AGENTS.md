# Development Methodology

## Spec-Driven Development

All non-trivial development tasks MUST follow Spec-Driven Development (SDD).

Before implementing a feature, bug fix, refactor, migration, or architectural change:

1. Investigate the existing codebase.
2. Identify affected functionality and dependencies.
3. Define the expected behavior.
4. Create explicit functional scenarios.
5. Define acceptance criteria.
6. Design the implementation according to the existing architecture.
7. Create an implementation plan.
8. Implement only after the plan is complete.
9. Validate the implementation against the acceptance criteria.

Do not jump directly from a user request to implementation for non-trivial tasks.

### Task Complexity

SDD is mandatory for non-trivial tasks, including:

* New features
* Migrations
* Refactors
* API changes
* Database changes
* Authentication/authorization changes
* Architectural changes
* Bug fixes that modify or affect application behavior

SDD may be skipped for trivial tasks such as:

* Typo corrections
* Formatting-only changes
* Simple documentation changes
* Renaming without behavioral impact

When uncertain whether a task is trivial or non-trivial, treat it as non-trivial.

---

## Evidence

Treat the repository as the primary source of truth.

Do not invent behavior, APIs, business rules, dependencies, or architecture.

Distinguish findings as:

* **Observed** — directly verified in the codebase.
* **Inferred** — strongly implied by the available implementation but not directly verified.
* **Unknown** — cannot be determined from the available evidence.

When behavior cannot be verified, explicitly mark it as **Unknown**.

Do not silently convert assumptions into requirements.

---

## Planning

Every SDD plan MUST contain:

* Discovery
* Functional specification
* Functional scenarios
* Architecture/design
* Acceptance criteria
* Traceability
* Implementation tasks
* Testing strategy
* Risks
* Open questions

The specification and implementation plan MUST be explicitly documented before implementation begins.

The implementation agent MUST use the approved specification and plan as its source of truth.

---

## Scope Control

Do not expand the scope of a task without documenting why the additional work is required.

If additional required work is discovered during planning or implementation:

1. Identify why it is required.
2. Determine whether it is covered by the specification.
3. Update the specification and/or plan if necessary.
4. Re-evaluate affected acceptance criteria.
5. Do not silently expand the implementation scope.

---

## Implementation

Implementation MUST follow the approved specification and plan.

Do not introduce behavior that is not represented in the specification unless required to fix a discovered inconsistency.

If implementation reveals that the specification or plan is incorrect:

1. Stop.
2. Update the specification/plan.
3. Re-evaluate affected acceptance criteria.
4. Continue only after the plan is consistent again.

Do not mark planned work as complete based solely on code being written.

---

## Validation

An implementation is not complete until:

* Tests pass.
* Acceptance criteria are verified.
* The implementation matches the specification.
* The implementation matches the approved plan.
* No unexplained deviations remain.
* Known risks have been addressed or explicitly accepted.
