import SwiftUI

// MARK: - LuxeCard Configuration

/// Configuration options for LuxeCard appearance and behavior.
///
/// `LuxeCardConfiguration` provides complete control over the visual appearance and interactive
/// behavior of LuxeCard components. Use presets for quick styling or customize individual properties.
///
/// ## Overview
/// LuxeCard is a premium floating glass card with hover effects, press animations, and haptic feedback.
/// It creates a modern, elevated UI element perfect for dashboards, profiles, and content showcases.
///
/// ## Presets
/// - `default`: Balanced settings suitable for most use cases
/// - `compact`: Smaller radius and subtle effects for dense layouts
/// - `prominent`: Large, bold appearance with stronger shadows
/// - `subtle`: Minimal, understated styling
/// - `floating`: Maximum elevation with deep shadows
///
/// ## Example
/// ```swift
/// // Using a preset
/// LuxeCard(configuration: .prominent) {
///     Text("Premium Content")
/// }
///
/// // Custom configuration
/// let config = LuxeCardConfiguration(
///     cornerRadius: 24,
///     hoverScale: 1.05,
///     enableHaptics: true
/// )
/// LuxeCard(configuration: config) {
///     Text("Custom Card")
/// }
/// ```
public struct LuxeCardConfiguration: Sendable {
    /// The corner radius of the card. Default: 20
    public var cornerRadius: CGFloat
    /// The blur radius for the glass effect background. Default: 10
    public var blur: CGFloat
    /// The opacity of the card's background fill. Default: 0.15
    public var backgroundOpacity: Double
    /// The width of the card's border stroke. Default: 1
    public var borderWidth: CGFloat
    /// The opacity of the border gradient. Default: 0.3
    public var borderOpacity: Double
    /// The color of the card's drop shadow. Default: .black
    public var shadowColor: Color
    /// The blur radius of the shadow. Default: 20
    public var shadowRadius: CGFloat
    /// The horizontal offset of the shadow. Default: 0
    public var shadowX: CGFloat
    /// The vertical offset of the shadow. Default: 10
    public var shadowY: CGFloat
    /// The scale factor when the card is hovered. Default: 1.02
    public var hoverScale: CGFloat
    /// The scale factor when the card is pressed. Default: 0.98
    public var pressScale: CGFloat
    /// The spring animation response time in seconds. Default: 0.3
    public var animationResponse: Double
    /// The spring animation damping fraction. Default: 0.7
    public var animationDamping: Double
    /// Whether to trigger haptic feedback on interactions. Default: true
    public var enableHaptics: Bool
    
    public init(
        cornerRadius: CGFloat = 20,
        blur: CGFloat = 10,
        backgroundOpacity: Double = 0.15,
        borderWidth: CGFloat = 1,
        borderOpacity: Double = 0.3,
        shadowColor: Color = .black,
        shadowRadius: CGFloat = 20,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 10,
        hoverScale: CGFloat = 1.02,
        pressScale: CGFloat = 0.98,
        animationResponse: Double = 0.3,
        animationDamping: Double = 0.7,
        enableHaptics: Bool = true
    ) {
        self.cornerRadius = cornerRadius
        self.blur = blur
        self.backgroundOpacity = backgroundOpacity
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.hoverScale = hoverScale
        self.pressScale = pressScale
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.enableHaptics = enableHaptics
    }
    
    // Presets
    public static let `default` = LuxeCardConfiguration()
    
    public static let compact = LuxeCardConfiguration(
        cornerRadius: 12,
        blur: 8,
        shadowRadius: 10,
        hoverScale: 1.01
    )
    
    public static let prominent = LuxeCardConfiguration(
        cornerRadius: 28,
        blur: 15,
        backgroundOpacity: 0.2,
        shadowRadius: 30,
        shadowY: 15,
        hoverScale: 1.05
    )
    
    public static let subtle = LuxeCardConfiguration(
        cornerRadius: 16,
        blur: 5,
        backgroundOpacity: 0.1,
        shadowRadius: 8,
        hoverScale: 1.01
    )
    
    public static let floating = LuxeCardConfiguration(
        cornerRadius: 24,
        blur: 12,
        shadowRadius: 40,
        shadowY: 20,
        hoverScale: 1.03
    )
}

