package com.example.focusflow.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.focusflow.FocusFlowApplication
import com.example.focusflow.data.FocusSession
import com.example.focusflow.data.Habit
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class FocusFlowViewModel(application: Application) : AndroidViewModel(application) {

    private val database = (application as FocusFlowApplication).database
    private val focusSessionDao = database.focusSessionDao()
    private val habitDao = database.habitDao()

    // ── Timer State ──
    private val _focusDurationMinutes = MutableStateFlow(25)
    val focusDurationMinutes: StateFlow<Int> = _focusDurationMinutes.asStateFlow()

    private val _breakDurationMinutes = MutableStateFlow(5)
    val breakDurationMinutes: StateFlow<Int> = _breakDurationMinutes.asStateFlow()

    private val _timeLeftSeconds = MutableStateFlow(25 * 60)
    val timeLeftSeconds: StateFlow<Int> = _timeLeftSeconds.asStateFlow()

    private val _isRunning = MutableStateFlow(false)
    val isRunning: StateFlow<Boolean> = _isRunning.asStateFlow()

    private val _isBreak = MutableStateFlow(false)
    val isBreak: StateFlow<Boolean> = _isBreak.asStateFlow()

    private var timerJob: Job? = null

    // ── Points & Sessions ──
    val totalPoints: StateFlow<Int> = focusSessionDao.getTotalPoints()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), 0)

    val sessionCount: StateFlow<Int> = focusSessionDao.getSessionCount()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), 0)

    // ── Habits ──
    private val today: String =
        LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE)

    val habits: StateFlow<List<Habit>> = habitDao.getHabitsForDate(today)
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    init {
        initializeDefaultHabits()
    }

    private fun initializeDefaultHabits() {
        viewModelScope.launch {
            val count = habitDao.getHabitCountForDate(today)
            if (count == 0) {
                val defaults = listOf(
                    Habit(name = "💧 Drink Water", date = today),
                    Habit(name = "📖 Read Book", date = today),
                    Habit(name = "🏃 Exercise", date = today),
                    Habit(name = "🧘 Meditate", date = today),
                    Habit(name = "📵 No Social Media", date = today),
                    Habit(name = "😴 Sleep 8 Hours", date = today)
                )
                habitDao.insertAll(defaults)
            }
        }
    }

    // ── Timer Controls ──
    fun startTimer() {
        if (_isRunning.value) return
        _isRunning.value = true
        timerJob = viewModelScope.launch {
            while (_timeLeftSeconds.value > 0 && _isRunning.value) {
                delay(1000L)
                if (_isRunning.value) {
                    _timeLeftSeconds.value -= 1
                }
            }
            if (_timeLeftSeconds.value == 0 && _isRunning.value) {
                onTimerComplete()
            }
        }
    }

    fun pauseTimer() {
        _isRunning.value = false
        timerJob?.cancel()
    }

    fun resetTimer() {
        _isRunning.value = false
        timerJob?.cancel()
        _isBreak.value = false
        _timeLeftSeconds.value = _focusDurationMinutes.value * 60
    }

    private fun onTimerComplete() {
        _isRunning.value = false
        if (!_isBreak.value) {
            // Focus session completed → award points
            viewModelScope.launch {
                focusSessionDao.insert(
                    FocusSession(
                        durationMinutes = _focusDurationMinutes.value,
                        pointsEarned = _focusDurationMinutes.value
                    )
                )
            }
            // Switch to break
            _isBreak.value = true
            _timeLeftSeconds.value = _breakDurationMinutes.value * 60
        } else {
            // Break completed → switch back to focus
            _isBreak.value = false
            _timeLeftSeconds.value = _focusDurationMinutes.value * 60
        }
    }

    // ── Habit Controls ──
    fun toggleHabit(habit: Habit) {
        viewModelScope.launch {
            habitDao.update(habit.copy(isCompleted = !habit.isCompleted))
        }
    }

    // ── Duration Settings ──
    fun setFocusDuration(minutes: Int) {
        if (!_isRunning.value) {
            _focusDurationMinutes.value = minutes
            if (!_isBreak.value) {
                _timeLeftSeconds.value = minutes * 60
            }
        }
    }

    fun setBreakDuration(minutes: Int) {
        if (!_isRunning.value) {
            _breakDurationMinutes.value = minutes
            if (_isBreak.value) {
                _timeLeftSeconds.value = minutes * 60
            }
        }
    }
}
