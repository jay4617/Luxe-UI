import SwiftUI

// MARK: - Color Scheme

/// A comprehensive color palette for LuxeUI theming.
///
/// `LuxeColorScheme` defines all the semantic colors used throughout the UI.
/// Colors are organized by purpose: primary actions, backgrounds, text, and status indicators.
///
/// ## Overview
/// The color scheme provides consistent colors for:
/// - **Primary/Secondary/Accent**: Brand and action colors
/// - **Background/Surface**: Container and layering colors
/// - **Text**: Primary and secondary text colors
/// - **Status**: Success, warning, error, and info indicators
///
/// ## Example
/// ```swift
/// let scheme = LuxeColorScheme(
///     primary: .blue,
///     secondary: .purple,
///     accent: .cyan,
///     success: .green,
///     error: .red
/// )
/// ```
public struct LuxeColorScheme: Sendable {
    /// The primary brand color for main actions and highlights
    public var primary: Color
    /// The secondary brand color for supporting elements
    public var secondary: Color
    /// The accent color for emphasis and interactive elements
    public var accent: Color
    /// The main background color for the app
    public var background: Color
    /// The surface color for cards and elevated containers
    public var surface: Color
    /// The primary text color
    public var text: Color
    /// The secondary/muted text color
    public var textSecondary: Color
    /// The color for success states and positive actions
    public var success: Color
    /// The color for warnings and caution states
    public var warning: Color
    /// The color for errors and destructive actions
    public var error: Color
    /// The color for informational messages
    public var info: Color
    
    public init(
        primary: Color = .blue,
        secondary: Color = .purple,
        accent: Color = .cyan,
        background: Color = Color(red: 0.05, green: 0.05, blue: 0.1),
        surface: Color = Color(red: 0.1, green: 0.1, blue: 0.15),
        text: Color = .white,
        textSecondary: Color = .white.opacity(0.7),
        success: Color = .green,
        warning: Color = .orange,
        error: Color = .red,
        info: Color = .cyan
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.text = text
        self.textSecondary = textSecondary
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
    }
}

// MARK: - Typography

/// Typography settings for consistent text styling across the UI.
///
/// `LuxeTypography` defines font sizes, weights, and line heights using a scale system.
/// This ensures visual consistency and makes it easy to maintain a coherent type hierarchy.
///
/// ## Scale
/// - **XS/S**: Captions, labels, metadata
/// - **M**: Body text (default)
/// - **L**: Emphasized body, subheadings
/// - **XL/XXL**: Headings
/// - **Display**: Hero text, large titles
///
/// ## Example
/// ```swift
/// let typography = LuxeTypography(
///     fontSizeM: 16,
///     fontSizeL: 18,
///     fontSizeDisplay: 48
/// )
/// ```
public struct LuxeTypography: Sendable {
    /// Extra small font size for fine print. Default: 10
    public var fontSizeXS: CGFloat
    /// Small font size for captions. Default: 12
    public var fontSizeS: CGFloat
    /// Medium font size for body text. Default: 14
    public var fontSizeM: CGFloat
    /// Large font size for emphasized text. Default: 16
    public var fontSizeL: CGFloat
    /// Extra large font size for subheadings. Default: 20
    public var fontSizeXL: CGFloat
    /// Double extra large font size for headings. Default: 24
    public var fontSizeXXL: CGFloat
    /// Display font size for hero text. Default: 36
    public var fontSizeDisplay: CGFloat
    /// Light font weight
    public var fontWeightLight: Font.Weight
    /// Regular font weight
    public var fontWeightRegular: Font.Weight
    /// Medium font weight
    public var fontWeightMedium: Font.Weight
    /// Semibold font weight
    public var fontWeightSemibold: Font.Weight
    /// Bold font weight
    public var fontWeightBold: Font.Weight
    /// Tight line height multiplier. Default: 1.2
    public var lineHeightTight: CGFloat
    /// Normal line height multiplier. Default: 1.5
    public var lineHeightNormal: CGFloat
    /// Relaxed line height multiplier. Default: 1.8
    public var lineHeightRelaxed: CGFloat
    
