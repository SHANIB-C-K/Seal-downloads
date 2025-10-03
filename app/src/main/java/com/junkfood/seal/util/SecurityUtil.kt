package com.junkfood.seal.util

import android.net.Uri
import android.util.Log
import java.io.File
import java.net.URL
import java.util.regex.Pattern

/**
 * Security utility functions for input validation and sanitization
 */
object SecurityUtil {
    
    private const val TAG = "SecurityUtil"
    
    // URL validation patterns
    private val VALID_URL_PATTERN = Pattern.compile(
        "^https?://(?:www\\.)?[-a-zA-Z0-9@:%._+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_+.~#?&=]*)$"
    )
    
    private val YOUTUBE_URL_PATTERN = Pattern.compile(
        "^https?://(?:www\\.)?(youtube\\.com|youtu\\.be|m\\.youtube\\.com)/.+"
    )
    
    // File path validation
    private val SAFE_FILENAME_PATTERN = Pattern.compile("^[a-zA-Z0-9._\\-\\s()\\[\\]]+$")
    
    // Dangerous file extensions to block
    private val DANGEROUS_EXTENSIONS = setOf(
        "exe", "bat", "cmd", "com", "pif", "scr", "vbs", "js", "jar", "app", "deb", "pkg", "dmg"
    )
    
    /**
     * Validates if a URL is safe to process
     */
    fun isValidUrl(url: String?): Boolean {
        if (url.isNullOrBlank()) return false
        
        return try {
            // Basic URL validation
            val urlObj = URL(url)
            
            // Check protocol
            if (urlObj.protocol !in listOf("http", "https")) {
                Log.w(TAG, "Invalid protocol: ${urlObj.protocol}")
                return false
            }
            
            // Check against pattern
            VALID_URL_PATTERN.matcher(url).matches()
        } catch (e: Exception) {
            Log.w(TAG, "Invalid URL format: $url", e)
            false
        }
    }
    
    /**
     * Validates if a URL is from a supported video platform
     */
    fun isSupportedVideoUrl(url: String?): Boolean {
        if (!isValidUrl(url)) return false
        
        return YOUTUBE_URL_PATTERN.matcher(url!!).matches() ||
                url.contains("vimeo.com") ||
                url.contains("dailymotion.com") ||
                url.contains("twitch.tv") ||
                url.contains("tiktok.com")
    }
    
    /**
     * Sanitizes filename to prevent directory traversal and other attacks
     */
    fun sanitizeFilename(filename: String?): String {
        if (filename.isNullOrBlank()) return "download"
        
        // Remove path separators and dangerous characters
        var sanitized = filename
            .replace(Regex("[/\\\\:*?\"<>|]"), "_")
            .replace("..", "_")
            .trim()
        
        // Limit length
        if (sanitized.length > 200) {
            sanitized = sanitized.substring(0, 200)
        }
        
        // Ensure it doesn't start with dots or dashes
        sanitized = sanitized.trimStart('.', '-')
        
        // If empty after sanitization, use default
        if (sanitized.isBlank()) {
            sanitized = "download"
        }
        
        return sanitized
    }
    
    /**
     * Validates file path to prevent directory traversal attacks
     */
    fun isValidFilePath(path: String?): Boolean {
        if (path.isNullOrBlank()) return false
        
        try {
            val file = File(path)
            val canonicalPath = file.canonicalPath
            
            // Check for directory traversal attempts
            if (canonicalPath.contains("..") || 
                canonicalPath.startsWith("/system") ||
                canonicalPath.startsWith("/data/data") && !canonicalPath.contains("com.junkfood.seal")) {
                Log.w(TAG, "Potentially dangerous path: $canonicalPath")
                return false
            }
            
            return true
        } catch (e: Exception) {
            Log.w(TAG, "Invalid file path: $path", e)
            return false
        }
    }
    
    /**
     * Checks if file extension is safe
     */
    fun isSafeFileExtension(filename: String?): Boolean {
        if (filename.isNullOrBlank()) return true
        
        val extension = filename.substringAfterLast('.', "").lowercase()
        return extension !in DANGEROUS_EXTENSIONS
    }
    
    /**
     * Validates URI for content provider access
     */
    fun isValidContentUri(uri: Uri?): Boolean {
        if (uri == null) return false
        
        return when (uri.scheme?.lowercase()) {
            "content", "file" -> {
                // Additional validation can be added here
                !(uri.path?.contains("..") ?: false)
            }
            else -> false
        }
    }
    
    /**
     * Sanitizes user input for command execution
     */
    fun sanitizeCommandInput(input: String?): String {
        if (input.isNullOrBlank()) return ""
        
        // Remove potentially dangerous characters for command injection
        return input
            .replace(Regex("[;&|`$(){}\\[\\]<>]"), "")
            .trim()
    }
    
    /**
     * Validates download directory path
     */
    fun isValidDownloadDirectory(path: String?): Boolean {
        if (path.isNullOrBlank()) return false
        
        try {
            val file = File(path)
            
            // Must be a directory
            if (file.exists() && !file.isDirectory) return false
            
            // Check canonical path for security
            val canonicalPath = file.canonicalPath
            
            // Should be in external storage or app's private directory
            return canonicalPath.startsWith("/storage/emulated/0/") ||
                   canonicalPath.startsWith("/sdcard/") ||
                   canonicalPath.contains("com.junkfood.seal")
        } catch (e: Exception) {
            Log.w(TAG, "Invalid download directory: $path", e)
            return false
        }
    }
}