// MARK: - LuxeCard

/// A premium floating glass card with hover effects, press animations, and haptic feedback.
///
/// `LuxeCard` is a versatile container component that creates a modern, elevated UI element
/// with glassmorphic styling. It automatically responds to user interactions with smooth
/// scale animations and optional haptic feedback.
///
/// ## Features
/// - **Glass Effect**: Frosted glass background with customizable blur and opacity
/// - **Hover Animation**: Scales up smoothly when the user hovers (macOS) or long-presses
/// - **Press Animation**: Scales down when pressed for tactile feedback
/// - **Gradient Border**: Subtle gradient stroke that adds depth
/// - **Drop Shadow**: Configurable shadow for floating appearance
/// - **Haptic Feedback**: Optional haptic response on interactions (iOS/macOS)
///
/// ## Example
/// ```swift
/// LuxeCard {
///     VStack(spacing: 12) {
///         Image(systemName: "star.fill")
///             .font(.largeTitle)
///             .foregroundColor(.yellow)
///         Text("Premium Feature")
///             .font(.headline)
///     }
///     .padding()
/// }
/// .onTap { print("Card tapped!") }
/// .onHoverStart { print("Hover began") }
/// ```
///
/// ## Customization
/// Use `LuxeCardConfiguration` presets or create custom configurations:
/// ```swift
/// LuxeCard(configuration: .prominent) {
///     // Content
/// }
/// ```
public struct LuxeCard<Content: View>: View {
    private let content: Content
    private var configuration: LuxeCardConfiguration
    
    @State private var isHovered = false
    @State private var isPressed = false
    
    // Callbacks
    private var onHoverStart: (() -> Void)?
    private var onHoverEnd: (() -> Void)?
    private var onTapAction: (() -> Void)?
    
    public init(
        configuration: LuxeCardConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    // Convenience initializers with individual parameters
    public init(
        cornerRadius: CGFloat = 20,
        blur: CGFloat = 10,
        backgroundOpacity: Double = 0.15,
        borderWidth: CGFloat = 1,
        shadowRadius: CGFloat = 20,
        hoverScale: CGFloat = 1.02,
        pressScale: CGFloat = 0.98,
        enableHaptics: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = LuxeCardConfiguration(
            cornerRadius: cornerRadius,
            blur: blur,
            backgroundOpacity: backgroundOpacity,
            borderWidth: borderWidth,
            shadowRadius: shadowRadius,
            hoverScale: hoverScale,
            pressScale: pressScale,
            enableHaptics: enableHaptics
        )
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: configuration.cornerRadius)
                            .fill(.white.opacity(configuration.backgroundOpacity))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(configuration.borderOpacity),
                                .white.opacity(configuration.borderOpacity * 0.33)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: configuration.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
            .shadow(
                color: configuration.shadowColor.opacity(0.3),
                radius: configuration.shadowRadius,
                x: configuration.shadowX,
                y: configuration.shadowY
            )
            .scaleEffect(isPressed ? configuration.pressScale : (isHovered ? configuration.hoverScale : 1.0))
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: isHovered
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: isPressed
            )
            .onHover { hovering in
                isHovered = hovering
                if hovering {
                    onHoverStart?()
                } else {
                    onHoverEnd?()
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            if configuration.enableHaptics {
                                TactileFeedback.light()
                            }
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        onTapAction?()
                    }
            )
    }
    
    // Modifier methods for callbacks
    public func onHoverStart(_ action: @escaping () -> Void) -> LuxeCard {
        var copy = self
        copy.onHoverStart = action
        return copy
    }
    
    public func onHoverEnd(_ action: @escaping () -> Void) -> LuxeCard {
        var copy = self
        copy.onHoverEnd = action
        return copy
    }
    
    public func onTap(_ action: @escaping () -> Void) -> LuxeCard {
        var copy = self
        copy.onTapAction = action
        return copy
    }
    
    // Modifier methods for configuration
    public func cardCornerRadius(_ radius: CGFloat) -> LuxeCard {
        var copy = self
        copy.configuration.cornerRadius = radius
        return copy
    }
    
    public func cardShadow(color: Color = .black, radius: CGFloat = 20, x: CGFloat = 0, y: CGFloat = 10) -> LuxeCard {
        var copy = self
        copy.configuration.shadowColor = color
        copy.configuration.shadowRadius = radius
        copy.configuration.shadowX = x
        copy.configuration.shadowY = y
        return copy
    }
    
    public func cardHoverEffect(scale: CGFloat = 1.02) -> LuxeCard {
        var copy = self
        copy.configuration.hoverScale = scale
        return copy
    }
    
    public func cardPressEffect(scale: CGFloat = 0.98) -> LuxeCard {
        var copy = self
        copy.configuration.pressScale = scale
        return copy
    }
}

