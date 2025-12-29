# Spec: Design System Theming

## Capability
Provide a comprehensive design system for the Flutter mobile application that matches the visual design of the reference Next.js project, ensuring consistent colors, typography, spacing, and visual effects across light and dark modes.

## ADDED Requirements

### Requirement: Color Palette from Reference
The application SHALL implement the complete color palette from the reference project's `globals.css`, converting OKLCH color values to Flutter Color objects while maintaining visual fidelity and WCAG contrast ratios.

#### Scenario: Light Mode Primary Colors
**Given** the reference project defines primary colors in OKLCH format
**When** the Flutter app is in light mode
**Then** all primary colors (background, foreground, primary, secondary, muted, accent) SHALL match the reference visual appearance within delta-E < 2.0
**And** all color combinations SHALL maintain WCAG AA contrast ratios (4.5:1 for text, 3:1 for UI components)

#### Scenario: Dark Mode Color Conversion
**Given** the reference project has dark mode color definitions
**When** the user switches to dark mode
**Then** all colors SHALL convert from OKLCH to sRGB accurately
**And** glassmorphism overlay colors (glassOverlayStart, glassOverlayEnd, glassBorder) SHALL be defined
**And** surface and background colors SHALL create appropriate visual hierarchy

### Requirement: Typography System Alignment
The application SHALL use the Inter font family matching the reference project and implement a typography scale that produces similar visual hierarchy and readability on mobile devices.

#### Scenario: Inter Font Loading
**Given** the reference project uses Inter as the primary font
**When** the Flutter app renders text
**Then** the Inter font family SHALL be loaded via Google Fonts
**And** font weights (400, 500, 600, 700) SHALL be available
**And** fallback fonts SHALL be defined for loading states

#### Scenario: Typography Scale Matching
**Given** the reference project has defined font sizes in rem units
**When** Flutter components render text
**Then** font sizes SHALL match reference visual appearance (e.g., 2rem → ~32dp)
**And** line heights SHALL be adjusted for mobile readability
**And** letter spacing SHALL be preserved or adapted for mobile rendering

### Requirement: Design Tokens Harmonization
The application SHALL implement design tokens (spacing, border radius, elevation, opacity) that align with the reference project's design system while following Flutter conventions.

#### Scenario: Spacing Scale Alignment
**Given** the reference project uses 0.75rem (12px) as base spacing
**When** Flutter widgets use spacing values
**Then** the spacing scale SHALL map reference rem values to logical pixels (dp)
**And** spacing SHALL be consistent across all components
**And** spacing constants SHALL be defined in `design_tokens.dart`

#### Scenario: Border Radius System
**Given** the reference project defines radius variants (sm, md, lg, xl)
**When** Flutter widgets render with rounded corners
**Then** radius values SHALL match: radiusSm (8dp), radiusMd (12dp), radiusLg (16dp), radiusXl (20dp)
**And** all card and container components SHALL use these standardized values
**And** visual consistency SHALL be maintained across screens

#### Scenario: Opacity and Elevation
**Given** the reference project uses specific opacity values (10%, 15%, etc.)
**When** Flutter components apply transparency or shadows
**Then** opacity constants SHALL be defined matching reference usage
**And** elevation values SHALL create similar visual depth as reference shadows
**And** dark mode elevation SHALL differ appropriately from light mode

### Requirement: Glassmorphism Effects
The application SHALL implement glassmorphic visual effects for dark mode cards matching the reference project's backdrop blur and overlay patterns.

#### Scenario: Glassmorphic Card in Dark Mode
**Given** the app is in dark mode
**And** a card component supports glassmorphism
**When** the card is rendered
**Then** a BackdropFilter SHALL be applied with blur radius matching reference
**And** a gradient overlay SHALL be applied (glassOverlayStart → glassOverlayEnd)
**And** a subtle border SHALL use glassBorder color
**And** performance SHALL maintain 60fps on target devices

#### Scenario: Glassmorphism Fallback
**Given** the device is detected as low-end
**Or** glassmorphism is disabled for performance
**When** a glassmorphic card is rendered
**Then** a solid background color SHALL be used instead
**And** visual hierarchy SHALL be maintained through other means (shadows, borders)
**And** no visual artifacts or lag SHALL occur

### Requirement: Safe Area Handling
The application SHALL handle safe areas (notches, status bars, navigation bars) using patterns from the reference project's safe-area-inset handling.

#### Scenario: Bottom Navigation Safe Area
**Given** the device has a bottom safe area inset (e.g., iPhone home indicator)
**When** the bottom navigation is rendered
**Then** padding SHALL be applied as max(12dp, safe area inset)
**And** a home indicator bar SHALL be rendered if appropriate
**And** the navigation SHALL not overlap system UI elements

#### Scenario: Top Header Safe Area
**Given** the device has a top safe area inset (e.g., notch or status bar)
**When** the header is rendered
**Then** padding SHALL be applied to avoid overlap
**And** the header background SHALL extend into the safe area
**And** content SHALL start below the safe area

## MODIFIED Requirements

### Requirement: Theme System Structure
The existing theme system in `app_theme.dart` SHALL be extended to incorporate reference design colors while maintaining backward compatibility.

#### Scenario: Light Theme Extension
**Given** the existing lightTheme is defined
**When** the theme system is updated with reference colors
**Then** ColorScheme.primary SHALL use the reference primary color
**And** ColorScheme.secondary SHALL use the reference secondary color
**And** all color roles (surface, background, error, etc.) SHALL map to reference equivalents
**And** deprecated color constants SHALL remain for backward compatibility

#### Scenario: Dark Theme Extension
**Given** the existing darkTheme is defined
**When** the theme system is updated with reference colors
**Then** dark mode specific colors SHALL be applied (darkSurface, darkBackground, darkBorder)
**And** glassmorphism colors SHALL be available
**And** contrast ratios SHALL meet WCAG AA in dark mode
**And** visual hierarchy SHALL be clear despite lower overall contrast

## Success Criteria

1. **Visual Parity**: Side-by-side comparison shows Flutter app matches reference web design within acceptable tolerances (delta-E < 2.0 for colors)
2. **Accessibility**: All color combinations meet WCAG AA contrast requirements (4.5:1 text, 3:1 UI)
3. **Performance**: Glassmorphism effects maintain 60fps on target devices
4. **Consistency**: Design tokens are applied uniformly across all components
5. **Documentation**: All design token mappings from reference to Flutter are documented

## Related Capabilities
- `component-styling` - Uses this design system for component appearance
- Future: accessibility-enhancements - Builds on color contrast foundation
