package com.example.focusflow

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.focusflow.ui.navigation.AppNavigation
import com.example.focusflow.ui.theme.FocusFlowTheme
import com.example.focusflow.viewmodel.FocusFlowViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            FocusFlowTheme {
                val focusViewModel: FocusFlowViewModel = viewModel()
                AppNavigation(viewModel = focusViewModel)
            }
        }
    }
}
