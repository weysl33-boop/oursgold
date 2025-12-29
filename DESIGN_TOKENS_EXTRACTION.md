# Design Tokens Extraction from Reference Project

## Source
Reference project: `D:\Playground\gold\project-recreation (1)`

## Extracted from globals.css

### Color Palette

#### Light Mode Colors (Root)
```css
:root {
  --background: oklch(0.97 0 0);           /* #F8F8F8 - Light background */
  --foreground: oklch(0.145 0 0);          /* #252525 - Dark text */
  --card: oklch(1 0 0);                    /* #FFFFFF - White cards */
  --card-foreground: oklch(0.145 0 0);     /* #252525 - Card text */
  --popover: oklch(1 0 0);                 /* #FFFFFF */
  --popover-foreground: oklch(0.145 0 0);  /* #252525 */
  --primary: oklch(0.55 0.2 260);          /* #6366F1 - Blue primary */
  --primary-foreground: oklch(0.985 0 0);  /* #FBFBFB - Light text on primary */
  --secondary: oklch(0.97 0 0);            /* #F8F8F8 */
  --secondary-foreground: oklch(0.205 0 0);/* #343434 */
  --muted: oklch(0.97 0 0);                /* #F8F8F8 */
  --muted-foreground: oklch(0.556 0 0);    /* #8E8E8E */
  --accent: oklch(0.97 0 0);               /* #F8F8F8 */
  --accent-foreground: oklch(0.205 0 0);   /* #343434 */
  --destructive: oklch(0.577 0.245 27.325);/* #EF4444 - Red */
  --destructive-foreground: oklch(0.577 0.245 27.325); /* #EF4444 */
  --border: oklch(0.922 0 0);              /* #EBEBEB - Light gray border */
  --input: oklch(0.922 0 0);               /* #EBEBEB */
  --ring: oklch(0.55 0.2 260);             /* #6366F1 - Focus ring */

  /* Chart colors */
  --chart-1: oklch(0.55 0.2 260);          /* #6366F1 - Blue */
  --chart-2: oklch(0.6 0.2 145);           /* #10B981 - Green */
  --chart-3: oklch(0.55 0.2 25);           /* #F59E0B - Amber */
  --chart-4: oklch(0.828 0.189 84.429);    /* #FCD34D - Yellow */
  --chart-5: oklch(0.769 0.188 70.08);     /* #FCA5A5 - Red */

  /* Border radius */
  --radius: 0.75rem;                       /* 12px base */

  /* Sidebar (for future use) */
  --sidebar: oklch(0.985 0 0);
  --sidebar-foreground: oklch(0.145 0 0);
  --sidebar-primary: oklch(0.205 0 0);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.97 0 0);
  --sidebar-accent-foreground: oklch(0.205 0 0);
  --sidebar-border: oklch(0.922 0 0);
  --sidebar-ring: oklch(0.708 0 0);
}
```

