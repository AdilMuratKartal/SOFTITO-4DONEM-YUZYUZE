---
name: Mindful Emerald Rhythm
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#bbcabf'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#86948a'
  outline-variant: '#3c4a42'
  surface-tint: '#4edea3'
  primary: '#4edea3'
  on-primary: '#003824'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#006c49'
  secondary: '#ffb95f'
  on-secondary: '#472a00'
  secondary-container: '#ee9800'
  on-secondary-container: '#5b3800'
  tertiary: '#adc6ff'
  on-tertiary: '#002e6a'
  tertiary-container: '#71a1ff'
  on-tertiary-container: '#00367a'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#ffddb8'
  secondary-fixed-dim: '#ffb95f'
  on-secondary-fixed: '#2a1700'
  on-secondary-fixed-variant: '#653e00'
  tertiary-fixed: '#d8e2ff'
  tertiary-fixed-dim: '#adc6ff'
  on-tertiary-fixed: '#001a42'
  on-tertiary-fixed-variant: '#004395'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
  surface-light: '#FFFFFF'
  surface-dark: '#1E293B'
  border-light: '#E2E8F0'
  border-dark: '#334155'
  text-light: '#0F172A'
  text-dark: '#F8FAFC'
  text-secondary: '#94A3B8'
  danger: '#EF4444'
  mood-great: '#10B981'
  mood-good: '#34D399'
  mood-neutral: '#FBBF24'
  mood-bad: '#FB923C'
  mood-terrible: '#F87171'
typography:
  display-timer:
    fontFamily: Plus Jakarta Sans
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-section:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
    letterSpacing: -0.01em
  title-card:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
  body-default:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-subdued:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
  label-badge:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
  label-meta:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-caption:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-micro-active:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
  label-micro-default:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.25rem
---

## Brand & Style

This design system is engineered for mindful daily execution, zero-friction tracking, and positive psychological reinforcement. It balances utilitarian clarity with dynamic micro-interactions, turning routine logging into moments of quiet reward. The interface eliminates cognitive load through decisive hierarchy, high legibility, and high-contrast feedback states.

The aesthetic philosophy centers on modern, crisp minimalism fused with deliberate tactile response:
- **Zero-Friction Ergonomics:** Everything critical is within thumb reach, operating on single-tap gestures with immediate, gratifying visual validation.
- **Hairline Geometry:** In place of heavy drop shadows or skeumorphic depth, the interface relies on precision 1px hairline strokes, clean contrast layers, and intentional negative space.
- **Micro-Delight & Gamification:** Restrained, functional layouts come alive during completion states—featuring soft spring physics, category-specific tinting, streak fire indicators, and contextual mood expressions.

## Colors

The palette employs deep slate canvases (`#0F172A`, `#1E293B`) paired with a vivid emerald green primary accent (`#10B981`). The chromatic hierarchy reinforces action, continuity, and sentiment:

- **Primary (`#10B981`):** The engine of accomplishment. Used for completed micro-habit rings, confirmed checkboxes, and success affirmations.
- **Secondary (`#F59E0B`):** Dedicated to momentum, streaks, and focus urgency.
- **Tertiary / Info (`#3B82F6`):** Applied to scheduled reminders, temporal stamps, and recurring time tags.
- **Mood Quintet:** A spectrum of emotional tracking states calibrated with identical baseline saturation:
  - `mood-great` (`#10B981`)
  - `mood-good` (`#34D399`)
  - `mood-neutral` (`#FBBF24`)
  - `mood-bad` (`#FB923C`)
  - `mood-terrible` (`#F87171`)

### Opacity Rules
- **Active Mood Pill Background:** `18%` tint of the respective mood token.
- **Streak & Category Highlights:** `15%` tint of the parent category color or secondary gold.
- **Subdued Text / Inactive Borders:** `70%` alpha on `text-secondary`.

## Typography

Typography is set exclusively in **Plus Jakarta Sans**, chosen for its geometric precision, legible counter-forms at micro scales, and friendly contemporary aesthetic.

