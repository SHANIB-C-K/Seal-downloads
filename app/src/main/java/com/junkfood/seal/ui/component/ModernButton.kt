package com.junkfood.seal.ui.component

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.junkfood.seal.ui.design.Gradients
import com.junkfood.seal.ui.design.LocalElevation
import com.junkfood.seal.ui.design.LocalSpacing
import com.junkfood.seal.ui.design.Motion

/**
 * Modern button component with gradient background and smooth animations
 * Utilizes design tokens for consistent spacing and elevation
 * Created by shanib c k
 */
@Composable
fun ModernButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    text: String,
    icon: ImageVector? = null,
    style: ModernButtonStyle = ModernButtonStyle.Primary,
    size: ModernButtonSize = ModernButtonSize.Medium
) {
    val spacing = LocalSpacing.current
    val elevation = LocalElevation.current
    var isPressed by remember { mutableStateOf(false) }
    
    val scale by animateFloatAsState(
        targetValue = if (isPressed) 0.95f else 1f,
        animationSpec = Motion.scaleAnimation,
        label = "button_scale"
    )
    
    val colors = when (style) {
        ModernButtonStyle.Primary -> ModernButtonDefaults.primaryColors()
        ModernButtonStyle.Secondary -> ModernButtonDefaults.secondaryColors()
        ModernButtonStyle.Outline -> ModernButtonDefaults.outlineColors()
    }
    
    val containerColor by animateColorAsState(
        targetValue = if (enabled) colors.containerColor else colors.disabledContainerColor,
        label = "container_color"
    )
    
    val contentColor by animateColorAsState(
        targetValue = if (enabled) colors.contentColor else colors.disabledContentColor,
        label = "content_color"
    )
    
    val padding = when (size) {
        ModernButtonSize.Small -> PaddingValues(
            horizontal = spacing.default, 
            vertical = spacing.small
        )
        ModernButtonSize.Medium -> PaddingValues(
            horizontal = spacing.extraLarge, 
            vertical = spacing.medium
        )
        ModernButtonSize.Large -> PaddingValues(
            horizontal = spacing.huge, 
            vertical = spacing.default
        )
    }
    
    val cornerRadius = when (size) {
        ModernButtonSize.Small -> 12.dp
        ModernButtonSize.Medium -> 16.dp
        ModernButtonSize.Large -> 20.dp
    }

    Box(
        modifier = modifier
            .scale(scale)
            .shadow(
                elevation = if (isPressed) elevation.level2 else elevation.level4,
                shape = RoundedCornerShape(cornerRadius),
                ambientColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.2f)
            )
            .clip(RoundedCornerShape(cornerRadius))
            .background(
                brush = when (style) {
                    ModernButtonStyle.Primary -> Gradients.primaryGradient()
                    ModernButtonStyle.Secondary -> Gradients.secondaryGradient()
                    ModernButtonStyle.Outline -> Gradients.surfaceGradient()
                }
            )
            .clickable(
                enabled = enabled,
                onClick = {
                    isPressed = true
                    onClick()
                }
            )
            .padding(padding),
        contentAlignment = Alignment.Center
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(spacing.small)
        ) {
            if (icon != null) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = contentColor,
                    modifier = Modifier.size(
                        when (size) {
                            ModernButtonSize.Small -> 16.dp
                            ModernButtonSize.Medium -> 20.dp
                            ModernButtonSize.Large -> 24.dp
                        }
                    )
                )
            }
            
            Text(
                text = text,
                style = MaterialTheme.typography.labelLarge.copy(
                    fontWeight = FontWeight.SemiBold,
                    fontSize = when (size) {
                        ModernButtonSize.Small -> 14.sp
                        ModernButtonSize.Medium -> 16.sp
                        ModernButtonSize.Large -> 18.sp
                    }
                ),
                color = contentColor
            )
        }
    }
    
    LaunchedEffect(isPressed) {
        if (isPressed) {
            kotlinx.coroutines.delay(Motion.DURATION_QUICK.toLong())
            isPressed = false
        }
    }
}

enum class ModernButtonStyle {
    Primary,
    Secondary,
    Outline
}

enum class ModernButtonSize {
    Small,
    Medium,
    Large
}

@Immutable
data class ModernButtonColors(
    val containerColor: Color,
    val contentColor: Color,
    val disabledContainerColor: Color,
    val disabledContentColor: Color
)

object ModernButtonDefaults {
    @Composable
    fun primaryColors(): ModernButtonColors = ModernButtonColors(
        containerColor = MaterialTheme.colorScheme.primary,
        contentColor = MaterialTheme.colorScheme.onPrimary,
        disabledContainerColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.38f),
        disabledContentColor = MaterialTheme.colorScheme.onPrimary.copy(alpha = 0.38f)
    )
    
    @Composable
    fun secondaryColors(): ModernButtonColors = ModernButtonColors(
        containerColor = MaterialTheme.colorScheme.secondary,
        contentColor = MaterialTheme.colorScheme.onSecondary,
        disabledContainerColor = MaterialTheme.colorScheme.secondary.copy(alpha = 0.38f),
        disabledContentColor = MaterialTheme.colorScheme.onSecondary.copy(alpha = 0.38f)
    )
    
    @Composable
    fun outlineColors(): ModernButtonColors = ModernButtonColors(
        containerColor = MaterialTheme.colorScheme.surface,
        contentColor = MaterialTheme.colorScheme.primary,
        disabledContainerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.38f),
        disabledContentColor = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
    )
}
