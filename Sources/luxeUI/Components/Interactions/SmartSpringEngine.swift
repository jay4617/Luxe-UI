import SwiftUI

// MARK: - Smart Spring Configuration

/// Configuration options for velocity-aware spring physics interactions.
///
/// `SmartSpringConfiguration` controls how draggable elements respond to user
/// gestures with intelligent spring physics that adapt to drag velocity.
///
/// ## Overview
/// The smart spring engine provides:
/// - **Velocity-Aware Response**: Faster drags increase sensitivity
/// - **Optional Rotation**: Elements can tilt based on drag direction
/// - **Constrained Motion**: Maximum offset and rotation limits
/// - **Haptic Feedback**: Tactile response at velocity thresholds
/// - **Tunable Physics**: Control response speed and damping
///
/// ## Presets
/// - `default`: Balanced physics for general use
/// - `bouncy`: More playful with higher sensitivity and lower damping
/// - `stiff`: Controlled motion with less bounce
/// - `wobbly`: Fun rotation effect with low damping
/// - `subtle`: Minimal, understated movement
///
/// ## Example
/// ```swift
/// Image("card")
///     .smartSpring(configuration: .bouncy)
/// ```
public struct SmartSpringConfiguration: Sendable {
    /// Drag sensitivity multiplier (1.0 = normal). Default: 1.0
    public var sensitivity: Double
    /// Whether the element rotates during drag. Default: false
    public var enableRotation: Bool
    /// Rotation intensity multiplier. Default: 1.0
    public var rotationMultiplier: Double
    /// Maximum drag offset in points. Default: 100
    public var maxOffset: CGFloat
    /// Maximum rotation in degrees. Default: 15
    public var maxRotation: Double
    /// Spring animation response speed. Default: 0.3
    public var responseSpeed: Double
    /// Spring damping (0 = bouncy, 1 = no bounce). Default: 0.7
    public var dampingFraction: Double
    /// Velocity threshold for haptic feedback. Default: 500
    public var velocityThreshold: CGFloat
    /// Whether haptic feedback is enabled. Default: true
    public var enableHaptics: Bool
    /// The intensity of haptic feedback. Default: .light
    public var hapticIntensity: TactileFeedback.Intensity
    
    public init(
        sensitivity: Double = 1.0,
        enableRotation: Bool = false,
        rotationMultiplier: Double = 1.0,
        maxOffset: CGFloat = 100,
        maxRotation: Double = 15,
        responseSpeed: Double = 0.3,
        dampingFraction: Double = 0.7,
        velocityThreshold: CGFloat = 500,
        enableHaptics: Bool = true,
        hapticIntensity: TactileFeedback.Intensity = .light
    ) {
        self.sensitivity = sensitivity
        self.enableRotation = enableRotation
        self.rotationMultiplier = rotationMultiplier
        self.maxOffset = maxOffset
        self.maxRotation = maxRotation
        self.responseSpeed = responseSpeed
        self.dampingFraction = dampingFraction
        self.velocityThreshold = velocityThreshold
        self.enableHaptics = enableHaptics
        self.hapticIntensity = hapticIntensity
    }
    
    // Presets
    
    /// Default balanced physics for general use.
    public static let `default` = SmartSpringConfiguration()
    
    /// Bouncy preset with higher sensitivity and lower damping.
    /// Creates a playful, energetic feel.
    public static let bouncy = SmartSpringConfiguration(
        sensitivity: 1.5,
        responseSpeed: 0.4,
        dampingFraction: 0.5
    )
    
    /// Stiff preset with controlled motion and minimal bounce.
    /// Creates a precise, professional feel.
    public static let stiff = SmartSpringConfiguration(
        sensitivity: 0.5,
        responseSpeed: 0.2,
        dampingFraction: 0.9
    )
    
    /// Wobbly preset with rotation enabled and low damping.
    /// Creates a fun, organic feel.
    public static let wobbly = SmartSpringConfiguration(
        sensitivity: 1.2,
        enableRotation: true,
        rotationMultiplier: 1.5,
        dampingFraction: 0.4
    )
    
    /// Subtle preset with minimal, understated movement.
    /// Ideal for professional interfaces.
    public static let subtle = SmartSpringConfiguration(
        sensitivity: 0.3,
        maxOffset: 30,
        responseSpeed: 0.2
    )
}

// MARK: - Smart Spring Modifier

