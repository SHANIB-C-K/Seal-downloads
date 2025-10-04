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
 * Modern card component with enhanced visual design and smooth interactions
 * Utilizes design tokens for consistent spacing and elevation
 * Created by shanib c k
 */
@Composable
fun ModernCard(
    modifier: Modifier = Modifier,
    title: String,
    subtitle: String? = null,
    icon: ImageVector? = null,
    onClick: (() -> Unit)? = null,
    enabled: Boolean = true,
    colors: ModernCardColors = ModernCardDefaults.colors(),
    content: @Composable ColumnScope.() -> Unit = {}
) {
    val spacing = LocalSpacing.current
    val elevation = LocalElevation.current
    var isPressed by remember { mutableStateOf(false) }
    
    val scale by animateFloatAsState(
        targetValue = if (isPressed) 0.98f else 1f,
        animationSpec = Motion.scaleAnimation,
        label = "card_scale"
    )
    
    val containerColor by animateColorAsState(
        targetValue = if (enabled) colors.containerColor else colors.disabledContainerColor,
        label = "container_color"
    )
    
    val contentColor by animateColorAsState(
        targetValue = if (enabled) colors.contentColor else colors.disabledContentColor,
        label = "content_color"
    )

    Card(
        modifier = modifier
            .scale(scale)
            .shadow(
                elevation = if (isPressed) elevation.level2 else elevation.level5,
                shape = RoundedCornerShape(spacing.large),
                ambientColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.1f)
            )
            .then(
                if (onClick != null) {
                    Modifier.clickable(
                        enabled = enabled,
                        onClick = {
                            isPressed = true
                            onClick()
                        }
                    )
                } else Modifier
            ),
        shape = RoundedCornerShape(spacing.large),
        colors = CardDefaults.cardColors(
            containerColor = containerColor,
            contentColor = contentColor
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(brush = Gradients.cardGradient())
                .padding(spacing.large)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(spacing.default)
            ) {
                if (icon != null) {
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
                            imageVector = icon,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.size(spacing.extraLarge)
                        )
                    }
                }
                
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = title,
                        style = MaterialTheme.typography.titleMedium.copy(
                            fontWeight = FontWeight.SemiBold,
                            fontSize = 18.sp
                        ),
                        color = contentColor
                    )
                    
                    if (subtitle != null) {
                        Spacer(modifier = Modifier.height(spacing.extraSmall))
                        Text(
                            text = subtitle,
                            style = MaterialTheme.typography.bodyMedium,
                            color = contentColor.copy(alpha = 0.7f)
                        )
                    }
                }
            }
            
            if (content != {}) {
                Spacer(modifier = Modifier.height(spacing.default))
                content()
            }
        }
    }
    
    LaunchedEffect(isPressed) {
        if (isPressed) {
            kotlinx.coroutines.delay(Motion.DURATION_QUICK.toLong())
            isPressed = false
        }
    }
}

@Immutable
data class ModernCardColors(
    val containerColor: Color,
    val contentColor: Color,
    val disabledContainerColor: Color,
    val disabledContentColor: Color
)

object ModernCardDefaults {
    @Composable
    fun colors(
        containerColor: Color = MaterialTheme.colorScheme.surfaceContainer,
        contentColor: Color = MaterialTheme.colorScheme.onSurface,
        disabledContainerColor: Color = MaterialTheme.colorScheme.surfaceContainer.copy(alpha = 0.38f),
        disabledContentColor: Color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
    ): ModernCardColors = ModernCardColors(
        containerColor = containerColor,
        contentColor = contentColor,
        disabledContainerColor = disabledContainerColor,
        disabledContentColor = disabledContentColor
    )
}