    public init(
        fontSizeXS: CGFloat = 10,
        fontSizeS: CGFloat = 12,
        fontSizeM: CGFloat = 14,
        fontSizeL: CGFloat = 16,
        fontSizeXL: CGFloat = 20,
        fontSizeXXL: CGFloat = 24,
        fontSizeDisplay: CGFloat = 36,
        fontWeightLight: Font.Weight = .light,
        fontWeightRegular: Font.Weight = .regular,
        fontWeightMedium: Font.Weight = .medium,
        fontWeightSemibold: Font.Weight = .semibold,
        fontWeightBold: Font.Weight = .bold,
        lineHeightTight: CGFloat = 1.2,
        lineHeightNormal: CGFloat = 1.5,
        lineHeightRelaxed: CGFloat = 1.8
    ) {
        self.fontSizeXS = fontSizeXS
        self.fontSizeS = fontSizeS
        self.fontSizeM = fontSizeM
        self.fontSizeL = fontSizeL
        self.fontSizeXL = fontSizeXL
        self.fontSizeXXL = fontSizeXXL
        self.fontSizeDisplay = fontSizeDisplay
        self.fontWeightLight = fontWeightLight
        self.fontWeightRegular = fontWeightRegular
        self.fontWeightMedium = fontWeightMedium
        self.fontWeightSemibold = fontWeightSemibold
        self.fontWeightBold = fontWeightBold
        self.lineHeightTight = lineHeightTight
        self.lineHeightNormal = lineHeightNormal
        self.lineHeightRelaxed = lineHeightRelaxed
    }
}

// MARK: - Spacing

/// Consistent spacing values for padding, margins, and gaps.
///
/// `LuxeSpacing` provides a spacing scale that ensures visual rhythm and consistency
/// across your UI. Use these values for padding, margins, stack spacing, and gaps.
///
/// ## Scale (Default Values)
/// - **xxxs**: 2pt - Hairline spacing
/// - **xxs**: 4pt - Tight spacing
/// - **xs**: 8pt - Compact spacing
/// - **s**: 12pt - Small spacing
/// - **m**: 16pt - Medium spacing (common default)
/// - **l**: 24pt - Large spacing
/// - **xl**: 32pt - Extra large spacing
/// - **xxl**: 48pt - Section spacing
/// - **xxxl**: 64pt - Major section spacing
///
/// ## Example
/// ```swift
/// VStack(spacing: theme.spacing.m) {
///     Text("Title")
///     Text("Subtitle")
/// }
/// .padding(theme.spacing.l)
/// ```
public struct LuxeSpacing: Sendable {
    /// Hairline spacing: 2pt
    public var xxxs: CGFloat
    /// Tight spacing: 4pt
    public var xxs: CGFloat
    /// Compact spacing: 8pt
    public var xs: CGFloat
    /// Small spacing: 12pt
    public var s: CGFloat
    /// Medium spacing: 16pt
    public var m: CGFloat
    /// Large spacing: 24pt
    public var l: CGFloat
    /// Extra large spacing: 32pt
    public var xl: CGFloat
    /// Section spacing: 48pt
    public var xxl: CGFloat
    /// Major section spacing: 64pt
    public var xxxl: CGFloat
    
    public init(
        xxxs: CGFloat = 2,
        xxs: CGFloat = 4,
        xs: CGFloat = 8,
        s: CGFloat = 12,
        m: CGFloat = 16,
        l: CGFloat = 24,
        xl: CGFloat = 32,
        xxl: CGFloat = 48,
        xxxl: CGFloat = 64
    ) {
        self.xxxs = xxxs
        self.xxs = xxs
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
    }
}

// MARK: - Border Radius

/// Corner radius values for consistent rounded corners across the UI.
///
/// `LuxeBorderRadius` provides a scale of corner radius values from sharp (none)
/// to fully rounded (full/pill shape).
///
/// ## Scale
/// - **none**: 0pt - Sharp corners
/// - **xs**: 4pt - Subtle rounding
/// - **s**: 8pt - Small rounding
/// - **m**: 12pt - Medium rounding (common default)
/// - **l**: 16pt - Large rounding
/// - **xl**: 24pt - Extra large rounding
/// - **full**: 9999pt - Pill/capsule shape
///
/// ## Example
/// ```swift
/// RoundedRectangle(cornerRadius: theme.borderRadius.m)
/// ```
public struct LuxeBorderRadius: Sendable {
    /// Sharp corners: 0pt
    public var none: CGFloat
    /// Subtle rounding: 4pt
    public var xs: CGFloat
    /// Small rounding: 8pt
    public var s: CGFloat
    /// Medium rounding: 12pt
    public var m: CGFloat
    /// Large rounding: 16pt
    public var l: CGFloat
    /// Extra large rounding: 24pt
    public var xl: CGFloat
    /// Pill/capsule shape: 9999pt
    public var full: CGFloat
    
