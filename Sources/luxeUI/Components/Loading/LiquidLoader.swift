import SwiftUI

// MARK: - Liquid Loader Configuration

/// Configuration options for the LiquidLoader component.
public struct LiquidLoaderConfiguration: Sendable {
    public var circleCount: Int
    public var speed: Double
    public var blobColor: Color
    public var blurRadius: CGFloat
    public var scaleEffect: CGFloat
    
    public init(
        circleCount: Int = 5,
        speed: Double = 1.0,
        blobColor: Color = .blue,
        blurRadius: CGFloat = 10,
        scaleEffect: CGFloat = 1.0
    ) {
        self.circleCount = circleCount
        self.speed = speed
        self.blobColor = blobColor
        self.blurRadius = blurRadius
        self.scaleEffect = scaleEffect
    }
    
    public static let `default` = LiquidLoaderConfiguration()
    public static let fast = LiquidLoaderConfiguration(speed: 2.0)
    public static let slow = LiquidLoaderConfiguration(speed: 0.5)
    public static let gooey = LiquidLoaderConfiguration(blurRadius: 15, scaleEffect: 1.2)
}

// MARK: - Liquid Loader Component

/// A loading indicator that uses a "gooey" liquid effect.
///
/// `LiquidLoader` animates multiple circles orbiting a center point.
/// It uses a blur and threshold technique (alpha threshold) to make the circles
/// appear to merge like liquid when they overlap.
///
/// ## Example
/// ```swift
/// LiquidLoader(configuration: .default)
///     .frame(width: 100, height: 100)
/// ```
public struct LiquidLoader: View {
    private let configuration: LiquidLoaderConfiguration
    @State private var rotation: Double = 0
    
    public init(configuration: LiquidLoaderConfiguration = .default) {
        self.configuration = configuration
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                // Add blur filter to the entire layer to create the "goo" base
                context.addFilter(.alphaThreshold(min: 0.5, color: configuration.blobColor))
                context.addFilter(.blur(radius: configuration.blurRadius))
                
                // Draw symbols
                context.drawLayer { ctx in
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let radius = min(size.width, size.height) / 3
                    
                    for i in 0..<configuration.circleCount {
                        let angle = (Double(i) / Double(configuration.circleCount)) * 2 * .pi
                        let timeOffset = timeline.date.timeIntervalSinceReferenceDate * configuration.speed
                        
                        // Calculate position with orbital movement
                        let currentAngle = angle + timeOffset
                        let x = center.x + cos(currentAngle) * radius
                        let y = center.y + sin(currentAngle) * radius
                        
                        // Draw individual blobs
                        let blobSize = CGSize(
                            width: size.width / 5 * configuration.scaleEffect,
                            height: size.height / 5 * configuration.scaleEffect
                        )
                        
                        // Pulsing effect calculation
                        let pulse = sin(timeOffset * 2 + Double(i)) * 0.2 + 1.0
                         let pulsedSize = CGSize(
                            width: blobSize.width * pulse,
                            height: blobSize.height * pulse
                        )
                        
                        let rect = CGRect(
                            x: x - pulsedSize.width / 2,
                            y: y - pulsedSize.height / 2,
                            width: pulsedSize.width,
                            height: pulsedSize.height
                        )
                        
                        ctx.fill(Circle().path(in: rect), with: .color(.white))
                    }
                    
                    // Draw center anchor blob
                    let centerBlobSize = CGSize(
                        width: size.width / 4,
                        height: size.height / 4
                    )
                    let centerRect = CGRect(
                        x: center.x - centerBlobSize.width / 2,
                        y: center.y - centerBlobSize.height / 2,
                        width: centerBlobSize.width,
                        height: centerBlobSize.height
                    )
                    ctx.fill(Circle().path(in: centerRect), with: .color(.white))
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct LiquidLoader_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 50) {
                LiquidLoader(configuration: .default)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                LiquidLoader(configuration: LiquidLoaderConfiguration(
                    circleCount: 3,
                    speed: 1.5,
                    blobColor: .green,
                    blurRadius: 8
                ))
                .frame(width: 100, height: 100)
                
                 LiquidLoader(configuration: LiquidLoaderConfiguration(
                    circleCount: 8,
                    speed: 0.5,
                    blobColor: .orange,
                    blurRadius: 12
                ))
                .frame(width: 150, height: 150)
            }
        }
    }
}
#endif
