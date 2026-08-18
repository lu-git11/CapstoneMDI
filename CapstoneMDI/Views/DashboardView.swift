//
//  DashboardView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI

struct DashboardView: View {
    
    
    @State private var taskGroups : [DashboardGroup] = []  //= TaskGroup.sampleData
    @State private var selectedGroup: DashboardGroup?
    @State private var isShowingAddGroup = false
    @State private var workout = Workout(
        title: "Full Body Strength",
        coach: "Alex Trainer",
        summary: "A balanced routine targeting all major muscle groups.",
        image: "workout_placeholder",
        reviewTitle: "",
        reviewText: "",
        rating: nil
    )
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            ZStack {
                Background.gradient3.ignoresSafeArea()
                List(selection: $selectedGroup) {
                    NavigationLink(destination: WorkoutView()) {
                        HStack(spacing: 20) {
                            Image(systemName: "house.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 35, height: 35)
                                .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 8))
                            
                            Text ("Workouts")
                        }
                    }// end navigation link
                    
                    NavigationLink(destination: ReviewView(workout: $workout)) {
                        HStack(spacing: 20) {
                            Image(systemName: "house.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 35, height: 35)
                                .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 8))
                                
                            Text ("Reviews")
                        }
                    }// end navigation link
                    .padding(.vertical, 5)
                } //end list
            }//end ZStack
            .navigationDestination(for: DashboardGroup.self) { group in Text(group.title)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingAddGroup = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }// end toolbar
                .sheet(isPresented: $isShowingAddGroup) {
                    NewDashboardView { newGroup in
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        taskGroups.append(newGroup)
                    }
                    selectedGroup = newGroup
                    }
                }// end sheet
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
            }// end navigation
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }// end view
}// end struct

#Preview("Dashboard") {
    DashboardView()
}