// MARK: - LuxeButton Configuration

/// Configuration options for LuxeButton appearance and behavior.
///
/// `LuxeButtonConfiguration` controls the size, styling, and interaction feedback of LuxeButton.
/// Use size presets for quick sizing or customize individual properties.
///
/// ## Overview
/// LuxeButton is a premium button with gradient backgrounds, press animations, and haptic feedback.
/// It supports multiple visual styles and can be fully customized.
///
/// ## Presets
/// - `small`: Compact button for toolbars and dense layouts
/// - `medium`: Standard size, suitable for most use cases (default)
/// - `large`: Prominent button for primary actions
/// - `extraLarge`: Hero-sized button for landing pages
///
/// ## Example
/// ```swift
/// LuxeButton("Get Started", style: .primary, configuration: .large) {
///     print("Button tapped!")
/// }
/// ```
public struct LuxeButtonConfiguration: Sendable {
    /// The corner radius of the button. Default: 12
    public var cornerRadius: CGFloat
    /// The font size of the button text. Default: 16
    public var fontSize: CGFloat
    /// The font weight of the button text. Default: .semibold
    public var fontWeight: Font.Weight
    /// The horizontal padding inside the button. Default: 24
    public var paddingHorizontal: CGFloat
    /// The vertical padding inside the button. Default: 12
    public var paddingVertical: CGFloat
    /// The blur radius of the button's shadow. Default: 10
    public var shadowRadius: CGFloat
    /// The scale factor when the button is pressed. Default: 0.95
    public var pressScale: CGFloat
    /// The spring animation response time. Default: 0.2
    public var animationResponse: Double
    /// The spring animation damping fraction. Default: 0.7
    public var animationDamping: Double
    /// Whether to trigger haptic feedback on tap. Default: true
    public var enableHaptics: Bool
    /// The intensity of haptic feedback. Default: .medium
    public var hapticIntensity: TactileFeedback.Intensity
    
    public init(
        cornerRadius: CGFloat = 12,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .semibold,
        paddingHorizontal: CGFloat = 24,
        paddingVertical: CGFloat = 12,
        shadowRadius: CGFloat = 10,
        pressScale: CGFloat = 0.95,
        animationResponse: Double = 0.2,
        animationDamping: Double = 0.7,
        enableHaptics: Bool = true,
        hapticIntensity: TactileFeedback.Intensity = .medium
    ) {
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.shadowRadius = shadowRadius
        self.pressScale = pressScale
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.enableHaptics = enableHaptics
        self.hapticIntensity = hapticIntensity
    }
    
    // Size presets
    public static let small = LuxeButtonConfiguration(
        cornerRadius: 8,
        fontSize: 14,
        paddingHorizontal: 16,
        paddingVertical: 8,
        shadowRadius: 6
    )
    
    public static let medium = LuxeButtonConfiguration()
    
    public static let large = LuxeButtonConfiguration(
        cornerRadius: 16,
        fontSize: 18,
        paddingHorizontal: 32,
        paddingVertical: 16,
        shadowRadius: 15
    )
    
    public static let extraLarge = LuxeButtonConfiguration(
        cornerRadius: 20,
        fontSize: 20,
        fontWeight: .bold,
        paddingHorizontal: 40,
        paddingVertical: 20,
        shadowRadius: 20
    )
}

