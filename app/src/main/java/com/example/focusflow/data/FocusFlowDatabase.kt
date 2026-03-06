package com.example.focusflow.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
    entities = [FocusSession::class, Habit::class],
    version = 1,
    exportSchema = false
)
abstract class FocusFlowDatabase : RoomDatabase() {

    abstract fun focusSessionDao(): FocusSessionDao
    abstract fun habitDao(): HabitDao

    companion object {
        @Volatile
        private var INSTANCE: FocusFlowDatabase? = null

        fun getInstance(context: Context): FocusFlowDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    FocusFlowDatabase::class.java,
                    "focusflow_database"
                ).build()
                INSTANCE = instance
                instance
            }
        }
    }
}
