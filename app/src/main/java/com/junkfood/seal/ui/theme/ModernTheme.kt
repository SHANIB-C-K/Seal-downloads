package com.junkfood.seal.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.junkfood.seal.ui.design.LocalElevation
import com.junkfood.seal.ui.design.LocalSpacing
import com.junkfood.seal.ui.design.Elevation
import com.junkfood.seal.ui.design.Spacing

/**
 * Modern theme for Seal app with enhanced colors and typography
 * Features a beautiful gradient-ready color system with design tokens
 * Created by shanib c k
 */

// Modern Color Palette - Enhanced with better contrast and accessibility
private val ModernPrimary = Color(0xFF6366F1) // Indigo - main brand color
private val ModernPrimaryVariant = Color(0xFF4F46E5) // Darker indigo
private val ModernSecondary = Color(0xFF06B6D4) // Cyan - accent color
private val ModernSecondaryVariant = Color(0xFF0891B2) // Darker cyan
private val ModernTertiary = Color(0xFF8B5CF6) // Purple - tertiary accent
private val ModernError = Color(0xFFEF4444) // Red - error states
private val ModernWarning = Color(0xFFF59E0B) // Amber - warnings
private val ModernSuccess = Color(0xFF10B981) // Emerald - success states

// Light Theme Colors - Enhanced for better visual hierarchy
private val ModernLightColorScheme = lightColorScheme(
    primary = ModernPrimary,
    onPrimary = Color.White,
    primaryContainer = Color(0xFFEEF2FF), // Very light indigo
    onPrimaryContainer = Color(0xFF1E1B4B), // Deep indigo
    
    secondary = ModernSecondary,
    onSecondary = Color.White,
    secondaryContainer = Color(0xFFE0F7FA), // Very light cyan
    onSecondaryContainer = Color(0xFF0F172A), // Deep blue-gray
    
    tertiary = ModernTertiary,
    onTertiary = Color.White,
    tertiaryContainer = Color(0xFFF3E8FF), // Very light purple
    onTertiaryContainer = Color(0xFF2D1B69), // Deep purple
    
    error = ModernError,
    onError = Color.White,
    errorContainer = Color(0xFFFEE2E2), // Very light red
    onErrorContainer = Color(0xFF7F1D1D), // Deep red
    
    background = Color(0xFFFAFAFA), // Soft white
    onBackground = Color(0xFF1F2937), // Dark gray
    
    surface = Color.White,
    onSurface = Color(0xFF1F2937), // Dark gray
    surfaceVariant = Color(0xFFF8FAFC), // Off-white
    onSurfaceVariant = Color(0xFF64748B), // Medium gray
    
    surfaceContainer = Color(0xFFF1F5F9), // Light gray-blue
    surfaceContainerHigh = Color(0xFFE2E8F0), // Medium-light gray
    surfaceContainerHighest = Color(0xFFCBD5E1), // Medium gray
    
    outline = Color(0xFFD1D5DB), // Border gray
    outlineVariant = Color(0xFFE5E7EB), // Subtle border
    
    inverseSurface = Color(0xFF1F2937),
    inverseOnSurface = Color(0xFFF9FAFB),
    inversePrimary = Color(0xFF818CF8)
)

