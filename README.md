# LuxeUI ✨

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2015%2B%20%7C%20macOS%2012%2B-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Swift-5.9%2B-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/SwiftUI-Native-purple.svg" alt="SwiftUI">
</p>

<p align="center">
  <img src="https://github.com/Ronitsabhaya75/Luxe-UI/actions/workflows/swift.yml/badge.svg" alt="Swift CI">
  <img src="https://github.com/Ronitsabhaya75/Luxe-UI/actions/workflows/tests.yml/badge.svg" alt="Tests">
</p>

<p align="center">
  <strong>The Premium SwiftUI Component Library for 2026</strong>
</p>

---

A beautiful, production-ready SwiftUI component library featuring refractive glass effects, intelligent interactions, and a powerful theme system.

## ✨ Highlights

- **Refractive Glass Effects** - Real lens warping, not just blur
- **Intelligent Interactions** - Magnetic pull, smart springs, predictive layouts
- **Theme System** - Global design tokens that flow to all components
- **Smooth Animations** - 60 FPS physics-based motion
- **Zero Dependencies** - Pure SwiftUI

## 🚀 Quick Install

```swift
import LuxeUI

LuxeCard {
    VStack(spacing: 12) {
        Image(systemName: "sparkles")
            .font(.system(size: 40))
        Text("Premium")
            .font(.headline)
        Text("Hover me!")
            .font(.caption)
    }
}
```

**Features:**
- Hover scale animation
- Shimmer gradient overlay
- Glowing border effects
- Smooth spring animations

#### 1.5. **Refractive Glass** - The 2026 Signature Effect ⭐
Physical lens-warping effect that actually distorts the background like real liquid glass.

```swift
// Simple modifier
VStack {
    Text("Premium Content")
}
.padding()
.refractiveGlass(intensity: 0.2)

// Or use the card component
RefractiveGlassCard(
    distortionIntensity: 0.25,
    chromaticAberration: true
) {
    VStack {
        Image(systemName: "wand.and.stars")
            .font(.largeTitle)
        Text("Liquid Glass")
    }
}
```

**Unique Features:**
- Real lens distortion at edges (not just blur!)
- Animated caustic light patterns
- Chromatic aberration (RGB separation)
- Multi-layer refractive depth
- Liquid shimmer animation
-  **Can't be easily built by hand** - this is why developers need LuxeUI!

[ Read the full Refractive Glass implementation guide](REFRACTIVE_GLASS_GUIDE.md)

#### 2. **LuxeButton** - Premium Buttons
Buttons with glass effects, gradients, and haptic feedback.

```swift
LuxeButton("Click Me", style: .primary) {
    print("Tapped!")
}

// Styles available
LuxeButton("Primary", style: .primary) { }
LuxeButton("Secondary", style: .secondary) { }
LuxeButton("Glass", style: .glass) { }
```

**Features:**
- Press animations
- Haptic feedback (iOS)
- Gradient or glass backgrounds
- Shadow effects

#### 3. **MeshGradientBackground** - Animated Backgrounds
Beautiful animated mesh gradients like macOS 15.

```swift
MeshGradientBackground(colors: [.purple, .pink, .blue])
```


**Features:**
- Floating animated orbs
- Smooth continuous animation
- Multiple color support
- Creates depth and atmosphere

#### 4. **CircularProgressBar** - Animated Progress Rings
Animated ring progress indicator with smooth animations.

```swift
CircularProgressBar(
    progress: 0.75,
    showPercentage: true,
    gradient: true,
    size: 160
)

// Size variants
CircularProgressBar.small(progress: 0.5)
CircularProgressBar.medium(progress: 0.65, showPercentage: true)
CircularProgressBar.large(progress: 0.9, showPercentage: true)
```

#### 5. **LuxeBadge** - Glowing Badges
Small badges with glow effects.

```swift
LuxeBadge("Premium UI", color: .purple)
```

#### 6. **Glassmorphism Container**
Modern frosted glass effect with customizable blur and transparency.

```swift
import LuxeUI

GlassmorphismContainer {
    VStack {
        Text("Hello, World!")
        Button("Click Me") { }
    }
}

// Or use the modifier
Text("Glass Effect")
    .glassmorphic()
```

#### 7. **Multi-Thumb Slider**
Slider with multiple draggable thumbs for range selection.

```swift
@State private var values: [Double] = [20, 80]

MultiThumbSlider(
    values: $values,
    range: 0...100,
    showLabels: true
)
```

#### 8. **FloatingOrb** - Animated Glowing Orbs
Atmospheric background elements with pulse animations.

```swift
FloatingOrb(size: 300, color: .purple)
```

---

##  **Visual Effects**

### Advanced Animations
- Spring-based smooth animations
- Hover effects with scale transforms
- Shimmer gradient overlays
- Pulse animations
- Continuous background animations

### Material & Blur
- Ultra-thin material effects
- Radial gradients for depth
- Multi-layer blur effects
- Frosted glass appearance

---

## **Quick Start**

### Swift Package Manager

Add LuxeUI to your project via Swift Package Manager:

1. In Xcode, go to **File → Add Packages...**
2. Enter the repository URL
3. Select your target and add the package

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Ronitsabhaya75/Luxe-UI.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → Enter the repository URL.

## 💡 Basic Usage

```swift
import SwiftUI
import LuxeUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .luxeTheme(.midnight)
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            MeshGradientBackground()
            
            RefractiveGlassCard {
                Text("Hello, LuxeUI!")
                    .font(.title)
            }
        }
    }
}
```

## 📚 Documentation

**All documentation is available in the [`documentation/`](documentation/) folder:**

| Guide | Description |
|-------|-------------|
| [INDEX.md](documentation/INDEX.md) | 📍 Start here - Navigation hub |
| [README.md](documentation/README.md) | Full project overview & features |
| [API.md](documentation/API.md) | Complete API reference |
| [QUICKSTART.md](documentation/QUICKSTART.md) | Get started in 5 minutes |
| [EXAMPLES.md](documentation/EXAMPLES.md) | Code examples & patterns |
| [REFRACTIVE_GLASS.md](documentation/REFRACTIVE_GLASS.md) | Signature glass effect guide |
| [CONTRIBUTING.md](documentation/CONTRIBUTING.md) | Contribution guidelines |
| [TESTING.md](documentation/TESTING.md) | Testing documentation |

## 🛠 Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.9+
- Xcode 15.0+

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---
