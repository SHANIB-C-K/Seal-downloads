package com.junkfood.seal.ui.component

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Download
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.graphics.graphicsLayer
import kotlinx.coroutines.delay

/**
 * Modern splash screen with animations
 * Created by shanib c k
 */
@Composable
fun ModernSplashScreen(
    modifier: Modifier = Modifier,
    onSplashFinished: () -> Unit = {}
) {
    var isVisible by remember { mutableStateOf(false) }
    var showLogo by remember { mutableStateOf(false) }
    var showText by remember { mutableStateOf(false) }
    var showDeveloper by remember { mutableStateOf(false) }
    
    val scale by animateFloatAsState(
        targetValue = if (showLogo) 1f else 0f,
        animationSpec = spring(
            dampingRatio = 0.6f,
            stiffness = Spring.StiffnessLow
        ),
        label = "logo_scale"
    )
    
    val rotation by animateFloatAsState(
        targetValue = if (showLogo) 0f else 180f,
        animationSpec = spring(
            dampingRatio = 0.8f,
            stiffness = Spring.StiffnessMedium
        ),
        label = "logo_rotation"
    )

    LaunchedEffect(Unit) {
        isVisible = true
        delay(300)
        showLogo = true
        delay(800)
        showText = true
        delay(500)
        showDeveloper = true
        delay(1500)
        onSplashFinished()
    }

    Box(
        modifier = modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        MaterialTheme.colorScheme.primary,
                        MaterialTheme.colorScheme.secondary,
                        MaterialTheme.colorScheme.tertiary
                    )
                )
            ),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Logo Animation
            Box(
                modifier = Modifier
                    .size(120.dp)
                    .scale(scale)
                    .clip(RoundedCornerShape(24.dp))
                    .background(
                        color = Color.White.copy(alpha = 0.2f),
                        shape = RoundedCornerShape(24.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Filled.Download,
                    contentDescription = null,
                    tint = Color.White,
                    modifier = Modifier
                        .size(60.dp)
                        .graphicsLayer {
                            rotationZ = rotation
                        }
                )
            }
            
            Spacer(modifier = Modifier.height(32.dp))
            
            // App Name Animation
            AnimatedVisibility(
                visible = showText,
                enter = slideInVertically(
                    initialOffsetY = { it },
                    animationSpec = spring(dampingRatio = 0.8f)
                ) + fadeIn()
            ) {
                Text(
                    text = "Seal",
                    style = MaterialTheme.typography.displayMedium.copy(
                        fontWeight = FontWeight.Bold,
                        fontSize = 48.sp
                    ),
                    color = Color.White,
                    textAlign = TextAlign.Center
                )
            }
            
            Spacer(modifier = Modifier.height(8.dp))
            
            // Subtitle Animation
            AnimatedVisibility(
                visible = showText,
                enter = slideInVertically(
                    initialOffsetY = { it },
                    animationSpec = spring(dampingRatio = 0.8f)
                ) + fadeIn()
            ) {
                Text(
                    text = "Modern Video Downloader",
                    style = MaterialTheme.typography.titleLarge,
                    color = Color.White.copy(alpha = 0.9f),
                    textAlign = TextAlign.Center
                )
            }
            
            Spacer(modifier = Modifier.height(48.dp))
            
            // Developer Credit Animation
            AnimatedVisibility(
                visible = showDeveloper,
                enter = slideInVertically(
                    initialOffsetY = { it },
                    animationSpec = spring(dampingRatio = 0.8f)
                ) + fadeIn()
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = "Developed by",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color.White.copy(alpha = 0.7f),
                        textAlign = TextAlign.Center
                    )
                    
                    Spacer(modifier = Modifier.height(4.dp))
                    
                    Text(
                        text = "shanib c k",
                        style = MaterialTheme.typography.titleMedium.copy(
                            fontWeight = FontWeight.SemiBold
                        ),
                        color = Color.White,
                        textAlign = TextAlign.Center
                    )
                }
            }
        }
        
        // Loading Indicator
        AnimatedVisibility(
            visible = isVisible,
            modifier = Modifier.align(Alignment.BottomCenter),
            enter = fadeIn()
        ) {
            Box(
                modifier = Modifier.padding(bottom = 80.dp)
            ) {
                CircularProgressIndicator(
                    color = Color.White,
                    strokeWidth = 2.dp,
                    modifier = Modifier.size(32.dp)
                )
            }
        }
    }
}
