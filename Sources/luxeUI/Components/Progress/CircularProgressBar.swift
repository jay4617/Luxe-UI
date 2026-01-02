import SwiftUI

// MARK: - Circular Progress Configuration

/// Configuration options for the circular progress bar component.
///
/// `CircularProgressConfiguration` controls the appearance and behavior of
/// the circular progress indicator, including size, colors, animation, and glow effects.
///
/// ## Overview
/// Customize every aspect of the progress bar:
/// - **Size & Width**: Control overall dimensions and stroke thickness
/// - **Colors**: Single color or gradient progress arcs
/// - **Percentage Display**: Optional centered percentage text
/// - **Glow Effect**: Neon-like glow around the progress arc
/// - **Animation**: Smooth animated progress updates
///
/// ## Size Presets
/// - `small`: 50pt, compact for inline use
/// - `medium`: 80pt, balanced for most use cases
/// - `large`: 120pt, prominent display
/// - `extraLarge`: 160pt, hero-level display
///
/// ## Style Presets
/// - `default`: Gradient with glow effect
/// - `flat`: Solid color, no glow
/// - `neon`: Cyan/blue with strong glow
/// - `subtle`: Minimal track, no glow
///
/// ## Example
/// ```swift
/// CircularProgressBar(progress: 0.75, configuration: .neon)
/// ```
public struct CircularProgressConfiguration: Sendable {
    /// The overall diameter of the progress bar. Default: 100
    public var size: CGFloat
    /// The thickness of the progress stroke. Default: 10
    public var lineWidth: CGFloat
    /// The cap style for stroke ends (.round or .butt). Default: .round
    public var lineCap: CGLineCap
    /// The color of the background track. Default: .gray
    public var trackColor: Color
    /// The opacity of the background track. Default: 0.2
    public var trackOpacity: Double
    /// Colors for the progress arc (used as gradient if multiple). Default: [.blue, .purple]
    public var progressColors: [Color]
    /// Whether to use gradient coloring. Default: true
    public var useGradient: Bool
    /// Whether to show the percentage text in center. Default: true
    public var showPercentage: Bool
    /// Font size for the percentage text. Default: 24
    public var percentageFontSize: CGFloat
    /// Font weight for the percentage text. Default: .bold
    public var percentageFontWeight: Font.Weight
    /// Color of the percentage text. Default: .white
    public var percentageColor: Color
    /// Duration of progress animation in seconds. Default: 0.5
    public var animationDuration: Double
    /// Whether to show glow effect around progress. Default: true
    public var enableGlow: Bool
    /// The blur radius of the glow effect. Default: 8
    public var glowRadius: CGFloat
    /// The opacity of the glow effect. Default: 0.5
    public var glowOpacity: Double
    /// Rotation offset in degrees (-90 starts at top). Default: -90
    public var rotationOffset: Double
    
    public init(
        size: CGFloat = 100,
        lineWidth: CGFloat = 10,
        lineCap: CGLineCap = .round,
        trackColor: Color = .gray,
        trackOpacity: Double = 0.2,
        progressColors: [Color] = [.blue, .purple],
        useGradient: Bool = true,
        showPercentage: Bool = true,
        percentageFontSize: CGFloat = 24,
        percentageFontWeight: Font.Weight = .bold,
        percentageColor: Color = .white,
        animationDuration: Double = 0.5,
        enableGlow: Bool = true,
        glowRadius: CGFloat = 8,
        glowOpacity: Double = 0.5,
        rotationOffset: Double = -90
    ) {
        self.size = size
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.trackColor = trackColor
        self.trackOpacity = trackOpacity
        self.progressColors = progressColors
        self.useGradient = useGradient
        self.showPercentage = showPercentage
        self.percentageFontSize = percentageFontSize
        self.percentageFontWeight = percentageFontWeight
        self.percentageColor = percentageColor
        self.animationDuration = animationDuration
        self.enableGlow = enableGlow
        self.glowRadius = glowRadius
        self.glowOpacity = glowOpacity
        self.rotationOffset = rotationOffset
    }
    
    // Size presets
    
    /// Small size (50pt) for compact inline use.
    public static let small = CircularProgressConfiguration(
        size: 50,
        lineWidth: 6,
        percentageFontSize: 12
    )
    
    /// Medium size (80pt) for balanced display.
    public static let medium = CircularProgressConfiguration(
        size: 80,
        lineWidth: 8,
        percentageFontSize: 18
    )
    
    /// Large size (120pt) for prominent display.
    public static let large = CircularProgressConfiguration(
        size: 120,
        lineWidth: 12,
        percentageFontSize: 28
    )
    
    /// Extra large size (160pt) for hero-level display.
    public static let extraLarge = CircularProgressConfiguration(
        size: 160,
        lineWidth: 14,
        percentageFontSize: 36
    )
    
    // Style presets
    
    /// Default style with gradient and glow.
    public static let `default` = CircularProgressConfiguration()
    
    /// Flat style without gradient or glow effects.
    public static let flat = CircularProgressConfiguration(
        useGradient: false,
        enableGlow: false
    )
    
