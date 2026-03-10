#!/usr/bin/env python3
"""
Sync images from posts.json to HTML files
Run: python3 scripts/sync-images.py
"""
import json
import os
import re

def sync_images():
    with open('posts.json', 'r') as f:
        posts = json.load(f)
    
    image_map = {p['slug']: p['image'] for p in posts}
    updated_count = 0
    
    for slug, image_id in image_map.items():
        html_file = f'posts/{slug}.html'
        
        if not os.path.exists(html_file):
            continue
            
        with open(html_file, 'r') as f:
            content = f.read()
        
        # Replace all unsplash image URLs with the one from posts.json
        new_content = re.sub(
            r'https://images\.unsplash\.com/photo-[a-zA-Z0-9_-]+\?w=\d+',
            f'https://images.unsplash.com/{image_id}?w=1200&q=80',
            content
        )
        
        if new_content != content:
            with open(html_file, 'w') as f:
                f.write(new_content)
            print(f"✅ Updated {slug}.html")
            updated_count += 1
    
    print(f"\n📊 Total files updated: {updated_count}")
    return updated_count

if __name__ == '__main__':
    sync_images()
