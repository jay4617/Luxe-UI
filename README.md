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
// Package.swift
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
