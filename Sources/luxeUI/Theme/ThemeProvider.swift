import SwiftUI

// MARK: - Theme Provider Configuration

/// Configuration options for the theme provider component.
///
/// `ThemeProviderConfiguration` controls how themes are applied and
/// animated when switching between themes.
///
/// ## Presets
/// - `default`: Animated theme transitions (0.3s)
/// - `instant`: No animation, immediate theme changes
/// - `smooth`: Slower animation (0.5s) for dramatic transitions
///
/// ## Example
/// ```swift
/// ThemeProvider(configuration: .smooth) {
///     ContentView()
/// }
/// ```
public struct ThemeProviderConfiguration: Sendable {
    /// The theme to provide to children. Default: .default
    public var theme: Theme
    /// Whether theme changes should animate. Default: true
    public var animated: Bool
    /// Duration of theme transition animation. Default: 0.3
    public var animationDuration: Double
    /// Whether theme propagates to all children. Default: true
    public var propagateToChildren: Bool
    
    public init(
        theme: Theme = .default,
        animated: Bool = true,
        animationDuration: Double = 0.3,
        propagateToChildren: Bool = true
    ) {
        self.theme = theme
        self.animated = animated
        self.animationDuration = animationDuration
        self.propagateToChildren = propagateToChildren
    }
    
    // MARK: - Presets
    
    /// Default configuration with animated transitions.
    public static let `default` = ThemeProviderConfiguration()
    
    /// Instant theme changes with no animation.
    public static let instant = ThemeProviderConfiguration(animated: false)
    
    /// Smooth transitions with longer animation duration.
    public static let smooth = ThemeProviderConfiguration(
        animationDuration: 0.5
    )
}

// MARK: - Theme Provider

/// A container view that provides theme context to its children.
///
/// `ThemeProvider` wraps content and injects a theme into the environment,
/// with optional animated transitions between themes.
///
/// ## Features
/// - **Environment Injection**: Theme flows to all child views
/// - **Animated Transitions**: Smooth theme switching
/// - **Modifier Chain**: Fluent API for configuration
///
/// ## Example
/// ```swift
/// // Basic usage
/// ThemeProvider(theme: .midnight) {
///     ContentView()
/// }
///
/// // With configuration
/// ThemeProvider(configuration: .smooth) {
///     ContentView()
/// }
///     .theme(.ocean)
///
/// // Modifier chain
/// ThemeProvider {
///     ContentView()
/// }
///     .theme(.sunset)
///     .animated(true)
///     .animationDuration(0.4)
/// ```
public struct ThemeProvider<Content: View>: View {
    private var configuration: ThemeProviderConfiguration
    private let content: Content
    
    public init(
        configuration: ThemeProviderConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    public init(
        theme: Theme,
        animated: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = ThemeProviderConfiguration(theme: theme, animated: animated)
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.luxeTheme, configuration.theme)
            .animation(
                configuration.animated
                    ? .easeInOut(duration: configuration.animationDuration)
                    : nil,
                value: configuration.theme.primaryColor.description
            )
    }
    
    // MARK: - Modifier Methods
    
    public func theme(_ theme: Theme) -> ThemeProvider {
        var copy = self
        copy.configuration.theme = theme
        return copy
    }
    
    public func animated(_ value: Bool) -> ThemeProvider {
        var copy = self
        copy.configuration.animated = value
        return copy
    }
    
    public func animationDuration(_ duration: Double) -> ThemeProvider {
        var copy = self
        copy.configuration.animationDuration = duration
        return copy
    }
}

// MARK: - Dynamic Theme Provider

/// A theme provider that supports reactive theme switching via a binding.
///
/// `DynamicThemeProvider` is ideal for apps that allow users to change
/// themes at runtime, as it responds to binding changes automatically.
///
/// ## Example
/// ```swift
/// struct SettingsView: View {
///     @State var theme = Theme.midnight
///
///     var body: some View {
///         DynamicThemeProvider(theme: $theme) {
///             VStack {
///                 ContentView()
///                 ThemePicker(selection: $themePreset)
///             }
///         }
///     }
/// }
/// ```
public struct DynamicThemeProvider<Content: View>: View {
    @Binding private var currentTheme: Theme
    private var animated: Bool
    private var animationDuration: Double
    private let content: Content
    