/// The visual style of a LuxeButton.
///
/// ## Styles
/// - `primary`: Gradient background using theme's primary and accent colors. Best for main CTAs.
/// - `secondary`: Uses theme's secondary color. For secondary actions.
/// - `glass`: Frosted glass effect with translucent background. Elegant, subtle appearance.
/// - `custom`: Define your own gradient colors, foreground, and shadow.
public enum LuxeButtonStyle: Sendable {
    /// Gradient background using theme's primary and accent colors
    case primary
    /// Uses theme's secondary color for a less prominent appearance
    case secondary
    /// Frosted glass effect with translucent material background
    case glass
    /// Custom styling with user-defined colors
    case custom(
        background: [Color],
        foreground: Color,
        shadowColor: Color
    )
}

/// A premium button with gradient backgrounds, press animations, and haptic feedback.
///
/// `LuxeButton` is a versatile button component that automatically styles itself based on the
/// current theme. It provides smooth press animations and optional haptic feedback for a
/// polished, premium feel.
///
/// ## Features
/// - **Multiple Styles**: Primary, secondary, glass, or fully custom
/// - **Press Animation**: Smooth scale-down effect when pressed
/// - **Gradient Background**: Beautiful color transitions using theme colors
/// - **Haptic Feedback**: Configurable tactile response on tap
/// - **Theme Integration**: Automatically uses colors from the active LuxeUI theme
///
/// ## Example
/// ```swift
/// // Primary button
/// LuxeButton("Get Started", style: .primary) {
///     startOnboarding()
/// }
///
/// // Glass style button
/// LuxeButton("Learn More", style: .glass) {
///     showDetails()
/// }
///
/// // Custom colors
/// LuxeButton("Delete", style: .custom(
///     background: [.red, .orange],
///     foreground: .white,
///     shadowColor: .red
/// )) {
///     deleteItem()
/// }
/// ```
public struct LuxeButton: View {
    private let title: String
    private let style: LuxeButtonStyle
    private var configuration: LuxeButtonConfiguration
    private let action: () -> Void
    
    // Custom colors
    private var customGradient: [Color]?
    private var customForeground: Color?
    private var customShadowColor: Color?
    
    @State private var isPressed = false
    @Environment(\.luxeTheme) private var theme
    
    public init(
        _ title: String,
        style: LuxeButtonStyle = .primary,
        configuration: LuxeButtonConfiguration = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.configuration = configuration
        self.action = action
    }
    
    // Size convenience initializers
    public static func small(_ title: String, style: LuxeButtonStyle = .primary, action: @escaping () -> Void) -> LuxeButton {
        LuxeButton(title, style: style, configuration: .small, action: action)
    }
    
    public static func medium(_ title: String, style: LuxeButtonStyle = .primary, action: @escaping () -> Void) -> LuxeButton {
        LuxeButton(title, style: style, configuration: .medium, action: action)
    }
    
    public static func large(_ title: String, style: LuxeButtonStyle = .primary, action: @escaping () -> Void) -> LuxeButton {
        LuxeButton(title, style: style, configuration: .large, action: action)
    }
    
    private var gradientColors: [Color] {
        if let custom = customGradient { return custom }
        switch style {
        case .primary:
            return [theme.primaryColor, theme.accentColor]
        case .secondary:
            return [theme.secondaryColor, theme.secondaryColor.opacity(0.8)]
        case .glass:
            return [.white.opacity(0.2), .white.opacity(0.1)]
        case .custom(let background, _, _):
            return background
        }
    }
    
    private var foregroundColor: Color {
        if let custom = customForeground { return custom }
        switch style {
        case .primary, .secondary:
            return .white
        case .glass:
            return .white
        case .custom(_, let foreground, _):
            return foreground
        }
    }
    
    private var shadowColor: Color {
        if let custom = customShadowColor { return custom }
        switch style {
        case .primary:
            return theme.primaryColor
        case .secondary:
            return theme.secondaryColor
        case .glass:
            return .clear
        case .custom(_, _, let shadow):
            return shadow
        }
    }
    
