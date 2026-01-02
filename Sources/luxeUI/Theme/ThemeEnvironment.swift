import SwiftUI

// MARK: - Environment Key

/// Environment key for storing the current LuxeUI theme.
private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .default
}

public extension EnvironmentValues {
    /// The current LuxeUI theme in the environment.
    var luxeTheme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - Theme Modifier

/// A view modifier that injects a theme into the environment.
///
/// This modifier is typically used via the `.luxeTheme()` view extension
/// rather than being applied directly.
public struct ThemeModifier: ViewModifier {
    private let theme: Theme
    
    public init(theme: Theme) {
        self.theme = theme
    }
    
    public func body(content: Content) -> some View {
        content
            .environment(\.luxeTheme, theme)
    }
}

// MARK: - View Extension

public extension View {
    /// Apply a LuxeUI theme to this view and all its children.
    ///
    /// The theme flows down through the view hierarchy and is automatically
    /// picked up by all LuxeUI components.
    ///
    /// ## Example
    /// ```swift
    /// ContentView()
    ///     .luxeTheme(.midnight)
    /// ```
    func luxeTheme(_ theme: Theme) -> some View {
        modifier(ThemeModifier(theme: theme))
    }
    
    /// Apply a preset theme using the ThemePreset enum.
    ///
    /// ## Example
    /// ```swift
    /// ContentView()
    ///     .luxeTheme(.ocean)
    /// ```
    func luxeTheme(_ preset: ThemePreset) -> some View {
        modifier(ThemeModifier(theme: preset.theme))
    }
}

// MARK: - Theme Reader

/// A view that reads the current theme from the environment.
///
/// Use `ThemeReader` when you need to access theme values in custom views
/// that aren't LuxeUI components.
///
/// ## Example
/// ```swift
/// ThemeReader { theme in
///     Text("Custom Component")
///         .foregroundColor(theme.primaryColor)
///         .font(.system(size: theme.typography.body))
/// }
/// ```
public struct ThemeReader<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    private let content: (Theme) -> Content
    
    public init(@ViewBuilder content: @escaping (Theme) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(theme)
    }
}
