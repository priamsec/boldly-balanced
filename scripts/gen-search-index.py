#!/usr/bin/env python3
# Regenerate search-index.json from posts.json
import json

with open('posts.json', 'r') as f:
    posts = json.load(f)

search_index = {"posts": []}
for p in posts:
    search_index["posts"].append({
        "title": p["title"],
        "url": f"posts/{p['slug']}.html",
        "tags": [p["category"].lower()]
    })

with open('search-index.json', 'w') as f:
    json.dump(search_index, f, indent=2)

print(f"Generated search-index.json with {len(search_index['posts'])} posts")
