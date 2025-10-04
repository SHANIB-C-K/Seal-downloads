package com.junkfood.seal.util

import android.util.Log
import com.junkfood.seal.BuildConfig
import java.util.regex.Pattern

/**
 * Secure logging utility that sanitizes sensitive information before logging
 * In release builds, logging is disabled or heavily redacted
 */
object SecureLogger {
    
    private const val DEFAULT_TAG = "Seal"
    
    // Patterns to redact sensitive information
    private val URL_PATTERN = Pattern.compile("https?://[^\\s]+")
    private val TOKEN_PATTERN = Pattern.compile("(token|key|password|secret)[\"']?\\s*[:=]\\s*[\"']?([^\\s\"',}]+)", Pattern.CASE_INSENSITIVE)
    private val FILE_PATH_PATTERN = Pattern.compile("/(?:storage|data|sdcard)/[^\\s]+")
    private val EMAIL_PATTERN = Pattern.compile("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}")
    
    /**
     * Log debug message
     */
    fun d(tag: String = DEFAULT_TAG, message: String, throwable: Throwable? = null) {
        if (BuildConfig.DEBUG) {
            val sanitized = sanitizeMessage(message)
            if (throwable != null) {
                Log.d(tag, sanitized, throwable)
            } else {
                Log.d(tag, sanitized)
            }
        }
    }
    
    /**
     * Log info message
     */
    fun i(tag: String = DEFAULT_TAG, message: String, throwable: Throwable? = null) {
        if (BuildConfig.DEBUG) {
            val sanitized = sanitizeMessage(message)
            if (throwable != null) {
                Log.i(tag, sanitized, throwable)
            } else {
                Log.i(tag, sanitized)
            }
        }
    }
    
    /**
     * Log warning message
     */
    fun w(tag: String = DEFAULT_TAG, message: String, throwable: Throwable? = null) {
        val sanitized = sanitizeMessage(message)
        if (throwable != null) {
            Log.w(tag, sanitized, throwable)
        } else {
            Log.w(tag, sanitized)
        }
    }
    
    /**
     * Log error message
     */
    fun e(tag: String = DEFAULT_TAG, message: String, throwable: Throwable? = null) {
        val sanitized = sanitizeMessage(message)
        if (throwable != null) {
            Log.e(tag, sanitized, throwable)
        } else {
            Log.e(tag, sanitized)
        }
    }
    
    /**
     * Sanitizes sensitive information from log messages
     */
    private fun sanitizeMessage(message: String): String {
        if (!BuildConfig.DEBUG) {
            // In release builds, heavily redact
            return message.take(100) + if (message.length > 100) "... [REDACTED]" else ""
        }
        
        var sanitized = message
        
        // Redact URLs (show only domain)
        sanitized = URL_PATTERN.matcher(sanitized).replaceAll { matchResult ->
            val url = matchResult.group()
            try {
                val domain = url.split("//").getOrNull(1)?.split("/")?.firstOrNull() ?: "***"
                "https://$domain/***"
            } catch (e: Exception) {
                "[URL_REDACTED]"
            }
        }
        
        // Redact tokens, keys, passwords
        sanitized = TOKEN_PATTERN.matcher(sanitized).replaceAll("$1=***")
        
        // Redact file paths (show only filename)
        sanitized = FILE_PATH_PATTERN.matcher(sanitized).replaceAll { matchResult ->
            val path = matchResult.group()
            val filename = path.split("/").lastOrNull() ?: "file"
            "/.../***/$filename"
        }
        
        // Redact email addresses
        sanitized = EMAIL_PATTERN.matcher(sanitized).replaceAll { matchResult ->
            val email = matchResult.group()
            val parts = email.split("@")
            if (parts.size == 2) {
                "${parts[0].take(2)}***@${parts[1]}"
            } else {
                "[EMAIL_REDACTED]"
            }
        }
        
        return sanitized
    }
    
    /**
     * Check if debug logging is enabled
     */
    fun isDebugEnabled(): Boolean = BuildConfig.DEBUG
    
    /**
     * Log verbose message (only in debug builds)
     */
    fun v(tag: String = DEFAULT_TAG, message: String, throwable: Throwable? = null) {
        if (BuildConfig.DEBUG) {
            val sanitized = sanitizeMessage(message)
            if (throwable != null) {
                Log.v(tag, sanitized, throwable)
            } else {
                Log.v(tag, sanitized)
            }
        }
    }
}
