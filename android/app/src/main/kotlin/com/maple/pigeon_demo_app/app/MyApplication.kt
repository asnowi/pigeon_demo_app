package com.maple.pigeon_demo_app.app

import android.app.Application

class MyApplication: Application(){

    companion object {
        @JvmStatic
        lateinit var instance: MyApplication
            private set
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
    }
}