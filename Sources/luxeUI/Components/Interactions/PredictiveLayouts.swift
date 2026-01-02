import SwiftUI

// MARK: - Predictive Layout Configuration

/// Configuration options for probability-based adaptive UI layouts.
///
/// `PredictiveLayoutConfiguration` controls how UI elements respond to
/// probability values, enabling interfaces that adapt based on predicted
/// user actions or AI-driven relevance scores.
///
/// ## Overview
/// Predictive layouts make elements more prominent as their action probability
/// increases. Higher probability elements become:
/// - More opaque (fade in)
/// - Larger (scale up)
/// - More elevated (stronger shadow)
/// - Glowing (optional highlight effect)
///
/// ## Use Cases
/// - **AI-Driven UI**: Highlight recommended actions
/// - **Form Optimization**: Emphasize likely next fields
/// - **Smart Lists**: Surface relevant items
/// - **Contextual Actions**: Promote timely buttons
///
/// ## Presets
/// - `default`: Balanced effect with all features
/// - `subtle`: Minimal scale and glow changes
/// - `prominent`: Strong visual differentiation
/// - `noAnimation`: Instant transitions, no effects
///
/// ## Example
/// ```swift
/// LuxeAdaptiveContainer(probability: 0.8) {
///     Text("Recommended Action")
/// }
/// ```
public struct PredictiveLayoutConfiguration: Sendable {
    /// Base opacity when probability is 0. Default: 0.7
    public var baseOpacity: Double
    /// Full opacity when probability is 1. Default: 1.0
    public var activeOpacity: Double
    /// Base scale when probability is 0. Default: 1.0
    public var baseScale: CGFloat
    /// Full scale when probability is 1. Default: 1.05
    public var activeScale: CGFloat
    /// Base shadow radius when probability is 0. Default: 5
    public var baseShadowRadius: CGFloat
    /// Full shadow radius when probability is 1. Default: 20
    public var activeShadowRadius: CGFloat
    /// Color of the glow effect. Default: .blue
    public var glowColor: Color
    /// Opacity of the glow effect. Default: 0.3
    public var glowOpacity: Double
    /// Spring animation response speed. Default: 0.3
    public var animationResponse: Double
    /// Spring damping ratio. Default: 0.7
    public var animationDamping: Double
    /// Threshold above which glow activates. Default: 0.5
    public var probabilityThreshold: Double
    /// Whether to show glow effect. Default: true
    public var enableGlow: Bool
    /// Whether to enable scale animation. Default: true
    public var enableScale: Bool
    /// Whether to enable shadow/elevation. Default: true
    public var enableElevation: Bool
    
    public init(
        baseOpacity: Double = 0.7,
        activeOpacity: Double = 1.0,
        baseScale: CGFloat = 1.0,
        activeScale: CGFloat = 1.05,
        baseShadowRadius: CGFloat = 5,
        activeShadowRadius: CGFloat = 20,
        glowColor: Color = .blue,
        glowOpacity: Double = 0.3,
        animationResponse: Double = 0.3,
        animationDamping: Double = 0.7,
        probabilityThreshold: Double = 0.5,
        enableGlow: Bool = true,
        enableScale: Bool = true,
        enableElevation: Bool = true
    ) {
        self.baseOpacity = baseOpacity
        self.activeOpacity = activeOpacity
        self.baseScale = baseScale
        self.activeScale = activeScale
        self.baseShadowRadius = baseShadowRadius
        self.activeShadowRadius = activeShadowRadius
        self.glowColor = glowColor
        self.glowOpacity = glowOpacity
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.probabilityThreshold = probabilityThreshold
        self.enableGlow = enableGlow
        self.enableScale = enableScale
        self.enableElevation = enableElevation
    }
    
    /// Default balanced configuration with all effects.
    public static let `default` = PredictiveLayoutConfiguration()
    
    /// Subtle configuration with minimal visual changes.
    public static let subtle = PredictiveLayoutConfiguration(
        activeScale: 1.02,
        activeShadowRadius: 10,
        glowOpacity: 0.2
    )
    
    /// Prominent configuration with strong differentiation.
    public static let prominent = PredictiveLayoutConfiguration(
        activeScale: 1.08,
        activeShadowRadius: 30,
        glowOpacity: 0.5
    )
    
