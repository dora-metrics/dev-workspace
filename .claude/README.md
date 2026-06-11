# Dev Workspace Skills

This directory contains shared AI agent skills for the Pelorus development workspace.

## Structure

```
.claude/          # Claude Code skills directory
.agents -> .claude  # Symlink for future multi-agent portability
```

## Agent Skills Open Standard

Skills in this directory follow the [Agent Skills open standard](https://agentskills.io/) defined in `SKILL.md` format. This makes them portable across multiple AI coding assistants including:

- **Claude Code** (Anthropic)
- **Cursor** 
- **GitHub Copilot**
- **Gemini CLI** (Google)
- **Codex CLI** (OpenAI)
- And 30+ other agents

## Usage in This Workspace

All repositories in the Pelorus dev spaces workspace ([pelorus](../pelorus/), [pelorus-api](../pelorus-api/), [pelorus-ui](../pelorus-ui/)) automatically load these shared skills via the `additionalDirectories` setting in their `.claude/settings.json`:

```json
{
  "permissions": {
    "additionalDirectories": ["/projects/dev-workspace"]
  }
}
```

This allows workspace-level skills to be defined once and used across all repositories without duplication or symlinks.

## Directory Naming: `.claude` vs `.agents`

**Current state:** Skills are stored in `.claude/skills/` with a symlink `.agents -> .claude`

**Why:** Claude Code currently requires the `.claude/` directory name ([GitHub Issue #31005](https://github.com/anthropics/claude-code/issues/31005)). The symlink expresses intent for future multi-agent portability when other tools are added to the workspace.

**Future:** If Claude Code adopts the `.agents/` convention from the open standard, we can reverse the symlink direction without changing skill content.

## Adding Skills

To add a new workspace-level skill:

1. Create a directory in `.claude/skills/` with your skill name:
   ```bash
   mkdir -p .claude/skills/my-skill
   ```

2. Create a `SKILL.md` file following the [Agent Skills specification](https://agentskills.io/specification):
   ```markdown
   ---
   name: my-skill
   description: What this skill does and when to use it
   ---
   
   Your skill instructions here...
   ```

3. The skill will be available immediately in all workspace repositories (no restart needed)

## Available Skills

- **handoff**: Compact the current conversation into a handoff document for another agent to pick up

## References

- [Agent Skills Open Standard](https://agentskills.io/)
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Multi-Repo Workspace Patterns](https://karun.me/blog/2026/03/26/structuring-claude-code-for-multi-repo-workspaces/)
