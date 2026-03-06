package com.example.focusflow.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface FocusSessionDao {

    @Insert
    suspend fun insert(session: FocusSession)

    @Query("SELECT COALESCE(SUM(pointsEarned), 0) FROM focus_sessions")
    fun getTotalPoints(): Flow<Int>

    @Query("SELECT COUNT(*) FROM focus_sessions")
    fun getSessionCount(): Flow<Int>

    @Query("SELECT * FROM focus_sessions ORDER BY completedAt DESC")
    fun getAllSessions(): Flow<List<FocusSession>>
}