    /// Neon style with cyan/blue colors and strong glow.
    public static let neon = CircularProgressConfiguration(
        progressColors: [.cyan, .blue],
        glowRadius: 15,
        glowOpacity: 0.8
    )
    
    /// Subtle style with minimal track visibility.
    public static let subtle = CircularProgressConfiguration(
        trackOpacity: 0.1,
        enableGlow: false
    )
}

// MARK: - Circular Progress Bar

/// An animated circular progress indicator with gradient and glow effects.
///
/// `CircularProgressBar` displays progress as an arc around a circle, with
/// optional percentage text in the center and various visual effects.
///
/// ## Features
/// - **Gradient Progress**: Multi-color gradient arcs
/// - **Glow Effect**: Neon-like glow around the progress arc
/// - **Percentage Display**: Optional centered progress percentage
/// - **Smooth Animation**: Animated progress changes
/// - **Size Presets**: Small to extra-large convenience initializers
/// - **Theme Integration**: Uses theme colors when available
/// - **Callbacks**: Progress change and completion handlers
///
/// ## Example
/// ```swift
/// // Basic usage
/// CircularProgressBar(progress: 0.75)
///
/// // With configuration
/// CircularProgressBar(progress: 0.5, configuration: .neon)
///
/// // Convenience parameters
/// CircularProgressBar(
///     progress: 0.65,
///     showPercentage: true,
///     gradient: true,
///     size: 120,
///     colors: [.green, .mint]
/// )
///
/// // Static size helpers
/// CircularProgressBar.large(progress: 0.8, colors: [.orange, .red])
/// ```
///
/// ## Callbacks
/// ```swift
/// CircularProgressBar(progress: value)
///     .onProgressChange { newValue in
///         print("Progress: \(newValue)")
///     }
///     .onComplete {
///         print("Reached 100%!")
///     }
/// ```
public struct CircularProgressBar: View {
    private let progress: Double
    private var configuration: CircularProgressConfiguration
    
    // Callbacks
    private var onComplete: (() -> Void)?
    private var onProgressChange: ((Double) -> Void)?
    
    @State private var animatedProgress: Double = 0
    @Environment(\.luxeTheme) private var theme
    
    public init(
        progress: Double,
        configuration: CircularProgressConfiguration = .default
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = configuration
    }
    
    // Convenience initializer with common parameters
    public init(
        progress: Double,
        showPercentage: Bool = true,
        gradient: Bool = true,
        size: CGFloat = 100,
        lineWidth: CGFloat = 10,
        colors: [Color]? = nil
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = CircularProgressConfiguration(
            size: size,
            lineWidth: lineWidth,
            progressColors: colors ?? [.blue, .purple],
            useGradient: gradient,
            showPercentage: showPercentage
        )
    }
    
    // Size convenience initializers
    public static func small(
        progress: Double,
        showPercentage: Bool = false,
        colors: [Color]? = nil
    ) -> CircularProgressBar {
        var config = CircularProgressConfiguration.small
        config.showPercentage = showPercentage
        if let colors = colors {
            config.progressColors = colors
        }
        return CircularProgressBar(progress: progress, configuration: config)
    }
    
    public static func medium(
        progress: Double,
        showPercentage: Bool = true,
        colors: [Color]? = nil
    ) -> CircularProgressBar {
        var config = CircularProgressConfiguration.medium
        config.showPercentage = showPercentage
        if let colors = colors {
            config.progressColors = colors
        }
        return CircularProgressBar(progress: progress, configuration: config)
    }
    
    public static func large(
        progress: Double,
        showPercentage: Bool = true,
        colors: [Color]? = nil
    ) -> CircularProgressBar {
        var config = CircularProgressConfiguration.large
        config.showPercentage = showPercentage
        if let colors = colors {
            config.progressColors = colors
        }
        return CircularProgressBar(progress: progress, configuration: config)
    }
    
    public var body: some View {
        ZStack {
            // Track circle
            Circle()
                .stroke(
                    configuration.trackColor.opacity(configuration.trackOpacity),
                    style: StrokeStyle(
                        lineWidth: configuration.lineWidth,
                        lineCap: configuration.lineCap
                    )
                )
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    configuration.useGradient
                        ? AnyShapeStyle(
                            AngularGradient(
                                colors: configuration.progressColors + [configuration.progressColors.first ?? .blue],
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360)
                            )
                        )
                        : AnyShapeStyle(configuration.progressColors.first ?? .blue),
                    style: StrokeStyle(
                        lineWidth: configuration.lineWidth,
                        lineCap: configuration.lineCap
                    )
                )
                .rotationEffect(.degrees(configuration.rotationOffset))
                .shadow(
                    color: configuration.enableGlow 
                        ? configuration.progressColors.first?.opacity(configuration.glowOpacity) ?? .blue.opacity(configuration.glowOpacity)
                        : .clear,
                    radius: configuration.glowRadius
                )
            
