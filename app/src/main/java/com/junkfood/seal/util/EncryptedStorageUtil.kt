package com.junkfood.seal.util

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Utility for encrypting sensitive data using Android Keystore
 * This provides hardware-backed encryption for sensitive preferences
 * 
 * NOTE: For production use, consider using androidx.security:security-crypto
 * which provides EncryptedSharedPreferences with better compatibility
 */
object EncryptedStorageUtil {
    
    private const val KEYSTORE_ALIAS = "SealSecureKeyAlias"
    private const val ANDROID_KEYSTORE = "AndroidKeyStore"
    private const val TRANSFORMATION = "AES/GCM/NoPadding"
    private const val GCM_IV_LENGTH = 12
    private const val GCM_TAG_LENGTH = 128
    
    /**
     * Encrypts a string value
     */
    fun encrypt(plainText: String): String? {
        return try {
            val cipher = getCipher()
            cipher.init(Cipher.ENCRYPT_MODE, getOrCreateKey())
            
            val iv = cipher.iv
            val encrypted = cipher.doFinal(plainText.toByteArray(Charsets.UTF_8))
            
            // Combine IV and encrypted data
            val combined = iv + encrypted
            Base64.encodeToString(combined, Base64.NO_WRAP)
        } catch (e: Exception) {
            SecureLogger.e("EncryptedStorage", "Encryption failed", e)
            null
        }
    }
    
    /**
     * Decrypts an encrypted string value
     */
    fun decrypt(encryptedText: String): String? {
        return try {
            val combined = Base64.decode(encryptedText, Base64.NO_WRAP)
            
            // Extract IV and encrypted data
            val iv = combined.sliceArray(0 until GCM_IV_LENGTH)
            val encrypted = combined.sliceArray(GCM_IV_LENGTH until combined.size)
            
            val cipher = getCipher()
            val spec = GCMParameterSpec(GCM_TAG_LENGTH, iv)
            cipher.init(Cipher.DECRYPT_MODE, getOrCreateKey(), spec)
            
            val decrypted = cipher.doFinal(encrypted)
            String(decrypted, Charsets.UTF_8)
        } catch (e: Exception) {
            SecureLogger.e("EncryptedStorage", "Decryption failed", e)
            null
        }
    }
    
    /**
     * Gets or creates the encryption key in Android Keystore
     */
    private fun getOrCreateKey(): SecretKey {
        val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE)
        keyStore.load(null)
        
        // Check if key already exists
        if (keyStore.containsAlias(KEYSTORE_ALIAS)) {
            val entry = keyStore.getEntry(KEYSTORE_ALIAS, null) as KeyStore.SecretKeyEntry
            return entry.secretKey
        }
        
        // Generate new key
        val keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES,
            ANDROID_KEYSTORE
        )
        
        val keyGenParameterSpec = KeyGenParameterSpec.Builder(
            KEYSTORE_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .setUserAuthenticationRequired(false) // No biometric needed
            .setRandomizedEncryptionRequired(true)
            .build()
        
        keyGenerator.init(keyGenParameterSpec)
        return keyGenerator.generateKey()
    }
    
    /**
     * Gets cipher instance for encryption/decryption
     */
    private fun getCipher(): Cipher {
        return Cipher.getInstance(TRANSFORMATION)
    }
    
    /**
     * Securely stores a string preference
     */
    fun putSecureString(context: Context, key: String, value: String) {
        val encrypted = encrypt(value)
        if (encrypted != null) {
            context.getSharedPreferences("secure_prefs", Context.MODE_PRIVATE)
                .edit()
                .putString(key, encrypted)
                .apply()
        }
    }
    
    /**
     * Retrieves a securely stored string preference
     */
    fun getSecureString(context: Context, key: String, defaultValue: String? = null): String? {
        val encrypted = context.getSharedPreferences("secure_prefs", Context.MODE_PRIVATE)
            .getString(key, null)
        
        return if (encrypted != null) {
            decrypt(encrypted) ?: defaultValue
        } else {
            defaultValue
        }
    }
    
    /**
     * Removes a secure preference
     */
    fun removeSecureString(context: Context, key: String) {
        context.getSharedPreferences("secure_prefs", Context.MODE_PRIVATE)
            .edit()
            .remove(key)
            .apply()
    }
    
    /**
     * Checks if a secure key exists
     */
    fun containsSecureKey(context: Context, key: String): Boolean {
        return context.getSharedPreferences("secure_prefs", Context.MODE_PRIVATE)
            .contains(key)
    }
    
    /**
     * Clears all secure preferences
     */
    fun clearAllSecurePreferences(context: Context) {
        context.getSharedPreferences("secure_prefs", Context.MODE_PRIVATE)
            .edit()
            .clear()
            .apply()
    }
}
