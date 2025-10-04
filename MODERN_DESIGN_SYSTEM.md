# Modern Design System for Seal

## 🎨 Overview

This document describes the modern design system implemented for the Seal Video/Audio Downloader application. The design system provides a consistent, beautiful, and accessible user interface across all screens.

---

## 📦 Design Tokens

Design tokens are the foundational building blocks of the design system. They ensure consistency across the application.

### Spacing (`ui/design/Spacing.kt`)

Consistent spacing values for layouts:

```kotlin
val spacing = LocalSpacing.current

spacing.none          // 0dp
spacing.extraSmall    // 4dp
spacing.small         // 8dp
spacing.medium        // 12dp
spacing.default       // 16dp
spacing.large         // 20dp
spacing.extraLarge    // 24dp
spacing.huge          // 32dp
spacing.massive       // 40dp
spacing.colossal      // 48dp
```

**Usage:**
```kotlin
Column(
    modifier = Modifier.padding(spacing.default),
    verticalArrangement = Arrangement.spacedBy(spacing.medium)
) {
    // Content
}
```

### Elevation (`ui/design/Elevation.kt`)

Consistent elevation values for shadows and depth:

```kotlin
val elevation = LocalElevation.current

elevation.none     // 0dp
elevation.level1   // 1dp
elevation.level2   // 2dp
elevation.level3   // 4dp
elevation.level4   // 6dp
elevation.level5   // 8dp
elevation.level6   // 12dp
elevation.level7   // 16dp
elevation.level8   // 24dp
```

**Usage:**
```kotlin
Card(
    modifier = Modifier.shadow(
        elevation = elevation.level5,
        shape = RoundedCornerShape(spacing.large)
    )
) {
    // Content
}
```

### Gradients (`ui/design/Gradients.kt`)

Beautiful gradient effects for modern UI:

```kotlin
// Primary gradient
Gradients.primaryGradient()

// Secondary gradient
Gradients.secondaryGradient()

// Tertiary gradient
Gradients.tertiaryGradient()

// Surface gradients
Gradients.surfaceGradient()
Gradients.backgroundGradient()
Gradients.cardGradient()
Gradients.glassGradient()

// Shimmer effect
Gradients.shimmerGradient(showShimmer = true)
```

**Usage:**
```kotlin
Box(
    modifier = Modifier
        .background(brush = Gradients.primaryGradient())
) {
    // Content
}
```

### Motion (`ui/design/Motion.kt`)

Consistent animation specs:

```kotlin
// Durations
Motion.DURATION_INSTANT     // 50ms
Motion.DURATION_QUICK       // 100ms
Motion.DURATION_SHORT       // 200ms
Motion.DURATION_MEDIUM      // 300ms
Motion.DURATION_LONG        // 400ms
Motion.DURATION_EXTRA_LONG  // 500ms

// Animation specs
Motion.scaleAnimation
Motion.fadeAnimation
Motion.slideAnimation
Motion.springLow
Motion.springMedium
Motion.springHigh
```

**Usage:**
```kotlin
val scale by animateFloatAsState(
    targetValue = if (pressed) 0.95f else 1f,
    animationSpec = Motion.scaleAnimation,
    label = "scale"
)
```

---

## 🎨 Color Scheme

### Light Mode

