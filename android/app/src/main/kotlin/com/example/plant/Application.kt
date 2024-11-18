package com.example.plant

import io.flutter.app.FlutterApplication
import androidx.multidex.MultiDex

class Application : FlutterApplication() {
    override fun attachBaseContext(base: android.content.Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}