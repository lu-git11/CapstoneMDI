//
//  ExercisePickerView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/18/26.
//

import SwiftUI
import SwiftData
 
struct ExercisePickerView: View {
    
    let user: User
    let selectedSection: String
    var onAdd: ((Exercise) -> Void)? = nil
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchTerm: String = ""
    @State private var results: [ExerciseInfo] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Background.gradient2
                    .ignoresSafeArea()
                
                List {
                    if !results.isEmpty {
                        Section {
                            ForEach(results) { info in
                                exerciseRow(for: info)
                            }
                        } header: {
                            Text("\(results.count) result\(results.count == 1 ? "" : "s")")
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .overlay {
                    statusOverlay
                }
                .searchable(text: $searchTerm, prompt: "Search exercises")
                .navigationTitle("Add Exercise")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismiss() }
                    }
                }
                .task(id: searchTerm) {
                    await search()
                }
            }
        }
    }
    
    
    private func exerciseRow(for info: ExerciseInfo) -> some View {
        Button {
            add(info)
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(info.displayName.capitalized)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    if let category = info.category?.name {
                        Text(category)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.tint)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
    }

    @ViewBuilder
    private var statusOverlay: some View {
        if isLoading {
            VStack(spacing: 10) {
                ProgressView()
                Text("Searching…")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } else if let errorMessage {
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title)
                    .foregroundStyle(.yellow)
                Text("Something went wrong")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
        } else if searchTerm.trimmingCharacters(in: .whitespaces).isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text("Search for an exercise")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Try “bench press”, “squat”, or “curl”")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } else if results.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "questionmark.circle")
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text("No exercises found")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Try a different search term")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Networking
    
    private func search() async {
        let trimmed = searchTerm.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            results = []
            errorMessage = nil
            return
        }
        
        do {
        try? await Task.sleep(nanoseconds: 400_000_000)
        guard !Task.isCancelled else { return }
        
        isLoading = true
        errorMessage = nil
        
        results = try await ExerciseAPIService.searchExercises(term: trimmed)
        } catch {
            print("Exercise search failed: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func add(_ info: ExerciseInfo) {
 
            let targetSectionName: String
            if selectedSection != "All" {
                targetSectionName = selectedSection
            } else if let categoryName = info.category?.name?.capitalized, !categoryName.isEmpty {
                targetSectionName = categoryName
            } else {
                targetSectionName = "Main Workout"
            }

            let exercise = Exercise(
                name: info.displayName.capitalized,
                targetSets: 3,
                targetReps: 10,
                order: 0,
                section: targetSectionName,
                user: user
            )
            
            if exercise.modelContext == nil {
                modelContext.insert(exercise)
            }
            
            try? modelContext.save()
            dismiss()
        }
    }

 
