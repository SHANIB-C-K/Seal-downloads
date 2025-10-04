package com.junkfood.seal.ui.page.settings.network

import android.annotation.SuppressLint
import android.os.Build
import android.util.Log
import android.webkit.CookieManager
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import androidx.annotation.RequiresApi
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Close
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.google.accompanist.web.AccompanistWebChromeClient
import com.google.accompanist.web.AccompanistWebViewClient
import com.google.accompanist.web.WebView
import com.google.accompanist.web.rememberWebViewState
import com.google.android.material.R
import com.junkfood.seal.util.PreferenceUtil.updateString
import com.junkfood.seal.util.USER_AGENT_STRING
import com.junkfood.seal.util.connectWithDelimiter
import com.junkfood.seal.util.SecurityUtil
import com.junkfood.seal.util.SecureLogger
import java.io.ByteArrayInputStream

private const val TAG = "WebViewPage"

data class Cookie(
    val domain: String = "",
    val name: String = "",
    val value: String = "",
    val includeSubdomains: Boolean = true,
    val path: String = "/",
    val secure: Boolean = true,
    val expiry: Long = 0L,
) {
    constructor(
        url: String,
        name: String,
        value: String,
    ) : this(domain = url.toDomain(), name = name, value = value)

    fun toNetscapeCookieString(): String {
        return connectWithDelimiter(
            domain,
            includeSubdomains.toString().uppercase(),
            path,
            secure.toString().uppercase(),
            expiry.toString(),
            name,
            value,
            delimiter = "\u0009",
        )
    }
}

private val domainRegex = Regex("""http(s)?://(\w*(www|m|account|sso))?|/.*""")

private fun String.toDomain(): String {
    return this.replace(domainRegex, "")
}

private fun makeCookie(url: String, cookieString: String): Cookie {
    cookieString.split("=").run {
        return Cookie(url = url, name = first(), value = last())
    }
}

@SuppressLint("SetJavaScriptEnabled")
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WebViewPage(cookiesViewModel: CookiesViewModel, onDismissRequest: () -> Unit) {

    val state by cookiesViewModel.stateFlow.collectAsStateWithLifecycle()
    Log.d(TAG, state.editingCookieProfile.url)

    val cookieManager = CookieManager.getInstance()
    val cookieSet = remember { mutableSetOf<Cookie>() }
    val websiteUrl = state.editingCookieProfile.url
    val webViewState = rememberWebViewState(websiteUrl)

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        topBar = {
            TopAppBar(
                title = { Text(webViewState.pageTitle.toString(), maxLines = 1) },
                navigationIcon = {
                    IconButton(onClick = { onDismissRequest() }) {
                        Icon(
                            imageVector = Icons.Outlined.Close,
                            stringResource(id = androidx.appcompat.R.string.abc_action_mode_done),
                        )
                    }
                },
                actions = {
                    TextButton(onClick = onDismissRequest) {
                        Text(text = stringResource(id = R.string.abc_action_mode_done))
                    }
                },
            )
        },
    ) { paddingValues ->
        val webViewClient = remember {
            object : AccompanistWebViewClient() {
                override fun onPageFinished(view: WebView, url: String?) {
                    super.onPageFinished(view, url)
                    if (url.isNullOrEmpty()) return
                    
                    // Inject Content Security Policy
                    val csp = """javascript:(function() {
                        var meta = document.createElement('meta');
                        meta.httpEquiv = 'Content-Security-Policy';
                        meta.content = "default-src 'self' https:; script-src 'self' 'unsafe-inline' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' https: data:; font-src 'self' https: data:; connect-src 'self' https:; frame-ancestors 'none';";
                        document.head.appendChild(meta);
                    })()"""
                    view?.evaluateJavascript(csp, null)
                }

                override fun shouldOverrideUrlLoading(
                    view: WebView?,
                    request: WebResourceRequest?,
                ): Boolean {
                    val url = request?.url?.toString()
                    
                    // Validate URL before loading
                    if (url != null && !SecurityUtil.isValidWebViewUrl(url)) {
                        SecureLogger.w(TAG, "Blocked invalid URL: $url")
                        return true // Block the navigation
                    }
                    
                    return if (request?.url?.scheme?.contains("http") == true)
                        super.shouldOverrideUrlLoading(view, request)
                    else true
                }
                
                @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
                override fun shouldInterceptRequest(
                    view: WebView?,
                    request: WebResourceRequest?
                ): WebResourceResponse? {
                    // Add security headers
                    val url = request?.url?.toString()
                    if (url != null && SecurityUtil.isValidUrl(url)) {
                        return null // Let WebView handle it
                    }
                    
                    // Block invalid requests
                    SecureLogger.w(TAG, "Blocked resource request: $url")
                    return WebResourceResponse(
                        "text/plain",
                        "UTF-8",
                        ByteArrayInputStream("Blocked".toByteArray())
                    )
                }
            }
        }
        val webViewChromeClient = remember { object : AccompanistWebChromeClient() {} }
        WebView(
            state = webViewState,
            client = webViewClient,
            chromeClient = webViewChromeClient,
            modifier = Modifier.padding(paddingValues).fillMaxSize(),
            captureBackPresses = true,
            factory = { context ->
                WebView(context).apply {
                    settings.run {
                        // Security hardening
                        javaScriptEnabled = true // Required for cookie functionality
                        javaScriptCanOpenWindowsAutomatically = false // Security: prevent popup windows
                        
                        // DOM storage - required for modern sites
                        domStorageEnabled = true
                        
                        // File access restrictions
                        allowFileAccess = false
                        allowContentAccess = false
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                            allowFileAccessFromFileURLs = false
                            allowUniversalAccessFromFileURLs = false
                        }
                        
                        // Additional security settings
                        setSupportMultipleWindows(false)
                        setSupportZoom(false)
                        builtInZoomControls = false
                        displayZoomControls = false
                        
                        // Safe browsing
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            safeBrowsingEnabled = true
                        }
                        
                        // Mixed content
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            mixedContentMode = android.webkit.WebSettings.MIXED_CONTENT_NEVER_ALLOW
                        }
                        
                        // Database and storage
                        databaseEnabled = false
                        
                        // Geolocation
                        setGeolocationEnabled(false)
                        
                        // User agent
                        USER_AGENT_STRING.updateString(userAgentString)
                    }
                    
                    // Cookie settings - disable third-party by default
                    cookieManager.setAcceptThirdPartyCookies(this, false)
                    
                    // Remove all JavaScript interfaces for security
                    removeJavascriptInterface("searchBoxJavaBridge_")
                    removeJavascriptInterface("accessibility")
                    removeJavascriptInterface("accessibilityTraversal")
                }
            },
        )
    }
}
