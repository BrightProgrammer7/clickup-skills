# ClickUp API v2 — Full Endpoint Reference

Base URL: `https://api.clickup.com`

All requests require header: `Authorization: {token}`
POST/PUT requests also require: `Content-Type: application/json`

---

## Authorization

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/user` | Get authenticated user |
| POST | `/api/v2/oauth/token` | Get access token (OAuth flow) |

**OAuth body:** `{ "client_id", "client_secret", "code" }`

---

## Teams (Workspaces)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/team` | Get authorized workspaces |

---

## Spaces

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/team/{team_id}/space` | Get spaces in workspace |
| GET | `/api/v2/space/{space_id}` | Get single space |
| POST | `/api/v2/team/{team_id}/space` | Create space |
| PUT | `/api/v2/space/{space_id}` | Update space |
| DELETE | `/api/v2/space/{space_id}` | Delete space |

**Create/Update body:** `{ "name": "Space Name", "multiple_assignees": true, "features": {} }`

---

## Folders

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/space/{space_id}/folder` | Get folders in space |
| GET | `/api/v2/folder/{folder_id}` | Get single folder |
| POST | `/api/v2/space/{space_id}/folder` | Create folder |
| PUT | `/api/v2/folder/{folder_id}` | Update folder |
| DELETE | `/api/v2/folder/{folder_id}` | Delete folder |

**Create/Update body:** `{ "name": "Folder Name" }`

---

## Lists

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/folder/{folder_id}/list` | Get lists in folder |
| GET | `/api/v2/space/{space_id}/list` | Get folderless lists in space |
| GET | `/api/v2/list/{list_id}` | Get single list |
| POST | `/api/v2/folder/{folder_id}/list` | Create list in folder |
| POST | `/api/v2/space/{space_id}/list` | Create folderless list |
| PUT | `/api/v2/list/{list_id}` | Update list |
| DELETE | `/api/v2/list/{list_id}` | Delete list |

**Create body:** `{ "name": "List Name", "content": "Description", "status": "red" }`

---

## Tasks

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/list/{list_id}/task` | Get tasks in list (paginated, max 100) |
| GET | `/api/v2/task/{task_id}` | Get single task |
| POST | `/api/v2/list/{list_id}/task` | Create task |
| PUT | `/api/v2/task/{task_id}` | Update task |
| DELETE | `/api/v2/task/{task_id}` | Delete task |

### Get Tasks Query Parameters

| Param | Type | Description |
|-------|------|-------------|
| `page` | int | Page number (0-indexed) |
| `order_by` | string | `id`, `created`, `updated`, `due_date` |
| `reverse` | bool | Reverse sort order |
| `subtasks` | bool | Include subtasks |
| `statuses[]` | string | Filter by status (repeat for multiple) |
| `include_closed` | bool | Include closed tasks |
| `assignees[]` | int | Filter by assignee ID |
| `tags[]` | string | Filter by tag |
| `due_date_gt` | int | Due date greater than (ms) |
| `due_date_lt` | int | Due date less than (ms) |
| `date_created_gt` | int | Created after (ms) |
| `date_created_lt` | int | Created before (ms) |
| `date_updated_gt` | int | Updated after (ms) |
| `date_updated_lt` | int | Updated before (ms) |
| `custom_fields` | json | Filter by custom field values |

### Create Task Body

```json
{
  "name": "Task Name",
  "description": "Markdown description",
  "assignees": [183],
  "tags": ["tag1"],
  "status": "Open",
  "priority": 3,
  "due_date": 1714521600000,
  "due_date_time": true,
  "time_estimate": 3600000,
  "start_date": 1714000000000,
  "start_date_time": true,
  "notify_all": false,
  "parent": null,
  "links_to": null,
  "custom_fields": [
    { "id": "field_uuid", "value": "field value" }
  ]
}
```

**Notes:**
- Only `name` is required
- Set `parent` to a task ID to create a subtask
- Priority: 1=Urgent, 2=High, 3=Normal, 4=Low
- All timestamps in milliseconds

### Update Task Body

