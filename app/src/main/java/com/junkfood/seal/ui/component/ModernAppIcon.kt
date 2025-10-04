package com.junkfood.seal.ui.component

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.*
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.Fill
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * Modern app icon component with gradient design
 * Created by shanib c k
 */
@Composable
fun ModernAppIcon(
    modifier: Modifier = Modifier,
    size: Dp = 120.dp
) {
    Box(
        modifier = modifier
            .size(size)
            .clip(RoundedCornerShape(size * 0.2f))
            .background(
                brush = Brush.linearGradient(
                    colors = listOf(
                        Color(0xFF6366F1), // Indigo
                        Color(0xFF8B5CF6), // Purple
                        Color(0xFF06B6D4)  // Cyan
                    ),
                    start = Offset.Zero,
                    end = Offset.Infinite
                )
            )
    ) {
        Canvas(
            modifier = Modifier.fillMaxSize()
        ) {
            drawModernSealIcon(
                size = this.size,
                primaryColor = Color.White,
                secondaryColor = Color.White.copy(alpha = 0.8f)
            )
        }
    }
}

private fun DrawScope.drawModernSealIcon(
    size: Size,
    primaryColor: Color,
    secondaryColor: Color
) {
    val centerX = size.width / 2f
    val centerY = size.height / 2f
    val iconSize = size.minDimension * 0.6f
    
    // Draw download arrow
    val arrowPath = Path().apply {
        val arrowWidth = iconSize * 0.4f
        val arrowHeight = iconSize * 0.6f
        val strokeWidth = iconSize * 0.08f
        
        // Arrow shaft
        moveTo(centerX - strokeWidth / 2, centerY - arrowHeight / 2)
        lineTo(centerX + strokeWidth / 2, centerY - arrowHeight / 2)
        lineTo(centerX + strokeWidth / 2, centerY + arrowHeight / 4)
        lineTo(centerX + arrowWidth / 2, centerY + arrowHeight / 4)
        lineTo(centerX, centerY + arrowHeight / 2)
        lineTo(centerX - arrowWidth / 2, centerY + arrowHeight / 4)
        lineTo(centerX - strokeWidth / 2, centerY + arrowHeight / 4)
        close()
    }
    
    // Draw shadow
    drawPath(
        path = arrowPath,
        color = Color.Black.copy(alpha = 0.2f),
        style = Fill
    )
    
    // Draw main arrow with slight offset
    drawPath(
        path = arrowPath,
        color = primaryColor,
        style = Fill
    )
    
    // Draw decorative circles
    val circleRadius = iconSize * 0.05f
    val circlePositions = listOf(
        Offset(centerX - iconSize * 0.3f, centerY - iconSize * 0.35f),
        Offset(centerX + iconSize * 0.3f, centerY - iconSize * 0.35f),
        Offset(centerX - iconSize * 0.4f, centerY + iconSize * 0.3f),
        Offset(centerX + iconSize * 0.4f, centerY + iconSize * 0.3f)
    )
    
    circlePositions.forEachIndexed { index, position ->
        drawCircle(
            color = secondaryColor.copy(alpha = 0.6f - index * 0.1f),
            radius = circleRadius * (1f - index * 0.1f),
            center = position
        )
    }
    
    // Draw progress arc
    val arcRadius = iconSize * 0.45f
    drawArc(
        color = secondaryColor.copy(alpha = 0.4f),
        startAngle = -90f,
        sweepAngle = 270f,
        useCenter = false,
        topLeft = Offset(centerX - arcRadius, centerY - arcRadius),
        size = Size(arcRadius * 2, arcRadius * 2),
        style = Stroke(width = iconSize * 0.03f, cap = StrokeCap.Round)
    )
}

@Composable
fun ModernAppIconSmall(
    modifier: Modifier = Modifier,
    size: Dp = 48.dp
) {
    ModernAppIcon(
        modifier = modifier,
        size = size
    )
}