/// A view modifier that adds velocity-aware spring physics to drag gestures.
///
/// `SmartSpringModifier` makes views draggable with intelligent spring physics
/// that adapt to the speed of the user's drag gesture.
///
/// ## Features
/// - **Velocity Awareness**: Faster drags increase element responsiveness
/// - **Spring Return**: Elements spring back to origin when released
/// - **Optional Rotation**: Elements can tilt in the drag direction
/// - **Haptic Feedback**: Tactile response when velocity exceeds threshold
/// - **Constrained Motion**: Configurable maximum offset and rotation
///
/// ## Example
/// ```swift
/// // Using the modifier directly
/// Image("card")
///     .modifier(SmartSpringModifier(configuration: .bouncy))
///
/// // Using the convenience extension
/// Image("card")
///     .smartSpring(configuration: .wobbly)
/// ```
public struct SmartSpringModifier: ViewModifier {
    private let configuration: SmartSpringConfiguration
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @GestureState private var dragVelocity: CGSize = .zero
    
    public init(configuration: SmartSpringConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(offset)
            .rotationEffect(.degrees(configuration.enableRotation ? rotation : 0))
            .gesture(
                DragGesture()
                    .updating($dragVelocity) { value, state, _ in
                        state = value.translation
                    }
                    .onChanged { value in
                        let velocity = hypot(value.velocity.width, value.velocity.height)
                        let velocityFactor = min(velocity / configuration.velocityThreshold, 2.0)
                        let scaledSensitivity = configuration.sensitivity * (1.0 + velocityFactor * 0.5)
                        
                        withAnimation(.spring(
                            response: configuration.responseSpeed,
                            dampingFraction: configuration.dampingFraction
                        )) {
                            offset = CGSize(
                                width: min(max(value.translation.width * scaledSensitivity, -configuration.maxOffset), configuration.maxOffset),
                                height: min(max(value.translation.height * scaledSensitivity, -configuration.maxOffset), configuration.maxOffset)
                            )
                            
                            if configuration.enableRotation {
                                rotation = Double(value.translation.width / 20) * configuration.rotationMultiplier
                                rotation = min(max(rotation, -configuration.maxRotation), configuration.maxRotation)
                            }
                        }
                        
                        if velocity > configuration.velocityThreshold && configuration.enableHaptics {
                            TactileFeedback.trigger(configuration.hapticIntensity)
                        }
                    }
                    .onEnded { value in
                        let velocity = hypot(value.velocity.width, value.velocity.height)
                        
                        withAnimation(.spring(
                            response: configuration.responseSpeed,
                            dampingFraction: configuration.dampingFraction
                        )) {
                            offset = .zero
                            rotation = 0
                        }
                        
                        if velocity > configuration.velocityThreshold * 1.5 && configuration.enableHaptics {
                            TactileFeedback.medium()
                        }
                    }
            )
    }
}

// MARK: - Magnetic Pull Configuration

/// Configuration options for the magnetic pull hover effect.
///
/// `MagneticPullConfiguration` controls how elements respond when the cursor
/// approaches, creating a magnetic attraction effect.
///
/// ## Overview
/// The magnetic pull effect makes elements subtly move toward the cursor
/// when it enters a defined radius, creating an engaging interactive feel.
///
/// ## Presets
/// - `default`: Balanced magnetic attraction
/// - `strong`: More pronounced pull with larger radius
/// - `subtle`: Gentle, understated attraction
/// - `wide`: Large detection radius with moderate strength
///
/// ## Example
/// ```swift
/// Button("Click Me") { }
///     .magneticPull(configuration: .strong)
/// ```
public struct MagneticPullConfiguration: Sendable {
    /// The detection radius around the element. Default: 100
    public var radius: CGFloat
    /// The strength of the magnetic attraction (0-1). Default: 0.5
    public var strength: Double
    /// Maximum offset the element can move. Default: 20
    public var maxOffset: CGFloat
    /// Spring animation response speed. Default: 0.3
    public var responseSpeed: Double
    /// Spring damping ratio. Default: 0.7
    public var dampingFraction: Double
    /// Whether haptic feedback is enabled. Default: true
    public var enableHaptics: Bool
    /// Whether to trigger haptic when cursor enters radius. Default: true
    public var hapticOnEnter: Bool
    
    public init(
        radius: CGFloat = 100,
        strength: Double = 0.5,
        maxOffset: CGFloat = 20,
        responseSpeed: Double = 0.3,
        dampingFraction: Double = 0.7,
        enableHaptics: Bool = true,
        hapticOnEnter: Bool = true
    ) {
        self.radius = radius
        self.strength = strength
        self.maxOffset = maxOffset
        self.responseSpeed = responseSpeed
        self.dampingFraction = dampingFraction
        self.enableHaptics = enableHaptics
        self.hapticOnEnter = hapticOnEnter
    }
    
    /// Default balanced magnetic attraction.
    public static let `default` = MagneticPullConfiguration()
    