- **Completed State Transformation:** Completed habit titles trigger a switch to `text-secondary` accompanied by a strike-through (`textDecoration: lineThrough`), signaling resolved state without losing legibility.
- **Micro Scales:** The 11px and 12px tiers maintain tight numeric line heights and elevated weights (600/700) to ensure immediate scannability on high-DPI smartphone displays.
- **Display Timer:** Focus dial metrics leverage -0.02em tracking for dense, athletic clarity.

## Layout & Spacing

The layout is optimized for single-handed mobile navigation using a 4px base modular scale.

- **Outer Margins:** Fixed 16px (`1rem`) horizontal page margins with 12px (`0.75rem`) vertical gutters preserve edge breathing room.
- **Stacking Spacing:** Habit cards conform to a rhythmic 12px bottom separation (`space-md`). Internal card paddings sit at 14px for compact, thumb-friendly density.
- **Micro-Gaps:** 4px separates paired icons and text labels (e.g., flame icon to streak count, clock to time range). 8px handles inline tag-to-badge gaps.

## Elevation & Depth

This system avoids blurred drop shadows entirely, opting for crisp structural layers:

- **1px Hairline Borders:** Card containers, interactive mood selectors, and dialog sheets use 1px solid outlines (`border-light` / `border-dark`).
- **Interactive State Elevation:** Active or selected items receive border upgrades rather than shadows—thickening from 1px to 1.5px and shifting from neutral borders to saturated chromatic tokens (`mood.activeColor` or `primary`).
- **Surface Layering:** Dismissible swipes reveal a submerged, zero-elevation action canvas (`danger`) underneath cards. Modal sheets and bottom sheets present a 1px border perimeter against a solid surface overlay without diffuse ambient glows.

## Shapes

The geometry is defined by intentional, curved boundaries that harmonize with touch actions:

- **Cards & Primary Modules:** 16px radius (`1rem`) applied to habit cards, swipe surfaces, and mood track containers.
- **Nested Controls & Icon Boxes:** 12px radius (`0.75rem`) for category icon backdrops and individual sentiment buttons.
- **Interactive Badges:** 20px radius (`1.25rem`) to create smooth pill contours for streak counters and status tags.
- **Complete Buttons:** Perfectly circular 38px touch targets for habit checkmark toggles.

## Components

### Micro-Habit Card
- **Structure:** 14px internal padding, 16px corner radius, 1px perimeter border (`border-dark` in dark mode, `border-light` in light mode).
- **Leading Element:** 38x38px category icon container with 12px radius and 15% category tint fill.
- **Center Body:** Habit title (`title-card`), stacked above an inline row with category name, reminder bell, and time badge.
- **Trailing Action:** 38x38px circular toggle. Incomplete: 2px border outline with transparent center. Complete: solid emerald green (`primary`) fill with a centered white check icon.
- **Micro-Interaction:** Single-tap triggers haptic feedback, a subtle scale pulse (1.0 -> 1.05 -> 1.0 via spring physics, 200ms), and a strike-through on the label.

### Mood Selector Strip
- **Container:** Rounded 16px border-wrapped frame containing 5 equal touch segments representing: Harika, İyi, Normal, Kötü, Berbat.
- **Mood Items:** 12px radius inner buttons with vertical stack: 22px emoji over 11px micro-label.
- **Selection State:** On tap, transitions over 200ms into an 18% tint background of the respective mood token, accented with a 1.5px solid border in that exact hue.

### Streak Counter Badge
- **Container:** Full pill shape (20px radius), 10px horizontal padding, 4px vertical padding.
- **Palette:** 15% secondary amber tint fill (`#F59E0B26`), 0px border.
- **Content:** 16px flame icon paired with 12px bold typography (`#F59E0B`).

### Swipe Action Canvas
- **Destructive Swipe:** Swipe-to-dismiss gesture from right to left (`endToStart`), exposing a full-bleed `danger` (`#EF4444`) underlay rounded to 16px, terminating with a 26px white trash icon 20px from the leading edge.

### Focus / Pomodoro Dial
- **Display:** Centered numeric read-out using `display-timer` (`36px bold`), surrounded by a thin circular track with an emerald progress stroke indicator.