    /// No animation configuration for instant transitions.
    public static let noAnimation = PredictiveLayoutConfiguration(
        enableGlow: false,
        enableScale: false,
        enableElevation: false
    )
}

// MARK: - Adaptive Container

/// A container that adapts its appearance based on a probability value.
///
/// `LuxeAdaptiveContainer` wraps content and adjusts opacity, scale, and
/// glow effects based on a probability score (0.0 to 1.0).
///
/// ## Features
/// - **Interpolated Opacity**: Fades from base to active opacity
/// - **Interpolated Scale**: Grows as probability increases
/// - **Dynamic Shadow**: Elevation increases with probability
/// - **Glow Effect**: Activates above the threshold
/// - **Smooth Animation**: Spring-based transitions
///
/// ## Example
/// ```swift
/// // AI-recommended action
/// LuxeAdaptiveContainer(probability: recommendation.score) {
///     Button("Buy Now") { purchase() }
/// }
///
/// // With custom configuration
/// LuxeAdaptiveContainer(
///     probability: relevance,
///     configuration: .prominent
/// ) {
///     ProductCard(item)
/// }
/// ```
public struct LuxeAdaptiveContainer<Content: View>: View {
    private let content: Content
    private let probability: Double
    private var configuration: PredictiveLayoutConfiguration
    
    @Environment(\.luxeTheme) private var theme
    
    public init(
        probability: Double,
        configuration: PredictiveLayoutConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.probability = probability
        self.configuration = configuration
        self.content = content()
    }
    
    private var interpolatedOpacity: Double {
        configuration.baseOpacity + (configuration.activeOpacity - configuration.baseOpacity) * probability
    }
    
    private var interpolatedScale: CGFloat {
        if !configuration.enableScale { return 1.0 }
        return configuration.baseScale + (configuration.activeScale - configuration.baseScale) * CGFloat(probability)
    }
    
    private var interpolatedShadow: CGFloat {
        if !configuration.enableElevation { return 0 }
        return configuration.baseShadowRadius + (configuration.activeShadowRadius - configuration.baseShadowRadius) * CGFloat(probability)
    }
    
    public var body: some View {
        content
            .opacity(interpolatedOpacity)
            .scaleEffect(interpolatedScale)
            .shadow(
                color: configuration.enableGlow && probability > configuration.probabilityThreshold 
                    ? configuration.glowColor.opacity(configuration.glowOpacity * probability) 
                    : .clear,
                radius: interpolatedShadow
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: probability
            )
    }
    
    // Modifier methods
    public func glowColor(_ color: Color) -> LuxeAdaptiveContainer {
        var copy = self
        copy.configuration.glowColor = color
        return copy
    }
    
    public func threshold(_ value: Double) -> LuxeAdaptiveContainer {
        var copy = self
        copy.configuration.probabilityThreshold = value
        return copy
    }
}

// MARK: - Smart Form Button Configuration

/// Configuration options for the smart form button that adapts to form completion.
///
/// `SmartFormButtonConfiguration` controls how the submit button grows and
/// changes color as the form completion probability increases.
///
/// ## Overview
/// Smart form buttons visually indicate form readiness:
/// - **Size**: Button grows as more fields are completed
/// - **Color**: Transitions from gray to vibrant as form fills
/// - **Shadow**: Glow intensifies at high completion
/// - **Haptics**: Feedback when crossing completion threshold
///
/// ## Presets
/// - `default`: Balanced size range and animation
/// - `compact`: Smaller button for tight layouts
/// - `large`: Bigger button for prominent CTAs
///
/// ## Example
/// ```swift
/// SmartFormButton(
///     "Submit",
///     completionProbability: formProgress,
///     configuration: .large
/// ) {
///     submitForm()
/// }
/// ```
public struct SmartFormButtonConfiguration: Sendable {
    /// Minimum button width when probability is 0. Default: 120
    public var minWidth: CGFloat
    /// Maximum button width when probability is 1. Default: 280
    public var maxWidth: CGFloat
    /// Minimum button height when probability is 0. Default: 44
    public var minHeight: CGFloat
    /// Maximum button height when probability is 1. Default: 56
    public var maxHeight: CGFloat
    /// The corner radius of the button. Default: 14
    public var cornerRadius: CGFloat
    /// The font size for the button text. Default: 16
    public var fontSize: CGFloat
    /// The font weight for the button text. Default: .semibold
    public var fontWeight: Font.Weight
    /// Gradient colors when form is incomplete. Default: grays
    public var inactiveColors: [Color]
    /// Gradient colors when form is complete. Default: [.green, .cyan]
    public var activeColors: [Color]
    /// Shadow radius at full completion. Default: 20
    public var shadowRadius: CGFloat
    /// Spring animation response speed. Default: 0.4
    public var animationResponse: Double
    /// Spring damping ratio. Default: 0.7
    public var animationDamping: Double
    /// Whether haptic feedback is enabled. Default: true
    public var enableHaptics: Bool
    /// Probability threshold for haptic trigger. Default: 0.5
    public var hapticThreshold: Double
    