- **Primary:** Indigo (#6366F1) - Main brand color
- **Secondary:** Cyan (#06B6D4) - Accent color
- **Tertiary:** Purple (#8B5CF6) - Tertiary accent
- **Error:** Red (#EF4444)
- **Background:** Soft White (#FAFAFA)
- **Surface:** White (#FFFFFF)

### Dark Mode (OLED-Optimized)

- **Primary:** Light Indigo (#818CF8)
- **Secondary:** Light Cyan (#22D3EE)
- **Tertiary:** Light Purple (#A78BFA)
- **Error:** Light Red (#F87171)
- **Background:** Very Dark Blue (#0F172A)
- **Surface:** Dark Blue-Gray (#1E293B)

---

## 🧩 Modern Components

### ModernButton

Enhanced button with gradient backgrounds and smooth animations.

```kotlin
ModernButton(
    text = "Download",
    icon = Icons.Outlined.FileDownload,
    style = ModernButtonStyle.Primary,
    size = ModernButtonSize.Medium,
    onClick = { /* Action */ }
)
```

**Styles:**
- `ModernButtonStyle.Primary` - Gradient primary color
- `ModernButtonStyle.Secondary` - Gradient secondary color
- `ModernButtonStyle.Outline` - Surface with outline

**Sizes:**
- `ModernButtonSize.Small` - Compact button
- `ModernButtonSize.Medium` - Standard button
- `ModernButtonSize.Large` - Large button

### ModernCard

Beautiful card component with gradient overlay and press animations.

```kotlin
ModernCard(
    title = "Card Title",
    subtitle = "Optional subtitle",
    icon = Icons.Outlined.Info,
    onClick = { /* Action */ }
) {
    // Card content
    Text("Additional content goes here")
}
```

### ModernTextField

Modern text input with smooth focus animations.

```kotlin
var text by remember { mutableStateOf("") }

ModernTextField(
    value = text,
    onValueChange = { text = it },
    label = "URL",
    placeholder = "Enter video URL",
    leadingIcon = Icons.Outlined.Link,
    supportingText = "Paste a video link to download"
)
```

---

## 📐 Typography

The modern typography system provides clear hierarchy:

- **Display Large:** 57sp, Bold - Hero text
- **Display Medium:** 45sp, Bold - Section headers
- **Display Small:** 36sp, Bold - Page titles
- **Headline Large:** 32sp, SemiBold
- **Headline Medium:** 28sp, SemiBold
- **Headline Small:** 24sp, SemiBold
- **Title Large:** 22sp, SemiBold
- **Title Medium:** 16sp, Medium
- **Title Small:** 14sp, Medium
- **Body Large:** 16sp, Normal
- **Body Medium:** 14sp, Normal
- **Body Small:** 12sp, Normal
- **Label Large:** 14sp, Medium
- **Label Medium:** 12sp, Medium
- **Label Small:** 11sp, Medium

**Usage:**
```kotlin
Text(
    text = "Headline",
    style = MaterialTheme.typography.headlineMedium
)
```

---

## 🔧 Shapes

Modern rounded corners for a softer look:

- **Extra Small:** 4dp - Small chips, tags
- **Small:** 8dp - Buttons, small cards
- **Medium:** 12dp - Standard cards
- **Large:** 16dp - Large cards, bottom sheets
- **Extra Large:** 28dp - Dialogs, modals

---

## ♿ Accessibility

All components follow accessibility best practices:

- **Minimum touch target:** 48dp × 48dp
- **Color contrast:** AA standard (4.5:1 for text)
- **Content descriptions:** All icons have descriptions
- **Focus indicators:** Clear focus states
- **TalkBack support:** Full screen reader support

---

## 🚀 Implementation Guide

### Step 1: Import Design Tokens

```kotlin
import com.junkfood.seal.ui.design.LocalSpacing
import com.junkfood.seal.ui.design.LocalElevation
import com.junkfood.seal.ui.design.Gradients
import com.junkfood.seal.ui.design.Motion
```

### Step 2: Use in Components

```kotlin
@Composable
fun MyScreen() {
    val spacing = LocalSpacing.current
    val elevation = LocalElevation.current
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(spacing.default),
        verticalArrangement = Arrangement.spacedBy(spacing.medium)
    ) {
        ModernCard(
            title = "Download Video",
            subtitle = "High quality downloads"
        ) {
            ModernButton(
                text = "Start Download",
                style = ModernButtonStyle.Primary,
                onClick = { /* Action */ }
            )
        }
    }
}
```

### Step 3: Apply Gradients

```kotlin
Box(
    modifier = Modifier
        .fillMaxWidth()
        .height(200.dp)
        .background(brush = Gradients.primaryGradient())
) {
    // Content with gradient background
}
```

### Step 4: Add Animations

```kotlin
var isExpanded by remember { mutableStateOf(false) }

val size by animateDpAsState(
    targetValue = if (isExpanded) 200.dp else 100.dp,
    animationSpec = Motion.tweenMedium(),
    label = "size"
)
```

---

## 📱 Screen Examples

### Download Page

```kotlin
@Composable
fun DownloadPageModern() {
    val spacing = LocalSpacing.current
    
    Scaffold(
        topBar = {
            // Modern top app bar with gradient
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(spacing.default)
        ) {
            ModernTextField(
                value = url,
                onValueChange = { url = it },
                label = "Video URL",
                placeholder = "Paste link here"
            )
            
            Spacer(modifier = Modifier.height(spacing.large))
            
            ModernButton(
                text = "Download",
                icon = Icons.Outlined.FileDownload,
                style = ModernButtonStyle.Primary,
                size = ModernButtonSize.Large,
                onClick = { /* Start download */ }
            )
        }
    }
}
```

### Settings Page

```kotlin
@Composable
fun SettingsPageModern() {
    val spacing = LocalSpacing.current
    
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(spacing.default),
        verticalArrangement = Arrangement.spacedBy(spacing.medium)
    ) {
        item {
            ModernCard(
                title = "Appearance",
                icon = Icons.Outlined.Palette,
                onClick = { /* Navigate */ }
            )
        }
        
        item {
            ModernCard(
                title = "Download Settings",
                icon = Icons.Outlined.Settings,
                onClick = { /* Navigate */ }
            )
        }
    }
}
```

---

## 🎯 Migration Checklist

For each page/component:

- [ ] Replace hard-coded spacing with `LocalSpacing.current`
- [ ] Replace hard-coded elevations with `LocalElevation.current`
- [ ] Use `Gradients` for backgrounds instead of solid colors
- [ ] Apply `Motion` animation specs for consistency
- [ ] Replace standard components with Modern variants
- [ ] Ensure proper use of MaterialTheme color scheme
- [ ] Test dark/light mode appearance
- [ ] Verify accessibility (touch targets, contrast)
- [ ] Test with TalkBack enabled

---

## 📚 Additional Resources

- **Material 3 Guidelines:** https://m3.material.io/
- **Compose Documentation:** https://developer.android.com/jetpack/compose
- **Accessibility Best Practices:** https://developer.android.com/guide/topics/ui/accessibility

---

## 👥 Contributors

Design system created by **shanib c k** for the Seal project.

---

## 📄 License

This design system follows the same GPL-3.0 license as the Seal project.
