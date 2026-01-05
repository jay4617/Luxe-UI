import SwiftUI

// MARK: - LuxeSlider Configuration

public struct LuxeSliderConfiguration: Sendable {
    public var trackHeight: CGFloat
    public var thumbSize: CGFloat
    public var trackColor: Color
    public var activeTrackColor: Color // Single color or gradient handled by view
    public var thumbColor: Color
    public var enableHaptics: Bool
    public var showValueLabel: Bool
    
    public init(
        trackHeight: CGFloat = 6,
        thumbSize: CGFloat = 24,
        trackColor: Color = .gray.opacity(0.3),
        activeTrackColor: Color = .blue,
        thumbColor: Color = .white,
        enableHaptics: Bool = true,
        showValueLabel: Bool = false
    ) {
        self.trackHeight = trackHeight
        self.thumbSize = thumbSize
        self.trackColor = trackColor
        self.activeTrackColor = activeTrackColor
        self.thumbColor = thumbColor
        self.enableHaptics = enableHaptics
        self.showValueLabel = showValueLabel
    }
    
    public static let `default` = LuxeSliderConfiguration()
}

// MARK: - LuxeSlider

/// A continuous single-value slider with premium feel.
public struct LuxeSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double
    var configuration: LuxeSliderConfiguration
    
    @State private var isDragging: Bool = false
    
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1,
        configuration: LuxeSliderConfiguration = .default
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.configuration = configuration
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track Background
                Capsule()
                    .fill(configuration.trackColor)
                    .frame(height: configuration.trackHeight)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                // Tap/Click to seek
                                let progress = value.location.x / geometry.size.width
                                updateValue(progress: progress)
                                if configuration.enableHaptics {
                                    TactileFeedback.light()
                                }
                            }
                    )
                
                // Active Track
                let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
                Capsule()
                    .fill(configuration.activeTrackColor)
                    .frame(width: max(0, min(geometry.size.width * progress, geometry.size.width)), height: configuration.trackHeight)
                    .allowsHitTesting(false) // Let touches pass to track
                
                // Thumb
                Circle()
                    .fill(configuration.thumbColor)
                    .shadow(radius: isDragging ? 4 : 2, y: 2)
                    .frame(width: configuration.thumbSize, height: configuration.thumbSize)
                    .overlay(
                        Circle().strokeBorder(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .scaleEffect(isDragging ? 1.1 : 1.0)
                    .offset(x: (geometry.size.width - configuration.thumbSize) * progress)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !isDragging {
                                    isDragging = true
                                    if configuration.enableHaptics {
                                        TactileFeedback.light()
                                    }
                                }
                                let location = value.location.x
                                let newProgress = location / geometry.size.width
                                updateValue(progress: newProgress)
                            }
                            .onEnded { _ in
                                isDragging = false
                                if configuration.enableHaptics {
                                    TactileFeedback.light()
                                }
                            }
                    )
                
                // Floating Label
                if configuration.showValueLabel && isDragging {
                    Text(String(format: "%.0f", value))
                        .font(.caption.bold())
                        .padding(6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .offset(x: ((geometry.size.width - configuration.thumbSize) * progress) - 10, y: -40)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(height: max(configuration.trackHeight, configuration.thumbSize))
        }
        .frame(height: max(configuration.trackHeight, configuration.thumbSize))
    }
    
    private func updateValue(progress: Double) {
        let clampedProgress = max(0, min(1, progress))
        let rawValue = range.lowerBound + (clampedProgress * (range.upperBound - range.lowerBound))
        
        // Snap to step
        let steppedValue = round(rawValue / step) * step
        let finalValue = max(range.lowerBound, min(range.upperBound, steppedValue))
        
        if value != finalValue {
            value = finalValue
            if configuration.enableHaptics && isDragging {
                TactileFeedback.light() // Use light instead of selection
            }
        }
    }
}