    public init(
        minWidth: CGFloat = 120,
        maxWidth: CGFloat = 280,
        minHeight: CGFloat = 44,
        maxHeight: CGFloat = 56,
        cornerRadius: CGFloat = 14,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .semibold,
        inactiveColors: [Color] = [.gray.opacity(0.3), .gray.opacity(0.2)],
        activeColors: [Color] = [.green, .cyan],
        shadowRadius: CGFloat = 20,
        animationResponse: Double = 0.4,
        animationDamping: Double = 0.7,
        enableHaptics: Bool = true,
        hapticThreshold: Double = 0.5
    ) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.inactiveColors = inactiveColors
        self.activeColors = activeColors
        self.shadowRadius = shadowRadius
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
        self.enableHaptics = enableHaptics
        self.hapticThreshold = hapticThreshold
    }
    
    /// Default balanced configuration.
    public static let `default` = SmartFormButtonConfiguration()
    
    /// Compact configuration for tight layouts.
    public static let compact = SmartFormButtonConfiguration(
        minWidth: 100,
        maxWidth: 200,
        minHeight: 36,
        maxHeight: 48
    )
    
    /// Large configuration for prominent call-to-action.
    public static let large = SmartFormButtonConfiguration(
        minWidth: 150,
        maxWidth: 350,
        minHeight: 50,
        maxHeight: 64,
        fontSize: 18
    )
}

// MARK: - Smart Form Button

/// A submit button that grows and changes color based on form completion.
///
/// `SmartFormButton` provides visual feedback about form readiness by
/// adapting its size, color, and effects based on a completion probability.
///
/// ## Features
/// - **Dynamic Size**: Button grows as more fields are completed
/// - **Color Transition**: Shifts from gray (incomplete) to vibrant (complete)
/// - **Glow Effect**: Adds shadow glow at high completion
/// - **Haptic Feedback**: Triggers when crossing completion threshold
/// - **Spring Animation**: Smooth transitions between states
///
/// ## Example
/// ```swift
/// @State var name = ""
/// @State var email = ""
///
/// var completeness: Double {
///     (name.isEmpty ? 0 : 0.5) + (email.isEmpty ? 0 : 0.5)
/// }
///
/// VStack {
///     TextField("Name", text: $name)
///     TextField("Email", text: $email)
///     
///     SmartFormButton("Submit", completionProbability: completeness) {
///         submitForm()
///     }
/// }
/// ```
public struct SmartFormButton: View {
    private let title: String
    private let completionProbability: Double
    private let action: () -> Void
    private var configuration: SmartFormButtonConfiguration
    
    @State private var isPressed = false
    @State private var lastHapticProbability: Double = 0
    
    public init(
        _ title: String,
        completionProbability: Double,
        configuration: SmartFormButtonConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.completionProbability = completionProbability
        self.configuration = configuration
        self.action = action
    }
    
    private var interpolatedWidth: CGFloat {
        configuration.minWidth + (configuration.maxWidth - configuration.minWidth) * CGFloat(completionProbability)
    }
    
    private var interpolatedHeight: CGFloat {
        configuration.minHeight + (configuration.maxHeight - configuration.minHeight) * CGFloat(completionProbability)
    }
    
    private var currentGradient: [Color] {
        if completionProbability < 0.3 {
            return configuration.inactiveColors
        } else if completionProbability < 0.7 {
            return [
                configuration.inactiveColors[0].opacity(1 - completionProbability),
                configuration.activeColors[0].opacity(completionProbability)
            ]
        } else {
            return configuration.activeColors
        }
    }
    
