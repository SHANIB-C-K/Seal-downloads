package com.junkfood.seal.ui.design

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color

/**
 * Design tokens for gradient brushes
 * Provides consistent gradient effects for modern UI
 * Created by shanib c k
 */
@Immutable
object Gradients {
    
    @Composable
    fun primaryGradient(alpha: Float = 1f): Brush {
        val primary = MaterialTheme.colorScheme.primary
        return Brush.linearGradient(
            colors = listOf(
                primary.copy(alpha = alpha),
                primary.copy(alpha = alpha * 0.85f)
            ),
            start = Offset(0f, 0f),
            end = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY)
        )
    }
    
    @Composable
    fun secondaryGradient(alpha: Float = 1f): Brush {
        val secondary = MaterialTheme.colorScheme.secondary
        return Brush.linearGradient(
            colors = listOf(
                secondary.copy(alpha = alpha),
                secondary.copy(alpha = alpha * 0.85f)
            ),
            start = Offset(0f, 0f),
            end = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY)
        )
    }
    
    @Composable
    fun tertiaryGradient(alpha: Float = 1f): Brush {
        val tertiary = MaterialTheme.colorScheme.tertiary
        return Brush.linearGradient(
            colors = listOf(
                tertiary.copy(alpha = alpha),
                tertiary.copy(alpha = alpha * 0.85f)
            ),
            start = Offset(0f, 0f),
            end = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY)
        )
    }
    
    @Composable
    fun surfaceGradient(): Brush {
        val surface = MaterialTheme.colorScheme.surface
        val surfaceVariant = MaterialTheme.colorScheme.surfaceVariant
        return Brush.verticalGradient(
            colors = listOf(
                surface,
                surfaceVariant.copy(alpha = 0.5f)
            )
        )
    }
    
    @Composable
    fun backgroundGradient(): Brush {
        val background = MaterialTheme.colorScheme.background
        val surface = MaterialTheme.colorScheme.surface
        return Brush.verticalGradient(
            colors = listOf(
                background,
                surface.copy(alpha = 0.3f)
            )
        )
    }
    
    @Composable
    fun shimmerGradient(
        showShimmer: Boolean,
        targetValue: Float = 1000f
    ): Brush {
        val colors = if (showShimmer) {
            listOf(
                Color.LightGray.copy(alpha = 0.6f),
                Color.LightGray.copy(alpha = 0.2f),
                Color.LightGray.copy(alpha = 0.6f)
            )
        } else {
            listOf(Color.Transparent, Color.Transparent, Color.Transparent)
        }
        
        return Brush.linearGradient(
            colors = colors,
            start = Offset.Zero,
            end = Offset(targetValue, targetValue)
        )
    }
    
    @Composable
    fun cardGradient(): Brush {
        val surface = MaterialTheme.colorScheme.surfaceContainer
        return Brush.verticalGradient(
            colors = listOf(
                surface,
                surface.copy(alpha = 0.95f)
            )
        )
    }
    
    @Composable
    fun glassGradient(): Brush {
        val surface = MaterialTheme.colorScheme.surface
        return Brush.verticalGradient(
            colors = listOf(
                surface.copy(alpha = 0.95f),
                surface.copy(alpha = 0.85f)
            )
        )
    }
}
