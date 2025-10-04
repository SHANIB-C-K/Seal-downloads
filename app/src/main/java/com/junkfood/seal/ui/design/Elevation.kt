package com.junkfood.seal.ui.design

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * Design token for elevation and shadows
 * Provides consistent elevation values for modern depth
 * Created by shanib c k
 */
@Immutable
data class Elevation(
    val none: Dp = 0.dp,
    val level1: Dp = 1.dp,
    val level2: Dp = 2.dp,
    val level3: Dp = 4.dp,
    val level4: Dp = 6.dp,
    val level5: Dp = 8.dp,
    val level6: Dp = 12.dp,
    val level7: Dp = 16.dp,
    val level8: Dp = 24.dp
)

val LocalElevation = staticCompositionLocalOf { Elevation() }
