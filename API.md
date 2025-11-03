# TODOD API Documentation

## Base URL
`http://<ec2-private-ip>`

## Endpoints

### GET /todos
List all todos

**Response:**
```json
[
  {"id": 1, "text": "Buy milk"},
  {"id": 2, "text": "Walk dog"}
]
```

### POST /todos
Add new todo

**Request:**
```json
{"text": "Task description"}
```

**Response:**
```json
{"id": 3, "text": "Task description"}
```

### DELETE /todos/{id}
Delete todo by ID

**Response:** 204 No Content

## Examples

```bash
# List todos
curl http://172.16.1.10/todos

# Add todo
curl -X POST -H "Content-Type: application/json" \
  -d '{"text":"Buy groceries"}' \
  http://172.16.1.10/todos

# Delete todo
curl -X DELETE http://172.16.1.10/todos/1
```