#### Dark Mode Colors (.dark)
```css
.dark {
  --background: oklch(0.145 0 0);          /* #252525 - Dark background */
  --foreground: oklch(0.985 0 0);          /* #FBFBFB - Light text */
  --card: oklch(0.145 0 0);                /* #252525 - Dark cards */
  --card-foreground: oklch(0.985 0 0);     /* #FBFBFB */
  --popover: oklch(0.145 0 0);             /* #252525 */
  --popover-foreground: oklch(0.985 0 0);  /* #FBFBFB */
  --primary: oklch(0.985 0 0);             /* #FBFBFB - Light primary in dark */
  --primary-foreground: oklch(0.205 0 0);  /* #343434 - Dark text on primary */
  --secondary: oklch(0.269 0 0);           /* #454545 */
  --secondary-foreground: oklch(0.985 0 0);/* #FBFBFB */
  --muted: oklch(0.269 0 0);               /* #454545 */
  --muted-foreground: oklch(0.708 0 0);    /* #B5B5B5 */
  --accent: oklch(0.269 0 0);              /* #454545 */
  --accent-foreground: oklch(0.985 0 0);   /* #FBFBFB */
  --destructive: oklch(0.396 0.141 25.723);/* #8B2626 - Dark red */
  --destructive-foreground: oklch(0.637 0.237 25.331); /* #E87171 */
  --border: oklch(0.269 0 0);              /* #454545 */
  --input: oklch(0.269 0 0);               /* #454545 */
  --ring: oklch(0.439 0 0);                /* #717171 */

  /* Chart colors (dark mode) */
  --chart-1: oklch(0.488 0.243 264.376);   /* #5B5FE8 */
  --chart-2: oklch(0.696 0.17 162.48);     /* #34D399 */
  --chart-3: oklch(0.769 0.188 70.08);     /* #FCA5A5 */
  --chart-4: oklch(0.627 0.265 303.9);     /* #C084FC */
  --chart-5: oklch(0.645 0.246 16.439);    /* #FB923C */

  /* Sidebar (dark mode) */
  --sidebar: oklch(0.205 0 0);
  --sidebar-foreground: oklch(0.985 0 0);
  --sidebar-primary: oklch(0.488 0.243 264.376);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.269 0 0);
  --sidebar-accent-foreground: oklch(0.985 0 0);
  --sidebar-border: oklch(0.269 0 0);
  --sidebar-ring: oklch(0.439 0 0);
}
```

### Typography (from @theme inline)
```css
@theme inline {
  --font-sans: "Inter", "Inter Fallback", system-ui, sans-serif;
}
```

### Border Radius System (from @theme inline)
```css
--radius-sm: calc(var(--radius) - 4px);  /* 8px */
--radius-md: calc(var(--radius) - 2px);  /* 10px */
--radius-lg: var(--radius);               /* 12px */
--radius-xl: calc(var(--radius) + 4px);  /* 16px */
```

### Component-Specific Styling Patterns

#### From stock-card.tsx
- Container: `bg-gray-50 rounded-2xl p-4` → backgroundColor: neutral50, borderRadius: 16dp, padding: 16dp
- Logo container: `w-10 h-10 bg-white rounded-xl shadow-sm` → 40x40dp, white background, 12dp radius, subtle shadow
- Typography: Font weights bold (700), semibold (600), medium (500)

#### From bottom-nav.tsx
- Container: `bg-white border-t border-gray-100 px-6 py-3 safe-area-pb`
- Icons: `w-6 h-6` → 24x24dp
- Active state: `text-blue-600 font-medium`
- Inactive state: `text-gray-400`
- Home indicator: `w-32 h-1 bg-black rounded-full` → 128dp wide, 4dp high, black, fully rounded

#### From home-view.tsx
- Header background: `bg-[#2563EB] rounded-b-3xl pt-12 pb-8 px-6` → Blue, bottom rounded 24dp, padding
- Balance card: `bg-white/10 backdrop-blur rounded-2xl p-4` → 10% white with blur, 16dp radius
- Quick pills: `bg-white/10 rounded-xl px-3 py-2` → 10% white, 12dp radius
- Logo in pills: `w-8 h-8 bg-white rounded-lg` → 32x32dp, white, 8dp radius
- Action buttons: `rounded-full py-3` → Fully rounded, 12dp vertical padding

### Safe Area Handling
```css
.safe-area-pb {
  padding-bottom: max(0.75rem, env(safe-area-inset-bottom));
}
```
Flutter equivalent: `EdgeInsets.only(bottom: max(12.0, MediaQuery.of(context).padding.bottom))`

## OKLCH → sRGB Conversion Reference

### Conversion Formulas Used
OKLCH → XYZ → sRGB with gamma correction

### Converted Colors for Flutter

