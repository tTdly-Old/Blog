import json
import os

def handle_raw_json(path):
    with open(path, 'r') as f:
        data = json.load(f)

    discussion = data["discussion"]
    _body = data["discussion"]["body"]
    _discussion_meta = {
        "create_at": discussion["created_at"],
        "title": discussion["title"],
        "locked": discussion["locked"],
        "labels": discussion["labels"],
    }
    if discussion["updated_at"] is not None:
        _discussion_meta["updated_at"] = discussion["updated_at"]
    _action_meta = {
        "number": discussion["number"],
        "action": data["action"],
        "category": discussion["category"]["name"],
    }
    return _action_meta, _discussion_meta, _body

def create_front_matter(data):
    content = "--------"
    for k, v in data.items():
        if type(v) == bool:
            if v:
                v = "true"
            else:
                v = "false"
        if not k == "labels":
            content += f"\n{k}: {v}"
        else:
            content += f"\n{k}:"
            if len(v) == 0:
                content += "[]"
            else:
                for label in v:
                    content += f"\n  - {label['name']}"
    content += "\n--------"
    return content

def write_markdown(i_meta, i_body):
    base_path = os.path.join(os.getcwd())
    content_path = os.path.join(base_path, "content")
    target_path = os.path.join(content_path, i_meta["category"])
    os.makedirs(target_path, exist_ok=True)
    file_path = os.path.join(target_path, f"{i_meta['number']}.md")
    with open(file_path, "w") as f:
        f.write(i_body)
    return file_path.replace(base_path, "")


if __name__ == "__main__":
    print("Get metadata for this discussion")
    action_meta, discussion_meta, body =\
        handle_raw_json(os.environ.get("GITHUB_EVENT_PATH"))
    print(f"  - action_metadata: {action_meta}")
    print(f"  - discussion_metadata: {discussion_meta}")

    print("Create front matter for this discussion")
    front_matter = create_front_matter(discussion_meta)

    print("Write markdown for this discussion")
    result_path = write_markdown(action_meta, f"{front_matter} \n\n\n {body}")

    print(f"Success sync discussion #{action_meta['number']} to {result_path}")




