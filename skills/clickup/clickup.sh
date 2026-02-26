#!/usr/bin/env bash
# ClickUp API v2 Helper Script
# Usage: source this file or run individual functions
# Requires: CLICKUP_TOKEN environment variable

set -euo pipefail

CLICKUP_BASE="https://api.clickup.com/api/v2"

_cu() {
  local method="$1" endpoint="$2"
  shift 2
  curl -s -X "$method" \
    -H "Authorization: $CLICKUP_TOKEN" \
    -H "Content-Type: application/json" \
    "${CLICKUP_BASE}${endpoint}" "$@"
}

# --- Discovery ---

cu_user() {
  _cu GET /user | python3 -m json.tool
}

cu_teams() {
  _cu GET /team | python3 -c "
import sys, json
for t in json.load(sys.stdin)['teams']:
    print(f\"{t['id']}\t{t['name']}\")"
}

cu_spaces() {
  local team_id="$1"
  _cu GET "/team/${team_id}/space" | python3 -c "
import sys, json
for s in json.load(sys.stdin)['spaces']:
    print(f\"{s['id']}\t{s['name']}\")"
}

cu_folders() {
  local space_id="$1"
  _cu GET "/space/${space_id}/folder" | python3 -c "
import sys, json
for f in json.load(sys.stdin)['folders']:
    print(f\"{f['id']}\t{f['name']}\")"
}

cu_lists() {
  local parent_id="$1"
  local parent_type="${2:-space}"  # "space" or "folder"
  _cu GET "/${parent_type}/${parent_id}/list" | python3 -c "
import sys, json
for l in json.load(sys.stdin)['lists']:
    print(f\"{l['id']}\t{l['name']}\")"
}

# --- Tasks ---

cu_tasks() {
  local list_id="$1"
  local page="${2:-0}"
  _cu GET "/list/${list_id}/task?page=${page}" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for t in data['tasks']:
    status = t['status']['status']
    priority = t.get('priority', {})
    p = priority.get('priority', 'none') if priority else 'none'
    print(f\"{t['id']}\t[{status}]\t(P:{p})\t{t['name']}\")"
}

cu_task() {
  local task_id="$1"
  _cu GET "/task/${task_id}" | python3 -m json.tool
}

cu_create_task() {
  local list_id="$1" name="$2"
  local description="${3:-}"
  local priority="${4:-3}"
  _cu POST "/list/${list_id}/task" \
    -d "{\"name\": \"${name}\", \"description\": \"${description}\", \"priority\": ${priority}}"
}

cu_update_task() {
  local task_id="$1"
  shift
  _cu PUT "/task/${task_id}" -d "$1"
}

cu_delete_task() {
  local task_id="$1"
  _cu DELETE "/task/${task_id}"
}

# --- Comments ---

cu_comments() {
  local task_id="$1"
  _cu GET "/task/${task_id}/comment" | python3 -c "
import sys, json
for c in json.load(sys.stdin)['comments']:
    user = c.get('user', {}).get('username', 'unknown')
    text = c.get('comment_text', '')[:100]
    print(f\"{c['id']}\t{user}\t{text}\")"
}

cu_add_comment() {
  local task_id="$1" text="$2"
  _cu POST "/task/${task_id}/comment" \
    -d "{\"comment_text\": \"${text}\", \"notify_all\": false}"
}

# --- Time Tracking ---

cu_time_entries() {
  local team_id="$1" start="$2" end="$3"
  _cu GET "/team/${team_id}/time_entries?start_date=${start}&end_date=${end}" | python3 -c "
import sys, json
data = json.load(sys.stdin).get('data', [])
for e in data:
    dur_min = int(e.get('duration', 0)) // 60000
    task = e.get('task', {}).get('name', 'no task') if e.get('task') else 'no task'
    print(f\"{e['id']}\t{dur_min}m\t{task}\t{e.get('description', '')}\")"
}

cu_start_timer() {
  local team_id="$1" task_id="$2"
  _cu POST "/team/${team_id}/time_entries/start" \
    -d "{\"tid\": \"${task_id}\"}"
}

cu_stop_timer() {
  local team_id="$1"
  _cu POST "/team/${team_id}/time_entries/stop"
}

# --- Tags ---

cu_tags() {
  local space_id="$1"
  _cu GET "/space/${space_id}/tag" | python3 -c "
import sys, json
for t in json.load(sys.stdin).get('tags', []):
    print(f\"{t['name']}\")"
}

cu_add_tag() {
  local task_id="$1" tag_name="$2"
  _cu POST "/task/${task_id}/tag/${tag_name}"
}

# --- Utility ---

cu_ms() {
  # Convert date string to milliseconds: cu_ms "2025-01-15"
  python3 -c "
import datetime, sys
dt = datetime.datetime.strptime('$1', '%Y-%m-%d')
print(int(dt.timestamp() * 1000))"
}

echo "ClickUp helper loaded. Functions: cu_user, cu_teams, cu_spaces, cu_folders, cu_lists, cu_tasks, cu_task, cu_create_task, cu_update_task, cu_delete_task, cu_comments, cu_add_comment, cu_time_entries, cu_start_timer, cu_stop_timer, cu_tags, cu_add_tag, cu_ms"
