---
name: clickup
description: Use when managing ClickUp tasks, lists, spaces, time tracking, comments, or any project management operation via the ClickUp REST API. Triggers on "clickup", "task", "project management", "time entry", "workspace"
license: Apache-2.0
---

# ClickUp API Skill (No MCP)

## Overview

Interact with ClickUp workspaces using direct REST API calls (`curl`). No MCP server required — just a personal API token stored in `CLICKUP_TOKEN`.

## Setup

### 1. Get Your API Token

Go to **ClickUp > Settings > Apps > API Token** and generate a personal token.

### 2. Store Token

```bash
export CLICKUP_TOKEN="pk_YOUR_TOKEN_HERE"
```

Store in `.env` or export before running commands.

### 3. Verify Connection

```bash
curl -s -H "Authorization: $CLICKUP_TOKEN" \
  https://api.clickup.com/api/v2/user | python3 -m json.tool
```

## ClickUp Hierarchy

```
Workspace (Team) → Space → Folder (optional) → List → Task → Subtask
```

**Key terminology:** In API v2, "Team" = Workspace, "Project" = Folder.

## Quick Reference

| Action | Method | Endpoint |
|---|---|---|
| Get user | GET | `/api/v2/user` |
| Get workspaces | GET | `/api/v2/team` |
| Get spaces | GET | `/api/v2/team/{team_id}/space` |
| Get folders | GET | `/api/v2/space/{space_id}/folder` |
| Get lists (folder) | GET | `/api/v2/folder/{folder_id}/list` |
| Get lists (folderless) | GET | `/api/v2/space/{space_id}/list` |
| Get tasks | GET | `/api/v2/list/{list_id}/task` |
| Get single task | GET | `/api/v2/task/{task_id}` |
| Create task | POST | `/api/v2/list/{list_id}/task` |
| Update task | PUT | `/api/v2/task/{task_id}` |
| Delete task | DELETE | `/api/v2/task/{task_id}` |
| Get comments | GET | `/api/v2/task/{task_id}/comment` |
| Add comment | POST | `/api/v2/task/{task_id}/comment` |
| Get custom fields | GET | `/api/v2/list/{list_id}/field` |
| Set custom field | POST | `/api/v2/task/{task_id}/field/{field_id}` |
| Get time entries | GET | `/api/v2/team/{team_id}/time_entries` |
| Create time entry | POST | `/api/v2/team/{team_id}/time_entries` |
| Start timer | POST | `/api/v2/team/{team_id}/time_entries/start` |
| Stop timer | POST | `/api/v2/team/{team_id}/time_entries/stop` |
| Get members (task) | GET | `/api/v2/task/{task_id}/member` |
| Get members (list) | GET | `/api/v2/list/{list_id}/member` |
| Get tags | GET | `/api/v2/space/{space_id}/tag` |
| Get goals | GET | `/api/v2/team/{team_id}/goal` |
| Create webhook | POST | `/api/v2/team/{team_id}/webhook` |

**Base URL:** `https://api.clickup.com`

## Common Workflows

### Discovery: Find Your Workspace → Space → List IDs

```bash
# Step 1: Get workspace (team) ID
curl -s -H "Authorization: $CLICKUP_TOKEN" \
  https://api.clickup.com/api/v2/team | python3 -c "
import sys, json
teams = json.load(sys.stdin)['teams']
for t in teams:
    print(f\"{t['id']}: {t['name']}\")"

# Step 2: Get spaces in workspace
curl -s -H "Authorization: $CLICKUP_TOKEN" \
  "https://api.clickup.com/api/v2/team/{TEAM_ID}/space" | python3 -c "
import sys, json
spaces = json.load(sys.stdin)['spaces']
for s in spaces:
    print(f\"{s['id']}: {s['name']}\")"

# Step 3: Get lists (folderless)
curl -s -H "Authorization: $CLICKUP_TOKEN" \
  "https://api.clickup.com/api/v2/space/{SPACE_ID}/list" | python3 -c "
import sys, json
lists = json.load(sys.stdin)['lists']
for l in lists:
    print(f\"{l['id']}: {l['name']}\")"
```

