# Platrare release keep rules. Flutter enables R8 on release builds and adds
# its own engine rules; these cover the app's plugins.

# flutter_local_notifications serialises scheduled notifications with Gson
# and reads them back on reboot (BOOT_COMPLETED receiver). Stripping the
# reflective field names crashes the reschedule after a device restart.
-keep class com.dexterous.** { *; }
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Home-screen widget receiver / provider are looked up by name from the
# manifest and the launcher.
-keep class com.platrare.app.** { *; }

# Keep line numbers so Play Console stack traces stay readable after R8.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
