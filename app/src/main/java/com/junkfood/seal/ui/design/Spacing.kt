package com.junkfood.seal.ui.design

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * Design token for spacing across the app
 * Provides consistent spacing values for modern UI
 * Created by shanib c k
 */
@Immutable
data class Spacing(
    val none: Dp = 0.dp,
    val extraSmall: Dp = 4.dp,
    val small: Dp = 8.dp,
    val medium: Dp = 12.dp,
    val default: Dp = 16.dp,
    val large: Dp = 20.dp,
    val extraLarge: Dp = 24.dp,
    val huge: Dp = 32.dp,
    val massive: Dp = 40.dp,
    val colossal: Dp = 48.dp
)

val LocalSpacing = staticCompositionLocalOf { Spacing() }
