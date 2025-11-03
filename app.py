from flask import Flask, jsonify, request
import json
import os

app = Flask(__name__)
DATA_FILE = 'todos.json'

def load_todos():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    return []

def save_todos(todos):
    with open(DATA_FILE, 'w') as f:
        json.dump(todos, f)

@app.route('/todos', methods=['GET'])
def list_todos():
    return jsonify(load_todos())

@app.route('/todos', methods=['POST'])
def add_todo():
    todos = load_todos()
    new_todo = {
        'id': max([t['id'] for t in todos], default=0) + 1,
        'text': request.json['text']
    }
    todos.append(new_todo)
    save_todos(todos)
    return jsonify(new_todo), 201

@app.route('/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    todos = load_todos()
    todos = [todo for todo in todos if todo['id'] != todo_id]
    save_todos(todos)
    return '', 204

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)