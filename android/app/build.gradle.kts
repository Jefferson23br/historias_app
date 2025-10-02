plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.historias_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        
        applicationId = "com.example.historias_app"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")  
    id("kotlin-android")
}

android {
    namespace "com.example.historias_app"  
    compileSdk 34

    defaultConfig {
        applicationId "com.example.historias_app"
        minSdk 21
        targetSdk 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
}

dependencies {

    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))


    implementation("com.google.firebase:firebase-analytics")


    implementation("com.google.firebase:firebase-auth")


    implementation("com.google.firebase:firebase-firestore")


    implementation("com.google.firebase:firebase-storage")
}