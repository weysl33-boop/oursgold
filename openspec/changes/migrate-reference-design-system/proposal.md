# Proposal: Migrate Reference Design System

## Change ID
`migrate-reference-design-system`

## Type
Enhancement

## Status
Draft

## Summary
Migrate the visual design system from the Next.js reference project (`project-recreation (1)`) to the existing Flutter mobile application. This change extracts the proven design patterns, color palette, typography system, and component styling from the reference implementation and adapts them to Flutter's widget system, creating visual consistency between the web and mobile experiences.

## Problem Statement

The Flutter application currently has a functional design system with design tokens, but lacks the refined visual polish and cohesive aesthetic demonstrated in the reference project:

1. **Design System Inconsistency**
   - Reference project uses OKLCH color space with sophisticated light/dark mode theming
   - Flutter app uses simple hex colors without the same level of tonal variation
   - Reference has a more refined radius system (sm/md/lg/xl variants)
   - Typography scales differ between web and mobile implementations

2. **Visual Refinement Gap**
   - Reference project demonstrates glassmorphic effects and backdrop blur
   - Card components in reference have more sophisticated elevation and border treatments
   - Reference uses a consistent spacing rhythm (0.75rem base with safe-area handling)
   - Flutter implementation lacks the same level of visual depth and layering

3. **Component Pattern Mismatch**
   - Reference `StockCard` has a different visual treatment than Flutter `MarketCard`
   - Bottom navigation styling differs significantly
   - Header/balance card patterns from reference not present in Flutter
   - Different approaches to showing price changes and trends

4. **Dark Mode Implementation**
   - Reference uses sophisticated dark mode with specific surface colors
   - Flutter dark mode is functional but less refined
   - Glassmorphic overlay effects in reference not implemented in Flutter
   - Border and outline treatments differ

5. **Animation and Interaction Patterns**
   - Reference uses tw-animate-css for consistent animations
   - Flutter has flutter_animate but patterns not aligned with reference
   - Safe area handling differs between platforms
   - Touch feedback patterns could be more consistent

## Proposed Solution

Extract and adapt the design system from the reference Next.js project to Flutter:

### 1. Color System Migration
- Translate OKLCH color values to Flutter Color objects
- Implement the complete color palette including variants (chart-1 through chart-5)
- Create dark mode color mappings matching reference implementation
- Preserve glassmorphism overlay colors and opacity values
- Document color semantic meanings from reference

### 2. Design Token Harmonization
- Align spacing scale with reference (0.75rem = 12px base)
- Adopt radius system from reference (sm/md/lg/xl variants)
- Extract and implement elevation/shadow values
- Match typography scale to reference (Inter font family)
- Standardize icon sizes across platforms

### 3. Component Style Migration
- Redesign `MarketCard` to match reference `StockCard` visual treatment
- Update bottom navigation to match reference styling
- Implement header/balance card pattern from reference home view
- Align watchlist item styling with reference
- Create glassmorphic card variants for dark mode

### 4. Layout Pattern Adoption
- Extract safe-area handling patterns from reference
- Implement rounded header backgrounds (rounded-b-3xl pattern)
- Adopt grid and flex patterns from reference components
- Align spacing between sections with reference
- Match container max-width constraints (max-w-md pattern)

### 5. Animation System Alignment
- Map tw-animate-css patterns to flutter_animate equivalents
- Standardize animation durations and easing curves
- Implement consistent micro-interactions
- Add backdrop blur effects where appropriate
- Preserve performance characteristics

## Goals

1. **Visual Consistency**: Achieve visual parity between reference web design and Flutter mobile app
2. **Design System Completeness**: Port the complete design system including colors, typography, spacing, and components
3. **Platform Appropriateness**: Adapt web patterns to mobile idioms while preserving visual identity
4. **Maintainability**: Create clear mappings between reference and Flutter implementations for future updates
5. **Backward Compatibility**: Minimize breaking changes to existing Flutter codebase