Same fields as create. Only include fields you want to change.

**Cannot update custom fields via PUT task** — use the Custom Fields endpoint instead.

---

## Comments

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/task/{task_id}/comment` | Get task comments |
| POST | `/api/v2/task/{task_id}/comment` | Create task comment |
| GET | `/api/v2/list/{list_id}/comment` | Get list comments |
| POST | `/api/v2/list/{list_id}/comment` | Create list comment |
| POST | `/api/v2/view/{view_id}/comment` | Create chat view comment |
| PUT | `/api/v2/comment/{comment_id}` | Update comment |
| DELETE | `/api/v2/comment/{comment_id}` | Delete comment |

**Create comment body:**
```json
{
  "comment_text": "Plain text comment",
  "notify_all": false,
  "assignee": 183
}
```

---

## Custom Fields

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/list/{list_id}/field` | Get accessible custom fields |
| POST | `/api/v2/task/{task_id}/field/{field_id}` | Set custom field value |
| DELETE | `/api/v2/task/{task_id}/field/{field_id}` | Remove custom field value |

**Set value body:** `{ "value": "the value" }`

Value format depends on field type (text, number, dropdown, date, etc.).

---

## Members

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/task/{task_id}/member` | Get task members |
| GET | `/api/v2/list/{list_id}/member` | Get list members |

---

## Tags

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/space/{space_id}/tag` | Get space tags |
| POST | `/api/v2/space/{space_id}/tag` | Create tag |
| PUT | `/api/v2/space/{space_id}/tag/{tag_name}` | Update tag |
| DELETE | `/api/v2/space/{space_id}/tag/{tag_name}` | Delete tag |
| POST | `/api/v2/task/{task_id}/tag/{tag_name}` | Add tag to task |
| DELETE | `/api/v2/task/{task_id}/tag/{tag_name}` | Remove tag from task |

---

## Time Tracking 2.0

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/team/{team_id}/time_entries` | Get time entries |
| POST | `/api/v2/team/{team_id}/time_entries` | Create time entry |
| GET | `/api/v2/team/{team_id}/time_entries/{timer_id}` | Get single entry |
| PUT | `/api/v2/team/{team_id}/time_entries/{timer_id}` | Update entry |
| DELETE | `/api/v2/team/{team_id}/time_entries/{timer_id}` | Delete entry |
| GET | `/api/v2/team/{team_id}/time_entries/current` | Get running timer |
| POST | `/api/v2/team/{team_id}/time_entries/start` | Start timer |
| POST | `/api/v2/team/{team_id}/time_entries/stop` | Stop timer |

### Get Time Entries Params

| Param | Type | Description |
|-------|------|-------------|
| `start_date` | int | Start of range (ms) |
| `end_date` | int | End of range (ms) |
| `assignee` | int | Filter by user ID |
| `include_task_tags` | bool | Include task tags |
| `include_location_names` | bool | Include space/folder/list names |

### Create Time Entry Body

```json
{
  "tid": "task_id",
  "description": "What was worked on",
  "start": 1700000000000,
  "duration": 3600000,
  "assignee": 183,
  "billable": true,
  "tags": [{ "name": "dev" }]
}
```

---

## Goals

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/team/{team_id}/goal` | Get goals |
| GET | `/api/v2/goal/{goal_id}` | Get single goal |
| POST | `/api/v2/team/{team_id}/goal` | Create goal |
| PUT | `/api/v2/goal/{goal_id}` | Update goal |
| DELETE | `/api/v2/goal/{goal_id}` | Delete goal |
| POST | `/api/v2/goal/{goal_id}/key_result` | Create key result |
| PUT | `/api/v2/key_result/{key_result_id}` | Update key result |
| DELETE | `/api/v2/key_result/{key_result_id}` | Delete key result |

---