    public init(
        none: CGFloat = 0,
        xs: CGFloat = 4,
        s: CGFloat = 8,
        m: CGFloat = 12,
        l: CGFloat = 16,
        xl: CGFloat = 24,
        full: CGFloat = 9999
    ) {
        self.none = none
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.full = full
    }
}

// MARK: - Effects

/// Visual effect values for shadows, blurs, glows, and animation timing.
///
/// `LuxeEffects` provides consistent values for visual effects that add depth
/// and polish to your UI. Use these for drop shadows, blur effects, glows,
/// and animation durations.
///
/// ## Shadow Scale
/// - **Small**: 4pt - Subtle elevation
/// - **Medium**: 8pt - Standard cards
/// - **Large**: 16pt - Prominent elements
/// - **XL**: 32pt - Floating elements
///
/// ## Animation Timing
/// - **Fast**: 0.15s - Micro-interactions
/// - **Normal**: 0.3s - Standard transitions
/// - **Slow**: 0.5s - Emphasis animations
///
/// ## Example
/// ```swift
/// .shadow(radius: theme.effects.shadowMedium)
/// .animation(.easeOut(duration: theme.effects.animationNormal))
/// ```
public struct LuxeEffects: Sendable {
    /// Small shadow radius: 4pt
    public var shadowSmall: CGFloat
    /// Medium shadow radius: 8pt
    public var shadowMedium: CGFloat
    /// Large shadow radius: 16pt
    public var shadowLarge: CGFloat
    /// Extra large shadow radius: 32pt
    public var shadowXL: CGFloat
    /// Small blur radius: 8pt
    public var blurSmall: CGFloat
    /// Medium blur radius: 16pt
    public var blurMedium: CGFloat
    /// Large blur radius: 32pt
    public var blurLarge: CGFloat
    /// Small glow radius: 4pt
    public var glowSmall: CGFloat
    /// Medium glow radius: 8pt
    public var glowMedium: CGFloat
    /// Large glow radius: 16pt
    public var glowLarge: CGFloat
    /// Fast animation duration: 0.15s
    public var animationFast: Double
    /// Normal animation duration: 0.3s
    public var animationNormal: Double
    /// Slow animation duration: 0.5s
    public var animationSlow: Double
    
    public init(
        shadowSmall: CGFloat = 4,
        shadowMedium: CGFloat = 8,
        shadowLarge: CGFloat = 16,
        shadowXL: CGFloat = 32,
        blurSmall: CGFloat = 8,
        blurMedium: CGFloat = 16,
        blurLarge: CGFloat = 32,
        glowSmall: CGFloat = 4,
        glowMedium: CGFloat = 8,
        glowLarge: CGFloat = 16,
        animationFast: Double = 0.15,
        animationNormal: Double = 0.3,
        animationSlow: Double = 0.5
    ) {
        self.shadowSmall = shadowSmall
        self.shadowMedium = shadowMedium
        self.shadowLarge = shadowLarge
        self.shadowXL = shadowXL
        self.blurSmall = blurSmall
        self.blurMedium = blurMedium
        self.blurLarge = blurLarge
        self.glowSmall = glowSmall
        self.glowMedium = glowMedium
        self.glowLarge = glowLarge
        self.animationFast = animationFast
        self.animationNormal = animationNormal
        self.animationSlow = animationSlow
    }
}

// MARK: - Theme