### Create a Task

```bash
curl -s -X POST \
  -H "Authorization: $CLICKUP_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.clickup.com/api/v2/list/{LIST_ID}/task" \
  -d '{
    "name": "My New Task",
    "description": "Task description here",
    "status": "Open",
    "priority": 3,
    "assignees": [],
    "tags": [],
    "due_date": null,
    "notify_all": false
  }'
```

**Priority values:** 1 = Urgent, 2 = High, 3 = Normal, 4 = Low

### Create a Subtask

Same as creating a task, but add `"parent": "{parent_task_id}"` to the JSON body.

### Update a Task

```bash
curl -s -X PUT \
  -H "Authorization: $CLICKUP_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.clickup.com/api/v2/task/{TASK_ID}" \
  -d '{
    "name": "Updated Name",
    "status": "in progress",
    "priority": 2
  }'
```

### Get Tasks with Pagination

```bash
PAGE=0
while true; do
  RESULT=$(curl -s -H "Authorization: $CLICKUP_TOKEN" \
    "https://api.clickup.com/api/v2/list/{LIST_ID}/task?page=$PAGE")
  COUNT=$(echo "$RESULT" | python3 -c "import sys,json; print(len(json.load(sys.stdin)['tasks']))")
  echo "$RESULT" | python3 -c "
import sys, json
for t in json.load(sys.stdin)['tasks']:
    print(f\"{t['id']}: [{t['status']['status']}] {t['name']}\")"
  [ "$COUNT" -lt 100 ] && break
  PAGE=$((PAGE + 1))
done
```

### Add a Comment

```bash
curl -s -X POST \
  -H "Authorization: $CLICKUP_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.clickup.com/api/v2/task/{TASK_ID}/comment" \
  -d '{
    "comment_text": "This is a comment from the API",
    "notify_all": false
  }'
```

### Track Time

```bash
# Get time entries (date range in milliseconds)
curl -s -H "Authorization: $CLICKUP_TOKEN" \
  "https://api.clickup.com/api/v2/team/{TEAM_ID}/time_entries?start_date=1700000000000&end_date=1710000000000"

# Create a time entry (duration in milliseconds)
curl -s -X POST \
  -H "Authorization: $CLICKUP_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.clickup.com/api/v2/team/{TEAM_ID}/time_entries" \
  -d '{
    "tid": "{TASK_ID}",
    "description": "Working on feature",
    "start": 1700000000000,
    "duration": 3600000
  }'
```

## Rate Limits

- **100 requests/minute** per token (all plans)
- HTTP **429** returned when exceeded
- Check response headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- Use webhooks instead of polling where possible

## Pagination

- Use `page` query param (0-indexed) with max **100** results per page
- Loop until returned items < 100 (indicates last page)
- Applies to: tasks, time entries, comments, and other list endpoints

## Common Mistakes

| Mistake | Fix |
|---|---|
| Using "workspace" in URL | Use `team` — API v2 calls workspaces "teams" |
| Updating custom fields via PUT task | Use dedicated `POST /task/{id}/field/{field_id}` endpoint |
| Forgetting Content-Type header on POST/PUT | Always include `Content-Type: application/json` |
| Timestamps in seconds | ClickUp uses **milliseconds** (Unix epoch × 1000) |
| Not paginating task lists | Max 100 per page — always implement pagination loop |
| Polling instead of webhooks | Subscribe to webhook events for real-time updates |

## Webhook Events

Subscribe to events: `taskCreated`, `taskUpdated`, `taskDeleted`, `listCreated`, `listUpdated`, `listDeleted`, `folderCreated`, `folderUpdated`, `folderDeleted`, `spaceCreated`, `spaceUpdated`, `spaceDeleted`, `goalCreated`, `goalUpdated`, `goalDeleted`.

See `clickup-api-reference.md` for the full endpoint reference.