            // Percentage text
            if configuration.showPercentage {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(
                        size: configuration.percentageFontSize,
                        weight: configuration.percentageFontWeight
                    ))
                    .foregroundColor(configuration.percentageColor)
            }
        }
        .frame(width: configuration.size, height: configuration.size)
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            let oldValue = animatedProgress
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = newValue
            }
            onProgressChange?(newValue)
            
            if newValue >= 1.0 && oldValue < 1.0 {
                onComplete?()
            }
        }
    }
    
    // Modifier methods
    public func onComplete(_ action: @escaping () -> Void) -> CircularProgressBar {
        var copy = self
        copy.onComplete = action
        return copy
    }
    
    public func onProgressChange(_ action: @escaping (Double) -> Void) -> CircularProgressBar {
        var copy = self
        copy.onProgressChange = action
        return copy
    }
    
    public func colors(_ colors: [Color]) -> CircularProgressBar {
        var copy = self
        copy.configuration.progressColors = colors
        return copy
    }
    
    public func trackColor(_ color: Color, opacity: Double = 0.2) -> CircularProgressBar {
        var copy = self
        copy.configuration.trackColor = color
        copy.configuration.trackOpacity = opacity
        return copy
    }
    
    public func lineWidth(_ width: CGFloat) -> CircularProgressBar {
        var copy = self
        copy.configuration.lineWidth = width
        return copy
    }
    
    public func showPercentage(_ show: Bool) -> CircularProgressBar {
        var copy = self
        copy.configuration.showPercentage = show
        return copy
    }
    
    public func glow(_ enabled: Bool, radius: CGFloat = 8, opacity: Double = 0.5) -> CircularProgressBar {
        var copy = self
        copy.configuration.enableGlow = enabled
        copy.configuration.glowRadius = radius
        copy.configuration.glowOpacity = opacity
        return copy
    }
    
    public func gradient(_ enabled: Bool) -> CircularProgressBar {
        var copy = self
        copy.configuration.useGradient = enabled
        return copy
    }
}

// MARK: - Linear Progress Configuration

public struct LinearProgressConfiguration: Sendable {
    public var height: CGFloat
    public var cornerRadius: CGFloat
    public var trackColor: Color
    public var trackOpacity: Double
    public var progressColors: [Color]
    public var useGradient: Bool
    public var animationDuration: Double
    public var enableGlow: Bool
    public var glowRadius: CGFloat
    public var glowOpacity: Double
    
    public init(
        height: CGFloat = 8,
        cornerRadius: CGFloat = 4,
        trackColor: Color = .gray,
        trackOpacity: Double = 0.2,
        progressColors: [Color] = [.blue, .purple],
        useGradient: Bool = true,
        animationDuration: Double = 0.3,
        enableGlow: Bool = true,
        glowRadius: CGFloat = 5,
        glowOpacity: Double = 0.4
    ) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.trackColor = trackColor
        self.trackOpacity = trackOpacity
        self.progressColors = progressColors
        self.useGradient = useGradient
        self.animationDuration = animationDuration
        self.enableGlow = enableGlow
        self.glowRadius = glowRadius
        self.glowOpacity = glowOpacity
    }
    
    public static let `default` = LinearProgressConfiguration()
    
    public static let thin = LinearProgressConfiguration(
        height: 4,
        cornerRadius: 2,
        glowRadius: 3
    )
    
    public static let thick = LinearProgressConfiguration(
        height: 12,
        cornerRadius: 6,
        glowRadius: 8
    )
}

// MARK: - Linear Progress Bar

public struct LinearProgressBar: View {
    private let progress: Double
    private var configuration: LinearProgressConfiguration
    
    @State private var animatedProgress: Double = 0
    
    public init(
        progress: Double,
        configuration: LinearProgressConfiguration = .default
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = configuration
    }
    
    public init(
        progress: Double,
        height: CGFloat = 8,
        colors: [Color]? = nil,
        gradient: Bool = true
    ) {
        self.progress = max(0, min(1, progress))
        self.configuration = LinearProgressConfiguration(
            height: height,
            progressColors: colors ?? [.blue, .purple],
            useGradient: gradient
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(configuration.trackColor.opacity(configuration.trackOpacity))
                
                // Progress
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(
                        configuration.useGradient
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: configuration.progressColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            : AnyShapeStyle(configuration.progressColors.first ?? .blue)
                    )
                    .frame(width: geometry.size.width * animatedProgress)
                    .shadow(
                        color: configuration.enableGlow
                            ? configuration.progressColors.first?.opacity(configuration.glowOpacity) ?? .blue.opacity(configuration.glowOpacity)
                            : .clear,
                        radius: configuration.glowRadius
                    )
            }
        }
        .frame(height: configuration.height)
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedProgress = newValue
            }
        }
    }
    
    // Modifier methods
    public func colors(_ colors: [Color]) -> LinearProgressBar {
        var copy = self
        copy.configuration.progressColors = colors
        return copy
    }
    
    public func height(_ height: CGFloat) -> LinearProgressBar {
        var copy = self
        copy.configuration.height = height
        copy.configuration.cornerRadius = height / 2
        return copy
    }
    
    public func glow(_ enabled: Bool) -> LinearProgressBar {
        var copy = self
        copy.configuration.enableGlow = enabled
        return copy
    }
}