// Dark Theme Colors - Optimized for OLED and dark mode preferences
private val ModernDarkColorScheme = darkColorScheme(
    primary = Color(0xFF818CF8), // Light indigo
    onPrimary = Color(0xFF1E1B4B), // Deep indigo
    primaryContainer = Color(0xFF312E81), // Dark indigo
    onPrimaryContainer = Color(0xFFEEF2FF), // Very light indigo
    
    secondary = Color(0xFF22D3EE), // Light cyan
    onSecondary = Color(0xFF0F172A), // Very dark blue
    secondaryContainer = Color(0xFF164E63), // Dark cyan
    onSecondaryContainer = Color(0xFFE0F7FA), // Very light cyan
    
    tertiary = Color(0xFFA78BFA), // Light purple
    onTertiary = Color(0xFF2D1B69), // Deep purple
    tertiaryContainer = Color(0xFF553C9A), // Dark purple
    onTertiaryContainer = Color(0xFFF3E8FF), // Very light purple
    
    error = Color(0xFFF87171), // Light red
    onError = Color(0xFF7F1D1D), // Deep red
    errorContainer = Color(0xFF991B1B), // Dark red
    onErrorContainer = Color(0xFFFEE2E2), // Very light red
    
    background = Color(0xFF0F172A), // Very dark blue (OLED-friendly)
    onBackground = Color(0xFFF8FAFC), // Off-white
    
    surface = Color(0xFF1E293B), // Dark blue-gray
    onSurface = Color(0xFFF8FAFC), // Off-white
    surfaceVariant = Color(0xFF334155), // Medium dark blue-gray
    onSurfaceVariant = Color(0xFF94A3B8), // Light gray
    
    surfaceContainer = Color(0xFF475569), // Medium blue-gray
    surfaceContainerHigh = Color(0xFF64748B), // Light-medium gray
    surfaceContainerHighest = Color(0xFF94A3B8), // Light gray
    
    outline = Color(0xFF64748B), // Border gray
    outlineVariant = Color(0xFF475569), // Subtle border
    
    inverseSurface = Color(0xFFF1F5F9),
    inverseOnSurface = Color(0xFF1E293B),
    inversePrimary = Color(0xFF4F46E5)
)

// Modern Typography
private val ModernTypography = Typography(
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 57.sp,
        lineHeight = 64.sp,
        letterSpacing = (-0.25).sp
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 45.sp,
        lineHeight = 52.sp,
        letterSpacing = 0.sp
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 36.sp,
        lineHeight = 44.sp,
        letterSpacing = 0.sp
    ),
    headlineLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.SemiBold,
        fontSize = 32.sp,
        lineHeight = 40.sp,
        letterSpacing = 0.sp
    ),
    headlineMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.SemiBold,
        fontSize = 28.sp,
        lineHeight = 36.sp,
        letterSpacing = 0.sp
    ),
    headlineSmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.SemiBold,
        fontSize = 24.sp,
        lineHeight = 32.sp,
        letterSpacing = 0.sp
    ),
    titleLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.SemiBold,
        fontSize = 22.sp,
        lineHeight = 28.sp,
        letterSpacing = 0.sp
    ),
    titleMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.15.sp
    ),
    titleSmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 14.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.1.sp
    ),
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    ),
    bodyMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 14.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.25.sp
    ),
    bodySmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 12.sp,
        lineHeight = 16.sp,
        letterSpacing = 0.4.sp
    ),
    labelLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 14.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.1.sp
    ),
    labelMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 12.sp,
        lineHeight = 16.sp,
        letterSpacing = 0.5.sp
    ),
    labelSmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 11.sp,
        lineHeight = 16.sp,
        letterSpacing = 0.5.sp
    )
)

@Composable
fun ModernSealTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = androidx.compose.ui.platform.LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context)
            else dynamicLightColorScheme(context)
        }
        darkTheme -> ModernDarkColorScheme
        else -> ModernLightColorScheme
    }

    // Provide design tokens through CompositionLocal
    CompositionLocalProvider(
        LocalSpacing provides Spacing(),
        LocalElevation provides Elevation()
    ) {
        MaterialTheme(
            colorScheme = colorScheme,
            typography = ModernTypography,
            shapes = ModernShapes,
            content = content
        )
    }
}

// Modern Shapes - Rounded corners for a softer, modern look
private val ModernShapes = Shapes(
    extraSmall = RoundedCornerShape(4.dp),   // Small chips, tags
    small = RoundedCornerShape(8.dp),        // Buttons, small cards
    medium = RoundedCornerShape(12.dp),      // Standard cards
    large = RoundedCornerShape(16.dp),       // Large cards, bottom sheets
    extraLarge = RoundedCornerShape(28.dp)   // Dialogs, modals
)
