import SwiftUI

// MARK: - Multi-Thumb Slider Configuration

/// Configuration options for the multi-thumb range slider.
///
/// `MultiThumbSliderConfiguration` controls the appearance and behavior of
/// the range slider, including track styling, thumb appearance, labels,
/// and haptic feedback.
///
/// ## Overview
/// The multi-thumb slider allows users to select a range with two or more
/// draggable thumbs. Customize:
/// - **Track**: Height, colors, and active range highlighting
/// - **Thumbs**: Size, color, border, and shadow
/// - **Labels**: Value labels above each thumb
/// - **Haptics**: Feedback on value changes and boundaries
///
/// ## Presets
/// - `default`: Balanced appearance for most use cases
/// - `compact`: Smaller track and thumbs for tight spaces
/// - `large`: Bigger thumbs for touch-friendly interfaces
/// - `minimal`: Very thin track, no labels or borders
/// - `vibrant`: Colorful gradient with cyan/purple colors
///
/// ## Example
/// ```swift
/// @State var range = [20.0, 80.0]
///
/// MultiThumbSlider(values: $range, configuration: .vibrant)
/// ```
public struct MultiThumbSliderConfiguration: Sendable {
    /// The height of the track. Default: 6
    public var trackHeight: CGFloat
    /// The diameter of the thumb circles. Default: 24
    public var thumbSize: CGFloat
    /// The color of the inactive track. Default: .gray
    public var trackColor: Color
    /// The opacity of the inactive track. Default: 0.3
    public var trackOpacity: Double
    /// Colors for the active (selected) range gradient. Default: [.blue, .purple]
    public var activeTrackColors: [Color]
    /// The fill color of the thumbs. Default: .white
    public var thumbColor: Color
    /// The border color of the thumbs. Default: .blue
    public var thumbBorderColor: Color
    /// The border width of the thumbs. Default: 2
    public var thumbBorderWidth: CGFloat
    /// The shadow color behind the thumbs. Default: .black
    public var thumbShadowColor: Color
    /// The shadow blur radius. Default: 4
    public var thumbShadowRadius: CGFloat
    /// Whether to show value labels above thumbs. Default: true
    public var showLabels: Bool
    /// The font size for value labels. Default: 12
    public var labelFontSize: CGFloat
    /// The color of value labels. Default: .white
    public var labelColor: Color
    /// Whether haptic feedback is enabled. Default: true
    public var enableHaptics: Bool
    /// Whether to trigger haptics on every value change. Default: false
    public var hapticOnChange: Bool
    /// Whether to trigger haptics at range boundaries. Default: true
    public var hapticOnBoundary: Bool
    /// The spring animation response speed. Default: 0.2
    public var animationResponse: Double
    /// The spring animation damping ratio. Default: 0.8
    public var animationDamping: Double
    
    public init(
        trackHeight: CGFloat = 6,
        thumbSize: CGFloat = 24,
        trackColor: Color = .gray,
        trackOpacity: Double = 0.3,
        activeTrackColors: [Color] = [.blue, .purple],
        thumbColor: Color = .white,
        thumbBorderColor: Color = .blue,
        thumbBorderWidth: CGFloat = 2,
        thumbShadowColor: Color = .black,
        thumbShadowRadius: CGFloat = 4,
        showLabels: Bool = true,
        labelFontSize: CGFloat = 12,
        labelColor: Color = .white,
        enableHaptics: Bool = true,
        hapticOnChange: Bool = false,
        hapticOnBoundary: Bool = true,
        animationResponse: Double = 0.2,
        animationDamping: Double = 0.8
    ) {
        self.trackHeight = trackHeight
        self.thumbSize = thumbSize
        self.trackColor = trackColor
        self.trackOpacity = trackOpacity
        self.activeTrackColors = activeTrackColors
        self.thumbColor = thumbColor
        self.thumbBorderColor = thumbBorderColor
        self.thumbBorderWidth = thumbBorderWidth
        self.thumbShadowColor = thumbShadowColor
        self.thumbShadowRadius = thumbShadowRadius
        self.showLabels = showLabels
        self.labelFontSize = labelFontSize
        self.labelColor = labelColor
        self.enableHaptics = enableHaptics
        self.hapticOnChange = hapticOnChange
        self.hapticOnBoundary = hapticOnBoundary
        self.animationResponse = animationResponse
        self.animationDamping = animationDamping
    }
    
    // Presets
    
    /// Default balanced configuration for most use cases.
    public static let `default` = MultiThumbSliderConfiguration()
    
    /// Compact configuration with smaller track and thumbs.
    /// Ideal for tight UI spaces.
    public static let compact = MultiThumbSliderConfiguration(
        trackHeight: 4,
        thumbSize: 18,
        thumbBorderWidth: 1,
        labelFontSize: 10
    )
    