    public var body: some View {
        Button(action: {
            if configuration.enableHaptics {
                TactileFeedback.heavy()
            }
            action()
        }) {
            Text(title)
                .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
                .foregroundColor(.white)
                .frame(width: interpolatedWidth, height: interpolatedHeight)
                .background(
                    LinearGradient(
                        colors: currentGradient,
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
                    color: completionProbability > 0.5 
                        ? configuration.activeColors[0].opacity(0.4 * completionProbability) 
                        : .clear,
                    radius: configuration.shadowRadius * CGFloat(completionProbability),
                    y: 8
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(
            .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
            value: completionProbability
        )
        .animation(
            .spring(response: 0.2, dampingFraction: 0.7),
            value: isPressed
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onChange(of: completionProbability) { newValue in
            if configuration.enableHaptics {
                // Haptic when crossing threshold
                if newValue >= configuration.hapticThreshold && lastHapticProbability < configuration.hapticThreshold {
                    TactileFeedback.medium()
                }
                // Haptic when form becomes complete
                if newValue >= 0.95 && lastHapticProbability < 0.95 {
                    TactileFeedback.success()
                }
                lastHapticProbability = newValue
            }
        }
    }
    
    // Modifier methods
    public func colors(inactive: [Color], active: [Color]) -> SmartFormButton {
        var copy = self
        copy.configuration.inactiveColors = inactive
        copy.configuration.activeColors = active
        return copy
    }
    
    public func size(minWidth: CGFloat = 120, maxWidth: CGFloat = 280, minHeight: CGFloat = 44, maxHeight: CGFloat = 56) -> SmartFormButton {
        var copy = self
        copy.configuration.minWidth = minWidth
        copy.configuration.maxWidth = maxWidth
        copy.configuration.minHeight = minHeight
        copy.configuration.maxHeight = maxHeight
        return copy
    }
}

// MARK: - Predictive List Item Configuration

/// Configuration options for probability-based list items.
///
/// `PredictiveListItemConfiguration` controls how list items adapt their
/// appearance based on relevance or recommendation probability.
///
/// ## Presets
/// - `default`: Balanced visual differentiation
/// - `subtle`: Minimal changes for understated effect
/// - `prominent`: Strong differentiation for important items
///
/// ## Example
/// ```swift
/// PredictiveListItem(probability: item.relevance, configuration: .prominent) {
///     Text(item.title)
/// }
/// ```
public struct PredictiveListItemConfiguration: Sendable {
    /// Base opacity when probability is 0. Default: 0.6
    public var baseOpacity: Double
    /// Full opacity when probability is 1. Default: 1.0
    public var activeOpacity: Double
    /// Base scale when probability is 0. Default: 0.98
    public var baseScale: CGFloat
    /// Full scale when probability is 1. Default: 1.0
    public var activeScale: CGFloat
    /// Base leading padding. Default: 0
    public var leadingPadding: CGFloat
    /// Leading padding at full probability (indent effect). Default: 8
    public var activeLeadingPadding: CGFloat
    /// Color of the glow effect. Default: .blue
    public var glowColor: Color
    /// Opacity of the glow effect. Default: 0.2
    public var glowOpacity: Double
    /// Shadow radius for glow effect. Default: 10
    public var shadowRadius: CGFloat
    /// Spring animation response speed. Default: 0.3
    public var animationResponse: Double
    /// Whether haptic feedback is enabled. Default: true
    public var enableHaptics: Bool
    
    public init(
        baseOpacity: Double = 0.6,
        activeOpacity: Double = 1.0,
        baseScale: CGFloat = 0.98,
        activeScale: CGFloat = 1.0,
        leadingPadding: CGFloat = 0,
        activeLeadingPadding: CGFloat = 8,
        glowColor: Color = .blue,
        glowOpacity: Double = 0.2,
        shadowRadius: CGFloat = 10,
        animationResponse: Double = 0.3,
        enableHaptics: Bool = true
    ) {
        self.baseOpacity = baseOpacity
        self.activeOpacity = activeOpacity
        self.baseScale = baseScale
        self.activeScale = activeScale
        self.leadingPadding = leadingPadding
        self.activeLeadingPadding = activeLeadingPadding
        self.glowColor = glowColor
        self.glowOpacity = glowOpacity
        self.shadowRadius = shadowRadius
        self.animationResponse = animationResponse
        self.enableHaptics = enableHaptics
    }
    
    /// Default balanced configuration.
    public static let `default` = PredictiveListItemConfiguration()
    
    /// Subtle configuration with minimal visual changes.
    public static let subtle = PredictiveListItemConfiguration(
        baseOpacity: 0.8,
        activeScale: 1.0,
        activeLeadingPadding: 4
    )
    
    /// Prominent configuration with strong differentiation.
    public static let prominent = PredictiveListItemConfiguration(
        baseOpacity: 0.5,
        activeScale: 1.02,
        activeLeadingPadding: 12,
        glowOpacity: 0.3
    )
}

// MARK: - Predictive List Item

/// A list item that adapts its appearance based on relevance probability.
///
/// `PredictiveListItem` wraps content and adjusts opacity, scale, padding,
/// and glow based on a probability score to surface relevant items.
///
/// ## Features
/// - **Opacity Adaptation**: More relevant items are more visible
/// - **Scale Effect**: Subtle size increase for high-probability items
/// - **Indent Effect**: Higher probability items shift right slightly
/// - **Glow Effect**: Highlights above threshold probability
/// - **Spring Animation**: Smooth transitions as probabilities change
///
/// ## Example
/// ```swift
/// ForEach(searchResults) { result in
///     PredictiveListItem(probability: result.relevance) {
///         HStack {
///             Image(systemName: result.icon)
///             Text(result.title)
///         }
///     }
///     .glowColor(.purple)
/// }
/// ```
public struct PredictiveListItem<Content: View>: View {
    private let content: Content
    private let probability: Double
    private var configuration: PredictiveListItemConfiguration
    
    public init(
        probability: Double,
        configuration: PredictiveListItemConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.probability = probability
        self.configuration = configuration
        self.content = content()
    }
    
    private var interpolatedOpacity: Double {
        configuration.baseOpacity + (configuration.activeOpacity - configuration.baseOpacity) * probability
    }
    
    private var interpolatedScale: CGFloat {
        configuration.baseScale + (configuration.activeScale - configuration.baseScale) * CGFloat(probability)
    }
    
    private var interpolatedPadding: CGFloat {
        configuration.leadingPadding + (configuration.activeLeadingPadding - configuration.leadingPadding) * CGFloat(probability)
    }
    
    public var body: some View {
        content
            .opacity(interpolatedOpacity)
            .scaleEffect(interpolatedScale, anchor: .leading)
            .padding(.leading, interpolatedPadding)
            .shadow(
                color: probability > 0.5 
                    ? configuration.glowColor.opacity(configuration.glowOpacity * probability) 
                    : .clear,
                radius: configuration.shadowRadius * CGFloat(probability)
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: 0.7),
                value: probability
            )
    }
    
    // Modifier methods
    public func glowColor(_ color: Color) -> PredictiveListItem {
        var copy = self
        copy.configuration.glowColor = color
        return copy
    }
}

// MARK: - Intent Calculator

/// Utility struct for calculating user intent probabilities.
///
/// `IntentCalculator` provides static methods to compute probability values
/// for various user actions, useful for driving predictive UI components.
///
/// ## Overview
/// Use these calculators to determine probability values for:
/// - Form completion status
/// - Hover intent (time on target)
/// - Scroll position proximity
/// - Click intent (mouse approach)
/// - Item selection likelihood
///
/// ## Example
/// ```swift
/// // Calculate form progress
/// let probability = IntentCalculator.formCompletionProbability(
///     filledFields: 3,
///     totalFields: 5,
///     isValid: true
/// )
///
/// SmartFormButton("Submit", completionProbability: probability) {
///     submit()
/// }
/// ```
public struct IntentCalculator {
    /// Calculate form completion probability based on filled fields.
    ///
    /// - Parameters:
    ///   - filledFields: Number of fields with content
    ///   - totalFields: Total number of form fields
    ///   - isValid: Whether current input is valid (adds bonus)
    /// - Returns: Probability from 0.0 to 1.0
    public static func formCompletionProbability(
        filledFields: Int,
        totalFields: Int,
        isValid: Bool = true
    ) -> Double {
        guard totalFields > 0 else { return 0 }
        let fillRatio = Double(filledFields) / Double(totalFields)
        let validityBonus = isValid ? 0.1 : 0
        return min(fillRatio + validityBonus, 1.0)
    }
    
    /// Calculate hover intent based on time spent hovering.
    ///
    /// - Parameters:
    ///   - duration: How long the user has been hovering
    ///   - maxDuration: Duration at which probability reaches 1.0
    /// - Returns: Probability from 0.0 to 1.0
    public static func hoverIntentProbability(
        duration: TimeInterval,
        maxDuration: TimeInterval = 2.0
    ) -> Double {
        min(duration / maxDuration, 1.0)
    }
    
    /// Calculate scroll intent based on proximity to target.
    ///
    /// - Parameters:
    ///   - currentPosition: Current scroll Y position
    ///   - targetPosition: Target element Y position
    ///   - viewportHeight: Height of the visible viewport
    /// - Returns: Probability from 0.0 to 1.0
    public static func scrollIntentProbability(
        currentPosition: CGFloat,
        targetPosition: CGFloat,
        viewportHeight: CGFloat
    ) -> Double {
        let distance = abs(currentPosition - targetPosition)
        let normalizedDistance = distance / viewportHeight
        return max(0, 1 - normalizedDistance)
    }
    
    /// Calculate click intent based on mouse movement toward target.
    ///
    /// - Parameters:
    ///   - approachVelocity: Speed of mouse movement toward target
    ///   - distanceToTarget: Current distance from target center
    ///   - maxDistance: Distance at which probability is 0
    /// - Returns: Probability from 0.0 to 1.0
    public static func clickIntentProbability(
        approachVelocity: CGFloat,
        distanceToTarget: CGFloat,
        maxDistance: CGFloat = 100
    ) -> Double {
        let distanceFactor = max(0, 1 - distanceToTarget / maxDistance)
        let velocityFactor = min(approachVelocity / 500, 1.0)
        return distanceFactor * (0.7 + velocityFactor * 0.3)
    }
    
    /// Calculate selection probability for an item in a list.
    ///
    /// - Parameters:
    ///   - itemIndex: Index of the item to calculate
    ///   - totalItems: Total number of items in the list
    ///   - recentSelections: Indices of recently selected items
    ///   - weights: Custom probability weights by index
    /// - Returns: Probability from 0.0 to 1.0
    public static func selectionProbability(
        itemIndex: Int,
        totalItems: Int,
        recentSelections: [Int] = [],
        weights: [Int: Double] = [:]
    ) -> Double {
        var probability = 1.0 / Double(totalItems)
        
        // Boost recently selected items
        if recentSelections.contains(itemIndex) {
            probability *= 1.5
        }
        
        // Apply custom weights
        if let weight = weights[itemIndex] {
            probability *= weight
        }
        
        return min(probability, 1.0)
    }
}

// MARK: - Predictive Modifier

public struct PredictiveModifier: ViewModifier {
    let probability: Double
    let configuration: PredictiveLayoutConfiguration
    
    public init(probability: Double, configuration: PredictiveLayoutConfiguration = .default) {
        self.probability = probability
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .opacity(configuration.baseOpacity + (configuration.activeOpacity - configuration.baseOpacity) * probability)
            .scaleEffect(
                configuration.enableScale 
                    ? configuration.baseScale + (configuration.activeScale - configuration.baseScale) * CGFloat(probability)
                    : 1.0
            )
            .shadow(
                color: configuration.enableGlow && probability > configuration.probabilityThreshold
                    ? configuration.glowColor.opacity(configuration.glowOpacity * probability)
                    : .clear,
                radius: configuration.enableElevation
                    ? configuration.baseShadowRadius + (configuration.activeShadowRadius - configuration.baseShadowRadius) * CGFloat(probability)
                    : 0
            )
            .animation(
                .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                value: probability
            )
    }
}

// MARK: - View Extension

public extension View {
    func predictive(
        probability: Double,
        configuration: PredictiveLayoutConfiguration = .default
    ) -> some View {
        self.modifier(PredictiveModifier(probability: probability, configuration: configuration))
    }
}