## Non-Goals

1. Implementing web-specific features not applicable to mobile (hover states beyond tap feedback)
2. Porting the entire component library (only essential components)
3. Replacing Riverpod state management or routing
4. Adding new features or functionality (pure visual migration)
5. Creating a web version of the app (mobile-only focus)

## Scope

### In Scope
- Color palette translation (OKLCH → Flutter Color)
- Typography system migration (Inter font, scale matching)
- Design tokens alignment (spacing, radius, elevation)
- Core component styling migration:
  - MarketCard/StockCard
  - Bottom navigation
  - Header/balance card
  - Watchlist items
- Dark mode refinements matching reference
- Animation pattern alignment
- Safe area handling improvements

### Out of Scope
- Portfolio/exchange/profile views (not in Phase 1 mobile scope)
- Complex UI components (charts, forms, dialogs beyond existing scope)
- Backend integration or API changes
- New feature implementation
- Web platform support

## Dependencies

### Internal
- Existing `polish-ui-design` proposal (coordination required)
- Current Flutter theme system (`app_theme.dart`, `colors.dart`, `typography.dart`)
- Existing widget implementations (`market_card.dart`, `bottom_nav_shell.dart`)
- Riverpod state management (no changes)

### External
- **Google Fonts** (^6.1.0) - Inter font family matching reference
- **flutter_animate** (^4.5.0) - Already in use, patterns to be aligned
- **backdrop_filter** (built-in) - For glassmorphism effects
- No additional dependencies required (leverage existing tools)

### Reference Assets
- `project-recreation (1)/app/globals.css` - Color system and design tokens
- `project-recreation (1)/components/*.tsx` - Component patterns
- Reference screenshots for visual comparison

## Risks & Mitigations

### Risk 1: OKLCH Color Conversion Accuracy
**Severity**: Medium
**Mitigation**:
- Use precise OKLCH → sRGB conversion formulas
- Visual comparison testing between web and mobile
- Document any unavoidable color differences
- Test on multiple device screens

### Risk 2: Conflict with polish-ui-design Proposal
**Severity**: High
**Mitigation**:
- Coordinate implementation order (this proposal should inform polish-ui-design)
- Share design token definitions between proposals
- Consider merging or sequencing proposals
- Clear communication about which proposal owns which components

### Risk 3: Platform-Specific Patterns
**Severity**: Medium
**Mitigation**:
- Adapt web patterns to mobile idioms (e.g., hover → tap)
- Respect Flutter Material Design guidelines
- Test on both iOS and Android
- Get design approval for adaptations

### Risk 4: Font Rendering Differences
**Severity**: Low
**Mitigation**:
- Use Google Fonts package for consistent Inter rendering
- Test on various screen densities
- Adjust line heights and letter spacing as needed for mobile
- Document any rendering differences

### Risk 5: Performance Impact of Glassmorphism
**Severity**: Medium
**Mitigation**:
- Use BackdropFilter sparingly
- Test on low-end devices
- Provide option to disable effects on older devices
- Monitor frame rates during animations

## Success Criteria

1. **Visual Parity**
   - Side-by-side comparison shows consistent visual language
   - Color palette matches reference within perceptual tolerance
   - Typography scale produces similar visual hierarchy
   - Component styling achieves same aesthetic quality

2. **Design System Completeness**
   - All design tokens documented and implemented
   - Color system includes all variants from reference
   - Typography system fully ported
   - Spacing and radius systems aligned

3. **Code Quality**
   - Design tokens centralized in theme configuration
   - Clear comments mapping Flutter → Reference patterns
   - No code duplication between this and polish-ui-design
   - Widget tests pass for updated components

4. **Performance**
   - No frame drops from glassmorphism effects
   - Smooth animations (60fps maintained)
   - App size increase < 1MB (Inter font already planned)
   - No accessibility regressions

