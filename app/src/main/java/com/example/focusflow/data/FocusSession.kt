package com.example.focusflow.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "focus_sessions")
data class FocusSession(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val durationMinutes: Int,
    val pointsEarned: Int,
    val completedAt: Long = System.currentTimeMillis()
)
