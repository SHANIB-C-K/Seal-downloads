# 🚀 Quick Reference - Modern Design System

## 📦 Import Once, Use Everywhere

```kotlin
import com.junkfood.seal.ui.design.LocalSpacing
import com.junkfood.seal.ui.design.LocalElevation
import com.junkfood.seal.ui.design.Gradients
import com.junkfood.seal.ui.design.Motion
```

---

## 🎨 Design Tokens

### Spacing
```kotlin
val spacing = LocalSpacing.current

spacing.extraSmall    // 4dp
spacing.small         // 8dp
spacing.medium        // 12dp
spacing.default       // 16dp  ⭐ Most common
spacing.large         // 20dp
spacing.extraLarge    // 24dp
spacing.huge          // 32dp
spacing.massive       // 40dp
spacing.colossal      // 48dp
```

### Elevation
```kotlin
val elevation = LocalElevation.current

elevation.level2      // 2dp  - Buttons pressed
elevation.level4      // 6dp  - Buttons normal
elevation.level5      // 8dp  - Cards
elevation.level6      // 12dp - Floating elements
```

---

## 🎨 Color Usage

```kotlin
// Material Theme Colors (already theme-aware)
MaterialTheme.colorScheme.primary           // Main brand color
MaterialTheme.colorScheme.secondary         // Accent color
MaterialTheme.colorScheme.tertiary          // Tertiary accent
MaterialTheme.colorScheme.error             // Error states
MaterialTheme.colorScheme.surface           // Card backgrounds
MaterialTheme.colorScheme.background        // Screen backgrounds
MaterialTheme.colorScheme.onPrimary         // Text on primary
MaterialTheme.colorScheme.onSurface         // Text on surface
```

---

## 🌈 Gradients

```kotlin
// Primary gradient (Indigo)
.background(brush = Gradients.primaryGradient())

// Secondary gradient (Cyan)
.background(brush = Gradients.secondaryGradient())

// Tertiary gradient (Purple)
.background(brush = Gradients.tertiaryGradient())

// Surface gradient (Subtle)
.background(brush = Gradients.surfaceGradient())

// Card gradient
.background(brush = Gradients.cardGradient())

// Glass effect
.background(brush = Gradients.glassGradient())
```

---

## 🎭 Animations

```kotlin
// Scale animation (for buttons, cards)
val scale by animateFloatAsState(
    targetValue = if (pressed) 0.95f else 1f,
    animationSpec = Motion.scaleAnimation
)

// Color animation (for backgrounds, borders)
val color by animateColorAsState(
    targetValue = if (focused) primary else outline,
    animationSpec = Motion.tweenShort()
)

// Size animation
val size by animateDpAsState(
    targetValue = if (expanded) 200.dp else 100.dp,
    animationSpec = Motion.tweenMedium()
)
```

---

## 🧩 Modern Components

### ModernButton
```kotlin
ModernButton(
    text = "Download",
    icon = Icons.Outlined.FileDownload,
    style = ModernButtonStyle.Primary,   // or Secondary, Outline
    size = ModernButtonSize.Medium,      // or Small, Large
    onClick = { /* action */ }
)
```

### ModernCard
```kotlin
ModernCard(
    title = "Video Title",
    subtitle = "1080p • 42.5 MB",
    icon = Icons.Outlined.VideoFile,
    onClick = { /* action */ }
) {
    // Additional content goes here
    Text("Description or extra info")
}
```

### ModernTextField
```kotlin
var text by remember { mutableStateOf("") }

ModernTextField(
    value = text,
    onValueChange = { text = it },
    label = "Video URL",
    placeholder = "Paste link here...",
    leadingIcon = Icons.Outlined.Link,
    supportingText = "Enter a valid video URL"
)
```

---

## 📐 Layout Patterns

### Standard Page Layout
```kotlin
@Composable
fun MyPage() {
    val spacing = LocalSpacing.current
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(spacing.default),
        verticalArrangement = Arrangement.spacedBy(spacing.medium)
    ) {
        // Page content
    }
}
```

### Card Grid
```kotlin
LazyColumn(
    contentPadding = PaddingValues(spacing.default),
    verticalArrangement = Arrangement.spacedBy(spacing.medium)
) {
    items(myItems) { item ->
        ModernCard(
            title = item.title,
            subtitle = item.subtitle
        )
    }
}
```

### Hero Section
```kotlin
Box(
    modifier = Modifier
        .fillMaxWidth()
        .height(200.dp)
        .background(brush = Gradients.primaryGradient()),
    contentAlignment = Alignment.Center
) {
    Text(
        text = "Seal",
        style = MaterialTheme.typography.displayLarge,
        color = MaterialTheme.colorScheme.onPrimary
    )
}
```

---

## 🎯 Common Patterns

### Rounded Container
```kotlin
Box(
    modifier = Modifier
        .clip(RoundedCornerShape(spacing.large))
        .background(MaterialTheme.colorScheme.surface)
        .padding(spacing.default)
) {
    // Content
}
```

