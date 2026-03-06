package com.example.focusflow.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface HabitDao {

    @Insert
    suspend fun insert(habit: Habit)

    @Insert
    suspend fun insertAll(habits: List<Habit>)

    @Update
    suspend fun update(habit: Habit)

    @Query("SELECT * FROM habits WHERE date = :date ORDER BY id ASC")
    fun getHabitsForDate(date: String): Flow<List<Habit>>

    @Query("SELECT COUNT(*) FROM habits WHERE date = :date")
    suspend fun getHabitCountForDate(date: String): Int
}
