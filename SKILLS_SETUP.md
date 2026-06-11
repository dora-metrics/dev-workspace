# Workspace-Wide Skills Setup

This document describes the multi-repository skill sharing configuration for the Pelorus OpenShift Dev Spaces workspace.

## Overview

Skills defined in the `dev-workspace` repository are automatically available across all repositories in the workspace ([pelorus](../pelorus/), [pelorus-api](../pelorus-api/), [pelorus-ui](../pelorus-ui/)) without symlinks or duplication.

## Implementation

### 1. Skills Storage
Skills are stored in `/projects/dev-workspace/.claude/skills/` following the [Agent Skills open standard](https://agentskills.io/).

### 2. Multi-Agent Portability Intent
A symlink `.agents -> .claude` expresses future intent for multi-agent portability:
```bash
/projects/dev-workspace/.agents -> /projects/dev-workspace/.claude
```

**Current limitation:** Claude Code requires `.claude/` directory naming ([Issue #31005](https://github.com/anthropics/claude-code/issues/31005)), so we use `.claude/` as the primary directory with a symlink to `.agents/` for future compatibility.

### 3. Workspace-Wide Access
Each repository includes a `.claude/settings.json` that references the dev-workspace directory:

**pelorus/.claude/settings.json**
```json
{
  "permissions": {
    "additionalDirectories": ["/projects/dev-workspace"]
  }
}
```

**pelorus-api/.claude/settings.json**
```json
{
  "permissions": {
    "additionalDirectories": ["/projects/dev-workspace"]
  }
}
```

**pelorus-ui/.claude/settings.json**
```json
{
  "permissions": {
    "additionalDirectories": ["/projects/dev-workspace"]
  }
}
```

## How It Works

1. When Claude Code starts in any repository (e.g., `cd /projects/pelorus && claude`), it:
   - Loads the repository's `.claude/settings.json`
   - Processes the `additionalDirectories` array
   - Discovers and loads skills from `/projects/dev-workspace/.claude/skills/`

2. Skills are loaded **progressively**:
   - Metadata (name, description) loads at startup
   - Full instructions load only when the skill is invoked
   - Live reload: edits take effect immediately without restart

3. Skills can be invoked via:
   - Direct invocation: `/skill-name`
   - Auto-discovery: Claude loads relevant skills based on description matching

## Benefits

✅ **No symlinks** between repositories  
✅ **No duplication** of skill definitions  
✅ **Version controlled** in dev-workspace repository  
✅ **Live reload** - edits take effect immediately  
✅ **Standards compliant** - follows Agent Skills open standard  
✅ **Future portable** - ready for multi-agent support via `.agents` symlink

## Available Skills

- **handoff**: Compact the current conversation into a handoff document for another agent to pick up

## Adding New Skills

To add a workspace-level skill:

```bash
cd /projects/dev-workspace

# Create skill directory
mkdir -p .claude/skills/my-skill

# Create SKILL.md following the spec
cat > .claude/skills/my-skill/SKILL.md <<'EOF'
---
name: my-skill
description: What this skill does and when to use it
---

Your skill instructions here...
EOF
```

The new skill will be immediately available in all workspace repositories.

## Alternative Approaches Considered

### Option 2: Parent Directory Discovery
Place skills in `/projects/.claude/skills/` to leverage Claude Code's parent directory walking.

**Rejected because:**
- `/projects` is not a git repository
- Skills wouldn't be version controlled
- Pollutes the parent directory

### Option 3: Git Submodules
Make dev-workspace a submodule in each repository.

**Rejected because:**
- Unnecessary complexity in Dev Spaces where all repos are already co-located
- Submodule management overhead
- All repos already cloned at `/projects/` in the workspace

### Option 4: NPM Package Distribution
Package skills and distribute via npm.

**Rejected because:**
- Overkill for 4 repositories in a single workspace
- Build/publish complexity
- Better suited for 50+ repos across teams

## References

- [Agent Skills Open Standard](https://agentskills.io/)
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Multi-Repo Workspace Patterns](https://karun.me/blog/2026/03/26/structuring-claude-code-for-multi-repo-workspaces/)
- [Claude Code --add-dir Guide](https://claudelog.com/faqs/--add-dir/)
- [GitHub Issue: Support for .agents directory](https://github.com/anthropics/claude-code/issues/31005)

## Testing

To verify the setup works:

```bash
# From any repository
cd /projects/pelorus  # or pelorus-api, or pelorus-ui

# Start Claude Code
claude

# Verify workspace skills are loaded
# The handoff skill should be available via /handoff
```
