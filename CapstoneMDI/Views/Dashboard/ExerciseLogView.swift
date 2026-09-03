//
//  ExerciseLogView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/21/26.
//

import SwiftUI
import SwiftData
import Charts

struct ExerciseLogView: View {
    let user: User
    
    @Query private var logs: [ExerciseLog]
    
    init(user: User) {
        self.user = user
        
        let userID = user.id
        
        _logs = Query(
            filter: #Predicate<ExerciseLog> { $0.userID == userID },
            sort: \ExerciseLog.date,
            order: .reverse
        )
    }
    
    private var sevenDayCutoff: Date {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        return calendar.date(byAdding: .day, value: -6, to: startOfToday) ?? startOfToday
    }
    
    private var groupedLogs: [(day: Date, logs: [ExerciseLog])] {
        var result: [(day: Date, logs: [ExerciseLog])] = []
        let calendar = Calendar.current
        
        for log in logs where log.date >= sevenDayCutoff {
            let day = calendar.startOfDay(for: log.date)
            if let lastIndex = result.indices.last,
               calendar.isDate(result[lastIndex].day, inSameDayAs: day) {
                result[lastIndex].logs.append(log)
            } else {
                result.append((day: day, logs: [log]))
            }
        }
        return result
    }
    
    private var dailyRepsSeries: [(day: Date, totalReps: Int)] {
        let calendar = Calendar.current
        var totals: [Date: Int] = [:]
        
        for log in logs where log.date >= sevenDayCutoff {
            let day = calendar.startOfDay(for: log.date)
            totals[day, default: 0] += log.currentReps
        }
        
        // Sort by date ascending
        return totals.keys.sorted().map { day in
            (day: day, totalReps: totals[day] ?? 0)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !dailyRepsSeries.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reps per Day")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 16)
                    
                    Chart(dailyRepsSeries, id: \.day) { point in
                        BarMark(
                            x: .value("Day", point.day, unit: .day),
                            y: .value("Reps", point.totalReps)
                        )
                        .foregroundStyle(.blue.gradient)
                        .cornerRadius(4)
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 5)) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month().day(), centered: true)
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .frame(height: 180)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            
            List {
                if logs.isEmpty {
                    ContentUnavailableView(
                        "No Completed Workouts",
                        systemImage: "chart.bar.fill",
                        description: Text("Logged exercises will appear here.")
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(groupedLogs, id: \.day) { section in
                        Section(header: Text(sectionTitle(for: section.day)).font(.headline)) {
                            ForEach(section.logs) { log in
                                HStack(spacing: 14) {
                                    Image(systemName: "dumbbell.fill")
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                        .frame(width: 38, height: 38)
                                        .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 10))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(log.exerciseName)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        
                                        Text(log.date.formatted(date: .omitted, time: .shortened))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(log.completedSets) sets")
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.primary)
                                        Text("\(log.currentReps) reps")
                                            .font(.caption.weight(.medium))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(12)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .background(Background.gradient3)
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Exercise Log")
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }
    
    
    private func sectionTitle(for day: Date) -> String {
        if Calendar.current.isDateInToday(day) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(day) {
            return "Yesterday"
        } else {
            return day.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseLogView(
            user: User(
                username: "test",
                name: "Test User",
                password: User.hashPassword("password"))
                )
    }
    .modelContainer(for: [ExerciseLog.self, User.self], inMemory: true)
}
