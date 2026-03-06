package com.example.focusflow.ui.screens

import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.focusflow.ui.theme.FocusGreen
import com.example.focusflow.viewmodel.FocusFlowViewModel

@Composable
fun HabitScreen(viewModel: FocusFlowViewModel) {
    val habits by viewModel.habits.collectAsState()
    val completedCount = habits.count { it.isCompleted }
    val totalCount = habits.size

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp)
    ) {
        Text(
            text = "📋 Daily Habits",
            fontSize = 28.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.onBackground
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = "Complete your daily habits to build consistency",
            fontSize = 14.sp,
            color = MaterialTheme.colorScheme.onBackground.copy(alpha = 0.6f)
        )

        Spacer(modifier = Modifier.height(16.dp))

        // ── Progress Card ──
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(
                containerColor = FocusGreen.copy(alpha = 0.15f)
            )
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(text = "Progress", fontWeight = FontWeight.SemiBold)
                    Text(
                        text = "$completedCount/$totalCount completed",
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f)
                    )
                }
                Spacer(modifier = Modifier.height(8.dp))
                LinearProgressIndicator(
                    progress = {
                        if (totalCount > 0) completedCount.toFloat() / totalCount else 0f
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(8.dp),
                    color = FocusGreen,
                    trackColor = FocusGreen.copy(alpha = 0.2f)
                )
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // ── Habit List ──
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(8.dp),
            modifier = Modifier.weight(1f)
        ) {
            items(habits, key = { it.id }) { habit ->
                val bgColor by animateColorAsState(
                    targetValue = if (habit.isCompleted)
                        FocusGreen.copy(alpha = 0.1f)
                    else
                        MaterialTheme.colorScheme.surface,
                    label = "habitBg"
                )

                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { viewModel.toggleHabit(habit) },
                    shape = RoundedCornerShape(12.dp),
                    colors = CardDefaults.cardColors(containerColor = bgColor)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Checkbox(
                            checked = habit.isCompleted,
                            onCheckedChange = { viewModel.toggleHabit(habit) },
                            colors = CheckboxDefaults.colors(checkedColor = FocusGreen)
                        )
                        Spacer(modifier = Modifier.width(12.dp))
                        Text(
                            text = habit.name,
                            fontSize = 16.sp,
                            fontWeight = if (habit.isCompleted) FontWeight.Normal
                            else FontWeight.Medium,
                            textDecoration = if (habit.isCompleted)
                                TextDecoration.LineThrough else TextDecoration.None,
                            color = if (habit.isCompleted)
                                MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5f)
                            else
                                MaterialTheme.colorScheme.onSurface
                        )
                    }
                }
            }
        }

        // ── Celebration ──
        if (completedCount == totalCount && totalCount > 0) {
            Spacer(modifier = Modifier.height(16.dp))
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(
                    containerColor = FocusGreen.copy(alpha = 0.2f)
                )
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(20.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(text = "🎉", fontSize = 40.sp)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "All habits completed!",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = FocusGreen
                    )
                    Text(
                        text = "Great job staying disciplined today!",
                        fontSize = 14.sp,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f)
                    )
                }
            }
        }
    }
}
