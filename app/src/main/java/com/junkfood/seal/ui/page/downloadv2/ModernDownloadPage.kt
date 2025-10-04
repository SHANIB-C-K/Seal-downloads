package com.junkfood.seal.ui.page.downloadv2

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.background
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.junkfood.seal.R
import com.junkfood.seal.ui.component.ModernButton
import com.junkfood.seal.ui.component.ModernButtonSize
import com.junkfood.seal.ui.component.ModernButtonStyle
import com.junkfood.seal.ui.component.ModernCard

/**
 * Modern download page with enhanced UI design
 * Created by shanib c k
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ModernDownloadPage(
    modifier: Modifier = Modifier,
    onDownloadClick: () -> Unit = {},
    onMenuClick: () -> Unit = {},
    onSettingsClick: () -> Unit = {},
    onHistoryClick: () -> Unit = {}
) {
    val context = LocalContext.current
    var isVisible by remember { mutableStateOf(false) }
    
    LaunchedEffect(Unit) {
        isVisible = true
    }

    Scaffold(
        modifier = modifier.fillMaxSize(),
        containerColor = MaterialTheme.colorScheme.background,
        topBar = {
            ModernTopBar(
                onMenuClick = onMenuClick,
                onSettingsClick = onSettingsClick
            )
        },
        floatingActionButton = {
            ModernFloatingActionButton(
                onClick = onDownloadClick,
                isVisible = isVisible
            )
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            item {
                AnimatedVisibility(
                    visible = isVisible,
                    enter = slideInVertically(
                        initialOffsetY = { -it },
                        animationSpec = spring(dampingRatio = 0.8f)
                    ) + fadeIn()
                ) {
                    WelcomeSection()
                }
            }
            
            item {
                AnimatedVisibility(
                    visible = isVisible,
                    enter = slideInVertically(
                        initialOffsetY = { it },
                        animationSpec = spring(dampingRatio = 0.8f)
                    ) + fadeIn()
                ) {
                    QuickActionsSection(
                        onDownloadClick = onDownloadClick,
                        onHistoryClick = onHistoryClick
                    )
                }
            }
            
            item {
                AnimatedVisibility(
                    visible = isVisible,
                    enter = slideInVertically(
                        initialOffsetY = { it },
                        animationSpec = spring(dampingRatio = 0.8f)
                    ) + fadeIn()
                ) {
                    FeaturesSection()
                }
            }
            
            item {
                AnimatedVisibility(
                    visible = isVisible,
                    enter = slideInVertically(
                        initialOffsetY = { it },
                        animationSpec = spring(dampingRatio = 0.8f)
                    ) + fadeIn()
                ) {
                    DeveloperSection()
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ModernTopBar(
    onMenuClick: () -> Unit,
    onSettingsClick: () -> Unit
) {
    TopAppBar(
        title = {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Box(
                    modifier = Modifier
                        .size(32.dp)
                        .background(
                            brush = Brush.linearGradient(
                                colors = listOf(
                                    MaterialTheme.colorScheme.primary,
                                    MaterialTheme.colorScheme.secondary
                                )
                            ),
                            shape = RoundedCornerShape(8.dp)
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Filled.Download,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onPrimary,
                        modifier = Modifier.size(20.dp)
                    )
                }
                
                Text(
                    text = stringResource(R.string.app_name),
                    style = MaterialTheme.typography.headlineSmall.copy(
                        fontWeight = FontWeight.Bold
                    )
                )
            }
        },
        navigationIcon = {
            IconButton(onClick = onMenuClick) {
                Icon(
                    imageVector = Icons.Outlined.Menu,
                    contentDescription = "Menu"
                )
            }
        },
        actions = {
            IconButton(onClick = onSettingsClick) {
                Icon(
                    imageVector = Icons.Outlined.Settings,
                    contentDescription = "Settings"
                )
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = Color.Transparent
        )
    )
}

@Composable
private fun ModernFloatingActionButton(
    onClick: () -> Unit,
    isVisible: Boolean
) {
    AnimatedVisibility(
        visible = isVisible,
        enter = scaleIn(
            animationSpec = spring(dampingRatio = 0.6f)
        ) + fadeIn(),
        exit = scaleOut() + fadeOut()
    ) {
        ExtendedFloatingActionButton(
            onClick = onClick,
            icon = {
                Icon(
                    imageVector = Icons.Filled.Add,
                    contentDescription = null
                )
            },
            text = {
                Text(
                    text = stringResource(R.string.download),
                    fontWeight = FontWeight.SemiBold
                )
            },
            containerColor = MaterialTheme.colorScheme.primary,
            contentColor = MaterialTheme.colorScheme.onPrimary,
            modifier = Modifier.clip(RoundedCornerShape(16.dp))
        )
    }
}

@Composable
private fun WelcomeSection() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        )
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    brush = Brush.linearGradient(
                        colors = listOf(
                            MaterialTheme.colorScheme.primary.copy(alpha = 0.1f),
                            MaterialTheme.colorScheme.secondary.copy(alpha = 0.1f)
                        )
                    )
                )
                .padding(24.dp)
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Icon(
                    imageVector = Icons.Filled.CloudDownload,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.size(48.dp)
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                Text(
                    text = "Welcome to Seal",
                    style = MaterialTheme.typography.headlineMedium.copy(
                        fontWeight = FontWeight.Bold
                    ),
                    color = MaterialTheme.colorScheme.onPrimaryContainer,
                    textAlign = TextAlign.Center
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                Text(
                    text = "Your modern video & audio downloader\nDeveloped by shanib c k",
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.8f),
                    textAlign = TextAlign.Center
                )
            }
        }
    }
}

@Composable
private fun QuickActionsSection(
    onDownloadClick: () -> Unit,
    onHistoryClick: () -> Unit
) {
    Column(
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(
            text = "Quick Actions",
            style = MaterialTheme.typography.titleLarge.copy(
                fontWeight = FontWeight.SemiBold
            ),
            color = MaterialTheme.colorScheme.onBackground
        )
        
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            ModernCard(
                modifier = Modifier.weight(1f),
                title = "New Download",
                subtitle = "Start downloading",
                icon = Icons.Filled.Download,
                onClick = onDownloadClick
            )
            
            ModernCard(
                modifier = Modifier.weight(1f),
                title = "History",
                subtitle = "View downloads",
                icon = Icons.Filled.History,
                onClick = onHistoryClick
            )
        }
    }
}

@Composable
private fun FeaturesSection() {
    Column(
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(
            text = "Features",
            style = MaterialTheme.typography.titleLarge.copy(
                fontWeight = FontWeight.SemiBold
            ),
            color = MaterialTheme.colorScheme.onBackground
        )
        
        val features = listOf(
            Triple(Icons.Filled.VideoLibrary, "Video Downloads", "Download videos in various formats"),
            Triple(Icons.Filled.AudioFile, "Audio Extraction", "Extract audio from videos"),
            Triple(Icons.Filled.PlaylistPlay, "Playlist Support", "Download entire playlists"),
            Triple(Icons.Filled.Subtitles, "Subtitles", "Download with subtitles")
        )
        
        features.forEach { (icon, title, description) ->
            ModernCard(
                modifier = Modifier.fillMaxWidth(),
                title = title,
                subtitle = description,
                icon = icon
            )
        }
    }
}

@Composable
private fun DeveloperSection() {
    ModernCard(
        modifier = Modifier.fillMaxWidth(),
        title = "About Developer",
        subtitle = "Created with ❤️ by shanib c k",
        icon = Icons.Filled.Person
    ) {
        Spacer(modifier = Modifier.height(8.dp))
        
        Text(
            text = "Seal is a modern, feature-rich video downloader built with the latest Android technologies. It provides a seamless experience for downloading videos and audio from various platforms.",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f)
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Row(
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            ModernButton(
                onClick = { /* Open GitHub */ },
                text = "GitHub",
                icon = Icons.Filled.Code,
                style = ModernButtonStyle.Outline,
                size = ModernButtonSize.Small,
                modifier = Modifier.weight(1f)
            )
            
            ModernButton(
                onClick = { /* Open sponsor */ },
                text = "Sponsor",
                icon = Icons.Filled.Favorite,
                style = ModernButtonStyle.Secondary,
                size = ModernButtonSize.Small,
                modifier = Modifier.weight(1f)
            )
        }
    }
}
