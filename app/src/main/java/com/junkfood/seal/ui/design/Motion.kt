package com.junkfood.seal.ui.design

import androidx.compose.animation.core.AnimationSpec
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Immutable

/**
 * Design tokens for motion and animations
 * Provides consistent animation specs for modern UI
 * Created by shanib c k
 */
@Immutable
object Motion {
    // Duration values
    const val DURATION_INSTANT = 50
    const val DURATION_QUICK = 100
    const val DURATION_SHORT = 200
    const val DURATION_MEDIUM = 300
    const val DURATION_LONG = 400
    const val DURATION_EXTRA_LONG = 500
    
    // Spring configurations
    val springLow = spring<Float>(
        dampingRatio = Spring.DampingRatioLowBouncy,
        stiffness = Spring.StiffnessLow
    )
    
    val springMedium = spring<Float>(
        dampingRatio = Spring.DampingRatioMediumBouncy,
        stiffness = Spring.StiffnessMedium
    )
    
    val springHigh = spring<Float>(
        dampingRatio = Spring.DampingRatioNoBouncy,
        stiffness = Spring.StiffnessHigh
    )
    
    // Tween configurations
    fun <T> tweenShort(): AnimationSpec<T> = tween(durationMillis = DURATION_SHORT)
    fun <T> tweenMedium(): AnimationSpec<T> = tween(durationMillis = DURATION_MEDIUM)
    fun <T> tweenLong(): AnimationSpec<T> = tween(durationMillis = DURATION_LONG)
    
    // Common animation specs
    val scaleAnimation = spring<Float>(
        dampingRatio = 0.6f,
        stiffness = Spring.StiffnessMedium
    )
    
    val fadeAnimation = tween<Float>(durationMillis = DURATION_MEDIUM)
    
    val slideAnimation = spring<Float>(
        dampingRatio = 0.8f,
        stiffness = Spring.StiffnessMediumLow
    )
}