/// The central theme configuration for LuxeUI components.
///
/// `Theme` is the main configuration object that controls the visual appearance of all
/// LuxeUI components. Apply a theme at your app's root level using `.luxeTheme()` and
/// all child components will automatically adopt its styling.
///
/// ## Overview
/// Theme provides:
/// - **Colors**: Primary, secondary, accent, background, surface, and text colors
/// - **Typography**: Font sizes and weights via `LuxeTypography`
/// - **Spacing**: Consistent spacing values via `LuxeSpacing`
/// - **Border Radius**: Corner rounding values via `LuxeBorderRadius`
/// - **Effects**: Shadows, blurs, and animation timing via `LuxeEffects`
///
/// ## Preset Themes
/// - `default`: Blue/purple with dark background
/// - `midnight`: Deep purple with very dark background
/// - `sunset`: Warm orange/red tones
/// - `ocean`: Cool blue/teal tones
/// - `forest`: Natural green tones
/// - `neon`: Vibrant pink/cyan for bold designs
/// - `monochrome`: Black, white, and gray
/// - `light`: Light mode with white background
///
/// ## Example
/// ```swift
/// // Using a preset theme
/// ContentView()
///     .luxeTheme(.midnight)
///
/// // Creating a custom theme
/// let custom = Theme(
///     primaryColor: .orange,
///     secondaryColor: .red,
///     cornerRadius: 20
/// )
/// ContentView()
///     .luxeTheme(custom)
///
/// // Using builder pattern
/// let modified = Theme.default
///     .withPrimaryColor(.green)
///     .withHaptics(false)
/// ```
public struct Theme: Sendable {
    // Color tokens
    /// The primary brand color for main actions and highlights
    public var primaryColor: Color
    /// The secondary brand color for supporting elements
    public var secondaryColor: Color
    /// The accent color for emphasis
    public var accentColor: Color
    /// The main background color
    public var backgroundColor: Color
    /// The surface color for cards and containers
    public var surfaceColor: Color
    /// The primary text color
    public var textColor: Color
    /// The secondary/muted text color
    public var textSecondaryColor: Color
    
    // Design system
    /// Complete color scheme with semantic colors
    public var colors: LuxeColorScheme
    /// Typography settings for text styling
    public var typography: LuxeTypography
    /// Spacing scale for consistent layout
    public var spacing: LuxeSpacing
    /// Border radius scale for corners
    public var borderRadius: LuxeBorderRadius
    /// Effect values for shadows, blurs, and animations
    public var effects: LuxeEffects
    
    // Legacy support
    /// Body text font size. Default: 16
    public var fontSizeBody: CGFloat
    /// Headline font size. Default: 24
    public var fontSizeHeadline: CGFloat
    /// Default corner radius. Default: 16
    public var cornerRadius: CGFloat
    /// Small spacing value. Default: 8
    public var spacingS: CGFloat
    /// Medium spacing value. Default: 16
    public var spacingM: CGFloat
    /// Large spacing value. Default: 24
    public var spacingL: CGFloat
    /// Default shadow radius. Default: 10
    public var shadowRadius: CGFloat
    /// Default animation duration. Default: 0.3
    public var animationDuration: Double
    /// Whether haptic feedback is enabled. Default: true
    public var enableHaptics: Bool
    
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .purple,
        accentColor: Color = .cyan,
        backgroundColor: Color = Color(red: 0.05, green: 0.05, blue: 0.1),
        surfaceColor: Color = Color(red: 0.1, green: 0.1, blue: 0.15),
        textColor: Color = .white,
        textSecondaryColor: Color = .white.opacity(0.7),
        colors: LuxeColorScheme? = nil,
        typography: LuxeTypography = LuxeTypography(),
        spacing: LuxeSpacing = LuxeSpacing(),
        borderRadius: LuxeBorderRadius = LuxeBorderRadius(),
        effects: LuxeEffects = LuxeEffects(),
        fontSizeBody: CGFloat = 16,
        fontSizeHeadline: CGFloat = 24,
        cornerRadius: CGFloat = 16,
        spacingS: CGFloat = 8,
        spacingM: CGFloat = 16,
        spacingL: CGFloat = 24,
        shadowRadius: CGFloat = 10,
        animationDuration: Double = 0.3,
        enableHaptics: Bool = true
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.surfaceColor = surfaceColor
        self.textColor = textColor
        self.textSecondaryColor = textSecondaryColor
        
        self.colors = colors ?? LuxeColorScheme(
            primary: primaryColor,
            secondary: secondaryColor,
            accent: accentColor,
            background: backgroundColor,
            surface: surfaceColor,
            text: textColor,
            textSecondary: textSecondaryColor
        )
        
        self.typography = typography
        self.spacing = spacing
        self.borderRadius = borderRadius
        self.effects = effects
        