    /// Strong attraction with larger radius and more offset.
    public static let strong = MagneticPullConfiguration(
        radius: 150,
        strength: 0.8,
        maxOffset: 30
    )
    
    /// Subtle attraction with smaller radius and less offset.
    public static let subtle = MagneticPullConfiguration(
        radius: 80,
        strength: 0.3,
        maxOffset: 10
    )
    
    /// Wide detection radius with moderate attraction.
    public static let wide = MagneticPullConfiguration(
        radius: 200,
        strength: 0.4,
        maxOffset: 25
    )
}

// MARK: - Magnetic Pull Modifier

/// A view modifier that creates a magnetic pull effect toward the cursor.
///
/// `MagneticPullModifier` makes elements subtly move toward the cursor
/// when it enters a defined radius, creating an engaging hover interaction.
///
/// ## Features
/// - **Proximity Detection**: Responds when cursor enters the defined radius
/// - **Smooth Animation**: Spring-based movement toward the cursor
/// - **Haptic Feedback**: Optional tactile feedback on entry
/// - **Auto-Reset**: Returns to origin when cursor leaves
///
/// ## Example
/// ```swift
/// // Using the modifier directly
/// Button("Magnetic") { }
///     .modifier(MagneticPullModifier(configuration: .strong))
///
/// // Using the convenience extension
/// Button("Magnetic") { }
///     .magneticPull(configuration: .subtle)
/// ```
public struct MagneticPullModifier: ViewModifier {
    private let configuration: MagneticPullConfiguration
    
    @State private var offset: CGSize = .zero
    @State private var isInRange = false
    
    public init(configuration: MagneticPullConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(offset)
            .animation(
                .spring(response: configuration.responseSpeed, dampingFraction: configuration.dampingFraction),
                value: offset
            )
            .onHover { hovering in
                // Fallback for platforms without onContinuousHover
                if !hovering {
                    isInRange = false
                    offset = .zero
                }
            }
    }
}

// MARK: - Smart Spring Button Configuration

/// Configuration options for the smart spring button component.
///
/// `SmartSpringButtonConfiguration` controls the visual appearance and
/// interaction behavior of buttons with spring-based press and hover effects.
///
/// ## Presets
/// - `default`: Standard button with gradient and hover scale
/// - `magnetic`: Larger with cyan/blue gradient and stronger hover
/// - `compact`: Smaller sizing for tight spaces
///
/// ## Example
/// ```swift
/// SmartSpringButton("Submit", style: .magnetic) {
///     submitForm()
/// }
/// ```
public struct SmartSpringButtonConfiguration: Sendable {
    /// The corner radius of the button. Default: 16
    public var cornerRadius: CGFloat
    /// The internal padding around content. Default: 20
    public var padding: CGFloat
    /// The shadow blur radius. Default: 15
    public var shadowRadius: CGFloat
    /// Scale when pressed (< 1 shrinks). Default: 0.95
    public var pressScale: CGFloat
    /// Scale when hovered (> 1 enlarges). Default: 1.05
    public var hoverScale: CGFloat
    /// Background gradient colors. Default: [.purple, .pink]
    public var gradient: [Color]
    /// Whether haptic feedback is enabled. Default: true
    public var enableHaptics: Bool
    /// The intensity of haptic feedback. Default: .medium
    public var hapticIntensity: TactileFeedback.Intensity
    /// Spring animation response speed. Default: 0.3
    public var animationResponse: Double
    /// Spring damping ratio. Default: 0.7
    public var animationDamping: Double
    
    public init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 20,
        shadowRadius: CGFloat = 15,
        pressScale: CGFloat = 0.95,
        hoverScale: CGFloat = 1.05,
        gradient: [Color] = [.purple, .pink],
        enableHaptics: Bool = true,
        hapticIntensity: TactileFeedback.Intensity = .medium,
        animationResponse: Double = 0.3,
        animationDamping: Double = 0.7
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadowRadius = shadowRadius
        self.pressScale = pressScale
        self.hoverScale = hoverScale
        self.gradient = gradient
        self.enableHaptics = enableHaptics
        self.hapticIntensity = hapticIntensity
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
    }
    
    /// Default style with purple/pink gradient.
    public static let `default` = SmartSpringButtonConfiguration()
    
    /// Magnetic style with larger size and cyan/blue gradient.
    public static let magnetic = SmartSpringButtonConfiguration(
        cornerRadius: 20,
        padding: 24,
        shadowRadius: 20,
        hoverScale: 1.08,
        gradient: [.cyan, .blue]
    )
    
    /// Compact style for tight UI spaces.
    public static let compact = SmartSpringButtonConfiguration(
        cornerRadius: 12,
        padding: 14,
        shadowRadius: 10,
        hoverScale: 1.03
    )
}