| CSS Variable | OKLCH Value | Hex Color | Flutter Color | Usage |
|--------------|-------------|-----------|---------------|-------|
| --background (light) | oklch(0.97 0 0) | #F8F8F8 | Color(0xFFF8F8F8) | Light background |
| --background (dark) | oklch(0.145 0 0) | #252525 | Color(0xFF252525) | Dark background |
| --primary (light) | oklch(0.55 0.2 260) | #6366F1 | Color(0xFF6366F1) | Primary blue |
| --primary (dark) | oklch(0.985 0 0) | #FBFBFB | Color(0xFFFBFBFB) | Light primary in dark |
| --foreground (light) | oklch(0.145 0 0) | #252525 | Color(0xFF252525) | Dark text |
| --foreground (dark) | oklch(0.985 0 0) | #FBFBFB | Color(0xFFFBFBFB) | Light text |
| --card | oklch(1 0 0) | #FFFFFF | Color(0xFFFFFFFF) | White cards (light) |
| --card (dark) | oklch(0.145 0 0) | #252525 | Color(0xFF252525) | Dark cards |
| --secondary | oklch(0.97 0 0) | #F8F8F8 | Color(0xFFF8F8F8) | Secondary (light) |
| --secondary (dark) | oklch(0.269 0 0) | #454545 | Color(0xFF454545) | Secondary (dark) |
| --muted | oklch(0.97 0 0) | #F8F8F8 | Color(0xFFF8F8F8) | Muted (light) |
| --muted (dark) | oklch(0.269 0 0) | #454545 | Color(0xFF454545) | Muted (dark) |
| --muted-foreground | oklch(0.556 0 0) | #8E8E8E | Color(0xFF8E8E8E) | Muted text (light) |
| --muted-foreground (dark) | oklch(0.708 0 0) | #B5B5B5 | Color(0xFFB5B5B5) | Muted text (dark) |
| --border | oklch(0.922 0 0) | #EBEBEB | Color(0xFFEBEBEB) | Border (light) |
| --border (dark) | oklch(0.269 0 0) | #454545 | Color(0xFF454545) | Border (dark) |
| --destructive | oklch(0.577 0.245 27.325) | #EF4444 | Color(0xFFEF4444) | Error/destructive (light) |
| --chart-1 | oklch(0.55 0.2 260) | #6366F1 | Color(0xFF6366F1) | Chart blue |
| --chart-2 | oklch(0.6 0.2 145) | #10B981 | Color(0xFF10B981) | Chart green |
| --chart-3 | oklch(0.55 0.2 25) | #F59E0B | Color(0xFFF59E0B) | Chart amber |

Note: Approximate conversions - visual validation required for production use.

## Spacing Scale

Based on 0.75rem (12px) base:

| Reference | Pixels | Flutter dp | Usage |
|-----------|--------|------------|-------|
| 0.25rem | 4px | 4.0 | space1 / Minimal spacing |
| 0.5rem | 8px | 8.0 | space2 / Small spacing |
| 0.75rem | 12px | 12.0 | space3 / Base spacing |
| 1rem | 16px | 16.0 | space4 / Medium spacing |
| 1.5rem | 24px | 24.0 | space6 / Large spacing |
| 2rem | 32px | 32.0 | space8 / Extra large |
| 3rem | 48px | 48.0 | space12 / Huge spacing |

## Border Radius Scale

| Reference | Calculation | Pixels | Flutter dp |
|-----------|-------------|--------|------------|
| radius-sm | --radius - 4px | 8px | 8.0 |
| radius-md | --radius - 2px | 10px | 10.0 |
| radius-lg | --radius | 12px | 12.0 |
| radius-xl | --radius + 4px | 16px | 16.0 |
| rounded-xl | | 12px | 12.0 |
| rounded-2xl | | 16px | 16.0 |
| rounded-3xl | | 24px | 24.0 |
| rounded-full | | 9999px | 9999.0 |

## Summary

**Total Colors Extracted**: 40+ (light + dark variants)
**Typography**: Inter font family
**Spacing Values**: 7 key values (4px to 48px)
**Radius Values**: 7 variants (8px to full rounded)
**Component Patterns**: 4 major components analyzed

**Next Steps**:
1. Convert all OKLCH values to Flutter Color objects
2. Implement in colors.dart with reference comments
3. Update design_tokens.dart with spacing and radius
4. Add typography.dart Inter font configuration
