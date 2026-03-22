# Post Workflow

## Overview

| Action | Review | Deploy |
|--------|--------|--------|
| Create new post | ✅ Yes (content) | ✅ Direct |
| Modify existing | ✅ Yes | After approval |

---

## Creating New Posts

### 1. Choose Topic
- Check content calendar or Logan's research
- Pick category with highest content gap
- Generate counter-narrative angle

### 2. Write Article Content FIRST

**Content requirements:**
- 1,500-2,500 words
- Unique, well-researched body (not placeholder text)
- Counter-narrative headline
- Hook → development → payoff structure
- Bold for emphasis, short paragraphs
- "You" not "people" (direct address)

**Content placeholders in template:**
| Placeholder | Description |
|-------------|-------------|
| `CONTENT_GOES_HERE` | Replace with full article HTML |
| `TITLE` | Full article title |
| `META_DESCRIPTION` | SEO description (120-160 chars) |
| `TLDR_CONTENT` | Key takeaway (1-2 sentences) |
| `EXCERPT` | Short teaser paragraph |

### 3. Choose Image
- Use verified working Unsplash URL
- Test image loads before using

### 4. Create Post

```bash
cd /home/frn/.openclaw/workspace/projects/web-applications/boldlybalance
cp templates/post-template.html posts/{slug}.html
```

### 5. Replace All Placeholders

```bash
python3 << 'PYEOF'
# Replace TITLE, META_DESCRIPTION, CONTENT_GOES_HERE, etc.
PYEOF
```

**All placeholders:**
| Placeholder | Required |
|-------------|----------|
| `TITLE` | ✅ |
| `META_DESCRIPTION` | ✅ |
| `CATEGORY` | ✅ |
| `EXCERPT` | ✅ |
| `TLDR_CONTENT` | ✅ |
| `CONTENT_GOES_HERE` | ✅ (actual article) |
| `PHOTO_ID` / `OG_IMAGE_URL` | ✅ |
| `CANONICAL_URL` | ✅ |
| `DATE_PUBLISHED` | ✅ |
| `READING_TIME` | ✅ |
| `ARTICLE_IMAGE_ALT` | ✅ |
| `RELATED_*` | ✅ (3 articles) |
| `SHARE_*` | ✅ (6 platforms) |

### 6. Update All Indexes

Pipeline handles automatically:
| Index | Updated |
|-------|---------|
| `posts.json` | ✅ |
| `search-index.json` | ✅ |
| `sitemap.xml` | ✅ |
| `api/posts.json` | ✅ |
| `api/posts/{slug}.json` | ✅ |
| `feed.xml` | ✅ |

### 7. Deploy

Pipeline handles automatically.

### 8. Report

- **Title:** Post title
- **Category:** Category name
- **URL:** Live link
- **Word count:** Must be 1,500-2,500

---

## Modifying Existing Posts

1. **Propose** → Describe changes needed
2. **Wait** → For approval before proceeding
3. **Update** → Make changes
4. **Deploy** → After approval

---

## Valid Categories

```
Fitness, Food, Sleep, Travel, Mind, Wellness, Lifestyle, Technology
Recovery, Finance, Home Decor, Mindset, Case Study, Routine, Reviews
```

---

## SEO Checklist

- [ ] Title tag (50-60 chars)
- [ ] Meta description (120-160 chars)
- [ ] Canonical URL (`blog.boldlybalance.life`)
- [ ] OG image (1200x630, verified working)
- [ ] TL;DR section
- [ ] Share buttons (6 platforms)
- [ ] Related articles (3)
- [ ] Word count: 1,500-2,500

---

## Important Rules

1. **Write content BEFORE creating post** - No empty shells
2. **Test images** - Verify Unsplash URLs work
3. **Unique content** - Every post must have different body text
4. **No placeholder text** - `CONTENT_GOES_HERE` must be replaced with real article

---

## Template Location

```
/home/frn/.openclaw/workspace/projects/web-applications/boldlybalance/templates/post-template.html
```

## Pipeline Script

```
~/.openclaw/workspace/pipelines/create-post.sh
```

**Note:** Pipeline script is for INDEX UPDATES only. Content must be written separately.
