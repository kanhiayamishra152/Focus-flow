package com.example.focusflow

import android.app.Application

class FocusFlowApplication : Application() {

    lateinit var database: com.example.focusflow.data.FocusFlowDatabase
        private set

    override fun onCreate() {
        super.onCreate()
        database = com.example.focusflow.data.FocusFlowDatabase.getInstance(this)
    }
}