### Elevated Card
```kotlin
Card(
    modifier = Modifier
        .fillMaxWidth()
        .shadow(
            elevation = elevation.level5,
            shape = RoundedCornerShape(spacing.large)
        ),
    shape = RoundedCornerShape(spacing.large)
) {
    // Content
}
```

### Icon Button with Background
```kotlin
Box(
    modifier = Modifier
        .size(spacing.colossal)
        .background(
            color = MaterialTheme.colorScheme.primary.copy(alpha = 0.1f),
            shape = RoundedCornerShape(spacing.medium)
        ),
    contentAlignment = Alignment.Center
) {
    Icon(
        imageVector = Icons.Outlined.Download,
        contentDescription = "Download",
        tint = MaterialTheme.colorScheme.primary
    )
}
```

---

## 📱 Responsive Spacing

### Compact Devices
```kotlin
Column(
    modifier = Modifier.padding(spacing.default),
    verticalArrangement = Arrangement.spacedBy(spacing.small)
)
```

### Medium/Large Devices
```kotlin
Column(
    modifier = Modifier.padding(spacing.large),
    verticalArrangement = Arrangement.spacedBy(spacing.medium)
)
```

---

## ♿ Accessibility

### Minimum Touch Targets
```kotlin
IconButton(
    onClick = { /* action */ },
    modifier = Modifier.size(48.dp)  // Minimum touch target
) {
    Icon(/* ... */)
}
```

### Content Descriptions
```kotlin
Icon(
    imageVector = Icons.Outlined.Download,
    contentDescription = "Download video",  // ✅ Always provide
    tint = MaterialTheme.colorScheme.primary
)
```

### Semantic Labels
```kotlin
Text(
    text = "Settings",
    modifier = Modifier.semantics {
        contentDescription = "Navigate to settings"
    }
)
```

---

## 🎨 Typography Scale

```kotlin
// Display (Hero text)
Text("Seal", style = MaterialTheme.typography.displayLarge)

// Headline (Section headers)
Text("Downloads", style = MaterialTheme.typography.headlineMedium)

// Title (Card titles)
Text("Video Title", style = MaterialTheme.typography.titleLarge)

// Body (Content)
Text("Description", style = MaterialTheme.typography.bodyMedium)

// Label (Buttons, tags)
Text("Download", style = MaterialTheme.typography.labelLarge)
```

---

## 🔄 State Management

### Button States
```kotlin
var isPressed by remember { mutableStateOf(false) }

val scale by animateFloatAsState(
    targetValue = if (isPressed) 0.95f else 1f,
    animationSpec = Motion.scaleAnimation
)

ModernButton(
    modifier = Modifier.scale(scale),
    onClick = {
        isPressed = true
        // Actual action
    }
)

LaunchedEffect(isPressed) {
    if (isPressed) {
        delay(Motion.DURATION_QUICK.toLong())
        isPressed = false
    }
}
```

### Focus States
```kotlin
var isFocused by remember { mutableStateOf(false) }

val borderColor by animateColorAsState(
    targetValue = if (isFocused) {
        MaterialTheme.colorScheme.primary
    } else {
        MaterialTheme.colorScheme.outline
    },
    animationSpec = Motion.tweenShort()
)
```

---

## 📋 Migration Checklist

When updating a file:

- [ ] Import design tokens
- [ ] Replace `16.dp` → `spacing.default`
- [ ] Replace `8.dp` → `spacing.small`
- [ ] Replace `24.dp` → `spacing.extraLarge`
- [ ] Use `Gradients` for backgrounds
- [ ] Use `Motion` specs for animations
- [ ] Replace `Button` → `ModernButton`
- [ ] Replace `Card` → `ModernCard`
- [ ] Replace `TextField` → `ModernTextField`
- [ ] Test dark/light modes
- [ ] Verify accessibility

---

## 💡 Pro Tips

1. **Spacing**: Use `spacing.default` (16dp) for most padding
2. **Elevation**: Use `level5` for cards, `level4` for buttons
3. **Gradients**: Use sparingly for emphasis (buttons, headers)
4. **Animations**: Keep duration under 300ms for snappy feel
5. **Rounded Corners**: `spacing.large` (20dp) for cards
6. **Touch Targets**: Minimum 48dp for buttons/icons
7. **Contrast**: Test with dark mode enabled
8. **Icons**: Always provide contentDescription

---

## 🐛 Common Mistakes

❌ **Don't:**
```kotlin
.padding(16.dp)  // Hard-coded
.background(Color(0xFF6366F1))  // Hard-coded color
spring(dampingRatio = 0.6f)  // Custom animation spec
```

✅ **Do:**
```kotlin
.padding(spacing.default)  // Token
.background(brush = Gradients.primaryGradient())  // Gradient
Motion.scaleAnimation  // Consistent spec
```

---

## 📞 Need Help?

- **Design System Guide:** `MODERN_DESIGN_SYSTEM.md`
- **Implementation Summary:** `IMPLEMENTATION_SUMMARY.md`
- **This Quick Reference:** `QUICK_REFERENCE.md`

---

**Happy Coding! 🚀**