    public var body: some View {
        Button(action: {
            if configuration.enableHaptics {
                TactileFeedback.trigger(configuration.hapticIntensity)
            }
            action()
        }) {
            Text(title)
                .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
                .foregroundColor(foregroundColor)
                .padding(.horizontal, configuration.paddingHorizontal)
                .padding(.vertical, configuration.paddingVertical)
                .background(
                    Group {
                        if case .glass = style {
                            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                                .fill(.ultraThinMaterial)
                        } else {
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(
                    color: shadowColor.opacity(0.4),
                    radius: configuration.shadowRadius,
                    y: 5
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? configuration.pressScale : 1.0)
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: isPressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
    
    // Customization methods
    public func gradient(_ colors: [Color]) -> LuxeButton {
        var copy = self
        copy.customGradient = colors
        return copy
    }
    
    public func foregroundColor(_ color: Color) -> LuxeButton {
        var copy = self
        copy.customForeground = color
        return copy
    }
    
    public func shadowColor(_ color: Color) -> LuxeButton {
        var copy = self
        copy.customShadowColor = color
        return copy
    }
    
    public func cornerRadius(_ radius: CGFloat) -> LuxeButton {
        var copy = self
        copy.configuration.cornerRadius = radius
        return copy
    }
    
    public func fontSize(_ size: CGFloat) -> LuxeButton {
        var copy = self
        copy.configuration.fontSize = size
        return copy
    }
}

// MARK: - LuxeBadge Configuration

/// Configuration options for LuxeBadge appearance.
///
/// `LuxeBadgeConfiguration` controls the size, typography, and glow effects of badges.
///
/// ## Overview
/// LuxeBadge is a small label component with an optional glowing effect, perfect for
/// status indicators, tags, and notification counts.
///
/// ## Presets
/// - `default`: Standard badge with glow effect
/// - `small`: Compact badge for tight spaces
/// - `large`: Prominent badge for emphasis
/// - `noGlow`: Badge without the glow effect
///
/// ## Example
/// ```swift
/// LuxeBadge("NEW", color: .green, configuration: .default)
/// LuxeBadge("PRO", color: .purple, configuration: .large)
/// ```
public struct LuxeBadgeConfiguration: Sendable {
    /// The font size of the badge text. Default: 10
    public var fontSize: CGFloat
    /// The font weight of the badge text. Default: .bold
    public var fontWeight: Font.Weight
    /// The horizontal padding inside the badge. Default: 12
    public var paddingHorizontal: CGFloat
    /// The vertical padding inside the badge. Default: 6
    public var paddingVertical: CGFloat
    /// The corner radius (uses capsule shape). Default: 20
    public var cornerRadius: CGFloat
    /// The opacity of the badge's background fill. Default: 0.2
    public var backgroundOpacity: Double
    /// The blur radius of the glow effect. Default: 8
    public var glowRadius: CGFloat
    /// The opacity of the glow effect. Default: 0.5
    public var glowOpacity: Double
    /// Whether to show the glow effect. Default: true
    public var enableGlow: Bool
    
    public init(
        fontSize: CGFloat = 10,
        fontWeight: Font.Weight = .bold,
        paddingHorizontal: CGFloat = 12,
        paddingVertical: CGFloat = 6,
        cornerRadius: CGFloat = 20,
        backgroundOpacity: Double = 0.2,
        glowRadius: CGFloat = 8,
        glowOpacity: Double = 0.5,
        enableGlow: Bool = true
    ) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.cornerRadius = cornerRadius
        self.backgroundOpacity = backgroundOpacity
        self.glowRadius = glowRadius
        self.glowOpacity = glowOpacity
        self.enableGlow = enableGlow
    }
    
    /// Standard badge with glow effect
    public static let `default` = LuxeBadgeConfiguration()
    /// Compact badge for tight spaces
    public static let small = LuxeBadgeConfiguration(fontSize: 8, paddingHorizontal: 8, paddingVertical: 4)
    /// Prominent badge for emphasis
    public static let large = LuxeBadgeConfiguration(fontSize: 12, paddingHorizontal: 16, paddingVertical: 8)
    /// Badge without the glow effect
    public static let noGlow = LuxeBadgeConfiguration(enableGlow: false)
}

/// A small glowing label for status indicators, tags, and notification counts.
///
/// `LuxeBadge` displays text in a pill-shaped container with an optional glow effect.
/// It's perfect for drawing attention to new features, status indicators, or counts.
///
/// ## Features
/// - **Glow Effect**: Optional colored glow for emphasis
/// - **Pill Shape**: Automatic capsule shape with configurable padding
/// - **Color Customization**: Badge adopts the color you specify
/// - **Multiple Sizes**: Small, default, and large presets
///
/// ## Example
/// ```swift
/// // Status badge
/// LuxeBadge("LIVE", color: .green)
///
/// // Feature badge
/// LuxeBadge("NEW", color: .blue, configuration: .large)
///
/// // Subtle badge without glow
/// LuxeBadge("BETA", color: .orange, configuration: .noGlow)
/// ```
public struct LuxeBadge: View {
    private let text: String
    private let color: Color
    private let configuration: LuxeBadgeConfiguration
    
    public init(
        _ text: String,
        color: Color = .white,
        configuration: LuxeBadgeConfiguration = .default
    ) {
        self.text = text
        self.color = color
        self.configuration = configuration
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
            .foregroundColor(color)
            .padding(.horizontal, configuration.paddingHorizontal)
            .padding(.vertical, configuration.paddingVertical)
            .background(
                Capsule()
                    .fill(color.opacity(configuration.backgroundOpacity))
                    .overlay(
                        Capsule()
                            .stroke(color.opacity(0.5), lineWidth: 1)
                    )
            )
            .shadow(
                color: configuration.enableGlow ? color.opacity(configuration.glowOpacity) : .clear,
                radius: configuration.glowRadius
            )
    }
}

// MARK: - FloatingOrb Configuration

/// Configuration options for FloatingOrb appearance and animation.
///
/// `FloatingOrbConfiguration` controls the blur, opacity, and floating animation of orbs.
///
/// ## Overview
/// FloatingOrb creates ambient, glowing circular elements that add depth and atmosphere
/// to backgrounds. They work beautifully with MeshGradientBackground.
///
/// ## Presets
/// - `default`: Standard animated orb with glow
/// - `subtle`: Softer appearance with minimal movement
/// - `vibrant`: Brighter, more dynamic movement
/// - `static`: No animation, fixed position
///
/// ## Example
/// ```swift
/// FloatingOrb(size: 200, color: .purple, configuration: .vibrant)
/// ```
public struct FloatingOrbConfiguration: Sendable {
    /// The blur radius applied to the orb. Higher = softer. Default: 60
    public var blurRadius: CGFloat
    /// The opacity of the orb. Default: 0.6
    public var opacity: Double
    /// The duration of one complete float cycle in seconds. Default: 4
    public var animationDuration: Double
    /// The vertical distance the orb floats. Default: 20
    public var animationRange: CGFloat
    /// Whether the floating animation is enabled. Default: true
    public var enableAnimation: Bool
    /// Whether to show the glow effect. Default: true
    public var enableGlow: Bool
    /// The blur radius of the glow shadow. Default: 50
    public var glowRadius: CGFloat
    
    public init(
        blurRadius: CGFloat = 60,
        opacity: Double = 0.6,
        animationDuration: Double = 4,
        animationRange: CGFloat = 20,
        enableAnimation: Bool = true,
        enableGlow: Bool = true,
        glowRadius: CGFloat = 50
    ) {
        self.blurRadius = blurRadius
        self.opacity = opacity
        self.animationDuration = animationDuration
        self.animationRange = animationRange
        self.enableAnimation = enableAnimation
        self.enableGlow = enableGlow
        self.glowRadius = glowRadius
    }
    
    /// Standard animated orb with glow
    public static let `default` = FloatingOrbConfiguration()
    /// Softer appearance with minimal movement
    public static let subtle = FloatingOrbConfiguration(blurRadius: 80, opacity: 0.4, animationRange: 10)
    /// Brighter, more dynamic movement
    public static let vibrant = FloatingOrbConfiguration(blurRadius: 40, opacity: 0.8, animationRange: 30)
    /// No animation, fixed position
    public static let `static` = FloatingOrbConfiguration(enableAnimation: false)
}

/// An animated glowing orb for atmospheric background effects.
///
/// `FloatingOrb` creates a soft, circular glow that gently floats up and down.
/// Multiple orbs can be layered to create rich, dynamic backgrounds similar
/// to the mesh gradient effects in macOS.
///
/// ## Features
/// - **Radial Gradient**: Smooth color-to-transparent fade
/// - **Blur Effect**: Configurable softness for ambient glow
/// - **Float Animation**: Gentle up-and-down movement
/// - **Glow Shadow**: Additional depth with colored shadow
///
/// ## Example
/// ```swift
/// ZStack {
///     Color.black
///     FloatingOrb(size: 300, color: .purple)
///         .offset(x: -100, y: -150)
///     FloatingOrb(size: 250, color: .blue)
///         .offset(x: 100, y: 100)
/// }
/// ```
public struct FloatingOrb: View {
    private let size: CGFloat
    private let color: Color
    private let configuration: FloatingOrbConfiguration
    
    @State private var offset: CGFloat = 0
    
    public init(
        size: CGFloat,
        color: Color,
        configuration: FloatingOrbConfiguration = .default
    ) {
        self.size = size
        self.color = color
        self.configuration = configuration
    }
    
    public var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color, color.opacity(0.3), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .blur(radius: configuration.blurRadius)
            .opacity(configuration.opacity)
            .shadow(
                color: configuration.enableGlow ? color.opacity(0.5) : .clear,
                radius: configuration.glowRadius
            )
            .offset(y: configuration.enableAnimation ? offset : 0)
            .onAppear {
                if configuration.enableAnimation {
                    withAnimation(
                        .easeInOut(duration: configuration.animationDuration)
                        .repeatForever(autoreverses: true)
                    ) {
                        offset = configuration.animationRange
                    }
                }
            }
    }
}

// MARK: - MeshGradientBackground Configuration

/// Configuration options for MeshGradientBackground appearance and animation.
///
/// `MeshGradientConfiguration` controls the orb count, sizes, positions, and animation
/// of the mesh gradient effect.
///
/// ## Overview
/// MeshGradientBackground creates beautiful, animated gradient backgrounds similar to
/// the mesh gradients in macOS 15. Multiple colored orbs blend together to create
/// a rich, dynamic backdrop.
///
/// ## Presets
/// - `default`: Three orbs with balanced animation
/// - `minimal`: Two orbs for a cleaner look
/// - `vibrant`: Five orbs with dynamic movement
/// - `static`: No animation, fixed gradient
///
/// ## Example
/// ```swift
/// MeshGradientBackground(
///     colors: [.purple, .blue, .cyan],
///     configuration: .vibrant
/// )
/// ```
public struct MeshGradientConfiguration: Sendable {
    /// The number of color orbs to display. Default: 3
    public var orbCount: Int
    /// The sizes of each orb in order. Default: [400, 350, 300]
    public var orbSizes: [CGFloat]
    /// The x,y offset positions for each orb. Default varies
    public var orbOffsets: [(x: CGFloat, y: CGFloat)]
    /// The blur radius applied to all orbs. Default: 100
    public var orbBlur: CGFloat
    /// The opacity of the orbs. Default: 0.7
    public var orbOpacity: Double
    /// The duration of one animation cycle in seconds. Default: 8
    public var animationDuration: Double
    /// The distance orbs move during animation. Default: 50
    public var animationRange: CGFloat
    /// Whether animation is enabled. Default: true
    public var enableAnimation: Bool
    /// The solid background color behind the orbs. Default: dark blue
    public var backgroundColor: Color
    
    public init(
        orbCount: Int = 3,
        orbSizes: [CGFloat] = [400, 350, 300],
        orbOffsets: [(x: CGFloat, y: CGFloat)] = [(-100, -200), (150, 100), (-50, 250)],
        orbBlur: CGFloat = 100,
        orbOpacity: Double = 0.7,
        animationDuration: Double = 8,
        animationRange: CGFloat = 50,
        enableAnimation: Bool = true,
        backgroundColor: Color = Color(red: 0.05, green: 0.05, blue: 0.1)
    ) {
        self.orbCount = orbCount
        self.orbSizes = orbSizes
        self.orbOffsets = orbOffsets
        self.orbBlur = orbBlur
        self.orbOpacity = orbOpacity
        self.animationDuration = animationDuration
        self.animationRange = animationRange
        self.enableAnimation = enableAnimation
        self.backgroundColor = backgroundColor
    }
    
    /// Three orbs with balanced animation
    public static let `default` = MeshGradientConfiguration()
    
    /// Two orbs for a cleaner look
    public static let minimal = MeshGradientConfiguration(
        orbCount: 2,
        orbSizes: [300, 250],
        orbOffsets: [(0, -100), (0, 100)],
        orbBlur: 120,
        orbOpacity: 0.5
    )
    
    /// Five orbs with dynamic movement
    public static let vibrant = MeshGradientConfiguration(
        orbCount: 5,
        orbSizes: [450, 400, 350, 300, 250],
        orbOffsets: [(-150, -250), (200, -100), (-100, 150), (150, 200), (0, 0)],
        orbBlur: 80,
        orbOpacity: 0.85,
        animationRange: 70
    )
    
    /// No animation, fixed gradient
    public static let `static` = MeshGradientConfiguration(enableAnimation: false)
}

/// An animated mesh gradient background with multiple blended color orbs.
///
/// `MeshGradientBackground` creates stunning, modern backgrounds similar to macOS 15's
/// mesh gradient system. Multiple colored orbs blend together and animate slowly
/// to create a rich, dynamic backdrop for your UI.
///
/// ## Features
/// - **Multiple Orbs**: Configurable number of color blobs
/// - **Smooth Animation**: Gentle movement for a living feel
/// - **Customizable Colors**: Use any colors from your palette
/// - **Background Color**: Solid color behind the gradient
/// - **Performance Optimized**: Efficient blur and animation
///
/// ## Example
/// ```swift
/// ZStack {
///     MeshGradientBackground(colors: [.purple, .blue, .cyan])
///     
///     VStack {
///         Text("Welcome")
///             .font(.largeTitle)
///     }
/// }
/// ```
public struct MeshGradientBackground: View {
    private let colors: [Color]
    private let configuration: MeshGradientConfiguration
    
    @State private var animate = false
    
    public init(
        colors: [Color],
        configuration: MeshGradientConfiguration = .default
    ) {
        self.colors = colors
        self.configuration = configuration
    }
    
    // Convenience initializer with individual parameters
    public init(
        colors: [Color],
        orbCount: Int = 3,
        orbBlur: CGFloat = 100,
        orbOpacity: Double = 0.7,
        animationDuration: Double = 8,
        enableAnimation: Bool = true,
        backgroundColor: Color = Color(red: 0.05, green: 0.05, blue: 0.1)
    ) {
        self.colors = colors
        self.configuration = MeshGradientConfiguration(
            orbCount: orbCount,
            orbBlur: orbBlur,
            orbOpacity: orbOpacity,
            animationDuration: animationDuration,
            enableAnimation: enableAnimation,
            backgroundColor: backgroundColor
        )
    }
    
    public var body: some View {
        ZStack {
            configuration.backgroundColor
                .ignoresSafeArea()
            
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<min(colors.count, configuration.orbCount), id: \.self) { index in
                        let size = configuration.orbSizes.indices.contains(index) 
                            ? configuration.orbSizes[index] 
                            : CGFloat(400 - index * 50)
                        let offset = configuration.orbOffsets.indices.contains(index)
                            ? configuration.orbOffsets[index]
                            : (x: CGFloat(index * 50 - 100), y: CGFloat(index * 100 - 200))
                        
                        Circle()
                            .fill(colors[index])
                            .frame(width: size, height: size)
                            .blur(radius: configuration.orbBlur)
                            .opacity(configuration.orbOpacity)
                            .offset(
                                x: offset.x + (configuration.enableAnimation && animate ? configuration.animationRange : 0),
                                y: offset.y + (configuration.enableAnimation && animate ? configuration.animationRange : 0)
                            )
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if configuration.enableAnimation {
                withAnimation(
                    .easeInOut(duration: configuration.animationDuration)
                    .repeatForever(autoreverses: true)
                ) {
                    animate = true
                }
            }
        }
    }
}

// MARK: - TactileFeedback

public struct TactileFeedback: Sendable {
    public enum Intensity: Sendable {
        case light
        case medium
        case heavy
    }
    
    public static func trigger(_ intensity: Intensity) {
        switch intensity {
        case .light: light()
        case .medium: medium()
        case .heavy: heavy()
        }
    }
    
    public static func light() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
    }
    
    public static func medium() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        #endif
    }
    
    public static func heavy() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }
    
    public static func success() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
    }
    
    public static func warning() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        #endif
    }
    
    public static func error() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }
}
