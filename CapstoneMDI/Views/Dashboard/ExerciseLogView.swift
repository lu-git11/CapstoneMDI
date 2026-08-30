//
//  ExerciseLogView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/21/26.
//

import SwiftUI
import SwiftData

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
    
    private var groupedLogs: [(day: Date, logs: [ExerciseLog])] {
        var result: [(day: Date, logs: [ExerciseLog])] = []
        let calendar = Calendar.current
        
        for log in logs {
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
    
    var body: some View {
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
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Exercise Log")
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Background.gradient3)
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
    ExerciseLogView(user: User(username: "test", name: "Test User", password: User.hashPassword("password")))
}