    public init(
        theme: Binding<Theme>,
        animated: Bool = true,
        animationDuration: Double = 0.3,
        @ViewBuilder content: () -> Content
    ) {
        self._currentTheme = theme
        self.animated = animated
        self.animationDuration = animationDuration
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.luxeTheme, currentTheme)
            .animation(
                animated ? .easeInOut(duration: animationDuration) : nil,
                value: currentTheme.primaryColor.description
            )
    }
}

// MARK: - Theme Picker

/// A horizontal picker for selecting theme presets.
///
/// `ThemePicker` displays all available theme presets as colored buttons,
/// allowing users to switch themes visually.
///
/// ## Features
/// - **Visual Preview**: Shows primary color for each theme
/// - **Selection Indicator**: Ring around selected theme
/// - **Optional Labels**: Theme names below buttons
/// - **Horizontal Scroll**: Scrollable when many themes
///
/// ## Example
/// ```swift
/// @State var preset: ThemePreset = .default
///
/// ThemePicker(selection: $preset)
///     .padding()
/// ```
public struct ThemePicker: View {
    @Binding private var selectedPreset: ThemePreset
    private var showLabels: Bool
    private var itemSize: CGFloat
    
    public init(
        selection: Binding<ThemePreset>,
        showLabels: Bool = true,
        itemSize: CGFloat = 40
    ) {
        self._selectedPreset = selection
        self.showLabels = showLabels
        self.itemSize = itemSize
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ThemePreset.allCases, id: \.rawValue) { preset in
                    ThemePresetButton(
                        preset: preset,
                        isSelected: selectedPreset == preset,
                        showLabel: showLabels,
                        size: itemSize
                    ) {
                        selectedPreset = preset
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Theme Preset Button

private struct ThemePresetButton: View {
    let preset: ThemePreset
    let isSelected: Bool
    let showLabel: Bool
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [preset.theme.primaryColor, preset.theme.secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size, height: size)
                    
                    if isSelected {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: size + 6, height: size + 6)
                    }
                }
                
                if showLabel {
                    Text(preset.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white : .gray)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Theme-Aware Components

/// A text view that automatically uses theme colors
public struct ThemedText: View {
    @Environment(\.luxeTheme) private var theme
    
    private let text: String
    private var style: TextStyle
    private var customColor: Color?
    
    public enum TextStyle {
        case body
        case headline
        case caption
        case display
    }
    
    public init(_ text: String, style: TextStyle = .body) {
        self.text = text
        self.style = style
    }
    
    public var body: some View {
        Text(text)
            .font(fontForStyle)
            .foregroundColor(customColor ?? colorForStyle)
    }
    
    private var fontForStyle: Font {
        switch style {
        case .body: return .system(size: theme.typography.fontSizeM)
        case .headline: return .system(size: theme.typography.fontSizeXL, weight: .bold)
        case .caption: return .system(size: theme.typography.fontSizeS)
        case .display: return .system(size: theme.typography.fontSizeDisplay, weight: .bold)
        }
    }
    
    private var colorForStyle: Color {
        switch style {
        case .body, .display: return theme.textColor
        case .headline: return theme.textColor
        case .caption: return theme.textSecondaryColor
        }
    }
    
    // MARK: - Modifiers
    
    public func foregroundColor(_ color: Color) -> ThemedText {
        var copy = self
        copy.customColor = color
        return copy
    }
}

/// A background view that uses theme colors
public struct ThemedBackground<Content: View>: View {
    @Environment(\.luxeTheme) private var theme
    
    private let content: Content
    private var useSurface: Bool
    
    public init(
        useSurface: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.useSurface = useSurface
        self.content = content()
    }
    
    public var body: some View {
        content
            .background(useSurface ? theme.surfaceColor : theme.backgroundColor)
    }
}
