//
//  ExerciseView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/26/26.
//

import SwiftUI
import SwiftData

struct ExerciseView: View {

    let user: User

    @State private var showExercisePicker: Bool = false
    @State private var selectedSection: String = "Main Workout"
    @State private var customSections: [String] = ["Warmup", "Main Workout", "Cooldown"]
    @State private var showAddSectionAlert: Bool = false
    @State private var newSectionName: String = ""

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var exercises: [Exercise]
   
       init(user: User) {
            self.user = user
            let userID = user.id
            _exercises = Query(
                filter: #Predicate<Exercise> { $0.userID == userID },
                sort: \Exercise.order
            )
       }

    /// Aggregates default tabs with any section names stored on existing exercises
    private var availableSections: [String] {
        let existingInExercises = Set(exercises.compactMap { $0.section })
        let combined = Set(customSections).union(existingInExercises)
        return Array(combined).sorted()
    }

    /// Filters exercises based on the active tab selection
    private var filteredExercises: [Exercise] {
        if selectedSection == "All" {
            return exercises
        }
        return exercises.filter { ($0.section ?? "Main Workout") == selectedSection }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Section / Tab Selector
            sectionTabBar
                .padding(.vertical, 10)

            // MARK: - Main Content Area
            ScrollView {
                VStack(spacing: 12) {
                    if filteredExercises.isEmpty {
                        ContentUnavailableView(
                            "No Exercises in \(selectedSection)",
                            systemImage: "dumbbell.fill",
                            description: Text("Tap below to add exercises to this section.")
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(filteredExercises) { exercise in
                            ExerciseRow(exercise: exercise, user: user)
                        }
                    }

                    // Add Exercise Button targeting the active section
                    Button {
                        showExercisePicker = true
                    } label: {
                        Label("Add Exercise to \(selectedSection == "All" ? "Routine" : selectedSection)", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .background(Background.gradient3)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Exercises")
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Label("Finish", systemImage: "checkmark")
                }
            }
        }
        .sheet(isPresented: $showExercisePicker) {
            ExercisePickerView(
                user: user,
                selectedSection: selectedSection
            )
        }
        .alert("New Section Tab", isPresented: $showAddSectionAlert) {
            TextField("Section Name (e.g. Core, Cardio)", text: $newSectionName)
            Button("Add") {
                let trimmed = newSectionName.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty {
                    if !customSections.contains(trimmed) {
                        customSections.append(trimmed)
                    }
                    selectedSection = trimmed
                    newSectionName = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newSectionName = ""
            }
        } message: {
            Text("Enter a title for the new section tab.")
        }
    }

    // MARK: - Section Tab Bar
    private var sectionTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All" tab option
                sectionChip(title: "All", isSelected: selectedSection == "All") {
                    selectedSection = "All"
                }

                // Dynamic tabs
                ForEach(availableSections, id: \.self) { section in
                    sectionChip(title: section, isSelected: selectedSection == section) {
                        selectedSection = section
                    }
                }

                // Add Section Button
                Button {
                    showAddSectionAlert = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Section")
                    }
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.12))
                    .foregroundStyle(.primary)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }

    private func sectionChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(isSelected ? .bold : .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AnyShapeStyle(Color.accentColor) : AnyShapeStyle(Color.white.opacity(0.15))
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Exercise Row Subview
    private struct ExerciseRow: View {
        let exercise: Exercise
        let user: User

        @Environment(\.modelContext) private var modelContext
        @Query private var matchingLogs: [ExerciseLog]
        @State private var log: ExerciseLog?
        @State private var justLoggedSet: Bool = false
        
        @State private var showRepPicker: Bool = false
        @State private var selectedRepsSelection: Int = 10

        init(exercise: Exercise, user: User) {
            self.exercise = exercise
            self.user = user
            let exerciseID = exercise.id
            let userID = user.id
            _matchingLogs = Query(filter: #Predicate<ExerciseLog> { log in
                log.exerciseID == exerciseID && log.userID == userID
            })
        }

        private var completedSets: Int { log?.completedSets ?? 0 }
        private var currentReps: Int { log?.currentReps ?? 0 }
        private var isComplete: Bool { completedSets == exercise.targetSets }
        private var repsGoalReached: Bool { currentReps >= exercise.targetReps }
        private let successColor = Color(red: 0.35, green: 1.0, blue: 0.55)

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(exercise.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    progressRing
                }

                // Sets Stepper
                HStack(spacing: 18) {
                    roundButton(systemName: "minus", enabled: completedSets > 0) {
                        ensureLog()
                        if completedSets > 0 { log?.completedSets -= 1 }
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        Text("\(completedSets)")
                            .font(.title.bold())
                            .contentTransition(.numericText())
                            .foregroundStyle(.primary)
                        Text("SETS")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.secondary)
                            .tracking(1)
                    }
                    .frame(minWidth: 70)

                    Spacer()

                    roundButton(systemName: "plus", enabled: completedSets < exercise.targetSets, prominent: true) {
                        ensureLog()
                        if completedSets < exercise.targetSets { log?.completedSets += 1 }
                    }
                }
                .padding(.vertical, 4)