        self.fontSizeBody = fontSizeBody
        self.fontSizeHeadline = fontSizeHeadline
        self.cornerRadius = cornerRadius
        self.spacingS = spacingS
        self.spacingM = spacingM
        self.spacingL = spacingL
        self.shadowRadius = shadowRadius
        self.animationDuration = animationDuration
        self.enableHaptics = enableHaptics
    }
    
    // MARK: - Preset Themes
    
    public static let `default` = Theme()
    
    public static let midnight = Theme(
        primaryColor: Color(red: 0.4, green: 0.2, blue: 0.8),
        secondaryColor: Color(red: 0.6, green: 0.2, blue: 0.6),
        accentColor: .cyan,
        backgroundColor: Color(red: 0.02, green: 0.02, blue: 0.08),
        surfaceColor: Color(red: 0.08, green: 0.08, blue: 0.15)
    )
    
    public static let sunset = Theme(
        primaryColor: Color(red: 1.0, green: 0.4, blue: 0.2),
        secondaryColor: Color(red: 0.9, green: 0.2, blue: 0.4),
        accentColor: .yellow,
        backgroundColor: Color(red: 0.1, green: 0.05, blue: 0.05),
        surfaceColor: Color(red: 0.15, green: 0.08, blue: 0.08)
    )
    
    public static let ocean = Theme(
        primaryColor: Color(red: 0.0, green: 0.6, blue: 0.8),
        secondaryColor: Color(red: 0.0, green: 0.4, blue: 0.6),
        accentColor: .mint,
        backgroundColor: Color(red: 0.02, green: 0.05, blue: 0.1),
        surfaceColor: Color(red: 0.05, green: 0.1, blue: 0.15)
    )
    
    public static let forest = Theme(
        primaryColor: Color(red: 0.2, green: 0.7, blue: 0.4),
        secondaryColor: Color(red: 0.1, green: 0.5, blue: 0.3),
        accentColor: .yellow,
        backgroundColor: Color(red: 0.02, green: 0.08, blue: 0.04),
        surfaceColor: Color(red: 0.05, green: 0.12, blue: 0.06)
    )
    
    public static let neon = Theme(
        primaryColor: Color(red: 1.0, green: 0.0, blue: 0.8),
        secondaryColor: Color(red: 0.0, green: 1.0, blue: 0.8),
        accentColor: .yellow,
        backgroundColor: Color(red: 0.02, green: 0.02, blue: 0.05),
        surfaceColor: Color(red: 0.05, green: 0.05, blue: 0.1)
    )
    
    public static let monochrome = Theme(
        primaryColor: .white,
        secondaryColor: .gray,
        accentColor: .white,
        backgroundColor: .black,
        surfaceColor: Color(white: 0.1),
        textColor: .white,
        textSecondaryColor: .gray
    )
    
    public static let light = Theme(
        primaryColor: .blue,
        secondaryColor: .purple,
        accentColor: .cyan,
        backgroundColor: Color(white: 0.95),
        surfaceColor: .white,
        textColor: .black,
        textSecondaryColor: .gray
    )
    
    // MARK: - Builder Pattern
    
    public func withPrimaryColor(_ color: Color) -> Theme {
        var copy = self
        copy.primaryColor = color
        copy.colors.primary = color
        return copy
    }
    
    public func withSecondaryColor(_ color: Color) -> Theme {
        var copy = self
        copy.secondaryColor = color
        copy.colors.secondary = color
        return copy
    }
    
    public func withAccentColor(_ color: Color) -> Theme {
        var copy = self
        copy.accentColor = color
        copy.colors.accent = color
        return copy
    }
    
    public func withBackgroundColor(_ color: Color) -> Theme {
        var copy = self
        copy.backgroundColor = color
        copy.colors.background = color
        return copy
    }
    
    public func withTypography(_ typography: LuxeTypography) -> Theme {
        var copy = self
        copy.typography = typography
        return copy
    }
    
    public func withSpacing(_ spacing: LuxeSpacing) -> Theme {
        var copy = self
        copy.spacing = spacing
        return copy
    }
    
    public func withEffects(_ effects: LuxeEffects) -> Theme {
        var copy = self
        copy.effects = effects
        return copy
    }
    
    public func withHaptics(_ enabled: Bool) -> Theme {
        var copy = self
        copy.enableHaptics = enabled
        return copy
    }
}

// MARK: - Theme Presets Enum

public enum ThemePreset: String, CaseIterable, Sendable {
    case `default`
    case midnight
    case sunset
    case ocean
    case forest
    case neon
    case monochrome
    case light
    
    public var theme: Theme {
        switch self {
        case .default: return .default
        case .midnight: return .midnight
        case .sunset: return .sunset
        case .ocean: return .ocean
        case .forest: return .forest
        case .neon: return .neon
        case .monochrome: return .monochrome
        case .light: return .light
        }
    }
}
