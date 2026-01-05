import SwiftUI

// MARK: - Liquid Button Configuration

/// Configuration options for the LiquidButton component.
public struct LiquidButtonConfiguration: Sendable {
    public var colors: [Color]
    public var morphIntensity: CGFloat
    public var speed: Double
    public var cornerRadius: CGFloat
    public var textColor: Color
    public var font: Font
    public var scaleOnPress: CGFloat
    
    public init(
        colors: [Color] = [.blue, .purple],
        morphIntensity: CGFloat = 0.3,
        speed: Double = 1.0,
        cornerRadius: CGFloat = 16,
        textColor: Color = .white,
        font: Font = .headline,
        scaleOnPress: CGFloat = 0.95
    ) {
        self.colors = colors
        self.morphIntensity = morphIntensity
        self.speed = speed
        self.cornerRadius = cornerRadius
        self.textColor = textColor
        self.font = font
        self.scaleOnPress = scaleOnPress
    }
    
    public static let `default` = LiquidButtonConfiguration()
    public static let neon = LiquidButtonConfiguration(colors: [.cyan, .blue], morphIntensity: 0.5, speed: 1.5)
    public static let lava = LiquidButtonConfiguration(colors: [.orange, .red], morphIntensity: 0.4, speed: 0.8)
}

// MARK: - Liquid Button Component

/// A button with an animated, morphing liquid background.
///
/// `LiquidButton` uses `LiquidBlob` as a background layer, clipped to a
/// rounded rectangle shape. It provides haptic feedback and scale animations on press.
///
/// ## Example
/// ```swift
/// LiquidButton("Press Me", action: {
///     print("Tapped!")
/// })
/// ```
public struct LiquidButton: View {
    private let title: String
    private let icon: String?
    private let action: () -> Void
    private let configuration: LiquidButtonConfiguration
    
    @State private var isPressed: Bool = false
    
    public init(
        _ title: String,
        icon: String? = nil,
        configuration: LiquidButtonConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.configuration = configuration
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(configuration.font)
            .foregroundColor(configuration.textColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    // Liquid Animation Background
                    LiquidBlob(
                        colors: configuration.colors,
                        size: 300, // Large enough to cover button
                        configuration: LiquidBlobConfiguration(
                            animationDuration: 5.0 / configuration.speed,
                            morphIntensity: configuration.morphIntensity,
                            pulseScale: 1.05,
                            rotationEnabled: true,
                            blurRadius: 10
                        )
                    )
                    .frame(width: 200, height: 100)
                    .mask(
                        RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    )
                    
                    // Glass Overlay
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
            )
        }
        .buttonStyle(DisplayButtonStyle(scaleOnPress: configuration.scaleOnPress))
    }
}

// Custom Button Style for Animation
struct DisplayButtonStyle: ButtonStyle {
    let scaleOnPress: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleOnPress : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    TactileFeedback.light()
                }
            }
    }
}

// MARK: - Preview

#if DEBUG
struct LiquidButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                LiquidButton("Default Button") {}
                
                LiquidButton(
                    "Neon Style",
                    icon: "sparkles",
                    configuration: .neon
                ) {}
                
                LiquidButton(
                    "Lava Style",
                    configuration: .lava
                ) {}
            }
        }
    }
}
#endif
