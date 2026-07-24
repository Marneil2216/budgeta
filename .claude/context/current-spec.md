# Current Spec — Monthly Balance Carryover + Balance History

## Problem
The app currently recalculates the budget fresh every month with no memory of prior months. Any leftover (or overspent) balance at month-end is lost — it neither helps nor hurts the following month. There is also no way for the user to see what their remaining balance was in past months.

## Users and Needs
Single logged-in Budgeta user (existing single-user data model, unchanged). They want:
1. Leftover balance from a completed month to automatically carry into the next month's budget.
2. A place to look back at completed months and see what the final remaining balance was for each.

## Acceptance Criteria
1. On app load, if the calendar month has advanced past the last-processed month, the system computes and persists the final remaining balance for the now-completed month(s) using the existing formula: `remainingBalance = salary - activeFixedExpenses - variableExpenses(that month)`.
2. If a completed month's final remaining balance is **positive**, that amount is **added** to the following month's budget baseline.
3. If a completed month's final remaining balance is **negative**, that amount is **subtracted** from the following month's budget baseline.
4. The current (in-progress) month's dashboard `remainingBalance` and `dailyBudget` reflect the carryover from the prior completed month.
5. Rollover happens automatically — no manual "close out month" action.
6. The very first month a user has (no prior completed month) carries over `0`.
7. A new bottom-nav tab labeled **"Balance History"** is added.
8. The Balance History tab shows a simple list of **completed months only** (current in-progress month excluded), each with its final remaining balance.
9. Balance History entries are **read-only** — no editing or deleting past entries, by anyone, through the UI.

## Constraints
- `dashboardSummaryProvider` stays a synchronous derivation (per `docs/architecture.md`) — no async work added inside it directly. Carryover/history data is exposed via a new provider watched the same way `userProfileProvider` is watched today.
- New persisted data lives in new table(s)/migration — existing tables (`user_profiles`, `fixed_expenses`, `variable_expenses`) are not repurposed.
- RLS enabled on any new table, scoped to `auth.uid()`, consistent with existing tables.
- Single-user data model unchanged — no sharing/multi-user concerns.
- New UI follows existing constraints: Dart 3.5.3 / Flutter < 3.27 (`withOpacity()`, not `withValues()`), neumorphic theme, `AppColors`/`AppSpacing` tokens, feature-folder structure (`lib/features/<name>/data|domain|presentation/`).

## Out of Scope
- Editing or correcting a past month's saved balance.
- Charts/graphs on the Balance History page — plain list only.
- Exporting history.
- Showing the current in-progress month in the Balance History list.

## Open Questions
None blocking — schema/table naming and exact rollover-detection mechanics are implementation details for the planning gate, not spec-level decisions.
