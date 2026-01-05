import SwiftUI
import LuxeUI

@main
struct LiquidUIDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1000, idealWidth: 1200, minHeight: 800)
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct ContentView: View {
    @State private var progress: Double = 0.4
    @State private var pulseState: Bool = false
    
    var body: some View {
        ZStack {
            // Animated Liquid Background
            // Performant Background
            MeshGradientBackground(
                colors: [
                    Color(red: 0.1, green: 0.05, blue: 0.2),
                    Color(red: 0.0, green: 0.0, blue: 0.1),
                    Color(red: 0.05, green: 0.1, blue: 0.3)
                ]
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 50) {
                    // Header
                    VStack(spacing: 16) {
                        Text("LuxeUI Liquid")
                            .font(.system(size: 64, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cyan, .blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .blue.opacity(0.5), radius: 20)
                        
                        Text("Living Interface Components")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 60)
                    
                    // Liquid Loaders
                    VStack(alignment: .leading, spacing: 30) {
                        SectionHeader(title: "Liquid Loaders", subtitle: "Organic merging animations")
                        
                        GlassmorphismContainer(configuration: .frosted) {
                            HStack(spacing: 60) {
                                VStack {
                                    LiquidLoader(configuration: .default)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.cyan)
                                    Text("Default")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                VStack {
                                    LiquidLoader(configuration: .gooey)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.purple)
                                    Text("Gooey")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                VStack {
                                    LiquidLoader(configuration: LiquidLoaderConfiguration(circleCount: 8, speed: 2.0, blobColor: .orange))
                                        .frame(width: 100, height: 100)
                                    Text("Fast & Intense")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding(40)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Liquid Buttons
                    VStack(alignment: .leading, spacing: 30) {
                        SectionHeader(title: "Liquid Buttons", subtitle: "Interactive morphing backgrounds")
                        
                        GlassmorphismContainer(configuration: .frosted) {
                            HStack(spacing: 60) {
                                LiquidButton("Get Started", action: { print("Started") })
                                
                                LiquidButton(
                                    "Premium Access",
                                    icon: "crown.fill",
                                    configuration: .neon,
                                    action: { print("Premium") }
                                )
                                
                                LiquidButton(
                                    "Danger Zone",
                                    icon: "exclamationmark.triangle.fill",
                                    configuration: .lava,
                                    action: { print("Danger") }
                                )
                            }
                            .padding(40)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Liquid Progress
                    VStack(alignment: .leading, spacing: 30) {
                        SectionHeader(title: "Liquid Progress", subtitle: "Wave-based fill animation")
                        
                        GlassmorphismContainer(configuration: .frosted) {
                            VStack(spacing: 40) {
                                LiquidProgress(progress: progress, configuration: .large)
                                    .overlay(
                                        Text("\(Int(progress * 100))%")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .shadow(radius: 2)
                                    )
                                
                                LiquidProgress(progress: progress, configuration: .ocean)
                                
                                HStack {
                                    Button(action: { withAnimation { progress = max(0, progress - 0.1) } }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Spacer()
                                    
                                    Button(action: { withAnimation { progress = min(1, progress + 0.1) } }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal)
                            }
                            .padding(40)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Blobs Showcase
                    VStack(alignment: .leading, spacing: 30) {
                        SectionHeader(title: "Liquid Blobs", subtitle: "Decorative morphing elements")
                        
                        HStack(spacing: 40) {
                            LiquidBlob(colors: [.blue, .cyan], size: 200, configuration: .default)
                            LiquidBlob(colors: [.purple, .pink], size: 200, configuration: .pulsing)
                            LiquidBlob(colors: [.green, .mint], size: 200, configuration: .intense)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.title3)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}