    /// Large configuration with bigger thumbs and track.
    /// Better for touch-friendly interfaces.
    public static let large = MultiThumbSliderConfiguration(
        trackHeight: 8,
        thumbSize: 32,
        thumbBorderWidth: 3,
        labelFontSize: 14
    )
    
    /// Minimal configuration with thin track and no labels.
    /// Clean, understated appearance.
    public static let minimal = MultiThumbSliderConfiguration(
        trackHeight: 2,
        thumbSize: 16,
        thumbBorderWidth: 0,
        showLabels: false
    )
    
    /// Vibrant configuration with colorful gradient and glow.
    /// Eye-catching, premium appearance.
    public static let vibrant = MultiThumbSliderConfiguration(
        trackHeight: 6,
        thumbSize: 26,
        activeTrackColors: [.cyan, .blue, .purple],
        thumbBorderColor: .cyan,
        thumbShadowRadius: 8
    )
}

// MARK: - Multi-Thumb Slider

/// A range slider with multiple draggable thumbs for selecting value ranges.
///
/// `MultiThumbSlider` allows users to select a range by dragging two or more
/// thumb controls along a track. The active range between thumbs is highlighted
/// with a gradient.
///
/// ## Features
/// - **Multiple Thumbs**: Support for 2+ thumbs to define complex ranges
/// - **Gradient Track**: Active range highlighted with customizable gradient
/// - **Value Labels**: Optional labels showing current values above thumbs
/// - **Haptic Feedback**: Tactile feedback on drag and boundary hits
/// - **Step Values**: Snap to discrete step increments
/// - **Smooth Animation**: Spring-based thumb movement
/// - **Callbacks**: Handlers for drag start, change, and end events
///
/// ## Example
/// ```swift
/// @State var priceRange = [100.0, 500.0]
///
/// // Basic usage
/// MultiThumbSlider(values: $priceRange, range: 0...1000)
///
/// // With configuration
/// MultiThumbSlider(
///     values: $priceRange,
///     range: 0...1000,
///     step: 50,
///     configuration: .vibrant
/// )
///
/// // Convenience parameters
/// MultiThumbSlider(
///     values: $priceRange,
///     range: 0...1000,
///     showLabels: true,
///     colors: [.green, .blue]
/// )
/// ```
///
/// ## Callbacks
/// ```swift
/// MultiThumbSlider(values: $range)
///     .onValueChange { newValues in
///         print("Range: \(newValues[0]) - \(newValues[1])")
///     }
///     .onDragStart { thumbIndex in
///         print("Started dragging thumb \(thumbIndex)")
///     }
///     .onDragEnd { thumbIndex in
///         print("Stopped dragging thumb \(thumbIndex)")
///     }
/// ```
public struct MultiThumbSlider: View {
    @Binding private var values: [Double]
    private let range: ClosedRange<Double>
    private let step: Double
    private var configuration: MultiThumbSliderConfiguration
    
    // Callbacks
    private var onValueChange: (([Double]) -> Void)?
    private var onDragStart: ((Int) -> Void)?
    private var onDragEnd: ((Int) -> Void)?
    
    @State private var activeThumb: Int? = nil
    @State private var lastHapticValue: [Double] = []
    
    public init(
        values: Binding<[Double]>,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1,
        configuration: MultiThumbSliderConfiguration = .default
    ) {
        self._values = values
        self.range = range
        self.step = step
        self.configuration = configuration
    }
    
    // Convenience initializer with common parameters
    public init(
        values: Binding<[Double]>,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1,
        showLabels: Bool = true,
        colors: [Color]? = nil
    ) {
        self._values = values
        self.range = range
        self.step = step
        var config = MultiThumbSliderConfiguration()
        config.showLabels = showLabels
        if let colors = colors {
            config.activeTrackColors = colors
        }
        self.configuration = config
    }
    