## Views

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/team/{team_id}/view` | Get workspace views |
| GET | `/api/v2/space/{space_id}/view` | Get space views |
| GET | `/api/v2/folder/{folder_id}/view` | Get folder views |
| GET | `/api/v2/list/{list_id}/view` | Get list views |
| GET | `/api/v2/view/{view_id}` | Get single view |
| GET | `/api/v2/view/{view_id}/task` | Get tasks from view |
| POST | `/api/v2/team/{team_id}/view` | Create workspace view |
| PUT | `/api/v2/view/{view_id}` | Update view |
| DELETE | `/api/v2/view/{view_id}` | Delete view |

---

## Webhooks

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/team/{team_id}/webhook` | Get webhooks |
| POST | `/api/v2/team/{team_id}/webhook` | Create webhook |
| PUT | `/api/v2/webhook/{webhook_id}` | Update webhook |
| DELETE | `/api/v2/webhook/{webhook_id}` | Delete webhook |

### Create Webhook Body

```json
{
  "endpoint": "https://your-server.com/webhook",
  "events": ["taskCreated", "taskUpdated", "taskDeleted"],
  "space_id": "space_id",
  "folder_id": "folder_id",
  "list_id": "list_id",
  "task_id": "task_id"
}
```

Only one location level per webhook (most specific wins).

### Available Events

`taskCreated`, `taskUpdated`, `taskDeleted`, `taskPriorityUpdated`, `taskStatusUpdated`, `taskAssigneeUpdated`, `taskDueDateUpdated`, `taskTagUpdated`, `taskMoved`, `taskCommentPosted`, `taskCommentUpdated`, `taskTimeEstimateUpdated`, `taskTimeTrackedUpdated`, `listCreated`, `listUpdated`, `listDeleted`, `folderCreated`, `folderUpdated`, `folderDeleted`, `spaceCreated`, `spaceUpdated`, `spaceDeleted`, `goalCreated`, `goalUpdated`, `goalDeleted`, `keyResultCreated`, `keyResultUpdated`, `keyResultDeleted`

---

## Checklists

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v2/task/{task_id}/checklist` | Create checklist |
| PUT | `/api/v2/checklist/{checklist_id}` | Update checklist |
| DELETE | `/api/v2/checklist/{checklist_id}` | Delete checklist |
| POST | `/api/v2/checklist/{checklist_id}/checklist_item` | Create item |
| PUT | `/api/v2/checklist/{checklist_id}/checklist_item/{item_id}` | Update item |
| DELETE | `/api/v2/checklist/{checklist_id}/checklist_item/{item_id}` | Delete item |

---

## Task Dependencies

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v2/task/{task_id}/dependency` | Add dependency |
| DELETE | `/api/v2/task/{task_id}/dependency` | Remove dependency |
| POST | `/api/v2/task/{task_id}/link/{links_to}` | Add task link |
| DELETE | `/api/v2/task/{task_id}/link/{links_to}` | Remove task link |

---

## Attachments

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v2/task/{task_id}/attachment` | Upload attachment |

**Note:** Use `multipart/form-data`. One file per request.

---

## Guests

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v2/team/{team_id}/guest` | Invite guest |
| GET | `/api/v2/team/{team_id}/guest/{guest_id}` | Get guest |
| PUT | `/api/v2/team/{team_id}/guest/{guest_id}` | Edit guest |
| DELETE | `/api/v2/team/{team_id}/guest/{guest_id}` | Remove guest |
| POST | `/api/v2/task/{task_id}/guest/{guest_id}` | Add guest to task |
| DELETE | `/api/v2/task/{task_id}/guest/{guest_id}` | Remove guest from task |
| POST | `/api/v2/list/{list_id}/guest/{guest_id}` | Add guest to list |
| DELETE | `/api/v2/list/{list_id}/guest/{guest_id}` | Remove guest from list |
| POST | `/api/v2/folder/{folder_id}/guest/{guest_id}` | Add guest to folder |
| DELETE | `/api/v2/folder/{folder_id}/guest/{guest_id}` | Remove guest from folder |

---

## Shared Hierarchy

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v2/team/{team_id}/shared` | Get shared hierarchy |

---

## Rate Limits

- **100 requests/minute** per token (all plans)
- HTTP 429 when exceeded
- Headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- Implement exponential backoff on 429 responses
