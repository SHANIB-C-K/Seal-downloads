# Concurrent Downloads Implementation in Seal

## Overview
Seal now supports configurable concurrent downloads, allowing multiple downloads to run simultaneously.

## Features Implemented

### 1. **Configurable Concurrency**
- **Default**: 3 concurrent downloads
- **Range**: 1-6 concurrent downloads
- **Setting Location**: Settings → General → Advanced Settings → Maximum concurrent downloads

### 2. **Smart Queue Management**
- **Automatic Processing**: Downloads are automatically queued and processed
- **Priority System**: Downloads are prioritized over info fetching
- **State Management**: Proper state tracking for each download task

### 3. **Task States**
```
Idle → FetchingInfo → ReadyWithInfo → Running → Completed
                                   ↓
                                 Error/Canceled
```

### 4. **UI Components Added**
- **Settings UI**: New preference item in General Download Preferences
- **Dialog**: Radio button selection for concurrency level (1-6)
- **Reactive Updates**: UI updates immediately when settings change

## Technical Implementation

### Files Modified:
1. **`PreferenceUtil.kt`**: Added `MAX_CONCURRENT_DOWNLOADS` preference
2. **`DownloaderV2.kt`**: Made concurrency configurable via `getMaxConcurrency()`
3. **`GeneralDownloadPreferences.kt`**: Added UI for configuring concurrent downloads
4. **`strings.xml`**: Added localization strings

### Key Code Changes:

#### PreferenceUtil.kt
```kotlin
const val MAX_CONCURRENT_DOWNLOADS = "max_concurrent_downloads"
// Default value: 3
```

#### DownloaderV2.kt
```kotlin
private fun getMaxConcurrency(): Int = PreferenceUtil.getValue(PreferenceUtil.MAX_CONCURRENT_DOWNLOADS)

private fun doYourWork() {
    if (taskStateMap.countRunning() >= getMaxConcurrency()) return
    // Process next pending task...
}
```

## How It Works

### Current System (Already Working)
1. **Task Queue**: Uses `SnapshotStateMap<Task, Task.State>` for reactive state management
2. **Automatic Processing**: `doYourWork()` function continuously processes pending tasks
3. **Concurrency Control**: Limits running tasks based on `getMaxConcurrency()`
4. **Background Service**: Manages downloads in background via `DownloadService`

### New Enhancement
- **User Control**: Users can now configure how many downloads run simultaneously
- **Resource Management**: Lower values for slower devices, higher for powerful ones
- **Immediate Effect**: Changes apply to new downloads without app restart

## Usage Instructions

1. **Open Settings**: Navigate to Settings → General
2. **Find Option**: Scroll to "Advanced Settings" section
3. **Configure**: Tap "Maximum concurrent downloads"
4. **Select**: Choose from 1-6 concurrent downloads
5. **Apply**: Changes take effect immediately

## Benefits

- **Faster Downloads**: Multiple files download simultaneously
- **Better Resource Usage**: Configurable based on device capabilities
- **User Control**: Customizable experience
- **Smart Management**: Automatic queue processing and error handling

## System Requirements

- **Memory**: Higher concurrency uses more RAM
- **Network**: Multiple downloads share bandwidth
- **Storage**: Ensure sufficient space for concurrent downloads
- **Battery**: More concurrent downloads may drain battery faster

The concurrent download system is now fully functional and ready to use!
