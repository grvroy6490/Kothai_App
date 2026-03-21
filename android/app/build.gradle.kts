import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.dckap.visai"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Load keystore properties
    // key.properties is in android/ folder, build.gradle.kts is in android/app/
    val keystorePropertiesFile = file("../key.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
    }

    compileOptions {
        // Required by flutter_local_notifications (Java 8+ APIs on older Android)
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "org.dckap.visai"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (!keystorePropertiesFile.exists()) {
                throw GradleException("Release keystore file not found: ${keystorePropertiesFile.absolutePath}")
            }
            val keyAliasValue = keystoreProperties["keyAlias"] as String?
            val keyPasswordValue = keystoreProperties["keyPassword"] as String?
            val storeFileValue = keystoreProperties["storeFile"] as String?
            val storePasswordValue = keystoreProperties["storePassword"] as String?
            
            if (keyAliasValue == null || keyPasswordValue == null || storeFileValue == null || storePasswordValue == null) {
                throw GradleException("Missing keystore properties. Check key.properties file.")
            }
            
            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue
            
            val keystoreFile = if (storeFileValue.startsWith("/") || storeFileValue.matches(Regex("^[A-Za-z]:.*"))) {
                // Absolute path
                file(storeFileValue)
            } else {
                // Relative path from android folder (where key.properties is)
                // key.properties is in android/, so resolve relative to that
                file("../$storeFileValue")
            }
            
            if (!keystoreFile.exists()) {
                throw GradleException("Keystore file not found: ${keystoreFile.absolutePath}")
            }
            
            storeFile = keystoreFile
            storePassword = storePasswordValue
        }
    }

    buildTypes {
        release {
            // Always use release signing config - fail if not available
            signingConfig = signingConfigs.getByName("release")
            // Enable code shrinking, obfuscation, and optimization
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Enable additional optimizations
            isDebuggable = false
            isJniDebuggable = false
            isRenderscriptDebuggable = false
            renderscriptOptimLevel = 3
        }
    }
    
    // Configure R8 to ignore missing classes for optional dependencies
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "/META-INF/DEPENDENCIES"
            excludes += "/META-INF/LICENSE"
            excludes += "/META-INF/LICENSE.txt"
            excludes += "/META-INF/license.txt"
            excludes += "/META-INF/NOTICE"
            excludes += "/META-INF/NOTICE.txt"
            excludes += "/META-INF/notice.txt"
            excludes += "/META-INF/ASL2.0"
            excludes += "/META-INF/*.kotlin_module"
            // Exclude unnecessary files
            excludes += "/kotlin/**"
            excludes += "/kotlinx/**"
            excludes += "/META-INF/services/**"
        }
    }
    
    // Enable split per ABI for app bundles (automatic with bundles, but explicit for clarity)
    splits {
        abi {
            isEnable = false // Disable for app bundles - Play Store handles this automatically
            reset()
            // App bundles automatically split by ABI, so we don't need manual splits
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

