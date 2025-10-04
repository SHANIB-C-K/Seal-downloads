package com.junkfood.seal.ui.component

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * Modern navigation drawer with enhanced styling
 * Created by shanib c k
 */
@Composable
fun ModernNavigationDrawer(
    modifier: Modifier = Modifier,
    selectedRoute: String? = null,
    onNavigate: (String) -> Unit = {},
    onClose: () -> Unit = {}
) {
    var isVisible by remember { mutableStateOf(false) }
    
    LaunchedEffect(Unit) {
        isVisible = true
    }

    Column(
        modifier = modifier
            .fillMaxHeight()
            .width(320.dp)
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        MaterialTheme.colorScheme.surface,
                        MaterialTheme.colorScheme.surfaceContainer
                    )
                )
            )
            .padding(16.dp)
    ) {
        // Header Section
        AnimatedVisibility(
            visible = isVisible,
            enter = slideInVertically(
                initialOffsetY = { -it },
                animationSpec = spring(dampingRatio = 0.8f)
            ) + fadeIn()
        ) {
            ModernDrawerHeader()
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Navigation Items
        AnimatedVisibility(
            visible = isVisible,
            enter = slideInVertically(
                initialOffsetY = { it },
                animationSpec = spring(dampingRatio = 0.8f)
            ) + fadeIn()
        ) {
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(navigationItems) { item ->
                    ModernNavigationItem(
                        item = item,
                        isSelected = selectedRoute == item.route,
                        onClick = {
                            onNavigate(item.route)
                            onClose()
                        }
                    )
                }
                
                item {
                    Spacer(modifier = Modifier.height(16.dp))
                    HorizontalDivider(
                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f)
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                }
                
                items(settingsItems) { item ->
                    ModernNavigationItem(
                        item = item,
                        isSelected = selectedRoute == item.route,
                        onClick = {
                            onNavigate(item.route)
                            onClose()
                        }
                    )
                }
            }
        }
        
        Spacer(modifier = Modifier.weight(1f))
        
        // Footer Section
        AnimatedVisibility(
            visible = isVisible,
            enter = slideInVertically(
                initialOffsetY = { it },
                animationSpec = spring(dampingRatio = 0.8f)
            ) + fadeIn()
        ) {
            ModernDrawerFooter()
        }
    }
}

@Composable
private fun ModernDrawerHeader() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            ModernAppIconSmall(size = 56.dp)
            
            Column {
                Text(
                    text = "Seal",
                    style = MaterialTheme.typography.headlineSmall.copy(
                        fontWeight = FontWeight.Bold
                    ),
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
                
                Text(
                    text = "Modern Downloader",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.8f)
                )
            }
        }
    }
}

@Composable
private fun ModernNavigationItem(
    item: NavigationItem,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    val backgroundColor by animateColorAsState(
        targetValue = if (isSelected) {
            MaterialTheme.colorScheme.primaryContainer
        } else {
            Color.Transparent
        },
        label = "nav_item_background"
    )
    
    val contentColor by animateColorAsState(
        targetValue = if (isSelected) {
            MaterialTheme.colorScheme.onPrimaryContainer
        } else {
            MaterialTheme.colorScheme.onSurface
        },
        label = "nav_item_content"
    )

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(backgroundColor)
            .clickable { onClick() }
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Icon(
            imageVector = if (isSelected) item.selectedIcon else item.unselectedIcon,
            contentDescription = item.title,
            tint = contentColor,
            modifier = Modifier.size(24.dp)
        )
        
        Text(
            text = item.title,
            style = MaterialTheme.typography.bodyLarge.copy(
                fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Normal
            ),
            color = contentColor
        )
        
        if (item.badge != null) {
            Spacer(modifier = Modifier.weight(1f))
            
            Badge(
                containerColor = MaterialTheme.colorScheme.error,
                contentColor = MaterialTheme.colorScheme.onError
            ) {
                Text(
                    text = item.badge,
                    style = MaterialTheme.typography.labelSmall
                )
            }
        }
    }
}

@Composable
private fun ModernDrawerFooter() {
    Column(
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        HorizontalDivider(
            color = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f)
        )
        
        Text(
            text = "Developed by shanib c k",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f),
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)
        )
        
        Text(
            text = "Version 1.0.0",
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.4f),
            modifier = Modifier.padding(horizontal = 16.dp)
        )
    }
}

data class NavigationItem(
    val route: String,
    val title: String,
    val selectedIcon: ImageVector,
    val unselectedIcon: ImageVector,
    val badge: String? = null
)

private val navigationItems = listOf(
    NavigationItem(
        route = "home",
        title = "Home",
        selectedIcon = Icons.Filled.Home,
        unselectedIcon = Icons.Outlined.Home
    ),
    NavigationItem(
        route = "downloads",
        title = "Downloads",
        selectedIcon = Icons.Filled.Download,
        unselectedIcon = Icons.Outlined.Download
    ),
    NavigationItem(
        route = "history",
        title = "History",
        selectedIcon = Icons.Filled.History,
        unselectedIcon = Icons.Outlined.History
    ),
    NavigationItem(
        route = "tasks",
        title = "Tasks",
        selectedIcon = Icons.Filled.Task,
        unselectedIcon = Icons.Outlined.Task,
        badge = "3"
    )
)

private val settingsItems = listOf(
    NavigationItem(
        route = "settings",
        title = "Settings",
        selectedIcon = Icons.Filled.Settings,
        unselectedIcon = Icons.Outlined.Settings
    ),
    NavigationItem(
        route = "about",
        title = "About",
        selectedIcon = Icons.Filled.Info,
        unselectedIcon = Icons.Outlined.Info
    ),
    NavigationItem(
        route = "help",
        title = "Help & Support",
        selectedIcon = Icons.Filled.Help,
        unselectedIcon = Icons.Outlined.Help
    )
)
