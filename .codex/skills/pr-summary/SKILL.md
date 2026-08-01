---
name: pr-summary
description: Draft concise pull request titles and descriptions from code changes, git diffs, commits, or user-provided change notes. Use when Codex is asked to open a PR, prepare PR text, summarize changes for a pull request, create a short PR title including unrelated main changes when needed, write a compact PR body, or include a manual image/screenshot placeholder.
---

# PR Summary

## Workflow

1. Inspect the available change context before writing:
   - Prefer `git status --short`, `git diff --stat`, and a focused `git diff`.
   - If the user provides change notes instead of a repo, use those notes.
   - Do not include unrelated dirty-worktree changes in the PR text.
2. Write the title as the shortest accurate summary of the main change.
   - If there are two important but unrelated changes, include both in the title while keeping it as short as possible.
   - If there are more than two unrelated changes, summarize the dominant theme and mention the rest in the description.
3. Write the description with brief bullet points only.
4. Always include the image section with the placeholder so the PR author can delete it manually when it is not needed.

## Output Format

Use this format by default:

```markdown
Title: <short imperative or noun-phrase title>

Description:
- <main user-facing or technical change>
- <secondary change, if useful>
- <test/validation note, if available>

Images:
<img src="REPLACE_WITH_IMAGE_URL" width="250" />
```

## Style Rules

- Keep the title under 60 characters when possible.
- For two unrelated changes, prefer compact joined titles such as `Fix tests and add PR skill`.
- Prefer concrete verbs: `Add`, `Fix`, `Update`, `Rename`, `Refactor`, `Remove`.
- Keep the body short enough to scan in a few seconds.
- Use 2-4 bullets for most PRs.
- Avoid long background, implementation details, and marketing language.
- Mention tests only if they were actually run or clearly changed.
- If validation was not run, either omit the test bullet or use `Not run`.
- Always include the `Images` section.
- Always include the placeholder exactly with width `250`.

## Image Placeholder

When screenshots need to be added manually, use:

```html
<img src="REPLACE_WITH_IMAGE_URL" width="250" />
```

For multiple images, repeat the tag on separate lines and use meaningful placeholder names:

```html
<img src="REPLACE_WITH_HOME_IMAGE_URL" width="250" />
<img src="REPLACE_WITH_DETAILS_IMAGE_URL" width="250" />
```