5. **Documentation**
   - Design system mapping document created
   - Screenshots comparing reference vs Flutter
   - Migration guide for future component updates
   - Known differences documented with rationale

## Alternatives Considered

### Alternative 1: Full Visual Redesign (Not Using Reference)
**Pros**: Complete freedom to optimize for mobile
**Cons**: Loses proven design system from reference, more work
**Decision**: Rejected - reference provides high-quality starting point

### Alternative 2: Merge with polish-ui-design Proposal
**Pros**: Single coordinated effort, no duplication
**Cons**: Large scope, harder to review, mixing concerns
**Decision**: Rejected - keep focused on reference extraction

### Alternative 3: Defer Until After polish-ui-design
**Pros**: Avoids conflicts, cleaner sequence
**Cons**: polish-ui-design might make incompatible choices
**Decision**: Rejected - this should inform polish-ui-design

### Alternative 4: Parallel Implementation with Coordination (Selected)
**Pros**: Leverages reference immediately, informs polish-ui-design
**Cons**: Requires coordination between proposals
**Decision**: **Selected** - best balance with clear coordination plan

## Implementation Strategy

### Phase 1: Design System Extraction (Week 1)
- Extract all CSS custom properties from `globals.css`
- Convert OKLCH colors to Flutter Color objects
- Map typography scale (Inter font family)
- Document spacing, radius, and elevation values
- Create reference comparison document

### Phase 2: Core Theme Migration (Week 1-2)
- Update `colors.dart` with reference color palette
- Update `typography.dart` with Inter font and reference scale
- Update `design_tokens.dart` with reference spacing/radius
- Create glassmorphism utilities (backdrop blur, overlays)
- Update `app_theme.dart` light/dark themes

### Phase 3: Component Migration (Week 2-3)
- Redesign MarketCard matching StockCard from reference
- Update BottomNavShell matching reference bottom-nav
- Implement header/balance card pattern for home page
- Update watchlist item styling
- Add safe area handling patterns

### Phase 4: Polish and Refinement (Week 3-4)
- Fine-tune colors and spacing
- Implement glassmorphic effects in dark mode
- Align animation patterns
- Test across devices and screen sizes
- Performance optimization

### Phase 5: Documentation and Handoff (Week 4)
- Create migration guide document
- Screenshot comparisons (reference vs Flutter)
- Update component documentation
- Coordinate with polish-ui-design proposal
- Final testing and bug fixes

## Timeline

**Estimated Duration**: 3-4 weeks (part-time development)

- Week 1: Design system extraction and core theme migration
- Week 2-3: Component migration and implementation
- Week 3-4: Polish, refinement, and documentation
- Coordination with `polish-ui-design`: Ongoing

## Open Questions

1. **Coordination with polish-ui-design**: Should this proposal be implemented first to inform polish-ui-design, or should they be merged?
2. **Inter Font Licensing**: Confirm Inter font usage rights for commercial mobile app (already open source, but verify)
3. **Glassmorphism Scope**: Should all cards use glassmorphism in dark mode, or only specific components like reference?
4. **Component Prioritization**: Which components beyond MarketCard, BottomNav, and Header should be migrated in Phase 1?
5. **Color Accuracy**: What is acceptable delta-E threshold for OKLCH → sRGB conversion (suggest < 2.0)?
6. **Safe Area Strategy**: Should safe-area handling be component-specific or global utility?

## Related Changes

- `polish-ui-design` - Complementary proposal for overall UI polish (coordination required)
- `add-precious-metals-social-platform` - Original implementation baseline
- Future: Extend design system to community and profile features

## References

- Reference project: `D:\Playground\gold\project-recreation (1)`
- [OKLCH Color Picker](https://oklch.com) - For color conversion validation
- [Inter Font](https://rsms.me/inter/) - Typography reference
- [Material Design 3](https://m3.material.io) - Flutter design guidelines
- [Flutter BackdropFilter](https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html) - Glassmorphism implementation
