####################################
# Common rules
####################################

# Keep PDFViewer library classes
-keep class com.rajat.pdfviewer.** { *; }

# Keep AndroidX Lifecycle classes
-keep class androidx.lifecycle.** { *; }

# Keep Kotlin coroutines classes
-keep class kotlinx.coroutines.** { *; }

# Keep Razorpay classes and suppress warnings
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }

# Keep JavaScript interface annotations
-keepattributes JavascriptInterface
-keepattributes *Annotation*

-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Avoid inlining methods (can help with debugging/stack traces)
-optimizations !method/inlining/*

# Keep onPayment* methods (for Razorpay callbacks, etc.)
-keepclasseswithmembers class * {
    public void onPayment*(...);
}

####################################
# Your app's classes
####################################
-keep class com.divyansh.academixstore.utils.** { *; }
-keep class com.divyansh.academixstore.models.** { *; }

####################################
# Gson & JSON parsing
####################################

# Keep generic type signatures (ESSENTIAL for Gson TypeToken)
-keepattributes Signature

# Keep Gson TypeToken
-keep class com.google.gson.reflect.TypeToken { *; }

# Keep Gson annotations and fields
-keepattributes *Annotation*
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

####################################
# Appwrite SDK classes (using Gson)
####################################
-keep class io.appwrite.** { *; }

####################################
# Additional (remove duplicates)
####################################

# (Removed duplicate rules and kept only once)
