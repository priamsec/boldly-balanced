# Affiliate CTA Design Pattern

## Template

```html
<div style="background: transparent; padding: 2rem; margin: 2rem 0; text-align: center; border: 2px dashed #ccc; border-radius: 12px;">
    <h3 style="margin-top: 0;">[TITLE]</h3>
    <p>[Subtitle]</p>
    <ul style="text-align: left; max-width: 400px; margin: 1rem auto; list-style: none; padding: 0;">
        <li style="margin: 0.75rem 0;"><strong>EMOJI Title</strong> – <a href="https://www.amazon.nl/PRODUCT?crid=XXX&tag=vitalwell0b-21" target="_blank" rel="nofollow">Shop on Amazon</a></li>
        <li style="margin: 0.75rem 0;"><strong>EMOJI Title</strong> – <a href="https://www.amazon.nl/PRODUCT?crid=XXX&tag=vitalwell0b-21" target="_blank" rel="nofollow">Shop on Amazon</a></li>
        <li style="margin: 0.75rem 0;"><strong>EMOJI Title</strong> – <a href="https://www.amazon.nl/PRODUCT?crid=XXX&tag=vitalwell0b-21" target="_blank" rel="nofollow">Shop on Amazon</a></li>
    </ul>
</div>
```

## Design Rules

- **No white background** — use `background: transparent`
- **Subtle border** — `border: 2px dashed #ccc`
- **No location text** — use "Shop on Amazon" not "Amazon NL"
- **Always include tag** — `?tag=vitalwell0b-21` at end of Amazon links
- **Clean list** — `list-style: none; padding: 0`
- **Vertical spacing** — `margin: 0.75rem 0` for each item

## Example Products (tested)

- Bullet Journal: https://www.amazon.nl/Lonely-Oak-Dotted-Bullet-Journal/dp/B0D78VNFNJ?crid=VJ3CD8ZP8IBW&tag=vitalwell0b-21
- Habit Tracker: https://www.amazon.nl/Happy-Habit-Mood-Tracker-Tracking/dp/B0CPWNXPPP?crid=29ZWQ89R6KSHN&tag=vitalwell0b-21
- Atomic Habits: https://www.amazon.nl/-/en/Atomic-Habits-Challenges-Remarkable-Results/dp/1847941834?crid=3A792OKX6L8KE&tag=vitalwell0b-21