                Divider()
                    .background(Color.white.opacity(0.1))

                // Reps Stepper
                HStack(spacing: 18) {
                    roundButton(systemName: "minus", enabled: currentReps > 1, size: 32) {
                        ensureLog()
                        if currentReps > 1 { log?.currentReps -= 1 }
                    }

                    Spacer()

                    Button {
                        ensureLog()
                        selectedRepsSelection = currentReps
                        showRepPicker = true
                    } label: {
                        VStack(spacing: 2) {
                            Text("\(currentReps)")
                                .font(.title3.weight(.bold))
                                .contentTransition(.numericText())
                                .foregroundStyle(repsGoalReached ? successColor : (isComplete ? .secondary : .primary))
                        Text("REPS")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.secondary)
                            .tracking(1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.08))
                    )
                }
                .buttonStyle(.plain)

                Spacer()

                roundButton(systemName: "plus", enabled: true, size: 32) {
                    ensureLog()
                    log?.currentReps += 1
                }
                }

                if !isComplete {
                    Button {
                        logSet()
                    } label: {
                        Label("Log Set", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(repsGoalReached ? successColor : Color.white.opacity(0.5))
                    .foregroundStyle(repsGoalReached ? .black : .primary)
                    .controlSize(.regular)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .opacity(isComplete ? 0.65 : 1.0)
            .scaleEffect(isComplete ? 0.98 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isComplete ? Color.green.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isComplete)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: repsGoalReached)
            .onAppear(perform: ensureLog)
            .sheet(isPresented: $showRepPicker) {
                NavigationStack {
                    VStack {
                        Picker("Select Reps", selection: $selectedRepsSelection) {
                            ForEach(1...30, id: \.self) { rep in
                                Text("\(rep) reps")
                                    .tag(rep)
                            }
                        }
                        .pickerStyle(.wheel)
                        .labelsHidden()
                    }
                    .navigationTitle("Select Reps")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                log?.currentReps = selectedRepsSelection
                                showRepPicker = false
                            }
                            .bold()
                        }
                    }
                }
                .presentationDetents([.height(260)])
            }
        }

        private var progressRing: some View {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 4)

                Circle()
                    .trim(from: 0, to: exercise.targetSets > 0 ? CGFloat(completedSets) / CGFloat(exercise.targetSets) : 0)
                    .stroke(isComplete ? successColor : Color.accentColor,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .shadow(color: isComplete ? successColor.opacity(0.6) : .clear, radius: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: completedSets)

                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(successColor)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text("\(completedSets)/\(exercise.targetSets)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 38, height: 38)
            .scaleEffect(justLoggedSet ? 1.25 : 1)
            .animation(.spring(response: 0.35, dampingFraction: 0.55), value: isComplete)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: justLoggedSet)
        }

        private func roundButton(systemName: String, enabled: Bool, size: CGFloat = 36, prominent: Bool = false, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Image(systemName: systemName)
                    .font(.system(size: size * 0.45, weight: .bold))
                    .foregroundStyle(enabled ? (prominent ? .white : .primary) : .secondary)
                    .frame(width: size, height: size)
                    .background(
                        Circle()
                            .fill(prominent && enabled ? AnyShapeStyle(Color.accentColor.gradient) : AnyShapeStyle(Color.white.opacity(0.1)))
                    )
            }
            .disabled(!enabled)
            .buttonStyle(.plain)
        }

        private func logSet() {
            ensureLog()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                log?.completedSets += 1
                log?.currentReps = 10
                log?.date = Date()
                justLoggedSet = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                justLoggedSet = false
            }
        }

        private func ensureLog() {
            if log != nil { return }
            if let existing = matchingLogs.first {
                log = existing
                
                if existing.currentReps == 0 {
                    existing.currentReps = 10
                }
            } else {
                let newLog = ExerciseLog(exercise: exercise, user: user)
                newLog.currentReps = 10
                modelContext.insert(newLog)
                log = newLog
            }
        }
    }
}