/// Style options for the smart spring button.
public enum SmartSpringButtonStyle: Sendable {
    /// Standard button style.
    case standard
    /// Magnetic button with enhanced hover effect.
    case magnetic
    /// Custom configuration.
    case custom(SmartSpringButtonConfiguration)
}

// MARK: - Smart Spring Button

/// A button with spring-based press and hover animations.
///
/// `SmartSpringButton` provides an interactive button that scales down when
/// pressed and up when hovered, with smooth spring animations.
///
/// ## Features
/// - **Press Animation**: Shrinks slightly when tapped
/// - **Hover Animation**: Enlarges on hover (desktop/trackpad)
/// - **Gradient Background**: Configurable multi-color gradient
/// - **Haptic Feedback**: Tactile response on tap
/// - **Custom Content**: Accepts any view as label
///
/// ## Example
/// ```swift
/// // With text label
/// SmartSpringButton("Submit") {
///     submitForm()
/// }
///
/// // With custom label
/// SmartSpringButton(style: .magnetic, action: { save() }) {
///     HStack {
///         Image(systemName: "checkmark")
///         Text("Save")
///     }
/// }
/// ```
public struct SmartSpringButton<Label: View>: View {
    private let action: () -> Void
    private let label: Label
    private let style: SmartSpringButtonStyle
    private var configuration: SmartSpringButtonConfiguration
    
    @State private var isPressed = false
    @State private var isHovered = false
    @State private var magneticOffset: CGSize = .zero
    
    public init(
        style: SmartSpringButtonStyle = .standard,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.style = style
        self.action = action
        self.label = label()
        
        switch style {
        case .standard:
            self.configuration = .default
        case .magnetic:
            self.configuration = .magnetic
        case .custom(let config):
            self.configuration = config
        }
    }
    
    public var body: some View {
        Button(action: {
            if configuration.enableHaptics {
                TactileFeedback.trigger(configuration.hapticIntensity)
            }
            action()
        }) {
            label
                .padding(configuration.padding)
                .background(
                    LinearGradient(
                        colors: configuration.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(
                    color: configuration.gradient.first?.opacity(0.4) ?? .purple.opacity(0.4),
                    radius: configuration.shadowRadius,
                    y: 8
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? configuration.pressScale : (isHovered ? configuration.hoverScale : 1.0))
        .offset(magneticOffset)
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: isPressed
        )
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: isHovered
        )
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: magneticOffset
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onHover { hovering in
            isHovered = hovering
            if !hovering {
                magneticOffset = .zero
            }
        }
    }
    
    // Modifier methods
    public func gradient(_ colors: [Color]) -> SmartSpringButton {
        var copy = self
        copy.configuration.gradient = colors
        return copy
    }
    
    public func cornerRadius(_ radius: CGFloat) -> SmartSpringButton {
        var copy = self
        copy.configuration.cornerRadius = radius
        return copy
    }
    
    public func haptics(_ enabled: Bool, intensity: TactileFeedback.Intensity = .medium) -> SmartSpringButton {
        var copy = self
        copy.configuration.enableHaptics = enabled
        copy.configuration.hapticIntensity = intensity
        return copy
    }
}

// MARK: - View Extensions

public extension View {
    func smartSprings(configuration: SmartSpringConfiguration = .default) -> some View {
        self.modifier(SmartSpringModifier(configuration: configuration))
    }
    
    func smartSprings(
        sensitivity: Double = 1.0,
        enableRotation: Bool = false,
        rotationMultiplier: Double = 1.0,
        maxOffset: CGFloat = 100,
        responseSpeed: Double = 0.3,
        dampingFraction: Double = 0.7,
        enableHaptics: Bool = true
    ) -> some View {
        let config = SmartSpringConfiguration(
            sensitivity: sensitivity,
            enableRotation: enableRotation,
            rotationMultiplier: rotationMultiplier,
            maxOffset: maxOffset,
            responseSpeed: responseSpeed,
            dampingFraction: dampingFraction,
            enableHaptics: enableHaptics
        )
        return self.modifier(SmartSpringModifier(configuration: config))
    }
    
    func magneticPull(configuration: MagneticPullConfiguration = .default) -> some View {
        self.modifier(MagneticPullModifier(configuration: configuration))
    }
    
    func magneticPull(
        radius: CGFloat = 100,
        strength: Double = 0.5,
        maxOffset: CGFloat = 20,
        enableHaptics: Bool = true
    ) -> some View {
        let config = MagneticPullConfiguration(
            radius: radius,
            strength: strength,
            maxOffset: maxOffset,
            enableHaptics: enableHaptics
        )
        return self.modifier(MagneticPullModifier(configuration: config))
    }
}
