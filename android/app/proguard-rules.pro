-keep class com.stripe.android.** { *; }
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.reactnativestripesdk.** { *; }

# Keep generic signatures; needed for correct type resolution
-keepattributes Signature

# Keep annotation related stuff
-keepattributes *Annotation*

# Keep Stripe SDK
-keep class com.stripe.android.** { *; }
-dontwarn com.stripe.android.**

# Keep ReactNativeStripeSdk
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**