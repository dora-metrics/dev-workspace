---
name: handoff
description: Generate a comprehensive session summary document for context transfer to a new agent session
---

# Handoff Skill

Generate a comprehensive markdown document that captures the current session state, allowing a new agent to pick up where you left off.

## When to Use

Use this skill when:
- You need to switch to a new agent session but want to preserve context
- You're approaching context window limits and need to flush and restart
- You want to document the current state of work for later resumption
- You need to handoff work to another developer or agent session

## Output

Generate a structured markdown document named `handoff-{timestamp}.md` in the current working directory containing:

### 1. Session Overview
- Date and time of handoff
- Primary working directory
- Current git branch and status
- Brief summary of what was accomplished in this session

### 2. Current State
- **Active Tasks**: List any in-progress work, TODOs, or incomplete tasks
- **Recent Changes**: Summary of files modified, created, or deleted
- **Git Status**: Detailed git status including staged/unstaged changes
- **Open Questions**: Any unresolved questions or blockers

### 3. Context & Background
- **Original Request**: What the user originally asked for
- **Approach Taken**: High-level strategy and key decisions made
- **Key Findings**: Important discoveries during exploration
- **Dependencies**: Critical files, functions, or systems involved

### 4. Next Steps
- **Immediate Actions**: What should happen next (priority order)
- **Pending Decisions**: Choices that need user input
- **Testing Required**: What needs verification
- **Known Risks**: Potential issues to watch for

### 5. Technical Details
- **Modified Files**: List with line numbers and brief change descriptions
- **Key Code Locations**: Important functions, classes, or sections
- **Command History**: Relevant bash commands executed
- **Environment Details**: Important env vars, ports, or configuration

### 6. Reference Information
- **Related PRs/Issues**: Links to relevant external resources
- **Documentation**: Links to relevant docs read or referenced
- **Code Patterns**: Important patterns or conventions observed

## Instructions

1. **Gather Current State**:
   - Run `git status` to see all changes
   - Run `git diff` to capture modifications
   - Run `git log -5 --oneline` for recent commits
   - List any running processes or servers

2. **Review Conversation History**:
   - Identify the original user request
   - Summarize key decisions and changes made
   - Note any feedback or course corrections
   - Capture unresolved questions

3. **Create Structured Document**:
   - Use clear headings and sections
   - Include file paths as clickable links: `[filename.ts](path/to/filename.ts)`
   - Include line references: `[filename.ts:42](path/to/filename.ts#L42)`
   - Keep summaries concise but complete
   - Use bullet points for readability

4. **Save Document**:
   - Filename format: `handoff-YYYY-MM-DD-HHMM.md`
   - Save in the primary working directory
   - Confirm the file was created successfully

5. **Provide Summary**:
   - Tell the user where the handoff document was saved
   - Give a one-line summary of session status
   - Mention any critical next steps

## Example Output Structure

```markdown
# Session Handoff - 2026-06-05 14:30

## Session Overview
**Date**: June 5, 2026, 2:30 PM  
**Working Directory**: `/projects/pelorus`  
**Branch**: `feature/oauth-integration`  
**Status**: Implementation 75% complete, testing in progress

## Current State

### Active Tasks
- [ ] Complete OAuth integration with Grafana
- [ ] Update documentation for new auth flow
- [x] Implement token refresh mechanism

### Recent Changes
- Modified: [oauth.py](exporters/oauth.py) - Added token refresh logic
- Created: [test_oauth.py](tests/test_oauth.py) - Unit tests for OAuth flow
- Modified: [README.md](README.md#L45-L67) - Updated configuration docs

...
```

## Tips

- **Be thorough but concise**: Capture everything needed but avoid unnecessary detail
- **Make it actionable**: Focus on what the next agent needs to know to continue
- **Include context**: Don't assume the next agent knows the history
- **Link liberally**: Use markdown links for all file and code references
- **Timestamp everything**: Use absolute dates, not relative ("yesterday")
- **Surface blockers**: Clearly call out anything that's stuck or needs decisions

## Anti-patterns to Avoid

- Don't just dump git diffs without context
- Don't assume knowledge of earlier conversation
- Don't leave out the "why" behind decisions
- Don't forget to note what's already been tried and ruled out
- Don't skip environment or configuration details
