#!/bin/bash
# Boldly Balance - Index Update Pipeline
# Updates indexes after a new post HTML has been created
# Usage: AFTER creating post HTML, run this to update indexes

set -e

BLOG_DIR="/home/frn/.openclaw/workspace/projects/web-applications/boldlybalance"
cd "$BLOG_DIR"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <slug> [title] [category] [excerpt] [photo-id] [date]"
    echo ""
    echo "Example:"
    echo "  $0 new-article \"Article Title\" Wellness \"Short excerpt\" photo-abc123"
    echo ""
    echo "Note: Post HTML must exist at posts/{slug}.html before running"
    exit 1
fi

SLUG="$1"
TITLE="${2:-New Article}"
CATEGORY="${3:-Wellness}"
EXCERPT="${4:-Article excerpt}"
PHOTO_ID="${5:-photo-1507003211169-0a1dd7228f2d}"
DATE="${6:-$(date +%Y-%m-%d)}"
BASE_URL="https://blog.boldlybalance.life"

export SLUG TITLE CATEGORY EXCERPT PHOTO_ID DATE BASE_URL

echo "=== Boldly Balance Index Update ==="
echo "Slug: $SLUG"
echo ""

# Verify post exists
if [ ! -f "posts/${SLUG}.html" ]; then
    echo "ERROR: posts/${SLUG}.html not found!"
    echo "Create the post HTML first, then run this script."
    exit 1
fi

# Update indexes
echo "[1/5] Updating indexes..."

python3 - << 'PYEOF'
import os
import json
import re

SLUG = os.environ.get('SLUG', '')
TITLE = os.environ.get('TITLE', '')
CATEGORY = os.environ.get('CATEGORY', '')
EXCERPT = os.environ.get('EXCERPT', '')
PHOTO_ID = os.environ.get('PHOTO_ID', '')
DATE = os.environ.get('DATE', '')
BASE_URL = os.environ.get('BASE_URL', '')

# Load posts
with open('posts.json') as f:
    posts = json.load(f)

# Check if slug exists
exists = any(p['slug'] == SLUG for p in posts)

if exists:
    # Update existing
    for p in posts:
        if p['slug'] == SLUG:
            p['title'] = TITLE
            p['category'] = CATEGORY
            p['excerpt'] = EXCERPT
            p['image'] = PHOTO_ID
            p['date'] = DATE
            break
    print(f"Updated existing post: {SLUG}")
else:
    # Add new at top
    posts.insert(0, {
        'slug': SLUG,
        'title': TITLE,
        'category': CATEGORY,
        'image': PHOTO_ID,
        'excerpt': EXCERPT,
        'date': DATE
    })
    print(f"Added new post: {SLUG}")

with open('posts.json', 'w') as f:
    json.dump(posts, f, indent=2)

# Update search-index.json
with open('search-index.json') as f:
    search = json.load(f)

exists = any(s['url'] == f'posts/{SLUG}.html' for s in search)
if exists:
    for s in search:
        if s['url'] == f'posts/{SLUG}.html':
            s['title'] = TITLE
            s['tags'] = [CATEGORY.lower()]
            break
else:
    search.insert(0, {
        'title': TITLE,
        'url': f'posts/{SLUG}.html',
        'tags': [CATEGORY.lower()]
    })

with open('search-index.json', 'w') as f:
    json.dump(search, f, indent=2)

# Update sitemap.xml
with open('sitemap.xml') as f:
    sitemap = f.read()

new_url = f'<url><loc>{BASE_URL}/posts/{SLUG}.html</loc><lastmod>{DATE}</lastmod><changefreq>monthly</changefreq><priority>0.7</priority></url>'

if f'posts/{SLUG}.html' not in sitemap:
    sitemap = re.sub(
        r'(<url><loc>' + BASE_URL.replace('.', r'\.') + r'/</loc><changefreq>daily</changefreq><priority>1\.0</priority></url>)',
        r'\1\n' + new_url,
        sitemap
    )
    with open('sitemap.xml', 'w') as f:
        f.write(sitemap)

# Create API file
api_post = {
    'slug': SLUG,
    'title': TITLE,
    'category': CATEGORY,
    'excerpt': EXCERPT,
    'image': f'https://images.unsplash.com/{PHOTO_ID}',
    'url': f'{BASE_URL}/posts/{SLUG}.html',
    'apiUrl': f'{BASE_URL}/api/posts/{SLUG}.json',
    'date': DATE
}
with open(f'api/posts/{SLUG}.json', 'w') as f:
    json.dump(api_post, f, indent=2)

# Update api/posts.json
with open('api/posts.json') as f:
    api_posts = json.load(f)

if any(p['slug'] == SLUG for p in api_posts['posts']):
    for p in api_posts['posts']:
        if p['slug'] == SLUG:
            p.update(api_post)
            break
else:
    api_posts['posts'].insert(0, api_post)

with open('api/posts.json', 'w') as f:
    json.dump(api_posts, f, indent=2)

# Regenerate feed.xml
xml = '''<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>Boldly Balance</title>
<link>https://blog.boldlybalance.life</link>
<description>Your daily dose of lifestyle inspiration.</description>
'''
for post in posts[:50]:
    title = post['title'].replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
    excerpt = post['excerpt'].replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
    xml += f'''<item>
<title>{title}</title>
<link>https://blog.boldlybalance.life/posts/{post["slug"]}.html</link>
<description>{excerpt}</description>
<guid>https://blog.boldlybalance.life/posts/{post["slug"]}.html</guid>
<pubDate>{post.get("date", "2026-03-01")}</pubDate>
</item>
'''
xml += '</channel>\n</rss>'
with open('feed.xml', 'w') as f:
    f.write(xml)

print("Indexes updated")
PYEOF

echo "[2/5] Verifying files..."
ls -la "posts/${SLUG}.html" "api/posts/${SLUG}.json"

echo "[3/5] Git adding..."
git add -A

echo "[4/5] Git committing..."
git commit -m "Add/Update: ${CATEGORY} article - ${TITLE}"

echo "[5/5] Git pushing..."
git push origin main

echo ""
echo "=== Done ==="
echo "URL: ${BASE_URL}/posts/${SLUG}.html"