    private func normalizedPosition(for value: Double) -> Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    private func valueForPosition(_ position: Double) -> Double {
        let rawValue = range.lowerBound + position * (range.upperBound - range.lowerBound)
        let steppedValue = (rawValue / step).rounded() * step
        return min(max(steppedValue, range.lowerBound), range.upperBound)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(configuration.trackColor.opacity(configuration.trackOpacity))
                    .frame(height: configuration.trackHeight)
                
                // Active track (between thumbs for range slider)
                if values.count >= 2 {
                    let sortedValues = values.sorted()
                    let startX = geometry.size.width * normalizedPosition(for: sortedValues[0])
                    let endX = geometry.size.width * normalizedPosition(for: sortedValues[1])
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: configuration.activeTrackColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: endX - startX, height: configuration.trackHeight)
                        .offset(x: startX)
                } else if values.count == 1 {
                    // Single thumb - fill from start
                    let endX = geometry.size.width * normalizedPosition(for: values[0])
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: configuration.activeTrackColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: endX, height: configuration.trackHeight)
                }
                
                // Thumbs
                ForEach(values.indices, id: \.self) { index in
                    ThumbView(
                        value: values[index],
                        isActive: activeThumb == index,
                        configuration: configuration,
                        showLabel: configuration.showLabels
                    )
                    .position(
                        x: geometry.size.width * normalizedPosition(for: values[index]),
                        y: geometry.size.height / 2
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if activeThumb != index {
                                    activeThumb = index
                                    onDragStart?(index)
                                    if configuration.enableHaptics {
                                        TactileFeedback.light()
                                    }
                                }
                                
                                let position = gesture.location.x / geometry.size.width
                                let clampedPosition = min(max(position, 0), 1)
                                let newValue = valueForPosition(clampedPosition)
                                
                                // Ensure values don't cross each other
                                var constrainedValue = newValue
                                if values.count > 1 {
                                    if index == 0 {
                                        constrainedValue = min(newValue, values[1] - step)
                                    } else if index == 1 {
                                        constrainedValue = max(newValue, values[0] + step)
                                    }
                                }
                                
                                if values[index] != constrainedValue {
                                    values[index] = constrainedValue
                                    onValueChange?(values)
                                    
                                    // Haptic on step change
                                    if configuration.enableHaptics && configuration.hapticOnChange {
                                        TactileFeedback.light()
                                    }
                                    
                                    // Haptic on boundary
                                    if configuration.enableHaptics && configuration.hapticOnBoundary {
                                        if constrainedValue == range.lowerBound || constrainedValue == range.upperBound {
                                            TactileFeedback.medium()
                                        }
                                    }
                                }
                            }
                            .onEnded { _ in
                                onDragEnd?(activeThumb ?? index)
                                activeThumb = nil
                                if configuration.enableHaptics {
                                    TactileFeedback.light()
                                }
                            }
                    )
                }
            }
            .frame(height: max(configuration.thumbSize, configuration.trackHeight))
        }
        .frame(height: configuration.thumbSize + (configuration.showLabels ? 30 : 0))
    }
    
    // Modifier methods
    public func onValueChange(_ action: @escaping ([Double]) -> Void) -> MultiThumbSlider {
        var copy = self
        copy.onValueChange = action
        return copy
    }
    
    public func onDragStart(_ action: @escaping (Int) -> Void) -> MultiThumbSlider {
        var copy = self
        copy.onDragStart = action
        return copy
    }
    
    public func onDragEnd(_ action: @escaping (Int) -> Void) -> MultiThumbSlider {
        var copy = self
        copy.onDragEnd = action
        return copy
    }
    
    public func colors(_ colors: [Color]) -> MultiThumbSlider {
        var copy = self
        copy.configuration.activeTrackColors = colors
        return copy
    }
    
    public func thumbSize(_ size: CGFloat) -> MultiThumbSlider {
        var copy = self
        copy.configuration.thumbSize = size
        return copy
    }
    
    public func trackHeight(_ height: CGFloat) -> MultiThumbSlider {
        var copy = self
        copy.configuration.trackHeight = height
        return copy
    }
    
    public func showLabels(_ show: Bool) -> MultiThumbSlider {
        var copy = self
        copy.configuration.showLabels = show
        return copy
    }
    
    public func haptics(_ enabled: Bool, onChange: Bool = false, onBoundary: Bool = true) -> MultiThumbSlider {
        var copy = self
        copy.configuration.enableHaptics = enabled
        copy.configuration.hapticOnChange = onChange
        copy.configuration.hapticOnBoundary = onBoundary
        return copy
    }
}

// MARK: - Thumb View

private struct ThumbView: View {
    let value: Double
    let isActive: Bool
    let configuration: MultiThumbSliderConfiguration
    let showLabel: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            if showLabel {
                Text("\(Int(value))")
                    .font(.system(size: configuration.labelFontSize, weight: .medium))
                    .foregroundColor(configuration.labelColor)
                    .opacity(isActive ? 1 : 0.7)
            }
            
            Circle()
                .fill(configuration.thumbColor)
                .frame(width: configuration.thumbSize, height: configuration.thumbSize)
                .overlay(
                    Circle()
                        .stroke(
                            isActive 
                                ? configuration.thumbBorderColor 
                                : configuration.thumbBorderColor.opacity(0.5),
                            lineWidth: configuration.thumbBorderWidth
                        )
                )
                .shadow(
                    color: configuration.thumbShadowColor.opacity(isActive ? 0.4 : 0.2),
                    radius: isActive ? configuration.thumbShadowRadius * 1.5 : configuration.thumbShadowRadius,
                    y: 2
                )
                .scaleEffect(isActive ? 1.15 : 1.0)
                .animation(
                    .spring(response: configuration.animationResponse, dampingFraction: configuration.animationDamping),
                    value: isActive
                )
        }
    }
}


