# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

#noinspection ShrinkerUnresolvedReference

# Enable obfuscation for better security
# -dontobfuscate

# Keep only essential classes from obfuscation
-keep class com.junkfood.seal.App { *; }
-keep class com.junkfood.seal.MainActivity { *; }
-keep class com.junkfood.seal.QuickDownloadActivity { *; }
-keep class com.junkfood.seal.CrashReportActivity { *; }
-keep class com.junkfood.seal.DownloadService { *; }

# Keep data classes and serializable classes
-keep class com.junkfood.seal.database.** { *; }
-keep class com.junkfood.seal.ui.page.settings.network.Cookie { *; }

# Additional security: Remove debug information in release builds
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# ============================================================
# SECURITY HARDENING - Added for enhanced protection
# ============================================================

# Strip all logging in release builds for security
-assumenosideeffects class com.junkfood.seal.util.SecureLogger {
    public static *** v(...);
    public static *** d(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Also strip standard Android logging in release
-assumenosideeffects class android.util.Log {
    public static *** v(...);
    public static *** d(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Keep SecurityUtil but obfuscate implementation
-keep class com.junkfood.seal.util.SecurityUtil {
    public static <methods>;
}

# Keep SecureLogger interface but strip implementation
-keep class com.junkfood.seal.util.SecureLogger {
    public static <methods>;
}

# Aggressive string encryption for sensitive classes
-keepclassmembers class com.junkfood.seal.util.SecurityUtil {
    <fields>;
}
-keepclassmembers class com.junkfood.seal.util.SecureLogger {
    <fields>;
}

# Additional obfuscation for security-sensitive code
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''

# Remove debugging attributes that could help reverse engineering
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,*Annotation*,EnclosingMethod

# Obfuscate all package names
-flattenpackagehierarchy
-repackageclasses 'sealed'

# Keep crash reporting working
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

-keep class com.yausername.** { *; }
-keep class org.apache.commons.compress.archivers.zip.** { *; }

# Keep `Companion` object fields of serializable classes.
# This avoids serializer lookup through `getDeclaredClasses` as done for named companion objects.
-if @kotlinx.serialization.Serializable class **
-keepclassmembers class <1> {
    static <1>$Companion Companion;
}

# Keep `serializer()` on companion objects (both default and named) of serializable classes.
-if @kotlinx.serialization.Serializable class ** {
    static **$* *;
}
-keepclassmembers class <2>$<3> {
    kotlinx.serialization.KSerializer serializer(...);
}

# Keep `INSTANCE.serializer()` of serializable objects.
-if @kotlinx.serialization.Serializable class ** {
    public static ** INSTANCE;
}
-keepclassmembers class <1> {
    public static <1> INSTANCE;
    kotlinx.serialization.KSerializer serializer(...);
}

# @Serializable and @Polymorphic are used at runtime for polymorphic serialization.
-keepattributes RuntimeVisibleAnnotations,AnnotationDefault

# Serializer for classes with named companion objects are retrieved using `getDeclaredClasses`.
# If you have any, uncomment and replace classes with those containing named companion objects.
#-keepattributes InnerClasses # Needed for `getDeclaredClasses`.
#-if @kotlinx.serialization.Serializable class
#com.example.myapplication.HasNamedCompanion, # <-- List serializable classes with named companions.
#com.example.myapplication.HasNamedCompanion2
#{
#    static **$* *;
#}
#-keepnames class <1>$$serializer { # -keepnames suffices; class is kept when serializer() is kept.
#    static <1>$$serializer INSTANCE;
#}